/*==============================================================================
Project      : NYC Taxi Analytics
Layer        : Bronze
Script       : 01_create_internal_stage.sql
Author       : Raju Nalla
Description  : Creates an internal stage for storing NYC Yellow Taxi Parquet files.

Execution    : One Time
Dependencies : None
==============================================================================*/

/*----------------------------------------------------------------------------
Step 1 : Create Internal Stage
----------------------------------------------------------------------------*/

-- Your SQL Code Here


USE ROLE ACCOUNTADMIN;
USE WAREHOUSE NYC_WH;
USE DATABASE NYC_TAXI_DB;
USE SCHEMA AUDIT;

CREATE OR REPLACE STAGE NYC_INTERNAL_STAGE
COMMENT='Internal Stage for Bronze Layer Loading';

SHOW STAGES;