-- ==========================================================
-- Project : Enterprise Snowflake Migration
-- Module  : Warehouse Creation
-- Author  : Raju Nalla
-- ==========================================================

USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE WAREHOUSE NYC_WH
WITH
WAREHOUSE_SIZE = 'XSMALL'
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE
COMMENT = 'Warehouse for NYC Taxi Migration Project';

