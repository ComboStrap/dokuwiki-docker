<?php
// File created by Dokuwiki Docker


// load the standard cascade
if (!defined('DOKU_CONF')) {
    define('DOKU_CONF', __DIR__ . '/../conf/');
}
if (!isset($config_cascade) || $config_cascade === []) {
    include __DIR__ . '/config_cascade.php';
}

// Adjust config_cascade
// Add a set of default
$config_cascade['main']['default'][] = '/opt/dokuwiki-docker/meta/dokuwiki-conf/local.default.php';
// Set the protected
array_unshift($config_cascade['main']['protected'], '/opt/dokuwiki-docker/meta/dokuwiki-conf/local.protected.php');
