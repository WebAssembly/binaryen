#!/bin/bash

sudo apt -y install ninja-build cmake clang
pip3 install -r requirements-dev.txt

export ASAN_OPTIONS="symbolize=1"
COMPILER_FLAGS="-fsanitize=address"

mkdir -p asan
cmake -S . -B asan/ -G Ninja -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_FLAGS="$COMPILER_FLAGS" -DCMAKE_CXX_FLAGS="$COMPILER_FLAGS"
cmake --build asan
