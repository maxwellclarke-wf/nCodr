ENV = docker-machine start default && eval "$$(docker-machine env default)"
BASE_PATH = /Users/maxwellclarke/workspaces/nCodr/test/test_files
TEST_ENCODE_IN = $(BASE_PATH)/input_files:/encodeIn
TEST_ENCODE_OUT = $(BASE_PATH)/output_files:/encodeOut

ENCODER_VOLUMES = -v $(TEST_ENCODE_IN) -v $(TEST_ENCODE_OUT)

DART_PATH = docker/dart_encode
DART_TAG = emcee/$(DART_NAME)
DART_NAME = encodr
DART_RUN_ARGS = --volumes-from $(DART_NAME) $(ENCODER_VOLUMES)

FFMPEG_PATH = docker/ffmpeg
FFMPEG_TAG = docker/ffmpeg
FFMPEG_NAME = ffmpeg
FFMPEG_RUN_ARGS = $(ENCODER_VOLUMES)

DROPBOX_PATH = docker/dropbox
DROPBOX_TAG = docker/dropbox
DROPBOX_NAME = dropbox

# BUILD_CMD = $(ENV) && docker build -t $(BUILD_TAG) $(DOCKER_PATH)
BUILD_CMD = $(ENV) && docker build -t $(1) $(2)

# REMOVE_DOCKER(machineName)
REMOVE_DOCKER = docker rm $(1)
# RUN_DOCKER_CMD(dockerName, dockerTag, extraArgs)
RUN_DOCKER_CMD = $(ENV) && $(call REMOVE_DOCKER, $(1) ) && docker run -it --name $(1) $(2) $(3)
# STOP_DOCKER(docker_name)
STOP_DOCKER = $(ENV) && docker stop -t 1 $(1)

# TARGETS

build_ffmpeg:
	$(call BUILD_CMD, $(FFMPEG_TAG), $(FFMPEG_PATH))
run_ffmpeg: build_ffmpeg clean_test
	$(call RUN_DOCKER_CMD, $(FFMPEG_NAME), $(FFMPEG_RUN_ARGS), $(FFMPEG_TAG) )
stop_ffmpeg:
	$(call STOP_DOCKER, $(FFMPEG_NAME))

build_dart:
	$(call BUILD_CMD, $(DART_TAG), $(DART_PATH))
run_dart: build_dart clean_test
	$(call RUN_DOCKER_CMD, $(DART_NAME), $(DART_RUN_ARGS), $(DART_TAG) )
stop_dart:
	$(call STOP_DOCKER, $(DART_PATH))

build_dropbox:
	$(call BUILD_CMD, $(DROPBOX_TAG), $(DROPBOX_PATH))

build: build_dart build_ffmpeg build_dropbox

stop: stop_dart stop_ffmpeg

push: push_dart push_ffmpeg

push_dart: build_dart
	$(ENV) && \
	docker push emcee/encodr
push_ffmpeg: build_ffmpeg
	$(ENV) && \
	docker push emcee/ffmpeg

clean_test:
	rm -f test/test_files/output_files/{encodr.sh,*.mp4}