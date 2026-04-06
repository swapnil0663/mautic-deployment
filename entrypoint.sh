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

# 3. THE FIX: Force Mautic to trust Render's Load Balancer (SSL fix)
# This prevents the 301 redirect loop
sed -i '1a if (isset($_SERVER["HTTP_X_FORWARDED_PROTO"]) && $_SERVER["HTTP_X_FORWARDED_PROTO"] == "https") { $_SERVER["HTTPS"] = "on"; }' /var/www/html/index.php

# 4. Handle Mautic 5 path
mkdir -p /var/www/html/config
cp "$MAUTIC_CONFIG_FILE" /var/www/html/config/local.php || true

echo "🚀 Starting Apache..."
exec apache2-foreground
