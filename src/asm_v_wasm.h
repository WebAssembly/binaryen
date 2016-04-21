/*
 * Copyright 2015 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef wasm_asm_v_wasm_h
#define wasm_asm_v_wasm_h

#include "mixed_arena.h"
#include "emscripten-optimizer/optimizer.h"
#include "wasm.h"

namespace wasm {

WasmType asmToWasmType(AsmType asmType);

AsmType wasmToAsmType(WasmType type);

char getSig(WasmType type);

std::string getSig(FunctionType *type);

std::string getSig(Function *func);

std::string getSig(CallBase *call);

std::string getSig(WasmType result, const ExpressionList& operands);

WasmType sigToWasmType(char sig);

FunctionType sigToFunctionType(std::string sig);

FunctionType* ensureFunctionType(std::string sig, Module* wasm, MixedArena& allocator);

} // namespace wasm

#endif // wasm_asm_v_wasm_h
