include_directories(fuzzing)
FILE(GLOB fuzzing_HEADERS fuzzing/*h)
set(fuzzing_SOURCES
  fuzzing/fuzz-stats.cpp
  fuzzing/fuzzing.cpp
  fuzzing/heap-types.cpp
  fuzzing/parameters.cpp
  fuzzing/random.cpp
  ${fuzzing_HEADERS}
)

add_library(wasm-opt-lib STATIC EXCLUDE_FROM_ALL
  ${PROJECT_SOURCE_DIR}/src/wasm-opt-c.cpp
  ${fuzzing_SOURCES}
)
set_target_properties(wasm-opt-lib PROPERTIES OUTPUT_NAME wasm-opt)
target_link_libraries(wasm-opt-lib PUBLIC binaryen)
target_include_directories(wasm-opt-lib SYSTEM INTERFACE ${PROJECT_SOURCE_DIR}/src)

binaryen_add_executable(wasm-opt wasm-opt.cpp)
target_link_libraries(wasm-opt PRIVATE wasm-opt-lib)
binaryen_add_executable(wasm-metadce wasm-metadce.cpp)
binaryen_add_executable(wasm2js wasm2js.cpp)
binaryen_add_executable(wasm-emscripten-finalize wasm-emscripten-finalize.cpp)
binaryen_add_executable(wasm-as wasm-as.cpp)
binaryen_add_executable(wasm-dis wasm-dis.cpp)
binaryen_add_executable(wasm-ctor-eval wasm-ctor-eval.cpp)
if(NOT BUILD_EMSCRIPTEN_TOOLS_ONLY)
  binaryen_add_executable(wasm-shell wasm-shell.cpp)
  binaryen_add_executable(wasm-merge wasm-merge.cpp)
  binaryen_add_executable(wasm-fuzz-types "${fuzzing_SOURCES};wasm-fuzz-types.cpp")
  binaryen_add_executable(wasm-fuzz-lattices "${fuzzing_SOURCES};wasm-fuzz-lattices.cpp")
  binaryen_add_executable(wasm-embed wasm-embed.cpp)
  add_subdirectory(wasm-reduce)
endif()

add_subdirectory(wasm-split)
