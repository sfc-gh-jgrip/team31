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
