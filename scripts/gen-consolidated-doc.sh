#!/bin/bash

# Trade Me API Documentation Generator
# This script generates the consolidated OpenAPI documentation and starts a Docker server

set -e

echo "🔧 Generating consolidated OpenAPI documentation..."

# Generate consolidated documentation using Redocly
redocly bundle openapi/api.yaml --output openapi/openapi-consolidated.yaml --force

echo "✅ Consolidated documentation generated at: openapi/openapi-consolidated.yaml"

echo "🚀 Starting Swagger UI Docker server..."

# Start Docker container with Swagger UI
docker run -p 8080:8080 \
  -e SWAGGER_JSON=/openapi/openapi-consolidated.yaml \
  -v "$(pwd)/openapi:/openapi" \
  swaggerapi/swagger-ui

echo "📖 Documentation available at: http://localhost:8080"