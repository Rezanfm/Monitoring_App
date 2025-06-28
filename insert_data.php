<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Jika ini adalah request OPTIONS (preflight CORS), langsung exit
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit();
}

$host = "localhost";
$user = "root";
$pass = ""; // Ganti jika password MySQL Anda ada
$db = "db_monitoring";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]));
}

// Mengambil data dari POST request
$suhu = isset($_POST['suhu']) ? (float)$_POST['suhu'] : null;
$turbidity = isset($_POST['turbidity']) ? (float)$_POST['turbidity'] : null;
$waktu = date("Y-m-d H:i:s"); // Ambil waktu saat ini

if ($suhu === null || $turbidity === null) {
    echo json_encode(["success" => false, "message" => "Suhu and Turbidity data are required."]);
    $conn->close();
    exit();
}

// Masukkan data ke tabel monitoring_data
$stmt = $conn->prepare("INSERT INTO monitoring_data (suhu, turbidity, waktu) VALUES (?, ?, ?)");
$stmt->bind_param("dds", $suhu, $turbidity, $waktu);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Data inserted successfully."]);
} else {
    echo json_encode(["success" => false, "message" => "Failed to insert data: " . $stmt->error]);
}

$stmt->close();
$conn->close();
?>
