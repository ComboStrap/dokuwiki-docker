# Dev


## How to develop the scripts

We need a Dokuwiki Env, therefore the best way is to use the created
`dokuwiki docker` image 

```bash
docker run \
  --name site-com-combostrap \
  --rm \
  -p 8081:80 \
  --user 1000:1000 \
  -e DOKU_DOCKER_ENV=dev \
  -e DOKU_DOCKER_ACL_POLICY='public' \
  -e DOKU_DOCKER_ADMIN_NAME='admin' \
  -e DOKU_DOCKER_ADMIN_PASSWORD='welcome' \
  -v $PWD/resources/dokuwiki-docker:/opt/dokuwiki-docker \
  -v $PWD/resources/dokuwiki-installer:/opt/dokuwiki-installer \
  ghcr.io/combostrap/dokuwiki:php8.3-latest
```
