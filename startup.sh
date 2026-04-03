#!/bin/bash

# Navigate to the UI directory where server.py is located
cd /home/site/wwwroot/UI || { echo 'Error: UI directory not found'; exit 1; }

# Start the Flask application on port 8000
python -m flask run --host=0.0.0.0 --port=8000