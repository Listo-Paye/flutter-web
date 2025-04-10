class Constants {
  // API configuration
  static const String apiUrl = 'http://localhost:3001/api';
  
  // Keycloak configuration
  static const String keycloakUrl = 'http://localhost:8080/auth';
  static const String keycloakRealm = 'master';
  static const String keycloakClientId = 'secure-app';
  
  // Security headers
  static const Map<String, String> securityHeaders = {
    'X-Content-Type-Options': 'nosniff',
    'X-Frame-Options': 'DENY',
    'Content-Security-Policy': "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:;",
  };
}

