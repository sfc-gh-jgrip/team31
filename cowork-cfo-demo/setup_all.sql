-- ============================================================================
-- Aldwych CFO — Snowflake CoWork demo — CONCATENATED COLD-START SETUP
-- GENERATED FILE — do not edit by hand. Regenerate with ./build_setup_all.sh
-- after changing any numbered *.sql file.
--
-- HOW TO RUN (for someone standing up the demo in their own account):
--   Snowsight » Projects » Workspaces » add a SQL file, paste this in,
--   then Run All — signed in as (or able to use) ACCOUNTADMIN.
--   Or from the CLI:  snow sql -f setup_all.sql
--
-- Everything runs in ONE session, so the forecast step's CALL + RESULT_SCAN
-- stay bound together. Teardown is kept separate: run 99_teardown.sql.
--
-- If the account ALREADY has CoWork enabled, the SNOWFLAKE_INTELLIGENCE
-- bootstrap in the prereqs section may error on CREATE SCHEMA (the schema
-- already exists). That is expected — see the note in that section.
-- Generated: 2026-09-17T15:59:05Z
-- ============================================================================


-- ----------------------------------------------------------------------------
-- >>> BEGIN 00_prereqs.sql
-- ----------------------------------------------------------------------------
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

-- <<< END 00_prereqs.sql

-- ----------------------------------------------------------------------------
-- >>> BEGIN 00_setup.sql
-- ----------------------------------------------------------------------------
-- CFO CoWork Demo — 00 setup
-- Creates an isolated database/schema/warehouse for the Aldwych Bank CFO demo.
-- Safe to re-run.

CREATE WAREHOUSE IF NOT EXISTS CFO_DEMO_WH
  WITH WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE
  COMMENT = 'CFO CoWork demo warehouse';

CREATE DATABASE IF NOT EXISTS CFO_DEMO
  COMMENT = 'Aldwych Bank CFO CoWork demo (synthetic data)';

CREATE SCHEMA IF NOT EXISTS CFO_DEMO.ALDWYCH
  COMMENT = 'Synthetic Office-of-the-CFO demo mart';

USE WAREHOUSE CFO_DEMO_WH;
USE SCHEMA CFO_DEMO.ALDWYCH;

-- <<< END 00_setup.sql

-- ----------------------------------------------------------------------------
-- >>> BEGIN 01_dimensions.sql
-- ----------------------------------------------------------------------------
-- CFO CoWork Demo — 01 dimensions
-- Reference dimensions for the SME book. Safe to re-run.
USE SCHEMA CFO_DEMO.ALDWYCH;

CREATE OR REPLACE TABLE DIM_SEGMENT (segment_name STRING, segment_order INT) COMMENT='SME sub-segments';
INSERT INTO DIM_SEGMENT VALUES ('Micro',1),('Small',2),('Medium',3);

CREATE OR REPLACE TABLE DIM_DIVISION (division_name STRING, is_ringfenced BOOLEAN) COMMENT='Aldwych divisions';
INSERT INTO DIM_DIVISION VALUES ('Aldwych Retail',TRUE),('Aldwych Commercial',FALSE),('Aldwych Private',FALSE),('Aldwych Business',FALSE);

CREATE OR REPLACE TABLE DIM_SECTOR (sector_id INT, sector_name STRING, pd_multiplier NUMBER(4,2), COMMENT STRING) COMMENT='SME sectors';
INSERT INTO DIM_SECTOR VALUES
 (0,'Construction',1.45,'Cyclical, higher default'),(1,'Hospitality',1.60,'High volatility'),(2,'Manufacturing',1.05,'Stable'),
 (3,'Retail Trade',1.30,'Margin pressure'),(4,'Professional Services',0.75,'Low default'),(5,'Agriculture',1.15,'Seasonal'),
 (6,'Transport & Logistics',1.20,'Fuel-sensitive'),(7,'Healthcare',0.70,'Defensive');

CREATE OR REPLACE TABLE DIM_REGION (region_id INT, region_name STRING) COMMENT='UK regions';
INSERT INTO DIM_REGION VALUES
 (0,'North East'),(1,'North West'),(2,'Yorkshire & Humber'),(3,'East Midlands'),(4,'West Midlands'),
 (5,'East of England'),(6,'London'),(7,'South East'),(8,'South West'),(9,'Wales'),(10,'Scotland'),(11,'Northern Ireland');

