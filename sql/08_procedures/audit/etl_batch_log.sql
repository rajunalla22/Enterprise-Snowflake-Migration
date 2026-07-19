/*==============================================================================
Project      : NYC Taxi Analytics
Layer        : Audit
Script       : etl_batch_log.sql
Author       : Raju Nalla

Description  :
Stores one record for every file processed through the ETL pipeline.
==============================================================================*/


CREATE OR REPLACE TABLE AUDIT.ETL_BATCH_LOG
(
    BATCH_ID           VARCHAR,
    FILE_NAME          VARCHAR,
    FILE_PATH          VARCHAR,
    SOURCE_LAYER       VARCHAR,
    LOAD_START_TIME    TIMESTAMP_NTZ,
    LOAD_END_TIME      TIMESTAMP_NTZ,
    BRONZE_ROWS        NUMBER,
    SILVER_ROWS        NUMBER,
    GOLD_ROWS          NUMBER,
    STATUS             VARCHAR,
    ERROR_MESSAGE      VARCHAR,
    CREATED_ON         TIMESTAMP_NTZ
);