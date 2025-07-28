# Flask Web Application with Docker Deployment

A modern, multi-page Flask web application with Docker containerization and automated CI/CD deployment pipeline.

## 🚀 Project Overview

This project consists of two main components:
- **Nginx Static Site**: Serves on port 80 (existing)
- **Flask Web App**: Serves on port 5000 (new)

Both applications run in Docker containers and are deployed together on AWS EC2 using GitHub Actions.

## 📋 Features

### Flask Application Features
- **Multi-page responsive design** with Bootstrap 5
- **User management system** with CRUD operations
- **RESTful API endpoints** for data management
- **Contact form** with form validation
- **Service showcase pages**
- **Error handling** with custom 404/500 pages
- **SQLite database** integration
- **CORS enabled** for cross-origin requests

### Development Features
- **Docker containerization** for consistent deployment
- **Docker Compose** for multi-container orchestration
- **GitHub Actions CI/CD** pipeline
- **Automated testing** and deployment
- **Health checks** for container monitoring
- **Volume persistence** for database data

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐
│   Nginx Site    │    │   Flask App     │
│   Port: 80      │    │   Port: 5000    │
│                 │    │                 │
│ usama0022/      │    │ usama0022/      │
│ my-website      │    │ flask-app       │
└─────────────────┘    └─────────────────┘
         │                       │
         └───────────────────────┘
                    │
            ┌───────────────┐
            │ Docker Network│
            │  app-network  │
            └───────────────┘
```

## 🛠️ Technology Stack

### Backend
- **Python 3.11** - Programming language
- **Flask 3.1.1** - Web framework
- **SQLAlchemy** - Database ORM
- **SQLite** - Database
- **Flask-CORS** - Cross-origin resource sharing

### Frontend
- **Bootstrap 5** - CSS framework
- **Font Awesome 6** - Icons
- **Vanilla JavaScript** - Client-side functionality
- **Responsive Design** - Mobile-first approach

### DevOps
- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration
- **GitHub Actions** - CI/CD pipeline
- **DockerHub** - Container registry
- **AWS EC2** - Cloud hosting

## 📁 Project Structure

```
.
├── flask-app/                  # Flask application directory
│   ├── src/
│   │   ├── models/            # Database models
│   │   ├── routes/            # Flask blueprints
│   │   │   ├── main.py        # Main page routes
│   │   │   └── user.py        # User API routes
│   │   ├── static/            # Static files
│   │   │   ├── css/           # Custom stylesheets
│   │   │   └── js/            # JavaScript files
│   │   ├── templates/         # Jinja2 templates
│   │   │   ├── errors/        # Error page templates
│   │   │   ├── base.html      # Base template
│   │   │   ├── home.html      # Home page
│   │   │   ├── about.html     # About page
│   │   │   ├── services.html  # Services page
│   │   │   ├── contact.html   # Contact page
│   │   │   └── users.html     # User management
│   │   ├── database/          # SQLite database
│   │   └── main.py           # Flask application entry point
│   ├── venv/                 # Python virtual environment
│   ├── Dockerfile            # Docker configuration
│   ├── requirements.txt      # Python dependencies
│   └── .dockerignore        # Docker ignore file
├── .github/
│   └── workflows/
│       └── deploy-flask.yml  # GitHub Actions workflow
├── docker-compose.yml       # Multi-container configuration
├── run-local.sh             # Local development script
└── README.md               # This file
```

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Git for version control
- (Optional) Python 3.11 for local development

### Local Development

1. **Clone the repository**:
   ```bash
   git clone <your-repo-url>
   cd <your-repo-name>
   ```

2. **Switch to the Flask branch**:
   ```bash
   git checkout innullrs
   ```

3. **Run locally with Docker**:
   ```bash
   ./run-local.sh start
   ```

4. **Access the applications**:
   - Nginx Site: http://localhost:80
   - Flask App: http://localhost:5000

### Available Commands

```bash
./run-local.sh start     # Build and start all services
./run-local.sh stop      # Stop all services
./run-local.sh restart   # Restart all services
./run-local.sh logs      # Show logs from all services
./run-local.sh build     # Build Flask app image only
./run-local.sh cleanup   # Stop services and clean up
./run-local.sh help      # Show help message
```

## 🔧 Development Setup

### Python Virtual Environment (Optional)

If you want to develop without Docker:

```bash
cd flask-app
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
python src/main.py
```

### Environment Variables

The Flask app uses these environment variables:
- `FLASK_ENV`: Set to `production` for deployment
- `FLASK_APP`: Set to `src/main.py`

## 🚀 Deployment

### GitHub Repository Setup

1. **Create new branch**:
   ```bash
   git checkout -b innullrs
   git add .
   git commit -m "Add Flask web application"
   git push origin innullrs
   ```

2. **Configure GitHub Secrets**:
   Go to your repository settings → Secrets and variables → Actions, and add:
   
   - `DOCKERHUB_USERNAME`: Your DockerHub username
   - `DOCKERHUB_TOKEN`: Your DockerHub access token
   - `EC2_HOST`: Your EC2 instance IP address
   - `EC2_USERNAME`: EC2 username (usually `ubuntu`)
   - `EC2_SSH_KEY`: Your EC2 private key

### AWS EC2 Setup

1. **Prepare EC2 instance**:
   ```bash
   # Install Docker
   sudo apt update
   sudo apt install -y docker.io docker-compose
   sudo usermod -aG docker ubuntu
   
   # Create project directory
   mkdir -p /home/ubuntu/project
   cd /home/ubuntu/project
   ```

2. **Deploy**: Push to the `innullrs` branch to trigger deployment

### Manual Deployment

If you prefer manual deployment:

```bash
# On EC2 instance
cd /home/ubuntu/project

