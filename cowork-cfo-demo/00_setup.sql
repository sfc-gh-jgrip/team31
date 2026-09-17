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
