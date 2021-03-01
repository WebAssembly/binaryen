#!/bin/bash
bin/wasm-autogen c-api-decl > src/binaryen-c.autogen.h
bin/wasm-autogen c-api-impl > src/binaryen-c.autogen.cpp
