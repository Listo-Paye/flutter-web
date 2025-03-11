import 'dart:async';

import 'package:flutter/material.dart';

/// A utility class to manage memory usage in the app
class MemoryManager {
  // Singleton instance
  static final MemoryManager _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  // Memory cleanup timer
  Timer? _cleanupTimer;

  // Start periodic memory cleanup
  void startPeriodicCleanup({Duration interval = const Duration(minutes: 5)}) {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(interval, (_) => performCleanup());
  }

  // Stop periodic cleanup
  void stopPeriodicCleanup() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }

  // Perform memory cleanup
  void performCleanup() {
    // Clear image caches
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();

    // Suggest garbage collection
    // Note: This doesn't guarantee GC will run, it's just a suggestion
    // to the Dart VM that now might be a good time to run GC
    // ignore: unused_local_variable
    final dummy = <Object>[];
    dummy.clear();
  }
}
