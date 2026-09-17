-- CFO CoWork Demo — 05 agent
-- Creates the Snowflake Intelligence / CoWork agent over the CFO semantic view.
-- Requires the SNOWFLAKE_INTELLIGENCE.AGENTS schema (present by default when
-- Snowflake Intelligence is enabled). Run as a role that can create agents.

CREATE OR REPLACE AGENT SNOWFLAKE_INTELLIGENCE.AGENTS.ALDWYCH_CFO_AGENT
WITH PROFILE='{"display_name":"Aldwych CFO Agent"}'
COMMENT='CFO demo agent over the Aldwych synthetic CFO semantic view'
FROM SPECIFICATION $$
{
  "models": { "orchestration": "auto" },
  "instructions": {
    "response": "You are a finance analyst for the Aldwych Bank CFO. Answer in concise, financial terms (GBP). Prefer the CFO_SEMANTIC semantic view. Distinguish deterministic from probabilistic exposure. Never assert figures not backed by the data.",
    "orchestration": "Use the Cortex Analyst tool for any quantitative question about provisions, forecasts, scenarios, exposure, capital, or process cost."
  },
  "tools": [
    { "tool_spec": { "type": "cortex_analyst_text_to_sql", "name": "cfo_analyst" } }
  ],
  "tool_resources": {
    "cfo_analyst": { "semantic_view": "CFO_DEMO.ALDWYCH.CFO_SEMANTIC" }
  }
}
$$;

-- Open the agent in Snowsight: AI & ML » Snowflake Intelligence (CoWork),
-- select "Aldwych CFO Agent", and ask the demo questions in README.md.
