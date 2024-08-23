# Dev Contribution


## How to develop the Docker image

* Change the [Dockerfile](../Dockerfile)
* [Build](../build.sh)
```bash
/build.sh
```
* [Push](../push.sh) if satisfied
```bash
./push.sh
```

## How to develop the bash scripts

* Use the [last build](../build.sh) as some script need Dokuwiki scripts
```bash
/build.sh
```
* Give execution permissions on your desktop to the scripts
```bash
chmod +755 resources/dokuwiki-docker/bin/*
chmod +755 resources/dokuwiki-installer/bin/*
chmod +755 resources/phpctl/bin/*
chmod +755 resources/dokuctl/bin/*
```
* Then run:
```bash
docker run \
  --name dd \
  --rm \
  -p 8081:80 \
  --user 1000:1000 \
  -e DOKU_DOCKER_STRICT=true \
  -e DOKU_DOCKER_ENV=dev \
  -e DOKU_DOCKER_STARTER_SITE=false \
  -v $PWD/resources/dokuwiki-docker:/opt/dokuwiki-docker \
  -v $PWD/resources/dokuwiki-installer:/opt/dokuwiki-installer \
  -v $PWD/resources/comboctl:/opt/comboctl \
  -v $PWD/resources/phpctl:/opt/phpctl \
  ghcr.io/combostrap/dokuwiki:php8.3-latest
```
* All scripts run with the above command are from your desktop.
* Change them, re-run.
