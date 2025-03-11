import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Flutter Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Performance Benchmark',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildNavItem(
            context,
            icon: Icons.dashboard,
            title: 'Dashboard',
            route: '/dashboard',
          ),
          _buildNavItem(
            context,
            icon: Icons.bar_chart,
            title: 'Analytics',
            route: '/analytics',
          ),
          _buildNavItem(
            context,
            icon: Icons.timeline,
            title: 'Activity',
            route: '/activity',
          ),
          _buildNavItem(
            context,
            icon: Icons.people,
            title: 'Users',
            route: '/users',
          ),
          _buildNavItem(
            context,
            icon: Icons.settings,
            title: 'Settings',
            route: '/settings',
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              // Show about dialog
              showAboutDialog(
                context: context,
                applicationName: 'Flutter Dashboard Benchmark',
                applicationVersion: '1.0.0',
                applicationIcon: const FlutterLogo(size: 32),
                children: [
                  const Text(
                    'A performance benchmark application comparing Flutter Web with React.',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final isSelected = GoRouterState.of(context).matchedLocation == route;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context); // Close drawer
        if (!isSelected) {
          context.go(route);
        }
      },
    );
  }
}

