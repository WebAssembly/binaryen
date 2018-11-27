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
// asm.js-to-WebAssembly translator. Uses the Emscripten optimizer
// infrastructure.
//

#ifndef wasm_asm2wasm_h
#define wasm_asm2wasm_h

#include "wasm.h"
#include "emscripten-optimizer/optimizer.h"
#include "mixed_arena.h"
#include "shared-constants.h"
#include "asmjs/shared-constants.h"
#include "asm_v_wasm.h"
#include "passes/passes.h"
#include "pass.h"
#include "parsing.h"
#include "ir/bits.h"
#include "ir/branch-utils.h"
#include "ir/function-type-utils.h"
#include "ir/literal-utils.h"
#include "ir/module-utils.h"
#include "ir/trapping.h"
#include "ir/utils.h"
#include "wasm-builder.h"
#include "wasm-emscripten.h"
#include "wasm-module-building.h"

namespace wasm {

using namespace cashew;

// Names

Name I32_CTTZ("i32_cttz"),
     I32_CTPOP("i32_ctpop"),
     I32_BC2F("i32_bc2f"),
     I32_BC2I("i32_bc2i"),
     I64("i64"),
     I64_CONST("i64_const"),
     I64_ADD("i64_add"),
     I64_SUB("i64_sub"),
     I64_MUL("i64_mul"),
     I64_UDIV("i64_udiv"),
     I64_SDIV("i64_sdiv"),
     I64_UREM("i64_urem"),
     I64_SREM("i64_srem"),
     I64_AND("i64_and"),
     I64_OR("i64_or"),
     I64_XOR("i64_xor"),
     I64_SHL("i64_shl"),
     I64_ASHR("i64_ashr"),
     I64_LSHR("i64_lshr"),
     I64_EQ("i64_eq"),
     I64_NE("i64_ne"),
     I64_ULE("i64_ule"),
     I64_SLE("i64_sle"),
     I64_UGE("i64_uge"),
     I64_SGE("i64_sge"),
     I64_ULT("i64_ult"),
     I64_SLT("i64_slt"),
     I64_UGT("i64_ugt"),
     I64_SGT("i64_sgt"),
     I64_TRUNC("i64_trunc"),
     I64_SEXT("i64_sext"),
     I64_ZEXT("i64_zext"),
     I64_S2F("i64_s2f"),
     I64_S2D("i64_s2d"),
     I64_U2F("i64_u2f"),
     I64_U2D("i64_u2d"),
     I64_F2S("i64_f2s"),
     I64_D2S("i64_d2s"),
     I64_F2U("i64_f2u"),
     I64_D2U("i64_d2u"),
     I64_BC2D("i64_bc2d"),
     I64_BC2I("i64_bc2i"),
     I64_CTTZ("i64_cttz"),
     I64_CTLZ("i64_ctlz"),
     I64_CTPOP("i64_ctpop"),
     F32_COPYSIGN("f32_copysign"),
     F64_COPYSIGN("f64_copysign"),
     LOAD1("load1"),
     LOAD2("load2"),
     LOAD4("load4"),
     LOAD8("load8"),
     LOADF("loadf"),
     LOADD("loadd"),
     STORE1("store1"),
     STORE2("store2"),
     STORE4("store4"),
     STORE8("store8"),
     STOREF("storef"),
     STORED("stored"),
     FTCALL("ftCall_"),
     MFTCALL("mftCall_"),
     MAX_("max"),
     MIN_("min"),
     ATOMICS("Atomics"),
     ATOMICS_LOAD("load"),
     ATOMICS_STORE("store"),
     ATOMICS_EXCHANGE("exchange"),
     ATOMICS_COMPARE_EXCHANGE("compareExchange"),
     ATOMICS_ADD("add"),
     ATOMICS_SUB("sub"),
     ATOMICS_AND("and"),
     ATOMICS_OR("or"),
     ATOMICS_XOR("xor"),
     I64_ATOMICS_LOAD("i64_atomics_load"),
     I64_ATOMICS_STORE("i64_atomics_store"),
     I64_ATOMICS_AND("i64_atomics_and"),
     I64_ATOMICS_OR("i64_atomics_or"),
     I64_ATOMICS_XOR("i64_atomics_xor"),
     I64_ATOMICS_ADD("i64_atomics_add"),
     I64_ATOMICS_SUB("i64_atomics_sub"),
     I64_ATOMICS_EXCHANGE("i64_atomics_exchange"),
     I64_ATOMICS_COMPAREEXCHANGE("i64_atomics_compareExchange"),
     EMSCRIPTEN_DEBUGINFO("emscripten_debuginfo");

// Utilities

static void abort_on(std::string why, Ref element) {
  std::cerr << why << ' ';
  element->stringify(std::cerr);
  std::cerr << '\n';
  abort();
}
static void abort_on(std::string why, IString element) {
  std::cerr << why << ' ' << element.str << '\n';
  abort();
}

Index indexOr(Index x, Index y) {
  return x ? x : y;
}

// useful when we need to see our parent, in an asm.js expression stack
struct AstStackHelper {
  static std::vector<Ref> astStack;
  AstStackHelper(Ref curr) {
    astStack.push_back(curr);
  }
  ~AstStackHelper() {
    astStack.pop_back();
  }
  Ref getParent() {
    if (astStack.size() >= 2) {
      return astStack[astStack.size()-2];
    } else {
      return Ref();
    }
  }
};

std::vector<Ref> AstStackHelper::astStack;

static bool startsWith(const char* string, const char *prefix) {
  while (1) {
    if (*prefix == 0) return true;
    if (*string == 0) return false;
    if (*string++ != *prefix++) return false;
  }
};

//
// Asm2WasmPreProcessor - does some initial parsing/processing
// of asm.js code.
//

struct Asm2WasmPreProcessor {
  bool memoryGrowth = false;
  bool debugInfo = false;

  std::vector<std::string> debugInfoFileNames;
  std::unordered_map<std::string, Index> debugInfoFileIndices;

  char* allocatedCopy = nullptr;

  ~Asm2WasmPreProcessor() {
    if (allocatedCopy) free(allocatedCopy);
  }

  char* process(char* input) {
    // emcc --separate-asm modules can look like
    //
    //    Module["asm"] = (function(global, env, buffer) {
    //      ..
    //    });
    //
    // we need to clean that up.
    if (*input == 'M') {
      size_t num = strlen(input);
      while (*input != 'f') {
        input++;
        num--;
      }
      char *end = input + num - 1;
      while (*end != '}') {
        *end = 0;
        end--;
      }
    }

    // asm.js memory growth uses a quite elaborate pattern. Instead of parsing and
    // matching it, we do a simpler detection on emscripten's asm.js output format
    const char* START_FUNCS = "// EMSCRIPTEN_START_FUNCS";
    char *marker = strstr(input, START_FUNCS);
    if (marker) {
      *marker = 0; // look for memory growth code just up to here, as an optimization
    }
    char *growthSign = strstr(input, "return true;"); // this can only show up in growth code, as normal asm.js lacks "true"
    if (growthSign) {
      memoryGrowth = true;
      // clean out this function, we don't need it. first where it starts
      char *growthFuncStart = growthSign;
      while (*growthFuncStart != '{') growthFuncStart--; // skip body
      while (*growthFuncStart != '(') growthFuncStart--; // skip params
      while (*growthFuncStart != ' ') growthFuncStart--; // skip function name
      while (*growthFuncStart != 'f') growthFuncStart--; // skip 'function'
      assert(strstr(growthFuncStart, "function ") == growthFuncStart);
      char *growthFuncEnd = strchr(growthSign, '}');
      assert(growthFuncEnd > growthFuncStart + 5);
      growthFuncStart[0] = '/';
      growthFuncStart[1] = '*';
      growthFuncEnd--;
      growthFuncEnd[0] = '*';
      growthFuncEnd[1] = '/';
    }
    if (marker) {
      *marker = START_FUNCS[0];
    }

    // handle debug info, if this build wants that.
    if (debugInfo) {
      // asm.js debug info comments look like
      //   ..command..; //@line 4 "tests/hello_world.c"
      // we convert those into emscripten_debuginfo(file, line)
      // calls, where the params are indices into a mapping. then
      // the compiler and optimizer can operate on them. after
      // that, we can apply the debug info to the wasm node right
      // before it - this is guaranteed to be correct without opts,
      // and is usually decently accurate with them.
      const auto SCALE_FACTOR = 1.25; // an upper bound on how much more space we need as a multiple of the original
      const auto ADD_FACTOR = 100; // an upper bound on how much we write for each debug info element itself
      auto size = strlen(input);
      auto upperBound = Index(size * SCALE_FACTOR) + ADD_FACTOR;
      char* copy = allocatedCopy = (char*)malloc(upperBound);
      char* end = copy + upperBound;
      char* out = copy;
      std::string DEBUGINFO_INTRINSIC = EMSCRIPTEN_DEBUGINFO.str;
      auto DEBUGINFO_INTRINSIC_SIZE = DEBUGINFO_INTRINSIC.size();
      const char* UNKNOWN_FILE = "(unknown)";
      bool seenUseAsm = false;
      while (input[0]) {
        if (out + ADD_FACTOR >= end) {
          Fatal() << "error in handling debug info";
        }
        if (startsWith(input, "//@line")) {
          char* linePos = input + 8;
          char* lineEnd = strpbrk(input + 8, " \n");
          if (!lineEnd) {
            // comment goes to end of input
            break;
          }
          input = lineEnd + 1;
          std::string file;
          if (*lineEnd == ' ') {
            // we have a file
            char* filePos = strpbrk(input, "\"\n");
            if (!filePos) {
              // goes to end of input
              break;
            }
            if (*filePos == '"') {
              char* fileEnd = strpbrk(filePos + 1, "\"\n");
              input = fileEnd + 1;
              *fileEnd = 0;
              file = filePos + 1;
            } else {
              file = UNKNOWN_FILE;
              input = filePos + 1;
            }
          } else {
            // no file, we found \n
            file = UNKNOWN_FILE;
          }
          *lineEnd = 0;
          std::string line = linePos;
          auto iter = debugInfoFileIndices.find(file);
          if (iter == debugInfoFileIndices.end()) {
            Index index = debugInfoFileNames.size();
            debugInfoFileNames.push_back(file);
            debugInfoFileIndices[file] = index;
          }
          std::string fileIndex = std::to_string(debugInfoFileIndices[file]);
          // write out the intrinsic
          strcpy(out, DEBUGINFO_INTRINSIC.c_str());
          out += DEBUGINFO_INTRINSIC_SIZE;
          *out++ = '(';
          strcpy(out, fileIndex.c_str());
          out += fileIndex.size();
          *out++ = ',';
          strcpy(out, line.c_str());
          out += line.size();
          *out++ = ')';
          *out++ = ';';
        } else if (!seenUseAsm && (startsWith(input, "asm'") || startsWith(input, "asm\""))) {
          // end of  "use asm"  or  "almost asm"
          const auto SKIP = 5; // skip the end of "use asm"; (5 chars, a,s,m," or ',;)
          seenUseAsm = true;
          memcpy(out, input, SKIP);
          out += SKIP;
          input += SKIP;
          // add a fake import for the intrinsic, so the module validates
          std::string import = "\n var emscripten_debuginfo = env.emscripten_debuginfo;";
          strcpy(out, import.c_str());
          out += import.size();
        } else {
          *out++ = *input++;
        }
      }
      if (out >= end) {
        Fatal() << "error in handling debug info";
      }
      *out = 0;
      input = copy;
    }

    return input;
  }
};

static Call* checkDebugInfo(Expression* curr) {
  if (auto* call = curr->dynCast<Call>()) {
    if (call->target == EMSCRIPTEN_DEBUGINFO) {
      return call;
    }
  }
  return nullptr;
}

// Debug info appears in the ast as calls to the debug intrinsic. These are usually
// after the relevant node. We adjust them to a position that is not dce-able, so that
// they are not trivially removed when optimizing.
struct AdjustDebugInfo : public WalkerPass<PostWalker<AdjustDebugInfo, Visitor<AdjustDebugInfo>>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new AdjustDebugInfo(); }

  AdjustDebugInfo() {
    name = "adjust-debug-info";
  }

  void visitBlock(Block* curr) {
    // look for a debug info call that is unreachable
    if (curr->list.size() == 0) return;
    auto* back = curr->list.back();
    for (Index i = 1; i < curr->list.size(); i++) {
      if (checkDebugInfo(curr->list[i]) && !checkDebugInfo(curr->list[i - 1])) {
        // swap them
        std::swap(curr->list[i - 1], curr->list[i]);
      }
    }
    if (curr->list.back() != back) {
      // we changed the last element, update the type
      curr->finalize();
    }
  }
};

//
// Asm2WasmBuilder - converts an asm.js module into WebAssembly
//

class Asm2WasmBuilder {
public:
  Module& wasm;

  MixedArena &allocator;

  Builder builder;

  std::unique_ptr<OptimizingIncrementalModuleBuilder> optimizingBuilder;

  // globals

  struct MappedGlobal {
    Type type;
    bool import; // if true, this is an import - we should read the value, not just set a zero
    IString module, base;
    MappedGlobal() : type(none), import(false) {}
    MappedGlobal(Type type) : type(type), import(false) {}
    MappedGlobal(Type type, bool import, IString module, IString base) : type(type), import(import), module(module), base(base) {}
  };

  // function table
  std::map<IString, int> functionTableStarts; // each asm function table gets a range in the one wasm table, starting at a location

