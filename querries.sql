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

-- create 4th table whatchistory
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

