# NeuroLearn — Database and Metrics Guide

Companion to [PROJECT_GUIDE.md](PROJECT_GUIDE.md). It answers four questions:

- What is stored?
- Where is it stored?
- Which code writes it, and when?
- Which code reads it, and what does it compute?

Everything here was checked against the code and the local database on 12 Nov 2026. File references point at
`backend-java/src/main/java/com/neurolearn/`.

---

## 1. Look at the database yourself

The local database runs in Docker as `neurolearn-postgres` (PostgreSQL 16), on port **5433**.
These are the local development defaults from `application-dev.yml`: database `neurolearn`, user `neurolearn`, password `neurolearn`.
They are not the production (Neon) credentials.

```bash
docker exec -it neurolearn-postgres psql -U neurolearn -d neurolearn
```

Useful psql commands:

| Command | What it shows |
|---|---|
| `\dt` | every table |
| `\d question_attempts` | columns, keys, constraints and indexes of one table |
| `select * from flyway_schema_history;` | which migration created what, and when |
| `\q` | quit |

For a GUI, use DBeaver or pgAdmin with these settings: host `localhost`, port `5433`, database `neurolearn`, user `neurolearn`.

The schema is created only by Flyway migrations (`backend-java/src/main/resources/db/migration/V1…V14`).
Hibernate is set to `validate`, so it never changes tables. If code and schema disagree, the app refuses to start.

---

## 2. The map: 11 tables in 4 groups

```
 PEOPLE                    CONTENT                          LEARNING                                ORGANISATION
 ──────                    ───────                          ────────                                ────────────
 users ─┬─ 1:1 ─ student_profiles ─┬─ 1:N ─ learning_sessions ─┬─ 1:N ─ question_attempts ─ N:1 ─┐   classes
        │                          │                           └─ 1:N ─ session_hint_events ─ N:1 ┤      │ 1:N
        │                          ├─ 1:N ─ topic_progress  (one row per student × topic)         │   class_enrollments ─ N:1 ─ student_profiles
        │                          └─ 1:N ─ question_attempts (also linked directly)               │
        │                                                                                         │
        ├─ parent_student_links (parent user ↔ student user)       questions ─ 1:N ─ question_misconceptions
        └─ classes.teacher_user_id, questions.created_by_user_id
```

| Group | Table | One row is… | Rows (local) |
|---|---|---|---|
| People | `users` | one login account (student, teacher or parent) | 13 |
| People | `student_profiles` | the game and learning state of one student | 10 |
| Content | `questions` | one multiple-choice question | 330 |
| Content | `question_misconceptions` | the mistake behind one wrong option | 603 |
| Learning | `learning_sessions` | one quiz sitting | 61 |
| Learning | `question_attempts` | **one answer** (the raw evidence) | 66 |
| Learning | `session_hint_events` | one 50:50 or clue used | 1 |
| Learning | `topic_progress` | one student's running state in one topic | 23 |
| Organisation | `classes` | a teacher's class (with its difficulty strategy) | 2 |
| Organisation | `class_enrollments` | one student in one class | 3 |
| Organisation | `parent_student_links` | one parent allowed to see one child | 2 |

`flyway_schema_history` is the twelfth table, but it belongs to Flyway, not to the app.

**Why there are two levels of learning data.** `question_attempts` is the **event log**: every answer, never
changed after it's written. `topic_progress` is a **running summary** (counters and P(L)), updated in the same
transaction as each attempt. Dashboards read the summary, so they don't have to rescan the log. The mastery rule
reads the log, because it needs to know *which level* each correct answer was at.

---

## 3. Every table, column by column

Legend:
- **W** = written by (file, method, and the moment it happens).
- **R** = read by.

### 3.1 `users` (V1)

| Column | Type | Meaning |
|---|---|---|
| `id` | bigint PK | |
| `name` | varchar(100) | display name |
| `email` | varchar(150) UNIQUE | the login, and the JWT subject |
| `password_hash` | varchar(255) | BCrypt hash (`$2a$10$…`, cost 10); the plain password is never stored |
| `role` | varchar(30) | `STUDENT`, `TEACHER` or `PARENT` |
| `created_at` | timestamptz | |

