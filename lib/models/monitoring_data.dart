class MonitoringData {
  final int id;
  final double suhu;
  final double turbidity;
  final DateTime waktu;

  MonitoringData({
    required this.id,
    required this.suhu,
    required this.turbidity,
    required this.waktu,
  });

  factory MonitoringData.fromJson(Map<String, dynamic> json) {
    // Pastikan parsing robust untuk data yang mungkin berupa string
    final int parsedId = int.tryParse(json['id']?.toString() ?? '0') ?? 0;
    final double parsedSuhu = double.tryParse(json['suhu']?.toString() ?? '0.0') ?? 0.0;
    final double parsedTurbidity = double.tryParse(json['turbidity']?.toString() ?? '0.0') ?? 0.0;
    final DateTime parsedWaktu = DateTime.parse(json['waktu']?.toString() ?? DateTime.now().toIso8601String());

    return MonitoringData(
      id: parsedId,
      suhu: parsedSuhu,
      turbidity: parsedTurbidity,
      waktu: parsedWaktu,
    );
  }
}
