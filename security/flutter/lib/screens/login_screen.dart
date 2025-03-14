import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web/services/auth_service.dart';
import 'package:universal_html/html.dart' as html;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    // Check if this is a callback from Keycloak
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForAuthCode();
    });
  }

  void _checkForAuthCode() async {
    final uri = Uri.parse(html.window.location.href);
    final code = uri.queryParameters['code'];
    
    if (code != null) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final success = await authService.handleAuthCallback(code);
      
      if (success) {
        // Remove code from URL for security
        html.window.history.pushState({}, '', '/dashboard');
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'User Account Management',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Secure authentication and profile management',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authService.isLoading ? null : () => authService.login(),
                      child: authService.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Login with Keycloak'),
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
}

