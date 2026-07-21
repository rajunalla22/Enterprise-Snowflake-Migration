### Sprint 1 – Project Planning & Environment Setup
## Objective

- Design an end-to-end ETL pipeline using Snowflake based on the Medallion Architecture.

## Completed Activities
- Created Snowflake database NYC_TAXI_DB
- Created schemas:
- BRONZE
- SILVER
- GOLD
- AUDIT
- Configured Warehouse
- Created internal stage
- Created required file formats
- Uploaded NYC Taxi Parquet files
- Uploaded Taxi Zone Lookup CSV
- Outcome

- Project environment prepared successfully.

## Sprint 2 – Bronze Layer Development
## Objective

- Load raw NYC Taxi data into Bronze layer.

## Completed Activities

## Created

- RAW_TRIPS table
- COPY INTO implementation
- Batch processing framework
- Dynamic file loading
- Metadata columns

## Added audit columns

- LOAD_TIMESTAMP
- SOURCE_FILE_NAME
- LOAD_BATCH_ID
- RECORD_SOURCE

## Implemented

- Stored Procedure

- SP_LOAD_BRONZE()

## Features

- Dynamic COPY INTO
- Duplicate Batch Validation
- Audit Logging
- Error Handling
- Row Count Tracking
- Outcome

- Bronze layer successfully loads raw Parquet files.

## Sprint 3 – Silver Layer Development
## Objective

- Transform raw data into validated business-ready data.

## Created

- SILVER.TRIPS table

## Implemented

- SP_LOAD_SILVER()

## Business Rules

- Remove NULL records
- Validate Pickup Date
- Validate Dropoff Date
- Trip Distance > 0
- Fare Amount > 0
- Total Amount > 0
- Pickup < Dropoff

## Additional Features

- Duplicate Batch Check
- Batch-wise Processing
- Audit Update
- Exception Handling
## Outcome

- Validated business data loaded successfully into Silver layer.

## Sprint 4 – Gold Layer Development
## Objective

- Build analytical data model.

## Created

## Dimension Tables

- DIM_DATE
- DIM_LOCATION

## Fact Table

- FACT_TRIPS

- Created Transformation View

- VW_TRIPS_TRANSFORMED

## Implemented

- SP_LOAD_GOLD()

##Features

- SHA-256 Trip Business Key
- MERGE implementation
- Dimension Loading
- Fact Loading
- Batch-wise Processing
- Audit Update
## Outcome

- Gold layer successfully populated.

## Sprint 5 – Audit Framework
## Objective

- Track complete ETL execution.

## Created
- AUDIT.ETL_BATCH_LOG

## Captured

- Batch ID
- File Name
- File Path
- Start Time
- End Time
- Bronze Rows
- Silver Rows
- Gold Rows
- Status
- Error Message
- Outcome

- Complete ETL monitoring framework implemented.

## Sprint 6 – Pipeline Orchestration
## Objective

- Execute complete ETL using one stored procedure.

## Implemented

- SP_RUN_PIPELINE()

## Pipeline Flow

Generate Batch ID
        │
        ▼
Load Bronze
        │
        ▼
Load Silver
        │
        ▼
Load Gold
        │
        ▼
Update Audit

- Batch ID automatically generated from

- 2023/01/yellow_tripdata_2023-01.parquet

- to

- BATCH_2023_01
## Outcome

- Single procedure executes complete ETL.

## Sprint 7 – Debugging & Optimization
- Issues Identified
- Duplicate Silver Rows

## Issue

- Silver rows doubled after pipeline execution.

## Root Cause

- Manual execution before pipeline caused duplicate inserts.

## Solution

- Implemented duplicate batch validation inside

- SP_LOAD_SILVER()
- Gold Load Issue

## Issue

- FACT_TRIPS loaded zero rows.

## Root Cause

- Transformation view was reading from

- SILVER.TRIPS_STREAM

- The stream contained historical INSERT and DELETE records, causing incorrect source data for the MERGE.

## Solution

- Modified the transformation view to read directly from:

- SILVER.TRIPS

- instead of the stream.

- This provided a clean, batch-specific dataset for the Gold layer.

## Audit Validation

## Verified

- Bronze row counts
- Silver row counts
- Gold row counts
- Batch status updates