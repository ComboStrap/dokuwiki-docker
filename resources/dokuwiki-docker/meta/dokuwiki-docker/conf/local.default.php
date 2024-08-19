<?php
/**
 * Default Values
 */

/**
 * The docker instance generally run behind a proxy
 * that serves the certificate in http mode
 * When generating the sitemap, if the base url is not
 * set, the sitemap will generate http url
 * The base url needs to be set
 * https://www.dokuwiki.org/config:baseurl
 * Example: https://www.yourserver.com:port
 */
$baseUrl = getenv('DOKU_DOCKER_BASE_URL');
if ($baseUrl !== false) {
    $conf['baseurl'] = $baseUrl;
}
