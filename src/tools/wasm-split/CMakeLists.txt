FILE(GLOB wasm_split_HEADERS *h)
set(wasm_split_SOURCES
  wasm-split.cpp
  split-options.cpp
  instrumenter.cpp
  ${wasm_split_HEADERS}
)
binaryen_add_executable(wasm-split "${wasm_split_SOURCES}")
