# Hong Kong Stock Analysis with FMP API

This project analyzes Hong Kong stock portfolio performance and sends beautiful Plotly charts to Telegram.

## 🔄 Migration from Google Sheets to FMP API

The system now uses **Financial Modeling Prep (FMP) API** instead of Google Sheets for more reliable historical price data.

### Key Features:
- ✅ **First run**: Fetches full historical data from FMP API
- ✅ **Caching**: Saves data to `stock_prices_cache.json`
- ✅ **Incremental updates**: Only fetches missing dates on subsequent runs
- ✅ **Efficient**: Reduces API calls and speeds up daily runs

## 📋 Prerequisites

### 1. Get FMP API Key

1. Sign up at [Financial Modeling Prep](https://financialmodelingprep.com/developer/docs/)
2. Get your free API key (free tier: 250 requests/day)
3. Note: You need about 6 requests for the 6 stocks on first run, then 1-6 requests per day for updates

### 2. Set Environment Variable

**On Linux/Mac:**
```bash
export FMP_API_KEY='your_api_key_here'
```

**On Windows (PowerShell):**
```powershell
$env:FMP_API_KEY='your_api_key_here'
```

**For Docker:**
```bash
docker run --rm -e FMP_API_KEY='your_api_key_here' gary-stock-analysis
```

## 🧪 Testing

### Test FMP API Connection:
```bash
python test_fmp_api.py
```

This will test:
- ✅ FMP API connectivity
- ✅ Cache system
- ✅ Full workflow with incremental updates

## 🐳 Docker Setup

### 1. Build Docker Image:
```bash
docker build -t gary-stock-analysis .
```

### 2. Run Manually:
```bash
docker run --rm -e FMP_API_KEY='your_api_key_here' gary-stock-analysis
```

### 3. Run with Volume (to persist cache):
```bash
docker run --rm \
  -e FMP_API_KEY='your_api_key_here' \
  -v $(pwd)/cache:/app \
  gary-stock-analysis
```

This mounts a local `cache` directory so the JSON cache persists between runs.

## ⏰ Cron Job Setup

### Update Crontab:
```bash
crontab -e
```

### Add this line for daily 4 PM HKT (8 AM UTC):
```bash
0 8 * * * docker run --rm -e FMP_API_KEY='your_key' -v /home/ken/AI/gary/stock/cache:/app gary-stock-analysis
```

**Important**: Replace `your_key` with your actual FMP API key.

## 📊 How It Works

### First Run:
1. Checks for `stock_prices_cache.json`
2. Not found → Fetches full historical data from 2021-01-01
3. Saves all data to cache
4. Generates chart and sends to Telegram

### Subsequent Runs:
1. Loads `stock_prices_cache.json`
2. Checks latest date in cache
3. Only fetches missing dates (e.g., today if cache is from yesterday)
4. Updates cache with new data
5. Generates chart and sends to Telegram

### Example Output:
```
🌐 Loading stock prices with FMP API + Cache...
📦 Cache found: Checking for missing dates...

📈 Processing stock 9988...
📅 Fetching missing dates: 2025-10-23 to 2025-10-24
📡 Fetching 9988.HK from FMP API...
✅ Fetched 2 price points for 9988.HK

📈 Processing stock 0388...
✅ 0388 is up to date

... (other stocks)

💾 Saved cache with 1152 dates
✅ Loaded 1152 rows of price data
📅 Date range: 2021-01-04 to 2025-10-24
```

## 📁 Files

- `hk_stock_analysis_docker.py` - Main analysis script with FMP integration
- `profolio.csv` - Your portfolio transactions
- `stock_prices_cache.json` - Cached price data (auto-generated)
- `Dockerfile` - Docker configuration
- `test_fmp_api.py` - Test script for FMP API

## 🔑 API Key Security

**Never commit your API key to git!**

Add to `.gitignore`:
```
stock_prices_cache.json
*.env
.env
```

For production, consider using:
- Docker secrets
- Environment variable files
- Secret management services (AWS Secrets Manager, etc.)

## 🎯 Stocks Tracked

Currently tracking 6 Hong Kong stocks:
- 9988 (Alibaba)
- 0388 (Hong Kong Exchanges)
- 0823 (Link REIT)
- 3690 (Meituan)
- 0728 (China Telecom)
- 3329 (Qianhai Health)

## 📈 Performance

### API Usage:
- **First run**: ~6 API calls (one per stock)
- **Daily updates**: 1-6 API calls (only for stocks with new data)
- **Free tier limit**: 250 calls/day (more than enough)

### Speed:
- **First run**: ~10-15 seconds (fetching historical data)
- **Daily updates**: ~3-5 seconds (only fetching 1-2 days)
- **With cache**: Very fast, no API calls if already up to date

## 🆘 Troubleshooting

### "FMP_API_KEY not set"
- Make sure you set the environment variable
- For Docker, use `-e FMP_API_KEY='your_key'`

### "No historical data for X.HK"
- Check if the stock symbol is correct
- Some stocks might not be available on FMP
- Try the symbol on FMP website first

### Cache not updating
- Delete `stock_prices_cache.json` and run again
- Check file permissions
- Make sure volume mount is correct in Docker

### API rate limit exceeded
- Free tier: 250 requests/day
- Wait 24 hours or upgrade to paid plan
- Cache helps reduce API calls significantly

## 📞 Support

For issues or questions:
1. Check the test script: `python test_fmp_api.py`
2. Review Docker logs: `docker logs <container_id>`
3. Verify API key at [FMP Dashboard](https://financialmodelingprep.com/developer/docs/)

