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
#include "wasm-traversal.h"
#include "shared-constants.h"
#include "asm_v_wasm.h"
#include "wasm-builder.h"

namespace wasm {

template<typename T, typename MiniT>
struct LEB {
  T value;

  LEB() {}
  LEB(T value) : value(value) {}

  bool isSigned() {
    return int(MiniT(-1)) < 0; 
  }

  bool hasMore(T temp, MiniT byte) {
    // for signed, we must ensure the last bit has the right sign, as it will zero extend
    return isSigned() ? (temp != 0 && int32_t(temp) != -1) || (value >= 0 && (byte & 64)) || (value < 0 && !(byte & 64)): (temp != 0);
  }

  void write(std::vector<uint8_t>* out) {
    T temp = value;
    bool more;
    do {
      uint8_t byte = temp & 127;
      temp >>= 7;
      more = hasMore(temp, byte);
      if (more) {
        byte = byte | 128;
      }
      out->push_back(byte);
    } while (more);
  }

  void writeAt(std::vector<uint8_t>* out, size_t at, size_t minimum = 0) {
    T temp = value;
    size_t offset = 0;
    bool more;
    do {
      uint8_t byte = temp & 127;
      temp >>= 7;
      more = hasMore(temp, byte) || offset + 1 < minimum;
      if (more) {
        byte = byte | 128;
      }
      (*out)[at + offset] = byte;
      offset++;
    } while (more);
  }

  void read(std::function<MiniT ()> get) {
    value = 0;
    T shift = 0;
    MiniT byte;
    while (1) {
      byte = get();
      value |= ((T(byte & 127)) << shift);
      if (!(byte & 128)) break;
      shift += 7;
    }
    // if signed LEB, then we might need to sign-extend. (compile should optimize this out if not needed)
    if (isSigned()) {
      shift += 7;
      if (byte & 64 && size_t(shift) < 8*sizeof(T)) {
        // the highest bit we received was a 1, sign-extend all the rest
        value = value | (T(-1) << shift);
        assert(value < 0);
      }
    }
  }
};

typedef LEB<uint32_t, uint8_t> U32LEB;
typedef LEB<uint64_t, uint8_t> U64LEB;
typedef LEB<int32_t, int8_t> S32LEB;
typedef LEB<int64_t, int8_t> S64LEB;

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
  BufferWithRandomAccess& operator<<(U32LEB x) {
    if (debug) std::cerr << "writeU32LEB: " << x.value << " (at " << size() << ")" << std::endl;
    x.write(this);
    return *this;
  }
  BufferWithRandomAccess& operator<<(U64LEB x) {
    if (debug) std::cerr << "writeU64LEB: " << x.value << " (at " << size() << ")" << std::endl;
    x.write(this);
    return *this;
  }
  BufferWithRandomAccess& operator<<(S32LEB x) {
    if (debug) std::cerr << "writeS32LEB: " << x.value << " (at " << size() << ")" << std::endl;
    x.write(this);
    return *this;
  }
  BufferWithRandomAccess& operator<<(S64LEB x) {
    if (debug) std::cerr << "writeS64LEB: " << x.value << " (at " << size() << ")" << std::endl;
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
  void writeAt(size_t i, U32LEB x) {
    if (debug) std::cerr << "backpatchU32LEB: " << x.value << " (at " << i << ")" << std::endl;
    x.writeAt(this, i, 5); // fill all 5 bytes, we have to do this when backpatching
  }

  template <typename T>
  void writeTo(T& o) {
    for (auto c : *this) o << c;
  }
};

namespace BinaryConsts {

namespace Section {
  auto Memory = "memory";
  auto Signatures = "type";
  auto ImportTable = "import";
  auto FunctionSignatures = "function";
  auto Functions = "code";
  auto ExportTable = "export";
  auto DataSegments = "data";
  auto FunctionTable = "table";
  auto Names = "name";
  auto End = "end";
  auto Start = "start";
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
  I32EqZ = 0xc0, // XXX
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
  I64EqZ = 0xc1, // XXX
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

  I32Const = 0x10,
  I64Const = 0x11,
  F64Const = 0x12,
  F32Const = 0x13,
  GetLocal = 0x14,
  SetLocal = 0x15,
  CallFunction = 0x16,
  CallIndirect = 0x17,
  CallImport = 0x18,

