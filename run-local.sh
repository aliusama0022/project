#!/bin/bash

# Local development script for Flask Web App project
# This script helps build and run both containers locally

set -e

echo "🐳 Flask Web App - Local Development Setup"
echo "=========================================="

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        echo "❌ Docker is not running. Please start Docker and try again."
        exit 1
    fi
    echo "✅ Docker is running"
}

# Function to build Flask app image
build_flask() {
    echo "🔨 Building Flask app image..."
    cd flask-app
    docker build -t usama0022/flask-app:latest .
    cd ..
    echo "✅ Flask app image built successfully"
}

# Function to pull Nginx image
pull_nginx() {
    echo "📥 Pulling Nginx site image..."
    docker pull usama0022/my-website:latest || {
        echo "⚠️  Warning: Could not pull usama0022/my-website:latest"
        echo "   This is expected if the image doesn't exist yet."
        echo "   The Flask app will still work on port 5000."
    }
}

# Function to start services
start_services() {
    echo "🚀 Starting services with Docker Compose..."
    docker-compose up -d
    echo "✅ Services started successfully"
    echo ""
    echo "📋 Service Status:"
    docker-compose ps
    echo ""
    echo "🌐 Access your applications:"
    echo "   • Nginx Site: http://localhost:80"
    echo "   • Flask App:  http://localhost:5000"
    echo ""
    echo "📊 To view logs:"
    echo "   • All services: docker-compose logs -f"
    echo "   • Flask only:   docker-compose logs -f flask-app"
    echo "   • Nginx only:   docker-compose logs -f nginx-site"
    echo ""
    echo "🛑 To stop services:"
    echo "   • docker-compose down"
}

# Function to stop services
stop_services() {
    echo "🛑 Stopping services..."
    docker-compose down
    echo "✅ Services stopped"
}

# Function to show logs
show_logs() {
    echo "📊 Showing logs (Press Ctrl+C to exit)..."
    docker-compose logs -f
}

# Function to clean up
cleanup() {
    echo "🧹 Cleaning up..."
    docker-compose down -v
    docker system prune -f
    echo "✅ Cleanup completed"
}

# Main menu
case "${1:-start}" in
    "start")
        check_docker
        build_flask
        pull_nginx
        start_services
        ;;
    "stop")
        stop_services
        ;;
    "restart")
        stop_services
        check_docker
        build_flask
        start_services
        ;;
    "logs")
        show_logs
        ;;
    "build")
        check_docker
        build_flask
        ;;
    "cleanup")
        cleanup
        ;;
    "help"|"-h"|"--help")
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  start    - Build and start all services (default)"
        echo "  stop     - Stop all services"
        echo "  restart  - Restart all services"
        echo "  logs     - Show logs from all services"
        echo "  build    - Build Flask app image only"
        echo "  cleanup  - Stop services and clean up Docker resources"
        echo "  help     - Show this help message"
        ;;
    *)
        echo "❌ Unknown command: $1"
        echo "Run '$0 help' for usage information"
        exit 1
        ;;
esac

