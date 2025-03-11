import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dashboard_benchmark/data/data_provider.dart';
import 'package:flutter_dashboard_benchmark/screens/dashboard/widgets/control_panel.dart';
import 'package:flutter_dashboard_benchmark/screens/dashboard/widgets/chart_card.dart';
import 'package:flutter_dashboard_benchmark/widgets/app_drawer.dart';
import 'package:flutter_dashboard_benchmark/widgets/app_bar.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleRefresh() {
    setState(() {
      _isRefreshing = true;
    });
    
    ref.read(chartDataProvider.notifier).refreshData();
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    });
  }

  void _handleChartTap(String chartId) {
    context.go('/detailed/$chartId');
  }

  @override
  Widget build(BuildContext context) {
    final chartData = ref.watch(chartDataProvider);
    final updateInterval = ref.watch(updateIntervalProvider);
    final performanceMetrics = ref.watch(performanceMetricsProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Dashboard'),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ControlPanel(
                  updateInterval: updateInterval,
                  onIntervalChanged: (value) {
                    ref.read(updateIntervalProvider.notifier).state = value;
                    ref.read(chartDataProvider.notifier).updateInterval(value);
                  },
                  onRefresh: _handleRefresh,
                  isRefreshing: _isRefreshing,
                  cpuUsage: performanceMetrics.cpuUsage,
                  memoryUsage: performanceMetrics.memoryUsage,
                  fps: performanceMetrics.fps,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 500.0,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 1.2,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final entry = chartData.entries.elementAt(index);
                    return AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                index * 0.1,
                                0.1 + index * 0.1,
                                curve: Curves.easeOut,
                              ),
                            ),
                          ),
                          child: child,
                        );
                      },
                      child: ChartCard(
                        chartId: entry.key,
                        data: entry.value,
                        onTap: () => _handleChartTap(entry.key),
                      ),
                    );
                  },
                  childCount: chartData.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animationController.forward();
  }
}

