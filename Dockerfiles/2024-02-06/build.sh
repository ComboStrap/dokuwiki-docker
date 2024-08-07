#!/usr/bin/env bash
# Exit immediately if a command exits with a non-zero status
set -e


# Dokuwiki Version + our version
VERSION=2024-02-06b-php8.3-v1

# Build or exit
docker build . -t ghcr.io/combostrap/dokuwiki:"$VERSION" # || exit 1


# Run
# docker run --name dokuwiki -p 8080:80 --rm ghcr.io/combostrap/dokuwiki:2024-02-06b-php8.3-v1

# Push
# docker push ghcr.io/combostrap/dokuwiki:2024-02-06b-php8.3-v1
