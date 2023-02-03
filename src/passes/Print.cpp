/*
 * Copyright 2016 WebAssembly Community Group participants
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
// Print out text in s-expression format
//

#include <ir/iteration.h>
#include <ir/module-utils.h>
#include <ir/table-utils.h>
#include <pass.h>
#include <pretty_printing.h>
#include <wasm-stack.h>
#include <wasm.h>

namespace wasm {

static std::ostream& printExpression(Expression* expression,
                                     std::ostream& o,
                                     bool minify = false,
                                     bool full = false,
                                     Module* wasm = nullptr);

static std::ostream&
printStackInst(StackInst* inst, std::ostream& o, Function* func = nullptr);

static std::ostream&
printStackIR(StackIR* ir, std::ostream& o, Function* func = nullptr);

namespace {

bool isFullForced() {
  if (getenv("BINARYEN_PRINT_FULL")) {
    return std::stoi(getenv("BINARYEN_PRINT_FULL")) != 0;
  }
  return false;
}

std::ostream& printName(Name name, std::ostream& o) {
  assert(name && "Cannot print an empty name");
  // We need to quote names if they have tricky chars.
  // TODO: This is not spec-compliant since the spec does not support quoted
  // identifiers and has a limited set of valid idchars. We need a more robust
  // escaping scheme here. Reusing `printEscapedString` is not sufficient,
  // either.
  if (name.str.find_first_of("()") == std::string_view::npos) {
    o << '$' << name.str;
  } else {
    o << "\"$" << name.str << '"';
  }
  return o;
}

std::ostream& printMemoryName(Name name, std::ostream& o, Module* wasm) {
  if (!wasm || wasm->memories.size() > 1) {
    o << ' ';
    printName(name, o);
  }
  return o;
}

std::ostream& printLocal(Index index, Function* func, std::ostream& o) {
  Name name;
  if (func) {
    name = func->getLocalNameOrDefault(index);
  }
  if (!name) {
    name = Name::fromInt(index);
  }
  return printName(name, o);
}

bool maybePrintRefShorthand(std::ostream& o, Type type) {
  if (!type.isRef()) {
    return false;
  }
  auto heapType = type.getHeapType();
  if (heapType.isBasic() && type.isNullable()) {
    switch (heapType.getBasic()) {
      case HeapType::ext:
        o << "externref";
        return true;
      case HeapType::func:
        o << "funcref";
        return true;
      case HeapType::any:
        o << "anyref";
        return true;
      case HeapType::eq:
        o << "eqref";
        return true;
      case HeapType::i31:
        o << "i31ref";
        return true;
      case HeapType::struct_:
        o << "structref";
        return true;
      case HeapType::array:
        o << "arrayref";
        return true;
      case HeapType::string:
        o << "stringref";
        return true;
      case HeapType::stringview_wtf8:
        o << "stringview_wtf8";
        return true;
      case HeapType::stringview_wtf16:
        o << "stringview_wtf16";
        return true;
      case HeapType::stringview_iter:
        o << "stringview_iter";
        return true;
      case HeapType::none:
        o << "nullref";
        return true;
      case HeapType::noext:
        o << "nullexternref";
        return true;
      case HeapType::nofunc:
        o << "nullfuncref";
        return true;
    }
  }
  return false;
}

// Helper for printing the name of a type. This output is guaranteed to not
// contain spaces.
struct TypeNamePrinter {
  // Optional. If present, the module's HeapType names will be used.
  Module* wasm;

  // Keep track of the first depth at which we see each HeapType so if we see it
  // again, we can unambiguously refer to it without infinitely recursing.
  size_t currHeapTypeDepth = 0;
  std::unordered_map<HeapType, size_t> heapTypeDepths;

  // The stream we are printing to.
  std::ostream& os;

  TypeNamePrinter(std::ostream& os, Module* wasm = nullptr)
    : wasm(wasm), os(os) {}

  void print(Type type);
  void print(HeapType heapType);
  void print(const Tuple& tuple);
  void print(const Field& field);
  void print(const Signature& sig);
  void print(const Struct& struct_);
  void print(const Array& array);

  // FIXME: This hard limit on how many times we call print() avoids extremely
  //        large outputs, which can be inconveniently large in some cases, but
  //        we should have a better mechanism for this.
  static const size_t MaxPrints = 100;

  size_t prints = 0;

  bool exceededLimit() {
    if (prints >= MaxPrints) {
      os << "?";
      return true;
    }
    prints++;
    return false;
  }
};

void TypeNamePrinter::print(Type type) {
  if (exceededLimit()) {
    return;
  }
  if (type.isBasic()) {
    os << type;
  } else if (type.isTuple()) {
    print(type.getTuple());
  } else if (type.isRef()) {
    if (!maybePrintRefShorthand(os, type)) {
      os << "ref";
      if (type.isNullable()) {
        os << "?";
      }
      os << '|';
      print(type.getHeapType());
      os << '|';
    }
  } else {
    WASM_UNREACHABLE("unexpected type");
  }
}

void TypeNamePrinter::print(HeapType type) {
  if (exceededLimit()) {
    return;
  }
  if (type.isBasic()) {
    os << type;
    return;
  }
  // If there is a name for this type in this module, use it.
  // FIXME: in theory there could be two types, one with a name, and one
  // without, and the one without gets an automatic name that matches the
  // other's. To check for that, if (first) we could assert at the very end of
  // this function that the automatic name is not present in the given names.
  if (wasm && wasm->typeNames.count(type)) {
    os << '$' << wasm->typeNames[type].name;
    return;
  }
  // If we have seen this HeapType before, just print its relative depth instead
  // of infinitely recursing.
  auto it = heapTypeDepths.find(type);
  if (it != heapTypeDepths.end()) {
    assert(it->second <= currHeapTypeDepth);
    size_t relativeDepth = currHeapTypeDepth - it->second;
    os << "..." << relativeDepth;
    return;
  }

  // If this is the top-level heap type, add a $
  if (currHeapTypeDepth == 0) {
    os << "$";
  }

  // Update the context for the current HeapType before recursing.
  heapTypeDepths[type] = ++currHeapTypeDepth;

  if (type.isSignature()) {
    print(type.getSignature());
  } else if (type.isStruct()) {
    print(type.getStruct());
  } else if (type.isArray()) {
    print(type.getArray());
  } else {
    WASM_UNREACHABLE("unexpected type");
  }

  // Restore the previous context after the recursion.
  heapTypeDepths.erase(type);
  --currHeapTypeDepth;
}

void TypeNamePrinter::print(const Tuple& tuple) {
  auto sep = "";
  for (auto type : tuple.types) {
    os << sep;
    sep = "_";
    print(type);
  }
}

void TypeNamePrinter::print(const Field& field) {
  if (field.mutable_) {
    os << "mut:";
  }
  if (field.type == Type::i32 && field.packedType != Field::not_packed) {
    if (field.packedType == Field::i8) {
      os << "i8";
    } else if (field.packedType == Field::i16) {
      os << "i16";
    } else {
      WASM_UNREACHABLE("invalid packed type");
    }
  } else {
    print(field.type);
  }
}

void TypeNamePrinter::print(const Signature& sig) {
  // TODO: Switch to using an unambiguous delimiter rather than differentiating
  // only the top level with a different arrow.
  print(sig.params);
  if (currHeapTypeDepth == 1) {
    os << "_=>_";
  } else {
    os << "_->_";
  }
  print(sig.results);
}

void TypeNamePrinter::print(const Struct& struct_) {
  os << '{';
  auto sep = "";
  for (const auto& field : struct_.fields) {
    os << sep;
    sep = "_";
    print(field);
  }
  os << '}';
}

void TypeNamePrinter::print(const Array& array) {
  os << '[';
  print(array.element);
  os << ']';
}

std::ostream& printType(std::ostream& o, Type type, Module* wasm) {
  if (type.isBasic()) {
    o << type;
  } else if (type.isTuple()) {
    o << '(';
    auto sep = "";
    for (const auto& t : type) {
      o << sep;
      printType(o, t, wasm);
      sep = " ";
    }
    o << ')';
  } else if (type.isRef()) {
    if (!maybePrintRefShorthand(o, type)) {
      o << "(ref ";
      if (type.isNullable()) {
        o << "null ";
      }
      TypeNamePrinter(o, wasm).print(type.getHeapType());
      o << ')';
    }
  } else {
    WASM_UNREACHABLE("unexpected type");
  }
  return o;
}

std::ostream& printHeapType(std::ostream& o, HeapType type, Module* wasm) {
  TypeNamePrinter(o, wasm).print(type);
  return o;
}

std::ostream& printPrefixedTypes(std::ostream& o,
                                 const char* prefix,
                                 Type type,
                                 Module* wasm) {
  o << '(' << prefix;
  if (type == Type::none) {
    return o << ')';
  }
  if (type.isTuple()) {
    // Tuple types are not printed in parens, we can just emit them one after
    // the other in the same list as the "result".
    for (auto t : type) {
      o << ' ';
      printType(o, t, wasm);
    }
  } else {
    o << ' ';
    printType(o, type, wasm);
  }
  o << ')';
  return o;
}

std::ostream& printResultType(std::ostream& o, Type type, Module* wasm) {
  return printPrefixedTypes(o, "result", type, wasm);
}

std::ostream& printParamType(std::ostream& o, Type type, Module* wasm) {
  return printPrefixedTypes(o, "param", type, wasm);
}

// Generic processing of a struct's field, given an optional module. Calls func
// with the field name, if it is present, or with a null Name if not.
template<typename T>
void processFieldName(Module* wasm, HeapType type, Index index, T func) {
  if (wasm) {
    auto it = wasm->typeNames.find(type);
    if (it != wasm->typeNames.end()) {
      auto& fieldNames = it->second.fieldNames;
      auto it = fieldNames.find(index);
      if (it != fieldNames.end()) {
        auto name = it->second;
        if (name.is()) {
          func(it->second);
          return;
        }
      }
    }
  }
  func(Name());
}

std::ostream& printEscapedString(std::ostream& os, std::string_view str) {
  os << '"';
  for (unsigned char c : str) {
    switch (c) {
      case '\t':
        os << "\\t";
        break;
      case '\n':
        os << "\\n";
        break;
      case '\r':
        os << "\\r";
        break;
      case '"':
        os << "\\\"";
        break;
      case '\'':
        os << "\\'";
        break;
      case '\\':
        os << "\\\\";
        break;
      default: {
        if (c >= 32 && c < 127) {
          os << c;
        } else {
          os << std::hex << '\\' << (c / 16) << (c % 16) << std::dec;
        }
      }
    }
  }
  return os << '"';
}

// Print a name from the type section, if available. Otherwise print the type
// normally.
void printTypeOrName(Type type, std::ostream& o, Module* wasm) {
  if (type.isRef() && wasm) {
    auto heapType = type.getHeapType();
    auto iter = wasm->typeNames.find(heapType);
    if (iter != wasm->typeNames.end()) {
      o << iter->second.name;
      if (type.isNullable()) {
        o << " null";
      }
      return;
    }
  }

  // No luck with a name, just print the test as best we can.
  o << type;
}

} // anonymous namespace

// Printing "unreachable" as a instruction prefix type is not valid in wasm text
// format. Print something else to make it pass.
static Type forceConcrete(Type type) {
  return type.isConcrete() ? type : Type::i32;
}

// Prints the internal contents of an expression: everything but
// the children.
struct PrintExpressionContents
  : public OverriddenVisitor<PrintExpressionContents> {
  Module* wasm = nullptr;
  Function* currFunction = nullptr;
  std::ostream& o;
  FeatureSet features;

  PrintExpressionContents(Module* wasm, Function* currFunction, std::ostream& o)
    : wasm(wasm), currFunction(currFunction), o(o), features(wasm->features) {}

  PrintExpressionContents(Function* currFunction, std::ostream& o)
    : currFunction(currFunction), o(o), features(FeatureSet::All) {}

  void visitBlock(Block* curr) {
    printMedium(o, "block");
    if (curr->name.is()) {
      o << ' ';
      printName(curr->name, o);
    }
    if (curr->type.isConcrete()) {
      o << ' ';
      printResultType(o, curr->type, wasm);
    }
  }
  void visitIf(If* curr) {
    printMedium(o, "if");
    if (curr->type.isConcrete()) {
      o << ' ';
      printResultType(o, curr->type, wasm);
    }
  }
  void visitLoop(Loop* curr) {
    printMedium(o, "loop");
    if (curr->name.is()) {
      o << ' ';
      printName(curr->name, o);
    }
    if (curr->type.isConcrete()) {
      o << ' ';
      printResultType(o, curr->type, wasm);
    }
  }
  void visitBreak(Break* curr) {
    if (curr->condition) {
      printMedium(o, "br_if ");
    } else {
      printMedium(o, "br ");
    }
    printName(curr->name, o);
  }
  void visitSwitch(Switch* curr) {
    printMedium(o, "br_table");
    for (auto& t : curr->targets) {
      o << ' ';
      printName(t, o);
    }
    o << ' ';
    printName(curr->default_, o);
  }
  void visitCall(Call* curr) {
    if (curr->isReturn) {
      printMedium(o, "return_call ");
    } else {
      printMedium(o, "call ");
    }
    printName(curr->target, o);
  }
  void visitCallIndirect(CallIndirect* curr) {
    if (curr->isReturn) {
      printMedium(o, "return_call_indirect ");
    } else {
      printMedium(o, "call_indirect ");
    }

    if (features.hasReferenceTypes()) {
      printName(curr->table, o);
      o << ' ';
    }

    o << '(';
    printMinor(o, "type ");

    TypeNamePrinter(o, wasm).print(curr->heapType);

    o << ')';
  }
  void visitLocalGet(LocalGet* curr) {
    printMedium(o, "local.get ");
    printLocal(curr->index, currFunction, o);
  }
  void visitLocalSet(LocalSet* curr) {
    if (curr->isTee()) {
      printMedium(o, "local.tee ");
    } else {
      printMedium(o, "local.set ");
    }
    printLocal(curr->index, currFunction, o);
  }
  void visitGlobalGet(GlobalGet* curr) {
    printMedium(o, "global.get ");
    printName(curr->name, o);
  }
  void visitGlobalSet(GlobalSet* curr) {
    printMedium(o, "global.set ");
    printName(curr->name, o);
  }
  void visitLoad(Load* curr) {
    prepareColor(o) << forceConcrete(curr->type);
    if (curr->isAtomic) {
      o << ".atomic";
    }
    o << ".load";
    if (curr->type != Type::unreachable &&
        curr->bytes < curr->type.getByteSize()) {
      if (curr->bytes == 1) {
        o << '8';
      } else if (curr->bytes == 2) {
        o << "16";
      } else if (curr->bytes == 4) {
        o << "32";
      } else {
        abort();
      }
      o << (curr->signed_ ? "_s" : "_u");
    }
    restoreNormalColor(o);
    printMemoryName(curr->memory, o, wasm);
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
    if (curr->align != curr->bytes) {
      o << " align=" << curr->align;
    }
  }
  void visitStore(Store* curr) {
    prepareColor(o) << forceConcrete(curr->valueType);
    if (curr->isAtomic) {
      o << ".atomic";
    }
    o << ".store";
    if (curr->bytes < 4 || (curr->valueType == Type::i64 && curr->bytes < 8)) {
      if (curr->bytes == 1) {
        o << '8';
      } else if (curr->bytes == 2) {
        o << "16";
      } else if (curr->bytes == 4) {
        o << "32";
      } else {
        abort();
      }
    }
    restoreNormalColor(o);
    printMemoryName(curr->memory, o, wasm);
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
    if (curr->align != curr->bytes) {
      o << " align=" << curr->align;
    }
  }
  static void printRMWSize(std::ostream& o, Type type, uint8_t bytes) {
    prepareColor(o) << forceConcrete(type) << ".atomic.rmw";
    if (type != Type::unreachable && bytes != type.getByteSize()) {
      if (bytes == 1) {
        o << '8';
      } else if (bytes == 2) {
        o << "16";
      } else if (bytes == 4) {
        o << "32";
      } else {
        WASM_UNREACHABLE("invalid RMW byte length");
      }
    }
    o << '.';
  }
  void visitAtomicRMW(AtomicRMW* curr) {
    prepareColor(o);
    printRMWSize(o, curr->type, curr->bytes);
    switch (curr->op) {
      case RMWAdd:
        o << "add";
        break;
      case RMWSub:
        o << "sub";
        break;
      case RMWAnd:
        o << "and";
        break;
      case RMWOr:
        o << "or";
        break;
      case RMWXor:
        o << "xor";
        break;
      case RMWXchg:
        o << "xchg";
        break;
    }
    if (curr->type != Type::unreachable &&
        curr->bytes != curr->type.getByteSize()) {
      o << "_u";
    }
    restoreNormalColor(o);
    printMemoryName(curr->memory, o, wasm);
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
  }
  void visitAtomicCmpxchg(AtomicCmpxchg* curr) {
    prepareColor(o);
    printRMWSize(o, curr->type, curr->bytes);
    o << "cmpxchg";
    if (curr->type != Type::unreachable &&
        curr->bytes != curr->type.getByteSize()) {
      o << "_u";
    }
    restoreNormalColor(o);
    printMemoryName(curr->memory, o, wasm);
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
  }
  void visitAtomicWait(AtomicWait* curr) {
    prepareColor(o);
    Type type = forceConcrete(curr->expectedType);
    assert(type == Type::i32 || type == Type::i64);
    o << "memory.atomic.wait" << (type == Type::i32 ? "32" : "64");
    restoreNormalColor(o);
    printMemoryName(curr->memory, o, wasm);
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
  }
  void visitAtomicNotify(AtomicNotify* curr) {
    printMedium(o, "memory.atomic.notify");
    printMemoryName(curr->memory, o, wasm);
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
  }
  void visitAtomicFence(AtomicFence* curr) { printMedium(o, "atomic.fence"); }
  void visitSIMDExtract(SIMDExtract* curr) {
    prepareColor(o);
    switch (curr->op) {
      case ExtractLaneSVecI8x16:
        o << "i8x16.extract_lane_s";
        break;
      case ExtractLaneUVecI8x16:
        o << "i8x16.extract_lane_u";
        break;
      case ExtractLaneSVecI16x8:
        o << "i16x8.extract_lane_s";
        break;
      case ExtractLaneUVecI16x8:
        o << "i16x8.extract_lane_u";
        break;
      case ExtractLaneVecI32x4:
        o << "i32x4.extract_lane";
        break;
      case ExtractLaneVecI64x2:
        o << "i64x2.extract_lane";
        break;
      case ExtractLaneVecF32x4:
        o << "f32x4.extract_lane";
        break;
      case ExtractLaneVecF64x2:
        o << "f64x2.extract_lane";
        break;
    }
    restoreNormalColor(o);
    o << " " << int(curr->index);
  }
  void visitSIMDReplace(SIMDReplace* curr) {
    prepareColor(o);
    switch (curr->op) {
      case ReplaceLaneVecI8x16:
        o << "i8x16.replace_lane";
        break;
      case ReplaceLaneVecI16x8:
        o << "i16x8.replace_lane";
        break;
      case ReplaceLaneVecI32x4:
        o << "i32x4.replace_lane";
        break;
      case ReplaceLaneVecI64x2:
        o << "i64x2.replace_lane";
        break;
      case ReplaceLaneVecF32x4:
        o << "f32x4.replace_lane";
        break;
      case ReplaceLaneVecF64x2:
        o << "f64x2.replace_lane";
        break;
    }
    restoreNormalColor(o);
    o << " " << int(curr->index);
  }
  void visitSIMDShuffle(SIMDShuffle* curr) {
    prepareColor(o);
    o << "i8x16.shuffle";
    restoreNormalColor(o);
    for (uint8_t mask_index : curr->mask) {
      o << " " << std::to_string(mask_index);
    }
  }
  void visitSIMDTernary(SIMDTernary* curr) {
    prepareColor(o);
    switch (curr->op) {
      case Bitselect:
        o << "v128.bitselect";
        break;
      case LaneselectI8x16:
        o << "i8x16.laneselect";
        break;
      case LaneselectI16x8:
        o << "i16x8.laneselect";
        break;
      case LaneselectI32x4:
        o << "i32x4.laneselect";
        break;
      case LaneselectI64x2:
        o << "i64x2.laneselect";
        break;
      case RelaxedFmaVecF32x4:
        o << "f32x4.relaxed_fma";
        break;
      case RelaxedFmsVecF32x4:
        o << "f32x4.relaxed_fms";
        break;
      case RelaxedFmaVecF64x2:
        o << "f64x2.relaxed_fma";
        break;
      case RelaxedFmsVecF64x2:
        o << "f64x2.relaxed_fms";
        break;
      case DotI8x16I7x16AddSToVecI32x4:
        o << "i32x4.dot_i8x16_i7x16_add_s";
        break;
    }
    restoreNormalColor(o);
  }
  void visitSIMDShift(SIMDShift* curr) {
    prepareColor(o);
    switch (curr->op) {
      case ShlVecI8x16:
        o << "i8x16.shl";
        break;
      case ShrSVecI8x16:
        o << "i8x16.shr_s";
        break;
      case ShrUVecI8x16:
        o << "i8x16.shr_u";
        break;
      case ShlVecI16x8:
        o << "i16x8.shl";
        break;
      case ShrSVecI16x8:
        o << "i16x8.shr_s";
        break;
      case ShrUVecI16x8:
        o << "i16x8.shr_u";
        break;
      case ShlVecI32x4:
        o << "i32x4.shl";
        break;
      case ShrSVecI32x4:
        o << "i32x4.shr_s";
        break;
      case ShrUVecI32x4:
        o << "i32x4.shr_u";
        break;
      case ShlVecI64x2:
        o << "i64x2.shl";
        break;
      case ShrSVecI64x2:
        o << "i64x2.shr_s";
        break;
      case ShrUVecI64x2:
        o << "i64x2.shr_u";
        break;
    }
    restoreNormalColor(o);
  }
  void visitSIMDLoad(SIMDLoad* curr) {
    prepareColor(o);
    switch (curr->op) {
      case Load8SplatVec128:
        o << "v128.load8_splat";
        break;
      case Load16SplatVec128:
        o << "v128.load16_splat";
        break;
      case Load32SplatVec128:
        o << "v128.load32_splat";
        break;
      case Load64SplatVec128:
        o << "v128.load64_splat";
        break;
      case Load8x8SVec128:
        o << "v128.load8x8_s";
        break;
      case Load8x8UVec128:
        o << "v128.load8x8_u";
        break;
      case Load16x4SVec128:
        o << "v128.load16x4_s";
        break;
      case Load16x4UVec128:
        o << "v128.load16x4_u";
        break;
      case Load32x2SVec128:
        o << "v128.load32x2_s";
        break;
      case Load32x2UVec128:
        o << "v128.load32x2_u";
        break;
      case Load32ZeroVec128:
        o << "v128.load32_zero";
        break;
      case Load64ZeroVec128:
        o << "v128.load64_zero";
        break;
    }
    restoreNormalColor(o);
    printMemoryName(curr->memory, o, wasm);
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
    if (curr->align != curr->getMemBytes()) {
      o << " align=" << curr->align;
    }
  }
  void visitSIMDLoadStoreLane(SIMDLoadStoreLane* curr) {
    prepareColor(o);
    switch (curr->op) {
      case Load8LaneVec128:
        o << "v128.load8_lane";
        break;
      case Load16LaneVec128:
        o << "v128.load16_lane";
        break;
      case Load32LaneVec128:
        o << "v128.load32_lane";
        break;
      case Load64LaneVec128:
        o << "v128.load64_lane";
        break;
      case Store8LaneVec128:
        o << "v128.store8_lane";
        break;
      case Store16LaneVec128:
        o << "v128.store16_lane";
        break;
      case Store32LaneVec128:
        o << "v128.store32_lane";
        break;
      case Store64LaneVec128:
        o << "v128.store64_lane";
        break;
    }
    restoreNormalColor(o);
    printMemoryName(curr->memory, o, wasm);
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
    if (curr->align != curr->getMemBytes()) {
      o << " align=" << curr->align;
    }
    o << " " << int(curr->index);
  }
  void visitMemoryInit(MemoryInit* curr) {
    prepareColor(o);
    o << "memory.init";
    restoreNormalColor(o);
    printMemoryName(curr->memory, o, wasm);
    o << ' ' << curr->segment;
  }
  void visitDataDrop(DataDrop* curr) {
    prepareColor(o);
    o << "data.drop";
    restoreNormalColor(o);
    o << ' ' << curr->segment;
  }
  void visitMemoryCopy(MemoryCopy* curr) {
    prepareColor(o);
    o << "memory.copy";
    restoreNormalColor(o);
    printMemoryName(curr->destMemory, o, wasm);
    printMemoryName(curr->sourceMemory, o, wasm);
  }
  void visitMemoryFill(MemoryFill* curr) {
    prepareColor(o);
    o << "memory.fill";
    restoreNormalColor(o);
    printMemoryName(curr->memory, o, wasm);
  }
  void visitConst(Const* curr) {
    o << curr->value.type << ".const " << curr->value;
  }
  void visitUnary(Unary* curr) {
    prepareColor(o);
    switch (curr->op) {
      case ClzInt32:
        o << "i32.clz";
        break;
      case CtzInt32:
        o << "i32.ctz";
        break;
      case PopcntInt32:
        o << "i32.popcnt";
        break;
      case EqZInt32:
        o << "i32.eqz";
        break;
      case ClzInt64:
        o << "i64.clz";
        break;
      case CtzInt64:
        o << "i64.ctz";
        break;
      case PopcntInt64:
        o << "i64.popcnt";
        break;
      case EqZInt64:
        o << "i64.eqz";
        break;
      case NegFloat32:
        o << "f32.neg";
        break;
      case AbsFloat32:
        o << "f32.abs";
        break;
      case CeilFloat32:
        o << "f32.ceil";
        break;
      case FloorFloat32:
        o << "f32.floor";
        break;
      case TruncFloat32:
        o << "f32.trunc";
        break;
      case NearestFloat32:
        o << "f32.nearest";
        break;
      case SqrtFloat32:
        o << "f32.sqrt";
        break;
      case NegFloat64:
        o << "f64.neg";
        break;
      case AbsFloat64:
        o << "f64.abs";
        break;
      case CeilFloat64:
        o << "f64.ceil";
        break;
      case FloorFloat64:
        o << "f64.floor";
        break;
      case TruncFloat64:
        o << "f64.trunc";
        break;
      case NearestFloat64:
        o << "f64.nearest";
        break;
      case SqrtFloat64:
        o << "f64.sqrt";
        break;
      case ExtendSInt32:
        o << "i64.extend_i32_s";
        break;
      case ExtendUInt32:
        o << "i64.extend_i32_u";
        break;
      case WrapInt64:
        o << "i32.wrap_i64";
        break;
      case TruncSFloat32ToInt32:
        o << "i32.trunc_f32_s";
        break;
      case TruncSFloat32ToInt64:
        o << "i64.trunc_f32_s";
        break;
      case TruncUFloat32ToInt32:
        o << "i32.trunc_f32_u";
        break;
      case TruncUFloat32ToInt64:
        o << "i64.trunc_f32_u";
        break;
      case TruncSFloat64ToInt32:
        o << "i32.trunc_f64_s";
        break;
      case TruncSFloat64ToInt64:
        o << "i64.trunc_f64_s";
        break;
      case TruncUFloat64ToInt32:
        o << "i32.trunc_f64_u";
        break;
      case TruncUFloat64ToInt64:
        o << "i64.trunc_f64_u";
        break;
      case ReinterpretFloat32:
        o << "i32.reinterpret_f32";
        break;
      case ReinterpretFloat64:
        o << "i64.reinterpret_f64";
        break;
      case ConvertUInt32ToFloat32:
        o << "f32.convert_i32_u";
        break;
      case ConvertUInt32ToFloat64:
        o << "f64.convert_i32_u";
        break;
      case ConvertSInt32ToFloat32:
        o << "f32.convert_i32_s";
        break;
      case ConvertSInt32ToFloat64:
        o << "f64.convert_i32_s";
        break;
      case ConvertUInt64ToFloat32:
        o << "f32.convert_i64_u";
        break;
      case ConvertUInt64ToFloat64:
        o << "f64.convert_i64_u";
        break;
      case ConvertSInt64ToFloat32:
        o << "f32.convert_i64_s";
        break;
      case ConvertSInt64ToFloat64:
        o << "f64.convert_i64_s";
        break;
      case PromoteFloat32:
        o << "f64.promote_f32";
        break;
      case DemoteFloat64:
        o << "f32.demote_f64";
        break;
      case ReinterpretInt32:
        o << "f32.reinterpret_i32";
        break;
      case ReinterpretInt64:
        o << "f64.reinterpret_i64";
        break;
      case ExtendS8Int32:
        o << "i32.extend8_s";
        break;
      case ExtendS16Int32:
        o << "i32.extend16_s";
        break;
      case ExtendS8Int64:
        o << "i64.extend8_s";
        break;
      case ExtendS16Int64:
        o << "i64.extend16_s";
        break;
      case ExtendS32Int64:
        o << "i64.extend32_s";
        break;
      case TruncSatSFloat32ToInt32:
        o << "i32.trunc_sat_f32_s";
        break;
      case TruncSatUFloat32ToInt32:
        o << "i32.trunc_sat_f32_u";
        break;
      case TruncSatSFloat64ToInt32:
        o << "i32.trunc_sat_f64_s";
        break;
      case TruncSatUFloat64ToInt32:
        o << "i32.trunc_sat_f64_u";
        break;
      case TruncSatSFloat32ToInt64:
        o << "i64.trunc_sat_f32_s";
        break;
      case TruncSatUFloat32ToInt64:
        o << "i64.trunc_sat_f32_u";
        break;
      case TruncSatSFloat64ToInt64:
        o << "i64.trunc_sat_f64_s";
        break;
      case TruncSatUFloat64ToInt64:
        o << "i64.trunc_sat_f64_u";
        break;
      case SplatVecI8x16:
        o << "i8x16.splat";
        break;
      case SplatVecI16x8:
        o << "i16x8.splat";
        break;
      case SplatVecI32x4:
        o << "i32x4.splat";
        break;
      case SplatVecI64x2:
        o << "i64x2.splat";
        break;
      case SplatVecF32x4:
        o << "f32x4.splat";
        break;
      case SplatVecF64x2:
        o << "f64x2.splat";
        break;
      case NotVec128:
        o << "v128.not";
        break;
      case AnyTrueVec128:
        o << "v128.any_true";
        break;
      case AbsVecI8x16:
        o << "i8x16.abs";
        break;
      case NegVecI8x16:
        o << "i8x16.neg";
        break;
      case AllTrueVecI8x16:
        o << "i8x16.all_true";
        break;
      case BitmaskVecI8x16:
        o << "i8x16.bitmask";
        break;
      case PopcntVecI8x16:
        o << "i8x16.popcnt";
        break;
      case AbsVecI16x8:
        o << "i16x8.abs";
        break;
      case NegVecI16x8:
        o << "i16x8.neg";
        break;
      case AllTrueVecI16x8:
        o << "i16x8.all_true";
        break;
      case BitmaskVecI16x8:
        o << "i16x8.bitmask";
        break;
      case AbsVecI32x4:
        o << "i32x4.abs";
        break;
      case NegVecI32x4:
        o << "i32x4.neg";
        break;
      case AllTrueVecI32x4:
        o << "i32x4.all_true";
        break;
      case BitmaskVecI32x4:
        o << "i32x4.bitmask";
        break;
      case AbsVecI64x2:
        o << "i64x2.abs";
        break;
      case NegVecI64x2:
        o << "i64x2.neg";
        break;
      case AllTrueVecI64x2:
        o << "i64x2.all_true";
        break;
      case BitmaskVecI64x2:
        o << "i64x2.bitmask";
        break;
      case AbsVecF32x4:
        o << "f32x4.abs";
        break;
      case NegVecF32x4:
        o << "f32x4.neg";
        break;
      case SqrtVecF32x4:
        o << "f32x4.sqrt";
        break;
      case CeilVecF32x4:
        o << "f32x4.ceil";
        break;
      case FloorVecF32x4:
        o << "f32x4.floor";
        break;
      case TruncVecF32x4:
        o << "f32x4.trunc";
        break;
      case NearestVecF32x4:
        o << "f32x4.nearest";
        break;
      case AbsVecF64x2:
        o << "f64x2.abs";
        break;
      case NegVecF64x2:
        o << "f64x2.neg";
        break;
      case SqrtVecF64x2:
        o << "f64x2.sqrt";
        break;
      case CeilVecF64x2:
        o << "f64x2.ceil";
        break;
      case FloorVecF64x2:
        o << "f64x2.floor";
        break;
      case TruncVecF64x2:
        o << "f64x2.trunc";
        break;
      case NearestVecF64x2:
        o << "f64x2.nearest";
        break;
      case ExtAddPairwiseSVecI8x16ToI16x8:
        o << "i16x8.extadd_pairwise_i8x16_s";
        break;
      case ExtAddPairwiseUVecI8x16ToI16x8:
        o << "i16x8.extadd_pairwise_i8x16_u";
        break;
      case ExtAddPairwiseSVecI16x8ToI32x4:
        o << "i32x4.extadd_pairwise_i16x8_s";
        break;
      case ExtAddPairwiseUVecI16x8ToI32x4:
        o << "i32x4.extadd_pairwise_i16x8_u";
        break;
      case TruncSatSVecF32x4ToVecI32x4:
        o << "i32x4.trunc_sat_f32x4_s";
        break;
      case TruncSatUVecF32x4ToVecI32x4:
        o << "i32x4.trunc_sat_f32x4_u";
        break;
      case ConvertSVecI32x4ToVecF32x4:
        o << "f32x4.convert_i32x4_s";
        break;
      case ConvertUVecI32x4ToVecF32x4:
        o << "f32x4.convert_i32x4_u";
        break;
      case ExtendLowSVecI8x16ToVecI16x8:
        o << "i16x8.extend_low_i8x16_s";
        break;
      case ExtendHighSVecI8x16ToVecI16x8:
        o << "i16x8.extend_high_i8x16_s";
        break;
      case ExtendLowUVecI8x16ToVecI16x8:
        o << "i16x8.extend_low_i8x16_u";
        break;
      case ExtendHighUVecI8x16ToVecI16x8:
        o << "i16x8.extend_high_i8x16_u";
        break;
      case ExtendLowSVecI16x8ToVecI32x4:
        o << "i32x4.extend_low_i16x8_s";
        break;
      case ExtendHighSVecI16x8ToVecI32x4:
        o << "i32x4.extend_high_i16x8_s";
        break;
      case ExtendLowUVecI16x8ToVecI32x4:
        o << "i32x4.extend_low_i16x8_u";
        break;
      case ExtendHighUVecI16x8ToVecI32x4:
        o << "i32x4.extend_high_i16x8_u";
        break;
      case ExtendLowSVecI32x4ToVecI64x2:
        o << "i64x2.extend_low_i32x4_s";
        break;
      case ExtendHighSVecI32x4ToVecI64x2:
        o << "i64x2.extend_high_i32x4_s";
        break;
      case ExtendLowUVecI32x4ToVecI64x2:
        o << "i64x2.extend_low_i32x4_u";
        break;
      case ExtendHighUVecI32x4ToVecI64x2:
        o << "i64x2.extend_high_i32x4_u";
        break;
      case ConvertLowSVecI32x4ToVecF64x2:
        o << "f64x2.convert_low_i32x4_s";
        break;
      case ConvertLowUVecI32x4ToVecF64x2:
        o << "f64x2.convert_low_i32x4_u";
        break;
      case TruncSatZeroSVecF64x2ToVecI32x4:
        o << "i32x4.trunc_sat_f64x2_s_zero";
        break;
      case TruncSatZeroUVecF64x2ToVecI32x4:
        o << "i32x4.trunc_sat_f64x2_u_zero";
        break;
      case DemoteZeroVecF64x2ToVecF32x4:
        o << "f32x4.demote_f64x2_zero";
        break;
      case PromoteLowVecF32x4ToVecF64x2:
        o << "f64x2.promote_low_f32x4";
        break;
      case RelaxedTruncSVecF32x4ToVecI32x4:
        o << "i32x4.relaxed_trunc_f32x4_s";
        break;
      case RelaxedTruncUVecF32x4ToVecI32x4:
        o << "i32x4.relaxed_trunc_f32x4_u";
        break;
      case RelaxedTruncZeroSVecF64x2ToVecI32x4:
        o << "i32x4.relaxed_trunc_f64x2_s_zero";
        break;
      case RelaxedTruncZeroUVecF64x2ToVecI32x4:
        o << "i32x4.relaxed_trunc_f64x2_u_zero";
        break;
      case InvalidUnary:
        WASM_UNREACHABLE("unvalid unary operator");
    }
    restoreNormalColor(o);
  }
  void visitBinary(Binary* curr) {
    prepareColor(o);
    switch (curr->op) {
      case AddInt32:
        o << "i32.add";
        break;
      case SubInt32:
        o << "i32.sub";
        break;
      case MulInt32:
        o << "i32.mul";
        break;
      case DivSInt32:
        o << "i32.div_s";
        break;
      case DivUInt32:
        o << "i32.div_u";
        break;
      case RemSInt32:
        o << "i32.rem_s";
        break;
      case RemUInt32:
        o << "i32.rem_u";
        break;
      case AndInt32:
        o << "i32.and";
        break;
      case OrInt32:
        o << "i32.or";
        break;
      case XorInt32:
        o << "i32.xor";
        break;
      case ShlInt32:
        o << "i32.shl";
        break;
      case ShrUInt32:
        o << "i32.shr_u";
        break;
      case ShrSInt32:
        o << "i32.shr_s";
        break;
      case RotLInt32:
        o << "i32.rotl";
        break;
      case RotRInt32:
        o << "i32.rotr";
        break;
      case EqInt32:
        o << "i32.eq";
        break;
      case NeInt32:
        o << "i32.ne";
        break;
      case LtSInt32:
        o << "i32.lt_s";
        break;
      case LtUInt32:
        o << "i32.lt_u";
        break;
      case LeSInt32:
        o << "i32.le_s";
        break;
      case LeUInt32:
        o << "i32.le_u";
        break;
      case GtSInt32:
        o << "i32.gt_s";
        break;
      case GtUInt32:
        o << "i32.gt_u";
        break;
      case GeSInt32:
        o << "i32.ge_s";
        break;
      case GeUInt32:
        o << "i32.ge_u";
        break;

      case AddInt64:
        o << "i64.add";
        break;
      case SubInt64:
        o << "i64.sub";
        break;
      case MulInt64:
        o << "i64.mul";
        break;
      case DivSInt64:
        o << "i64.div_s";
        break;
      case DivUInt64:
        o << "i64.div_u";
        break;
      case RemSInt64:
        o << "i64.rem_s";
        break;
      case RemUInt64:
        o << "i64.rem_u";
        break;
      case AndInt64:
        o << "i64.and";
        break;
      case OrInt64:
        o << "i64.or";
        break;
      case XorInt64:
        o << "i64.xor";
        break;
      case ShlInt64:
        o << "i64.shl";
        break;
      case ShrUInt64:
        o << "i64.shr_u";
        break;
      case ShrSInt64:
        o << "i64.shr_s";
        break;
      case RotLInt64:
        o << "i64.rotl";
        break;
      case RotRInt64:
        o << "i64.rotr";
        break;
      case EqInt64:
        o << "i64.eq";
        break;
      case NeInt64:
        o << "i64.ne";
        break;
      case LtSInt64:
        o << "i64.lt_s";
        break;
      case LtUInt64:
        o << "i64.lt_u";
        break;
      case LeSInt64:
        o << "i64.le_s";
        break;
      case LeUInt64:
        o << "i64.le_u";
        break;
      case GtSInt64:
        o << "i64.gt_s";
        break;
      case GtUInt64:
        o << "i64.gt_u";
        break;
      case GeSInt64:
        o << "i64.ge_s";
        break;
      case GeUInt64:
        o << "i64.ge_u";
        break;

      case AddFloat32:
        o << "f32.add";
        break;
      case SubFloat32:
        o << "f32.sub";
        break;
      case MulFloat32:
        o << "f32.mul";
        break;
      case DivFloat32:
        o << "f32.div";
        break;
      case CopySignFloat32:
        o << "f32.copysign";
        break;
      case MinFloat32:
        o << "f32.min";
        break;
      case MaxFloat32:
        o << "f32.max";
        break;
      case EqFloat32:
        o << "f32.eq";
        break;
      case NeFloat32:
        o << "f32.ne";
        break;
      case LtFloat32:
        o << "f32.lt";
        break;
      case LeFloat32:
        o << "f32.le";
        break;
      case GtFloat32:
        o << "f32.gt";
        break;
      case GeFloat32:
        o << "f32.ge";
        break;

      case AddFloat64:
        o << "f64.add";
        break;
      case SubFloat64:
        o << "f64.sub";
        break;
      case MulFloat64:
        o << "f64.mul";
        break;
      case DivFloat64:
        o << "f64.div";
        break;
      case CopySignFloat64:
        o << "f64.copysign";
        break;
      case MinFloat64:
        o << "f64.min";
        break;
      case MaxFloat64:
        o << "f64.max";
        break;
      case EqFloat64:
        o << "f64.eq";
        break;
      case NeFloat64:
        o << "f64.ne";
        break;
      case LtFloat64:
        o << "f64.lt";
        break;
      case LeFloat64:
        o << "f64.le";
        break;
      case GtFloat64:
        o << "f64.gt";
        break;
      case GeFloat64:
        o << "f64.ge";
        break;

      case EqVecI8x16:
        o << "i8x16.eq";
        break;
      case NeVecI8x16:
        o << "i8x16.ne";
        break;
      case LtSVecI8x16:
        o << "i8x16.lt_s";
        break;
      case LtUVecI8x16:
        o << "i8x16.lt_u";
        break;
      case GtSVecI8x16:
        o << "i8x16.gt_s";
        break;
      case GtUVecI8x16:
        o << "i8x16.gt_u";
        break;
      case LeSVecI8x16:
        o << "i8x16.le_s";
        break;
      case LeUVecI8x16:
        o << "i8x16.le_u";
        break;
      case GeSVecI8x16:
        o << "i8x16.ge_s";
        break;
      case GeUVecI8x16:
        o << "i8x16.ge_u";
        break;
      case EqVecI16x8:
        o << "i16x8.eq";
        break;
      case NeVecI16x8:
        o << "i16x8.ne";
        break;
      case LtSVecI16x8:
        o << "i16x8.lt_s";
        break;
      case LtUVecI16x8:
        o << "i16x8.lt_u";
        break;
      case GtSVecI16x8:
        o << "i16x8.gt_s";
        break;
      case GtUVecI16x8:
        o << "i16x8.gt_u";
        break;
      case LeSVecI16x8:
        o << "i16x8.le_s";
        break;
      case LeUVecI16x8:
        o << "i16x8.le_u";
        break;
      case GeSVecI16x8:
        o << "i16x8.ge_s";
        break;
      case GeUVecI16x8:
        o << "i16x8.ge_u";
        break;
      case EqVecI32x4:
        o << "i32x4.eq";
        break;
      case NeVecI32x4:
        o << "i32x4.ne";
        break;
      case LtSVecI32x4:
        o << "i32x4.lt_s";
        break;
      case LtUVecI32x4:
        o << "i32x4.lt_u";
        break;
      case GtSVecI32x4:
        o << "i32x4.gt_s";
        break;
      case GtUVecI32x4:
        o << "i32x4.gt_u";
        break;
      case LeSVecI32x4:
        o << "i32x4.le_s";
        break;
      case LeUVecI32x4:
        o << "i32x4.le_u";
        break;
      case GeSVecI32x4:
        o << "i32x4.ge_s";
        break;
      case GeUVecI32x4:
        o << "i32x4.ge_u";
        break;
      case EqVecI64x2:
        o << "i64x2.eq";
        break;
      case NeVecI64x2:
        o << "i64x2.ne";
        break;
      case LtSVecI64x2:
        o << "i64x2.lt_s";
        break;
      case GtSVecI64x2:
        o << "i64x2.gt_s";
        break;
      case LeSVecI64x2:
        o << "i64x2.le_s";
        break;
      case GeSVecI64x2:
        o << "i64x2.ge_s";
        break;
      case EqVecF32x4:
        o << "f32x4.eq";
        break;
      case NeVecF32x4:
        o << "f32x4.ne";
        break;
      case LtVecF32x4:
        o << "f32x4.lt";
        break;
      case GtVecF32x4:
        o << "f32x4.gt";
        break;
      case LeVecF32x4:
        o << "f32x4.le";
        break;
      case GeVecF32x4:
        o << "f32x4.ge";
        break;
      case EqVecF64x2:
        o << "f64x2.eq";
        break;
      case NeVecF64x2:
        o << "f64x2.ne";
        break;
      case LtVecF64x2:
        o << "f64x2.lt";
        break;
      case GtVecF64x2:
        o << "f64x2.gt";
        break;
      case LeVecF64x2:
        o << "f64x2.le";
        break;
      case GeVecF64x2:
        o << "f64x2.ge";
        break;

      case AndVec128:
        o << "v128.and";
        break;
      case OrVec128:
        o << "v128.or";
        break;
      case XorVec128:
        o << "v128.xor";
        break;
      case AndNotVec128:
        o << "v128.andnot";
        break;

      case AddVecI8x16:
        o << "i8x16.add";
        break;
      case AddSatSVecI8x16:
        o << "i8x16.add_sat_s";
        break;
      case AddSatUVecI8x16:
        o << "i8x16.add_sat_u";
        break;
      case SubVecI8x16:
        o << "i8x16.sub";
        break;
      case SubSatSVecI8x16:
        o << "i8x16.sub_sat_s";
        break;
      case SubSatUVecI8x16:
        o << "i8x16.sub_sat_u";
        break;
      case MinSVecI8x16:
        o << "i8x16.min_s";
        break;
      case MinUVecI8x16:
        o << "i8x16.min_u";
        break;
      case MaxSVecI8x16:
        o << "i8x16.max_s";
        break;
      case MaxUVecI8x16:
        o << "i8x16.max_u";
        break;
      case AvgrUVecI8x16:
        o << "i8x16.avgr_u";
        break;
      case AddVecI16x8:
        o << "i16x8.add";
        break;
      case AddSatSVecI16x8:
        o << "i16x8.add_sat_s";
        break;
      case AddSatUVecI16x8:
        o << "i16x8.add_sat_u";
        break;
      case SubVecI16x8:
        o << "i16x8.sub";
        break;
      case SubSatSVecI16x8:
        o << "i16x8.sub_sat_s";
        break;
      case SubSatUVecI16x8:
        o << "i16x8.sub_sat_u";
        break;
      case MulVecI16x8:
        o << "i16x8.mul";
        break;
      case MinSVecI16x8:
        o << "i16x8.min_s";
        break;
      case MinUVecI16x8:
        o << "i16x8.min_u";
        break;
      case MaxSVecI16x8:
        o << "i16x8.max_s";
        break;
      case MaxUVecI16x8:
        o << "i16x8.max_u";
        break;
      case AvgrUVecI16x8:
        o << "i16x8.avgr_u";
        break;
      case Q15MulrSatSVecI16x8:
        o << "i16x8.q15mulr_sat_s";
        break;
      case ExtMulLowSVecI16x8:
        o << "i16x8.extmul_low_i8x16_s";
        break;
      case ExtMulHighSVecI16x8:
        o << "i16x8.extmul_high_i8x16_s";
        break;
      case ExtMulLowUVecI16x8:
        o << "i16x8.extmul_low_i8x16_u";
        break;
      case ExtMulHighUVecI16x8:
        o << "i16x8.extmul_high_i8x16_u";
        break;

      case AddVecI32x4:
        o << "i32x4.add";
        break;
      case SubVecI32x4:
        o << "i32x4.sub";
        break;
      case MulVecI32x4:
        o << "i32x4.mul";
        break;
      case MinSVecI32x4:
        o << "i32x4.min_s";
        break;
      case MinUVecI32x4:
        o << "i32x4.min_u";
        break;
      case MaxSVecI32x4:
        o << "i32x4.max_s";
        break;
      case MaxUVecI32x4:
        o << "i32x4.max_u";
        break;
      case DotSVecI16x8ToVecI32x4:
        o << "i32x4.dot_i16x8_s";
        break;
      case ExtMulLowSVecI32x4:
        o << "i32x4.extmul_low_i16x8_s";
        break;
      case ExtMulHighSVecI32x4:
        o << "i32x4.extmul_high_i16x8_s";
        break;
      case ExtMulLowUVecI32x4:
        o << "i32x4.extmul_low_i16x8_u";
        break;
      case ExtMulHighUVecI32x4:
        o << "i32x4.extmul_high_i16x8_u";
        break;

      case AddVecI64x2:
        o << "i64x2.add";
        break;
      case SubVecI64x2:
        o << "i64x2.sub";
        break;
      case MulVecI64x2:
        o << "i64x2.mul";
        break;
      case ExtMulLowSVecI64x2:
        o << "i64x2.extmul_low_i32x4_s";
        break;
      case ExtMulHighSVecI64x2:
        o << "i64x2.extmul_high_i32x4_s";
        break;
      case ExtMulLowUVecI64x2:
        o << "i64x2.extmul_low_i32x4_u";
        break;
      case ExtMulHighUVecI64x2:
        o << "i64x2.extmul_high_i32x4_u";
        break;

      case AddVecF32x4:
        o << "f32x4.add";
        break;
      case SubVecF32x4:
        o << "f32x4.sub";
        break;
      case MulVecF32x4:
        o << "f32x4.mul";
        break;
      case DivVecF32x4:
        o << "f32x4.div";
        break;
      case MinVecF32x4:
        o << "f32x4.min";
        break;
      case MaxVecF32x4:
        o << "f32x4.max";
        break;
      case PMinVecF32x4:
        o << "f32x4.pmin";
        break;
      case PMaxVecF32x4:
        o << "f32x4.pmax";
        break;
      case AddVecF64x2:
        o << "f64x2.add";
        break;
      case SubVecF64x2:
        o << "f64x2.sub";
        break;
      case MulVecF64x2:
        o << "f64x2.mul";
        break;
      case DivVecF64x2:
        o << "f64x2.div";
        break;
      case MinVecF64x2:
        o << "f64x2.min";
        break;
      case MaxVecF64x2:
        o << "f64x2.max";
        break;
      case PMinVecF64x2:
        o << "f64x2.pmin";
        break;
      case PMaxVecF64x2:
        o << "f64x2.pmax";
        break;

      case NarrowSVecI16x8ToVecI8x16:
        o << "i8x16.narrow_i16x8_s";
        break;
      case NarrowUVecI16x8ToVecI8x16:
        o << "i8x16.narrow_i16x8_u";
        break;
      case NarrowSVecI32x4ToVecI16x8:
        o << "i16x8.narrow_i32x4_s";
        break;
      case NarrowUVecI32x4ToVecI16x8:
        o << "i16x8.narrow_i32x4_u";
        break;

      case SwizzleVecI8x16:
        o << "i8x16.swizzle";
        break;

      case RelaxedMinVecF32x4:
        o << "f32x4.relaxed_min";
        break;
      case RelaxedMaxVecF32x4:
        o << "f32x4.relaxed_max";
        break;
      case RelaxedMinVecF64x2:
        o << "f64x2.relaxed_min";
        break;
      case RelaxedMaxVecF64x2:
        o << "f64x2.relaxed_max";
        break;
      case RelaxedSwizzleVecI8x16:
        o << "i8x16.relaxed_swizzle";
        break;
      case RelaxedQ15MulrSVecI16x8:
        o << "i16x8.relaxed_q15mulr_s";
        break;
      case DotI8x16I7x16SToVecI16x8:
        o << "i16x8.dot_i8x16_i7x16_s";
        break;

      case InvalidBinary:
        WASM_UNREACHABLE("unvalid binary operator");
    }
    restoreNormalColor(o);
  }
  void visitSelect(Select* curr) {
    prepareColor(o) << "select";
    restoreNormalColor(o);
    if (curr->type.isRef()) {
      o << ' ';
      printResultType(o, curr->type, wasm);
    }
  }
  void visitDrop(Drop* curr) { printMedium(o, "drop"); }
  void visitReturn(Return* curr) { printMedium(o, "return"); }
  void visitMemorySize(MemorySize* curr) {
    printMedium(o, "memory.size");
    printMemoryName(curr->memory, o, wasm);
  }
  void visitMemoryGrow(MemoryGrow* curr) {
    printMedium(o, "memory.grow");
    printMemoryName(curr->memory, o, wasm);
  }
  void visitRefNull(RefNull* curr) {
    printMedium(o, "ref.null ");
    printHeapType(o, curr->type.getHeapType(), wasm);
  }
  void visitRefIsNull(RefIsNull* curr) { printMedium(o, "ref.is_null"); }
  void visitRefFunc(RefFunc* curr) {
    printMedium(o, "ref.func ");
    printName(curr->func, o);
  }
  void visitRefEq(RefEq* curr) { printMedium(o, "ref.eq"); }
  void visitTableGet(TableGet* curr) {
    printMedium(o, "table.get ");
    printName(curr->table, o);
  }
  void visitTableSet(TableSet* curr) {
    printMedium(o, "table.set ");
    printName(curr->table, o);
  }
  void visitTableSize(TableSize* curr) {
    printMedium(o, "table.size ");
    printName(curr->table, o);
  }
  void visitTableGrow(TableGrow* curr) {
    printMedium(o, "table.grow ");
    printName(curr->table, o);
  }
  void visitTry(Try* curr) {
    printMedium(o, "try");
    if (curr->name.is()) {
      o << ' ';
      printName(curr->name, o);
    }
    if (curr->type.isConcrete()) {
      o << ' ';
      printResultType(o, curr->type, wasm);
    }
  }
  void visitThrow(Throw* curr) {
    printMedium(o, "throw ");
    printName(curr->tag, o);
  }
  void visitRethrow(Rethrow* curr) {
    printMedium(o, "rethrow ");
    printName(curr->target, o);
  }
  void visitNop(Nop* curr) { printMinor(o, "nop"); }
  void visitUnreachable(Unreachable* curr) { printMinor(o, "unreachable"); }
  void visitPop(Pop* curr) {
    prepareColor(o) << "pop";
    for (auto type : curr->type) {
      o << ' ';
      printType(o, type, wasm);
    }
    restoreNormalColor(o);
  }
  void visitTupleMake(TupleMake* curr) { printMedium(o, "tuple.make"); }
  void visitTupleExtract(TupleExtract* curr) {
    printMedium(o, "tuple.extract ");
    o << curr->index;
  }
  void visitI31New(I31New* curr) { printMedium(o, "i31.new"); }
  void visitI31Get(I31Get* curr) {
    printMedium(o, curr->signed_ ? "i31.get_s" : "i31.get_u");
  }

  // If we cannot print a valid unreachable instruction (say, a struct.get,
  // where if the ref is unreachable, we don't know what heap type to print),
  // then print the children in a block, which is good enough as this
  // instruction is never reached anyhow.
  //
  // This function checks if the input is in fact unreachable, and if so, begins
  // to emit a replacement for it and returns true.
  bool printUnreachableReplacement(Expression* curr) {
    if (curr->type == Type::unreachable) {
      printMedium(o, "block");
      return true;
    }
    return false;
  }
  bool printUnreachableOrNullReplacement(Expression* curr) {
    if (curr->type == Type::unreachable || curr->type.isNull()) {
      printMedium(o, "block");
      return true;
    }
    return false;
  }

  void visitCallRef(CallRef* curr) {
    // TODO: Workaround if target has bottom type.
    if (printUnreachableOrNullReplacement(curr->target)) {
      return;
    }
    printMedium(o, curr->isReturn ? "return_call_ref " : "call_ref ");
    printHeapType(o, curr->target->type.getHeapType(), wasm);
  }
  void visitRefTest(RefTest* curr) {
    // TODO: These instructions are deprecated. Remove them.
    if (auto type = curr->castType.getHeapType();
        curr->castType.isNonNullable() && type.isBasic()) {
      switch (type.getBasic()) {
        case HeapType::func:
          printMedium(o, "ref.is_func");
          return;
        case HeapType::i31:
          printMedium(o, "ref.is_i31");
          return;
        default:
          break;
      }
    }
    printMedium(o, "ref.test ");
    if (curr->castType.isNullable()) {
      printMedium(o, "null ");
    }
    printHeapType(o, curr->castType.getHeapType(), wasm);
  }
  void visitRefCast(RefCast* curr) {
    if (printUnreachableReplacement(curr)) {
      return;
    }
    if (curr->safety == RefCast::Unsafe) {
      printMedium(o, "ref.cast_nop ");
    } else {
      // TODO: These instructions are deprecated. Remove them.
      if (auto type = curr->type.getHeapType();
          type.isBasic() && curr->type.isNonNullable()) {
        switch (type.getBasic()) {
          case HeapType::func:
            printMedium(o, "ref.as_func");
            return;
          case HeapType::i31:
            printMedium(o, "ref.as_i31");
            return;
          default:
            break;
        }
      }
      if (curr->type.isNullable()) {
        printMedium(o, "ref.cast null ");
      } else {
        printMedium(o, "ref.cast ");
      }
    }
    printHeapType(o, curr->type.getHeapType(), wasm);
  }

  void visitBrOn(BrOn* curr) {
    switch (curr->op) {
      case BrOnNull:
        printMedium(o, "br_on_null ");
        printName(curr->name, o);
        return;
      case BrOnNonNull:
        printMedium(o, "br_on_non_null ");
        printName(curr->name, o);
        return;
      case BrOnCast:
        // TODO: These instructions are deprecated, so stop emitting them.
        if (auto type = curr->castType.getHeapType();
            type.isBasic() && curr->castType.isNonNullable()) {
          switch (type.getBasic()) {
            case HeapType::func:
              printMedium(o, "br_on_func ");
              printName(curr->name, o);
              return;
            case HeapType::i31:
              printMedium(o, "br_on_i31 ");
              printName(curr->name, o);
              return;
            default:
              break;
          }
        }
        printMedium(o, "br_on_cast ");
        printName(curr->name, o);
        o << ' ';
        if (curr->castType.isNullable()) {
          printMedium(o, "null ");
        }
        printHeapType(o, curr->castType.getHeapType(), wasm);
        return;
      case BrOnCastFail:
        // TODO: These instructions are deprecated, so stop emitting them.
        if (auto type = curr->castType.getHeapType();
            type.isBasic() && curr->castType.isNonNullable()) {
          switch (type.getBasic()) {
            case HeapType::func:
              printMedium(o, "br_on_non_func ");
              printName(curr->name, o);
              return;
            case HeapType::i31:
              printMedium(o, "br_on_non_i31 ");
              printName(curr->name, o);
              return;
            default:
              break;
          }
        }
        printMedium(o, "br_on_cast_fail ");
        printName(curr->name, o);
        o << ' ';
        if (curr->castType.isNullable()) {
          printMedium(o, "null ");
        }
        printHeapType(o, curr->castType.getHeapType(), wasm);
        return;
    }
    WASM_UNREACHABLE("Unexpected br_on* op");
  }
  void visitStructNew(StructNew* curr) {
    if (printUnreachableReplacement(curr)) {
      return;
    }
    printMedium(o, "struct.new");
    if (curr->isWithDefault()) {
      printMedium(o, "_default");
    }
    o << ' ';
    TypeNamePrinter(o, wasm).print(curr->type.getHeapType());
  }
  void printFieldName(HeapType type, Index index) {
    processFieldName(wasm, type, index, [&](Name name) {
      if (name.is()) {
        o << '$' << name;
      } else {
        o << index;
      }
    });
  }
  void visitStructGet(StructGet* curr) {
    if (printUnreachableOrNullReplacement(curr->ref)) {
      return;
    }
    auto heapType = curr->ref->type.getHeapType();
    const auto& field = heapType.getStruct().fields[curr->index];
    if (field.type == Type::i32 && field.packedType != Field::not_packed) {
      if (curr->signed_) {
        printMedium(o, "struct.get_s ");
      } else {
        printMedium(o, "struct.get_u ");
      }
    } else {
      printMedium(o, "struct.get ");
    }
    TypeNamePrinter(o, wasm).print(heapType);
    o << ' ';
    printFieldName(heapType, curr->index);
  }
  void visitStructSet(StructSet* curr) {
    if (printUnreachableOrNullReplacement(curr->ref)) {
      return;
    }
    printMedium(o, "struct.set ");
    auto heapType = curr->ref->type.getHeapType();
    TypeNamePrinter(o, wasm).print(heapType);
    o << ' ';
    printFieldName(heapType, curr->index);
  }
  void visitArrayNew(ArrayNew* curr) {
    if (printUnreachableReplacement(curr)) {
      return;
    }
    printMedium(o, "array.new");
    if (curr->isWithDefault()) {
      printMedium(o, "_default");
    }
    o << ' ';
    TypeNamePrinter(o, wasm).print(curr->type.getHeapType());
  }
  void visitArrayNewSeg(ArrayNewSeg* curr) {
    if (printUnreachableReplacement(curr)) {
      return;
    }
    printMedium(o, "array.new_");
    switch (curr->op) {
      case NewData:
        printMedium(o, "data");

        break;
      case NewElem:
        printMedium(o, "elem");
        break;
      default:
        WASM_UNREACHABLE("unexpected op");
    }
    o << ' ';
    TypeNamePrinter(o, wasm).print(curr->type.getHeapType());
    o << ' ' << curr->segment;
  }
  void visitArrayInit(ArrayInit* curr) {
    if (printUnreachableReplacement(curr)) {
      return;
    }
    printMedium(o, "array.init_static");
    o << ' ';
    TypeNamePrinter(o, wasm).print(curr->type.getHeapType());
  }
  void visitArrayGet(ArrayGet* curr) {
    if (printUnreachableOrNullReplacement(curr->ref)) {
      return;
    }
    const auto& element = curr->ref->type.getHeapType().getArray().element;
    if (element.type == Type::i32 && element.packedType != Field::not_packed) {
      if (curr->signed_) {
        printMedium(o, "array.get_s ");
      } else {
        printMedium(o, "array.get_u ");
      }
    } else {
      printMedium(o, "array.get ");
    }
    TypeNamePrinter(o, wasm).print(curr->ref->type.getHeapType());
  }
  void visitArraySet(ArraySet* curr) {
    if (printUnreachableOrNullReplacement(curr->ref)) {
      return;
    }
    printMedium(o, "array.set ");
    TypeNamePrinter(o, wasm).print(curr->ref->type.getHeapType());
  }
  void visitArrayLen(ArrayLen* curr) { printMedium(o, "array.len"); }
  void visitArrayCopy(ArrayCopy* curr) {
    if (printUnreachableOrNullReplacement(curr->srcRef) ||
        printUnreachableOrNullReplacement(curr->destRef)) {
      return;
    }
    printMedium(o, "array.copy ");
    TypeNamePrinter(o, wasm).print(curr->destRef->type.getHeapType());
    o << ' ';
    TypeNamePrinter(o, wasm).print(curr->srcRef->type.getHeapType());
  }
  void visitRefAs(RefAs* curr) {
    switch (curr->op) {
      case RefAsNonNull:
        printMedium(o, "ref.as_non_null");
        break;
      case ExternInternalize:
        printMedium(o, "extern.internalize");
        break;
      case ExternExternalize:
        printMedium(o, "extern.externalize");
        break;
      default:
        WASM_UNREACHABLE("invalid ref.is_*");
    }
  }
  void visitStringNew(StringNew* curr) {
    switch (curr->op) {
      case StringNewUTF8:
        if (!curr->try_) {
          printMedium(o, "string.new_wtf8 utf8");
        } else {
          printMedium(o, "string.new_utf8_try");
        }
        break;
      case StringNewWTF8:
        printMedium(o, "string.new_wtf8 wtf8");
        break;
      case StringNewReplace:
        printMedium(o, "string.new_wtf8 replace");
        break;
      case StringNewWTF16:
        printMedium(o, "string.new_wtf16");
        break;
      case StringNewUTF8Array:
        if (!curr->try_) {
          printMedium(o, "string.new_wtf8_array utf8");
        } else {
          printMedium(o, "string.new_utf8_array_try");
        }
        break;
      case StringNewWTF8Array:
        printMedium(o, "string.new_wtf8_array wtf8");
        break;
      case StringNewReplaceArray:
        printMedium(o, "string.new_wtf8_array replace");
        break;
      case StringNewWTF16Array:
        printMedium(o, "string.new_wtf16_array");
        break;
      case StringNewFromCodePoint:
        printMedium(o, "string.from_code_point");
        break;
      default:
        WASM_UNREACHABLE("invalid string.new*");
    }
  }
  void visitStringConst(StringConst* curr) {
    printMedium(o, "string.const ");
    printEscapedString(o, curr->string.str);
  }
  void visitStringMeasure(StringMeasure* curr) {
    switch (curr->op) {
      case StringMeasureUTF8:
        printMedium(o, "string.measure_wtf8 utf8");
        break;
      case StringMeasureWTF8:
        printMedium(o, "string.measure_wtf8 wtf8");
        break;
      case StringMeasureWTF16:
        printMedium(o, "string.measure_wtf16");
        break;
      case StringMeasureIsUSV:
        printMedium(o, "string.is_usv_sequence");
        break;
      case StringMeasureWTF16View:
        printMedium(o, "stringview_wtf16.length");
        break;
      case StringMeasureHash:
        printMedium(o, "string.hash");
        break;
      default:
        WASM_UNREACHABLE("invalid string.measure*");
    }
  }
  void visitStringEncode(StringEncode* curr) {
    switch (curr->op) {
      case StringEncodeUTF8:
        printMedium(o, "string.encode_wtf8 utf8");
        break;
      case StringEncodeWTF8:
        printMedium(o, "string.encode_wtf8 wtf8");
        break;
      case StringEncodeWTF16:
        printMedium(o, "string.encode_wtf16");
        break;
      case StringEncodeUTF8Array:
        printMedium(o, "string.encode_wtf8_array utf8");
        break;
      case StringEncodeWTF8Array:
        printMedium(o, "string.encode_wtf8_array wtf8");
        break;
      case StringEncodeWTF16Array:
        printMedium(o, "string.encode_wtf16_array");
        break;
      default:
        WASM_UNREACHABLE("invalid string.encode*");
    }
  }
  void visitStringConcat(StringConcat* curr) {
    printMedium(o, "string.concat");
  }
  void visitStringEq(StringEq* curr) {
    switch (curr->op) {
      case StringEqEqual:
        printMedium(o, "string.eq");
        break;
      case StringEqCompare:
        printMedium(o, "string.compare");
        break;
      default:
        WASM_UNREACHABLE("invalid string.eq*");
    }
  }
  void visitStringAs(StringAs* curr) {
    switch (curr->op) {
      case StringAsWTF8:
        printMedium(o, "string.as_wtf8");
        break;
      case StringAsWTF16:
        printMedium(o, "string.as_wtf16");
        break;
      case StringAsIter:
        printMedium(o, "string.as_iter");
        break;
      default:
        WASM_UNREACHABLE("invalid string.as*");
    }
  }
  void visitStringWTF8Advance(StringWTF8Advance* curr) {
    printMedium(o, "stringview_wtf8.advance");
  }
  void visitStringWTF16Get(StringWTF16Get* curr) {
    printMedium(o, "stringview_wtf16.get_codeunit");
  }
  void visitStringIterNext(StringIterNext* curr) {
    printMedium(o, "stringview_iter.next");
  }
  void visitStringIterMove(StringIterMove* curr) {
    switch (curr->op) {
      case StringIterMoveAdvance:
        printMedium(o, "stringview_iter.advance");
        break;
      case StringIterMoveRewind:
        printMedium(o, "stringview_iter.rewind");
        break;
      default:
        WASM_UNREACHABLE("invalid string.move*");
    }
  }
  void visitStringSliceWTF(StringSliceWTF* curr) {
    switch (curr->op) {
      case StringSliceWTF8:
        printMedium(o, "stringview_wtf8.slice");
        break;
      case StringSliceWTF16:
        printMedium(o, "stringview_wtf16.slice");
        break;
      default:
        WASM_UNREACHABLE("invalid string.slice*");
    }
  }
  void visitStringSliceIter(StringSliceIter* curr) {
    printMedium(o, "stringview_iter.slice");
  }
};

// Prints an expression in s-expr format, including both the
// internal contents and the nested children.
struct PrintSExpression : public UnifiedExpressionVisitor<PrintSExpression> {
  std::ostream& o;
  unsigned indent = 0;

  bool minify;
  const char* maybeSpace;
  const char* maybeNewLine;

  bool full = false;    // whether to not elide nodes in output when possible
                        // (like implicit blocks) and to emit types
  bool stackIR = false; // whether to print stack IR if it is present
                        // (if false, and Stack IR is there, we just
                        // note it exists)

  Module* currModule = nullptr;
  Function* currFunction = nullptr;
  Function::DebugLocation lastPrintedLocation;
  bool debugInfo;

  // Used to print delegate's depth argument when it throws to the caller
  int controlFlowDepth = 0;

  PrintSExpression(std::ostream& o) : o(o) {
    setMinify(false);
    if (!full) {
      full = isFullForced();
    }
  }

  void printDebugLocation(const Function::DebugLocation& location) {
    if (lastPrintedLocation == location) {
      return;
    }
    lastPrintedLocation = location;
    auto fileName = currModule->debugInfoFileNames[location.fileIndex];
    o << ";;@ " << fileName << ":" << location.lineNumber << ":"
      << location.columnNumber << '\n';
    doIndent(o, indent);
  }

  void printDebugLocation(Expression* curr) {
    if (currFunction) {
      // show an annotation, if there is one
      auto& debugLocations = currFunction->debugLocations;
      auto iter = debugLocations.find(curr);
      if (iter != debugLocations.end()) {
        printDebugLocation(iter->second);
      }
      // show a binary position, if there is one
      if (debugInfo) {
        auto iter = currFunction->expressionLocations.find(curr);
        if (iter != currFunction->expressionLocations.end()) {
          Colors::grey(o);
          o << ";; code offset: 0x" << std::hex << iter->second.start
            << std::dec << '\n';
          restoreNormalColor(o);
          doIndent(o, indent);
        }
      }
    }
  }

  // Prints debug info for a delimiter in an expression.
  void printDebugDelimiterLocation(Expression* curr, Index i) {
    if (currFunction && debugInfo) {
      auto iter = currFunction->delimiterLocations.find(curr);
      if (iter != currFunction->delimiterLocations.end()) {
        auto& locations = iter->second;
        Colors::grey(o);
        o << ";; code offset: 0x" << std::hex << locations[i] << std::dec
          << '\n';
        restoreNormalColor(o);
        doIndent(o, indent);
      }
    }
  }

  void printExpressionContents(Expression* curr) {
    if (currModule) {
      PrintExpressionContents(currModule, currFunction, o).visit(curr);
    } else {
      PrintExpressionContents(currFunction, o).visit(curr);
    }
  }

  void visit(Expression* curr) {
    printDebugLocation(curr);
    UnifiedExpressionVisitor<PrintSExpression>::visit(curr);
  }

  void setMinify(bool minify_) {
    minify = minify_;
    maybeSpace = minify ? "" : " ";
    maybeNewLine = minify ? "" : "\n";
  }

  void setFull(bool full_) { full = full_; }

  void setStackIR(bool stackIR_) { stackIR = stackIR_; }

  void setDebugInfo(bool debugInfo_) { debugInfo = debugInfo_; }

  void incIndent() {
    if (minify) {
      return;
    }
    o << '\n';
    indent++;
  }
  void decIndent() {
    if (!minify) {
      assert(indent > 0);
      indent--;
      doIndent(o, indent);
    }
    o << ')';
  }
  void printFullLine(Expression* expression) {
    if (!minify) {
      doIndent(o, indent);
    }
    if (full) {
      o << "[";
      printTypeOrName(expression->type, o, currModule);
      o << "] ";
    }
    visit(expression);
    o << maybeNewLine;
  }

  // loop, if, and try can contain implicit blocks. But they are not needed to
  // be printed in some cases.
  void maybePrintImplicitBlock(Expression* curr, bool allowMultipleInsts) {
    auto block = curr->dynCast<Block>();
    if (!full && block && block->name.isNull() &&
        (allowMultipleInsts || block->list.size() == 1)) {
      for (auto expression : block->list) {
        printFullLine(expression);
      }
    } else {
      printFullLine(curr);
    }
  }

  // Generic visitor, overridden only when necessary.
  void visitExpression(Expression* curr) {
    o << '(';
    printExpressionContents(curr);
    auto it = ChildIterator(curr);
    if (!it.children.empty()) {
      incIndent();
      for (auto* child : it) {
        printFullLine(child);
      }
      decIndent();
    } else {
      o << ')';
    }
  }

  void visitBlock(Block* curr) {
    // special-case Block, because Block nesting (in their first element) can be
    // incredibly deep
    std::vector<Block*> stack;
    while (1) {
      if (stack.size() > 0) {
        doIndent(o, indent);
        printDebugLocation(curr);
      }
      stack.push_back(curr);
      if (full) {
        o << "[";
        printTypeOrName(curr->type, o, currModule);
        o << "]";
      }
      o << '(';
      printExpressionContents(curr);
      incIndent();
      if (curr->list.size() > 0 && curr->list[0]->is<Block>()) {
        // recurse into the first element
        curr = curr->list[0]->cast<Block>();
        continue;
      } else {
        break; // that's all we can recurse, start to unwind
      }
    }

    controlFlowDepth += stack.size();
    auto* top = stack.back();
    while (stack.size() > 0) {
      curr = stack.back();
      stack.pop_back();
      auto& list = curr->list;
      for (size_t i = 0; i < list.size(); i++) {
        if (curr != top && i == 0) {
          // one of the block recursions we already handled
          decIndent();
          if (full) {
            o << " ;; end block";
            auto* child = list[0]->cast<Block>();
            if (child->name.is()) {
              o << ' ' << child->name;
            }
          }
          o << '\n';
          continue;
        }
        printFullLine(list[i]);
      }
      controlFlowDepth--;
    }
    decIndent();
    if (full) {
      o << " ;; end block";
      if (curr->name.is()) {
        o << ' ' << curr->name;
      }
    }
  }
  void visitIf(If* curr) {
    controlFlowDepth++;
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->condition);
    maybePrintImplicitBlock(curr->ifTrue, false);
    if (curr->ifFalse) {
      // Note: debug info here is not used as LLVM does not emit ifs, and since
      // LLVM is the main source of DWARF, effectively we never encounter ifs
      // with DWARF.
      printDebugDelimiterLocation(curr, BinaryLocations::Else);
      maybePrintImplicitBlock(curr->ifFalse, false);
    }
    decIndent();
    if (full) {
      o << " ;; end if";
    }
    controlFlowDepth--;
  }
  void visitLoop(Loop* curr) {
    controlFlowDepth++;
    o << '(';
    printExpressionContents(curr);
    incIndent();
    maybePrintImplicitBlock(curr->body, true);
    decIndent();
    if (full) {
      o << " ;; end loop";
      if (curr->name.is()) {
        o << ' ' << curr->name;
      }
    }
    controlFlowDepth--;
  }
  // try-catch-end is written in the folded wat format as
  // (try
  //  (do
  //   ...
  //  )
  //  (catch $e
  //    ...
  //  )
  //  ...
  //  (catch_all
  //    ...
  //  )
  // )
  // The parenthesis wrapping do/catch/catch_all is just a syntax and does not
  // affect nested depths of instructions within.
  //
  // try-delegate is written in the forded format as
  // (try
  //  (do
  //    ...
  //  )
  //  (delegate $label)
  // )
  // When the 'delegate' delegates to the caller, we write the argument as an
  // immediate.
  void visitTry(Try* curr) {
    controlFlowDepth++;
    o << '(';
    printExpressionContents(curr);
    incIndent();
    doIndent(o, indent);
    o << '(';
    printMedium(o, "do");
    incIndent();
    maybePrintImplicitBlock(curr->body, true);
    decIndent();
    o << "\n";
    for (size_t i = 0; i < curr->catchTags.size(); i++) {
      doIndent(o, indent);
      printDebugDelimiterLocation(curr, i);
      o << '(';
      printMedium(o, "catch ");
      printName(curr->catchTags[i], o);
      incIndent();
      maybePrintImplicitBlock(curr->catchBodies[i], true);
      decIndent();
      o << "\n";
    }
    if (curr->hasCatchAll()) {
      doIndent(o, indent);
      printDebugDelimiterLocation(curr, curr->catchTags.size());
      o << '(';
      printMedium(o, "catch_all");
      incIndent();
      maybePrintImplicitBlock(curr->catchBodies.back(), true);
      decIndent();
      o << "\n";
    }
    controlFlowDepth--;

    if (curr->isDelegate()) {
      doIndent(o, indent);
      o << '(';
      printMedium(o, "delegate ");
      if (curr->delegateTarget == DELEGATE_CALLER_TARGET) {
        o << controlFlowDepth;
      } else {
        printName(curr->delegateTarget, o);
      }
      o << ")\n";
    }
    decIndent();
    if (full) {
      o << " ;; end try";
    }
  }
  void maybePrintUnreachableReplacement(Expression* curr, Type type) {
    // See the parallel function
    // PrintExpressionContents::printUnreachableReplacement for background. That
    // one handles the header, and this one the body. For convenience, this one
    // also gets a parameter of the type to check for unreachability, to avoid
    // boilerplate in the callers; if the type is not unreachable, it does the
    // normal behavior.
    //
    // Note that the list of instructions using that function must match those
    // using this one, so we print the header and body properly together.

    if (type != Type::unreachable) {
      visitExpression(curr);
      return;
    }

    // Emit a block with drops of the children.
    o << "(block";
    if (!minify) {
      o << " ;; (replaces something unreachable we can't emit)";
    }
    incIndent();
    for (auto* child : ChildIterator(curr)) {
      Drop drop;
      drop.value = child;
      printFullLine(&drop);
    }
    Unreachable unreachable;
    printFullLine(&unreachable);
    decIndent();
  }
  // This must be used for the same Expressions that use
  // PrintExpressionContents::printUnreachableOrNullReplacement.
  void maybePrintUnreachableOrNullReplacement(Expression* curr, Type type) {
    if (type.isNull()) {
      type = Type::unreachable;
    }
    maybePrintUnreachableReplacement(curr, type);
  }
  void visitCallRef(CallRef* curr) {
    maybePrintUnreachableOrNullReplacement(curr, curr->target->type);
  }
  void visitRefCast(RefCast* curr) {
    maybePrintUnreachableReplacement(curr, curr->type);
  }
  void visitStructNew(StructNew* curr) {
    maybePrintUnreachableReplacement(curr, curr->type);
  }
  void visitStructSet(StructSet* curr) {
    maybePrintUnreachableOrNullReplacement(curr, curr->ref->type);
  }
  void visitStructGet(StructGet* curr) {
    maybePrintUnreachableOrNullReplacement(curr, curr->ref->type);
  }
  void visitArrayNew(ArrayNew* curr) {
    maybePrintUnreachableReplacement(curr, curr->type);
  }
  void visitArrayNewSeg(ArrayNewSeg* curr) {
    maybePrintUnreachableReplacement(curr, curr->type);
  }
  void visitArrayInit(ArrayInit* curr) {
    maybePrintUnreachableReplacement(curr, curr->type);
  }
  void visitArraySet(ArraySet* curr) {
    maybePrintUnreachableOrNullReplacement(curr, curr->ref->type);
  }
  void visitArrayGet(ArrayGet* curr) {
    maybePrintUnreachableOrNullReplacement(curr, curr->ref->type);
  }
  // Module-level visitors
  void printSupertypeOr(HeapType curr, std::string noSuper) {
    if (auto super = curr.getSuperType()) {
      TypeNamePrinter(o, currModule).print(*super);
    } else {
      o << noSuper;
    }
  }

  void handleSignature(HeapType curr, Name name = Name()) {
    Signature sig = curr.getSignature();
    bool hasSupertype = !name.is() && !!curr.getSuperType();
    if (hasSupertype) {
      o << "(func_subtype";
    } else {
      o << "(func";
    }
    if (name.is()) {
      o << " $" << name;
    }
    if (sig.params.size() > 0) {
      o << maybeSpace;
      o << "(param ";
      auto sep = "";
      for (auto type : sig.params) {
        o << sep;
        printType(o, type, currModule);
        sep = " ";
      }
      o << ')';
    }
    if (sig.results.size() > 0) {
      o << maybeSpace;
      o << "(result ";
      auto sep = "";
      for (auto type : sig.results) {
        o << sep;
        printType(o, type, currModule);
        sep = " ";
      }
      o << ')';
    }
    if (hasSupertype) {
      o << ' ';
      printSupertypeOr(curr, "func");
    }
    o << ")";
  }
  void handleFieldBody(const Field& field) {
    if (field.mutable_) {
      o << "(mut ";
    }
    if (field.type == Type::i32 && field.packedType != Field::not_packed) {
      if (field.packedType == Field::i8) {
        o << "i8";
      } else if (field.packedType == Field::i16) {
        o << "i16";
      } else {
        WASM_UNREACHABLE("invalid packed type");
      }
    } else {
      printType(o, field.type, currModule);
    }
    if (field.mutable_) {
      o << ')';
    }
  }
  void handleArray(HeapType curr) {
    bool hasSupertype = !!curr.getSuperType();
    if (hasSupertype) {
      o << "(array_subtype ";
    } else {
      o << "(array ";
    }
    handleFieldBody(curr.getArray().element);
    if (hasSupertype) {
      o << ' ';
      printSupertypeOr(curr, "data");
    }
    o << ')';
  }
  void handleStruct(HeapType curr) {
    bool hasSupertype = !!curr.getSuperType();
    const auto& fields = curr.getStruct().fields;
    if (hasSupertype) {
      o << "(struct_subtype ";
    } else {
      o << "(struct ";
    }
    auto sep = "";
    for (Index i = 0; i < fields.size(); i++) {
      o << sep << "(field ";
      processFieldName(currModule, curr, i, [&](Name name) {
        if (name.is()) {
          o << '$' << name << ' ';
        }
      });
      handleFieldBody(fields[i]);
      o << ')';
      sep = " ";
    }
    if (hasSupertype) {
      o << ' ';
      printSupertypeOr(curr, "data");
    }
    o << ')';
  }
  void handleHeapType(HeapType type) {
    if (type.isSignature()) {
      handleSignature(type);
    } else if (type.isArray()) {
      handleArray(type);
    } else if (type.isStruct()) {
      handleStruct(type);
    } else {
      o << type;
    }
  }
  void visitExport(Export* curr) {
    o << '(';
    printMedium(o, "export ");
    // TODO: Escape the string properly.
    printText(o, curr->name.str.data()) << " (";
    switch (curr->kind) {
      case ExternalKind::Function:
        o << "func";
        break;
      case ExternalKind::Table:
        o << "table";
        break;
      case ExternalKind::Memory:
        o << "memory";
        break;
      case ExternalKind::Global:
        o << "global";
        break;
      case ExternalKind::Tag:
        o << "tag";
        break;
      case ExternalKind::Invalid:
        WASM_UNREACHABLE("invalid ExternalKind");
    }
    o << ' ';
    printName(curr->value, o) << "))";
  }
  void emitImportHeader(Importable* curr) {
    printMedium(o, "import ");
    // TODO: Escape the strings properly and use std::string_view.
    printText(o, curr->module.str.data()) << ' ';
    printText(o, curr->base.str.data()) << ' ';
  }
  void visitGlobal(Global* curr) {
    if (curr->imported()) {
      visitImportedGlobal(curr);
    } else {
      visitDefinedGlobal(curr);
    }
  }
  void emitGlobalType(Global* curr) {
    if (curr->mutable_) {
      o << "(mut ";
      printType(o, curr->type, currModule) << ')';
    } else {
      printType(o, curr->type, currModule);
    }
  }
  void visitImportedGlobal(Global* curr) {
    doIndent(o, indent);
    o << '(';
    emitImportHeader(curr);
    o << "(global ";
    printName(curr->name, o) << ' ';
    emitGlobalType(curr);
    o << "))" << maybeNewLine;
  }
  void visitDefinedGlobal(Global* curr) {
    doIndent(o, indent);
    o << '(';
    printMedium(o, "global ");
    printName(curr->name, o) << ' ';
    emitGlobalType(curr);
    o << ' ';
    visit(curr->init);
    o << ')';
    o << maybeNewLine;
  }
  void visitFunction(Function* curr) {
    if (curr->imported()) {
      visitImportedFunction(curr);
    } else {
      visitDefinedFunction(curr);
    }
  }
  void visitImportedFunction(Function* curr) {
    doIndent(o, indent);
    currFunction = curr;
    lastPrintedLocation = {0, 0, 0};
    o << '(';
    emitImportHeader(curr);
    handleSignature(curr->getSig(), curr->name);
    o << ')';
    o << maybeNewLine;
  }
  void visitDefinedFunction(Function* curr) {
    doIndent(o, indent);
    currFunction = curr;
    lastPrintedLocation = {0, 0, 0};
    if (currFunction->prologLocation.size()) {
      printDebugLocation(*currFunction->prologLocation.begin());
    }
    o << '(';
    printMajor(o, "func ");
    printName(curr->name, o);
    if (currModule && currModule->features.hasGC()) {
      o << " (type ";
      printHeapType(o, curr->type, currModule) << ')';
    }
    if (!stackIR && curr->stackIR && !minify) {
      o << " (; has Stack IR ;)";
    }
    if (curr->getParams().size() > 0) {
      Index i = 0;
      for (const auto& param : curr->getParams()) {
        o << maybeSpace;
        o << '(';
        printMinor(o, "param ");
        printLocal(i, currFunction, o);
        o << ' ';
        printType(o, param, currModule) << ')';
        ++i;
      }
    }
    if (curr->getResults() != Type::none) {
      o << maybeSpace;
      printResultType(o, curr->getResults(), currModule);
    }
    incIndent();
    for (size_t i = curr->getVarIndexBase(); i < curr->getNumLocals(); i++) {
      doIndent(o, indent);
      o << '(';
      printMinor(o, "local ");
      printLocal(i, currFunction, o) << ' ';
      printType(o, curr->getLocalType(i), currModule) << ')';
      o << maybeNewLine;
    }
    // Print the body.
    if (!stackIR || !curr->stackIR) {
      // It is ok to emit a block here, as a function can directly contain a
      // list, even if our ast avoids that for simplicity. We can just do that
      // optimization here..
      if (!full && curr->body->is<Block>() &&
          curr->body->cast<Block>()->name.isNull()) {
        Block* block = curr->body->cast<Block>();
        for (auto item : block->list) {
          printFullLine(item);
        }
      } else {
        printFullLine(curr->body);
      }
      assert(controlFlowDepth == 0);
    } else {
      // Print the stack IR.
      printStackIR(curr->stackIR.get(), o, curr);
    }
    if (currFunction->epilogLocation.size() &&
        lastPrintedLocation != *currFunction->epilogLocation.begin()) {
      // Print last debug location: mix of decIndent and printDebugLocation
      // logic.
      doIndent(o, indent);
      if (!minify) {
        indent--;
      }
      printDebugLocation(*currFunction->epilogLocation.begin());
      o << ')';
    } else {
      decIndent();
    }
    o << maybeNewLine;
  }
  void visitTag(Tag* curr) {
    if (curr->imported()) {
      visitImportedTag(curr);
    } else {
      visitDefinedTag(curr);
    }
  }
  void visitImportedTag(Tag* curr) {
    doIndent(o, indent);
    o << '(';
    emitImportHeader(curr);
    o << "(tag ";
    printName(curr->name, o);
    o << maybeSpace;
    printParamType(o, curr->sig.params, currModule);
    o << "))";
    o << maybeNewLine;
  }
  void visitDefinedTag(Tag* curr) {
    doIndent(o, indent);
    o << '(';
    printMedium(o, "tag ");
    printName(curr->name, o);
    o << maybeSpace;
    printParamType(o, curr->sig.params, currModule);
    o << ")" << maybeNewLine;
  }
  void printTableHeader(Table* curr) {
    o << '(';
    printMedium(o, "table") << ' ';
    printName(curr->name, o) << ' ';
    o << curr->initial;
    if (curr->hasMax()) {
      o << ' ' << curr->max;
    }
    o << ' ';
    printType(o, curr->type, currModule) << ')';
  }
  void visitTable(Table* curr) {
    if (curr->imported()) {
      doIndent(o, indent);
      o << '(';
      emitImportHeader(curr);
      printTableHeader(curr);
      o << ')' << maybeNewLine;
    } else {
      doIndent(o, indent);
      printTableHeader(curr);
      o << maybeNewLine;
    }
  }
  void visitElementSegment(ElementSegment* curr) {
    bool usesExpressions = TableUtils::usesExpressions(curr, currModule);
    auto printElemType = [&]() {
      if (!usesExpressions) {
        o << "func";
      } else {
        printType(o, curr->type, currModule);
      }
    };

    doIndent(o, indent);
    o << '(';
    printMedium(o, "elem");
    // If there is no explicit name, and there are multiple segments, use our
    // internal names to differentiate them.
    if (curr->hasExplicitName || currModule->elementSegments.size() > 1) {
      o << ' ';
      printName(curr->name, o);
    }

    if (curr->table.is()) {
      if (usesExpressions || currModule->tables.size() > 1) {
        // tableuse
        o << " (table ";
        printName(curr->table, o);
        o << ")";
      }

      o << ' ';
      visit(curr->offset);

      if (usesExpressions || currModule->tables.size() > 1) {
        o << ' ';
        printElemType();
      }
    } else {
      o << ' ';
      printElemType();
    }

    if (!usesExpressions) {
      for (auto* entry : curr->data) {
        auto* refFunc = entry->cast<RefFunc>();
        o << ' ';
        printName(refFunc->func, o);
      }
    } else {
      for (auto* entry : curr->data) {
        o << ' ';
        printExpression(entry, o);
      }
    }
    o << ')' << maybeNewLine;
  }
  void printMemoryHeader(Memory* curr) {
    o << '(';
    printMedium(o, "memory") << ' ';
    printName(curr->name, o) << ' ';
    if (curr->shared) {
      o << '(';
      printMedium(o, "shared ");
    }
    if (curr->is64()) {
      o << "i64 ";
    }
    o << curr->initial;
    if (curr->hasMax()) {
      o << ' ' << curr->max;
    }
    if (curr->shared) {
      o << ")";
    }
    o << ")";
  }
  void visitMemory(Memory* curr) {
    if (curr->imported()) {
      doIndent(o, indent);
      o << '(';
      emitImportHeader(curr);
      printMemoryHeader(curr);
      o << ')' << maybeNewLine;
    } else {
      doIndent(o, indent);
      printMemoryHeader(curr);
      o << '\n';
    }
  }
  void visitDataSegment(DataSegment* curr) {
    doIndent(o, indent);
    o << '(';
    printMajor(o, "data ");
    if (curr->hasExplicitName) {
      printName(curr->name, o);
      o << ' ';
    }
    if (!curr->isPassive) {
      assert(!currModule || currModule->memories.size() > 0);
      if (!currModule || curr->memory != currModule->memories[0]->name) {
        o << "(memory $" << curr->memory << ") ";
      }
      visit(curr->offset);
      o << ' ';
    }
    printEscapedString(o, {curr->data.data(), curr->data.size()});
    o << ')' << maybeNewLine;
  }
  void printDylinkSection(const std::unique_ptr<DylinkSection>& dylinkSection) {
    doIndent(o, indent) << ";; dylink section\n";
    doIndent(o, indent) << ";;   memorysize: " << dylinkSection->memorySize
                        << '\n';
    doIndent(o, indent) << ";;   memoryalignment: "
                        << dylinkSection->memoryAlignment << '\n';
    doIndent(o, indent) << ";;   tablesize: " << dylinkSection->tableSize
                        << '\n';
    doIndent(o, indent) << ";;   tablealignment: "
                        << dylinkSection->tableAlignment << '\n';
    for (auto& neededDynlib : dylinkSection->neededDynlibs) {
      doIndent(o, indent) << ";;   needed dynlib: " << neededDynlib << '\n';
    }
    if (dylinkSection->tail.size()) {
      doIndent(o, indent) << ";;   extra dylink data, size "
                          << dylinkSection->tail.size() << "\n";
    }
  }
  void visitModule(Module* curr) {
    currModule = curr;
    o << '(';
    printMajor(o, "module");
    if (curr->name.is()) {
      o << ' ';
      printName(curr->name, o);
    }
    incIndent();

    // Use the same type order as the binary output would even though there is
    // no code size benefit in the text format.
    auto indexedTypes = ModuleUtils::getOptimizedIndexedHeapTypes(*curr);
    std::optional<RecGroup> currGroup;
    bool nontrivialGroup = false;
    auto finishGroup = [&]() {
      if (nontrivialGroup) {
        decIndent();
        o << maybeNewLine;
      }
    };
    for (auto type : indexedTypes.types) {
      RecGroup newGroup = type.getRecGroup();
      if (!currGroup || *currGroup != newGroup) {
        if (currGroup) {
          finishGroup();
        }
        currGroup = newGroup;
        nontrivialGroup = currGroup->size() > 1;
        if (nontrivialGroup) {
          doIndent(o, indent);
          o << "(rec";
          incIndent();
        }
      }
      doIndent(o, indent);
      o << '(';
      printMedium(o, "type") << ' ';
      TypeNamePrinter(o, curr).print(type);
      o << ' ';
      handleHeapType(type);
      o << ")" << maybeNewLine;
    }
    finishGroup();

    ModuleUtils::iterImportedMemories(
      *curr, [&](Memory* memory) { visitMemory(memory); });
    ModuleUtils::iterImportedTables(*curr,
                                    [&](Table* table) { visitTable(table); });
    ModuleUtils::iterImportedGlobals(
      *curr, [&](Global* global) { visitGlobal(global); });
    ModuleUtils::iterImportedFunctions(
      *curr, [&](Function* func) { visitFunction(func); });
    ModuleUtils::iterImportedTags(*curr, [&](Tag* tag) { visitTag(tag); });
    ModuleUtils::iterDefinedGlobals(
      *curr, [&](Global* global) { visitGlobal(global); });
    ModuleUtils::iterDefinedMemories(
      *curr, [&](Memory* memory) { visitMemory(memory); });
    for (auto& segment : curr->dataSegments) {
      visitDataSegment(segment.get());
    }
    ModuleUtils::iterDefinedTables(*curr,
                                   [&](Table* table) { visitTable(table); });
    for (auto& segment : curr->elementSegments) {
      visitElementSegment(segment.get());
    }
    auto elemDeclareNames = TableUtils::getFunctionsNeedingElemDeclare(*curr);
    if (!elemDeclareNames.empty()) {
      doIndent(o, indent);
      printMedium(o, "(elem");
      o << " declare func";
      for (auto name : elemDeclareNames) {
        o << " $" << name;
      }
      o << ')' << maybeNewLine;
    }
    ModuleUtils::iterDefinedTags(*curr, [&](Tag* tag) { visitTag(tag); });
    for (auto& child : curr->exports) {
      doIndent(o, indent);
      visitExport(child.get());
      o << maybeNewLine;
    }
    if (curr->start.is()) {
      doIndent(o, indent);
      o << '(';
      printMedium(o, "start") << ' ';
      printName(curr->start, o) << ')';
      o << maybeNewLine;
    }
    ModuleUtils::iterDefinedFunctions(
      *curr, [&](Function* func) { visitFunction(func); });
    if (curr->dylinkSection) {
      printDylinkSection(curr->dylinkSection);
    }
    for (auto& section : curr->customSections) {
      doIndent(o, indent);
      o << ";; custom section \"" << section.name << "\", size "
        << section.data.size();
      bool isPrintable = true;
      for (auto c : section.data) {
        if (!isprint(static_cast<unsigned char>(c))) {
          isPrintable = false;
          break;
        }
      }
      if (isPrintable) {
        o << ", contents: ";
        // std::quoted is not available in all the supported compilers yet.
        o << '"';
        for (auto c : section.data) {
          if (c == '\\' || c == '"') {
            o << '\\';
          }
          o << c;
        }
        o << '"';
      }
      o << maybeNewLine;
    }
    if (curr->hasFeaturesSection) {
      doIndent(o, indent);
      o << ";; features section: " << curr->features.toString() << '\n';
    }
    decIndent();
    o << maybeNewLine;
    currModule = nullptr;
  }
};

// Prints out a module
class Printer : public Pass {
protected:
  std::ostream& o;

public:
  Printer() : o(std::cout) {}
  Printer(std::ostream* o) : o(*o) {}

  bool modifiesBinaryenIR() override { return false; }

  void run(Module* module) override {
    PrintSExpression print(o);
    print.setDebugInfo(getPassOptions().debugInfo);
    print.visitModule(module);
  }
};

Pass* createPrinterPass() { return new Printer(); }

// Prints out a minified module

class MinifiedPrinter : public Printer {
public:
  MinifiedPrinter() = default;
  MinifiedPrinter(std::ostream* o) : Printer(o) {}

  void run(Module* module) override {
    PrintSExpression print(o);
    print.setMinify(true);
    print.setDebugInfo(getPassOptions().debugInfo);
    print.visitModule(module);
  }
};

Pass* createMinifiedPrinterPass() { return new MinifiedPrinter(); }

// Prints out a module withough elision, i.e., the full ast

class FullPrinter : public Printer {
public:
  FullPrinter() = default;
  FullPrinter(std::ostream* o) : Printer(o) {}

  void run(Module* module) override {
    PrintSExpression print(o);
    print.setFull(true);
    print.setDebugInfo(getPassOptions().debugInfo);
    print.currModule = module;
    print.visitModule(module);
  }
};

Pass* createFullPrinterPass() { return new FullPrinter(); }

// Print Stack IR (if present)

class PrintStackIR : public Printer {
public:
  PrintStackIR() = default;
  PrintStackIR(std::ostream* o) : Printer(o) {}

  void run(Module* module) override {
    PrintSExpression print(o);
    print.setDebugInfo(getPassOptions().debugInfo);
    print.setStackIR(true);
    print.currModule = module;
    print.visitModule(module);
  }
};

Pass* createPrintStackIRPass() { return new PrintStackIR(); }

static std::ostream& printExpression(Expression* expression,
                                     std::ostream& o,
                                     bool minify,
                                     bool full,
                                     Module* wasm) {
  if (!expression) {
    o << "(null expression)";
    return o;
  }
  PrintSExpression print(o);
  print.setMinify(minify);
  print.currModule = wasm;
  if (full || isFullForced()) {
    print.setFull(true);
    o << "[";
    printTypeOrName(expression->type, o, wasm);
    o << "] ";
  }
  print.visit(expression);
  return o;
}

static std::ostream&
printStackInst(StackInst* inst, std::ostream& o, Function* func) {
  switch (inst->op) {
    case StackInst::Basic:
    case StackInst::BlockBegin:
    case StackInst::IfBegin:
    case StackInst::LoopBegin:
    case StackInst::TryBegin: {
      PrintExpressionContents(func, o).visit(inst->origin);
      break;
    }
    case StackInst::BlockEnd:
    case StackInst::IfEnd:
    case StackInst::LoopEnd:
    case StackInst::TryEnd: {
      printMedium(o, "end");
      o << " ;; type: ";
      TypeNamePrinter(o).print(inst->type);
      break;
    }
    case StackInst::IfElse: {
      printMedium(o, "else");
      break;
    }
    case StackInst::Catch: {
      // Because StackInst does not have info on which catch within a try this
      // is, we can't print the tag name.
      printMedium(o, "catch");
      break;
    }
    case StackInst::CatchAll: {
      printMedium(o, "catch_all");
      break;
    }
    case StackInst::Delegate: {
      printMedium(o, "delegate ");
      printName(inst->origin->cast<Try>()->delegateTarget, o);
      break;
    }
    default:
      WASM_UNREACHABLE("unexpeted op");
  }
  return o;
}

static std::ostream&
printStackIR(StackIR* ir, std::ostream& o, Function* func) {
  size_t indent = func ? 2 : 0;
  auto doIndent = [&]() { o << std::string(indent, ' '); };

  int controlFlowDepth = 0;
  // Stack to track indices of catches within a try
  SmallVector<Index, 4> catchIndexStack;
  for (Index i = 0; i < (*ir).size(); i++) {
    auto* inst = (*ir)[i];
    if (!inst) {
      continue;
    }
    switch (inst->op) {
      case StackInst::Basic: {
        doIndent();
        // Pop is a pseudo instruction and should not be printed in the stack IR
        // format to make it valid wat form.
        if (inst->origin->is<Pop>()) {
          break;
        }

        PrintExpressionContents(func, o).visit(inst->origin);
        break;
      }
      case StackInst::TryBegin:
        catchIndexStack.push_back(0);
        [[fallthrough]];
      case StackInst::BlockBegin:
      case StackInst::IfBegin:
      case StackInst::LoopBegin: {
        controlFlowDepth++;
        doIndent();
        PrintExpressionContents(func, o).visit(inst->origin);
        indent++;
        break;
      }
      case StackInst::TryEnd:
        catchIndexStack.pop_back();
        [[fallthrough]];
      case StackInst::BlockEnd:
      case StackInst::IfEnd:
      case StackInst::LoopEnd: {
        controlFlowDepth--;
        indent--;
        doIndent();
        printMedium(o, "end");
        break;
      }
      case StackInst::IfElse: {
        indent--;
        doIndent();
        printMedium(o, "else");
        indent++;
        break;
      }
      case StackInst::Catch: {
        indent--;
        doIndent();
        printMedium(o, "catch ");
        Try* curr = inst->origin->cast<Try>();
        printName(curr->catchTags[catchIndexStack.back()++], o);
        indent++;
        break;
      }
      case StackInst::CatchAll: {
        indent--;
        doIndent();
        printMedium(o, "catch_all");
        indent++;
        break;
      }
      case StackInst::Delegate: {
        controlFlowDepth--;
        indent--;
        doIndent();
        printMedium(o, "delegate ");
        Try* curr = inst->origin->cast<Try>();
        if (curr->delegateTarget == DELEGATE_CALLER_TARGET) {
          o << controlFlowDepth;
        } else {
          printName(curr->delegateTarget, o);
        }
        break;
      }
      default:
        WASM_UNREACHABLE("unexpeted op");
    }
    o << '\n';
  }
  assert(controlFlowDepth == 0);
  return o;
}

std::ostream& printStackIR(std::ostream& o, Module* module, bool optimize) {
  wasm::PassRunner runner(module);
  runner.add("generate-stack-ir");
  if (optimize) {
    runner.add("optimize-stack-ir");
  }
  runner.add(std::make_unique<PrintStackIR>(&o));
  runner.run();
  return o;
}

} // namespace wasm

namespace std {

std::ostream& operator<<(std::ostream& o, wasm::Module& module) {
  wasm::PassRunner runner(&module);
  wasm::Printer printer(&o);
  // Do not use runner.run(), since that will cause an infinite recursion in
  // BINARYEN_PASS_DEBUG=3, which prints modules (using this function) as part
  // of running passes.
  printer.setPassRunner(&runner);
  printer.run(&module);
  return o;
}

std::ostream& operator<<(std::ostream& o, wasm::Expression& expression) {
  return wasm::printExpression(&expression, o);
}

std::ostream& operator<<(std::ostream& o, wasm::Expression* expression) {
  return wasm::printExpression(expression, o);
}

std::ostream& operator<<(std::ostream& o, wasm::ModuleExpression pair) {
  return wasm::printExpression(pair.second, o, false, false, &pair.first);
}

std::ostream& operator<<(std::ostream& o, wasm::StackInst& inst) {
  return wasm::printStackInst(&inst, o);
}

std::ostream& operator<<(std::ostream& o, wasm::StackIR& ir) {
  return wasm::printStackIR(&ir, o);
}

} // namespace std
