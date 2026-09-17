-- CFO CoWork Demo — 00 prereqs (COLD START)
-- Run this FIRST in a brand-new Snowflake account, before 00_setup.sql.
-- It obviates the hidden assumptions the rest of the demo makes: that Snowflake
-- Intelligence (CoWork) is already bootstrapped, that Cortex models resolve in
-- the account's region, and that the querying role can call Cortex.
-- Safe to re-run — every statement is idempotent. Requires ACCOUNTADMIN.

USE ROLE ACCOUNTADMIN;

-- 1) Cross-region inference ---------------------------------------------------
-- Lets Cortex Analyst / CoWork resolve orchestration + Analyst models even when
-- the account's home region does not host them. Enabled by default so the demo
-- is not fettered by where the account happens to live. Comment out if the
-- account has data-residency constraints that preclude cross-region calls.
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION';

-- 2) Cortex access ------------------------------------------------------------
-- CORTEX_USER is granted to PUBLIC by default in new accounts; re-granting is a
-- harmless no-op that guarantees the running role can invoke Cortex.
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE PUBLIC;

-- 3) Snowflake Intelligence bootstrap ----------------------------------------
-- The agent (05_agent.sql) lives in SNOWFLAKE_INTELLIGENCE.AGENTS. That schema
-- only exists once CoWork is bootstrapped, so a cold account must create it here
-- or 05 fails outright. CREATE ... IF NOT EXISTS leaves an already-enabled
-- account untouched. USAGE to PUBLIC closes the database-usage gap that would
-- otherwise stop a fresh role from seeing the agent in the CoWork UI.
--
-- SKIP this section if the account ALREADY has CoWork enabled: when
-- SNOWFLAKE_INTELLIGENCE already exists and is owned by another role (e.g.
-- SNOWFLAKE_INTELLIGENCE_ADMIN_RL), ACCOUNTADMIN may lack CREATE SCHEMA on it
-- and the CREATE SCHEMA below will error. In that case the schema is already
-- present, so just move on to 00_setup.sql.
CREATE DATABASE IF NOT EXISTS SNOWFLAKE_INTELLIGENCE
  COMMENT = 'Snowflake Intelligence (CoWork) home database';
CREATE SCHEMA IF NOT EXISTS SNOWFLAKE_INTELLIGENCE.AGENTS
  COMMENT = 'CoWork agents';

GRANT USAGE ON DATABASE SNOWFLAKE_INTELLIGENCE TO ROLE PUBLIC;
GRANT USAGE ON SCHEMA SNOWFLAKE_INTELLIGENCE.AGENTS TO ROLE PUBLIC;

-- 4) Default warehouse for CoWork (OPTIONAL) ----------------------------------
-- CoWork determines an agent's permissions from the querying user's DEFAULT
-- ROLE and requires a DEFAULT WAREHOUSE with USAGE — a session-level USE
-- WAREHOUSE does not suffice. If agent calls fail despite correct grants, set a
-- default warehouse on the user who will run the demo. 00_setup.sql creates
-- CFO_DEMO_WH; uncomment and set your login name below once it exists.
-- ALTER USER <your_login_name> SET DEFAULT_WAREHOUSE = CFO_DEMO_WH;
