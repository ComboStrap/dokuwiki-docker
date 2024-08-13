<?php /** @noinspection PhpUndefinedNamespaceInspection */
/** @noinspection PhpUndefinedClassInspection */

/**
 * This script will create the file `conf/user.auth.php` file
 * that contains a list of users
 *
 * Syntax:
 * php users.auth.init.php username password email
 *
 * The code is based on https://github.com/dokuwiki/dokuwiki/blob/master/install.php
 * {@link store_data} function
 * We can't reuse the original function because it overwrite the files (ie local.php is overwritten)
 */

error_reporting(E_ERROR);

if (!defined('DOKU_INC')) define('DOKU_INC', '/var/www/html/');
if (!defined('DOKU_LOCAL')) define('DOKU_LOCAL', DOKU_INC . 'conf/');
require_once(DOKU_INC . 'inc/init.php');

/**
 * File should not exists
 */
$filePath = DOKU_LOCAL . 'users.auth.php';
if (file_exists($filePath)) {
    echo "User File ($filePath) already exists.\n";
    exit(1);
}

/**
 * Superuser data
 */
$username = $argv[1];
$password = $argv[2];
$email = $argv[3];
$realFullName = $username;
$groups = 'admin,user';

/**
 * Hash the password
 */
use dokuwiki\PassHash;

$phash = new PassHash();
try {
    $hashedPassword = $phash->hash_bcrypt($password);
} catch (Exception $e) {
    echo "Error while hashing the password.\n Code: {$e->getCode()}\nMessage: {$e->getMessage()}\n";
    exit(1);
}

/**
 * Create users.auth.php
 */
$now = gmdate('r');
$fileContent = <<<EOT
# users.auth.php
# <?php exit()?>
# Don't modify the lines above
#
# Userfile
#
# Auto-generated by Dokuwiki Docker script
# https://combostrap.com/admin/dokuwiki-docker-9iq3aso8
#
# Date: $now
#
# Format:
# login:passwordhash:Real Name:email:groups,comma,separated
EOT;

$fileContent = "$fileContent\n$username:$hashedPassword:$realFullName:$email:$groups\n";

$result = file_put_contents($filePath, $fileContent);

if (!$result) {
    echo "Error when creating the File ($filePath).\n";
    exit(1);
}

echo "Auth File ($filePath) saved.\n";
