#ifndef _asm_v_wasm_h_
#define _asm_v_wasm_h_

#include "emscripten-optimizer/optimizer.h"

namespace wasm {

WasmType asmToWasmType(AsmType asmType) {
  switch (asmType) {
    case ASM_INT: return WasmType::i32;
    case ASM_DOUBLE: return WasmType::f64;
    case ASM_FLOAT: return WasmType::f32;
    case ASM_NONE: return WasmType::none;
    default: {}
  }
  abort();
}

AsmType wasmToAsmType(WasmType type) {
  switch (type) {
    case WasmType::i32: return ASM_INT;
    case WasmType::f32: return ASM_FLOAT;
    case WasmType::f64: return ASM_DOUBLE;
    case WasmType::none: return ASM_NONE;
    default: {}
  }
  abort();
}

}

#endif // _asm_v_wasm_h_

