#!/bin/bash
set -e

echo "Configuring Apache2 environment variables..."

# Set ServerName of created container
export APACHE_SERVERNAME="${APACHE_SERVERNAME:-$(cat /etc/hostname)}"

# Set APACHE_FCGI_HOST_PORT to PHP FPM daemon in the CLI container
# If CLI_1_PORT_9000_TCP_ADDR is undefined (version 2 docker-compose.yml) - default to "cli"
export APACHE_FCGI_HOST_PORT="${APACHE_FCGI_HOST_PORT:-${CLI_1_PORT_9000_TCP_ADDR:-cli}:9000}"

# Basic HTTP Authentication
export APACHE_AUTH_OFF=''
if [[ $APACHE_BASIC_AUTH_USER != '' && $APACHE_BASIC_AUTH_PASS != '' ]]; then
	echo "Enabling Basic HTTP Authentication [${APACHE_BASIC_AUTH_USER}:${APACHE_BASIC_AUTH_PASS}]"
	htpasswd -cb /opt/htpasswd $APACHE_BASIC_AUTH_USER $APACHE_BASIC_AUTH_PASS
else
	# A simple way to disable authentication
	export APACHE_AUTH_OFF='Satisfy Any'
fi

# Execute passed CMD arguments
exec "$@"
