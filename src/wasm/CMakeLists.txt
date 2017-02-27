SET(wasm_SOURCES
  literal.cpp
  wasm.cpp
  wasm-binary.cpp
  wasm-io.cpp
  wasm-s-parser.cpp
  wasm-type.cpp
)
ADD_LIBRARY(wasm STATIC ${wasm_SOURCES})
