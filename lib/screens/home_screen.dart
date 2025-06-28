import 'package:flutter/material.dart';
import 'package:monitoring_app/api/api_service.dart';
import 'package:monitoring_app/models/monitoring_data.dart';
import 'package:monitoring_app/screens/charts_view.dart';
import 'package:monitoring_app/screens/dashboard_view.dart';
import 'package:monitoring_app/screens/login_screen.dart';
import 'package:monitoring_app/utils/auth_manager.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  MonitoringData? _latestData;
  bool _isLoadingDashboard = true;
  String? _errorMessageDashboard;
  int _selectedIndex = 0;
  Timer? _dashboardTimer;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData(); // Panggil pertama kali
    // Timer untuk refresh SETIAP 7 DETIK
    _dashboardTimer = Timer.periodic(const Duration(seconds: 7), (Timer t) { // <--- Perubahan di sini: 3 detik menjadi 7 detik
      if (mounted) {
        _fetchDashboardData();
      }
    });
  }

  @override
  void dispose() {
    _dashboardTimer?.cancel();
    super.dispose();
  }

  void _fetchDashboardData() async {
    setState(() {
      _isLoadingDashboard = true;
      _errorMessageDashboard = null;
    });
    try {
      final data = await _apiService.getCurrentMonitoringData();
      setState(() {
        _latestData = data;
        _isLoadingDashboard = false;
      });
    } catch (e) {
      setState(() {
        _errorMessageDashboard = e.toString().replaceFirst("Exception: ", "");
        _isLoadingDashboard = false;
      });
      print('Error fetching dashboard data: $e');
    }
  }

  void _logout() async {
    await AuthManager.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  List<Widget> get _widgetOptions {
    return <Widget>[
      DashboardView(
        latestData: _latestData,
        isLoading: _isLoadingDashboard,
        errorMessage: _errorMessageDashboard,
      ),
      const ChartsView(),
      const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline_rounded, size: 80, color: Colors.blueGrey),
            SizedBox(height: 20),
            Text('Informasi Lainnya', style: TextStyle(fontSize: 24, color: Colors.blueGrey, fontWeight: FontWeight.bold)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Halaman ini bisa dikembangkan lebih lanjut untuk menampilkan informasi detail tentang sistem monitoring atau pengaturan aplikasi.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle = 'Dashboard Monitoring';
    if (_selectedIndex == 1) {
      appBarTitle = 'Grafik Monitoring';
    } else if (_selectedIndex == 2) {
      appBarTitle = 'Informasi Aplikasi';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.refresh_rounded, size: 28),
              onPressed: _fetchDashboardData,
              tooltip: 'Refresh Data Dashboard',
            ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, size: 28),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart_rounded),
              label: 'Grafik',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline_rounded),
              label: 'Info',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
