CREATE OR REPLACE PROCEDURE AUDIT.SP_LOAD_GOLD
(
    P_BATCH_ID STRING
)
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$

DECLARE

    V_BATCH_EXISTS      NUMBER DEFAULT 0;
    V_DIM_DATE_COUNT    NUMBER DEFAULT 0;
    V_DIM_LOCATION_COUNT NUMBER DEFAULT 0;
    V_GOLD_ROWS         NUMBER DEFAULT 0;

BEGIN

    ------------------------------------------------------------------
    -- Validate Batch
    ------------------------------------------------------------------

    SELECT COUNT(*)
    INTO :V_BATCH_EXISTS
    FROM AUDIT.ETL_BATCH_LOG
    WHERE BATCH_ID = :P_BATCH_ID
      AND STATUS = 'SUCCESS';

    IF (V_BATCH_EXISTS = 0) THEN
        RETURN 'ERROR : Invalid Batch ID or Silver Load not completed.';
    END IF;

    ------------------------------------------------------------------
    -- Load DIM_DATE (Only First Time)
    ------------------------------------------------------------------

    SELECT COUNT(*)
    INTO :V_DIM_DATE_COUNT
    FROM GOLD.DIM_DATE;

    IF (V_DIM_DATE_COUNT = 0) THEN

        INSERT INTO GOLD.DIM_DATE
        (
            DATE_KEY,
            FULL_DATE,
            YEAR,
            QUARTER,
            MONTH,
            MONTH_NAME,
            DAY,
            DAY_NAME,
            WEEKDAY_FLAG
        )

        SELECT
            TO_NUMBER(TO_CHAR(DATE_VALUE,'YYYYMMDD')),
            DATE_VALUE,
            YEAR(DATE_VALUE),
            QUARTER(DATE_VALUE),
            MONTH(DATE_VALUE),
            MONTHNAME(DATE_VALUE),
            DAY(DATE_VALUE),
            DAYNAME(DATE_VALUE),
            CASE
                WHEN DAYOFWEEKISO(DATE_VALUE) IN (6,7)
                THEN FALSE
                ELSE TRUE
            END

        FROM
        (
            SELECT
                DATEADD(
                    DAY,
                    ROW_NUMBER() OVER(ORDER BY SEQ4())-1,
                    '2023-01-01'
                ) DATE_VALUE

            FROM TABLE(GENERATOR(ROWCOUNT=>365))
        );

    END IF;

    ------------------------------------------------------------------
    -- Load DIM_LOCATION (Only First Time)
    ------------------------------------------------------------------

    SELECT COUNT(*)
    INTO :V_DIM_LOCATION_COUNT
    FROM GOLD.DIM_LOCATION;

    IF (V_DIM_LOCATION_COUNT = 0) THEN

        INSERT INTO GOLD.DIM_LOCATION
        (
            LOCATION_ID,
            BOROUGH,
            ZONE,
            SERVICE_ZONE,
            LOAD_TIMESTAMP
        )

        SELECT
            $1,
            $2,
            $3,
            $4,
            CURRENT_TIMESTAMP()

        FROM
        @AUDIT.NYC_INTERNAL_STAGE/taxi_zone_lookup.csv
        (
            FILE_FORMAT => AUDIT.CSV_FILE_FORMAT
        );

    END IF;

    ------------------------------------------------------------------
    -- Check silver Table
    ------------------------------------------------------------------

    SELECT COUNT(*)
    INTO :V_GOLD_ROWS
    FROM SILVER.VW_TRIPS_TRANSFORMED
    WHERE LOAD_BATCH_ID = :P_BATCH_ID;
    
    IF (V_GOLD_ROWS = 0) THEN
        RETURN 'No Records Found For Gold Load.';
    END IF;

    ------------------------------------------------------------------
    -- MERGE FACT TABLE
    ------------------------------------------------------------------

    MERGE INTO GOLD.FACT_TRIPS TARGET

    USING
    (
        SELECT *
        FROM SILVER.VW_TRIPS_TRANSFORMED
        WHERE LOAD_BATCH_ID = :P_BATCH_ID
    ) SOURCE
    
    ON TARGET.TRIP_HASH_KEY = SOURCE.TRIP_HASH_KEY
    
    WHEN MATCHED THEN
    UPDATE SET
    
        TARGET.DATE_KEY                = SOURCE.DATE_KEY,
        TARGET.PICKUP_LOCATION_ID      = SOURCE.PICKUP_LOCATION_ID,
        TARGET.DROPOFF_LOCATION_ID     = SOURCE.DROPOFF_LOCATION_ID,
        TARGET.PICKUP_DATETIME         = SOURCE.PICKUP_DATETIME,
        TARGET.DROPOFF_DATETIME        = SOURCE.DROPOFF_DATETIME,
        TARGET.VENDOR_ID               = SOURCE.VENDOR_ID,
        TARGET.RATE_CODE_ID            = SOURCE.RATE_CODE_ID,
        TARGET.PAYMENT_TYPE            = SOURCE.PAYMENT_TYPE,
        TARGET.PASSENGER_COUNT         = SOURCE.PASSENGER_COUNT,
        TARGET.TRIP_DISTANCE           = SOURCE.TRIP_DISTANCE,
        TARGET.FARE_AMOUNT             = SOURCE.FARE_AMOUNT,
        TARGET.EXTRA                   = SOURCE.EXTRA,
        TARGET.MTA_TAX                 = SOURCE.MTA_TAX,
        TARGET.TIP_AMOUNT              = SOURCE.TIP_AMOUNT,
        TARGET.TOLLS_AMOUNT            = SOURCE.TOLLS_AMOUNT,
        TARGET.IMPROVEMENT_SURCHARGE   = SOURCE.IMPROVEMENT_SURCHARGE,
        TARGET.TOTAL_AMOUNT            = SOURCE.TOTAL_AMOUNT,
        TARGET.CONGESTION_SURCHARGE    = SOURCE.CONGESTION_SURCHARGE,
        TARGET.AIRPORT_FEE             = SOURCE.AIRPORT_FEE,
        TARGET.LOAD_TIMESTAMP          = CURRENT_TIMESTAMP(),
        TARGET.LOAD_BATCH_ID           = SOURCE.LOAD_BATCH_ID,
        TARGET.RECORD_SOURCE           = SOURCE.RECORD_SOURCE
    
    WHEN NOT MATCHED THEN
    
    INSERT
    (
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
    )
    
    VALUES
    (
        SOURCE.TRIP_HASH_KEY,
        SOURCE.DATE_KEY,
        SOURCE.PICKUP_LOCATION_ID,
        SOURCE.DROPOFF_LOCATION_ID,
        SOURCE.PICKUP_DATETIME,
        SOURCE.DROPOFF_DATETIME,
        SOURCE.VENDOR_ID,
        SOURCE.RATE_CODE_ID,
        SOURCE.PAYMENT_TYPE,
        SOURCE.PASSENGER_COUNT,
        SOURCE.TRIP_DISTANCE,
        SOURCE.FARE_AMOUNT,
        SOURCE.EXTRA,
        SOURCE.MTA_TAX,
        SOURCE.TIP_AMOUNT,
        SOURCE.TOLLS_AMOUNT,
        SOURCE.IMPROVEMENT_SURCHARGE,
        SOURCE.TOTAL_AMOUNT,
        SOURCE.CONGESTION_SURCHARGE,
        SOURCE.AIRPORT_FEE,
        SOURCE.LOAD_TIMESTAMP,
        SOURCE.LOAD_BATCH_ID,
        SOURCE.RECORD_SOURCE
    );

    ------------------------------------------------------------------
    -- Audit
    ------------------------------------------------------------------

    SELECT COUNT(*)
    INTO :V_GOLD_ROWS
    FROM GOLD.FACT_TRIPS
    WHERE LOAD_BATCH_ID = :P_BATCH_ID;

    UPDATE AUDIT.ETL_BATCH_LOG
    SET
        GOLD_ROWS = :V_GOLD_ROWS
    WHERE BATCH_ID = :P_BATCH_ID;

    RETURN
        'Gold Load Completed Successfully. Rows Loaded : '
        || V_GOLD_ROWS;

EXCEPTION

    WHEN OTHER THEN

        RETURN
            'Gold Load Failed : '
            || SQLERRM;

END;

$$;