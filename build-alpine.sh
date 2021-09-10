#!/bin/sh

apk update && apk add build-base cmake git python3 clang ninja
pip3 install -r requirements-dev.txt

cmake . -G Ninja -DCMAKE_CXX_FLAGS="-static" -DCMAKE_C_FLAGS="-static" -DCMAKE_BUILD_TYPE=Release -DBUILD_STATIC_LIB=ON -DCMAKE_INSTALL_PREFIX=alpine
ninja install
