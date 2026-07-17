/*==============================================================================
Project      : NYC Taxi Analytics
Layer        : Bronze
Script       : 03_create_bronze_table.sql
Author       : Raju Nalla
Description  : Creates the RAW_TRIPS table to store raw data without any
               business transformations.

Execution    : One Time
Dependencies : File Format
==============================================================================*/


CREATE OR REPLACE  TABLE RAW_TRIPS (
    VendorID                 NUMBER,
    tpep_pickup_datetime     NUMBER,
    tpep_dropoff_datetime    NUMBER,
    passenger_count          VARIANT,
    trip_distance            FLOAT,
    RatecodeID               VARIANT,
    store_and_fwd_flag       STRING,
    PULocationID             NUMBER,
    DOLocationID             NUMBER,
    payment_type             NUMBER,
    fare_amount              FLOAT,
    extra                    FLOAT,
    mta_tax                  FLOAT,
    tip_amount               FLOAT,
    tolls_amount             FLOAT,
    improvement_surcharge    FLOAT,
    total_amount             FLOAT,
    congestion_surcharge     FLOAT,
    airport_fee              FLOAT,

    -- Technical Metadata
    LOAD_TIMESTAMP           TIMESTAMP_NTZ,
    SOURCE_FILE_NAME         STRING,
    LOAD_BATCH_ID            STRING,
    RECORD_SOURCE            STRING
);