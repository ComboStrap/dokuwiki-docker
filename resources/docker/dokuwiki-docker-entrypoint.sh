#!/bin/bash
set -e

#############################################
# Script -
# * Dokuwiki: Install if not present
# * Conf: php-fpm and php
# Note: the current directory is /var/www/html
#############################################

# Env
# .bashrc to bring the environments
. /root/.bashrc

#############
# Supervisor
#############
# Create log dirs
# The log directory are not created and just stop supervisor
# https://github.com/Supervisor/supervisor/issues/120#issuecomment-209292870
SUPERVISOR_CONF_PATH=${SUPERVISOR_CONF_PATH:-/supervisord.conf}
LOG_HOME=${LOG_HOME:-/var/log}
export PHP_ERROR_LOG=${LOG_HOME}/php/error.log
export CADDY_LOG=${LOG_HOME}/caddy/caddy.log
LOGS=(
    "$CADDY_LOG"
    "$PHP_ERROR_LOG"
)
for LOG in "${LOGS[@]}"; do
    LOG_PARENT=$(dirname "$LOG")
    mkdir -p "$LOG_PARENT"
    touch "$LOG"
    chmod 666 "$LOG"
done

#############
# Php Conf
#############
export PHP_UPLOAD_MAX_FILESIZE=${PHP_UPLOAD_MAX_FILESIZE:-128M}
export PHP_POST_MAX_SIZE=${PHP_POST_MAX_SIZE:-$PHP_UPLOAD_MAX_FILESIZE}
export PHP_MEMORY_LIMIT=${PHP_UPLOAD_LIMIT:-256M}
export PHP_DATE_TIMEZONE=${PHP_DATE_TIMEZONE:-UTC}


# Note: Theses default configs are customized by configuration files into the $PHP_INI_DIR/conf.d/ directory.
if [[ ! -f "$PHP_INI_DIR/php.ini" ]] && [[ "${DOKU_DOCKER_ENV}" != "dev" ]]; then
  echo "Production Mode"
  mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
else
  echo "Development Mode"
  mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
fi


#############
# Php Fpm Conf
#############
export PHP_FPM_PM_START_SERVERS=${PHP_FPM_PM_START_SERVERS:-2}

#############
# Dokuwiki
#############
# https://www.dokuwiki.org/install
export DOKUWIKI_VERSION=${DOKUWIKI_VERSION:-2024-02-06b}
if [[ ! -f doku.php ]]; then

    # Install is done by downloading
    # Download DokuWiki from the official website or from GitHub

    echo "Dokuwiki not found, installing version ${DOKUWIKI_VERSION} ..."
    curl --fail -L "https://download.dokuwiki.org/src/dokuwiki/dokuwiki-${DOKUWIKI_VERSION}.tgz" -o dokuwiki.tgz || curl --fail -L "https://github.com/dokuwiki/dokuwiki/releases/download/release-${DOKUWIKI_VERSION}/dokuwiki-${DOKUWIKI_VERSION}.tgz" -o dokuwiki.tgz \
        && tar -xzf dokuwiki.tgz --strip-components=1 \
        && rm dokuwiki.tgz

    if [[ "${DOKU_DOCKER_COMBO_ENABLE}" != "false" ]]; then

      echo "Installing Sqlite Plugin ..."
      wget https://github.com/cosmocode/sqlite/archive/refs/heads/master.zip -O sqlite.zip \
        && unzip -q sqlite.zip -d lib/plugins && mv lib/plugins/sqlite-master lib/plugins/sqlite \
        && rm sqlite.zip

      echo "Installing Combo Plugin ..."
      wget https://github.com/ComboStrap/combo/archive/refs/heads/main.zip -O combo.zip \
        && unzip -q combo.zip -d lib/plugins && mv lib/plugins/combo-main lib/plugins/combo \
        && rm combo.zip

    else

      echo "Combo Plugin not enabled, skipping installation"

    fi

    echo "#####################################################"
    echo "# Go to the installer to configure your new wiki"
    echo "# See doc at https://www.dokuwiki.org/installer"
    echo "# The installer page is located at: http(s)://dokuwiki-docker-domain/install.php"
    echo "#####################################################"

fi

# Copy dokuwiki health and configuration
DOKUWIKI_DOCKER_VERSION_FILE=dokuwiki-docker-version
if [[ ! -f $DOKUWIKI_DOCKER_VERSION_FILE ]] || [ "$(cat $DOKUWIKI_DOCKER_VERSION_FILE)" -ne 1 ]; then

    echo "Copying conf and health dokuwiki files"
    cp -r -f /var/www/dokuwiki/* .

fi

################
# Start
################
# https://github.com/docker-library/php/blob/master/8.3/bookworm/fpm/docker-php-entrypoint
# Exec permits to respond to ctrl+c key and terminate the running process.
exec docker-php-entrypoint "$@"
