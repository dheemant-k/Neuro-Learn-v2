-- V11__difficulty_strategy.sql
-- Per-class choice of how the next question's difficulty is picked (docs/evaluation.md §4.5):
--   ADAPTIVE_RAMP  - ramp + skip ahead after 3 correct / slow down after misses (default)
--   FIXED_RAMP     - 5 questions per level, ignores answers (comparison arm for a pilot)
--   BKT_THRESHOLDS - the original engine (P(L) cut-offs)
-- Each attempt records which strategy served it, so a pilot can compare them.

ALTER TABLE classes
    ADD COLUMN difficulty_strategy VARCHAR(20) NOT NULL DEFAULT 'ADAPTIVE_RAMP',
    ADD CONSTRAINT chk_class_difficulty_strategy
        CHECK (difficulty_strategy IN ('ADAPTIVE_RAMP', 'FIXED_RAMP', 'BKT_THRESHOLDS'));

ALTER TABLE learning_sessions
    ADD COLUMN last_difficulty_strategy VARCHAR(20);

ALTER TABLE question_attempts
    ADD COLUMN difficulty_strategy VARCHAR(20);
