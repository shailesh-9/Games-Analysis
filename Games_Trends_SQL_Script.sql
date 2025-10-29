CREATE DATABASE gaming_data;

USE gaming_data;

CREATE TABLE games (
    source_id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_date DATE,
    team VARCHAR(255),
    rating DECIMAL(3, 1),
    genres_raw VARCHAR(255),
    summary TEXT,
    reviews_raw TEXT,
    plays_raw VARCHAR(50),
    plays_int INT,
    title_norm VARCHAR(255)
);

CREATE TABLE game_genres (
    game_id INT NOT NULL,
    genre VARCHAR(100) NOT NULL,
    PRIMARY KEY (game_id, genre),
    FOREIGN KEY (game_id) REFERENCES games(source_id)
);


CREATE TABLE game_reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY, -- Add an auto-increment ID for a unique row identifier
    game_id INT NOT NULL,
    review_text TEXT NOT NULL,
    FOREIGN KEY (game_id) REFERENCES games(source_id)
);


CREATE TABLE vgsales (
    `rank` INT PRIMARY KEY,
    `name` VARCHAR(255),
    platform VARCHAR(50),
    `year` INT,
    genre VARCHAR(100),
    publisher VARCHAR(255),
    na_sales DECIMAL(10, 2), -- Sales in North America (in millions)
    eu_sales DECIMAL(10, 2), -- Sales in Europe (in millions)
    jp_sales DECIMAL(10, 2), -- Sales in Japan (in millions)
    other_sales DECIMAL(10, 2), -- Sales in other regions (in millions)
    global_sales DECIMAL(10, 2), -- Total sales (in millions)
    name_norm VARCHAR(255)
);


-- Q1. Top 10 Global Selling Games

SELECT `rank`, name, platform, `year`, global_sales
FROM vgsales
ORDER BY global_sales DESC
LIMIT 10;


-- Q2. Publisher with Most Titles

SELECT publisher, COUNT(*) AS num_games
FROM vgsales
GROUP BY publisher
ORDER BY num_games DESC
LIMIT 1;


-- Q3. Top 5 Genres by North American Sales

SELECT genre, SUM(na_sales) AS total_na_sales
FROM vgsales
GROUP BY genre
ORDER BY total_na_sales DESC
LIMIT 5;


-- Q4. Total Global Sales for 'PS4' Platform

SELECT SUM(global_sales) AS total_ps4_sales
FROM vgsales
WHERE platform = 'PS4';


-- Q5. Year with the Highest Number of Game Releases

SELECT `year`, COUNT(*) AS games_released
FROM vgsales
WHERE `year` IS NOT NULL
GROUP BY `year`
ORDER BY games_released DESC
LIMIT 1;


-- Q6. High-Rated Games (4.4 or higher)

SELECT title, team, SUBSTRING(release_date, 1, 4) AS release_year, rating
FROM games
WHERE rating >= 4.4
ORDER BY rating DESC;


-- Q7. Game with the Highest Estimated Plays

SELECT title, plays_int
FROM games
ORDER BY plays_int DESC
LIMIT 1;


-- Q8. Count of Reviews for 'Elden Ring'

SELECT g.title, COUNT(r.review_id) AS total_reviews
FROM games g
JOIN game_reviews r ON g.source_id = r.game_id
WHERE g.title = 'Elden Ring'
GROUP BY g.title;


-- Q9. Average Rating for Games by 'Nintendo'

SELECT AVG(rating) AS avg_nintendo_rating
FROM games
WHERE team LIKE '%Nintendo%';


-- Q10. Long Reviews (over 100 chars) for 'Hades'

SELECT r.review_text
FROM game_reviews r
JOIN games g ON r.game_id = g.source_id
WHERE g.title = 'Hades' AND LENGTH(r.review_text) > 100;


-- Q11. Top 5 Most Popular Genres (by unique game count)

SELECT genre, COUNT(DISTINCT game_id) AS num_games
FROM game_genres
GROUP BY genre
ORDER BY num_games DESC
LIMIT 5;


-- Q12. Games Belonging to More than Three Genres

SELECT g.title, COUNT(gg.genre) AS genre_count
FROM games g
JOIN game_genres gg ON g.source_id = gg.game_id
GROUP BY g.title
HAVING genre_count > 3
ORDER BY genre_count DESC;


-- Q13. High-Rated Shooter Games (Rating > 4.0)

SELECT DISTINCT g.title, g.rating
FROM games g
JOIN game_genres gg ON g.source_id = gg.game_id
WHERE gg.genre = 'Shooter' AND g.rating > 4.0
ORDER BY g.rating DESC;


-- Q14. Total Worldwide Sales for the 1990s

SELECT SUM(global_sales) AS total_sales_1990s
FROM vgsales
WHERE `year` BETWEEN 1990 AND 1999;


-- Q15. Top Selling Nintendo Games (Global Sales > 15M)

SELECT `name`, platform, global_sales
FROM vgsales
WHERE publisher = 'Nintendo' AND global_sales > 15
ORDER BY global_sales DESC
LIMIT 5;