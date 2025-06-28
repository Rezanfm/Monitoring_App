<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit();
}

$host = "localhost";
$user = "root";
$pass = "";
$db = "db_monitoring";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
  die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

// Ambil data terbaru dari monitoring_data
$query = "SELECT id, suhu, turbidity, waktu FROM monitoring_data ORDER BY waktu DESC LIMIT 1";
$result = $conn->query($query);

$data = null;
if ($result && $result->num_rows > 0) {
    $data = $result->fetch_assoc();
    // Pastikan nilai suhu dan turbidity adalah float
    $data['suhu'] = (float)$data['suhu'];
    $data['turbidity'] = (float)$data['turbidity'];
}

echo json_encode($data); // Mengembalikan objek tunggal atau null
$conn->close();
?>
