USE ROLE ACCOUNTADMIN;
USE WAREHOUSE NYC_WH;
USE DATABASE NYC_TAXI_DB;
USE SCHEMA GOLD;

CREATE OR REPLACE TABLE FACT_TRIPS
(
    -----------------------------
    -- Dimension Keys
    -----------------------------
    DATE_KEY                NUMBER NOT NULL,
    PICKUP_LOCATION_ID      NUMBER NOT NULL,
    DROPOFF_LOCATION_ID     NUMBER NOT NULL,

    -----------------------------
    -- Event Timestamps
    -----------------------------
    PICKUP_DATETIME         TIMESTAMP_NTZ NOT NULL,
    DROPOFF_DATETIME        TIMESTAMP_NTZ NOT NULL,

    -----------------------------
    -- Business Attributes
    -----------------------------
    VENDOR_ID               NUMBER,
    RATE_CODE_ID            NUMBER,
    PAYMENT_TYPE            NUMBER,

    -----------------------------
    -- Measures
    -----------------------------
    PASSENGER_COUNT         NUMBER,
    TRIP_DISTANCE           FLOAT,
    FARE_AMOUNT             NUMBER(10,2),
    EXTRA                   NUMBER(10,2),
    MTA_TAX                 NUMBER(10,2),
    TIP_AMOUNT              NUMBER(10,2),
    TOLLS_AMOUNT            NUMBER(10,2),
    IMPROVEMENT_SURCHARGE   NUMBER(10,2),
    TOTAL_AMOUNT            NUMBER(10,2),
    CONGESTION_SURCHARGE    NUMBER(10,2),
    AIRPORT_FEE             NUMBER(10,2),

    -----------------------------
    -- Technical Metadata
    -----------------------------
    LOAD_TIMESTAMP          TIMESTAMP_NTZ,
    LOAD_BATCH_ID           STRING,
    RECORD_SOURCE           STRING
);





CREATE TABLE GOLD.FACT_TRIPS
(
    /*=========================================
      Business Key
    =========================================*/
    TRIP_HASH_KEY VARCHAR(64),
    /*=========================================
      Dimension Keys
    =========================================*/
    DATE_KEY NUMBER(8),
    PICKUP_LOCATION_ID NUMBER,
    DROPOFF_LOCATION_ID NUMBER,
    /*=========================================
      Trip Information
    =========================================*/
    PICKUP_DATETIME TIMESTAMP_NTZ,
    DROPOFF_DATETIME TIMESTAMP_NTZ,
    VENDOR_ID NUMBER,
    RATE_CODE_ID NUMBER,
    PAYMENT_TYPE NUMBER,
    PASSENGER_COUNT NUMBER,
    TRIP_DISTANCE FLOAT,
    FARE_AMOUNT FLOAT,
    EXTRA FLOAT,
    MTA_TAX FLOAT,
    TIP_AMOUNT FLOAT,
    TOLLS_AMOUNT FLOAT,
    IMPROVEMENT_SURCHARGE FLOAT,
    TOTAL_AMOUNT FLOAT,
    CONGESTION_SURCHARGE FLOAT,
    AIRPORT_FEE FLOAT,
    /*=========================================
      Audit Columns
    =========================================*/
    LOAD_TIMESTAMP TIMESTAMP_NTZ,
    LOAD_BATCH_ID STRING,
    RECORD_SOURCE STRING
);