- **W:** `AuthService.register` when someone signs up. V5 seeded the demo accounts.
- **R:** the following, which all look a user up by email:
  - `CustomUserDetailsService` on every authenticated request (it resolves the JWT's email to a user).
  - `AuthService.login`, which compares the BCrypt hash.
  - Every service, to resolve "who is calling".

### 3.2 `student_profiles` (V1, V3)

| Column | Meaning | Written when | Actually read? |
|---|---|---|---|
| `user_id` UNIQUE | 1:1 link to `users` | registration (STUDENT only) | yes, everywhere |
| `total_xp` | game points | every answer (+15 correct / +5 wrong); boss win (+100) | dashboard, roster |
| `current_level` | `total_xp / 100 + 1` | every answer, boss win | dashboard, roster |
| `overall_accuracy` | % correct over **attempt rows** | `completeSession` | only `/api/progress` returns it; the dashboards compute their own from `topic_progress` |
| `p_know` | P(L) of the **last topic answered** | every answer | only as a fallback when a student has no `topic_progress` rows |

- **W:** `AuthService.register` creates the row. `LearningSessionService.recordAttempt` and `completeSession` update it, and so does `ProgressService.awardBossDefeatBonus`.

`p_know` here is a leftover from before per-topic BKT. It is overwritten by whichever topic was answered last,
so it isn't a meaningful "overall" number. Every screen computes overall P(L) as the mean of the topic rows instead.

### 3.3 `questions` (V1, V6, V10)

| Column | Meaning |
|---|---|
| `topic` | section id, e.g. `elimination`, `quad_formula`, `final_boss` |
| `difficulty` | 1, 2 or 3 |
| `question_text`, `option_a`…`option_d` | the question |
| `correct_answer` | `A`–`D`. **Never sent to the browser before the student answers** (`QuestionResponse.forStudent` blanks it) |
| `explanation` | worked solution, shown after the answer |
| `subject` | always `Math` today |
| `character_theme` | `batman`, `superman` or `supergirl`: which hero's story the question is written for |
| `status` | `APPROVED`, `PENDING` or `REJECTED`. **Students are only ever served APPROVED questions**; the filter is in every query in `QuestionRepository` |
| `source` | `SEED` (migration), `LLM` (AI-generated) or `TEACHER` |
| `created_by_user_id`, `generator_model`, `prompt_version`, `created_at`, `reviewed_at` | provenance of AI questions: who asked, which model, which prompt, when approved |

- **W:**
  - Seed migrations V2, V6, V7, V12 and V13.
  - `QuestionGenerationService.generate`, which saves as PENDING.
  - `TeacherQuestionService`: edit, approve, reject.
- **R:**
  - `LearningSessionService.pickQuestion`, to choose the next question.
  - `recordAttempt`, to grade the answer.
  - `QuestionGenerationService`, as duplicate check and examples.
  - The teacher question bank.

Local bank: Batman 59, Superman 63 and Supergirl 87 approved; 121 AI drafts are pending.

### 3.4 `question_misconceptions` (V10)

One row per wrong option: *"chose D because they divided the constant by the wrong coefficient"*. The pair (`question_id`, `option_key`) is unique.

- **W:**
  - the AI generator (every draft must explain every wrong option);
  - teacher edits;
  - seed migration V13.
- **R:** the teacher question bank (`QuestionBankPanel.jsx`) and the AI generator.
- **Not read** by anything a student sees yet (see §7).

### 3.5 `learning_sessions` (V1, V9, V11)

| Column | Meaning | Written when |
|---|---|---|
| `student_id` | FK → `student_profiles` | `startSession` (quiz page opens) |
| `start_time` / `end_time` | | start / `completeSession` |
| `questions_attempted`, `accuracy` | totals for this sitting | `completeSession` |
| `last_question_id`, `last_adaptive_action`, `last_adaptive_reason`, `last_difficulty_strategy` | why the question on screen was chosen | every `next-question` call |
| `boss_bonus_awarded_at` (V14) | when this boss session's +100 bonus was paid; null if never | boss-victory claim (at most once) |

The `last_*` columns are a hand-off. When a question is served, the server notes *why* it chose it. When the
answer arrives, that reason is copied onto the attempt row (only if the answered question really is the one served).
This means every logged answer says which policy chose it and why, without trusting the browser to send it back.

### 3.6 `question_attempts` (V1, V9, V11): the most important table

| Column | Meaning | Source |
|---|---|---|
| `student_id`, `question_id`, `session_id` | who, what, which sitting | server |
| `selected_option` | `A`–`D` (CHECK constraint) | browser |
| `correct` | **graded on the server** by comparing with `questions.correct_answer` | server |
| `response_time_ms` | time from question shown to answer | browser (measured client-side) |
| `attempt_number` | always 1 today | browser |
| `hints_used` | how many hint events this session had on this question | server, from `session_hint_events` |
| `difficulty_served` | the question's level at the time | server |
| `adaptive_action` | `INCREASE` / `MAINTAIN` / `DECREASE` vs the previous question | server, from session hand-off |
| `adaptive_reason` | human-readable reason, e.g. "3 correct in a row: skipping ahead to Level 2." | server |
| `difficulty_strategy` | `ADAPTIVE_RAMP`, `FIXED_RAMP` or `BKT_THRESHOLDS` | server |
| `timestamp` | | server |

- **W:** `LearningSessionService.recordAttempt`, which writes exactly one row per answer.
- **R:**
  - **The ramp.** Before each new question, the student's whole history in the topic is replayed (oldest first) to work out the level: `findByStudentProfileIdAndQuestion_TopicOrderByTimestampAscIdAsc`.
  - **The mastery rule.** It counts correct answers on level-3 questions per topic: `countCorrectByStudentAndTopicAtDifficulty`.
  - **The dashboard's "recent history"**, which shows the last 10 answers with their response time.
  - **`completeSession`**, which computes the session and overall accuracy.
  - **Hint use**, which is refused if this question was already answered in the session.

### 3.7 `session_hint_events` (V9)

| Column | Meaning |
|---|---|
| `session_id`, `question_id` | |
| `hint_type` | `FIFTY_FIFTY` or `CLUE` |
| `eliminated_options` | e.g. `B,C`, the two wrong options removed by a 50:50, **chosen on the server** |

The triple (`session_id`, `question_id`, `hint_type`) is unique, so asking twice returns the same result.

- **R:** `recordAttempt` reads it for two things:
  - `hints_used`;
  - whether a 50:50 was used. If it was, the BKT update uses a guess probability of 0.5 instead of 0.25, so a correct answer counts as weaker evidence.

### 3.8 `topic_progress` (V1, V3): the running summary

One row per (student, topic), enforced by a UNIQUE constraint. It is created on the student's first answer in that topic.

| Column | Meaning | Update rule (per answer) |
|---|---|---|
| `attempts` | answers in this topic | +1 |
| `correct_count` | correct answers | +1 if correct |
| `p_know` | **P(L)**, BKT's probability the student knows the topic | BKT update (§5.1) |
| `mastery_score` | `round(P(L) × 100, 1)`, the same number as a percentage | recomputed from P(L) |

- **W:**
  - `recordAttempt`, on every answer (boss answers included).
  - V5, which seeded the demo history.
- **R:** every screen.
  - Student dashboard and roadmap.
  - Teacher roster and bottlenecks.
  - Parent report.
  - The BKT update itself, which reads the prior P(L).

### 3.9 `classes` and `class_enrollments` (V8, V11)

`classes` has these columns:
- `teacher_user_id`
- `name`
- `join_code` (6 characters, UNIQUE)
- **`difficulty_strategy`**: CHECK constraint, one of `ADAPTIVE_RAMP` (default), `FIXED_RAMP` or `BKT_THRESHOLDS`.

`class_enrollments` has `class_id`, `student_profile_id` and `joined_at`. The pair (class, student) is unique.

- **W:**
  - `ClassService`: create a class, join by code, remove a student.
  - The teacher's strategy dropdown (`PUT /api/teacher/classes/{id}/strategy`).
- **R:**
  - `ClassService.strategyForStudent`, before **every** question: it uses the strategy of the most recently joined class, or `ADAPTIVE_RAMP` if the student is in no class.
  - `ClassService.visibleStudentProfileIds`, so a teacher only sees students in their own classes.

### 3.10 `parent_student_links` (V4)

`parent_user_id` and `student_user_id` (both FK → `users`). The pair is unique.

- **W:** `ParentService.linkChild` (the parent enters the child's email). V5 seeded Martha → Bruce and Martha → Dick.
- **R:** `ParentService`. A parent can only open a child they are linked to (otherwise 403).

---

## 4. One answer, end to end: what is written where

This traces **Bruce answers question 19 with "A"** (attempt 95 in the local DB):

| Step | HTTP call | Reads | Writes |
|---|---|---|---|
| 1. Quiz page opens | `POST /api/sessions/start {topic}` | `users`, `student_profiles` | **`learning_sessions`**: new row 84, `start_time` |
| 2. Ask for a question | `GET /api/sessions/84/next-question?topic=pair_of_equations&characterTheme=batman` | `question_attempts` (this session; whole topic history), `topic_progress` (P(L)), `class_enrollments` → `classes` (strategy), `questions` (pick), attempts again (hard-correct count) | **`learning_sessions`** `last_question_id=19`, `last_adaptive_action=MAINTAIN`, `last_adaptive_reason="Level 1, question 3 of 5…"`, `last_difficulty_strategy=ADAPTIVE_RAMP` |
| 3. (optional) 50:50 | `POST /api/sessions/84/hints {questionId, FIFTY_FIFTY}` | `questions` (correct answer), `question_attempts` (already answered?) | **`session_hint_events`**: `eliminated_options` |
| 4. Submit | `POST /api/sessions/84/attempt {questionId:19, selectedOption:"A", responseTimeMs:1897}` | `questions` (grade), `session_hint_events`, `learning_sessions` (hand-off), `topic_progress` (prior P(L)) | one transaction: **`question_attempts`** new row 95 (correct=true, all columns above); **`student_profiles`** `total_xp += 15`, `current_level`, `p_know`; **`topic_progress`** `attempts+1`, `correct_count+1`, `p_know`, `mastery_score` |
| 5. Repeat 2–4 | | | |
| 6. Finish | `POST /api/sessions/84/complete` | `question_attempts` (this session; all of the student's attempts) | **`learning_sessions`** `end_time`, `questions_attempted=5`, `accuracy=40`; **`student_profiles`** `overall_accuracy` |

Step 4 is `@Transactional`: the attempt, XP and P(L) are written together or not at all. This is a concrete
reason the project uses a relational database (see Q2 below).

---

## 5. Every metric: stored, derived, and where it shows

### 5.1 Stored metrics (in the database)

| Metric | Where | Formula / rule |
|---|---|---|
| Correct | `question_attempts.correct` | `selected_option == questions.correct_answer` (server) |
| Response time | `question_attempts.response_time_ms` | measured in the browser |
| Hints used | `question_attempts.hints_used` | count of `session_hint_events` for that session + question |
| Level served | `question_attempts.difficulty_served` | `questions.difficulty` at answer time |
| Policy decision | `question_attempts.adaptive_action / adaptive_reason / difficulty_strategy` | copied from the session hand-off |
| XP | `student_profiles.total_xp` | +15 correct, +5 wrong, +100 for a boss win the server verified (once per boss session) |
| Level | `student_profiles.current_level` | `total_xp / 100 + 1` (integer division) |
| Topic attempts / correct | `topic_progress.attempts / correct_count` | counters |
| **P(L)** | `topic_progress.p_know` | BKT update (below); starts at 0.20 |
| Mastery score | `topic_progress.mastery_score` | `P(L) × 100`, 1 decimal |
| Session accuracy | `learning_sessions.accuracy` | correct ÷ answered in that session × 100 |
| Overall accuracy (stored) | `student_profiles.overall_accuracy` | correct ÷ all attempt rows × 100, at session end |

**The BKT update** (`adaptive/AdaptiveEngineService.updateKnowledge`). It uses the parameters in `BktParameters`:

| Parameter | Meaning | Value |
|---|---|---|
| P(L₀) | initial chance the student already knows the topic | 0.20 |
| P(T) | chance of learning it on each question | 0.18 |
| P(G) | chance of guessing right without knowing it | 0.25 (0.5 after a 50:50) |
| P(S) | chance of slipping, i.e. answering wrong while knowing it | 0.10 |

```
correct:   posterior = P(L)·(1−S) / [P(L)·(1−S) + (1−P(L))·G]
wrong:     posterior = P(L)·S     / [P(L)·S     + (1−P(L))·(1−G)]
then:      P(L)new   = posterior + (1 − posterior)·T          (clamped to 0.01–0.99, rounded to 2 dp)
predicted next-correct = P(L)new·(1−S) + (1−P(L)new)·G
```

Worked example from a fresh topic, P(L) = 0.20:

| Answer | Posterior | New P(L) |
|---|---|---|
| Correct | 0.18 / 0.38 = 0.474 | 0.474 + 0.526 × 0.18 = **0.57** |
| Wrong | 0.02 / 0.62 = 0.032 | 0.032 + 0.968 × 0.18 = **0.21** |

### 5.2 Derived metrics (computed when a screen asks)

| Metric | Computed in | Rule | Shown on |
|---|---|---|---|
| Topic accuracy | Dashboard/Progress/Teacher | `correct_count ÷ attempts × 100` | all |
| Overall answered / correct / accuracy | `DashboardService.buildDashboardForProfile` | sums of `topic_progress` | student, teacher (student view), parent |
| Overall P(L) | same | mean of the student's topic P(L)s | student, teacher roster, parent |
| Hard-correct | `MasteryRule.hardCorrectByTopic` | count of correct attempts on level-3 questions per topic | (input to Mastered) |
| **Mastered** | `MasteryRule.isMastered` | P(L) ≥ 0.85 **and** hard-correct ≥ 2 | roadmap badge, dashboards, roster, bottlenecks, parent |
| Section completed | `ProgressService.isSectionCompleted` | at least 3 answers, **and** P(L) ≥ 0.50 **or** ≥ 3 correct | roadmap |
| Section unlocked | `ProgressService.isSectionUnlocked` | first section, or previous completed, or itself completed | roadmap |
| Boss unlocked | `ProgressService.isBossUnlocked` | ≥ 3 sections completed (or all) | roadmap |
| Next level (ramp) | `adaptive/DifficultyRamp.replay` | 5 per level; 3 right in a row → up; 2 wrong in a row → reset count; 3 wrong in a row → down | quiz ("why this question") |
| Next level (BKT strategy) | `AdaptiveEngineService.evaluateBkt` | P(L) < 0.40 → L1; < 0.75 → L2; else L3 | quiz |
| Student status | `TeacherService.studentStatus` | Mastered (every practised topic meets the mastery rule on its own) / On Track (avg P(L) ≥ 0.60) / Needs Attention, plus "N/M topics mastered" | teacher roster |
| Boss won | `ProgressService.isBossWon` | in that session: ≥ 4 correct boss answers and < 3 wrong | boss bonus |
| Topic bottleneck | `TeacherService.isBottleneck` | someone below 0.60 **and** (class avg < 0.65 **or** strugglers ≥ masters) | teacher topic cards |
| Class averages | `TeacherService.getTeacherAnalytics` | mean XP, mean accuracy, mean P(L) over the roster | teacher header |

### 5.3 Evaluation metrics (simulation only, not in the database)

These are produced by `evaluation/EvaluationRunner` into `docs/evaluation/summary.csv`:

| Metric | Meaning |
|---|---|
| `mastered_by_10 / 20 / end` | share of simulated students who truly reached mastery |
| `median_questions_to_mastery` | how many questions that took |
| `mean_theta_gain` | how much true ability grew |
| `share_productive / too_hard / too_easy` | how often questions were in the useful difficulty band |
| `engine_claim_precision / recall` | when the app *said* "Mastered", how often it was true, and how many true masters it caught |
| `quit_rate` | share who gave up (frustration model) |

No real student data is used here. That is a limitation to state openly.

---

## 6. What the real local data shows (and what to say about it)

A query worth showing in the viva, which compares the event log with the summary:

```sql
select u.email,
       (select count(*) from question_attempts a where a.student_id = sp.id)          as attempt_rows,
       (select coalesce(sum(attempts),0) from topic_progress t where t.student_id = sp.id) as summary_attempts,
       (select count(*) from learning_sessions s where s.student_id = sp.id)           as sessions
from student_profiles sp join users u on u.id = sp.user_id order by sp.id;
```

| Student | attempt rows | summary attempts | sessions |
|---|---|---|---|
| bruce@neurolearn.com | 15 | 50 | 17 |
| dick@neurolearn.com | 0 | 25 | 0 |
| jason@neurolearn.com | 0 | 13 | 0 |
| testhero@neurolearn.com | 25 | 25 | 33 |

What this means:
- **Demo history is counters only.** V5 seeded `topic_progress` for Bruce, Dick and Jason so the dashboards aren't
  empty, but no individual answers. That is why totals come from `topic_progress`. It is also why Dick and Jason can
  never show "Mastered": they have no level-3 answers in the log.
- **More sessions than answers.** In development, React StrictMode runs the quiz page's start-up effect twice, so
  each quiz opens two sessions and one stays empty. Real users who leave mid-quiz also leave a session without an `end_time`.
- **Old rows show old behaviour.** Attempt 90 was served at level 3 while the ramp said level 1. That was the hero-fallback bug fixed in PR #7. Attempt 88 shows the old BKT-threshold strategy. The log is append-only, so history keeps the behaviour of its time. That is useful for audits.

---

## 7. Weak spots found while writing this (be ready for them)

These are real. Each one has the answer to give.

| # | Weak spot | Where | Say this |
|---|---|---|---|
| 1 | ~~**Boss win was trusted from the browser.**~~ **Fixed (V14).** The claim must name a boss session that belongs to the caller and holds at least 4 correct and fewer than 3 wrong boss answers, all graded on the server. The bonus is paid once per session (`learning_sessions.boss_bonus_awarded_at`), and it no longer fakes boss counters or sets P(L) to 0.95. | `ProgressService.awardBossDefeatBonus` | "The bonus is checked against the graded answers in that session and paid once; tests cover a lost fight, a replayed claim, and someone else's session." |
| 2 | ~~**One correct answer completed a section.**~~ **Fixed.** A section now needs at least 3 answers, and P(L) ≥ 0.50 or 3 correct. (One correct answer still takes P(L) from 0.20 to 0.57, but that alone no longer unlocks anything.) | `ProgressService.isSectionCompleted` | "Unlocking is easier than mastery on purpose, but it needs at least three answers of evidence." |
| 3 | ~~**Roster "Mastered" added up level-3 answers across topics.**~~ **Fixed.** The roster badge now means every topic the student has practised meets the mastery rule on its own, and it shows "N/M topics mastered". | `TeacherService.studentStatus` | "The same per-topic rule is used everywhere; the roster just summarises it." |
| 4 | **Response time is stored but not used** by any decision, only listed in recent history. | `question_attempts.response_time_ms` | "Collected on purpose for the next step: Evaluation 2 shows the ramp misreads lapses as not knowing; response time is the signal to tell them apart." |
| 5 | **Misconceptions aren't shown to students**, only to teachers. | `question_misconceptions` | "The data model and content are ready; showing 'you probably did X' on the feedback page is the next UI step." |
| 6 | **Two duplicate fields.** `mastery_score` is just P(L)×100. In the seeded demo rows it even holds accuracy (Bruce: graphing 87.5 vs P(L) 0.89). `student_profiles.p_know` is just the last topic's P(L). | `topic_progress`, `student_profiles` | "Legacy columns from before per-topic BKT; screens compute from `p_know` per topic. They can be dropped in a migration." |
| 7 | **Sessions don't store their topic**: the topic is sent with each request. | `learning_sessions` | "Adding a `topic` column would let the server reject mixed-topic sessions." |
| 8 | **Parent linking needs no consent from the child's side**: any parent account can link any student email. | `ParentService.linkChild` | "Fine for a demo; production needs an invite code from the student or teacher, like class join codes." |
| 9 | **Redundant index** `idx_users_email`, because the UNIQUE constraint already creates one. | V1 | minor |
| 10 | **P(L) is rounded to 2 decimals before it is stored**, so tiny changes are lost over many answers. | `BktUpdateResult` | minor; store full precision and round for display. |

---

## 8. More viva questions (database and metrics)

**Q1. Draw your schema.**
Use the map in §2: 11 tables in four groups (people, content, learning, organisation). The learning group is the core:
- `question_attempts` is the event log;
- `topic_progress` is the running summary;
- `learning_sessions` groups answers into sittings.

**Q2. Why a relational database?**
Three concrete reasons from this code:
1. Recording one answer writes three tables (`question_attempts`, `topic_progress`, `student_profiles`) in **one ACID transaction**. If one write failed, XP and P(L) would disagree.
2. The analytics are joins and aggregates: the teacher view joins classes → enrollments → profiles → topic_progress → attempts → questions.
3. Integrity is enforced in the database, not trusted to code:
   - 16 foreign keys;
   - UNIQUE (student, topic);
   - CHECK constraints on options, status, source, hint type and strategy.

**Q3. What is normalised, and what is denormalised on purpose?**
Users, questions and classes are normalised. `topic_progress` is a deliberate *denormalisation*: it could be computed from `question_attempts`, but it is kept up to date in the same transaction so dashboards stay fast and the BKT state persists.

**Q4. Why keep both `question_attempts` and `topic_progress`?**
BKT is a sequential model: P(L) after answer n depends on P(L) after n−1, so it must be stored. Recomputing it from the log on every request would cost O(history). The log is still kept for:
- the ramp, which replays it;
- the mastery rule, which needs level-3 answers;
- audits;
- the future pilot study.

**Q5. What happens if the server crashes halfway through saving an answer?**
`recordAttempt` is `@Transactional`, so PostgreSQL rolls back everything: no attempt row, no XP, no P(L) change.

**Q6. How do you stop a student from seeing the answer?**
`QuestionResponse.forStudent` sets `correctAnswer` and `explanation` to null on every student-facing endpoint. They come back only in the attempt response, after the answer is saved.

**Q7. How do you stop a student from claiming a wrong answer was right?**
The browser sends only `selectedOption`; `correct` is computed on the server. The `selected_option` CHECK constraint rejects anything but A–D.

**Q8. Where does P(L) live, and when does it change?**
In `topic_progress.p_know`, one value per student per topic. It changes only in `recordAttempt`, once per answer, using the BKT formula. Nothing else writes it.

**Q9. What is the difference between accuracy and P(L)?**
- **Accuracy** is past performance: correct ÷ answered.
- **P(L)** is a *belief about knowledge now*. It weighs recent answers, accounts for guessing (25%) and slipping (10%), and assumes some learning on each question (18%).

For example, on a fresh topic P(L) goes 0.20 → 0.57 → 0.86 → 0.96 over three correct answers, while accuracy is already 100% after the first. That speed is exactly why "Mastered" also needs level-3 evidence.

**Q10. Why does a wrong answer barely lower P(L) at the start?**
At P(L) = 0.20, BKT already thinks the student probably doesn't know the topic, so a wrong answer is expected. The learning-transition term then adds 18% of the remainder, and P(L) settles near 0.21. Wrong answers matter more when P(L) is high.

**Q11. Where do the BKT parameters come from?**
They are literature defaults (Corbett & Anderson 1995; typical published ranges), in `BktParameters`. They are not fitted, because there isn't enough real data (66 answers). Fitting per topic is future work once the pilot runs.

**Q12. What exactly makes a topic "Mastered"?**
`MasteryRule`: P(L) ≥ 0.85 **and** at least 2 correct answers on level-3 questions in that topic. One definition is used everywhere. Evaluation 1 showed that P(L) alone made the badge almost always undeserved, because easy questions inflate P(L).

**Q13. How is the next question's level decided, and is the reason stored?**
The policy comes from `classes.difficulty_strategy` (default ADAPTIVE_RAMP). The ramp replays the student's topic history from `question_attempts`. The reason text is saved on the session when the question is served, and copied onto the attempt when it's answered. Every logged answer therefore says why it was asked.

**Q14. How does the 50:50 change the maths?**
A `FIFTY_FIFTY` row in `session_hint_events` makes `recordAttempt` use a guess probability of 0.5 instead of 0.25. A correct answer then raises P(L) less, because it is weaker evidence.

**Q15. Can a teacher see another teacher's students?**
No. `ClassService.visibleStudentProfileIds` limits analytics to students enrolled in that teacher's classes, and `requireTeacherCanSeeStudent` returns 403 otherwise. Integration tests cover this.

**Q16. Can a parent see any child?**
Only children linked in `parent_student_links`. Creating a link needs no approval yet (weak spot 8).

**Q17. Which indexes exist and why?**
- `question_attempts(student_id)`: dashboards, ramp replay.
- `questions(topic, difficulty)` and `(status, topic)`: picking the next question.
- `topic_progress(student_id, topic)` UNIQUE: one row per pair, and the lookup on every answer.
- `class_enrollments(student_profile_id)`: the strategy lookup on every question.
- `classes(join_code)` UNIQUE.
- `session_hint_events(session_id, question_id)`.

**Q18. What happens when a student is deleted?**
- **Cascades:** the foreign keys delete their profile, progress, sessions, attempts, enrollments and links (`ON DELETE CASCADE`).
- **SET NULL:** questions the user generated keep existing with `created_by_user_id` = NULL, and attempts keep existing with `session_id` = NULL if only the session is deleted.

**Q19. How do schema changes reach production?**
Flyway. Each change is a new numbered SQL file (V1–V14). On start-up the app applies any that haven't run and records them in `flyway_schema_history`. Hibernate only validates. The same files build the test database (Testcontainers), the local Docker database and Neon.

**Q20. How is AI-generated content kept out of students' quizzes until checked?**
It is saved with `status = PENDING` and `source = LLM`, with provenance (model, prompt version, who asked). Every student query filters `status = APPROVED`, and only a teacher action sets APPROVED.

**Q21. How big will `question_attempts` get, and is that a problem?**
A class of 40 doing 30 questions a day for a year gives about 440k rows. That is small for PostgreSQL. The hot queries are by `student_id`, which is indexed. Partitioning by month would be the step after that.

**Q22. Why is `response_time_ms` collected if nothing uses it?**
Be honest (weak spot 4). It is the planned signal for telling a lapse from not knowing. Evaluation 2 shows why that matters. Using it in decisions needs real data first.

**Q23. Is any personal or sensitive data stored?**
Name, email and a BCrypt hash, plus learning events. There are no behavioural labels or diagnoses (the ADHD screening was removed). Response time is stored as a learning event, not used to label anyone. Passwords and secrets are never in the database or Git.

**Q24. Why don't the numbers on the student, teacher and parent screens disagree?**
Since PR #7 they all compute totals from the same source (`topic_progress` sums), and P(L) as the same mean of topic P(L)s. Before that, some used attempt rows and some used counters, and the demo data made them differ.

**Q25. Show me one answer in the database.**

```sql
select a.id, q.topic, a.difficulty_served, a.selected_option, q.correct_answer, a.correct,
       a.response_time_ms, a.hints_used, a.difficulty_strategy, a.adaptive_reason
from question_attempts a join questions q on q.id = a.question_id
order by a.id desc limit 5;
```

**Q26. Show how P(L) and mastery look for one student.**

```sql
select tp.topic, tp.attempts, tp.correct_count, tp.p_know,
       (select count(*) from question_attempts a join questions q on q.id = a.question_id
         where a.student_id = tp.student_id and q.topic = tp.topic and a.correct and q.difficulty = 3) as hard_correct
from topic_progress tp
where tp.student_id = (select sp.id from student_profiles sp join users u on u.id = sp.user_id
                       where u.email = 'bruce@neurolearn.com')
order by tp.topic;
```

Mastered = `p_know >= 0.85 and hard_correct >= 2`.

On the local data, Bruce has P(L) ≥ 0.85 in four topics (intro 0.96, elimination 0.91, graphing 0.89, substitution 0.85), but **none is Mastered**: he has no correct level-3 answers there. This is the mastery rule doing its job, and a good live demo.
