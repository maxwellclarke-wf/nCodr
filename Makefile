ENV = docker-machine start default && eval "$(docker-machine env default)"

build_ffmpeg:
	$(ENV) && \
	cd docker/ffmpeg && \
	docker build -t emcee/ffmpeg .

build_dart:
	$(ENV) && \
	cd docker/dart_encode && \
	docker build -t emcee/encodr .

build: build_dart build_ffmpeg

var_test:
	$(TEST) && echo $$test_var

var_test_other: var_test
	echo $$name