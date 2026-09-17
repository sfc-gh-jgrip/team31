-- CFO CoWork Demo — 02 seed (synthetic, deterministic)
-- All figures invented for demo. Numbers are internally consistent so CoWork/Analyst
-- computes headlines from the data (no hand-asserted totals).
USE SCHEMA CFO_DEMO.ALDWYCH;

-- Dimensions -----------------------------------------------------------------
INSERT INTO DIM_SEGMENT (segment_name, segment_order) VALUES
  ('Micro', 1), ('Small', 2), ('Medium', 3);

INSERT INTO DIM_DIVISION (division_name, is_ringfenced) VALUES
  ('Aldwych Retail', TRUE),
  ('Aldwych Commercial', FALSE),
  ('Aldwych Private', FALSE),
  ('Aldwych Business', FALSE);

-- Monthly SME provisions: 36 months x 3 segments, deterministic formula.
-- provision = exposure * annual PD * LGD / 12 * manual_overprovision(1.12)
INSERT INTO FACT_SME_PROVISIONS_MONTHLY
  (month_end, segment_name, exposure_gbp, default_rate, lgd, credit_loss_provision_gbp, process_mode)
WITH months AS (
  SELECT SEQ4() AS i FROM TABLE(GENERATOR(ROWCOUNT => 36))
),
seg AS (
  SELECT * FROM VALUES
    ('Micro',   70000000, 0.020),
    ('Small',  120000000, 0.017),
    ('Medium', 160000000, 0.015)
  AS t(segment_name, base_exp, base_pd)
)
SELECT
  LAST_DAY(DATEADD(month, m.i, DATE '2023-09-01'))                                   AS month_end,
  s.segment_name,
  ROUND(s.base_exp * (1 + 0.004 * m.i), 2)                                           AS exposure_gbp,
  ROUND(s.base_pd + 0.0004 * m.i + 0.001 * ABS(SIN(m.i / 2.0)), 5)                   AS default_rate,
  0.450                                                                              AS lgd,
  ROUND((s.base_exp * (1 + 0.004 * m.i))
        * (s.base_pd + 0.0004 * m.i + 0.001 * ABS(SIN(m.i / 2.0)))
        * 0.45 / 12 * 1.12, 2)                                                       AS credit_loss_provision_gbp,
  'MANUAL'
FROM months m CROSS JOIN seg s;

-- Risk model inventory -------------------------------------------------------
INSERT INTO DIM_RISK_MODEL
  (model_id, model_name, status, suspended_reason, portfolio_exposure_gbp, annual_manual_cost_gbp) VALUES
  ('SME-CR-01', 'SME Credit Risk Scoring (ML)', 'SUSPENDED',
   'FCA notice - insufficient data lineage/provenance to evidence training data', 350000000, 4200000),
  ('IB-MKT-02', 'Investment Bank Market Risk VaR', 'ACTIVE', NULL, 0, 0),
  ('AML-TX-03', 'AML Transaction Monitoring (partner)', 'ACTIVE', NULL, 0, 0);

-- Model-on vs manual scenario ------------------------------------------------
INSERT INTO FACT_MODEL_SCENARIO
  (segment_name, scenario, annual_provision_gbp, annual_manual_cost_gbp, rwa_gbp, capital_held_gbp) VALUES
  ('Micro',  'MANUAL', 1200000, 1000000,  67000000,  7040000),
  ('Small',  'MANUAL', 2000000, 1500000, 115000000, 12100000),
  ('Medium', 'MANUAL', 2500000, 1700000, 154000000, 16200000),
  ('Micro',  'MODEL',  1050000,  100000,  61600000,  6470000),
  ('Small',  'MODEL',  1760000,  100000, 105800000, 11130000),
  ('Medium', 'MODEL',  2200000,  100000, 141700000, 14900000);

-- Regulatory obligations -----------------------------------------------------
INSERT INTO FACT_REGULATORY_OBLIGATION
  (obligation_id, regulation, requirement, deadline_date, status, remediation_pct) VALUES
  ('OBL-FCA-01', 'FCA Notice', 'Reinstate SME model with evidenced data lineage/provenance', DATE '2026-12-31', 'AT_RISK', 35),
  ('OBL-BCBS-01', 'BCBS 239', 'Calculation/column-level lineage source-to-report (Principle 3)', DATE '2026-12-31', 'AT_RISK', 40),
  ('OBL-PRA-01', 'PRA SS1/23', 'Model data provenance for model risk management', DATE '2026-12-31', 'AT_RISK', 30);

-- Exposure components (consequence streams) ----------------------------------
INSERT INTO FACT_EXPOSURE_COMPONENT
  (component_id, obligation_id, component_type, amount_low_gbp, amount_high_gbp, amount_expected_gbp, probability, timing_quarter, is_deterministic) VALUES
  ('EC-01', 'OBL-FCA-01',  'PENALTY',          35000000, 55000000, 45000000, 0.600, '2026-Q4', FALSE),
  ('EC-02', 'OBL-BCBS-01', 'CAPITAL_ADDON',     5000000, 10000000,  6700000, 0.700, '2026-Q4', FALSE),
  ('EC-03', 'OBL-FCA-01',  'OPERATIONAL_COST',  4000000,  4400000,  4200000, 1.000, '2026-Q4', TRUE),
  ('EC-04', 'OBL-FCA-01',  'PNL_DRAG',          2500000,  4500000,  3500000, 0.800, '2026-Q4', FALSE);

-- Division capital context ---------------------------------------------------
INSERT INTO DIM_CAPITAL_CONTEXT
  (division_name, risk_weighted_assets_gbp, capital_held_gbp, sme_exposure_gbp) VALUES
  ('Aldwych Retail',     12000000000, 1260000000,  40000000),
  ('Aldwych Commercial',  8000000000,  840000000, 180000000),
  ('Aldwych Private',     3000000000,  315000000,  20000000),
  ('Aldwych Business',    5000000000,  525000000, 110000000);

-- Process effort -------------------------------------------------------------
INSERT INTO FACT_PROCESS_EFFORT
  (process_name, fte_count, cycle_time_weeks, annual_cost_gbp, pct_team_maintenance) VALUES
  ('Monthly Regulatory Reporting', 22.0, 3.0, 2800000, 55.0),
  ('SME Manual Credit Review',     30.0, NULL, 4200000, NULL);
