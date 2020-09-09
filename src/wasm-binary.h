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
#include <ostream>
#include <type_traits>

#include "asm_v_wasm.h"
#include "asmjs/shared-constants.h"
#include "ir/import-utils.h"
#include "ir/module-utils.h"
#include "parsing.h"
#include "support/debug.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm-validator.h"
#include "wasm.h"

#define DEBUG_TYPE "binary"

namespace wasm {

enum {
  // the maximum amount of bytes we emit per LEB
  MaxLEB32Bytes = 5,
};

// wasm VMs on the web have decided to impose some limits on what they
// accept
enum WebLimitations : uint32_t {
  MaxDataSegments = 100 * 1000,
  MaxFunctionBodySize = 128 * 1024,
  MaxFunctionLocals = 50 * 1000
};

template<typename T, typename MiniT> struct LEB {
  static_assert(sizeof(MiniT) == 1, "MiniT must be a byte");

  T value;

  LEB() = default;
  LEB(T value) : value(value) {}

  bool hasMore(T temp, MiniT byte) {
    // for signed, we must ensure the last bit has the right sign, as it will
    // zero extend
    return std::is_signed<T>::value
             ? (temp != 0 && temp != T(-1)) || (value >= 0 && (byte & 64)) ||
                 (value < 0 && !(byte & 64))
             : (temp != 0);
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

  // @minimum: a minimum number of bytes to write, padding as necessary
  // returns the number of bytes written
  size_t writeAt(std::vector<uint8_t>* out, size_t at, size_t minimum = 0) {
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
    return offset;
  }

  LEB<T, MiniT>& read(std::function<MiniT()> get) {
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
        if (!(std::is_signed<T>::value && last)) {
          throw ParseException("LEB dropped bits only valid for signed LEB");
        }
      }
      value |= significant_payload << shift;
      if (last) {
        break;
      }
      shift += 7;
      if (size_t(shift) >= sizeof(T) * 8) {
        throw ParseException("LEB overflow");
      }
    }
    // If signed LEB, then we might need to sign-extend. (compile should
    // optimize this out if not needed).
    if (std::is_signed<T>::value) {
      shift += 7;
      if ((byte & 64) && size_t(shift) < 8 * sizeof(T)) {
        size_t sext_bits = 8 * sizeof(T) - size_t(shift);
        value <<= sext_bits;
        value >>= sext_bits;
        if (value >= 0) {
          throw ParseException(
            " LEBsign-extend should produce a negative value");
        }
      }
    }
    return *this;
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
public:
  BufferWithRandomAccess() = default;

  BufferWithRandomAccess& operator<<(int8_t x) {
    BYN_TRACE("writeInt8: " << (int)(uint8_t)x << " (at " << size() << ")\n");
    push_back(x);
    return *this;
  }
  BufferWithRandomAccess& operator<<(int16_t x) {
    BYN_TRACE("writeInt16: " << x << " (at " << size() << ")\n");
    push_back(x & 0xff);
    push_back(x >> 8);
    return *this;
  }
  BufferWithRandomAccess& operator<<(int32_t x) {
    BYN_TRACE("writeInt32: " << x << " (at " << size() << ")\n");
    push_back(x & 0xff);
    x >>= 8;
    push_back(x & 0xff);
    x >>= 8;
    push_back(x & 0xff);
    x >>= 8;
    push_back(x & 0xff);
    return *this;
  }
  BufferWithRandomAccess& operator<<(int64_t x) {
    BYN_TRACE("writeInt64: " << x << " (at " << size() << ")\n");
    push_back(x & 0xff);
    x >>= 8;
    push_back(x & 0xff);
    x >>= 8;
    push_back(x & 0xff);
    x >>= 8;
    push_back(x & 0xff);
    x >>= 8;
    push_back(x & 0xff);
    x >>= 8;
    push_back(x & 0xff);
    x >>= 8;
    push_back(x & 0xff);
    x >>= 8;
    push_back(x & 0xff);
    return *this;
  }
  BufferWithRandomAccess& operator<<(U32LEB x) {
    size_t before = -1;
    WASM_UNUSED(before);
    BYN_DEBUG(before = size(); std::cerr << "writeU32LEB: " << x.value
                                         << " (at " << before << ")"
                                         << std::endl;);
    x.write(this);
    BYN_DEBUG(for (size_t i = before; i < size(); i++) {
      std::cerr << "  " << (int)at(i) << " (at " << i << ")\n";
    });
    return *this;
  }
  BufferWithRandomAccess& operator<<(U64LEB x) {
    size_t before = -1;
    WASM_UNUSED(before);
    BYN_DEBUG(before = size(); std::cerr << "writeU64LEB: " << x.value
                                         << " (at " << before << ")"
                                         << std::endl;);
    x.write(this);
    BYN_DEBUG(for (size_t i = before; i < size(); i++) {
      std::cerr << "  " << (int)at(i) << " (at " << i << ")\n";
    });
    return *this;
  }
  BufferWithRandomAccess& operator<<(S32LEB x) {
    size_t before = -1;
    WASM_UNUSED(before);
    BYN_DEBUG(before = size(); std::cerr << "writeS32LEB: " << x.value
                                         << " (at " << before << ")"
                                         << std::endl;);
    x.write(this);
    BYN_DEBUG(for (size_t i = before; i < size(); i++) {
      std::cerr << "  " << (int)at(i) << " (at " << i << ")\n";
    });
    return *this;
  }
  BufferWithRandomAccess& operator<<(S64LEB x) {
    size_t before = -1;
    WASM_UNUSED(before);
    BYN_DEBUG(before = size(); std::cerr << "writeS64LEB: " << x.value
                                         << " (at " << before << ")"
                                         << std::endl;);
    x.write(this);
    BYN_DEBUG(for (size_t i = before; i < size(); i++) {
      std::cerr << "  " << (int)at(i) << " (at " << i << ")\n";
    });
    return *this;
  }

  BufferWithRandomAccess& operator<<(uint8_t x) { return *this << (int8_t)x; }
  BufferWithRandomAccess& operator<<(uint16_t x) { return *this << (int16_t)x; }
  BufferWithRandomAccess& operator<<(uint32_t x) { return *this << (int32_t)x; }
  BufferWithRandomAccess& operator<<(uint64_t x) { return *this << (int64_t)x; }

  BufferWithRandomAccess& operator<<(float x) {
    BYN_TRACE("writeFloat32: " << x << " (at " << size() << ")\n");
    return *this << Literal(x).reinterpreti32();
  }
  BufferWithRandomAccess& operator<<(double x) {
    BYN_TRACE("writeFloat64: " << x << " (at " << size() << ")\n");
    return *this << Literal(x).reinterpreti64();
  }

  void writeAt(size_t i, uint16_t x) {
    BYN_TRACE("backpatchInt16: " << x << " (at " << i << ")\n");
    (*this)[i] = x & 0xff;
    (*this)[i + 1] = x >> 8;
  }
  void writeAt(size_t i, uint32_t x) {
    BYN_TRACE("backpatchInt32: " << x << " (at " << i << ")\n");
    (*this)[i] = x & 0xff;
    x >>= 8;
    (*this)[i + 1] = x & 0xff;
    x >>= 8;
    (*this)[i + 2] = x & 0xff;
    x >>= 8;
    (*this)[i + 3] = x & 0xff;
  }

  // writes out an LEB to an arbitrary location. this writes the LEB as a full
  // 5 bytes, the fixed amount that can easily be set aside ahead of time
  void writeAtFullFixedSize(size_t i, U32LEB x) {
    BYN_TRACE("backpatchU32LEB: " << x.value << " (at " << i << ")\n");
    // fill all 5 bytes, we have to do this when backpatching
    x.writeAt(this, i, MaxLEB32Bytes);
  }
  // writes out an LEB of normal size
  // returns how many bytes were written
  size_t writeAt(size_t i, U32LEB x) {
    BYN_TRACE("writeAtU32LEB: " << x.value << " (at " << i << ")\n");
    return x.writeAt(this, i);
  }

  template<typename T> void writeTo(T& o) {
    for (auto c : *this) {
      o << c;
    }
  }

  std::vector<char> getAsChars() {
    std::vector<char> ret;
    ret.resize(size());
    std::copy(begin(), end(), ret.begin());
    return ret;
  }
};

namespace BinaryConsts {

enum Meta { Magic = 0x6d736100, Version = 0x01 };

enum Section {
  User = 0,
  Type = 1,
  Import = 2,
  Function = 3,
  Table = 4,
  Memory = 5,
  Global = 6,
  Export = 7,
  Start = 8,
  Element = 9,
  Code = 10,
  Data = 11,
  DataCount = 12,
  Event = 13
};

enum SegmentFlag {
  IsPassive = 0x01,
  HasMemIndex = 0x02,
};

enum EncodedType {
  // value_type
  i32 = -0x1,  // 0x7f
  i64 = -0x2,  // 0x7e
  f32 = -0x3,  // 0x7d
  f64 = -0x4,  // 0x7c
  v128 = -0x5, // 0x7b
  // function reference type
  funcref = -0x10, // 0x70
  // opaque host reference type
  externref = -0x11, // 0x6f
  // any reference type
  anyref = -0x12, // 0x6e
  // exception reference type
  exnref = -0x18, // 0x68
  // func_type form
  Func = -0x20, // 0x60
  // block_type
  Empty = -0x40 // 0x40
};

enum EncodedHeapType {
  func = -0x10,    // 0x70
  extern_ = -0x11, // 0x6f
  any = -0x12,     // 0x6e
  exn = -0x18,     // 0x68
};

namespace UserSections {
extern const char* Name;
extern const char* SourceMapUrl;
extern const char* Dylink;
extern const char* Linking;
extern const char* Producers;
extern const char* TargetFeatures;

extern const char* AtomicsFeature;
extern const char* BulkMemoryFeature;
extern const char* ExceptionHandlingFeature;
extern const char* MutableGlobalsFeature;
extern const char* TruncSatFeature;
extern const char* SignExtFeature;
extern const char* SIMD128Feature;
extern const char* ExceptionHandlingFeature;
extern const char* TailCallFeature;
extern const char* ReferenceTypesFeature;
extern const char* MultivalueFeature;
extern const char* AnyrefFeature;

enum Subsection {
  NameFunction = 1,
  NameLocal = 2,
};

} // namespace UserSections

enum ASTNodes {
  Unreachable = 0x00,
  Nop = 0x01,
  Block = 0x02,
  Loop = 0x03,
  If = 0x04,
  Else = 0x05,

