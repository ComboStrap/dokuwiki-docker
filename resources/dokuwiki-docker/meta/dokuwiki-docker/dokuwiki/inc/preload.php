<?php

// load the standard cascade
if (!defined('DOKU_CONF')) {
    define('DOKU_CONF', __DIR__ . '/../conf/');
}
if (!isset($config_cascade) || $config_cascade === []) {
    include __DIR__ . '/config_cascade.php';
}

// Adjust config_cascade
// Add a set of default
$config_cascade['main']['default'][] = __DIR__ . '/../dokuwiki-docker/conf/local.default.php';
// Set the protected
array_unshift($config_cascade['main']['protected'], __DIR__ . '/../dokuwiki-docker/conf/local.protected.php');
