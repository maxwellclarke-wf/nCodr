
# ffmpeg - http://ffmpeg.org/download.html
#
# VERSION               2.8
#
# From https://trac.ffmpeg.org/wiki/CompilationGuide/Centos
#
# https://hub.docker.com/r/jrottenberg/ffmpeg/
#
#
FROM          jrottenberg/ffmpeg
MAINTAINER    Max Clarke <maxwelljclarke@gmail.com>

ENTRYPOINT    ["bash", "/tmp/workdir/run.sh"]
WORKDIR       /tmp/workdir

VOLUME ["/encodeOut", "/encodeIn"]


ENV           FFMPEG_VERSION=2.8.3 \
              YASM_VERSION=1.3.0   \
              OGG_VERSION=1.3.2    \
              VORBIS_VERSION=1.3.5 \
              THEORA_VERSION=1.1.1 \
              LAME_VERSION=3.99.5  \
              OPUS_VERSION=1.1.1   \
              FAAC_VERSION=1.28    \
              VPX_VERSION=1.4.0    \
              XVID_VERSION=1.3.4   \
              FDKAAC_VERSION=0.1.4 \
              X265_VERSION=1.8


# See https://github.com/jrottenberg/ffmpeg/blob/master/run.sh
COPY          run.sh /tmp/workdir/run.sh

#RUN           /tmp/workdir/run.sh