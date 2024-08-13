<?php
/**
 * https://raw.githubusercontent.com/dokuwiki/docker/main/root/var/www/html/.autoprepend.php
 * This file is automatically loaded by PHP before any other code. See dokuwiki.ini `auto-prepend` conf
 * This ensures that DOKU_INC is is always pointing to the correct location within the container,
 * even when the entry point is a plugin.
 */
if (!defined('DOKU_INC')) define('DOKU_INC', __DIR__ . '/dokuwiki/');
