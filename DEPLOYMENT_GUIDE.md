# 🚀 Flask Web App Deployment Guide

## 📋 Project Overview

This guide will help you deploy the Flask web application alongside your existing Nginx site on AWS EC2. The setup includes:

- **Flask Web App** (Port 5000) - Multi-page application with user management
- **Nginx Site** (Port 80) - Your existing static website
- **Docker Containerization** - Both apps run in separate containers
- **GitHub Actions CI/CD** - Automated deployment pipeline

## 🎯 Quick Start Checklist

- [ ] 1. Set up GitHub repository with innullrs branch
- [ ] 2. Configure GitHub Secrets
- [ ] 3. Prepare AWS EC2 instance
- [ ] 4. Deploy and test

## 📁 Project Structure

```
your-repo/
├── flask-app/                    # Flask application
│   ├── src/                      # Source code
│   ├── Dockerfile               # Flask container config
│   ├── requirements.txt         # Python dependencies
│   └── .dockerignore           # Docker ignore rules
├── .github/workflows/           # CI/CD pipeline
│   └── deploy-flask.yml        # GitHub Actions workflow
├── docker-compose.yml          # Multi-container orchestration
├── run-local.sh                # Local development script
├── setup-git.sh                # Git repository setup
└── README.md                   # Documentation
```

## 🔧 Step 1: GitHub Repository Setup

### 1.1 Initialize Repository

```bash
# Navigate to your project directory
cd /path/to/your/project

# Run the Git setup script
./setup-git.sh

# Add your GitHub remote (replace with your repo URL)
git remote add origin https://github.com/yourusername/your-repo.git

# Push the innullrs branch
git push -u origin innullrs
```

### 1.2 Configure GitHub Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions

Add these secrets:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `DOCKERHUB_USERNAME` | Your DockerHub username | `usama0022` |
| `DOCKERHUB_TOKEN` | DockerHub access token | `dckr_pat_...` |
| `EC2_HOST` | EC2 instance IP address | `54.123.45.67` |
| `EC2_USERNAME` | EC2 username | `ubuntu` |
| `EC2_SSH_KEY` | EC2 private key content | `-----BEGIN RSA PRIVATE KEY-----...` |

### 1.3 Create DockerHub Access Token

