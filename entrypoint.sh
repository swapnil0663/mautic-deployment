#!/bin/bash
set -e

# 1. Paths
MAUTIC_CONFIG_DIR="/var/www/html/app/config"
MAUTIC_CONFIG_FILE="$MAUTIC_CONFIG_DIR/local.php"

# 2. Copy Secret
mkdir -p "$MAUTIC_CONFIG_DIR"
if [ -f /etc/secrets/local.php ]; then
    cp /etc/secrets/local.php "$MAUTIC_CONFIG_FILE"
    chmod 644 "$MAUTIC_CONFIG_FILE"
    chown www-data:www-data "$MAUTIC_CONFIG_FILE"
    echo "✅ Config copied."
fi

# 3. THE FIX: Only attempt 'sed' if index.php exists
if [ -f "/var/www/html/index.php" ]; then
    sed -i '1a if (isset($_SERVER["HTTP_X_FORWARDED_PROTO"]) && $_SERVER["HTTP_X_FORWARDED_PROTO"] == "https") { $_SERVER["HTTPS"] = "on"; }' /var/www/html/index.php
    echo "✅ SSL Proxy fix applied to index.php."
else
    echo "⚠️ Warning: index.php not found yet. It will be created by Mautic on first run."
fi

# 4. Handle Mautic 5 path compatibility
mkdir -p /var/www/html/config
cp "$MAUTIC_CONFIG_FILE" /var/www/html/config/local.php || true

# 5. Final Permission Sync
chown -R www-data:www-data /var/www/html

echo "🚀 Starting Apache..."
exec apache2-foreground
