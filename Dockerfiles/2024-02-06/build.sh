#!/usr/bin/env bash
# Exit immediately if a command exits with a non-zero status
set -e


# Dokuwiki Version + our version
VERSION=2024-02-06b-php8.3-v1

# Build or exit
docker build . -t combo/dokuwiki:"$VERSION" # || exit 1

# Run
# docker run --name dokuwiki -p 8080:80 --rm combo/dokuwiki:2024-02-06b-php8.3-v1

# Push
# docker push gerardnico/dokuwiki:"$VERSION"
# docker push gerardnico/dokuwiki:2024-02-06b-v1
