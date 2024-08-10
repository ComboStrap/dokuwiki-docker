# Dokuwiki in Docker


## About
This repository contains ready [Dokuwiki](https://dokuwiki.org) in Docker images 
with ComboStrap and related plugins pre-installed (optional)


Get a ComboStrap dokuwiki based installation in a single line of command.

Example: Linux/Cygwin
```bash
docker run \
  --name dokuwiki \
  --rm \
  -p 8080:80 \
  ghcr.io/combostrap/dokuwiki:php8.3-v1
```

On a desktop, you could now configure the wiki at http://localhost:8080/install.php

## Features

You got out of the box:
* [nice URL rewrite ](https://www.dokuwiki.org/rewrite)
* Php Fpm and OpCache
* the combo plugin (You can [disable it](#disable-automatic-combo-installation))

## Docker Volume Parameter

The important run parameter is the [volume](#volume-content) to keep
your data between restart.

Note: If the [volume](#volume-content) is empty, after the run, it will be filled
with a new dokuwiki installation. 
You need to use the [DokuWiki's installer](https://www.dokuwiki.org/installer) to configure it.

Example:
* Linux / Windows WSL
```bash
cd ~/your-site
docker run \
  --name combo \
  --rm \
  -p 8080:80 \
  -v $PWD:/var/www/html \
  ghcr.io/combostrap/dokuwiki:php8.3-v1
```
* On Windows, don't bind mount a local directory as volume. See [perf](#poor-windows-perf-with-local-directory-volume-)

On a desktop:
* Dokuwiki would be available at: http://localhost:8080
* and the installer at: http://localhost:8080/install.php


## How to

### Choose the installed dokuwiki version

You can choose the initial [version](https://github.com/dokuwiki/dokuwiki/releases) 
to install via the `DOKUWIKI_VERSION` environment.

Example with the [2024-02-06b "Kaos" release](https://github.com/dokuwiki/dokuwiki/releases/tag/release-2024-02-06b)
```bash
docker run \
  --name dokuwiki \
  --rm \
  -p 8080:80 \
  -e DOKUWIKI_VERSION=2024-02-06b \
  -v $PWD:/var/www/html \
  ghcr.io/combostrap/dokuwiki:php8.3-v1
```

### Check if php-fpm is alive (health)

`php-fpm` has a [configuration](resources/conf/php-fpm/www.conf) `ping.path` set to `/ping`.
The response is given by the configuration `ping.response`.

Example: `http://localhost/php-fpm/ping`

### Check if dokuwiki is alive (health)


Example: `http://localhost/health.php`

### Monitor php-fpm with status

`php-fpm` has a [configuration](resources/conf/php-fpm/www.conf) `pm.status_path` set to `/status`.

Note the status endpoint is available only from localhost (ie ip 127.0.0.1)
therefore you need to run it via `docker exec`

Example: 
```bash
docker exec -ti dokuwiki curl localhost/php-fpm/status?full
```
```
pool:                 www
process manager:      dynamic
start time:           07/Aug/2024:14:04:53 +0000
start since:          173
accepted conn:        21
listen queue:         0
max listen queue:     0
listen queue len:     4096
idle processes:       1
request method:       GET
request URI:          /php-fpm/status?full
content length:       0
user:                 -
script:               /var/www/html
last request cpu:     0.00
last request memory:  0
```

For the documentation over the data and usage, see the [configuration file](resources/conf/php-fpm/www.conf)

### Disable Automatic Combo Installation

By default, this image will [install the Combo plugin](https://combostrap.com/get-started/how-to-install-combo-zzjmtimy)
automatically.

To disable this behavior, you need to set the `DOKU_DOCKER_COMBO_ENABLE` environment variable.

```bash
docker run -e DOKU_DOCKER_COMBO_ENABLE=false
```

### Set in dev mode

By default, this image will run php in production mode.
You can set it in dev mode via the `DOKU_DOCKER_ENV`

```bash
docker run -e DOKU_DOCKER_ENV=dev
```

## Volume Content

The volume contains a whole dokuwiki installation.

Why? We do not use symlink as [the official image](https://github.com/dokuwiki/docker/blob/main/root/build-setup.sh#L29)
to keep backup data as specified in the [backup](https://www.dokuwiki.org/faq:backup)
because it's too damn hard to keep the state of an installation.
* Plugins does not use a version/release system.
* You then need to back up the `lib` directory that contains the most code.
* Configuration file may be located into plugin/template (ie style.ini)
* Identification file are co-located with configuration file in the `conf` directory.
* Runtime data are mixed with persistent data into the `data` directory (ie cache/index/tmp)

If you want to keep the size low, you need to perform cleanup administrative task.


## Tag

### Syntax

A tag has the syntax
```bash
phpX.X-vX
# example
php8.3-v1
```
where:
* `phpX.X` is the php version used
* `vX` is the version of this image

Dokuwiki is installed if not found on the volume.
See [how to choose the installed dokuwiki version](#choose-the-installed-dokuwiki-version)

### Components

All image contains:
* php-fpm and opcache for performance
* caddy as webserver

### Tag List

* [php8.3-v1](Dockerfile) - [Kaos version](https://www.dokuwiki.org/changes#release_2024-02-06a_kaos) with php 8.3


## Support
### Poor Windows Perf with Local Directory Volume 

On Windows, you should not mount a windows host local directory
because it will be fucking slow.

ie don't do that
```dos
docker run ^
  -v c:\home\username\your-site:/var/www/html ^
  ghcr.io/combostrap/dokuwiki:php8.3-v1
```

Mounting a Windows folder into a Docker container is always slow no matter how you do it.
WSL2 is even slower than WSL1 in that respect.

See the [related issue](https://github.com/docker/for-win/issues/6742) that explains that this is structural.

The solution is buried into the [Docker WSL best practice](https://docs.docker.com/desktop/wsl/best-practices/)
```
It's recommended that you store source code and other data that is bind-mounted into Linux containers.
``` 

You should then:
* move the site data into the WSL Distro
* and from a Linux shell run:
```bash
docker run \
  -v ~\your-site:/var/www/html \
  ghcr.io/combostrap/dokuwiki:php8.3-v1
```


## Other related projects

* [Official DockWiki Docker Image](https://github.com/dokuwiki/docker)