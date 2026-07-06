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