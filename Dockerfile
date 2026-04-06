FROM mautic/mautic:5.0-apache

# Increase memory
RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory-limit.ini

# Copy our custom entrypoint and make it executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Tell Docker to use our script on startup
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 80