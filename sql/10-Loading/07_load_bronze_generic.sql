/*==============================================================================
Project      : NYC Taxi Analytics
Layer        : Bronze
Script       : 07_load_bronze_generic.sql
Author       : Raju Nalla

Description  :
Loads NYC Taxi Parquet files from the internal stage into the Bronze table.
Automatically populates audit columns required for downstream processing.

==============================================================================*/

--==========================================================================
-- Step 1 : Set Batch Variables
--==========================================================================

SET LOAD_YEAR     = '2023';
SET LOAD_MONTH    = '05';
SET LOAD_BATCH_ID = 'BATCH_2023_05';

--==========================================================================
-- Step 2 : Load Data into Bronze
--==========================================================================

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
        $1:Airport_fee,

        CURRENT_TIMESTAMP(),

        METADATA$FILENAME,

        $LOAD_BATCH_ID,

        'NYC_TAXI'

    FROM @AUDIT.NYC_INTERNAL_STAGE/2023/05
)
FILE_FORMAT = (FORMAT_NAME = AUDIT.NYC_PARQUET_FORMAT)
ON_ERROR = 'ABORT_STATEMENT';




-- =====================================================
-- Execute Bronze Load
-- =====================================================

CALL AUDIT.SP_LOAD_BRONZE
(
    '2023/05/yellow_tripdata_2023-05.parquet',
    'BATCH_2023_05'
);

SELECT *
FROM AUDIT.ETL_BATCH_LOG;