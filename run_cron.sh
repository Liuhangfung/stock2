#!/bin/bash

# Hong Kong Stock Analysis Cron Script
# This script ensures proper environment for Docker execution

# Set explicit PATH to include Docker
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

# Log file for debugging
LOG_FILE="/home/ken/AI/gary/stock/cron.log"

# Function to log with timestamp
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Start logging
log_message "=== Starting Hong Kong Stock Analysis ==="

# Change to the correct directory
cd /home/ken/AI/gary/stock || {
    log_message "ERROR: Failed to change to /home/ken/AI/gary/stock"
    exit 1
}

log_message "Changed to directory: $(pwd)"

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    log_message "ERROR: Docker command not found in PATH: $PATH"
    exit 1
fi

log_message "Docker found at: $(which docker)"

# Check if Docker image exists
if ! docker image inspect gary-stock-analysis &> /dev/null; then
    log_message "ERROR: Docker image 'gary-stock-analysis' not found"
    log_message "Available images:"
    docker images >> "$LOG_FILE" 2>&1
    exit 1
fi

log_message "Docker image 'gary-stock-analysis' found"

# Run the Docker container
log_message "Starting Docker container..."
docker run --rm gary-stock-analysis >> "$LOG_FILE" 2>&1

# Check exit code
EXIT_CODE=$?
if [ $EXIT_CODE -eq 0 ]; then
    log_message "SUCCESS: Docker container completed successfully"
else
    log_message "ERROR: Docker container failed with exit code $EXIT_CODE"
fi

log_message "=== Finished Hong Kong Stock Analysis ==="
log_message "" 