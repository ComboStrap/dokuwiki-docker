# Dokuwiki in Docker


## About
This repository contains `Dokuwiki in Docker` images.

## Run

Choose:
* a [tag](https://github.com/ComboStrap/dokuwiki-docker/pkgs/container/dokuwiki/versions) 
* and mount a volume at `/var/www/html`

```bash
docker run \
  --name dokuwiki \
  --v /var/www/html \
  ghcr.io/combostrap/dokuwiki:2024-02-06b-php8.3-v1
```

## Tag

### Syntax

A tag has the syntax
```bash
YYYY-MM-DDx-phpX.X-vX
# example
2024-02-06b-php8.3-v1
```
where:
  * `YYYY-MM-DDx` is the [dokuwiki version](https://download.dokuwiki.org/archive)
  * `phpX.X` is the php version
  * `vX` is the version of this image

### Components

All image contains:
* php-fpm and opcache for performance
* caddy as webserver

### Tag List

  * [2024-02-06b-php8.3-v1](Dockerfiles/2024-02-06/Dockerfile) - [Kaos version](https://www.dokuwiki.org/changes#release_2024-02-06a_kaos) with php 8.3


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

### Check if alive (health)

`php-fpm` has a [configuration](Dockerfiles/2024-02-06/resources/php-fpm/www.conf) `ping.path` set to `/ping`.
The response is given by the configuration `ping.response`.

Example: `http://localhost/php-fpm/ping`

### Monitor with Status

`php-fpm` has a [configuration](Dockerfiles/2024-02-06/resources/php-fpm/www.conf) `pm.status_path` set to `/status`.

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

For the documentation over the data and usage, see the [configuration file](Dockerfiles/2024-02-06/resources/php-fpm/www.conf)
