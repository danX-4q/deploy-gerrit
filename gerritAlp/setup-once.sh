#!/bin/bash

function step_2 {
	sed docker-compose.yaml -e 's/^#init\(    entrypoint.*\)$/\1/g' > docker-compose--setup-only.yaml
	docker-compose -f docker-compose--setup-only.yaml up gerrit && rm -rf docker-compose--setup-only.yaml
	./modify-gerrit-conf.sh

	#激动，终于试出，两次初始化，将数据库由h2迁移到postgres的效果
	./delete-gerrit-data.sh
	sed docker-compose.yaml -e 's/^#init\(    entrypoint.*\)$/\1/g' > docker-compose--setup-only.yaml
        docker-compose -f docker-compose--setup-only.yaml up gerrit && rm -rf docker-compose--setup-only.yaml
}

function step_1 {
	docker-compose up -d postgres
	while true
	do
		docker-compose logs --tail=5 postgres | grep "database system is ready to accept connections" -q && break
		sleep 1
	done
	echo "postgres ready for connections."

}

function step_3 {	
	docker-compose up -d
}

step_1
step_2
step_3

echo "$0 said: setup over, and already docker-compose up"

