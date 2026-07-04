# Enterprise RBAC Design

## Business Scenario

The NYC Taxi Analytics Platform will be used by multiple teams.

Each team requires different levels of access following the Principle of Least Privilege.

---

## Role Hierarchy

ACCOUNTADMIN
│
├── SECURITYADMIN
│
├── SYSADMIN
│
├── ETL_ROLE
│
├── ANALYST_ROLE
│
└── BI_ROLE

---

## ETL_ROLE

Purpose

- Data ingestion
- Data transformation
- Manage Bronze/Silver/Gold pipelines

Access

Warehouse
- NYC_WH

Database
- NYC_TAXI_DB

Schemas
- BRONZE
- SILVER
- GOLD
- STAGE
- AUDIT

Privileges

- USAGE
- CREATE TABLE
- INSERT
- UPDATE
- DELETE
- CREATE STAGE
- CREATE FILE FORMAT

---

## ANALYST_ROLE

Purpose

Business analysts

Access

Database
- NYC_TAXI_DB

Schema

- GOLD

Privileges

- SELECT
- USAGE

---

## BI_ROLE

Purpose

Power BI / Tableau

Access

Database
- NYC_TAXI_DB

Schema

- GOLD

Privileges

- SELECT only

---

## Security Principle

Principle of Least Privilege

Each role receives only the permissions required for its responsibilities.