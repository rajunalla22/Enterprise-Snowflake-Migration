/*==============================================================================
Project      : NYC Taxi Analytics
Layer        : Bronze
Script       : 02_create_file_format.sql
Author       : Raju Nalla
Description  : Creates a Parquet file format used for loading raw taxi data.

Execution    : One Time
Dependencies : Internal Stage
==============================================================================*/

/*----------------------------------------------------------------------------
Step 1 : Create File Format
----------------------------------------------------------------------------*/

-- Your SQL Code Here

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE NYC_WH;
USE DATABASE NYC_TAXI_DB;
USE SCHEMA AUDIT;

-- Create Parquet File Format
CREATE OR REPLACE FILE FORMAT NYC_PARQUET_FORMAT
TYPE = PARQUET
COMPRESSION = AUTO;

-- Verify
SHOW FILE FORMATS;

DESC FILE FORMAT NYC_PARQUET_FORMAT;
