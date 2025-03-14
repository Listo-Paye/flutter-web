import 'package:html_escape/html_escape.dart';

class SecurityUtils {
  // Sanitize user input to prevent XSS attacks
  static String sanitizeInput(String input) {
    if (input.isEmpty) return input;
    
    // Use HTML escape to prevent XSS
    return HtmlEscape().convert(input);
  }
  
  // Validate input based on field type
  static bool validateInput(String field, String value) {
    switch (field) {
      case 'name':
        return value.isNotEmpty && value.length >= 2 && value.length <= 100;
      case 'email':
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
        return emailRegex.hasMatch(value);
      case 'phone':
        if (value.isEmpty) return true; // Optional
        final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
        return phoneRegex.hasMatch(value);
      case 'address':
        if (value.isEmpty) return true; // Optional
        return value.length >= 5 && value.length <= 200;
      default:
        return value.isNotEmpty && value.length <= 500;
    }
  }
  
  // Add security headers to a web page
  static void addSecurityHeaders() {
    // This would be implemented in a real app using a platform channel
    // or other mechanism to interact with the web view
  }
}

