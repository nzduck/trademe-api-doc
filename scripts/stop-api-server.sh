#!/bin/bash

# Trade Me API Documentation Server Stopper
# This script stops the running documentation server

echo "🛑 Stopping Trade Me API documentation server..."

if docker ps --format "table {{.Names}}" | grep -q "trademe-api-docs"; then
    docker stop trademe-api-docs
    echo "✅ Server stopped successfully"
else
    echo "ℹ️  No running server found (container name: trademe-api-docs)"
    echo "💡 Check all running containers: docker ps"
fi