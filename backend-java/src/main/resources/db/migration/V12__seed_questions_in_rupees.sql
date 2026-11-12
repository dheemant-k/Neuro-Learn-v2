-- V12__seed_questions_in_rupees.sql
-- A few seeded word problems priced things in dollars, while the rest of the app (and the AI generator's
-- rules) use Indian rupees for class 9-10 students. Same numbers, so answers and explanations stay correct.
-- Only seeded questions are touched; teacher-edited or generated questions are left as they are.

UPDATE questions
SET question_text = replace(replace(question_text, ' bills', ' notes'), '$', '₹'),
    option_a      = replace(option_a, '$', '₹'),
    option_b      = replace(option_b, '$', '₹'),
    option_c      = replace(option_c, '$', '₹'),
    option_d      = replace(option_d, '$', '₹'),
    explanation   = replace(replace(explanation, ' bills', ' notes'), '$', '₹')
WHERE source = 'SEED'
  AND (question_text || option_a || option_b || option_c || option_d || coalesce(explanation, '')) LIKE '%$%';
