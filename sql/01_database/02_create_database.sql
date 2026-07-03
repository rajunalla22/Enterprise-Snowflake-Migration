-- ==========================================================
-- Project : Enterprise Snowflake Migration
-- Module  : Database Creation
-- Author  : Raju Nalla
-- ==========================================================

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE NYC_WH;

CREATE OR REPLACE DATABASE NYC_TAXI_DB
COMMENT = 'Enterprise Snowflake Migration Database';

