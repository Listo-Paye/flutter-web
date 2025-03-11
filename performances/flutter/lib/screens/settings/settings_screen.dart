import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dashboard_benchmark/data/data_provider.dart';
import 'package:flutter_dashboard_benchmark/theme/theme_provider.dart';
import 'package:flutter_dashboard_benchmark/widgets/app_bar.dart';
import 'package:flutter_dashboard_benchmark/widgets/app_drawer.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _showSuccessMessage = false;
  bool _enableFpsCounter = true;
  bool _enablePerformanceMode = false;
  bool _enableLazyLoading = true;
  double _animationSpeed = 500;

  void _handleSubmit() {
    setState(() {
      _showSuccessMessage = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showSuccessMessage = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final updateInterval = ref.watch(updateIntervalProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_showSuccessMessage)
                    Card(
                      color: Colors.green.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green.shade700),
                            const SizedBox(width: 16),
                            Text(
                              'Settings saved successfully!',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // General Settings
                  _buildSettingsCard(
                    title: 'General Settings',
                    children: [
                      // Theme setting
                      const Text(
                        'Theme',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.light,
                            label: Text('Light'),
                            icon: Icon(Icons.light_mode),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.dark,
                            label: Text('Dark'),
                            icon: Icon(Icons.dark_mode),
                          ),
                        ],
                        selected: {themeMode},
                        onSelectionChanged: (Set<ThemeMode> selection) {
                          if (selection.isNotEmpty) {
                            ref.read(themeModeProvider.notifier).toggleTheme();
                          }
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Update interval setting
                      const Text(
                        'Data Update Interval',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: updateInterval,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(updateIntervalProvider.notifier).state = value;
                            ref.read(chartDataProvider.notifier).updateInterval(value);
                          }
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 500,
                            child: Text('0.5 seconds (High CPU usage)'),
                          ),
                          DropdownMenuItem(
                            value: 1000,
                            child: Text('1 second'),
                          ),
                          DropdownMenuItem(
                            value: 2000,
                            child: Text('2 seconds'),
                          ),
                          DropdownMenuItem(
                            value: 5000,
                            child: Text('5 seconds'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Faster updates will increase CPU usage and may affect performance.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Chart Settings
                  _buildSettingsCard(
                    title: 'Chart Settings',
                    children: [
                      // Animation speed
                      const Text(
                        'Animation Speed',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: _animationSpeed,
                        min: 100,
                        max: 1000,
                        divisions: 9,
                        label: '${_animationSpeed.round()} ms',
                        onChanged: (value) {
                          setState(() {
                            _animationSpeed = value;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Fast',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Slow',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Smooth transitions
                      SwitchListTile(
                        title: const Text('Enable smooth transitions'),
                        value: true,
                        onChanged: (value) {},
                      ),
                      
                      // Show tooltips
                      SwitchListTile(
                        title: const Text('Show tooltips on hover'),
                        value: true,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Performance Settings
                  _buildSettingsCard(
                    title: 'Performance Settings',
                    children: [
                      // FPS counter
                      SwitchListTile(
                        title: const Text('Show FPS counter'),
                        value: _enableFpsCounter,
                        onChanged: (value) {
                          setState(() {
                            _enableFpsCounter = value;
                          });
                        },
                      ),
                      
                      // Performance mode
                      SwitchListTile(
                        title: const Text('Enable high performance mode (reduces animations)'),
                        value: _enablePerformanceMode,
                        onChanged: (value) {
                          setState(() {
                            _enablePerformanceMode = value;
                          });
                        },
                      ),
                      
                      // Lazy loading
                      SwitchListTile(
                        title: const Text('Enable lazy loading for charts'),
                        value: _enableLazyLoading,
                        onChanged: (value) {
                          setState(() {
                            _enableLazyLoading = value;
                          });
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Save button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text('Save Settings'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

