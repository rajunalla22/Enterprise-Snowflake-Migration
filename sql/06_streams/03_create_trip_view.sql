USE ROLE ACCOUNTADMIN;
USE WAREHOUSE NYC_WH;
USE DATABASE NYC_TAXI_DB;
USE SCHEMA SILVER;

CREATE OR REPLACE VIEW VW_TRIPS_TRANSFORMED AS
SELECT
    /*=====================================================
      Business Key
    =====================================================*/
    SHA2(
        CONCAT_WS(
            '|',
            VENDORID,
            PICKUP_DATETIME,
            DROPOFF_DATETIME,
            PULOCATIONID,
            DOLOCATIONID
        ),
        256
    ) AS TRIP_HASH_KEY,
    /*=====================================================
      Dimension Keys
    =====================================================*/
    TO_NUMBER(
        TO_CHAR(PICKUP_DATETIME,'YYYYMMDD')
    ) AS DATE_KEY,
    PULOCATIONID  AS PICKUP_LOCATION_ID,
    DOLOCATIONID  AS DROPOFF_LOCATION_ID,
    /*=====================================================
      Business Columns
    =====================================================*/
    PICKUP_DATETIME,
    DROPOFF_DATETIME,
    VENDORID        AS VENDOR_ID,
    RATECODEID      AS RATE_CODE_ID,
    PAYMENT_TYPE,
    PASSENGER_COUNT,
    TRIP_DISTANCE,
    FARE_AMOUNT,
    EXTRA,
    MTA_TAX,
    TIP_AMOUNT,
    TOLLS_AMOUNT,
    IMPROVEMENT_SURCHARGE,
    TOTAL_AMOUNT,
    CONGESTION_SURCHARGE,
    AIRPORT_FEE,
    /*=====================================================
      Audit Columns
    =====================================================*/
    LOAD_TIMESTAMP,
    LOAD_BATCH_ID,
    RECORD_SOURCE
FROM SILVER.TRIPS;