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
#include <sstream>

#include "wasm.h"
#include "shared-constants.h"

namespace wasm {

struct LEB128 {
  int32_t value;
  LEB128(int32_t value) : value(value) {}
};

// We mostly stream into a buffer as we create the binary format, however,
// sometimes we need to backtrack and write to a location behind us.
class BufferWithRandomAccess : public std::vector<unsigned char> {
public:
  BufferWithRandomAccess& operator<<(int8_t x) {
    push_back(x);
    return *this;
  }
  BufferWithRandomAccess& operator<<(int16_t x) {
    push_back(x & 0xff);
    push_back(x >> 8);
    return *this;
  }
  BufferWithRandomAccess& operator<<(int32_t x) {
    push_back(x & 0xff); x >>= 8;
    push_back(x & 0xff); x >>= 8;
    push_back(x & 0xff); x >>= 8;
    push_back(x & 0xff);
    return *this;
  }
  BufferWithRandomAccess& operator<<(int64_t x) {
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
    // XXX TODO
    magic
    return *this;
  }

  void writeAt(size_t i, int16_t x) {
    (*this)[i] = x & 0xff;
    (*this)[i+1] = x >> 8;
  }
  void writeAt(size_t i, int32_t x) {
    (*this)[i] = x & 0xff; x >>= 8;
    (*this)[i+1] = x & 0xff; x >>= 8;
    (*this)[i+2] = x & 0xff; x >>= 8;
    (*this)[i+3] = x & 0xff;
  }

  friend ostream& operator<<(ostream& o, BufferWithRandomAccess& b) {
    for (auto c : b) o << c;
  }
};

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
  I32Ior = 0x48,
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
  I64Ior = 0x63,
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
  BufferWithRandomAccess& o;

public:
  WasmBinaryWriter(Module* wasm, BufferWithRandomAccess& o) : wasm(wasm), o(o) {}

  void write() {
    writeMemory();
    writeSignatures();
    writeFunctions();
    writeDataSegments();
    writeFunctionTable();
    writeEnd();
  }

  writeMemory() {
    o << Section::Memory << int8_t(log2(wasm.memory.initial)) <<
                            int8_t(log2(wasm.memory.max)) <<
                            int8_t(1); // export memory
  }

  writeSignatures() {
    o << Section::Signatures << LEB128(wasm.functionTypes.size());
    for (auto type : wasm.functionTypes) {
      o << int8_t(type->params.size());
      o << binaryWasmType(type->result);
      for (auto param : type->params) {
        o << binaryWasmType(param);
      }
    }
  }

  int16_t getFunctionTypeIndex(Name type) {
    // TODO: optimize
    for (size_t i = 0; i < wasm.functionTypes.size(); i++) {
      if (wasm.functionTypes[i].name == type) return i;
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
      o << getFunctionTypeIndex(type);
      o << int8_t(FunctionEntry::Named |
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
        size_t curr = o.size();
        visit(function->body);
        o.writeAt(curr, uint16_t(o.size() - curr));
      }
    }
  }

  writeDataSegments() {
    o << Section::DataSegments << LEB128(wasm.memory.segments.size());
    for (auto& segment : wasm.memory.segments) {
      o << int32_t(segment.offset)
        << int32_t(XXX) // TODO: where/when do we emit this?
        << int32_t(segment.size)
        << int8_t(1); // load at program start
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

  // AST writing via visitors

  std::vector<Name> breakStack;

  void visitBlock(Block *curr) {
    o << int8_t(ASTNodes::Block) << int8_t(curr->list.size());
    breakStack.push_back(curr->name);
    for (auto child : curr->list) {
      visit(child);
    }
    breakStack.pop_back();
  }
  void visitIf(If *curr) {
    o << int8_t(curr->ifFalse ? ASTNodes::IfElse : ASTNodes::If);
    visit(curr->condition);
    visit(curr->ifTrue);
    if (curr->ifFalse) visit(curr->ifFalse);
  }
  void visitLoop(Loop *curr) {
    // TODO: optimize, as we usually have a block as our singleton child
    o << int8_t(ASTNodes::Loop) << int8_t(1);
    breakStack.push_back(curr->out);
    breakStack.push_back(curr->in);
    visit(curr->body);
    breakStack.pop_back();
    breakStack.pop_back();
  }
  void visitBreak(Break *curr) {
    o << int8_t(ASTNodes::Br);
    for (int i = breakStack.size() - 1; i >= 0; i--) {
      if (breakStack[i] == curr->name) {
        o << int8_t(breakStack.size() - 1 - i);
        return;
      }
    }
    abort();
  }
  void visitSwitch(Switch *curr) {
    o << int8_t(ASTNodes::TableSwitch) << int16_t(curr->cases.size())
                                     << int16_t(curr->targets.size());
    abort(); // WTF
  }
  void visitCall(Call *curr) {
    o << int8_t(ASTNodes::CallFunction) << LEB128(getFunctionIndex(curr->target));
    for (auto operand : curr->operands) {
      visit(operand);
    }
  }
  void visitCallImport(CallImport *curr) {
    o << int8_t(ASTNodes::CallFunction) << LEB128(getFunctionIndex(curr->target));
    for (auto operand : curr->operands) {
      visit(operand);
    }
  }
  void visitCallIndirect(CallIndirect *curr) {
    o << int8_t(ASTNodes::CallFunction) << LEB128(getFunctionTypeIndex(curr->functionType));
    for (auto operand : curr->operands) {
      visit(operand);
    }
  }
  void visitGetLocal(GetLocal *curr) {
    o << int8_t(ASTNodes::GetLocal) << LEB128(mappedLocals[curr->name]);
  }
  void visitSetLocal(SetLocal *curr) {
    o << int8_t(ASTNodes::SetLocal) << LEB128(mappedLocals[curr->name]);
    visit(curr->value);
  }

  void emitMemoryAccess(size_t alignment, size_t bytes, uint32_t offset)
    o << int8_t( (alignment == bytes || alignment == 0) ? 0 : 128) |
               (offset ? 8 : 0) );
    if (offset) o << LEB128(offset);
  }

