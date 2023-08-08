#!/bin/bash

# Stop containers and remove images

docker compose down
docker volume rm $(docker volume ls -q)
docker rmi -f $(docker images -a -q)