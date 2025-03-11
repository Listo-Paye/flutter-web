import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Data point model
class DataPoint {
  final String label;
  final double value;
  final double? secondaryValue;
  final Color? color;

  DataPoint({
    required this.label,
    required this.value,
    this.secondaryValue,
    this.color,
  });

  DataPoint copyWith({
    String? label,
    double? value,
    double? secondaryValue,
    Color? color,
  }) {
    return DataPoint(
      label: label ?? this.label,
      value: value ?? this.value,
      secondaryValue: secondaryValue ?? this.secondaryValue,
      color: color ?? this.color,
    );
  }
}

// Chart data model
class ChartData {
  final String type;
  final String title;
  final List<DataPoint> data;
  final Map<String, dynamic>? options;

  ChartData({
    required this.type,
    required this.title,
    required this.data,
    this.options,
  });
}

// Colors for charts
const List<Color> chartColors = [
  Color(0xFFFF6384),
  Color(0xFF36A2EB),
  Color(0xFFFFCE56),
  Color(0xFF4BC0C0),
  Color(0xFF9966FF),
  Color(0xFFFF9F40),
  Color(0xFF8AC926),
  Color(0xFF1982C4),
  Color(0xFF6A4C93),
  Color(0xFFF94144),
];

// Data generator utility
class DataGenerator {
  static ChartData generateRandomData(String type, int count) {
    final data = <DataPoint>[];
    final random = Random();

    for (int i = 0; i < count; i++) {
      final point = DataPoint(
        label: type == 'line' || type == 'area' ? 'T$i' : 'Category ${i + 1}',
        value: random.nextDouble() * 100,
        secondaryValue: type == 'scatter' ? random.nextDouble() * 100 : null,
        color: type == 'pie' ? chartColors[i % chartColors.length] : null,
      );
      data.add(point);
    }

    return ChartData(
      type: type,
      title: '${type[0].toUpperCase()}${type.substring(1)} Chart',
      data: data,
      options: _getDefaultOptions(type),
    );
  }

  static Map<String, dynamic>? _getDefaultOptions(String type) {
    switch (type) {
      case 'line':
        return {'tension': 0.4, 'fill': false, 'pointRadius': 3};
      case 'area':
        return {'tension': 0.4, 'fill': true, 'pointRadius': 2};
      case 'gauge':
        return {'min': 0, 'max': 100, 'arcWidth': 0.2};
      default:
        return {};
    }
  }
}

// Provider for update interval
final updateIntervalProvider = StateProvider<int>((ref) => 2000);

// Provider for chart data
final chartDataProvider =
    StateNotifierProvider<ChartDataNotifier, Map<String, ChartData>>((ref) {
      return ChartDataNotifier(ref);
    });

// Notifier to handle chart data updates
class ChartDataNotifier extends StateNotifier<Map<String, ChartData>> {
  final Ref _ref;
  Timer? _updateTimer;

  ChartDataNotifier(this._ref) : super({}) {
    _initializeData();
  }

  // Initialize data
  Future<void> _initializeData() async {
    final initialData = {
      'line-chart': DataGenerator.generateRandomData('line', 20),
      'bar-chart': DataGenerator.generateRandomData('bar', 12),
      'pie-chart': DataGenerator.generateRandomData('pie', 6),
      'gauge-chart': DataGenerator.generateRandomData('gauge', 1),
      'area-chart': DataGenerator.generateRandomData('area', 15),
      'scatter-chart': DataGenerator.generateRandomData('scatter', 30),
    };

    state = initialData;
    _setupUpdateTimer();
  }

  // Set up timer for real-time updates
  void _setupUpdateTimer() {
    // Cancel existing timer if any
    _updateTimer?.cancel();

    // Create new timer with current interval
    final updateInterval = _ref.read(updateIntervalProvider);
    _updateTimer = Timer.periodic(Duration(milliseconds: updateInterval), (_) {
      refreshData();
    });
  }

  // Update interval changed
  void updateInterval(int newInterval) {
    _setupUpdateTimer();
  }

