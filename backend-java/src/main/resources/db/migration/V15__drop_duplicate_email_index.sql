-- V15__drop_duplicate_email_index.sql
-- users.email is UNIQUE, and PostgreSQL already backs that constraint with an index
-- (users_email_key). idx_users_email (V1) indexed the same column a second time: it only
-- slowed down writes to users.
DROP INDEX IF EXISTS idx_users_email;