CREATE OR REPLACE TABLE DIM_RATING_GRADE (grade INT, pd_mid NUMBER(6,4), risk_weight NUMBER(5,3)) COMMENT='Internal rating grades 1 (best) to 10 (default)';
INSERT INTO DIM_RATING_GRADE VALUES
 (1,0.0030,0.200),(2,0.0050,0.300),(3,0.0090,0.400),(4,0.0150,0.550),(5,0.0250,0.700),
 (6,0.0400,0.900),(7,0.0650,1.100),(8,0.1000,1.300),(9,0.1600,1.500),(10,0.2500,1.500);

-- <<< END 01_dimensions.sql

-- ----------------------------------------------------------------------------
-- >>> BEGIN 02_loanbook.sql
-- ----------------------------------------------------------------------------
-- CFO CoWork Demo — 02 loan book
-- Deterministic 50k-loan SME facility book, generated via hashing so it is
-- reproducible in any account. Risk metrics are computed bottom-up per loan.
-- ~£17B total book; a ~£350-400M slice flagged model_portfolio = the
-- FCA-suspended SME credit model's portfolio.
USE SCHEMA CFO_DEMO.ALDWYCH;

CREATE OR REPLACE TABLE FACT_LOAN AS
WITH g AS (SELECT SEQ4() AS n FROM TABLE(GENERATOR(ROWCOUNT => 50000))),
pick AS (
  SELECT
    'L'||LPAD(n::STRING,6,'0') AS loan_id, n,
    CASE WHEN MOD(ABS(HASH(n,10)),100) < 55 THEN 'Micro'
         WHEN MOD(ABS(HASH(n,10)),100) < 85 THEN 'Small' ELSE 'Medium' END AS segment_name,
    MOD(ABS(HASH(n,11)),8) AS sector_id, MOD(ABS(HASH(n,12)),12) AS region_id,
    1 + MOD(ABS(HASH(n,13)),10) AS grade, 2016 + MOD(ABS(HASH(n,14)),11) AS vintage_year,
    MOD(ABS(HASH(n,15)),1000) AS spread_h, MOD(ABS(HASH(n,16)),1000) AS status_h,
    MOD(ABS(HASH(n,17)),1000) AS model_h,
    CASE WHEN MOD(ABS(HASH(n,10)),100) < 55 THEN 25000
         WHEN MOD(ABS(HASH(n,10)),100) < 85 THEN 150000 ELSE 800000 END AS base_ead
  FROM g
),
j AS (
  SELECT p.*, s.sector_name, s.pd_multiplier, r.region_name, rg.pd_mid, rg.risk_weight,
    ROUND(p.base_ead * (0.4 + (p.spread_h/1000.0)*3.0), 2) AS ead_gbp,
    LEAST(0.30, ROUND(rg.pd_mid * s.pd_multiplier, 5)) AS pd, 0.450 AS lgd,
    (p.model_h < 20) AS model_portfolio
  FROM pick p JOIN DIM_SECTOR s ON p.sector_id=s.sector_id
  JOIN DIM_REGION r ON p.region_id=r.region_id JOIN DIM_RATING_GRADE rg ON p.grade=rg.grade
)
SELECT loan_id,
  CASE WHEN segment_name='Micro' THEN 'Aldwych Business' ELSE 'Aldwych Commercial' END AS division_name,
  segment_name, sector_name, region_name, grade AS rating_grade, vintage_year, ead_gbp, pd, lgd,
  CASE WHEN status_h/1000.0 < pd*2 THEN 'Default' WHEN status_h/1000.0 < pd*4 THEN 'Watch' ELSE 'Performing' END AS status,
  ROUND(0.040 + grade*0.004 + (pd_multiplier-1)*0.01, 4) AS interest_rate, model_portfolio,
  ROUND(ead_gbp * pd * 0.45 * (CASE WHEN model_portfolio THEN 1.12 ELSE 1.00 END), 2) AS provision_gbp,
  ROUND(ead_gbp * risk_weight, 2) AS rwa_gbp, ROUND(ead_gbp * risk_weight * 0.105, 2) AS capital_gbp
FROM j;

-- <<< END 02_loanbook.sql

