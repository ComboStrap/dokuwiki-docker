# Dev Contribution


## How to develop the Docker image

* Change the [Dockerfile](../Dockerfile)
* [Build](../build)
```bash
/build.sh
```
* [Push](../push) if satisfied
```bash
./push.sh
```


## How to develop the bash scripts and configuration


```bash
cd ~/code/dokuwiki-docker
```
* Use the [last build](../build) as some script need Dokuwiki scripts
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
start
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
