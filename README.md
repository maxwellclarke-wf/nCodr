# nCodr
Docker-based ffmpeg mkv -> mp4 transcoder for Synology DiskStation
ffmpeg based on https://github.com/jrottenberg/ffmpeg

#### Build
`make build`

Pull down the latest built machines from:
* https://hub.docker.com/r/emcee/encodr
* https://hub.docker.com/r/emcee/ffmpeg

#### Run

** Synology **
You must supply two volumes on each machine, `/encodeIn` and `/encodeOut`.

The easiest way to get started (and there's probably a better way): 
* export containers that already exist to json in `DSM`
* push the image to hub: `make build && docker push emcee/<image>`
* Update the image in DSM
* Import exported container json

#### Last you were doing...
* Scripts lying about are in the process of being converted to Makefile.
* Create actual tests instead of a test method to run

#### Improvements for the future
* Dart:
  * Generalize Dart container rules
  * Pass files instead of commands
  * Change communication from encode.sh to http request
* Make process:
  * include pushing to repos
  * Generate .json config and uploading it to Synology somehow


