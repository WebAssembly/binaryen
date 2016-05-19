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

#include <cassert>
#include <istream>
#include <ostream>
#include <type_traits>

#include "wasm.h"
#include "wasm-traversal.h"
#include "asmjs/shared-constants.h"
#include "asm_v_wasm.h"
#include "wasm-builder.h"
#include "ast_utils.h"
#include "parsing.h"
#include "wasm-validator.h"

namespace wasm {

template<typename T, typename MiniT>
struct LEB {
  static_assert(sizeof(MiniT) == 1, "MiniT must be a byte");

  T value;

  LEB() {}
  LEB(T value) : value(value) {}

  bool hasMore(T temp, MiniT byte) {
    // for signed, we must ensure the last bit has the right sign, as it will zero extend
    return std::is_signed<T>::value ? (temp != 0 && int32_t(temp) != -1) || (value >= 0 && (byte & 64)) || (value < 0 && !(byte & 64)): (temp != 0);
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

  void read(std::function<MiniT()> get) {
    value = 0;
    T shift = 0;
    MiniT byte;
    while (1) {
      byte = get();
      bool last = !(byte & 128);
      T payload = byte & 127;
      typedef typename std::make_unsigned<T>::type mask_type;
      auto shift_mask = 0 == shift
                            ? ~mask_type(0)
                            : ((mask_type(1) << (sizeof(T) * 8 - shift)) - 1u);
      T significant_payload = payload & shift_mask;
      if (significant_payload != payload) {
        assert(std::is_signed<T>::value && last &&
               "dropped bits only valid for signed LEB");
      }
      value |= significant_payload << shift;
      if (last) break;
      shift += 7;
      assert(size_t(shift) < sizeof(T) * 8 && "LEB overflow");
    }
    // If signed LEB, then we might need to sign-extend. (compile should
    // optimize this out if not needed).
    if (std::is_signed<T>::value) {
      shift += 7;
      if ((byte & 64) && size_t(shift) < 8 * sizeof(T)) {
        size_t sext_bits = 8 * sizeof(T) - size_t(shift);
        value <<= sext_bits;
        value >>= sext_bits;
        assert(value < 0 && "sign-extend should produces a negative value");
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

enum Meta {
  Magic = 0x6d736100,
  Version = 11
};

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
  auto Start = "start";
};

enum FunctionEntry {
  Named = 1,
  Import = 2,
  Locals = 4,
  Export = 8
};

enum ASTNodes {
  CurrentMemory = 0x3b,
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
  I32EqZ = 0x5a,
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
  I64EqZ = 0xba,
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

  I32STruncF32        = 0x9d,
  I32STruncF64        = 0x9e,
  I32UTruncF32        = 0x9f,
  I32UTruncF64        = 0xa0,
  I32ConvertI64       = 0xa1,
  I64STruncF32        = 0xa2,
  I64STruncF64        = 0xa3,
  I64UTruncF32        = 0xa4,
  I64UTruncF64        = 0xa5,
  I64STruncI32        = 0xa6,
  I64UTruncI32        = 0xa7,
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
  I32ReinterpretF32   = 0xb4,
  I64ReinterpretF64   = 0xb5,
  I32RotR             = 0xb6,
  I32RotL             = 0xb7,
  I64RotR             = 0xb8,
  I64RotL             = 0xb9,

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

enum TypeForms {
  Basic = 0x40
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
    for (auto& func : wasm->functions) {
      if (func->type.isNull()) {
        func->type = ensureFunctionType(getSig(func.get()), wasm)->name;
      }
    }
  }

public:
  WasmBinaryWriter(Module* input, BufferWithRandomAccess& o, bool debug) : wasm(input), o(o), debug(debug) {
    prepare();
  }

  void write() {
    writeHeader();

    writeSignatures();
    writeImports();
    writeFunctionSignatures();
    writeFunctionTable();
    writeMemory();
    writeExports();
    writeStart();
    writeFunctions();
    writeDataSegments();
    writeNames();

    finishUp();
  }

  void writeHeader() {
    if (debug) std::cerr << "== writeHeader" << std::endl;
    o << int32_t(BinaryConsts::Magic); // magic number \0asm
    o << int32_t(BinaryConsts::Version);
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
      << int8_t(wasm->memory.exportName.is()); // export memory
    finishSection(start);
  }

  void writeSignatures() {
    if (wasm->functionTypes.size() == 0) return;
    if (debug) std::cerr << "== writeSignatures" << std::endl;
    auto start = startSection(BinaryConsts::Section::Signatures);
    o << U32LEB(wasm->functionTypes.size());
    for (auto& type : wasm->functionTypes) {
      if (debug) std::cerr << "write one" << std::endl;
      o << int8_t(BinaryConsts::TypeForms::Basic);
      o << U32LEB(type->params.size());
      for (auto param : type->params) {
        o << binaryWasmType(param);
      }
      if (type->result == none) {
        o << U32LEB(0);
      } else {
        o << U32LEB(1);
        o << binaryWasmType(type->result);
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
    for (auto& import : wasm->imports) {
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
    for (auto& curr : wasm->functions) {
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
      Function* function = wasm->getFunction(i);
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
    for (auto& curr : wasm->exports) {
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
      if (segment.data.size() > 0) num++;
    }
    auto start = startSection(BinaryConsts::Section::DataSegments);
    o << U32LEB(num);
    for (auto& segment : wasm->memory.segments) {
      if (segment.data.size() == 0) continue;
      o << U32LEB(segment.offset);
      writeInlineBuffer(&segment.data[0], segment.data.size());
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
    for (auto& curr : wasm->functions) {
      writeInlineString(curr->name.str);
      o << U32LEB(0); // TODO: locals
    }
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

  // emits a node, but if it is a block with no name, emit a list of its contents
  void recursePossibleBlockContents(Expression* curr) {
    auto* block = curr->dynCast<Block>();
    if (!block || (block->name.is() && BreakSeeker::has(curr, block->name))) {
      recurse(curr);
      return;
    }
    for (auto* child : block->list) {
      recurse(child);
    }
  }

  void visitIf(If *curr) {
    if (debug) std::cerr << "zz node: If" << std::endl;
    recurse(curr->condition);
    o << int8_t(BinaryConsts::If);
    breakStack.push_back(IMPOSSIBLE_CONTINUE); // the binary format requires this; we have a block if we need one; TODO: optimize
    recursePossibleBlockContents(curr->ifTrue); // TODO: emit block contents directly, if possible
    breakStack.pop_back();
    if (curr->ifFalse) {
      o << int8_t(BinaryConsts::Else);
      breakStack.push_back(IMPOSSIBLE_CONTINUE); // TODO ditto
      recursePossibleBlockContents(curr->ifFalse);
      breakStack.pop_back();
    }
    o << int8_t(BinaryConsts::End);
  }
  void visitLoop(Loop *curr) {
    if (debug) std::cerr << "zz node: Loop" << std::endl;
    o << int8_t(BinaryConsts::Loop);
    breakStack.push_back(curr->out);
    breakStack.push_back(curr->in);
    recursePossibleBlockContents(curr->body);
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
    }
    if (curr->condition) recurse(curr->condition);
    o << int8_t(curr->condition ? BinaryConsts::BrIf : BinaryConsts::Br)
      << U32LEB(curr->value ? 1 : 0) << U32LEB(getBreakIndex(curr->name));
  }
  void visitSwitch(Switch *curr) {
    if (debug) std::cerr << "zz node: Switch" << std::endl;
    if (curr->value) {
      recurse(curr->value);
    }
    recurse(curr->condition);
    o << int8_t(BinaryConsts::TableSwitch) << U32LEB(curr->value ? 1 : 0) << U32LEB(curr->targets.size());
    for (auto target : curr->targets) {
      o << uint32_t(getBreakIndex(target));
    }
    o << uint32_t(getBreakIndex(curr->default_));
  }
  void visitCall(Call *curr) {
    if (debug) std::cerr << "zz node: Call" << std::endl;
    for (auto* operand : curr->operands) {
      recurse(operand);
    }
    o << int8_t(BinaryConsts::CallFunction) << U32LEB(curr->operands.size()) << U32LEB(getFunctionIndex(curr->target));
  }
  void visitCallImport(CallImport *curr) {
    if (debug) std::cerr << "zz node: CallImport" << std::endl;
    for (auto* operand : curr->operands) {
      recurse(operand);
    }
    o << int8_t(BinaryConsts::CallImport) << U32LEB(curr->operands.size()) << U32LEB(getImportIndex(curr->target));
  }
  void visitCallIndirect(CallIndirect *curr) {
    if (debug) std::cerr << "zz node: CallIndirect" << std::endl;
    recurse(curr->target);
    for (auto* operand : curr->operands) {
      recurse(operand);
    }
    o << int8_t(BinaryConsts::CallIndirect) << U32LEB(curr->operands.size()) << U32LEB(getFunctionTypeIndex(curr->fullType->name));
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
      case ClzInt32:         o << int8_t(BinaryConsts::I32Clz); break;
      case CtzInt32:         o << int8_t(BinaryConsts::I32Ctz); break;
      case PopcntInt32:      o << int8_t(BinaryConsts::I32Popcnt); break;
      case EqZInt32:         o << int8_t(BinaryConsts::I32EqZ); break;
      case ClzInt64:         o << int8_t(BinaryConsts::I64Clz); break;
      case CtzInt64:         o << int8_t(BinaryConsts::I64Ctz); break;
      case PopcntInt64:      o << int8_t(BinaryConsts::I64Popcnt); break;
      case EqZInt64:         o << int8_t(BinaryConsts::I64EqZ); break;
      case NegFloat32:       o << int8_t(BinaryConsts::F32Neg); break;
      case AbsFloat32:       o << int8_t(BinaryConsts::F32Abs); break;
      case CeilFloat32:      o << int8_t(BinaryConsts::F32Ceil); break;
      case FloorFloat32:     o << int8_t(BinaryConsts::F32Floor); break;
      case TruncFloat32:     o << int8_t(BinaryConsts::F32Trunc); break;
      case NearestFloat32:   o << int8_t(BinaryConsts::F32NearestInt); break;
      case SqrtFloat32:      o << int8_t(BinaryConsts::F32Sqrt); break;
      case NegFloat64:       o << int8_t(BinaryConsts::F64Neg); break;
      case AbsFloat64:       o << int8_t(BinaryConsts::F64Abs); break;
      case CeilFloat64:      o << int8_t(BinaryConsts::F64Ceil); break;
      case FloorFloat64:     o << int8_t(BinaryConsts::F64Floor); break;
      case TruncFloat64:     o << int8_t(BinaryConsts::F64Trunc); break;
      case NearestFloat64:   o << int8_t(BinaryConsts::F64NearestInt); break;
      case SqrtFloat64:      o << int8_t(BinaryConsts::F64Sqrt); break;
      case ExtendSInt32:     o << int8_t(BinaryConsts::I64STruncI32); break;
      case ExtendUInt32:     o << int8_t(BinaryConsts::I64UTruncI32); break;
      case WrapInt64:        o << int8_t(BinaryConsts::I32ConvertI64); break;
      case TruncUFloat32ToInt32: o << int8_t(BinaryConsts::I32UTruncF32); break;
      case TruncUFloat32ToInt64: o << int8_t(BinaryConsts::I64UTruncF32); break;
      case TruncSFloat32ToInt32: o << int8_t(BinaryConsts::I32STruncF32); break;
      case TruncSFloat32ToInt64: o << int8_t(BinaryConsts::I64STruncF32); break;
      case TruncUFloat64ToInt32: o << int8_t(BinaryConsts::I32UTruncF64); break;
      case TruncUFloat64ToInt64: o << int8_t(BinaryConsts::I64UTruncF64); break;
      case TruncSFloat64ToInt32: o << int8_t(BinaryConsts::I32STruncF64); break;
      case TruncSFloat64ToInt64: o << int8_t(BinaryConsts::I64STruncF64); break;
      case ConvertUInt32ToFloat32: o << int8_t(BinaryConsts::F32UConvertI32); break;
      case ConvertUInt32ToFloat64: o << int8_t(BinaryConsts::F64UConvertI32); break;
      case ConvertSInt32ToFloat32: o << int8_t(BinaryConsts::F32SConvertI32); break;
      case ConvertSInt32ToFloat64: o << int8_t(BinaryConsts::F64SConvertI32); break;
      case ConvertUInt64ToFloat32: o << int8_t(BinaryConsts::F32UConvertI64); break;
      case ConvertUInt64ToFloat64: o << int8_t(BinaryConsts::F64UConvertI64); break;
      case ConvertSInt64ToFloat32: o << int8_t(BinaryConsts::F32SConvertI64); break;
      case ConvertSInt64ToFloat64: o << int8_t(BinaryConsts::F64SConvertI64); break;
      case DemoteFloat64:    o << int8_t(BinaryConsts::F32ConvertF64); break;
      case PromoteFloat32:   o << int8_t(BinaryConsts::F64ConvertF32); break;
      case ReinterpretFloat32: o << int8_t(BinaryConsts::I32ReinterpretF32); break;
      case ReinterpretFloat64: o << int8_t(BinaryConsts::I64ReinterpretF64); break;
      case ReinterpretInt32: o << int8_t(BinaryConsts::F32ReinterpretI32); break;
      case ReinterpretInt64: o << int8_t(BinaryConsts::F64ReinterpretI64); break;
      default: abort();
    }
  }
  void visitBinary(Binary *curr) {
    if (debug) std::cerr << "zz node: Binary" << std::endl;
    recurse(curr->left);
    recurse(curr->right);

    switch (curr->op) {
      case AddInt32:      o << int8_t(BinaryConsts::I32Add);     break;
      case SubInt32:      o << int8_t(BinaryConsts::I32Sub);     break;
      case MulInt32:      o << int8_t(BinaryConsts::I32Mul);     break;
      case DivSInt32:     o << int8_t(BinaryConsts::I32DivS);   break;
      case DivUInt32:     o << int8_t(BinaryConsts::I32DivU);   break;
      case RemSInt32:     o << int8_t(BinaryConsts::I32RemS);   break;
      case RemUInt32:     o << int8_t(BinaryConsts::I32RemU);   break;
      case AndInt32:      o << int8_t(BinaryConsts::I32And);     break;
      case OrInt32:       o << int8_t(BinaryConsts::I32Or);      break;
      case XorInt32:      o << int8_t(BinaryConsts::I32Xor);     break;
      case ShlInt32:      o << int8_t(BinaryConsts::I32Shl);     break;
      case ShrUInt32:     o << int8_t(BinaryConsts::I32ShrU);   break;
      case ShrSInt32:     o << int8_t(BinaryConsts::I32ShrS);   break;
      case RotLInt32:     o << int8_t(BinaryConsts::I32RotL);    break;
      case RotRInt32:     o << int8_t(BinaryConsts::I32RotR);    break;
      case EqInt32:       o << int8_t(BinaryConsts::I32Eq);      break;
      case NeInt32:       o << int8_t(BinaryConsts::I32Ne);      break;
      case LtSInt32:      o << int8_t(BinaryConsts::I32LtS);    break;
      case LtUInt32:      o << int8_t(BinaryConsts::I32LtU);    break;
      case LeSInt32:      o << int8_t(BinaryConsts::I32LeS);    break;
      case LeUInt32:      o << int8_t(BinaryConsts::I32LeU);    break;
      case GtSInt32:      o << int8_t(BinaryConsts::I32GtS);    break;
      case GtUInt32:      o << int8_t(BinaryConsts::I32GtU);    break;
      case GeSInt32:      o << int8_t(BinaryConsts::I32GeS);    break;
      case GeUInt32:      o << int8_t(BinaryConsts::I32GeU);    break;

      case AddInt64:      o << int8_t(BinaryConsts::I64Add);     break;
      case SubInt64:      o << int8_t(BinaryConsts::I64Sub);     break;
      case MulInt64:      o << int8_t(BinaryConsts::I64Mul);     break;
      case DivSInt64:     o << int8_t(BinaryConsts::I64DivS);   break;
      case DivUInt64:     o << int8_t(BinaryConsts::I64DivU);   break;
      case RemSInt64:     o << int8_t(BinaryConsts::I64RemS);   break;
      case RemUInt64:     o << int8_t(BinaryConsts::I64RemU);   break;
      case AndInt64:      o << int8_t(BinaryConsts::I64And);     break;
      case OrInt64:       o << int8_t(BinaryConsts::I64Or);      break;
      case XorInt64:      o << int8_t(BinaryConsts::I64Xor);     break;
      case ShlInt64:      o << int8_t(BinaryConsts::I64Shl);     break;
      case ShrUInt64:     o << int8_t(BinaryConsts::I64ShrU);   break;
      case ShrSInt64:     o << int8_t(BinaryConsts::I64ShrS);   break;
      case RotLInt64:     o << int8_t(BinaryConsts::I64RotL);    break;
      case RotRInt64:     o << int8_t(BinaryConsts::I64RotR);    break;
      case EqInt64:       o << int8_t(BinaryConsts::I64Eq);      break;
      case NeInt64:       o << int8_t(BinaryConsts::I64Ne);      break;
      case LtSInt64:      o << int8_t(BinaryConsts::I64LtS);    break;
      case LtUInt64:      o << int8_t(BinaryConsts::I64LtU);    break;
      case LeSInt64:      o << int8_t(BinaryConsts::I64LeS);    break;
      case LeUInt64:      o << int8_t(BinaryConsts::I64LeU);    break;
      case GtSInt64:      o << int8_t(BinaryConsts::I64GtS);    break;
      case GtUInt64:      o << int8_t(BinaryConsts::I64GtU);    break;
      case GeSInt64:      o << int8_t(BinaryConsts::I64GeS);    break;
      case GeUInt64:      o << int8_t(BinaryConsts::I64GeU);    break;

      case AddFloat32:      o << int8_t(BinaryConsts::F32Add);     break;
      case SubFloat32:      o << int8_t(BinaryConsts::F32Sub);     break;
      case MulFloat32:      o << int8_t(BinaryConsts::F32Mul);     break;
      case DivFloat32:      o << int8_t(BinaryConsts::F32Div);     break;
      case CopySignFloat32: o << int8_t(BinaryConsts::F32CopySign);break;
      case MinFloat32:      o << int8_t(BinaryConsts::F32Min);     break;
      case MaxFloat32:      o << int8_t(BinaryConsts::F32Max);     break;
      case EqFloat32:       o << int8_t(BinaryConsts::F32Eq);      break;
      case NeFloat32:       o << int8_t(BinaryConsts::F32Ne);      break;
      case LtFloat32:       o << int8_t(BinaryConsts::F32Lt);      break;
      case LeFloat32:       o << int8_t(BinaryConsts::F32Le);      break;
      case GtFloat32:       o << int8_t(BinaryConsts::F32Gt);      break;
      case GeFloat32:       o << int8_t(BinaryConsts::F32Ge);      break;

      case AddFloat64:      o << int8_t(BinaryConsts::F64Add);     break;
      case SubFloat64:      o << int8_t(BinaryConsts::F64Sub);     break;
      case MulFloat64:      o << int8_t(BinaryConsts::F64Mul);     break;
      case DivFloat64:      o << int8_t(BinaryConsts::F64Div);     break;
      case CopySignFloat64: o << int8_t(BinaryConsts::F64CopySign);break;
      case MinFloat64:      o << int8_t(BinaryConsts::F64Min);     break;
      case MaxFloat64:      o << int8_t(BinaryConsts::F64Max);     break;
      case EqFloat64:       o << int8_t(BinaryConsts::F64Eq);      break;
      case NeFloat64:       o << int8_t(BinaryConsts::F64Ne);      break;
      case LtFloat64:       o << int8_t(BinaryConsts::F64Lt);      break;
      case LeFloat64:       o << int8_t(BinaryConsts::F64Le);      break;
      case GtFloat64:       o << int8_t(BinaryConsts::F64Gt);      break;
      case GeFloat64:       o << int8_t(BinaryConsts::F64Ge);      break;
      default: abort();
    }
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
    }
    o << int8_t(BinaryConsts::Return) << U32LEB(curr->value ? 1 : 0);
  }
  void visitHost(Host *curr) {
    if (debug) std::cerr << "zz node: Host" << std::endl;
    switch (curr->op) {
      case CurrentMemory: {
        o << int8_t(BinaryConsts::CurrentMemory);
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
      else {
        std::cerr << "unfamiliar section: ";
        for (size_t i = 0; i < nameSize; i++) std::cerr << input[pos + i];
        std::cerr << std::endl;
        abort();
      }
      assert(pos == before + sectionSize);
    }

    processFunctions();

    if (!WasmValidator().validate(wasm)) {
      abort();
    }
  }

  bool more() {
    return pos < input.size();
  }

  uint8_t getInt8() {
    if (!more()) throw ParseException("unexpected end of input");
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
    if (x != y) throw ParseException("surprising value", 0, pos);
  }
  void verifyInt16(int16_t x) {
    int16_t y = getInt16();
    if (x != y) throw ParseException("surprising value", 0, pos);
  }
  void verifyInt32(int32_t x) {
    int32_t y = getInt32();
    if (x != y) throw ParseException("surprising value", 0, pos);
  }
  void verifyInt64(int64_t x) {
    int64_t y = getInt64();
    if (x != y) throw ParseException("surprising value", 0, pos);
  }
  void verifyFloat32(float x) {
    float y = getFloat32();
    if (x != y) throw ParseException("surprising value", 0, pos);
  }
  void verifyFloat64(double x) {
    double y = getFloat64();
    if (x != y) throw ParseException("surprising value", 0, pos);
  }

  void ungetInt8() {
    assert(pos > 0);
    if (debug) std::cerr << "ungetInt8 (at " << pos << ")" << std::endl;
    pos--;
  }

  void readHeader() {
    if (debug) std::cerr << "== readHeader" << std::endl;
    verifyInt32(BinaryConsts::Magic);
    verifyInt32(BinaryConsts::Version);
  }

  void readStart() {
    if (debug) std::cerr << "== readStart" << std::endl;
    startIndex = getU32LEB();
  }

  void readMemory() {
    if (debug) std::cerr << "== readMemory" << std::endl;
    wasm.memory.initial = getU32LEB();
    wasm.memory.max = getU32LEB();
    auto exportMemory = getInt8();
    if (exportMemory) {
      wasm.memory.exportName = Name("memory");
    }
  }

  void readSignatures() {
    if (debug) std::cerr << "== readSignatures" << std::endl;
    size_t numTypes = getU32LEB();
    if (debug) std::cerr << "num: " << numTypes << std::endl;
    for (size_t i = 0; i < numTypes; i++) {
      if (debug) std::cerr << "read one" << std::endl;
      auto curr = new FunctionType;
      auto form = getInt8();
      assert(form == BinaryConsts::TypeForms::Basic);
      size_t numParams = getU32LEB();
      if (debug) std::cerr << "num params: " << numParams << std::endl;
      for (size_t j = 0; j < numParams; j++) {
        curr->params.push_back(getWasmType());
      }
      auto numResults = getU32LEB();
      if (numResults == 0) {
        curr->result = none;
      } else {
        assert(numResults == 1);
        curr->result = getWasmType();
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
      auto curr = new Import;
      curr->name = Name(std::string("import$") + std::to_string(i));
      auto index = getU32LEB();
      assert(index < wasm.functionTypes.size());
      curr->type = wasm.getFunctionType(index);
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
      functionTypes.push_back(wasm.getFunctionType(index));
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
  size_t endOfFunction;

  void readFunctions() {
    if (debug) std::cerr << "== readFunctions" << std::endl;
    size_t total = getU32LEB();
    for (size_t i = 0; i < total; i++) {
      if (debug) std::cerr << "read one at " << pos << std::endl;
      size_t size = getU32LEB();
      assert(size > 0);
      endOfFunction = pos + size;
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
        Name::fromInt(i),
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
        func->body = getMaybeBlock();
        assert(depth == 0);
        assert(breakStack.empty());
        assert(expressionStack.empty());
        assert(pos == endOfFunction);
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
      auto curr = new Export;
      auto index = getU32LEB();
      assert(index < functionTypes.size());
      curr->name = getInlineString();
      exportIndexes[curr] = index;
    }
  }

  std::vector<Name> breakStack;

  std::vector<Expression*> expressionStack;

  BinaryConsts::ASTNodes lastSeparator = BinaryConsts::End;

  void processExpressions() { // until an end or else marker, or the end of the function
    while (1) {
      Expression* curr;
      auto ret = readExpression(curr);
      if (!curr) {
        lastSeparator = ret;
        return;
      }
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
      auto offset = getU32LEB();
      auto size = getU32LEB();
      std::vector<char> buffer;
      buffer.resize(size);
      for (size_t j = 0; j < size; j++) {
        buffer[j] = char(getInt8());
      }
      wasm.memory.segments.emplace_back(offset, (const char*)&buffer[0], size);
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
    if (pos == endOfFunction) {
      curr = nullptr;
      return BinaryConsts::End;
    }
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
        if (maybeVisitBinary(curr, code)) break;
        if (maybeVisitUnary(curr, code)) break;
        if (maybeVisitConst(curr, code)) break;
        if (maybeVisitLoad(curr, code)) break;
        if (maybeVisitStore(curr, code)) break;
        if (maybeVisitHost(curr, code)) break;
        std::cerr << "bad code 0x" << std::hex << (int)code << std::endl;
        abort();
      }
    }
    if (debug) std::cerr << "zz recurse from " << depth-- << " at " << pos << std::endl;
    return BinaryConsts::ASTNodes(code);
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

  Expression* getMaybeBlock() {
    auto start = expressionStack.size();
    processExpressions();
    size_t end = expressionStack.size();
    if (start - end == 1) {
      return popExpression();
    }
    auto* block = allocator.alloc<Block>();
    for (size_t i = start; i < end; i++) {
      block->list.push_back(expressionStack[i]);
    }
    block->finalize();
    expressionStack.resize(start);
    return block;
  }

  Expression* getBlock() {
    Name label = getNextLabel();
    breakStack.push_back(label);
    auto* block = Builder(wasm).blockify(getMaybeBlock());
    breakStack.pop_back();
    block->cast<Block>()->name = label;
    return block;
  }

  void visitIf(If *curr) {
    if (debug) std::cerr << "zz node: If" << std::endl;
    curr->condition = popExpression();
    curr->ifTrue = getBlock();
    if (lastSeparator == BinaryConsts::Else) {
      curr->ifFalse = getBlock();
      curr->finalize();
    }
    assert(lastSeparator == BinaryConsts::End);
  }
  void visitLoop(Loop *curr) {
    if (debug) std::cerr << "zz node: Loop" << std::endl;
    curr->out = getNextLabel();
    curr->in = getNextLabel();
    breakStack.push_back(curr->out);
    breakStack.push_back(curr->in);
    curr->body = getMaybeBlock();
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
    auto arity = getU32LEB();
    assert(arity == 0 || arity == 1);
    curr->name = getBreakName(getU32LEB());
    if (code == BinaryConsts::BrIf) curr->condition = popExpression();
    if (arity == 1) curr->value = popExpression();
    curr->finalize();
  }
  void visitSwitch(Switch *curr) {
    if (debug) std::cerr << "zz node: Switch" << std::endl;
    auto arity = getU32LEB();
    assert(arity == 0 || arity == 1);
    curr->condition = popExpression();
    if (arity == 1) curr->value = popExpression();
    auto numTargets = getU32LEB();
    for (size_t i = 0; i < numTargets; i++) {
      curr->targets.push_back(getBreakName(getInt32()));
    }
    curr->default_ = getBreakName(getInt32());
  }
  void visitCall(Call *curr) {
    if (debug) std::cerr << "zz node: Call" << std::endl;
    auto arity = getU32LEB();
    auto index = getU32LEB();
    auto type = functionTypes[index];
    auto num = type->params.size();
    assert(num == arity);
    curr->operands.resize(num);
    for (size_t i = 0; i < num; i++) {
      curr->operands[num - i - 1] = popExpression();
    }
    curr->type = type->result;
    functionCalls[index].push_back(curr);
  }
  void visitCallImport(CallImport *curr) {
    if (debug) std::cerr << "zz node: CallImport" << std::endl;
    auto arity = getU32LEB();
    curr->target = wasm.imports[getU32LEB()]->name;
    auto type = wasm.getImport(curr->target)->type;
    assert(type);
    auto num = type->params.size();
    assert(num == arity);
    if (debug) std::cerr << "zz node: CallImport " << curr->target << " with type " << type->name << " and " << num << " params\n";
    curr->operands.resize(num);
    for (size_t i = 0; i < num; i++) {
      curr->operands[num - i - 1] = popExpression();
    }
    curr->type = type->result;
  }
  void visitCallIndirect(CallIndirect *curr) {
    if (debug) std::cerr << "zz node: CallIndirect" << std::endl;
    auto arity = getU32LEB();
    curr->fullType = wasm.getFunctionType(getU32LEB());
    auto num = curr->fullType->params.size();
    assert(num == arity);
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

  void readMemoryAccess(Address& alignment, size_t bytes, Address& offset) {
    alignment = Pow2(getU32LEB());
    offset = getU32LEB();
  }

  bool maybeVisitLoad(Expression*& out, uint8_t code) {
    Load* curr;
    switch (code) {
      case BinaryConsts::I32LoadMem8S:  curr = allocator.alloc<Load>(); curr->bytes = 1; curr->type = i32; curr->signed_ = true; break;
      case BinaryConsts::I32LoadMem8U:  curr = allocator.alloc<Load>(); curr->bytes = 1; curr->type = i32; curr->signed_ = false; break;
      case BinaryConsts::I32LoadMem16S: curr = allocator.alloc<Load>(); curr->bytes = 2; curr->type = i32; curr->signed_ = true; break;
      case BinaryConsts::I32LoadMem16U: curr = allocator.alloc<Load>(); curr->bytes = 2; curr->type = i32; curr->signed_ = false; break;
      case BinaryConsts::I32LoadMem:    curr = allocator.alloc<Load>(); curr->bytes = 4; curr->type = i32; break;
      case BinaryConsts::I64LoadMem8S:  curr = allocator.alloc<Load>(); curr->bytes = 1; curr->type = i64; curr->signed_ = true; break;
      case BinaryConsts::I64LoadMem8U:  curr = allocator.alloc<Load>(); curr->bytes = 1; curr->type = i64; curr->signed_ = false; break;
      case BinaryConsts::I64LoadMem16S: curr = allocator.alloc<Load>(); curr->bytes = 2; curr->type = i64; curr->signed_ = true; break;
      case BinaryConsts::I64LoadMem16U: curr = allocator.alloc<Load>(); curr->bytes = 2; curr->type = i64; curr->signed_ = false; break;
      case BinaryConsts::I64LoadMem32S: curr = allocator.alloc<Load>(); curr->bytes = 4; curr->type = i64; curr->signed_ = true; break;
      case BinaryConsts::I64LoadMem32U: curr = allocator.alloc<Load>(); curr->bytes = 4; curr->type = i64; curr->signed_ = false; break;
      case BinaryConsts::I64LoadMem:    curr = allocator.alloc<Load>(); curr->bytes = 8; curr->type = i64; break;
      case BinaryConsts::F32LoadMem:    curr = allocator.alloc<Load>(); curr->bytes = 4; curr->type = f32; break;
      case BinaryConsts::F64LoadMem:    curr = allocator.alloc<Load>(); curr->bytes = 8; curr->type = f64; break;
      default: return false;
    }
    if (debug) std::cerr << "zz node: Load" << std::endl;
    readMemoryAccess(curr->align, curr->bytes, curr->offset);
    curr->ptr = popExpression();
    out = curr;
    return true;
  }
  bool maybeVisitStore(Expression*& out, uint8_t code) {
    Store* curr;
    switch (code) {
      case BinaryConsts::I32StoreMem8:  curr = allocator.alloc<Store>(); curr->bytes = 1; curr->type = i32; break;
      case BinaryConsts::I32StoreMem16: curr = allocator.alloc<Store>(); curr->bytes = 2; curr->type = i32; break;
      case BinaryConsts::I32StoreMem:   curr = allocator.alloc<Store>(); curr->bytes = 4; curr->type = i32; break;
      case BinaryConsts::I64StoreMem8:  curr = allocator.alloc<Store>(); curr->bytes = 1; curr->type = i64; break;
      case BinaryConsts::I64StoreMem16: curr = allocator.alloc<Store>(); curr->bytes = 2; curr->type = i64; break;
      case BinaryConsts::I64StoreMem32: curr = allocator.alloc<Store>(); curr->bytes = 4; curr->type = i64; break;
      case BinaryConsts::I64StoreMem:   curr = allocator.alloc<Store>(); curr->bytes = 8; curr->type = i64; break;
      case BinaryConsts::F32StoreMem:   curr = allocator.alloc<Store>(); curr->bytes = 4; curr->type = f32; break;
      case BinaryConsts::F64StoreMem:   curr = allocator.alloc<Store>(); curr->bytes = 8; curr->type = f64; break;
      default: return false;
    }
    if (debug) std::cerr << "zz node: Store" << std::endl;
    readMemoryAccess(curr->align, curr->bytes, curr->offset);
    curr->value = popExpression();
    curr->ptr = popExpression();
    out = curr;
    return true;
  }
  bool maybeVisitConst(Expression*& out, uint8_t code) {
    Const* curr;
    switch (code) {
      case BinaryConsts::I32Const: curr = allocator.alloc<Const>(); curr->value = Literal(getS32LEB()); break;
      case BinaryConsts::I64Const: curr = allocator.alloc<Const>(); curr->value = Literal(getS64LEB()); break;
      case BinaryConsts::F32Const: curr = allocator.alloc<Const>(); curr->value = Literal(getFloat32()); break;
      case BinaryConsts::F64Const: curr = allocator.alloc<Const>(); curr->value = Literal(getFloat64()); break;
      default: return false;
    }
    curr->type = curr->value.type;
    out = curr;
    if (debug) std::cerr << "zz node: Const" << std::endl;
    return true;
  }
  bool maybeVisitUnary(Expression*& out, uint8_t code) {
    Unary* curr;
    switch (code) {
      case BinaryConsts::I32Clz:         curr = allocator.alloc<Unary>(); curr->op = ClzInt32;      curr->type = i32; break;
      case BinaryConsts::I64Clz:         curr = allocator.alloc<Unary>(); curr->op = ClzInt64;      curr->type = i64; break;
      case BinaryConsts::I32Ctz:         curr = allocator.alloc<Unary>(); curr->op = CtzInt32;      curr->type = i32; break;
      case BinaryConsts::I64Ctz:         curr = allocator.alloc<Unary>(); curr->op = CtzInt64;      curr->type = i64; break;
      case BinaryConsts::I32Popcnt:      curr = allocator.alloc<Unary>(); curr->op = PopcntInt32;   curr->type = i32; break;
      case BinaryConsts::I64Popcnt:      curr = allocator.alloc<Unary>(); curr->op = PopcntInt64;   curr->type = i64; break;
      case BinaryConsts::I32EqZ:         curr = allocator.alloc<Unary>(); curr->op = EqZInt32;      curr->type = i32; break;
      case BinaryConsts::I64EqZ:         curr = allocator.alloc<Unary>(); curr->op = EqZInt64;      curr->type = i32; break;
      case BinaryConsts::F32Neg:         curr = allocator.alloc<Unary>(); curr->op = NegFloat32;    curr->type = f32; break;
      case BinaryConsts::F64Neg:         curr = allocator.alloc<Unary>(); curr->op = NegFloat64;           curr->type = f64; break;
      case BinaryConsts::F32Abs:         curr = allocator.alloc<Unary>(); curr->op = AbsFloat32;           curr->type = f32; break;
      case BinaryConsts::F64Abs:         curr = allocator.alloc<Unary>(); curr->op = AbsFloat64;           curr->type = f64; break;
      case BinaryConsts::F32Ceil:        curr = allocator.alloc<Unary>(); curr->op = CeilFloat32;          curr->type = f32; break;
      case BinaryConsts::F64Ceil:        curr = allocator.alloc<Unary>(); curr->op = CeilFloat64;          curr->type = f64; break;
      case BinaryConsts::F32Floor:       curr = allocator.alloc<Unary>(); curr->op = FloorFloat32;         curr->type = f32; break;
      case BinaryConsts::F64Floor:       curr = allocator.alloc<Unary>(); curr->op = FloorFloat64;         curr->type = f64; break;
      case BinaryConsts::F32NearestInt:  curr = allocator.alloc<Unary>(); curr->op = NearestFloat32;       curr->type = f32; break;
      case BinaryConsts::F64NearestInt:  curr = allocator.alloc<Unary>(); curr->op = NearestFloat64;       curr->type = f64; break;
      case BinaryConsts::F32Sqrt:        curr = allocator.alloc<Unary>(); curr->op = SqrtFloat32;          curr->type = f32; break;
      case BinaryConsts::F64Sqrt:        curr = allocator.alloc<Unary>(); curr->op = SqrtFloat64;          curr->type = f64; break;
      case BinaryConsts::F32UConvertI32: curr = allocator.alloc<Unary>(); curr->op = ConvertUInt32ToFloat32; curr->type = f32; break;
      case BinaryConsts::F64UConvertI32: curr = allocator.alloc<Unary>(); curr->op = ConvertUInt32ToFloat64; curr->type = f64; break;
      case BinaryConsts::F32SConvertI32: curr = allocator.alloc<Unary>(); curr->op = ConvertSInt32ToFloat32; curr->type = f32; break;
      case BinaryConsts::F64SConvertI32: curr = allocator.alloc<Unary>(); curr->op = ConvertSInt32ToFloat64; curr->type = f64; break;
      case BinaryConsts::F32UConvertI64: curr = allocator.alloc<Unary>(); curr->op = ConvertUInt64ToFloat32; curr->type = f32; break;
      case BinaryConsts::F64UConvertI64: curr = allocator.alloc<Unary>(); curr->op = ConvertUInt64ToFloat64; curr->type = f64; break;
      case BinaryConsts::F32SConvertI64: curr = allocator.alloc<Unary>(); curr->op = ConvertSInt64ToFloat32; curr->type = f32; break;
      case BinaryConsts::F64SConvertI64: curr = allocator.alloc<Unary>(); curr->op = ConvertSInt64ToFloat64; curr->type = f64; break;

      case BinaryConsts::I64STruncI32:  curr = allocator.alloc<Unary>(); curr->op = ExtendSInt32;  curr->type = i64; break;
      case BinaryConsts::I64UTruncI32:  curr = allocator.alloc<Unary>(); curr->op = ExtendUInt32;  curr->type = i64; break;
      case BinaryConsts::I32ConvertI64: curr = allocator.alloc<Unary>(); curr->op = WrapInt64;     curr->type = i32; break;

      case BinaryConsts::I32UTruncF32: curr = allocator.alloc<Unary>(); curr->op = TruncUFloat32ToInt32; curr->type = i32; break;
      case BinaryConsts::I32UTruncF64: curr = allocator.alloc<Unary>(); curr->op = TruncUFloat64ToInt32; curr->type = i32; break;
      case BinaryConsts::I32STruncF32: curr = allocator.alloc<Unary>(); curr->op = TruncSFloat32ToInt32; curr->type = i32; break;
      case BinaryConsts::I32STruncF64: curr = allocator.alloc<Unary>(); curr->op = TruncSFloat64ToInt32; curr->type = i32; break;
      case BinaryConsts::I64UTruncF32: curr = allocator.alloc<Unary>(); curr->op = TruncUFloat32ToInt64; curr->type = i64; break;
      case BinaryConsts::I64UTruncF64: curr = allocator.alloc<Unary>(); curr->op = TruncUFloat64ToInt64; curr->type = i64; break;
      case BinaryConsts::I64STruncF32: curr = allocator.alloc<Unary>(); curr->op = TruncSFloat32ToInt64; curr->type = i64; break;
      case BinaryConsts::I64STruncF64: curr = allocator.alloc<Unary>(); curr->op = TruncSFloat64ToInt64; curr->type = i64; break;

      case BinaryConsts::F32Trunc: curr = allocator.alloc<Unary>(); curr->op = TruncFloat32; curr->type = f32; break;
      case BinaryConsts::F64Trunc: curr = allocator.alloc<Unary>(); curr->op = TruncFloat64; curr->type = f64; break;

      case BinaryConsts::F32ConvertF64:     curr = allocator.alloc<Unary>(); curr->op = DemoteFloat64;     curr->type = f32; break;
      case BinaryConsts::F64ConvertF32:     curr = allocator.alloc<Unary>(); curr->op = PromoteFloat32;    curr->type = f64; break;
      case BinaryConsts::I32ReinterpretF32: curr = allocator.alloc<Unary>(); curr->op = ReinterpretFloat32;  curr->type = i32; break;
      case BinaryConsts::I64ReinterpretF64: curr = allocator.alloc<Unary>(); curr->op = ReinterpretFloat64;  curr->type = i64; break;
      case BinaryConsts::F32ReinterpretI32: curr = allocator.alloc<Unary>(); curr->op = ReinterpretInt32;    curr->type = f32; break;
      case BinaryConsts::F64ReinterpretI64: curr = allocator.alloc<Unary>(); curr->op = ReinterpretInt64;    curr->type = f64; break;

      default: return false;
    }
    if (debug) std::cerr << "zz node: Unary" << std::endl;
    curr->value = popExpression();
    out = curr;
    return true;
  }
  bool maybeVisitBinary(Expression*& out, uint8_t code) {
    Binary* curr;
    #define INT_TYPED_CODE(code) { \
      case BinaryConsts::I32##code: curr = allocator.alloc<Binary>(); curr->op = code##Int32; curr->type = i32; break; \
      case BinaryConsts::I64##code: curr = allocator.alloc<Binary>(); curr->op = code##Int64; curr->type = i64; break; \
    }
    #define FLOAT_TYPED_CODE(code) { \
      case BinaryConsts::F32##code: curr = allocator.alloc<Binary>(); curr->op = code##Float32; curr->type = f32; break; \
      case BinaryConsts::F64##code: curr = allocator.alloc<Binary>(); curr->op = code##Float64; curr->type = f64; break; \
    }
    #define TYPED_CODE(code) { \
      INT_TYPED_CODE(code) \
      FLOAT_TYPED_CODE(code) \
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
    out = curr;
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
    auto arity = getU32LEB();
    assert(arity == 0 || arity == 1);
    if (arity == 1) {
      curr->value = popExpression();
    }
  }
  bool maybeVisitHost(Expression*& out, uint8_t code) {
    Host* curr;
    switch (code) {
      case BinaryConsts::CurrentMemory: {
        curr = allocator.alloc<Host>();
        curr->op = CurrentMemory;
        curr->type = i32;
        break;
      }
      case BinaryConsts::GrowMemory: {
        curr = allocator.alloc<Host>();
        curr->op = GrowMemory;
        curr->operands.resize(1);
        curr->operands[0] = popExpression();
        break;
      }
      default: return false;
    }
    if (debug) std::cerr << "zz node: Host" << std::endl;
    curr->finalize();
    out = curr;
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
