set(asmjs_SOURCES
  asm_v_wasm.cpp
  asmangle.cpp
  shared-constants.cpp
)
add_library(asmjs OBJECT ${asmjs_SOURCES})