  Nop = 0x00,
  Block = 0x01,
  Loop = 0x02,
  If = 0x03,
  Else = 0x04,
  Select = 0x05,
  Br = 0x06,
  BrIf = 0x07,
  TableSwitch = 0x08,
  Return = 0x09,
  Unreachable = 0x0a,
  End = 0x0f
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

class WasmBinaryWriter : public Visitor<WasmBinaryWriter, void> {
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
    writeMemory();
    writeSignatures();
    writeImports();
    writeFunctionSignatures();
    writeFunctions();
    writeStart();
    writeExports();
    writeDataSegments();
    writeFunctionTable();
    writeNames();
    writeEnd();
    finishUp();
  }

  void writeHeader() {
    if (debug) std::cerr << "== writeHeader" << std::endl;
    o << int32_t(0x6d736100); // magic number \0asm
    o << int32_t(10);         // version number
  }

  int32_t writeU32LEBPlaceholder() {
    int32_t ret = o.size();
    o << int32_t(0);
    o << int8_t(0);
    return ret;
  }

  int32_t startSection(const char* name) {
    // emit 5 bytes of 0, which we'll fill with LEB later
    writeInlineString(name);
    return writeU32LEBPlaceholder();
  }

  void finishSection(int32_t start) {
    int32_t size = o.size() - start - 5; // section size does not include the 5 bytes of the size field itself
    o.writeAt(start, U32LEB(size));
  }

  void writeStart() {
    if (!wasm->start.is()) return;
    if (debug) std::cerr << "== writeStart" << std::endl;
    auto start = startSection(BinaryConsts::Section::Start);
    o << U32LEB(getFunctionIndex(wasm->start.str));
    finishSection(start);
  }

  void writeMemory() {
    if (wasm->memory.max == 0) return;
    if (debug) std::cerr << "== writeMemory" << std::endl;
    auto start = startSection(BinaryConsts::Section::Memory);
    o << U32LEB(wasm->memory.initial)
      << U32LEB(wasm->memory.max)
      << int8_t(1); // export memory
    finishSection(start);
  }

  void writeSignatures() {
    if (wasm->functionTypes.size() == 0) return;
    if (debug) std::cerr << "== writeSignatures" << std::endl;
    auto start = startSection(BinaryConsts::Section::Signatures);
    o << U32LEB(wasm->functionTypes.size());
    for (auto* type : wasm->functionTypes) {
      if (debug) std::cerr << "write one" << std::endl;
      o << U32LEB(type->params.size());
      o << binaryWasmType(type->result);
      for (auto param : type->params) {
        o << binaryWasmType(param);
      }
    }
    finishSection(start);
  }

  int32_t getFunctionTypeIndex(Name type) {
    // TODO: optimize
    for (size_t i = 0; i < wasm->functionTypes.size(); i++) {
      if (wasm->functionTypes[i]->name == type) return i;
    }
    abort();
  }

  void writeImports() {
    if (wasm->imports.size() == 0) return;
    if (debug) std::cerr << "== writeImports" << std::endl;
    auto start = startSection(BinaryConsts::Section::ImportTable);
    o << U32LEB(wasm->imports.size());
    for (auto* import : wasm->imports) {
      if (debug) std::cerr << "write one" << std::endl;
      o << U32LEB(getFunctionTypeIndex(import->type->name));
      writeInlineString(import->module.str);
      writeInlineString(import->base.str);
    }
    finishSection(start);
  }

  std::map<Index, size_t> mappedLocals; // local index => index in compact form of [all int32s][all int64s]etc
  std::map<WasmType, size_t> numLocalsByType; // type => number of locals of that type in the compact form

  void mapLocals(Function* function) {
    for (Index i = 0; i < function->getNumParams(); i++) {
      size_t curr = mappedLocals.size();
      mappedLocals[i] = curr;
    }
    for (auto type : function->vars) {
      numLocalsByType[type]++;
    }
    std::map<WasmType, size_t> currLocalsByType;
    for (Index i = function->getVarIndexBase(); i < function->getNumLocals(); i++) {
      size_t index = function->getVarIndexBase();
      WasmType type = function->getLocalType(i);
      currLocalsByType[type]++; // increment now for simplicity, must decrement it in returns
      if (type == i32) {
        mappedLocals[i] = index + currLocalsByType[i32] - 1;
        continue;
      }
      index += numLocalsByType[i32];
      if (type == i64) {
        mappedLocals[i] = index + currLocalsByType[i64] - 1;
        continue;
      }
      index += numLocalsByType[i64];
      if (type == f32) {
        mappedLocals[i] = index + currLocalsByType[f32] - 1;
        continue;
      }
      index += numLocalsByType[f32];
      if (type == f64) {
        mappedLocals[i] = index + currLocalsByType[f64] - 1;
        continue;
      }
      abort();
    }
  }

