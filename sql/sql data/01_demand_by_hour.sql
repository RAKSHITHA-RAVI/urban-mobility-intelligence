SELECT
  EXTRACT(HOUR FROM pickup_datetime) AS hour_of_day,
  EXTRACT(DAYOFWEEK FROM pickup_datetime) AS day_of_week,
  COUNT(*) AS total_trips,
  ROUND(AVG(fare_amount), 2) AS avg_fare,
  ROUND(AVG(trip_distance), 2) AS avg_distance,
  ROUND(SUM(total_amount), 2) AS total_revenue
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
WHERE
  fare_amount BETWEEN 2.50 AND 500
  AND trip_distance BETWEEN 0.1 AND 100
  AND pickup_datetime IS NOT NULL
GROUP BY hour_of_day, day_of_week
ORDER BY hour_of_day, day_of_week