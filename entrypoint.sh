#!/bin/bash
set -e

# 1. Paths for Mautic 5
MAUTIC_CONFIG_DIR="/var/www/html/config"
MAUTIC_CONFIG_FILE="$MAUTIC_CONFIG_DIR/local.php"

# 2. Ensure directory exists
mkdir -p "$MAUTIC_CONFIG_DIR"

# 3. Copy the Secret File and fix permissions
if [ -f /etc/secrets/local.php ]; then
    cp /etc/secrets/local.php "$MAUTIC_CONFIG_FILE"
    chmod 644 "$MAUTIC_CONFIG_FILE"
    chown www-data:www-data "$MAUTIC_CONFIG_FILE"
    echo "✅ Configuration synced successfully."
else
    echo "⚠️ Warning: Secret file /etc/secrets/local.php not found."
fi

# 4. Final ownership check
chown -R www-data:www-data /var/www/html/config

echo "🚀 Starting Apache..."
exec apache2-foreground
