from ubuntu:jammy

#APT_CN_UBUNTU_JAMMY
run apt update

run apt install -y nginx curl aria2
run curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
run mkdir /opt/filebrowser

run rm -rf /etc/nginx/sites-enabled/default
add ./NGINX /etc/nginx/sites-enabled/

run apt install -y wget \
	&& cd /opt \
	&& mkdir ttyd \
	&& cd ttyd \
	&& wget https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 \
	&& chmod +x ttyd.x86_64 \
	&& ln -s /opt/ttyd/ttyd.x86_64 /usr/bin/ttyd

run set -e \
        && mkdir /opt/uv \
        && cd /opt/uv \
        && aria2c -x 10 -j 10 -k 1M "https://github.com/astral-sh/uv/releases/download/0.6.14/uv-x86_64-unknown-linux-gnu.tar.gz" -o "uv.tar.gz" \
        && tar -zxvf uv.tar.gz \
        && rm -rf uv.tar.gz \
        && ln -s /opt/uv/uv-x86_64-unknown-linux-gnu/uv /usr/bin/uv \
        && ln -s /opt/uv/uv-x86_64-unknown-linux-gnu/uvx /usr/bin/uvx

#UV_LOCAL
#PIP_LOCAL
run set -e \
	&& uv venv /opt/venv --python 3.12 \
	&& . /opt/venv/bin/activate \
	&& uv pip install open-webui

run mkdir -p /app/backend/data

env DATA_DIR=/app/backend/data
workdir /app/backend/data
volume /app/backend/data

copy ./docker-entrypoint.sh /
run chmod +x /docker-entrypoint.sh
cmd []
entrypoint ["/docker-entrypoint.sh"]