  End = 0x0b,
  Br = 0x0c,
  BrIf = 0x0d,
  BrTable = 0x0e,
  Return = 0x0f,

  CallFunction = 0x10,
  CallIndirect = 0x11,
  RetCallFunction = 0x12,
  RetCallIndirect = 0x13,

  Drop = 0x1a,
  Select = 0x1b,
  SelectWithType = 0x1c, // added in reference types proposal

  LocalGet = 0x20,
  LocalSet = 0x21,
  LocalTee = 0x22,
  GlobalGet = 0x23,
  GlobalSet = 0x24,

  I32LoadMem = 0x28,
  I64LoadMem = 0x29,
  F32LoadMem = 0x2a,
  F64LoadMem = 0x2b,

  I32LoadMem8S = 0x2c,
  I32LoadMem8U = 0x2d,
  I32LoadMem16S = 0x2e,
  I32LoadMem16U = 0x2f,
  I64LoadMem8S = 0x30,
  I64LoadMem8U = 0x31,
  I64LoadMem16S = 0x32,
  I64LoadMem16U = 0x33,
  I64LoadMem32S = 0x34,
  I64LoadMem32U = 0x35,

  I32StoreMem = 0x36,
  I64StoreMem = 0x37,
  F32StoreMem = 0x38,
  F64StoreMem = 0x39,

