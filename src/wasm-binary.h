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
    return std::is_signed<T>::value ? (temp != 0 && temp != -1) || (value >= 0 && (byte & 64)) || (value < 0 && !(byte & 64)) : (temp != 0);
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
    size_t before = -1;
    if (debug) {
      before = size();
      std::cerr << "writeU32LEB: " << x.value << " (at " << before << ")" << std::endl;
    }
    x.write(this);
    if (debug) {
      for (size_t i = before; i < size(); i++) {
        std::cerr << "  " << (int)at(i) << " (at " << i << ")\n";
      }
    }
    return *this;
  }
  BufferWithRandomAccess& operator<<(U64LEB x) {
    size_t before = -1;
    if (debug) {
      before = size();
      std::cerr << "writeU64LEB: " << x.value << " (at " << before << ")" << std::endl;
    }
    x.write(this);
    if (debug) {
      for (size_t i = before; i < size(); i++) {
        std::cerr << "  " << (int)at(i) << " (at " << i << ")\n";
      }
    }
    return *this;
  }
  BufferWithRandomAccess& operator<<(S32LEB x) {
    size_t before = -1;
    if (debug) {
      before = size();
      std::cerr << "writeS32LEB: " << x.value << " (at " << before << ")" << std::endl;
    }
    x.write(this);
    if (debug) {
      for (size_t i = before; i < size(); i++) {
        std::cerr << "  " << (int)at(i) << " (at " << i << ")\n";
      }
    }
    return *this;
  }
  BufferWithRandomAccess& operator<<(S64LEB x) {
    size_t before = -1;
    if (debug) {
      before = size();
      std::cerr << "writeS64LEB: " << x.value << " (at " << before << ")" << std::endl;
    }
    x.write(this);
    if (debug) {
      for (size_t i = before; i < size(); i++) {
        std::cerr << "  " << (int)at(i) << " (at " << i << ")\n";
      }
    }
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
  Version = 0x0c
};

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
  Data = 11
};

enum ElementType {
  AnyFunc = 0x20
};

namespace UserSections {
extern const char* Name;
}

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
  TeeLocal = 0x19,
  GetGlobal = 0xbb,
  SetGlobal = 0xbc,

  Unreachable = 0x00,
  Block = 0x01,
  Loop = 0x02,
  If = 0x03,
  Else = 0x04,
  Select = 0x05,
  Br = 0x06,
  BrIf = 0x07,
  TableSwitch = 0x08,
  Return = 0x09,
  Nop = 0x0a,
  Drop = 0x0b,
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


inline int8_t binaryWasmType(WasmType type) {
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
  bool debugInfo = true;

  MixedArena allocator;

  void prepare();
public:
  WasmBinaryWriter(Module* input, BufferWithRandomAccess& o, bool debug) : wasm(input), o(o), debug(debug) {
    prepare();
  }

  void setDebugInfo(bool set) { debugInfo = set; }

  void write();
  void writeHeader();
  int32_t writeU32LEBPlaceholder();
  void writeResizableLimits(Address initial, Address maximum, bool hasMaximum);
  int32_t startSection(BinaryConsts::Section code);
  void finishSection(int32_t start);
  void writeStart();
  void writeMemory();
  void writeTypes();
  int32_t getFunctionTypeIndex(Name type);
  void writeImports();

  std::map<Index, size_t> mappedLocals; // local index => index in compact form of [all int32s][all int64s]etc
  std::map<WasmType, size_t> numLocalsByType; // type => number of locals of that type in the compact form

  void mapLocals(Function* function);
  void writeFunctionSignatures();
  void writeExpression(Expression* curr);
  void writeFunctions();
  void writeGlobals();
  void writeExports();
  void writeDataSegments();

  std::map<Name, Index> mappedFunctions; // name of the Function => index. first imports, then internals
  std::map<Name, uint32_t> mappedGlobals; // name of the Global => index. first imported globals, then internal globals
  uint32_t getFunctionIndex(Name name);
  uint32_t getGlobalIndex(Name name);

  void writeFunctionTableDeclaration();
  void writeTableElements();
  void writeNames();

  // helpers
  void writeInlineString(const char* name);
  void writeInlineBuffer(const char* data, size_t size);

  struct Buffer {
    const char* data;
    size_t size;
    size_t pointerLocation;
    Buffer(const char* data, size_t size, size_t pointerLocation) : data(data), size(size), pointerLocation(pointerLocation) {}
  };

  std::vector<Buffer> buffersToWrite;

  void emitBuffer(const char* data, size_t size);
  void emitString(const char *str);
  void finishUp();

  // AST writing via visitors
  int depth = 0; // only for debugging

  void recurse(Expression*& curr);
  std::vector<Name> breakStack;

  void visitBlock(Block *curr);
  // emits a node, but if it is a block with no name, emit a list of its contents
  void recursePossibleBlockContents(Expression* curr);
  void visitIf(If *curr);
  void visitLoop(Loop *curr);
  int32_t getBreakIndex(Name name);
  void visitBreak(Break *curr);
  void visitSwitch(Switch *curr);
  void visitCall(Call *curr);
  void visitCallImport(CallImport *curr);
  void visitCallIndirect(CallIndirect *curr);
  void visitGetLocal(GetLocal *curr);
  void visitSetLocal(SetLocal *curr);
  void visitGetGlobal(GetGlobal *curr);
  void visitSetGlobal(SetGlobal *curr);
  void emitMemoryAccess(size_t alignment, size_t bytes, uint32_t offset);
  void visitLoad(Load *curr);
  void visitStore(Store *curr);
  void visitConst(Const *curr);
  void visitUnary(Unary *curr);
  void visitBinary(Binary *curr);
  void visitSelect(Select *curr);
  void visitReturn(Return *curr);
  void visitHost(Host *curr);
  void visitNop(Nop *curr);
  void visitUnreachable(Unreachable *curr);
  void visitDrop(Drop *curr);
};

