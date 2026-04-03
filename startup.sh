#!/bin/bash
set -e

# Source the virtual environment that Oryx created
source /tmp/*/antenv/bin/activate

# Navigate to the UI directory where server.py is located
cd /home/site/wwwroot/UI || { echo 'Error: UI directory not found'; exit 1; }

# Set environment variables
export FLASK_APP=server.py
export FLASK_ENV=production
export SERVER_PORT=8000

# Start the Flask application
python -m flask run --host=0.0.0.0 --port=8000