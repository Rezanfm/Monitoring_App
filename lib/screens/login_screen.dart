import 'package:flutter/material.dart';
import 'package:monitoring_app/api/api_service.dart';
import 'package:monitoring_app/utils/auth_manager.dart';
import 'package:monitoring_app/screens/admin_dashboard_screen.dart';
import 'package:monitoring_app/screens/user_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _apiService.login(
        _usernameController.text,
        _passwordController.text,
      );
      await AuthManager.saveUser(user);

      if (!mounted) return; // Cek mounted setelah await

      if (user.role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserDashboardScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login gagal: ${e.toString().replaceFirst("Exception: ", "")}'), // Hapus "Exception: "
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Aplikasi Monitoring'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent, // Warna AppBar login
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 12, // Bayangan lebih dalam
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), // Sudut lebih membulat
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ganti ikon dengan gambar logo
                  Image.asset(
                    'assets/logo.png', // <--- PASTIKAN PATH INI SESUAI DENGAN LOGO ANDA
                    height: 120, // Sesuaikan tinggi logo
                    width: 120,  // Sesuaikan lebar logo
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon( // Fallback jika gambar tidak ditemukan
                        Icons.image_not_supported,
                        size: 80,
                        color: Colors.grey,
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Selamat Datang Kembali!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: const Icon(Icons.person_rounded, color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.blue.shade800, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.blueAccent.withOpacity(0.05),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_rounded, color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.blue.shade800, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.blueAccent.withOpacity(0.05),
                    ),
                  ),
                  const SizedBox(height: 35),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 5,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'MASUK',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