  Asm2WasmPreProcessor& preprocessor;
  bool debug;
  TrapMode trapMode;
  TrappingFunctionContainer trappingFunctions;
  PassOptions passOptions;
  bool legalizeJavaScriptFFI;
  bool runOptimizationPasses;
  bool wasmOnly;

public:
  std::map<IString, MappedGlobal> mappedGlobals;

private:
  void allocateGlobal(IString name, Type type) {
    assert(mappedGlobals.find(name) == mappedGlobals.end());
    mappedGlobals.emplace(name, MappedGlobal(type));
    wasm.addGlobal(builder.makeGlobal(
      name,
      type,
      LiteralUtils::makeZero(type, wasm),
      Builder::Mutable
    ));
  }

  struct View {
    unsigned bytes;
    bool integer, signed_;
    AsmType type;
    View() : bytes(0) {}
    View(unsigned bytes, bool integer, bool signed_, AsmType type) : bytes(bytes), integer(integer), signed_(signed_), type(type) {}
  };

  std::map<IString, View> views; // name (e.g. HEAP8) => view info

  // Imported names of Math.*
  IString Math_imul;
  IString Math_clz32;
  IString Math_fround;
  IString Math_abs;
  IString Math_floor;
  IString Math_ceil;
  IString Math_sqrt;
  IString Math_max;
  IString Math_min;

  // Imported names of Atomics.*
  IString Atomics_load;
  IString Atomics_store;
  IString Atomics_exchange;
  IString Atomics_compareExchange;
  IString Atomics_add;
  IString Atomics_sub;
  IString Atomics_and;
  IString Atomics_or;
  IString Atomics_xor;

  IString llvm_cttz_i32;

  IString tempDoublePtr; // imported name of tempDoublePtr

  // possibly-minified names, detected via their exports
  IString udivmoddi4;
  IString getTempRet0;

  // function types. we fill in this information as we see
  // uses, in the first pass

  std::map<IString, std::unique_ptr<FunctionType>> importedFunctionTypes;

  void noteImportedFunctionCall(Ref ast, Type resultType, Call* call) {
    assert(ast[0] == CALL && ast[1]->isString());
    IString importName = ast[1]->getIString();
    auto type = make_unique<FunctionType>();
    type->name = IString((std::string("type$") + importName.str).c_str(), false); // TODO: make a list of such types
    type->result = resultType;
    for (auto* operand : call->operands) {
      type->params.push_back(operand->type);
    }
    // if we already saw this signature, verify it's the same (or else handle that)
    if (importedFunctionTypes.find(importName) != importedFunctionTypes.end()) {
      FunctionType* previous = importedFunctionTypes[importName].get();
      if (*type != *previous) {
        // merge it in. we'll add on extra 0 parameters for ones not actually used, and upgrade types to
        // double where there is a conflict (which is ok since in JS, double can contain everything
        // i32 and f32 can).
        for (size_t i = 0; i < type->params.size(); i++) {
          if (previous->params.size() > i) {
            if (previous->params[i] == none) {
              previous->params[i] = type->params[i]; // use a more concrete type
            } else if (previous->params[i] != type->params[i]) {
              previous->params[i] = f64; // overloaded type, make it a double
            }
          } else {
            previous->params.push_back(type->params[i]); // add a new param
          }
        }
        // we accept none and a concrete type, but two concrete types mean we need to use an f64 to contain anything
        if (previous->result == none) {
          previous->result = type->result; // use a more concrete type
        } else if (previous->result != type->result && type->result != none) {
          previous->result = f64; // overloaded return type, make it a double
        }
      }
    } else {
      importedFunctionTypes[importName].swap(type);
    }
  }

  Type getResultTypeOfCallUsingParent(Ref parent, AsmData* data) {
    auto result = none;
    if (!!parent) {
      // if the parent is a seq, we cannot be the last element in it (we would have a coercion, which would be
      // the parent), so we must be (us, somethingElse), and so our return is void
      if (parent[0] != SEQ) {
        result = detectWasmType(parent, data);
      }
    }
    return result;
  }

  FunctionType* getFunctionType(Ref parent, ExpressionList& operands, AsmData* data) {
    Type result = getResultTypeOfCallUsingParent(parent, data);
    return ensureFunctionType(getSig(result, operands), &wasm);
  }

public:
 Asm2WasmBuilder(Module& wasm, Asm2WasmPreProcessor& preprocessor, bool debug, TrapMode trapMode, PassOptions passOptions, bool legalizeJavaScriptFFI, bool runOptimizationPasses, bool wasmOnly)
     : wasm(wasm),
       allocator(wasm.allocator),
       builder(wasm),
       preprocessor(preprocessor),
       debug(debug),
       trapMode(trapMode),
       trappingFunctions(trapMode, wasm, /* immediate = */ true),
       passOptions(passOptions),
       legalizeJavaScriptFFI(legalizeJavaScriptFFI),
       runOptimizationPasses(runOptimizationPasses),
       wasmOnly(wasmOnly) {}

 void processAsm(Ref ast);

private:
  AsmType detectAsmType(Ref ast, AsmData *data) {
    if (ast->isString()) {
      IString name = ast->getIString();
      if (!data->isLocal(name)) {
        // must be global
        assert(mappedGlobals.find(name) != mappedGlobals.end());
        return wasmToAsmType(mappedGlobals[name].type);
      }
    } else if (ast->isArray(SUB) && ast[1]->isString()) {
      // could be a heap access, use view info
      auto view = views.find(ast[1]->getIString());
      if (view != views.end()) {
        return view->second.type;
      }
    }
    return detectType(ast, data, false, Math_fround, wasmOnly);
  }

  Type detectWasmType(Ref ast, AsmData *data) {
    return asmToWasmType(detectAsmType(ast, data));
  }

  bool isUnsignedCoercion(Ref ast) {
    return detectSign(ast, Math_fround) == ASM_UNSIGNED;
  }

  bool isParentUnsignedCoercion(Ref parent) {
    // parent may not exist, or may be a non-relevant node
    if (!!parent && parent->isArray() && parent[0] == BINARY && isUnsignedCoercion(parent)) {
      return true;
    }
    return false;
  }

  BinaryOp parseAsmBinaryOp(IString op, Ref left, Ref right, Expression* leftWasm, Expression* rightWasm) {
    Type leftType = leftWasm->type;
    bool isInteger = leftType == Type::i32;

    if (op == PLUS) return isInteger ? BinaryOp::AddInt32 : (leftType == f32 ? BinaryOp::AddFloat32 : BinaryOp::AddFloat64);
    if (op == MINUS) return isInteger ? BinaryOp::SubInt32 : (leftType == f32 ? BinaryOp::SubFloat32 : BinaryOp::SubFloat64);
    if (op == MUL) return isInteger ? BinaryOp::MulInt32 : (leftType == f32 ? BinaryOp::MulFloat32 : BinaryOp::MulFloat64);
    if (op == AND) return BinaryOp::AndInt32;
    if (op == OR) return BinaryOp::OrInt32;
    if (op == XOR) return BinaryOp::XorInt32;
    if (op == LSHIFT) return BinaryOp::ShlInt32;
    if (op == RSHIFT) return BinaryOp::ShrSInt32;
    if (op == TRSHIFT) return BinaryOp::ShrUInt32;
    if (op == EQ) return isInteger ? BinaryOp::EqInt32 : (leftType == f32 ? BinaryOp::EqFloat32 : BinaryOp::EqFloat64);
    if (op == NE) return isInteger ? BinaryOp::NeInt32 : (leftType == f32 ? BinaryOp::NeFloat32 : BinaryOp::NeFloat64);

    bool isUnsigned = isUnsignedCoercion(left) || isUnsignedCoercion(right);

    if (op == DIV) {
      if (isInteger) {
        return isUnsigned ? BinaryOp::DivUInt32 : BinaryOp::DivSInt32;
      }
      return leftType == f32 ? BinaryOp::DivFloat32 : BinaryOp::DivFloat64;
    }
    if (op == MOD) {
      if (isInteger) {
        return isUnsigned ? BinaryOp::RemUInt32 : BinaryOp::RemSInt32;
      }
      return BinaryOp::RemSInt32; // XXX no floating-point remainder op, this must be handled by the caller
    }
    if (op == GE) {
      if (isInteger) {
        return isUnsigned ? BinaryOp::GeUInt32 : BinaryOp::GeSInt32;
      }
      return leftType == f32 ? BinaryOp::GeFloat32 : BinaryOp::GeFloat64;
    }
    if (op == GT) {
      if (isInteger) {
        return isUnsigned ? BinaryOp::GtUInt32 : BinaryOp::GtSInt32;
      }
      return leftType == f32 ? BinaryOp::GtFloat32 : BinaryOp::GtFloat64;
    }
    if (op == LE) {
      if (isInteger) {
        return isUnsigned ? BinaryOp::LeUInt32 : BinaryOp::LeSInt32;
      }
      return leftType == f32 ? BinaryOp::LeFloat32 : BinaryOp::LeFloat64;
    }
    if (op == LT) {
      if (isInteger) {
        return isUnsigned ? BinaryOp::LtUInt32 : BinaryOp::LtSInt32;
      }
      return leftType == f32 ? BinaryOp::LtFloat32 : BinaryOp::LtFloat64;
    }
    abort_on("bad wasm binary op", op);
    abort(); // avoid warning
  }

  int32_t bytesToShift(unsigned bytes) {
    switch (bytes) {
      case 1: return 0;
      case 2: return 1;
      case 4: return 2;
      case 8: return 3;
      default: {}
    }
    abort();
    return -1; // avoid warning
  }

  std::map<unsigned, Ref> tempNums;

  Literal checkLiteral(Ref ast, bool rawIsInteger = true) {
    if (ast->isNumber()) {
      if (rawIsInteger) {
        return Literal((int32_t)ast->getInteger());
      } else {
        return Literal(ast->getNumber());
      }
    } else if (ast->isArray(UNARY_PREFIX)) {
      if (ast[1] == PLUS && ast[2]->isNumber()) {
        return Literal((double)ast[2]->getNumber());
      }
      if (ast[1] == MINUS && ast[2]->isNumber()) {
        double num = -ast[2]->getNumber();
        if (isSInteger32(num)) return Literal((int32_t)num);
        if (isUInteger32(num)) return Literal((uint32_t)num);
        assert(false && "expected signed or unsigned int32");
      }
      if (ast[1] == PLUS && ast[2]->isArray(UNARY_PREFIX) && ast[2][1] == MINUS && ast[2][2]->isNumber()) {
        return Literal((double)-ast[2][2]->getNumber());
      }
      if (ast[1] == MINUS && ast[2]->isArray(UNARY_PREFIX) && ast[2][1] == PLUS && ast[2][2]->isNumber()) {
        return Literal((double)-ast[2][2]->getNumber());
      }
    } else if (wasmOnly && ast->isArray(CALL) && ast[1]->isString() && ast[1] == I64_CONST) {
      uint64_t low = ast[2][0]->getNumber();
      uint64_t high = ast[2][1]->getNumber();
      return Literal(uint64_t(low + (high << 32)));
    }
    return Literal();
  }

  Literal getLiteral(Ref ast) {
    Literal ret = checkLiteral(ast);
    assert(ret.type != none);
    return ret;
  }

  void fixCallType(Expression* call, Type type) {
    if (call->is<Call>()) call->cast<Call>()->type = type;
    else if (call->is<CallIndirect>()) call->cast<CallIndirect>()->type = type;
  }

  FunctionType* getBuiltinFunctionType(Name module, Name base, ExpressionList* operands = nullptr) {
    if (module == GLOBAL_MATH) {
      if (base == ABS) {
        assert(operands && operands->size() == 1);
        Type type = (*operands)[0]->type;
        if (type == i32) return ensureFunctionType("ii", &wasm);
        if (type == f32) return ensureFunctionType("ff", &wasm);
        if (type == f64) return ensureFunctionType("dd", &wasm);
      }
    }
    return nullptr;
  }

  // ensure a nameless block
  Block* blockify(Expression* expression) {
    if (expression->is<Block>() && !expression->cast<Block>()->name.is()) return expression->dynCast<Block>();
    auto ret = allocator.alloc<Block>();
    ret->list.push_back(expression);
    ret->finalize();
    return ret;
  }

  Expression* ensureDouble(Expression* expr) {
    return wasm::ensureDouble(expr, allocator);
  }

  Expression* truncateToInt32(Expression* value) {
    if (value->type == i64) return builder.makeUnary(UnaryOp::WrapInt64, value);
    // either i32, or a call_import whose type we don't know yet (but would be legalized to i32 anyhow)
    return value;
  }

  Function* processFunction(Ref ast);
};

