/**********************************************************************
Project      : Enterprise Snowflake Migration
Sprint       : 5
Layer        : Silver
Script       : 01_create_silver_table.sql

Purpose:
Creates the SILVER.TRIPS table for standardized and cleansed trip data.

Source:
BRONZE.RAW_TRIPS

Target:
SILVER.TRIPS

Author       : Raju Nalla
Version      : 1.0
**********************************************************************/

CREATE OR REPLACE TABLE TRIPS (

    VendorID NUMBER NOT NULL,
    pickup_datetime TIMESTAMP_NTZ NOT NULL,
    dropoff_datetime TIMESTAMP_NTZ NOT NULL,
    passenger_count NUMBER NOT NULL,
    RateCodeID NUMBER,
    store_and_fwd_flag STRING,
    PULocationID NUMBER,
    DOLocationID NUMBER,
    payment_type NUMBER,
    trip_distance FLOAT,
    fare_amount FLOAT,
    extra FLOAT,
    mta_tax FLOAT,
    tip_amount FLOAT,
    tolls_amount FLOAT,
    improvement_surcharge FLOAT,
    total_amount FLOAT,
    congestion_surcharge FLOAT,
    airport_fee FLOAT,

    -----------------------------
    -- Metadata
    -----------------------------

    LOAD_TIMESTAMP TIMESTAMP_NTZ,
    ETL_UPDATED_TIMESTAMP TIMESTAMP_NTZ,
    SOURCE_FILE_NAME STRING,
    LOAD_BATCH_ID STRING,
    RECORD_SOURCE STRING

);