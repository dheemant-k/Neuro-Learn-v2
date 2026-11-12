package com.neurolearn.service;

import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import static org.assertj.core.api.Assertions.assertThat;

/** Roster status and curriculum-bottleneck rules behind the Teacher dashboard. */
class TeacherRulesTest {

    @ParameterizedTest(name = "avg P(L)={0}, mastered {1} of {2} topics → {3}")
    @CsvSource({
            "0.20, 0, 0, Needs Attention",
            "0.59, 0, 3, Needs Attention",
            "0.60, 0, 3, On Track",
            "0.95, 2, 3, On Track",   // high average, but one practised topic isn't mastered
            "0.95, 0, 0, On Track",   // high P(L) with no topic mastered is not mastery
            "0.90, 3, 3, Mastered",   // every practised topic meets MasteryRule
            "0.70, 1, 1, Mastered"
    })
    void studentStatus(double avgPKnow, int mastered, int practised, String expected) {
        assertThat(TeacherService.studentStatus(avgPKnow, mastered, practised)).isEqualTo(expected);
    }

    @ParameterizedTest(name = "avg={0}, struggling={1}, mastered={2} → alert={3}")
    @CsvSource({
            "0.30, 0, 0, false",  // nobody struggling → never an alert
            "0.50, 1, 5, true",   // low class average
            "0.80, 3, 3, true",   // strugglers ≥ masters
            "0.80, 1, 4, false",  // healthy average, mostly masters
            "0.65, 1, 2, false"   // exactly at the average threshold, masters outnumber
    })
    void bottleneck(double avg, int struggling, int mastered, boolean expected) {
        assertThat(TeacherService.isBottleneck(avg, struggling, mastered)).isEqualTo(expected);
    }
}
