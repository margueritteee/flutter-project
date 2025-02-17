<?php
$servername = "localhost"; 
$username = "root"; 
$password = ""; 
$dbname = "user_data"; 

// Connect to MySQL
$conn = new mysqli($servername, $username, $password, $dbname);

// Check Connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get data from POST request
$data = json_decode(file_get_contents("php://input"), true);

$nom = $data['nom'];
$email = $data['email'];
$numero = $data['numero'];
$date_naissance = $data['date_naissance'];
$sexe = $data['sexe'];
$wilaya = $data['wilaya'];
$commentaire = $data['commentaire'];

// Prepare SQL statement
$sql = "INSERT INTO users (nom, email, numero, date_naissance, sexe, wilaya, commentaire) 
        VALUES ('$nom', '$email', '$numero', '$date_naissance', '$sexe', '$wilaya', '$commentaire')";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["status" => "success", "message" => "User registered successfully"]);
} else {
    echo json_encode(["status" => "error", "message" => "Error: " . $conn->error]);
}

// Close connection
$conn->close();
?>
