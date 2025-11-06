#!/bin/bash

# Quick start script for Docker setup
# Usage: ./start.sh [dev|prod]

MODE=${1:-dev}

echo "Starting Flask Food Delivery App in $MODE mode..."

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Creating .env file from env.example..."
    cp env.example .env
    echo "⚠️  Please edit .env file and update SECRET_KEY, DB_PASSWORD, and REDIS_PASSWORD before continuing!"
    echo "Press Enter to continue or Ctrl+C to exit..."
    read
fi

# Start services
if [ "$MODE" = "prod" ]; then
    echo "Starting in PRODUCTION mode..."
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
else
    echo "Starting in DEVELOPMENT mode..."
    docker-compose up -d --build
fi

# Wait for services to be healthy
echo "Waiting for services to be healthy..."
sleep 10

# Check service status
echo ""
echo "Service Status:"
docker-compose ps

echo ""
echo "✅ Application should be available at: http://localhost"
echo "✅ Health check: http://localhost/health"
echo ""
echo "View logs with: docker-compose logs -f"
echo "Stop services with: docker-compose down"

