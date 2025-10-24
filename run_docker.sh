#!/bin/bash

# Check if FMP_API_KEY is set
if [ -z "$FMP_API_KEY" ]; then
    echo "❌ Error: FMP_API_KEY environment variable is not set"
    echo "Please set it first:"
    echo "  export FMP_API_KEY='your_api_key_here'"
    exit 1
fi

echo "🐳 Building Docker container for Gary Stock Analysis..."

# Build the Docker image
docker build -t gary-stock-analysis .

echo "🚀 Running stock analysis in Docker..."

# Run the container with environment variables and volume for cache persistence
docker run --rm \
  -v $(pwd):/app \
  -e FMP_API_KEY="$FMP_API_KEY" \
  -e TELEGRAM_BOT_TOKEN="8324596740:AAH7j1rsRUddl0J-81vdeXoVFL666Y4MRYU" \
  -e TELEGRAM_CHAT_ID="1051226560" \
  gary-stock-analysis

echo "✅ Docker analysis complete!"
echo "📊 Cache saved to stock_prices_cache.json" 