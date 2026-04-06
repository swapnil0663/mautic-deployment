#!/bin/bash
set -e

# 1. Create the directories
mkdir -p /var/www/html/app/config
mkdir -p /var/www/html/config

# 2. Fix Permissions for the Secret (Crucial Step)
# This allows the www-data user to read the secret provided by Render
if [ -f /etc/secrets/local.php ]; then
    chmod 644 /etc/secrets/local.php
    
    # Create symlinks for both possible Mautic versions
    ln -sf /etc/secrets/local.php /var/www/html/app/config/local.php
    ln -sf /etc/secrets/local.php /var/www/html/config/local.php
    
    echo "✅ Permissions set and symlinks created."
else
    echo "⚠️ Warning: /etc/secrets/local.php not found."
fi

# 3. Ensure Mautic can write to its own cache/logs
chown -R www-data:www-data /var/www/html

echo "🚀 Starting Apache..."
exec apache2-foreground
