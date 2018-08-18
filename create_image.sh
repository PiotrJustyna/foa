#!/bin/sh

docker build --build-arg https_proxy=$HTTP_PROXY --build-arg http_proxy=$HTTP_PROXY --build-arg HTTP_PROXY=$HTTP_PROXY --build-arg HTTPS_PROXY=$HTTP_PROXY --build-arg NO_PROXY=$NO_PROXY --build-arg no_proxy=$NO_PROXY -t build_foa --file=alpine/build/dockerfile .
docker run -e http_proxy=$HTTP_PROXY -e https_proxy=$HTTP_PROXY -e HTTP_PROXY=$HTTP_PROXY -e HTTPS_PROXY=$HTTP_PROXY -e NO_PROXY=$NO_PROXY -e no_proxy=$NO_PROXY --rm --volume="$PWD/alpine/run/artifacts:/artifacts" build_foa
docker build -t foa alpine/run/
#sudo docker run -p 3000:3000 --volume="$PWD/ssl:/etc/ssl/certs" --log-driver=syslog foa