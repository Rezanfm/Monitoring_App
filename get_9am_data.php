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
$pass = ""; // Ganti jika password MySQL Anda ada
$db = "db_monitoring";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

// Mengambil data suhu dan turbidity yang terdeteksi tepat pada jam 09:00:00
// untuk 30 hari terakhir dari tanggal saat ini.
// ORDER BY waktu ASC memastikan data diurutkan dari yang paling lama ke terbaru.
$query = "
    SELECT
        id,
        suhu,
        turbidity,
        waktu
    FROM monitoring_data
    WHERE TIME(waktu) = '09:00:00'
    AND waktu >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
    ORDER BY waktu ASC;
";

$result = $conn->query($query);

$data = [];

if ($result) {
    while ($row = $result->fetch_assoc()) {
        // Pastikan nilai suhu dan turbidity adalah float
        $row['suhu'] = (float)$row['suhu'];
        $row['turbidity'] = (float)$row['turbidity'];
        $data[] = $row; // Mengembalikan semua kolom
    }
} else {
    echo json_encode(["error" => "Query failed: " . $conn->error]);
    $conn->close();
    exit();
}

echo json_encode($data);
$conn->close();
?>
