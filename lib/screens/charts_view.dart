import 'package:flutter/material.dart';
import 'package:monitoring_app/api/api_service.dart';
import 'package:monitoring_app/models/monitoring_data.dart';
import 'package:monitoring_app/widgets/custom_chart.dart';
import 'dart:async';

class ChartsView extends StatefulWidget {
  const ChartsView({super.key});

  @override
  State<ChartsView> createState() => _ChartsViewState();
}

class _ChartsViewState extends State<ChartsView> {
  final ApiService _apiService = ApiService();
  List<MonitoringData> _9AMData = []; // Data jam 9 pagi untuk kedua grafik
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetch9AMData();
    // Refresh setiap 30 detik untuk grafik (bisa disesuaikan)
    _timer = Timer.periodic(const Duration(seconds: 30), (Timer t) => _fetch9AMData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _fetch9AMData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await _apiService.get9AMData();
      setState(() {
        _9AMData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst("Exception: ", "");
        _isLoading = false;
      });
      print('Error fetching 9 AM data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
              const SizedBox(height: 10),
              Text(
                'Gagal memuat grafik: $_errorMessage',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _fetch9AMData,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_9AMData.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart_rounded, color: Colors.blueGrey, size: 60),
              const SizedBox(height: 10),
              Text(
                'Tidak ada data jam 09:00 pagi dalam 30 hari terakhir untuk menampilkan grafik.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueGrey, fontSize: 16),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    }

    final double graphWidth = _9AMData.length * 100.0;
    final double minGraphWidth = MediaQuery.of(context).size.width * 0.9;
    
    final double finalGraphWidth = graphWidth > minGraphWidth ? graphWidth : minGraphWidth;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Grafik Suhu
          SizedBox(
            height: 350,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: finalGraphWidth,
                child: CustomLineChart(
                  data: _9AMData, // Gunakan data 9 AM
                  title: 'Tren Suhu (Data Jam 09:00 Pagi)',
                  unit: '°C',
                  lineColor: Colors.orange.shade700,
                  getValue: (data) => data.suhu, // Ambil nilai suhu
                  minYConstraint: 25.0,
                  maxYConstraint: 33.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Grafik Turbidity
          SizedBox(
            height: 350,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: finalGraphWidth,
                child: CustomLineChart(
                  data: _9AMData, // Gunakan data 9 AM
                  title: 'Tren Turbidity (Data Jam 09:00 Pagi)',
                  unit: 'V',
                  lineColor: Colors.teal.shade600,
                  getValue: (data) => data.turbidity, // Ambil nilai turbidity
                  minYConstraint: 1.8,
                  maxYConstraint: 2.4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
