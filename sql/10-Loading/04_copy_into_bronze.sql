COPY INTO BRONZE.RAW_TRIPS
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
        $1:airport_fee,
        CURRENT_TIMESTAMP(),
        METADATA$FILENAME,
        '20260716_BATCH001',
        'NYC_INTERNAL_STAGE'
    FROM @NYC_TAXI_DB.AUDIT.NYC_INTERNAL_STAGE/2023/01/
)
FILE_FORMAT = (
    FORMAT_NAME = 'NYC_TAXI_DB.AUDIT.NYC_PARQUET_FORMAT'
)
ON_ERROR = 'ABORT_STATEMENT';


--2nd moth
COPY INTO BRONZE.RAW_TRIPS
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
        $1:airport_fee,
        CURRENT_TIMESTAMP(),
        METADATA$FILENAME,
        '20260716_BATCH001',
        'NYC_INTERNAL_STAGE'
    FROM @NYC_TAXI_DB.AUDIT.NYC_INTERNAL_STAGE/2023/02/
)
FILE_FORMAT = (
    FORMAT_NAME = 'NYC_TAXI_DB.AUDIT.NYC_PARQUET_FORMAT'
)
ON_ERROR = 'ABORT_STATEMENT';


--3rd month

COPY INTO BRONZE.RAW_TRIPS
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
        $1:airport_fee,
        CURRENT_TIMESTAMP(),
        METADATA$FILENAME,
        '20260716_BATCH001',
        'NYC_INTERNAL_STAGE'
    FROM @NYC_TAXI_DB.AUDIT.NYC_INTERNAL_STAGE/2023/03/
)
FILE_FORMAT = (
    FORMAT_NAME = 'NYC_TAXI_DB.AUDIT.NYC_PARQUET_FORMAT'
)
ON_ERROR = 'ABORT_STATEMENT';