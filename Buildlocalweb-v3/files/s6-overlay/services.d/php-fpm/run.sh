#!/usr/bin/with-contenv sh

echo "Starting php-fpm"

exec php-fpm \
        -c /etc/php \
        --fpm-config /usr/local/etc/php-fpm.conf
        --force-stderr
        --nodaemonize
