#!/usr/bin/env bash

echo '********************RUNNING START**************************'
echo ' Waiting for file mount...'
sleep 5

while :
do
	FFMPEG_COMMANDS=''
	IN=`cat /encodeOut/.encodr`
	while IFS=$'\n' read -ra ADDR; do
		#SAVE_IFS="$IFS"
		for i in "$ADDR"; do
			echo "data: $IN"
			echo "row: $i"
			echo "save_ifs: \"$SAVE_IFS\""
			IFS=':' read -r inputFile outputFile <<< "$i"
			echo "in: $inputFile"
			echo "out: $outputFile"
			FFMPEG_COMMANDS=$"${FFMPEG_COMMANDS} ffmpeg -n -i '$inputFile' -vcodec copy -acodec copy '$outputFile';"
      	done
		#IFS="$SAVE_IFS"
	done <<< "$IN"
	unset IN
	echo 'sleeping 30 seconds...'
	echo "$FFMPEG_COMMANDS"
	(eval $FFMPEG_COMMANDS)
	sleep 30
done