class WasmBinaryBuilder {
  Module& wasm;
  MixedArena& allocator;
  std::vector<char>& input;
  bool debug;

  size_t pos = 0;
  Index startIndex = -1;

public:
  WasmBinaryBuilder(Module& wasm, std::vector<char>& input, bool debug) : wasm(wasm), allocator(wasm.allocator), input(input), debug(debug) {}

  void read();
  bool readUserSection();
  bool more() { return pos < input.size();}

  uint8_t getInt8();
  uint16_t getInt16();
  uint32_t getInt32();
  uint64_t getInt64();
  float getFloat32();
  double getFloat64();
  uint32_t getU32LEB();
  uint64_t getU64LEB();
  int32_t getS32LEB();
  int64_t getS64LEB();
  WasmType getWasmType();
  Name getString();
  Name getInlineString();
  void verifyInt8(int8_t x);
  void verifyInt16(int16_t x);
  void verifyInt32(int32_t x);
  void verifyInt64(int64_t x);
  void verifyFloat32(float x);
  void verifyFloat64(double x);
  void ungetInt8();
  void readHeader();
  void readStart();
  void readMemory();
  void readSignatures();

  std::vector<Name> functionImportIndexes; // index in function index space => name of function import

  // gets a name in the combined function import+defined function space
  Name getFunctionIndexName(Index i);
  void getResizableLimits(Address& initial, Address& max, Address defaultIfNoMax);
  void readImports();

  std::vector<FunctionType*> functionTypes; // types of defined functions

  void readFunctionSignatures();
  size_t nextLabel;

  Name getNextLabel() {
    return cashew::IString(("label$" + std::to_string(nextLabel++)).c_str(), false);
  }

  // We read functions before we know their names, so we need to backpatch the names later
  std::vector<Function*> functions; // we store functions here before wasm.addFunction after we know their names
  std::map<Index, std::vector<Call*>> functionCalls; // at index i we have all calls to the defined function i
  Function* currFunction = nullptr;
  Index endOfFunction = -1; // before we see a function (like global init expressions), there is no end of function to check

  void readFunctions();

  std::map<Export*, Index> exportIndexes;
  void readExports();

  Expression* readExpression();
  void readGlobals();

  struct BreakTarget { Name name; int arity;};
  std::vector<BreakTarget> breakStack;

  std::vector<Expression*> expressionStack;

  BinaryConsts::ASTNodes lastSeparator = BinaryConsts::End;

  void processExpressions();
  Expression* popExpression();

  std::map<Index, Name> mappedGlobals; // index of the Global => name. first imported globals, then internal globals

  Name getGlobalName(Index index);
  void processFunctions();
  void readDataSegments();

  std::map<Index, std::vector<Index>> functionTable;

  void readFunctionTableDeclaration();
  void readTableElements();
  void readNames();

  // AST reading
  int depth = 0; // only for debugging

  BinaryConsts::ASTNodes readExpression(Expression*& curr);
  void visitBlock(Block *curr);
  Expression* getMaybeBlock(WasmType type);
  Expression* getBlock(WasmType type);
  void visitIf(If *curr);
  void visitLoop(Loop *curr);
  BreakTarget getBreakTarget(int32_t offset);
  void visitBreak(Break *curr, uint8_t code);
  void visitSwitch(Switch *curr);

  template<typename T>
  void fillCall(T* call, FunctionType* type) {
    assert(type);
    auto num = type->params.size();
    call->operands.resize(num);
    for (size_t i = 0; i < num; i++) {
      call->operands[num - i - 1] = popExpression();
    }
    call->type = type->result;
  }

  Expression* visitCall();
  void visitCallIndirect(CallIndirect *curr);
  void visitGetLocal(GetLocal *curr);
  void visitSetLocal(SetLocal *curr, uint8_t code);
  void visitGetGlobal(GetGlobal *curr);
  void visitSetGlobal(SetGlobal *curr);
  void readMemoryAccess(Address& alignment, size_t bytes, Address& offset);
  bool maybeVisitLoad(Expression*& out, uint8_t code);
  bool maybeVisitStore(Expression*& out, uint8_t code);
  bool maybeVisitConst(Expression*& out, uint8_t code);
  bool maybeVisitUnary(Expression*& out, uint8_t code);
  bool maybeVisitBinary(Expression*& out, uint8_t code);
  void visitSelect(Select *curr);
  void visitReturn(Return *curr);
  bool maybeVisitHost(Expression*& out, uint8_t code);
  void visitNop(Nop *curr);
  void visitUnreachable(Unreachable *curr);
  void visitDrop(Drop *curr);
};

} // namespace wasm

#endif // wasm_wasm_binary_h
