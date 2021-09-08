FILE(GLOB wasm_split_HEADERS *h)
set(wasm_split_SOURCES
  split-options.cpp
  instrumenter.cpp
  ${wasm_split_HEADERS}
)
add_library(wasm-split-lib OBJECT ${wasm_split_SOURCES})

binaryen_add_executable(wasm-split wasm-split.cpp $<TARGET_OBJECTS:wasm-split-lib>)
target_link_libraries(wasm-split wasm-split-lib)