  void writeFunctionSignatures() {
    if (wasm->functions.size() == 0) return;
    if (debug) std::cerr << "== writeFunctionSignatures" << std::endl;
    auto start = startSection(BinaryConsts::Section::FunctionSignatures);
    o << U32LEB(wasm->functions.size());
    for (auto* curr : wasm->functions) {
      if (debug) std::cerr << "write one" << std::endl;
      o << U32LEB(getFunctionTypeIndex(curr->type));
    }
    finishSection(start);
  }

  void writeFunctions() {
    if (wasm->functions.size() == 0) return;
    if (debug) std::cerr << "== writeFunctions" << std::endl;
    auto start = startSection(BinaryConsts::Section::Functions);
    size_t total = wasm->functions.size();
    o << U32LEB(total);
    for (size_t i = 0; i < total; i++) {
      if (debug) std::cerr << "write one at" << o.size() << std::endl;
      size_t sizePos = writeU32LEBPlaceholder();
      size_t start = o.size();
      Function* function = wasm->functions[i];
      mappedLocals.clear();
      numLocalsByType.clear();
      if (debug) std::cerr << "writing" << function->name << std::endl;
      mapLocals(function);
      o << U32LEB(
        (numLocalsByType[i32] ? 1 : 0) +
        (numLocalsByType[i64] ? 1 : 0) +
        (numLocalsByType[f32] ? 1 : 0) +
        (numLocalsByType[f64] ? 1 : 0)
      );
      if (numLocalsByType[i32]) o << U32LEB(numLocalsByType[i32]) << binaryWasmType(i32);
      if (numLocalsByType[i64]) o << U32LEB(numLocalsByType[i64]) << binaryWasmType(i64);
      if (numLocalsByType[f32]) o << U32LEB(numLocalsByType[f32]) << binaryWasmType(f32);
      if (numLocalsByType[f64]) o << U32LEB(numLocalsByType[f64]) << binaryWasmType(f64);
      depth = 0;
      recurse(function->body);
      o << int8_t(BinaryConsts::End);
      assert(depth == 0);
      size_t size = o.size() - start;
      assert(size <= std::numeric_limits<uint32_t>::max());
      if (debug) std::cerr << "body size: " << size << ", writing at " << sizePos << ", next starts at " << o.size() << std::endl;
      o.writeAt(sizePos, U32LEB(size));
    }
    finishSection(start);
  }

