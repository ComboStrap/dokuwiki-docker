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
    # bsdtar to unzip without the first directory \
    # https://www.libarchive.org/
    # https://packages.debian.org/unstable/libarchive-tools
    && apt-get install -y libarchive-tools \
    # Supervisor Installation
    && apt-get install -y --no-install-recommends supervisor \
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
# It's used only by Docker
# For Kubernetes, the probes must be defined in the manifest
####################################
HEALTHCHECK --timeout=5s \
    CMD curl --silent --fail-with-body http://localhost/dokuwiki-docker/ping.php || exit 1

####################################
# Default CMD
####################################
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
# All users can write in /run becayse supervisor will write socket/file in it
RUN chmod 0777 /run
ADD resources/conf/supervisor/supervisord.conf /supervisord.conf
#### Php
ADD resources/conf/php/dokuwiki-docker.ini /usr/local/etc/php/conf.d/dokuwiki-docker.ini
#### Php-fpm
# Security Note: Don't expose the Php FPM service to the world
# Because configuration settings are passed to php-fpm as fastcgi headers,
# anyone could alter the PHP configuration.
# If you want to expose the PHP-FPM port (default 9000), see the `listen.allowed_clients` conf.
# https://www.php.net/manual/en/install.fpm.configuration.php#listen-allowed-clients
# List: https://www.php.net/manual/en/install.fpm.configuration.php
ADD --chmod=0644 resources/conf/php-fpm/php-fpm.conf /usr/local/etc/
ADD --chmod=0644 resources/conf/php-fpm/www.conf /usr/local/etc/php-fpm.d/
## See also
## /usr/local/etc/php-fpm.d/docker.conf
## /usr/local/etc/php-fpm.d/zz-docker.conf
RUN chmod 0777 /var/log # Gives permission to the running user to create log
RUN chmod 0777 /usr/local/etc/php # Gives permission to the running user to create php ini file
#### Caddy
EXPOSE 80
COPY resources/conf/caddy/Caddyfile /Caddyfile
#### Bash (to get the same env with `docker exec bash -l`)
ADD --chmod=0755 resources/conf/bash/dokuwiki-docker-env.sh /etc/profile.d/dokuwiki-docker-env.sh

####################################
# Dokuwiki Docker App Install
####################################
RUN mkdir "/opt/dokuwiki-docker"
COPY resources/dokuwiki-docker /opt/dokuwiki-docker
RUN chmod 0755 /opt/dokuwiki-docker/bin/*
ENV PATH="/opt/dokuwiki-docker/bin:${PATH}"
ENTRYPOINT ["/opt/dokuwiki-docker/bin/dokuwiki-docker-entrypoint"]

####################################
# Phpctl App Install
####################################
RUN mkdir "/opt/phpctl"
COPY resources/phpctl /opt/phpctl
RUN chmod 0755 /opt/phpctl/bin/*
ENV PATH="/opt/phpctl/bin:${PATH}"

####################################
# dokuctl App Install
####################################
RUN mkdir "/opt/dokuctl"
COPY resources/dokuctl /opt/dokuctl
RUN chmod 0755 /opt/dokuctl/bin/*
ENV PATH="/opt/dokuctl/bin:${PATH}"
