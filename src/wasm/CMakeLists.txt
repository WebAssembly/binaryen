SET(wasm_SOURCES
  literal.cpp
  wasm.cpp
  wasm-binary.cpp
  wasm-emscripten.cpp
  wasm-interpreter.cpp
  wasm-io.cpp
  wasm-s-parser.cpp
  wasm-type.cpp
  wasm-validator.cpp
)
ADD_LIBRARY(wasm STATIC ${wasm_SOURCES})
