#!/bin/bash
# Docker Cleanup Script - Free up disk space

echo "🧹 Docker Cleanup - Freeing up disk space"
echo "=========================================="
echo ""

# Check current disk usage
echo "📊 Current disk usage:"
df -h /var/lib/docker
echo ""

# Show Docker disk usage
echo "🐳 Docker disk usage:"
docker system df
echo ""

# Ask for confirmation
read -p "⚠️  This will remove unused Docker data. Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo "🧹 Cleaning up Docker..."
echo ""

# Remove stopped containers
echo "1️⃣ Removing stopped containers..."
docker container prune -f

# Remove unused images
echo "2️⃣ Removing unused images..."
docker image prune -a -f

# Remove unused volumes
echo "3️⃣ Removing unused volumes..."
docker volume prune -f

# Remove build cache
echo "4️⃣ Removing build cache..."
docker builder prune -a -f

echo ""
echo "✅ Cleanup complete!"
echo ""

# Show new disk usage
echo "📊 New disk usage:"
df -h /var/lib/docker
echo ""

echo "🐳 New Docker disk usage:"
docker system df
echo ""

echo "🎉 Done! You should have more space now."

