package com.neurolearn.adaptive;

import java.util.List;

/**
 * Difficulty ramp used by the app <i>and</i> the evaluation simulator (one implementation, so the
 * app runs exactly the rule that was evaluated — docs/evaluation.md §4.5).
 *
 * <ul>
 *   <li>{@link Mode#FIXED}: 5 questions at a level, then the next level. Ignores answers.</li>
 *   <li>{@link Mode#ADAPTIVE}: same default, but up immediately after 3 correct in a row; 2 wrong in a
 *       row restart the count at the current level (slow down); 3 wrong in a row drop back one level.</li>
 * </ul>
 * Stateful: feed answers with {@link #observe(boolean)} and read {@link #level()} / {@link #reason()}.
 */
public final class DifficultyRamp {

    public enum Mode { FIXED, ADAPTIVE }

    static final int QUESTIONS_PER_LEVEL = 5;
    static final int SKIP_AHEAD_STREAK = 3;
    static final int SLOW_DOWN_STREAK = 2;
    static final int DROP_BACK_STREAK = 3;
    static final int MAX_LEVEL = 3;

    private final Mode mode;
    private int level = 1;
    private int atLevel = 0;
    private int rightStreak = 0;
    private int wrongStreak = 0;
    private String reason = "Starting at Level 1.";

    public DifficultyRamp(Mode mode) {
        this.mode = mode;
    }

    /** Replays a student's answers on one topic (oldest first) and returns the resulting ramp. */
    public static DifficultyRamp replay(Mode mode, List<Boolean> answersOldestFirst) {
        DifficultyRamp ramp = new DifficultyRamp(mode);
        for (boolean correct : answersOldestFirst) {
            ramp.observe(correct);
        }
        return ramp;
    }

    public void observe(boolean correct) {
        atLevel++;
        rightStreak = correct ? rightStreak + 1 : 0;
        wrongStreak = correct ? 0 : wrongStreak + 1;

        if (mode == Mode.ADAPTIVE) {
            if (wrongStreak >= DROP_BACK_STREAK && level > 1) {
                level--;
                reset();
                reason = String.format("%d misses in a row: back to Level %d to rebuild confidence.", DROP_BACK_STREAK, level);
                return;
            }
            if (wrongStreak == SLOW_DOWN_STREAK) {
                atLevel = 0;
                reason = String.format("%d misses in a row: staying at Level %d a little longer.", SLOW_DOWN_STREAK, level);
                return;
            }
            if (level < MAX_LEVEL && rightStreak >= SKIP_AHEAD_STREAK) {
                level++;
                reset();
                reason = String.format("%d correct in a row: skipping ahead to Level %d.", SKIP_AHEAD_STREAK, level);
                return;
            }
        }
        if (level < MAX_LEVEL && atLevel >= QUESTIONS_PER_LEVEL) {
            level++;
            reset();
            reason = String.format("%d questions done at the previous level: moving up to Level %d.", QUESTIONS_PER_LEVEL, level);
            return;
        }
        reason = level == MAX_LEVEL
                ? "Level 3 practice."
                : String.format("Level %d, question %d of %d before moving up.", level, atLevel + 1, QUESTIONS_PER_LEVEL);
    }

    private void reset() {
        atLevel = 0;
        rightStreak = 0;
        wrongStreak = 0;
    }

    public int level() {
        return level;
    }

    /** Why the next question is at {@link #level()} — shown in the app and logged on the attempt. */
    public String reason() {
        return (mode == Mode.ADAPTIVE ? "Adaptive ramp: " : "Fixed ramp: ") + reason;
    }

    public Mode mode() {
        return mode;
    }
}
