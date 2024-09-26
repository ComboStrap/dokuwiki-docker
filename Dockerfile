# Build caddy
FROM caddy:2.8.4-builder AS caddy-builder
# Note: xcaddy build creates the caddy binary in the current directory
RUN xcaddy build \
    --with github.com/caddyserver/transform-encoder \
    --with github.com/mholt/caddy-ratelimit

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
RUN apt-get update  \
    # phpctl dependencies (Top and Jq)
    && apt-get install -y procps jq \
    # Utility
    && apt-get install -y unzip wget git \
    # bsdtar to unzip without the first directory \
    # https://www.libarchive.org/
    # https://packages.debian.org/unstable/libarchive-tools
    && apt-get install -y libarchive-tools \
    # Supervisor Installation
    && apt-get install -y --no-install-recommends supervisor \
    # Php FastCgi - install the cgi-fcgi client to troubleshoot phpFpm
    && apt-get install -y libfcgi \
    # SQlite 3 Cli (pdo_sqlite uses a library, not the cli)
    && apt-get install -y sqlite3


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
COPY --from=caddy-builder /usr/bin/caddy /usr/bin/caddy

####################################
# Dokuwiki Download
# We add Dokuwiki in the image
# Why?
# * This is the most stable piece of Dokuwiki
# * If we run the image for script development, we don't need to download it
####################################
ENV DOKUWIKI_VERSION="2024-02-06b"
# Where Dokuwiki is installed
ENV DOKUWIKI_HOME='/var/www/html'
RUN curl --fail -L "https://github.com/dokuwiki/dokuwiki/releases/download/release-${DOKUWIKI_VERSION}/dokuwiki-${DOKUWIKI_VERSION}.tgz" \
    -o /opt/dokuwiki-${DOKUWIKI_VERSION}.tgz \
    && chmod 0777 /opt/dokuwiki-${DOKUWIKI_VERSION}.tgz

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
# Configuration
####################################
# Create a host user `1000` called `me` for convenience when using WSL
# ie the UID 1000 is assigned to first non-root user
# Why? The user id created on Linux systems starts from 1000
# It permits to mount ssh keys and other asset in the home directory
RUN addgroup --gid 1000 megroup && \
    adduser --uid 1000 --gid 1000 --shell /bin/bash me

#### Env
# Where the config are found (Used by caddy: https://caddyserver.com/docs/conventions#configuration-directory)
ENV XDG_CONFIG_HOME=/etc

# Configuration file are at the end to not build again
#### Supervisor
# All users can write in /run because supervisor will write socket/file in it
RUN chmod 0777 /run
ADD resources/conf/supervisor/supervisord.conf /supervisord.conf
#### Php
# The below env are used in the dokuwiki-docker.ini and are therefore needed
# otherwise we get `Warning: PHP Startup: Invalid date.timezone value ''`
ENV PHP_UPLOAD_MAX_FILESIZE="128M"
ENV PHP_POST_MAX_SIZE="128M"
ENV PHP_DATE_TIMEZONE="UTC"
# Log is needed to pass it to the supervisor
ENV PHP_ERROR_LOG=/var/log/php/error.log
ADD resources/conf/php/dokuwiki-docker.ini /usr/local/etc/php/conf.d/dokuwiki-docker.ini

