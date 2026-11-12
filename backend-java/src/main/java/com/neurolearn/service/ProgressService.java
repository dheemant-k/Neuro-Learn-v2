package com.neurolearn.service;

import com.neurolearn.dto.ProgressResponse;
import com.neurolearn.entity.*;
import com.neurolearn.exception.ForbiddenException;
import com.neurolearn.exception.NotFoundException;
import com.neurolearn.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
public class ProgressService {

    private static final Map<String, List<String>> CHAPTER_SECTIONS = Map.of(
            "linear_eq_2var", List.of(
                    "intro",
                    "graphing",
                    "pair_of_equations",
                    "substitution",
                    "elimination",
                    "word_problems"
            ),
            "quadratic_equations", List.of(
                    "quad_intro",
                    "quad_factoring",
                    "quad_formula",
                    "quad_discriminant",
                    "quad_graphing",
                    "quad_word_problems"
            )
    );

    private static final List<String> DEFAULT_SECTION_ORDER = CHAPTER_SECTIONS.get("linear_eq_2var");

    private final UserRepository userRepository;
    private final StudentProfileRepository profileRepository;
    private final TopicProgressRepository topicProgressRepository;
    private final MasteryRule masteryRule;
    private final LearningSessionRepository sessionRepository;
    private final QuestionAttemptRepository attemptRepository;

    public ProgressService(
            UserRepository userRepository,
            StudentProfileRepository profileRepository,
            TopicProgressRepository topicProgressRepository,
            MasteryRule masteryRule,
            LearningSessionRepository sessionRepository,
            QuestionAttemptRepository attemptRepository
    ) {
        this.userRepository = userRepository;
        this.profileRepository = profileRepository;
        this.topicProgressRepository = topicProgressRepository;
        this.masteryRule = masteryRule;
        this.sessionRepository = sessionRepository;
        this.attemptRepository = attemptRepository;
    }

    /**
     * A section counts as completed (unlocks the next one) after at least {@value #SECTION_MIN_ANSWERS} answers,
     * with P(L) of at least {@value #SECTION_UNLOCK_P_KNOW} or {@value #SECTION_UNLOCK_CORRECT} correct.
     * Deliberately easier than mastery, but no longer reachable with one lucky answer (one correct answer
     * alone takes P(L) from 0.20 to 0.57).
     */
    static final int SECTION_MIN_ANSWERS = 3;
    static final double SECTION_UNLOCK_P_KNOW = 0.50;
    static final int SECTION_UNLOCK_CORRECT = 3;
    /** Boss opens after this many completed sections (or all of them, for short chapters). */
    static final int BOSS_UNLOCK_SECTIONS = 3;

    static boolean isSectionCompleted(double pKnow, int attempts, int correct) {
        return attempts >= SECTION_MIN_ANSWERS && (pKnow >= SECTION_UNLOCK_P_KNOW || correct >= SECTION_UNLOCK_CORRECT);
    }

    /** The boss topics; a victory bonus can only be claimed for one of these. */
    static final Set<String> BOSS_TOPICS = Set.of("final_boss", "quad_final_boss");
    /** The fight is won with 4 hits (the 5th only finishes the animation) and lost on the 3rd miss. */
    static final int BOSS_WIN_CORRECT = 4;
    static final int BOSS_LOSE_WRONG = 3;
    static final int BOSS_BONUS_XP = 100;

    static boolean isBossWon(long correct, long wrong) {
        return correct >= BOSS_WIN_CORRECT && wrong < BOSS_LOSE_WRONG;
    }


    /** Open if it's the first section, the previous one is completed, or the student already completed this one. */
    static boolean isSectionUnlocked(int index, boolean previousCompleted, boolean completed) {
        return index == 0 || previousCompleted || completed;
    }

    static boolean isBossUnlocked(int completedSections, int totalSections) {
        return completedSections >= totalSections || completedSections >= BOSS_UNLOCK_SECTIONS;
    }

    /** The caller's own profile, or null if they have none yet. Never another student's. */
    private StudentProfile getProfileForEmail(String userEmail) {
        return userRepository.findByEmail(userEmail)
                .flatMap(user -> profileRepository.findByUserId(user.getId()))
                .orElse(null);
    }

    public ProgressResponse getProgress(String userEmail) {
        return getProgress(userEmail, "linear_eq_2var");
    }

