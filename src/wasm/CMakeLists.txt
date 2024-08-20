file(GLOB wasm_HEADERS ../*.h)
set(wasm_SOURCES
  literal.cpp
  parsing.cpp
  wasm.cpp
  wasm-binary.cpp
  wasm-debug.cpp
  wasm-emscripten.cpp
  wasm-interpreter.cpp
  wasm-io.cpp
  wasm-ir-builder.cpp
  wasm-stack.cpp
  wasm-stack-opts.cpp
  wasm-type.cpp
  wasm-type-shape.cpp
  wasm-validator.cpp
  ${wasm_HEADERS}
)
# wasm-debug.cpp includes LLVM header using std::iterator (deprecated in C++17)
if (NOT MSVC)
  set_source_files_properties(wasm-debug.cpp PROPERTIES COMPILE_FLAGS -Wno-deprecated-declarations)
endif()
add_library(wasm OBJECT ${wasm_SOURCES})
