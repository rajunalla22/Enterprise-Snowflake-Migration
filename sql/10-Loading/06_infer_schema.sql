USE ROLE ACCOUNTADMIN;
USE WAREHOUSE NYC_WH;
USE DATABASE NYC_TAXI_DB;
USE SCHEMA AUDIT;


-- Infer schema from Parquet files
SELECT * from Table (
    INFER_SCHEMA(
    Location => '@NYC_INTERNAL_STAGE', 
    File_Format => 'NYC_PARQUET_FORMAT'
    )
);