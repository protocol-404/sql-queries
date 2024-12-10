# Test Movies Database Project

This project is an educational exercise designed for YouCode School. It provides hands-on experience with SQL by creating and interacting with a database for managing movies, users, subscriptions, watch histories, and reviews. The project is intended for beginners to practice SQL concepts like creating tables, defining relationships, inserting data, and performing queries.

## Author Information
- **Name**: Ousama
- **Email**: [oujaberousama@gmail.com](mailto:oujaberousama@gmail.com)

---

## Database Setup

### 1. Create Database
```sql
CREATE DATABASE test_movies;
USE test_movies;
```

---

## Table Definitions

### 2. Subscription Table
This table stores subscription types and their monthly fees.
```sql
CREATE TABLE subscription (
    SubscriptionID INT AUTO_INCREMENT PRIMARY KEY,
    SubscriptionType VARCHAR(50) CHECK (LOWER(SubscriptionType) = 'basic' OR LOWER(SubscriptionType) = 'premium'),
    MonthlyFee DECIMAL(10,2) NOT NULL
);
```

### 3. Users Table
This table holds user information and links each user to a subscription.
```sql
CREATE TABLE users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    RegistrationDate DATE NOT NULL,
    SubscriptionID INT NOT NULL,
    FOREIGN KEY (SubscriptionID) REFERENCES subscription(SubscriptionID)
);
```

### 4. Movie Table
This table contains information about movies.
```sql
CREATE TABLE movie (
    MovieID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Genre VARCHAR(100) NOT NULL,
    ReleaseYear INT NOT NULL CHECK (ReleaseYear >= 1000 AND ReleaseYear <= 3000),
    Duration INT NOT NULL,
    Rating VARCHAR(10) NOT NULL
);
```

### 5. Watch History Table
This table tracks which users have watched which movies and their completion percentages.
```sql
CREATE TABLE watchhistory (
    WatchHistoryID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES users(UserID),
    MovieID INT NOT NULL,
    FOREIGN KEY (MovieID) REFERENCES movie(MovieID),
    WatchDate DATE NOT NULL,
    CompletionPercentage INT NOT NULL DEFAULT 0
);
```

### 6. Review Table
This table stores user reviews and ratings for movies.
```sql
CREATE TABLE review (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES users(UserID),
    MovieID INT NOT NULL,
    FOREIGN KEY (MovieID) REFERENCES movie(MovieID),
    Rating INT NOT NULL DEFAULT 0,
    ReviewText TEXT NULL,
    ReviewDate DATE
);
```

### Update column Sub_ID from NOT NULL to NULL to allow NULL values
```sql
ALTER TABLE users
MODIFY COLUMN SubscriptionID INT NULL;
```

---

## Fill the database

Use the script in the link bellow:

[script php using composer fake data](https://file.io/dP0CZFoNRxRi)

### Ensure Faker is installed via Composer:
```bash
composer require fakerphp/faker
```

- After that run your script by: `php script.php`
---

## Sample Operations

### 1. Insert Movie
```sql
INSERT INTO movie (Title, Genre, ReleaseYear, Duration, Rating)
VALUES ('Data Science Adventures', 'Documentary', 2000, 45, 'R');
```

### 2. Filter Data
```sql
SELECT Title, ReleaseYear 
FROM movie 
WHERE Genre = 'comedy' AND ReleaseYear > 2020;
```

### 3. Update Subscription Type
```sql
UPDATE users
SET SubscriptionID = (
    SELECT SubscriptionID
    FROM subscription
    WHERE LOWER(SubscriptionType) = 'premium' LIMIT 1
)
WHERE SubscriptionID = (
    SELECT SubscriptionID
    FROM subscription
    WHERE LOWER(SubscriptionType) = 'basic' LIMIT 1
);
```

### 4. Display All Users and Subscriptions
```sql
SELECT tab1.FirstName, tab2.SubscriptionType
FROM users tab1
JOIN subscription tab2
ON tab1.SubscriptionID = tab2.SubscriptionID;
```

### 5. Display Users Who Finished Watching a Movie
```sql
SELECT tab1.FirstName, tab2.CompletionPercentage
FROM users tab1
JOIN watchhistory tab2
ON tab1.UserID = tab2.UserID
WHERE CompletionPercentage = 100;
```

### 6. Top 5 Long Movies
```sql
SELECT Title 
FROM movie
ORDER BY Duration DESC
LIMIT 5;
```

### 7. Average Completion Percentage
```sql
SELECT AVG(CompletionPercentage) 
FROM watchhistory;
```

### 8. Group Users by Subscription Plans
```sql
SELECT tab2.SubscriptionType AS Plan, COUNT(tab1.UserID) AS Total
FROM users tab1
INNER JOIN subscription tab2 ON tab1.SubscriptionID = tab2.SubscriptionID
GROUP BY tab2.SubscriptionType
ORDER BY COUNT(tab1.UserID);
```

### 9. Extract Average Movie Rating
```sql
SELECT Title
FROM movie
WHERE MovieID IN (
    SELECT MovieID
    FROM review
    GROUP BY MovieID
    HAVING AVG(Rating) > 2
);
```

### 10. Find Pairs of Similar Movies
```sql
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
```

---

## Notes
- This project was created as a learning experience for SQL and database design.
- Feedback and suggestions are welcome!