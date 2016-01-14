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

#include <istream>
#include <ostream>

#include "wasm.h"
#include "shared-constants.h"
#include "asm_v_wasm.h"

namespace wasm {

struct LEB128 {
  uint32_t value;

  LEB128() {}
  LEB128(uint32_t value) : value(value) {}

  void write(std::vector<uint8_t>* out) {
    uint32_t temp = value;
    do {
      uint8_t byte = value & 127;
      temp >>= 7;
      if (temp) {
        byte = byte | 128;
      }
      out->push_back(byte);
    } while (temp);
  }

  void read(std::function<uint8_t ()> get) {
    value = 0;
    uint32_t shift = 0;
    while (1) {
      uint8_t byte = get();
      value |= ((byte & 127) << shift);
      if (!(byte & 128)) break;
      shift += 7;
    }
  }
};

//
// We mostly stream into a buffer as we create the binary format, however,
// sometimes we need to backtrack and write to a location behind us - wasm
// is optimized for reading, not writing.
//
class BufferWithRandomAccess : public std::vector<uint8_t> {
  bool debug;

public:
  BufferWithRandomAccess(bool debug) : debug(debug) {}

  BufferWithRandomAccess& operator<<(int8_t x) {
    if (debug) std::cerr << "writeInt8: " << (int)(uint8_t)x << std::endl;
    push_back(x);
    return *this;
  }
  BufferWithRandomAccess& operator<<(int16_t x) {
    if (debug) std::cerr << "writeInt16: " << x << std::endl;
    push_back(x & 0xff);
    push_back(x >> 8);
    return *this;
  }
  BufferWithRandomAccess& operator<<(int32_t x) {
    if (debug) std::cerr << "writeInt32: " << x << std::endl;
    push_back(x & 0xff); x >>= 8;
    push_back(x & 0xff); x >>= 8;
    push_back(x & 0xff); x >>= 8;
    push_back(x & 0xff);
    return *this;
  }
  BufferWithRandomAccess& operator<<(int64_t x) {
    if (debug) std::cerr << "writeInt64: " << x << std::endl;
    push_back(x & 0xff); x >>= 8;
    push_back(x & 0xff); x >>= 8;
    push_back(x & 0xff); x >>= 8;
    push_back(x & 0xff); x >>= 8;
    push_back(x & 0xff); x >>= 8;
    push_back(x & 0xff); x >>= 8;
    push_back(x & 0xff); x >>= 8;
    push_back(x & 0xff);
    return *this;
  }
  BufferWithRandomAccess& operator<<(LEB128 x) {
    if (debug) std::cerr << "writeLEB128: " << x.value << std::endl;
    x.write(this);
    return *this;
  }

  BufferWithRandomAccess& operator<<(uint8_t x) {
    return *this << (int8_t)x;
  }
  BufferWithRandomAccess& operator<<(uint16_t x) {
    return *this << (int16_t)x;
  }
  BufferWithRandomAccess& operator<<(uint32_t x) {
    return *this << (int32_t)x;
  }
  BufferWithRandomAccess& operator<<(uint64_t x) {
    return *this << (int64_t)x;
  }

  BufferWithRandomAccess& operator<<(float x) {
    if (debug) std::cerr << "writeFloat32: " << x << std::endl;
    return *this << Literal(x).reinterpreti32();
  }
  BufferWithRandomAccess& operator<<(double x) {
    if (debug) std::cerr << "writeFloat64: " << x << std::endl;
    return *this << Literal(x).reinterpreti64();
  }

  void writeAt(size_t i, uint16_t x) {
    (*this)[i] = x & 0xff;
    (*this)[i+1] = x >> 8;
  }
  void writeAt(size_t i, uint32_t x) {
    (*this)[i] = x & 0xff; x >>= 8;
    (*this)[i+1] = x & 0xff; x >>= 8;
    (*this)[i+2] = x & 0xff; x >>= 8;
    (*this)[i+3] = x & 0xff;
  }

  template <typename T>
  void writeTo(T& o) {
    for (auto c : *this) o << c;
  }
};

namespace BinaryConsts {

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

enum ASTNodes {
  MemorySize = 0x3b,
  GrowMemory = 0x39,
  I32Add = 0x40,
  I32Sub = 0x41,
  I32Mul = 0x42,
  I32DivS = 0x43,
  I32DivU = 0x44,
  I32RemS = 0x45,
  I32RemU = 0x46,
  I32And = 0x47,
  I32Or = 0x48,
  I32Xor = 0x49,
  I32Shl = 0x4a,
  I32ShrU = 0x4b,
  I32ShrS = 0x4c,
  I32Eq = 0x4d,
  I32Ne = 0x4e,
  I32LtS = 0x4f,
  I32LeS = 0x50,
  I32LtU = 0x51,
  I32LeU = 0x52,
  I32GtS = 0x53,
  I32GeS = 0x54,
  I32GtU = 0x55,
  I32GeU = 0x56,
  I32Clz = 0x57,
  I32Ctz = 0x58,
  I32Popcnt = 0x59,
  BoolNot = 0x5a,
  I64Add = 0x5b,
  I64Sub = 0x5c,
  I64Mul = 0x5d,
  I64DivS = 0x5e,
  I64DivU = 0x5f,
  I64RemS = 0x60,
  I64RemU = 0x61,
  I64And = 0x62,
  I64Or = 0x63,
  I64Xor = 0x64,
  I64Shl = 0x65,
  I64ShrU = 0x66,
  I64ShrS = 0x67,
  I64Eq = 0x68,
  I64Ne = 0x69,
  I64LtS = 0x6a,
  I64LeS = 0x6b,
  I64LtU = 0x6c,
  I64LeU = 0x6d,
  I64GtS = 0x6e,
  I64GeS = 0x6f,
  I64GtU = 0x70,
  I64GeU = 0x71,
  I64Clz = 0x72,
  I64Ctz = 0x73,
  I64Popcnt = 0x74,
  F32Add = 0x75,
  F32Sub = 0x76,
  F32Mul = 0x77,
  F32Div = 0x78,
  F32Min = 0x79,
  F32Max = 0x7a,
  F32Abs = 0x7b,
  F32Neg = 0x7c,
  F32CopySign = 0x7d,
  F32Ceil = 0x7e,
  F32Floor = 0x7f,
  F32Trunc = 0x80,
  F32NearestInt = 0x81,
  F32Sqrt = 0x82,
  F32Eq = 0x83,
  F32Ne = 0x84,
  F32Lt = 0x85,
  F32Le = 0x86,
  F32Gt = 0x87,
  F32Ge = 0x88,
  F64Add = 0x89,
  F64Sub = 0x8a,
  F64Mul = 0x8b,
  F64Div = 0x8c,
  F64Min = 0x8d,
  F64Max = 0x8e,
  F64Abs = 0x8f,
  F64Neg = 0x90,
  F64CopySign = 0x91,
  F64Ceil = 0x92,
  F64Floor = 0x93,
  F64Trunc = 0x94,
  F64NearestInt = 0x95,
  F64Sqrt = 0x96,
  F64Eq = 0x97,
  F64Ne = 0x98,
  F64Lt = 0x99,
  F64Le = 0x9a,
  F64Gt = 0x9b,
  F64Ge = 0x9c,
  I32SConvertF32 = 0x9d,
  I32SConvertF64 = 0x9e,
  I32UConvertF32 = 0x9f,
  I32UConvertF64 = 0xa0,
  I32ConvertI64 = 0xa1,
  I64SConvertF32 = 0xa2,
  I64SConvertF64 = 0xa3,
  I64UConvertF32 = 0xa4,
  I64UConvertF64 = 0xa5,
  I64SConvertI32 = 0xa6,
  I64UConvertI32 = 0xa7,

