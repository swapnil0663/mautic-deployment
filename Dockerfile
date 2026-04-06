FROM mautic/mautic:5.0-apache

# Increase memory for the installer
RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory-limit.ini

# Ensure Apache listens on the port Render expects
ENV PORT=80
EXPOSE 80