void Asm2WasmBuilder::processAsm(Ref ast) {
  assert(ast[0] == TOPLEVEL);
  if (ast[1]->size() == 0) {
    Fatal() << "empty input";
  }
  Ref asmFunction = ast[1][0];
  assert(asmFunction[0] == DEFUN);
  Ref body = asmFunction[3];
  assert(body[0][0] == STRING && (body[0][1]->getIString() == IString("use asm") || body[0][1]->getIString() == IString("almost asm")));

  // extra functions that we add, that are not from the compiled code. we need
  // to make sure to optimize them normally (OptimizingIncrementalModuleBuilder
  // does that on the fly for compiled code)
  std::vector<Function*> extraSupportFunctions;

  // first, add the memory elements. we do this before the main compile+optimize
  // since the optimizer should see the memory

  // apply memory growth, if relevant
  if (preprocessor.memoryGrowth) {
    EmscriptenGlueGenerator generator(wasm);
    auto* func = generator.generateMemoryGrowthFunction();
    extraSupportFunctions.push_back(func);
    wasm.memory.max = Memory::kUnlimitedSize;
  }

  // import memory
  wasm.memory.name = MEMORY;
  wasm.memory.module = ENV;
  wasm.memory.base = MEMORY;
  wasm.memory.exists = true;

  // import table
  wasm.table.name = TABLE;
  wasm.table.module = ENV;
  wasm.table.base = TABLE;
  wasm.table.exists = true;

  // Import memory offset, if not already there
  {
    auto* import = new Global;
    import->name = MEMORY_BASE;
    import->module = "env";
    import->base = MEMORY_BASE;
    import->type = i32;
    wasm.addGlobal(import);
  }

  // Import table offset, if not already there
  {
    auto* import = new Global;
    import->name = TABLE_BASE;
    import->module = "env";
    import->base = TABLE_BASE;
    import->type = i32;
    wasm.addGlobal(import);
  }

  auto addImport = [&](IString name, Ref imported, Type type) {
    assert(imported[0] == DOT);
    Ref module = imported[1];
    IString moduleName;
    if (module->isArray(DOT)) {
      // we can have (global.Math).floor; skip the 'Math'
      assert(module[1]->isString());
      if (module[2] == MATH) {
        if (imported[2] == IMUL) {
          assert(Math_imul.isNull());
          Math_imul = name;
          return;
        } else if (imported[2] == CLZ32) {
          assert(Math_clz32.isNull());
          Math_clz32 = name;
          return;
        } else if (imported[2] == FROUND) {
          assert(Math_fround.isNull());
          Math_fround = name;
          return;
        } else if (imported[2] == ABS) {
          assert(Math_abs.isNull());
          Math_abs = name;
          return;
        } else if (imported[2] == FLOOR) {
          assert(Math_floor.isNull());
          Math_floor = name;
          return;
        } else if (imported[2] == CEIL) {
          assert(Math_ceil.isNull());
          Math_ceil = name;
          return;
        } else if (imported[2] == SQRT) {
          assert(Math_sqrt.isNull());
          Math_sqrt = name;
          return;
        } else if (imported[2] == MAX_) {
          assert(Math_max.isNull());
          Math_max = name;
          return;
        } else if (imported[2] == MIN_) {
          assert(Math_min.isNull());
          Math_min = name;
          return;
        }
      } else if (module[2] == ATOMICS) {
        if (imported[2] == ATOMICS_LOAD) {
          assert(Atomics_load.isNull());
          Atomics_load = name;
          return;
        } else if (imported[2] == ATOMICS_STORE) {
          assert(Atomics_store.isNull());
          Atomics_store = name;
          return;
        } else if (imported[2] == ATOMICS_EXCHANGE) {
          assert(Atomics_exchange.isNull());
          Atomics_exchange = name;
          return;
        } else if (imported[2] == ATOMICS_COMPARE_EXCHANGE) {
          assert(Atomics_compareExchange.isNull());
          Atomics_compareExchange = name;
          return;
        } else if (imported[2] == ATOMICS_ADD) {
          assert(Atomics_add.isNull());
          Atomics_add = name;
          return;
        } else if (imported[2] == ATOMICS_SUB) {
          assert(Atomics_sub.isNull());
          Atomics_sub = name;
          return;
        } else if (imported[2] == ATOMICS_AND) {
          assert(Atomics_and.isNull());
          Atomics_and = name;
          return;
        } else if (imported[2] == ATOMICS_OR) {
          assert(Atomics_or.isNull());
          Atomics_or = name;
          return;
        } else if (imported[2] == ATOMICS_XOR) {
          assert(Atomics_xor.isNull());
          Atomics_xor = name;
          return;
        }
      }
      std::string fullName = module[1]->getCString();
      fullName += '.';
      fullName += + module[2]->getCString();
      moduleName = IString(fullName.c_str(), false);
    } else {
      assert(module->isString());
      moduleName = module->getIString();
      if (moduleName == ENV) {
        auto base = imported[2]->getIString();
        if (base == TEMP_DOUBLE_PTR) {
          assert(tempDoublePtr.isNull());
          tempDoublePtr = name;
          // we don't return here, as we can only optimize out some uses of tDP. So it remains imported
        } else if (base == LLVM_CTTZ_I32) {
          assert(llvm_cttz_i32.isNull());
          llvm_cttz_i32 = name;
          return;
        }
      }
    }
    auto base = imported[2]->getIString();
    // special-case some asm builtins
    if (module == GLOBAL && (base == NAN_ || base == INFINITY_)) {
      type = Type::f64;
    }
    if (type != Type::none) {
      // this is a global
      auto* import = new Global;
      import->name = name;
      import->module = moduleName;
      import->base = base;
      import->type = type;
      mappedGlobals.emplace(name, type);
      // __table_base and __memory_base are used as segment/element offsets, and must be constant;
      // otherwise, an asm.js import of a constant is mutable, e.g. STACKTOP
      if (name != TABLE_BASE && name != MEMORY_BASE) {
        // we need imported globals to be mutable, but wasm doesn't support that yet, so we must
        // import an immutable and create a mutable global initialized to its value
        import->name = Name(std::string(import->name.str) + "$asm2wasm$import");
        {
          wasm.addGlobal(builder.makeGlobal(
            name,
            type,
            builder.makeGetGlobal(import->name, type),
            Builder::Mutable
          ));
        }
      }
      if ((name == TABLE_BASE || name == MEMORY_BASE) &&
          wasm.getGlobalOrNull(import->base)) {
        return;
      }
      wasm.addGlobal(import);
    } else {
      // this is a function
      auto* import = new Function;
      import->name = name;
      import->module = moduleName;
      import->base = base;
      wasm.addFunction(import);
    }
  };

  IString Int8Array, Int16Array, Int32Array, UInt8Array, UInt16Array, UInt32Array, Float32Array, Float64Array;

  // set up optimization

  if (runOptimizationPasses) {
    Index numFunctions = 0;
    for (unsigned i = 1; i < body->size(); i++) {
      if (body[i][0] == DEFUN) numFunctions++;
    }
    optimizingBuilder = make_unique<OptimizingIncrementalModuleBuilder>(&wasm, numFunctions, passOptions, [&](PassRunner& passRunner) {
      // addPrePasses
      if (debug) {
        passRunner.setDebug(true);
        passRunner.setValidateGlobally(false);
      }
      // run autodrop first, before optimizations
      passRunner.add<AutoDrop>();
      if (preprocessor.debugInfo) {
        // fix up debug info to better survive optimization
        passRunner.add<AdjustDebugInfo>();
      }
      // optimize relooper label variable usage at the wasm level, where it is easy
      passRunner.add("relooper-jump-threading");
    }, debug, false /* do not validate globally yet */);
  }

  // if we see no function tables in the processing below, then the table still exists and has size 0

  wasm.table.initial = wasm.table.max = 0;

  // first pass - do all global things, aside from function bodies (second pass)
  // and function imports and indirect calls (last pass)

  for (unsigned i = 1; i < body->size(); i++) {
    Ref curr = body[i];
    if (curr[0] == VAR) {
      // import, global, or table
      for (unsigned j = 0; j < curr[1]->size(); j++) {
        Ref pair = curr[1][j];
        IString name = pair[0]->getIString();
        Ref value = pair[1];
        if (value->isNumber()) {
          // global int
          assert(value->getNumber() == 0);
          allocateGlobal(name, Type::i32);
        } else if (value[0] == BINARY) {
          // int import
          assert(value[1] == OR && value[3]->isNumber() && value[3]->getNumber() == 0);
          Ref import = value[2]; // env.what
          addImport(name, import, Type::i32);
        } else if (value[0] == UNARY_PREFIX) {
          // double import or global
          assert(value[1] == PLUS);
          Ref import = value[2];
          if (import->isNumber()) {
            // global
            assert(import->getNumber() == 0);
            allocateGlobal(name, Type::f64);
          } else {
            // import
            addImport(name, import, Type::f64);
          }
        } else if (value[0] == CALL) {
          assert(value[1]->isString() && value[1] == Math_fround && value[2][0]->isNumber() && value[2][0]->getNumber() == 0);
          allocateGlobal(name, Type::f32);
        } else if (value[0] == DOT) {
          // simple module.base import. can be a view, or a function.
          if (value[1]->isString()) {
            IString module = value[1]->getIString();
            IString base = value[2]->getIString();
            if (module == GLOBAL) {
              if (base == INT8ARRAY) {
                Int8Array = name;
              } else if (base == INT16ARRAY) {
                Int16Array = name;
              } else if (base == INT32ARRAY) {
                Int32Array = name;
              } else if (base == UINT8ARRAY) {
                UInt8Array = name;
              } else if (base == UINT16ARRAY) {
                UInt16Array = name;
              } else if (base == UINT32ARRAY) {
                UInt32Array = name;
              } else if (base == FLOAT32ARRAY) {
                Float32Array = name;
              } else if (base == FLOAT64ARRAY) {
                Float64Array = name;
              }
            }
          }
          // function import
          addImport(name, value, Type::none);
        } else if (value[0] == NEW) {
          // ignore imports of typed arrays, but note the names of the arrays
          value = value[1];
          assert(value[0] == CALL);
          unsigned bytes;
          bool integer, signed_;
          AsmType asmType;
          Ref constructor = value[1];
          if (constructor->isArray(DOT)) { // global.*Array
            IString heap = constructor[2]->getIString();
            if (heap == INT8ARRAY) {
              bytes = 1; integer = true; signed_ = true; asmType = ASM_INT;
            } else if (heap == INT16ARRAY) {
              bytes = 2; integer = true; signed_ = true; asmType = ASM_INT;
            } else if (heap == INT32ARRAY) {
              bytes = 4; integer = true; signed_ = true; asmType = ASM_INT;
            } else if (heap == UINT8ARRAY) {
              bytes = 1; integer = true; signed_ = false; asmType = ASM_INT;
            } else if (heap == UINT16ARRAY) {
              bytes = 2; integer = true; signed_ = false; asmType = ASM_INT;
            } else if (heap == UINT32ARRAY) {
              bytes = 4; integer = true; signed_ = false; asmType = ASM_INT;
            } else if (heap == FLOAT32ARRAY) {
              bytes = 4; integer = false; signed_ = true; asmType = ASM_FLOAT;
            } else if (heap == FLOAT64ARRAY) {
              bytes = 8; integer = false; signed_ = true; asmType = ASM_DOUBLE;
            } else {
              abort_on("invalid view import", heap);
            }
          } else { // *ArrayView that was previously imported
            assert(constructor->isString());
            IString viewName = constructor->getIString();
            if (viewName == Int8Array) {
              bytes = 1; integer = true; signed_ = true; asmType = ASM_INT;
            } else if (viewName == Int16Array) {
              bytes = 2; integer = true; signed_ = true; asmType = ASM_INT;
            } else if (viewName == Int32Array) {
              bytes = 4; integer = true; signed_ = true; asmType = ASM_INT;
            } else if (viewName == UInt8Array) {
              bytes = 1; integer = true; signed_ = false; asmType = ASM_INT;
            } else if (viewName == UInt16Array) {
              bytes = 2; integer = true; signed_ = false; asmType = ASM_INT;
            } else if (viewName == UInt32Array) {
              bytes = 4; integer = true; signed_ = false; asmType = ASM_INT;
            } else if (viewName == Float32Array) {
              bytes = 4; integer = false; signed_ = true; asmType = ASM_FLOAT;
            } else if (viewName == Float64Array) {
              bytes = 8; integer = false; signed_ = true; asmType = ASM_DOUBLE;
            } else {
              abort_on("invalid short view import", viewName);
            }
          }
          assert(views.find(name) == views.end());
          views.emplace(name, View(bytes, integer, signed_, asmType));
        } else if (value[0] == ARRAY) {
          // function table. we merge them into one big table, so e.g.   [foo, b1] , [b2, bar]  =>  [foo, b1, b2, bar]
          // TODO: when not using aliasing function pointers, we could merge them by noticing that
          //       index 0 in each table is the null func, and each other index should only have one
          //       non-null func. However, that breaks down when function pointer casts are emulated.
          if (wasm.table.segments.size() == 0) {
            wasm.table.segments.emplace_back(builder.makeGetGlobal(Name(TABLE_BASE), i32));
          }
          auto& segment = wasm.table.segments[0];
          functionTableStarts[name] = segment.data.size(); // this table starts here
          Ref contents = value[1];
          for (unsigned k = 0; k < contents->size(); k++) {
            IString curr = contents[k]->getIString();
            segment.data.push_back(curr);
          }
          wasm.table.initial = wasm.table.max = segment.data.size();
        } else {
          abort_on("invalid var element", pair);
        }
      }
    } else if (curr[0] == RETURN) {
      // exports
      Ref object = curr[1];
      Ref contents = object[1];
      std::map<Name, Export*> exported;
      for (unsigned k = 0; k < contents->size(); k++) {
        Ref pair = contents[k];
        IString key = pair[0]->getIString();
        if (pair[1]->isString()) {
          // exporting a function
          IString value = pair[1]->getIString();
          if (key == Name("_emscripten_replace_memory")) {
            // asm.js memory growth provides this special non-asm function, which we don't need (we use grow_memory)
            assert(!wasm.getFunctionOrNull(value));
            continue;
          } else if (key == UDIVMODDI4) {
            udivmoddi4 = value;
          } else if (key == GET_TEMP_RET0) {
            getTempRet0 = value;
          }
          if (exported.count(key) > 0) {
            // asm.js allows duplicate exports, but not wasm. use the last, like asm.js
            exported[key]->value = value;
          } else {
            auto* export_ = new Export;
            export_->name = key;
            export_->value = value;
            export_->kind = ExternalKind::Function;
            wasm.addExport(export_);
            exported[key] = export_;
          }
        } else {
          // export a number. create a global and export it
          assert(pair[1]->isNumber());
          assert(exported.count(key) == 0);
          auto value = pair[1]->getInteger();
          auto* global = builder.makeGlobal(
            key,
            i32,
            builder.makeConst(Literal(int32_t(value))),
            Builder::Immutable
          );
          wasm.addGlobal(global);
          auto* export_ = new Export;
          export_->name = key;
          export_->value = global->name;
          export_->kind = ExternalKind::Global;
          wasm.addExport(export_);
          exported[key] = export_;
        }
      }
    }
  }

  // second pass: function bodies
  for (unsigned i = 1; i < body->size(); i++) {
    Ref curr = body[i];
    if (curr[0] == DEFUN) {
      // function
      auto* func = processFunction(curr);
      if (wasm.getFunctionOrNull(func->name)) {
        Fatal() << "duplicate function: " << func->name;
      }
      if (runOptimizationPasses) {
        optimizingBuilder->addFunction(func);
      } else {
        wasm.addFunction(func);
      }
    }
  }

  if (runOptimizationPasses) {
    optimizingBuilder->finish();
    // if we added any helper functions (like non-trapping i32-div, etc.), then those
    // have not been optimized (the optimizing builder has just been fed the asm.js
    // functions). Optimize those now. Typically there are very few, just do it
    // sequentially.
    PassRunner passRunner(&wasm, passOptions);
    passRunner.addDefaultFunctionOptimizationPasses();
    for (auto& pair : trappingFunctions.getFunctions()) {
      auto* func = pair.second;
      passRunner.runOnFunction(func);
    }
    for (auto* func : extraSupportFunctions) {
      passRunner.runOnFunction(func);
    }
  }
  wasm.debugInfoFileNames = std::move(preprocessor.debugInfoFileNames);

  // third pass. first, function imports

  std::vector<IString> toErase;

  ModuleUtils::iterImportedFunctions(wasm, [&](Function* import) {
    IString name = import->name;
    if (importedFunctionTypes.find(name) != importedFunctionTypes.end()) {
      // special math builtins
      FunctionType* builtin = getBuiltinFunctionType(import->module, import->base);
      if (builtin) {
        import->type = builtin->name;
      } else {
        import->type = ensureFunctionType(getSig(importedFunctionTypes[name].get()), &wasm)->name;
      }
    } else if (import->module != ASM2WASM) { // special-case the special module
      // never actually used, which means we don't know the function type since the usage tells us, so illegal for it to remain
      toErase.push_back(name);
    }
  });

  for (auto curr : toErase) {
    wasm.removeFunction(curr);
  }

  // Finalize function imports now that we've seen all the calls

  ModuleUtils::iterImportedFunctions(wasm, [&](Function* func) {
    FunctionTypeUtils::fillFunction(func, wasm.getFunctionType(func->type));
  });

  // Finalize calls now that everything is known and generated

  struct FinalizeCalls : public WalkerPass<PostWalker<FinalizeCalls>> {
    bool isFunctionParallel() override { return true; }

    Pass* create() override { return new FinalizeCalls(parent); }

    Asm2WasmBuilder* parent;

    FinalizeCalls(Asm2WasmBuilder* parent) : parent(parent) {
      name = "finalize-calls";
    }

    void notifyAboutWrongOperands(std::string why, Function* calledFunc) {
      // use a mutex as this may be shown from multiple threads
      static std::mutex mutex;
      std::unique_lock<std::mutex> lock(mutex);
      static const int MAX_SHOWN = 20;
      static std::unique_ptr<std::atomic<int>> numShown;
      if (!numShown) {
        numShown = make_unique<std::atomic<int>>();
        numShown->store(0);
      }
      if (numShown->load() >= MAX_SHOWN) return;
      std::cerr << why << " in call from " << getFunction()->name << " to " << calledFunc->name << " (this is likely due to undefined behavior in C, like defining a function one way and calling it in another, which is important to fix)\n";
      (*numShown)++;
      if (numShown->load() >= MAX_SHOWN) {
        std::cerr << "(" << numShown->load() << " such warnings shown; not showing any more)\n";
      }
    }

    void visitCall(Call* curr) {
      // The call target may not exist if it is one of our special fake imports for callIndirect fixups
      auto* calledFunc = getModule()->getFunctionOrNull(curr->target);
      if (calledFunc && !calledFunc->imported()) {
        // The result type of the function being called is now known, and can be applied.
        auto result = calledFunc->result;
        if (curr->type != result) {
          curr->type = result;
        }
        // Handle mismatched numbers of arguments. In clang, if a function is declared one way
        // but called in another, it inserts bitcasts to make things work. Those end up
        // working since it is "ok" to drop or add parameters in native platforms, even
        // though it's undefined behavior. We warn about it here, but tolerate it, if there is
        // a simple solution.
        if (curr->operands.size() < calledFunc->params.size()) {
          notifyAboutWrongOperands("warning: asm2wasm adding operands", calledFunc);
          while (curr->operands.size() < calledFunc->params.size()) {
            // Add params as necessary, with zeros.
            curr->operands.push_back(
              LiteralUtils::makeZero(calledFunc->params[curr->operands.size()], *getModule())
            );
          }
        }
        if (curr->operands.size() > calledFunc->params.size()) {
          notifyAboutWrongOperands("warning: asm2wasm dropping operands", calledFunc);
          curr->operands.resize(calledFunc->params.size());
        }
        // If the types are wrong, validation will fail later anyhow, but add a warning here,
        // it may help people.
        for (Index i = 0; i < curr->operands.size(); i++) {
          auto sent = curr->operands[i]->type;
          auto expected = calledFunc->params[i];
          if (sent != unreachable && sent != expected) {
            notifyAboutWrongOperands("error: asm2wasm seeing an invalid argument type at index " + std::to_string(i) + " (this will not validate)", calledFunc);
          }
        }
      } else {
        // A call to an import
        // fill things out: add extra params as needed, etc. asm tolerates ffi overloading, wasm does not
        auto iter = parent->importedFunctionTypes.find(curr->target);
        if (iter == parent->importedFunctionTypes.end()) return; // one of our fake imports for callIndirect fixups
        auto type = iter->second.get();
        for (size_t i = 0; i < type->params.size(); i++) {
          if (i >= curr->operands.size()) {
            // add a new param
            auto val = parent->allocator.alloc<Const>();
            val->type = val->value.type = type->params[i];
            curr->operands.push_back(val);
          } else if (curr->operands[i]->type != type->params[i]) {
            // if the param is used, then we have overloading here and the combined type must be f64;
            // if this is an unreachable param, then it doesn't matter.
            assert(type->params[i] == f64 || curr->operands[i]->type == unreachable);
            // overloaded, upgrade to f64
            switch (curr->operands[i]->type) {
              case i32: curr->operands[i] = parent->builder.makeUnary(ConvertSInt32ToFloat64, curr->operands[i]); break;
              case f32: curr->operands[i] = parent->builder.makeUnary(PromoteFloat32, curr->operands[i]); break;
              default: {} // f64, unreachable, etc., are all good
            }
          }
        }
        Module* wasm = getModule();
        auto importResult = wasm->getFunctionType(wasm->getFunction(curr->target)->type)->result;
        if (curr->type != importResult) {
          auto old = curr->type;
          curr->type = importResult;
          if (importResult == f64) {
            // we use a JS f64 value which is the most general, and convert to it
            switch (old) {
              case i32:  {
                Unary* trunc = parent->builder.makeUnary(TruncSFloat64ToInt32, curr);
                replaceCurrent(makeTrappingUnary(trunc, parent->trappingFunctions));
                break;
              }
              case f32: {
                replaceCurrent(parent->builder.makeUnary(DemoteFloat64, curr));
                break;
              }
              case none: {
                // this function returns a value, but we are not using it, so it must be dropped.
                // autodrop will do that for us.
                break;
              }
              default: WASM_UNREACHABLE();
            }
          } else {
            assert(old == none);
            // we don't want a return value here, but the import does provide one
            // autodrop will do that for us.
          }
        }
      }
    }

    void visitCallIndirect(CallIndirect* curr) {
      // we already call into target = something + offset, where offset is a callImport with the name of the table. replace that with the table offset
      // note that for an ftCall or mftCall, we have no asm.js mask, so have nothing to do here
      auto* target = curr->target;
      // might be a block with a fallthrough
      if (auto* block = target->dynCast<Block>()) {
        target = block->list.back();
      }
      // the something might have been optimized out, leaving only the call
      if (auto* call = target->dynCast<Call>()) {
        auto tableName = call->target;
        if (parent->functionTableStarts.find(tableName) == parent->functionTableStarts.end()) return;
        curr->target = parent->builder.makeConst(Literal((int32_t)parent->functionTableStarts[tableName]));
        return;
      }
      auto* add = target->dynCast<Binary>();
      if (!add) return;
      if (add->right->is<Call>()) {
        auto* offset = add->right->cast<Call>();
        auto tableName = offset->target;
        if (parent->functionTableStarts.find(tableName) == parent->functionTableStarts.end()) return;
        add->right = parent->builder.makeConst(Literal((int32_t)parent->functionTableStarts[tableName]));
      } else {
        auto* offset = add->left->dynCast<Call>();
        if (!offset) return;
        auto tableName = offset->target;
        if (parent->functionTableStarts.find(tableName) == parent->functionTableStarts.end()) return;
        add->left = parent->builder.makeConst(Literal((int32_t)parent->functionTableStarts[tableName]));
      }
    }

    void visitFunction(Function* curr) {
      // changing call types requires we percolate types, and drop stuff.
      // we do this in this pass so that we don't look broken between passes
      AutoDrop().walkFunctionInModule(curr, getModule());
    }
  };

  // apply debug info, reducing intrinsic calls into annotations on the ast nodes
  struct ApplyDebugInfo : public WalkerPass<ExpressionStackWalker<ApplyDebugInfo, UnifiedExpressionVisitor<ApplyDebugInfo>>> {
    bool isFunctionParallel() override { return true; }

    Pass* create() override { return new ApplyDebugInfo(); }

    ApplyDebugInfo() {
      name = "apply-debug-info";
    }

    Call* lastDebugInfo = nullptr;

    void visitExpression(Expression* curr) {
      if (auto* call = checkDebugInfo(curr)) {
        lastDebugInfo = call;
        replaceCurrent(getModule()->allocator.alloc<Nop>());
      } else {
        if (lastDebugInfo) {
          auto& debugLocations = getFunction()->debugLocations;
          uint32_t fileIndex = lastDebugInfo->operands[0]->cast<Const>()->value.geti32();
          assert(getModule()->debugInfoFileNames.size() > fileIndex);
          uint32_t lineNumber = lastDebugInfo->operands[1]->cast<Const>()->value.geti32();
          // look up the stack, apply to the root expression
          Index i = expressionStack.size() - 1;
          while (1) {
            auto* exp = expressionStack[i];
            bool parentIsStructure = i > 0 && (expressionStack[i - 1]->is<Block>() ||
                                               expressionStack[i - 1]->is<Loop>() ||
                                               expressionStack[i - 1]->is<If>());
            if (i == 0 || parentIsStructure || exp->type == none || exp->type == unreachable) {
              if (debugLocations.count(exp) > 0) {
                // already present, so look back up
                i++;
                while (i < expressionStack.size()) {
                  exp = expressionStack[i];
                  if (debugLocations.count(exp) == 0) {
                    debugLocations[exp] = { fileIndex, lineNumber, 0 };
                    break;
                  }
                  i++;
                }
              } else {
                debugLocations[exp] = { fileIndex, lineNumber, 0 };
              }
              break;
            }
            i--;
          }
          lastDebugInfo = nullptr;
        }
      }
    }
  };

  PassRunner passRunner(&wasm, passOptions);
  passRunner.setFeatures(passOptions.features);
  if (debug) {
    passRunner.setDebug(true);
    passRunner.setValidateGlobally(false);
  }
  // finalizeCalls also does autoDrop, which is crucial for the non-optimizing case,
  // so that the output of the first pass is valid
  passRunner.add<FinalizeCalls>(this);
  if (legalizeJavaScriptFFI) {
    passRunner.add("legalize-js-interface");
  }
  if (runOptimizationPasses) {
    // autodrop can add some garbage
    passRunner.add("vacuum");
    passRunner.add("remove-unused-brs");
    passRunner.add("remove-unused-names");
    passRunner.add("merge-blocks");
    passRunner.add("optimize-instructions");
    passRunner.add("post-emscripten");
  } else {
    if (preprocessor.debugInfo) {
      // we would have run this before if optimizing, do it now otherwise. must
      // precede ApplyDebugInfo
      passRunner.add<AdjustDebugInfo>();
    }
  }
  if (preprocessor.debugInfo) {
    passRunner.add<ApplyDebugInfo>();
    passRunner.add("vacuum"); // FIXME maybe just remove the nops that were debuginfo nodes, if not optimizing?
  }
  if (runOptimizationPasses) {
    // do final global optimizations after all function work is done
    // (e.g. duplicate funcs may appear thanks to that work)
    passRunner.addDefaultGlobalOptimizationPostPasses();
  }
  passRunner.run();

  // remove the debug info intrinsic
  if (preprocessor.debugInfo) {
    wasm.removeFunction(EMSCRIPTEN_DEBUGINFO);
  }

  if (udivmoddi4.is() && getTempRet0.is()) {
    // generate a wasm-optimized __udivmoddi4 method, which we can do much more efficiently in wasm
    // we can only do this if we know getTempRet0 as well since we use it to figure out which minified global is tempRet0
    // (getTempRet0 might be an import, if this is a shared module, so we can't optimize that case)
    Name tempRet0;
    {
      Expression* curr = wasm.getFunction(getTempRet0)->body;
      if (curr->is<Block>()) curr = curr->cast<Block>()->list.back();
      if (curr->is<Return>()) curr = curr->cast<Return>()->value;
      auto* get = curr->cast<GetGlobal>();
      tempRet0 = get->name;
    }
    // udivmoddi4 receives xl, xh, yl, yl, r, and
    //    if r then *r = x % y
    //    returns x / y
    auto* func = wasm.getFunction(udivmoddi4);
    assert(!func->type.is());
    Builder::clearLocals(func);
    Index xl  = Builder::addParam(func, "xl", i32),
          xh  = Builder::addParam(func, "xh", i32),
          yl  = Builder::addParam(func, "yl", i32),
          yh  = Builder::addParam(func, "yh", i32),
          r   = Builder::addParam(func, "r", i32),
          x64 = Builder::addVar(func, "x64", i64),
          y64 = Builder::addVar(func, "y64", i64);
    auto* body = allocator.alloc<Block>();
    body->list.push_back(builder.makeSetLocal(x64, I64Utilities::recreateI64(builder, xl, xh)));
    body->list.push_back(builder.makeSetLocal(y64, I64Utilities::recreateI64(builder, yl, yh)));
    body->list.push_back(
      builder.makeIf(
        builder.makeGetLocal(r, i32),
        builder.makeStore(
          8, 0, 8,
          builder.makeGetLocal(r, i32),
          builder.makeBinary(
            RemUInt64,
            builder.makeGetLocal(x64, i64),
            builder.makeGetLocal(y64, i64)
          ),
          i64
        )
      )
    );
    body->list.push_back(
      builder.makeSetLocal(
        x64,
        builder.makeBinary(
          DivUInt64,
          builder.makeGetLocal(x64, i64),
          builder.makeGetLocal(y64, i64)
        )
      )
    );
    body->list.push_back(
      builder.makeSetGlobal(
        tempRet0,
        I64Utilities::getI64High(builder, x64)
      )
    );
    body->list.push_back(I64Utilities::getI64Low(builder, x64));
    body->finalize();
    func->body = body;
  }
}

