from ghcr.io/open-webui/open-webui:main
run apt update

run apt install -y nginx curl
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


WORKDIR /app/backend

copy ./docker-entrypoint.sh /
run chmod +x /docker-entrypoint.sh
cmd []
entrypoint ["/docker-entrypoint.sh"]
