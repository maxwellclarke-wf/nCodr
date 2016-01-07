# nCodr
* Docker-based ffmpeg mkv -> mp4 transcoder for Synology DiskStation
* ffmpeg based on https://github.com/jrottenberg/ffmpeg
* Dropbox image for Synology based on CentOS

#### Build
`make build`

Pull down the latest built machines from:
* https://hub.docker.com/r/emcee/encodr
* https://hub.docker.com/r/emcee/ffmpeg

#### Run

** Synology : ffmpeg & nCodr **
You must supply two volumes on each machine, `/encodeIn` and `/encodeOut`.

The easiest way to get started (and there's probably a better way): 
* export containers that already exist to json in `DSM`
* push the image to hub: `make build && docker push emcee/<image>`
* Update the image in DSM
* Import exported container json

#### Last you were doing...
* You fixed the make file so it doesn't suck as much
* Separation of concerns between dart watcher and ffmpeg
* Create actual tests instead of a test method to run

#### Improvements/other recipes for the future
* Dart:
  * Drop-in Dart microservice for RAD with Redstone
  * Generalize Dart container rules
  * Change communication from encode.sh to http request
* Make process:
  * include pushing to repos for dropbox
  * Generate .json config and uploading it to Synology somehow
  * Adding events to DSM notification center