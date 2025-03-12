import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// A utility class to optimize images for better performance
class ImageOptimizer {
  // Cache for decoded images
  static final Map<String, ui.Image> _imageCache = {};

  // Load and cache an image
  static Future<ui.Image> loadImage(String assetPath) async {
    // Check if image is already cached
    if (_imageCache.containsKey(assetPath)) {
      return _imageCache[assetPath]!;
    }

    // Load the image
    final completer = Completer<ui.Image>();
    final imageProvider = AssetImage(assetPath);

    final imageStream = imageProvider.resolve(const ImageConfiguration());
    final listener = ImageStreamListener((info, _) {
      completer.complete(info.image);
      _imageCache[assetPath] = info.image;
    });

    imageStream.addListener(listener);

    return completer.future;
  }

  // Clear the image cache
  static void clearCache() {
    _imageCache.clear();
  }

  // Resize an image to a specific size
  static Future<ui.Image> resizeImage(
    ui.Image image,
    int targetWidth,
    int targetHeight,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final src = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final dst = Rect.fromLTWH(
      0,
      0,
      targetWidth.toDouble(),
      targetHeight.toDouble(),
    );

    canvas.drawImageRect(image, src, dst, Paint());

    final picture = recorder.endRecording();
    return picture.toImage(targetWidth, targetHeight);
  }
}
