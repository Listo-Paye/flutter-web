import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard_benchmark/data/data_provider.dart';

class PieChartImpl extends StatefulWidget {
  final List<DataPoint> data;
  final Map<String, dynamic>? options;

  const PieChartImpl({super.key, required this.data, this.options});

  @override
  State<PieChartImpl> createState() => _PieChartImplState();
}

class _PieChartImplState extends State<PieChartImpl> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PieChartWidget(
      data: widget.data,
      touchedIndex: _touchedIndex,
      onTouchCallback: (FlTouchEvent event, pieTouchResponse) {
        setState(() {
          if (!event.isInterestedForInteractions ||
              pieTouchResponse == null ||
              pieTouchResponse.touchedSection == null) {
            _touchedIndex = -1;
            return;
          }
          _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
        });
      },
    );
  }
}

class PieChartWidget extends StatelessWidget {
  final List<DataPoint> data;
  final int? touchedIndex;
  final void Function(FlTouchEvent, PieTouchResponse?)? onTouchCallback;

  const PieChartWidget({
    super.key,
    required this.data,
    required this.touchedIndex,
    required this.onTouchCallback,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(touchCallback: onTouchCallback),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: _generateSections(),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _generateIndicators(context),
        ),
      ],
    );
  }

  List<PieChartSectionData> _generateSections() {
    return List.generate(data.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      // Calculate percentage
      final total = data.fold(0.0, (sum, item) => sum + item.value);
      final percentage = (data[i].value / total * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: data[i].color ?? chartColors[i % chartColors.length],
        value: data[i].value,
        title: '$percentage%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  List<Widget> _generateIndicators(BuildContext context) {
    return List.generate(data.length, (index) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    data[index].color ??
                    chartColors[index % chartColors.length],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              data[index].label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
              ),
            ),
          ],
        ),
      );
    });
  }
}
