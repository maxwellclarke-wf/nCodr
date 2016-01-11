FROM google/dart

WORKDIR /app

VOLUME ["/encodeOut", "/encodeIn"]

ADD pubspec.* /app/
RUN pub get
ADD . /app
RUN pub get --offline
RUN echo "*******DONE BUILDING*****"

ENTRYPOINT ["/usr/bin/dart", "--enable-async", "bin/server.dart"]
