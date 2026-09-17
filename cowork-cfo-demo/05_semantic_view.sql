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
