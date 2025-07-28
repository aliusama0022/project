#!/bin/bash

# Git setup script for Flask Web App project
# This script helps initialize the repository and create the innullrs branch

set -e

echo "🔧 Flask Web App - Git Repository Setup"
echo "======================================="

# Function to check if git is installed
check_git() {
    if ! command -v git &> /dev/null; then
        echo "❌ Git is not installed. Please install Git and try again."
        exit 1
    fi
    echo "✅ Git is available"
}

# Function to initialize git repository
init_repo() {
    if [ -d ".git" ]; then
        echo "✅ Git repository already exists"
    else
        echo "🔧 Initializing Git repository..."
        git init
        echo "✅ Git repository initialized"
    fi
}

# Function to create .gitignore
create_gitignore() {
    if [ ! -f ".gitignore" ]; then
        echo "📝 Creating .gitignore file..."
        cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# Virtual Environment
venv/
env/
ENV/

# Flask
instance/
.webassets-cache

# Database
*.db
*.sqlite
*.sqlite3

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Logs
*.log

# Environment variables
.env
.env.local
.env.development
.env.production

# Docker
.dockerignore

# Temporary files
tmp/
temp/
*.tmp

# Coverage reports
htmlcov/
.coverage
.coverage.*
coverage.xml
*.cover
.hypothesis/
.pytest_cache/
EOF
        echo "✅ .gitignore file created"
    else
        echo "✅ .gitignore file already exists"
    fi
}

# Function to add files and make initial commit
initial_commit() {
    echo "📦 Adding files to Git..."
    git add .
    
    if git diff --staged --quiet; then
        echo "ℹ️  No changes to commit"
    else
        echo "💾 Making initial commit..."
        git commit -m "Initial commit: Flask web application with Docker deployment

- Multi-page Flask application with Bootstrap UI
- User management system with SQLite database
- Docker containerization with Dockerfile
- Docker Compose configuration for multi-container setup
- GitHub Actions CI/CD pipeline
- Comprehensive documentation and setup scripts"
        echo "✅ Initial commit completed"
    fi
}

# Function to create and switch to innullrs branch
create_branch() {
    current_branch=$(git branch --show-current 2>/dev/null || echo "main")
    
    if git branch --list | grep -q "innullrs"; then
        echo "✅ Branch 'innullrs' already exists"
        git checkout innullrs
        echo "🔄 Switched to 'innullrs' branch"
    else
        echo "🌿 Creating new branch 'innullrs'..."
        git checkout -b innullrs
        echo "✅ Created and switched to 'innullrs' branch"
    fi
}

# Function to show next steps
show_next_steps() {
    echo ""
    echo "🎉 Git repository setup completed!"
    echo ""
    echo "📋 Next Steps:"
    echo "1. Add your GitHub repository as remote:"
    echo "   git remote add origin https://github.com/yourusername/your-repo.git"
    echo ""
    echo "2. Push the innullrs branch to GitHub:"
    echo "   git push -u origin innullrs"
    echo ""
    echo "3. Configure GitHub Secrets in your repository settings:"
    echo "   • DOCKERHUB_USERNAME: Your DockerHub username"
    echo "   • DOCKERHUB_TOKEN: Your DockerHub access token"
    echo "   • EC2_HOST: Your EC2 instance IP address"
    echo "   • EC2_USERNAME: EC2 username (usually 'ubuntu')"
    echo "   • EC2_SSH_KEY: Your EC2 private key"
    echo ""
    echo "4. Test locally before pushing:"
    echo "   ./run-local.sh start"
    echo ""
    echo "5. Push changes to trigger deployment:"
    echo "   git add ."
    echo "   git commit -m 'Deploy Flask application'"
    echo "   git push origin innullrs"
    echo ""
    echo "📊 Current status:"
    echo "   • Branch: $(git branch --show-current)"
    echo "   • Files tracked: $(git ls-files | wc -l)"
    echo "   • Last commit: $(git log -1 --pretty=format:'%h - %s (%cr)' 2>/dev/null || echo 'No commits yet')"
}

# Function to show repository info
show_repo_info() {
    echo ""
    echo "📁 Repository Information:"
    echo "   • Location: $(pwd)"
    echo "   • Git status:"
    git status --porcelain | head -10
    if [ $(git status --porcelain | wc -l) -gt 10 ]; then
        echo "   ... and $(( $(git status --porcelain | wc -l) - 10 )) more files"
    fi
}

# Main execution
main() {
    check_git
    init_repo
    create_gitignore
    initial_commit
    create_branch
    show_repo_info
    show_next_steps
}

# Handle command line arguments
case "${1:-setup}" in
    "setup")
        main
        ;;
    "branch")
        check_git
        create_branch
        ;;
    "commit")
        check_git
        git add .
        git commit -m "${2:-Update Flask application}"
        echo "✅ Changes committed"
        ;;
    "push")
        check_git
        git push origin innullrs
        echo "✅ Changes pushed to GitHub"
        ;;
    "status")
        check_git
        show_repo_info
        ;;
    "help"|"-h"|"--help")
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  setup    - Complete repository setup (default)"
        echo "  branch   - Create/switch to innullrs branch only"
        echo "  commit   - Add and commit all changes"
        echo "  push     - Push innullrs branch to origin"
        echo "  status   - Show repository status"
        echo "  help     - Show this help message"
        ;;
    *)
        echo "❌ Unknown command: $1"
        echo "Run '$0 help' for usage information"
        exit 1
        ;;
esac