  // Refresh all chart data
  void refreshData() {
    final newData = Map<String, ChartData>.from(state);
    final random = Random();

    // Update each chart with new data points
    newData.forEach((chartId, chartData) {
      switch (chartData.type) {
        case 'line':
        case 'area':
          // Add a new point and remove the oldest one
          final newPoint = DataPoint(
            label: 'T${chartData.data.length + 1}',
            value: random.nextDouble() * 100,
          );

          final updatedData = List<DataPoint>.from(chartData.data);
          updatedData.removeAt(0);
          updatedData.add(newPoint);

          newData[chartId] = ChartData(
            type: chartData.type,
            title: chartData.title,
            data: updatedData,
            options: chartData.options,
          );
          break;

        case 'bar':
          // Update existing bar values
          final updatedData =
              chartData.data.map((point) {
                return point.copyWith(
                  value: point.value + (random.nextDouble() * 10 - 5),
                );
              }).toList();

          newData[chartId] = ChartData(
            type: chartData.type,
            title: chartData.title,
            data: updatedData,
            options: chartData.options,
          );
          break;

        case 'pie':
          // Update pie chart segments
          final updatedData =
              chartData.data.map((point) {
                return point.copyWith(
                  value: max(5, point.value + (random.nextDouble() * 10 - 5)),
                );
              }).toList();

          newData[chartId] = ChartData(
            type: chartData.type,
            title: chartData.title,
            data: updatedData,
            options: chartData.options,
          );
          break;

        case 'gauge':
          // Update gauge value
          final currentValue = chartData.data[0].value;
          final newValue = min(
            100,
            max(0, currentValue + (random.nextDouble() * 10 - 5)),
          );

          final updatedData = [
            chartData.data[0].copyWith(value: newValue.toDouble()),
          ];

          newData[chartId] = ChartData(
            type: chartData.type,
            title: chartData.title,
            data: updatedData,
            options: chartData.options,
          );
          break;

        case 'scatter':
          // Update scatter plot points
          final updatedData =
              chartData.data.map((point) {
                return point.copyWith(
                  value: point.value + (random.nextDouble() * 6 - 3),
                  secondaryValue:
                      (point.secondaryValue ?? 0) +
                      (random.nextDouble() * 6 - 3),
                );
              }).toList();

          newData[chartId] = ChartData(
            type: chartData.type,
            title: chartData.title,
            data: updatedData,
            options: chartData.options,
          );
          break;
      }
    });

    state = newData;
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
}

// Performance metrics provider
final performanceMetricsProvider =
    StateNotifierProvider<PerformanceMetricsNotifier, PerformanceMetrics>((
      ref,
    ) {
      return PerformanceMetricsNotifier();
    });

// Performance metrics model
class PerformanceMetrics {
  final double? cpuUsage;
  final double? memoryUsage;
  final double? fps;

  PerformanceMetrics({this.cpuUsage, this.memoryUsage, this.fps});

  PerformanceMetrics copyWith({
    double? cpuUsage,
    double? memoryUsage,
    double? fps,
  }) {
    return PerformanceMetrics(
      cpuUsage: cpuUsage ?? this.cpuUsage,
      memoryUsage: memoryUsage ?? this.memoryUsage,
      fps: fps ?? this.fps,
    );
  }
}

// Notifier to handle performance metrics
class PerformanceMetricsNotifier extends StateNotifier<PerformanceMetrics> {
  Timer? _metricsTimer;

  PerformanceMetricsNotifier() : super(PerformanceMetrics()) {
    _startMonitoring();
  }

  void _startMonitoring() {
    _metricsTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _updateMetrics();
    });
    _updateMetrics(); // Initial update
  }

  void _updateMetrics() {
    final random = Random();

    // Simulate CPU usage (10-40%)
    final cpuUsage = random.nextDouble() * 30 + 10;

    // Simulate memory usage (100-300MB)
    final memoryUsage = random.nextDouble() * 200 + 100;

    // Simulate FPS (40-60)
    final fps = random.nextDouble() * 20 + 40;

    state = state.copyWith(
      cpuUsage: cpuUsage,
      memoryUsage: memoryUsage,
      fps: fps,
    );
  }

  @override
  void dispose() {
    _metricsTimer?.cancel();
    super.dispose();
  }
}
