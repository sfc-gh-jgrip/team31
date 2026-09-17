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
