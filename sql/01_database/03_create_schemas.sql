-- ==========================================================
-- Project : Enterprise Snowflake Migration
-- Module  : Schema Creation
-- Author  : Raju Nalla
-- ==========================================================

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE NYC_WH;
USE DATABASE NYC_TAXI_DB;

CREATE OR REPLACE SCHEMA BRONZE
COMMENT='Raw Landing Zone';

CREATE OR REPLACE SCHEMA SILVER
COMMENT='Cleaned Data Layer';

CREATE OR REPLACE SCHEMA GOLD
COMMENT='Business Reporting Layer';

CREATE OR REPLACE SCHEMA STAGE
COMMENT='Stages and File Formats';

CREATE OR REPLACE SCHEMA AUDIT
COMMENT='Audit and Metadata';