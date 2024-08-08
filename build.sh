#!/usr/bin/env bash
# Exit immediately if a command exits with a non-zero status
set -e


# Dokuwiki Version + our version
VERSION=php8.3-v1

# Build or exit
docker build . -t ghcr.io/combostrap/dokuwiki:"$VERSION" # || exit 1


# Run. See README
# Otherwise for combo dev
# docker run --name dokuwiki --rm -p 8080:80 -e DOKU_DOCKER_ENV=dev -v 'c:\dokuwiki':/var/www/html ghcr.io/combostrap/dokuwiki:php8.3-v1

# Push
# docker push ghcr.io/combostrap/dokuwiki:php8.3-v1
