set(wasm_SOURCES
  literal.cpp
  wasm.cpp
  wasm-binary.cpp
  wasm-emscripten.cpp
  wasm-interpreter.cpp
  wasm-io.cpp
  wasm-s-parser.cpp
  wasm-stack.cpp
  wasm-type.cpp
  wasm-validator.cpp
)
add_library(wasm OBJECT ${wasm_SOURCES})