  void writeExports() {
    if (wasm->exports.size() == 0) return;
    if (debug) std::cerr << "== writeexports" << std::endl;
    auto start = startSection(BinaryConsts::Section::ExportTable);
    o << U32LEB(wasm->exports.size());
    for (auto* curr : wasm->exports) {
      if (debug) std::cerr << "write one" << std::endl;
      o << U32LEB(getFunctionIndex(curr->value));
      writeInlineString(curr->name.str);
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
    o << U32LEB(num);
    for (auto& segment : wasm->memory.segments) {
      if (segment.size == 0) continue;
      o << U32LEB(segment.offset);
      writeInlineBuffer(segment.data, segment.size);
    }
    finishSection(start);
  }

  std::map<Name, uint32_t> mappedImports; // name of the Import => index
  uint32_t getImportIndex(Name name) {
    if (!mappedImports.size()) {
      // Create name => index mapping. 
      for (size_t i = 0; i < wasm->imports.size(); i++) {
        assert(mappedImports.count(wasm->imports[i]->name) == 0);
        mappedImports[wasm->imports[i]->name] = i;
      }    
    }
    assert(mappedImports.count(name));
    return mappedImports[name];
  }
  
  std::map<Name, uint32_t> mappedFunctions; // name of the Function => index 
  uint32_t getFunctionIndex(Name name) {
    if (!mappedFunctions.size()) {
      // Create name => index mapping. 
      for (size_t i = 0; i < wasm->functions.size(); i++) {
        assert(mappedFunctions.count(wasm->functions[i]->name) == 0);
        mappedFunctions[wasm->functions[i]->name] = i;
      }    
    }
    assert(mappedFunctions.count(name));
    return mappedFunctions[name];
  }

  void writeFunctionTable() {
    if (wasm->table.names.size() == 0) return;
    if (debug) std::cerr << "== writeFunctionTable" << std::endl;
    auto start = startSection(BinaryConsts::Section::FunctionTable);
    o << U32LEB(wasm->table.names.size());
    for (auto name : wasm->table.names) {
      o << U32LEB(getFunctionIndex(name));
    }
    finishSection(start);
  }

  void writeNames() {
    if (wasm->functions.size() == 0) return;
    if (debug) std::cerr << "== writeNames" << std::endl;
    auto start = startSection(BinaryConsts::Section::Names);
    o << U32LEB(wasm->functions.size());
    for (auto* curr : wasm->functions) {
      writeInlineString(curr->name.str);
      o << U32LEB(0); // TODO: locals
    }
    finishSection(start);
  }

  void writeEnd() {
    auto start = startSection(BinaryConsts::Section::End);
    finishSection(start);
  }

  // helpers

  void writeInlineString(const char* name) {
    int32_t size = strlen(name);
    o << U32LEB(size);
    for (int32_t i = 0; i < size; i++) {
      o << int8_t(name[i]);
    }
  }

  void writeInlineBuffer(const char* data, size_t size) {
    o << U32LEB(size);
    for (size_t i = 0; i < size; i++) {
      o << int8_t(data[i]);
    }
  }

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
    o << int8_t(BinaryConsts::End);
  }
  void visitIf(If *curr) {
    if (debug) std::cerr << "zz node: If" << std::endl;
    o << int8_t(BinaryConsts::If);
    recurse(curr->condition);
    recurse(curr->ifTrue); // TODO: emit block contents directly, if block with no name
    if (curr->ifFalse) {
      o << int8_t(BinaryConsts::Else);
      recurse(curr->ifFalse);
    }
    o << int8_t(BinaryConsts::End);
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
    o << int8_t(BinaryConsts::End);
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
      << U32LEB(getBreakIndex(curr->name));
  }
  void visitSwitch(Switch *curr) {
    if (debug) std::cerr << "zz node: Switch" << std::endl;
    o << int8_t(BinaryConsts::TableSwitch) << U32LEB(curr->targets.size());
    for (auto target : curr->targets) {
      o << U32LEB(getBreakIndex(target));
    }
    o << U32LEB(getBreakIndex(curr->default_));
    recurse(curr->condition);
    o << int8_t(BinaryConsts::End);
    if (curr->value) {
      recurse(curr->value);
    } else {
      visitNop(nullptr);
    }
    o << int8_t(BinaryConsts::End);
  }
  void visitCall(Call *curr) {
    if (debug) std::cerr << "zz node: Call" << std::endl;
    for (auto* operand : curr->operands) {
      recurse(operand);
    }
    o << int8_t(BinaryConsts::CallFunction) << U32LEB(getFunctionIndex(curr->target));
  }
  void visitCallImport(CallImport *curr) {
    if (debug) std::cerr << "zz node: CallImport" << std::endl;
    for (auto* operand : curr->operands) {
      recurse(operand);
    }
    o << int8_t(BinaryConsts::CallImport) << U32LEB(getImportIndex(curr->target));
  }
  void visitCallIndirect(CallIndirect *curr) {
    if (debug) std::cerr << "zz node: CallIndirect" << std::endl;
    recurse(curr->target);
    for (auto* operand : curr->operands) {
      recurse(operand);
    }
    o << int8_t(BinaryConsts::CallIndirect) << U32LEB(getFunctionTypeIndex(curr->fullType->name));
  }
  void visitGetLocal(GetLocal *curr) {
    if (debug) std::cerr << "zz node: GetLocal " << (o.size() + 1) << std::endl;
    o << int8_t(BinaryConsts::GetLocal) << U32LEB(mappedLocals[curr->index]);
  }
  void visitSetLocal(SetLocal *curr) {
    if (debug) std::cerr << "zz node: SetLocal" << std::endl;
    recurse(curr->value);
    o << int8_t(BinaryConsts::SetLocal) << U32LEB(mappedLocals[curr->index]);
  }

