# NeuroLearn: Presentation Prep

Everything for the final mock presentation in one file: what to say, what to show, how the code and
database work, why each choice was made, the hard questions, and a summary of every other markdown file
in the repo. Read sections 1–4 tonight; keep 9, 10 and 12 open tomorrow.

Detailed sources, if you need more: [PROJECT_GUIDE.md](PROJECT_GUIDE.md) (code and design),
[DATABASE_GUIDE.md](DATABASE_GUIDE.md) (every table and metric), [evaluation.md](evaluation.md) and
[evaluation_attention.md](evaluation_attention.md) (the two studies).

---

## 1. Running order (about 15 minutes)

| Time | Part | What to say or show |
|---|---|---|
| 0:00 | Pitch | §2: what it is, who it is for, the three things that make it more than CRUD |
| 1:30 | Story | §3: ADHD screening prototype → rejected for evidence and law → adaptive tutor → evaluation changed the engine |
| 3:00 | **Live demo** | §9: student quiz (adaptivity visible), boss fight, teacher dashboard and AI generation, parent report |
| 9:00 | Architecture | §4: layers, the core loop, the models (BKT, ramp, mastery rule) |
| 11:00 | Database | §5: 11 tables in 4 groups, event log vs running summary, show one real answer row |
| 12:30 | Evaluation | §7: the honest result and what it changed |
| 13:30 | Close | §8 limitations (say them first), §11 what's next |
| then | Questions | §10 |

---

## 2. The 60-second pitch

> NeuroLearn is a gamified, adaptive maths practice app for class 9–10 (linear and quadratic equations),
> designed to be friendly to students who struggle with attention and frustration. Students play a
> superhero roadmap as Batman, Superman or Supergirl. After every answer the server grades it, updates
> an estimate of what the student knows using **Bayesian Knowledge Tracing**, and picks the next
> question's difficulty with an **adaptive ramp**. Teachers run classes, see where the class gets stuck,
> and generate new questions with an **AI pipeline that checks its own answers and needs teacher
> approval**. Parents get a report card.

What makes it more than a CRUD app:
1. **A real student model** running on every answer (BKT, with our own 50:50-hint adjustment).
2. **An evaluation harness**: a simulator of 5,000 students comparing 7 difficulty policies. It showed
   our original engine lost to a simple fixed sequence, so we replaced it with the adaptive ramp and made
   "Mastered" stricter. **The evaluation changed the product.**
3. **A safe AI pipeline**: generate → validate in code → independent re-solve → teacher review.

---

## 3. The story (why it looks the way it does)

| Stage | What | Why it changed |
|---|---|---|
| Prototype (`legacy-python/`) | Flask app, webcam eye-tracking, LSTM "attention" model, aimed at **ADHD pre-screening** | Response-time and attention patterns are **not specific to ADHD** for one child; India's **DPDP Act** forbids behavioural monitoring of children; the LSTM had no real training data; labelling a child can harm |
| Rewrite | Spring Boot + React + PostgreSQL, BKT, gamified roadmap | Maintainable, testable, explainable instead of an unvalidated black box |
| Evaluation 1 | Simulation of difficulty policies | Original BKT engine **lost** to a fixed ramp → adaptive ramp became the default; "Mastered" now needs hard-question evidence |
| AI, classes, deployment | Gemini question pipeline, per-class strategy, Docker, Vercel + Render + Neon | Content scale, a pilot-ready comparison, a live demo |
| Evaluation 2 | Inattentive learners (attention lapses) | Showed the next problem to solve: tell a lapse from a knowledge gap (response time is already logged) |

**How to say the ADHD part:** "NeuroLearn is ADHD-*friendly* by design: short sessions, instant feedback,
game rewards, fewer too-hard questions. It is deliberately **not** a screening tool, and we removed that
idea for evidence, legal and ethical reasons." Don't demo "calm mode": it exists only as CSS, with no
button.

