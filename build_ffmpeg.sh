#!/usr/bin/env bash

docker-machine start default &&
eval "$(docker-machine env default)" &&
cd ffmpeg_container &&
docker build -t emcee/ffmpeg . &&
cd ..
