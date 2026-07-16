--=========================================================
-- VALIDATIONS
--=========================================================

-- Validation 1 - Total Row Count
SELECT COUNT(*) AS TOTAL_ROWS
FROM SILVER.TRIPS;

-- Validation 2 - Source File Counts
SELECT
    SOURCE_FILE_NAME,
    COUNT(*) AS TOTAL_ROWS
FROM SILVER.TRIPS
GROUP BY SOURCE_FILE_NAME
ORDER BY SOURCE_FILE_NAME;

-- Validation 3 - Date Distribution
SELECT
    DATE(PICKUP_DATETIME) AS PICKUP_DATE,
    COUNT(*) AS TOTAL_ROWS
FROM SILVER.TRIPS
GROUP BY DATE(PICKUP_DATETIME)
ORDER BY PICKUP_DATE;

-- Validation 4 - Bad Historical Records
SELECT *
FROM SILVER.TRIPS
WHERE PICKUP_DATETIME < '2023-01-01';

-- Validation 5 - Duplicate Check
SELECT
    SOURCE_FILE_NAME,
    COUNT(*) TOTAL,
    COUNT(DISTINCT
        VENDORID,
        PICKUP_DATETIME,
        DROPOFF_DATETIME,
        PULOCATIONID,
        DOLOCATIONID
    ) AS DISTINCT_ROWS
FROM SILVER.TRIPS
GROUP BY SOURCE_FILE_NAME;