# Pull latest images
docker pull usama0022/flask-app:latest
docker pull usama0022/my-website:latest

# Start services
docker-compose up -d

# Check status
docker-compose ps
```

## 📊 API Endpoints

### User Management API

- `GET /api/users` - Get all users
- `POST /api/users` - Create new user
- `GET /api/users/<id>` - Get specific user
- `PUT /api/users/<id>` - Update user
- `DELETE /api/users/<id>` - Delete user

### Web Pages

- `/` - Home page
- `/about` - About page
- `/services` - Services page
- `/contact` - Contact page
- `/users` - User management interface

## 🔍 Monitoring

### Health Checks

Both containers include health checks:
- **Nginx**: `curl -f http://localhost`
- **Flask**: `curl -f http://localhost:5000`

### Logs

View application logs:
```bash
# All services
docker-compose logs -f

# Flask app only
docker-compose logs -f flask-app

# Nginx only
docker-compose logs -f nginx-site
```

## 🛠️ Troubleshooting

### Common Issues

1. **Port conflicts**:
   ```bash
   # Check what's using the ports
   sudo netstat -tulpn | grep :80
   sudo netstat -tulpn | grep :5000
   ```

2. **Container won't start**:
   ```bash
   # Check container logs
   docker-compose logs flask-app
   
   # Rebuild image
   ./run-local.sh build
   ```

3. **Database issues**:
   ```bash
   # Reset database volume
   docker-compose down -v
   docker-compose up -d
   ```

### Development Tips

- Use `docker-compose logs -f flask-app` to monitor Flask logs
- The database persists in a Docker volume named `flask-data`
- Static files are served directly by Flask in development
- CORS is enabled for all origins in development

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Test locally: `./run-local.sh start`
5. Commit changes: `git commit -m "Add feature"`
6. Push to branch: `git push origin feature-name`
7. Create a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

If you encounter any issues:

1. Check the [Troubleshooting](#-troubleshooting) section
2. Review container logs: `docker-compose logs`
3. Ensure all required secrets are configured in GitHub
4. Verify EC2 instance has Docker installed and running

## 🔄 Updates

To update the application:

1. Make changes to the code
2. Test locally: `./run-local.sh restart`
3. Commit and push to `innullrs` branch
4. GitHub Actions will automatically deploy to EC2

---

**Happy coding! 🎉**