1. Go to [DockerHub](https://hub.docker.com/)
2. Account Settings → Security → New Access Token
3. Name: `GitHub Actions`
4. Permissions: `Read, Write, Delete`
5. Copy the token and add to GitHub secrets

## 🖥️ Step 2: AWS EC2 Preparation

### 2.1 Install Docker on EC2

```bash
# SSH into your EC2 instance
ssh -i your-key.pem ubuntu@your-ec2-ip

# Update system
sudo apt update

# Install Docker
sudo apt install -y docker.io docker-compose

# Add ubuntu user to docker group
sudo usermod -aG docker ubuntu

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Verify installation
docker --version
docker-compose --version
```

### 2.2 Create Project Directory

```bash
# Create project directory
mkdir -p /home/ubuntu/project
cd /home/ubuntu/project

# Create docker-compose.yml (will be updated by CI/CD)
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  nginx-site:
    image: usama0022/my-website:latest
    container_name: nginx-site
    ports:
      - "80:80"
    networks:
      - app-network
    restart: unless-stopped

  flask-app:
    image: usama0022/flask-app:latest
    container_name: flask-app
    ports:
      - "5000:5000"
    networks:
      - app-network
    restart: unless-stopped
    environment:
      - FLASK_ENV=production
      - FLASK_APP=src/main.py
    volumes:
      - flask-data:/app/src/database

networks:
  app-network:
    driver: bridge

volumes:
  flask-data:
    driver: local
EOF
```

### 2.3 Security Group Configuration

Ensure your EC2 security group allows:
- **Port 22** (SSH) - Your IP only
- **Port 80** (HTTP) - 0.0.0.0/0
- **Port 5000** (Flask) - 0.0.0.0/0

## 🚀 Step 3: Deployment

### 3.1 Automatic Deployment

Once you push to the `innullrs` branch, GitHub Actions will:

1. **Test** the Flask application
2. **Build** Docker image and push to DockerHub
3. **Deploy** to EC2 automatically

```bash
# Make changes to your code
git add .
git commit -m "Deploy Flask application"
git push origin innullrs
```

### 3.2 Manual Deployment (Alternative)

If you prefer manual deployment:

```bash
# On EC2 instance
cd /home/ubuntu/project

# Pull latest images
docker pull usama0022/my-website:latest
docker pull usama0022/flask-app:latest

# Start services
docker-compose up -d

# Check status
docker-compose ps
```

### 3.3 Verify Deployment

After deployment, test your applications:

```bash
# Test Nginx site
curl http://your-ec2-ip:80

# Test Flask app
curl http://your-ec2-ip:5000

# Check container status
docker-compose ps

# View logs
docker-compose logs flask-app
```

## 🌐 Step 4: Access Your Applications

- **Nginx Site**: `http://your-ec2-ip:80`
- **Flask App**: `http://your-ec2-ip:5000`

### Flask App Pages:
- Home: `http://your-ec2-ip:5000/`
- About: `http://your-ec2-ip:5000/about`
- Services: `http://your-ec2-ip:5000/services`
- Contact: `http://your-ec2-ip:5000/contact`
- Users: `http://your-ec2-ip:5000/users`

### API Endpoints:
- GET `/api/users` - List all users
- POST `/api/users` - Create new user
- GET `/api/users/<id>` - Get specific user
- PUT `/api/users/<id>` - Update user
- DELETE `/api/users/<id>` - Delete user

## 🔧 Step 5: Local Development

### 5.1 Development Setup

```bash
# Clone repository
git clone https://github.com/yourusername/your-repo.git
cd your-repo
git checkout innullrs

# Run locally with Docker
./run-local.sh start

# Access applications
# Nginx: http://localhost:80
# Flask: http://localhost:5000
```

### 5.2 Development Commands

```bash
./run-local.sh start     # Start all services
./run-local.sh stop      # Stop all services
./run-local.sh restart   # Restart services
./run-local.sh logs      # View logs
./run-local.sh build     # Rebuild Flask image
./run-local.sh cleanup   # Clean up resources
```

### 5.3 Python Development (Optional)

```bash
cd flask-app
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
python src/main.py
```

## 📊 Monitoring and Maintenance

### Container Health Checks

Both containers include health checks:
```bash
# Check container health
docker-compose ps

# View detailed health status
docker inspect nginx-site --format='{{.State.Health.Status}}'
docker inspect flask-app --format='{{.State.Health.Status}}'
```

### Log Management

```bash
# View all logs
docker-compose logs

# Follow logs in real-time
docker-compose logs -f

# View specific service logs
docker-compose logs flask-app
docker-compose logs nginx-site

# Limit log output
docker-compose logs --tail=50 flask-app
```

### Database Backup

```bash
# Backup SQLite database
docker cp flask-app:/app/src/database/app.db ./backup-$(date +%Y%m%d).db

# Restore database
docker cp ./backup-20241225.db flask-app:/app/src/database/app.db
docker-compose restart flask-app
```

## 🛠️ Troubleshooting

### Common Issues

#### 1. Container Won't Start
```bash
# Check logs
docker-compose logs flask-app

# Rebuild image
docker-compose build flask-app
docker-compose up -d flask-app
```

#### 2. Port Conflicts
```bash
# Check what's using ports
sudo netstat -tulpn | grep :80
sudo netstat -tulpn | grep :5000

# Stop conflicting services
sudo systemctl stop apache2  # If Apache is running
sudo systemctl stop nginx    # If Nginx is running locally
```

#### 3. Database Issues
```bash
# Reset database
docker-compose down -v
docker-compose up -d
```

#### 4. GitHub Actions Deployment Fails
- Check GitHub Actions logs in your repository
- Verify all secrets are correctly configured
- Ensure EC2 instance is accessible
- Check Docker daemon is running on EC2

### Health Check Commands

```bash
# Test Flask app health
curl -f http://your-ec2-ip:5000/

# Test Nginx health
curl -f http://your-ec2-ip:80/

# Check Docker daemon
sudo systemctl status docker

# Check available disk space
df -h

# Check memory usage
free -h
```

## 🔄 Updates and Maintenance

### Updating the Application

1. Make changes to your code
2. Test locally: `./run-local.sh restart`
3. Commit and push:
   ```bash
   git add .
   git commit -m "Update application"
   git push origin innullrs
   ```
4. GitHub Actions will automatically deploy

### Manual Updates

```bash
# On EC2 instance
cd /home/ubuntu/project

# Pull latest images
docker pull usama0022/flask-app:latest

# Restart services
docker-compose up -d flask-app
```

### Scaling Considerations

For production scaling, consider:
- Load balancer (AWS ALB/ELB)
- Multiple EC2 instances
- External database (RDS)
- Container orchestration (ECS/EKS)
- CDN for static assets (CloudFront)

## 📞 Support

If you encounter issues:

1. Check the [Troubleshooting](#-troubleshooting) section
2. Review container logs: `docker-compose logs`
3. Verify GitHub secrets configuration
4. Ensure EC2 security groups are correct
5. Check GitHub Actions workflow logs

## 🎉 Success Indicators

Your deployment is successful when:

- ✅ GitHub Actions workflow completes without errors
- ✅ Both containers are running: `docker-compose ps`
- ✅ Nginx site accessible on port 80
- ✅ Flask app accessible on port 5000
- ✅ All Flask pages load correctly
- ✅ User management functionality works
- ✅ API endpoints respond correctly

---

**Congratulations! Your Flask web application is now deployed and running alongside your Nginx site! 🎊**

