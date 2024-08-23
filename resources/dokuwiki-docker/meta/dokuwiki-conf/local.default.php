<?php
/**
 * Default Values
 */


/**
 * Enable sitemap
 */
$conf['sitemap'] = 5;

/**
 * Note if we want to allow setting Dokuwiki Conf, we should do the following
 *
 *  $conf['baseurl'] = $_SERVER['DOKU_DOCKER_BASE_URL'] ?? '';
 *
 * the syntax was taken from here
 * https://forum.dokuwiki.org/d/19800-use-environment-variables-for-configuration-in-localphp
 * but there is no env due to the config
 * https://www.php.net/manual/en/ini.core.php#ini.variables-order
 * we use the SERVER variable
 */


