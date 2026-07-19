CREATE OR REPLACE PROCEDURE AUDIT.SP_LOAD_BRONZE
(
    P_FILE_PATH STRING,
    P_BATCH_ID  STRING
)
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    V_SQL            STRING;
    V_BATCH_EXISTS   NUMBER DEFAULT 0;
    V_BRONZE_ROWS    NUMBER DEFAULT 0;
    V_FILE_NAME      STRING;
BEGIN

    ------------------------------------------------------------------
    -- Extract File Name
    ------------------------------------------------------------------
    V_FILE_NAME := SPLIT_PART(P_FILE_PATH,'/',3);

    ------------------------------------------------------------------
    -- Check if Batch Already Processed
    ------------------------------------------------------------------
    SELECT COUNT(*)
      INTO :V_BATCH_EXISTS
    FROM AUDIT.ETL_BATCH_LOG
    WHERE BATCH_ID = :P_BATCH_ID
      AND STATUS = 'SUCCESS';

    IF (V_BATCH_EXISTS > 0) THEN
        RETURN 'Batch ' || P_BATCH_ID || ' has already been processed.';
    END IF;

    ------------------------------------------------------------------
    -- Insert STARTED Record
    ------------------------------------------------------------------
    INSERT INTO AUDIT.ETL_BATCH_LOG
    (
        BATCH_ID,
        FILE_NAME,
        FILE_PATH,
        SOURCE_LAYER,
        LOAD_START_TIME,
        STATUS,
        CREATED_ON
    )
    VALUES
    (
        :P_BATCH_ID,
        :V_FILE_NAME,
        :P_FILE_PATH,
        'BRONZE',
        CURRENT_TIMESTAMP(),
        'STARTED',
        CURRENT_TIMESTAMP()
    );

    ------------------------------------------------------------------
    -- Build Dynamic COPY Statement
    ------------------------------------------------------------------
    V_SQL :=
    'COPY INTO BRONZE.RAW_TRIPS
    FROM
    (
        SELECT
            $1:VendorID,
            $1:tpep_pickup_datetime,
            $1:tpep_dropoff_datetime,
            $1:passenger_count,
            $1:trip_distance,
            $1:RatecodeID,
            $1:store_and_fwd_flag,
            $1:PULocationID,
            $1:DOLocationID,
            $1:payment_type,
            $1:fare_amount,
            $1:extra,
            $1:mta_tax,
            $1:tip_amount,
            $1:tolls_amount,
            $1:improvement_surcharge,
            $1:total_amount,
            $1:congestion_surcharge,
            $1:Airport_fee,
            CURRENT_TIMESTAMP(),
            METADATA$FILENAME,
            ''' || P_BATCH_ID || ''',
            ''NYC_TAXI''
        FROM @NYC_TAXI_DB.AUDIT.NYC_INTERNAL_STAGE/' || P_FILE_PATH || '
    )
    FILE_FORMAT = (
        FORMAT_NAME = ''NYC_TAXI_DB.AUDIT.NYC_PARQUET_FORMAT''
    )
    FORCE = TRUE
    ON_ERROR = ''ABORT_STATEMENT'';';

    ------------------------------------------------------------------
    -- Execute COPY
    ------------------------------------------------------------------
    EXECUTE IMMEDIATE V_SQL;

    ------------------------------------------------------------------
    -- Count Loaded Rows
    ------------------------------------------------------------------
    SELECT COUNT(*)
      INTO :V_BRONZE_ROWS
    FROM BRONZE.RAW_TRIPS
    WHERE LOAD_BATCH_ID = :P_BATCH_ID;

    ------------------------------------------------------------------
    -- Update Success Log
    ------------------------------------------------------------------
    UPDATE AUDIT.ETL_BATCH_LOG
    SET
        LOAD_END_TIME = CURRENT_TIMESTAMP(),
        BRONZE_ROWS   = :V_BRONZE_ROWS,
        STATUS         = 'SUCCESS'
    WHERE BATCH_ID = :P_BATCH_ID;

    RETURN 'Bronze Load Completed Successfully. Rows Loaded : '
           || V_BRONZE_ROWS;

EXCEPTION
WHEN OTHER THEN

    UPDATE AUDIT.ETL_BATCH_LOG
    SET
        LOAD_END_TIME = CURRENT_TIMESTAMP(),
        STATUS         = 'FAILED',
        ERROR_MESSAGE  = SQLERRM
    WHERE BATCH_ID = :P_BATCH_ID;

    RETURN 'Bronze Load Failed : ' || SQLERRM;

END;
$$;


--call the procedure to load the data into bronze
CALL AUDIT.SP_LOAD_BRONZE(
    '2023/05/yellow_tripdata_2023-05.parquet',
    'BATCH_2023_05'
);