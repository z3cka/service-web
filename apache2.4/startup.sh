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

# Execute passed CMD arguments
exec "$@"
