#!/bin/bash
set -e

# 1. Define paths
SECRET_SOURCE="/etc/secrets/local.php"
MAUTIC_CONFIG_DIR="/var/www/html/app/config"
MAUTIC_CONFIG_FILE="$MAUTIC_CONFIG_DIR/local.php"

# 2. Ensure the directory exists
mkdir -p "$MAUTIC_CONFIG_DIR"

# 3. Copy the secret to a writable location and fix permissions
if [ -f "$SECRET_SOURCE" ]; then
    cp "$SECRET_SOURCE" "$MAUTIC_CONFIG_FILE"
    # Now that it's a copy in a writable area, we can set permissions
    chmod 644 "$MAUTIC_CONFIG_FILE"
    chown www-data:www-data "$MAUTIC_CONFIG_FILE"
    echo "✅ Secret copied and permissions fixed at $MAUTIC_CONFIG_FILE"
else
    echo "⚠️ Warning: $SECRET_SOURCE not found. Mautic might start in installer mode."
fi

# 4. Handle Mautic 5 path compatibility as well
mkdir -p /var/www/html/config
cp "$MAUTIC_CONFIG_FILE" /var/www/html/config/local.php || true

# 5. Start Apache
echo "🚀 Starting Apache..."
exec apache2-foreground
