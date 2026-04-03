#!/bin/bash

# Navigate to the UI directory where server.py is located
cd /home/site/wwwroot/UI || { echo 'Error: UI directory not found'; exit 1; }

# Start the Flask application using gunicorn
gunicorn --bind 0.0.0.0:8000 --workers 4 server:app