  I32StoreMem8 = 0x3a,
  I32StoreMem16 = 0x3b,
  I64StoreMem8 = 0x3c,
  I64StoreMem16 = 0x3d,
  I64StoreMem32 = 0x3e,

  MemorySize = 0x3f,
  MemoryGrow = 0x40,

  I32Const = 0x41,
  I64Const = 0x42,
  F32Const = 0x43,
  F64Const = 0x44,

  I32EqZ = 0x45,
  I32Eq = 0x46,
  I32Ne = 0x47,
  I32LtS = 0x48,
  I32LtU = 0x49,
  I32GtS = 0x4a,
  I32GtU = 0x4b,
  I32LeS = 0x4c,
  I32LeU = 0x4d,
  I32GeS = 0x4e,
  I32GeU = 0x4f,
  I64EqZ = 0x50,
  I64Eq = 0x51,
  I64Ne = 0x52,
  I64LtS = 0x53,
  I64LtU = 0x54,
  I64GtS = 0x55,
  I64GtU = 0x56,
  I64LeS = 0x57,
  I64LeU = 0x58,
  I64GeS = 0x59,
  I64GeU = 0x5a,
  F32Eq = 0x5b,
  F32Ne = 0x5c,
  F32Lt = 0x5d,
  F32Gt = 0x5e,
  F32Le = 0x5f,
  F32Ge = 0x60,
  F64Eq = 0x61,
  F64Ne = 0x62,
  F64Lt = 0x63,
  F64Gt = 0x64,
  F64Le = 0x65,
  F64Ge = 0x66,

  I32Clz = 0x67,
  I32Ctz = 0x68,
  I32Popcnt = 0x69,
  I32Add = 0x6a,
  I32Sub = 0x6b,
  I32Mul = 0x6c,
  I32DivS = 0x6d,
  I32DivU = 0x6e,
  I32RemS = 0x6f,
  I32RemU = 0x70,
  I32And = 0x71,
  I32Or = 0x72,
  I32Xor = 0x73,
  I32Shl = 0x74,
  I32ShrS = 0x75,
  I32ShrU = 0x76,
  I32RotL = 0x77,
  I32RotR = 0x78,

  I64Clz = 0x79,
  I64Ctz = 0x7a,
  I64Popcnt = 0x7b,
  I64Add = 0x7c,
  I64Sub = 0x7d,
  I64Mul = 0x7e,
  I64DivS = 0x7f,
  I64DivU = 0x80,
  I64RemS = 0x81,
  I64RemU = 0x82,
  I64And = 0x83,
  I64Or = 0x84,
  I64Xor = 0x85,
  I64Shl = 0x86,
  I64ShrS = 0x87,
  I64ShrU = 0x88,
  I64RotL = 0x89,
  I64RotR = 0x8a,

  F32Abs = 0x8b,
  F32Neg = 0x8c,
  F32Ceil = 0x8d,
  F32Floor = 0x8e,
  F32Trunc = 0x8f,
  F32NearestInt = 0x90,
  F32Sqrt = 0x91,
  F32Add = 0x92,
  F32Sub = 0x93,
  F32Mul = 0x94,
  F32Div = 0x95,
  F32Min = 0x96,
  F32Max = 0x97,
  F32CopySign = 0x98,

  F64Abs = 0x99,
  F64Neg = 0x9a,
  F64Ceil = 0x9b,
  F64Floor = 0x9c,
  F64Trunc = 0x9d,
  F64NearestInt = 0x9e,
  F64Sqrt = 0x9f,
  F64Add = 0xa0,
  F64Sub = 0xa1,
  F64Mul = 0xa2,
  F64Div = 0xa3,
  F64Min = 0xa4,
  F64Max = 0xa5,
  F64CopySign = 0xa6,

  I32WrapI64 = 0xa7,
  I32STruncF32 = 0xa8,
  I32UTruncF32 = 0xa9,
  I32STruncF64 = 0xaa,
  I32UTruncF64 = 0xab,
  I64SExtendI32 = 0xac,
  I64UExtendI32 = 0xad,
  I64STruncF32 = 0xae,
  I64UTruncF32 = 0xaf,
  I64STruncF64 = 0xb0,
  I64UTruncF64 = 0xb1,
  F32SConvertI32 = 0xb2,
  F32UConvertI32 = 0xb3,
  F32SConvertI64 = 0xb4,
  F32UConvertI64 = 0xb5,
  F32DemoteI64 = 0xb6,
  F64SConvertI32 = 0xb7,
  F64UConvertI32 = 0xb8,
  F64SConvertI64 = 0xb9,
  F64UConvertI64 = 0xba,
  F64PromoteF32 = 0xbb,

  I32ReinterpretF32 = 0xbc,
  I64ReinterpretF64 = 0xbd,
  F32ReinterpretI32 = 0xbe,
  F64ReinterpretI64 = 0xbf,

  I32ExtendS8 = 0xc0,
  I32ExtendS16 = 0xc1,
  I64ExtendS8 = 0xc2,
  I64ExtendS16 = 0xc3,
  I64ExtendS32 = 0xc4,

  // prefixes

  MiscPrefix = 0xfc,
  SIMDPrefix = 0xfd,
  AtomicPrefix = 0xfe,

  // atomic opcodes

  AtomicNotify = 0x00,
  I32AtomicWait = 0x01,
  I64AtomicWait = 0x02,
  AtomicFence = 0x03,

  I32AtomicLoad = 0x10,
  I64AtomicLoad = 0x11,
  I32AtomicLoad8U = 0x12,
  I32AtomicLoad16U = 0x13,
  I64AtomicLoad8U = 0x14,
  I64AtomicLoad16U = 0x15,
  I64AtomicLoad32U = 0x16,
  I32AtomicStore = 0x17,
  I64AtomicStore = 0x18,
  I32AtomicStore8 = 0x19,
  I32AtomicStore16 = 0x1a,
  I64AtomicStore8 = 0x1b,
  I64AtomicStore16 = 0x1c,
  I64AtomicStore32 = 0x1d,

