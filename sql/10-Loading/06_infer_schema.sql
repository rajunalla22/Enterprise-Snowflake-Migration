/*==============================================================================
Project      : NYC Taxi Analytics
Layer        : Bronze
Script       : 06_infer_schema.sql
Author       : Raju Nalla
Description  : Infers the schema from Parquet files before creating the
               Bronze table.

Execution    : One Time
Dependencies : Internal Stage
==============================================================================*/


USE ROLE ACCOUNTADMIN;
USE WAREHOUSE NYC_WH;
USE DATABASE NYC_TAXI_DB;
USE SCHEMA AUDIT;


-- Infer schema from Parquet files
SELECT * from Table (
    INFER_SCHEMA(
    Location => '@NYC_INTERNAL_STAGE', 
    File_Format => 'NYC_PARQUET_FORMAT'
    )
);