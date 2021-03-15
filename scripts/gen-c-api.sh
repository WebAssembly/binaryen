#!/bin/bash
bin/wasm-api-gen c-api-decl > src/binaryen-c.autogen.h
bin/wasm-api-gen c-api-impl > src/binaryen-c.autogen.cpp
