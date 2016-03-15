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
      uint8_t byte = temp & 127;
      temp >>= 7;
      if (temp) {
        byte = byte | 128;
      }
      out->push_back(byte);
    } while (temp);
  }

  void writeAt(std::vector<uint8_t>* out, size_t at, size_t minimum = 0) {
    uint32_t temp = value;
    size_t offset = 0;
    bool more;
    do {
      uint8_t byte = temp & 127;
      temp >>= 7;
      more = temp || offset + 1 < minimum;
      if (more) {
        byte = byte | 128;
      }
      (*out)[at + offset] = byte;
      offset++;
    } while (more);
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
    if (debug) std::cerr << "writeInt8: " << (int)(uint8_t)x << " (at " << size() << ")" << std::endl;
    push_back(x);
    return *this;
  }
  BufferWithRandomAccess& operator<<(int16_t x) {
    if (debug) std::cerr << "writeInt16: " << x << " (at " << size() << ")" << std::endl;
    push_back(x & 0xff);
    push_back(x >> 8);
    return *this;
  }
  BufferWithRandomAccess& operator<<(int32_t x) {
    if (debug) std::cerr << "writeInt32: " << x << " (at " << size() << ")" << std::endl;
    push_back(x & 0xff); x >>= 8;
    push_back(x & 0xff); x >>= 8;
    push_back(x & 0xff); x >>= 8;
    push_back(x & 0xff);
    return *this;
  }
  BufferWithRandomAccess& operator<<(int64_t x) {
    if (debug) std::cerr << "writeInt64: " << x << " (at " << size() << ")" << std::endl;
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
    if (debug) std::cerr << "writeLEB128: " << x.value << " (at " << size() << ")" << std::endl;
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
    if (debug) std::cerr << "writeFloat32: " << x << " (at " << size() << ")" << std::endl;
    return *this << Literal(x).reinterpreti32();
  }
  BufferWithRandomAccess& operator<<(double x) {
    if (debug) std::cerr << "writeFloat64: " << x << " (at " << size() << ")" << std::endl;
    return *this << Literal(x).reinterpreti64();
  }

  void writeAt(size_t i, uint16_t x) {
    if (debug) std::cerr << "backpatchInt16: " << x << " (at " << i << ")" << std::endl;
    (*this)[i] = x & 0xff;
    (*this)[i+1] = x >> 8;
  }
  void writeAt(size_t i, uint32_t x) {
    if (debug) std::cerr << "backpatchInt32: " << x << " (at " << i << ")" << std::endl;
    (*this)[i] = x & 0xff; x >>= 8;
    (*this)[i+1] = x & 0xff; x >>= 8;
    (*this)[i+2] = x & 0xff; x >>= 8;
    (*this)[i+3] = x & 0xff;
  }
  void writeAt(size_t i, LEB128 x, size_t minimum = 0) {
    if (debug) std::cerr << "backpatchLEB128: " << x.value << " (at " << i << "), minimum " << minimum << std::endl;
    x.writeAt(this, i, minimum);
  }

  template <typename T>
  void writeTo(T& o) {
    for (auto c : *this) o << c;
  }
};

namespace BinaryConsts {

namespace Section {
  auto Memory = "memory";
  auto Signatures = "signatures";
  auto Functions = "functions"; // FIXME
  auto DataSegments = "data_segments";
  auto FunctionTable = "function_table";
  auto End = "end";
  auto Start = "start_function";
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

  I32SConvertF32      = 0x9d,
  I32SConvertF64      = 0x9e,
  I32UConvertF32      = 0x9f,
  I32UConvertF64      = 0xa0,
  I32ConvertI64       = 0xa1,
  I64SConvertF32      = 0xa2,
  I64SConvertF64      = 0xa3,
  I64UConvertF32      = 0xa4,
  I64UConvertF64      = 0xa5,
  I64SConvertI32      = 0xa6,
  I64UConvertI32      = 0xa7,
  F32SConvertI32      = 0xa8,
  F32UConvertI32      = 0xa9,
  F32SConvertI64      = 0xaa,
  F32UConvertI64      = 0xab,
  F32ConvertF64       = 0xac,
  F32ReinterpretI32   = 0xad,
  F64SConvertI32      = 0xae,
  F64UConvertI32      = 0xaf,
  F64SConvertI64      = 0xb0,
  F64UConvertI64      = 0xb1,
  F64ConvertF32       = 0xb2,
  F64ReinterpretI64   = 0xb3,
  I64ReinterpretF64   = 0xb5,
  I32RotR             = 0xb6,
  I32RotL             = 0xb7,
  I64RotR             = 0xb8,
  I64RotL             = 0xb9,
  I32ReinterpretF32   = 0xfe, // XXX not in v8 spec doc

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
  Unreachable = 0x15,
  EndMarker = 0xff
};

enum MemoryAccess {
  Offset = 0x10,     // bit 4
  Alignment = 0x80,  // bit 7
  NaturalAlignment = 0
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

class WasmBinaryWriter : public WasmVisitor<WasmBinaryWriter, void> {
  Module* wasm;
  BufferWithRandomAccess& o;
  bool debug;

  MixedArena allocator;

  void prepare() {
    // we need function types for all our functions
    for (auto* func : wasm->functions) {
      if (func->type.isNull()) {
        func->type = ensureFunctionType(getSig(func), wasm, allocator)->name;
      }
    }
  }

public:
  WasmBinaryWriter(Module* input, BufferWithRandomAccess& o, bool debug) : o(o), debug(debug) {
    wasm = allocator.alloc<Module>();
    *wasm = *input; // simple shallow copy; we won't be modifying any internals, just adding some function types, so this is fine
    prepare();
  }