  AtomicRMWOps_Begin = 0x1e,
  I32AtomicRMWAdd = 0x1e,
  I64AtomicRMWAdd = 0x1f,
  I32AtomicRMWAdd8U = 0x20,
  I32AtomicRMWAdd16U = 0x21,
  I64AtomicRMWAdd8U = 0x22,
  I64AtomicRMWAdd16U = 0x23,
  I64AtomicRMWAdd32U = 0x24,
  I32AtomicRMWSub = 0x25,
  I64AtomicRMWSub = 0x26,
  I32AtomicRMWSub8U = 0x27,
  I32AtomicRMWSub16U = 0x28,
  I64AtomicRMWSub8U = 0x29,
  I64AtomicRMWSub16U = 0x2a,
  I64AtomicRMWSub32U = 0x2b,
  I32AtomicRMWAnd = 0x2c,
  I64AtomicRMWAnd = 0x2d,
  I32AtomicRMWAnd8U = 0x2e,
  I32AtomicRMWAnd16U = 0x2f,
  I64AtomicRMWAnd8U = 0x30,
  I64AtomicRMWAnd16U = 0x31,
  I64AtomicRMWAnd32U = 0x32,
  I32AtomicRMWOr = 0x33,
  I64AtomicRMWOr = 0x34,
  I32AtomicRMWOr8U = 0x35,
  I32AtomicRMWOr16U = 0x36,
  I64AtomicRMWOr8U = 0x37,
  I64AtomicRMWOr16U = 0x38,
  I64AtomicRMWOr32U = 0x39,
  I32AtomicRMWXor = 0x3a,
  I64AtomicRMWXor = 0x3b,
  I32AtomicRMWXor8U = 0x3c,
  I32AtomicRMWXor16U = 0x3d,
  I64AtomicRMWXor8U = 0x3e,
  I64AtomicRMWXor16U = 0x3f,
  I64AtomicRMWXor32U = 0x40,
  I32AtomicRMWXchg = 0x41,
  I64AtomicRMWXchg = 0x42,
  I32AtomicRMWXchg8U = 0x43,
  I32AtomicRMWXchg16U = 0x44,
  I64AtomicRMWXchg8U = 0x45,
  I64AtomicRMWXchg16U = 0x46,
  I64AtomicRMWXchg32U = 0x47,
  AtomicRMWOps_End = 0x47,

  AtomicCmpxchgOps_Begin = 0x48,
  I32AtomicCmpxchg = 0x48,
  I64AtomicCmpxchg = 0x49,
  I32AtomicCmpxchg8U = 0x4a,
  I32AtomicCmpxchg16U = 0x4b,
  I64AtomicCmpxchg8U = 0x4c,
  I64AtomicCmpxchg16U = 0x4d,
  I64AtomicCmpxchg32U = 0x4e,
  AtomicCmpxchgOps_End = 0x4e,

  // truncsat opcodes

  I32STruncSatF32 = 0x00,
  I32UTruncSatF32 = 0x01,
  I32STruncSatF64 = 0x02,
  I32UTruncSatF64 = 0x03,
  I64STruncSatF32 = 0x04,
  I64UTruncSatF32 = 0x05,
  I64STruncSatF64 = 0x06,
  I64UTruncSatF64 = 0x07,

  // SIMD opcodes

  V128Load = 0x00,
  I16x8LoadExtSVec8x8 = 0x01,
  I16x8LoadExtUVec8x8 = 0x02,
  I32x4LoadExtSVec16x4 = 0x03,
  I32x4LoadExtUVec16x4 = 0x04,
  I64x2LoadExtSVec32x2 = 0x05,
  I64x2LoadExtUVec32x2 = 0x06,
  V8x16LoadSplat = 0x07,
  V16x8LoadSplat = 0x08,
  V32x4LoadSplat = 0x09,
  V64x2LoadSplat = 0x0a,
  V128Store = 0x0b,

  V128Const = 0x0c,
  V8x16Shuffle = 0x0d,
  V8x16Swizzle = 0x0e,

  I8x16Splat = 0x0f,
  I16x8Splat = 0x10,
  I32x4Splat = 0x11,
  I64x2Splat = 0x12,
  F32x4Splat = 0x13,
  F64x2Splat = 0x14,

  I8x16ExtractLaneS = 0x15,
  I8x16ExtractLaneU = 0x16,
  I8x16ReplaceLane = 0x17,
  I16x8ExtractLaneS = 0x18,
  I16x8ExtractLaneU = 0x19,
  I16x8ReplaceLane = 0x1a,
  I32x4ExtractLane = 0x1b,
  I32x4ReplaceLane = 0x1c,
  I64x2ExtractLane = 0x1d,
  I64x2ReplaceLane = 0x1e,
  F32x4ExtractLane = 0x1f,
  F32x4ReplaceLane = 0x20,
  F64x2ExtractLane = 0x21,
  F64x2ReplaceLane = 0x22,

  I8x16Eq = 0x23,
  I8x16Ne = 0x24,
  I8x16LtS = 0x25,
  I8x16LtU = 0x26,
  I8x16GtS = 0x27,
  I8x16GtU = 0x28,
  I8x16LeS = 0x29,
  I8x16LeU = 0x2a,
  I8x16GeS = 0x2b,
  I8x16GeU = 0x2c,
  I16x8Eq = 0x2d,
  I16x8Ne = 0x2e,
  I16x8LtS = 0x2f,
  I16x8LtU = 0x30,
  I16x8GtS = 0x31,
  I16x8GtU = 0x32,
  I16x8LeS = 0x33,
  I16x8LeU = 0x34,
  I16x8GeS = 0x35,
  I16x8GeU = 0x36,
  I32x4Eq = 0x37,
  I32x4Ne = 0x38,
  I32x4LtS = 0x39,
  I32x4LtU = 0x3a,
  I32x4GtS = 0x3b,
  I32x4GtU = 0x3c,
  I32x4LeS = 0x3d,
  I32x4LeU = 0x3e,
  I32x4GeS = 0x3f,
  I32x4GeU = 0x40,
  F32x4Eq = 0x41,
  F32x4Ne = 0x42,
  F32x4Lt = 0x43,
  F32x4Gt = 0x44,
  F32x4Le = 0x45,
  F32x4Ge = 0x46,
  F64x2Eq = 0x47,
  F64x2Ne = 0x48,
  F64x2Lt = 0x49,
  F64x2Gt = 0x4a,
  F64x2Le = 0x4b,
  F64x2Ge = 0x4c,

