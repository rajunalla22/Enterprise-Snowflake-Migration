--------------- Create Stored Procedure to Load Silver Layer ---------------

CREATE OR REPLACE PROCEDURE AUDIT.SP_LOAD_SILVER
(
    P_BATCH_ID STRING
)
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    V_BATCH_EXISTS NUMBER DEFAULT 0;
    V_SILVER_ROWS NUMBER DEFAULT 0;

BEGIN

    --------------------------------------------------------
    -- Validate Batch Exists
    --------------------------------------------------------

    SELECT COUNT(*)
    INTO :V_BATCH_EXISTS
    FROM AUDIT.ETL_BATCH_LOG
    WHERE BATCH_ID = :P_BATCH_ID
      AND STATUS = 'SUCCESS';

    IF (V_BATCH_EXISTS = 0) THEN
        RETURN 'Bronze batch not found or not completed successfully.';
    END IF;

    --------------------------------------------------------
    -- Load Silver
    --------------------------------------------------------

    CREATE OR REPLACE PROCEDURE AUDIT.SP_LOAD_SILVER
(
    P_BATCH_ID STRING
)
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    V_BATCH_EXISTS  NUMBER DEFAULT 0;
    V_SILVER_EXISTS NUMBER DEFAULT 0;
    V_SILVER_ROWS   NUMBER DEFAULT 0;

BEGIN

    ----------------------------------------------------------------------
    -- Step 1 : Validate Bronze Batch
    ----------------------------------------------------------------------

    SELECT COUNT(*)
    INTO :V_BATCH_EXISTS
    FROM AUDIT.ETL_BATCH_LOG
    WHERE BATCH_ID = :P_BATCH_ID
      AND STATUS = 'SUCCESS';

    IF (V_BATCH_EXISTS = 0) THEN
        RETURN 'Bronze batch not found or not completed successfully.';
    END IF;

    ----------------------------------------------------------------------
    -- Step 2 : Check if Silver already loaded
    ----------------------------------------------------------------------

    SELECT COUNT(*)
    INTO :V_SILVER_EXISTS
    FROM SILVER.TRIPS
    WHERE LOAD_BATCH_ID = :P_BATCH_ID;

    IF (V_SILVER_EXISTS > 0) THEN
        RETURN 'Silver data already loaded for batch ' || P_BATCH_ID;
    END IF;

    ----------------------------------------------------------------------
    -- Step 3 : Load Silver
    ----------------------------------------------------------------------

    INSERT INTO SILVER.TRIPS
    (
        VENDORID,
        PICKUP_DATETIME,
        DROPOFF_DATETIME,
        PASSENGER_COUNT,
        RATECODEID,
        STORE_AND_FWD_FLAG,
        PULOCATIONID,
        DOLOCATIONID,
        PAYMENT_TYPE,
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
        ETL_UPDATED_TIMESTAMP,
        SOURCE_FILE_NAME,
        LOAD_BATCH_ID,
        RECORD_SOURCE
    )

    SELECT

        VENDORID,
        TO_TIMESTAMP_NTZ(TPEP_PICKUP_DATETIME/1000000),
        TO_TIMESTAMP_NTZ(TPEP_DROPOFF_DATETIME/1000000),
        PASSENGER_COUNT::NUMBER,
        RATECODEID::NUMBER,
        STORE_AND_FWD_FLAG,
        PULOCATIONID,
        DOLOCATIONID,
        PAYMENT_TYPE,
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
        CURRENT_TIMESTAMP(),
        SOURCE_FILE_NAME,
        LOAD_BATCH_ID,
        RECORD_SOURCE
    FROM BRONZE.RAW_TRIPS
    WHERE LOAD_BATCH_ID = :P_BATCH_ID
      AND VENDORID IS NOT NULL
      AND TPEP_PICKUP_DATETIME IS NOT NULL
      AND TPEP_DROPOFF_DATETIME IS NOT NULL
      AND PULOCATIONID IS NOT NULL
      AND DOLOCATIONID IS NOT NULL
      AND PAYMENT_TYPE IS NOT NULL
      AND TO_TIMESTAMP_NTZ(TPEP_PICKUP_DATETIME/1000000)
            BETWEEN '2023-01-01'
            AND '2023-12-31 23:59:59'
      AND TO_TIMESTAMP_NTZ(TPEP_DROPOFF_DATETIME/1000000)
            BETWEEN '2023-01-01'
            AND '2023-12-31 23:59:59'
      AND TRIP_DISTANCE > 0
      AND FARE_AMOUNT > 0
      AND TOTAL_AMOUNT > 0
      AND TO_TIMESTAMP_NTZ(TPEP_PICKUP_DATETIME/1000000)
            <
          TO_TIMESTAMP_NTZ(TPEP_DROPOFF_DATETIME/1000000);
    ----------------------------------------------------------------------
    -- Step 4 : Count Loaded Rows
    ----------------------------------------------------------------------
    SELECT COUNT(*)
    INTO :V_SILVER_ROWS
    FROM SILVER.TRIPS
    WHERE LOAD_BATCH_ID = :P_BATCH_ID;
    ----------------------------------------------------------------------
    -- Step 5 : Update Audit Table
    ----------------------------------------------------------------------
    UPDATE AUDIT.ETL_BATCH_LOG
    SET
        SILVER_ROWS = :V_SILVER_ROWS
    WHERE BATCH_ID = :P_BATCH_ID;
    ----------------------------------------------------------------------
    -- Step 6 : Return Success
    ----------------------------------------------------------------------
    RETURN 'Silver Load Completed Successfully. Rows Loaded : '
            || V_SILVER_ROWS;

EXCEPTION

WHEN OTHER THEN

    UPDATE AUDIT.ETL_BATCH_LOG
    SET
        STATUS = 'FAILED',
        ERROR_MESSAGE = SQLERRM,
        LOAD_END_TIME = CURRENT_TIMESTAMP()
    WHERE BATCH_ID = :P_BATCH_ID;

    RETURN 'Silver Load Failed : ' || SQLERRM;

END;
$$;



----call the procedure to load the data into silver
CALL AUDIT.SP_LOAD_SILVER('BATCH_2023_05');