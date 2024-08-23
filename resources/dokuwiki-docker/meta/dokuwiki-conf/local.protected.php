<?php
/**
 * https://github.com/dokuwiki/docker/blob/main/root/var/www/html/conf/docker.protected.php
 * settings that should not be overwritten in the docker environment
 */

/**
 * ACL is mandatory
 * It's a backward compatibility conf
 * https://www.dokuwiki.org/config:useacl
 */
$conf['useacl'] = 1;

/**
 * URL rewrite is on
 * https://www.dokuwiki.org/config:im_convert
 */
$conf['userewrite'] = 1;
// `use slash` is needed with user rewrite
$conf['useslash'] = 1;

/**
 * Gd
 * https://www.dokuwiki.org/config:im_convert
 */
$conf['im_convert'] = '/usr/bin/convert';