---

## 4. How it works

### 4.1 Architecture

```
Browser (React 19 + Vite + Tailwind)
   │  JSON over HTTPS, "Authorization: Bearer <JWT>"
   ▼
Spring Boot 3.4 API (Java 17)
   JwtAuthenticationFilter → Controllers → Services → Repositories (Spring Data JPA)
                                      ├─ adaptive/  BKT engine, DifficultyRamp
                                      ├─ MasteryRule
                                      └─ ai/  LlmClient (Gemini or offline Fake) — teachers only
   ▼
PostgreSQL 16 (Neon in the cloud), schema by Flyway V1–V16
```

- **Layered architecture:** controller (HTTP) → service (business rules) → repository (data). Each layer
  only talks to the one below.
- Backend: 106 Java files. 10 controllers, 11 services, 15 entities, 11 repositories, plus `adaptive/`,
  `ai/`, `security/`, `exception/` and the offline `evaluation/` package.
- Frontend: 8 pages (Home, Auth, Roadmap, Learn, Test (quiz), Feedback, BossFight, Dashboard with
  student/teacher/parent views), 5 components, one `api.js` fetch wrapper.

### 4.2 The core loop: one answer

1. **Quiz opens:** `POST /api/sessions/start` creates a `learning_sessions` row.
2. **Next question:** `GET /api/sessions/{id}/next-question?topic=…&characterTheme=…`
   - checks the session belongs to the caller (403 otherwise);
   - reads P(L) for the topic from `topic_progress`;
   - finds the class strategy (`ADAPTIVE_RAMP` by default);
   - **replays the student's whole history in the topic** through `DifficultyRamp` to get the level;
   - `pickQuestion`: an approved, unseen question at that level, from the student's hero, then the sister
     hero (Supergirl ↔ Superman), then any hero. If the level runs out it moves to the **nearest** level,
     easier first (1 → 2, never 1 → 3);
   - stores *why* it was chosen on the session;
   - returns the question **without the answer**.
3. **Answer:** `POST /api/sessions/{id}/attempt` runs as one transaction:
   - grades on the server;
   - logs the attempt (option, response time, hints, level, strategy, reason);
   - awards XP (+15 / +5);
   - BKT update of P(L);
   - checks the mastery rule.
4. **Finish:** `POST /api/sessions/{id}/complete` stores the session totals.

### 4.3 The models

**Bayesian Knowledge Tracing** (Corbett & Anderson 1995), `AdaptiveEngineService`. Each topic is a skill
the student either knows or doesn't; P(L) is the probability they know it. Its parameters:

| Parameter | Meaning | Value |
|---|---|---|
| P(L₀) | starting probability the student knows the topic | 0.20 |
| P(T) | chance of learning it on each question | 0.18 |
| P(G) | chance of guessing right without knowing it | 0.25 (0.50 after a 50:50) |
| P(S) | chance of a slip: answering wrong while knowing it | 0.10 |

```
correct:  post = P·(1−S) / [P·(1−S) + (1−P)·G]
wrong:    post = P·S     / [P·S + (1−P)·(1−G)]
then:     P_new = post + (1 − post)·T
```

Worked example from a fresh topic: three correct answers take P(L) 0.20 → **0.57** → 0.86 → 0.96. One
wrong answer from 0.20 gives 0.21. Our own extension: after a 50:50, a correct answer is weaker evidence,
so G becomes 0.5.

**Adaptive ramp** (`DifficultyRamp`, the default policy):
- 5 questions per level;
- **3 right in a row → up a level**;
- **2 wrong in a row → restart the count** at this level;
- **3 wrong in a row → down a level**;
- every decision has a reason sentence, which is shown to the student and logged.

The same class runs in the app and in the simulator, so what was evaluated is exactly what runs. Other
strategies a teacher can pick per class: `FIXED_RAMP` (5 per level, ignores answers) and `BKT_THRESHOLDS`
(the original engine: P(L) < 0.40 → level 1, < 0.75 → level 2, else level 3).

