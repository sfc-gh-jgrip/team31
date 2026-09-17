-- CFO CoWork Demo — 06 agent
-- Creates the Snowflake Intelligence / CoWork agent over the CFO semantic view.
-- IMPORTANT: tool_resources MUST include an execution_environment (warehouse),
-- otherwise the agent will not render/run in the CoWork UI.

CREATE OR REPLACE AGENT SNOWFLAKE_INTELLIGENCE.AGENTS.ALDWYCH_CFO_AGENT
WITH PROFILE='{"display_name":"Aldwych CFO Agent","color":"blue"}'
COMMENT='CFO demo agent over the Aldwych synthetic CFO semantic view (loan-level)'
FROM SPECIFICATION $$
{
  "models": { "orchestration": "auto" },
  "instructions": {
    "response": "You are a finance analyst for the Aldwych Bank CFO. Answer concisely in financial terms and always state GBP. Distinguish deterministic from probabilistic exposure. Support deep dives by sector, region, rating grade, vintage and loan status. Never assert figures not backed by the data.",
    "orchestration": "Use the cfo_analyst tool for any quantitative question about the SME book, provisions, forecasts, model-vs-manual scenario, regulatory exposure, capital, or process cost.",
    "system": "You are the Aldwych Bank CFO analyst. Data is synthetic and generated for demonstration. Express amounts in GBP and round large numbers readably (e.g. \u00a312.9M).",
    "sample_questions": [
      {"question": "Forecast SME credit-loss provisions for the next 4 quarters and show which segment and sector drive the increase"},
      {"question": "If we reinstate the automated credit model, compare MANUAL vs MODEL: provisions, manual cost, RWA and capital held"},
      {"question": "What is our probability-weighted regulatory exposure for quarter 2026-Q4, split into deterministic vs probabilistic?"},
      {"question": "Show total exposure and average PD by sector, highest risk first"},
      {"question": "Which regions and rating grades hold the most exposure in Default or Watch status?"},
      {"question": "Which risk models are offline and what are they costing us per year?"}
    ]
  },
  "tools": [
    { "tool_spec": { "type": "cortex_analyst_text_to_sql", "name": "cfo_analyst", "description": "Aldwych CFO finance/risk mart: 50k-loan SME book (sector, region, rating, vintage, status), monthly provisions + forecast, model-vs-manual scenario, regulatory obligations and exposure, capital and RWA, process effort." } }
  ],
  "tool_resources": {
    "cfo_analyst": { "execution_environment": { "type": "warehouse", "warehouse": "CFO_DEMO_WH" }, "semantic_view": "CFO_DEMO.ALDWYCH.CFO_SEMANTIC" }
  }
}
$$;

-- Make the agent + query path usable by the role you use in CoWork.
GRANT USAGE ON AGENT SNOWFLAKE_INTELLIGENCE.AGENTS.ALDWYCH_CFO_AGENT TO ROLE PUBLIC;
GRANT USAGE ON DATABASE CFO_DEMO TO ROLE PUBLIC;
GRANT USAGE ON SCHEMA CFO_DEMO.ALDWYCH TO ROLE PUBLIC;
GRANT SELECT ON ALL TABLES IN SCHEMA CFO_DEMO.ALDWYCH TO ROLE PUBLIC;
GRANT SELECT ON SEMANTIC VIEW CFO_DEMO.ALDWYCH.CFO_SEMANTIC TO ROLE PUBLIC;
GRANT USAGE ON WAREHOUSE CFO_DEMO_WH TO ROLE PUBLIC;

-- Open in Snowsight: AI & ML » Snowflake Intelligence (CoWork) » Aldwych CFO Agent.
