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

### Learned

- AWS S3 folder hierarchy
- AWS Role & Policy

### Challenges

- Encountered AWS IAM AssumeRole authorization issue during Snowflake Storage Integration.
- Investigated IAM Role, IAM Policy, Trust Relationship and External ID configuration.
- Chose to continue development using Internal Stage to avoid blocking project progress.

### Next Steps

- Create External Stage
- Create File Format
- Load Bronze Layer