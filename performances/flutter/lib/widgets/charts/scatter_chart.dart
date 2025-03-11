import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard_benchmark/data/data_provider.dart';

class ScatterChartImpl extends StatelessWidget {
  final List<DataPoint> data;
  final Map<String, dynamic>? options;

  const ScatterChartImpl({super.key, required this.data, this.options});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ScatterChartWidget(
      data: data,
      dotColor:
          isDarkMode
              ? Colors.blue.withOpacity(0.7)
              : Colors.blue.shade700.withOpacity(0.7),
      dotBorderColor: isDarkMode ? Colors.blue.shade900 : Colors.blue.shade900,
    );
  }
}

class ScatterChartWidget extends StatelessWidget {
  final List<DataPoint> data;
  final Color dotColor;
  final Color dotBorderColor;

  const ScatterChartWidget({
    super.key,
    required this.data,
    required this.dotColor,
    required this.dotBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ScatterChart(
      ScatterChartData(
        scatterSpots: List.generate(data.length, (index) {
          return ScatterSpot(
            data[index].value,
            data[index].secondaryValue ?? 50.0,
            dotPainter: FlDotCirclePainter(
              color: dotColor,
              strokeColor: dotBorderColor,
              strokeWidth: 1,
              radius: 6,
            ),
          );
        }),
        minX: 0,
        maxX: 100,
        minY: 0,
        maxY: 100,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          horizontalInterval: 20,
          verticalInterval: 20,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: isDarkMode ? Colors.white10 : Colors.black12,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: isDarkMode ? Colors.white10 : Colors.black12,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 20,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
        ),
        scatterTouchData: ScatterTouchData(
          enabled: true,
          touchTooltipData: ScatterTouchTooltipData(
            tooltipRoundedRadius: 8,
            getTooltipItems: (ScatterSpot touchedBarSpot) {
              return ScatterTooltipItem(
                'X: ${touchedBarSpot.x.toStringAsFixed(1)}, Y: ${touchedBarSpot.y.toStringAsFixed(1)}',
                textStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
