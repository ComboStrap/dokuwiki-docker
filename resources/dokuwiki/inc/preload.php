<?php

// load the standard cascade
if (!defined('DOKU_CONF')) {
    define('DOKU_CONF', __DIR__ . '/../conf/');
}
if (!isset($config_cascade) || $config_cascade === []) {
    include __DIR__ . '/config_cascade.php';
}

// adjust the previously set config_cascade
$config_cascade['main']['default'][] = '/var/www/html/conf/dokuwiki-docker.php';
array_unshift($config_cascade['main']['protected'], '/var/www/html/conf/dokuwiki-docker.protected.php');
