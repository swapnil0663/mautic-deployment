#!/bin/bash
set -e

# 1. Paths
MAUTIC_ROOT="/var/www/html"

# 2. Sync Configuration
mkdir -p "$MAUTIC_ROOT/config"
if [ -f /etc/secrets/local.php ]; then
    cp /etc/secrets/local.php "$MAUTIC_ROOT/config/local.php"
    chown www-data:www-data "$MAUTIC_ROOT/config/local.php"
    echo "✅ Configuration synced."
fi

# 3. THE REDIRECT KILLER: Inject Apache Env Var
# This tells the server to pretend the internal connection is HTTPS
echo 'SetEnvIf X-Forwarded-Proto https HTTPS=on' > /etc/apache2/conf-enabled/render-ssl.conf
echo "✅ Apache SSL Header fix applied."

# 4. Permissions check
chown -R www-data:www-data "$MAUTIC_ROOT"

echo "🚀 Starting Apache..."
exec apache2-foreground
