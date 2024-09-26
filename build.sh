#!/usr/bin/env bash
# Exit immediately if a command exits with a non-zero status
set -Eeuo pipefail


# Dokuwiki Version + our version
# VERSION=php8.3-v1
VERSION=php8.3-latest

# Build or exit
docker build . --progress=plain -t ghcr.io/combostrap/dokuwiki:"$VERSION" # || exit 1


# Run. See README
# Otherwise for combo dev
# docker run --name dokuwiki --rm -p 8080:80 -e DOKU_DOCKER_ENV=dev -v 'c:\dokuwiki':/var/www/html ghcr.io/combostrap/dokuwiki:php8.3-last
# docker run --name dokuwiki -it --rm ghcr.io/combostrap/dokuwiki:php8.3-latest bash

# Push
# docker push ghcr.io/combostrap/dokuwiki:php8.3-latest
