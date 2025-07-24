#!/bin/bash

# AarogyaRekha Django App Startup Script for Azure App Service
# This script runs when the Azure container starts

set -e  # Exit on any error

echo "🚀 Starting AarogyaRekha Django Application..."

# Change to the backend directory
cd /home/site/wwwroot/aarogyarekha-backend

# Install any missing requirements
echo "📦 Installing Python dependencies..."
pip install -r requirements.txt

# Create logs directory if it doesn't exist
mkdir -p logs

# Collect static files
echo "📁 Collecting static files..."
python manage.py collectstatic --noinput --clear

# Run database migrations
echo "🗄️ Running database migrations..."
python manage.py migrate --noinput

# Create superuser if credentials are provided
if [ "$DJANGO_SUPERUSER_EMAIL" ] && [ "$DJANGO_SUPERUSER_PASSWORD" ]; then
    echo "👤 Creating Django superuser..."
    python manage.py shell -c "
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(email='$DJANGO_SUPERUSER_EMAIL').exists():
    User.objects.create_superuser('$DJANGO_SUPERUSER_EMAIL', '$DJANGO_SUPERUSER_PASSWORD')
    print('Superuser created successfully')
else:
    print('Superuser already exists')
"
fi

# Start the Django application using Gunicorn
echo "🌐 Starting Django with Gunicorn..."
exec gunicorn --bind=0.0.0.0:8000 --workers=3 --timeout=600 --access-logfile='-' --error-logfile='-' aarogyarekha_backend.wsgi:application
