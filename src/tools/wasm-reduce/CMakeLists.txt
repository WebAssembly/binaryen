FILE(GLOB wasm_reduce_HEADERS *h)
set(wasm_reduce_SOURCES
  wasm-reduce.cpp
  ${wasm_reduce_HEADERS}
)
binaryen_add_executable(wasm-reduce "${wasm_reduce_SOURCES}")