  V128Not = 0x4d,
  V128And = 0x4e,
  V128AndNot = 0x4f,
  V128Or = 0x50,
  V128Xor = 0x51,
  V128Bitselect = 0x52,

  I8x16Abs = 0x60,
  I8x16Neg = 0x61,
  I8x16AnyTrue = 0x62,
  I8x16AllTrue = 0x63,
  I8x16Bitmask = 0x64,
  I8x16NarrowSI16x8 = 0x65,
  I8x16NarrowUI16x8 = 0x66,
  I8x16Shl = 0x6b,
  I8x16ShrS = 0x6c,
  I8x16ShrU = 0x6d,
  I8x16Add = 0x6e,
  I8x16AddSatS = 0x6f,
  I8x16AddSatU = 0x70,
  I8x16Sub = 0x71,
  I8x16SubSatS = 0x72,
  I8x16SubSatU = 0x73,
  I8x16Mul = 0x75,
  I8x16MinS = 0x76,
  I8x16MinU = 0x77,
  I8x16MaxS = 0x78,
  I8x16MaxU = 0x79,
  I8x16AvgrU = 0x7b,

  I16x8Abs = 0x80,
  I16x8Neg = 0x81,
  I16x8AnyTrue = 0x82,
  I16x8AllTrue = 0x83,
  I16x8Bitmask = 0x84,
  I16x8NarrowSI32x4 = 0x85,
  I16x8NarrowUI32x4 = 0x86,
  I16x8WidenLowSI8x16 = 0x87,
  I16x8WidenHighSI8x16 = 0x88,
  I16x8WidenLowUI8x16 = 0x89,
  I16x8WidenHighUI8x16 = 0x8a,
  I16x8Shl = 0x8b,
  I16x8ShrS = 0x8c,
  I16x8ShrU = 0x8d,
  I16x8Add = 0x8e,
  I16x8AddSatS = 0x8f,
  I16x8AddSatU = 0x90,
  I16x8Sub = 0x91,
  I16x8SubSatS = 0x92,
  I16x8SubSatU = 0x93,
  I16x8Mul = 0x95,
  I16x8MinS = 0x96,
  I16x8MinU = 0x97,
  I16x8MaxS = 0x98,
  I16x8MaxU = 0x99,
  I16x8AvgrU = 0x9b,

  I32x4Abs = 0xa0,
  I32x4Neg = 0xa1,
  I32x4AnyTrue = 0xa2,
  I32x4AllTrue = 0xa3,
  I32x4Bitmask = 0xa4,
  I32x4WidenLowSI16x8 = 0xa7,
  I32x4WidenHighSI16x8 = 0xa8,
  I32x4WidenLowUI16x8 = 0xa9,
  I32x4WidenHighUI16x8 = 0xaa,
  I32x4Shl = 0xab,
  I32x4ShrS = 0xac,
  I32x4ShrU = 0xad,
  I32x4Add = 0xae,
  I32x4Sub = 0xb1,
  I32x4Mul = 0xb5,
  I32x4MinS = 0xb6,
  I32x4MinU = 0xb7,
  I32x4MaxS = 0xb8,
  I32x4MaxU = 0xb9,
  I32x4DotSVecI16x8 = 0xba,

  I64x2Neg = 0xc1,
  I64x2AnyTrue = 0xc2,
  I64x2AllTrue = 0xc3,
  I64x2Shl = 0xcb,
  I64x2ShrS = 0xcc,
  I64x2ShrU = 0xcd,
  I64x2Add = 0xce,
  I64x2Sub = 0xd1,
  I64x2Mul = 0xd5,

  F32x4Abs = 0xe0,
  F32x4Neg = 0xe1,
  F32x4Sqrt = 0xe3,
  F32x4Add = 0xe4,
  F32x4Sub = 0xe5,
  F32x4Mul = 0xe6,
  F32x4Div = 0xe7,
  F32x4Min = 0xe8,
  F32x4Max = 0xe9,
  F32x4PMin = 0xea,
  F32x4PMax = 0xeb,

  F32x4Ceil = 0xd8,
  F32x4Floor = 0xd9,
  F32x4Trunc = 0xda,
  F32x4Nearest = 0xdb,
  F64x2Ceil = 0xdc,
  F64x2Floor = 0xdd,
  F64x2Trunc = 0xde,
  F64x2Nearest = 0xdf,

  F64x2Abs = 0xec,
  F64x2Neg = 0xed,
  F64x2Sqrt = 0xef,
  F64x2Add = 0xf0,
  F64x2Sub = 0xf1,
  F64x2Mul = 0xf2,
  F64x2Div = 0xf3,
  F64x2Min = 0xf4,
  F64x2Max = 0xf5,
  F64x2PMin = 0xf6,
  F64x2PMax = 0xf7,

  I32x4TruncSatSF32x4 = 0xf8,
  I32x4TruncSatUF32x4 = 0xf9,
  F32x4ConvertSI32x4 = 0xfa,
  F32x4ConvertUI32x4 = 0xfb,

  V128Load32Zero = 0xfc,
  V128Load64Zero = 0xfd,

  F32x4QFMA = 0xb4,
  F32x4QFMS = 0xd4,
  F64x2QFMA = 0xfe,
  F64x2QFMS = 0xff,

  I64x2TruncSatSF64x2 = 0x0100,
  I64x2TruncSatUF64x2 = 0x0101,
  F64x2ConvertSI64x2 = 0x0102,
  F64x2ConvertUI64x2 = 0x0103,

  // bulk memory opcodes

  MemoryInit = 0x08,
  DataDrop = 0x09,
  MemoryCopy = 0x0a,
  MemoryFill = 0x0b,

