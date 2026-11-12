package com.neurolearn.service;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import static org.assertj.core.api.Assertions.assertThat;

/** Roadmap unlock and mastery rules in ProgressService (documented in README §26). */
class ProgressRulesTest {

    @ParameterizedTest(name = "pKnow={0}, attempts={1}, correct={2} → completed={3}")
    @CsvSource({
            "0.20, 0, 0, false",   // untouched section
            "0.57, 1, 1, false",   // one lucky answer is no longer enough
            "0.86, 2, 2, false",   // two answers: still too few
            "0.49, 5, 2, false",   // enough answers, but under both thresholds
            "0.50, 3, 2, true",    // 3 answers and P(L) threshold reached
            "0.20, 6, 3, true",    // 3 correct reached even with low P(L)
            "0.95, 10, 10, true"
    })
    void sectionCompletion(double pKnow, int attempts, int correct, boolean expected) {
        assertThat(ProgressService.isSectionCompleted(pKnow, attempts, correct)).isEqualTo(expected);
    }

    @Test
    void masteryIsStricterThanUnlock() {
        assertThat(MasteryRule.isMastered(0.84, 5)).isFalse();
        assertThat(MasteryRule.isMastered(0.85, 2)).isTrue();
        assertThat(ProgressService.isSectionCompleted(0.50, 3, 1)).isTrue();
        assertThat(MasteryRule.isMastered(0.50, 5)).isFalse();
    }

    @ParameterizedTest(name = "{0} correct, {1} wrong → boss won={2}")
    @CsvSource({
            "0, 0, false",
            "3, 0, false",   // boss still has HP left
            "4, 0, true",
            "4, 2, true",
            "5, 3, false",   // third miss ends the fight first
            "6, 1, true"
    })
    void bossWin(long correct, long wrong, boolean expected) {
        assertThat(ProgressService.isBossWon(correct, wrong)).isEqualTo(expected);
    }

    @Test
    void masteryNeedsHardQuestionEvidenceNotJustHighPKnow() {
        assertThat(MasteryRule.isMastered(0.99, 0)).isFalse();
        assertThat(MasteryRule.isMastered(0.99, 1)).isFalse();
        assertThat(MasteryRule.isMastered(0.99, 2)).isTrue();
        assertThat(MasteryRule.hardCorrectStillNeeded(0)).isEqualTo(2);
        assertThat(MasteryRule.hardCorrectStillNeeded(1)).isEqualTo(1);
        assertThat(MasteryRule.hardCorrectStillNeeded(7)).isZero();
    }

    @Test
    void completedSectionIsNeverLocked() {
        assertThat(ProgressService.isSectionUnlocked(0, false, false)).isTrue();   // first section
        assertThat(ProgressService.isSectionUnlocked(3, true, false)).isTrue();    // previous done
        assertThat(ProgressService.isSectionUnlocked(3, false, false)).isFalse();  // not reached yet
        assertThat(ProgressService.isSectionUnlocked(3, false, true)).isTrue();    // done earlier: stays open
    }

    @ParameterizedTest(name = "{0}/{1} sections done → boss unlocked={2}")
    @CsvSource({
            "0, 6, false",
            "2, 6, false",
            "3, 6, true",
            "6, 6, true",
            "2, 2, true"    // short chapter: all sections done
    })
    void bossUnlock(int completed, int total, boolean expected) {
        assertThat(ProgressService.isBossUnlocked(completed, total)).isEqualTo(expected);
    }
}
