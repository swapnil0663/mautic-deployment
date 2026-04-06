#!/bin/bash
set -e

# 1. Define paths (Mautic 5 standard)
MAUTIC_CONFIG_DIR="/var/www/html/config"
MAUTIC_CONFIG_FILE="$MAUTIC_CONFIG_DIR/local.php"

# 2. Ensure directories exist
mkdir -p "$MAUTIC_CONFIG_DIR"
mkdir -p "/var/www/html/app/config"

# 3. Copy the Secret File and fix permissions
if [ -f /etc/secrets/local.php ]; then
    cp /etc/secrets/local.php "$MAUTIC_CONFIG_FILE"
    # Sync to Mautic 4 path just in case
    cp /etc/secrets/local.php "/var/www/html/app/config/local.php"
    
    chmod 644 "$MAUTIC_CONFIG_FILE"
    chown www-data:www-data "$MAUTIC_CONFIG_FILE"
    echo "✅ Configuration synced successfully."
else
    echo "⚠️ Warning: Secret file not found."
fi

# 4. Final ownership check for the whole web root
chown -R www-data:www-data /var/www/html

echo "🚀 Starting Mautic..."
export MAUTIC_URL="https://mautic-deployment.onrender.com"
exec apache2-foreground