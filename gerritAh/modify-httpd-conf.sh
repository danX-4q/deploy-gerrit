#!/bin/bash

TARGE_DIR=/var/lib/docker/volumes/gerritah_httpd-conf-volume/_data/
SRC_DIR=./support-files--httpd/

cp ${SRC_DIR}httpd.conf ${SRC_DIR}httpd.password ${TARGE_DIR}
cp ${SRC_DIR}httpd-vhosts.conf ${TARGE_DIR}extra/

