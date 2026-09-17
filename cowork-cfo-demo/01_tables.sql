-- CFO CoWork Demo — 01 tables
-- Synthetic Aldwych Bank CFO data mart. All figures are invented for demo use.
USE SCHEMA CFO_DEMO.ALDWYCH;

-- Dimensions -----------------------------------------------------------------
CREATE OR REPLACE TABLE DIM_SEGMENT (
  segment_name  STRING COMMENT 'SME sub-segment',
  segment_order INT    COMMENT 'Display order'
) COMMENT = 'SME lending sub-segments';

CREATE OR REPLACE TABLE DIM_DIVISION (
  division_name STRING  COMMENT 'Aldwych banking division',
  is_ringfenced BOOLEAN COMMENT 'TRUE = ring-fenced retail estate'
) COMMENT = 'Aldwych Bank divisions';

-- Facts ----------------------------------------------------------------------
CREATE OR REPLACE TABLE FACT_SME_PROVISIONS_MONTHLY (
  month_end                 DATE    COMMENT 'Month-end date of the reporting period',
  segment_name              STRING  COMMENT 'SME sub-segment',
  exposure_gbp              NUMBER(18,2) COMMENT 'Gross SME credit exposure (GBP)',
  default_rate              NUMBER(7,5)  COMMENT 'Modelled probability of default for the month',
  lgd                       NUMBER(5,3)  COMMENT 'Loss given default assumption',
  credit_loss_provision_gbp NUMBER(18,2) COMMENT 'Credit-loss provision booked (GBP)',
  process_mode              STRING  COMMENT 'MANUAL = current manual underwriting process'
) COMMENT = 'Monthly SME credit-loss provisions (historical actuals, MANUAL process)';

CREATE OR REPLACE TABLE DIM_RISK_MODEL (
  model_id                 STRING  COMMENT 'Model identifier',
  model_name               STRING  COMMENT 'Risk model name',
  status                   STRING  COMMENT 'ACTIVE or SUSPENDED',
  suspended_reason         STRING  COMMENT 'Why the model is offline',
  portfolio_exposure_gbp   NUMBER(18,2) COMMENT 'Exposure governed by this model (GBP)',
  annual_manual_cost_gbp   NUMBER(18,2) COMMENT 'Annual manual review cost while suspended (GBP)'
) COMMENT = 'Risk model inventory and status';

CREATE OR REPLACE TABLE FACT_MODEL_SCENARIO (
  segment_name         STRING  COMMENT 'SME sub-segment',
  scenario             STRING  COMMENT 'MANUAL (today) or MODEL (automated reinstated)',
  annual_provision_gbp NUMBER(18,2) COMMENT 'Annualised credit-loss provision under the scenario (GBP)',
  annual_manual_cost_gbp NUMBER(18,2) COMMENT 'Annual manual review labour cost under the scenario (GBP)',
  rwa_gbp              NUMBER(18,2) COMMENT 'Risk-weighted assets under the scenario (GBP)',
  capital_held_gbp     NUMBER(18,2) COMMENT 'Regulatory capital held against RWA (GBP)'
) COMMENT = 'Model-on vs manual scenario comparison for payback / capital relief';

CREATE OR REPLACE TABLE FACT_REGULATORY_OBLIGATION (
  obligation_id   STRING COMMENT 'Obligation identifier',
  regulation      STRING COMMENT 'Regulation / notice',
  requirement     STRING COMMENT 'What must be satisfied',
  deadline_date   DATE   COMMENT 'Regulatory deadline',
  status          STRING COMMENT 'ON_TRACK / AT_RISK / BREACHED',
  remediation_pct NUMBER(5,2) COMMENT 'Percent of remediation complete'
) COMMENT = 'Regulatory obligations and deadlines';

CREATE OR REPLACE TABLE FACT_EXPOSURE_COMPONENT (
  component_id      STRING COMMENT 'Component identifier',
  obligation_id     STRING COMMENT 'FK to FACT_REGULATORY_OBLIGATION',
  component_type    STRING COMMENT 'PENALTY / CAPITAL_ADDON / OPERATIONAL_COST / PNL_DRAG',
  amount_low_gbp    NUMBER(18,2) COMMENT 'Low estimate (GBP)',
  amount_high_gbp   NUMBER(18,2) COMMENT 'High estimate (GBP)',
  amount_expected_gbp NUMBER(18,2) COMMENT 'Expected (probability-weighted) amount (GBP)',
  probability       NUMBER(4,3)  COMMENT 'Probability the exposure crystallises (0-1)',
  timing_quarter    STRING COMMENT 'Quarter the exposure would land',
  is_deterministic  BOOLEAN COMMENT 'TRUE = near-certain (e.g. live FCA notice)'
) COMMENT = 'Quantified consequence streams of missing regulatory deadlines';

CREATE OR REPLACE TABLE DIM_CAPITAL_CONTEXT (
  division_name         STRING COMMENT 'Aldwych banking division',
  risk_weighted_assets_gbp NUMBER(18,2) COMMENT 'RWA for the division (GBP)',
  capital_held_gbp      NUMBER(18,2) COMMENT 'Regulatory capital held (GBP)',
  sme_exposure_gbp      NUMBER(18,2) COMMENT 'SME exposure within the division (GBP)'
) COMMENT = 'Division-level capital and RWA context';

CREATE OR REPLACE TABLE FACT_PROCESS_EFFORT (
  process_name         STRING COMMENT 'Business process',
  fte_count            NUMBER(6,1) COMMENT 'Full-time-equivalents engaged',
  cycle_time_weeks     NUMBER(4,1) COMMENT 'Elapsed cycle time (weeks)',
  annual_cost_gbp      NUMBER(18,2) COMMENT 'Annual cost of the process (GBP)',
  pct_team_maintenance NUMBER(5,2) COMMENT 'Percent of team time spent on legacy maintenance'
) COMMENT = 'Operational effort / productivity drag';
