# Dev Contribution


## How to develop the Docker image

* Change the [Dockerfile](../Dockerfile)
* Build
```bash
dockenv build
```
* Push if satisfied
```bash
dockenv push
```


## How to develop the bash scripts and configuration


```bash
cd ~/code/dokuwiki-docker
```
* Use the last build as some script need Dokuwiki scripts
```bash
dockenv build
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
dokuwiki-docker-run
```
* Then connect with bash
```bash
dockenv shell
```
* Change 
  * the scripts and rerun them
  * the configuration and reload them


### Caddy

```bash
caddy reload --config /etc/caddy/Caddyfile
```
