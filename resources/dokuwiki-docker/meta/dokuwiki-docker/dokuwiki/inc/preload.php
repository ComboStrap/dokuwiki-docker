<?php

// load the standard cascade
if (!defined('DOKU_CONF')) {
    define('DOKU_CONF', __DIR__ . '/../conf/');
}
if (!isset($config_cascade) || $config_cascade === []) {
    include __DIR__ . '/config_cascade.php';
}

// Adjust the previously set config_cascade
$config_cascade['main']['default'][] = __DIR__ . '/../dokuwiki-docker/conf/local.default.php';
array_unshift($config_cascade['main']['protected'], __DIR__ . '/../dokuwiki-docker/conf/local.protected.php');
