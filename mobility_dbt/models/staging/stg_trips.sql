-- Staging model: clean and standardise raw NYC taxi trips
-- Filters bad data, renames columns, adds time dimensions

WITH source AS (
    SELECT
        vendor_id,
        pickup_datetime,
        dropoff_datetime,
        passenger_count,
        trip_distance,
        pickup_location_id,
        dropoff_location_id,
        fare_amount,
        tip_amount,
        total_amount,
        payment_type
    FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
    WHERE
        fare_amount BETWEEN 2.50 AND 500
        AND trip_distance BETWEEN 0.1 AND 100
        AND pickup_datetime IS NOT NULL
        AND dropoff_datetime IS NOT NULL
),

cleaned AS (
    SELECT
        vendor_id,
        pickup_datetime,
        dropoff_datetime,
        passenger_count,
        trip_distance,
        pickup_location_id,
        dropoff_location_id,
        fare_amount,
        tip_amount,
        total_amount,
        payment_type,

        -- Time dimensions
        DATE(pickup_datetime)                    AS trip_date,
        EXTRACT(YEAR FROM pickup_datetime)        AS trip_year,
        EXTRACT(MONTH FROM pickup_datetime)       AS trip_month,
        EXTRACT(HOUR FROM pickup_datetime)        AS pickup_hour,
        EXTRACT(DAYOFWEEK FROM pickup_datetime)   AS day_of_week,

        -- Derived metrics
        ROUND(tip_amount / NULLIF(fare_amount, 0) * 100, 2) AS tip_rate_pct,
        TIMESTAMP_DIFF(dropoff_datetime,
            pickup_datetime, MINUTE)              AS trip_duration_mins,

        -- Time of day segment
        CASE
            WHEN EXTRACT(HOUR FROM pickup_datetime) BETWEEN 7 AND 9
                THEN 'Morning Rush'
            WHEN EXTRACT(HOUR FROM pickup_datetime) BETWEEN 17 AND 19
                THEN 'Evening Rush'
            WHEN EXTRACT(HOUR FROM pickup_datetime) BETWEEN 22 AND 23
                OR EXTRACT(HOUR FROM pickup_datetime) BETWEEN 0 AND 2
                THEN 'Late Night'
            ELSE 'Off Peak'
        END AS time_segment,

        -- Trip distance segment
        CASE
            WHEN trip_distance >= 20   THEN 'Long Haul'
            WHEN trip_distance >= 10   THEN 'Medium-Long'
            WHEN trip_distance >= 5    THEN 'Medium'
            WHEN trip_distance >= 2    THEN 'Short'
            ELSE 'Very Short'
        END AS distance_segment

    FROM source
)

SELECT * FROM cleaned