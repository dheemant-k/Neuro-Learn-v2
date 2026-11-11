# Deployment

Two ways to run NeuroLearn outside a dev setup: the whole stack on one machine with Docker Compose,
or a free-tier cloud setup (Vercel + Render + Neon).

## 1. One machine: Docker Compose

```bash
cp .env.example .env          # then set JWT_SECRET (openssl rand -base64 48)
docker compose up -d --build  # → http://localhost:3000
```

| Container | Image | What it does |
|---|---|---|
| `postgres` | `postgres:16-alpine` | Data in the `postgres_data` volume; also on `localhost:5433` for dev tools |
| `backend` | `backend-java/Dockerfile` (Maven → JRE 17, non-root) | Spring Boot API, `prod` profile; Flyway migrates on start; health check `/api/health` |
| `frontend` | `Frontend/Dockerfile` (Vite build → nginx) | Serves the app and proxies `/api/` to the backend (same origin, so no CORS setup) |

- The backend refuses to start without a JWT secret of 32+ bytes.
- Postgres applies `DB_*` only when its volume is first created. Reusing the local dev volume means
  keeping `neurolearn` / `neurolearn`.
- For real Gemini generation set `AI_PROVIDER=gemini` and `GEMINI_API_KEY` in `.env` (never commit it).
- Stop with `docker compose down` (add `-v` to also delete the database).
- Dev workflow is unchanged: `docker compose up -d postgres`, then run backend and frontend yourself.

## 2. Cloud: Vercel + Render + Neon

Vercel serves static sites and short serverless functions. It cannot run the always-on JVM or host
Postgres, so each piece goes where it fits:

| Piece | Host | Setup |
|---|---|---|
| Database | **Neon** (or Supabase / Render Postgres) | Create a Postgres 16 database; copy the *pooled* connection details |
| API | **Render** web service, runtime *Docker* | Root directory `backend-java` (uses its Dockerfile); health check path `/api/health` |
| Web app | **Vercel** | Root directory `Frontend`, framework *Vite* (build `npm run build`, output `dist`) |

### Render (API) environment

| Variable | Value |
|---|---|
| `SPRING_DATASOURCE_URL` | `jdbc:postgresql://<neon-host>/<db>?sslmode=require` (replaces `DB_HOST/PORT/NAME`) |
| `DB_USER`, `DB_PASSWORD` | from Neon |
| `DB_POOL_SIZE` | `5` (free-tier connection limits) |
| `JWT_SECRET` | 32+ random characters |
| `CORS_ALLOWED_ORIGINS` | `https://<your-app>.vercel.app` |
| `AI_PROVIDER` / `GEMINI_API_KEY` | optional, as above |

`PORT` is set by Render and picked up automatically. `SPRING_PROFILES_ACTIVE=prod` is already set
in the image.

### Vercel (web app) environment

| Variable | Value |
|---|---|
| `VITE_API_BASE` | `https://<your-api>.onrender.com/api` (baked in at build time; redeploy after changing) |

### Before sharing the URL

- **Demo accounts.** Migration V5 seeds `bruce@`, `teacher@` and `parent@neurolearn.com` with the
  public password `password123`. Change or delete them in the production database first.
- **Cold starts.** Render's free tier sleeps after ~15 min idle (first request takes 30–60 s), and
  Neon's free compute also scales to zero. Open the app a minute before a demo.
- **Gemini key.** Set it only in Render's environment, never in the repo or Vercel; the browser
  never needs it.
