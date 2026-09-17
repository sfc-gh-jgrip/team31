-- CFO CoWork Demo — 99 teardown
-- Removes everything created by this demo. Irreversible.
DROP AGENT IF EXISTS SNOWFLAKE_INTELLIGENCE.AGENTS.ALDWYCH_CFO_AGENT;
DROP DATABASE IF EXISTS CFO_DEMO;
DROP WAREHOUSE IF EXISTS CFO_DEMO_WH;

-- Intentionally NOT dropped: the SNOWFLAKE_INTELLIGENCE database and its
-- AGENTS schema. They are shared CoWork infrastructure that other agents may
-- rely on; removing them could subvert unrelated demos. The cross-region
-- inference parameter set in 00_prereqs.sql is also left as-is.
