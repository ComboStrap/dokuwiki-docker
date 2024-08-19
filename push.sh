#!/usr/bin/env bash
# Exit immediately if a command exits with a non-zero status
set -Eeuo pipefail


# Dokuwiki Version + our version
# VERSION=php8.3-v1
VERSION=php8.3-latest

# Push
docker push ghcr.io/combostrap/dokuwiki:"$VERSION"