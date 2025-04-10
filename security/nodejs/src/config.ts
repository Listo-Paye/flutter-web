// Configuration with environment variables
export const config = {
  port: process.env.PORT || 3001,
  nodeEnv: process.env.NODE_ENV || "development",
  clientOrigins: process.env.CLIENT_ORIGINS
    ? process.env.CLIENT_ORIGINS.split(",")
    : ["http://localhost:3000", "http://localhost:5000"],
  jwtSecret: process.env.JWT_SECRET || "your-secret-key",
  keycloakConfig: {
    realm: process.env.KEYCLOAK_REALM || "master",
    authServerUrl: process.env.KEYCLOAK_URL || "http://localhost:8080/auth",
    resource: process.env.KEYCLOAK_CLIENT_ID || "secure-app",
    bearerOnly: true,
    confidentialPort: 0,
  },
  logLevel: process.env.LOG_LEVEL || "info",
}

