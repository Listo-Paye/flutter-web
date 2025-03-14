import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_web/models/user.dart';
import 'package:flutter_web/utils/constants.dart';
import 'package:flutter_web/utils/security_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart' as html;

class AuthService with ChangeNotifier {
  final FlutterSecureStorage _storage;
  User? _currentUser;
  String? _accessToken;
  String? _refreshToken;
  bool _isLoading = false;

  AuthService(this._storage);

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      _isLoading = true;
      notifyListeners();

      final token = await _storage.read(key: 'access_token');
      if (token == null) {
        return false;
      }

      // Validate token and get user info
      final response = await http.get(
        Uri.parse('${Constants.apiUrl}/users/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        _currentUser = User.fromJson(userData);
        _accessToken = token;
        return true;
      } else {
        // Try to refresh token
        final refreshed = await _refreshAccessToken();
        if (refreshed) {
          return await isAuthenticated();
        }
        return false;
      }
    } catch (e) {
      debugPrint('Error checking authentication: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Initiate Keycloak login
  Future<void> login() async {
    final redirectUri = '${html.window.location.origin}/login';
    final authUrl = '${Constants.keycloakUrl}/realms/${Constants.keycloakRealm}/protocol/openid-connect/auth';
    
    final url = Uri.parse(authUrl).replace(queryParameters: {
      'client_id': Constants.keycloakClientId,
      'redirect_uri': redirectUri,
      'response_type': 'code',
      'scope': 'openid profile email',
    });

    await launchUrl(url);
  }

  // Handle the OAuth callback
  Future<bool> handleAuthCallback(String code) async {
    try {
      _isLoading = true;
      notifyListeners();

      final tokenUrl = '${Constants.keycloakUrl}/realms/${Constants.keycloakRealm}/protocol/openid-connect/token';
      final redirectUri = '${html.window.location.origin}/login';

      final response = await http.post(
        Uri.parse(tokenUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'authorization_code',
          'client_id': Constants.keycloakClientId,
          'code': code,
          'redirect_uri': redirectUri,
        },
      );

      if (response.statusCode == 200) {
        final tokenData = json.decode(response.body);
        
        // Sanitize and store tokens
        _accessToken = SecurityUtils.sanitizeInput(tokenData['access_token']);
        _refreshToken = SecurityUtils.sanitizeInput(tokenData['refresh_token']);
        
        await _storage.write(key: 'access_token', value: _accessToken);
        await _storage.write(key: 'refresh_token', value: _refreshToken);
        
        // Get user profile
        await _fetchUserProfile();
        return true;
      } else {
        debugPrint('Failed to exchange code for token: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error handling auth callback: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh the access token
  Future<bool> _refreshAccessToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) {
        return false;
      }

      final tokenUrl = '${Constants.keycloakUrl}/realms/${Constants.keycloakRealm}/protocol/openid-connect/token';

      final response = await http.post(
        Uri.parse(tokenUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'refresh_token',
          'client_id': Constants.keycloakClientId,
          'refresh_token': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        final tokenData = json.decode(response.body);
        
        _accessToken = SecurityUtils.sanitizeInput(tokenData['access_token']);
        _refreshToken = SecurityUtils.sanitizeInput(tokenData['refresh_token']);
        
        await _storage.write(key: 'access_token', value: _accessToken);
        await _storage.write(key: 'refresh_token', value: _refreshToken);
        
        return true;
      } else {
        // If refresh fails, clear tokens
        await logout();
        return false;
      }
    } catch (e) {
      debugPrint('Error refreshing token: $e');
      await logout();
      return false;
    }
  }

  // Fetch user profile
  Future<void> _fetchUserProfile() async {
    try {
      if (_accessToken == null) {
        return;
      }

      final response = await http.get(
        Uri.parse('${Constants.apiUrl}/users/profile'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        _currentUser = User.fromJson(userData);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Clear local storage
      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'refresh_token');
      
      // Clear user data
      _currentUser = null;
      _accessToken = null;
      _refreshToken = null;
      
      // Redirect to login page in web
      html.window.location.href = '/login';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user profile
  Future<bool> updateProfile(Map<String, String> profileData) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_accessToken == null) {
        return false;
      }

      // Sanitize all inputs
      final sanitizedData = profileData.map((key, value) => 
        MapEntry(key, SecurityUtils.sanitizeInput(value))
      );

      final response = await http.put(
        Uri.parse('${Constants.apiUrl}/users/profile'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(sanitizedData),
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        _currentUser = User.fromJson(userData);
        notifyListeners();
        return true;
      } else {
        debugPrint('Failed to update profile: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