  I32LoadMem8S = 0x20,
  I32LoadMem8U = 0x21,
  I32LoadMem16S = 0x22,
  I32LoadMem16U = 0x23,
  I64LoadMem8S = 0x24,
  I64LoadMem8U = 0x25,
  I64LoadMem16S = 0x26,
  I64LoadMem16U = 0x27,
  I64LoadMem32S = 0x28,
  I64LoadMem32U = 0x29,
  I32LoadMem = 0x2a,
  I64LoadMem = 0x2b,
  F32LoadMem = 0x2c,
  F64LoadMem = 0x2d,
  I32StoreMem8 = 0x2e,
  I32StoreMem16 = 0x2f,
  I64StoreMem8 = 0x30,
  I64StoreMem16 = 0x31,
  I64StoreMem32 = 0x32,
  I32StoreMem = 0x33,
  I64StoreMem = 0x34,
  F32StoreMem = 0x35,
  F64StoreMem = 0x36,

  I8Const = 0x09,
  I32Const = 0x0a,
  I64Const = 0x0b,
  F64Const = 0x0c,
  F32Const = 0x0d,
  GetLocal = 0x0e,
  SetLocal = 0x0f,
  LoadGlobal = 0x10,
  StoreGlobal = 0x11,
  CallFunction = 0x12,
  CallIndirect = 0x13,

