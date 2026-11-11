package com.neurolearn.adaptive;

import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/** The ramp rule the app serves with (and the simulator evaluates — same class). */
class DifficultyRampTest {

    private static List<Integer> levels(DifficultyRamp.Mode mode, boolean... answers) {
        DifficultyRamp ramp = new DifficultyRamp(mode);
        List<Integer> out = new ArrayList<>();
        for (boolean correct : answers) {
            out.add(ramp.level());
            ramp.observe(correct);
        }
        return out;
    }

    private static boolean[] repeat(boolean v, int n) {
        boolean[] a = new boolean[n];
        java.util.Arrays.fill(a, v);
        return a;
    }

    @Test
    void fixedRampIsFivePerLevelRegardlessOfAnswers() {
        assertThat(levels(DifficultyRamp.Mode.FIXED, repeat(true, 12))).containsExactly(1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3);
        assertThat(levels(DifficultyRamp.Mode.FIXED, repeat(false, 12))).containsExactly(1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3);
    }

    @Test
    void adaptiveRampSkipsAheadSlowsDownAndDropsBack() {
        assertThat(levels(DifficultyRamp.Mode.ADAPTIVE, repeat(true, 7))).containsExactly(1, 1, 1, 2, 2, 2, 3);
        assertThat(levels(DifficultyRamp.Mode.ADAPTIVE, true, false, true, false, true, true)).containsExactly(1, 1, 1, 1, 1, 2);
        assertThat(levels(DifficultyRamp.Mode.ADAPTIVE, true, true, true, false, false, false, true)).containsExactly(1, 1, 1, 2, 2, 2, 1);
    }

    @Test
    void neverGoesBelowOneOrAboveThree() {
        assertThat(levels(DifficultyRamp.Mode.ADAPTIVE, repeat(false, 20))).containsOnly(1, 2); // 5-per-level still advances at 1
        assertThat(levels(DifficultyRamp.Mode.ADAPTIVE, repeat(true, 20))).allMatch(l -> l >= 1 && l <= 3);
    }

    @Test
    void replayEqualsStepByStepAndReasonsExplainMoves() {
        List<Boolean> answers = List.of(true, true, true, false, false);
        DifficultyRamp replayed = DifficultyRamp.replay(DifficultyRamp.Mode.ADAPTIVE, answers);
        DifficultyRamp stepped = new DifficultyRamp(DifficultyRamp.Mode.ADAPTIVE);
        answers.forEach(stepped::observe);
        assertThat(replayed.level()).isEqualTo(stepped.level()).isEqualTo(2);
        assertThat(replayed.reason()).isEqualTo("Adaptive ramp: 2 misses in a row: staying at Level 2 a little longer.");

        assertThat(DifficultyRamp.replay(DifficultyRamp.Mode.ADAPTIVE, List.of(true, true, true)).reason()).contains("skipping ahead to Level 2");
        assertThat(DifficultyRamp.replay(DifficultyRamp.Mode.FIXED, List.of()).reason()).isEqualTo("Fixed ramp: Starting at Level 1.");
    }
}
