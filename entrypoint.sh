#!/bin/bash
set -e

# Create both possible config directories
mkdir -p /var/www/html/app/config
mkdir -p /var/www/html/config

# Create the symlink at runtime to BOTH locations
if [ -f /etc/secrets/local.php ]; then
    ln -sf /etc/secrets/local.php /var/www/html/app/config/local.php
    ln -sf /etc/secrets/local.php /var/www/html/config/local.php
    echo "✅ Symlinks created for Mautic 4 and Mautic 5 paths."
else
    echo "⚠️ Warning: /etc/secrets/local.php not found."
fi

# Ensure permissions
chown -R www-data:www-data /var/www/html/app/config /var/www/html/config

echo "🚀 Starting Apache..."
exec apache2-foreground
