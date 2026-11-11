package com.neurolearn.entity;

/**
 * How the next question's difficulty is chosen (set per class; see V11 and docs/evaluation.md §4.5).
 * ADAPTIVE_RAMP is the default and the best all-round policy in the evaluation.
 */
public enum DifficultyStrategy {
    ADAPTIVE_RAMP,
    FIXED_RAMP,
    BKT_THRESHOLDS
}
