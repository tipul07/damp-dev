<?php

$servername = 'mysql';
$username = 'user';
$password = 'password';

try {
    // Create connection
    $conn = new mysqli($servername, $username, $password);
} catch( Exception $e ) {
    die('Connection failed: ' . $e->getMessage());
}

// Check connection
if ($conn->connect_error) {
    die('Connection failed: ' . $conn->connect_error);
}
echo 'Connected successfully';
