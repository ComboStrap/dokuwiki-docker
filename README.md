# Dokuwiki in Docker


## About
This repository contains `Dokuwiki in Docker` images.

## Run

Mount a [volume](#volume-content) at `/var/www/html`

* Linux
```bash
docker run \
  --name dokuwiki \
  --rm \
  -p 8080:80 \
  -v /tmp/doku/:var/www/html \
  ghcr.io/combostrap/dokuwiki:2024-02-06b-php8.3-v1
```
* Cygwin
```bash
docker run \
  --name dokuwiki \
  --rm \
  -p 8080:80 \
  -v 'c:\temp\dokuwiki':/var/www/html \
  ghcr.io/combostrap/dokuwiki:2024-02-06b-php8.3-v1
```


## Tag

### Syntax

A tag has the syntax
```bash
phpX.X-fpm-vX
# example
php8.3-fpm-v1
```
where:
  * `phpX.X-fpm` is the base php version used
  * `vX` is the version of this image
  
Dokuwiki is installed if not found on the volume. 
See [how to choose the installed dokuwiki version](#choose-the-installed-version)

### Components

All image contains:
* php-fpm and opcache for performance
* caddy as webserver

### Tag List

  * [2024-02-06b-php8.3-v1](Dockerfile) - [Kaos version](https://www.dokuwiki.org/changes#release_2024-02-06a_kaos) with php 8.3


## Configuration

### Disable Automatic Combo Installation

By default, this image will [install the Combo plugin](https://combostrap.com/get-started/how-to-install-combo-zzjmtimy) automatically. 
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

## How to

### Choose the installed version

You can choose the initial [version](https://github.com/ComboStrap/dokuwiki-docker/pkgs/container/dokuwiki/versions) 
to install via the `DOKUWIKI_VERSION` environment.

Example:
```bash
docker run \
  --name dokuwiki \
  --rm \
  -p 8080:80 \
  -e DOKUWIKI_VERSION=2024-02-06b \
  -v 'c:\temp\dokuwiki':/var/www/html \
  ghcr.io/combostrap/dokuwiki:2024-02-06b-php8.3-v1
```

### Check if alive (health)

`php-fpm` has a [configuration](resources/php-fpm/www.conf) `ping.path` set to `/ping`.
The response is given by the configuration `ping.response`.

Example: `http://localhost/php-fpm/ping`

### Monitor with Status

`php-fpm` has a [configuration](resources/php-fpm/www.conf) `pm.status_path` set to `/status`.

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

For the documentation over the data and usage, see the [configuration file](resources/php-fpm/www.conf)

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

## Other related projects

* [Official DockWiki Docker Image](https://github.com/dokuwiki/docker)