import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web/services/auth_service.dart';
import 'package:flutter_web/widgets/app_layout.dart';
import 'package:flutter_web/widgets/dashboard_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;
    
    return AppLayout(
      title: 'Dashboard',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Welcome, ${user?.name ?? 'User'}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 32),
            GridView.count(
              crossAxisCount: _getColumnCount(context),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                DashboardCard(
                  title: 'Personal Information',
                  description: 'View and manage your personal information',
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                ),
                const DashboardCard(
                  title: 'Security Settings',
                  description: 'Manage your security preferences and password',
                  onTap: null, // Not implemented in this example
                ),
                const DashboardCard(
                  title: 'Notifications',
                  description: 'Configure your notification preferences',
                  onTap: null, // Not implemented in this example
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _getColumnCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 3;
    if (width > 800) return 2;
    return 1;
  }
}

