SET(asmjs_SOURCES
  asm_v_wasm.cpp
  asmangle.cpp
  shared-constants.cpp
)
ADD_LIBRARY(asmjs OBJECT ${asmjs_SOURCES})
