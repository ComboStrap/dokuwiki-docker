#!/bin/bash
set -e

# Comes from https://github.com/docker-library/php/blob/master/8.3/bookworm/fpm/docker-php-entrypoint
# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

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
export PHP_FPM_LOG=${LOG_HOME}/php-fpm/php-fpm.log
export CADDY_LOG=${LOG_HOME}/caddy/caddy.log
LOGS=(
    "$PHP_FPM_LOG"
    "$CADDY_LOG"
)
for LOG in "${LOGS[@]}"; do
    LOG_PARENT=$(dirname "$LOG")
    mkdir -p "$LOG_PARENT"
    touch "$LOG"
done

#############
# Php Conf
#############
# Note: Theses default configs can be customized by copying configuration files into the $PHP_INI_DIR/conf.d/ directory.
if [[ ! -f "$PHP_INI_DIR/php.ini" ]] && [[ "${DOKU_DOCKER_ENV}" != "dev" ]]; then
  mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
else
  mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
fi


#############
# Php Fpm Conf
#############
export PHP_FPM_PM_START_SERVERS=${PHP_FPM_PM_START_SERVERS:-2}

#############
# Dokuwiki
#############
if [[ ! -f /var/www/html/doku.php ]]; then

    # Install is done by unarchiving, not downloading to avoid network problem, not copying to avoid a lot of IO
    # The location of the archive
    ARCHIVE_DIR=/var/www/dokuwiki

    # Installation
    echo "Dokuwiki not installed, installing ..."
    echo "Installing Dokuwiki ..."
    tar -xzf $ARCHIVE_DIR/dokuwiki.tgz --strip-components=1

    if [[ "${DOKU_DOCKER_COMBO_ENABLE}" != "false" ]]; then
      echo "Installing Sqlite Plugin ..."
      unzip $ARCHIVE_DIR/sqlite.zip -d lib/plugins && mv lib/plugins/sqlite-master lib/plugins/sqlite
      echo "Installing Combo Plugin ..."
      unzip $ARCHIVE_DIR/combo.zip -d lib/plugins && mv lib/plugins/combo-main lib/plugins/combo
    else
      echo "Combo Plugin not enabled, skipping installation"
    fi

fi

################
# Start
################
# Exec comes from https://github.com/docker-library/php/blob/master/8.3/bookworm/fpm/docker-php-entrypoint
# It permits to respond to ctrl+c key and terminate the running process.
exec "$@"
