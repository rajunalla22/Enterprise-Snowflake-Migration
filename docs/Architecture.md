# Enterprise Snowflake Migration Architecture

This document describes the architecture of the Enterprise Snowflake Migration Project.

CSV Files
     │
     ▼
Internal Stage
     │
     ▼
SP_LOAD_BRONZE
     │
     ▼
BRONZE.RAW_TRIPS
     │
     ▼
SP_LOAD_SILVER
     │
     ▼
SILVER.TRIPS
     │
     ▼
VW_TRIPS_TRANSFORMED
     │
     ▼
SP_LOAD_GOLD
     │
     ▼
GOLD.FACT_TRIPS
     │
     ▼
AUDIT.ETL_BATCH_LOG