    public ProgressResponse getProgress(String userEmail, String chapterId) {
        // No profile yet → same roadmap as a brand-new student (all sections, nothing attempted).
        StudentProfile profile = getProfileForEmail(userEmail);

        List<String> sectionOrder = CHAPTER_SECTIONS.getOrDefault(chapterId, DEFAULT_SECTION_ORDER);

        Map<String, TopicProgress> progressMap = new HashMap<>();
        Map<String, Long> hardCorrect = profile != null ? masteryRule.hardCorrectByTopic(profile.getId()) : Map.of();
        if (profile != null) {
            for (TopicProgress tp : topicProgressRepository.findByStudentProfileId(profile.getId())) {
                progressMap.put(tp.getTopic(), tp);
            }
        }

        List<ProgressResponse.SectionProgressDto> dtoList = new ArrayList<>();
        boolean previousCompleted = true; // First section is always unlocked
        int completedCount = 0;
        double sumPKnow = 0.0;

        for (int i = 0; i < sectionOrder.size(); i++) {
            String secId = sectionOrder.get(i);
            TopicProgress tp = progressMap.get(secId);

            int attempts = tp != null && tp.getAttempts() != null ? tp.getAttempts() : 0;
            int correct = tp != null && tp.getCorrectCount() != null ? tp.getCorrectCount() : 0;
            double accuracy = attempts > 0 ? Math.round(((double) correct / attempts) * 1000.0) / 10.0 : 0.0;
            double pKnow = tp != null && tp.getPKnow() != null ? tp.getPKnow() : 0.20;
            sumPKnow += pKnow;

            boolean isMastered = MasteryRule.isMastered(pKnow, hardCorrect.getOrDefault(secId, 0L));
            boolean isCompleted = isSectionCompleted(pKnow, attempts, correct);
            // A section the student already completed never shows as locked.
            boolean isUnlocked = isSectionUnlocked(i, previousCompleted, isCompleted);

            if (isCompleted) {
                completedCount++;
            }

            dtoList.add(new ProgressResponse.SectionProgressDto(
                    secId,
                    attempts,
                    correct,
                    accuracy,
                    Math.round(pKnow * 100.0) / 100.0,
                    isMastered,
                    isCompleted,
                    isUnlocked
            ));

            previousCompleted = isCompleted;
        }

        boolean bossUnlocked = isBossUnlocked(completedCount, sectionOrder.size());
        double overallPKnow = Math.round((sumPKnow / sectionOrder.size()) * 100.0) / 100.0;

        return new ProgressResponse(
                profile != null && profile.getTotalXp() != null ? profile.getTotalXp() : 0,
                profile != null && profile.getCurrentLevel() != null ? profile.getCurrentLevel() : 1,
                profile != null && profile.getOverallAccuracy() != null ? profile.getOverallAccuracy() : 0.0,
                overallPKnow,
                bossUnlocked,
                dtoList
        );
    }

    /**
     * Pays the boss-victory bonus, but only for a fight the server can see was won: the session must belong to
     * the caller and contain at least {@value #BOSS_WIN_CORRECT} correct boss answers and fewer than
     * {@value #BOSS_LOSE_WRONG} wrong ones, all graded on the server. Paid at most once per session; asking
     * again returns the progress unchanged. The answers themselves already updated XP and P(L) as they came in.
     */
    @Transactional
    public ProgressResponse awardBossDefeatBonus(String userEmail, Long sessionId, String bossTopic, String chapterId) {
        StudentProfile profile = getProfileForEmail(userEmail);
        if (profile == null) {
            throw new ForbiddenException("Only student accounts can claim a boss victory");
        }
        if (sessionId == null) {
            throw new IllegalArgumentException("sessionId is required");
        }
        String topic = bossTopic == null || bossTopic.isBlank() ? "final_boss" : bossTopic.trim();
        if (!BOSS_TOPICS.contains(topic)) {
            throw new IllegalArgumentException("bossTopic must be one of " + new TreeSet<>(BOSS_TOPICS));
        }
        LearningSession session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new NotFoundException("Session not found: " + sessionId));
        if (!session.getStudentProfile().getId().equals(profile.getId())) {
            throw new ForbiddenException("This session belongs to another student");
        }
        if (session.getBossBonusAwardedAt() != null) {
            return getProgress(userEmail, chapterId);
        }

        List<QuestionAttempt> bossAnswers = attemptRepository.findBySessionId(sessionId).stream()
                .filter(a -> topic.equals(a.getQuestion().getTopic()))
                .toList();
        long correct = bossAnswers.stream().filter(QuestionAttempt::getCorrect).count();
        long wrong = bossAnswers.size() - correct;
        if (!isBossWon(correct, wrong)) {
            throw new IllegalArgumentException(String.format(
                    "No boss victory in this session: %d correct and %d wrong boss answers (a win needs %d correct and fewer than %d wrong)",
                    correct, wrong, BOSS_WIN_CORRECT, BOSS_LOSE_WRONG));
        }

        int newXp = (profile.getTotalXp() != null ? profile.getTotalXp() : 0) + BOSS_BONUS_XP;
        profile.setTotalXp(newXp);
        profile.setCurrentLevel((newXp / 100) + 1);
        profileRepository.save(profile);
        session.setBossBonusAwardedAt(java.time.OffsetDateTime.now());
        sessionRepository.save(session);

        return getProgress(userEmail, chapterId);
    }
}
