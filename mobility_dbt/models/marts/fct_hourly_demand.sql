-- Mart model: hourly demand patterns
-- Grain: one row per hour per day of week

WITH staging AS (
    SELECT * FROM {{ ref('stg_trips') }}
)

SELECT
    pickup_hour,
    day_of_week,
    time_segment,

    COUNT(*)                        AS total_trips,
    ROUND(AVG(fare_amount), 2)      AS avg_fare,
    ROUND(SUM(total_amount), 2)     AS total_revenue,
    ROUND(AVG(tip_rate_pct), 2)     AS avg_tip_rate,
    ROUND(AVG(trip_distance), 2)    AS avg_distance

FROM staging
GROUP BY
    pickup_hour,
    day_of_week,
    time_segment
ORDER BY
    pickup_hour,
    day_of_week