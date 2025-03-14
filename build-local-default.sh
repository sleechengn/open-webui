#!/usr/bin/bash
set -e

export DOCKER_BUILDKIT=1

TGT_PRX=/opt/tmp
TGT_DIR=$TGT_PRX/open-webui-build
rm -rf $TGT_DIR && mkdir -p $TGT_PRX
/usr/bin/cp -ra $(dirname $0) $TGT_DIR

pushd $TGT_DIR
echo current $TGT_DIR
rm -rf .git
sed -i '1i\# syntax=docker/dockerfile:1.3' Dockerfile
./build.sh 192.168.13.73:5000/sleechengn/open-webui:latest
popd
rm -rf $TGT_DIR
docker push 192.168.13.73:5000/sleechengn/open-webui:latest
