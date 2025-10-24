# 🔒 Secure API Key Setup

## ⚠️ Security Issue

**DON'T DO THIS:**
```bash
# ❌ BAD: API key visible in crontab
0 8 * * * docker run --rm -e FMP_API_KEY='1P4Q2rfzBpA5zAMM5vA7cglrpxtCJzMG' gary-stock-analysis
```

**Problems:**
- ❌ API key visible to anyone who can read crontab
- ❌ Shows up in process list (`ps aux`)
- ❌ Stored in plain text in crontab file
- ❌ Could be leaked in logs

---

## ✅ Secure Solution: Use Environment File

### Step 1: Setup on Server

```bash
# SSH to your server
ssh root@dev-ken

# Navigate to project directory
cd /home/ken/AI/gary/stock

# Run the setup script
bash setup-env.sh
```

**What it does:**
1. Creates `.env` file with your API key
2. Sets file permissions to `600` (only you can read/write)
3. Creates `docker-run.sh` script that loads the API key securely

### Step 2: Manual Setup (Alternative)

If you prefer to do it manually:

```bash
# Navigate to project directory
cd /home/ken/AI/gary/stock

# Create .env file
cat > .env << EOF
FMP_API_KEY=1P4Q2rfzBpA5zAMM5vA7cglrpxtCJzMG
EOF

# Secure the file (only owner can read/write)
chmod 600 .env

# Verify permissions
ls -la .env
# Should show: -rw------- (600)

# Make docker-run.sh executable
chmod +x docker-run.sh
```

### Step 3: Test the Secure Setup

```bash
# Test the docker-run script
./docker-run.sh
```

Expected output:
```
🐳 DOCKER Hong Kong Stock Analysis with Plotly Images
...
✅ Chart sent to Telegram!
```

### Step 4: Update Crontab (Secure Way)

```bash
# Edit crontab
crontab -e
```

**Add this line (NO API KEY!):**
```bash
0 8 * * * /home/ken/AI/gary/stock/docker-run.sh >> /home/ken/AI/gary/stock/cron.log 2>&1
```

**Benefits:**
- ✅ No API key visible in crontab
- ✅ API key stored in secure `.env` file
- ✅ File permissions protect the key
- ✅ Logs output to file for debugging

---

## 🔐 Security Best Practices

### File Permissions:

```bash
# .env file (API key)
chmod 600 .env
# -rw------- (only owner can read/write)

# docker-run.sh (script)
chmod 700 docker-run.sh
# -rwx------ (only owner can read/write/execute)
```

### Verify Security:

```bash
# Check .env permissions
ls -la /home/ken/AI/gary/stock/.env

# Check who can read it
sudo -u nobody cat /home/ken/AI/gary/stock/.env
# Should fail with "Permission denied"

# Check crontab doesn't contain API key
crontab -l | grep FMP_API_KEY
# Should return nothing
```

---

## 📁 File Structure

```
/home/ken/AI/gary/stock/
├── .env                    ← API key (chmod 600, NOT in git)
├── docker-run.sh           ← Secure run script (chmod 700)
├── setup-env.sh            ← Setup helper script
├── hk_stock_analysis_docker.py
├── Dockerfile
├── profolio.csv
└── ...
```

---

## 🔄 How It Works

### docker-run.sh:
```bash
#!/bin/bash
# Load environment variables from .env file
if [ -f /home/ken/AI/gary/stock/.env ]; then
    export $(cat /home/ken/AI/gary/stock/.env | xargs)
else
    echo "Error: .env file not found!"
    exit 1
fi

# Run Docker (API key loaded from environment)
docker run --rm -e FMP_API_KEY="$FMP_API_KEY" gary-stock-analysis
```

### Crontab:
```bash
# Just calls the script - no secrets here!
0 8 * * * /home/ken/AI/gary/stock/docker-run.sh >> /home/ken/AI/gary/stock/cron.log 2>&1
```

---

## 🆘 Troubleshooting

### Error: ".env file not found"
```bash
# Check if file exists
ls -la /home/ken/AI/gary/stock/.env

# If missing, create it
cd /home/ken/AI/gary/stock
bash setup-env.sh
```

### Error: "Permission denied"
```bash
# Fix permissions
chmod 600 /home/ken/AI/gary/stock/.env
chmod 700 /home/ken/AI/gary/stock/docker-run.sh
```

### Cron job not running
```bash
# Check cron logs
grep CRON /var/log/syslog | tail -20

# Check script logs
tail -50 /home/ken/AI/gary/stock/cron.log

# Test script manually
/home/ken/AI/gary/stock/docker-run.sh
```

---

## 🔄 Updating API Key

If you need to change your API key:

```bash
# Method 1: Edit .env file
nano /home/ken/AI/gary/stock/.env
# Change the key, save and exit

# Method 2: Run setup again
cd /home/ken/AI/gary/stock
bash setup-env.sh
```

---

## ✅ Security Checklist

Before going to production:

- [ ] `.env` file created with API key
- [ ] `.env` file permissions set to `600`
- [ ] `docker-run.sh` permissions set to `700`
- [ ] `.env` added to `.gitignore` (already done)
- [ ] Crontab uses `docker-run.sh` (no API key in crontab)
- [ ] Tested `docker-run.sh` manually
- [ ] Verified `.env` is not in git: `git status`
- [ ] Verified crontab has no secrets: `crontab -l`

---

## 📊 Comparison

| Method | Security | Convenience | Recommended |
|--------|----------|-------------|-------------|
| **API key in crontab** | ❌ Low | ✅ Easy | ❌ No |
| **Environment file** | ✅ High | ✅ Easy | ✅ Yes |
| **Docker secrets** | ✅ Very High | ⚠️ Complex | For production |
| **Secrets manager** | ✅ Very High | ⚠️ Complex | For enterprise |

---

## 🎯 Summary

**Old Way (Insecure):**
```bash
# Crontab with API key visible
0 8 * * * docker run --rm -e FMP_API_KEY='key_here' gary-stock-analysis
```

**New Way (Secure):**
```bash
# Crontab calls script (no secrets)
0 8 * * * /home/ken/AI/gary/stock/docker-run.sh >> /home/ken/AI/gary/stock/cron.log 2>&1

# API key stored securely in .env file (chmod 600)
```

**Your API key is now safe! 🔒**

