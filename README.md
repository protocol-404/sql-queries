# Movie Subscription System Database

This document provides a detailed schema for a database system designed to manage movie subscriptions, users, watch history, and reviews. It includes the SQL queries to create the necessary database and tables and filter data of tables, It educational project from youcode.

## Database Information

- **Database Name**: `test_movies`
- **Author**: Protocol
- **Email**: oujaberousama@gmail.com

## Database Creation

### 1. Create the Database

```sql
CREATE DATABASE test_movies;
```

### 2. Use the Database

```sql
USE test_movies;
```

## Tables

### 1. `subscription` Table

This table stores information about different subscription types available to users.

```sql
CREATE TABLE subscription (
    SubscriptionID INT AUTO_INCREMENT PRIMARY KEY,
    SubscriptionType VARCHAR(50),
    MonthlyFee DECIMAL(10,2) NOT NULL,
        CHECK
            (LOWER(subscriptionType) = 'basic'
        OR
            LOWER(subscriptionType) = 'premium')
);
```

- `SubscriptionID`: Unique identifier for each subscription type.
- `SubscriptionType`: Type of subscription, either 'basic' or 'premium'.
- `MonthlyFee`: Monthly fee for the subscription type.

### 2. `users` Table

This table stores user details.

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

- `UserID`: Unique identifier for each user.
- `FirstName`: User's first name.
- `LastName`: User's last name.
- `Email`: User's email address unique.
- `RegistrationDate`: Date when the user registered.
- `SubscriptionID`: Foreign key referencing the subscription the user is on.

### 3. `movie` Table

This table stores information about the movies available in the system.

```sql
CREATE TABLE movie (
    MovieID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Genre VARCHAR(100) NOT NULL,
    ReleaseYear INT NOT NULL,
    Duration INT NOT NULL,
    Rating VARCHAR(10) NOT NULL,
        CHECK (ReleaseYear >= 1000 AND ReleaseYear <= 3000),
);
```

- `MovieID`: Unique identifier for each movie.
- `Title`: The title of the movie.
- `Genre`: Genre of the movie (e.g., Action, Drama, Comedy).
- `ReleaseYear`: The year the movie was released.
- `Duration`: Duration of the movie in minutes.
- `Rating`: The rating of the movie (e.g., PG, R).

### 4. `whatchistory` Table

This table tracks the watch history of each user.

```sql
CREATE TABLE whatchistory (
    WhatchHistoryID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES users(UserID),
    MovieID INT NOT NULL,
    FOREIGN KEY (MovieID) REFERENCES movie(MovieID),
    WhatchDate DATE NOT NULL,
    CompletionPercentage INT NOT NULL DEFAULT 0
);
```

- `WhatchHistoryID`: Unique identifier for each watch history entry.
- `UserID`: Foreign key referencing the user who watched the movie.
- `MovieID`: Foreign key referencing the movie that was watched.
- `WhatchDate`: Date the movie was watched.
- `CompletionPercentage`: Percentage of the movie watched.

### 5. `review` Table

This table stores reviews submitted by users for movies.

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

- `ReviewID`: Unique identifier for each review.
- `UserID`: Foreign key referencing the user who submitted the review.
- `MovieID`: Foreign key referencing the movie being reviewed.
- `Rating`: Rating given to the movie (e.g., 1 to 5).
- `ReviewText`: The textual review (optional).
- `ReviewDate`: Date the review was submitted.

## Database Updates

### 1. Modify the `SubscriptionID` Column in `users` Table

This command modifies the `SubscriptionID` column in the `users` table to allow `NULL` values.

```sql
ALTER TABLE users
MODIFY COLUMN SubscriptionID INT NULL;
```

This change allows a user to have no subscription, meaning they are not assigned to free plan subscription.

## Fill the database

Use the script in the link bellow:

[script php using composer fake data](https://google.com)

## Filter data tables
