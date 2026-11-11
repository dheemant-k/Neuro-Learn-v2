package com.neurolearn.dto;

import jakarta.validation.constraints.NotBlank;

/** strategy: ADAPTIVE_RAMP, FIXED_RAMP or BKT_THRESHOLDS. */
public record SetStrategyRequest(@NotBlank(message = "is required") String strategy) {
}