**Mastery rule** (`MasteryRule`): "Mastered" = P(L) ≥ 0.85 **and** 2 correct level-3 answers in that
topic. One definition everywhere (roadmap, dashboards, teacher roster, parent report). Why: BKT ignores
difficulty, so easy wins inflated it; in simulation the old badge was right **0%** of the time.

**Progress rules** (`ProgressService`):
- A section is **completed** after at least 3 answers, with P(L) ≥ 0.50 or 3 correct. That unlocks the
  next section.
- The **boss** unlocks after 3 completed sections.
- A **boss win** (checked on the server against that session's graded answers) is at least 4 correct and
  fewer than 3 wrong. It pays +100 XP, once per session.

### 4.4 AI question generation (teachers only)

1. The teacher picks topic, level, hero and count (limit: 40 a day per teacher).
2. **Gemini generates** (temperature 0.8) to a strict JSON schema; every wrong option must name the
   student mistake behind it.
3. **Code validates:** 4 distinct options, one key, LaTeX converted to plain text, no duplicates.
4. **Independent re-solve** (temperature 0.0): the question is kept only if the solver agrees.
5. Saved as **PENDING** with provenance (model, prompt version, who asked). Students only ever see
   **APPROVED**. The teacher reviews, edits, approves or rejects.

**No student data is sent to the model.**

---

## 5. The database in one page

**11 tables in 4 groups** (plus Flyway's own history table). Schema only by Flyway migrations V1–V16;
Hibernate only *validates*.

| Group | Table | One row is | Written when | Read by |
|---|---|---|---|---|
| People | `users` | a login (STUDENT/TEACHER/PARENT), BCrypt hash | sign-up | every request (JWT → user) |
| People | `student_profiles` | XP, level for one student | sign-up, every answer, boss win | dashboards, roster |
| Content | `questions` | one MCQ: topic, level 1–3, hero theme, status, source, provenance | seed migrations, AI generator, teacher review | question picker, grader |
| Content | `question_misconceptions` | the mistake behind one wrong option | AI generator, seeds V13/V16 | teacher question bank |
| Learning | `learning_sessions` | one quiz sitting, plus "why this question" hand-off, boss bonus paid | start, each question, finish | attempt recording, ownership check |
| Learning | **`question_attempts`** | **one answer**: option, correct (server-graded), response time, hints, level, strategy, reason | each answer, never updated | ramp replay, mastery rule, recent history |
| Learning | `session_hint_events` | one 50:50 or clue | hint used | grading (50:50 → weaker evidence) |
| Learning | `topic_progress` | per student × topic: attempts, correct, **P(L)** | each answer (same transaction) | every dashboard, BKT prior |
| Org | `classes` | teacher's class, join code, **difficulty strategy** | create class, strategy dropdown | strategy lookup before every question |
| Org | `class_enrollments` | student in class | join by code | teacher sees own students only |
| Org | `parent_student_links` | parent may see child | parent links child | parent report |

**Key idea:** `question_attempts` is the **event log** (raw evidence). `topic_progress` is the
**running summary**, updated in the same transaction. Dashboards read the summary because it's fast;
the ramp and mastery rule read the log because they need order and levels.

**Live demo query** (the mastery rule doing its job):

```sql
select tp.topic, tp.attempts, tp.correct_count, tp.p_know,
  (select count(*) from question_attempts a join questions q on q.id = a.question_id
   where a.student_id = tp.student_id and q.topic = tp.topic and a.correct and q.difficulty = 3) as hard_correct
from topic_progress tp
where tp.student_id = (select sp.id from student_profiles sp join users u on u.id = sp.user_id
                       where u.email = 'bruce@neurolearn.com')
order by tp.topic;
```

Bruce has P(L) 0.96 in intro but **no** correct level-3 answers, so he is not Mastered.

Open the database: `docker exec -it neurolearn-postgres psql -U neurolearn -d neurolearn`, then `\dt`,
`\d question_attempts`. GUI (DBeaver/pgAdmin): localhost:5433, db and user `neurolearn`.

**Question bank:** 254 approved questions (Batman 74, Superman 75, Supergirl 105). The quiz page shuffles
the options. Every Chapter 2 section has questions at all 3 levels for every hero, and every section has
at least 2 level-3 questions; a test guards both. All 254 answers were checked (equations solved with
sympy where they could be parsed, the rest by hand).

---

## 6. Metrics: stored vs computed

- **Stored (in the database):**
  - correct, selected option, response time, hints used, level served;
  - adaptive action, reason and strategy per answer;
  - XP and level;
  - per-topic attempts, correct and P(L);
  - session accuracy.
- **Computed when a screen loads:**
  - topic and overall accuracy (sums of `topic_progress`);
  - overall P(L) (mean of the topic P(L)s);
  - Mastered;
  - section completed, unlocked, boss unlocked;
  - next level;
  - predicted next-correct = P(L)·0.9 + (1−P(L))·0.25;
  - teacher student status (Mastered / On Track ≥ 0.60 / Needs Attention, plus "N/M topics mastered");
  - topic bottleneck (someone < 0.60 and (class average < 0.65 or strugglers ≥ masters));
  - class averages.
- **Simulation only (not in the database):**
  - mastered by question 10 / 20 / 30;
  - median questions to mastery;
  - too-hard share;
  - claim precision;
  - quit rate.

All three dashboards (student, teacher, parent) compute totals from the same source, so their numbers
agree.

---

## 7. The evaluations (the honest result)

Simulation: 5,000 students, 30 questions, 7 policies. Training and test populations are separate, and
every policy sees the same students and random draws. **Not real students.**

**Evaluation 1** (attentive students, 6 scenarios):

| Finding | Number |
|---|---|
| Original BKT engine vs fixed ramp, mastered by Q30 | 61.2% vs **73.4%** |
| Old "Mastered" claim | median question 5; true **0.0%** of the time |
| Adaptive ramp beats the original engine | **6 of 6** scenarios |
| Adaptive ramp vs fixed ramp, weak starters | **45.2%** vs 40.7% |
| Frustration scenario: quit / mastered | adaptive **44.0% / 44.3%** vs fixed 52.8% / 42.3% |
| Too-hard questions (baseline) | **25.3%** vs 38.3% |

**Evaluation 2** (attention lapses rising 10% → 39% over a session):

| Finding | Number |
|---|---|
| Mastered by Q30 | fixed 52.1% vs adaptive 35.0% |
| Too-hard questions | adaptive **27.7%** vs fixed 50.0% |
| With quitting: quit rate | adaptive **59.0%** vs fixed 68.0% |
| Why | lapse misses hold the ramp at easier levels (2.46 vs 3.00 at Q30) |

**One-line story:** "For the average student a good fixed sequence is as good as adaptivity. Adaptivity
pays off for the students a fixed sequence loses: weak starters and students who give up. For
inattentive students the system must learn to tell a lapse from a gap, and we already log the signal for
that."

---

## 8. Honest limitations (say these before you're asked)

1. The evaluation is a **simulation**; there's no real-student study yet. A two-class pilot design is
   ready (one class per strategy).
2. BKT uses literature-default parameters; there's too little real data to fit them, but the fitter is
   built and tested.
3. BKT treats a topic as one skill and ignores item difficulty (mitigated by the mastery rule).
4. Response time is logged but not yet used in decisions.
5. Misconceptions are stored but shown only to teachers, not students yet.
6. Two legacy columns duplicate information: `topic_progress.mastery_score` and `student_profiles.p_know`.
7. Parents can link a child by email without an approval step. Production needs an invite code.
8. Free hosting sleeps: the first request after idle takes 30–60 s.

---

## 9. Demo script

**Before you start:**
- Docker Desktop running (and **not paused**).
- `docker compose up -d postgres`.
- Backend: `cd backend-java && ./mvnw spring-boot:run`.
- Frontend: `cd Frontend && npm run dev`, then open http://localhost:5173.
- Logins use password `password123`: `bruce@neurolearn.com` (student), `teacher@neurolearn.com`,
  `parent@neurolearn.com`.
- If demoing the deployed site instead, open it a minute early (cold start). Remember it only has the
  latest questions after the newest PR is merged and Render has redeployed.

1. **Home → Sign in as Bruce** (student). Pick **Supergirl**, open **Linear Equations**.
   - *Say:* roadmap sections unlock as you complete them; the coloured bar is the BKT knowledge estimate.
2. Open a section → **Adaptive Quest**. Answer two or three questions.
   - *Point at:* the level tier (🟢/🟡/🔴), "Knowledge estimate updated (+N%)", XP, the worked
     explanation after each answer.
   - *Say:* the answer never reaches the browser before you submit; grading is on the server.
   - Use **X-Ray 50:50** once. *Say:* the server picked which two options to remove, and a correct answer
     after a hint counts as weaker evidence in BKT.
   - Optional: show **Krypton Clue** and **Scratchpad**.
3. Finish the quiz → **Feedback** page (accuracy, XP).
4. **Dashboard** as the student: XP, level, per-section P(L), recent answers with response times.
5. **Logout → teacher.**
   - *Point at:* classes with join codes, the **difficulty strategy** dropdown (adaptive ramp / fixed /
     original), topic bottlenecks, the roster with status and "N/M topics mastered".
   - **Inspect** a student (Escape closes it).
6. **Question Bank tab:** pending AI drafts with provenance and each wrong option's misconception.
   Approve or reject one.
   - Generating live needs a Gemini key. Without one the app uses the offline fake provider, which is
     fine to show the pipeline.
7. **Logout → parent:** linked children → **Report Card**.
8. Optional, if time: back as a student, a **boss fight**. *Say:* the +100 bonus is paid only if the
   server sees a won fight in that session's graded answers.
9. Optional: **psql**, run the Bruce query from §5.

**If something breaks:**
- API not responding: check Docker isn't paused, then restart the backend.
- Port 8080 busy: an old backend is still running; stop it.
- Blank roadmap: hard-refresh the page.
- Have the Data Map page and DATABASE_GUIDE open as a backup.

---

## 10. Question drill

**Project and scope**
- *Is this an ADHD detection tool?* No. It started as one; we removed screening because behavioural
  signals aren't specific to ADHD for an individual, the DPDP Act restricts behavioural monitoring of
  children, and labelling harms. It's ADHD-friendly by design.
- *Your evaluation says a fixed sequence is as good. Why build this?* For the average student, yes.
  Adaptivity helps the students a fixed sequence loses (weak starters 45.2% vs 40.7%; quitting 44.0% vs
  52.8%). And the evaluation caught a broken "Mastered" badge (0% correct) that we fixed. Being able to
  measure and improve is the point.
- *What's novel?*
  - The 50:50-aware BKT update.
  - One shared ramp class for app and simulator.
  - Per-class strategy for pilots.
  - The two-layer AI check with teacher approval.
  - An evaluation that changed the product.

**Models**
- *Why BKT, not deep learning?* There's no training data (DKT needs tens of thousands of students), and
  BKT is explainable, works from the first answer and is standard. The prototype had an LSTM; it couldn't
  be trained or explained.
- *Where do the parameters come from?* Literature defaults. The fitter recovers known parameters within
  ±0.02, and real fitting waits for pilot data.
- *Why does a wrong answer barely lower P(L) at the start?* At 0.20 a wrong answer is expected, and the
  learning term adds 18% of the remainder.
- *How is the next level chosen?* The class strategy plus a replay of the topic history through the ramp
  (5 per level, 3 right → up, 2 wrong → slow down, 3 wrong → down).
- *What if there are no questions at that level?*
  1. Same level: sister hero, then any hero.
  2. Nearest level, easier first.
  3. Repeats only when everything has been seen.
- *What exactly is Mastered?* P(L) ≥ 0.85 and 2 correct level-3 answers in that topic.

**Database**
- *Why PostgreSQL, not MongoDB?* The data is relational (16 foreign keys); analytics need joins and
  aggregates; one answer updates three tables in one ACID transaction. Constraints (UNIQUE, CHECK) live in
  the database.
- *Why both `question_attempts` and `topic_progress`?* BKT is sequential, so the state must be stored;
  recomputing it every request would cost O(history). The log stays for the ramp, the mastery rule,
  audits and the pilot.
- *What if the server crashes mid-answer?* `@Transactional`: everything rolls back.
- *How do schema changes reach production?* Flyway migrations V1–V16 run on start-up; the same files
  build test, Docker and Neon.
- *What happens when a student is deleted?* The foreign keys cascade to their profile, progress, sessions
  and attempts; questions they generated keep `created_by_user_id = NULL`.
- *Indexes?*
  - `question_attempts(student_id)`;
  - `questions(topic, difficulty)` and `(status, topic)`;
  - unique `topic_progress(student_id, topic)`;
  - `class_enrollments(student_profile_id)`.

**Security**
- *Can a student cheat?* The answer isn't sent before submitting; grading is on the server; sessions have
  ownership checks; hints are logged and refused after answering; the boss bonus is verified against
  graded answers and paid once per session.
- *Auth?*
  - BCrypt passwords.
  - Stateless JWT (HS256, 24 h; the server refuses to start with a short secret).
  - Deny-by-default role rules, plus ownership checks in services.
- *Stolen token?* It's valid until expiry. That's the stateless trade-off; mitigations are short expiry,
  HTTPS and a blacklist if needed.
- *What goes to Gemini?* Only curriculum content, never student data. Generated questions stay PENDING
  until a teacher approves.

**Engineering**
- *Testing?*
  - 152 backend tests: unit tests for BKT, ramp, rules and parsing, plus integration tests on a real
    PostgreSQL via Testcontainers for authorization, grading, mastery, classes, AI and the question bank.
  - Frontend: ESLint with zero warnings, plus a production build.
  - CI on every PR, including Docker builds.
- *How would it scale?* The API is stateless, so add instances behind a load balancer. For the database:
  indexes on hot paths, a connection pooler, and read replicas for analytics.
- *What's next?*
  - Run the pilot.
  - Fit BKT per topic.
  - A lapse-aware ramp using response time.
  - Show misconceptions to students.
  - IRT item calibration.

---

## 11. Numbers cheat sheet

| What | Value |
|---|---|
| Tables / foreign keys / migrations | 11 / 16 / V1–V16 |
| Approved questions | 254 (Batman 74, Superman 75, Supergirl 105) |
| Misconception rows on approved questions | 375 |
| Sections | 12 (6 linear, 6 quadratic) + 2 bosses |
| BKT | P(L₀) 0.20, P(T) 0.18, P(G) 0.25 (0.5 after 50:50), P(S) 0.10 |
| Mastered | P(L) ≥ 0.85 and 2 correct level-3 answers |
| Section complete | ≥ 3 answers and (P(L) ≥ 0.50 or 3 correct) |
| Boss | unlocks after 3 sections; win = ≥ 4 correct, < 3 wrong; +100 XP once per session |
| XP | +15 correct, +5 wrong; level = XP / 100 + 1 |
| AI limit | 40 generated questions per teacher per day |
| Backend tests | 152, all passing |
| Simulation | 5,000 students, 30 questions, 7 policies, 6 + 4 scenarios |

---

## 12. Every markdown file, summarised

| File | What it is | Use it for |
|---|---|---|
| `README.md` | The original proposal and full vision: problem, objectives, learning loop, planned dashboards, stack, scope and out-of-scope list (no ADHD diagnosis, no webcam), 100-hour plan, success criteria, BKT maths and citations. An "As built" note at §4 marks where the code differs from the proposal. | Requirements and scope questions; the citations |
| `docs/PROJECT_GUIDE.md` | The design defence: pitch, history, architecture, request flows, models, research basis, evaluation summary, design-decision table, security, testing, limitations, viva questions, 5-minute demo | The main reference for "explain the codebase" |
| `docs/DATABASE_GUIDE.md` | Every table and column, who writes and reads it and when, one answer traced end to end, every metric with its formula, real local data, weak spots with answers (most now fixed), 26 database questions and runnable SQL | "Explain the database" and metrics questions |
| `docs/evaluation.md` | Evaluation 1: 7 policies on attentive simulated students, 6 scenarios, train/test split, results, BKT fitting, recommendations, threats to validity, pilot design | The evaluation numbers and method |
| `docs/evaluation_attention.md` | Evaluation 2: same set-up with fatigue-driven attention lapses; fixed ramp masters more, adaptive ramp is gentler and keeps more students; points to response time | The ADHD-angle research question |
| `docs/deployment.md` | Docker Compose for one machine; Vercel (web) + Render (API) + Neon (Postgres) for the cloud; env vars; resetting demo passwords; cold starts | Deployment questions |
| `docs/AI_FUTURE_SCOPE.md` | Review of the AI options (Nov 2026): fix data first, server-side grading, teacher-reviewed generation, guarded hints, fit BKT before deep models, **decision: no per-child ADHD flag** (science + DPDP + ethics) | Why the AI is shaped this way; the ADHD decision |
| `FUTURE_WORKFLOW.md` | The phase plan (0–9): what was found broken (all endpoints public, no tests, no deployment), what was fixed in each phase, what remains (session status, pacing insights, curriculum in DB, research track) | "What did you build when" and future work |
| `Frontend/README.md` | How to run, lint and build the frontend; folder layout; demo accounts | Running the UI |
| `docs/history/neurolearn_migration_plan.md` | The plan to move from the Python/Flask attention prototype to Spring Boot + PostgreSQL | Showing the pivot was planned |
| `docs/history/COMMIT_HISTORY_AND_WORK_DONE.md` | Snapshot of work up to Chapter 2 (older; some numbers outdated, e.g. P(T)) | History only |
| `docs/history/future_scope.md` | October 2026 honest inventory and roadmap (says one chapter; outdated) | History only |
| `docs/history/research_and_aiml_scope.md` | Research and AI/ML ideas. **Some statistics in it could not be verified; don't quote them.** | History only |
| `docs/history/next_steps_plan.md` | The cancelled "engagement flag" plan (Phases A–D) | Shows what was rejected and why |
| `docs/history/implementation_plan.md` | Plan for teacher analytics and parent linking | History only |
| `docs/history/task.md`, `walkthrough.md` | Early task list and the roadmap/boss-fight walkthrough | History only |

---

## 13. Checklist

**Tonight**
- [ ] Merge the latest PR (adds the Chapter 2 questions, V16) so the deployed site matches; open the site
      once afterwards so Render redeploys and runs V12–V16 on Neon.
- [ ] Rehearse §2 aloud twice (under 90 seconds).
- [ ] Do the §9 demo once end to end, with timing.
- [ ] Read §8 and §10.

**30 minutes before**
- [ ] Docker Desktop running, not paused; `docker compose up -d postgres`.
- [ ] Backend and frontend started; log in as Bruce once.
- [ ] Deployed site opened once (wakes Render and Neon).
- [ ] Tabs ready: app, teacher login, psql or DBeaver, this file, the Data Map page.
