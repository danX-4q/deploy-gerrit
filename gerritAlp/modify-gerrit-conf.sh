#!/bin/bash

TARGE_FILE=/var/lib/docker/volumes/gerritalp_gerrit-etc-volume/_data/gerrit.config
TMPL_FILE=./support-files--gerrit/gerrit.config.tmpl

serverId=$(grep serverId ${TARGE_FILE} | 
gawk -F '=' '{print $2}' | 
sed s/[[:space:]]//g)

echo $serverId

sed -e "s|####serverId####|${serverId}|g" ${TMPL_FILE} > ${TARGE_FILE}

