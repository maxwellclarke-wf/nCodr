## Personal Repo for docker images running on Synology DiskStation.  Use at your own risk.

#### emcee/nCodr [nCodr]
* Docker-based mkv file watcher with output directory checking
* Uses Dart

#### emcee/ffmpeg [ffmpeg]
* ffmpeg based on https://github.com/jrottenberg/ffmpeg
* ffmpeg mkv -> mp4 transcoder for Synology DiskStation

#### emcee/dropbox [dropbox]
* Dropbox image for Synology based on CentOS

#### Build
`make build`
`make build_[image_name]`

Pull down the latest built machines from:
* https://hub.docker.com/r/emcee/encodr
* https://hub.docker.com/r/emcee/ffmpeg
* https://hub.docker.com/r/emcee/dropbox

#### Run
* 'make run_[image_name]' runs the docker machine with access to the testing folder and echo the command run
* **Warning: This command defaults name to [image_name], deleting any previous machine by that name.**
* [nCodr] and [ffmpeg] rely on each other
You must supply two volumes on each machine, `/encodeIn` and `/encodeOut`.
* [dropbox] will require you to enter a token to authenticate, see the logs

#### Stop container
* `make stop` to stop all containers now
* 'make stop_[image_name]' stops specific machines

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
* Synology Integration
  * Automate delivery to NAS
  * Events integration
  * Restart on error (Container health monitoring)
* Dart:
  * Tests.  Actual tests.
  * Drop-in Dart microservice for RAD with Redstone
  * postgres database for persistence
  * task queue
  * site scraper / authenticator
  * Change communication from encode.sh to http request
* Make process:
  * include pushing to repos
  * make command that adds a new docker name template readme