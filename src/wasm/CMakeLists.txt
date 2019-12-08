SET(wasm_SOURCES
  literal.cpp
  wasm.cpp
  wasm-binary.cpp
  wasm-emscripten.cpp
  wasm-debug.cpp
  wasm-interpreter.cpp
  wasm-io.cpp
  wasm-s-parser.cpp
  wasm-stack.cpp
  wasm-type.cpp
  wasm-validator.cpp
)
ADD_LIBRARY(wasm OBJECT ${wasm_SOURCES})
