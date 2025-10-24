@echo off

REM Check if FMP_API_KEY is set
if "%FMP_API_KEY%"=="" (
    echo ❌ Error: FMP_API_KEY environment variable is not set
    echo Please set it first:
    echo   $env:FMP_API_KEY='your_api_key_here'
    pause
    exit /b 1
)

echo 🐳 Building Docker container for Gary Stock Analysis...

REM Build the Docker image
docker build -t gary-stock-analysis .

echo 🚀 Running stock analysis in Docker with FMP API...

REM Run the container with environment variables and volume for cache
docker run --rm ^
  -v "%cd%:/app" ^
  -e FMP_API_KEY=%FMP_API_KEY% ^
  -e TELEGRAM_BOT_TOKEN=8324596740:AAH7j1rsRUddl0J-81vdeXoVFL666Y4MRYU ^
  -e TELEGRAM_CHAT_ID=1051226560 ^
  gary-stock-analysis

echo ✅ Docker analysis complete!
echo 📊 Cache saved to stock_prices_cache.json
pause 