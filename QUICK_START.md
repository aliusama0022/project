# 🚀 Flask Web App - Quick Start Guide

## Prerequisites
- Docker and Docker Compose installed on your system
- Git (optional, for version control)

## 📦 What's Included
- Complete Flask web application with multi-page UI
- Docker configuration for containerization
- GitHub Actions CI/CD pipeline
- Local development scripts
- Comprehensive documentation

## ⚡ Quick Commands

### 1. Extract and Navigate
```bash
# Extract the zip file
unzip flask_web_app_project.zip
cd flask_web_app_project

# Make scripts executable
chmod +x run-local.sh setup-git.sh
```

### 2. Run Locally (Docker Required)
```bash
# Start both Nginx and Flask applications
./run-local.sh start

# Access your applications:
# - Nginx Site: http://localhost:80
# - Flask App: http://localhost:5000
```

### 3. Alternative: Run Flask Only (Python Required)
```bash
cd flask-app

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run Flask app
python src/main.py

# Access Flask app: http://localhost:5000
```

### 4. Setup Git Repository (Optional)
```bash
# Initialize Git and create innullrs branch
./setup-git.sh

# Add your GitHub remote
git remote add origin https://github.com/yourusername/your-repo.git

# Push to GitHub
git push -u origin innullrs
```

## 🌐 Application Features

### Flask Web App (Port 5000)
- **Home Page**: Welcome page with feature overview
- **About Page**: Project information and tech stack
- **Services Page**: Service offerings showcase
- **Contact Page**: Contact form with validation
- **Users Page**: User management interface with CRUD operations

### API Endpoints
- `GET /api/users` - List all users
- `POST /api/users` - Create new user
- `GET /api/users/<id>` - Get specific user
- `PUT /api/users/<id>` - Update user
- `DELETE /api/users/<id>` - Delete user

## 🛠️ Development Commands

```bash
# Start all services
./run-local.sh start

# Stop all services
./run-local.sh stop

# Restart services
./run-local.sh restart

# View logs
./run-local.sh logs

# Rebuild Flask image
./run-local.sh build

# Clean up resources
./run-local.sh cleanup

# Show help
./run-local.sh help
```

## 📁 Project Structure
```
flask_web_app_project/
├── flask-app/                   # Flask application
│   ├── src/                     # Source code
│   │   ├── models/              # Database models
│   │   ├── routes/              # Flask routes
│   │   ├── static/              # CSS, JS, images
│   │   ├── templates/           # HTML templates
│   │   └── main.py              # Application entry point
│   ├── Dockerfile               # Docker configuration
│   └── requirements.txt         # Python dependencies
├── .github/workflows/           # GitHub Actions CI/CD
├── docker-compose.yml           # Multi-container setup
├── run-local.sh                 # Local development script
├── setup-git.sh                 # Git setup script
├── README.md                    # Detailed documentation
└── DEPLOYMENT_GUIDE.md          # AWS deployment guide
```

## 🚀 Deployment to AWS EC2

1. **Setup GitHub Repository**: Use `./setup-git.sh`
2. **Configure GitHub Secrets**: Add DockerHub and EC2 credentials
3. **Push to innullrs branch**: Triggers automatic deployment
4. **Access Applications**: 
   - Nginx: `http://your-ec2-ip:80`
   - Flask: `http://your-ec2-ip:5000`

See `DEPLOYMENT_GUIDE.md` for detailed deployment instructions.

## 🆘 Troubleshooting

### Docker Issues
```bash
# Check if Docker is running
docker --version
docker-compose --version

# If Docker not installed, install it first
# On Ubuntu: sudo apt install docker.io docker-compose
# On macOS: Install Docker Desktop
# On Windows: Install Docker Desktop
```

### Port Conflicts
```bash
# Check what's using ports 80 and 5000
netstat -tulpn | grep :80
netstat -tulpn | grep :5000

# Stop conflicting services if needed
```

### Python Issues
```bash
# Ensure Python 3.11+ is installed
python --version

# If issues with virtual environment
rm -rf flask-app/venv
cd flask-app
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## 📞 Support

- Check `README.md` for comprehensive documentation
- Review `DEPLOYMENT_GUIDE.md` for AWS deployment
- Examine container logs: `./run-local.sh logs`
- Test individual components: `cd flask-app && python src/main.py`

---

**Happy coding! 🎉**

