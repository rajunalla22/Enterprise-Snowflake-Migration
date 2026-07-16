# Project Journal

## Sprint 1

- Project initialized
- Git configured
- AWS account created
- Snowflake account created
- Created Virtual Warehouse
- Created Database
- Created Schemas
 - BRONZE
  - SILVER
  - GOLD
  - STAGE
  - AUDIT
- Created ETL_ROLE
- Created ANALYST_ROLE
- Created BI_ROLE
- Granted Warehouse Access
- Granted Database Access
- Granted Schema Access
- Configured Resource Monitor



#### Learned
- Difference between Compute and Storage
- Virtual Warehouse lifecycle
- Why schemas are used
- Medallion Architecture
- Snowflake RBAC hierarchy
- Difference between ACCOUNTADMIN and SECURITYADMIN
- Principle of Least Privilege
- Granting warehouse privileges
- Granting database privileges
- Granting schema privileges
- Snowflake RBAC
- Principle of Least Privilege
- Resource Monitors
- Credit Governance

#### Challenges
- Git remote configuration issue
- Fixed GitHub connection
- Learned how to configure origin

#### Next Steps
- AWS S3


## Sprint 2

### Completed

- Created AWS S3 bucket
- Designed enterprise folder structure
- Uploaded NYC Yellow Taxi January–April 2023 dataset

### Learned

- Enterprise Landing Zone design
- S3 bucket organization
- Raw data ingestion concepts

### Next Steps


## Sprint 3

### Completed
- Created AWS IAM Role
- Created Policy which Allows Snowflake Storage Integration to read NYC Taxi data from S3. 
- Switched to Internal Stage
- Uploaded files successfully

### Learned

- AWS S3 folder hierarchy
- AWS Role & Policy
- Internal Stage creation

### Challenges

- Encountered AWS IAM AssumeRole authorization issue during Snowflake Storage Integration.
- Investigated IAM Role, IAM Policy, Trust Relationship and External ID configuration.
- Chose to continue development using Internal Stage to avoid blocking project progress.

### Next Steps

- Create External Stage
- Create File Format
- Load Bronze Layer

## Sprint 4

### Completed
- Created Internal File Format (PARQUET)
- Used INFER_SCHEMA to discover dataset columns
- Designed BRONZE.RAW_TRIPS table
- Loaded 4 Parquet files into Bronze using COPY INTO
- Added Technical Metadata columns
- Validated successful load using audit queries

### Learned

- Internal Stage
- Parquet File Format
- INFER_SCHEMA
- COPY INTO
- Metadata Columns
- Batch Loading
- Source File Tracking
- Bronze Layer Design

### Challenges

- Understood how multiple files are loaded into one Bronze table.
- Learned why metadata columns are required for auditing and troubleshooting.

### Validation

- Total Rows : 12,672,737
- Files Loaded : 4
- Batch ID : 20260708_BATCH001

### Next Steps

- Create Silver Layer
- Convert Epoch timestamps
- Cast Variant columns
- Data Quality Checks
- Build Silver Table


## Sprint 5

### Completed
- Created SILVER.TRIPS table
- Converted Epoch timestamps to TIMESTAMP
- Converted VARIANT columns to appropriate data types
- Applied Data Quality rules
- Loaded cleaned data from Bronze to Silver

### Learned
- Bronze vs Silver layer responsibilities
- Data type conversion
- Epoch timestamp conversion
- TRY_TO_NUMBER()
- Data Quality filtering
- INSERT...SELECT transformation

### Challenges
- Encountered invalid Epoch timestamps (2001 records)
- Found non-numeric values in numeric columns
- Applied TRY_TO_NUMBER()
- Filtered invalid business records before loading Silver

### Validation
- Validated Silver row count
- Compared Bronze vs Silver records
- Verified timestamps converted correctly
- Verified metadata columns populated


### Next Steps
- Build Gold Layer
- Create Dimension Tables
- Create Fact Trips Table
- Implement Streams & Tasks

## Sprint 6

### Completed

