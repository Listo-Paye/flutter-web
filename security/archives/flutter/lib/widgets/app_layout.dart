import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web/services/auth_service.dart';

class AppLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const AppLayout({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          TextButton(
            onPressed: () => authService.logout(),
            child: const Text('Logout'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: MediaQuery.of(context).size.width < 800
          ? _buildDrawer(context)
          : null,
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 800) _buildSidebar(context),
          Expanded(
            child: child,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
        child: Text(
          '© ${DateTime.now().year} Secure User Management',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      child: _buildNavItems(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: _buildNavItems(context),
    );
  }

  Widget _buildNavItems(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Color(0xFF3B82F6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'User Management',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Secure account management',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.dashboard),
          title: const Text('Dashboard'),
          selected: currentRoute == '/dashboard' || currentRoute == '/',
          selectedColor: const Color(0xFF3B82F6),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
            if (MediaQuery.of(context).size.width < 800) {
              Navigator.pop(context); // Close drawer on mobile
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Profile'),
          selected: currentRoute == '/profile',
          selectedColor: const Color(0xFF3B82F6),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/profile');
            if (MediaQuery.of(context).size.width < 800) {
              Navigator.pop(context); // Close drawer on mobile
            }
          },
        ),
      ],
    );
  }
}

