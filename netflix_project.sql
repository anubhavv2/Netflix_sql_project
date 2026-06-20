SHOW DATABASES;
CREATE DATABASE netflix_db;

USE netflix_db;
CREATE TABLE netflix
(
show_id VARCHAR(6),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(250),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(250)
);

/* alternate way to import data from csv */
SET GLOBAL LOCAL_INFILE=ON;
LOAD DATA LOCAL INFILE 'C:/Users/hp/Desktop/Netflix Project/netflix_titles - Copy.csv' INTO TABLE netflix
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SELECT count(*) FROM netflix;

SELECT * FROM netflix;

-- Q1) Count the number of Movies vs TV Shows
SELECT type, COUNT(*) AS 'Type Count' FROM netflix
GROUP BY type; 


-- Q2) Find the most common rating for movies and tv shows
SELECT type, rating FROM
(SELECT type, rating, COUNT(*), 
RANK() OVER(PARTITION BY type ORDER BY COUNT(*)DESC) AS ranking 
FROM netflix
GROUP BY type, rating) AS t1
WHERE ranking = 1;


-- Q3) List all MOVIES which was released in specific year eg 2020
SELECT * FROM netflix
WHERE (type= 'Movie' AND release_year=2020);


-- Q4) Find the top 5 countries with the most content on netflix
SELECT country, count(show_id) AS Content_Count
FROM netflix
GROUP BY country
ORDER BY count(show_id) DESC
LIMIT 5;


-- Q5) Identify the longest movie
SELECT * FROM netflix
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC
LIMIT 1;
/* cast helps in changing datatype, unsigned means unsigned datatype ie 0 or +ve no */


-- Q6) Find the content added in the last 5 years
SELECT * FROM netflix
WHERE (YEAR(CURRENT_DATE())-YEAR(DATE(date_added)) <= 5);


-- Q7) Find all the movies/tv shows directed by 'Rajiv Chilaka'
SELECT * FROM netflix 
WHERE director LIKE '%rajiv chilaka%';



-- Q8) List all TV shows with more than 5 seasons
SELECT * FROM netflix
WHERE 
type = "TV Show" AND CAST(SUBSTRING_INDEX(duration,' ',1) AS UNSIGNED) >5;


-- Q9) Count the number of content items in each genre
-- this will work only is postgresql
/* SELECT
UNREST(STRING_TO_ARRAY(listed_in,',')) AS genre,
COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1 */


-- Q10) Find each year and the average number of content release in India on Netflix. 
-- Return top 5 year with highest avg content release!
SELECT YEAR(date_added) as years, COUNT(*) as yearly_content,
(COUNT(*) / (SELECT COUNT(*) FROM netflix WHERE country LIKE '%India%'))*100 AS avg_yearly_content
FROM netflix
WHERE country like '%India%'
GROUP BY years
ORDER BY avg_yearly_content DESC;


-- Q11) List all movies that are documentaries
SELECT * FROM netflix
WHERE listed_in LIKE '%documentaries%'
AND type = 'Movie';


-- Q12) Find all the content without a director
SELECT * FROM netflix
WHERE director IS NULL OR director = '';







SELECT * FROM netflix; 






