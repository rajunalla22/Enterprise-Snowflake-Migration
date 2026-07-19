/*==============================================================================
Project      : NYC Taxi Analytics
Layer        : Stream
Script       : 02_validate_stream.sql
Description  : Validates the Stream after data changes.
==============================================================================*/

-- Check Stream Contents
SELECT *
FROM SILVER.TRIPS_STREAM
LIMIT 100;

-- Number of Pending Changes
SELECT COUNT(*) AS PENDING_ROWS
FROM SILVER.TRIPS_STREAM;

-- Verify Stream Metadata
SHOW STREAMS;