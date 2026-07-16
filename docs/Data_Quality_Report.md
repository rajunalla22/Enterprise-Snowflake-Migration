# Data Quality Report

## Issue 1

Date:
Sprint 5

Problem

Invalid numeric value 'N'

Cause

Source file contained alphabetic value.

Resolution

TRY_TO_NUMBER() used.

Status

Resolved

--------------------------------------

## Issue 2

Date:
Sprint 6

Problem

NULL values loaded.

Cause

Incorrect table recreation.

Resolution

Recreated tables and reloaded.

Status

Resolved

--------------------------------------

## Issue 3

Date:
Sprint 7

Problem

Five records from 2008/2009.

Cause

Source data anomaly.

Resolution

Confirmed source issue.
Excluded naturally from Gold using DIM_DATE join.

Status

Documented