package com.neurolearn.service;

import com.neurolearn.dto.QuestionResponse;
import com.neurolearn.entity.Question;
import com.neurolearn.repository.QuestionRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class QuestionService {

    private final QuestionRepository questionRepository;

    public QuestionService(QuestionRepository questionRepository) {
        this.questionRepository = questionRepository;
    }

    public List<QuestionResponse> getQuestions(String topic, Integer difficulty) {
        return getQuestions(topic, difficulty, null);
    }

    /**
     * Approved questions for a topic (and level, if given). With a hero theme, that hero's questions come
     * first, then the sister hero's (Supergirl/Superman), then everyone else's. The list is never cut to
     * one theme: a boss fight needs at least 4 questions to be winnable, and some heroes have fewer
     * (the Chapter 2 boss had 1–3 per hero, so it could not be beaten).
     */
    public List<QuestionResponse> getQuestions(String topic, Integer difficulty, String characterTheme) {
        List<Question> questions;
        if (topic != null && !topic.isBlank() && difficulty != null) {
            questions = questionRepository.findByTopicAndDifficulty(topic, difficulty);
        } else if (topic != null && !topic.isBlank()) {
            questions = questionRepository.findByTopic(topic);
        } else {
            questions = questionRepository.findAllApproved();
        }
        if (characterTheme != null && !characterTheme.isBlank()) {
            String theme = characterTheme.trim().toLowerCase(java.util.Locale.ROOT);
            String sister = LearningSessionService.SISTER_THEME.get(theme);
            questions = questions.stream()
                    .sorted(java.util.Comparator.comparingInt((Question q) -> {
                        String t = q.getCharacterTheme() == null ? "" : q.getCharacterTheme().toLowerCase(java.util.Locale.ROOT);
                        return t.equals(theme) ? 0 : t.equals(sister) ? 1 : 2;
                    }))
                    .collect(Collectors.toList());
        }
        return questions.stream().map(QuestionResponse::forStudent).collect(Collectors.toList());
    }

    public QuestionResponse getRandomQuestion(String topic, Integer difficulty) {
        return getRandomQuestion(topic, difficulty, null);
    }

    public QuestionResponse getRandomQuestion(String topic, Integer difficulty, String characterTheme) {
        Optional<Question> questionOpt;
        if (characterTheme != null && !characterTheme.isBlank()) {
            if (topic != null && !topic.isBlank() && difficulty != null) {
                questionOpt = questionRepository.findRandomQuestionByTopicAndDifficultyAndCharacterTheme(topic, difficulty, characterTheme);
            } else if (topic != null && !topic.isBlank()) {
                questionOpt = questionRepository.findRandomQuestionByTopicAndCharacterTheme(topic, characterTheme);
            } else {
                questionOpt = questionRepository.findAllApproved().stream()
                        .filter(q -> characterTheme.equalsIgnoreCase(q.getCharacterTheme()))
                        .findAny();
            }
            if (questionOpt.isEmpty()) {
                return getRandomQuestion(topic, difficulty, null);
            }
        } else {
            if (topic != null && !topic.isBlank() && difficulty != null) {
                questionOpt = questionRepository.findRandomQuestionByTopicAndDifficulty(topic, difficulty);
            } else if (topic != null && !topic.isBlank()) {
                questionOpt = questionRepository.findRandomQuestionByTopic(topic);
            } else {
                questionOpt = questionRepository.findAllApproved().stream().findAny();
            }
        }

        return questionOpt.map(QuestionResponse::forStudent)
                .orElseGet(() -> {
                    // Fallback to any question under the topic
                    if (topic != null && !topic.isBlank()) {
                        return questionRepository.findRandomQuestionByTopic(topic)
                                .map(QuestionResponse::forStudent)
                                .orElse(null);
                    }
                    return null;
                });
    }

    public List<String> getAvailableTopics() {
        return questionRepository.findDistinctTopics();
    }
}