-- ----------------------------------------------------------------------------
-- >>> BEGIN 03_derived.sql
-- ----------------------------------------------------------------------------
-- CFO CoWork Demo — 03 derived facts
-- Everything here rolls up bottom-up from FACT_LOAN, so headlines are computed
-- from the book (nothing hand-asserted). Plus the regulatory/effort facts.
USE SCHEMA CFO_DEMO.ALDWYCH;

-- Monthly provisions history (segment x sector x 48 months), derived from the
-- loan book's current annual EL, scaled to a MONTHLY flow (annual/12) with an
-- upward trend, seasonality, and deterministic noise. Latest month ~= book.
CREATE OR REPLACE TABLE FACT_PROVISIONS_MONTHLY AS
WITH base AS (
  SELECT segment_name, sector_name, SUM(provision_gbp) AS cur_annual_prov, SUM(ead_gbp) AS cur_ead
  FROM FACT_LOAN GROUP BY 1,2
),
months AS (SELECT SEQ4() AS i FROM TABLE(GENERATOR(ROWCOUNT => 48)))
SELECT
  LAST_DAY(DATEADD(month, m.i, DATE '2022-09-01')) AS month_end,
  b.segment_name, b.sector_name,
  b.segment_name || ' | ' || b.sector_name AS series_key,
  ROUND(b.cur_ead * (0.70 + 0.30*(m.i/47.0)), 2) AS exposure_gbp,
  GREATEST(0, ROUND((b.cur_annual_prov/12.0) * (0.70 + 0.30*(m.i/47.0)
      + 0.03*SIN(2*3.14159265*m.i/12)
      + (MOD(ABS(HASH(m.i, b.segment_name, b.sector_name)),100)-50)/2500.0), 2)) AS credit_loss_provision_gbp
FROM months m CROSS JOIN base b;

-- Model-on vs manual scenario, bottom-up from the flagged model portfolio.
-- MODEL: better PD precision (drop the 1.12 manual over-provision, -10% loss),
-- ~8% RWA relief; manual review cost falls from ~£4.2M to ~£0.3M.
CREATE OR REPLACE TABLE FACT_MODEL_SCENARIO AS
WITH mp AS (SELECT * FROM FACT_LOAN WHERE model_portfolio),
tot AS (SELECT SUM(ead_gbp) AS tot_ead FROM mp)
SELECT segment_name, 'MANUAL' AS scenario,
  ROUND(SUM(provision_gbp),2) AS annual_provision_gbp,
  ROUND(4200000 * SUM(ead_gbp)/(SELECT tot_ead FROM tot),2) AS annual_manual_cost_gbp,
  ROUND(SUM(rwa_gbp),2) AS rwa_gbp, ROUND(SUM(capital_gbp),2) AS capital_held_gbp
FROM mp GROUP BY segment_name
UNION ALL
SELECT segment_name, 'MODEL',
  ROUND(SUM(ead_gbp*pd*0.45*0.90),2),
  ROUND(300000 * SUM(ead_gbp)/(SELECT tot_ead FROM tot),2),
  ROUND(SUM(rwa_gbp*0.92),2), ROUND(SUM(rwa_gbp*0.92*0.105),2)
FROM mp GROUP BY segment_name;

-- Division capital context, rolled up from the book.
CREATE OR REPLACE TABLE DIM_CAPITAL_CONTEXT AS
SELECT division_name, ROUND(SUM(rwa_gbp),2) AS risk_weighted_assets_gbp,
  ROUND(SUM(capital_gbp),2) AS capital_held_gbp, ROUND(SUM(ead_gbp),2) AS sme_exposure_gbp
FROM FACT_LOAN GROUP BY division_name;

-- Risk model inventory.
CREATE OR REPLACE TABLE DIM_RISK_MODEL (
  model_id STRING, model_name STRING, status STRING, suspended_reason STRING,
  portfolio_exposure_gbp NUMBER(18,2), annual_manual_cost_gbp NUMBER(18,2)) COMMENT='Risk model inventory';
INSERT INTO DIM_RISK_MODEL
SELECT 'SME-CR-01','SME Credit Risk Scoring (ML)','SUSPENDED',
       'FCA notice - insufficient data lineage/provenance to evidence training data',
       (SELECT ROUND(SUM(ead_gbp),2) FROM FACT_LOAN WHERE model_portfolio), 4200000
