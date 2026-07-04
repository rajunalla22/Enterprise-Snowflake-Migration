-- ===========================================================
-- Enterprise Snowflake Migration
-- Module : Grant Privileges
-- ===========================================================

USE ROLE SECURITYADMIN;

-- Allow ETL_ROLE to use the warehouse
GRANT USAGE ON WAREHOUSE NYC_WH TO ROLE ETL_ROLE;

-- Allow ETL_ROLE to use the database
GRANT USAGE ON DATABASE NYC_TAXI_DB TO ROLE ETL_ROLE;

-- Allow ETL_ROLE to use schemas
GRANT USAGE ON SCHEMA NYC_TAXI_DB.BRONZE TO ROLE ETL_ROLE;
GRANT USAGE ON SCHEMA NYC_TAXI_DB.SILVER TO ROLE ETL_ROLE;
GRANT USAGE ON SCHEMA NYC_TAXI_DB.GOLD TO ROLE ETL_ROLE;
GRANT USAGE ON SCHEMA NYC_TAXI_DB.STAGE TO ROLE ETL_ROLE;
GRANT USAGE ON SCHEMA NYC_TAXI_DB.AUDIT TO ROLE ETL_ROLE;