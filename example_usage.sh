#!/bin/bash

# Example Usage - FMP API Stock Analysis
# ========================================

echo "📚 Example Usage for FMP API Stock Analysis"
echo ""

# Step 1: Set your FMP API key
echo "Step 1: Set your FMP API key"
echo "----------------------------"
echo "export FMP_API_KEY='your_api_key_here'"
echo ""
echo "Get your key from: https://financialmodelingprep.com/"
echo ""

# Step 2: Test the API (optional but recommended)
echo "Step 2: Test the API (optional)"
echo "-------------------------------"
echo "python test_fmp_api.py"
echo ""

# Step 3: Build Docker image
echo "Step 3: Build Docker image"
echo "--------------------------"
echo "docker build -t gary-stock-analysis ."
echo ""

# Step 4: Run manually (first time)
echo "Step 4: Run manually (first time - will take 10-15 seconds)"
echo "------------------------------------------------------------"
echo "docker run --rm -e FMP_API_KEY='your_key' -v \$(pwd):/app gary-stock-analysis"
echo ""
echo "This will:"
echo "  - Fetch full historical data from 2021-01-01"
echo "  - Save to stock_prices_cache.json"
echo "  - Generate chart"
echo "  - Send to Telegram"
echo ""

# Step 5: Run again (subsequent runs)
echo "Step 5: Run again (subsequent runs - will take 3-5 seconds)"
echo "------------------------------------------------------------"
echo "docker run --rm -e FMP_API_KEY='your_key' -v \$(pwd):/app gary-stock-analysis"
echo ""
echo "This will:"
echo "  - Load cache"
echo "  - Only fetch missing dates (today if cache is yesterday)"
echo "  - Update cache"
echo "  - Generate chart"
echo "  - Send to Telegram"
echo ""

# Step 6: Set up cron job
echo "Step 6: Set up cron job (for daily 4 PM HKT / 8 AM UTC)"
echo "--------------------------------------------------------"
echo "crontab -e"
echo ""
echo "Add this line:"
echo "0 8 * * * cd /home/ken/AI/gary/stock && docker run --rm -e FMP_API_KEY='your_key' -v /home/ken/AI/gary/stock:/app gary-stock-analysis"
echo ""

# Alternative: Use the provided scripts
echo "Alternative: Use the provided scripts"
echo "-------------------------------------"
echo ""
echo "For Linux/Mac:"
echo "  export FMP_API_KEY='your_key'"
echo "  ./run_docker.sh"
echo ""
echo "For Windows (PowerShell):"
echo "  \$env:FMP_API_KEY='your_key'"
echo "  .\\run_docker.bat"
echo ""

# Troubleshooting
echo "Troubleshooting"
echo "---------------"
echo ""
echo "1. Check if API key is set:"
echo "   echo \$FMP_API_KEY"
echo ""
echo "2. Check cache file:"
echo "   ls -lh stock_prices_cache.json"
echo "   cat stock_prices_cache.json | head -20"
echo ""
echo "3. Delete cache and start fresh:"
echo "   rm stock_prices_cache.json"
echo "   docker run --rm -e FMP_API_KEY='your_key' -v \$(pwd):/app gary-stock-analysis"
echo ""
echo "4. View Docker logs:"
echo "   docker ps -a  # Get container ID"
echo "   docker logs <container_id>"
echo ""

echo "✅ Ready to go! Set your FMP_API_KEY and run the commands above."

