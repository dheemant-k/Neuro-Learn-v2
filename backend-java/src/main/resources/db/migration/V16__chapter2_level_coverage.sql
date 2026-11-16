-- V16__chapter2_level_coverage.sql
-- Chapter 2 (quadratics) had almost no level-3 questions, and "Mastered" needs two correct level-3 answers in
-- a section, so no Chapter 2 section could ever be mastered. Some sections also had no level-1 question for
-- some heroes. These 45 hand-written questions give every quadratics section, for every hero, at least one
-- level-1, one level-2 and two level-3 questions. Every keyed answer was checked with sympy; each wrong option
-- records the mistake it represents.

-- A Superman question about Superman and Supergirl was titled after Lois and Clark.
UPDATE questions SET question_text = replace(question_text, 'Lois and Clark Flight Distance:', 'Kryptonian Patrol Distance:')
    WHERE source = 'SEED' AND question_text LIKE '%Lois and Clark Flight Distance:%';

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_intro', 2, '🦇 Riddler''s Cipher: Write (x + 3)(2x - 1) = 4 in standard form ax^2 + bx + c = 0.', '2x^2 + 5x + 1 = 0', '2x^2 + 5x - 7 = 0', '2x^2 - 5x - 7 = 0', '2x^2 + 7x - 7 = 0', 'B', 'Expand: (x + 3)(2x - 1) = 2x^2 - x + 6x - 3 = 2x^2 + 5x - 3. Subtract 4 from both sides: 2x^2 + 5x - 7 = 0.', 'Math', 'batman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Added 4 to the left side instead of subtracting it.'), ('C', 'Took the middle term as -6x + x instead of 6x - x.'), ('D', 'Added 6x and x instead of combining 6x and -x.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_intro', 3, '🦇 Alfred''s Vault Code: For which value of k is x = 2 a root of kx^2 - 3x - 10 = 0?', 'k = 8', 'k = 2.5', 'k = 4', 'k = -1', 'C', 'Substitute x = 2: k(4) - 3(2) - 10 = 0, so 4k - 16 = 0 and k = 4.', 'Math', 'batman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Used x instead of x^2 for the k term (2k - 16 = 0).'), ('B', 'Left out the -3x term (4k - 10 = 0).'), ('D', 'Changed the sign of the constant (4k - 6 + 10 = 0).')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_intro', 3, '🦇 Batcomputer Root Builder: Which quadratic equation has roots x = 3 and x = -5?', 'x^2 - 2x - 15 = 0', 'x^2 + 2x + 15 = 0', 'x^2 - 8x + 15 = 0', 'x^2 + 2x - 15 = 0', 'D', 'Roots 3 and -5 give factors (x - 3)(x + 5) = 0. Expand: x^2 + 5x - 3x - 15 = x^2 + 2x - 15 = 0.', 'Math', 'batman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Wrote the factors as (x + 3)(x - 5), flipping both signs.'), ('B', 'Made the constant +15 instead of 3 × (-5) = -15.'), ('C', 'Used roots 3 and 5, dropping the minus sign.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_intro', 2, '🦸 DEO Signal Check: Is x = -3 a root of x^2 + x - 6 = 0?', 'Yes: (-3)^2 + (-3) - 6 = 0', 'No: (-3)^2 + (-3) - 6 = -18', 'No: (-3)^2 + (-3) - 6 = 6', 'No: only x = 3 can be a root', 'A', 'Substitute x = -3: (-3)^2 = 9, so 9 - 3 - 6 = 0. The equation is satisfied, so x = -3 is a root (the other root is 2).', 'Math', 'supergirl', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Squared -3 as -9 instead of 9.'), ('C', 'Added 3 instead of subtracting it (9 + 3 - 6).'), ('D', 'Assumed a root must be positive.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_intro', 3, '🦸 Brainiac''s Lock: For what value of k is x = -1 a root of 2x^2 + kx - 5 = 0?', 'k = 3', 'k = -3', 'k = -7', 'k = 7', 'B', 'Substitute x = -1: 2(1) + k(-1) - 5 = 0, so 2 - k - 5 = 0, giving -k = 3 and k = -3.', 'Math', 'supergirl', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Lost the minus sign when solving -k = 3.'), ('C', 'Squared -1 as -1 (-2 - k - 5 = 0).'), ('D', 'Combined 2 and -5 as 7 instead of -3.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_intro', 3, '🦸 National City Grid: Which equation with whole-number coefficients has roots x = 1/2 and x = -4?', '2x^2 - 7x - 4 = 0', '2x^2 + 7x + 4 = 0', '2x^2 + 7x - 4 = 0', '2x^2 + 9x - 4 = 0', 'C', 'Root 1/2 gives the factor (2x - 1); root -4 gives (x + 4). Expand (2x - 1)(x + 4) = 2x^2 + 8x - x - 4 = 2x^2 + 7x - 4.', 'Math', 'supergirl', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Used roots -1/2 and 4, flipping both signs.'), ('B', 'Made the constant +4 instead of -1 × 4 = -4.'), ('D', 'Added 8x and x instead of combining 8x and -x.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_intro', 3, '🦸 Fortress Crystal Code: One root of x^2 - 7x + k = 0 is 3. Find k and the other root.', 'k = 12, other root 4', 'k = 12, other root -4', 'k = 21, other root 7', 'k = -12, other root 4', 'A', 'Substitute x = 3: 9 - 21 + k = 0, so k = 12. Then x^2 - 7x + 12 = (x - 3)(x - 4) = 0, so the other root is 4.', 'Math', 'superman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Took the sum of the roots as -7 instead of 7.'), ('C', 'Multiplied 7 by 3 to get k.'), ('D', 'Moved the -12 across without changing its sign.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_intro', 3, '🦸 S.T.A.R. Labs Reactor: Write 3x(x - 2) = 2(x + 5) - x^2 in its simplest standard form.', '4x^2 - 4x - 10 = 0', '3x^2 - 8x - 10 = 0', '2x^2 - 4x + 5 = 0', '2x^2 - 4x - 5 = 0', 'D', 'Expand: 3x^2 - 6x = 2x + 10 - x^2. Move everything left: 4x^2 - 8x - 10 = 0. Divide by 2: 2x^2 - 4x - 5 = 0.', 'Math', 'superman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Added 2x to the left side instead of subtracting it.'), ('B', 'Left the -x^2 term on the right side.'), ('C', 'Changed the sign of the constant when moving it.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_factoring', 1, '🦸 CatCo Elevator Fix: Solve x^2 - 49 = 0 to reset the elevator code.', 'x = 7 or x = -7', 'x = 49 or x = -49', 'x = 7 only', 'x = 24.5', 'A', 'Difference of squares: (x - 7)(x + 7) = 0, so x = 7 or x = -7.', 'Math', 'supergirl', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Forgot to take the square root of 49.'), ('C', 'Missed the negative root.'), ('D', 'Halved 49 instead of taking its square root.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_factoring', 3, '🦇 Joker''s Gas Valves: Solve 6x^2 - x - 2 = 0 by factoring.', 'x = -2/3 and x = 1/2', 'x = 2/3 and x = 1/2', 'x = 2/3 and x = -1/2', 'x = 3/2 and x = -2', 'C', 'Find two numbers that multiply to 6 × (-2) = -12 and add to -1: -4 and 3. So 6x^2 - 4x + 3x - 2 = 2x(3x - 2) + 1(3x - 2) = (3x - 2)(2x + 1) = 0, giving x = 2/3 and x = -1/2.', 'Math', 'batman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Set the factors to zero with the wrong signs.'), ('B', 'Dropped the minus sign on one root.'), ('D', 'Read the roots off the coefficients inside the brackets upside down.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_factoring', 3, '🦇 Arkham Lock Override: Solve x^2 = 7x.', 'x = 7 only', 'x = 0 and x = 7', 'x = 0 and x = -7', 'x = 1 and x = 7', 'B', 'Move everything to one side: x^2 - 7x = 0. Factor: x(x - 7) = 0, so x = 0 or x = 7. Dividing both sides by x would lose the root x = 0.', 'Math', 'batman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Divided both sides by x and lost the root x = 0.'), ('C', 'Took the second root as -7.'), ('D', 'Treated the x outside the bracket as giving x = 1.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_factoring', 3, '🦸 DEO Sensor Grid: Solve 4x^2 - 12x + 9 = 0.', 'x = 3/2 and x = -3/2', 'x = 3/2 (a repeated root)', 'x = 9/4', 'x = 3 and x = 3/4', 'B', 'This is a perfect square: 4x^2 - 12x + 9 = (2x - 3)^2. So 2x - 3 = 0 and x = 3/2, a repeated root.', 'Math', 'supergirl', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Treated it like a difference of squares.'), ('C', 'Divided 9 by 4 instead of factoring.'), ('D', 'Split -12x into the wrong pair of terms.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_factoring', 3, '🦸 Brainiac''s Drone Swarm: Solve 3x^2 + 5x - 12 = 0 by factoring.', 'x = -4/3 and x = 3', 'x = 4/3 and x = 3', 'x = 4/3 and x = -3', 'x = 4 and x = -1', 'C', 'Find two numbers that multiply to 3 × (-12) = -36 and add to 5: 9 and -4. So 3x^2 + 9x - 4x - 12 = 3x(x + 3) - 4(x + 3) = (3x - 4)(x + 3) = 0, giving x = 4/3 and x = -3.', 'Math', 'supergirl', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Set both factors to zero with the wrong signs.'), ('B', 'Dropped the minus sign on x = -3.'), ('D', 'Forgot the coefficient 3 in front of x.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_factoring', 3, '🦸 LexCorp Firewall: Solve 2x^2 + 7x + 3 = 0 by factoring.', 'x = 1/2 and x = 3', 'x = -1/2 and x = -3', 'x = -1/2 and x = 3', 'x = -1 and x = -3/2', 'B', 'Find two numbers that multiply to 2 × 3 = 6 and add to 7: 6 and 1. So 2x^2 + 6x + x + 3 = 2x(x + 3) + 1(x + 3) = (2x + 1)(x + 3) = 0, giving x = -1/2 and x = -3.', 'Math', 'superman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Set the factors to zero with the wrong signs.'), ('C', 'Got the sign of only one root wrong.'), ('D', 'Paired the numbers into the wrong brackets.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_factoring', 3, '🦸 Fortress Power Grid: Solve (x - 2)(x + 5) = 8.', 'x = 2 and x = -5', 'x = 10 and x = 3', 'x = 3 and x = -6', 'x = -3 and x = 6', 'C', 'A product equal to 8 (not 0) can''t be split factor by factor. Expand: x^2 + 3x - 10 = 8, so x^2 + 3x - 18 = 0 = (x + 6)(x - 3). The roots are x = 3 and x = -6.', 'Math', 'superman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Set each bracket to zero even though the product is 8, not 0.'), ('B', 'Set each bracket equal to 8.'), ('D', 'Factored correctly but flipped both signs.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_formula', 1, '🦇 Batcave Lesson: To use the quadratic formula on 3x^2 - 5x + 2 = 0, what are a, b and c?', 'a = 3, b = -5, c = 2', 'a = 3, b = 5, c = 2', 'a = 3, b = -5, c = -2', 'a = -5, b = 3, c = 2', 'A', 'Match 3x^2 - 5x + 2 = 0 with ax^2 + bx + c = 0: a = 3, b = -5 (keep the sign), c = 2.', 'Math', 'batman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Dropped the minus sign on b.'), ('C', 'Changed the sign of c.'), ('D', 'Swapped a and b.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_formula', 1, '🦸 DEO Training: In the quadratic formula x = (-b ± √( ? )) / 2a, what goes under the square root?', 'b^2 + 4ac', 'b - 4ac', 'b^2 - 4ac', '4ac - b^2', 'C', 'The quadratic formula is x = (-b ± √(b^2 - 4ac)) / 2a. The part under the root, b^2 - 4ac, is the discriminant.', 'Math', 'supergirl', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Used + instead of - between b^2 and 4ac.'), ('B', 'Forgot to square b.'), ('D', 'Reversed the order of the subtraction.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_formula', 3, '🦇 Batmobile Brake Calibration: Solve x^2 + 6x + 4 = 0 using the quadratic formula.', 'x = 3 ± √5', 'x = -3 ± √5', 'x = -3 ± 2√5', 'x = -6 ± √5', 'B', 'a = 1, b = 6, c = 4. Discriminant = 36 - 16 = 20, and √20 = 2√5. x = (-6 ± 2√5) / 2 = -3 ± √5.', 'Math', 'batman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Used +b instead of -b.'), ('C', 'Forgot to divide √20 = 2√5 by 2.'), ('D', 'Divided only the root part by 2, not -6.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_formula', 3, '🦇 Mr. Freeze Cryo Chamber: Solve 2x^2 - 3x - 4 = 0 using the quadratic formula.', 'x = (-3 ± √41) / 4', 'x = (3 ± √23) / 4', 'x = (3 ± √41) / 2', 'x = (3 ± √41) / 4', 'D', 'a = 2, b = -3, c = -4. Discriminant = 9 - 4(2)(-4) = 9 + 32 = 41. x = (3 ± √41) / (2 × 2) = (3 ± √41) / 4.', 'Math', 'batman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Used +b instead of -b (with b = -3, -b = +3).'), ('B', 'Took c as +4, giving 9 - 32.'), ('C', 'Divided by a instead of 2a.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_formula', 3, '🦸 National City Satellite: Solve x^2 - 4x - 1 = 0 using the quadratic formula.', 'x = 2 ± √5', 'x = -2 ± √5', 'x = 2 ± √3', 'x = 4 ± √5', 'A', 'a = 1, b = -4, c = -1. Discriminant = 16 + 4 = 20, and √20 = 2√5. x = (4 ± 2√5) / 2 = 2 ± √5.', 'Math', 'supergirl', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Used +b instead of -b.'), ('C', 'Took c as +1, giving 16 - 4 = 12.'), ('D', 'Forgot to divide -b by 2a.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_formula', 3, '🦸 Kara''s Flight Path: Solve 3x^2 + 2x - 2 = 0 using the quadratic formula.', 'x = (1 ± √7) / 3', 'x = (-1 ± √7) / 3', 'x = (-1 ± √7) / 6', 'x = (-2 ± √28) / 3', 'B', 'a = 3, b = 2, c = -2. Discriminant = 4 + 24 = 28, and √28 = 2√7. x = (-2 ± 2√7) / 6 = (-1 ± √7) / 3.', 'Math', 'supergirl', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Used +b instead of -b.'), ('C', 'Divided the top by 2 but not the bottom.'), ('D', 'Divided by a instead of 2a.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_formula', 3, '🦸 Metropolis Bridge Arch: Solve x^2 + 2x - 7 = 0 using the quadratic formula.', 'x = 1 ± 2√2', 'x = -1 ± 4√2', 'x = -1 ± 2√2', 'x = -1 ± √6', 'C', 'a = 1, b = 2, c = -7. Discriminant = 4 + 28 = 32, and √32 = 4√2. x = (-2 ± 4√2) / 2 = -1 ± 2√2.', 'Math', 'superman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Used +b instead of -b.'), ('B', 'Forgot to divide 4√2 by 2.'), ('D', 'Took c as -5 by mistake, giving 4 + 20 = 24.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_formula', 3, '🦸 Daily Planet Satellite Dish: Solve 5x^2 - 2x - 1 = 0 using the quadratic formula.', 'x = (-1 ± √6) / 5', 'x = (1 ± √6) / 10', 'x = (1 ± √6) / 5', 'x = (2 ± √24) / 5', 'C', 'a = 5, b = -2, c = -1. Discriminant = 4 + 20 = 24, and √24 = 2√6. x = (2 ± 2√6) / 10 = (1 ± √6) / 5.', 'Math', 'superman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Used +b instead of -b.'), ('B', 'Divided the top by 2 but not the bottom.'), ('D', 'Divided by a instead of 2a.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_discriminant', 2, '🦸 Brainiac Probe Scan: Find the discriminant of 2x^2 - 5x + 3 = 0 and the nature of its roots.', 'Δ = 49, two distinct real roots', 'Δ = 1, two distinct real roots', 'Δ = -1, no real roots', 'Δ = 1, one repeated root', 'B', 'Δ = b^2 - 4ac = (-5)^2 - 4(2)(3) = 25 - 24 = 1. Since Δ > 0, there are two distinct real roots (x = 1 and x = 3/2).', 'Math', 'supergirl', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Added 4ac instead of subtracting it.'), ('C', 'Got the sign of the result wrong.'), ('D', 'Thought Δ = 1 means one root; only Δ = 0 gives a repeated root.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_discriminant', 3, '🦇 Riddler''s Puzzle: For what value of k does x^2 - 6x + k = 0 have equal roots?', 'k = 36', 'k = 3', 'k = 9', 'k = -9', 'C', 'Equal roots need Δ = 0: (-6)^2 - 4(1)(k) = 0, so 36 - 4k = 0 and k = 9. Check: x^2 - 6x + 9 = (x - 3)^2.', 'Math', 'batman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Set k equal to b^2 and forgot the 4.'), ('B', 'Halved 6 instead of solving 36 - 4k = 0.'), ('D', 'Got the sign wrong when solving.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_discriminant', 3, '🦇 Gotham Power Grid: For which values of k does x^2 + kx + 16 = 0 have equal roots?', 'k = 8 only', 'k = 8 or k = -8', 'k = 4 or k = -4', 'k = 16 or k = -16', 'B', 'Equal roots need Δ = 0: k^2 - 4(1)(16) = 0, so k^2 = 64 and k = 8 or k = -8. Both work: (x + 4)^2 and (x - 4)^2.', 'Math', 'batman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Forgot that k^2 = 64 also has the negative solution.'), ('C', 'Took the square root of 16 instead of 64.'), ('D', 'Set k^2 = 256 by squaring twice.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_discriminant', 3, '🦸 DEO Containment Field: For which values of k does 2x^2 + 4x + k = 0 have no real roots?', 'k < 2', 'k = 2', 'k > 8', 'k > 2', 'D', 'No real roots need Δ < 0: 4^2 - 4(2)(k) < 0, so 16 - 8k < 0, which gives 8k > 16 and k > 2.', 'Math', 'supergirl', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Flipped the inequality when solving.'), ('B', 'Gave the value for equal roots (Δ = 0).'), ('C', 'Forgot the factor a = 2 in 4ac.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_discriminant', 3, '🦸 CatCo Broadcast Tower: For what value of p does px^2 - 12x + 9 = 0 have equal roots?', 'p = 4', 'p = 3', 'p = -4', 'p = 16', 'A', 'Equal roots need Δ = 0: (-12)^2 - 4(p)(9) = 0, so 144 - 36p = 0 and p = 4. Check: 4x^2 - 12x + 9 = (2x - 3)^2.', 'Math', 'supergirl', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Divided 9 by 3 instead of solving 144 - 36p = 0.'), ('C', 'Got the sign wrong when solving.'), ('D', 'Divided 144 by 9 and forgot the 4.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_discriminant', 3, '🦸 Fortress Reactor Core: For which values of k does kx^2 + 6x + 1 = 0 have two distinct real roots?', 'k > 9', 'k < 9 and k ≠ 0', 'k < 9 (any value, including 0)', 'k = 9', 'B', 'Two distinct real roots need Δ > 0: 36 - 4k > 0, so k < 9. Also k ≠ 0, because with k = 0 the equation 6x + 1 = 0 is linear, not quadratic.', 'Math', 'superman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Flipped the inequality.'), ('C', 'Forgot that k = 0 makes the equation linear.'), ('D', 'Gave the value for equal roots (Δ = 0).')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_discriminant', 3, '🦸 LexCorp Satellite Lock: 3x^2 - 2x + c = 0 has exactly one (repeated) root. Find c and the root.', 'c = 3, root x = 1/3', 'c = 1/3, root x = -1/3', 'c = -1/3, root x = 1/3', 'c = 1/3, root x = 1/3', 'D', 'One repeated root needs Δ = 0: 4 - 12c = 0, so c = 1/3. The root is x = -b / 2a = 2 / 6 = 1/3.', 'Math', 'superman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Inverted 1/3 to get c = 3.'), ('B', 'Used x = b / 2a instead of -b / 2a.'), ('C', 'Got the sign of c wrong.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_graphing', 2, '🦸 National City Skyline: What is the vertex of the parabola y = x^2 - 6x + 5?', '(-3, -4)', '(3, 5)', '(3, -4)', '(6, 5)', 'C', 'The vertex is at x = -b / 2a = 6 / 2 = 3. Then y = 9 - 18 + 5 = -4. Vertex: (3, -4).', 'Math', 'supergirl', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Used x = b / 2a instead of -b / 2a.'), ('B', 'Took the y-intercept 5 as the vertex height.'), ('D', 'Forgot to divide by 2a.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_graphing', 3, '🦇 Batarang Arc: A Batarang follows y = -2x^2 + 8x + 3. What is its maximum height?', '2', '35', '3', '11', 'D', 'The maximum is at x = -b / 2a = -8 / (2 × -2) = 2. Then y = -2(4) + 8(2) + 3 = -8 + 16 + 3 = 11.', 'Math', 'batman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Gave the x-value of the vertex instead of the height.'), ('B', 'Squared -2x as (−2x)^2 = 4x^2 with a plus sign.'), ('C', 'Gave the starting height (the y-intercept).')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_graphing', 3, '🦇 Gotham Bridge Cable: Where does the parabola y = x^2 - 2x - 8 cross the x-axis?', '(-4, 0) and (2, 0)', '(4, 0) and (-2, 0)', '(0, -8)', '(1, -9)', 'B', 'Set y = 0: x^2 - 2x - 8 = 0, which factors as (x - 4)(x + 2) = 0. So it crosses at (4, 0) and (-2, 0).', 'Math', 'batman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Flipped the signs of both roots.'), ('C', 'Gave the y-intercept instead.'), ('D', 'Gave the vertex instead.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_graphing', 3, '🦸 Kara''s Dive: Supergirl''s path is y = x^2 + 4x + 7. What is its lowest height, and does it ever touch the ground (y = 0)?', 'Lowest 3 at x = -2; never touches the ground', 'Lowest 3 at x = 2; touches the ground twice', 'Lowest 7 at x = 0; never touches the ground', 'Lowest -3 at x = -2; touches the ground twice', 'A', 'Vertex: x = -b / 2a = -4 / 2 = -2, and y = 4 - 8 + 7 = 3, so the lowest height is 3. The parabola opens upwards and its lowest point is above 0, so it never reaches y = 0 (Δ = 16 - 28 < 0).', 'Math', 'supergirl', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Used x = b / 2a and assumed every parabola crosses the axis.'), ('C', 'Took the y-intercept as the lowest point.'), ('D', 'Got the sign of the vertex height wrong.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_graphing', 3, '🦸 DEO Radar Dish: Which parabola has its vertex at (1, -4) and passes through (3, 0)?', 'y = (x + 1)^2 - 4', 'y = (x - 1)^2 - 4', 'y = 2(x - 1)^2 - 4', 'y = (x - 1)^2 + 4', 'B', 'Vertex form: y = a(x - 1)^2 - 4. Substitute (3, 0): 0 = a(2)^2 - 4, so 4a = 4 and a = 1. The parabola is y = (x - 1)^2 - 4.', 'Math', 'supergirl', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Used (x + 1) for a vertex at x = 1.'), ('C', 'Solved 4a = 4 incorrectly.'), ('D', 'Used +4 for a vertex at y = -4.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_graphing', 3, '🦸 Superman''s Flight Arc: For y = -x^2 + 4x + 5, find the vertex and where it crosses the x-axis.', 'Vertex (-2, 9); crosses at x = 1 and x = -5', 'Vertex (2, 5); crosses at x = -1 and x = 5', 'Vertex (2, 9); crosses at x = -1 and x = 5', 'Vertex (2, 9); crosses at x = 1 and x = -5', 'C', 'Vertex: x = -b / 2a = -4 / (-2) = 2, and y = -4 + 8 + 5 = 9. Crossings: -x^2 + 4x + 5 = 0, so x^2 - 4x - 5 = 0 = (x - 5)(x + 1), giving x = 5 and x = -1.', 'Math', 'superman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Used x = b / 2a and flipped the roots.'), ('B', 'Took the y-intercept 5 as the vertex height.'), ('D', 'Flipped the signs of the roots.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_graphing', 3, '🦸 Metropolis Fountain: For y = 2x^2 - 12x + 13, find the axis of symmetry and the minimum value.', 'x = 3, minimum 13', 'x = -3, minimum 67', 'x = 6, minimum 13', 'x = 3, minimum -5', 'D', 'Axis of symmetry: x = -b / 2a = 12 / 4 = 3. Minimum: y = 2(9) - 12(3) + 13 = 18 - 36 + 13 = -5.', 'Math', 'superman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Took the y-intercept as the minimum.'), ('B', 'Used x = b / 2a, then evaluated at x = -3.'), ('C', 'Forgot to divide by 2a.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_word_problems', 1, '🦇 Batcave Training Mat: A square training mat has an area of 64 m^2. What is its side length?', '32 m', '8 m', '16 m', '-8 m or 8 m', 'B', 'Let the side be x. Then x^2 = 64, so x = 8 or x = -8. A length can''t be negative, so the side is 8 m.', 'Math', 'batman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Halved the area instead of taking its square root.'), ('C', 'Divided the area by 4, mixing it up with perimeter.'), ('D', 'Kept the negative root, but a length can''t be negative.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_word_problems', 1, '🦸 Kara''s Number Puzzle: Kara thinks of a positive number. Its square minus 5 is 44. What is the number?', '49', '√39', '7', '24.5', 'C', 'Let the number be x: x^2 - 5 = 44, so x^2 = 49 and x = 7 (it must be positive).', 'Math', 'supergirl', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Forgot to take the square root.'), ('B', 'Subtracted 5 instead of adding it (x^2 = 39).'), ('D', 'Halved 49 instead of taking its square root.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_word_problems', 1, '🦸 Daily Planet Photo: A rectangular photo is 3 cm longer than it is wide, and its area is 40 cm^2. Which equation finds the width x?', 'x^2 + 3 = 40', '2x + 3 = 40', 'x^2 - 3x - 40 = 0', 'x^2 + 3x - 40 = 0', 'D', 'The length is x + 3, so the area is x(x + 3) = 40. Expand and rearrange: x^2 + 3x - 40 = 0 (it factors as (x + 8)(x - 5), so the width is 5 cm).', 'Math', 'superman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Added 3 to x^2 instead of multiplying x by (x + 3).'), ('B', 'Used a perimeter-style sum instead of the area.'), ('C', 'Used x - 3 for the length.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_word_problems', 3, '🦇 Batmobile Garage: A rectangular garage has a perimeter of 34 m and an area of 60 m^2. What are its dimensions?', '15 m by 4 m', '10 m by 6 m', '12 m by 5 m', '17 m by 3.5 m', 'C', 'Length + width = 34 / 2 = 17, so width = 17 - L. Area: L(17 - L) = 60, so L^2 - 17L + 60 = 0 = (L - 12)(L - 5). The garage is 12 m by 5 m.', 'Math', 'batman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Matched the area but not the perimeter (15 + 4 = 19, not 17).'), ('B', 'Matched the area but not the perimeter (10 + 6 = 16, not 17).'), ('D', 'Used the full perimeter as one side.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_word_problems', 3, '🦇 Rooftop Grapple: A grapple falls from a 40 m roof with height h = -5t^2 + 10t + 40 metres after t seconds. When does it hit the street?', 't = 1 s', 't = -2 s or t = 4 s', 't = 8 s', 't = 4 s', 'D', 'Set h = 0: -5t^2 + 10t + 40 = 0. Divide by -5: t^2 - 2t - 8 = 0 = (t - 4)(t + 2). Time can''t be negative, so t = 4 s.', 'Math', 'batman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Gave the time of maximum height (t = -b / 2a).'), ('B', 'Kept the negative time, which isn''t possible.'), ('C', 'Read the constant -8 as the answer.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_word_problems', 3, '🦸 DEO Access Codes: Two consecutive positive odd numbers have a product of 143. What are they?', '13 and 15', '11 and 13', '9 and 11', '-13 and -11', 'B', 'Let the numbers be x and x + 2: x(x + 2) = 143, so x^2 + 2x - 143 = 0 = (x + 13)(x - 11). The positive solution is x = 11, so the numbers are 11 and 13.', 'Math', 'supergirl', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Took the root 13 as the smaller number.'), ('C', 'Guessed numbers near √143 without checking.'), ('D', 'Kept the negative pair, but the numbers must be positive.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_word_problems', 3, '🦸 DEO Drone Test Zone: The DEO has 40 m of fencing for a rectangular test zone. What is the largest area it can enclose?', '100 m^2', '400 m^2', '96 m^2', '1600 m^2', 'A', 'If the width is w, the length is 20 - w and the area is A = w(20 - w) = -w^2 + 20w. The maximum is at w = -b / 2a = 10, giving A = 10 × 10 = 100 m^2 (a square).', 'Math', 'supergirl', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Squared half the fencing (20^2) instead of a quarter.'), ('C', 'Picked one possible rectangle (12 × 8) rather than the maximum.'), ('D', 'Squared the full 40 m of fencing.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source)
    VALUES ('quad_word_problems', 3, '🦸 Fortress Crystal Garden: A rectangle''s length is 2 m more than twice its width, and its area is 60 m^2. Find the width.', '6 m', '5 m', '-6 m or 5 m', '√30 m', 'B', 'Width w, length 2w + 2: w(2w + 2) = 60, so 2w^2 + 2w - 60 = 0, i.e. w^2 + w - 30 = 0 = (w + 6)(w - 5). Width must be positive, so w = 5 m (length 12 m).', 'Math', 'superman', 'APPROVED', 'SEED')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Took the root -6 and dropped its sign.'), ('C', 'Kept the negative width, which isn''t possible.'), ('D', 'Ignored the linear term (w^2 = 30).')) AS m(k, v);
