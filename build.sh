#!/usr/bin/bash
if [ $1 ]; then
		docker build $(dirname $0) -t $1
	else
		docker build $(dirname $0) -t sleechengn/open-webui:latest
fi
