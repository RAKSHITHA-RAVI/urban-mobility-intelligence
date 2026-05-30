-- Mart model: daily trip aggregations for dashboards
-- Grain: one row per day per time segment

WITH staging AS (
    SELECT * FROM {{ ref('stg_trips') }}
)

SELECT
    trip_date,
    trip_year,
    trip_month,
    time_segment,
    distance_segment,
    pickup_location_id,

    -- Volume metrics
    COUNT(*)                                AS total_trips,
    SUM(passenger_count)                    AS total_passengers,

    -- Revenue metrics
    ROUND(SUM(fare_amount), 2)              AS total_fare,
    ROUND(SUM(tip_amount), 2)              AS total_tips,
    ROUND(SUM(total_amount), 2)            AS total_revenue,
    ROUND(AVG(fare_amount), 2)             AS avg_fare,
    ROUND(AVG(tip_amount), 2)             AS avg_tip,
    ROUND(AVG(tip_rate_pct), 2)           AS avg_tip_rate_pct,

    -- Distance & duration metrics
    ROUND(AVG(trip_distance), 2)           AS avg_distance_miles,
    ROUND(AVG(trip_duration_mins), 1)      AS avg_duration_mins,
    ROUND(AVG(total_amount /
        NULLIF(trip_duration_mins, 0)
    ), 2)                                  AS revenue_per_minute

FROM staging
GROUP BY
    trip_date,
    trip_year,
    trip_month,
    time_segment,
    distance_segment,
    pickup_location_id