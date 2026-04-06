#!/bin/bash

# Create the directory if it doesn't exist
mkdir -p /var/www/html/app/config

# Create the symlink at runtime
if [ -f /etc/secrets/local.php ]; then
    ln -sf /etc/secrets/local.php /var/www/html/app/config/local.php
    echo "✅ Symlink created: /etc/secrets/local.php -> /var/www/html/app/config/local.php"
fi

# Hand over control to the original Mautic entrypoint
exec docker-mautic-entrypoint apache2-foreground