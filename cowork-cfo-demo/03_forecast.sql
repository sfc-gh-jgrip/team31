-- CFO CoWork Demo — 03 forecast
-- Forecasts SME credit-loss provisions per segment for the next 12 months
-- using Snowflake native ML.FORECAST, and lands results in a table the
-- semantic view can read.
USE SCHEMA CFO_DEMO.ALDWYCH;

-- Training input: normalise to first-of-month for equal monthly spacing.
CREATE OR REPLACE VIEW V_PROVISIONS_TRAIN AS
SELECT
  segment_name,
  DATE_TRUNC('month', month_end)::TIMESTAMP_NTZ AS month_ts,
  credit_loss_provision_gbp
FROM FACT_SME_PROVISIONS_MONTHLY;

-- Multi-series forecast model (one series per SME segment).
CREATE OR REPLACE SNOWFLAKE.ML.FORECAST CFO_PROVISION_FORECAST(
  INPUT_DATA        => SYSTEM$REFERENCE('VIEW', 'V_PROVISIONS_TRAIN'),
  SERIES_COLNAME    => 'SEGMENT_NAME',
  TIMESTAMP_COLNAME => 'MONTH_TS',
  TARGET_COLNAME    => 'CREDIT_LOSS_PROVISION_GBP'
);

-- Produce the 12-month forecast and persist it.
-- NOTE: the CALL and the RESULT_SCAN capture must run in the SAME session,
-- so keep these two statements together.
CALL CFO_PROVISION_FORECAST!FORECAST(FORECASTING_PERIODS => 12);

CREATE OR REPLACE TABLE FACT_SME_PROVISIONS_FORECAST AS
SELECT
  SERIES::STRING                         AS segment_name,
  TS::DATE                               AS month_end,
  ROUND(FORECAST, 2)                     AS forecast_provision_gbp,
  ROUND(LOWER_BOUND, 2)                  AS lower_bound_gbp,
  ROUND(UPPER_BOUND, 2)                  AS upper_bound_gbp
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));
