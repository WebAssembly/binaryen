include_directories(fuzzing)
FILE(GLOB fuzzing_HEADERS fuzzing/*h)
set(fuzzing_SOURCES
  fuzzing/fuzzing.cpp
  fuzzing/heap-types.cpp
  fuzzing/random.cpp
  ${fuzzing_HEADERS}
)

binaryen_add_executable(wasm-opt "${fuzzing_SOURCES};wasm-opt.cpp")
binaryen_add_executable(wasm-metadce wasm-metadce.cpp)
binaryen_add_executable(wasm2js wasm2js.cpp)
binaryen_add_executable(wasm-emscripten-finalize wasm-emscripten-finalize.cpp)
binaryen_add_executable(wasm-as wasm-as.cpp)
binaryen_add_executable(wasm-dis wasm-dis.cpp)
binaryen_add_executable(wasm-ctor-eval wasm-ctor-eval.cpp)
if(NOT BUILD_EMSCRIPTEN_TOOLS_ONLY)
  binaryen_add_executable(wasm-shell wasm-shell.cpp)
  binaryen_add_executable(wasm-reduce wasm-reduce.cpp)
  binaryen_add_executable(wasm-merge wasm-merge.cpp)
  binaryen_add_executable(wasm-fuzz-types "${fuzzing_SOURCES};wasm-fuzz-types.cpp")
  binaryen_add_executable(wasm-fuzz-lattices "${fuzzing_SOURCES};wasm-fuzz-lattices.cpp")
endif()
if(BUILD_WASM_VALIDATE_REFINEMENT)
  binaryen_add_executable(wasm-validate-refinement wasm-validate-refinement.cpp)
  add_library(z3 SHARED IMPORTED)
  if(NOT LIBZ3_LOCATION)
    find_library(LIBZ3_LOCATION z3)
  endif()
  set_property(TARGET z3 PROPERTY IMPORTED_LOCATION ${LIBZ3_LOCATION})
  target_link_libraries(wasm-validate-refinement z3)
endif()

add_subdirectory(wasm-split)
