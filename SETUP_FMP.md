# Quick Setup Guide - FMP API Migration

## 🎯 Quick Start

### 1. Get Your FMP API Key

1. Go to https://financialmodelingprep.com/developer/docs/
2. Sign up for a free account
3. Copy your API key from the dashboard

### 2. Set Environment Variable

**Windows (PowerShell):**
```powershell
$env:FMP_API_KEY='your_api_key_here'
```

**Linux/Mac:**
```bash
export FMP_API_KEY='your_api_key_here'
```

### 3. Test Locally (Optional)

```bash
python test_fmp_api.py
```

Expected output:
```
✅ Success! Got XXX data points
✅ Cache system working!
✅ Full workflow working!
```

### 4. Run with Docker

**Windows:**
```powershell
.\run_docker.bat
```

**Linux/Mac:**
```bash
./run_docker.sh
```

## 📊 What Happens on First Run

```
🌐 Loading stock prices with FMP API + Cache...
📥 First run: Fetching full historical data...

📈 Processing stock 9988...
📡 Fetching 9988.HK from FMP API...
✅ Fetched 1150 price points for 9988.HK

📈 Processing stock 0388...
📡 Fetching 0388.HK from FMP API...
✅ Fetched 1150 price points for 0388.HK

... (4 more stocks)

💾 Saved cache with 1150 dates
✅ Loaded 1150 rows of price data
📅 Date range: 2021-01-04 to 2025-10-24
```

This will take about 10-15 seconds and create `stock_prices_cache.json`.

## 📊 What Happens on Subsequent Runs

```
🌐 Loading stock prices with FMP API + Cache...
📦 Cache found: Checking for missing dates...

📈 Processing stock 9988...
📅 Fetching missing dates: 2025-10-24 to 2025-10-24
📡 Fetching 9988.HK from FMP API...
✅ Fetched 1 price points for 9988.HK

📈 Processing stock 0388...
✅ 0388 is up to date

... (other stocks)

💾 Saved cache with 1151 dates
✅ Loaded 1151 rows of price data
```

This takes only 3-5 seconds! 🚀

## 🔄 Updating Cron Job

### Old Cron (Google Sheets):
```bash
0 8 * * * cd /home/ken/AI/gary/stock && docker run --rm gary-stock-analysis
```

### New Cron (FMP API):
```bash
0 8 * * * cd /home/ken/AI/gary/stock && docker run --rm -e FMP_API_KEY='your_key' -v /home/ken/AI/gary/stock:/app gary-stock-analysis
```

**Important changes:**
1. Added `-e FMP_API_KEY='your_key'` - sets API key
2. Added `-v /home/ken/AI/gary/stock:/app` - persists cache between runs

### Update Your Crontab:
```bash
crontab -e
```

Replace the old line with the new one, then save.

## 🎯 Benefits of FMP API

| Feature | Google Sheets | FMP API |
|---------|--------------|---------|
| **Reliability** | ⚠️ Sometimes returns NA | ✅ Always reliable |
| **Speed (first run)** | ~5 seconds | ~10-15 seconds |
| **Speed (daily)** | ~5 seconds | ~3-5 seconds |
| **Setup** | Need to publish sheet | Just need API key |
| **Maintenance** | Need to check formulas | Zero maintenance |
| **Data quality** | Can have gaps | Always complete |

## 🆘 Troubleshooting

### Error: "FMP_API_KEY not set"
**Solution:** Set the environment variable before running:
```bash
export FMP_API_KEY='your_key_here'
```

### Error: "No historical data for X.HK"
**Solution:** 
1. Check if the stock symbol is correct
2. Try accessing the stock on FMP website first
3. Some stocks might not be available

### Cache not updating
**Solution:**
```bash
# Delete cache and start fresh
rm stock_prices_cache.json
docker run --rm -e FMP_API_KEY='your_key' -v $(pwd):/app gary-stock-analysis
```

### API rate limit exceeded
**Solution:**
- Free tier: 250 requests/day
- You're using ~6 requests on first run, then 1-6 per day
- Should be fine unless you run it many times
- Wait 24 hours or upgrade to paid plan

## 📁 Files Created

After first run, you'll see:
```
gary_stock/
├── stock_prices_cache.json  ← New! Price data cache
├── portfolio_chart.png       ← Generated chart
├── hk_stock_analysis_docker.py
├── profolio.csv
└── ...
```

**Do not delete `stock_prices_cache.json`** - it makes subsequent runs much faster!

## ✅ Verification

After setup, verify everything works:

1. **Check cache exists:**
   ```bash
   ls -lh stock_prices_cache.json
   ```
   Should show a file ~500KB-1MB

2. **Check cache content:**
   ```bash
   head -20 stock_prices_cache.json
   ```
   Should show JSON with dates and stock prices

3. **Run manually:**
   ```bash
   docker run --rm -e FMP_API_KEY='your_key' -v $(pwd):/app gary-stock-analysis
   ```
   Should complete in 3-5 seconds (after first run)

4. **Check Telegram:**
   You should receive the chart in both Telegram chats

## 🎉 Done!

Your system is now using FMP API with intelligent caching. Enjoy faster, more reliable stock analysis!

