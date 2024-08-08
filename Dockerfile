# Dokuwiki in Docker
# Files are at the end to not build package agains
#
# We start from the Php FPM image
# https://hub.docker.com/_/php/
# Dockerfile is at: https://github.com/docker-library/php/blob/master/8.3/bookworm/fpm/Dockerfile
FROM php:8.3-fpm-bookworm

####################################
# Package Installation
####################################

# Update is needed to locate packages
# Otherwise we get `Unable to locate package xxx`
RUN apt-get update && apt-get install -y \
    unzip \
    wget \
    git \
    # Supervisor Installation
    && apt-get install --no-install-recommends -y supervisor \
    # Php FastCgi - install the cgi-fcgi client to troubleshoot phpFpm
    && apt-get install -y libfcgi

####################################
# Php Extensions Installation
####################################

# Add Combostrap required Php Module
# You can check the installed module with `docker run --rm php:8.3-fpm-bookworm php -m`
#
# We use the `install-php-extensions` bash script to takes care of the package installations needed by the installation
# See https://github.com/mlocati/docker-php-extension-installer
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/download/2.3.5/install-php-extensions /usr/local/bin/

# We follows also the extensions of the official image https://github.com/dokuwiki/docker/blob/main/root/build-deps.sh
# ie gd bz2 intl opcache bz2 pdo_sqlite (pdo_sqlite is already installed)
RUN install-php-extensions gd intl opcache bz2

####################################
# Caddy Installation
####################################
COPY --from=caddy:2.8.4-alpine /usr/bin/caddy /usr/bin/caddy

####################################
# Healthcheck
# The file name is the standard name configuration in php-fpm
####################################
HEALTHCHECK --timeout=5s \
    CMD curl --silent --fail-with-body http://localhost/health_check.php || exit 1

####################################
# Entrypoint and default CMD
####################################
ADD --chmod=0755 resources/docker/dokuwiki-docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["dokuwiki-docker-entrypoint.sh"]
# we set the `c` to avoid the below warning:
# UserWarning: Supervisord is running as root and it is searching
# for its configuration file in default locations (including its current working directory);
# you probably want to specify a "-c" argument specifying
# an absolute path to a configuration file for improved security.
CMD ["supervisord", "-c", "/supervisord.conf"]

####################################
# Label
# https://docs.docker.com/reference/dockerfile/#label
# This labels are used by Github
####################################
# * connect the repo
LABEL org.opencontainers.image.source="https://github.com/combostrap/dokuwiki-docker"
# * set a description
LABEL org.opencontainers.image.description="Dokuwiki in Docker"

####################################
# Configuration files
####################################
# Configuration file are at the end to not build again
#### Supervisor
ADD resources/supervisor/supervisord.conf /supervisord.conf
#### Php-fpm
# Security Note: Don't expose the Php FPM service to the world
# Because configuration settings are passed to php-fpm as fastcgi headers,
# anyone could alter the PHP configuration.
# If you want to expose the PHP-FPM port (default 9000), see the `listen.allowed_clients` conf.
# https://www.php.net/manual/en/install.fpm.configuration.php#listen-allowed-clients
# List: https://www.php.net/manual/en/install.fpm.configuration.php
RUN mkdir -p /var/log/php-fpm \
    && touch /var/log/php-fpm/www.error.log && chmod 666 /var/log/php-fpm/www.error.log \
    && touch /var/log/php-fpm/www.access.log && chmod 666 /var/log/php-fpm/www.access.log
ADD --chmod=0644 resources/php-fpm/www.conf /usr/local/etc/php-fpm.d/
#### Dokuwiki
RUN mkdir "/var/www/dokuwiki/"
COPY resources/dokuwiki /var/www/dokuwiki/
#### caddy
EXPOSE 80
COPY resources/caddy/Caddyfile /Caddyfile