#!/bin/sh

# preparing files
rm -rf foa
rm -rf ./alpine/run/artifacts
cp -r ../foa foa

docker build -t build_foa --file=./alpine/build/dockerfile .
docker run --rm --volume="$PWD/alpine/run/artifacts:/artifacts" build_foa
docker build -t foa alpine/run/
# not running in detached mode for easier debugging
docker run -p 3000:3000 --volume="$PWD/../ssl:/etc/ssl/certs" foa