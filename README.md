# Netflix Movies and TV Shows Data Analysis using SQL

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

# Dataset Import Troubleshoot

```sql
SET GLOBAL LOCAL_INFILE=ON;
LOAD DATA LOCAL INFILE 'dataset_location/dataset_name.csv' INTO TABLE netflix
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
```

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT type, COUNT(*) AS 'Type Count' FROM netflix
GROUP BY type; 
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
SELECT type, rating FROM
(SELECT type, rating, COUNT(*), 
RANK() OVER(PARTITION BY type ORDER BY COUNT(*)DESC) AS ranking 
FROM netflix
GROUP BY type, rating) AS t1
WHERE ranking = 1;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT * FROM netflix
WHERE (type= 'Movie' AND release_year=2020);
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT country, count(show_id) AS Content_Count
FROM netflix
GROUP BY country
ORDER BY count(show_id) DESC
LIMIT 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT * FROM netflix
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC
LIMIT 1;
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT * FROM netflix
WHERE (YEAR(CURRENT_DATE())-YEAR(DATE(date_added)) <= 5);
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT * FROM netflix 
WHERE director LIKE '%rajiv chilaka%';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT * FROM netflix
WHERE 
type = "TV Show" AND CAST(SUBSTRING_INDEX(duration,' ',1) AS UNSIGNED) >5;
```

**Objective:** Identify TV shows with more than 5 seasons.


### 9.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
SELECT YEAR(date_added) as years, COUNT(*) as yearly_content,
(COUNT(*) / (SELECT COUNT(*) FROM netflix WHERE country LIKE '%India%'))*100 AS avg_yearly_content
FROM netflix
WHERE country like '%India%'
GROUP BY years
ORDER BY avg_yearly_content DESC;
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 10. List All Movies that are Documentaries

```sql
SELECT * FROM netflix
WHERE listed_in LIKE '%documentaries%'
AND type = 'Movie';
```

**Objective:** Retrieve all movies classified as documentaries.

### 11. Find All Content Without a Director

```sql
SELECT * FROM netflix
WHERE director IS NULL OR director = '';
```

**Objective:** List content that does not have a director.

### 12. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
SELECT 
IF(description LIKE "%kill%" OR description LIKE "%violence%", 'Bad','Good') AS category,
COUNT(show_id) AS category_count
FROM netflix
GROUP BY category;
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.
