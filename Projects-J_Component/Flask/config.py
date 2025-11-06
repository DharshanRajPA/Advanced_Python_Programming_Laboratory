import os

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'dev-secret-key-change-in-production'
    
    # Database configuration - PostgreSQL for production, SQLite for local dev
    DB_HOST = os.environ.get('DB_HOST', 'localhost')
    DB_PORT = os.environ.get('DB_PORT', '5432')
    DB_NAME = os.environ.get('DB_NAME', 'food_order_db')
    DB_USER = os.environ.get('DB_USER', 'foodapp_user')
    DB_PASSWORD = os.environ.get('DB_PASSWORD', 'foodapp_pass')
    
    # Use PostgreSQL if DB_HOST is set to a non-localhost value, otherwise SQLite
    # Check if we're in a containerized environment (DB_HOST is not localhost)
    _db_host = os.environ.get('DB_HOST', 'localhost')
    if _db_host and _db_host != 'localhost':
        SQLALCHEMY_DATABASE_URI = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    else:
        SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or 'sqlite:///food_order.db'
    
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # Redis configuration
    REDIS_HOST = os.environ.get('REDIS_HOST', 'localhost')
    REDIS_PORT = int(os.environ.get('REDIS_PORT', 6379))
    REDIS_DB = int(os.environ.get('REDIS_DB', 0))
    
    # Flask settings
    FLASK_ENV = os.environ.get('FLASK_ENV', 'development')
    FLASK_DEBUG = os.environ.get('FLASK_DEBUG', 'True').lower() == 'true'

