SET(asmjs_SOURCES
  asm_v_wasm.cpp
)
ADD_LIBRARY(asmjs STATIC ${asmjs_SOURCES})