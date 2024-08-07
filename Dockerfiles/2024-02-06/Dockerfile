# Php FPM
# https://hub.docker.com/_/php/
# Dockerfile: https://github.com/docker-library/php/blob/master/8.3/bookworm/fpm/Dockerfile
FROM php:8.3-fpm-bookworm

# Label
# https://docs.docker.com/reference/dockerfile/#label
LABEL org.opencontainers.image.source="https://github.com/combostrap/dokuwiki-docker"
LABEL org.opencontainers.image.description="Dokuwiki in Docker"

# Packages
# Update is needed to locate packages
# Otherwise we get `Unable to locate package xxx`
RUN apt-get update && apt-get install -y \
    unzip \
    git


####################################
# Supervisor
####################################
RUN apt-get install --no-install-recommends -y supervisor
ADD resources/supervisor/supervisord.conf /supervisord.conf
# we set the `c` to avoid the below warning:
# UserWarning: Supervisord is running as root and it is searching
# for its configuration file in default locations (including its current working directory);
# you probably want to specify a "-c" argument specifying
# an absolute path to a configuration file for improved security.
CMD ["supervisord", "-c", "/supervisord.conf"]


####################################
# Dokuwiki
####################################
# https://www.dokuwiki.org/install
# Download dokuwiki locally to copy it if not present on the mounted volume
WORKDIR /var/www/dokuwiki
RUN mkdir -p /var/www/dokuwiki \
    && apt-get install -y wget unzip \
    && wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-2024-02-06b.tgz -O dokuwiki.tgz \
    && wget https://github.com/cosmocode/sqlite/archive/refs/heads/master.zip -O sqlite.zip \
    && wget https://github.com/ComboStrap/combo/archive/refs/heads/main.zip -O combo.zip
# Returns to the default working directory
WORKDIR /var/www/html

####################################
# Php FPM
#################################### \
# List: https://www.php.net/manual/en/install.fpm.configuration.php
# Security Note: Don't expose the Php FPM service to the world
# Because configuration settings are passed to php-fpm as fastcgi headers,
# anyone could alter the PHP configuration.
# If you want to expose the PHP-FPM port (default 9000), see the `listen.allowed_clients` conf.
# https://www.php.net/manual/en/install.fpm.configuration.php#listen-allowed-clients
ADD --chmod=0644 resources/php-fpm/www.conf /usr/local/etc/php-fpm.d/
# install the cgi-fcgi client to troubleshoot phpFpm
RUN apt-get install -y libfcgi \
    && mkdir -p /var/log/php-fpm \
    && touch /var/log/php-fpm/www.error.log && chmod 666 /var/log/php-fpm/www.error.log \
    && touch /var/log/php-fpm/www.access.log && chmod 666 /var/log/php-fpm/www.access.log

####################################
# Php
####################################
# https://hub.docker.com/_/php/

# Add Combostrap required Php Module
# You can check the installed module with `docker run --rm php:8.3-fpm-bookworm php -m`
# We use the `install-php-extensions` script to takes care of the needed extensions package installation
# See https://github.com/mlocati/docker-php-extension-installer
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN install-php-extensions gd intl opcache

####################################
# Caddy
####################################
COPY --from=caddy:2.8.4-alpine /usr/bin/caddy /usr/bin/caddy
COPY resources/caddy/Caddyfile /Caddyfile
EXPOSE 80

####################################
# Entrypoint
####################################
ADD --chmod=0755 resources/docker/docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]