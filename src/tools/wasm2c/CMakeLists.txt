set(PREBUILT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/prebuilt)
set(WASM_RT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/wasm-rt)

set(WASM2C_TEMPLATE_SOURCES
    ${PREBUILT_DIR}/wasm2c_header_top.cpp
    ${PREBUILT_DIR}/wasm2c_header_bottom.cpp
    ${PREBUILT_DIR}/wasm2c_source_includes.cpp
    ${PREBUILT_DIR}/wasm2c_source_declarations.cpp
    ${PREBUILT_DIR}/wasm2c_simd_source_declarations.cpp
    ${PREBUILT_DIR}/wasm2c_atomicops_source_declarations.cpp
    ${PREBUILT_DIR}/wasm2c_spec_top.cpp
)

binaryen_add_executable(wasm2c "wasm2c-builder.cpp;assertion-emitter.cpp;wasm2c.cpp;${WASM2C_TEMPLATE_SOURCES}")
# TODO: https://github.com/WebAssembly/binaryen/issues/8775 - stop using picosha2
target_include_directories(wasm2c PRIVATE ${PROJECT_SOURCE_DIR}/third_party/picosha2 ${PROJECT_SOURCE_DIR}/src/tools/wasm2c)

set(WASM_RT_SOURCES
  ${WASM_RT_DIR}/wasm-rt-exceptions-impl.c
  ${WASM_RT_DIR}/wasm-rt-impl.c
  ${WASM_RT_DIR}/wasm-rt-mem-impl.c
)

set(WASM_RT_INCLUDES
  ${WASM_RT_DIR}/wasm-rt-exceptions.h
  ${WASM_RT_DIR}/wasm-rt.h
  ${WASM_RT_DIR}/wasm-rt-impl.h
  ${WASM_RT_DIR}/wasm-rt-impl-tableops.inc
  ${WASM_RT_DIR}/wasm-rt-mem-impl-helper.inc
)

set_source_files_properties(${WASM_RT_SOURCES}
    PROPERTIES LANGUAGE C
)

set_source_files_properties(${WASM_RT_INCLUDES}
    PROPERTIES LANGUAGE C
)

add_library(wasm-rt ${WASM_RT_SOURCES})
