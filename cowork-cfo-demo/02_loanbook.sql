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
