import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard_benchmark/data/data_provider.dart';

class AreaChart extends StatelessWidget {
  final List<DataPoint> data;
  final Map<String, dynamic>? options;

  const AreaChart({super.key, required this.data, this.options});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AreaChartWidget(
      data: data,
      lineColor: isDarkMode ? Colors.blue : Colors.blue.shade700,
      gradientColors: [
        isDarkMode
            ? Colors.blue.withOpacity(0.3)
            : Colors.blue.withOpacity(0.2),
        isDarkMode
            ? Colors.blue.withOpacity(0.0)
            : Colors.blue.withOpacity(0.0),
      ],
      tension: options?['tension'] ?? 0.4,
      pointRadius: options?['pointRadius'] ?? 2.0,
    );
  }
}

class AreaChartWidget extends StatelessWidget {
  final List<DataPoint> data;
  final Color lineColor;
  final List<Color> gradientColors;
  final double tension;
  final double pointRadius;

  const AreaChartWidget({
    super.key,
    required this.data,
    required this.lineColor,
    required this.gradientColors,
    this.tension = 0.4,
    this.pointRadius = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) {
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
              interval: data.length > 10 ? 2 : 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= data.length || value < 0) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    data[value.toInt()].label,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
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
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: data.length - 1.0,
        minY: 0,
        maxY: 100,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 8,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final index = barSpot.x.toInt();
                if (index >= 0 && index < data.length) {
                  return LineTooltipItem(
                    '${data[index].label}: ${barSpot.y.toStringAsFixed(1)}',
                    TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return null;
                }
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(data.length, (index) {
              return FlSpot(index.toDouble(), data[index].value);
            }),
            isCurved: true,
            curveSmoothness: tension,
            color: lineColor,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: pointRadius,
                  color: lineColor,
                  strokeWidth: 1,
                  strokeColor: isDarkMode ? Colors.white : Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
