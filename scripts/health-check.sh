#!/bin/bash
# Health check script for the web application

echo "Running health check..."

# Check if the web server is responding
if curl -s --head http://localhost:80 | grep "200 OK" > /dev/null; then
    echo "✅ Health check passed!"
    exit 0
else
    echo "❌ Health check failed!"
    exit 1
fi
