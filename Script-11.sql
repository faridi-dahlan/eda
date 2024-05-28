USE netflix_titles_sql;

#melihat kolom di tabel
DESCRIBE netflix_titles_raw ;

#lihat data
SELECT *
FROM netflix_titles_raw ntr 
LIMIT 5;

#ubah format date_added dan lowercase
CREATE TABLE netflix_1 AS
SELECT show_id, lower(type) AS type_lower, lower(title) AS title_lower, 
lower(director) AS director_lower, lower(cast) AS cast_lower,lower(country) AS country_lower,
STR_TO_DATE(date_added, '%M %e, %Y') AS date_added_new,release_year,
lower(rating) AS rating_lower,duration,lower(listed_in) AS listed_in_lower, lower(description) AS description_lower 
FROM netflix_titles_raw ntr
WHERE date_added != '' AND date_added IS NOT NULL;

#agar min dan season menjadi hilang
CREATE TABLE netflix_titles_sql AS
SELECT n.*,
	CASE
		WHEN duration LIKE '%min' THEN (SUBSTRING_INDEX(REPLACE(duration,' min',''),' ',1)*1)
		WHEN duration LIKE '%Season' THEN (SUBSTRING_INDEX(REPLACE(duration,' Season',''),' ',1)*480)
	ELSE (SUBSTRING_INDEX(REPLACE(duration,' Seasons',''),' ',1)*480)
	END AS duration_min_filter
FROM netflix_1 n ;

#checking data dengan 10 baris
SELECT *
FROM netflix_titles_sql nts 
LIMIT 10;

