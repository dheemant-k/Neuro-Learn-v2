-- V13__seed_supergirl_questions.sql
-- Supergirl had no Chapter 1 questions and only a handful in Chapter 2, so Supergirl players were served
-- other heroes' questions. These were drafted with the app's own pipeline (Gemini, then format and
-- duplicate checks and an independent re-solve), then every answer and explanation was checked by hand.
-- Stored as reviewed seed content; each wrong option keeps the student mistake it represents.

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('intro', 1, 'Supergirl buys x energy capsules and y power cores for the Fortress of Solitude for a total of ₹50. If each capsule costs ₹5 and each core costs ₹10, which linear equation represents this total?', '5x + 10y = 50', '10x + 5y = 50', '5x - 10y = 50', '5x + 10y + 50 = 0', 'A', '1. The cost of x capsules at ₹5 each is 5x.
2. The cost of y cores at ₹10 each is 10y.
3. Adding both costs together gives the total cost: 5x + 10y = 50.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Swapped the prices per capsule and per core between x and y.'), ('C', 'Subtracted the cost of power cores instead of adding it.'), ('D', 'Added the total cost of 50 to the left side instead of setting the sum equal to 50.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('intro', 1, 'Supergirl tracks a rogue drone moving along the straight line path 3x - y = 7. Which of the following ordered pairs (x, y) lies on this path?', '(3, 2)', '(2, 3)', '(3, -2)', '(2, 1)', 'A', '1. Substitute x = 3 and y = 2 into the left side of 3x - y = 7.
2. Calculate: 3(3) - 2 = 9 - 2 = 7.
3. Since LHS = RHS = 7, the point (3, 2) lies on the line.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Swapped x and y coordinates when testing the equation.'), ('C', 'Subtracted -2 instead of positive 2, getting 3(3) - (-2) = 11.'), ('D', 'Evaluated 3x + y = 7 instead of 3x - y = 7.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('intro', 1, 'Supergirl needs to reboot a mainframe requiring a linear equation in one variable. Which of the following is a linear equation in one variable?', '4x + 7 = 19', '2x + 3y = 12', 'x^2 - 5 = 0', '3x + y^2 = 8', 'A', '1. A linear equation in one variable contains only one variable and has a degree of 1.
2. 4x + 7 = 19 has only the variable x with power 1.
3. The other options either contain two variables or a variable raised to power 2.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Selected an equation with two variables instead of one variable.'), ('C', 'Selected a quadratic equation (degree 2) in one variable.'), ('D', 'Selected an equation containing a variable squared (degree 2).')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('intro', 1, 'Supergirl confirms that the coordinate (2, 1) is a solution to the equation 2x + 3y = k. What is the value of k?', 'k = 7', 'k = 8', 'k = 1', 'k = 12', 'A', '1. Substitute x = 2 and y = 1 into the equation 2x + 3y = k.
2. Calculate the left side: 2(2) + 3(1) = 4 + 3 = 7.
3. Therefore, k = 7.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Swapped the values of x and y, calculating 2(1) + 3(2) = 8.'), ('C', 'Subtracted the two terms instead of adding them, calculating 4 - 3 = 1.'), ('D', 'Multiplied the two terms instead of adding them, calculating 4 * 3 = 12.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('intro', 1, 'Supergirl saved 8 more citizens than Superman did on Monday. If Supergirl saved x citizens and Superman saved y citizens, which linear equation represents this situation?', 'x - y = 8', 'y - x = 8', 'x + y = 8', 'x = 8y', 'A', '1. Supergirl''s count (x) is 8 more than Superman''s count (y), so x = y + 8.
2. Subtract y from both sides of the equation.
3. This gives x - y = 8.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Wrote Superman''s count as greater than Supergirl''s count.'), ('C', 'Added the counts of citizens saved instead of finding their difference.'), ('D', 'Multiplied Superman''s count by 8 instead of adding 8.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('intro', 2, 'Supergirl tracks a solar beam along the path 3x + ky = 18. If the beam passes through the point (4, 3), what is the value of k?', 'k = 2', 'k = 6', 'k = 10', 'k = -2', 'A', 'Step 1: Substitute x = 4 and y = 3 into the equation 3x + ky = 18.
Step 2: 3(4) + 3k = 18, which simplifies to 12 + 3k = 18.
Step 3: Subtract 12 from both sides to get 3k = 6.
Step 4: Divide by 3 to find k = 2.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Subtracted 12 from 18 to get 3k = 6, but forgot to divide by the coefficient of y.'), ('C', 'Added 12 and 18 instead of subtracting 12, getting 3k = 30.'), ('D', 'Subtracted 18 from 12 instead of 12 from 18, getting 3k = -6 and k = -2.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('intro', 2, 'Supergirl buys entry passes for a charity event in National City. The cost of 4 adult passes and 3 child passes is ₹500. If x is the cost of an adult pass and y is the cost of a child pass, which linear equation represents this situation?', '4x + 3y = 500', '3x + 4y = 500', '4x - 3y = 500', '7(x + y) = 500', 'A', 'Step 1: The total cost of 4 adult passes at ₹x each is 4x.
Step 2: The total cost of 3 child passes at ₹y each is 3y.
Step 3: Adding both costs gives the total sum of ₹500, so 4x + 3y = 500.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Swapped the coefficients of the adult pass (x) and child pass (y).'), ('C', 'Used subtraction instead of addition for calculating total cost.'), ('D', 'Added the quantities of passes (4 + 3 = 7) together as a single multiplier.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('intro', 2, 'Supergirl sets up a defense perimeter given by the linear equation 5x - 2y = 16. Which of the following ordered pairs (x, y) is a solution to this equation?', '(4, 2)', '(2, 4)', '(4, -2)', '(3, 1)', 'A', 'Step 1: Substitute x = 4 and y = 2 into the left-hand side of 5x - 2y = 16.
Step 2: 5(4) - 2(2) = 20 - 4 = 16.
Step 3: Since LHS = RHS, the point (4, 2) is a valid solution.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Swapped the x and y coordinates when substituting into the equation.'), ('C', 'Made a sign error with y = -2, calculating 5(4) - 2(-2) = 20 - 4 instead of 20 + 4.'), ('D', 'Calculated 5(3) - 2(1) incorrectly as 16 instead of 13.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('intro', 2, 'Supergirl flies 50 km more than twice the distance covered by her DEO drone in a day. If the drone covers x km and Supergirl covers y km, which linear equation correctly expresses y in terms of x?', 'y = 2x + 50', 'y = 2x - 50', 'x = 2y + 50', 'y = 50x + 2', 'A', 'Step 1: Twice the drone''s distance is written as 2x.
Step 2: ''50 km more than'' means adding 50 to 2x.
Step 3: Therefore, Supergirl''s total distance y is given by y = 2x + 50.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Subtracted 50 instead of adding 50 for ''more than''.'), ('C', 'Swapped the variables, treating x as Supergirl''s distance and y as the drone''s distance.'), ('D', 'Swapped the multiplier 2 and the constant term 50.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('intro', 2, 'While inspecting DEO satellite signals, Supergirl needs to identify non-linear equations. Which of the following is NOT a linear equation in two variables?', '4x + xy = 10', '3x - 4y = 7', '(x)/(2) + (y)/(3) = 5', '2x + 5y + 9 = 0', 'A', 'Step 1: A linear equation in two variables must have a degree of 1 for each term containing variables.
Step 2: In 4x + xy = 10, the term xy has a degree of 1 + 1 = 2.
Step 3: Therefore, 4x + xy = 10 is not a linear equation.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Mistakenly thought that having a minus sign makes an equation non-linear.'), ('C', 'Mistakenly thought that fractional coefficients make an equation non-linear.'), ('D', 'Mistakenly thought that having the constant term on the left side makes an equation non-linear.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('intro', 3, 'Supergirl bought a total of 10 rescue gadgets, consisting of x solar suits costing ₹400 each and y energy cuffs costing ₹250 each. If she spent a total of ₹3100, how many solar suits (x) did she buy?', 'x = 4', 'x = 6', 'x = 5', 'x = 3', 'A', 'Step 1: Form the system of equations: x + y = 10 and 400x + 250y = 3100.
Step 2: Substitute y = 10 - x into the total cost equation: 400x + 250(10 - x) = 3100.
Step 3: Simplify: 400x + 2500 - 250x = 3100, giving 150x = 600, so x = 4.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Calculated the number of energy cuffs (y) instead of solar suits (x).'), ('C', 'Assumed an equal number of solar suits and energy cuffs by dividing 10 by 2.'), ('D', 'Made a subtraction error when solving 3100 - 2500, writing 450 instead of 600.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('intro', 3, 'Supergirl calculates that the forcefield boundary line follows the linear equation (a + 3)x + 2y = 24. If the point (2, 4) lies on this line, what is the value of a?', 'a = 5', 'a = 8', 'a = 2', 'a = 6', 'A', 'Step 1: Substitute x = 2 and y = 4 into the equation: (a + 3)(2) + 2(4) = 24.
Step 2: Expand and simplify: 2a + 6 + 8 = 24, which gives 2a + 14 = 24.
Step 3: Solve for a: 2a = 10, so a = 5.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Forgot to distribute 2 to the term 3 inside the bracket when evaluating (a + 3)(2).'), ('C', 'Swapped the x and y coordinates when substituting into the equation.'), ('D', 'Made an arithmetic subtraction error when solving 24 - 14.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('intro', 3, 'Supergirl''s flight speed is x km/h and a DEO drone''s speed is y km/h. Supergirl''s speed is 50 km/h more than twice the drone''s speed, and their combined speed is 800 km/h. Which pair of linear equations correctly represents this situation?', 'x - 2y = 50 and x + y = 800', 'x + 2y = 50 and x + y = 800', '2x - y = 50 and x + y = 800', 'x - 2y = 800 and x + y = 50', 'A', 'Step 1: ''Supergirl''s speed is 50 more than twice the drone''s speed'' translates to x = 2y + 50, which simplifies to x - 2y = 50.
Step 2: ''Their combined speed is 800'' translates to x + y = 800.
Step 3: The correct pair of equations is x - 2y = 50 and x + y = 800.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Translated ''50 more than twice y'' as x + 2y = 50 instead of x - 2y = 50.'), ('C', 'Doubled x instead of y, writing 2x - y = 50.'), ('D', 'Swapped the total combined speed of 800 and the difference condition of 50.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('intro', 3, 'Brainiac locks a vault with a two-digit code where x is the tens digit and y is the units digit. The sum of the digits is 9 (x + y = 9), and when 27 is added to the number, the digits reverse, giving y - x = 3. What is the original two-digit code (10x + y)?', '36', '63', '27', '45', 'A', 'Step 1: Add the two linear equations x + y = 9 and y - x = 3 to get 2y = 12, so y = 6.
Step 2: Substitute y = 6 into x + y = 9 to find x = 3.
Step 3: The original two-digit code is 10x + y = 10(3) + 6 = 36.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Swapped the tens digit and units digit, giving the reversed number instead of the original code.'), ('C', 'Took the added value 27 directly as the secret code.'), ('D', 'Picked a two-digit number whose digits sum to 9 but have a difference of 1 instead of 3.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('intro', 3, 'Supergirl must calibrate two power towers, A and B, whose energy outputs x and y satisfy the linear equations 3x - 2y = 12 and x + 4y = 18. Which coordinate pair (x, y) is the solution for both equations?', '(6, 3)', '(4, 0)', '(2, 4)', '(3, 6)', 'A', 'Step 1: From the second equation, express x in terms of y: x = 18 - 4y.
Step 2: Substitute into the first equation: 3(18 - 4y) - 2y = 12, which gives 54 - 14y = 12, so 14y = 42 and y = 3.
Step 3: Substitute y = 3 back into x = 18 - 4(3) to find x = 6, giving the solution (6, 3).', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Checked only the first equation 3x - 2y = 12 and stopped without verifying the second equation.'), ('C', 'Checked only the second equation x + 4y = 18 and stopped without verifying the first equation.'), ('D', 'Swapped the x and y values of the correct coordinate pair.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('graphing', 1, 'Supergirl is tracking a heat beam along the path y = 3x - 5. What is the y-intercept of this line?', '(0, 3)', '(0, -5)', '(5, 0)', '(0, 5)', 'B', 'The equation is in slope-intercept form y = mx + c, where c is the y-intercept. Here, c = -5, so the point is (0, -5).', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Confusing the slope m with the y-intercept c.'), ('C', 'Setting y to 0 and solving for x (finding the x-intercept instead).'), ('D', 'Ignoring the negative sign in the equation.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('graphing', 1, 'To save a falling plane, Supergirl flies along the vertical line x = 4. What is the slope of this line?', '0', '4', '1', 'Undefined', 'D', 'Vertical lines have a constant x-coordinate. Since the change in x is 0, the slope (rise/run) involves division by zero, which is undefined.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Confusing vertical lines with horizontal lines which have a slope of 0.'), ('B', 'Using the x-intercept value as the slope.'), ('C', 'Assuming vertical lines have a unit slope.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('graphing', 1, 'Supergirl calculates a flight path represented by the equation 2x + y = 6. What is the slope of this line?', '2', '6', '-2', '-6', 'C', 'Rearrange the equation to y = -2x + 6. The coefficient of x, which is -2, represents the slope.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Taking the coefficient of x directly from the original form without rearranging.'), ('B', 'Confusing the constant term with the slope.'), ('D', 'Multiplying the constant and the coefficient instead of isolating y.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('graphing', 1, 'Supergirl needs to intercept a drone moving along the x-axis. What is the equation of the x-axis?', 'x = 0', 'y = x', 'y = 0', 'y = 1', 'C', 'Every point on the x-axis has a y-coordinate of 0. Therefore, the line is defined by y = 0.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Confusing the x-axis with the y-axis, which is x = 0.'), ('B', 'Assuming the line passes through the origin at a 45-degree angle.'), ('D', 'Assuming the line is a horizontal line one unit above the origin.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('graphing', 1, 'Supergirl spots an energy signature at the point (2, 7) that lies on the line y = 3x + k. What is the value of k?', '1', '13', '2', '7', 'A', 'Substitute x = 2 and y = 7 into the equation: 7 = 3(2) + k. This simplifies to 7 = 6 + k, so k = 1.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Adding 6 to 7 instead of subtracting 6 from 7.'), ('C', 'Confusing the x-coordinate with the value of k.'), ('D', 'Confusing the y-coordinate with the value of k.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('graphing', 2, 'Supergirl flies along a path defined by the equation 3x - y = 6. What is the slope of her flight path?', 'slope = -3', 'slope = 3', 'slope = 6', 'slope = -6', 'B', 'Rewrite the equation in slope-intercept form (y = mx + c). Adding y to both sides and subtracting 6 gives y = 3x - 6. The coefficient of x is the slope, which is 3.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Confusing the sign of the x-coefficient when rearranging the equation.'), ('C', 'Mistaking the constant term for the slope.'), ('D', 'Multiplying the constant by the x-coefficient instead of isolating y.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('graphing', 2, 'To save a falling drone, Supergirl must intercept it at the y-intercept of the line 2x + 4y = 8. What is this point?', '(0, 2)', '(4, 0)', '(0, 4)', '(2, 0)', 'A', 'To find the y-intercept, set x = 0 in the equation. This gives 2(0) + 4y = 8, which simplifies to 4y = 8. Dividing by 4, we get y = 2, so the point is (0, 2).', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Finding the x-intercept instead of the y-intercept.'), ('C', 'Dividing the constant 8 by the x-coefficient instead of the y-coefficient.'), ('D', 'Identifying the x-intercept but writing it as a y-intercept point.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('graphing', 2, 'Supergirl tracks a heat signature along the line y = -2x + 5. What is the x-intercept of this line?', '(2.5, 0)', '(0, 5)', '(5, 0)', '(0, 2.5)', 'A', 'To find the x-intercept, set y = 0 in the equation. This gives 0 = -2x + 5, so 2x = 5. Dividing by 2, we get x = 2.5, resulting in the point (2.5, 0).', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Using the y-intercept value as the x-intercept coordinate.'), ('C', 'Forgetting to divide by the coefficient of x.'), ('D', 'Confusing the x and y coordinates in the final point.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('graphing', 2, 'Supergirl calculates that a rogue satellite is descending along the line y = (1/2)x + 3. What is the slope of its trajectory?', 'slope = 3', 'slope = 1/2', 'slope = 2', 'slope = 6', 'B', 'The equation is already in slope-intercept form (y = mx + c), where m is the slope. Here, m = 1/2, so the slope is 1/2.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Mistaking the y-intercept for the slope.'), ('C', 'Taking the reciprocal of the slope instead of the value itself.'), ('D', 'Multiplying the slope by the y-intercept.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('graphing', 3, 'Supergirl flies along a path defined by 3x - 2y = 12. What is the slope of her flight path?', 'slope = 3', 'slope = 1.5', 'slope = -1.5', 'slope = -3', 'B', 'Rewrite the equation in slope-intercept form (y = mx + c): -2y = -3x + 12. Dividing by -2 gives y = 1.5x - 6. The slope m is 1.5.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Incorrectly identifying the coefficient of x as the slope without isolating y.'), ('C', 'Failing to account for the negative sign when moving 3x to the other side.'), ('D', 'Swapping the signs of both coefficients during rearrangement.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('graphing', 3, 'To save a falling train, Supergirl creates a force field along the line y = -4x + 8. Where does this field intersect the x-axis?', '(2, 0)', '(8, 0)', '(0, 8)', '(0, 2)', 'A', 'For the x-intercept, set y = 0. Then 0 = -4x + 8, which means 4x = 8. Dividing by 4 gives x = 2, so the point is (2, 0).', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Confusing the y-intercept value with the x-intercept.'), ('C', 'Giving the y-intercept (0, 8) instead of the x-intercept.'), ('D', 'Swapping the coordinates of the x-intercept.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('graphing', 2, 'Supergirl detects a heat trail following the equation y = 5x. Which of these points lies on her path?', '(1, 4)', '(5, 1)', '(2, 10)', '(10, 2)', 'C', 'Substitute the x-value of each point into y = 5x to check if the y-value matches. For (2, 10), 5 times 2 equals 10, which matches the point.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Incorrectly calculating the product 5 times 1.'), ('B', 'Mistakenly dividing 5 by 5 instead of multiplying.'), ('D', 'Dividing the y-coordinate by the x-coordinate instead of multiplying.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('graphing', 1, 'Supergirl scans a security perimeter defined by x + y = 7. What is the y-intercept of this line?', '(0, 7)', '(7, 0)', '(0, 1)', '(1, 0)', 'A', 'To find the y-intercept, set x = 0. The equation becomes 0 + y = 7, so y = 7. The point is (0, 7).', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Giving the x-intercept instead of the y-intercept.'), ('C', 'Mistaking the coefficient of y for the intercept.'), ('D', 'Confusing the x-intercept with the y-intercept coordinates.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('pair_of_equations', 1, 'Supergirl flies along the line x + y = 5, while a villain escapes on path x - y = 1. Are these paths consistent or inconsistent?', 'Inconsistent', 'Consistent', 'Coincident', 'Parallel', 'B', 'Since the ratios of the coefficients of x and y are not equal (1/1 is not equal to 1/-1), the lines intersect at exactly one point (3, 2). Systems with at least one solution are consistent.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Student confused intersecting lines with parallel lines.'), ('C', 'Student incorrectly assumed all lines with similar numbers are coincident.'), ('D', 'Student identified the lines were not parallel but picked ''Parallel'' as the label for the system.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('pair_of_equations', 1, 'Supergirl notices two flight paths defined by x + 2y = 4 and 2x + 4y = 8. What is the nature of these lines?', 'Intersecting at one point', 'Parallel', 'Coincident', 'Perpendicular', 'C', 'Dividing the second equation by 2 gives x + 2y = 4, which is identical to the first. Since the equations are multiples of each other, the lines are coincident.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Student failed to simplify the second equation and assumed distinct lines.'), ('B', 'Student looked at the ratios but missed that the constant term also scales proportionally.'), ('D', 'Student incorrectly assumed that because the coefficients are doubled, the lines must be at a right angle.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('pair_of_equations', 1, 'Supergirl tracks a robot on the line 3x + y = 7. If another robot follows 3x + y = 10, how many solutions does this system have?', '1 solution', '0 solutions', '2 solutions', 'Infinitely many solutions', 'B', 'The ratio of coefficients 3/3 and 1/1 are equal, but they are not equal to the ratio of the constants 7/10. This indicates the lines are parallel and never meet.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Student assumed every system of linear equations must have a solution.'), ('C', 'Student confused the number of equations with the number of solutions.'), ('D', 'Student assumed that lines with the same slope always overlap.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('pair_of_equations', 2, 'Supergirl detects two heat signatures following the paths 2x + 3y = 6 and 4x + 6y = 18. What is the nature of these two paths?', 'Intersecting lines', 'Coincident lines', 'Parallel lines', 'Perpendicular lines', 'C', 'Compare the ratios of coefficients: a1/a2 = 2/4 = 1/2, b1/b2 = 3/6 = 1/2, and c1/c2 = 6/18 = 1/3. Since a1/a2 = b1/b2 is not equal to c1/c2, the lines are parallel.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Student assumed lines always intersect unless they are identical.'), ('B', 'Student failed to simplify the constant ratio and assumed all coefficients are proportional.'), ('D', 'Student mistakenly thought any non-intersecting lines must be perpendicular.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('pair_of_equations', 2, 'Supergirl needs to intercept a villain moving along x - 2y = 4. Which path 2x - 4y = k will result in infinitely many solutions (coincident lines)?', 'k = 4', 'k = 8', 'k = 2', 'k = 0', 'B', 'For infinitely many solutions, the ratio of coefficients must be equal: 1/2 = -2/-4 = 4/k. Solving 1/2 = 4/k gives k = 8.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Student forgot to multiply the constant term by the same factor as the variables.'), ('C', 'Student divided the constant term instead of multiplying it.'), ('D', 'Student assumed the constant must be zero for coincidence.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('pair_of_equations', 2, 'Supergirl is monitoring two energy beams: x + 2y = 3 and 2x + 4y = 6. How many common points do these beams share?', '0 points', '1 point', '2 points', 'Infinitely many points', 'D', 'The second equation is exactly double the first equation (2x + 4y = 6). This means the lines are coincident, sharing all points.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Student thought coincident lines were parallel.'), ('B', 'Student assumed all systems must have exactly one solution.'), ('C', 'Student guessed a random number of points.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('pair_of_equations', 2, 'Supergirl finds two robot paths: x + y = 10 and x - y = 4. What is the value of x at the intersection point?', 'x = 6', 'x = 7', 'x = 3', 'x = 14', 'B', 'Adding the two equations: (x + y) + (x - y) = 10 + 4 results in 2x = 14. Dividing by 2, we get x = 7.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Student calculated the difference instead of the sum.'), ('C', 'Student subtracted the equations incorrectly.'), ('D', 'Student added the constants but forgot to divide by 2.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('pair_of_equations', 3, 'Supergirl is tracking two energy beams defined by 2x - y = 5 and 4x - 2y = k. For the beams to be coincident (infinitely many solutions), what must the value of k be?', 'k = 5', 'k = 10', 'k = 2.5', 'k = 0', 'B', 'For coincident lines, the ratio of coefficients a1/a2 = b1/b2 = c1/c2 must hold. Here, 2/4 = -1/-2 = 5/k. Solving 1/2 = 5/k gives k = 10.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Student forgot to multiply the constant term by the same factor as x and y.'), ('C', 'Student divided the constant term by the ratio instead of multiplying.'), ('D', 'Student assumed the constant term must be zero for coincidence.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('pair_of_equations', 3, 'To save the city, Supergirl must find the intersection of 5x - 3y = 1 and 2x + y = 7. Where do these paths meet?', '(2, 3)', '(3, 2)', '(1, 5)', '(2, 1)', 'A', 'From the second equation, y = 7 - 2x. Substitute into the first: 5x - 3(7 - 2x) = 1. This simplifies to 5x - 21 + 6x = 1, so 11x = 22, x = 2. Substituting x = 2, y = 7 - 4 = 3.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Student swapped the x and y values in the final coordinate.'), ('C', 'Student made an arithmetic error when substituting x into the equation.'), ('D', 'Student solved for x correctly but made an error calculating y.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('pair_of_equations', 3, 'Supergirl analyzes a system of equations: x + 3y = 6 and 2x + 6y = 18. What is the nature of this system?', 'Consistent and independent', 'Consistent and dependent', 'Inconsistent (no solution)', 'Intersecting at one point', 'C', 'Check the ratios: 1/2 = 3/6, but these do not equal 6/18 (which is 1/3). Since a1/a2 = b1/b2 is not equal to c1/c2, the lines are parallel and inconsistent.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Student assumed all systems with coefficients in ratio are independent.'), ('B', 'Student mistakenly thought the lines were coincident because the ratios of x and y match.'), ('D', 'Student assumed that any two linear equations must intersect somewhere.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('pair_of_equations', 3, 'Supergirl intercepting a villain''s signal finds the lines x - 2y = 0 and 3x + 4y = 20. What is the point of intersection (x, y)?', '(2, 4)', '(4, 2)', '(5, 1)', '(1, 5)', 'B', 'From x - 2y = 0, x = 2y. Substitute into the second: 3(2y) + 4y = 20. Then 6y + 4y = 20, so 10y = 20, y = 2. Then x = 2(2) = 4.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Student swapped the variables during the substitution process.'), ('C', 'Student made a calculation error while adding the y terms.'), ('D', 'Student solved for y correctly but failed to multiply by 2 to find x.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('word_problems', 1, 'Supergirl is gathering Kryptonian crystals. She has 12 crystals in total, and she has 4 more red crystals than blue crystals. How many red crystals does she have?', '8', '4', '6', '10', 'A', 'Let r be red and b be blue. r + b = 12 and r - b = 4. Adding the equations gives 2r = 16, so r = 8.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Student calculated the difference instead of solving for the larger variable.'), ('C', 'Student divided the total by 2 without considering the difference.'), ('D', 'Student added the difference to the total before dividing.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('word_problems', 1, 'Supergirl flies to two training sites. The distance to Site A and Site B combined is 20 km, and Site A is 6 km closer than Site B. How far is Site B?', '13 km', '7 km', '14 km', '10 km', 'A', 'Let A be Site A and B be Site B. A + B = 20 and B - A = 6. Adding the equations gives 2B = 26, so B = 13.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Student solved for Site A instead of Site B.'), ('C', 'Student subtracted the difference from the total instead of using the system of equations.'), ('D', 'Student assumed both sites were equidistant from the center.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('word_problems', 1, 'Supergirl buys 2 energy bars and 3 water bottles for ₹120. If each energy bar costs ₹15 more than a water bottle, what is the price of a water bottle?', '₹18', '₹33', '₹25', '₹20', 'A', 'Let e be bar price and w be water price. 2e + 3w = 120 and e = w + 15. Substitute: 2(w + 15) + 3w = 120, so 5w + 30 = 120, 5w = 90, w = 18.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Student solved for the price of the energy bar instead of the water bottle.'), ('C', 'Student calculated 120 divided by (2+3) ignoring the price difference.'), ('D', 'Student incorrectly distributed the 2 into the bracket as 2w + 15.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('word_problems', 1, 'Supergirl uses two types of laser beams to clear debris. The sum of the intensities is 30 units, and the difference is 10 units. What is the intensity of the stronger beam?', '20 units', '10 units', '15 units', '25 units', 'A', 'Let x be the stronger beam and y the weaker. x + y = 30 and x - y = 10. Adding them gives 2x = 40, so x = 20.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Student solved for the weaker beam instead of the stronger one.'), ('C', 'Student divided the sum by 2.'), ('D', 'Student added the sum and difference and divided by 2 incorrectly.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('word_problems', 1, 'Supergirl spends 10 hours total training in the air and in the gym. She spends 2 hours more in the air than in the gym. How many hours did she spend in the air?', '6 hours', '4 hours', '5 hours', '8 hours', 'A', 'Let a be air time and g be gym time. a + g = 10 and a - g = 2. Adding them gives 2a = 12, so a = 6.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Student solved for gym time instead of air time.'), ('C', 'Student divided the total time by 2.'), ('D', 'Student simply added the difference to the gym time without using the total constraint.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('word_problems', 2, 'Supergirl saves two groups of citizens from a collapsing bridge. The first group has 4 more people than the second group, and the total number of people saved is 20. How many people are in the second group?', '8', '10', '12', '6', 'A', 'Let the second group be x. First group is x + 4. Equation: x + (x + 4) = 20. Simplifying gives 2x = 16, so x = 8.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Student assumed the total was divided equally.'), ('C', 'Student identified the size of the larger group instead of the smaller one.'), ('D', 'Student subtracted 4 from 20 and divided by 2 incorrectly.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('word_problems', 2, 'Supergirl needs to charge her solar cells at two different stations. The sum of the charging times at station A and B is 12 hours, and the difference is 2 hours. How long does she spend at station A if it is the longer one?', '7 hours', '6 hours', '5 hours', '8 hours', 'A', 'Let A = x and B = y. x + y = 12 and x - y = 2. Adding equations: 2x = 14, so x = 7.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Student simply divided the total time by 2.'), ('C', 'Student found the time for the shorter station (B) instead of the longer one.'), ('D', 'Student miscalculated the addition of 12 and 2.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('word_problems', 2, 'Supergirl spots two villain robots. The sum of their power levels is 50, and the first robot is 3 times as powerful as the second. What is the power level of the second robot?', '12.5', '10', '15', '25', 'A', 'Let second robot be x. First is 3x. Equation: 3x + x = 50. Then 4x = 50, so x = 12.5.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Student assumed the robots had a 4:1 ratio instead of 3:1.'), ('C', 'Student miscalculated the division of 50 by 4.'), ('D', 'Student divided 50 by 2 instead of 4.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('word_problems', 2, 'Supergirl flies over two sectors of the city. The distance of sector 1 is twice the distance of sector 2. The difference between the distances is 10 km. How long is sector 2?', '10 km', '20 km', '5 km', '15 km', 'A', 'Let sector 2 = x. Sector 1 = 2x. Equation: 2x - x = 10. Therefore, x = 10.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Student provided the distance for sector 1 instead of sector 2.'), ('C', 'Student halved the difference instead of solving the system.'), ('D', 'Student added the difference to the base instead of solving the equation.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('word_problems', 2, 'Supergirl flies to two different locations to save kittens. The sum of the distances is 40 km, and the difference between them is 10 km. What is the distance to the further location?', '30 km', '20 km', '25 km', '15 km', 'C', 'Let x and y be the distances. x + y = 40 and x - y = 10. Adding the equations gives 2x = 50, so x = 25.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Adding the difference to the total instead of using the system.'), ('B', 'Dividing the total distance by 2 incorrectly.'), ('D', 'Finding the shorter distance (y = 15) instead of the further one.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('word_problems', 2, 'Supergirl saves two groups of people. The number of people in the first group is 5 more than the second group. Together there are 45 people. How many are in the first group?', '20', '25', '22', '27', 'B', 'Let x be first group, y be second. x + y = 45 and x - y = 5. Adding them: 2x = 50, so x = 25.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Forgetting to add the difference factor.'), ('C', 'Halving the total without accounting for the difference.'), ('D', 'Subtracting 5 from the total instead of solving the system.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('substitution', 1, 'Supergirl is tracking a DEO satellite signal defined by the equations y = x + 3 and 2x + y = 12. Using substitution, what is the value of x?', 'x = 3', 'x = 6', 'x = 5', 'x = 4', 'A', 'Substitute y = x + 3 into the second equation: 2x + (x + 3) = 12.
Combine like terms: 3x + 3 = 12.
Subtract 3 from both sides: 3x = 9, so x = 3.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Calculated the value of y instead of x.'), ('C', 'Forgot to subtract 3 before dividing by 3, solving 3x = 15.'), ('D', 'Divided 12 by 3 directly without subtracting 3 first.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('substitution', 1, 'Supergirl needs to adjust energy levels in CatCo''s server room using the equations x = 2y and x + 3y = 20. What is the value of y?', 'y = 4', 'y = 8', 'y = 5', 'y = 10', 'A', 'Substitute x = 2y into the second equation: 2y + 3y = 20.
Combine like terms: 5y = 20.
Divide by 5: y = 4.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Calculated the value of x instead of y.'), ('C', 'Divided 20 by 4 instead of dividing by 5.'), ('D', 'Ignored the 3y term and solved 2y = 20 to get y = 10.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('substitution', 1, 'Supergirl calculates the intersection point (x, y) of two alien laser paths in National City given by y = 3x and x + y = 12. Find the point (x, y).', '(3, 9)', '(9, 3)', '(4, 12)', '(3, 6)', 'A', 'Substitute y = 3x into x + y = 12: x + 3x = 12, so 4x = 12 and x = 3.
Now substitute x = 3 back to find y: y = 3(3) = 9.
The point is (3, 9).', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Swapped the x and y values in the final coordinate pair.'), ('C', 'Omitted the single x term when combining, getting 3x = 12 so x = 4 and y = 12.'), ('D', 'Subtracted 3 from 9 instead of evaluating 3 multiplied by 3 to find y.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('substitution', 1, 'To secure a lead box containing kryptonite, Supergirl solves x = y - 2 and 2x + y = 11. What is the value of x?', 'x = 5', 'x = 3', 'x = 7', 'x = 1', 'B', 'Substitute x = y - 2 into 2x + y = 11: 2(y - 2) + y = 11.
Expand and simplify: 2y - 4 + y = 11, so 3y = 15 and y = 5.
Substitute y = 5 into x = y - 2 to get x = 3.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Calculated the value of y instead of x.'), ('C', 'Added 2 to y instead of subtracting 2 to find x.'), ('D', 'Subtracted 2 twice from y by mistake.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('substitution', 1, 'Kara Danvers is organizing news sources for a story using equations y = 4x and x + y = 25. What is the value of y?', 'y = 20', 'y = 5', 'y = 25', 'y = 16', 'A', 'Substitute y = 4x into x + y = 25: x + 4x = 25.
Combine like terms: 5x = 25, so x = 5.
Substitute x = 5 into y = 4x to get y = 4(5) = 20.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Calculated the value of x instead of y.'), ('C', 'Took the total sum of 25 as the value of y directly.'), ('D', 'Assumed x = 4 and incorrectly evaluated y = 4 * 4 = 16.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('substitution', 2, 'Supergirl is tracking a drone whose flight path follows the equations y = 3x - 2 and x + y = 14. Solve using substitution to find the value of x.', 'x = 10', 'x = 4', 'x = 3', 'x = 16', 'B', '1. Substitute y = 3x - 2 into x + y = 14 to get x + (3x - 2) = 14.
2. Combine like terms: 4x - 2 = 14.
3. Add 2 to both sides: 4x = 16, so x = 4.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Student found the value of y instead of x.'), ('C', 'Student changed -2 to +2 when substituting, solving 4x + 2 = 14.'), ('D', 'Student forgot to divide by 4 after adding 2 to 14.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('substitution', 2, 'Supergirl needs to determine the power level y of a generator using the equations x = 2y + 1 and 3x - y = 18. What is the value of y?', 'y = 7', 'y = 5', 'y = 3', 'y = 6', 'C', '1. Substitute x = 2y + 1 into 3x - y = 18 to get 3(2y + 1) - y = 18.
2. Expand and simplify: 6y + 3 - y = 18, which gives 5y + 3 = 18.
3. Subtract 3 from both sides: 5y = 15, so y = 3.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Student found the value of x instead of y.'), ('B', 'Student divided 15 by 3 instead of 5 in the equation 5y = 15.'), ('D', 'Student solved 3x = 18 directly, ignoring the -y term and substitution.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('substitution', 2, 'Supergirl is locating the landing coordinates (x, y) of Lex Luthor''s airship. The system of equations is y = 2x - 1 and 3x + 2y = 12. Solve by substitution.', '(3, 2)', '(2, 5)', '(2, 1)', '(2, 3)', 'D', '1. Substitute y = 2x - 1 into 3x + 2y = 12 to get 3x + 2(2x - 1) = 12.
2. Expand: 3x + 4x - 2 = 12, so 7x = 14, giving x = 2.
3. Substitute x = 2 into y = 2x - 1 to get y = 2(2) - 1 = 3. Point: (2, 3).', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Student swapped the values of x and y in the ordered pair.'), ('B', 'Student made a sign error when calculating y, using y = 2x + 1 instead of y = 2x - 1.'), ('C', 'Student forgot to multiply x by 2 when evaluating y, calculating y = x - 1.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('substitution', 2, 'Supergirl is rescuing citizens from two collapsing towers. The number of people in Tower A (x) and Tower B (y) satisfy x = y + 5 and 2x + 3y = 45. Solve for x.', 'x = 12', 'x = 7', 'x = 16', 'x = 2', 'A', '1. Substitute x = y + 5 into 2x + 3y = 45 to get 2(y + 5) + 3y = 45.
2. Expand and combine: 2y + 10 + 3y = 45, so 5y + 10 = 45, which gives 5y = 35 and y = 7.
3. Substitute y = 7 into x = y + 5 to find x = 12.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Student found the value of y instead of x.'), ('C', 'Student added 10 to 45 instead of subtracting it when solving 5y + 10 = 45.'), ('D', 'Student subtracted 5 from y instead of adding 5 when finding x.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('substitution', 2, 'Supergirl needs to find the frequency x of a kryptonite detector. The system of equations is y = 4x - 5 and x + y = 20. Solve using substitution to find x.', 'x = 15', 'x = 5', 'x = 3', 'x = 4', 'B', '1. Substitute y = 4x - 5 into x + y = 20 to get x + (4x - 5) = 20.
2. Combine like terms: 5x - 5 = 20.
3. Add 5 to both sides: 5x = 25, so x = 5.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Student found the value of y instead of x.'), ('C', 'Student subtracted 5 from 20 instead of adding 5 when solving 5x - 5 = 20.'), ('D', 'Student forgot to add 5 to 20, solving 5x = 20 directly.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('substitution', 3, 'Supergirl spent a total of 14 hours patrolling National City and Metropolis. The hours spent in National City (x) is 2 hours more than 3 times the hours spent in Metropolis (y), giving the system x + y = 14 and x = 3y + 2. Using substitution, find x.', 'x = 11', 'x = 3', 'x = 10', 'x = 12', 'A', '1) Substitute x = 3y + 2 into x + y = 14 to get (3y + 2) + y = 14.
2) Simplify to 4y + 2 = 14, which gives 4y = 12, so y = 3.
3) Substitute y = 3 into x = 3y + 2 to get x = 3(3) + 2 = 11.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Student calculated the value of y instead of x.'), ('C', 'Student added 2 to 14 instead of subtracting 2 when solving 4y + 2 = 14, leading to y = 4 and x = 10.'), ('D', 'Student subtracted 2 from 14 to get 12 and forgot to divide by 4 to find y.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('substitution', 3, 'Supergirl and Alex collected 25 energy crystals in total from alien ruins. Alex collected 5 crystals fewer than twice the number collected by Supergirl. If x is Supergirl''s crystals and y is Alex''s crystals, solve the system x + y = 25 and y = 2x - 5 by substitution to find the point (x, y).', '(10, 15)', '(15, 10)', '(8, 17)', '(10, 5)', 'A', '1) Substitute y = 2x - 5 into x + y = 25 to get x + (2x - 5) = 25.
2) Combine like terms to get 3x - 5 = 25, so 3x = 30, which gives x = 10.
3) Substitute x = 10 into y = 2x - 5 to get y = 2(10) - 5 = 15. The solution point is (10, 15).', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Student reversed the values of x and y in the final coordinate pair.'), ('C', 'Student subtracted 5 from 25 instead of adding 5, getting 3x = 20, leading to an incorrect x value.'), ('D', 'Student calculated y by subtracting 5 directly from x instead of using y = 2x - 5.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('substitution', 3, 'To restore the DEO defense shield, Supergirl needs to balance two core voltages, x and y. The voltages satisfy 2x - y = 4 and y = x + 3. Using substitution, find the value of primary voltage x.', 'x = 7', 'x = 1', 'x = 10', 'x = 4', 'A', '1) Substitute y = x + 3 into 2x - y = 4 to get 2x - (x + 3) = 4.
2) Distribute the negative sign: 2x - x - 3 = 4, which simplifies to x - 3 = 4.
3) Add 3 to both sides to find x = 7.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Student did not distribute the negative sign to +3, writing 2x - x + 3 = 4.'), ('C', 'Student found the value of secondary voltage y instead of primary voltage x.'), ('D', 'Student ignored the constant term 3 when substituting, writing 2x - x = 4.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('substitution', 3, 'Supergirl tracks two rogue drones moving at speeds x and y (in km/h). Their speeds satisfy 3x + 2y = 36 and x = y + 2. Using substitution, find the speed of the faster drone, x.', 'x = 8', 'x = 6', 'x = 10', 'x = 12', 'A', '1) Substitute x = y + 2 into 3x + 2y = 36 to get 3(y + 2) + 2y = 36.
2) Expand and simplify: 3y + 6 + 2y = 36, so 5y + 6 = 36, giving 5y = 30 and y = 6.
3) Substitute y = 6 into x = y + 2 to get x = 8.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Student calculated the speed of the slower drone y instead of x.'), ('C', 'Student added 2 to y twice when computing x.'), ('D', 'Student multiplied y by 2 instead of adding 2 to calculate x.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('substitution', 3, 'Supergirl rescues two scientist teams, Team A with x members and Team B with y members. The total number of members is 30, and x = 3y - 6. Using substitution, solve the system x + y = 30 and x = 3y - 6 to find the number of members in Team B (y).', 'y = 9', 'y = 21', 'y = 6', 'y = 18', 'A', '1) Substitute x = 3y - 6 into x + y = 30 to get (3y - 6) + y = 30.
2) Combine like terms to get 4y - 6 = 30, then add 6 to both sides to get 4y = 36.
3) Divide by 4 to get y = 9.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Student solved for the number of members in Team A (x) instead of Team B (y).'), ('C', 'Student subtracted 6 from 30 instead of adding 6 when solving 4y - 6 = 30.'), ('D', 'Student omitted the coefficient 3 and wrote y - 6 + y = 30.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('elimination', 1, 'Supergirl is tracking two Kryptonian drones flying through National City. Solve by elimination: x + y = 12 and x - y = 2. What is the value of x?', 'x = 7', 'x = 5', 'x = 10', 'x = 14', 'A', 'Add the two equations to eliminate y: (x + y) + (x - y) = 12 + 2.
This simplifies to 2x = 14.
Divide by 2 to get x = 7.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Solves for y instead of finding the value of x.'), ('C', 'Subtracts the two equations directly without dividing the result by 2.'), ('D', 'Adds the right-hand side constants directly without dividing by 2.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('elimination', 1, 'Supergirl needs to balance the power levels in the DEO headquarters. Solve by elimination: 2x + y = 11 and 2x - y = 5. What is the value of y?', 'y = 4', 'y = 3', 'y = 6', 'y = 8', 'B', 'Subtract the second equation from the first to eliminate x: (2x + y) - (2x - y) = 11 - 5.
This gives 2y = 6.
Divide by 2 to get y = 3.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Solves for x instead of finding the value of y.'), ('C', 'Subtracts the constants on the right-hand side but forgets to divide by 2.'), ('D', 'Adds the two equations to find x instead of subtracting them to find y.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('elimination', 1, 'Supergirl is calibrating the focal length of her heat vision. Solve by elimination: x + 2y = 10 and x - 2y = 2. What is the value of x?', 'x = 12', 'x = 2', 'x = 6', 'x = 8', 'C', 'Add both equations to eliminate y: (x + 2y) + (x - 2y) = 10 + 2.
This gives 2x = 12.
Divide by 2 to get x = 6.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Adds the right-hand side constants but forgets to divide by 2.'), ('B', 'Solves for y instead of finding the value of x.'), ('D', 'Subtracts the two equations instead of adding them.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('elimination', 1, 'Supergirl is calculating the weight distribution to lift two falling beams. Solve by elimination: 3x + y = 13 and x - y = 3. What is the value of x?', 'x = 4', 'x = 1', 'x = 16', 'x = 5', 'A', 'Add the two equations to eliminate y: (3x + y) + (x - y) = 13 + 3.
This simplifies to 4x = 16.
Divide by 4 to get x = 4.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Solves for y instead of finding the value of x.'), ('C', 'Adds the right-hand side constants but forgets to divide by 4.'), ('D', 'Subtracts the equations instead of adding them, giving 2x = 10.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('elimination', 1, 'Supergirl is measuring solar radiation absorbency rates at the Fortress of Solitude. Solve by elimination: 2x + 3y = 12 and 4x - 3y = 6. What is the value of x?', 'x = 2', 'x = 6', 'x = 18', 'x = 3', 'D', 'Add the two equations to eliminate y: (2x + 3y) + (4x - 3y) = 12 + 6.
This simplifies to 6x = 18.
Divide by 6 to get x = 3.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Solves for y instead of finding the value of x.'), ('B', 'Subtracts the constants on the right-hand side instead of adding them.'), ('C', 'Adds the right-hand side constants but forgets to divide by 6.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('elimination', 2, 'Supergirl tracks two rogue drones in National City. The system equations for their positions are 4x + 3y = 25 and 4x - 3y = 7. What is the value of x?', 'x = 4', 'x = 3', 'x = 8', 'x = 6', 'A', '1. Add the two equations to eliminate y: (4x + 4x) + (3y - 3y) = 25 + 7.
2. Simplify: 8x = 32.
3. Divide by 8 to get x = 4.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Solves for y instead of x.'), ('C', 'Adds the right-hand sides to get 32, but divides by the single coefficient 4 instead of 8.'), ('D', 'Subtracts the right-hand sides to get 18 and divides by 3 incorrectly.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('elimination', 2, 'Supergirl adjusts the power levels of two energy shields at the DEO. The equations are 3x + 4y = 26 and 3x - 4y = 10. What is the value of y?', 'y = 6', 'y = 2', 'y = 4', 'y = 11', 'B', '1. Subtract the second equation from the first to eliminate x: (3x - 3x) + (4y - (-4y)) = 26 - 10.
2. Simplify: 8y = 16.
3. Divide by 8 to get y = 2.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Solves for x instead of y.'), ('C', 'Subtracted the right-hand sides to get 16, but divided by 4 instead of 8.'), ('D', 'Substitutes x = 6 into 3x + 4y = 26 to get 18 + 4y = 26, but adds 18 to 26 instead of subtracting it.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('elimination', 2, 'Supergirl is balancing the energy output of two alien power cells. The equations are 5x + 2y = 34 and 3x - 2y = 14. What is the value of x?', 'x = 10', 'x = 6', 'x = 2', 'x = 8', 'B', '1. Add the two equations to eliminate y: (5x + 3x) + (2y - 2y) = 34 + 14.
2. Simplify: 8x = 48.
3. Divide by 8 to get x = 6.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Subtracts the equations instead of adding them, getting 2x = 20.'), ('C', 'Solves for y instead of x.'), ('D', 'Adds the right-hand sides to get 48, but divides by 6 instead of 8.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('elimination', 2, 'Supergirl uses elimination to find the speeds of two alien ships. The equations are 4x + 3y = 27 and 2x - 3y = 9. What is the value of y?', 'y = 1', 'y = 6', 'y = 9', 'y = 3', 'A', '1. Add the two equations to eliminate y: 6x = 36, so x = 6.
2. Substitute x = 6 into 4x + 3y = 27: 4(6) + 3y = 27.
3. Simplify: 24 + 3y = 27 => 3y = 3 => y = 1.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Solves for x instead of y.'), ('C', 'Substitutes x = 6 correctly to get 24 + 3y = 27, but forgets to subtract 24 from 27.'), ('D', 'Subtracted the right-hand sides as 27 - 9 = 18 and divided by 6 without eliminating a variable properly.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('elimination', 2, 'Supergirl is solving a system of equations to decode a message from Krypton. The equations are 3x + 7y = 33 and 3x + 2y = 18. What is the value of y?', 'y = 4', 'y = 3', 'y = 5', 'y = 10', 'B', '1. Subtract the second equation from the first to eliminate x: (3x - 3x) + (7y - 2y) = 33 - 18.
2. Simplify: 5y = 15.
3. Divide by 5 to get y = 3.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Solves for x instead of y.'), ('C', 'Subtracted 33 - 18 = 15 correctly, but divided by the coefficient 3 of x instead of 5.'), ('D', 'Subtracted 33 - 18 = 15, but subtracted the coefficient 5 from 15 instead of dividing.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('elimination', 3, 'Supergirl is purchasing defense equipment for National City. 2 high-grade sensors and 3 power cores cost ₹180, while 3 high-grade sensors and 2 power cores cost ₹170. Using elimination, what is the cost of one high-grade sensor?', '₹40', '₹30', '₹50', '₹35', 'B', 'Let x be sensor cost and y be core cost: 2x + 3y = 180 and 3x + 2y = 170.
Multiply first equation by 2: 4x + 6y = 360. Multiply second by 3: 9x + 6y = 510.
Subtract the two equations: (9x - 4x) = 510 - 360, so 5x = 150, which gives x = 30.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Calculated the cost of a power core (y) instead of a sensor (x).'), ('C', 'Subtracted 510 - 360 incorrectly to get 250 instead of 150.'), ('D', 'Averaged the total costs (180 + 170) / 10 instead of using the elimination method.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('elimination', 3, 'Supergirl and Alex Danvers are clearing debris from National City. In Zone 1, 4 steel beams and 3 concrete blocks weigh 25 tonnes. In Zone 2, 2 steel beams and 5 concrete blocks weigh 23 tonnes. What is the weight of one concrete block?', '4 tonnes', '7 tonnes', '3 tonnes', '5 tonnes', 'C', 'Let x = steel beam weight and y = concrete block weight. 4x + 3y = 25 and 2x + 5y = 23.
Multiply second equation by 2: 4x + 10y = 46.
Subtract first equation: (4x + 10y) - (4x + 3y) = 46 - 25, giving 7y = 21, so y = 3 tonnes.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Calculated the weight of a steel beam (x) instead of a concrete block (y).'), ('B', 'Divided 21 by 3 instead of 7 after subtracting equations.'), ('D', 'Subtracted 46 - 25 incorrectly as 35, obtaining 35 / 7 = 5.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('elimination', 3, 'Flying through a fierce storm in National City, Supergirl''s speed against the wind is 400 km/h, and her speed with the wind is 500 km/h. If x is her speed in still air and y is the wind speed, use elimination to find her flying speed in still air (x).', '50 km/h', '400 km/h', '900 km/h', '450 km/h', 'D', 'Set up equations: x - y = 400 and x + y = 500.
Add the two equations together: (x - y) + (x + y) = 400 + 500.
This simplifies to 2x = 900, which gives x = 450 km/h.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Calculated the wind speed (y) instead of her speed in still air (x).'), ('B', 'Took the speed against the wind directly without solving the system of equations.'), ('C', 'Added the two speeds together to get 2x = 900 but forgot to divide by 2.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('elimination', 3, 'Supergirl intercepts two LexCorp transports carrying alien artifacts. Transport A has 3 small crates and 4 large crates weighing 34 kg in total. Transport B has 5 small crates and 2 large crates weighing 38 kg in total. What is the weight of one small crate?', '6 kg', '4 kg', '8 kg', '7 kg', 'A', 'Let x = small crate weight and y = large crate weight: 3x + 4y = 34 and 5x + 2y = 38.
Multiply second equation by 2: 10x + 4y = 76.
Subtract first equation: (10x + 4y) - (3x + 4y) = 76 - 34, so 7x = 42, giving x = 6 kg.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('B', 'Calculated the weight of a large crate (y) instead of a small crate (x).'), ('C', 'Subtracted 76 - 34 incorrectly as 56, getting 56 / 7 = 8.'), ('D', 'Divided 42 by 6 instead of 7 when solving 7x = 42.')) AS m(k, v);

WITH new_q AS (
INSERT INTO questions (topic, difficulty, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, subject, character_theme, status, source, prompt_version)
    VALUES ('elimination', 3, 'Supergirl helps calibrate the DEO defense grid by solving a pair of power equations: 3x + 4y = 25 and 5x - 2y = 7. Using elimination, what is the value of y?', 'y = 3', 'y = 4', 'y = 11', 'y = 8', 'B', 'Multiply second equation by 2: 10x - 4y = 14.
Add to first equation: (3x + 4y) + (10x - 4y) = 25 + 14, giving 13x = 39, so x = 3.
Substitute x = 3 into 3(3) + 4y = 25, getting 9 + 4y = 25, so 4y = 16, which gives y = 4.', 'Math', 'supergirl', 'APPROVED', 'SEED', 'qgen-v2')
    RETURNING id)
INSERT INTO question_misconceptions (question_id, option_key, misconception)
SELECT new_q.id, m.k, m.v FROM new_q, (VALUES ('A', 'Solved for x instead of y.'), ('C', 'Added 15 and 7 when solving 5(3) - 2y = 7, getting 2y = 22 and y = 11.'), ('D', 'Made a sign error when subtracting 9 from 25, writing 4y = 32 and y = 8.')) AS m(k, v);