  Nop = 0x00,
  Block = 0x01,
  Loop = 0x02,
  If = 0x03,
  IfElse = 0x04,
  Select = 0x05,
  Br = 0x06,
  BrIf = 0x07,
  TableSwitch = 0x08,
  Return = 0x14,
  Unreachable = 0x15
};

enum MemoryAccess {
  Offset = 8,
  Alignment = 128
};

} // namespace BinaryConsts

int8_t binaryWasmType(WasmType type) {
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
  BufferWithRandomAccess& o;
  bool debug;

  MixedArena allocator;

  void prepare() {
    // we need function types for all our functions
    for (auto func : wasm->functions) {
      func->type = ensureFunctionType(getSig(func), wasm, allocator)->name;
    }
  }

public:
  WasmBinaryWriter(Module* input, BufferWithRandomAccess& o, bool debug) : o(o), debug(debug) {
    wasm = allocator.alloc<Module>();
    *wasm = *input; // simple shallow copy; we won't be modifying any internals, just adding some function types, so this is fine
    prepare();
  }

  void write() {
    writeMemory();
    writeSignatures();
    writeFunctions();
    writeDataSegments();
    writeFunctionTable();
    writeEnd();
    finishUp();
  }

  void writeMemory() {
    if (debug) std::cerr << "== writeMemory" << std::endl;
    o << int8_t(BinaryConsts::Memory) << int8_t(log2(wasm->memory.initial))
                                      << int8_t(log2(wasm->memory.max))
                                      << int8_t(1); // export memory
  }

  void writeSignatures() {
    if (debug) std::cerr << "== writeSignatures" << std::endl;
    o << int8_t(BinaryConsts::Signatures) << LEB128(wasm->functionTypes.size());
    for (auto type : wasm->functionTypes) {
      if (debug) std::cerr << "write one" << std::endl;
      o << int8_t(type->params.size());
      o << binaryWasmType(type->result);
      for (auto param : type->params) {
        o << binaryWasmType(param);
      }
    }
  }

  int16_t getFunctionTypeIndex(Name type) {
    // TODO: optimize
    for (size_t i = 0; i < wasm->functionTypes.size(); i++) {
      if (wasm->functionTypes[i]->name == type) return i;
    }
    abort();
  }

  std::map<Name, size_t> mappedLocals; // local name => index in compact form of [all int32s][all int64s]etc
  std::map<WasmType, size_t> numLocalsByType; // type => number of locals of that type in the compact form

  void mapLocals(Function* function) {
    for (auto& param : function->params) {
      size_t curr = mappedLocals.size();
      mappedLocals[param.name] = curr;
    }
    for (auto& local : function->locals) {
      numLocalsByType[local.type]++;
    }
    std::map<WasmType, size_t> currLocalsByType;
    for (auto& local : function->locals) {
      size_t index = function->params.size();
      Name name = local.name;
      WasmType type = local.type;
      currLocalsByType[type]++; // increment now for simplicity, must decrement it in returns
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

  void writeFunctions() {
    if (debug) std::cerr << "== writeFunctions" << std::endl;
    size_t total = wasm->imports.size() + wasm->functions.size();
    o << int8_t(BinaryConsts::Functions) << LEB128(total);
    for (size_t i = 0; i < total; i++) {
      if (debug) std::cerr << "write one at" << o.size() << std::endl;
      Import* import = i < wasm->imports.size() ? wasm->imports[i] : nullptr;
      Function* function = i >= wasm->imports.size() ? wasm->functions[i - wasm->imports.size()] : nullptr;
      Name name, type;
      if (import) {
        name = import->name;
        type = import->type->name;
      } else {
        name = function->name;
        type = function->type;
      }
      if (debug) std::cerr << "writing" << name << std::endl;
      o << getFunctionTypeIndex(type);
      o << int8_t(BinaryConsts::Named |
                  (BinaryConsts::Import * !!import) |
                  (BinaryConsts::Locals * (function && function->locals.size() > 0)) |
                  (BinaryConsts::Export * (wasm->exportsMap.count(name) > 0)));
      emitString(name.str);
      if (function && function->locals.size() > 0) {
        mapLocals(function);
        o << uint16_t(numLocalsByType[i32])
          << uint16_t(numLocalsByType[i64])
          << uint16_t(numLocalsByType[f32])
          << uint16_t(numLocalsByType[f64]);
      }
      if (function) {
        size_t sizePos = o.size();
        o << (uint16_t)0; // placeholder
        size_t start = o.size();
        visit(function->body);
        size_t size = o.size() - start;
        assert(size <= std::numeric_limits<uint16_t>::max());
        if (debug) std::cerr << "body size: " << size << ", writing at " << sizePos << ", next starts at " << o.size() << std::endl;
        o.writeAt(sizePos, uint16_t(size));
      }
    }
  }

  void writeDataSegments() {
    o << int8_t(BinaryConsts::DataSegments) << LEB128(wasm->memory.segments.size());
    for (auto& segment : wasm->memory.segments) {
      o << int32_t(segment.offset);
      emitBuffer(segment.data, segment.size);
      o << int32_t(segment.size);
      o << int8_t(1); // load at program start
    }
  }

  uint16_t getFunctionIndex(Name name) {
    // TODO: optimize
    for (size_t i = 0; i < wasm->imports.size(); i++) {
      if (wasm->imports[i]->name == name) return i;
    }
    for (size_t i = 0; i < wasm->functions.size(); i++) {
      if (wasm->functions[i]->name == name) return wasm->imports.size() + i;
    }
    abort();
  }

  void writeFunctionTable() {
    if (debug) std::cerr << "== writeFunctionTable" << std::endl;
    o << int8_t(BinaryConsts::FunctionTable) << LEB128(wasm->table.names.size());
    for (auto name : wasm->table.names) {
      o << getFunctionIndex(name);
    }
  }

  void writeEnd() {
    o << int8_t(BinaryConsts::End);
  }

  // helpers

  struct Buffer {
    const char* data;
    size_t size;
    size_t pointerLocation;
    Buffer(const char* data, size_t size, size_t pointerLocation) : data(data), size(size), pointerLocation(pointerLocation) {}
  };

  std::vector<Buffer> buffersToWrite;

  void emitBuffer(const char* data, size_t size) {
    assert(size > 0);
    buffersToWrite.emplace_back(data, size, o.size());
    o << uint32_t(0); // placeholder
  }

  void emitString(const char *str) {
    if (debug) std::cerr << "emitString " << str << std::endl;
    emitBuffer(str, strlen(str) + 1);
  }

  void finishUp() {
    if (debug) std::cerr << "finishUp" << std::endl;
    // finish buffers
    for (auto& buffer : buffersToWrite) {
      if (debug) std::cerr << "writing buffer" << (int)buffer.data[0] << "," << (int)buffer.data[1] << " at " << o.size() << " and pointer is at " << buffer.pointerLocation << std::endl;
      o.writeAt(buffer.pointerLocation, (uint32_t)o.size());
      for (size_t i = 0; i < buffer.size; i++) {
        o << (uint8_t)buffer.data[i];
      }
    }
  }

  // AST writing via visitors

  std::vector<Name> breakStack;

  void visitBlock(Block *curr) {
    if (debug) std::cerr << "Block" << std::endl;
    o << int8_t(BinaryConsts::Block) << int8_t(curr->list.size());
    breakStack.push_back(curr->name);
    for (auto child : curr->list) {
      visit(child);
    }
    breakStack.pop_back();
  }
  void visitIf(If *curr) {
    if (debug) std::cerr << "If" << std::endl;
    o << int8_t(curr->ifFalse ? BinaryConsts::IfElse : BinaryConsts::If);
    visit(curr->condition);
    visit(curr->ifTrue);
    if (curr->ifFalse) visit(curr->ifFalse);
  }
  void visitLoop(Loop *curr) {
    if (debug) std::cerr << "Loop" << std::endl;
    // TODO: optimize, as we usually have a block as our singleton child
    o << int8_t(BinaryConsts::Loop) << int8_t(1);
    breakStack.push_back(curr->out);
    breakStack.push_back(curr->in);
    visit(curr->body);
    breakStack.pop_back();
    breakStack.pop_back();
  }
  void visitBreak(Break *curr) {
    if (debug) std::cerr << "Break" << std::endl;
    o << int8_t(curr->condition ? BinaryConsts::BrIf : BinaryConsts::Br);
    for (int i = breakStack.size() - 1; i >= 0; i--) {
      if (breakStack[i] == curr->name) {
        o << int8_t(breakStack.size() - 1 - i);
        return;
      }
    }
    if (curr->condition) visit(curr->condition);
  }
  void visitSwitch(Switch *curr) {
    if (debug) std::cerr << "Switch" << std::endl;
    o << int8_t(BinaryConsts::TableSwitch) << int16_t(curr->cases.size())
                                           << int16_t(curr->targets.size());
    std::map<Name, int16_t> mapping; // target name => index in cases
    for (size_t i = 0; i < curr->cases.size(); i++) {
      mapping[curr->cases[i].name] = i;
    }
    for (auto target : curr->targets) {
      o << mapping[target];
    }
    visit(curr->value);
    for (auto c : curr->cases) {
      visit(c.body);
    }
  }
  void visitCall(Call *curr) {
    if (debug) std::cerr << "Call" << std::endl;
    o << int8_t(BinaryConsts::CallFunction) << LEB128(getFunctionIndex(curr->target));
    for (auto operand : curr->operands) {
      visit(operand);
    }
  }
  void visitCallImport(CallImport *curr) {
    if (debug) std::cerr << "CallImport" << std::endl;
    o << int8_t(BinaryConsts::CallFunction) << LEB128(getFunctionIndex(curr->target));
    for (auto operand : curr->operands) {
      visit(operand);
    }
  }
  void visitCallIndirect(CallIndirect *curr) {
    if (debug) std::cerr << "CallIndirect" << std::endl;
    o << int8_t(BinaryConsts::CallFunction) << LEB128(getFunctionTypeIndex(curr->fullType->name));
    visit(curr->target);
    for (auto operand : curr->operands) {
      visit(operand);
    }
  }
  void visitGetLocal(GetLocal *curr) {
    if (debug) std::cerr << "GetLocal" << std::endl;
    o << int8_t(BinaryConsts::GetLocal) << LEB128(mappedLocals[curr->name]);
  }
  void visitSetLocal(SetLocal *curr) {
    if (debug) std::cerr << "SetLocal" << std::endl;
    o << int8_t(BinaryConsts::SetLocal) << LEB128(mappedLocals[curr->name]);
    visit(curr->value);
  }

  void emitMemoryAccess(size_t alignment, size_t bytes, uint32_t offset) {
    o << int8_t( ((alignment == bytes || alignment == 0) ? 0 : BinaryConsts::Alignment) |
                 (offset ? BinaryConsts::Offset : 0) );
    if (offset) o << LEB128(offset);
  }

  void visitLoad(Load *curr) {
    if (debug) std::cerr << "Load" << std::endl;
    switch (curr->type) {
      case i32: {
        switch (curr->bytes) {
          case 1: o << int8_t(curr->signed_ ? BinaryConsts::I32LoadMem8S : BinaryConsts::I32LoadMem8U); break;
          case 2: o << int8_t(curr->signed_ ? BinaryConsts::I32LoadMem16S : BinaryConsts::I32LoadMem16U); break;
          case 4: o << int8_t(BinaryConsts::I32LoadMem); break;
          default: abort();
        }
        break;
      }
      case i64: {
        switch (curr->bytes) {
          case 1: o << int8_t(curr->signed_ ? BinaryConsts::I64LoadMem8S : BinaryConsts::I64LoadMem8U); break;
          case 2: o << int8_t(curr->signed_ ? BinaryConsts::I64LoadMem16S : BinaryConsts::I64LoadMem16U); break;
          case 4: o << int8_t(curr->signed_ ? BinaryConsts::I64LoadMem32S : BinaryConsts::I64LoadMem32U); break;
          case 8: o << int8_t(BinaryConsts::I64LoadMem); break;
          default: abort();
        }
        break;
      }
      case f32: o << int8_t(BinaryConsts::F32LoadMem); break;
      case f64: o << int8_t(BinaryConsts::F64LoadMem); break;
      default: abort();
    }
    emitMemoryAccess(curr->align, curr->bytes, curr->offset);
    visit(curr->ptr);
  }
  void visitStore(Store *curr) {
    if (debug) std::cerr << "Store" << std::endl;
    switch (curr->type) {
      case i32: {
        switch (curr->bytes) {
          case 1: o << int8_t(BinaryConsts::I32StoreMem8); break;
          case 2: o << int8_t(BinaryConsts::I32StoreMem16); break;
          case 4: o << int8_t(BinaryConsts::I32StoreMem); break;
          default: abort();
        }
        break;
      }
      case i64: {
        switch (curr->bytes) {
          case 1: o << int8_t(BinaryConsts::I64StoreMem8); break;
          case 2: o << int8_t(BinaryConsts::I64StoreMem16); break;
          case 4: o << int8_t(BinaryConsts::I64StoreMem32); break;
          case 8: o << int8_t(BinaryConsts::I64StoreMem); break;
          default: abort();
        }
        break;
      }
      case f32: o << int8_t(BinaryConsts::F32StoreMem); break;
      case f64: o << int8_t(BinaryConsts::F64StoreMem); break;
      default: abort();
    }
    emitMemoryAccess(curr->align, curr->bytes, curr->offset);
    visit(curr->ptr);
    visit(curr->value);
  }
  void visitConst(Const *curr) {
    if (debug) std::cerr << "Const" << std::endl;
    switch (curr->type) {
      case i32: {
        int32_t value = curr->value.i32;
        if (value >= -128 && value <= 127) {
          o << int8_t(BinaryConsts::I8Const) << int8_t(value);
          break;
        }
        o << int8_t(BinaryConsts::I32Const) << value;
        break;
      }
      case i64: {
        o << int8_t(BinaryConsts::I64Const) << curr->value.i64;
        break;
      }
      case f32: {
        o << int8_t(BinaryConsts::F32Const) << curr->value.f32;
        break;
      }
      case f64: {
        o << int8_t(BinaryConsts::F64Const) << curr->value.f64;
        break;
      }
      default: abort();
    }
  }
  void visitUnary(Unary *curr) {
    if (debug) std::cerr << "Unary" << std::endl;
    switch (curr->op) {
      case Clz:              o << int8_t(curr->type == i32 ? BinaryConsts::I32Clz        : BinaryConsts::I64Clz); break;
      case Ctz:              o << int8_t(curr->type == i32 ? BinaryConsts::I32Ctz        : BinaryConsts::I64Ctz); break;
      case Popcnt:           o << int8_t(curr->type == i32 ? BinaryConsts::I32Popcnt     : BinaryConsts::I64Popcnt); break;
      case Neg:              o << int8_t(curr->type == f32 ? BinaryConsts::F32Neg        : BinaryConsts::F64Neg); break;
      case Abs:              o << int8_t(curr->type == f32 ? BinaryConsts::F32Abs        : BinaryConsts::F64Abs); break;
      case Ceil:             o << int8_t(curr->type == f32 ? BinaryConsts::F32Ceil       : BinaryConsts::F64Ceil); break;
      case Floor:            o << int8_t(curr->type == f32 ? BinaryConsts::F32Floor      : BinaryConsts::F64Floor); break;
      case Trunc:            o << int8_t(curr->type == f32 ? BinaryConsts::F32Trunc      : BinaryConsts::F64Trunc); break;;
      case Nearest:          o << int8_t(curr->type == f32 ? BinaryConsts::F32NearestInt : BinaryConsts::F64NearestInt); break;
      case Sqrt:             o << int8_t(curr->type == f32 ? BinaryConsts::F32Sqrt       : BinaryConsts::F64Sqrt); break;
      case ExtendSInt32:     abort(); break;
      case ExtendUInt32:     abort(); break;
      case WrapInt64:        abort(); break;
      case TruncSFloat32:    abort(); // XXX no signe/dunsigned versions of trunc?
      case TruncUFloat32:    abort(); // XXX
      case TruncSFloat64:    abort(); // XXX
      case TruncUFloat64:    abort(); // XXX
      case ReinterpretFloat: abort(); // XXX missing
      case ConvertUInt32:    o << int8_t(curr->type == f32 ? BinaryConsts::I32UConvertF32 : BinaryConsts::I32UConvertF64); break;
      case ConvertSInt32:    o << int8_t(curr->type == f32 ? BinaryConsts::I32SConvertF32 : BinaryConsts::I32SConvertF64); break;
      case ConvertUInt64:    o << int8_t(curr->type == f32 ? BinaryConsts::I64UConvertF32 : BinaryConsts::I64UConvertF64); break;
      case ConvertSInt64:    o << int8_t(curr->type == f32 ? BinaryConsts::I64UConvertF32 : BinaryConsts::I64UConvertF64); break;
      case PromoteFloat32:   abort(); // XXX
      case DemoteFloat64:    abort(); // XXX
      case ReinterpretInt:   abort(); // XXX
      default: abort();
    }
    visit(curr->value);
  }
  void visitBinary(Binary *curr) {
    if (debug) std::cerr << "Binary" << std::endl;
    #define TYPED_CODE(code) { \
      switch (curr->left->type) { \
        case i32: o << int8_t(BinaryConsts::I32##code); break; \
        case i64: o << int8_t(BinaryConsts::I64##code); break; \
        case f32: o << int8_t(BinaryConsts::F32##code); break; \
        case f64: o << int8_t(BinaryConsts::F64##code); break; \
        default: abort(); \
      } \
      break; \
    }
    #define INT_TYPED_CODE(code) { \
      switch (curr->left->type) { \
        case i32: o << int8_t(BinaryConsts::I32##code); break; \
        case i64: o << int8_t(BinaryConsts::I64##code); break; \
        default: abort(); \
      } \
      break; \
    }
    #define FLOAT_TYPED_CODE(code) { \
      switch (curr->left->type) { \
        case f32: o << int8_t(BinaryConsts::F32##code); break; \
        case f64: o << int8_t(BinaryConsts::F64##code); break; \
        default: abort(); \
      } \
      break; \
    }

    switch (curr->op) {
      case Add:      TYPED_CODE(Add);
      case Sub:      TYPED_CODE(Sub);
      case Mul:      TYPED_CODE(Mul);
      case DivS:     o << int8_t(curr->type == i32 ? BinaryConsts::I32DivS     : BinaryConsts::I64DivS); break;
      case DivU:     o << int8_t(curr->type == i32 ? BinaryConsts::I32DivU     : BinaryConsts::I64DivU); break;
      case RemS:     o << int8_t(curr->type == i32 ? BinaryConsts::I32RemS     : BinaryConsts::I64RemS); break;
      case RemU:     o << int8_t(curr->type == i32 ? BinaryConsts::I32RemU     : BinaryConsts::I64RemU); break;
      case And:      o << int8_t(curr->type == i32 ? BinaryConsts::I32And      : BinaryConsts::I64And); break;
      case Or:       o << int8_t(curr->type == i32 ? BinaryConsts::I32Or       : BinaryConsts::I64Or); break;
      case Xor:      o << int8_t(curr->type == i32 ? BinaryConsts::I32Xor      : BinaryConsts::I64Xor); break;
      case Shl:      o << int8_t(curr->type == i32 ? BinaryConsts::I32Shl      : BinaryConsts::I64Shl); break;
      case ShrU:     o << int8_t(curr->type == i32 ? BinaryConsts::I32ShrU     : BinaryConsts::I64ShrU); break;
      case ShrS:     o << int8_t(curr->type == i32 ? BinaryConsts::I32ShrS     : BinaryConsts::I64ShrS); break;
      case Div:      o << int8_t(curr->type == f32 ? BinaryConsts::F32Div      : BinaryConsts::F64Div); break;
      case CopySign: o << int8_t(curr->type == f32 ? BinaryConsts::F32CopySign : BinaryConsts::F64CopySign); break;
      case Min:      o << int8_t(curr->type == f32 ? BinaryConsts::F32Min      : BinaryConsts::F64Min); break;
      case Max:      o << int8_t(curr->type == f32 ? BinaryConsts::F32Max      : BinaryConsts::F64Max); break;
      case Eq:       TYPED_CODE(Eq);
      case Ne:       TYPED_CODE(Ne);
      case LtS:      INT_TYPED_CODE(LtS);
      case LtU:      INT_TYPED_CODE(LtU);
      case LeS:      INT_TYPED_CODE(LeS);
      case LeU:      INT_TYPED_CODE(LeU);
      case GtS:      INT_TYPED_CODE(GtS);
      case GtU:      INT_TYPED_CODE(GtU);
      case GeS:      INT_TYPED_CODE(GeS);
      case GeU:      INT_TYPED_CODE(GeU);
      case Lt:       FLOAT_TYPED_CODE(Lt);
      case Le:       FLOAT_TYPED_CODE(Le);
      case Gt:       FLOAT_TYPED_CODE(Gt);
      case Ge:       FLOAT_TYPED_CODE(Ge);
      default:       abort();
    }
    visit(curr->left);
    visit(curr->right);
    #undef TYPED_CODE
    #undef INT_TYPED_CODE
    #undef FLOAT_TYPED_CODE
  }
  void visitSelect(Select *curr) {
    if (debug) std::cerr << "Select" << std::endl;
    o << int8_t(BinaryConsts::Select);
    visit(curr->ifTrue);
    visit(curr->ifFalse);
    visit(curr->condition);
  }
  void visitHost(Host *curr) {
    if (debug) std::cerr << "Host" << std::endl;
    switch (curr->op) {
      case MemorySize: {
        o << int8_t(BinaryConsts::MemorySize);
        break;
      }
      case GrowMemory: {
        o << int8_t(BinaryConsts::GrowMemory);
        visit(curr->operands[0]);
        break;
      }
      default: abort();
    }
  }
  void visitNop(Nop *curr) {
    if (debug) std::cerr << "Nop" << std::endl;
    o << int8_t(BinaryConsts::Nop);
  }
  void visitUnreachable(Unreachable *curr) {
    if (debug) std::cerr << "Unreachable" << std::endl;
    o << int8_t(BinaryConsts::Unreachable);
  }
};

class WasmBinaryBuilder {
  AllocatingModule& wasm;
  MixedArena& allocator;
  std::vector<char>& input;
  bool debug;

  size_t pos;

public:
  WasmBinaryBuilder(AllocatingModule& wasm, std::vector<char>& input, bool debug) : wasm(wasm), allocator(wasm.allocator), input(input), debug(debug), pos(0) {}

  void read() {
    readMemory();
    readSignatures();
    readFunctions();
    readDataSegments();
    readFunctionTable();
    readEnd();

    processFunctions();
  }

  uint8_t getInt8() {
    assert(pos < input.size());
    if (debug) std::cerr << "getInt8: " << (int)(uint8_t)input[pos] << std::endl;
    return input[pos++];
  }
  uint16_t getInt16() {
    if (debug) std::cerr << "<==" << std::endl;
    auto ret = uint16_t(getInt8()) | (uint16_t(getInt8()) << 8);
    if (debug) std::cerr << "getInt16: " << ret << " ==>" << std::endl;
    return ret;
  }
  uint32_t getInt32() {
    if (debug) std::cerr << "<==" << std::endl;
    auto ret = uint32_t(getInt16()) | (uint32_t(getInt16()) << 16);
    if (debug) std::cerr << "getInt32: " << ret << " ==>" << std::endl;
    return ret;
  }
  uint64_t getInt64() {
    if (debug) std::cerr << "<==" << std::endl;
    auto ret = uint64_t(getInt32()) | (uint64_t(getInt32()) << 32);
    if (debug) std::cerr << "getInt64: " << ret << " ==>" << std::endl;
    return ret;
  }
  float getFloat32() {
    if (debug) std::cerr << "<==" << std::endl;
    auto ret = Literal(getInt32()).reinterpretf32();
    if (debug) std::cerr << "getFloat32: " << ret << " ==>" << std::endl;
    return ret;
  }
  double getFloat64() {
    if (debug) std::cerr << "<==" << std::endl;
    auto ret = Literal(getInt64()).reinterpretf64();
    if (debug) std::cerr << "getFloat64: " << ret << " ==>" << std::endl;
    return ret;
  }

  uint32_t getLEB128() {
    if (debug) std::cerr << "<==" << std::endl;
    LEB128 ret;
    ret.read([&]() {
      return getInt8();
    });
    if (debug) std::cerr << "getLEB128: " << ret.value << " ==>" << std::endl;
    return ret.value;
  }
  WasmType getWasmType() {
    int8_t type = getInt8();
    switch (type) {
      case 0: return none;
      case 1: return i32;
      case 2: return i64;
      case 3: return f32;
      case 4: return f64;
      default: abort();
    }
  }

  Name getString() {
    if (debug) std::cerr << "<==" << std::endl;
    size_t offset = getInt32();
    Name ret = cashew::IString((&input[0]) + offset, false);
    if (debug) std::cerr << "getString: " << ret << " ==>" << std::endl;
    return ret;
  }

  void verifyInt8(int8_t x) {
    int8_t y = getInt8();
    assert(x == y);
  }
  void verifyInt16(int16_t x) {
    int16_t y = getInt16();
    assert(x == y);
  }
  void verifyInt32(int32_t x) {
    int32_t y = getInt32();
    assert(x == y);
  }
  void verifyInt64(int64_t x) {
    int64_t y = getInt64();
    assert(x == y);
  }
  void verifyFloat32(float x) {
    float y = getFloat32();
    assert(x == y);
  }
  void verifyFloat64(double x) {
    double y = getFloat64();
    assert(x == y);
  }

  void readMemory() {
    if (debug) std::cerr << "== readMemory" << std::endl;
    verifyInt8(BinaryConsts::Memory);
    wasm.memory.initial = pow(2, getInt8());
    wasm.memory.max = pow(2, getInt8());
    verifyInt8(1); // export memory
  }

  void readSignatures() {
    if (debug) std::cerr << "== readSignatures" << std::endl;
    verifyInt8(BinaryConsts::Signatures);
    size_t numTypes = getLEB128();
    if (debug) std::cerr << "num: " << numTypes << std::endl;
    for (size_t i = 0; i < numTypes; i++) {
      if (debug) std::cerr << "read one" << std::endl;
      auto curr = allocator.alloc<FunctionType>();
      size_t numParams = getInt8();
      if (debug) std::cerr << "num params: " << numParams << std::endl;
      curr->result = getWasmType();
      for (size_t j = 0; j < numParams; j++) {
        curr->params.push_back(getWasmType());
      }
      wasm.addFunctionType(curr);
    }
  }

  std::vector<Name> mappedFunctions; // index => name of the Import or Function

  size_t nextLabel;

  Name getNextLabel() {
    return cashew::IString(("label$" + std::to_string(nextLabel++)).c_str(), false);
  }

  void readFunctions() {
    if (debug) std::cerr << "== readFunctions" << std::endl;
    verifyInt8(BinaryConsts::Functions);
    size_t total = getLEB128(); // imports and functions
    for (size_t i = 0; i < total; i++) {
      if (debug) std::cerr << "read one at " << pos << std::endl;
      auto type = wasm.functionTypes[getInt16()];
      auto data = getInt8();
      bool named = data & BinaryConsts::Named;
      assert(named);
      bool import = data & BinaryConsts::Import;
      bool locals = data & BinaryConsts::Locals;
      bool export_ = data & BinaryConsts::Export;
      Name name = getString();
      if (debug) std::cerr << "reading" << name << std::endl;
      mappedFunctions.push_back(name);
      if (import) {
        auto imp = allocator.alloc<Import>();
        imp->name = name;
        imp->type = type;
        wasm.addImport(imp);
      } else {
        auto func = allocator.alloc<Function>();
        func->name = name;
        func->type = type->name;
        size_t nextVar = 0;
        auto addVar = [&]() {
          Name name = cashew::IString(("var$" + std::to_string(nextVar++)).c_str(), false);
          return name;
        };
        for (size_t j = 0; j < type->params.size(); j++) {
          func->params.emplace_back(addVar(), type->params[j]);
        }
        if (locals) {
          auto addLocals = [&](WasmType type) {
            int16_t num = getInt16();
            while (num > 0) {
              func->locals.emplace_back(addVar(), type);
              num--;
            }
          };
          addLocals(i32);
          addLocals(i64);
          addLocals(f32);
          addLocals(f64);
        }
        size_t size = getInt16();
        // we can't read the function yet - it might call other functions that are defined later,
        // and we do depend on the function type, as well as the mappedFunctions table.
        functions.emplace_back(func, pos, size);
        pos += size;
        func->body = nullptr; // will be filled later. but we do have the name and the type already.
        wasm.addFunction(func);
      }
      if (export_) {
        auto e = allocator.alloc<Export>();
        e->name = name;
        e->value = name;
        wasm.addExport(e);
      }
    }
  }

  struct FunctionData {
    Function* func;
    size_t pos, size;
    FunctionData(Function* func, size_t pos, size_t size) : func(func), pos(pos), size(size) {}
  };

  std::vector<FunctionData> functions;

  std::vector<Name> mappedLocals; // index => local name

  std::vector<Name> breakStack;

  void processFunctions() {
    for (auto& func : functions) {
      Function* curr = func.func;
      pos = func.pos;
      nextLabel = 0;
      // prepare locals
      for (size_t i = 0; i < curr->params.size(); i++) {
        mappedLocals.push_back(curr->params[i].name);
      }
      for (size_t i = 0; i < curr->locals.size(); i++) {
        mappedLocals.push_back(curr->locals[i].name);
      }
      // process body
      assert(breakStack.empty());
      readExpression(curr->body);
      assert(breakStack.empty());
      assert(pos == func.pos + func.size);
    }
  }

  void readDataSegments() {
    if (debug) std::cerr << "== readDataSegments" << std::endl;
    verifyInt8(BinaryConsts::DataSegments);
    auto num = getLEB128();
    for (size_t i = 0; i < num; i++) {
      auto curr = allocator.alloc<Memory::Segment>();
      curr->offset = getInt32();
      auto start = getInt32();
      auto size = getInt32();
      auto buffer = malloc(size);
      memcpy(buffer, &input[start], size);
      curr->data = (const char*)buffer;
      curr->size = size;
      verifyInt8(1); // load at program start
    }
  }

  void readFunctionTable() {
    if (debug) std::cerr << "== readFunctionTable" << std::endl;
    verifyInt8(BinaryConsts::FunctionTable);
    auto num = getLEB128();
    for (size_t i = 0; i < num; i++) {
      wasm.table.names.push_back(mappedFunctions[getInt16()]);
    }
  }

  void readEnd() {
    if (debug) std::cerr << "== readEnd" << std::endl;
    verifyInt8(BinaryConsts::End);
  }

  // AST reading

  void readExpression(Expression*& curr) {
    uint8_t code = getInt8();
    if (debug) std::cerr << "readExpression seeing " << (int)code << std::endl;
    switch (code) {
      case BinaryConsts::Block:        return visitBlock((curr = allocator.alloc<Block>())->cast<Block>());
      case BinaryConsts::If:
      case BinaryConsts::IfElse:       return visitIf((curr = allocator.alloc<If>())->cast<If>(), code); // code distinguishes if from if_else
      case BinaryConsts::Loop:         return visitLoop((curr = allocator.alloc<Loop>())->cast<Loop>());
      case BinaryConsts::Br:
      case BinaryConsts::BrIf:         return visitBreak((curr = allocator.alloc<Break>())->cast<Break>(), code); // code distinguishes br from br_if
      case BinaryConsts::TableSwitch:  return visitSwitch((curr = allocator.alloc<Switch>())->cast<Switch>());
      case BinaryConsts::CallFunction: {
        // might be an import or not. we have to check here.
        Name target = mappedFunctions[getLEB128()];
        assert(target.is());
        if (debug) std::cerr << "call(import?) target: " << target << std::endl;
        if (wasm.importsMap.find(target) == wasm.importsMap.end()) {
          return visitCall((curr = allocator.alloc<Call>())->cast<Call>(), target);
        } else {
          assert(wasm.functionsMap.find(target) != wasm.functionsMap.end());
          return visitCallImport((curr = allocator.alloc<CallImport>())->cast<CallImport>(), target);
        }
      }
      case BinaryConsts::CallIndirect: return visitCallIndirect((curr = allocator.alloc<CallIndirect>())->cast<CallIndirect>());
      case BinaryConsts::GetLocal:     return visitGetLocal((curr = allocator.alloc<GetLocal>())->cast<GetLocal>());
      case BinaryConsts::SetLocal:     return visitSetLocal((curr = allocator.alloc<SetLocal>())->cast<SetLocal>());
      case BinaryConsts::Select:       return visitSelect((curr = allocator.alloc<Select>())->cast<Select>());
      case BinaryConsts::Nop:          return visitNop((curr = allocator.alloc<Nop>())->cast<Nop>());
      case BinaryConsts::Unreachable:  return visitUnreachable((curr = allocator.alloc<Unreachable>())->cast<Unreachable>());
    }
    // otherwise, the code is a subcode TODO: optimize
    if (maybeVisit<Binary>(curr, code)) return;
    if (maybeVisit<Unary>(curr, code)) return;
    if (maybeVisit<Const>(curr, code)) return;
    if (maybeVisit<Load>(curr, code)) return;
    if (maybeVisit<Store>(curr, code)) return;
    if (maybeVisit<Host>(curr, code)) return;
    abort();
  }

  template<typename T>
  bool maybeVisit(Expression*& curr, uint8_t code) {
    T temp;
    if (maybeVisitImpl(&temp, code)) {
      auto actual = allocator.alloc<T>();
      *actual = temp;
      curr = actual;
      return true;
    }
    return false;
  }

  void visitBlock(Block *curr) {
    if (debug) std::cerr << "Block" << std::endl;
    auto num = getInt8();
    curr->name = getNextLabel();
    breakStack.push_back(curr->name);
    for (auto i = 0; i < num; i++) {
      Expression* child;
      readExpression(child);
      curr->list.push_back(child);
    }
    breakStack.pop_back();
  }
  void visitIf(If *curr, uint8_t code) {
    if (debug) std::cerr << "If" << std::endl;
    readExpression(curr->condition);
    readExpression(curr->ifTrue);
    if (code == BinaryConsts::IfElse) readExpression(curr->ifFalse);
  }
  void visitLoop(Loop *curr) {
    if (debug) std::cerr << "Loop" << std::endl;
    verifyInt8(1); // size TODO: generalize
    curr->out = getNextLabel();
    curr->in = getNextLabel();
    breakStack.push_back(curr->out);
    breakStack.push_back(curr->in);
    readExpression(curr->body);
    breakStack.pop_back();
    breakStack.pop_back();
  }
  void visitBreak(Break *curr, uint8_t code) {
    if (debug) std::cerr << "Break" << std::endl;
    auto offset = getInt8();
    curr->name = breakStack[breakStack.size() - 1 - offset];
    if (code == BinaryConsts::BrIf) readExpression(curr->condition);
  }
  void visitSwitch(Switch *curr) {
    if (debug) std::cerr << "Switch" << std::endl;
    auto numCases = getInt16();
    auto numTargets = getInt16();
    std::map<size_t, Name> caseLabels;
    auto getCaseLabel = [&](size_t index) {
      if (caseLabels.find(index) == caseLabels.end()) {
        caseLabels[index] = getNextLabel();
      }
      return caseLabels[index];
    };
    for (auto i = 0; i < numTargets; i++) {
      curr->targets.push_back(getCaseLabel(getInt16()));
    }
    readExpression(curr->value);
    for (auto i = 0; i < numCases; i++) {
      Switch::Case c;
      c.name = getCaseLabel(i);
      readExpression(c.body);
      curr->cases.push_back(c);
    }
  }
  void visitCall(Call *curr, Name target) {
    if (debug) std::cerr << "Call" << std::endl;
    curr->target = target;
    Name type = wasm.functionsMap[curr->target]->type;
    auto num = wasm.functionTypesMap[type]->params.size();
    for (size_t i = 0; i < num; i++) {
      Expression* operand;
      readExpression(operand);
      curr->operands.push_back(operand);
    }
  }
  void visitCallImport(CallImport *curr, Name target) {
    if (debug) std::cerr << "CallImport" << std::endl;
    curr->target = target;
    Name type = wasm.functionsMap[curr->target]->type;
    auto num = wasm.functionTypesMap[type]->params.size();
    for (size_t i = 0; i < num; i++) {
      Expression* operand;
      readExpression(operand);
      curr->operands.push_back(operand);
    }
  }
  void visitCallIndirect(CallIndirect *curr) {
    if (debug) std::cerr << "CallIndirect" << std::endl;
    curr->fullType = wasm.functionTypes[getLEB128()];
    readExpression(curr->target);
    auto num = curr->fullType->params.size();
    for (size_t i = 0; i < num; i++) {
      Expression* operand;
      readExpression(operand);
      curr->operands.push_back(operand);
    }
  }
  void visitGetLocal(GetLocal *curr) {
    if (debug) std::cerr << "GetLocal" << std::endl;
    curr->name = mappedLocals[getLEB128()];
  }
  void visitSetLocal(SetLocal *curr) {
    if (debug) std::cerr << "SetLocal" << std::endl;
    curr->name = mappedLocals[getLEB128()];
    readExpression(curr->value);
  }

  void readMemoryAccess(uint32_t& alignment, size_t bytes, uint32_t& offset) {
    auto value = getInt8();
    alignment = value & BinaryConsts::Alignment ? 1 : bytes;
    if (value & BinaryConsts::Offset) {
      offset = getLEB128();
    } else {
      offset = 0;
    }
  }

  bool maybeVisitImpl(Load *curr, uint8_t code) {
    if (debug) std::cerr << "maybe Load" << std::endl;
    switch (code) {
      case BinaryConsts::I32LoadMem8S:  curr->bytes = 1; curr->type = i32; curr->signed_ = true; break;
      case BinaryConsts::I32LoadMem8U:  curr->bytes = 1; curr->type = i32; curr->signed_ = false; break;
      case BinaryConsts::I32LoadMem16S: curr->bytes = 2; curr->type = i32; curr->signed_ = true; break;
      case BinaryConsts::I32LoadMem16U: curr->bytes = 2; curr->type = i32; curr->signed_ = false; break;
      case BinaryConsts::I32LoadMem:    curr->bytes = 4; curr->type = i32; break;
      case BinaryConsts::I64LoadMem8S:  curr->bytes = 1; curr->type = i64; curr->signed_ = true; break;
      case BinaryConsts::I64LoadMem8U:  curr->bytes = 1; curr->type = i64; curr->signed_ = false; break;
      case BinaryConsts::I64LoadMem16S: curr->bytes = 2; curr->type = i64; curr->signed_ = true; break;
      case BinaryConsts::I64LoadMem16U: curr->bytes = 2; curr->type = i64; curr->signed_ = false; break;
      case BinaryConsts::I64LoadMem32S: curr->bytes = 4; curr->type = i64; curr->signed_ = true; break;
      case BinaryConsts::I64LoadMem32U: curr->bytes = 4; curr->type = i64; curr->signed_ = false; break;
      case BinaryConsts::I64LoadMem:    curr->bytes = 8; curr->type = i64; break;
      case BinaryConsts::F32LoadMem:    curr->bytes = 4; curr->type = f32; break;
      case BinaryConsts::F64LoadMem:    curr->bytes = 8; curr->type = f64; break;
      default: return false;
    }
    readMemoryAccess(curr->align, curr->bytes, curr->offset);
    readExpression(curr->ptr);
    return true;
  }
  bool maybeVisitImpl(Store *curr, uint8_t code) {
    if (debug) std::cerr << "maybe Store" << std::endl;
    switch (code) {
      case BinaryConsts::I32StoreMem8:  curr->bytes = 1; curr->type = i32; break;
      case BinaryConsts::I32StoreMem16: curr->bytes = 2; curr->type = i32; break;
      case BinaryConsts::I32StoreMem:   curr->bytes = 4; curr->type = i32; break;
      case BinaryConsts::I64StoreMem8:  curr->bytes = 1; curr->type = i64; break;
      case BinaryConsts::I64StoreMem16: curr->bytes = 2; curr->type = i64; break;
      case BinaryConsts::I64StoreMem32: curr->bytes = 4; curr->type = i64; break;
      case BinaryConsts::I64StoreMem:   curr->bytes = 8; curr->type = i64; break;
      case BinaryConsts::F32StoreMem:   curr->bytes = 4; curr->type = f32; break;
      case BinaryConsts::F64StoreMem:   curr->bytes = 8; curr->type = f64; break;
      default: return false;
    }
    readMemoryAccess(curr->align, curr->bytes, curr->offset);
    readExpression(curr->ptr);
    readExpression(curr->value);
    return true;
  }
  bool maybeVisitImpl(Const *curr, uint8_t code) {
    if (debug) std::cerr << "maybe Const" << std::endl;
    switch (code) {
      case BinaryConsts::I8Const:  curr->value.i32 = getInt8();    curr->type = i32; break;
      case BinaryConsts::I32Const: curr->value.i32 = getInt32();   curr->type = i32; break;
      case BinaryConsts::I64Const: curr->value.i64 = getInt64();   curr->type = i64; break;
      case BinaryConsts::F32Const: curr->value.f32 = getFloat32(); curr->type = f32; break;
      case BinaryConsts::F64Const: curr->value.f64 = getFloat64(); curr->type = f64; break;
      default: return false;
    }
    return true;
  }
  bool maybeVisitImpl(Unary *curr, uint8_t code) {
    if (debug) std::cerr << "maybe Unary" << std::endl;
    switch (code) {
      case BinaryConsts::I32Clz:         curr->op = Clz;           curr->type = i32; break;
      case BinaryConsts::I64Clz:         curr->op = Clz;           curr->type = i64; break;
      case BinaryConsts::I32Ctz:         curr->op = Ctz;           curr->type = i32; break;
      case BinaryConsts::I64Ctz:         curr->op = Ctz;           curr->type = i64; break;
      case BinaryConsts::I32Popcnt:      curr->op = Popcnt;        curr->type = i32; break;
      case BinaryConsts::I64Popcnt:      curr->op = Popcnt;        curr->type = i64; break;
      case BinaryConsts::F32Neg:         curr->op = Neg;           curr->type = f32; break;
      case BinaryConsts::F64Neg:         curr->op = Neg;           curr->type = f64; break;
      case BinaryConsts::F32Abs:         curr->op = Abs;           curr->type = f32; break;
      case BinaryConsts::F64Abs:         curr->op = Abs;           curr->type = f64; break;
      case BinaryConsts::F32Ceil:        curr->op = Ceil;          curr->type = f32; break;
      case BinaryConsts::F64Ceil:        curr->op = Ceil;          curr->type = f64; break;
      case BinaryConsts::F32Floor:       curr->op = Floor;         curr->type = f32; break;
      case BinaryConsts::F64Floor:       curr->op = Floor;         curr->type = f64; break;
      case BinaryConsts::F32NearestInt:  curr->op = Nearest;       curr->type = f32; break;
      case BinaryConsts::F64NearestInt:  curr->op = Nearest;       curr->type = f64; break;
      case BinaryConsts::F32Sqrt:        curr->op = Sqrt;          curr->type = f32; break;
      case BinaryConsts::F64Sqrt:        curr->op = Sqrt;          curr->type = f64; break;
      case BinaryConsts::I32UConvertF32: curr->op = ConvertUInt32; curr->type = f32; break;
      case BinaryConsts::I32UConvertF64: curr->op = ConvertUInt32; curr->type = f64; break;
      case BinaryConsts::I32SConvertF32: curr->op = ConvertSInt32; curr->type = f32; break;
      case BinaryConsts::I32SConvertF64: curr->op = ConvertSInt32; curr->type = f64; break;
      case BinaryConsts::I64UConvertF32: curr->op = ConvertUInt64; curr->type = f32; break;
      case BinaryConsts::I64UConvertF64: curr->op = ConvertUInt64; curr->type = f64; break;
      case BinaryConsts::I64SConvertF32: curr->op = ConvertSInt64; curr->type = f32; break;
      case BinaryConsts::I64SConvertF64: curr->op = ConvertSInt64; curr->type = f64; break;
      default: return false;
    }
    readExpression(curr->value);
    return true;
  }
  bool maybeVisitImpl(Binary *curr, uint8_t code) {
    if (debug) std::cerr << "maybe Binary" << std::endl;
    #define TYPED_CODE(code) { \
      case BinaryConsts::I32##code: curr->op = code; curr->type = i32; break; \
      case BinaryConsts::I64##code: curr->op = code; curr->type = i64; break; \
      case BinaryConsts::F32##code: curr->op = code; curr->type = f32; break; \
      case BinaryConsts::F64##code: curr->op = code; curr->type = f64; break; \
    }
    #define INT_TYPED_CODE(code) { \
      case BinaryConsts::I32##code: curr->op = code; curr->type = i32; break; \
      case BinaryConsts::I64##code: curr->op = code; curr->type = i64; break; \
    }
    #define FLOAT_TYPED_CODE(code) { \
      case BinaryConsts::F32##code: curr->op = code; curr->type = f32; break; \
      case BinaryConsts::F64##code: curr->op = code; curr->type = f64; break; \
    }
    switch (code) {
      TYPED_CODE(Add);
      TYPED_CODE(Sub);
      TYPED_CODE(Mul);
      INT_TYPED_CODE(DivS);
      INT_TYPED_CODE(DivU);
      INT_TYPED_CODE(RemS);
      INT_TYPED_CODE(RemU);
      INT_TYPED_CODE(And);
      INT_TYPED_CODE(Or);
      INT_TYPED_CODE(Xor);
      INT_TYPED_CODE(Shl);
      INT_TYPED_CODE(ShrU);
      INT_TYPED_CODE(ShrS);
      FLOAT_TYPED_CODE(Div);
      FLOAT_TYPED_CODE(CopySign);
      FLOAT_TYPED_CODE(Min);
      FLOAT_TYPED_CODE(Max);
      TYPED_CODE(Eq);
      TYPED_CODE(Ne);
      INT_TYPED_CODE(LtS);
      INT_TYPED_CODE(LtU);
      INT_TYPED_CODE(LeS);
      INT_TYPED_CODE(LeU);
      INT_TYPED_CODE(GtS);
      INT_TYPED_CODE(GtU);
      INT_TYPED_CODE(GeS);
      INT_TYPED_CODE(GeU);
      FLOAT_TYPED_CODE(Lt);
      FLOAT_TYPED_CODE(Le);
      FLOAT_TYPED_CODE(Gt);
      FLOAT_TYPED_CODE(Ge);
      default: return false;
    }
    readExpression(curr->left);
    readExpression(curr->right);
    return true;
    #undef TYPED_CODE
    #undef INT_TYPED_CODE
    #undef FLOAT_TYPED_CODE
  }
  void visitSelect(Select *curr) {
    if (debug) std::cerr << "Select" << std::endl;
    readExpression(curr->ifTrue);
    readExpression(curr->ifFalse);
    readExpression(curr->condition);
  }
  bool maybeVisitImpl(Host *curr, uint8_t code) {
    if (debug) std::cerr << "maybe Host" << std::endl;
    switch (code) {
      case BinaryConsts::MemorySize: curr->op = MemorySize; break;
      case BinaryConsts::GrowMemory: {
        curr->op = GrowMemory;
        readExpression(curr->operands[0]);
        break;
      }
      default: return false;
    }
    return true;
  }
  void visitNop(Nop *curr) {
    if (debug) std::cerr << "Nop" << std::endl;
  }
  void visitUnreachable(Unreachable *curr) {
    if (debug) std::cerr << "Unreachable" << std::endl;
  }
};

} // namespace wasm

#endif // wasm_wasm_binary_h

