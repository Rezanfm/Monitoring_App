import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/monitoring_data.dart';
import '../models/user.dart';
import '../utils/app_constants.dart';

class ApiService {
  // Mengambil data terbaru untuk dashboard dari GET_DATA_URL
  Future<MonitoringData?> getCurrentMonitoringData() async {
    try {
      final response = await http.get(Uri.parse(AppConstants.GET_DATA_URL)); // Menggunakan GET_DATA_URL

      if (response.statusCode == 200) {
        if (response.body.isEmpty || response.body == 'null') {
          return null;
        }
        // get_data.php sekarang mengembalikan objek tunggal, jadi langsung decode
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return MonitoringData.fromJson(jsonResponse);
      } else {
        throw Exception(
            'Failed to load current data: ${response.statusCode}. Response body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching current data: $e');
    }
  }

  // Fungsi untuk mengambil data monitoring jam 9 pagi (all data)
  Future<List<MonitoringData>> get9AMData() async {
    try {
      final response = await http.get(Uri.parse(AppConstants.GET_9AM_DATA_URL));

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return [];
        }
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => MonitoringData.fromJson(data))
            .toList();
      } else {
        throw Exception(
            'Failed to load 9 AM data: ${response.statusCode}. Response body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching 9 AM data: $e');
    }
  }

  // Fungsi untuk login
  Future<User> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.LOGIN_URL),
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success']) {
          return User.fromJson(jsonResponse['user']);
        } else {
          throw Exception(jsonResponse['message'] ?? 'Login failed');
        }
      } else {
        throw Exception('Failed to connect to server: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  // Fungsi untuk mengirim data sensor
  Future<bool> insertData(double suhu, double turbidity) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.INSERT_DATA_URL),
        body: {
          'suhu': suhu.toString(),
          'turbidity': turbidity.toString(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['success'] ?? false;
      } else {
        throw Exception('Failed to insert sensor data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error inserting sensor data: $e');
    }
  }
}