Function* Asm2WasmBuilder::processFunction(Ref ast) {
  auto name = ast[1]->getIString();

  if (debug) {
    std::cout << "asm2wasming func: " << ast[1]->getIString().str << '\n';
  }

  auto function = new Function;
  function->name = name;
  Ref params = ast[2];
  Ref body = ast[3];

  UniqueNameMapper nameMapper;

  // given an asm.js label, returns the wasm label for breaks or continues
  auto getBreakLabelName = [](IString label) {
    return Name(std::string("label$break$") + label.str);
  };
  auto getContinueLabelName = [](IString label) {
    return Name(std::string("label$continue$") + label.str);
  };

  IStringSet functionVariables; // params or vars

  IString parentLabel; // set in LABEL, then read in WHILE/DO/SWITCH
  std::vector<IString> breakStack; // where a break will go
  std::vector<IString> continueStack; // where a continue will go

  AsmData asmData; // need to know var and param types, for asm type detection

  for (unsigned i = 0; i < params->size(); i++) {
    Ref curr = body[i];
    auto* assign = curr->asAssignName();
    IString name = assign->target();
    AsmType asmType = detectType(assign->value(), nullptr, false, Math_fround, wasmOnly);
    Builder::addParam(function, name, asmToWasmType(asmType));
    functionVariables.insert(name);
    asmData.addParam(name, asmType);
  }
  unsigned start = params->size();
  while (start < body->size() && body[start]->isArray(VAR)) {
    Ref curr = body[start];
    for (unsigned j = 0; j < curr[1]->size(); j++) {
      Ref pair = curr[1][j];
      IString name = pair[0]->getIString();
      AsmType asmType = detectType(pair[1], nullptr, true, Math_fround, wasmOnly);
      Builder::addVar(function, name, asmToWasmType(asmType));
      functionVariables.insert(name);
      asmData.addVar(name, asmType);
    }
    start++;
  }

  bool addedI32Temp = false;
  auto ensureI32Temp = [&]() {
    if (addedI32Temp) return;
    addedI32Temp = true;
    Builder::addVar(function, I32_TEMP, i32);
    functionVariables.insert(I32_TEMP);
    asmData.addVar(I32_TEMP, ASM_INT);
  };

  bool seenReturn = false; // function->result is updated if we see a return
  // processors
  std::function<Expression* (Ref, unsigned)> processStatements;
  std::function<Expression* (Ref, unsigned)> processUnshifted;
  std::function<Expression* (Ref, unsigned)> processIgnoringShift;

  std::function<Expression* (Ref)> process = [&](Ref ast) -> Expression* {
    AstStackHelper astStackHelper(ast); // TODO: only create one when we need it?
    if (ast->isString()) {
      IString name = ast->getIString();
      if (functionVariables.has(name)) {
        // var in scope
        auto ret = allocator.alloc<GetLocal>();
        ret->index = function->getLocalIndex(name);
        ret->type = asmToWasmType(asmData.getType(name));
        return ret;
      }
      if (name == DEBUGGER) {
        Call *call = allocator.alloc<Call>();
        call->target = DEBUGGER;
        call->type = none;
        static bool addedImport = false;
        if (!addedImport) {
          addedImport = true;
          auto import = new Function; // debugger = asm2wasm.debugger;
          import->name = DEBUGGER;
          import->module = ASM2WASM;
          import->base = DEBUGGER;
          auto* functionType = ensureFunctionType("v", &wasm);
          import->type = functionType->name;
          FunctionTypeUtils::fillFunction(import, functionType);
          wasm.addFunction(import);
        }
        return call;
      }
      // global var
      assert(mappedGlobals.find(name) != mappedGlobals.end() ? true : (std::cerr << name.str << '\n', false));
      MappedGlobal& global = mappedGlobals[name];
      return builder.makeGetGlobal(name, global.type);
    }
    if (ast->isNumber()) {
      auto ret = allocator.alloc<Const>();
      double num = ast->getNumber();
      if (isSInteger32(num)) {
        ret->value = Literal(int32_t(toSInteger32(num)));
      } else if (isUInteger32(num)) {
        ret->value = Literal(uint32_t(toUInteger32(num)));
      } else {
        ret->value = Literal(num);
      }
      ret->type = ret->value.type;
      return ret;
    }
    if (ast->isAssignName()) {
      auto* assign = ast->asAssignName();
      IString name = assign->target();
      if (functionVariables.has(name)) {
        auto ret = allocator.alloc<SetLocal>();
        ret->index = function->getLocalIndex(assign->target());
        ret->value = process(assign->value());
        ret->setTee(false);
        ret->finalize();
        return ret;
      }
      // global var
      if (mappedGlobals.find(name) == mappedGlobals.end()) {
        Fatal() << "error: access of a non-existent global var " << name.str;
      }
      auto* ret = builder.makeSetGlobal(name, process(assign->value()));
      // set_global does not return; if our value is trivially not used, don't emit a load (if nontrivially not used, opts get it later)
      auto parent = astStackHelper.getParent();
      if (!parent || parent->isArray(BLOCK) || parent->isArray(IF)) return ret;
      return builder.makeSequence(ret, builder.makeGetGlobal(name, ret->value->type));
    }
    if (ast->isAssign()) {
      auto* assign = ast->asAssign();
      assert(assign->target()->isArray(SUB));
      Ref target = assign->target();
      assert(target[1]->isString());
      IString heap = target[1]->getIString();
      assert(views.find(heap) != views.end());
      View& view = views[heap];
      auto ret = allocator.alloc<Store>();
      ret->isAtomic = false;
      ret->bytes = view.bytes;
      ret->offset = 0;
      ret->align = view.bytes;
      ret->ptr = processUnshifted(target[2], view.bytes);
      ret->value = process(assign->value());
      ret->valueType = asmToWasmType(view.type);
      ret->finalize();
      if (ret->valueType != ret->value->type) {
        // in asm.js we have some implicit coercions that we must do explicitly here
        if (ret->valueType == f32 && ret->value->type == f64) {
          auto conv = allocator.alloc<Unary>();
          conv->op = DemoteFloat64;
          conv->value = ret->value;
          conv->type = Type::f32;
          ret->value = conv;
        } else if (ret->valueType == f64 && ret->value->type == f32) {
          ret->value = ensureDouble(ret->value);
        } else {
          abort_on("bad sub[] types", ast);
        }
      }
      return ret;
    }
    IString what = ast[0]->getIString();
    if (what == BINARY) {
      if ((ast[1] == OR || ast[1] == TRSHIFT) && ast[3]->isNumber() && ast[3]->getNumber() == 0) {
        auto ret = process(ast[2]); // just look through the ()|0 or ()>>>0 coercion
        fixCallType(ret, i32);
        return ret;
      }
      auto ret = allocator.alloc<Binary>();
      ret->left = process(ast[2]);
      ret->right = process(ast[3]);
      ret->op = parseAsmBinaryOp(ast[1]->getIString(), ast[2], ast[3], ret->left, ret->right);
      ret->finalize();
      if (ret->op == BinaryOp::RemSInt32 && isFloatType(ret->type)) {
        // WebAssembly does not have floating-point remainder, we have to emit a call to a special import of ours
        Call *call = allocator.alloc<Call>();
        call->target = F64_REM;
        call->operands.push_back(ensureDouble(ret->left));
        call->operands.push_back(ensureDouble(ret->right));
        call->type = f64;
        static bool addedImport = false;
        if (!addedImport) {
          addedImport = true;
          auto import = new Function; // f64-rem = asm2wasm.f64-rem;
          import->name = F64_REM;
          import->module = ASM2WASM;
          import->base = F64_REM;
          auto* functionType = ensureFunctionType("ddd", &wasm);
          import->type = functionType->name;
          FunctionTypeUtils::fillFunction(import, functionType);
          wasm.addFunction(import);
        }
        return call;
      }
      return makeTrappingBinary(ret, trappingFunctions);
    } else if (what == SUB) {
      Ref target = ast[1];
      assert(target->isString());
      IString heap = target->getIString();
      assert(views.find(heap) != views.end());
      View& view = views[heap];
      auto ret = allocator.alloc<Load>();
      ret->isAtomic = false;
      ret->bytes = view.bytes;
      ret->signed_ = view.signed_;
      ret->offset = 0;
      ret->align = view.bytes;
      ret->ptr = processUnshifted(ast[2], view.bytes);
      ret->type = getType(view.bytes, !view.integer);
      return ret;
    } else if (what == UNARY_PREFIX) {
      if (ast[1] == PLUS) {
        Literal literal = checkLiteral(ast);
        if (literal.type != none) {
          return builder.makeConst(literal);
        }
        auto ret = process(ast[2]); // we are a +() coercion
        if (ret->type == i32) {
          auto conv = allocator.alloc<Unary>();
          conv->op = isUnsignedCoercion(ast[2]) ? ConvertUInt32ToFloat64 : ConvertSInt32ToFloat64;
          conv->value = ret;
          conv->type = Type::f64;
          return conv;
        }
        if (ret->type == f32) {
          return ensureDouble(ret);
        }
        fixCallType(ret, f64);
        return ret;
      } else if (ast[1] == MINUS) {
        if (ast[2]->isNumber() || (ast[2]->isArray(UNARY_PREFIX) && ast[2][1] == PLUS && ast[2][2]->isNumber())) {
          auto ret = allocator.alloc<Const>();
          ret->value = getLiteral(ast);
          ret->type = ret->value.type;
          return ret;
        }
        AsmType asmType = detectAsmType(ast[2], &asmData);
        if (asmType == ASM_INT) {
          // wasm has no unary negation for int, so do 0-
          auto ret = allocator.alloc<Binary>();
          ret->op = SubInt32;
          ret->left = builder.makeConst(Literal((int32_t)0));
          ret->right = process(ast[2]);
          ret->type = Type::i32;
          return ret;
        }
        auto ret = allocator.alloc<Unary>();
        ret->value = process(ast[2]);
        if (asmType == ASM_DOUBLE) {
          ret->op = NegFloat64;
          ret->type = Type::f64;
        } else if (asmType == ASM_FLOAT) {
          ret->op = NegFloat32;
          ret->type = Type::f32;
        } else {
          WASM_UNREACHABLE();
        }
        return ret;
      } else if (ast[1] == B_NOT) {
        // ~, might be ~~ as a coercion or just a not
        if (ast[2]->isArray(UNARY_PREFIX) && ast[2][1] == B_NOT) {
          // if we have an unsigned coercion on us, it is an unsigned op
          Expression* expr = process(ast[2][2]);
          bool isSigned = !isParentUnsignedCoercion(astStackHelper.getParent());
          bool isF64 = expr->type == f64;
          UnaryOp op;
          if (isSigned && isF64) {
            op = UnaryOp::TruncSFloat64ToInt32;
          } else if (isSigned && !isF64) {
            op = UnaryOp::TruncSFloat32ToInt32;
          } else if (!isSigned && isF64) {
            op = UnaryOp::TruncUFloat64ToInt32;
          } else { // !isSigned && !isF64
            op = UnaryOp::TruncUFloat32ToInt32;
          }
          return makeTrappingUnary(builder.makeUnary(op, expr), trappingFunctions);
        }
        // no bitwise unary not, so do xor with -1
        auto ret = allocator.alloc<Binary>();
        ret->op = XorInt32;
        ret->left = process(ast[2]);
        ret->right = builder.makeConst(Literal(int32_t(-1)));
        ret->type = Type::i32;
        return ret;
      } else if (ast[1] == L_NOT) {
        auto ret = allocator.alloc<Unary>();
        ret->op = EqZInt32;
        ret->value = process(ast[2]);
        ret->type = i32;
        return ret;
      }
      abort_on("bad unary", ast);
    } else if (what == IF) {
      auto* condition = process(ast[1]);
      auto* ifTrue = process(ast[2]);
      return builder.makeIf(truncateToInt32(condition), ifTrue, !!ast[3] ? process(ast[3]) : nullptr);
    } else if (what == CALL) {
      if (ast[1]->isString()) {
        IString name = ast[1]->getIString();
        if (name == Math_imul) {
          assert(ast[2]->size() == 2);
          auto ret = allocator.alloc<Binary>();
          ret->op = MulInt32;
          ret->left = process(ast[2][0]);
          ret->right = process(ast[2][1]);
          ret->type = Type::i32;
          return ret;
        }
        if (name == Math_clz32 || name == llvm_cttz_i32) {
          assert(ast[2]->size() == 1);
          auto ret = allocator.alloc<Unary>();
          ret->op = name == Math_clz32 ? ClzInt32 : CtzInt32;
          ret->value = process(ast[2][0]);
          ret->type = Type::i32;
          return ret;
        }
        if (name == Math_fround) {
          assert(ast[2]->size() == 1);
          Literal lit = checkLiteral(ast[2][0], false /* raw is float */);
          if (lit.type == f64) {
            return builder.makeConst(Literal((float)lit.getf64()));
          }
          auto ret = allocator.alloc<Unary>();
          ret->value = process(ast[2][0]);
          if (ret->value->type == f64) {
            ret->op = DemoteFloat64;
          } else if (ret->value->type == i32) {
            if (isUnsignedCoercion(ast[2][0])) {
              ret->op = ConvertUInt32ToFloat32;
            } else {
              ret->op = ConvertSInt32ToFloat32;
            }
          } else if (ret->value->type == f32) {
            return ret->value;
          } else if (ret->value->type == none) { // call, etc.
            ret->value->type = f32;
            return ret->value;
          } else {
            abort_on("confusing fround target", ast[2][0]);
          }
          ret->type = f32;
          return ret;
        }
        if (name == Math_abs) {
          // overloaded on type: i32, f32 or f64
          Expression* value = process(ast[2][0]);
          if (value->type == i32) {
            // No wasm support, so use a temp local
            ensureI32Temp();
            auto set = allocator.alloc<SetLocal>();
            set->index = function->getLocalIndex(I32_TEMP);
            set->value = value;
            set->setTee(false);
            set->finalize();
            auto get = [&]() {
              auto ret = allocator.alloc<GetLocal>();
              ret->index = function->getLocalIndex(I32_TEMP);
              ret->type = i32;
              return ret;
            };
            auto isNegative = allocator.alloc<Binary>();
            isNegative->op = LtSInt32;
            isNegative->left = get();
            isNegative->right = builder.makeConst(Literal(0));
            isNegative->finalize();
            auto block = allocator.alloc<Block>();
            block->list.push_back(set);
            auto flip = allocator.alloc<Binary>();
            flip->op = SubInt32;
            flip->left = builder.makeConst(Literal(0));
            flip->right = get();
            flip->type = i32;
            auto select = allocator.alloc<Select>();
            select->ifTrue = flip;
            select->ifFalse = get();
            select->condition = isNegative;
            select->type = i32;
            block->list.push_back(select);
            block->finalize();
            return block;
          } else if (value->type == f32 || value->type == f64) {
            auto ret = allocator.alloc<Unary>();
            ret->op = value->type == f32 ? AbsFloat32 : AbsFloat64;
            ret->value = value;
            ret->type = value->type;
            return ret;
          } else {
            WASM_UNREACHABLE();
          }
        }
        if (name == Math_floor || name == Math_sqrt || name == Math_ceil) {
          // overloaded on type: f32 or f64
          Expression* value = process(ast[2][0]);
          auto ret = allocator.alloc<Unary>();
          ret->value = value;
          if (value->type == f32) {
            ret->op = name == Math_floor ? FloorFloat32 : name == Math_ceil ? CeilFloat32 : SqrtFloat32;
            ret->type = value->type;
          } else if (value->type == f64) {
            ret->op = name == Math_floor ? FloorFloat64 : name == Math_ceil ? CeilFloat64 : SqrtFloat64;
            ret->type = value->type;
          } else {
            Fatal() << "floor/sqrt/ceil only work on float/double in asm.js and wasm";
          }
          return ret;
        }
        if (name == Math_max || name == Math_min) {
          // overloaded on type: f32 or f64
          assert(ast[2]->size() == 2);
          auto ret = allocator.alloc<Binary>();
          ret->left = process(ast[2][0]);
          ret->right = process(ast[2][1]);
          if (ret->left->type == f32) {
            ret->op = name == Math_max ? MaxFloat32 : MinFloat32;
          } else if (ret->left->type == f64) {
            ret->op = name == Math_max ? MaxFloat64 : MinFloat64;
          } else {
            Fatal() << "min/max only work on float/double in asm.js and wasm";
          }
          ret->type = ret->left->type;
          return ret;
        }
        if (name == Atomics_load ||
            name == Atomics_store ||
            name == Atomics_exchange ||
            name == Atomics_compareExchange ||
            name == Atomics_add ||
            name == Atomics_sub ||
            name == Atomics_and ||
            name == Atomics_or ||
            name == Atomics_xor) {
          // atomic operation
          Ref target = ast[2][0];
          assert(target->isString());
          IString heap = target->getIString();
          assert(views.find(heap) != views.end());
          View& view = views[heap];
          wasm.memory.shared = true;
          if (name == Atomics_load) {
            Expression* ret = builder.makeAtomicLoad(view.bytes, 0, processUnshifted(ast[2][1], view.bytes), asmToWasmType(view.type));
            if (view.signed_) {
              // atomic loads are unsigned; add a signing
              ret = Bits::makeSignExt(ret, view.bytes, wasm);
            }
            return ret;
          } else if (name == Atomics_store) {
            // asm.js stores return the value, wasm does not
            auto type = asmToWasmType(view.type);
            auto temp = Builder::addVar(function, type);
            return builder.makeSequence(
              builder.makeAtomicStore(view.bytes, 0, processUnshifted(ast[2][1], view.bytes),
                                      builder.makeTeeLocal(temp, process(ast[2][2])),
                                      type),
              builder.makeGetLocal(temp, type)
            );
          } else if (name == Atomics_exchange) {
            return builder.makeAtomicRMW(AtomicRMWOp::Xchg, view.bytes, 0, processUnshifted(ast[2][1], view.bytes), process(ast[2][2]), asmToWasmType(view.type));
          } else if (name == Atomics_compareExchange) {
            // cmpxchg is odd in fastcomp output - we must ignore the shift, a cmpxchg of a i8 will look like compareExchange(HEAP8, ptr >> 2)
            return builder.makeAtomicCmpxchg(view.bytes, 0, processIgnoringShift(ast[2][1], view.bytes), process(ast[2][2]), process(ast[2][3]), asmToWasmType(view.type));
          } else if (name == Atomics_add) {
            return builder.makeAtomicRMW(AtomicRMWOp::Add, view.bytes, 0, processUnshifted(ast[2][1], view.bytes), process(ast[2][2]), asmToWasmType(view.type));
          } else if (name == Atomics_sub) {
            return builder.makeAtomicRMW(AtomicRMWOp::Sub, view.bytes, 0, processUnshifted(ast[2][1], view.bytes), process(ast[2][2]), asmToWasmType(view.type));
          } else if (name == Atomics_and) {
            return builder.makeAtomicRMW(AtomicRMWOp::And, view.bytes, 0, processUnshifted(ast[2][1], view.bytes), process(ast[2][2]), asmToWasmType(view.type));
          } else if (name == Atomics_or) {
            return builder.makeAtomicRMW(AtomicRMWOp::Or, view.bytes, 0, processUnshifted(ast[2][1], view.bytes), process(ast[2][2]), asmToWasmType(view.type));
          } else if (name == Atomics_xor) {
            return builder.makeAtomicRMW(AtomicRMWOp::Xor, view.bytes, 0, processUnshifted(ast[2][1], view.bytes), process(ast[2][2]), asmToWasmType(view.type));
          }
          WASM_UNREACHABLE();
        }
        bool tableCall = false;
        if (wasmOnly) {
          auto num = ast[2]->size();
          switch (name.str[0]) {
            case 'l': {
              auto align = num == 2 ? ast[2][1]->getInteger() : 0;
              if (name == LOAD1) return builder.makeLoad(1, true, 0, 1,                 process(ast[2][0]), i32);
              if (name == LOAD2) return builder.makeLoad(2, true, 0, indexOr(align, 2), process(ast[2][0]), i32);
              if (name == LOAD4) return builder.makeLoad(4, true, 0, indexOr(align, 4), process(ast[2][0]), i32);
              if (name == LOAD8) return builder.makeLoad(8, true, 0, indexOr(align, 8), process(ast[2][0]), i64);
              if (name == LOADF) return builder.makeLoad(4, true, 0, indexOr(align, 4), process(ast[2][0]), f32);
              if (name == LOADD) return builder.makeLoad(8, true, 0, indexOr(align, 8), process(ast[2][0]), f64);
              break;
            }
            case 's': {
              auto align = num == 3 ? ast[2][2]->getInteger() : 0;
              if (name == STORE1) return builder.makeStore(1, 0, 1,                 process(ast[2][0]), process(ast[2][1]), i32);
              if (name == STORE2) return builder.makeStore(2, 0, indexOr(align, 2), process(ast[2][0]), process(ast[2][1]), i32);
              if (name == STORE4) return builder.makeStore(4, 0, indexOr(align, 4), process(ast[2][0]), process(ast[2][1]), i32);
              if (name == STORE8) return builder.makeStore(8, 0, indexOr(align, 8), process(ast[2][0]), process(ast[2][1]), i64);
              if (name == STOREF) {
                auto* value = process(ast[2][1]);
                if (value->type == f64) {
                  // asm.js allows storing a double to HEAPF32, we must cast here
                  value = builder.makeUnary(DemoteFloat64, value);
                }
                return builder.makeStore(4, 0, indexOr(align, 4), process(ast[2][0]), value, f32);
              }
              if (name == STORED) return builder.makeStore(8, 0, indexOr(align, 8), process(ast[2][0]), process(ast[2][1]), f64);
              break;
            }
            case 'i': {
              if (num == 1) {
                auto* value = process(ast[2][0]);
                if (name == I64) {
                  // no-op "coercion" / "cast", although we also tolerate i64(0) for constants that fit in i32
                  if (value->type == i32) {
                    return builder.makeConst(Literal(int64_t(value->cast<Const>()->value.geti32())));
                  } else {
                    fixCallType(value, i64);
                    return value;
                  }
                }
                if (name == I32_CTTZ) return builder.makeUnary(UnaryOp::CtzInt32, value);
                if (name == I32_CTPOP) return builder.makeUnary(UnaryOp::PopcntInt32, value);
                if (name == I32_BC2F) return builder.makeUnary(UnaryOp::ReinterpretInt32, value);
                if (name == I32_BC2I) return builder.makeUnary(UnaryOp::ReinterpretFloat32, value);

                if (name == I64_TRUNC) return builder.makeUnary(UnaryOp::WrapInt64, value);
                if (name == I64_SEXT) return builder.makeUnary(UnaryOp::ExtendSInt32, value);
                if (name == I64_ZEXT) return builder.makeUnary(UnaryOp::ExtendUInt32, value);
                if (name == I64_S2F) return builder.makeUnary(UnaryOp::ConvertSInt64ToFloat32, value);
                if (name == I64_S2D) return builder.makeUnary(UnaryOp::ConvertSInt64ToFloat64, value);
                if (name == I64_U2F) return builder.makeUnary(UnaryOp::ConvertUInt64ToFloat32, value);
                if (name == I64_U2D) return builder.makeUnary(UnaryOp::ConvertUInt64ToFloat64, value);
                if (name == I64_F2S) {
                  Unary* conv = builder.makeUnary(UnaryOp::TruncSFloat32ToInt64, value);
                  return makeTrappingUnary(conv, trappingFunctions);
                }
                if (name == I64_D2S) {
                  Unary* conv = builder.makeUnary(UnaryOp::TruncSFloat64ToInt64, value);
                  return makeTrappingUnary(conv, trappingFunctions);
                }
                if (name == I64_F2U) {
                  Unary* conv = builder.makeUnary(UnaryOp::TruncUFloat32ToInt64, value);
                  return makeTrappingUnary(conv, trappingFunctions);
                }
                if (name == I64_D2U) {
                  Unary* conv = builder.makeUnary(UnaryOp::TruncUFloat64ToInt64, value);
                  return makeTrappingUnary(conv, trappingFunctions);
                }
                if (name == I64_BC2D) return builder.makeUnary(UnaryOp::ReinterpretInt64, value);
                if (name == I64_BC2I) return builder.makeUnary(UnaryOp::ReinterpretFloat64, value);
                if (name == I64_CTTZ) return builder.makeUnary(UnaryOp::CtzInt64, value);
                if (name == I64_CTLZ) return builder.makeUnary(UnaryOp::ClzInt64, value);
                if (name == I64_CTPOP) return builder.makeUnary(UnaryOp::PopcntInt64, value);
                if (name == I64_ATOMICS_LOAD) return builder.makeAtomicLoad(8, 0, value, i64);
              } else if (num == 2) { // 2 params,binary
                if (name == I64_CONST) return builder.makeConst(getLiteral(ast));
                auto* left = process(ast[2][0]);
                auto* right = process(ast[2][1]);
                // maths
                if (name == I64_ADD) return builder.makeBinary(BinaryOp::AddInt64, left, right);
                if (name == I64_SUB) return builder.makeBinary(BinaryOp::SubInt64, left, right);
                if (name == I64_MUL) return builder.makeBinary(BinaryOp::MulInt64, left, right);
                if (name == I64_UDIV) {
                  Binary* div = builder.makeBinary(BinaryOp::DivUInt64, left, right);
                  return makeTrappingBinary(div, trappingFunctions);
                }
                if (name == I64_SDIV) {
                  Binary* div = builder.makeBinary(BinaryOp::DivSInt64, left, right);
                  return makeTrappingBinary(div, trappingFunctions);
                }
                if (name == I64_UREM) {
                  Binary* rem = builder.makeBinary(BinaryOp::RemUInt64, left, right);
                  return makeTrappingBinary(rem, trappingFunctions);
                }
                if (name == I64_SREM) {
                  Binary* rem = builder.makeBinary(BinaryOp::RemSInt64, left, right);
                  return makeTrappingBinary(rem, trappingFunctions);
                }
                if (name == I64_AND) return builder.makeBinary(BinaryOp::AndInt64, left, right);
                if (name == I64_OR) return builder.makeBinary(BinaryOp::OrInt64, left, right);
                if (name == I64_XOR) return builder.makeBinary(BinaryOp::XorInt64, left, right);
                if (name == I64_SHL) return builder.makeBinary(BinaryOp::ShlInt64, left, right);
                if (name == I64_ASHR) return builder.makeBinary(BinaryOp::ShrSInt64, left, right);
                if (name == I64_LSHR) return builder.makeBinary(BinaryOp::ShrUInt64, left, right);
                // comps
                if (name == I64_EQ) return builder.makeBinary(BinaryOp::EqInt64, left, right);
                if (name == I64_NE) return builder.makeBinary(BinaryOp::NeInt64, left, right);
                if (name == I64_ULE) return builder.makeBinary(BinaryOp::LeUInt64, left, right);
                if (name == I64_SLE) return builder.makeBinary(BinaryOp::LeSInt64, left, right);
                if (name == I64_UGE) return builder.makeBinary(BinaryOp::GeUInt64, left, right);
                if (name == I64_SGE) return builder.makeBinary(BinaryOp::GeSInt64, left, right);
                if (name == I64_ULT) return builder.makeBinary(BinaryOp::LtUInt64, left, right);
                if (name == I64_SLT) return builder.makeBinary(BinaryOp::LtSInt64, left, right);
                if (name == I64_UGT) return builder.makeBinary(BinaryOp::GtUInt64, left, right);
                if (name == I64_SGT) return builder.makeBinary(BinaryOp::GtSInt64, left, right);
                // atomics
                if (name == I64_ATOMICS_STORE) {
                  wasm.memory.shared = true;
                  return builder.makeAtomicStore(8, 0, left, right, i64);
                }
                if (name == I64_ATOMICS_ADD) {
                  wasm.memory.shared = true;
                  return builder.makeAtomicRMW(AtomicRMWOp::Add, 8, 0, left, right, i64);
                }
                if (name == I64_ATOMICS_SUB) {
                  wasm.memory.shared = true;
                  return builder.makeAtomicRMW(AtomicRMWOp::Sub, 8, 0, left, right, i64);
                }
                if (name == I64_ATOMICS_AND) {
                  wasm.memory.shared = true;
                  return builder.makeAtomicRMW(AtomicRMWOp::And, 8, 0, left, right, i64);
                }
                if (name == I64_ATOMICS_OR) {
                  wasm.memory.shared = true;
                  return builder.makeAtomicRMW(AtomicRMWOp::Or, 8, 0, left, right, i64);
                }
                if (name == I64_ATOMICS_XOR) {
                  wasm.memory.shared = true;
                  return builder.makeAtomicRMW(AtomicRMWOp::Xor, 8, 0, left, right, i64);
                }
                if (name == I64_ATOMICS_EXCHANGE) {
                  wasm.memory.shared = true;
                  return builder.makeAtomicRMW(AtomicRMWOp::Xchg, 8, 0, left, right, i64);
                }
              } else if (num == 3) {
                if (name == I64_ATOMICS_COMPAREEXCHANGE) {
                  wasm.memory.shared = true;
                  return builder.makeAtomicCmpxchg(8, 0, process(ast[2][0]), process(ast[2][1]), process(ast[2][2]), i64);
                }
              }
              break;
            }
            case 'f': {
              if (name == F32_COPYSIGN) return builder.makeBinary(BinaryOp::CopySignFloat32, process(ast[2][0]), process(ast[2][1]));
              if (name == F64_COPYSIGN) return builder.makeBinary(BinaryOp::CopySignFloat64, process(ast[2][0]), process(ast[2][1]));
              break;
            }
            default: {}
          }
        }
        // ftCall_* and mftCall_* represent function table calls, either from the outside, or
        // from the inside of the module. when compiling to wasm, we can just convert those
        // into table calls
        if ((name.str[0] == 'f' && strncmp(name.str, FTCALL.str, 7) == 0) ||
            (name.str[0] == 'm' && strncmp(name.str, MFTCALL.str, 8) == 0)) {
          tableCall = true;
        }
        Expression* ret;
        ExpressionList* operands;
        bool callImport = false;
        Index firstOperand = 0;
        Ref args = ast[2];
        if (tableCall) {
          auto specific = allocator.alloc<CallIndirect>();
          specific->target = process(args[0]);
          firstOperand = 1;
          operands = &specific->operands;
          ret = specific;
        } else {
          // if we call an import, it definitely exists already; if it's a
          // defined function then it might not have been seen yet
          auto* target = wasm.getFunctionOrNull(name);
          callImport = target && target->imported();
          auto specific = allocator.alloc<Call>();
          specific->target = name;
          operands = &specific->operands;
          ret = specific;
        }
        for (unsigned i = firstOperand; i < args->size(); i++) {
          operands->push_back(process(args[i]));
        }
        if (tableCall) {
          auto specific = ret->dynCast<CallIndirect>();
          // note that we could also get the type from the suffix of the name, e.g., mftCall_vi
          auto* fullType = getFunctionType(astStackHelper.getParent(), specific->operands, &asmData);
          specific->fullType = fullType->name;
          specific->type = fullType->result;
        }
        if (callImport) {
          // apply the detected type from the parent
          // note that this may not be complete, e.g. we may see f(); but f is an
          // import which does return a value, and we use that elsewhere. finalizeCalls
          // fixes that up. what we do here is wherever a value is used, we set the right
          // value, which is enough to ensure that the wasm ast is valid for such uses.
          // this is important as we run the optimizer on functions before we get
          // to finalizeCalls (which we can only do once we've read all the functions,
          // and we optimize in parallel starting earlier).
          auto* call = ret->cast<Call>();
          call->type = getResultTypeOfCallUsingParent(astStackHelper.getParent(), &asmData);
          noteImportedFunctionCall(ast, call->type, call);
        }
        return ret;
      }
      // function pointers
      auto ret = allocator.alloc<CallIndirect>();
      Ref target = ast[1];
      assert(target[0] == SUB && target[1]->isString() && target[2][0] == BINARY && target[2][1] == AND && target[2][3]->isNumber()); // FUNCTION_TABLE[(expr) & mask]
      ret->target = process(target[2]); // TODO: as an optimization, we could look through the mask
      Ref args = ast[2];
      for (unsigned i = 0; i < args->size(); i++) {
        ret->operands.push_back(process(args[i]));
      }
      auto* fullType = getFunctionType(astStackHelper.getParent(), ret->operands, &asmData);
      ret->fullType = fullType->name;
      ret->type = fullType->result;
      // we don't know the table offset yet. emit target = target + callImport(tableName), which we fix up later when we know how asm function tables are layed out inside the wasm table.
      ret->target = builder.makeBinary(BinaryOp::AddInt32, ret->target, builder.makeCall(target[1]->getIString(), {}, i32));
      return ret;
    } else if (what == RETURN) {
      Type type = !!ast[1] ? detectWasmType(ast[1], &asmData) : none;
      if (seenReturn) {
        assert(function->result == type);
      } else {
        function->result = type;
      }
      // wasm has no return, so we just break on the topmost block
      auto ret = allocator.alloc<Return>();
      ret->value = !!ast[1] ? process(ast[1]) : nullptr;
      return ret;
    } else if (what == BLOCK) {
      Name name;
      if (parentLabel.is()) {
        name = nameMapper.pushLabelName(getBreakLabelName(parentLabel));
        parentLabel = IString();
        breakStack.push_back(name);
      }
      auto ret = processStatements(ast[1], 0);
      if (name.is()) {
        breakStack.pop_back();
        nameMapper.popLabelName(name);
        Block* block = ret->dynCast<Block>();
        if (block && block->name.isNull()) {
          block->name = name;
        } else {
          block = allocator.alloc<Block>();
          block->name = name;
          block->list.push_back(ret);
          block->finalize();
          ret = block;
        }
      }
      return ret;
    } else if (what == BREAK) {
      auto ret = allocator.alloc<Break>();
      assert(breakStack.size() > 0);
      ret->name = !!ast[1] ? nameMapper.sourceToUnique(getBreakLabelName(ast[1]->getIString())) : breakStack.back();
      return ret;
    } else if (what == CONTINUE) {
      auto ret = allocator.alloc<Break>();
      assert(continueStack.size() > 0);
      ret->name = !!ast[1] ? nameMapper.sourceToUnique(getContinueLabelName(ast[1]->getIString())) : continueStack.back();
      return ret;
    } else if (what == WHILE) {
      bool forever = ast[1]->isNumber() && ast[1]->getInteger() == 1;
      auto ret = allocator.alloc<Loop>();
      IString out, in;
      if (!parentLabel.isNull()) {
        out = getBreakLabelName(parentLabel);
        in = getContinueLabelName(parentLabel);
        parentLabel = IString();
      } else {
        out = "while-out";
        in = "while-in";
      }
      out = nameMapper.pushLabelName(out);
      in = nameMapper.pushLabelName(in);
      ret->name = in;
      breakStack.push_back(out);
      continueStack.push_back(in);
      if (forever) {
        ret->body = process(ast[2]);
      } else {
        Break *breakOut = allocator.alloc<Break>();
        breakOut->name = out;
        If *condition = allocator.alloc<If>();
        condition->condition = builder.makeUnary(EqZInt32, process(ast[1]));
        condition->ifTrue = breakOut;
        condition->finalize();
        auto body = allocator.alloc<Block>();
        body->list.push_back(condition);
        body->list.push_back(process(ast[2]));
        body->finalize();
        ret->body = body;
      }
      // loops do not automatically loop, add a branch back
      Block* block = builder.blockifyWithName(ret->body, out);
      auto continuer = allocator.alloc<Break>();
      continuer->name = ret->name;
      block->list.push_back(continuer);
      block->finalize();
      ret->body = block;
      ret->finalize();
      continueStack.pop_back();
      breakStack.pop_back();
      nameMapper.popLabelName(in);
      nameMapper.popLabelName(out);
      return ret;
    } else if (what == DO) {
      if (ast[1]->isNumber() && ast[1]->getNumber() == 0) {
        // one-time loop, unless there is a continue
        IString stop;
        if (!parentLabel.isNull()) {
          stop = getBreakLabelName(parentLabel);
          parentLabel = IString();
        } else {
          stop = "do-once";
        }
        stop = nameMapper.pushLabelName(stop);
        Name more = nameMapper.pushLabelName("unlikely-continue");
        breakStack.push_back(stop);
        continueStack.push_back(more);
        auto child = process(ast[2]);
        continueStack.pop_back();
        breakStack.pop_back();
        nameMapper.popLabelName(more);
        nameMapper.popLabelName(stop);
        // if we never continued, we don't need a loop
        BranchUtils::BranchSeeker seeker(more);
        seeker.walk(child);
        if (seeker.found == 0) {
          auto block = allocator.alloc<Block>();
          block->list.push_back(child);
          if (isConcreteType(child->type)) {
            block->list.push_back(builder.makeNop()); // ensure a nop at the end, so the block has guaranteed none type and no values fall through
          }
          block->name = stop;
          block->finalize();
          return block;
        } else {
          auto loop = allocator.alloc<Loop>();
          loop->body = child;
          loop->name = more;
          loop->finalize();
          return builder.blockifyWithName(loop, stop);
        }
      }
      // general do-while loop
      auto loop = allocator.alloc<Loop>();
      IString out, in;
      if (!parentLabel.isNull()) {
        out = getBreakLabelName(parentLabel);
        in = getContinueLabelName(parentLabel);
        parentLabel = IString();
      } else {
        out = "do-out";
        in = "do-in";
      }
      out = nameMapper.pushLabelName(out);
      in = nameMapper.pushLabelName(in);
      loop->name = in;
      breakStack.push_back(out);
      continueStack.push_back(in);
      loop->body = process(ast[2]);
      continueStack.pop_back();
      breakStack.pop_back();
      nameMapper.popLabelName(in);
      nameMapper.popLabelName(out);
      Break *continuer = allocator.alloc<Break>();
      continuer->name = in;
      continuer->condition = process(ast[1]);
      continuer->finalize();
      Block *block = builder.blockifyWithName(loop->body, out, continuer);
      loop->body = block;
      loop->finalize();
      return loop;
    } else if (what == FOR) {
      Ref finit = ast[1],
          fcond = ast[2],
          finc = ast[3],
          fbody = ast[4];
      auto ret = allocator.alloc<Loop>();
      IString out, in;
      if (!parentLabel.isNull()) {
        out = getBreakLabelName(parentLabel);
        in = getContinueLabelName(parentLabel);
        parentLabel = IString();
      } else {
        out = "for-out";
        in = "for-in";
      }
      out = nameMapper.pushLabelName(out);
      in = nameMapper.pushLabelName(in);
      ret->name = in;
      breakStack.push_back(out);
      continueStack.push_back(in);
      Break *breakOut = allocator.alloc<Break>();
      breakOut->name = out;
      If *condition = allocator.alloc<If>();
      condition->condition = builder.makeUnary(EqZInt32, process(fcond));
      condition->ifTrue = breakOut;
      condition->finalize();
      auto body = allocator.alloc<Block>();
      body->list.push_back(condition);
      body->list.push_back(process(fbody));
      body->list.push_back(process(finc));
      body->finalize();
      ret->body = body;
      // loops do not automatically loop, add a branch back
      auto continuer = allocator.alloc<Break>();
      continuer->name = ret->name;
      Block* block = builder.blockifyWithName(ret->body, out, continuer);
      ret->body = block;
      ret->finalize();
      continueStack.pop_back();
      breakStack.pop_back();
      nameMapper.popLabelName(in);
      nameMapper.popLabelName(out);
      Block *outer = allocator.alloc<Block>();
      // add an outer block for the init as well
      outer->list.push_back(process(finit));
      outer->list.push_back(ret);
      outer->finalize();
      return outer;
    } else if (what == LABEL) {
      assert(parentLabel.isNull());
      parentLabel = ast[1]->getIString();
      return process(ast[2]);
    } else if (what == CONDITIONAL) {
      auto ret = allocator.alloc<If>();
      ret->condition = process(ast[1]);
      ret->ifTrue = process(ast[2]);
      ret->ifFalse = process(ast[3]);
      ret->finalize();
      return ret;
    } else if (what == SEQ) {
      // Some (x, y) patterns can be optimized, like bitcasts,
      //  (HEAP32[tempDoublePtr >> 2] = i, Math_fround(HEAPF32[tempDoublePtr >> 2])); // i32->f32
      //  (HEAP32[tempDoublePtr >> 2] = i, +HEAPF32[tempDoublePtr >> 2]); // i32->f32, no fround
      //  (HEAPF32[tempDoublePtr >> 2] = f, HEAP32[tempDoublePtr >> 2] | 0); // f32->i32
      if (ast[1]->isAssign()) {
        auto* assign = ast[1]->asAssign();
        Ref target = assign->target();
        if (target->isArray(SUB) && target[1]->isString() && target[2]->isArray(BINARY) && target[2][1] == RSHIFT &&
            target[2][2]->isString() && target[2][2] == tempDoublePtr && target[2][3]->isNumber() && target[2][3]->getNumber() == 2) {
          // (?[tempDoublePtr >> 2] = ?, ?)  so far
          auto heap = target[1]->getIString();
          if (views.find(heap) != views.end()) {
            AsmType writeType = views[heap].type;
            AsmType readType = ASM_NONE;
            Ref readValue;
            if (ast[2]->isArray(BINARY) && ast[2][1] == OR && ast[2][3]->isNumber() && ast[2][3]->getNumber() == 0) {
              readType = ASM_INT;
              readValue = ast[2][2];
            } else if (ast[2]->isArray(UNARY_PREFIX) && ast[2][1] == PLUS) {
              readType = ASM_DOUBLE;
              readValue = ast[2][2];
            } else if (ast[2]->isArray(CALL) && ast[2][1]->isString() && ast[2][1] == Math_fround) {
              readType = ASM_FLOAT;
              readValue = ast[2][2][0];
            }
            if (readType != ASM_NONE) {
              if (readValue->isArray(SUB) && readValue[1]->isString() && readValue[2]->isArray(BINARY) && readValue[2][1] == RSHIFT &&
                  readValue[2][2]->isString() && readValue[2][2] == tempDoublePtr && readValue[2][3]->isNumber() && readValue[2][3]->getNumber() == 2) {
                // pattern looks right!
                Ref writtenValue = assign->value();
                if (writeType == ASM_INT && (readType == ASM_FLOAT || readType == ASM_DOUBLE)) {
                  auto conv = allocator.alloc<Unary>();
                  conv->op = ReinterpretInt32;
                  conv->value = process(writtenValue);
                  conv->type = Type::f32;
                  if (readType == ASM_DOUBLE) {
                    return ensureDouble(conv);
                  }
                  return conv;
                } else if (writeType == ASM_FLOAT && readType == ASM_INT) {
                  auto conv = allocator.alloc<Unary>();
                  conv->op = ReinterpretFloat32;
                  conv->value = process(writtenValue);
                  if (conv->value->type == f64) {
                    // this has an implicit f64->f32 in the write to memory
                    conv->value = builder.makeUnary(DemoteFloat64, conv->value);
                  }
                  conv->type = Type::i32;
                  return conv;
                }
              }
            }
          }
        }
      }
      auto ret = allocator.alloc<Block>();
      ret->list.push_back(process(ast[1]));
      ret->list.push_back(process(ast[2]));
      ret->finalize();
      return ret;
    } else if (what == SWITCH) {
      IString name; // for breaking out of the entire switch
      if (!parentLabel.isNull()) {
        name = getBreakLabelName(parentLabel);
        parentLabel = IString();
      } else {
        name = "switch";
      }
      name = nameMapper.pushLabelName(name);
      breakStack.push_back(name);

      auto br = allocator.alloc<Switch>();
      br->condition = process(ast[1]);

      Ref cases = ast[2];
      bool seen = false;
      int64_t min = 0; // the lowest index we see; we will offset to it
      int64_t max = 0; // the highest, to check if the range is too big
      for (unsigned i = 0; i < cases->size(); i++) {
        Ref curr = cases[i];
        Ref condition = curr[0];
        if (!condition->isNull()) {
          int64_t index = getLiteral(condition).getInteger();
          if (!seen) {
            seen = true;
            min = index;
            max = index;
          } else {
            if (index < min) min = index;
            if (index > max) max = index;
          }
        }
      }
      // we can use a switch if it's not too big
      auto range = double(max) - double(min); // test using doubles to avoid UB
      bool canSwitch = 0 <= range && range < 10240;

      auto top = allocator.alloc<Block>();
      if (canSwitch) {

        // we may need a break for the case where the condition doesn't match
        // any of the cases. it should go to the default, if we have one, or
        // outside if not
        Break* breakWhenNotMatching = nullptr;

        if (br->condition->type == i32) {
          Binary* offsetor = allocator.alloc<Binary>();
          offsetor->op = BinaryOp::SubInt32;
          offsetor->left = br->condition;
          offsetor->right = builder.makeConst(Literal(int32_t(min)));
          offsetor->type = i32;
          br->condition = offsetor;
        } else {
          assert(br->condition->type == i64);
          // 64-bit condition. after offsetting it must be in a reasonable range, but the offsetting itself must be 64-bit
          Binary* offsetor = allocator.alloc<Binary>();
          offsetor->op = BinaryOp::SubInt64;
          offsetor->left = br->condition;
          offsetor->right = builder.makeConst(Literal(int64_t(min)));
          offsetor->type = i64;
          // the switch itself can be 32-bit, as the range is in a reasonable range. so after
          // offsetting, we need to make sure there are no high bits, then we can just look
          // at the lower 32 bits
          auto temp = Builder::addVar(function, i64);
          auto* block = builder.makeBlock();
          block->list.push_back(builder.makeSetLocal(temp, offsetor));
          // if high bits, we can break to the default (we'll fill in the name later)
          breakWhenNotMatching = builder.makeBreak(Name(), nullptr,
            builder.makeUnary(
              UnaryOp::WrapInt64,
              builder.makeBinary(BinaryOp::ShrUInt64,
                builder.makeGetLocal(temp, i64),
                builder.makeConst(Literal(int64_t(32)))
              )
            )
          );
          block->list.push_back(breakWhenNotMatching);
          block->list.push_back(
            builder.makeGetLocal(temp, i64)
          );
          block->finalize();
          br->condition = builder.makeUnary(UnaryOp::WrapInt64, block);
        }

        top->list.push_back(br);

        for (unsigned i = 0; i < cases->size(); i++) {
          Ref curr = cases[i];
          Ref condition = curr[0];
          Ref body = curr[1];
          auto case_ = processStatements(body, 0);
          Name name;
          if (condition->isNull()) {
            name = br->default_ = nameMapper.pushLabelName("switch-default");
          } else {
            auto index = getLiteral(condition).getInteger();
            assert(index >= min);
            index -= min;
            assert(index >= 0);
            uint64_t index_s = index;
            name = nameMapper.pushLabelName("switch-case");
            if (br->targets.size() <= index_s) {
              br->targets.resize(index_s + 1);
            }
            br->targets[index_s] = name;
          }
          auto next = allocator.alloc<Block>();
          top->name = name;
          next->list.push_back(top);
          next->list.push_back(case_);
          next->finalize();
          top = next;
          nameMapper.popLabelName(name);
        }

        // the outermost block can be branched to to exit the whole switch
        top->name = name;

        // ensure a default
        if (br->default_.isNull()) {
          br->default_ = top->name;
        }
        if (breakWhenNotMatching) {
          breakWhenNotMatching->name = br->default_;
        }
        for (size_t i = 0; i < br->targets.size(); i++) {
          if (br->targets[i].isNull()) br->targets[i] = br->default_;
        }
      } else {
        // we can't switch, make an if-chain instead of br_table
        auto var = Builder::addVar(function, br->condition->type);
        top->list.push_back(builder.makeSetLocal(var, br->condition));
        auto* brHolder = top;
        If* chain = nullptr;
        If* first = nullptr;

        for (unsigned i = 0; i < cases->size(); i++) {
          Ref curr = cases[i];
          Ref condition = curr[0];
          Ref body = curr[1];
          auto case_ = processStatements(body, 0);
          Name name;
          if (condition->isNull()) {
            name = br->default_ = nameMapper.pushLabelName("switch-default");
          } else {
            name = nameMapper.pushLabelName("switch-case");
            auto* iff = builder.makeIf(
              builder.makeBinary(
                br->condition->type == i32 ? EqInt32 : EqInt64,
                builder.makeGetLocal(var, br->condition->type),
                builder.makeConst(getLiteral(condition))
              ),
              builder.makeBreak(name),
              chain
            );
            chain = iff;
            if (!first) first = iff;
          }
          auto next = allocator.alloc<Block>();
          top->name = name;
          next->list.push_back(top);
          next->list.push_back(case_);
          top = next;
          nameMapper.popLabelName(name);
        }

        // the outermost block can be branched to to exit the whole switch
        top->name = name;

        // ensure a default
        if (br->default_.isNull()) {
          br->default_ = top->name;
        }

        first->ifFalse = builder.makeBreak(br->default_);

        brHolder->list.push_back(chain);
      }

      breakStack.pop_back();
      nameMapper.popLabelName(name);

      return top;
    }
    abort_on("confusing expression", ast);
    return (Expression*)nullptr; // avoid warning
  };

  // given HEAP32[addr >> 2], we need an absolute address, and would like to remove that shift.
  // if there is a shift, we can just look through it, etc.
  processUnshifted = [&](Ref ptr, unsigned bytes) {
    auto shifts = bytesToShift(bytes);
    // HEAP?[addr >> ?], or HEAP8[x | 0]
    if ((ptr->isArray(BINARY) && ptr[1] == RSHIFT && ptr[3]->isNumber() && ptr[3]->getInteger() == shifts) ||
        (bytes == 1 && ptr->isArray(BINARY) && ptr[1] == OR && ptr[3]->isNumber() && ptr[3]->getInteger() == 0)) {
      return process(ptr[2]); // look through it
    } else if (ptr->isNumber()) {
      // constant, apply a shift (e.g. HEAP32[1] is address 4)
      unsigned addr = ptr->getInteger();
      unsigned shifted = addr << shifts;
      return (Expression*)builder.makeConst(Literal(int32_t(shifted)));
    }
    abort_on("bad processUnshifted", ptr);
    return (Expression*)nullptr; // avoid warning
  };

  processIgnoringShift = [&](Ref ptr, unsigned bytes) {
    // If there is a shift here, no matter the size look through it.
    if ((ptr->isArray(BINARY) && ptr[1] == RSHIFT && ptr[3]->isNumber()) ||
        (bytes == 1 && ptr->isArray(BINARY) && ptr[1] == OR && ptr[3]->isNumber() && ptr[3]->getInteger() == 0)) {
      return process(ptr[2]);
    }
    // Otherwise do the same as processUnshifted.
    return processUnshifted(ptr, bytes);
  };

  processStatements = [&](Ref ast, unsigned from) -> Expression* {
    unsigned size = ast->size() - from;
    if (size == 0) return allocator.alloc<Nop>();
    if (size == 1) return process(ast[from]);
    auto block = allocator.alloc<Block>();
    for (unsigned i = from; i < ast->size(); i++) {
      block->list.push_back(process(ast[i]));
    }
    block->finalize();
    return block;
  };
  // body
  function->body = processStatements(body, start);
  // cleanups/checks
  assert(breakStack.size() == 0 && continueStack.size() == 0);
  assert(parentLabel.isNull());
  return function;
}

} // namespace wasm

#endif // wasm_asm2wasm_h
