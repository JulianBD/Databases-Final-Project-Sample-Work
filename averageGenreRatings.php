<?php

include "conf.php";
include "open.php";

$dbhost = 'cs315-reddy-dorsey.mysql.database.azure.com';
$dbuser = 'david@cs315-reddy-dorsey';
$dbpass = 'yarowsky315!';
$conn = mysqli_connect($dbhost,$dbuser, $dbpass);

if (!$conn) {
    die (mysqli_error());
} else {
    // TopArtistsPitchfork
    $in_genre = $_POST["in_genre"];
    $start_year = $_POST["start_year"];
    $end_year = $_POST["end_year"];

    mysqli_select_db($conn, "cs315");
    #echo("Hello!");
    $result = mysqli_query($conn, "CALL AverageGenreRatingPitchfork('$in_genre','$start_year','$end_year')");

    if (!$result) {
       echo "Query failed!\n";
       print mysqli_error();
    } else {
    
    echo "<head>\n<link rel=\"stylesheet\" type=\"text/css\" media=\"screen\" href=\"main.css\"/>\n</head>";
    echo "<body><div class=\"small-container\"><table border = 1>\n";
    echo "<tr><td>Year</td><td>Average Score</td></td>\n";
    while ($myrow = mysqli_fetch_array($result)) {
        // printf("in row");
        printf("<tr><td>%s</td><td>%s</td></tr>\n", $myrow["pub_year"], $myrow["average_score"]);
    }
    echo "</table>\n</div></body>";
    #echo("Hello again!");
    }
}