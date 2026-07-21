# 🚖 NYC Taxi ETL Pipeline using Snowflake

## 📌 Project Overview

This project demonstrates an end-to-end ETL pipeline built using **Snowflake** following the **Medallion Architecture (Bronze → Silver → Gold)**.

The pipeline ingests NYC Taxi trip data from Parquet files stored in a Snowflake Internal Stage, performs data validation and transformation, loads dimensional and fact tables, and maintains a complete audit trail for every batch execution.

The entire ETL process is orchestrated through a single stored procedure, making the solution reusable, scalable, and easy to maintain.

---

# 🏗️ Architecture

```text
                    NYC Taxi Parquet Files
                             │
                             ▼
                  Snowflake Internal Stage
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
                     │               │
                     ▼               ▼
              DIM_DATE         DIM_LOCATION
                             │
                             ▼
                 AUDIT.ETL_BATCH_LOG
```

---

# 🎯 Objectives

- Build an enterprise-style ETL pipeline in Snowflake.
- Implement Medallion Architecture.
- Perform batch-wise data ingestion.
- Apply business validations.
- Load analytical dimension and fact tables.
- Maintain audit and monitoring framework.
- Demonstrate reusable stored procedures.

---

# 🛠️ Technology Stack

- Snowflake
- SQL Stored Procedures
- Snowflake Internal Stage
- Snowflake Views
- MERGE Statement
- COPY INTO
- Parquet Files
- Batch Processing
- Dimensional Modeling
- Git & GitHub

---

# 📂 Project Structure

```
Snowflake-NYC-Taxi-ETL
│
├── README.md
│
├── docs
│   ├── PROJECT_JOURNAL.md
│   ├── Architecture.png
│   └── Project_Overview.md
│
├── sql
│   ├── database_setup.sql
│   ├── file_format.sql
│   ├── internal_stage.sql
│   │
│   ├── bronze
│   │     ├── bronze_table.sql
│   │     └── sp_load_bronze.sql
│   │
│   ├── silver
│   │     ├── silver_table.sql
│   │     ├── sp_load_silver.sql
│   │     └── vw_trips_transformed.sql
│   │
│   ├── gold
│   │     ├── dim_date.sql
│   │     ├── dim_location.sql
│   │     ├── fact_trips.sql
│   │     └── sp_load_gold.sql
│   │
│   ├── audit
│   │     ├── audit_table.sql
│   │     └── sp_run_pipeline.sql
│   │
│   └── sample_queries.sql
│
└── data
    └── taxi_zone_lookup.csv
```

---

# ⚙️ ETL Pipeline Flow

### Bronze Layer

- Loads raw Parquet files.
- Stores source data without transformations.
- Captures metadata columns.
- Maintains audit information.

### Silver Layer

Applies business validations including:

- Remove NULL values
- Validate Pickup & Dropoff timestamps
- Remove invalid trip distances
- Remove invalid fare amounts
- Validate pickup time < dropoff time

### Gold Layer

Builds analytical data model.

Creates:

- DIM_DATE
- DIM_LOCATION
- FACT_TRIPS

Implements:

- SHA-256 Trip Business Key
- MERGE-based loading
- Batch-wise processing

---

# 📊 Audit Framework

The project maintains complete ETL execution details.

Captured information:

- Batch ID
- File Name
- File Path
- Load Start Time
- Load End Time
- Bronze Rows
- Silver Rows
- Gold Rows
- Status
- Error Message

---

# 🚀 Running the Pipeline

Execute the complete ETL using a single stored procedure.

```sql
CALL AUDIT.SP_RUN_PIPELINE(
'2023/01/yellow_tripdata_2023-01.parquet'
);
```

---

# ✅ Sample Execution Result

| Layer | Rows Loaded |
|--------|------------:|
| Bronze | 3,066,766 |
| Silver | 2,998,277 |
| Gold | 2,998,277 |

Pipeline Status

```
SUCCESS
```

---

# ✨ Key Features

- End-to-End Snowflake ETL Pipeline
- Medallion Architecture
- Batch Processing
- Dynamic File Loading
- Stored Procedure-based Orchestration
- Data Validation
- SHA-256 Business Key Generation
- MERGE-based Fact Loading
- Audit Logging
- Exception Handling
- Reusable SQL Components

---

# 📚 Key Learnings

During development, several real-world engineering challenges were identified and resolved, including:

- Batch duplicate handling
- Audit framework implementation
- Stored procedure orchestration
- Gold layer MERGE optimization
- Snowflake Streams evaluation
- Performance tuning
- ETL debugging techniques

These experiences helped build a production-style Snowflake ETL solution.

---

# 📈 Future Enhancements

- Snowflake Tasks for scheduling
- Snowflake Streams for incremental CDC
- Metadata-driven framework
- Notification framework
- CI/CD deployment using GitHub Actions
- Data Quality Dashboard
- Performance Monitoring

---

# 👨‍💻 Author

**Raju Nalla**

Data Engineer | Snowflake | SQL | Python | Azure

---

# ⭐ If you found this project helpful

Feel free to ⭐ the repository and connect with me on LinkedIn.