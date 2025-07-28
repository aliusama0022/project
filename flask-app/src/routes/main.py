from flask import Blueprint, render_template, request, flash, redirect, url_for, jsonify
from src.models.user import User, db

main_bp = Blueprint('main', __name__)

@main_bp.route('/')
def home():
    """Home page route"""
    return render_template('home.html')

@main_bp.route('/about')
def about():
    """About page route"""
    return render_template('about.html')

@main_bp.route('/services')
def services():
    """Services page route"""
    return render_template('services.html')

@main_bp.route('/contact', methods=['GET', 'POST'])
def contact():
    """Contact page route with form handling"""
    if request.method == 'POST':
        # Get form data
        name = request.form.get('name')
        email = request.form.get('email')
        phone = request.form.get('phone')
        company = request.form.get('company')
        subject = request.form.get('subject')
        message = request.form.get('message')
        newsletter = request.form.get('newsletter')
        
        # Basic validation
        if not all([name, email, subject, message]):
            flash('Please fill in all required fields.', 'error')
            return render_template('contact.html')
        
        # Here you would typically save to database or send email
        # For demo purposes, we'll just show a success message
        flash(f'Thank you {name}! Your message has been received. We will get back to you soon.', 'success')
        
        # Log the contact form submission (in a real app, you'd save this to database)
        print(f"Contact Form Submission:")
        print(f"Name: {name}")
        print(f"Email: {email}")
        print(f"Phone: {phone}")
        print(f"Company: {company}")
        print(f"Subject: {subject}")
        print(f"Message: {message}")
        print(f"Newsletter: {'Yes' if newsletter else 'No'}")
        
        return redirect(url_for('main.contact'))
    
    return render_template('contact.html')

@main_bp.route('/users')
def users():
    """Users management page route"""
    return render_template('users.html')

# API endpoint for getting user statistics (used by users page)
@main_bp.route('/api/stats/users')
def user_stats():
    """Get user statistics"""
    try:
        total_users = User.query.count()
        # For demo purposes, recent users is just total users
        # In a real app, you'd filter by date
        recent_users = total_users
        
        return jsonify({
            'total_users': total_users,
            'recent_users': recent_users
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Error handlers
@main_bp.errorhandler(404)
def not_found_error(error):
    """Handle 404 errors"""
    return render_template('errors/404.html'), 404

@main_bp.errorhandler(500)
def internal_error(error):
    """Handle 500 errors"""
    db.session.rollback()
    return render_template('errors/500.html'), 500

