import 'package:flutter/material.dart';
import 'package:flutter_dashboard_benchmark/data/data_provider.dart';
import 'package:flutter_dashboard_benchmark/widgets/app_bar.dart';
import 'package:flutter_dashboard_benchmark/widgets/charts/area_chart.dart';
import 'package:flutter_dashboard_benchmark/widgets/charts/bar_chart.dart';
import 'package:flutter_dashboard_benchmark/widgets/charts/gauge_chart.dart';
import 'package:flutter_dashboard_benchmark/widgets/charts/line_chart.dart';
import 'package:flutter_dashboard_benchmark/widgets/charts/pie_chart.dart';
import 'package:flutter_dashboard_benchmark/widgets/charts/scatter_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DetailedViewScreen extends ConsumerStatefulWidget {
  final String chartId;

  const DetailedViewScreen({super.key, required this.chartId});

  @override
  ConsumerState<DetailedViewScreen> createState() => _DetailedViewScreenState();
}

class _DetailedViewScreenState extends ConsumerState<DetailedViewScreen> {
  double _zoomLevel = 1.0;
  bool _isLoading = false;

  void _handleRefresh() {
    setState(() {
      _isLoading = true;
    });

    ref.read(chartDataProvider.notifier).refreshData();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _handleZoomIn() {
    setState(() {
      _zoomLevel = _zoomLevel + 0.1;
      if (_zoomLevel > 1.5) _zoomLevel = 1.5;
    });
  }

  void _handleZoomOut() {
    setState(() {
      _zoomLevel = _zoomLevel - 0.1;
      if (_zoomLevel < 0.5) _zoomLevel = 0.5;
    });
  }

  void _handleDownload() {
    // In a real app, you would implement actual chart download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chart download functionality would be implemented here'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chartData = ref.watch(chartDataProvider);
    final data = chartData[widget.chartId];

    if (data == null) {
      // Navigate back if chart doesn't exist
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/dashboard');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: '${data.title} - Detailed View',
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/dashboard'),
            tooltip: 'Back to Dashboard',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chart controls
              _buildChartControls(context),

              const SizedBox(height: 16),

              // Chart container
              _buildChartContainer(data),

              const SizedBox(height: 24),

              // Data summary cards
              _buildDataSummaryCards(data),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartControls(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.spaceBetween,
          children: [
            // Refresh button
            ElevatedButton.icon(
              onPressed: _handleRefresh,
              icon:
                  _isLoading
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Icon(Icons.refresh, size: 16),
              label: const Text('Refresh'),
            ),

            // Download button
            OutlinedButton.icon(
              onPressed: _handleDownload,
              icon: const Icon(Icons.download, size: 16),
              label: const Text('Download'),
            ),

            // Zoom controls
            Card(
              margin: EdgeInsets.zero,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.zoom_out),
                    onPressed: _zoomLevel > 0.5 ? _handleZoomOut : null,
                    tooltip: 'Zoom out',
                  ),
                  Text(
                    '${(_zoomLevel * 100).toInt()}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.zoom_in),
                    onPressed: _zoomLevel < 1.5 ? _handleZoomIn : null,
                    tooltip: 'Zoom in',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartContainer(ChartData data) {
    return Card(
      child: Container(
        height: 500,
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Transform.scale(
              scale: _zoomLevel,
              alignment: Alignment.topLeft,
              child: _buildChart(data),
            ),
            if (_isLoading)
              Container(
                color: Colors.white.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(ChartData data) {
    switch (data.type) {
      case 'line':
        return LineChartImpl(data: data.data, options: data.options);
      case 'bar':
        return BarChartImpl(data: data.data, options: data.options);
      case 'pie':
        return PieChartImpl(data: data.data, options: data.options);
      case 'gauge':
        return GaugeChart(data: data.data, options: data.options);
      case 'area':
        return AreaChart(data: data.data, options: data.options);
      case 'scatter':
        return ScatterChartImpl(data: data.data, options: data.options);
      default:
        return const Center(child: Text('Unsupported chart type'));
    }
  }

  Widget _buildDataSummaryCards(ChartData data) {
    // Calculate statistics
    final total = data.data.fold(0.0, (sum, item) => sum + item.value);
    final average = total / data.data.length;
    final maxValue = data.data
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);
    final minValue = data.data
        .map((e) => e.value)
        .reduce((a, b) => a < b ? a : b);

    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // Data Summary Card
        _buildSummaryCard(
          title: 'Data Summary',
          content: [
            'Total data points: ${data.data.length}',
            'Average value: ${average.toStringAsFixed(2)}',
            'Max value: ${maxValue.toStringAsFixed(2)}',
            'Min value: ${minValue.toStringAsFixed(2)}',
          ],
        ),

        // Chart Information Card
        _buildSummaryCard(
          title: 'Chart Information',
          content: [
            'Type: ${data.type}',
            'Last updated: Just now',
            'Update frequency: Real-time',
            'Data source: Simulated',
          ],
        ),

        // Actions Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Actions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Export Data as CSV'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Share Chart'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required List<String> content,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...content.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(item),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
