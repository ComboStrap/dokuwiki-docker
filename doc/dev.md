# Dev


## How to develop the scripts

We need a Dokuwiki Env, therefore the best way is to use the created
`dokuwiki docker` image 

```bash
/build.sh

chmod +755 resources/dokuwiki-docker/bin/*
chmod +755 resources/dokuwiki-installer/bin/*
chmod +755 resources/phpctl/bin/*
chmod +755 resources/dokuctl/bin/*

docker run \
  --name dd \
  --rm \
  -p 8081:80 \
  --user 1000:1000 \
  -e DOKU_DOCKER_STRICT=true \
  -e DOKU_DOCKER_ENV=dev \
  -v $PWD/resources/dokuwiki-docker:/opt/dokuwiki-docker \
  -v $PWD/resources/dokuwiki-installer:/opt/dokuwiki-installer \
  -v $PWD/resources/dokuctl:/opt/dokuctl \
  -v $PWD/resources/phpctl:/opt/phpctl \
  ghcr.io/combostrap/dokuwiki:php8.3-latest
```
