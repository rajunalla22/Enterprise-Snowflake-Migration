create or replace view NYC_TAXI_DB.SILVER.VW_TRIPS_TRANSFORMED(
	TRIP_HASH_KEY,
	DATE_KEY,
	PICKUP_LOCATION_ID,
	DROPOFF_LOCATION_ID,
	PICKUP_DATETIME,
	DROPOFF_DATETIME,
	VENDOR_ID,
	RATE_CODE_ID,
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
	LOAD_TIMESTAMP,
	LOAD_BATCH_ID,
	RECORD_SOURCE
) as
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