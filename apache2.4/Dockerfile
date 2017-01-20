FROM debian:jessie

# Prevent services autoload (http://jpetazzo.github.io/2013/10/06/policy-rc-d-do-not-start-services-automatically/)
RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d

# Enabling additional repos
RUN sed -i 's/main/main contrib non-free/' /etc/apt/sources.list

# Install packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes --no-install-recommends install \
    curl \
    wget \
    ca-certificates \
    locales \
    supervisor \
    procps \
    dnsutils \
    nano \
    apache2-mpm-worker \
    ssl-cert \
    # Cleanup
    && DEBIAN_FRONTEND=noninteractive apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set timezone and locale
RUN dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8
ENV LC_ALL C.UTF-8

# Configuration
COPY config/apache2/sites-available/drupal.conf /etc/apache2/sites-available/drupal.conf
COPY config/apache2/sites-available/drupal-ssl.conf /etc/apache2/sites-available/drupal-ssl.conf
COPY config/apache2/sites-available/host.conf /etc/apache2/sites-available/includes/host.conf

# Startup script
COPY startup.sh /opt/startup.sh

RUN \
    # Configure folders, set permissions
    usermod -u 1000 www-data && \
    mkdir -p /var/run/apache2 && \
    mkdir -p /var/lock/apache2 && \
    chown -R www-data:www-data /var/run/apache2 && \
    chown -R www-data:www-data /var/lock/apache2 && \
    chown -R www-data:www-data /var/www && \
    ln -s /var/www/html /var/www/docroot && \
    # Enable Apache modules and sites
    a2enmod actions alias proxy_fcgi rewrite ssl && \
    a2dissite 000-default default-ssl && \
    a2ensite drupal drupal-ssl && \
    # Send logs to stdout for Docker will pick these up
    sed -i 's/ErrorLog .*/ErrorLog \/dev\/stdout/' /etc/apache2/apache2.conf && \
    sed -i 's/LogLevel .*/LogLevel info/' /etc/apache2/apache2.conf

# Configure Apache environment variables
# Need these since we are lauching apache directly with apache2 and not with apache2ctl
ENV APACHE_RUN_USER=www-data \
    APACHE_RUN_GROUP=www-data \
    APACHE_LOG_DIR=/var/log/apache2 \
    APACHE_PID_FILE=/var/run/apache2.pid \
    APACHE_RUN_DIR=/var/run/apache2 \
    APACHE_LOCK_DIR=/var/lock/apache2 \
    APACHE_SERVERADMIN=webmaster@localhost \
    APACHE_DOCUMENTROOT=/var/www/docroot

# Set TERM so text editors/etc. can be used
ENV TERM xterm

WORKDIR /var/www

EXPOSE 80 443

# Starter script
ENTRYPOINT ["/opt/startup.sh"]

# Launching apache2 directly (instead of apachectl) so it gets PID 1
CMD ["apache2", "-DFOREGROUND"]
