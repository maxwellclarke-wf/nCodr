#!/usr/bin/env bash


docker-machine start default &&
eval "$(docker-machine env default)" &&
docker rm encodr
docker run -it \
--name encodr \
--volumes-from encodr \
-v /Users/maxwellclarke/workspaces/platform/nCoder/test/test_files/input_files:/encodeIn \
-v /Users/maxwellclarke/workspaces/platform/nCoder/test/test_files/output_files:/encodeOut \
emcee/encodr
#ffmpeg -i $inputFile -vcodec copy -acodec copy $outputdir`basename $inputFile ".$extension"`