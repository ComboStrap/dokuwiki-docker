<?php

# Create the user.auth.php file
# Parameters: username password
error_reporting(E_ERROR);

if (!defined('DOKU_INC')) define('DOKU_INC', __DIR__ . '/../../');
require_once(DOKU_INC . 'inc/init.php');

use dokuwiki\PassHash;

$user = $argv[0];
$password = $argv[1];
echo "$password\n";
// hash the password
$phash = new PassHash();
$pass = $phash->hash_bcrypt($password);

echo "$pass\n";
