import 'package:flutter/material.dart';

/// A widget that displays a loading spinner while a deferred component loads
class DeferredWidget extends StatelessWidget {
  /// The function that loads the deferred library
  final Future<dynamic> Function() libraryLoader;
  
  /// The function that returns the widget once loaded
  final Widget Function() builder;

  const DeferredWidget(this.libraryLoader, this.builder, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: libraryLoader(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading component: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return builder();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

