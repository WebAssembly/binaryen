set(PREBUILT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/prebuilt)

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
