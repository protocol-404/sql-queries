<?php
require 'vendor/autoload.php';
use Faker\Factory;

$host = 'localhost';
$dbname = 'test_movies';
$username = 'root';
$password = 'root';

$conn = new mysqli($host, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$numberOfUsers = 10;
$numberOfMovies = 5;
$numberOfWatchHistory = 15;
$numberOfReviews = 20;

$faker = Factory::create();

$subscriptions = [
    ['Basic', 5.99],
    ['Premium', 11.99]
];

foreach ($subscriptions as $index => $subscription) {
    $stmt = $conn->prepare("INSERT IGNORE INTO subscription (SubscriptionType, MonthlyFee) VALUES (?, ?)");
    $stmt->bind_param('sd', $subscription[0], $subscription[1]);
    $stmt->execute();
    $stmt->close();
}

for ($i = 1; $i <= $numberOfUsers; $i++) {
    $firstName = $faker->firstName;
    $lastName = $faker->lastName;
    $email = $faker->unique()->safeEmail;
    $registrationDate = $faker->date;
    $subscriptionID = $faker->numberBetween(1, count($subscriptions));

    $stmt = $conn->prepare("INSERT INTO users (UserID, FirstName, LastName, Email, RegistrationDate, SubscriptionID) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->bind_param('issssi', $i, $firstName, $lastName, $email, $registrationDate, $subscriptionID);
    $stmt->execute();
    $stmt->close();
}

for ($i = 1; $i <= $numberOfMovies; $i++) {
    $title = $faker->sentence(3);
    $genre = $faker->randomElement(['Comedy', 'Horror', 'Romance', 'Science Fiction', 'Documentary']);
    $releaseYear = $faker->numberBetween(1900, 2023);
    $duration = $faker->numberBetween(80, 180);
    $rating = $faker->randomElement(['PG', 'PG-13', 'R']);
    
    $stmt = $conn->prepare("INSERT INTO movie (MovieID, Title, Genre, ReleaseYear, Duration, Rating) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->bind_param('isssis', $i, $title, $genre, $releaseYear, $duration, $rating);
    $stmt->execute();
    $stmt->close();
}

for ($i = 1; $i <= $numberOfWatchHistory; $i++) {
    $userID = $faker->numberBetween(1, $numberOfUsers);
    $movieID = $faker->numberBetween(1, $numberOfMovies);
    $whatchDate = $faker->date;
    $completionPercentage = $faker->numberBetween(0, 100);
    
    $stmt = $conn->prepare("INSERT INTO whatchistory (WhatchHistoryID, UserID, MovieID, WhatchDate, CompletionPercentage) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param('iiisi', $i, $userID, $movieID, $whatchDate, $completionPercentage);
    $stmt->execute();
    $stmt->close();
}

for ($i = 1; $i <= $numberOfReviews; $i++) {
    $userID = $faker->numberBetween(1, $numberOfUsers);
    $movieID = $faker->numberBetween(1, $numberOfMovies);
    $rating = $faker->numberBetween(1, 5);
    $reviewText = $faker->optional()->sentence(10);
    $reviewDate = $faker->date;
    
    $stmt = $conn->prepare("INSERT INTO review (ReviewID, UserID, MovieID, Rating, ReviewText, ReviewDate) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->bind_param('iiisis', $i, $userID, $movieID, $rating, $reviewText, $reviewDate);
    $stmt->execute();
    $stmt->close();
}

echo "Fake data inserted successfully!";
$conn->close();
?>