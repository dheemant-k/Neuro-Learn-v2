package com.neurolearn.integration;

import com.fasterxml.jackson.databind.JsonNode;
import com.neurolearn.repository.QuestionAttemptRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;

import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/** The app serves difficulty by the student's class strategy (V11, docs/evaluation.md §4.5). */
class DifficultyStrategyIntegrationTest extends IntegrationTestBase {

    @Autowired
    private QuestionAttemptRepository attemptRepository;

    // ── helpers ───────────────────────────────────────────────────

    private long session(String token) throws Exception {
        return postJson("/api/sessions/start", token, Map.of("topic", "intro")).get("id").asLong();
    }

    private JsonNode next(String token, long sessionId) throws Exception {
        return getJson("/api/sessions/" + sessionId + "/next-question?topic=intro", token);
    }

    /** Asks for the next question and answers it right or wrong; returns the next-question response used. */
    private JsonNode serveAndAnswer(String token, long sessionId, boolean correct) throws Exception {
        JsonNode n = next(token, sessionId);
        answer(token, sessionId, n.get("question").get("id").asLong(), correct);
        return n;
    }

    private String classWithStrategy(String teacher, String strategy) throws Exception {
        String created = mvc.perform(authed(jsonPost("/api/teacher/classes", Map.of("name", strategy + " class")), teacher))
                .andExpect(status().isCreated()).andReturn().getResponse().getContentAsString();
        JsonNode c = json.readTree(created);
        assertThat(c.get("difficultyStrategy").asText()).isEqualTo("ADAPTIVE_RAMP"); // default
        if (!strategy.equals("ADAPTIVE_RAMP")) {
            String body = mvc.perform(authed(put("/api/teacher/classes/" + c.get("id").asLong() + "/strategy"), teacher)
                            .contentType(MediaType.APPLICATION_JSON).content(json.writeValueAsString(Map.of("strategy", strategy))))
                    .andExpect(status().isOk()).andReturn().getResponse().getContentAsString();
            assertThat(json.readTree(body).get("difficultyStrategy").asText()).isEqualTo(strategy);
        }
        return c.get("joinCode").asText();
    }

    private String studentInClass(String teacher, String strategy) throws Exception {
        String student = registerFresh("STUDENT");
        postJson("/api/student/classes/join", student, Map.of("joinCode", classWithStrategy(teacher, strategy)));
        return student;
    }

    // ── tests ─────────────────────────────────────────────────────

    @Test
    void studentsWithoutAClassGetTheAdaptiveRampAndItIsLogged() throws Exception {
        String student = registerFresh("STUDENT");
        long s = session(student);

        JsonNode first = serveAndAnswer(student, s, true);
        assertThat(first.get("currentDifficulty").asInt()).isEqualTo(1);
        assertThat(first.get("adaptiveReason").asText()).startsWith("Adaptive ramp:");
        serveAndAnswer(student, s, true);
        serveAndAnswer(student, s, true);

        JsonNode afterStreak = next(student, s);
        assertThat(afterStreak.get("currentDifficulty").asInt()).isEqualTo(2);
        assertThat(afterStreak.get("adaptiveReason").asText()).contains("3 correct in a row");
        assertThat(attemptRepository.findBySessionId(s)).allSatisfy(a ->
                assertThat(a.getDifficultyStrategy()).isEqualTo("ADAPTIVE_RAMP"));
    }

    @Test
    void adaptiveRampDropsBackAfterThreeMisses() throws Exception {
        String student = registerFresh("STUDENT");
        long s = session(student);
        for (int i = 0; i < 3; i++) serveAndAnswer(student, s, true);   // → level 2
        for (int i = 0; i < 3; i++) serveAndAnswer(student, s, false);  // 3 misses → back to 1
        JsonNode n = next(student, s);
        assertThat(n.get("currentDifficulty").asInt()).isEqualTo(1);
        assertThat(n.get("adaptiveAction").asText()).isEqualTo("DECREASE");
        assertThat(n.get("adaptiveReason").asText()).contains("back to Level 1");
    }

    @Test
    void progressCarriesAcrossSessions() throws Exception {
        String student = registerFresh("STUDENT");
        long first = session(student);
        for (int i = 0; i < 3; i++) serveAndAnswer(student, first, true);
        postJson("/api/sessions/" + first + "/complete", student, Map.of());

        long second = session(student);
        assertThat(next(student, second).get("currentDifficulty").asInt()).isEqualTo(2);
    }

    @Test
    void fixedRampClassIgnoresStreaks() throws Exception {
        String student = studentInClass(registerFresh("TEACHER"), "FIXED_RAMP");
        long s = session(student);
        for (int i = 0; i < 3; i++) serveAndAnswer(student, s, true);
        JsonNode stillOne = next(student, s);
        assertThat(stillOne.get("currentDifficulty").asInt()).isEqualTo(1);
        assertThat(stillOne.get("adaptiveReason").asText()).startsWith("Fixed ramp:");
        serveAndAnswer(student, s, true);
        serveAndAnswer(student, s, true);
        assertThat(next(student, s).get("currentDifficulty").asInt()).isEqualTo(2);
        assertThat(attemptRepository.findBySessionId(s)).allSatisfy(a ->
                assertThat(a.getDifficultyStrategy()).isEqualTo("FIXED_RAMP"));
    }

    @Test
    void bktClassUsesTheOriginalEngineAndExplainsMissingMastery() throws Exception {
        String student = studentInClass(registerFresh("TEACHER"), "BKT_THRESHOLDS");
        long s = session(student);
        serveAndAnswer(student, s, true);
        serveAndAnswer(student, s, true);   // P(L) ≈ 0.86 → engine's level 3

        JsonNode n = next(student, s);
        assertThat(n.get("currentDifficulty").asInt()).isEqualTo(3);
        assertThat(n.get("isMastered").asBoolean()).isFalse();
        assertThat(n.get("adaptiveReason").asText()).contains("answer 2 more level-3 questions correctly");
    }

    @Test
    void onlyTheClassTeacherCanChangeTheStrategyAndValuesAreValidated() throws Exception {
        String teacher = registerFresh("TEACHER");
        String other = registerFresh("TEACHER");
        String student = registerFresh("STUDENT");
        String created = mvc.perform(authed(jsonPost("/api/teacher/classes", Map.of("name", "Owned")), teacher))
                .andExpect(status().isCreated()).andReturn().getResponse().getContentAsString();
        long classId = json.readTree(created).get("id").asLong();
        String path = "/api/teacher/classes/" + classId + "/strategy";

        assertThat(statusOf(put(path).contentType(MediaType.APPLICATION_JSON).content("{\"strategy\":\"FIXED_RAMP\"}"), other)).isEqualTo(403);
        assertThat(statusOf(put(path).contentType(MediaType.APPLICATION_JSON).content("{\"strategy\":\"FIXED_RAMP\"}"), student)).isEqualTo(403);
        assertThat(statusOf(put(path).contentType(MediaType.APPLICATION_JSON).content("{\"strategy\":\"RANDOM\"}"), teacher)).isEqualTo(400);
        assertThat(statusOf(put(path).contentType(MediaType.APPLICATION_JSON).content("{\"strategy\":\"\"}"), teacher)).isEqualTo(400);
        assertThat(statusOf(put(path).contentType(MediaType.APPLICATION_JSON).content("{\"strategy\":\"fixed_ramp\"}"), teacher)).isEqualTo(200);
        assertThat(getJson("/api/teacher/classes", teacher).get(0).get("difficultyStrategy").asText()).isEqualTo("FIXED_RAMP");
    }
}
