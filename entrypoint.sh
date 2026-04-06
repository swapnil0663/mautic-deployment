#!/bin/bash
set -e

# Create the directory if it doesn't exist
mkdir -p /var/www/html/app/config

# Create the symlink at runtime
if [ -f /etc/secrets/local.php ]; then
    ln -sf /etc/secrets/local.php /var/www/html/app/config/local.php
    echo "✅ Symlink created successfully."
else
    echo "⚠️ Warning: /etc/secrets/local.php not found."
fi

# Ensure permissions are correct for Apache
chown -R www-data:www-data /var/www/html/app/config

# Start Apache in the foreground (standard for this Docker image)
echo "🚀 Starting Apache..."
exec apache2-foreground
