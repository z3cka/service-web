FROM debian:wheezy

MAINTAINER Leonid Makarov <leonid.makarov@blinkreaction.com>

# Prevent services autoload (http://jpetazzo.github.io/2013/10/06/policy-rc-d-do-not-start-services-automatically/)
RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d

# Enabling additional repos
RUN sed -i 's/main/main contrib non-free/' /etc/apt/sources.list

# Basic packages
RUN \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes --no-install-recommends install \
    ca-certificates apache2-mpm-worker libapache2-mod-fastcgi && \
    # Cleanup
    DEBIAN_FRONTEND=noninteractive apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN a2enmod actions alias fastcgi rewrite ssl && \
    a2ensite default-ssl

# Configuration
ADD ./config/apache2/sites-available/default /etc/apache2/sites-available/default
ADD ./config/apache2/sites-available/default-ssl /etc/apache2/sites-available/default-ssl
ADD ./config/apache2/sites-available/host.conf /etc/apache2/sites-available/includes/host.conf
ADD ./config/apache2/mods-enabled/fastcgi.conf /etc/apache2/mods-enabled/fastcgi.conf

RUN \
    sed -i 's/ErrorLog .*/ErrorLog \/dev\/stdout/' /etc/apache2/apache2.conf && \
    sed -i 's/LogLevel .*/LogLevel info/' /etc/apache2/apache2.conf

# Generate SSL certificate and key
RUN openssl req -batch -nodes -newkey rsa:2048 -keyout /etc/ssl/private/server.key -out /tmp/server.csr && \
    openssl x509 -req -days 365 -in /tmp/server.csr -signkey /etc/ssl/private/server.key -out /etc/ssl/certs/server.crt;rm /tmp/server.csr

RUN usermod -u 1000 www-data && \
    mkdir -p /var/run/apache2/fastcgi/dynamic && \
    chown -R www-data:www-data /var/run/apache2 && \
    chown -R www-data:www-data /var/www

# Startup script
COPY ./startup.sh /opt/startup.sh

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
#ENV APACHE_SERVERADMIN admin@localhost
#ENV APACHE_SERVERNAME localhost
#ENV APACHE_SERVERALIAS docker.localhost
ENV DOCROOT /var/www/docroot

WORKDIR /var/www

EXPOSE 80 443

# Starter script
ENTRYPOINT ["/opt/startup.sh"]

#CMD ["apache2ctl", "-DFOREGROUND"]
CMD ["/usr/sbin/apache2", "-DFOREGROUND"]
