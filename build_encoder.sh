#!/usr/bin/env bash

docker-machine start default &&
eval "$(docker-machine env default)" &&
docker build -t emcee/encodr .
