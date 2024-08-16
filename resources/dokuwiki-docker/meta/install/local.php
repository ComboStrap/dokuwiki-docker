<?php
/**
 * Dokuwiki's Main Configuration File - Local Settings
 * Created by Dokuwiki Docker
 * https://combostrap.com/admin/dokuwiki-docker-9iq3aso8
 */
$conf['title'] = 'Default';
$conf['lang'] = 'en';
$conf['license'] = 'cc-by-sa';
// mandatory (even in readonly)
$conf['useacl'] = 1;
$conf['disableactions'] = 'register';
$conf['superuser'] = '@admin';
// Sane Default
// The level 2 is the top of TOC rendering
// https://www.dokuwiki.org/config:toptoclevel
$conf['toptoclevel'] = 2;
// Number of heading for rendering
// https://www.dokuwiki.org/config:tocminheads
$conf['tocminheads'] = 1;
// Maximum section editing level
// https://www.dokuwiki.org/config:maxseclevel
$conf['maxseclevel'] = 4;
// https://www.dokuwiki.org/config:useheading
$conf['useheading'] = 1;
