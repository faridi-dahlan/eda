--eksternal table dari gcs
CREATE OR REPLACE EXTERNAL TABLE `faridi-dezoomcamp.smartdata_da.external_netflix_titles_bq`
(
  show_id INT64,
  type STRING,
  title	STRING,
  director STRING,
  `cast` STRING,
  country STRING,
  date_added STRING,
  release_year INT64,
  rating STRING,
  duration STRING,
  listed_in STRING,
  description STRING
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://final_project_faridi/netflix_titles_raw.csv'],
  skip_leading_rows = 1,
  max_bad_records = 10
);

--transformasi tabel dari tabel eksternal (lowercase dan datetype)
CREATE OR REPLACE TABLE `faridi-dezoomcamp.smartdata_da.external_netflix_titles_bq1` AS
SELECT show_id, lower(type) AS type_lower, lower(title) AS title_lower, 
lower(director) AS director_lower, lower(`cast`) AS cast_lower,lower(country) AS country_lower,
PARSE_DATE('%B %e, %Y', date_added) as date_added,release_year,
lower(rating) AS rating_lower,duration,lower(listed_in) AS listed_in_lower, lower(description) AS description_lower
FROM `faridi-dezoomcamp.smartdata_da.external_netflix_titles_bq`
WHERE date_added != '' AND date_added IS NOT NULL;

--menyeragamkan min dan season menjadi min
CREATE OR REPLACE TABLE `faridi-dezoomcamp.smartdata_da.external_netflix_titles_bq2` AS
SELECT 
  bq1.*,
  CASE
    WHEN duration LIKE '%min' THEN SAFE_CAST(SPLIT(REGEXP_REPLACE(duration, ' min', ''), ' ')[OFFSET(0)] AS INT64)
    WHEN duration LIKE '%Season' THEN SAFE_CAST(SPLIT(REGEXP_REPLACE(duration, ' Season', ''), ' ')[OFFSET(0)] AS INT64) * 480
    ELSE SAFE_CAST(SPLIT(REGEXP_REPLACE(duration, ' Seasons', ''), ' ')[OFFSET(0)] AS INT64) * 480
  END AS duration_min_filter
FROM 
  `faridi-dezoomcamp.smartdata_da.external_netflix_titles_bq1` AS bq1;
