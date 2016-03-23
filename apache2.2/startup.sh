#!/bin/bash
set -e

echo "Configuring Apache2 environment variables..."

# Set ServerName of created container
if [ -z $APACHE_SERVERNAME ]; then
	export APACHE_SERVERNAME="$(cat /etc/hostname)"
fi

# Set APACHE_FCGI_HOST_PORT to PHP FPM daemon in the CLI container
if [ -z $APACHE_FCGI_HOST_PORT ]; then
	export APACHE_FCGI_HOST_PORT="${CLI_1_PORT_9000_TCP_ADDR}:9000"
fi

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
