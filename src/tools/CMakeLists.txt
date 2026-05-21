include_directories(fuzzing)
FILE(GLOB fuzzing_HEADERS fuzzing/*h)
set(fuzzing_SOURCES
  fuzzing/fuzzing.cpp
  fuzzing/heap-types.cpp
  fuzzing/parameters.cpp
  fuzzing/random.cpp
  ${fuzzing_HEADERS}
)

binaryen_add_executable(wasm-opt "${fuzzing_SOURCES};wasm-opt.cpp")
binaryen_add_executable(wasm-metadce wasm-metadce.cpp)
binaryen_add_executable(wasm2js wasm2js.cpp)
set(TEMPLATE_CMAKE ${PROJECT_SOURCE_DIR}/scripts/gen-wasm2c-templates.cmake)
set(TEMPLATE_DIR ${PROJECT_SOURCE_DIR}/src/templates)
set(PREBUILT_DIR ${PROJECT_SOURCE_DIR}/src/prebuilt)

add_custom_command(
  OUTPUT ${PREBUILT_DIR}/wasm2c_header_top.cc
         ${PREBUILT_DIR}/wasm2c_header_bottom.cc
         ${PREBUILT_DIR}/wasm2c_source_includes.cc
         ${PREBUILT_DIR}/wasm2c_source_declarations.cc
         ${PREBUILT_DIR}/wasm2c_simd_source_declarations.cc
         ${PREBUILT_DIR}/wasm2c_atomicops_source_declarations.cc
         ${PREBUILT_DIR}/wasm2c_spec_top.cc

  COMMAND ${CMAKE_COMMAND} -D out="${PREBUILT_DIR}/wasm2c_header_top.cc" -D in="${TEMPLATE_DIR}/wasm2c.top.h" -D symbol="s_header_top" -P ${TEMPLATE_CMAKE}
  COMMAND ${CMAKE_COMMAND} -D out="${PREBUILT_DIR}/wasm2c_header_bottom.cc" -D in="${TEMPLATE_DIR}/wasm2c.bottom.h" -D symbol="s_header_bottom" -P ${TEMPLATE_CMAKE}
  COMMAND ${CMAKE_COMMAND} -D out="${PREBUILT_DIR}/wasm2c_source_includes.cc" -D in="${TEMPLATE_DIR}/wasm2c.includes.c" -D symbol="s_source_includes" -P ${TEMPLATE_CMAKE}
  COMMAND ${CMAKE_COMMAND} -D out="${PREBUILT_DIR}/wasm2c_source_declarations.cc" -D in="${TEMPLATE_DIR}/wasm2c.declarations.c" -D symbol="s_source_declarations" -P ${TEMPLATE_CMAKE}
  COMMAND ${CMAKE_COMMAND} -D out="${PREBUILT_DIR}/wasm2c_simd_source_declarations.cc" -D in="${TEMPLATE_DIR}/wasm2c_simd.declarations.c" -D symbol="s_simd_source_declarations" -P ${TEMPLATE_CMAKE}
  COMMAND ${CMAKE_COMMAND} -D out="${PREBUILT_DIR}/wasm2c_atomicops_source_declarations.cc" -D in="${TEMPLATE_DIR}/wasm2c_atomicops.declarations.c" -D symbol="s_atomicops_source_declarations" -P ${TEMPLATE_CMAKE}
  COMMAND ${CMAKE_COMMAND} -D out="${PREBUILT_DIR}/wasm2c_spec_top.cc" -D in="${TEMPLATE_DIR}/wasm2c_spec.top.c" -D symbol="s_spec_top" -P ${TEMPLATE_CMAKE}

  DEPENDS ${TEMPLATE_DIR}/wasm2c.top.h
          ${TEMPLATE_DIR}/wasm2c.bottom.h
          ${TEMPLATE_DIR}/wasm2c.includes.c
          ${TEMPLATE_DIR}/wasm2c.declarations.c
          ${TEMPLATE_DIR}/wasm2c_simd.declarations.c
          ${TEMPLATE_DIR}/wasm2c_atomicops.declarations.c
          ${TEMPLATE_DIR}/wasm2c_spec.top.c
)

set(WASM2C_GENERATED_SOURCES
    ${PREBUILT_DIR}/wasm2c_header_top.cc
    ${PREBUILT_DIR}/wasm2c_header_bottom.cc
    ${PREBUILT_DIR}/wasm2c_source_includes.cc
    ${PREBUILT_DIR}/wasm2c_source_declarations.cc
    ${PREBUILT_DIR}/wasm2c_simd_source_declarations.cc
    ${PREBUILT_DIR}/wasm2c_atomicops_source_declarations.cc
    ${PREBUILT_DIR}/wasm2c_spec_top.cc
)

binaryen_add_executable(wasm2c "wasm2c.cpp;${WASM2C_GENERATED_SOURCES}")
target_include_directories(wasm2c PRIVATE ${PROJECT_SOURCE_DIR}/third_party/picosha2)
binaryen_add_executable(wasm-emscripten-finalize wasm-emscripten-finalize.cpp)
binaryen_add_executable(wasm-as wasm-as.cpp)
binaryen_add_executable(wasm-dis wasm-dis.cpp)
binaryen_add_executable(wasm-ctor-eval wasm-ctor-eval.cpp)
if(NOT BUILD_EMSCRIPTEN_TOOLS_ONLY)
  binaryen_add_executable(wasm-shell wasm-shell.cpp)
  binaryen_add_executable(wasm-merge wasm-merge.cpp)
  binaryen_add_executable(wasm-fuzz-types "${fuzzing_SOURCES};wasm-fuzz-types.cpp")
  binaryen_add_executable(wasm-fuzz-lattices "${fuzzing_SOURCES};wasm-fuzz-lattices.cpp")
  add_subdirectory(wasm-reduce)
endif()

add_subdirectory(wasm-split)
