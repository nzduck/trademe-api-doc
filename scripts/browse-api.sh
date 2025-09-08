#!/bin/bash

# Trade Me API Browser
# This script generates consolidated OpenAPI documentation, starts a Docker server, and opens the browser

set -e

echo "🔧 Generating consolidated OpenAPI documentation..."

# Generate consolidated documentation using Redocly
redocly bundle openapi/api.yaml --output openapi/openapi-consolidated.yaml --force

echo "✅ Consolidated documentation generated at: openapi/openapi-consolidated.yaml"

echo "🚀 Starting Swagger UI Docker server on port 5353..."

# Start Docker container with Swagger UI in background
docker run -d -p 5353:8080 \
  --name trademe-api-docs \
  --rm \
  -e SWAGGER_JSON=/openapi/openapi-consolidated.yaml \
  -v "$(pwd)/openapi:/openapi" \
  swaggerapi/swagger-ui

echo "⏳ Waiting for server to start..."
sleep 3

echo "🌐 Opening documentation in Chrome browser..."

# Open Chrome browser (cross-platform)
if command -v google-chrome &> /dev/null; then
    google-chrome http://localhost:5353 2>/dev/null &
elif command -v google-chrome-stable &> /dev/null; then
    google-chrome-stable http://localhost:5353 2>/dev/null &
elif command -v chromium-browser &> /dev/null; then
    chromium-browser http://localhost:5353 2>/dev/null &
elif command -v chromium &> /dev/null; then
    chromium http://localhost:5353 2>/dev/null &
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    open -a "Google Chrome" http://localhost:5353 2>/dev/null || open http://localhost:5353
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    # Windows
    start chrome http://localhost:5353 2>/dev/null || start http://localhost:5353
else
    # Linux fallback
    xdg-open http://localhost:5353 2>/dev/null &
fi

echo "📖 Documentation available at: http://localhost:5353"
echo "🛑 To stop the server: docker stop trademe-api-docs"