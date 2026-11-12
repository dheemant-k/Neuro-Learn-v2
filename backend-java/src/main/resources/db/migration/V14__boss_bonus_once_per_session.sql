-- V14__boss_bonus_once_per_session.sql
-- The boss-victory bonus used to be granted on the browser's word, as often as it was asked for.
-- It is now checked against the graded answers in the boss session and paid at most once per session;
-- this column records when it was paid.
ALTER TABLE learning_sessions ADD COLUMN boss_bonus_awarded_at TIMESTAMPTZ;
