import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/monitoring_data.dart';

class CustomLineChart extends StatelessWidget {
  final List<MonitoringData> data;
  final String title;
  final String unit;
  final Color lineColor;
  final double Function(MonitoringData) getValue;
  final double? minYConstraint;
  final double? maxYConstraint;


  const CustomLineChart({
    super.key,
    required this.data,
    required this.title,
    required this.unit,
    required this.lineColor,
    required this.getValue,
    this.minYConstraint,
    this.maxYConstraint,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada data $title yang tersedia untuk periode ini.',
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }

    data.sort((a, b) => a.waktu.compareTo(b.waktu));

    final Map<String, MonitoringData> groupedByDate = {};
    for (var item in data) {
      final dateKey = DateFormat('yyyy-MM-dd').format(item.waktu);
      groupedByDate[dateKey] = item;
    }

    final filteredData = groupedByDate.values.toList()
      ..sort((a, b) => a.waktu.compareTo(b.waktu));


    final spots = filteredData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), getValue(entry.value));
    }).toList();

    double minX = 0;
    double maxX = (filteredData.length - 1).toDouble();

    double calculatedMinY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b) - (spots.length > 1 ? 1 : 0.5);
    double calculatedMaxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + (spots.length > 1 ? 1 : 0.5);

    if (spots.length == 1) {
      calculatedMinY = spots.first.y - 0.5;
      calculatedMaxY = spots.first.y + 0.5;
    }

    double minY = minYConstraint ?? calculatedMinY;
    double maxY = maxYConstraint ?? calculatedMaxY;


    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: LineChart(
                LineChartData(

                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Color.fromARGB(255, 55, 67, 77).withOpacity(0.2),
                        strokeWidth: 0.5,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Color.fromARGB(255, 55, 67, 77).withOpacity(0.2),
                        strokeWidth: 0.5,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < filteredData.length) {
                            final DateTime date = filteredData[index].waktu;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(DateFormat('dd/MM').format(date), textAlign: TextAlign.center),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toStringAsFixed(1)} $unit');
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: const Color(0xff37434d).withOpacity(0.5), width: 1),
                  ),
                  minX: minX,
                  maxX: maxX,
                  minY: minY,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: lineColor,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            lineColor.withOpacity(0.4),
                            lineColor.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) {
                        return Colors.blueAccent.withOpacity(0.8);
                      },
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final dataPoint = filteredData[touchedSpot.x.toInt()];
                          final time = DateFormat('dd/MM HH:mm').format(dataPoint.waktu);
                          return LineTooltipItem(
                            '${getValue(dataPoint).toStringAsFixed(1)} $unit\n$time',
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          );
                        }).toList();
                      },
                    ),
                    getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                      return spotIndexes.map((spotIndex) {
                        return TouchedSpotIndicatorData(
                          FlLine(color: Colors.black, strokeWidth: 2),
                          FlDotData(
                            getDotPainter: (spot, percent, bar, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: Colors.white,
                                strokeWidth: 2,
                                strokeColor: barData.color!,
                              );
                            },
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
