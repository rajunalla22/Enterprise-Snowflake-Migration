/*==============================================================================
Project      : NYC Taxi Analytics
Layer        : Bronze
Script       : 05_validate_load.sql
Author       : Raju Nalla
Description  : Validates successful loading of data into Bronze.

Execution    : After Every Load
Dependencies : RAW_TRIPS Table
==============================================================================*/

-- Validation Queries

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE NYC_WH;
USE DATABASE NYC_TAXI_DB;
USE SCHEMA BRONZE;

----------------------------------------------------
-- Row Count
----------------------------------------------------

SELECT COUNT(*) AS TOTAL_ROWS
FROM RAW_TRIPS;

----------------------------------------------------
-- Sample Data
----------------------------------------------------

SELECT *
FROM RAW_TRIPS
LIMIT 10;

----------------------------------------------------
-- Rows by Source File
----------------------------------------------------

SELECT
    SOURCE_FILE_NAME,
    COUNT(*) AS ROW_COUNT
FROM RAW_TRIPS
GROUP BY SOURCE_FILE_NAME
ORDER BY SOURCE_FILE_NAME;

----------------------------------------------------
-- Batch Validation
----------------------------------------------------

SELECT
    LOAD_BATCH_ID,
    COUNT(*) AS ROW_COUNT
FROM RAW_TRIPS
GROUP BY LOAD_BATCH_ID;