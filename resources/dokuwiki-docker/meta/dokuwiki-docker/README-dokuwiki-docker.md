# Dokuwiki Docker


The directory `dokuwiki-docker`:
* contains artifacts (scripts, ...)
* is copied into the dokuwiki installation directory at `dokuwiki-home\dokuwiki-docker`

## Layout
* [dokuwiki-docker/dokuwiki](dokuwiki) - This subdirectory contains artifacts (scripts, ...)
that are copied into the dokuwiki installation directory.

## New Version
For each new [version](dokuwiki-docker-version), all files are overwritten.

Why? Because the volume contains a whole DokuWiki installation.
