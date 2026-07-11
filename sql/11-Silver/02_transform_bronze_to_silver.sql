INSERT INTO SILVER.TRIPS (
VendorID,
pickup_datetime,
dropoff_datetime,
passenger_count,
RateCodeID,
store_and_fwd_flag,
pulocationid,
dolocationid,
payment_type,
trip_distance,
fare_amount,
extra,
mta_tax,
tip_amount,
tolls_amount,
improvement_surcharge,
total_amount,
congestion_surcharge,
airport_fee,
LOAD_TIMESTAMP ,
ETL_UPDATED_TIMESTAMP,
SOURCE_FILE_NAME,
LOAD_BATCH_ID,
record_source
)
SELECT 
VendorID,
TO_TIMESTAMP_NTZ(tpep_pickup_datetime / 1000000),
TO_TIMESTAMP_NTZ(tpep_dropoff_datetime / 1000000),
Passenger_count :: NUMBER,
RateCodeID :: NUMBER,
store_and_fwd_flag,
pulocationid,
dolocationid,
Payment_Type,
Trip_Distance,
Fare_Amount :: FLOAT,
Extra :: NUMBER(10,2),
Mta_tax :: NUMBER(10,2),
Tip_Amount :: NUMBER(10,2),
Tolls_Amount :: NUMBER(10,2),
Improvement_Surcharge :: NUMBER(10,2),
total_amount :: NUMBER(10,2),
Congestion_Surcharge :: NUMBER(10,2),
Airport_Fee :: NUMBER(10,2),

current_timestamp() as LOAD_TIMESTAMP,
current_timestamp() as ETL_UPDATED_TIMESTAMP,
source_file_name,
20260708_BATCH001,
record_source
FROM 
BRONZE.RAW_TRIPS
WHERE
    TO_TIMESTAMP_NTZ(tpep_pickup_datetime / 1000000)
        BETWEEN '2023-01-01' AND '2023-12-31'
AND TO_TIMESTAMP_NTZ(tpep_dropoff_datetime / 1000000)
        BETWEEN '2023-01-01' AND '2023-12-31'
AND fare_amount >= 0
AND total_amount >= 0
AND trip_distance >= 0;