  // reference types opcodes

  RefNull = 0xd0,
  RefIsNull = 0xd1,
  RefFunc = 0xd2,

  // exception handling opcodes

  Try = 0x06,
  Catch = 0x07,
  Throw = 0x08,
  Rethrow = 0x09,
  BrOnExn = 0x0a
};

enum MemoryAccess {
  Offset = 0x10,    // bit 4
  Alignment = 0x80, // bit 7
  NaturalAlignment = 0
};

enum MemoryFlags { HasMaximum = 1 << 0, IsShared = 1 << 1 };

enum FeaturePrefix {
  FeatureUsed = '+',
  FeatureRequired = '=',
  FeatureDisallowed = '-'
};

} // namespace BinaryConsts

inline S32LEB binaryType(Type type) {
  int ret = 0;
  TODO_SINGLE_COMPOUND(type);
  switch (type.getBasic()) {
    // None only used for block signatures. TODO: Separate out?
    case Type::none:
      ret = BinaryConsts::EncodedType::Empty;
      break;
    case Type::i32:
      ret = BinaryConsts::EncodedType::i32;
      break;
    case Type::i64:
      ret = BinaryConsts::EncodedType::i64;
      break;
    case Type::f32:
      ret = BinaryConsts::EncodedType::f32;
      break;
    case Type::f64:
      ret = BinaryConsts::EncodedType::f64;
      break;
    case Type::v128:
      ret = BinaryConsts::EncodedType::v128;
      break;
    case Type::funcref:
      ret = BinaryConsts::EncodedType::funcref;
      break;
    case Type::externref:
      ret = BinaryConsts::EncodedType::externref;
      break;
    case Type::exnref:
      ret = BinaryConsts::EncodedType::exnref;
      break;
    case Type::anyref:
      ret = BinaryConsts::EncodedType::anyref;
      break;
    case Type::unreachable:
      WASM_UNREACHABLE("unexpected type");
  }
  return S32LEB(ret);
}

inline S32LEB binaryHeapType(HeapType type) {
  int ret = 0;
  switch (type.kind) {
    case HeapType::FuncKind:
      ret = BinaryConsts::EncodedHeapType::func;
      break;
    case HeapType::ExternKind:
      ret = BinaryConsts::EncodedHeapType::extern_;
      break;
    case HeapType::ExnKind:
      ret = BinaryConsts::EncodedHeapType::exn;
      break;
    case HeapType::AnyKind:
      ret = BinaryConsts::EncodedHeapType::any;
      break;
    case HeapType::EqKind:
    case HeapType::I31Kind:
    case HeapType::SignatureKind:
    case HeapType::StructKind:
    case HeapType::ArrayKind:
      WASM_UNREACHABLE("TODO: GC types");
  }
  return S32LEB(ret); // TODO: Actually encoded as s33
}

// Writes out wasm to the binary format

class WasmBinaryWriter {
  // Computes the indexes in a wasm binary, i.e., with function imports
  // and function implementations sharing a single index space, etc.,
  // and with the imports first (the Module's functions and globals
  // arrays are not assumed to be in a particular order, so we can't
  // just use them directly).
  struct BinaryIndexes {
    std::unordered_map<Name, Index> functionIndexes;
    std::unordered_map<Name, Index> eventIndexes;
    std::unordered_map<Name, Index> globalIndexes;

    BinaryIndexes(Module& wasm) {
      auto addIndexes = [&](auto& source, auto& indexes) {
        auto addIndex = [&](auto* curr) {
          auto index = indexes.size();
          indexes[curr->name] = index;
        };
        for (auto& curr : source) {
          if (curr->imported()) {
            addIndex(curr.get());
          }
        }
        for (auto& curr : source) {
          if (!curr->imported()) {
            addIndex(curr.get());
          }
        }
      };
      addIndexes(wasm.functions, functionIndexes);
      addIndexes(wasm.events, eventIndexes);

      // Globals may have tuple types in the IR, in which case they lower to
      // multiple globals, one for each tuple element, in the binary. Tuple
      // globals therefore occupy multiple binary indices, and we have to take
      // that into account when calculating indices.
      Index globalCount = 0;
      auto addGlobal = [&](auto* curr) {
        globalIndexes[curr->name] = globalCount;
        globalCount += curr->type.size();
      };
      for (auto& curr : wasm.globals) {
        if (curr->imported()) {
          addGlobal(curr.get());
        }
      }
      for (auto& curr : wasm.globals) {
        if (!curr->imported()) {
          addGlobal(curr.get());
        }
      }
    }
  };

public:
  WasmBinaryWriter(Module* input, BufferWithRandomAccess& o)
    : wasm(input), o(o), indexes(*input) {
    prepare();
  }

  // locations in the output binary for the various parts of the module
  struct TableOfContents {
    struct Entry {
      Name name;
      size_t offset; // where the entry starts
      size_t size;   // the size of the entry
      Entry(Name name, size_t offset, size_t size)
        : name(name), offset(offset), size(size) {}
    };
    std::vector<Entry> functionBodies;
  } tableOfContents;

  void setNamesSection(bool set) { debugInfo = set; }
  void setSourceMap(std::ostream* set, std::string url) {
    sourceMap = set;
    sourceMapUrl = url;
  }
  void setSymbolMap(std::string set) { symbolMap = set; }

  void write();
  void writeHeader();
  int32_t writeU32LEBPlaceholder();
  void writeResizableLimits(Address initial,
                            Address maximum,
                            bool hasMaximum,
                            bool shared);
  template<typename T> int32_t startSection(T code);
  void finishSection(int32_t start);
  int32_t startSubsection(BinaryConsts::UserSections::Subsection code);
  void finishSubsection(int32_t start);
  void writeStart();
  void writeMemory();
  void writeTypes();
  void writeImports();

  void writeFunctionSignatures();
  void writeExpression(Expression* curr);
  void writeFunctions();
  void writeGlobals();
  void writeExports();
  void writeDataCount();
  void writeDataSegments();
  void writeEvents();