UNION ALL SELECT 'IB-MKT-02','Investment Bank Market Risk VaR','ACTIVE',NULL,0,0
UNION ALL SELECT 'AML-TX-03','AML Transaction Monitoring (partner)','ACTIVE',NULL,0,0;

-- Regulatory obligations.
CREATE OR REPLACE TABLE FACT_REGULATORY_OBLIGATION (
  obligation_id STRING, regulation STRING, requirement STRING, deadline_date DATE, status STRING, remediation_pct NUMBER(5,2)) COMMENT='Regulatory obligations and deadlines';
INSERT INTO FACT_REGULATORY_OBLIGATION VALUES
 ('OBL-FCA-01','FCA Notice','Reinstate SME model with evidenced data lineage/provenance',DATE '2026-12-31','AT_RISK',35),
 ('OBL-BCBS-01','BCBS 239','Calculation/column-level lineage source-to-report (Principle 3)',DATE '2026-12-31','AT_RISK',40),
 ('OBL-PRA-01','PRA SS1/23','Model data provenance for model risk management',DATE '2026-12-31','AT_RISK',30);

-- Consequence streams if deadlines are missed.
CREATE OR REPLACE TABLE FACT_EXPOSURE_COMPONENT (
  component_id STRING, obligation_id STRING, component_type STRING, amount_low_gbp NUMBER(18,2), amount_high_gbp NUMBER(18,2),
  amount_expected_gbp NUMBER(18,2), probability NUMBER(4,3), timing_quarter STRING, is_deterministic BOOLEAN) COMMENT='Regulatory exposure components';
INSERT INTO FACT_EXPOSURE_COMPONENT VALUES
 ('EC-01','OBL-FCA-01','PENALTY',35000000,55000000,45000000,0.600,'2026-Q4',FALSE),
 ('EC-02','OBL-BCBS-01','CAPITAL_ADDON',5000000,10000000,6700000,0.700,'2026-Q4',FALSE),
 ('EC-03','OBL-FCA-01','OPERATIONAL_COST',4000000,4400000,4200000,1.000,'2026-Q4',TRUE),
 ('EC-04','OBL-FCA-01','PNL_DRAG',2500000,4500000,3500000,0.800,'2026-Q4',FALSE);

-- Operational effort / productivity drag.
CREATE OR REPLACE TABLE FACT_PROCESS_EFFORT (
  process_name STRING, fte_count NUMBER(6,1), cycle_time_weeks NUMBER(4,1), annual_cost_gbp NUMBER(18,2), pct_team_maintenance NUMBER(5,2)) COMMENT='Operational effort';
INSERT INTO FACT_PROCESS_EFFORT VALUES
 ('Monthly Regulatory Reporting',22.0,3.0,2800000,55.0),
 ('SME Manual Credit Review',30.0,NULL,4200000,NULL);

-- <<< END 03_derived.sql

-- ----------------------------------------------------------------------------
-- >>> BEGIN 04_forecast.sql
-- ----------------------------------------------------------------------------
-- CFO CoWork Demo — 04 forecast
-- Forecasts monthly SME provisions for the next 12 months across all 24
-- (segment x sector) series with Snowflake native ML.FORECAST.
USE SCHEMA CFO_DEMO.ALDWYCH;

CREATE OR REPLACE VIEW V_PROVISIONS_TRAIN AS
SELECT series_key, DATE_TRUNC('month', month_end)::TIMESTAMP_NTZ AS month_ts, credit_loss_provision_gbp
FROM FACT_PROVISIONS_MONTHLY;

CREATE OR REPLACE SNOWFLAKE.ML.FORECAST CFO_PROVISION_FORECAST(
  INPUT_DATA        => SYSTEM$REFERENCE('VIEW','CFO_DEMO.ALDWYCH.V_PROVISIONS_TRAIN'),
  SERIES_COLNAME    => 'SERIES_KEY',
  TIMESTAMP_COLNAME => 'MONTH_TS',
  TARGET_COLNAME    => 'CREDIT_LOSS_PROVISION_GBP'
);

-- Keep the CALL and the RESULT_SCAN capture in the SAME session.
CALL CFO_PROVISION_FORECAST!FORECAST(FORECASTING_PERIODS => 12);

