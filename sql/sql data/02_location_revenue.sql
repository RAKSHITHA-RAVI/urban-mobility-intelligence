SELECT
  pickup_location_id,
  COUNT(*) AS total_trips,
  ROUND(AVG(fare_amount), 2) AS avg_fare,
  ROUND(SUM(total_amount), 2) AS total_revenue,
  ROUND(AVG(trip_distance), 2) AS avg_distance,
  ROUND(AVG(tip_amount / NULLIF(fare_amount, 0)) * 100, 2) AS tip_rate_pct
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
WHERE
  fare_amount BETWEEN 2.50 AND 500
  AND trip_distance BETWEEN 0.1 AND 100
  AND pickup_location_id IS NOT NULL
GROUP BY pickup_location_id
ORDER BY total_trips DESC
LIMIT 50