  void emitMemoryAccess(size_t alignment, size_t bytes, uint32_t offset) {
    o << U32LEB(Log2(alignment ? alignment : bytes));
    o << U32LEB(offset);
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
        o << int8_t(BinaryConsts::I32Const) << S32LEB(curr->value.geti32());
        break;
      }
      case i64: {
        o << int8_t(BinaryConsts::I64Const) << S64LEB(curr->value.geti64());
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
      case EqZ:              o << int8_t(curr->type == i32 ? BinaryConsts::I32EqZ        : BinaryConsts::I64EqZ); break;
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
  Module& wasm;
  MixedArena& allocator;
  std::vector<char>& input;
  bool debug;

  size_t pos = 0;
  int32_t startIndex = -1;

public:
  WasmBinaryBuilder(Module& wasm, std::vector<char>& input, bool debug) : wasm(wasm), allocator(wasm.allocator), input(input), debug(debug) {}

  void read() {

    readHeader();

    // read sections until the end
    while (more()) {
      auto nameSize = getU32LEB();
      uint32_t sectionSize, before;
      auto match = [&](const char* name) {
        for (size_t i = 0; i < nameSize; i++) {
          if (pos + i >= input.size()) return false;
          if (name[i] == 0) return false;
          if (input[pos + i] != name[i]) return false;
        }
        if (strlen(name) != nameSize) return false;
        // name matched, read section size and then section itself
        pos += nameSize;
        sectionSize = getU32LEB();
        before = pos;
        assert(pos + sectionSize <= input.size());
        return true;
      };
      if (match(BinaryConsts::Section::Start)) readStart();
      else if (match(BinaryConsts::Section::Memory)) readMemory();
      else if (match(BinaryConsts::Section::Signatures)) readSignatures();
      else if (match(BinaryConsts::Section::ImportTable)) readImports();
      else if (match(BinaryConsts::Section::FunctionSignatures)) readFunctionSignatures();
      else if (match(BinaryConsts::Section::Functions)) readFunctions();
      else if (match(BinaryConsts::Section::ExportTable)) readExports();
      else if (match(BinaryConsts::Section::DataSegments)) readDataSegments();
      else if (match(BinaryConsts::Section::FunctionTable)) readFunctionTable();
      else if (match(BinaryConsts::Section::Names)) readNames();
      else if (match(BinaryConsts::Section::End)) {
        if (debug) std::cerr << "== readEnd" << std::endl;
        break;
      } else {
        abort();
      }
      assert(pos == before + sectionSize);
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

  uint32_t getU32LEB() {
    if (debug) std::cerr << "<==" << std::endl;
    U32LEB ret;
    ret.read([&]() {
      return getInt8();
    });
    if (debug) std::cerr << "getU32LEB: " << ret.value << " ==>" << std::endl;
    return ret.value;
  }
  uint64_t getU64LEB() {
    if (debug) std::cerr << "<==" << std::endl;
    U64LEB ret;
    ret.read([&]() {
      return getInt8();
    });
    if (debug) std::cerr << "getU64LEB: " << ret.value << " ==>" << std::endl;
    return ret.value;
  }
  int32_t getS32LEB() {
    if (debug) std::cerr << "<==" << std::endl;
    S32LEB ret;
    ret.read([&]() {
      return (int8_t)getInt8();
    });
    if (debug) std::cerr << "getU32LEB: " << ret.value << " ==>" << std::endl;
    return ret.value;
  }
  int64_t getS64LEB() {
    if (debug) std::cerr << "<==" << std::endl;
    S64LEB ret;
    ret.read([&]() {
      return (int8_t)getInt8();
    });
    if (debug) std::cerr << "getU64LEB: " << ret.value << " ==>" << std::endl;
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

  Name getInlineString() {
    if (debug) std::cerr << "<==" << std::endl;
    auto len = getU32LEB();
    std::string str;
    for (size_t i = 0; i < len; i++) {
      str = str + char(getInt8());
    }
    if (debug) std::cerr << "getInlineString: " << str << " ==>" << std::endl;
    return Name(str);
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
    startIndex = getU32LEB();
  }

  void readMemory() {
    if (debug) std::cerr << "== readMemory" << std::endl;
    wasm.memory.initial = getU32LEB();
    wasm.memory.max = getU32LEB();
    verifyInt8(1); // export memory
  }

  void readSignatures() {
    if (debug) std::cerr << "== readSignatures" << std::endl;
    size_t numTypes = getU32LEB();
    if (debug) std::cerr << "num: " << numTypes << std::endl;
    for (size_t i = 0; i < numTypes; i++) {
      if (debug) std::cerr << "read one" << std::endl;
      auto curr = allocator.alloc<FunctionType>();
      size_t numParams = getU32LEB();
      if (debug) std::cerr << "num params: " << numParams << std::endl;
      curr->result = getWasmType();
      for (size_t j = 0; j < numParams; j++) {
        curr->params.push_back(getWasmType());
      }
      wasm.addFunctionType(curr);
    }
  }

  void readImports() {
    if (debug) std::cerr << "== readImports" << std::endl;
    size_t num = getU32LEB();
    if (debug) std::cerr << "num: " << num << std::endl;
    for (size_t i = 0; i < num; i++) {
      if (debug) std::cerr << "read one" << std::endl;
      auto curr = allocator.alloc<Import>();
      curr->name = Name(std::string("import$") + std::to_string(i));
      auto index = getU32LEB();
      assert(index < wasm.functionTypes.size());
      curr->type = wasm.functionTypes[index];
      assert(curr->type->name.is());
      curr->module = getInlineString();
      curr->base = getInlineString();
      wasm.addImport(curr);
    }
  }

  std::vector<FunctionType*> functionTypes;

  void readFunctionSignatures() {
    if (debug) std::cerr << "== readFunctionSignatures" << std::endl;
    size_t num = getU32LEB();
    if (debug) std::cerr << "num: " << num << std::endl;
    for (size_t i = 0; i < num; i++) {
      if (debug) std::cerr << "read one" << std::endl;
      auto index = getU32LEB();
      assert(index < wasm.functionTypes.size());
      functionTypes.push_back(wasm.functionTypes[index]);
    }
  }

  size_t nextLabel;

  Name getNextLabel() {
    return cashew::IString(("label$" + std::to_string(nextLabel++)).c_str(), false);
  }

  // We read functions before we know their names, so we need to backpatch the names later

  std::vector<Function*> functions; // we store functions here before wasm.addFunction after we know their names
  std::map<size_t, std::vector<Call*>> functionCalls; // at index i we have all calls to i
  Function* currFunction = nullptr;

  void readFunctions() {
    if (debug) std::cerr << "== readFunctions" << std::endl;
    size_t total = getU32LEB();
    for (size_t i = 0; i < total; i++) {
      if (debug) std::cerr << "read one at " << pos << std::endl;
      size_t size = getU32LEB();
      assert(size > 0); // we could also check it matches the seen size
      auto type = functionTypes[i];
      if (debug) std::cerr << "reading" << i << std::endl;
      size_t nextVar = 0;
      auto addVar = [&]() {
        Name name = cashew::IString(("var$" + std::to_string(nextVar++)).c_str(), false);
        return name;
      };
      std::vector<NameType> params, vars;
      for (size_t j = 0; j < type->params.size(); j++) {
        params.emplace_back(addVar(), type->params[j]);
      }
      size_t numLocalTypes = getU32LEB();
      for (size_t t = 0; t < numLocalTypes; t++) {
        auto num = getU32LEB();
        auto type = getWasmType();
        while (num > 0) {
          vars.emplace_back(addVar(), type);
          num--;
        }
      }
      auto func = Builder(wasm).makeFunction(
        Name("TODO"),
        std::move(params),
        type->result,
        std::move(vars)
      );
      func->type = type->name;
      currFunction = func;
      {
        // process the function body
        if (debug) std::cerr << "processing function: " << i << std::endl;
        nextLabel = 0;
        // process body
        assert(breakStack.empty());
        assert(expressionStack.empty());
        depth = 0;
        processExpressions();
        assert(expressionStack.size() == 1);
        func->body = popExpression();
        assert(depth == 0);
        assert(breakStack.empty());
        assert(expressionStack.empty());
      }
      currFunction = nullptr;
      functions.push_back(func);
    }
  }

  std::map<Export*, size_t> exportIndexes;

  void readExports() {
    if (debug) std::cerr << "== readExports" << std::endl;
    size_t num = getU32LEB();
    if (debug) std::cerr << "num: " << num << std::endl;
    for (size_t i = 0; i < num; i++) {
      if (debug) std::cerr << "read one" << std::endl;
      auto curr = allocator.alloc<Export>();
      auto index = getU32LEB();
      assert(index < functionTypes.size());
      curr->name = getInlineString();
      exportIndexes[curr] = index;
    }
  }

  std::vector<Name> breakStack;

  std::vector<Expression*> expressionStack;

  BinaryConsts::ASTNodes processExpressions() { // until an end or else marker
    while (1) {
      Expression* curr;
      auto ret = readExpression(curr);
      if (!curr) return ret;
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
      wasm.addFunction(func);
    }
    // now that we have names for each function, apply things

    if (startIndex >= 0) {
      wasm.start = wasm.functions[startIndex]->name;
    }

    for (auto& iter : exportIndexes) {
      Export* curr = iter.first;
      curr->value = wasm.functions[iter.second]->name;
      wasm.addExport(curr);
    }

    for (auto& iter : functionCalls) {
      size_t index = iter.first;
      auto& calls = iter.second;
      for (auto* call : calls) {
        call->target = wasm.functions[index]->name;
      }
    }

    for (size_t index : functionTable) {
      assert(index < wasm.functions.size());
      wasm.table.names.push_back(wasm.functions[index]->name);
    }
  }

  void readDataSegments() {
    if (debug) std::cerr << "== readDataSegments" << std::endl;
    auto num = getU32LEB();
    for (size_t i = 0; i < num; i++) {
      Memory::Segment curr;
      curr.offset = getU32LEB();
      auto size = getU32LEB();
      auto buffer = (char*)malloc(size);
      for (size_t j = 0; j < size; j++) {
        buffer[j] = char(getInt8());
      }
      curr.data = (const char*)buffer;
      curr.size = size;
      wasm.memory.segments.push_back(curr);
    }
  }

  std::vector<size_t> functionTable;

  void readFunctionTable() {
    if (debug) std::cerr << "== readFunctionTable" << std::endl;
    auto num = getU32LEB();
    for (size_t i = 0; i < num; i++) {
      auto index = getU32LEB();
      functionTable.push_back(index);
    }
  }

  void readNames() {
    if (debug) std::cerr << "== readNames" << std::endl;
    auto num = getU32LEB();
    for (size_t i = 0; i < num; i++) {
      functions[i]->name = getInlineString();
      auto numLocals = getU32LEB();
      assert(numLocals == 0); // TODO
    }
  }

  // AST reading

  int depth; // only for debugging

  BinaryConsts::ASTNodes readExpression(Expression*& curr) {
    if (debug) std::cerr << "zz recurse into " << ++depth << " at " << pos << std::endl;
    uint8_t code = getInt8();
    if (debug) std::cerr << "readExpression seeing " << (int)code << std::endl;
    switch (code) {
      case BinaryConsts::Block:        visitBlock((curr = allocator.alloc<Block>())->cast<Block>()); break;
      case BinaryConsts::If:           visitIf((curr = allocator.alloc<If>())->cast<If>());  break;
      case BinaryConsts::Loop:         visitLoop((curr = allocator.alloc<Loop>())->cast<Loop>()); break;
      case BinaryConsts::Br:
      case BinaryConsts::BrIf:         visitBreak((curr = allocator.alloc<Break>())->cast<Break>(), code); break; // code distinguishes br from br_if
      case BinaryConsts::TableSwitch:  visitSwitch((curr = allocator.alloc<Switch>())->cast<Switch>()); break;
      case BinaryConsts::CallFunction: visitCall((curr = allocator.alloc<Call>())->cast<Call>()); break;
      case BinaryConsts::CallImport:   visitCallImport((curr = allocator.alloc<CallImport>())->cast<CallImport>()); break;
      case BinaryConsts::CallIndirect: visitCallIndirect((curr = allocator.alloc<CallIndirect>())->cast<CallIndirect>()); break;
      case BinaryConsts::GetLocal:     visitGetLocal((curr = allocator.alloc<GetLocal>())->cast<GetLocal>()); break;
      case BinaryConsts::SetLocal:     visitSetLocal((curr = allocator.alloc<SetLocal>())->cast<SetLocal>()); break;
      case BinaryConsts::Select:       visitSelect((curr = allocator.alloc<Select>())->cast<Select>()); break;
      case BinaryConsts::Return:       visitReturn((curr = allocator.alloc<Return>())->cast<Return>()); break;
      case BinaryConsts::Nop:          visitNop((curr = allocator.alloc<Nop>())->cast<Nop>()); break;
      case BinaryConsts::Unreachable:  visitUnreachable((curr = allocator.alloc<Unreachable>())->cast<Unreachable>()); break;
      case BinaryConsts::End:
      case BinaryConsts::Else:         curr = nullptr; break;
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
    return BinaryConsts::ASTNodes(code);
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
  void visitIf(If *curr) {
    if (debug) std::cerr << "zz node: If" << std::endl;
    size_t start = expressionStack.size();
    auto next = processExpressions();
    size_t end = expressionStack.size();
    assert(end - start == 2);
    curr->ifTrue = popExpression();
    curr->condition = popExpression();
    if (next == BinaryConsts::Else) {
      size_t start = expressionStack.size();
      processExpressions();
      size_t end = expressionStack.size();
      assert(end - start == 1);
      curr->ifFalse = popExpression();
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
    curr->name = getBreakName(getU32LEB());
    if (code == BinaryConsts::BrIf) curr->condition = popExpression();
    curr->value = popExpression();
  }
  void visitSwitch(Switch *curr) {
    if (debug) std::cerr << "zz node: Switch" << std::endl;
    auto numTargets = getU32LEB();
    for (size_t i = 0; i < numTargets; i++) {
      curr->targets.push_back(getBreakName(getU32LEB()));
    }
    curr->default_ = getBreakName(getU32LEB());
    processExpressions();
    curr->condition = popExpression();
    processExpressions();
    curr->value = popExpression();
    if (curr->value->is<Nop>()) curr->value = nullptr;
  }
  void visitCall(Call *curr) {
    if (debug) std::cerr << "zz node: Call" << std::endl;
    auto index = getU32LEB();
    auto type = functionTypes[index];
    auto num = type->params.size();
    curr->operands.resize(num);
    for (size_t i = 0; i < num; i++) {
      curr->operands[num - i - 1] = popExpression();
    }
    curr->type = type->result;
    functionCalls[index].push_back(curr);
  }
  void visitCallImport(CallImport *curr) {
    if (debug) std::cerr << "zz node: CallImport" << std::endl;
    curr->target = wasm.imports[getU32LEB()]->name;
    auto type = wasm.getImport(curr->target)->type;
    assert(type);
    auto num = type->params.size();
    if (debug) std::cerr << "zz node: CallImport " << curr->target << " with type " << type->name << " and " << num << " params\n";
    curr->operands.resize(num);
    for (size_t i = 0; i < num; i++) {
      curr->operands[num - i - 1] = popExpression();
    }
    curr->type = type->result;
  }
  void visitCallIndirect(CallIndirect *curr) {
    if (debug) std::cerr << "zz node: CallIndirect" << std::endl;
    curr->fullType = wasm.functionTypes[getU32LEB()];
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
    curr->index = getU32LEB();
    assert(curr->index < currFunction->getNumLocals());
    curr->type = currFunction->getLocalType(curr->index);
  }
  void visitSetLocal(SetLocal *curr) {
    if (debug) std::cerr << "zz node: SetLocal" << std::endl;
    curr->index = getU32LEB();
    assert(curr->index < currFunction->getNumLocals());
    curr->value = popExpression();
    curr->type = curr->value->type;
  }

  void readMemoryAccess(uint32_t& alignment, size_t bytes, uint32_t& offset) {
    alignment = Pow2(getU32LEB());
    offset = getU32LEB();
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
      case BinaryConsts::I32Const: curr->value = Literal(getS32LEB()); break;
      case BinaryConsts::I64Const: curr->value = Literal(getS64LEB()); break;
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
      case BinaryConsts::I32EqZ:         curr->op = EqZ;           curr->type = i32; break;
      case BinaryConsts::I64EqZ:         curr->op = EqZ;           curr->type = i64; break;
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
