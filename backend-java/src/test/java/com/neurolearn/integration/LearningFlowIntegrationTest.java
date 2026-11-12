package com.neurolearn.integration;

import com.fasterxml.jackson.databind.JsonNode;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * README §23 success path as a test:
 * register → start session → receive question → submit answer → performance recorded
 * → difficulty adapted → next question → complete → dashboard/profile updated.
 */
class LearningFlowIntegrationTest extends IntegrationTestBase {

    @Test
    void studentCompletesAnAdaptiveSessionAndDashboardUpdates() throws Exception {
        String token = registerFresh("STUDENT");

        JsonNode before = getJson("/api/dashboard", token);
        assertThat(before.get("total_answered").asInt()).isZero();

        long sessionId = postJson("/api/sessions/start", token, Map.of("topic", "intro")).get("id").asLong();

        int answered = 0;
        int correct = 0;
        for (int i = 0; i < 3; i++) {
            JsonNode next = getJson("/api/sessions/" + sessionId + "/next-question?topic=intro&characterTheme=batman", token);
            assertThat(next.get("adaptiveAction").asText()).isIn("INCREASE", "MAINTAIN", "DECREASE");
            assertThat(next.get("adaptiveReason").asText()).isNotBlank();
            JsonNode q = next.get("question");
            assertThat(q.get("topic").asText()).isEqualTo("intro");

            boolean answerCorrect = i != 1; // correct, wrong, correct
            JsonNode attempt = answer(token, sessionId, q.get("id").asLong(), answerCorrect);
            assertThat(attempt.get("correct").asBoolean()).isEqualTo(answerCorrect);
            answered++;
            if (answerCorrect) correct++;
        }

        JsonNode done = postJson("/api/sessions/" + sessionId + "/complete", token, Map.of());
        assertThat(done.get("totalQuestions").asInt()).isEqualTo(answered);
        assertThat(done.get("totalCorrect").asInt()).isEqualTo(correct);

        JsonNode after = getJson("/api/dashboard", token);
        assertThat(after.get("total_answered").asInt()).isEqualTo(answered);
        assertThat(after.get("total_correct").asInt()).isEqualTo(correct);
        assertThat(after.get("total_xp").asInt()).isPositive();
        assertThat(after.get("recent_history")).hasSize(answered);

        JsonNode progress = getJson("/api/progress", token);
        JsonNode intro = progress.get("sections").get(0);
        assertThat(intro.get("sectionId").asText()).isEqualTo("intro");
        assertThat(intro.get("attempts").asInt()).isEqualTo(answered);
    }

    @Test
    void missingHeroFallsBackToTheSisterHeroAtTheChosenLevel() throws Exception {
        // The seeded bank has no level-1 Supergirl question for the quadratic formula. A new student starts at
        // level 1, so the fallback must keep level 1 and prefer Superman (same world) over any other hero or level.
        String token = registerFresh("STUDENT");
        long sessionId = postJson("/api/sessions/start", token, Map.of("topic", "quad_formula")).get("id").asLong();

        JsonNode next = getJson("/api/sessions/" + sessionId
                + "/next-question?topic=quad_formula&characterTheme=supergirl", token);

        assertThat(next.get("currentDifficulty").asInt()).isEqualTo(1);
        assertThat(next.get("question").get("difficulty").asInt()).isEqualTo(1);
        assertThat(next.get("question").get("characterTheme").asText()).isEqualTo("superman");
    }

    @Test
    void supergirlHasHerOwnQuestionsInEveryChapterOneTopic() throws Exception {
        String token = registerFresh("STUDENT");
        for (String topic : List.of("intro", "graphing", "pair_of_equations", "substitution", "elimination", "word_problems")) {
            long sessionId = postJson("/api/sessions/start", token, Map.of("topic", topic)).get("id").asLong();
            JsonNode next = getJson("/api/sessions/" + sessionId + "/next-question?topic=" + topic + "&characterTheme=supergirl", token);
            assertThat(next.get("question").get("characterTheme").asText()).as(topic).isEqualTo("supergirl");
            assertThat(next.get("question").get("difficulty").asInt()).as(topic).isEqualTo(1);
        }
    }

