FROM mautic/mautic:5.0-apache

# Set recommended PHP settings for Mautic
RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory-limit.ini   