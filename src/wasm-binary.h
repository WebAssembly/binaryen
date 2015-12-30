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

//
// Parses and emits WebAssembly binary code
//

#ifndef wasm_wasm_binary_h
#define wasm_wasm_binary_h

#include <ostream>

#include "wasm.h"
#include "shared-constants.h"

namespace wasm {

enum Section {
  Memory = 0,
  Signatures = 1,
  Functions = 2,
  DataSegments = 4,
  FunctionTable = 5,
  End = 6
};

enum FunctionEntry {
  Named = 1,
  Import = 2,
  Locals = 4,
  Export = 8
};

char binaryWasmType(WasmType type) {
  switch (type) {
    case none: return 0;
    case i32: return 1;
    case i64: return 2;
    case f32: return 3;
    case f64: return 4;
    default: abort();
  }
}

class WasmBinaryWriter : public WasmVisitor<void> {
  Module* wasm;
  ostream& o;

public:
  WasmBinaryWriter(Module* wasm, ostream& o) : wasm(wasm), o(o) {}

  void write() {
    writeMemory();
    writeSignatures();
    writeFunctions();
    writeDataSegments();
    writeFunctionTable();
    writeEnd();
  }

  writeMemory() {
    o << Section::Memory << char(log2(wasm.memory.initial)) <<
                            char(log2(wasm.memory.max)) <<
                            char(1); // export memory
  }

  writeSignatures() {
    o << Section::Signatures << LEB128(wasm.functionTypes.size());
    for (auto type : wasm.functionTypes) {
      o << char(type->params.size());
      o << binaryWasmType(type->result);
      for (auto param : type->params) {
        o << binaryWasmType(param);
      }
    }
  }

  int16_t functionTypeIndex(Name type) {
    // TODO: optimize
    for (size_t i = 0; i < wasm.functionTypes.size(); i++) {
      if (wasm.functionTypes[i].name == type) return i;
    }
    abort();
  }

  std::map<Name, size_t> mappedLocals; // local name => index in compact form of [all int32s][all int64s]etc
  std::map<WasmType, size_t> numLocalsByType; // type => number of locals of that type in the compact form

  void mapLocals(Function* function) {
    for (auto& local : function->locals) {
      numLocalsByType[local.type]++;
    }
    std::map<WasmType, size_t> currLocalsByType;
    for (auto& local : function->locals) {
      size_t index = 0;
      Name name = local.name;
      WasmType type = local.type;
      currLocalsByType[type]++; // increment now for simplicity, must decremebt it in returns
      if (type == i32) {
        mappedLocals[name] = index + currLocalsByType[i32] - 1;
        break;
      }
      index += numLocalsByType[i32];
      if (type == i64) {
        mappedLocals[name] = index + currLocalsByType[i64] - 1;
        break;
      }
      index += numLocalsByType[i64];
      if (type == f32) {
        mappedLocals[name] = index + currLocalsByType[f32] - 1;
        break;
      }
      index += numLocalsByType[f32];
      if (type == f64) {
        mappedLocals[name] = index + currLocalsByType[f64] - 1;
        break;
      }
    }
  }

  std::vector<char> encodeAST(Function* function) {
  }

  writeFunctions() {
    size_t total = wasm.imports.size() + wasm.functions.size();
    o << Section::Functions << LEB128(total);
    for (size_t i = 0; i < total; i++) {
      Import* import = i < wasm.imports.size() ? wasm.imports[i] : nullptr;
      Function* function = i >= wasm.imports.size() ? wasm.functions[i - wasm.imports.size()] : nullptr;
      Name name, type;
      if (import) {
        name = import->name;
        type = import->type.name;
      } else {
        name = function->name;
        type = function->type;
      }
      o << functionTypeIndex(type);
      o << char(FunctionEntry::Named |
                (FunctionEntry::Import * !!import) |
                (FunctionEntry::Locals * (function && function->locals.size() > 0) |
                (FunctionEntry::Export) * (wasm.exportsMap[name].count(name) > 0)));
      // TODO: name. how can we do an offset? into what section? and how do we know it now?
      if (function && function->locals.size() > 0) {
        mapLocals(function);
        o << uint16_t(numLocalsByType[i32])
          << uint16_t(numLocalsByType[i64])
          << uint16_t(numLocalsByType[f32])
          << uint16_t(numLocalsByType[f64]);
      }
      if (function) {
        auto ast = encodeAST(function);
        o << uint16_t(ast.size());
        for (auto c : ast) {
          o << c;
        }
      }
    }
  }

  writeDataSegments() {
    o << Section::DataSegments << LEB128(wasm.memory.segments.size());
    for (auto& segment : wasm.memory.segments) {
      o << int32_t(segment.offset)
        << int32_t(XXX) // TODO: where/when do we emit this?
        << int32_t(segment.size)
        << char(1); // load at program start
    }
  }

  uint16_t getFunctionIndex(Name name) {
    // TODO: optimize
    for (size_t i = 0; i < wasm.imports.size()) {
      if (wasm.imports[i]->name == name) return i;
    }
    for (size_t i = 0; i < wasm.functions.size()) {
      if (wasm.functions[i]->name == name) return wasm.imports.size() + i;
    }
    abort();
  }

  writeFunctionTable() {
    o << Section::FunctionTable << LEB128(wasm.table.names.size());
    for (auto name : wasm.table.names) {
      o << getFunctionIndex(name);
    }
  }

  writeEnd() {
    o << Section::End;
  }
};

class WasmBinaryBuilder {
  AllocatingModule& wasm;
  MixedArena& allocator;
  istream& i;
public:
  WasmBinaryBuilder(AllocatingModule& wasm, istream& i) : wasm(wasm), allocator(wasm.allocator), i(i) {}

  void read() {
    //
  }
};

} // namespace wasm

#endif // wasm_wasm_binary_h

