ENV = docker-machine start default && eval "$$(docker-machine env default)"
BASE_PATH = /Users/maxwellclarke/workspaces/nCodr/test/test_files

build_ffmpeg:
	$(ENV) && \
	cd docker/ffmpeg && \
	docker build -t emcee/ffmpeg .

build_dart:
	$(ENV) && \
	cd docker/dart_encode && \
	docker build -t emcee/encodr .

build: build_dart build_ffmpeg

run_ffmpeg: build_ffmpeg clean_test
	$(ENV) && \
	cd docker/ffmpeg && \
	docker rm ffmpeg && \
	docker run -it \
	--name ffmpeg \
	--volumes-from encodr \
	-v $(BASE_PATH)/input_files:/encodeIn \
	-v $(BASE_PATH)/output_files:/encodeOut \
	emcee/ffmpeg

run_dart: build_dart clean_test
	$(ENV) && \
	cd docker/dart_encode && \
	docker rm encodr && \
	docker run -it \
	--name encodr \
	--volumes-from encodr \
	-v $(BASE_PATH)/input_files:/encodeIn \
	-v $(BASE_PATH)/output_files:/encodeOut \
	emcee/encodr

stop: stop_dart stop_ffmpeg

stop_dart:
	$(ENV) && \
	docker stop -t 1 encodr

stop_ffmpeg:
	$(ENV) && \
	docker stop -t 1 ffmpeg

push: push_dart push_ffmpeg

push_dart:
	$(ENV) && \
	docker push emcee/encodr

push_ffmpeg:
	$(ENV) && \
	docker push emcee/ffmpeg

clean_test:
	rm -f test/test_files/output_files/{encodr.sh,*.mp4}