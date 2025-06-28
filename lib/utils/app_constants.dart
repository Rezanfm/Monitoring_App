class AppConstants {
  // PENTING: GANTI DENGAN IP ADDRESS KOMPUTER ANDA YANG BENAR SAAT INI!
  static const String BASE_URL = "http://localhost/monitoring_app";

  static const String LOGIN_URL = "$BASE_URL/login.php";
  // Kembali menggunakan GET_DATA_URL untuk dashboard
  static const String GET_DATA_URL = "$BASE_URL/get_data.php"; 
  static const String GET_9AM_DATA_URL = "$BASE_URL/get_9am_data.php";
  static const String INSERT_DATA_URL = "$BASE_URL/insert_data.php";
}
