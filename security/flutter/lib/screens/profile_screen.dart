import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web/services/auth_service.dart';
import 'package:flutter_web/widgets/app_layout.dart';
import 'package:flutter_web/widgets/profile_form.dart';
import 'package:flutter_web/models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  String? _successMessage;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;
    
    if (user == null) {
      return const AppLayout(
        title: 'Profile',
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return AppLayout(
      title: 'Profile',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Information',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            if (_successMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  border: Border.all(color: const Color(0xFF10B981)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _successMessage!,
                  style: const TextStyle(color: Color(0xFF10B981)),
                ),
              ),
              
            if (_errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  border: Border.all(color: const Color(0xFFEF4444)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Color(0xFFEF4444)),
                ),
              ),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: _isEditing
                    ? ProfileForm(
                        user: user,
                        onSubmit: _handleSubmit,
                        onCancel: () => setState(() => _isEditing = false),
                      )
                    : _buildProfileInfo(user),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileField('Name', user.name),
        const SizedBox(height: 16),
        _buildProfileField('Email', user.email),
        const SizedBox(height: 16),
        _buildProfileField('Phone', user.phone ?? 'Not provided'),
        const SizedBox(height: 16),
        _buildProfileField('Address', user.address ?? 'Not provided'),
        const SizedBox(height: 24),
        SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: () => setState(() => _isEditing = true),
            child: const Text('Edit Profile'),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Future<void> _handleSubmit(Map<String, String> data) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    final success = await authService.updateProfile(data);
    
    setState(() {
      _isEditing = false;
      if (success) {
        _successMessage = 'Profile updated successfully';
        _errorMessage = null;
        
        // Clear success message after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() => _successMessage = null);
          }
        });
      } else {
        _errorMessage = 'Failed to update profile. Please try again.';
        _successMessage = null;
      }
    });
  }
}

