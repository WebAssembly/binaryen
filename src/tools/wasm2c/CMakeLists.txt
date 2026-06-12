set(TEMPLATE_CMAKE ${CMAKE_CURRENT_SOURCE_DIR}/gen-wasm2c-templates.cmake)
set(TEMPLATE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/templates)
set(PREBUILT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/prebuilt)

add_custom_command(
  OUTPUT ${PREBUILT_DIR}/wasm2c_header_top.cpp
         ${PREBUILT_DIR}/wasm2c_header_bottom.cpp
         ${PREBUILT_DIR}/wasm2c_source_includes.cpp
         ${PREBUILT_DIR}/wasm2c_source_declarations.cpp
         ${PREBUILT_DIR}/wasm2c_simd_source_declarations.cpp
         ${PREBUILT_DIR}/wasm2c_atomicops_source_declarations.cpp
         ${PREBUILT_DIR}/wasm2c_spec_top.cpp

  COMMAND ${CMAKE_COMMAND} -D out="${PREBUILT_DIR}/wasm2c_header_top.cpp" -D in="${TEMPLATE_DIR}/wasm2c.top.h" -D symbol="HeaderTop" -P ${TEMPLATE_CMAKE}
  COMMAND ${CMAKE_COMMAND} -D out="${PREBUILT_DIR}/wasm2c_header_bottom.cpp" -D in="${TEMPLATE_DIR}/wasm2c.bottom.h" -D symbol="HeaderBottom" -P ${TEMPLATE_CMAKE}
  COMMAND ${CMAKE_COMMAND} -D out="${PREBUILT_DIR}/wasm2c_source_includes.cpp" -D in="${TEMPLATE_DIR}/wasm2c.includes.c" -D symbol="SourceIncludes" -P ${TEMPLATE_CMAKE}
  COMMAND ${CMAKE_COMMAND} -D out="${PREBUILT_DIR}/wasm2c_source_declarations.cpp" -D in="${TEMPLATE_DIR}/wasm2c.declarations.c" -D symbol="SourceDeclarations" -P ${TEMPLATE_CMAKE}
  COMMAND ${CMAKE_COMMAND} -D out="${PREBUILT_DIR}/wasm2c_simd_source_declarations.cpp" -D in="${TEMPLATE_DIR}/wasm2c_simd.declarations.c" -D symbol="SimdSourceDeclarations" -P ${TEMPLATE_CMAKE}
  COMMAND ${CMAKE_COMMAND} -D out="${PREBUILT_DIR}/wasm2c_atomicops_source_declarations.cpp" -D in="${TEMPLATE_DIR}/wasm2c_atomicops.declarations.c" -D symbol="AtomicsOpsSourceDeclarations" -P ${TEMPLATE_CMAKE}
  COMMAND ${CMAKE_COMMAND} -D out="${PREBUILT_DIR}/wasm2c_spec_top.cpp" -D in="${TEMPLATE_DIR}/wasm2c_spec.top.c" -D symbol="SpecTop" -P ${TEMPLATE_CMAKE}

  DEPENDS ${TEMPLATE_DIR}/wasm2c.top.h
          ${TEMPLATE_DIR}/wasm2c.bottom.h
          ${TEMPLATE_DIR}/wasm2c.includes.c
          ${TEMPLATE_DIR}/wasm2c.declarations.c
          ${TEMPLATE_DIR}/wasm2c_simd.declarations.c
          ${TEMPLATE_DIR}/wasm2c_atomicops.declarations.c
          ${TEMPLATE_DIR}/wasm2c_spec.top.c
)

set(WASM2C_GENERATED_SOURCES
    ${PREBUILT_DIR}/wasm2c_header_top.cpp
    ${PREBUILT_DIR}/wasm2c_header_bottom.cpp
    ${PREBUILT_DIR}/wasm2c_source_includes.cpp
    ${PREBUILT_DIR}/wasm2c_source_declarations.cpp
    ${PREBUILT_DIR}/wasm2c_simd_source_declarations.cpp
    ${PREBUILT_DIR}/wasm2c_atomicops_source_declarations.cpp
    ${PREBUILT_DIR}/wasm2c_spec_top.cpp
)

binaryen_add_executable(wasm2c "wasm2c-builder.cpp;assertion-emitter.cpp;wasm2c.cpp;${WASM2C_GENERATED_SOURCES}")
# TODO: https://github.com/WebAssembly/binaryen/issues/8775 - stop using picosha2
target_include_directories(wasm2c PRIVATE ${PROJECT_SOURCE_DIR}/third_party/picosha2 ${PROJECT_SOURCE_DIR}/src/tools/wasm2c)
