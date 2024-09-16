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


## How to develop the bash scripts and configuration


```bash
cd ~/code/dokuwiki-docker
```
* Use the [last build](../build.sh) as some script need Dokuwiki scripts
```bash
./build.sh
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
  -p 8085:80 \
  --user 1000:1000 \
  -e DOKU_DOCKER_STRICT=true \
  -e DOKU_DOCKER_ENV=dev \
  -e DOKU_DOCKER_STARTER_SITE=false \
  -e DOKU_DOCKER_ACL_POLICY='public' \
  -e DOKU_DOCKER_ADMIN_NAME='admin' \
  -e DOKU_DOCKER_ADMIN_PASSWORD='welcome' \
  -v $PWD/resources/dokuwiki-docker:/opt/dokuwiki-docker \
  -v $PWD/resources/dokuwiki-installer:/opt/dokuwiki-installer \
  -v $PWD/resources/comboctl:/opt/comboctl \
  -v $PWD/resources/phpctl:/opt/phpctl \
  -v $PWD/resources/conf/bash/bash.bashrc:/etc/bash.bashrc \
  -v $PWD/resources/conf/caddy/Caddyfile:/etc/caddy/Caddyfile \
  ghcr.io/combostrap/dokuwiki:php8.3-latest
```
* Then connect with bash
```bash
docker exec -ti dd bash
```
* Change 
  * the scripts and rerun them
  * the configuration and reload them


### Caddy

```bash
caddy reload --config /etc/caddy/Caddyfile
```
