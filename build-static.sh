#!/bin/sh

set -eu

apk upgrade
apk add \
  alpine-sdk \
  cmake \
  coreutils \
  git \
  lld \
  llvm \
  ninja-is-really-ninja \
  nodejs \
  py3-pip \
  zstd

VENV="$(mktemp -d)"

python3 -m venv "$VENV"

. "$VENV/bin/activate"

pip3 install -r requirements-dev.txt

cmake \
  -Bbuild \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="/tmp/binaryen-$GITHUB_REF_NAME" \
  -DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld -s -static" \
  -DBUILD_STATIC_LIB=ON \
  -DENABLE_WERROR=OFF \
  -DINSTALL_LIBS=OFF

cmake --build build --target install -- -v

COMPILER_FLAGS="-fuse-ld=lld -s -static" ./check.py --binaryen-bin build/bin --binaryen-lib build/lib

tar \
  --sort=name \
  --owner=0 \
  --group=0 \
  --numeric-owner \
  --use-compress-program="gzip -9" \
  -cf "binaryen-$GITHUB_REF_NAME-x86_64-linux-static.tar.gz" \
  -C /tmp \
  "binaryen-$GITHUB_REF_NAME"
