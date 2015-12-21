#!/usr/bin/env bash

echo '********************RUNNING START**************************'

while :
do
  whoami
  pwd
  echo '******encode in******'
  ls /encodeIn
  echo '******encode out*****'
  ls /encodeOut
  touch /encodeIn/.encode_running
  bash /encodeOut/encodr.sh
  echo 'sleeping 30 seconds...'
  sleep 30
done

# Left to do:
# Fix build process by adding 'docker rm encodr ffmpeg'
# Make sure ffmpeg is reading from proper script and generating proper output