  void visitLoad(Load *curr) {
    switch (curr->type) {
      case i32: {
        switch (curr->bytes) {
          case 1: o << int8_t(curr->signed_ ? ASTNodes::I32LoadMem8S : ASTNodes::I32LoadMem8U); break;
          case 2: o << int8_t(curr->signed_ ? ASTNodes::I32LoadMem16S : ASTNodes::I32LoadMem16U); break;
          case 4: o << int8_t(ASTNodes::I32LoadMem); break;
          default: abort();
        }
        break;
      }
      case i64: {
        switch (curr->bytes) {
          case 1: o << int8_t(curr->signed_ ? ASTNodes::I64LoadMem8S : ASTNodes::I64LoadMem8U); break;
          case 2: o << int8_t(curr->signed_ ? ASTNodes::I64LoadMem16S : ASTNodes::I64LoadMem16U); break;
          case 4: o << int8_t(curr->signed_ ? ASTNodes::I64LoadMem32S : ASTNodes::I64LoadMem32U); break;
          case 8: o << int8_t(ASTNodes::I64LoadMem); break;
          default: abort();
        }
        break;
      }
      case f32: o << int8_t(ASTNodes::F32LoadMem); break;
      case f64: o << int8_t(ASTNodes::F64LoadMem); break;
      default: abort();
    }
    emitMemoryAccess(curr->alignment, curr->bytes, curr->offset);
    visit(curr->ptr);
  }
  void visitStore(Store *curr) {
    switch (curr->type) {
      case i32: {
        switch (curr->bytes) {
          case 1: o << int8_t(ASTNodes::I32StoreMem8); break;
          case 2: o << int8_t(ASTNodes::I32StoreMem16); break;
          case 4: o << int8_t(ASTNodes::I32StoreMem); break;
          default: abort();
        }
        break;
      }
      case i64: {
        switch (curr->bytes) {
          case 1: o << int8_t(ASTNodes::I64StoreMem8); break;
          case 2: o << int8_t(ASTNodes::I64StoreMem16); break;
          case 4: o << int8_t(ASTNodes::I64StoreMem32); break;
          case 8: o << int8_t(ASTNodes::I64StoreMem); break;
          default: abort();
        }
        break;
      }
      case f32: o << int8_t(ASTNodes::F32StoreMem); break;
      case f64: o << int8_t(ASTNodes::F64StoreMem); break;
      default: abort();
    }
    emitMemoryAccess(curr->alignment, curr->bytes, curr->offset);
    visit(curr->ptr);
    visit(curr->value);
  }
  void visitConst(Const *curr) {
    switch (curr->type) {
      case i32: {
        int32_t value = curr->value.i32;
        if (value >= -128 && value <= 127) {
          o << int8_t(ASTNodes::I8Const) << int8_t(value);
          break;
        }
        o << int8_t(ASTNodes::I32Const) << value;
        break;
      }
      case i64: {
        o << int8_t(ASTNodes::I64Const) << curr->value.i64;
        break;
      }
      case f32: {
        o << int8_t(ASTNodes::F32Const) << curr->value.f32;
        break;
      }
      case f64: {
        o << int8_t(ASTNodes::F64Const) << curr->value.f64;
        break;
      }
      default: abort();
    }
  }
  void visitUnary(Unary *curr) {
    switch (op) {
      case Clz:              o << int8_t(curr->type == i32 ? I32Clz : I64Clz); break;
      case Ctz:              o << int8_t(curr->type == i32 ? I32Ctz : I64Ctz); break;
      case Popcnt:           o << int8_t(curr->type == i32 ? I32Popcnt : I64Popcnt); break;
      case Neg:              o << int8_t(curr->type == f32 ? F32Neg : F64Neg); break;
      case Abs:              o << int8_t(curr->type == f32 ? F32Abs : F64Abs); break;
      case Ceil:             o << int8_t(curr->type == f32 ? F32Ceil : F64Ceil); break;
      case Floor:            o << int8_t(curr->type == f32 ? F32Floor : F64Floor); break;
      case Trunc:            o << int8_t(curr->type == f32 ? F32Trunc : F64Trunc); break;;
      case Nearest:          o << int8_t(curr->type == f32 ? F32NearestInt : F64NearestInt); break;
      case Sqrt:             o << int8_t(curr->type == f32 ? F32Sqrt : F64Sqrt); break;
      case ExtendSInt32:     o << "extend_s/i32"; break;
      case ExtendUInt32:     o << "extend_u/i32"; break;
      case WrapInt64:        o << "wrap/i64"; break;
      case TruncSFloat32:    // XXX no signe/dunsigned versions of trunc?
      case TruncUFloat32:    // XXX
      case TruncSFloat64:    // XXX
      case TruncUFloat64:    // XXX
      case ReinterpretFloat: // XXX missing
      case ConvertUInt32:    o << int8_t(curr->type == f32 ? I32UConvertF32 : I32UConvertF64); break;
      case ConvertSInt32:    o << int8_t(curr->type == f32 ? I32SConvertF32 : I32SConvertF64); break;
      case ConvertUInt64:    o << int8_t(curr->type == f32 ? I64UConvertF32 : I64UConvertF64); break;
      case ConvertSInt64:    o << int8_t(curr->type == f32 ? I64UConvertF32 : I64UConvertF64); break;
      case PromoteFloat32:   // XXX
      case DemoteFloat64:    // XXX
      case ReinterpretInt:   // XXX
      default: abort();
    }
    visit(curr->value);
  }
  void visitBinary(Binary *curr) {
    #define TYPED_CODE(code) { \
      switch (curr->left->type) { \
        case i32: o << int8_t(I32##code); break; \
        case i64: o << int8_t(I64##code); break; \
        case f32: o << int8_t(F32##code); break; \
        case f64: o << int8_t(F64##code); break; \
        default: abort(); \
      } \
    }

    switch (op) {
      case Add:      TYPED_CODE(Add);
      case Sub:      TYPED_CODE(Sub);
      case Mul:      TYPED_CODE(Mul);
      case DivS:     int8_t(curr->type == i32 ? I32DivS : I64DivS); break;
      case DivU:     int8_t(curr->type == i32 ? I32DivU : I64DivU); break;
      case RemS:     int8_t(curr->type == i32 ? I32RemS : I64RemS); break;
      case RemU:     int8_t(curr->type == i32 ? I32RemU : I64RemU); break;
      case And:      int8_t(curr->type == i32 ? I32And : I64And); break;
      case Or:       int8_t(curr->type == i32 ? I32Or : I64Or); break;
      case Xor:      int8_t(curr->type == i32 ? I32Xor : I64Xor); break;
      case Shl:      int8_t(curr->type == i32 ? I32Shl : I64Shl); break;
      case ShrU:     int8_t(curr->type == i32 ? I32ShrU : I64ShrU); break;
      case ShrS:     int8_t(curr->type == i32 ? I32ShrS : I64ShrS); break;
      case Div:      int8_t(curr->type == f32 ? F32Div : F64Div); break;
      case CopySign: int8_t(curr->type == f32 ? F32CopySign : F64CopySign); break;
      case Min:      int8_t(curr->type == f32 ? F32Min : F64Min); break;
      case Max:      int8_t(curr->type == f32 ? F32Max : F64Max); break;
      case Eq:       TYPED_CODE(Eq);
      case Ne:       TYPED_CODE(Ne);
      case LtS:      TYPED_CODE(LtS);
      case LtU:      TYPED_CODE(LtU);
      case LeS:      TYPED_CODE(LeS);
      case LeU:      TYPED_CODE(LeU);
      case GtS:      TYPED_CODE(GtS);
      case GtU:      TYPED_CODE(GtU);
      case GeS:      TYPED_CODE(GeS);
      case GeU:      TYPED_CODE(GeU);
      case Lt:       TYPED_CODE(Lt);
      case Le:       TYPED_CODE(Le);
      case Gt:       TYPED_CODE(Gt);
      case Ge:       TYPED_CODE(Ge);
      default:       abort();
    }
    visit(curr->left);
    visit(curr->right);
  }
  void visitSelect(Select *curr) {
    o << int8_t(ASTNodes::Select);
    visit(curr->ifTrue);
    visit(curr->ifFalse);
    visit(curr->condition);
  }
  void visitHost(Host *curr) {
    switch (curr->op) {
      case MemorySize: {
        o << int8_t(ASTNodes::MemorySize);
        break;
      }
      case GrowMemory: {
        o << int8_t(ASTNodes::GrowMemory);
        visit(curr->operands[0]);
        break;
      }
      default: abort();
    }
    return o;
  }
  void visitNop(Nop *curr) {
    o << int8_t(ASTNodes::Nop);
  }
  void visitUnreachable(Unreachable *curr) {
    o << int8_t(ASTNodes::Unreachable);
  }
};

class WasmBinaryBuilder {
  AllocatingModule& wasm;
  MixedArena& allocator;
  istream& i;
public:
  WasmBinaryBuilder(AllocatingModule& wasm, istream& i) : wasm(wasm), allocator(wasm.allocator), i(i) {}

  void read() {
    abort(); // TODO
  }
};

} // namespace wasm

#endif // wasm_wasm_binary_h

