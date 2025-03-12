import 'dart:async';

import 'package:flutter/scheduler.dart';

/// A utility class to monitor performance metrics in Flutter
class PerformanceMonitor {
  // Singleton instance
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  // Performance metrics
  double _fps = 0;
  double _frameTime = 0;
  int _frameCount = 0;
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  // Callbacks
  Function(double fps)? onFpsUpdate;
  Function(double frameTime)? onFrameTimeUpdate;

  // Start monitoring
  void startMonitoring() {
    if (_timer != null) return;

    _stopwatch = Stopwatch()..start();
    _frameCount = 0;

    // Set up a ticker to count frames
    SchedulerBinding.instance.addPostFrameCallback(_onFrame);

    // Update metrics every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final elapsed = _stopwatch.elapsedMilliseconds;
      if (elapsed > 0) {
        _fps = _frameCount * 1000 / elapsed;
        _frameTime = elapsed / _frameCount;

        // Notify listeners
        onFpsUpdate?.call(_fps);
        onFrameTimeUpdate?.call(_frameTime);

        // Reset counters
        _frameCount = 0;
        _stopwatch.reset();
      }
    });
  }

  // Stop monitoring
  void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
    _stopwatch.stop();
  }

  // Called after each frame
  void _onFrame(Duration timeStamp) {
    if (_timer != null) {
      _frameCount++;
      SchedulerBinding.instance.addPostFrameCallback(_onFrame);
    }
  }

  // Get current FPS
  double get fps => _fps;

  // Get current frame time in milliseconds
  double get frameTime => _frameTime;
}
