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
