DROP TABLE netflix_utf8;

-- create a table 
CREATE TABLE netflix_utf8 (
    show_id VARCHAR(20),
    type VARCHAR(20),
    title TEXT,
    director TEXT,
    cast TEXT,
    country TEXT,
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(20),
    duration VARCHAR(50),
    listed_in TEXT,
    description TEXT
);

-- 1.view first 10 records 
SELECT * FROM netflix_utf8 LIMIT 10;

-- 2.show total table records 
SELECT * FROM netflix_utf8;

-- 3.total count of records 
SELECT COUNT(*) as total_countent FROM netflix_utf8;

-- 4.to find unique  type in type column 
SELECT DISTINCT type 
FROM  netflix_utf8;

-- 5. find unique rating 
SELECT DISTINCT rating FROM netflix_utf8;

-- 6. display only movie titles
SELECT title FROM netflix_utf8
WHERE type ='Movie';

-- 7. display only tv shows titles
SELECT title FROM netflix_utf8 
WHERE  type ='TV Show';

-- 8. display movies released after 2020
SELECT title, release_year 
FROM netflix_utf8 
WHERE type='Movie' AND release_year > 2020;

-- 9.find null countries 
SELECT COUNT(*)  AS null_countries FROM netflix_utf8 
WHERE country IS  NULL;  -- NOT NULL ALSO  OR  TO FIND BLANK ''

-- 10. Sort by releasing year
SELECT title , release_year
FROM netflix_utf8 
ORDER BY  release_year DESC; -- ASC

-- 11. COUNT TOTAL MOVIES AND TV SHOWS
SELECT COUNT(*) AS total_movies
FROM netflix_utf8 
WHERE type= 'Movie';  -- type ='TV Show'

 -- 12. TOP 10 LATEST RELEASED
SELECT *
FROM netflix_utf8 
ORDER BY  release_year DESC
LIMIT 20;

-- 13.FIND ALL CONTENT IN INDIA
SELECT * FROM netflix_utf8
WHERE country LIKE '%India%';

-- 14. FIND TITLE START WITH A
SELECT * FROM netflix_utf8 
WHERE title LIKE 'A%'

-- 15.COUNT TOTAL UNIQUE COUNTRIES
SELECT  COUNT(DISTINCT country )FROM netflix_utf8 ;


-- 17. CHECK DATA RANGE 
SELECT MIN(release_year) AS older,
MAX(release_year) AS later
FROM netflix_utf8 ;

-- 18. find  record added in year 2021
SELECT  * FROM netflix_utf8 
WHERE release_year LIKE '2021%';






-- 15 Business Problems & Solutions



-- 1. Count the number of Movies vs TV Shows
SELECT type ,
COUNT(*) AS total_content
FROM netflix_utf8 
GROUP BY type ;


-- 2. Find the most common rating for movies and TV shows

SELECT type, rating , total_content
FROM
(
SELECT type,rating,
COUNT(*) AS total_content,
RANK() OVER(PARTITION BY type 
             ORDER BY COUNT(*) DESC )AS ranking 
FROM netflix_utf8 
GROUP BY type, rating 
) t
WHERE ranking = 1;


-- 3. List all movies released in a specific year (e.g., 2020)
SELECT *
FROM netflix_utf8 
WHERE type = 'Movie' AND release_year LIKE '2020%';


-- 4. Find the top 5 countries with the most content on Netflix
SELECT country,
       COUNT(show_id) AS total_content
FROM netflix_utf8
WHERE country IS NOT NULL       -- COUNTRY WITH NOT NULL
  AND country <> ''           -- COUNTRY WITHNOT  BLANK SPACE 
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;


-- 5. Identify the longest movie( max duration)
SELECT * FROM netflix_utf8 
WHERE type ='Movie'
AND duration = (SELECT MAX(duration)FROM netflix_utf8);


-- 6. Find content added in the last 5 years
SELECT *
FROM netflix_utf8
WHERE STR_TO_DATE(date_added, '%M %d, %Y')         -- convert date 
      >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);         -- date added excetly 5 years  before today 


 -- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT * FROM netflix_utf8 
WHERE director LIKE '%Rajiv Chilaka%';


-- 8. List all TV shows with more than 5 seasons
SELECT * FROM netflix_utf8 
WHERE type = 'TV Show' AND 
CAST(SUBSTRING_INDEX(duration,' ',1)AS UNSIGNED)>5;   -- DIVING duration then conver into numeric 



-- 9. Count the number of content items in each genre
SELECT listed_in,
       COUNT(show_id) AS total_content
FROM netflix_utf8
GROUP BY listed_in
ORDER BY total_content DESC;

-- 10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!
SELECT 
YEAR(STR_TO_DATE(date_added, '%M %d, %Y') )as year,       -- extract year by date added 
COUNT(*) AS yearly_content,                                 -- count content added in each year
ROUND(                                          
COUNT(*) * 100.0 /                                  -- calculating per of total india available 
(
SELECT COUNT(*)
FROM netflix_utf8 WHERE country LIKE '%India%'
),
2
) as AVERAGE_CONTENT
FROM netflix_utf8
WHERE country LIKE '%India%'
GROUP BY year
ORDER BY AVERAGE_CONTENT DESC
LIMIT 5;



-- 11. List all movies that are documentaries     
SELECT * FROM netflix_utf8 
WHERE listed_in  LIKE '%documentaries%';


-- 12. Find all content without a director
SELECT * FROM netflix_utf8 
WHERE director IS NULL;


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT * FROM netflix_utf8 
WHERE  `type` ='Movie'and `cast` LIKE '%Salman Khan%'
AND release_year >YEAR ( CURDATE())-10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT
    `cast`,
    COUNT(*) AS total_content
FROM netflix_utf8
WHERE country LIKE '%India%'
  AND type = 'Movie'
GROUP BY `cast`
ORDER BY total_content DESC
LIMIT 10;

-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.
SELECT
    CASE
        WHEN description LIKE '%kill%'
          OR description LIKE '%violence%'
        THEN 'Bad'
        ELSE 'Good'
    END AS category,

    COUNT(*) AS total_content

FROM netflix_utf8

GROUP BY category;
