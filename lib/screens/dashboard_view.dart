import 'package:flutter/material.dart';
import 'package:monitoring_app/models/monitoring_data.dart';
import 'package:monitoring_app/widgets/data_card.dart';

class DashboardView extends StatefulWidget {
  final MonitoringData? latestData;
  final bool isLoading;
  final String? errorMessage;

  const DashboardView({
    Key? key,
    required this.latestData,
    required this.isLoading,
    this.errorMessage,
  }) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final ValueNotifier<String> suhuValue = ValueNotifier<String>('-');
  final ValueNotifier<String> turbidityValue = ValueNotifier<String>('-');

  @override
  void didUpdateWidget(covariant DashboardView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Hanya perbarui data jika ada perubahan
    if (widget.latestData != null && !widget.isLoading) {
      final newSuhu = widget.latestData!.suhu.toStringAsFixed(1);
      final newTurbidity = widget.latestData!.turbidity.toStringAsFixed(1);

      if (suhuValue.value != newSuhu) {
        suhuValue.value = newSuhu;
      }

      if (turbidityValue.value != newTurbidity) {
        turbidityValue.value = newTurbidity;
      }
    }
  }

  @override
  void dispose() {
    suhuValue.dispose();
    turbidityValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
    }

    if (widget.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
              const SizedBox(height: 10),
              Text(
                'Gagal memuat data: ${widget.errorMessage}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    }

    if (widget.latestData == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.info_outline, color: Colors.blueGrey, size: 60),
              SizedBox(height: 10),
              Text(
                'Tidak ada data monitoring yang tersedia.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueGrey, fontSize: 16),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        double width = constraints.maxWidth;
        if (width < 400) {
          crossAxisCount = 1;
        } else if (width >= 800) {
          crossAxisCount = 3;
        }
        return GridView.count(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          padding: const EdgeInsets.all(15),
          children: [
            DataCard(
              title: 'Suhu',
              valueNotifier: suhuValue,
              unit: '°C',
              icon: Icons.thermostat_rounded,
              color: Colors.red.shade600, // dipertahankan
            ),
            DataCard(
              title: 'Turbidity',
              valueNotifier: turbidityValue,
              unit: 'NTU',
              icon: Icons.waves_rounded,
              color: Colors.blue.shade600, // dipertahankan
            ),
          ],
        );
      },
    );
  }
}
