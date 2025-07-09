#!/bin/bash

# https://thingsboard.io/docs/user-guide/install/docker/

sudo docker-compose run --rm -e INSTALL_TB=true -e LOAD_DEMO=true thingsboard-ce

sudo docker-compose up -d
