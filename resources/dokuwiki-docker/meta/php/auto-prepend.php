<?php
/**
 * https://raw.githubusercontent.com/dokuwiki/docker/main/root/var/www/html/.autoprepend.php
 * This file is automatically loaded by PHP before any other code. See dokuwiki.ini `auto-prepend` conf
 * This ensures that DOKU_INC is is always pointing to the correct location within the container,
 * even when the entry point is a plugin.
 */

$DOKUWIKI_HOME = getenv('DOKUWIKI_HOME');
if($DOKUWIKI_HOME === false){
    echo "DOKUWIKI_HOME env variable should be set.\n";
    exit(1);
}
if (!defined('DOKU_INC')) define('DOKU_INC', "$DOKUWIKI_HOME/");
