<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *"); // atau ganti * dengan asal tertentu
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$host = "localhost";
$user = "root";
$pass = "";
$db = "db_web"; // Menggunakan database db_web

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]));
}

$username = $_POST['username'] ?? '';
$password = $_POST['password'] ?? '';

if (empty($username) || empty($password)) {
    echo json_encode(["success" => false, "message" => "Username and password are required."]);
    $conn->close();
    exit();
}

$stmt = $conn->prepare("SELECT id, username, password, role FROM users WHERE username = ?");
$stmt->bind_param("s", $username);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    
    // Bandingkan password yang dimasukkan user (setelah di-MD5) dengan password di database
    // PENTING: Ini berasumsi password di database sudah dalam bentuk hash MD5.
    if (md5($password) === $user['password']) { // Perubahan di sini: tambahkan md5()
        echo json_encode([
            "success" => true,
            "message" => "Login successful",
            "user" => [
                "id" => $user['id'],
                "username" => $user['username'],
                "role" => $user['role']
            ]
        ]);
    } else {
        echo json_encode(["success" => false, "message" => "Invalid credentials."]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Invalid credentials."]);
}

$stmt->close();
$conn->close();
?>