  void write() {
    writeHeader();
    writeStart();
    writeMemory();
    writeSignatures();
    writeFunctions();
    writeDataSegments();
    writeFunctionTable();
    writeEnd();
    finishUp();
  }

  void writeHeader() {
    if (debug) std::cerr << "== writeHeader" << std::endl;
    o << int32_t(0x6d736100); // magic number \0asm
    o << int32_t(10);         // version number
  }

  int32_t startSection(const char* name) {
    // emit 5 bytes of 0, which we'll fill with LEB later
    int32_t ret = o.size();
    o << int32_t(0);
    o << int8_t(0);
    int32_t size = strlen(name);
    o << LEB128(size);
    for (int32_t i = 0; i < size; i++) {
      o << int8_t(name[i]);
    }
    return ret;
  }

  void finishSection(int32_t start) {
    int32_t size = o.size() - start - 5; // section size does not include the 5 bytes of the size field itself
    o.writeAt(start, LEB128(size), 5);
  }

  void writeStart() {
    if (!wasm->start.is()) return;
    if (debug) std::cerr << "== writeStart" << std::endl;
    auto start = startSection(BinaryConsts::Section::Start);
    emitString(wasm->start.str);
    finishSection(start);
  }

  void writeMemory() {
    if (wasm->memory.max == 0) return;
    if (debug) std::cerr << "== writeMemory" << std::endl;
    auto start = startSection(BinaryConsts::Section::Memory);
    o << LEB128(wasm->memory.initial)
      << LEB128(wasm->memory.max)
      << int8_t(1); // export memory
    finishSection(start);
  }

  void writeSignatures() {
    if (wasm->functionTypes.size() == 0) return;
    if (debug) std::cerr << "== writeSignatures" << std::endl;
    auto start = startSection(BinaryConsts::Section::Signatures);
    o << LEB128(wasm->functionTypes.size());
    for (auto* type : wasm->functionTypes) {
      if (debug) std::cerr << "write one" << std::endl;
      o << int8_t(type->params.size());
      o << binaryWasmType(type->result);
      for (auto param : type->params) {
        o << binaryWasmType(param);
      }
    }
    finishSection(start);
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
        continue;
      }
      index += numLocalsByType[i32];
      if (type == i64) {
        mappedLocals[name] = index + currLocalsByType[i64] - 1;
        continue;
      }
      index += numLocalsByType[i64];
      if (type == f32) {
        mappedLocals[name] = index + currLocalsByType[f32] - 1;
        continue;
      }
      index += numLocalsByType[f32];
      if (type == f64) {
        mappedLocals[name] = index + currLocalsByType[f64] - 1;
        continue;
      }
      abort();
    }
  }

