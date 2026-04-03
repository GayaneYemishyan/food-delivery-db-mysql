#!/bin/bash
# Activate the Python virtual environment created by Azure's Oryx build system
source /antenv/bin/activate
# Navigate to the UI directory where server.py is located
cd /home/site/wwwroot/UI || { echo 'Error: UI directory not found'; exit 1; }
# Start the Flask application on port 8000 (required by Azure App Service)
gunicorn --bind=0.0.0.0:8000 --timeout 600 server:app
