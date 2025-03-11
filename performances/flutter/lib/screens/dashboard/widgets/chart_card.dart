import 'package:flutter/material.dart';
import 'package:flutter_dashboard_benchmark/data/data_provider.dart';
import 'package:flutter_dashboard_benchmark/widgets/charts/area_chart.dart';
import 'package:flutter_dashboard_benchmark/widgets/charts/bar_chart.dart';
import 'package:flutter_dashboard_benchmark/widgets/charts/gauge_chart.dart';
import 'package:flutter_dashboard_benchmark/widgets/charts/line_chart.dart';
import 'package:flutter_dashboard_benchmark/widgets/charts/pie_chart.dart';
import 'package:flutter_dashboard_benchmark/widgets/charts/scatter_chart.dart';

class ChartCard extends StatefulWidget {
  final String chartId;
  final ChartData data;
  final VoidCallback onTap;

  const ChartCard({
    super.key,
    required this.chartId,
    required this.data,
    required this.onTap,
  });

  @override
  State<ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {
  bool _isHovering = false;
  bool _isLoading = false;

  void _handleRefresh() {
    setState(() {
      _isLoading = true;
    });

    // Simulate refresh delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (hovering) {
        setState(() {
          _isHovering = hovering;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Card(
        elevation: _isHovering ? 4 : 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.data.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon:
                            _isLoading
                                ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Icon(Icons.refresh, size: 18),
                        onPressed: _handleRefresh,
                        tooltip: 'Refresh chart',
                        iconSize: 18,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.fullscreen, size: 18),
                        onPressed: widget.onTap,
                        tooltip: 'Expand chart',
                        iconSize: 18,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: _buildChart(),
                  ),
                  if (_isLoading)
                    Container(
                      color: Colors.white.withOpacity(0.5),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
            // Interactive footer that appears on hover
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _isHovering ? 40 : 0,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[200],
              child:
                  _isHovering
                      ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Updated just now',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Click to view details',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                      : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    switch (widget.data.type) {
      case 'line':
        return LineChartImpl(
          data: widget.data.data,
          options: widget.data.options,
        );
      case 'bar':
        return BarChartImpl(
          data: widget.data.data,
          options: widget.data.options,
        );
      case 'pie':
        return PieChartImpl(
          data: widget.data.data,
          options: widget.data.options,
        );
      case 'gauge':
        return GaugeChart(data: widget.data.data, options: widget.data.options);
      case 'area':
        return AreaChart(data: widget.data.data, options: widget.data.options);
      case 'scatter':
        return ScatterChartImpl(
          data: widget.data.data,
          options: widget.data.options,
        );
      default:
        return const Center(child: Text('Unsupported chart type'));
    }
  }
}