  uint32_t getFunctionIndex(Name name) const;
  uint32_t getGlobalIndex(Name name) const;
  uint32_t getEventIndex(Name name) const;
  uint32_t getTypeIndex(Signature sig) const;

  void writeFunctionTableDeclaration();
  void writeTableElements();
  void writeNames();
  void writeSourceMapUrl();
  void writeSymbolMap();
  void writeLateUserSections();
  void writeUserSection(const UserSection& section);
  void writeFeaturesSection();
  void writeDylinkSection();

  void initializeDebugInfo();
  void writeSourceMapProlog();
  void writeSourceMapEpilog();
  void writeDebugLocation(const Function::DebugLocation& loc);
  void writeDebugLocation(Expression* curr, Function* func);
  void writeDebugLocationEnd(Expression* curr, Function* func);
  void writeExtraDebugLocation(Expression* curr,
                               Function* func,
                               BinaryLocations::DelimiterId id);

  // helpers
  void writeInlineString(const char* name);
  void writeEscapedName(const char* name);
  void writeInlineBuffer(const char* data, size_t size);

  struct Buffer {
    const char* data;
    size_t size;
    size_t pointerLocation;
    Buffer(const char* data, size_t size, size_t pointerLocation)
      : data(data), size(size), pointerLocation(pointerLocation) {}
  };

  std::vector<Buffer> buffersToWrite;

  void emitBuffer(const char* data, size_t size);
  void emitString(const char* str);
  void finishUp();

  Module* getModule() { return wasm; }

private:
  Module* wasm;
  BufferWithRandomAccess& o;
  BinaryIndexes indexes;
  std::unordered_map<Signature, Index> typeIndices;
  std::vector<Signature> types;

  bool debugInfo = true;
  std::ostream* sourceMap = nullptr;
  std::string sourceMapUrl;
  std::string symbolMap;

  MixedArena allocator;

  // storage of source map locations until the section is placed at its final
  // location (shrinking LEBs may cause changes there)
  std::vector<std::pair<size_t, const Function::DebugLocation*>>
    sourceMapLocations;
  size_t sourceMapLocationsSizeAtSectionStart;
  Function::DebugLocation lastDebugLocation;

  std::unique_ptr<ImportInfo> importInfo;

  // General debugging info: track locations as we write.
  BinaryLocations binaryLocations;
  size_t binaryLocationsSizeAtSectionStart;
  // Track the expressions that we added for the current function being
  // written, so that we can update those specific binary locations when
  // the function is written out.
  std::vector<Expression*> binaryLocationTrackedExpressionsForFunc;

  void prepare();
};

class WasmBinaryBuilder {
  Module& wasm;
  MixedArena& allocator;
  const std::vector<char>& input;
  std::istream* sourceMap;
  std::pair<uint32_t, Function::DebugLocation> nextDebugLocation;
  bool DWARF = false;

  size_t pos = 0;
  Index startIndex = -1;
  std::set<Function::DebugLocation> debugLocation;
  size_t codeSectionLocation;

  std::set<BinaryConsts::Section> seenSections;

  // All signatures present in the type section
  std::vector<Signature> signatures;

public:
  WasmBinaryBuilder(Module& wasm, const std::vector<char>& input)
    : wasm(wasm), allocator(wasm.allocator), input(input), sourceMap(nullptr),
      nextDebugLocation(0, {0, 0, 0}), debugLocation() {}

  void setDWARF(bool value) { DWARF = value; }
  void read();
  void readUserSection(size_t payloadLen);

  bool more() { return pos < input.size(); }

  uint8_t getInt8();
  uint16_t getInt16();
  uint32_t getInt32();
  uint64_t getInt64();
  uint8_t getLaneIndex(size_t lanes);
  // it is unsafe to return a float directly, due to ABI issues with the
  // signalling bit
  Literal getFloat32Literal();
  Literal getFloat64Literal();
  Literal getVec128Literal();
  uint32_t getU32LEB();
  uint64_t getU64LEB();
  int32_t getS32LEB();
  int64_t getS64LEB();
  Type getType();
  HeapType getHeapType();
  Type getConcreteType();
  Name getInlineString();
  void verifyInt8(int8_t x);
  void verifyInt16(int16_t x);
  void verifyInt32(int32_t x);
  void verifyInt64(int64_t x);
  void ungetInt8();
  void readHeader();
  void readStart();
  void readMemory();
  void readSignatures();

  // gets a name in the combined import+defined space
  Name getFunctionName(Index index);
  Name getGlobalName(Index index);
  Name getEventName(Index index);

  void getResizableLimits(Address& initial,
                          Address& max,
                          bool& shared,
                          Address defaultIfNoMax);
  void readImports();

  // The signatures of each function, given in the function section
  std::vector<Signature> functionSignatures;

  void readFunctionSignatures();
  size_t nextLabel;

  Name getNextLabel();

  // We read functions before we know their names, so we need to backpatch the
  // names later

  // we store functions here before wasm.addFunction after we know their names
  std::vector<Function*> functions;
  // we store function imports here before wasm.addFunctionImport after we know
  // their names
  std::vector<Function*> functionImports;
  // at index i we have all refs to the function i
  std::map<Index, std::vector<Expression*>> functionRefs;
  Function* currFunction = nullptr;
  // before we see a function (like global init expressions), there is no end of
  // function to check
  Index endOfFunction = -1;

  // Throws a parsing error if we are not in a function context
  void requireFunctionContext(const char* error);

  void readFunctions();

  std::map<Export*, Index> exportIndices;
  std::vector<Export*> exportOrder;
  void readExports();

  Expression* readExpression();
  void readGlobals();

  struct BreakTarget {
    Name name;
    Type type;
    BreakTarget(Name name, Type type) : name(name), type(type) {}
  };
  std::vector<BreakTarget> breakStack;
  // the names that breaks target. this lets us know if a block has breaks to it
  // or not.
  std::unordered_set<Name> breakTargetNames;

  std::vector<Expression*> expressionStack;

