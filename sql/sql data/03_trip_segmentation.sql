WITH trip_segments AS (
  SELECT
    CASE
      WHEN trip_distance >= 20 THEN 'Long Haul (20+ miles)'
      WHEN trip_distance BETWEEN 10 AND 19.99 THEN 'Medium-Long (10-20 miles)'
      WHEN trip_distance BETWEEN 5 AND 9.99 THEN 'Medium (5-10 miles)'
      WHEN trip_distance BETWEEN 2 AND 4.99 THEN 'Short (2-5 miles)'
      ELSE 'Very Short (under 2 miles)'
    END AS trip_segment,
    CASE
      WHEN EXTRACT(HOUR FROM pickup_datetime) BETWEEN 7 AND 9 THEN 'Morning Rush'
      WHEN EXTRACT(HOUR FROM pickup_datetime) BETWEEN 17 AND 19 THEN 'Evening Rush'
      WHEN EXTRACT(HOUR FROM pickup_datetime) BETWEEN 22 AND 23
        OR EXTRACT(HOUR FROM pickup_datetime) BETWEEN 0 AND 2 THEN 'Late Night'
      ELSE 'Off Peak'
    END AS time_segment,
    fare_amount,
    tip_amount,
    total_amount,
    trip_distance,
    passenger_count
  FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
  WHERE
    fare_amount BETWEEN 2.50 AND 500
    AND trip_distance BETWEEN 0.1 AND 100
    AND pickup_datetime IS NOT NULL
)
SELECT
  trip_segment,
  time_segment,
  COUNT(*) AS total_trips,
  ROUND(AVG(fare_amount), 2) AS avg_fare,
  ROUND(AVG(tip_amount), 2) AS avg_tip,
  ROUND(AVG(tip_amount / NULLIF(fare_amount,0)) * 100, 1) AS tip_rate_pct,
  ROUND(SUM(total_amount), 2) AS total_revenue,
  ROUND(AVG(passenger_count), 1) AS avg_passengers
FROM trip_segments
GROUP BY trip_segment, time_segment
ORDER BY total_revenue DESC