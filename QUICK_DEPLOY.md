# 🚀 Quick Deploy Guide (Secure Version)

## 📋 On Your Server (5 Minutes)

### Step 1: Clone Repository
```bash
ssh root@dev-ken
cd /home/ken/AI/gary/
git clone https://github.com/Liuhangfung/stock2.git stock
cd stock
```

### Step 2: Setup API Key (Secure)
```bash
# Run the setup script
bash setup-env.sh

# When prompted, enter your API key:
# 1P4Q2rfzBpA5zAMM5vA7cglrpxtCJzMG
```

This creates:
- `.env` file with your API key (chmod 600 - secure!)
- `docker-run.sh` script that loads the key

### Step 3: Build Docker
```bash
docker build -t gary-stock-analysis .
```

### Step 4: Test Run
```bash
# Make script executable
chmod +x docker-run.sh

# Test it
./docker-run.sh
```

Expected output:
```
🐳 DOCKER Hong Kong Stock Analysis with Plotly Images
...
✅ Successfully sent to BOTH Telegram chats!
```

### Step 5: Setup Cron Job (Secure - No API Key!)
```bash
crontab -e
```

Add this line:
```bash
0 8 * * * /home/ken/AI/gary/stock/docker-run.sh >> /home/ken/AI/gary/stock/cron.log 2>&1
```

**Note:** No API key in crontab! It's loaded from `.env` file.

### Step 6: Verify
```bash
# Check .env file exists and is secure
ls -la .env
# Should show: -rw------- (600)

# Check crontab has no secrets
crontab -l
# Should NOT show your API key

# Check logs
tail -f cron.log
```

---

## 🔒 Security Features

✅ **API key stored in `.env` file** (not in crontab)
✅ **File permissions: 600** (only you can read)
✅ **`.env` in `.gitignore`** (never committed to git)
✅ **No secrets in process list** (`ps aux`)
✅ **Logs saved to file** (for debugging)

---

## 📊 Daily Operation

### What Happens at 4 PM HKT (8 AM UTC):
1. Cron runs `docker-run.sh`
2. Script loads API key from `.env`
3. Docker fetches missing price data (1-6 API calls)
4. Generates chart with performance strip
5. Sends to both Telegram chats
6. Updates cache for next day
7. Logs output to `cron.log`

**Time:** 3-5 seconds
**API Usage:** 1-6 calls per day

---

## 🆘 Troubleshooting

### Check if it's working:
```bash
# View recent logs
tail -50 /home/ken/AI/gary/stock/cron.log

# Test manually
/home/ken/AI/gary/stock/docker-run.sh

# Check cache
ls -lh stock_prices_cache.json
```

### If something fails:
```bash
# Check .env exists
cat /home/ken/AI/gary/stock/.env

# Check permissions
ls -la /home/ken/AI/gary/stock/.env

# Rebuild Docker
docker build -t gary-stock-analysis . --no-cache

# Check cron is running
systemctl status cron
```

---

## 📝 File Locations

```
/home/ken/AI/gary/stock/
├── .env                    ← Your API key (secure, chmod 600)
├── docker-run.sh           ← Run script (loads .env)
├── stock_prices_cache.json ← Price data cache
├── cron.log                ← Cron job logs
├── portfolio_chart.png     ← Generated chart
└── ...
```

---

## ✅ Deployment Checklist

- [ ] Repository cloned to server
- [ ] `.env` file created with API key
- [ ] `.env` permissions set to 600
- [ ] Docker image built
- [ ] `docker-run.sh` tested manually
- [ ] Chart received in Telegram
- [ ] Crontab updated (no API key in it!)
- [ ] Logs working (`cron.log`)
- [ ] Verified `.env` not in git

---

## 🎉 Done!

Your secure stock analysis system is now running!

- ✅ API key stored securely
- ✅ Daily updates at 4 PM HKT
- ✅ Charts sent to Telegram
- ✅ Cache updated automatically
- ✅ No secrets exposed

**Check your Telegram at 4 PM HKT tomorrow! 📈**

