/*==============================================================================
Project      : NYC Taxi Analytics
Layer        : Gold
Script       : 08_gold_business_validation.sql
Description  : Business validation queries for FACT_TRIPS.
==============================================================================*/

-- Total Records
SELECT COUNT(*) AS TOTAL_RECORDS
FROM GOLD.FACT_TRIPS;

-- Date Range
SELECT
    MIN(PICKUP_DATETIME) AS MIN_PICKUP,
    MAX(PICKUP_DATETIME) AS MAX_PICKUP
FROM GOLD.FACT_TRIPS;

-- Monthly Distribution
SELECT
    TO_CHAR(PICKUP_DATETIME,'YYYY-MM') AS MONTH,
    COUNT(*) AS TOTAL_TRIPS
FROM GOLD.FACT_TRIPS
GROUP BY 1
ORDER BY 1;

-- Vendor Distribution
SELECT
    VENDOR_ID,
    COUNT(*) AS TOTAL_TRIPS
FROM GOLD.FACT_TRIPS
GROUP BY VENDOR_ID
ORDER BY VENDOR_ID;

-- Payment Type Distribution
SELECT
    PAYMENT_TYPE,
    COUNT(*) AS TOTAL_TRIPS
FROM GOLD.FACT_TRIPS
GROUP BY PAYMENT_TYPE
ORDER BY PAYMENT_TYPE;

-- Average Fare
SELECT
    ROUND(AVG(FARE_AMOUNT),2) AS AVG_FARE
FROM GOLD.FACT_TRIPS;

-- Maximum Fare
SELECT
    MAX(FARE_AMOUNT) AS MAX_FARE
FROM GOLD.FACT_TRIPS;

-- Average Trip Distance
SELECT
    ROUND(AVG(TRIP_DISTANCE),2) AS AVG_DISTANCE
FROM GOLD.FACT_TRIPS;

-- Null Validation
SELECT
    COUNT_IF(DATE_KEY IS NULL)              AS DATE_KEY_NULLS,
    COUNT_IF(PICKUP_LOCATION_ID IS NULL)    AS PICKUP_LOCATION_NULLS,
    COUNT_IF(DROPOFF_LOCATION_ID IS NULL)   AS DROPOFF_LOCATION_NULLS
FROM GOLD.FACT_TRIPS;