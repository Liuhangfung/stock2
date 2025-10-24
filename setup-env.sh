#!/bin/bash
# Setup Environment Variables Securely
# Run this once on your server

echo "🔐 Setting up secure environment for FMP API"
echo ""

# Create .env file in the project directory
ENV_FILE="/home/ken/AI/gary/stock/.env"

# Check if .env already exists
if [ -f "$ENV_FILE" ]; then
    echo "⚠️  .env file already exists at $ENV_FILE"
    read -p "Do you want to overwrite it? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled."
        exit 0
    fi
fi

# Prompt for API key
read -p "Enter your FMP API key: " API_KEY

# Create .env file
cat > "$ENV_FILE" << EOF
FMP_API_KEY=$API_KEY
EOF

# Secure the file (only owner can read/write)
chmod 600 "$ENV_FILE"

echo ""
echo "✅ Environment file created at: $ENV_FILE"
echo "✅ File permissions set to 600 (owner read/write only)"
echo ""
echo "📝 Next steps:"
echo "1. Make docker-run.sh executable: chmod +x /home/ken/AI/gary/stock/docker-run.sh"
echo "2. Test: /home/ken/AI/gary/stock/docker-run.sh"
echo "3. Update crontab: crontab -e"
echo "   Add: 0 8 * * * /home/ken/AI/gary/stock/docker-run.sh"
echo ""
echo "🔒 Your API key is now stored securely!"

