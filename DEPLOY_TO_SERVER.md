# 🚀 Deploy to Server - FMP API Version

## ✅ Local Testing Complete!

Your FMP API integration has been tested successfully:
- ✅ Fetched 1,188 historical data points (2021-01-04 to 2025-10-24)
- ✅ Cache system working (215 KB cache file created)
- ✅ All 6 stocks loaded successfully
- ✅ Performance calculations correct

## 📦 Deploy to Your Linux Server

### Step 1: Upload Files to Server

```bash
# On your local machine, upload to server
scp -r . root@dev-ken:/home/ken/AI/gary/stock/
```

Or use git:
```bash
# On server
cd /home/ken/AI/gary/stock
git pull
```

### Step 2: Set FMP API Key on Server

```bash
# SSH to your server
ssh root@dev-ken

# Navigate to directory
cd /home/ken/AI/gary/stock

# Set API key (add to .bashrc for persistence)
echo 'export FMP_API_KEY="1P4Q2rfzBpA5zAMM5vA7cglrpxtCJzMG"' >> ~/.bashrc
source ~/.bashrc

# Verify it's set
echo $FMP_API_KEY
```

### Step 3: Build Docker Image

```bash
cd /home/ken/AI/gary/stock
docker build -t gary-stock-analysis .
```

Expected output:
```
Successfully built xxxxx
Successfully tagged gary-stock-analysis:latest
```

### Step 4: Test Run (First Time)

```bash
docker run --rm \
  -e FMP_API_KEY='1P4Q2rfzBpA5zAMM5vA7cglrpxtCJzMG' \
  -v /home/ken/AI/gary/stock:/app \
  gary-stock-analysis
```

**Expected behavior:**
- Takes ~15 seconds (fetching historical data)
- Creates `stock_prices_cache.json`
- Generates chart
- Sends to both Telegram chats
- Shows: "🎉 DOCKER analysis complete!"

### Step 5: Test Run (Second Time)

```bash
docker run --rm \
  -e FMP_API_KEY='1P4Q2rfzBpA5zAMM5vA7cglrpxtCJzMG' \
  -v /home/ken/AI/gary/stock:/app \
  gary-stock-analysis
```

**Expected behavior:**
- Takes ~3-5 seconds (using cache, only checking for updates)
- Shows: "✅ 9988 is up to date" for all stocks
- Generates chart
- Sends to Telegram

### Step 6: Update Cron Job

```bash
# Edit crontab
crontab -e
```

**Replace old line:**
```bash
0 8 * * * cd /home/ken/AI/gary/stock && docker run --rm gary-stock-analysis
```

**With new line:**
```bash
0 8 * * * cd /home/ken/AI/gary/stock && docker run --rm -e FMP_API_KEY='1P4Q2rfzBpA5zAMM5vA7cglrpxtCJzMG' -v /home/ken/AI/gary/stock:/app gary-stock-analysis
```

**Save and exit** (`:wq` in vim, or `Ctrl+X` then `Y` in nano)

### Step 7: Verify Cron Job

```bash
# Check crontab
crontab -l

# Check server time
date

# Calculate when next run will be (8:00 UTC = 4:00 PM HKT)
# If it's before 8:00 UTC, it will run today at 8:00 UTC
# If it's after 8:00 UTC, it will run tomorrow at 8:00 UTC
```

## 🔍 Verification Checklist

After deployment, verify:

- [ ] Files uploaded to `/home/ken/AI/gary/stock/`
- [ ] `FMP_API_KEY` environment variable set
- [ ] Docker image built successfully
- [ ] First manual run completed (~15 seconds)
- [ ] `stock_prices_cache.json` created (should be ~215 KB)
- [ ] Chart sent to both Telegram chats
- [ ] Second manual run faster (~3-5 seconds)
- [ ] Cron job updated with new command
- [ ] Cron job scheduled for 8:00 UTC (4 PM HKT)

## 📊 What to Expect Daily

### Morning (4 PM HKT / 8 AM UTC):
```
🌐 Loading stock prices with FMP API + Cache...
📦 Cache found: Checking for missing dates...

📈 Processing stock 9988...
📅 Fetching missing dates: 2025-10-24 to 2025-10-24
✅ Fetched 1 price point for 9988.HK

📈 Processing stock 0388...
✅ 0388 is up to date

... (other stocks)

💾 Saved cache with 1189 dates
✅ Chart sent to Telegram!
```

**Time:** 3-5 seconds
**API calls:** 1-6 (only for stocks with new data)

## 🆘 Troubleshooting

### Issue: "FMP_API_KEY not set"
```bash
# Check if set
echo $FMP_API_KEY

# If empty, set it
export FMP_API_KEY='1P4Q2rfzBpA5zAMM5vA7cglrpxtCJzMG'

# Add to .bashrc for persistence
echo 'export FMP_API_KEY="1P4Q2rfzBpA5zAMM5vA7cglrpxtCJzMG"' >> ~/.bashrc
```

### Issue: Cache not persisting
```bash
# Check if volume mount is correct
docker run --rm \
  -e FMP_API_KEY='1P4Q2rfzBpA5zAMM5vA7cglrpxtCJzMG' \
  -v /home/ken/AI/gary/stock:/app \
  gary-stock-analysis

# After run, check if cache exists
ls -lh /home/ken/AI/gary/stock/stock_prices_cache.json
```

### Issue: Chart not generating
```bash
# Check Docker logs
docker ps -a
docker logs <container_id>

# Rebuild Docker image
docker build -t gary-stock-analysis . --no-cache
```

### Issue: Telegram not receiving
```bash
# Check if image was created
ls -lh portfolio_chart.png

# Test Telegram bot token manually
curl -X POST "https://api.telegram.org/bot8324596740:AAH7j1rsRUddl0J-81vdeXoVFL666Y4MRYU/getMe"
```

## 📈 Monitoring

### Check Cache Status:
```bash
# View cache file
cat stock_prices_cache.json | head -50

# Check cache size
ls -lh stock_prices_cache.json

# Check latest date in cache
cat stock_prices_cache.json | grep -o '"2025-[0-9-]*"' | tail -1
```

### Check Cron Logs:
```bash
# View cron logs
grep CRON /var/log/syslog | tail -20

# Or
journalctl -u cron | tail -20
```

### Manual Test:
```bash
# Run manually anytime
cd /home/ken/AI/gary/stock
docker run --rm \
  -e FMP_API_KEY='1P4Q2rfzBpA5zAMM5vA7cglrpxtCJzMG' \
  -v /home/ken/AI/gary/stock:/app \
  gary-stock-analysis
```

## 🎉 Success Indicators

You'll know it's working when:
1. ✅ Cache file grows by a few KB each day
2. ✅ Telegram receives chart at 4 PM HKT daily
3. ✅ Chart shows updated prices
4. ✅ Performance percentages are accurate
5. ✅ No error messages in logs

## 📞 Need Help?

If you encounter issues:
1. Check the cache file exists and is growing
2. Verify API key is set: `echo $FMP_API_KEY`
3. Check Docker logs: `docker logs <container_id>`
4. Run manually to see detailed output
5. Check FMP API usage: https://financialmodelingprep.com/developer/docs/

---

**Your FMP API integration is ready for production! 🚀**

