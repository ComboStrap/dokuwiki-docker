# Dokuwiki Docker Installaer

The [dokuwiki-installer](bin/dokuwiki-installer)
implements the [installer](https://www.dokuwiki.org/installer) but
at the command line.



## List
* [local.php](meta/local.php) - the default configuration file if not present
* [readonly](meta/readonly) - the files for a readonly installation
* [public](meta/public) - the files for a public installation (publicly readable with one admin user)


## Note

`ACL` should be enabled otherwise the files are publicly editable
https://www.dokuwiki.org/config:useacl