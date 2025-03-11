import 'package:flutter/material.dart';

class ControlPanel extends StatelessWidget {
  final int updateInterval;
  final Function(int) onIntervalChanged;
  final VoidCallback onRefresh;
  final bool isRefreshing;
  final double? cpuUsage;
  final double? memoryUsage;
  final double? fps;

  const ControlPanel({
    super.key,
    required this.updateInterval,
    required this.onIntervalChanged,
    required this.onRefresh,
    required this.isRefreshing,
    this.cpuUsage,
    this.memoryUsage,
    this.fps,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard Controls',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Adjust update frequency and monitor performance',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.spaceBetween,
              children: [
                // Performance metrics
                _buildPerformanceMetrics(context),
                
                // Update interval control
                _buildUpdateIntervalControl(context),
                
                // Refresh button
                _buildRefreshButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetrics(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        _buildMetricChip(
          context,
          Icons.memory,
          'CPU: ${cpuUsage?.toStringAsFixed(1) ?? 'N/A'}%',
          Colors.blue,
        ),
        _buildMetricChip(
          context,
          Icons.storage,
          'Memory: ${memoryUsage?.toStringAsFixed(0) ?? 'N/A'} MB',
          Colors.green,
        ),
        _buildMetricChip(
          context,
          Icons.speed,
          'FPS: ${fps?.toStringAsFixed(0) ?? 'N/A'}',
          Colors.amber,
        ),
      ],
    );
  }

  Widget _buildMetricChip(BuildContext context, IconData icon, String label, Color color) {
    return Chip(
      avatar: Icon(icon, color: color, size: 16),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[800]
          : Colors.grey[200],
    );
  }

  Widget _buildUpdateIntervalControl(BuildContext context) {
    return DropdownButton<int>(
      value: updateInterval,
      hint: const Text('Update interval'),
      onChanged: (value) {
        if (value != null) {
          onIntervalChanged(value);
        }
      },
      items: const [
        DropdownMenuItem(
          value: 500,
          child: Text('0.5s (High CPU usage)'),
        ),
        DropdownMenuItem(
          value: 1000,
          child: Text('1s'),
        ),
        DropdownMenuItem(
          value: 2000,
          child: Text('2s'),
        ),
        DropdownMenuItem(
          value: 5000,
          child: Text('5s'),
        ),
      ],
    );
  }

  Widget _buildRefreshButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onRefresh,
      icon: isRefreshing
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.refresh, size: 16),
      label: const Text('Refresh All'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