#### Php-fpm
# Security Note: Don't expose the Php FPM service to the world
# Because configuration settings are passed to php-fpm as fastcgi headers,
# anyone could alter the PHP configuration.
# If you want to expose the PHP-FPM port (default 9000), see the `listen.allowed_clients` conf.
# https://www.php.net/manual/en/install.fpm.configuration.php#listen-allowed-clients
# List: https://www.php.net/manual/en/install.fpm.configuration.php
ADD --chmod=0644 resources/conf/php-fpm/php-fpm.conf /usr/local/etc/
# Default (Image, Fetch, ...) Pool
ENV PHP_FPM_PM_WWW_MIN_SPARE_SERVERS=2
ENV PHP_FPM_PM_WWW_MAX_SPARE_SERVERS=3
ENV PHP_FPM_PM_WWW_MAX_CHILDREN=4
ENV PHP_FPM_PM_WWW_MAX_REQUESTS=500
ENV PHP_FPM_PM_WWW_MEMORY_LIMIT=128M
ADD --chmod=0644 resources/conf/php-fpm/www.conf /usr/local/etc/php-fpm.d/
# Pages Pool
ENV PHP_FPM_PM_PAGES_MIN_SPARE_SERVERS=1
ENV PHP_FPM_PM_PAGES_MAX_SPARE_SERVERS=2
ENV PHP_FPM_PM_PAGES_MAX_CHILDREN=3
ENV PHP_FPM_PM_PAGES_MAX_REQUESTS=500
ENV PHP_FPM_PM_PAGES_MEMORY_LIMIT=256M
ENV PHP_FPM_PM_PAGES_REQUEST_SLOWLOG_TIMEOUT=0
ADD --chmod=0644 resources/conf/php-fpm/pages.conf /usr/local/etc/php-fpm.d/
RUN mkdir -p /var/log/php-fpm && chmod 0777 /var/log/php-fpm

## See also
## /usr/local/etc/php-fpm.d/docker.conf
## /usr/local/etc/php-fpm.d/zz-docker.conf
RUN chmod 0777 /var/log # Gives permission to the running user to create log
RUN chmod 0777 /usr/local/etc/php # Gives permission to the running user to create php ini file
#### Caddy
EXPOSE 80
# Log is needed to pass it to the supervisor
ENV CADDY_LOG=/var/log/caddy/caddy.log
RUN mkdir $XDG_CONFIG_HOME/caddy && chmod 0777 $XDG_CONFIG_HOME/caddy # Gives permission to the running user to create files in it
COPY resources/conf/caddy/Caddyfile $XDG_CONFIG_HOME/caddy/Caddyfile
# Trusted proxy caddy configuration
ENV DOKU_DOCKER_TRUSTED_PROXY=private_ranges
# Rate limit of pages
ENV DOKU_DOCKER_PAGES_RATE_LIMIT_EVENTS=2
ENV DOKU_DOCKER_PAGES_RATE_LIMIT_WINDOW=1s
#### Bash (to get the same env with `docker exec bash -l`)
# When bash initializes a non-login interactive bash shell on a Debian/Ubuntu-like system,
# the shell first reads /etc/bash.bashrc and then reads ~/.bashrc.
COPY resources/conf/bash-env /etc
### Third User
RUN chmod 0777 /home # Gives permission to the running user to create its own HOME

####################################
# Dokuwiki Docker Install
####################################
RUN mkdir "/opt/dokuwiki-docker"
COPY resources/dokuwiki-docker /opt/dokuwiki-docker
RUN chmod 0755 /opt/dokuwiki-docker/bin/*
ENTRYPOINT ["/opt/dokuwiki-docker/bin/dokuwiki-docker-entrypoint"]
ENV PATH="/opt/dokuwiki-docker/bin:${PATH}"

####################################
# Dokuwiki Installer
####################################
RUN mkdir "/opt/dokuwiki-installer"
COPY resources/dokuwiki-installer /opt/dokuwiki-installer
RUN chmod 0755 /opt/dokuwiki-installer/bin/*
ENV PATH="/opt/dokuwiki-installer/bin:${PATH}"

####################################
# Phpctl App Install
####################################
RUN mkdir "/opt/phpctl"
COPY resources/phpctl /opt/phpctl
RUN chmod 0755 /opt/phpctl/bin/*
ENV PATH="/opt/phpctl/bin:${PATH}"

####################################
# ComboCtl App Install
####################################
RUN mkdir "/opt/comboctl"
COPY resources/comboctl /opt/comboctl
RUN chmod 0755 /opt/comboctl/bin/*
ENV PATH="/opt/comboctl/bin:${PATH}"
