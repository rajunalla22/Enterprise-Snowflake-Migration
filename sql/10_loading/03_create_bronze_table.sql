USE ROLE ACCOUNTADMIN;
USE WAREHOUSE NYC_WH;
USE DATABASE NYC_TAXI_DB;
USE SCHEMA BRONZE;

----------------------------------------------------
-- Load Bronze Layer
----------------------------------------------------

COPY INTO RAW_TRIPS
FROM
(
    SELECT
        $1:VendorID,
        $1:tpep_pickup_datetime,
        $1:tpep_dropoff_datetime,
        $1:passenger_count,
        $1:trip_distance,
        $1:RateCodeID,
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
        $1:airport_fee,
        CURRENT_TIMESTAMP(),
        METADATA$FILENAME,
        '20260708_BATCH001',
        'NYC_INTERNAL_STAGE'
    FROM @NYC_TAXI_DB.AUDIT.NYC_INTERNAL_STAGE
)
FILE_FORMAT = (
    FORMAT_NAME = 'NYC_TAXI_DB.AUDIT.NYC_PARQUET_FORMAT'
)
ON_ERROR = 'ABORT_STATEMENT';