-- name: ousama
-- email: oujaberousama@gmail.com

-- create dB
CREATE DATABASE test_movies;

-- use dB to create tables
USE test_movies;

-- create 1st table subscription
CREATE TABLE subscription(
	SubscriptionID int AUTO_INCREMENT PRIMARY KEY,
    SubscriptionType VARCHAR(50) CHECK (lower(subscriptionType) = 'basic' OR lower(subscriptionType) = 'premium'),
    MonthlyFee DECIMAL(10,2) NOT NULL
);

-- create 2nd table users
CREATE TABLE users(
	UserID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    RegistrationDate DATE NOT NULL,
    SubscriptionID INT NOT NULL, 
    FOREIGN KEY (subscriptionID) REFERENCES subscription(subscriptionid)
);

-- create 3rd table movie
CREATE TABLE movie(
	MovieID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Genre VARCHAR(100) NOT NULL,
    ReleaseYear int NOT NULL CHECK (ReleaseYear >= 1000 AND ReleaseYear <= 3000), 
    Duration int NOT NULL,
    Rating VARCHAR(10) NOT NULL
);

-- create 4th table watchhistory
CREATE TABLE whatchistory(
	WhatchHistoryID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    	FOREIGN KEY (UserID) REFERENCES users(UserID),
    MovieID INT NOT NULL,
    	FOREIGN KEY (MovieID) REFERENCES movie(movieID),
    WhatchDate DATE NOT NULL,
    CompletionPercentage INT NOT NULL DEFAULT 0
);

-- create the last table review
CREATE TABLE review(
	ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    	FOREIGN KEY (UserID) REFERENCES users(UserID),
    MovieID INT NOT NULL,
    	FOREIGN KEY (MovieID) REFERENCES movie(MovieID),
    Rating INT NOT NULL DEFAULT 0,
    ReviewText TEXT NULL,
    ReviewDate DATE
);

-- update column Sub_ID from NOT NULL to NULL to allow NULL values
ALTER TABLE users
MODIFY COLUMN SubscriptionID INT NULL;

-- INSERT 1 COMMENT
INSERT INTO movie(`Title`, `Genre`, `ReleaseYear`, `Duration`, `Rating`)
VALUES ('Data Science Adventures', 'Documentary', 2000, 45, 'R')

-- filter data COMMENT
SELECT Title, Releaseyear from movie where `Genre` = 'comedy' AND `ReleaseYear` > 2020;

-- update type of subscriptionID
UPDATE users
SET SubscriptionID = (
    SELECT SubscriptionID
    FROM subscription
    WHERE lower(SubscriptionType) = 'premium' LIMIT 1
)
WHERE SubscriptionID = (
    SELECT SubscriptionID
    FROM subscription
    WHERE lower(SubscriptionType) = 'basic' LIMIT 1
);

-- display all user and sybscription
SELECT tab1.FirstName, tab2.SubscriptionType
FROM users tab1
JOIN subscription tab2
ON tab1.`SubscriptionID` = tab2.`SubscriptionID`;

-- display all users who finish watching a movie
SELECT tab1.FirstName, tab2.CompletionPercentage
FROM users tab1
JOIN whatchistory tab2
ON tab1.`UserID` = tab2.`UserID`
WHERE CompletionPercentage = 100;

-- display 5 long movie by Title
select `Title` FROM movie
ORDER BY `Duration` DESC LIMIT 5

-- average of watching movie
SELECT whatchistory.MovieID,
        movie.title,
        CONCAT(FLOOR(AVG(CompletionPercentage)),'%') as Complete
FROM whatchistory 
JOIN movie
ON movie.MovieID = whatchistory.MovieID
GROUP BY whatchistory.MovieID;

-- group users by Plans
SELECT tab2.Subscriptiontype AS Plan, COUNT(tab1.UserID) AS Total
FROM users tab1
INNER JOIN subscription tab2 ON tab1.SubscriptionID = tab2.SubscriptionID
GROUP BY tab2.SubscriptionType
ORDER BY COUNT(tab1.UserID);

-- extract average movie rating
SELECT Title
FROM movie
WHERE MovieID IN (
    SELECT MovieID
    FROM review
    GROUP BY MovieID
    HAVING AVG(Rating) > 2
);

-- find pairs of films
SELECT
    m1.Title AS Movie1,
    m2.Title AS Movie2,

    m1.Genre,
    m1.ReleaseYear

FROM movie m1
JOIN movie m2
    ON m1.Genre = m2.Genre
    AND m1.ReleaseYear = m2.ReleaseYear
    AND m1.MovieID < m2.MovieID;