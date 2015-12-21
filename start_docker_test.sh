#!/usr/bin/env bash

docker-machine start default &&
eval "$(docker-machine env default)" &&
docker build -t my/app . &&
#docker run -it --entrypoint='bash'
echo "build done, now for the play stuff"
docker run -d my/app