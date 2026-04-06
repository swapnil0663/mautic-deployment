FROM mautic/mautic:5.0-apache

# Increase memory
RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory-limit.ini

# Create a symlink from Render's secret location to Mautic's config location
# This ensures even after a restart, Mautic finds the config
RUN ln -s /etc/secrets/local.php /var/www/html/app/config/local.php

EXPOSE 80