  // Control flow structure parsing: these have not just the normal binary
  // data for an instruction, but also some bytes later on like "end" or "else".
  // We must be aware of the connection between those things, for debug info.
  std::vector<Expression*> controlFlowStack;

  // Called when we parse the beginning of a control flow structure.
  void startControlFlow(Expression* curr);

  // Called when we parse a later part of a control flow structure, like "end"
  // or "else".
  void continueControlFlow(BinaryLocations::DelimiterId id, BinaryLocation pos);

  // set when we know code is unreachable in the sense of the wasm spec: we are
  // in a block and after an unreachable element. this helps parse stacky wasm
  // code, which can be unsuitable for our IR when unreachable.
  bool unreachableInTheWasmSense;

  // set when the current code being processed will not be emitted in the
  // output, which is the case when it is literally unreachable, for example,
  // (block $a
  //   (unreachable)
  //   (block $b
  //     ;; code here is reachable in the wasm sense, even though $b as a whole
  //     ;; is not
  //     (unreachable)
  //     ;; code here is unreachable in the wasm sense
  //   )
  // )
  bool willBeIgnored;

  BinaryConsts::ASTNodes lastSeparator = BinaryConsts::End;

  // process a block-type scope, until an end or else marker, or the end of the
  // function
  void processExpressions();
  void skipUnreachableCode();

  void pushExpression(Expression* curr);
  Expression* popExpression();
  Expression* popNonVoidExpression();
  Expression* popTuple(size_t numElems);
  Expression* popTypedExpression(Type type);

  void validateBinary(); // validations that cannot be performed on the Module
  void processFunctions();

  size_t dataCount = 0;
  bool hasDataCount = false;

  void readDataSegments();
  void readDataCount();

  std::map<Index, std::vector<Index>> functionTable;

  void readFunctionTableDeclaration();
  void readTableElements();

  void readEvents();

  static Name escape(Name name);
  void readNames(size_t);
  void readFeatures(size_t);
  void readDylink(size_t);

  // Debug information reading helpers
  void setDebugLocations(std::istream* sourceMap_) { sourceMap = sourceMap_; }
  std::unordered_map<std::string, Index> debugInfoFileIndices;
  void readNextDebugLocation();
  void readSourceMapHeader();

  void handleBrOnExnNotTaken(Expression* curr);

  // AST reading
  int depth = 0; // only for debugging

  BinaryConsts::ASTNodes readExpression(Expression*& curr);
  void pushBlockElements(Block* curr, Type type, size_t start);
  void visitBlock(Block* curr);

  // Gets a block of expressions. If it's just one, return that singleton.
  Expression* getBlockOrSingleton(Type type, unsigned numPops = 0);

  void visitIf(If* curr);
  void visitLoop(Loop* curr);
  BreakTarget getBreakTarget(int32_t offset);
  void visitBreak(Break* curr, uint8_t code);
  void visitSwitch(Switch* curr);

  void visitCall(Call* curr);
  void visitCallIndirect(CallIndirect* curr);
  void visitLocalGet(LocalGet* curr);
  void visitLocalSet(LocalSet* curr, uint8_t code);
  void visitGlobalGet(GlobalGet* curr);
  void visitGlobalSet(GlobalSet* curr);
  void readMemoryAccess(Address& alignment, Address& offset);
  bool maybeVisitLoad(Expression*& out, uint8_t code, bool isAtomic);
  bool maybeVisitStore(Expression*& out, uint8_t code, bool isAtomic);
  bool maybeVisitNontrappingTrunc(Expression*& out, uint32_t code);
  bool maybeVisitAtomicRMW(Expression*& out, uint8_t code);
  bool maybeVisitAtomicCmpxchg(Expression*& out, uint8_t code);
  bool maybeVisitAtomicWait(Expression*& out, uint8_t code);
  bool maybeVisitAtomicNotify(Expression*& out, uint8_t code);
  bool maybeVisitAtomicFence(Expression*& out, uint8_t code);
  bool maybeVisitConst(Expression*& out, uint8_t code);
  bool maybeVisitUnary(Expression*& out, uint8_t code);
  bool maybeVisitBinary(Expression*& out, uint8_t code);
  bool maybeVisitTruncSat(Expression*& out, uint32_t code);
  bool maybeVisitSIMDBinary(Expression*& out, uint32_t code);
  bool maybeVisitSIMDUnary(Expression*& out, uint32_t code);
  bool maybeVisitSIMDConst(Expression*& out, uint32_t code);
  bool maybeVisitSIMDStore(Expression*& out, uint32_t code);
  bool maybeVisitSIMDExtract(Expression*& out, uint32_t code);
  bool maybeVisitSIMDReplace(Expression*& out, uint32_t code);
  bool maybeVisitSIMDShuffle(Expression*& out, uint32_t code);
  bool maybeVisitSIMDTernary(Expression*& out, uint32_t code);
  bool maybeVisitSIMDShift(Expression*& out, uint32_t code);
  bool maybeVisitSIMDLoad(Expression*& out, uint32_t code);
  bool maybeVisitMemoryInit(Expression*& out, uint32_t code);
  bool maybeVisitDataDrop(Expression*& out, uint32_t code);
  bool maybeVisitMemoryCopy(Expression*& out, uint32_t code);
  bool maybeVisitMemoryFill(Expression*& out, uint32_t code);
  void visitSelect(Select* curr, uint8_t code);
  void visitReturn(Return* curr);
  bool maybeVisitHost(Expression*& out, uint8_t code);
  void visitNop(Nop* curr);
  void visitUnreachable(Unreachable* curr);
  void visitDrop(Drop* curr);
  void visitRefNull(RefNull* curr);
  void visitRefIsNull(RefIsNull* curr);
  void visitRefFunc(RefFunc* curr);
  void visitTry(Try* curr);
  void visitThrow(Throw* curr);
  void visitRethrow(Rethrow* curr);
  void visitBrOnExn(BrOnExn* curr);

  void throwError(std::string text);

private:
  bool hasDWARFSections();
};

} // namespace wasm

#undef DEBUG_TYPE

#endif // wasm_wasm_binary_h
