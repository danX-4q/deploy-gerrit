#!/bin/bash

VPrefix=$(basename $(pwd))

ls /var/lib/docker/volumes/ | grep -iE "^${VPrefix}" | xargs -I{} docker volume rm {}

