#!/bin/bash
set -e

# 1. Paths
MAUTIC_ROOT="/var/www/html"
MAUTIC_CONFIG_FILE="$MAUTIC_ROOT/config/local.php"

# 2. Ensure directories exist
mkdir -p "$MAUTIC_ROOT/config"
mkdir -p "$MAUTIC_ROOT/app/config"

# 3. Sync Configuration from Render Secret
if [ -f /etc/secrets/local.php ]; then
    cp /etc/secrets/local.php "$MAUTIC_CONFIG_FILE"
    cp /etc/secrets/local.php "$MAUTIC_ROOT/app/config/local.php"
    chmod 644 "$MAUTIC_CONFIG_FILE"
    chown www-data:www-data "$MAUTIC_CONFIG_FILE"
    echo "✅ Configuration synced."
fi

# 4. THE KILLSWITCH: Force HTTPS recognition
# We inject this at the very top of index.php to stop the 301 loop
if [ -f "$MAUTIC_ROOT/index.php" ]; then
    sed -i '1a if (isset($_SERVER["HTTP_X_FORWARDED_PROTO"]) && $_SERVER["HTTP_X_FORWARDED_PROTO"] == "https") { $_SERVER["HTTPS"] = "on"; }' "$MAUTIC_ROOT/index.php"
    echo "✅ SSL Proxy fix injected into index.php."
fi

# 5. Permissions
chown -R www-data:www-data "$MAUTIC_ROOT"

echo "🚀 Starting Apache..."
exec apache2-foreground
