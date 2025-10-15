#!/bin/sh

# Assert that the env variable UPLOAD_SECRET is set
if [ -z "${UPLOAD_SECRET:-}" ]; then
    echo "Error: UPLOAD_SECRET is not set"
    exit 1
fi

set -e

envsubst '${UPLOAD_SECRET}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

spawn-fcgi -s /run/fcgi.socket -u www-writer -g www-data /usr/bin/fcgiwrap

# Set socket permissions so everyone can access it
chmod 666 /run/fcgi.socket
chmod o+rx /var/www/uploads

exec nginx -g 'daemon off;'
