 SCHEMAS of Netflix

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
