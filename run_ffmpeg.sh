#!/usr/bin/env bash


docker-machine start default &&
eval "$(docker-machine env default)" &&
docker rm ffmpeg
docker run -it \
--name ffmpeg \
--volumes-from encodr \
-v /Users/maxwellclarke/workspaces/platform/nCoder/test/test_files/input_files:/encodeIn \
-v /Users/maxwellclarke/workspaces/platform/nCoder/test/test_files/output_files:/encodeOut \
emcee/ffmpeg
#ffmpeg -i $inputFile -vcodec copy -acodec copy $outputdir`basename $inputFile ".$extension"`