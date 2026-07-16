# Troubleshooting

This document contains issues encountered during the project, investigation performed, and their current status.

---

# Sprint 3

## Issue 1: Snowflake Storage Integration - AWS AssumeRole Failure

### Problem
While configuring Snowflake Storage Integration with Amazon S3, the external stage was created successfully, but listing files from the stage failed with the following error:

```
Error assuming AWS_ROLE:
User:
arn:aws:iam::842806122230:user/rd8x1000-s

is not authorized to perform:
sts:AssumeRole

on resource:
arn:aws:iam::585384908158:role/NYC_SNOWFLAKE_STORAGE_ROLE
```

### Investigation Performed

- Created AWS S3 bucket
- Uploaded NYC Taxi Parquet datasets
- Created IAM Policy with S3 Read permissions
- Created IAM Role
- Attached IAM Policy to IAM Role
- Created Snowflake Storage Integration
- Retrieved Snowflake IAM User ARN
- Retrieved External ID
- Updated AWS Trust Relationship
- Revalidated Storage Integration

### Current Status

Storage Integration is created successfully.

External Stage is created successfully.

However, AWS is denying the AssumeRole request from the Snowflake IAM user.

The issue is currently under investigation.

### Workaround

To avoid blocking project progress, the project will continue using a Snowflake Internal Stage.

After completing the end-to-end migration project, AWS Storage Integration will be revisited and integrated as Version 2 of the project.

## Sprint 6 Issues

### Issue

INSERT statement failed when placed after CTE.

### Cause

Snowflake expects the WITH clause immediately before the SELECT statement of the INSERT.

### Resolution

Use:

INSERT INTO target_table
WITH cte AS (...)
SELECT ...
FROM cte;

instead of

WITH cte AS (...)
INSERT INTO ...



## Source Data Anomaly - Historical Taxi Records

### Problem

Validation identified five taxi trips with pickup dates in 2008/2009 after loading the February dataset.

### Investigation

- Verified timestamp conversion logic.
- Compared Bronze and Silver layers.
- Confirmed records exist in the original source file.

### Root Cause

Source dataset contains historical records.

### Resolution

No ETL changes required.

Gold layer automatically excludes these records because FACT_TRIPS joins with DIM_DATE, which contains only 2023 dates.

### Status

Resolved (Source Data Issue)


### Duplicate January Records Investigation

### Problem

- January row count appeared inconsistent.

### Investigation
- Deleted January partition.
- Reloaded using finalized COPY INTO.
- Verified stage path.
- Compared hash counts.
- Confirmed deterministic load.

### Resolution
- Accepted source dataset as authoritative after successful reload and validation.