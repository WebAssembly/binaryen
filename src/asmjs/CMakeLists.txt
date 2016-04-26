SET(asmjs_SOURCES
  asm_v_wasm.cpp
  shared-constants.cpp
)
ADD_LIBRARY(asmjs STATIC ${asmjs_SOURCES})