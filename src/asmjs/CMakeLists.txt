FILE(GLOB asmjs_HEADERS *.h)
set(asmjs_SOURCES
  asm_v_wasm.cpp
  asmangle.cpp
  shared-constants.cpp
  ${asmjs_HEADERS}
)
add_library(asmjs OBJECT ${asmjs_SOURCES})
