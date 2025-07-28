import os
from src.main import app, db

# Ensure the database directory exists
db_dir = os.path.join(app.root_path, 'database')
os.makedirs(db_dir, exist_ok=True)

# Initialize the database within the app context
with app.app_context():
    db.create_all()
    print("Database initialized successfully!")

