#!/bin/bash

#gerrit-cache-volume/
rm -rf /var/lib/docker/volumes/gerritalp_gerrit-cache-volume/_data/*

#gerrit-db-volume
rm -rf /var/lib/docker/volumes/gerritalp_gerrit-db-volume/_data/*

#gerritalp_gerrit-etc-volume/
#rm -rf /var/lib/docker/volumes/gerritalp_gerrit-etc-volume/_data/mail
#rm -rf 

#gerritalp_gerrit-git-volume/
rm -rf /var/lib/docker/volumes/gerritalp_gerrit-git-volume/_data/*

#gerritalp_gerrit-index-volume/
rm -rf /var/lib/docker/volumes/gerritalp_gerrit-index-volume/_data/*

