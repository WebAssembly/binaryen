FILE(GLOB wasm_split_HEADERS *h)
set(wasm_split_SOURCES
  split-options.cpp
  instrumenter.cpp
  ${wasm_split_HEADERS}
)
add_library(wasm-split-lib STATIC ${wasm_split_SOURCES})
