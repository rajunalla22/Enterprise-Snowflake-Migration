-- ===========================================================
-- Enterprise Snowflake Migration
-- Module : Role Creation
-- ===========================================================

USE ROLE SECURITYADMIN;

CREATE ROLE IF NOT EXISTS ETL_ROLE
COMMENT='Role for Data Engineering Team';

CREATE ROLE IF NOT EXISTS ANALYST_ROLE
COMMENT='Role for Data Analysts';

CREATE ROLE IF NOT EXISTS BI_ROLE
COMMENT='Role for BI Dashboard Users';

SHOW ROLES;