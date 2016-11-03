SET(wasm_SOURCES
  wasm.cpp
  wasm-binary.cpp
  wasm-s-parser.cpp
)
ADD_LIBRARY(wasm STATIC ${wasm_SOURCES})
