#!/bin/bash
set -e

echo "Configuring Apache2 with environment variables from Docker..."

# Set ServerName of created container
if [ -f /etc/apache2/apache2.conf ]; then
	echo "ServerName $(cat /etc/hostname)" >> /etc/apache2/apache2.conf
fi

# Set APACHE_FCGI_HOST_PORT to PHP FPM in the CLI container
export APACHE_FCGI_HOST_PORT=${CLI_1_PORT_9000_TCP_ADDR}:9000

# Execute passed CMD arguments
exec "$@"