- Created GOLD.DIM_DATE table
- Generated Date Dimension using GENERATOR()
- Loaded Date Dimension using DATEADD()
- Learned ISO week numbering behavior
- Created GOLD.DIM_LOCATION
- Created CSV File Format
- Loaded Taxi Zone Lookup into Dimension table
- Designed Star Schema
- Created GOLD.FACT_TRIPS
- Loaded Fact table from SILVER.TRIPS
- Joined Fact with DIM_DATE and DIM_LOCATION
- Performed end-to-end Gold Layer validation

### Learned

- Difference between Fact and Dimension tables
- Purpose of Star Schema
- Why Date Dimension is precomputed
- Importance of Lookup tables
- Why Dimensions are joined while loading Facts
- Difference between Natural Keys and Surrogate Keys
- How CTEs improve SQL readability
- Using INSERT INTO ... WITH in Snowflake
- Enterprise validation techniques for Gold Layer
- Referential Integrity concepts
### Challenges

- Understood why DATEADD() returns TIMESTAMP
- Resolved Snowflake INSERT + CTE syntax
- Clarified ISO week numbering behavior
- Validated DAY_OF_WEEK and IS_WEEKEND logic

### Validation

- Row Count Validation
- Fact vs Silver Count Validation
- Date Dimension Validation
- Location Dimension Validation
- Borough-wise Trip Count
- Aggregate Measure Validation
- Null Check
- Negative Value Check
- Passenger Count Validation
- Date Range Validation
- Missing Location Validation
- Missing Date Validation
- Batch Validation
- Source Validation
- Referential Integrity Validation


### Next Steps

- Create GOLD.DIM_LOCATION
- Load DIM_LOCATION from SILVER.TRIPS
- Validate DIM_LOCATION

# Sprint 7 - Incremental Loading using Snowflake Streams

## Objective
- Implement Change Data Capture using Streams.
- Create hash-based merge logic.
- Support incremental loading into Gold.
---

### Completed
- Created TRIPS_STREAM on SILVER.TRIPS.
- Created VW_TRIPS_TRANSFORMED.
- Added SHA2-256 Trip Hash Key.
- Recreated FACT_TRIPS.
- Implemented MERGE INTO.
- Validated Bronze, Silver and Gold.
- Identified and removed historical records from Silver.
- Reloaded January data from the finalized stage folder.
- Validated January, February and March row counts.
## Learning

Key understanding gained during this sprint:

- Snowflake Streams are metadata objects.
- Streams do not duplicate table data.
- Streams capture only future INSERT, UPDATE, and DELETE operations.
- Existing records present before stream creation are not tracked.
- Streams are the foundation for implementing incremental ETL pipelines.

---
  
### MERGE Statistics

Inserted Rows : 5,955,466
Updated Rows  : 0

Execution Time : ~4.2 seconds

## Validation

Completed validations:

- Stream created successfully.
- Stream visible using SHOW STREAMS.
- Stream queried successfully.
- Initial stream contains 0 rows as expected because no new DML occurred after stream creation.

### Additional Validation - February Incremental Dataset

After loading the February 2023 Parquet file into the Bronze and Silver layers, several validation checks were performed.

#### Validation Performed

- Verified total row count for January and February datasets.
- Verified source file distribution using SOURCE_FILE_NAME.
- Validated pickup date distribution.
- Identified 5 historical records (2008/2009).
- Confirmed those records originated from the source dataset rather than ETL transformation.
- Verified those records do not propagate to the Gold layer because FACT_TRIPS is loaded using an INNER JOIN with DIM_DATE.
- Verified March records (March 1, 6 and 7) exist in the source dataset and are expected.
- Verified no null values or referential integrity issues in Gold.

#### Observation

The NYC Taxi dataset contains five historical records from 2008/2009. These records remain in the Silver layer for data lineage and auditing but are naturally excluded from the Gold layer because there are no corresponding records in DIM_DATE.

This behaviour is documented as a source data anomaly rather than an ETL issue.

### Status

Initial full load completed successfully.


## Next Steps

- Simulate March incremental load
- Validate Stream captures only new records
- Execute incremental MERGE