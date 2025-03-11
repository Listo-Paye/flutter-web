import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_dashboard_benchmark/data/data_provider.dart';

class GaugeChart extends StatelessWidget {
  final List<DataPoint> data;
  final Map<String, dynamic>? options;

  const GaugeChart({super.key, required this.data, this.options});

  @override
  Widget build(BuildContext context) {
    // Get the value from the first data point
    final value = data.isNotEmpty ? data[0].value : 0;
    final min = options?['min'] ?? 0.0;
    final max = options?['max'] ?? 100.0;
    final arcWidth = options?['arcWidth'] ?? 0.2;

    // Calculate percentage for coloring
    final percentage = (value - min) / (max - min);

    // Determine color based on percentage
    Color color;
    if (percentage < 0.3) {
      color = Colors.green;
    } else if (percentage < 0.7) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return GaugeChartWidget(
      value: value.toDouble(),
      min: min,
      max: max,
      color: color,
      arcWidth: arcWidth,
      label: data.isNotEmpty ? data[0].label : 'Value',
    );
  }
}

class GaugeChartWidget extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final Color color;
  final double arcWidth;
  final String label;

  const GaugeChartWidget({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.color,
    required this.arcWidth,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight);

        return Center(
          child: SizedBox(
            width: size,
            height: size, // Half circle + space for text
            child: Column(
              children: [
                SizedBox(
                  width: size,
                  height: size / 2,
                  child: CustomPaint(
                    painter: GaugePainter(
                      value: value,
                      min: min,
                      max: max,
                      color: color,
                      backgroundColor:
                          isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                      arcWidth: arcWidth,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${value.round()}%',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GaugePainter extends CustomPainter {
  final double value;
  final double min;
  final double max;
  final Color color;
  final Color backgroundColor;
  final double arcWidth;

  GaugePainter({
    required this.value,
    required this.min,
    required this.max,
    required this.color,
    required this.backgroundColor,
    required this.arcWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    // Calculate the angle for the gauge
    final percentage = (value - min) / (max - min);
    final angle = percentage * math.pi;

    // Draw background arc
    final backgroundPaint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * arcWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * (1 - arcWidth / 2)),
      0,
      math.pi,
      false,
      backgroundPaint,
    );

    // Draw value arc
    final valuePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * arcWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * (1 - arcWidth / 2)),
      0,
      angle,
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(GaugePainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.min != min ||
        oldDelegate.max != max ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.arcWidth != arcWidth;
  }
}
