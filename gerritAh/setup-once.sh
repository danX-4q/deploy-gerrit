#!/bin/bash

function step_1 {
	sed docker-compose.yaml -e 's/^#\(    entrypoint.*\)$/\1/g' > docker-compose--setup-only.yaml
	docker-compose -f docker-compose--setup-only.yaml up gerrit && rm -rf docker-compose--setup-only.yaml
	./modify-gerrit-conf.sh
}

function step_2 {
	docker-compose -f docker-compose.yaml up -d httpd
	sleep 3
	docker-compose -f docker-compose.yaml stop httpd
	./modify-httpd-conf.sh
}

function step_3 {	
	docker-compose up -d
}


step_1
step_2
step_3

echo "$0 said: setup over, and already docker-compose up"

