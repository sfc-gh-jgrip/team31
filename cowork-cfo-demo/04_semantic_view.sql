-- CFO CoWork Demo — 04 semantic view
-- Semantic view consumed by Cortex Analyst / Snowflake CoWork so the CFO can
-- ask the demo questions in natural language.
-- Clause order matters: TABLES, RELATIONSHIPS, FACTS, DIMENSIONS, METRICS.
USE SCHEMA CFO_DEMO.ALDWYCH;

CREATE OR REPLACE SEMANTIC VIEW CFO_DEMO.ALDWYCH.CFO_SEMANTIC
  TABLES (
    provisions AS FACT_SME_PROVISIONS_MONTHLY
      PRIMARY KEY (month_end, segment_name)
      WITH SYNONYMS ('provisions','credit loss','impairments')
      COMMENT = 'Monthly SME credit-loss provisions (actuals)',
    forecast AS FACT_SME_PROVISIONS_FORECAST
      PRIMARY KEY (month_end, segment_name)
      WITH SYNONYMS ('forecast','projection')
      COMMENT = 'Forecast SME credit-loss provisions (next 12 months)',
    scenario AS FACT_MODEL_SCENARIO
      PRIMARY KEY (segment_name, scenario)
      WITH SYNONYMS ('scenario','model vs manual')
      COMMENT = 'Model-on vs manual scenario comparison',
    exposure AS FACT_EXPOSURE_COMPONENT
      PRIMARY KEY (component_id)
      WITH SYNONYMS ('regulatory exposure','consequences')
      COMMENT = 'Consequence streams of missing regulatory deadlines',
    obligations AS FACT_REGULATORY_OBLIGATION
      PRIMARY KEY (obligation_id)
      WITH SYNONYMS ('obligations','regulatory deadlines'),
    effort AS FACT_PROCESS_EFFORT
      PRIMARY KEY (process_name)
      WITH SYNONYMS ('process','operational effort'),
    capital AS DIM_CAPITAL_CONTEXT
      PRIMARY KEY (division_name)
      WITH SYNONYMS ('capital','RWA'),
    models AS DIM_RISK_MODEL
      PRIMARY KEY (model_id)
      WITH SYNONYMS ('risk models','models'),
    segment AS DIM_SEGMENT
      PRIMARY KEY (segment_name),
    division AS DIM_DIVISION
      PRIMARY KEY (division_name)
  )
  RELATIONSHIPS (
    provisions_seg AS provisions (segment_name) REFERENCES segment (segment_name),
    forecast_seg   AS forecast (segment_name)   REFERENCES segment (segment_name),
    scenario_seg   AS scenario (segment_name)   REFERENCES segment (segment_name),
    exposure_obl   AS exposure (obligation_id)  REFERENCES obligations (obligation_id),
    capital_div    AS capital (division_name)   REFERENCES division (division_name)
  )
  FACTS (
    provisions.exposure_gbp AS provisions.exposure_gbp,
    provisions.credit_loss_provision_gbp AS provisions.credit_loss_provision_gbp,
    provisions.default_rate AS provisions.default_rate,
    forecast.forecast_provision_gbp AS forecast.forecast_provision_gbp,
    forecast.lower_bound_gbp AS forecast.lower_bound_gbp,
    forecast.upper_bound_gbp AS forecast.upper_bound_gbp,
    scenario.annual_provision_gbp AS scenario.annual_provision_gbp,
    scenario.annual_manual_cost_gbp AS scenario.annual_manual_cost_gbp,
    scenario.rwa_gbp AS scenario.rwa_gbp,
    scenario.capital_held_gbp AS scenario.capital_held_gbp,
    exposure.amount_low_gbp AS exposure.amount_low_gbp,
    exposure.amount_high_gbp AS exposure.amount_high_gbp,
    exposure.amount_expected_gbp AS exposure.amount_expected_gbp,
    exposure.probability AS exposure.probability,
    obligations.remediation_pct AS obligations.remediation_pct,
    effort.fte_count AS effort.fte_count,
    effort.cycle_time_weeks AS effort.cycle_time_weeks,
    effort.annual_cost_gbp AS effort.annual_cost_gbp,
    effort.pct_team_maintenance AS effort.pct_team_maintenance,
    models.portfolio_exposure_gbp AS models.portfolio_exposure_gbp,
    models.annual_manual_cost_gbp AS models.annual_manual_cost_gbp,
    capital.risk_weighted_assets_gbp AS capital.risk_weighted_assets_gbp,
    capital.capital_held_gbp AS capital.capital_held_gbp,
    capital.sme_exposure_gbp AS capital.sme_exposure_gbp
  )
  DIMENSIONS (
    provisions.month_end AS provisions.month_end WITH SYNONYMS ('month','period'),
    provisions.segment AS provisions.segment_name WITH SYNONYMS ('sme segment','segment'),
    provisions.process_mode AS provisions.process_mode,
    forecast.month_end AS forecast.month_end,
    forecast.segment AS forecast.segment_name,
    scenario.scenario AS scenario.scenario WITH SYNONYMS ('model or manual','case'),
    scenario.segment AS scenario.segment_name,
    exposure.component_type AS exposure.component_type WITH SYNONYMS ('exposure type','consequence type'),
    exposure.timing_quarter AS exposure.timing_quarter WITH SYNONYMS ('quarter'),
    exposure.is_deterministic AS exposure.is_deterministic,
    obligations.regulation AS obligations.regulation WITH SYNONYMS ('regulation','regulator'),
    obligations.requirement AS obligations.requirement,
    obligations.status AS obligations.status,
    obligations.deadline_date AS obligations.deadline_date WITH SYNONYMS ('deadline'),
    models.model_name AS models.model_name WITH SYNONYMS ('model'),
    models.status AS models.status,
    models.suspended_reason AS models.suspended_reason,
    effort.process_name AS effort.process_name,
    capital.division AS capital.division_name WITH SYNONYMS ('division','business unit')
  )
  METRICS (
    provisions.total_provision AS SUM(provisions.credit_loss_provision_gbp)
      WITH SYNONYMS ('total provisions','total credit loss')
      COMMENT = 'Sum of monthly SME credit-loss provisions',
    provisions.total_exposure AS SUM(provisions.exposure_gbp)
      COMMENT = 'Sum of SME credit exposure',
    forecast.total_forecast_provision AS SUM(forecast.forecast_provision_gbp)
      WITH SYNONYMS ('forecast provisions')
      COMMENT = 'Sum of forecast SME credit-loss provisions',
    scenario.total_annual_provision AS SUM(scenario.annual_provision_gbp)
      COMMENT = 'Annual provisions by scenario (MANUAL vs MODEL)',
    scenario.total_manual_cost AS SUM(scenario.annual_manual_cost_gbp)
      COMMENT = 'Annual manual review labour cost by scenario',
    scenario.total_capital_held AS SUM(scenario.capital_held_gbp)
      COMMENT = 'Capital held by scenario (difference = capital relief)',
    exposure.gross_exposure AS SUM(exposure.amount_expected_gbp)
      COMMENT = 'Gross (un-weighted) regulatory exposure',
    exposure.prob_weighted_exposure AS SUM(exposure.amount_expected_gbp * exposure.probability)
      WITH SYNONYMS ('expected exposure','probability weighted exposure')
      COMMENT = 'Probability-weighted regulatory exposure',
    effort.total_process_cost AS SUM(effort.annual_cost_gbp)
      COMMENT = 'Annual cost of operational processes',
    capital.total_rwa AS SUM(capital.risk_weighted_assets_gbp)
      COMMENT = 'Total risk-weighted assets'
  )
  COMMENT = 'Aldwych Bank CFO demo semantic view (synthetic data) for Cortex Analyst / CoWork';
