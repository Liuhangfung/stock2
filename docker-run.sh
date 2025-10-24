#!/bin/bash
# Secure Docker Run Script
# This script loads API key from .env file

# Load environment variables from .env file
if [ -f /home/ken/AI/gary/stock/.env ]; then
    export $(cat /home/ken/AI/gary/stock/.env | xargs)
else
    echo "Error: .env file not found!"
    exit 1
fi

# Run Docker container
docker run --rm \
  -e FMP_API_KEY="$FMP_API_KEY" \
  gary-stock-analysis