CREATE OR REPLACE TABLE FACT_PROVISIONS_FORECAST AS
SELECT
  TRIM(SPLIT_PART(SERIES,'|',1)) AS segment_name,
  TRIM(SPLIT_PART(SERIES,'|',2)) AS sector_name,
  TS::DATE                        AS month_end,
  ROUND(FORECAST,2)               AS forecast_provision_gbp,
  ROUND(GREATEST(LOWER_BOUND,0),2) AS lower_bound_gbp,
  ROUND(UPPER_BOUND,2)            AS upper_bound_gbp
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));

-- <<< END 04_forecast.sql

-- ----------------------------------------------------------------------------
-- >>> BEGIN 05_semantic_view.sql
-- ----------------------------------------------------------------------------
-- CFO CoWork Demo — 05 semantic view
-- The Cortex Analyst / CoWork surface over the loan-level mart.
-- Clause order: TABLES, RELATIONSHIPS, FACTS, DIMENSIONS, METRICS.
USE SCHEMA CFO_DEMO.ALDWYCH;

CREATE OR REPLACE SEMANTIC VIEW CFO_DEMO.ALDWYCH.CFO_SEMANTIC
  TABLES (
    loans AS FACT_LOAN PRIMARY KEY (loan_id) WITH SYNONYMS ('loans','facilities','book','portfolio') COMMENT='SME loan-level book',
    monthly AS FACT_PROVISIONS_MONTHLY PRIMARY KEY (month_end, segment_name, sector_name) WITH SYNONYMS ('provisions history','monthly provisions'),
    forecast AS FACT_PROVISIONS_FORECAST PRIMARY KEY (month_end, segment_name, sector_name) WITH SYNONYMS ('forecast','projection'),
    scenario AS FACT_MODEL_SCENARIO PRIMARY KEY (segment_name, scenario) WITH SYNONYMS ('scenario','model vs manual'),
    exposure AS FACT_EXPOSURE_COMPONENT PRIMARY KEY (component_id) WITH SYNONYMS ('regulatory exposure'),
    obligations AS FACT_REGULATORY_OBLIGATION PRIMARY KEY (obligation_id) WITH SYNONYMS ('obligations','deadlines'),
    effort AS FACT_PROCESS_EFFORT PRIMARY KEY (process_name) WITH SYNONYMS ('process effort'),
    capital AS DIM_CAPITAL_CONTEXT PRIMARY KEY (division_name) WITH SYNONYMS ('capital','RWA')
  )
  RELATIONSHIPS (
    exposure_obl AS exposure (obligation_id) REFERENCES obligations (obligation_id)
  )
  FACTS (
    loans.ead_gbp AS loans.ead_gbp, loans.pd AS loans.pd, loans.lgd AS loans.lgd,
    loans.provision_gbp AS loans.provision_gbp, loans.rwa_gbp AS loans.rwa_gbp,
    loans.capital_gbp AS loans.capital_gbp, loans.interest_rate AS loans.interest_rate,
    monthly.exposure_gbp AS monthly.exposure_gbp, monthly.credit_loss_provision_gbp AS monthly.credit_loss_provision_gbp,
    forecast.forecast_provision_gbp AS forecast.forecast_provision_gbp, forecast.lower_bound_gbp AS forecast.lower_bound_gbp, forecast.upper_bound_gbp AS forecast.upper_bound_gbp,
    scenario.annual_provision_gbp AS scenario.annual_provision_gbp, scenario.annual_manual_cost_gbp AS scenario.annual_manual_cost_gbp, scenario.rwa_gbp AS scenario.rwa_gbp, scenario.capital_held_gbp AS scenario.capital_held_gbp,
    exposure.amount_low_gbp AS exposure.amount_low_gbp, exposure.amount_high_gbp AS exposure.amount_high_gbp, exposure.amount_expected_gbp AS exposure.amount_expected_gbp, exposure.probability AS exposure.probability,
    obligations.remediation_pct AS obligations.remediation_pct,
    effort.fte_count AS effort.fte_count, effort.cycle_time_weeks AS effort.cycle_time_weeks, effort.annual_cost_gbp AS effort.annual_cost_gbp, effort.pct_team_maintenance AS effort.pct_team_maintenance,
    capital.risk_weighted_assets_gbp AS capital.risk_weighted_assets_gbp, capital.capital_held_gbp AS capital.capital_held_gbp, capital.sme_exposure_gbp AS capital.sme_exposure_gbp
  )
  DIMENSIONS (
    loans.division AS loans.division_name WITH SYNONYMS ('division'),
    loans.segment AS loans.segment_name WITH SYNONYMS ('segment','sme segment'),
    loans.sector AS loans.sector_name WITH SYNONYMS ('sector','industry'),
    loans.region AS loans.region_name WITH SYNONYMS ('region','geography'),
    loans.rating_grade AS loans.rating_grade WITH SYNONYMS ('rating','grade'),
    loans.vintage_year AS loans.vintage_year WITH SYNONYMS ('vintage','origination year'),
    loans.status AS loans.status WITH SYNONYMS ('loan status'),
    loans.model_portfolio AS loans.model_portfolio WITH SYNONYMS ('model book','suspended model portfolio'),
    monthly.month_end AS monthly.month_end WITH SYNONYMS ('month'),
    monthly.segment AS monthly.segment_name,
    monthly.sector AS monthly.sector_name,
    forecast.month_end AS forecast.month_end,
    forecast.segment AS forecast.segment_name,
    forecast.sector AS forecast.sector_name,
    scenario.scenario AS scenario.scenario WITH SYNONYMS ('model or manual'),
    scenario.segment AS scenario.segment_name,
    exposure.component_type AS exposure.component_type WITH SYNONYMS ('exposure type'),
    exposure.timing_quarter AS exposure.timing_quarter WITH SYNONYMS ('quarter'),
    exposure.is_deterministic AS exposure.is_deterministic,
    obligations.regulation AS obligations.regulation,
    obligations.requirement AS obligations.requirement,
    obligations.status AS obligations.status,
    obligations.deadline_date AS obligations.deadline_date,
    effort.process_name AS effort.process_name,
    capital.division AS capital.division_name
  )
  METRICS (
    loans.loan_total_ead AS SUM(loans.ead_gbp) COMMENT='Total exposure at default',
    loans.loan_total_provision AS SUM(loans.provision_gbp) COMMENT='Total credit-loss provision',
    loans.loan_total_rwa AS SUM(loans.rwa_gbp) COMMENT='Total risk-weighted assets',
    loans.loan_total_capital AS SUM(loans.capital_gbp) COMMENT='Total regulatory capital',
    loans.loan_count AS COUNT(loans.loan_id) COMMENT='Number of facilities',
    loans.avg_pd AS AVG(loans.pd) COMMENT='Average probability of default',
    loans.avg_interest_rate AS AVG(loans.interest_rate) COMMENT='Average interest rate',
    monthly.monthly_provision AS SUM(monthly.credit_loss_provision_gbp) COMMENT='Provisions booked (monthly flow)',
    monthly.monthly_exposure AS SUM(monthly.exposure_gbp),
    forecast.forecast_provision AS SUM(forecast.forecast_provision_gbp) COMMENT='Forecast provisions',
    scenario.scn_provision AS SUM(scenario.annual_provision_gbp) COMMENT='Annual provision by scenario',
    scenario.scn_manual_cost AS SUM(scenario.annual_manual_cost_gbp) COMMENT='Annual manual cost by scenario',
    scenario.scn_capital AS SUM(scenario.capital_held_gbp) COMMENT='Capital held by scenario',
    scenario.scn_rwa AS SUM(scenario.rwa_gbp) COMMENT='RWA by scenario',
    exposure.gross_exposure AS SUM(exposure.amount_expected_gbp) COMMENT='Gross regulatory exposure',
    exposure.prob_weighted_exposure AS SUM(exposure.amount_expected_gbp * exposure.probability) COMMENT='Probability-weighted exposure',
    effort.total_process_cost AS SUM(effort.annual_cost_gbp) COMMENT='Annual process cost',
    capital.capital_total_rwa AS SUM(capital.risk_weighted_assets_gbp),
    capital.capital_total_held AS SUM(capital.capital_held_gbp)
  )
  COMMENT='Aldwych Bank CFO demo semantic view (synthetic, loan-level) for Cortex Analyst / CoWork';

-- <<< END 05_semantic_view.sql

-- ----------------------------------------------------------------------------
-- >>> BEGIN 06_agent.sql
-- ----------------------------------------------------------------------------
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

-- <<< END 06_agent.sql
