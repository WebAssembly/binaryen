# For travis
FROM buildpack-deps:xenial
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND noninteractive
RUN mkdir -p /root/emscripten/
COPY . /root/emscripten/

RUN echo "Starting Docker, in" `pwd` \
 && cd /root/ \
 && apt-get update \
 && apt-get install -y python python-pip cmake build-essential openjdk-9-jre-headless \
 && pip install --upgrade pip \
 && pip install lit \
 && wget https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz \
 && tar -xf emsdk-portable.tar.gz \
 && pushd emsdk-portable \
 && ./emsdk update \
 && ./emsdk install latest \
 && ./emsdk activate latest \
 && popd \
 && echo EMSCRIPTEN_ROOT="'/root/emscripten/'" >> .emscripten \
 && echo "Starting to build, in" `pwd` \
 && EMSCRIPTEN=/root/emscripten ./build-js.sh \
 && cmake . \
 && make -j2 \
 && ./check.py

