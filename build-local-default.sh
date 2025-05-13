#!/usr/bin/bash
set -e

export DOCKER_BUILDKIT=1

TGT_PRX=/opt/tmp
TGT_DIR=$TGT_PRX/open-webui-build
rm -rf $TGT_DIR
cp -ra $(dirname $0) $TGT_DIR

pushd $TGT_DIR
echo $TGT_DIR


sed -i '/^#PIP_LOCAL.*/i\ENV PIP_TRUSTED_HOST=192.168.13.86' Dockerfile
sed -i '/^#PIP_LOCAL.*/i\ENV PIP_INDEX_URL=http://192.168.13.86:3141/root/pypi/' Dockerfile
sed -i '/^#PIP_LOCAL.*/i\ENV PIP_EXTRA_INDEX_URL=http://192.168.13.86:3141/root/cu128/' Dockerfile

sed -i '/^#UV_LOCAL.*/i\ENV UV_INSECURE_HOST=192.168.13.86' Dockerfile
sed -i '/^#UV_LOCAL.*/i\ENV UV_DEFAULT_INDEX=http://192.168.13.86:3141/root/pypi/' Dockerfile
sed -i '/^#UV_LOCAL.*/i\ENV UV_EXTRA_INDEX_URL=http://192.168.13.86:3141/root/cu128/' Dockerfile
sed -i '/^#UV_LOCAL.*/i\ENV UV_INDEX_STRATEGY=unsafe-best-match' Dockerfile

sed -i '1i\# syntax=docker/dockerfile:1.3' Dockerfile

sed -i "/^#APT_CN_UBUNTU_JAMMY.*/i\RUN apt update" Dockerfile
sed -i "/^#APT_CN_UBUNTU_JAMMY.*/i\RUN apt install -y ca-certificates" Dockerfile
sed -i '/^#APT_CN_UBUNTU_JAMMY.*/i\RUN mv /etc/apt/sources.list /etc/apt/sources.list.back' Dockerfile
sed -i '/^#APT_CN_UBUNTU_JAMMY.*/i\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '/^#APT_CN_UBUNTU_JAMMY.*/i\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '/^#APT_CN_UBUNTU_JAMMY.*/i\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '/^#APT_CN_UBUNTU_JAMMY.*/i\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '/^#APT_CN_UBUNTU_JAMMY.*/i\RUN apt update' Dockerfile

./build.sh 192.168.13.73:5000/sleechengn/open-webui:latest
popd
docker push 192.168.13.73:5000/sleechengn/open-webui:latest