    @Test
    void sessionsAreOwnedByTheirStudent() throws Exception {
        String owner = registerFresh("STUDENT");
        String other = registerFresh("STUDENT");

        long sessionId = postJson("/api/sessions/start", owner, Map.of("topic", "intro")).get("id").asLong();
        long questionId = getJson("/api/sessions/" + sessionId + "/next-question?topic=intro", owner)
                .get("question").get("id").asLong();
        Map<String, Object> attempt = Map.of("questionId", questionId, "selectedOption", "A", "responseTimeMs", 1000, "attemptNumber", 1);

        mvc.perform(authed(get("/api/sessions/" + sessionId + "/next-question?topic=intro"), other))
                .andExpect(status().isForbidden())
                .andExpect(jsonPath("$.message").value("This session belongs to another student"));
        assertThat(statusOf(jsonPost("/api/sessions/" + sessionId + "/attempt", attempt), other)).isEqualTo(403);
        assertThat(statusOf(jsonPost("/api/sessions/" + sessionId + "/complete", Map.of()), other)).isEqualTo(403);

        // The intruder's attempts must not have touched the owner's data.
        assertThat(getJson("/api/dashboard", owner).get("total_answered").asInt()).isZero();

        assertThat(statusOf(get("/api/sessions/99999999/next-question"), owner)).isEqualTo(404);
        assertThat(statusOf(get("/api/sessions/abc/next-question"), owner)).isEqualTo(400);
        assertThat(statusOf(jsonPost("/api/sessions/" + sessionId + "/attempt", Map.of("selectedOption", "A")), owner)).isEqualTo(400);
    }

    @Test
    void newStudentNeverSeesAnotherStudentsData() throws Exception {
        // Regression: Dashboard/Progress used to fall back to the first student in the DB
        // when the caller had no profile yet.
        String fresh = registerFresh("STUDENT");

        JsonNode dash = getJson("/api/dashboard", fresh);
        assertThat(dash.get("total_answered").asInt()).isZero();
        assertThat(dash.get("total_xp").asInt()).isZero();

        JsonNode progress = getJson("/api/progress", fresh);
        assertThat(progress.get("totalXp").asInt()).isZero();
        for (JsonNode s : progress.get("sections")) {
            assertThat(s.get("attempts").asInt()).as(s.get("sectionId").asText()).isZero();
        }
    }

    /** Answers {@code correct} boss questions right and {@code wrong} wrong in a fresh boss session. */
    private long fightBoss(String token, int correct, int wrong) throws Exception {
        long sessionId = postJson("/api/sessions/start", token, Map.of("topic", "final_boss")).get("id").asLong();
        JsonNode bossQuestions = getJson("/api/questions?topic=final_boss", token);
        assertThat(bossQuestions.size()).isGreaterThanOrEqualTo(correct + wrong);
        int i = 0;
        for (; i < correct; i++) answer(token, sessionId, bossQuestions.get(i).get("id").asLong(), true);
        for (int j = 0; j < wrong; j++, i++) answer(token, sessionId, bossQuestions.get(i).get("id").asLong(), false);
        return sessionId;
    }

    private int xp(String token) throws Exception {
        return getJson("/api/progress", token).get("totalXp").asInt();
    }

    @Test
    void bossBonusIsPaidOnlyForAWinTheServerGraded() throws Exception {
        String student = registerFresh("STUDENT");

        // No session, or a session with no boss answers: nothing to verify, no bonus.
        assertThat(statusOf(jsonPost("/api/progress/boss-victory", Map.of("bossTopic", "final_boss")), student)).isEqualTo(400);
        long empty = postJson("/api/sessions/start", student, Map.of("topic", "final_boss")).get("id").asLong();
        assertThat(statusOf(jsonPost("/api/progress/boss-victory", Map.of("sessionId", empty, "bossTopic", "final_boss")), student)).isEqualTo(400);

        // Lost fight (3 misses): no bonus.
        long lost = fightBoss(student, 4, 3);
        int beforeLost = xp(student);
        assertThat(statusOf(jsonPost("/api/progress/boss-victory", Map.of("sessionId", lost, "bossTopic", "final_boss")), student)).isEqualTo(400);
        assertThat(xp(student)).isEqualTo(beforeLost);

        // Won fight: +100 once; asking again changes nothing.
        long won = fightBoss(student, 4, 1);
        int beforeWin = xp(student);
        JsonNode after = postJson("/api/progress/boss-victory", student, Map.of("sessionId", won, "bossTopic", "final_boss"));
        assertThat(after.get("totalXp").asInt()).isEqualTo(beforeWin + 100);
        JsonNode again = postJson("/api/progress/boss-victory", student, Map.of("sessionId", won, "bossTopic", "final_boss"));
        assertThat(again.get("totalXp").asInt()).isEqualTo(beforeWin + 100);
    }

    @Test
    void bossBonusCannotBeClaimedWithSomeoneElsesSessionOrForANonBossTopic() throws Exception {
        String winner = registerFresh("STUDENT");
        String other = registerFresh("STUDENT");
        long won = fightBoss(winner, 4, 0);

        assertThat(statusOf(jsonPost("/api/progress/boss-victory", Map.of("sessionId", won, "bossTopic", "final_boss")), other)).isEqualTo(403);
        assertThat(statusOf(jsonPost("/api/progress/boss-victory", Map.of("sessionId", won, "bossTopic", "intro")), winner)).isEqualTo(400);
        assertThat(xp(other)).isZero();
    }
}