  void writeFunctions() {
    if (wasm->functions.size() + wasm->imports.size() == 0) return;
    if (debug) std::cerr << "== writeFunctions" << std::endl;
    auto start = startSection(BinaryConsts::Section::Functions);
    size_t total = wasm->imports.size() + wasm->functions.size();
    o << LEB128(total);
    std::map<Name, Name> exportedFunctions;
    for (auto* e : wasm->exports) {
      exportedFunctions[e->value] = e->name;
    }
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
        mappedLocals.clear();
        numLocalsByType.clear();
      }
      if (debug) std::cerr << "writing" << name << std::endl;
      bool export_ = exportedFunctions.count(name) > 0;
      o << int8_t(BinaryConsts::Named |
                  (BinaryConsts::Import * !!import) |
                  (BinaryConsts::Locals * (function && function->locals.size() > 0)) |
                  (BinaryConsts::Export * export_));
      o << getFunctionTypeIndex(type);
      emitString(name.str);
      if (export_) emitString(exportedFunctions[name].str); // XXX addition to v8 binary format
      if (function) {
        mapLocals(function);
        if (function->locals.size() > 0) {
          o << uint16_t(numLocalsByType[i32])
            << uint16_t(numLocalsByType[i64])
            << uint16_t(numLocalsByType[f32])
            << uint16_t(numLocalsByType[f64]);
        }
        size_t sizePos = o.size();
        o << (uint32_t)0; // placeholder, we fill in the size later when we have it // XXX int32, diverge from v8 format, to get more code to compile
        size_t start = o.size();
        depth = 0;
        recurse(function->body);
        o << int8_t(BinaryConsts::EndMarker);
        assert(depth == 0);
        size_t size = o.size() - start;
        assert(size <= std::numeric_limits<uint32_t>::max());
        if (debug) std::cerr << "body size: " << size << ", writing at " << sizePos << ", next starts at " << o.size() << std::endl;
        o.writeAt(sizePos, uint32_t(size)); // XXX int32, diverge from v8 format, to get more code to compile
      } else {
        // import
        emitString(import->module.str); // XXX diverge
        emitString(import->base.str);   //     from v8
      }
    }
    finishSection(start);
  }

  void writeDataSegments() {
    if (wasm->memory.segments.size() == 0) return;
    uint32_t num = 0;
    for (auto& segment : wasm->memory.segments) {
      if (segment.size > 0) num++;
    }
    auto start = startSection(BinaryConsts::Section::DataSegments);
    o << LEB128(num);
    for (auto& segment : wasm->memory.segments) {
      if (segment.size == 0) continue;
      o << int32_t(segment.offset);
      emitBuffer(segment.data, segment.size);
      o << int32_t(segment.size);
      o << int8_t(1); // load at program start
    }
    finishSection(start);
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
    if (wasm->table.names.size() == 0) return;
    if (debug) std::cerr << "== writeFunctionTable" << std::endl;
    auto start = startSection(BinaryConsts::Section::FunctionTable);
    o << LEB128(wasm->table.names.size());
    for (auto name : wasm->table.names) {
      o << getFunctionIndex(name);
    }
    finishSection(start);
  }

  void writeEnd() {
    auto start = startSection(BinaryConsts::Section::End);
    finishSection(start);
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
    o << uint32_t(0); // placeholder, we'll fill in the pointer to the buffer later when we have it
  }

  void emitString(const char *str) {
    if (debug) std::cerr << "emitString " << str << std::endl;
    emitBuffer(str, strlen(str) + 1);
  }

  void finishUp() {
    if (debug) std::cerr << "finishUp" << std::endl;
    // finish buffers
    for (const auto& buffer : buffersToWrite) {
      if (debug) std::cerr << "writing buffer" << (int)buffer.data[0] << "," << (int)buffer.data[1] << " at " << o.size() << " and pointer is at " << buffer.pointerLocation << std::endl;
      o.writeAt(buffer.pointerLocation, (uint32_t)o.size());
      for (size_t i = 0; i < buffer.size; i++) {
        o << (uint8_t)buffer.data[i];
      }
    }
  }

  // AST writing via visitors

  int depth; // only for debugging

  void recurse(Expression*& curr) {
    if (debug) std::cerr << "zz recurse into " << ++depth << " at " << o.size() << std::endl;
    visit(curr);
    if (debug) std::cerr << "zz recurse from " << depth-- << " at " << o.size() << std::endl;
  }

  std::vector<Name> breakStack;

  void visitBlock(Block *curr) {
    if (debug) std::cerr << "zz node: Block" << std::endl;
    o << int8_t(BinaryConsts::Block);
    breakStack.push_back(curr->name);
    size_t i = 0;
    for (auto* child : curr->list) {
      if (debug) std::cerr << "  " << size_t(curr) << "\n zz Block element " << i++ << std::endl;
      recurse(child);
    }
    breakStack.pop_back();
    o << int8_t(BinaryConsts::EndMarker);
  }
  void visitIf(If *curr) {
    if (debug) std::cerr << "zz node: If" << std::endl;
    recurse(curr->condition);
    recurse(curr->ifTrue);
    if (curr->ifFalse) recurse(curr->ifFalse);
    o << int8_t(curr->ifFalse ? BinaryConsts::IfElse : BinaryConsts::If);
  }
  void visitLoop(Loop *curr) {
    if (debug) std::cerr << "zz node: Loop" << std::endl;
    // TODO: optimize, as we usually have a block as our singleton child
    o << int8_t(BinaryConsts::Loop) << int8_t(1);
    breakStack.push_back(curr->out);
    breakStack.push_back(curr->in);
    recurse(curr->body);
    breakStack.pop_back();
    breakStack.pop_back();
    o << int8_t(BinaryConsts::EndMarker);
  }

  int32_t getBreakIndex(Name name) { // -1 if not found
    for (int i = breakStack.size() - 1; i >= 0; i--) {
      if (breakStack[i] == name) {
        return breakStack.size() - 1 - i;
      }
    }
    std::cerr << "bad break: " << name << std::endl;
    abort();
  }

  void visitBreak(Break *curr) {
    if (debug) std::cerr << "zz node: Break" << std::endl;
    if (curr->value) {
      recurse(curr->value);
    } else {
      visitNop(nullptr);
    }
    if (curr->condition) recurse(curr->condition);
    o << int8_t(curr->condition ? BinaryConsts::BrIf : BinaryConsts::Br)
      << int32_t(getBreakIndex(curr->name));
  }
  void visitSwitch(Switch *curr) {
    if (debug) std::cerr << "zz node: Switch" << std::endl;
    o << int8_t(BinaryConsts::TableSwitch) << int16_t(curr->targets.size() + 1) << int8_t(curr->value != nullptr);
    for (auto target : curr->targets) {
      o << (int32_t)getBreakIndex(target);
    }
    o << (int32_t)getBreakIndex(curr->default_);
    recurse(curr->condition);
    o << int8_t(BinaryConsts::EndMarker);
    if (curr->value) {
      recurse(curr->value);
      o << int8_t(BinaryConsts::EndMarker);
    }
  }
  void visitCall(Call *curr) {
    if (debug) std::cerr << "zz node: Call" << std::endl;
    for (auto* operand : curr->operands) {
      recurse(operand);
    }
    o << int8_t(BinaryConsts::CallFunction) << LEB128(getFunctionIndex(curr->target));
  }
  void visitCallImport(CallImport *curr) {
    if (debug) std::cerr << "zz node: CallImport" << std::endl;
    for (auto* operand : curr->operands) {
      recurse(operand);
    }
    o << int8_t(BinaryConsts::CallFunction) << LEB128(getFunctionIndex(curr->target));
  }
  void visitCallIndirect(CallIndirect *curr) {
    if (debug) std::cerr << "zz node: CallIndirect" << std::endl;
    recurse(curr->target);
    for (auto* operand : curr->operands) {
      recurse(operand);
    }
    o << int8_t(BinaryConsts::CallIndirect) << LEB128(getFunctionTypeIndex(curr->fullType->name));
  }
  void visitGetLocal(GetLocal *curr) {
    if (debug) std::cerr << "zz node: GetLocal " << (o.size() + 1) << std::endl;
    o << int8_t(BinaryConsts::GetLocal) << LEB128(mappedLocals[curr->name]);
  }
  void visitSetLocal(SetLocal *curr) {
    if (debug) std::cerr << "zz node: SetLocal" << std::endl;
    recurse(curr->value);
    o << int8_t(BinaryConsts::SetLocal) << LEB128(mappedLocals[curr->name]);
  }

  void emitMemoryAccess(size_t alignment, size_t bytes, uint32_t offset) {
    o << int8_t( ((alignment == bytes || alignment == 0) ? BinaryConsts::NaturalAlignment : BinaryConsts::Alignment) |
                 (offset ? BinaryConsts::Offset : 0) );
    if (offset) o << LEB128(offset);
  }

  void visitLoad(Load *curr) {
    if (debug) std::cerr << "zz node: Load" << std::endl;
    recurse(curr->ptr);
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
  }
  void visitStore(Store *curr) {
    if (debug) std::cerr << "zz node: Store" << std::endl;
    recurse(curr->ptr);
    recurse(curr->value);
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
  }
  void visitConst(Const *curr) {
    if (debug) std::cerr << "zz node: Const" << curr << " : " << curr->type << std::endl;
    switch (curr->type) {
      case i32: {
        uint32_t value = curr->value.geti32();
        if (value <= 255) {
          o << int8_t(BinaryConsts::I8Const) << uint8_t(value);
          break;
        }
        o << int8_t(BinaryConsts::I32Const) << value;
        break;
      }
      case i64: {
        o << int8_t(BinaryConsts::I64Const) << curr->value.geti64();
        break;
      }
      case f32: {
        o << int8_t(BinaryConsts::F32Const) << curr->value.getf32();
        break;
      }
      case f64: {
        o << int8_t(BinaryConsts::F64Const) << curr->value.getf64();
        break;
      }
      default: abort();
    }
    if (debug) std::cerr << "zz const node done.\n";
  }
  void visitUnary(Unary *curr) {
    if (debug) std::cerr << "zz node: Unary" << std::endl;
    recurse(curr->value);
    switch (curr->op) {
      case Clz:              o << int8_t(curr->type == i32 ? BinaryConsts::I32Clz        : BinaryConsts::I64Clz); break;
      case Ctz:              o << int8_t(curr->type == i32 ? BinaryConsts::I32Ctz        : BinaryConsts::I64Ctz); break;
      case Popcnt:           o << int8_t(curr->type == i32 ? BinaryConsts::I32Popcnt     : BinaryConsts::I64Popcnt); break;
      case Neg:              o << int8_t(curr->type == f32 ? BinaryConsts::F32Neg        : BinaryConsts::F64Neg); break;
      case Abs:              o << int8_t(curr->type == f32 ? BinaryConsts::F32Abs        : BinaryConsts::F64Abs); break;
      case Ceil:             o << int8_t(curr->type == f32 ? BinaryConsts::F32Ceil       : BinaryConsts::F64Ceil); break;
      case Floor:            o << int8_t(curr->type == f32 ? BinaryConsts::F32Floor      : BinaryConsts::F64Floor); break;
      case Trunc:            o << int8_t(curr->type == f32 ? BinaryConsts::F32Trunc      : BinaryConsts::F64Trunc); break;
      case Nearest:          o << int8_t(curr->type == f32 ? BinaryConsts::F32NearestInt : BinaryConsts::F64NearestInt); break;
      case Sqrt:             o << int8_t(curr->type == f32 ? BinaryConsts::F32Sqrt       : BinaryConsts::F64Sqrt); break;
      case ExtendSInt32:     o << int8_t(BinaryConsts::I64SConvertI32); break;
      case ExtendUInt32:     o << int8_t(BinaryConsts::I64UConvertI32); break;
      case WrapInt64:        o << int8_t(BinaryConsts::I32ConvertI64); break;
      case TruncUFloat32:    o << int8_t(curr->type == i32 ? BinaryConsts::F32UConvertI32 : BinaryConsts::F32UConvertI64); break;
      case TruncSFloat32:    o << int8_t(curr->type == i32 ? BinaryConsts::F32SConvertI32 : BinaryConsts::F32SConvertI64); break;
      case TruncUFloat64:    o << int8_t(curr->type == i32 ? BinaryConsts::F64UConvertI32 : BinaryConsts::F64UConvertI64); break;
      case TruncSFloat64:    o << int8_t(curr->type == i32 ? BinaryConsts::F64SConvertI32 : BinaryConsts::F64SConvertI64); break;
      case ConvertUInt32:    o << int8_t(curr->type == f32 ? BinaryConsts::I32UConvertF32 : BinaryConsts::I32UConvertF64); break;
      case ConvertSInt32:    o << int8_t(curr->type == f32 ? BinaryConsts::I32SConvertF32 : BinaryConsts::I32SConvertF64); break;
      case ConvertUInt64:    o << int8_t(curr->type == f32 ? BinaryConsts::I64UConvertF32 : BinaryConsts::I64UConvertF64); break;
      case ConvertSInt64:    o << int8_t(curr->type == f32 ? BinaryConsts::I64SConvertF32 : BinaryConsts::I64SConvertF64); break;
      case DemoteFloat64:    o << int8_t(BinaryConsts::F32ConvertF64); break;
      case PromoteFloat32:   o << int8_t(BinaryConsts::F64ConvertF32); break;
      case ReinterpretFloat: o << int8_t(curr->type == f32 ? BinaryConsts::F32ReinterpretI32 : BinaryConsts::F64ReinterpretI64); break;
      case ReinterpretInt:   o << int8_t(curr->type == i32 ? BinaryConsts::I32ReinterpretF32 : BinaryConsts::I64ReinterpretF64); break;
      default: abort();
    }
  }
  void visitBinary(Binary *curr) {
    if (debug) std::cerr << "zz node: Binary" << std::endl;
    recurse(curr->left);
    recurse(curr->right);
    #define TYPED_CODE(code) { \
      switch (getReachableWasmType(curr->left->type, curr->right->type)) { \
        case i32: o << int8_t(BinaryConsts::I32##code); break; \
        case i64: o << int8_t(BinaryConsts::I64##code); break; \
        case f32: o << int8_t(BinaryConsts::F32##code); break; \
        case f64: o << int8_t(BinaryConsts::F64##code); break; \
        default: abort(); \
      } \
      break; \
    }
    #define INT_TYPED_CODE(code) { \
      switch (getReachableWasmType(curr->left->type, curr->right->type)) { \
        case i32: o << int8_t(BinaryConsts::I32##code); break; \
        case i64: o << int8_t(BinaryConsts::I64##code); break; \
        default: abort(); \
      } \
      break; \
    }
    #define FLOAT_TYPED_CODE(code) { \
      switch (getReachableWasmType(curr->left->type, curr->right->type)) { \
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
      case DivS:     INT_TYPED_CODE(DivS);
      case DivU:     INT_TYPED_CODE(DivU);
      case RemS:     INT_TYPED_CODE(RemS);
      case RemU:     INT_TYPED_CODE(RemU);
      case And:      INT_TYPED_CODE(And);
      case Or:       INT_TYPED_CODE(Or);
      case Xor:      INT_TYPED_CODE(Xor);
      case Shl:      INT_TYPED_CODE(Shl);;
      case ShrU:     INT_TYPED_CODE(ShrU);
      case ShrS:     INT_TYPED_CODE(ShrS);
      case RotL:     INT_TYPED_CODE(RotL);
      case RotR:     INT_TYPED_CODE(RotR);
      case Div:      FLOAT_TYPED_CODE(Div);
      case CopySign: FLOAT_TYPED_CODE(CopySign);
      case Min:      FLOAT_TYPED_CODE(Min);
      case Max:      FLOAT_TYPED_CODE(Max);
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
    #undef TYPED_CODE
    #undef INT_TYPED_CODE
    #undef FLOAT_TYPED_CODE
  }
  void visitSelect(Select *curr) {
    if (debug) std::cerr << "zz node: Select" << std::endl;
    recurse(curr->ifTrue);
    recurse(curr->ifFalse);
    recurse(curr->condition);
    o << int8_t(BinaryConsts::Select);
  }
  void visitReturn(Return *curr) {
    if (debug) std::cerr << "zz node: Return" << std::endl;
    if (curr->value) {
      recurse(curr->value);
    } else {
      visitNop(nullptr);
    }
    o << int8_t(BinaryConsts::Return);
  }
  void visitHost(Host *curr) {
    if (debug) std::cerr << "zz node: Host" << std::endl;
    switch (curr->op) {
      case MemorySize: {
        o << int8_t(BinaryConsts::MemorySize);
        break;
      }
      case GrowMemory: {
        recurse(curr->operands[0]);
        o << int8_t(BinaryConsts::GrowMemory);
        break;
      }
      default: abort();
    }
  }
  void visitNop(Nop *curr) {
    if (debug) std::cerr << "zz node: Nop" << std::endl;
    o << int8_t(BinaryConsts::Nop);
  }
  void visitUnreachable(Unreachable *curr) {
    if (debug) std::cerr << "zz node: Unreachable" << std::endl;
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
    readHeader();

    // read sections until the end
    while (more()) {
      auto sectionSize = getLEB128();
      assert(sectionSize < pos + input.size());
      auto nameSize = getLEB128();
      auto match = [&](const char* name) {
        for (size_t i = 0; i < nameSize; i++) {
          if (pos + i >= input.size()) return false;
          if (name[i] == 0) return false;
          if (input[pos + i] != name[i]) return false;
        }
        if (strlen(name) != nameSize) return false;
        pos += nameSize;
        return true;
      };
      if (match(BinaryConsts::Section::Start)) readStart();
      else if (match(BinaryConsts::Section::Memory)) readMemory();
      else if (match(BinaryConsts::Section::Signatures)) readSignatures();
      else if (match(BinaryConsts::Section::Functions)) readFunctions();
      else if (match(BinaryConsts::Section::DataSegments)) readDataSegments();
      else if (match(BinaryConsts::Section::FunctionTable)) readFunctionTable();
      else if (match(BinaryConsts::Section::End)) {
        if (debug) std::cerr << "== readEnd" << std::endl;
        break;
      } else {
        abort();
      }
    }

    processFunctions();
  }

  bool more() {
    return pos < input.size();
  }

  uint8_t getInt8() {
    assert(more());
    if (debug) std::cerr << "getInt8: " << (int)(uint8_t)input[pos] << " (at " << pos << ")" << std::endl;
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

  void ungetInt8() {
    assert(pos > 0);
    if (debug) std::cerr << "ungetInt8 (at " << pos << ")" << std::endl;
    pos--;
  }

  void readHeader() {
    if (debug) std::cerr << "== readHeader" << std::endl;
    verifyInt32(0x6d736100);
    verifyInt32(10);
  }

  void readStart() {
    if (debug) std::cerr << "== readStart" << std::endl;
    wasm.start = getString();
  }

  void readMemory() {
    if (debug) std::cerr << "== readMemory" << std::endl;
    wasm.memory.initial = getLEB128();
    wasm.memory.max = getLEB128();
    verifyInt8(1); // export memory
  }

  void readSignatures() {
    if (debug) std::cerr << "== readSignatures" << std::endl;
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
    size_t total = getLEB128(); // imports and functions
    for (size_t i = 0; i < total; i++) {
      if (debug) std::cerr << "read one at " << pos << std::endl;
      auto data = getInt8();
      auto type = wasm.functionTypes[getInt16()];
      bool named = data & BinaryConsts::Named;
      assert(named);
      bool import = data & BinaryConsts::Import;
      bool locals = data & BinaryConsts::Locals;
      bool export_ = data & BinaryConsts::Export;
      Name name = getString();
      if (export_) { // XXX addition to v8 binary format
        Name exportName = getString();
        auto e = allocator.alloc<Export>();
        e->name = exportName;
        e->value = name;
        wasm.addExport(e);
      }
      if (debug) std::cerr << "reading" << name << std::endl;
      mappedFunctions.push_back(name);
      if (import) {
        auto imp = allocator.alloc<Import>();
        imp->name = name;
        imp->module = getString(); // XXX diverge
        imp->base = getString();   //     from v8
        imp->type = type;
        wasm.addImport(imp);
      } else {
        auto func = allocator.alloc<Function>();
        func->name = name;
        func->type = type->name;
        func->result = type->result;
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
        size_t size = getInt32(); // XXX int32, diverge from v8 format, to get more code to compile
        // we can't read the function yet - it might call other functions that are defined later,
        // and we do depend on the function type, as well as the mappedFunctions table.
        functions.emplace_back(func, pos, size);
        pos += size;
        func->body = nullptr; // will be filled later. but we do have the name and the type already.
        wasm.addFunction(func);
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
  std::map<Name, WasmType> localTypes; // TODO: optimize

  std::vector<Name> breakStack;

  std::vector<Expression*> expressionStack;

  void processExpressions() { // until an end marker
    while (1) {
      Expression* curr;
      readExpression(curr);
      if (!curr) break; // end marker, done with this function/block/etc
      expressionStack.push_back(curr);
    }
  }

  Expression* popExpression() {
    assert(expressionStack.size() > 0);
    auto ret = expressionStack.back();
    expressionStack.pop_back();
    return ret;
  }

  void processFunctions() {
    for (auto& func : functions) {
      Function* curr = func.func;
      if (debug) std::cerr << "processing function: " << curr->name << std::endl;
      pos = func.pos;
      nextLabel = 0;
      // prepare locals
      mappedLocals.clear();
      localTypes.clear();
      for (size_t i = 0; i < curr->params.size(); i++) {
        mappedLocals.push_back(curr->params[i].name);
        localTypes[curr->params[i].name] = curr->params[i].type;
      }
      for (size_t i = 0; i < curr->locals.size(); i++) {
        mappedLocals.push_back(curr->locals[i].name);
        localTypes[curr->locals[i].name] = curr->locals[i].type;
      }
      // process body
      assert(breakStack.empty());
      assert(expressionStack.empty());
      depth = 0;
      processExpressions();
      assert(expressionStack.size() == 1);
      curr->body = popExpression();
      assert(depth == 0);
      assert(breakStack.empty());
      assert(expressionStack.empty());
      assert(pos == func.pos + func.size);
    }
  }

  void readDataSegments() {
    if (debug) std::cerr << "== readDataSegments" << std::endl;
    auto num = getLEB128();
    for (size_t i = 0; i < num; i++) {
      Memory::Segment curr;
      curr.offset = getInt32();
      auto start = getInt32();
      auto size = getInt32();
      auto buffer = malloc(size);
      memcpy(buffer, &input[start], size);
      curr.data = (const char*)buffer;
      curr.size = size;
      wasm.memory.segments.push_back(curr);
      verifyInt8(1); // load at program start
    }
  }

  void readFunctionTable() {
    if (debug) std::cerr << "== readFunctionTable" << std::endl;
    auto num = getLEB128();
    for (size_t i = 0; i < num; i++) {
      wasm.table.names.push_back(mappedFunctions[getInt16()]);
    }
  }

  // AST reading

  int depth; // only for debugging

  void readExpression(Expression*& curr) {
    if (debug) std::cerr << "zz recurse into " << ++depth << " at " << pos << std::endl;
    uint8_t code = getInt8();
    if (debug) std::cerr << "readExpression seeing " << (int)code << std::endl;
    switch (code) {
      case BinaryConsts::Block:        visitBlock((curr = allocator.alloc<Block>())->cast<Block>()); break;
      case BinaryConsts::If:
      case BinaryConsts::IfElse:       visitIf((curr = allocator.alloc<If>())->cast<If>(), code);  break;// code distinguishes if from if_else
      case BinaryConsts::Loop:         visitLoop((curr = allocator.alloc<Loop>())->cast<Loop>()); break;
      case BinaryConsts::Br:
      case BinaryConsts::BrIf:         visitBreak((curr = allocator.alloc<Break>())->cast<Break>(), code); break; // code distinguishes br from br_if
      case BinaryConsts::TableSwitch:  visitSwitch((curr = allocator.alloc<Switch>())->cast<Switch>()); break;
      case BinaryConsts::CallFunction: {
        // might be an import or not. we have to check here.
        Name target = mappedFunctions[getLEB128()];
        assert(target.is());
        if (debug) std::cerr << "call(import?) target: " << target << std::endl;
        if (wasm.importsMap.find(target) == wasm.importsMap.end()) {
          assert(wasm.functionsMap.find(target) != wasm.functionsMap.end());
          visitCall((curr = allocator.alloc<Call>())->cast<Call>(), target);
        } else {
          visitCallImport((curr = allocator.alloc<CallImport>())->cast<CallImport>(), target);
        }
        break;
      }
      case BinaryConsts::CallIndirect: visitCallIndirect((curr = allocator.alloc<CallIndirect>())->cast<CallIndirect>()); break;
      case BinaryConsts::GetLocal:     visitGetLocal((curr = allocator.alloc<GetLocal>())->cast<GetLocal>()); break;
      case BinaryConsts::SetLocal:     visitSetLocal((curr = allocator.alloc<SetLocal>())->cast<SetLocal>()); break;
      case BinaryConsts::Select:       visitSelect((curr = allocator.alloc<Select>())->cast<Select>()); break;
      case BinaryConsts::Return:       visitReturn((curr = allocator.alloc<Return>())->cast<Return>()); break;
      case BinaryConsts::Nop:          visitNop((curr = allocator.alloc<Nop>())->cast<Nop>()); break;
      case BinaryConsts::Unreachable:  visitUnreachable((curr = allocator.alloc<Unreachable>())->cast<Unreachable>()); break;
      case BinaryConsts::EndMarker:    curr = nullptr; break;
      default: {
        // otherwise, the code is a subcode TODO: optimize
        if (maybeVisit<Binary>(curr, code)) break;
        if (maybeVisit<Unary>(curr, code)) break;
        if (maybeVisit<Const>(curr, code)) break;
        if (maybeVisit<Load>(curr, code)) break;
        if (maybeVisit<Store>(curr, code)) break;
        if (maybeVisit<Host>(curr, code)) break;
        std::cerr << "bad code 0x" << std::hex << (int)code << std::endl;
        abort();
      }
    }
    if (debug) std::cerr << "zz recurse from " << depth-- << " at " << pos << std::endl;
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
    if (debug) std::cerr << "zz node: Block" << std::endl;
    // special-case Block and de-recurse nested blocks in their first position, as that is
    // a common pattern that can be very highly nested.
    std::vector<Block*> stack;
    while (1) {
      curr->name = getNextLabel();
      breakStack.push_back(curr->name);
      stack.push_back(curr);
      if (getInt8() == BinaryConsts::Block) {
        // a recursion
        curr = allocator.alloc<Block>();
        continue;
      } else {
        // end of recursion
        ungetInt8();
        break;
      }
    }
    Block* last = nullptr;
    while (stack.size() > 0) {
      curr = stack.back();
      stack.pop_back();
      size_t start = expressionStack.size(); // everything after this, that is left when we see the marker, is ours
      if (last) {
        // the previous block is our first-position element
        expressionStack.push_back(last);
      }
      last = curr;
      processExpressions();
      size_t end = expressionStack.size();
      assert(end >= start);
      for (size_t i = start; i < end; i++) {
        if (debug) std::cerr << "  " << size_t(expressionStack[i]) << "\n zz Block element " << curr->list.size() << std::endl;
        curr->list.push_back(expressionStack[i]);
      }
      expressionStack.resize(start);
      curr->finalize();
      breakStack.pop_back();
    }
  }
  void visitIf(If *curr, uint8_t code) {
    if (debug) std::cerr << "zz node: If" << std::endl;
    if (code == BinaryConsts::IfElse) {
      curr->ifFalse = popExpression();
    }
    curr->ifTrue = popExpression();
    curr->condition = popExpression();
    if (code == BinaryConsts::IfElse) {
      curr->finalize();
    }
  }
  void visitLoop(Loop *curr) {
    if (debug) std::cerr << "zz node: Loop" << std::endl;
    verifyInt8(1); // size TODO: generalize
    curr->out = getNextLabel();
    curr->in = getNextLabel();
    breakStack.push_back(curr->out);
    breakStack.push_back(curr->in);
    processExpressions();
    curr->body = popExpression();
    breakStack.pop_back();
    breakStack.pop_back();
    curr->finalize();
  }

  Name getBreakName(int32_t offset) {
    assert(breakStack.size() - 1 - offset < breakStack.size());
    return breakStack[breakStack.size() - 1 - offset];
  }

  void visitBreak(Break *curr, uint8_t code) {
    if (debug) std::cerr << "zz node: Break" << std::endl;
    curr->name = getBreakName(getInt32());
    if (code == BinaryConsts::BrIf) curr->condition = popExpression();
    curr->value = popExpression();
  }
  void visitSwitch(Switch *curr) {
    if (debug) std::cerr << "zz node: Switch" << std::endl;
    auto numTargets = getInt16();
    auto hasValue = getInt8();
    for (auto i = 0; i < numTargets - 1; i++) {
      curr->targets.push_back(getBreakName(getInt32()));
    }
    curr->default_ = getBreakName(getInt32());
    processExpressions();
    curr->condition = popExpression();
    if (hasValue) {
      processExpressions();
      curr->value = popExpression();
    }
  }
  void visitCall(Call *curr, Name target) {
    if (debug) std::cerr << "zz node: Call" << std::endl;
    curr->target = target;
    auto type = wasm.functionTypesMap[wasm.functionsMap[curr->target]->type];
    auto num = type->params.size();
    curr->operands.resize(num);
    for (size_t i = 0; i < num; i++) {
      curr->operands[num - i - 1] = popExpression();
    }
    curr->type = type->result;
  }
  void visitCallImport(CallImport *curr, Name target) {
    if (debug) std::cerr << "zz node: CallImport" << std::endl;
    curr->target = target;
    auto type = wasm.importsMap[curr->target]->type;
    auto num = type->params.size();
    curr->operands.resize(num);
    for (size_t i = 0; i < num; i++) {
      curr->operands[num - i - 1] = popExpression();
    }
    curr->type = type->result;
  }
  void visitCallIndirect(CallIndirect *curr) {
    if (debug) std::cerr << "zz node: CallIndirect" << std::endl;
    curr->fullType = wasm.functionTypes[getLEB128()];
    auto num = curr->fullType->params.size();
    curr->operands.resize(num);
    for (size_t i = 0; i < num; i++) {
      curr->operands[num - i - 1] = popExpression();
    }
    curr->target = popExpression();
    curr->type = curr->fullType->result;
  }
  void visitGetLocal(GetLocal *curr) {
    if (debug) std::cerr << "zz node: GetLocal " << pos << std::endl;
    curr->name = mappedLocals[getLEB128()];
    assert(curr->name.is());
    curr->type = localTypes[curr->name];
  }
  void visitSetLocal(SetLocal *curr) {
    if (debug) std::cerr << "zz node: SetLocal" << std::endl;
    curr->name = mappedLocals[getLEB128()];
    assert(curr->name.is());
    curr->value = popExpression();
    curr->type = curr->value->type;
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
    if (debug) std::cerr << "zz node: Load" << std::endl;
    readMemoryAccess(curr->align, curr->bytes, curr->offset);
    curr->ptr = popExpression();
    return true;
  }
  bool maybeVisitImpl(Store *curr, uint8_t code) {
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
    if (debug) std::cerr << "zz node: Store" << std::endl;
    readMemoryAccess(curr->align, curr->bytes, curr->offset);
    curr->value = popExpression();
    curr->ptr = popExpression();
    return true;
  }
  bool maybeVisitImpl(Const *curr, uint8_t code) {
    switch (code) {
      case BinaryConsts::I8Const:  curr->value = Literal(int32_t(getInt8())); break;
      case BinaryConsts::I32Const: curr->value = Literal(getInt32()); break;
      case BinaryConsts::I64Const: curr->value = Literal(getInt64()); break;
      case BinaryConsts::F32Const: curr->value = Literal(getFloat32()); break;
      case BinaryConsts::F64Const: curr->value = Literal(getFloat64()); break;
      default: return false;
    }
    curr->type = curr->value.type;
    if (debug) std::cerr << "zz node: Const" << std::endl;
    return true;
  }
  bool maybeVisitImpl(Unary *curr, uint8_t code) {
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

      case BinaryConsts::I64SConvertI32: curr->op = ExtendSInt32;  curr->type = i64; break;
      case BinaryConsts::I64UConvertI32: curr->op = ExtendUInt32;  curr->type = i64; break;
      case BinaryConsts::I32ConvertI64:  curr->op = WrapInt64;     curr->type = i32; break;

      case BinaryConsts::F32UConvertI32: curr->op = TruncUFloat32; curr->type = i32; break;
      case BinaryConsts::F64UConvertI32: curr->op = TruncUFloat64; curr->type = i32; break;
      case BinaryConsts::F32SConvertI32: curr->op = TruncSFloat32; curr->type = i32; break;
      case BinaryConsts::F64SConvertI32: curr->op = TruncSFloat64; curr->type = i32; break;
      case BinaryConsts::F32UConvertI64: curr->op = TruncUFloat32; curr->type = i64; break;
      case BinaryConsts::F64UConvertI64: curr->op = TruncUFloat64; curr->type = i64; break;
      case BinaryConsts::F32SConvertI64: curr->op = TruncSFloat32; curr->type = i64; break;
      case BinaryConsts::F64SConvertI64: curr->op = TruncSFloat64; curr->type = i64; break;

      case BinaryConsts::F32Trunc:       curr->op = Trunc;         curr->type = f32; break;
      case BinaryConsts::F64Trunc:       curr->op = Trunc;         curr->type = f64; break;

      case BinaryConsts::F32ConvertF64:     curr->op = DemoteFloat64;     curr->type = f32; break;
      case BinaryConsts::F64ConvertF32:     curr->op = PromoteFloat32;    curr->type = f64; break;
      case BinaryConsts::F32ReinterpretI32: curr->op = ReinterpretFloat;  curr->type = i32; break;
      case BinaryConsts::F64ReinterpretI64: curr->op = ReinterpretFloat;  curr->type = i64; break;
      case BinaryConsts::I64ReinterpretF64: curr->op = ReinterpretInt;    curr->type = f64; break;
      case BinaryConsts::I32ReinterpretF32: curr->op = ReinterpretInt;    curr->type = f32; break;

      default: return false;
    }
    if (debug) std::cerr << "zz node: Unary" << std::endl;
    curr->value = popExpression();
    return true;
  }
  bool maybeVisitImpl(Binary *curr, uint8_t code) {
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
      INT_TYPED_CODE(RotL);
      INT_TYPED_CODE(RotR);
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
    if (debug) std::cerr << "zz node: Binary" << std::endl;
    curr->right = popExpression();
    curr->left = popExpression();
    curr->finalize();
    return true;
    #undef TYPED_CODE
    #undef INT_TYPED_CODE
    #undef FLOAT_TYPED_CODE
  }
  void visitSelect(Select *curr) {
    if (debug) std::cerr << "zz node: Select" << std::endl;
    curr->condition = popExpression();
    curr->ifFalse = popExpression();
    curr->ifTrue = popExpression();
    curr->finalize();
  }
  void visitReturn(Return *curr) {
    if (debug) std::cerr << "zz node: Return" << std::endl;
    curr->value = popExpression();
  }
  bool maybeVisitImpl(Host *curr, uint8_t code) {
    switch (code) {
      case BinaryConsts::MemorySize: {
        curr->op = MemorySize;
        curr->type = i32;
        break;
      }
      case BinaryConsts::GrowMemory: {
        curr->op = GrowMemory;
        curr->operands.resize(1);
        curr->operands[0] = popExpression();
        break;
      }
      default: return false;
    }
    if (debug) std::cerr << "zz node: Host" << std::endl;
    curr->finalize();
    return true;
  }
  void visitNop(Nop *curr) {
    if (debug) std::cerr << "zz node: Nop" << std::endl;
  }
  void visitUnreachable(Unreachable *curr) {
    if (debug) std::cerr << "zz node: Unreachable" << std::endl;
  }
};

} // namespace wasm

#endif // wasm_wasm_binary_h
