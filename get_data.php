<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$host = "localhost";
$user = "root";
$pass = "";
$db = "db_monitoring";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
  die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

// Mengambil data terbaru saja (LIMIT 1)
$query = "SELECT id, suhu, turbidity, waktu FROM monitoring_data ORDER BY waktu DESC LIMIT 1";
$result = $conn->query($query);

$data = null; // Inisialisasi sebagai null jika tidak ada data

if ($result && $result->num_rows > 0) {
  $row = $result->fetch_assoc();
  // Pastikan nilai suhu dan turbidity adalah float
  $row['suhu'] = (float)$row['suhu'];
  $row['turbidity'] = (float)$row['turbidity'];
  $data = $row; // Mengembalikan objek tunggal
}

header('Content-Type: application/json');
echo json_encode($data); // Mengembalikan objek tunggal atau null
$conn->close();
?>
