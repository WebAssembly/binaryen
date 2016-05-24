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
#include "asmjs/shared-constants.h"
#include "asm_v_wasm.h"
#include "pass.h"
#include "ast_utils.h"
#include "wasm-builder.h"
#include <wasm-validator.h>

namespace wasm {

using namespace cashew;

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

//
// Asm2WasmPreProcessor - does some initial parsing/processing
// of asm.js code.
//

struct Asm2WasmPreProcessor {
  bool memoryGrowth = false;

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
      *marker = 0; // look for memory growth code just up to here
      char *growthSign = strstr(input, "return true;"); // this can only show up in growth code, as normal asm.js lacks "true"
      if (growthSign) {
        memoryGrowth = true;
        // clean out this function, we don't need it
        char *growthFuncStart = strstr(input, "function ");
        assert(strstr(growthFuncStart + 1, "function ") == 0); // should be only this one function in this area, so no confusion for us
        char *growthFuncEnd = strchr(growthSign, '}');
        assert(growthFuncEnd > growthFuncStart + 5);
        growthFuncStart[0] = '/';
        growthFuncStart[1] = '*';
        growthFuncEnd--;
        growthFuncEnd[0] = '*';
        growthFuncEnd[1] = '/';
      }
      *marker = START_FUNCS[0];
    }

    return input;
  }
};

//
// Asm2WasmBuilder - converts an asm.js module into WebAssembly
//

class Asm2WasmBuilder {
  Module& wasm;

  MixedArena &allocator;

  Builder builder;

  // globals

  unsigned nextGlobal; // next place to put a global
  unsigned maxGlobal; // highest address we can put a global
  struct MappedGlobal {
    unsigned address;
    WasmType type;
    bool import; // if true, this is an import - we should read the value, not just set a zero
    IString module, base;
    MappedGlobal() : address(0), type(none), import(false) {}
    MappedGlobal(unsigned address, WasmType type, bool import, IString module, IString base) : address(address), type(type), import(import), module(module), base(base) {}
  };

  // function table
  std::map<IString, int> functionTableStarts; // each asm function table gets a range in the one wasm table, starting at a location
  std::map<CallIndirect*, IString> callIndirects; // track these, as we need to fix them after we know the functionTableStarts. this maps call => its function table

  bool memoryGrowth;
  bool debug;
  bool imprecise;

public:
  std::map<IString, MappedGlobal> mappedGlobals;

  // the global mapping info is not present in the output wasm. We need to save it on the side
  // if we intend to load and run this module's wasm.
  void serializeMappedGlobals(const char *filename) {
    FILE *f = fopen(filename, "w");
    assert(f);
    fprintf(f, "{\n");
    bool first = true;
    for (auto& pair : mappedGlobals) {
      auto name = pair.first;
      auto& global = pair.second;
      if (first) first = false;
      else fprintf(f, ",");
      fprintf(f, "\"%s\": { \"address\": %d, \"type\": %d, \"import\": %d, \"module\": \"%s\", \"base\": \"%s\" }\n",
                 name.str, global.address, global.type, global.import, global.module.str, global.base.str);
    }
    fprintf(f, "}");
    fclose(f);
  }

private:
  void allocateGlobal(IString name, WasmType type, bool import, IString module = IString(), IString base = IString()) {
    assert(mappedGlobals.find(name) == mappedGlobals.end());
    mappedGlobals.emplace(name, MappedGlobal(nextGlobal, type, import, module, base));
    nextGlobal += 8;
    assert(nextGlobal < maxGlobal);
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

  IString llvm_cttz_i32;

  IString tempDoublePtr; // imported name of tempDoublePtr

  // possibly-minified names, detected via their exports
  IString udivmoddi4;
  IString getTempRet0;

  // function types. we fill in this information as we see
  // uses, in the first pass

  std::map<IString, std::unique_ptr<FunctionType>> importedFunctionTypes;
  std::map<IString, std::vector<CallImport*>> importedFunctionCalls;

  void noteImportedFunctionCall(Ref ast, WasmType resultType, AsmData *asmData, CallImport* call) {
    assert(ast[0] == CALL && ast[1][0] == NAME);
    IString importName = ast[1][1]->getIString();
    auto type = make_unique<FunctionType>();
    type->name = IString((std::string("type$") + importName.str).c_str(), false); // TODO: make a list of such types
    type->result = resultType;
    Ref args = ast[2];
    for (unsigned i = 0; i < args->size(); i++) {
      type->params.push_back(detectWasmType(args[i], asmData));
    }
    // if we already saw this signature, verify it's the same (or else handle that)
    if (importedFunctionTypes.find(importName) != importedFunctionTypes.end()) {
      FunctionType* previous = importedFunctionTypes[importName].get();
#if 0
      std::cout << "compare " << importName.str << "\nfirst: ";
      type.print(std::cout, 0);
      std::cout << "\nsecond: ";
      previous.print(std::cout, 0) << ".\n";
#endif
      if (*type != *previous) {
        // merge it in. we'll add on extra 0 parameters for ones not actually used, etc.
        for (size_t i = 0; i < type->params.size(); i++) {
          if (previous->params.size() > i) {
            if (previous->params[i] == none) {
              previous->params[i] = type->params[i]; // use a more concrete type
            }
          } else {
            previous->params.push_back(type->params[i]); // add a new param
          }
        }
        if (previous->result == none) {
          previous->result = type->result; // use a more concrete type
        }
      }
    } else {
      importedFunctionTypes[importName].swap(type);
    }
    importedFunctionCalls[importName].push_back(call);
  }

  FunctionType* getFunctionType(Ref parent, ExpressionList& operands) {
    // generate signature
    WasmType result = !!parent ? detectWasmType(parent, nullptr) : none;
    return ensureFunctionType(getSig(result, operands), &wasm);
  }

public:
 Asm2WasmBuilder(Module& wasm, bool memoryGrowth, bool debug, bool imprecise)
     : wasm(wasm),
       allocator(wasm.allocator),
       builder(wasm),
       nextGlobal(8),
       maxGlobal(1000),
       memoryGrowth(memoryGrowth),
       debug(debug),
       imprecise(imprecise) {}

 void processAsm(Ref ast);
 void optimize();

private:
  AsmType detectAsmType(Ref ast, AsmData *data) {
    if (ast[0] == NAME) {
      IString name = ast[1]->getIString();
      if (!data->isLocal(name)) {
        // must be global
        assert(mappedGlobals.find(name) != mappedGlobals.end());
        return wasmToAsmType(mappedGlobals[name].type);
      }
    } else if (ast[0] == SUB && ast[1][0] == NAME) {
      // could be a heap access, use view info
      auto view = views.find(ast[1][1]->getIString());
      if (view != views.end()) {
        return view->second.type;
      }
    }
    return detectType(ast, data, false, Math_fround);
  }

  WasmType detectWasmType(Ref ast, AsmData *data) {
    return asmToWasmType(detectAsmType(ast, data));
  }

  bool isUnsignedCoercion(Ref ast) {
    return detectSign(ast, Math_fround) == ASM_UNSIGNED;
  }

  BinaryOp parseAsmBinaryOp(IString op, Ref left, Ref right, Expression* leftWasm, Expression* rightWasm) {
    WasmType leftType = leftWasm->type;
    bool isInteger = leftType == WasmType::i32;

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

  Literal checkLiteral(Ref ast) {
    if (ast[0] == NUM) {
      return Literal((int32_t)ast[1]->getInteger());
    } else if (ast[0] == UNARY_PREFIX) {
      if (ast[1] == PLUS && ast[2][0] == NUM) {
        return Literal((double)ast[2][1]->getNumber());
      }
      if (ast[1] == MINUS && ast[2][0] == NUM) {
        double num = -ast[2][1]->getNumber();
        if (isSInteger32(num)) return Literal((int32_t)num);
        if (isUInteger32(num)) return Literal((uint32_t)num);
        assert(false && "expected signed or unsigned int32");
      }
      if (ast[1] == PLUS && ast[2][0] == UNARY_PREFIX && ast[2][1] == MINUS && ast[2][2][0] == NUM) {
        return Literal((double)-ast[2][2][1]->getNumber());
      }
      if (ast[1] == MINUS && ast[2][0] == UNARY_PREFIX && ast[2][1] == PLUS && ast[2][2][0] == NUM) {
        return Literal((double)-ast[2][2][1]->getNumber());
      }
    }
    return Literal();
  }

  Literal getLiteral(Ref ast) {
    Literal ret = checkLiteral(ast);
    if (ret.type == none) abort();
    return ret;
  }

  void fixCallType(Expression* call, WasmType type) {
    if (call->is<Call>()) call->type = type;
    if (call->is<CallImport>()) call->type = type;
    else if (call->is<CallIndirect>()) call->type = type;
  }

  FunctionType* getBuiltinFunctionType(Name module, Name base, ExpressionList* operands = nullptr) {
    if (module == GLOBAL_MATH) {
      if (base == ABS) {
        assert(operands && operands->size() == 1);
        WasmType type = (*operands)[0]->type;
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

  Function* processFunction(Ref ast);
};

void Asm2WasmBuilder::processAsm(Ref ast) {
  assert(ast[0] == TOPLEVEL);
  Ref asmFunction = ast[1][0];
  assert(asmFunction[0] == DEFUN);
  Ref body = asmFunction[3];
  assert(body[0][0] == STAT && body[0][1][0] == STRING && (body[0][1][1]->getIString() == IString("use asm") || body[0][1][1]->getIString() == IString("almost asm")));

  auto addImport = [&](IString name, Ref imported, WasmType type) {
    assert(imported[0] == DOT);
    Ref module = imported[1];
    IString moduleName;
    if (module[0] == DOT) {
      // we can have (global.Math).floor; skip the 'Math'
      assert(module[1][0] == NAME);
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
        }
      }
      std::string fullName = module[1][1]->getCString();
      fullName += '.';
      fullName += + module[2]->getCString();
      moduleName = IString(fullName.c_str(), false);
    } else {
      assert(module[0] == NAME);
      moduleName = module[1]->getIString();
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
    auto import = new Import();
    import->name = name;
    import->module = moduleName;
    import->base = imported[2]->getIString();
    // special-case some asm builtins
    if (import->module == GLOBAL && (import->base == NAN_ || import->base == INFINITY_)) {
      type = WasmType::f64;
    }
    if (type != WasmType::none) {
      // wasm has no imported constants, so allocate a global, and we need to write the value into that
      allocateGlobal(name, type, true, import->module, import->base);
      delete import;
    } else {
      wasm.addImport(import);
    }
  };

  IString Int8Array, Int16Array, Int32Array, UInt8Array, UInt16Array, UInt32Array, Float32Array, Float64Array;

  // first pass - do almost everything, but function imports and indirect calls

  for (unsigned i = 1; i < body->size(); i++) {
    Ref curr = body[i];
    if (curr[0] == VAR) {
      // import, global, or table
      for (unsigned j = 0; j < curr[1]->size(); j++) {
        Ref pair = curr[1][j];
        IString name = pair[0]->getIString();
        Ref value = pair[1];
        if (value[0] == NUM) {
          // global int
          assert(value[1]->getNumber() == 0);
          allocateGlobal(name, WasmType::i32, false);
        } else if (value[0] == BINARY) {
          // int import
          assert(value[1] == OR && value[3][0] == NUM && value[3][1]->getNumber() == 0);
          Ref import = value[2]; // env.what
          addImport(name, import, WasmType::i32);
        } else if (value[0] == UNARY_PREFIX) {
          // double import or global
          assert(value[1] == PLUS);
          Ref import = value[2];
          if (import[0] == NUM) {
            // global
            assert(import[1]->getNumber() == 0);
            allocateGlobal(name, WasmType::f64, false);
          } else {
            // import
            addImport(name, import, WasmType::f64);
          }
        } else if (value[0] == CALL) {
          assert(value[1][0] == NAME && value[1][1] == Math_fround && value[2][0][0] == NUM && value[2][0][1]->getNumber() == 0);
          allocateGlobal(name, WasmType::f32, false);
        } else if (value[0] == DOT) {
          // simple module.base import. can be a view, or a function.
          if (value[1][0] == NAME) {
            IString module = value[1][1]->getIString();
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
          addImport(name, value, WasmType::none);
        } else if (value[0] == NEW) {
          // ignore imports of typed arrays, but note the names of the arrays
          value = value[1];
          assert(value[0] == CALL);
          unsigned bytes;
          bool integer, signed_;
          AsmType asmType;
          Ref constructor = value[1];
          if (constructor[0] == DOT) { // global.*Array
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
            assert(constructor[0] == NAME);
            IString viewName = constructor[1]->getIString();
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
          functionTableStarts[name] = wasm.table.names.size(); // this table starts here
          Ref contents = value[1];
          for (unsigned k = 0; k < contents->size(); k++) {
            IString curr = contents[k][1]->getIString();
            wasm.table.names.push_back(curr);
          }
        } else {
          abort_on("invalid var element", pair);
        }
      }
    } else if (curr[0] == DEFUN) {
      // function
      wasm.addFunction(processFunction(curr));
    } else if (curr[0] == RETURN) {
      // exports
      Ref object = curr[1];
      Ref contents = object[1];
      for (unsigned k = 0; k < contents->size(); k++) {
        Ref pair = contents[k];
        IString key = pair[0]->getIString();
        assert(pair[1][0] == NAME);
        IString value = pair[1][1]->getIString();
        if (key == Name("_emscripten_replace_memory")) {
          // asm.js memory growth provides this special non-asm function, which we don't need (we use grow_memory)
          assert(!wasm.checkFunction(value));
          continue;
        } else if (key == UDIVMODDI4) {
          udivmoddi4 = value;
        } else if (key == GET_TEMP_RET0) {
          getTempRet0 = value;
        }
        assert(wasm.checkFunction(value));
        auto export_ = new Export;
        export_->name = key;
        export_->value = value;
        wasm.addExport(export_);
      }
    }
  }

  // second pass. first, function imports

  std::vector<IString> toErase;

  for (auto& import : wasm.imports) {
    IString name = import->name;
    if (importedFunctionTypes.find(name) != importedFunctionTypes.end()) {
      // special math builtins
      FunctionType* builtin = getBuiltinFunctionType(import->module, import->base);
      if (builtin) {
        import->type = builtin;
        continue;
      }
      import->type = ensureFunctionType(getSig(importedFunctionTypes[name].get()), &wasm);
    } else if (import->module != ASM2WASM) { // special-case the special module
      // never actually used
      toErase.push_back(name);
    }
  }

  for (auto curr : toErase) {
    wasm.removeImport(curr);
  }

  // fill out call_import - add extra params as needed. asm tolerates ffi overloading, wasm does not
  for (auto& pair : importedFunctionCalls) {
    IString name = pair.first;
    auto& list = pair.second;
    auto type = importedFunctionTypes[name].get();
    for (auto* call : list) {
      for (size_t i = call->operands.size(); i < type->params.size(); i++) {
        auto val = allocator.alloc<Const>();
        val->type = val->value.type = type->params[i];
        call->operands.push_back(val);
      }
    }
  }

  // finalize indirect calls

  for (auto& pair : callIndirects) {
    CallIndirect* call = pair.first;
    IString tableName = pair.second;
    assert(functionTableStarts.find(tableName) != functionTableStarts.end());
    auto sub = allocator.alloc<Binary>();
    // note that the target is already masked, so we just offset it, we don't need to guard against overflow (which would be an error anyhow)
    sub->op = AddInt32;
    sub->left = call->target;
    sub->right = builder.makeConst(Literal((int32_t)functionTableStarts[tableName]));
    sub->type = WasmType::i32;
    call->target = sub;
  }

  // apply memory growth, if relevant
  if (memoryGrowth) {
    // create and export a function that just calls memory growth
    Builder builder(wasm);
    wasm.addFunction(builder.makeFunction(
      GROW_WASM_MEMORY,
      { { NEW_SIZE, i32 } },
      none,
      {},
      builder.makeHost(
        GrowMemory,
        Name(),
        { builder.makeGetLocal(0, i32) }
      )
    ));
    auto export_ = new Export;
    export_->name = export_->value = GROW_WASM_MEMORY;
    wasm.addExport(export_);
  }

  wasm.memory.exportName = MEMORY;

#if 0 // enable asm2wasm i64 optimizations when browsers have consistent i64 support in wasm
  if (udivmoddi4.is() && getTempRet0.is()) {
    // generate a wasm-optimized __udivmoddi4 method, which we can do much more efficiently in wasm
    // we can only do this if we know getTempRet0 as well since we use it to figure out which minified global is tempRet0
    // (getTempRet0 might be an import, if this is a shared module, so we can't optimize that case)
    int tempRet0;
    {
      Expression* curr = wasm.getFunction(getTempRet0)->body;
      if (curr->is<Block>()) curr = curr->cast<Block>()->list[0];
      curr = curr->cast<Return>()->value;
      auto* load = curr->cast<Load>();
      auto* ptr = load->ptr->cast<Const>();
      tempRet0 = ptr->value.geti32() + load->offset;
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
    auto recreateI64 = [&](Index target, Index low, Index high) {
      return builder.makeSetLocal(
        target,
        builder.makeBinary(
          Or,
          builder.makeUnary(
            ExtendUInt32,
            builder.makeGetLocal(low, i32)
          ),
          builder.makeBinary(
            Shl,
            builder.makeUnary(
              ExtendUInt32,
              builder.makeGetLocal(high, i32)
            ),
            builder.makeConst(Literal(int64_t(32)))
          )
        )
      );
    };
    body->list.push_back(recreateI64(x64, xl, xh));
    body->list.push_back(recreateI64(y64, yl, yh));
    body->list.push_back(
      builder.makeIf(
        builder.makeGetLocal(r, i32),
        builder.makeStore(
          8, 0, 8,
          builder.makeGetLocal(r, i32),
          builder.makeBinary(
            RemU,
            builder.makeGetLocal(x64, i64),
            builder.makeGetLocal(y64, i64)
          )
        )
      )
    );
    body->list.push_back(
      builder.makeSetLocal(
        x64,
        builder.makeBinary(
          DivU,
          builder.makeGetLocal(x64, i64),
          builder.makeGetLocal(y64, i64)
        )
      )
    );
    body->list.push_back(
      builder.makeStore(
        4, 0, 4,
        builder.makeConst(Literal(int32_t(tempRet0))),
        builder.makeUnary(
          WrapInt64,
          builder.makeBinary(
            ShrU,
            builder.makeGetLocal(x64, i64),
            builder.makeConst(Literal(int64_t(32)))
          )
        )
      )
    );
    body->list.push_back(
      builder.makeUnary(
        WrapInt64,
        builder.makeGetLocal(x64, i64)
      )
    );
    func->body = body;
  }
#endif

  assert(WasmValidator().validate(wasm));
}

Function* Asm2WasmBuilder::processFunction(Ref ast) {
  auto name = ast[1]->getIString();

  if (debug) {
    std::cout << "\nfunc: " << ast[1]->getIString().str << '\n';
    ast->stringify(std::cout);
    std::cout << '\n';
  }

  auto function = new Function;
  function->name = name;
  Ref params = ast[2];
  Ref body = ast[3];

  unsigned nextId = 0;
  auto getNextId = [&nextId](std::string prefix) {
    return IString((prefix + '$' + std::to_string(nextId++)).c_str(), false);
  };

  // given an asm.js label, returns the wasm label for breaks or continues
  auto getBreakLabelName = [](IString label) {
    return IString((std::string("label$break$") + label.str).c_str(), false);
  };
  auto getContinueLabelName = [](IString label) {
    return IString((std::string("label$continue$") + label.str).c_str(), false);
  };

  IStringSet functionVariables; // params or vars

  IString parentLabel; // set in LABEL, then read in WHILE/DO/SWITCH
  std::vector<IString> breakStack; // where a break will go
  std::vector<IString> continueStack; // where a continue will go

  AsmData asmData; // need to know var and param types, for asm type detection

  for (unsigned i = 0; i < params->size(); i++) {
    Ref curr = body[i];
    assert(curr[0] == STAT);
    curr = curr[1];
    assert(curr[0] == ASSIGN && curr[2][0] == NAME);
    IString name = curr[2][1]->getIString();
    AsmType asmType = detectType(curr[3], nullptr, false, Math_fround);
    Builder::addParam(function, name, asmToWasmType(asmType));
    functionVariables.insert(name);
    asmData.addParam(name, asmType);
  }
  unsigned start = params->size();
  while (start < body->size() && body[start][0] == VAR) {
    Ref curr = body[start];
    for (unsigned j = 0; j < curr[1]->size(); j++) {
      Ref pair = curr[1][j];
      IString name = pair[0]->getIString();
      AsmType asmType = detectType(pair[1], nullptr, true, Math_fround);
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

  std::function<Expression* (Ref)> process = [&](Ref ast) -> Expression* {
    AstStackHelper astStackHelper(ast); // TODO: only create one when we need it?
    if (debug) {
      std::cout << "at: ";
      ast->stringify(std::cout);
      std::cout << '\n';
    }
    IString what = ast[0]->getIString();
    if (what == STAT) {
      return process(ast[1]); // and drop return value, if any
    } else if (what == ASSIGN) {
      if (ast[2][0] == NAME) {
        IString name = ast[2][1]->getIString();
        if (functionVariables.has(name)) {
          auto ret = allocator.alloc<SetLocal>();
          ret->index = function->getLocalIndex(ast[2][1]->getIString());
          ret->value = process(ast[3]);
          ret->type = ret->value->type;
          return ret;
        }
        // global var, do a store to memory
        assert(mappedGlobals.find(name) != mappedGlobals.end());
        MappedGlobal global = mappedGlobals[name];
        auto ret = allocator.alloc<Store>();
        ret->bytes = getWasmTypeSize(global.type);
        ret->offset = 0;
        ret->align = ret->bytes;
        ret->ptr = builder.makeConst(Literal(int32_t(global.address)));
        ret->value = process(ast[3]);
        ret->type = global.type;
        return ret;
      } else if (ast[2][0] == SUB) {
        Ref target = ast[2];
        assert(target[1][0] == NAME);
        IString heap = target[1][1]->getIString();
        assert(views.find(heap) != views.end());
        View& view = views[heap];
        auto ret = allocator.alloc<Store>();
        ret->bytes = view.bytes;
        ret->offset = 0;
        ret->align = view.bytes;
        ret->ptr = processUnshifted(target[2], view.bytes);
        ret->value = process(ast[3]);
        ret->type = asmToWasmType(view.type);
        if (ret->type != ret->value->type) {
          // in asm.js we have some implicit coercions that we must do explicitly here
          if (ret->type == f32 && ret->value->type == f64) {
            auto conv = allocator.alloc<Unary>();
            conv->op = DemoteFloat64;
            conv->value = ret->value;
            conv->type = WasmType::f32;
            ret->value = conv;
          } else {
            abort();
          }
        }
        return ret;
      }
      abort_on("confusing assign", ast);
    } else if (what == BINARY) {
      if ((ast[1] == OR || ast[1] == TRSHIFT) && ast[3][0] == NUM && ast[3][1]->getNumber() == 0) {
        auto ret = process(ast[2]); // just look through the ()|0 or ()>>>0 coercion
        fixCallType(ret, i32);
        return ret;
      }
      auto ret = allocator.alloc<Binary>();
      ret->left = process(ast[2]);
      ret->right = process(ast[3]);
      ret->op = parseAsmBinaryOp(ast[1]->getIString(), ast[2], ast[3], ret->left, ret->right);
      ret->finalize();
      if (ret->op == BinaryOp::RemSInt32 && isWasmTypeFloat(ret->type)) {
        // WebAssembly does not have floating-point remainder, we have to emit a call to a special import of ours
        CallImport *call = allocator.alloc<CallImport>();
        call->target = F64_REM;
        call->operands.push_back(ret->left);
        call->operands.push_back(ret->right);
        call->type = f64;
        static bool addedImport = false;
        if (!addedImport) {
          addedImport = true;
          auto import = new Import; // f64-rem = asm2wasm.f64-rem;
          import->name = F64_REM;
          import->module = ASM2WASM;
          import->base = F64_REM;
          import->type = ensureFunctionType("ddd", &wasm);
          wasm.addImport(import);
        }
        return call;
      }
      return ret;
    } else if (what == NUM) {
      auto ret = allocator.alloc<Const>();
      double num = ast[1]->getNumber();
      if (isSInteger32(num)) {
        ret->value = Literal(int32_t(toSInteger32(num)));
      } else if (isUInteger32(num)) {
        ret->value = Literal(uint32_t(toUInteger32(num)));
      } else {
        ret->value = Literal(num);
      }
      ret->type = ret->value.type;
      return ret;
    } else if (what == NAME) {
      IString name = ast[1]->getIString();
      if (functionVariables.has(name)) {
        // var in scope
        auto ret = allocator.alloc<GetLocal>();
        ret->index = function->getLocalIndex(name);
        ret->type = asmToWasmType(asmData.getType(name));
        return ret;
      }
      if (name == DEBUGGER) {
        CallImport *call = allocator.alloc<CallImport>();
        call->target = DEBUGGER;
        call->type = none;
        static bool addedImport = false;
        if (!addedImport) {
          addedImport = true;
          auto import = new Import; // debugger = asm2wasm.debugger;
          import->name = DEBUGGER;
          import->module = ASM2WASM;
          import->base = DEBUGGER;
          import->type = ensureFunctionType("v", &wasm);
          wasm.addImport(import);
        }
        return call;
      }
      // global var, do a load from memory
      assert(mappedGlobals.find(name) != mappedGlobals.end());
      MappedGlobal global = mappedGlobals[name];
      auto ret = allocator.alloc<Load>();
      ret->bytes = getWasmTypeSize(global.type);
      ret->signed_ = true; // but doesn't matter
      ret->offset = 0;
      ret->align = ret->bytes;
      ret->ptr = builder.makeConst(Literal(int32_t(global.address)));
      ret->type = global.type;
      return ret;
    } else if (what == SUB) {
      Ref target = ast[1];
      assert(target[0] == NAME);
      IString heap = target[1]->getIString();
      assert(views.find(heap) != views.end());
      View& view = views[heap];
      auto ret = allocator.alloc<Load>();
      ret->bytes = view.bytes;
      ret->signed_ = view.signed_;
      ret->offset = 0;
      ret->align = view.bytes;
      ret->ptr = processUnshifted(ast[2], view.bytes);
      ret->type = getWasmType(view.bytes, !view.integer);
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
          conv->type = WasmType::f64;
          return conv;
        }
        if (ret->type == f32) {
          auto conv = allocator.alloc<Unary>();
          conv->op = PromoteFloat32;
          conv->value = ret;
          conv->type = WasmType::f64;
          return conv;
        }
        fixCallType(ret, f64);
        return ret;
      } else if (ast[1] == MINUS) {
        if (ast[2][0] == NUM || (ast[2][0] == UNARY_PREFIX && ast[2][1] == PLUS && ast[2][2][0] == NUM)) {
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
          ret->type = WasmType::i32;
          return ret;
        }
        auto ret = allocator.alloc<Unary>();
        ret->value = process(ast[2]);
        if (asmType == ASM_DOUBLE) {
          ret->op = NegFloat64;
          ret->type = WasmType::f64;
        } else if (asmType == ASM_FLOAT) {
          ret->op = NegFloat32;
          ret->type = WasmType::f32;
        } else {
          abort();
        }
        return ret;
      } else if (ast[1] == B_NOT) {
        // ~, might be ~~ as a coercion or just a not
        if (ast[2][0] == UNARY_PREFIX && ast[2][1] == B_NOT) {
          if (imprecise) {
            auto ret = allocator.alloc<Unary>();
            ret->value = process(ast[2][2]);
            ret->op = ret->value->type == f64 ? TruncSFloat64ToInt32 : TruncSFloat32ToInt32; // imprecise, because this wasm thing might trap, while asm.js never would
            ret->type = WasmType::i32;
            return ret;
          } else {
            // WebAssembly traps on float-to-int overflows, but asm.js wouldn't, so we must emulate that
            CallImport *ret = allocator.alloc<CallImport>();
            ret->target = F64_TO_INT;
            auto input = process(ast[2][2]);
            if (input->type == f32) {
              auto conv = allocator.alloc<Unary>();
              conv->op = PromoteFloat32;
              conv->value = input;
              conv->type = WasmType::f64;
              input = conv;
            }
            ret->operands.push_back(input);
            ret->type = i32;
            static bool addedImport = false;
            if (!addedImport) {
              addedImport = true;
              auto import = new Import; // f64-to-int = asm2wasm.f64-to-int;
              import->name = F64_TO_INT;
              import->module = ASM2WASM;
              import->base = F64_TO_INT;
              import->type = ensureFunctionType("id", &wasm);
              wasm.addImport(import);
            }
            return ret;
          }
        }
        // no bitwise unary not, so do xor with -1
        auto ret = allocator.alloc<Binary>();
        ret->op = XorInt32;
        ret->left = process(ast[2]);
        ret->right = builder.makeConst(Literal(int32_t(-1)));
        ret->type = WasmType::i32;
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
      auto ret = allocator.alloc<If>();
      ret->condition = process(ast[1]);
      ret->ifTrue = process(ast[2]);
      ret->ifFalse = !!ast[3] ? process(ast[3]) : nullptr;
      return ret;
    } else if (what == CALL) {
      if (ast[1][0] == NAME) {
        IString name = ast[1][1]->getIString();
        if (name == Math_imul) {
          assert(ast[2]->size() == 2);
          auto ret = allocator.alloc<Binary>();
          ret->op = MulInt32;
          ret->left = process(ast[2][0]);
          ret->right = process(ast[2][1]);
          ret->type = WasmType::i32;
          return ret;
        }
        if (name == Math_clz32 || name == llvm_cttz_i32) {
          assert(ast[2]->size() == 1);
          auto ret = allocator.alloc<Unary>();
          ret->op = name == Math_clz32 ? ClzInt32 : CtzInt32;
          ret->value = process(ast[2][0]);
          ret->type = WasmType::i32;
          return ret;
        }
        if (name == Math_fround) {
          assert(ast[2]->size() == 1);
          Literal lit = checkLiteral(ast[2][0]);
          if (lit.type == i32) {
            return builder.makeConst(Literal((float)lit.geti32()));
          } else if (lit.type == f64) {
            return builder.makeConst(Literal((float)lit.getf64()));
          }
          auto ret = allocator.alloc<Unary>();
          ret->value = process(ast[2][0]);
          if (ret->value->type == f64) {
            ret->op = DemoteFloat64;
          } else if (ret->value->type == i32) {
            ret->op = ConvertSInt32ToFloat32;
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
            set->type = i32;
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
            abort();
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
            abort();
          }
          return ret;
        }
        Expression* ret;
        ExpressionList* operands;
        if (wasm.checkImport(name)) {
          Ref parent = astStackHelper.getParent();
          WasmType type = !!parent ? detectWasmType(parent, &asmData) : none;
          auto specific = allocator.alloc<CallImport>();
          noteImportedFunctionCall(ast, type, &asmData, specific);
          specific->target = name;
          operands = &specific->operands;
          ret = specific;
        } else {
          auto specific = allocator.alloc<Call>();
          specific->target = name;
          operands = &specific->operands;
          ret = specific;
        }
        Ref args = ast[2];
        for (unsigned i = 0; i < args->size(); i++) {
          operands->push_back(process(args[i]));
        }
        return ret;
      }
      // function pointers
      auto ret = allocator.alloc<CallIndirect>();
      Ref target = ast[1];
      assert(target[0] == SUB && target[1][0] == NAME && target[2][0] == BINARY && target[2][1] == AND && target[2][3][0] == NUM); // FUNCTION_TABLE[(expr) & mask]
      ret->target = process(target[2]); // TODO: as an optimization, we could look through the mask
      Ref args = ast[2];
      for (unsigned i = 0; i < args->size(); i++) {
        ret->operands.push_back(process(args[i]));
      }
      ret->fullType = getFunctionType(astStackHelper.getParent(), ret->operands);
      ret->type = ret->fullType->result;
      callIndirects[ret] = target[1][1]->getIString(); // we need to fix this up later, when we know how asm function tables are layed out inside the wasm table.
      return ret;
    } else if (what == RETURN) {
      WasmType type = !!ast[1] ? detectWasmType(ast[1], &asmData) : none;
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
        name = getBreakLabelName(parentLabel);
        parentLabel = IString();
        breakStack.push_back(name);
      }
      auto ret = processStatements(ast[1], 0);
      if (name.is()) {
        breakStack.pop_back();
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
      ret->name = !!ast[1] ? getBreakLabelName(ast[1]->getIString()) : breakStack.back();
      return ret;
    } else if (what == CONTINUE) {
      auto ret = allocator.alloc<Break>();
      assert(continueStack.size() > 0);
      ret->name = !!ast[1] ? getContinueLabelName(ast[1]->getIString()) : continueStack.back();
      return ret;
    } else if (what == WHILE) {
      bool forever = ast[1][0] == NUM && ast[1][1]->getInteger() == 1;
      auto ret = allocator.alloc<Loop>();
      IString out, in;
      if (!parentLabel.isNull()) {
        out = getBreakLabelName(parentLabel);
        in = getContinueLabelName(parentLabel);
        parentLabel = IString();
      } else {
        out = getNextId("while-out");
        in = getNextId("while-in");
      }
      ret->out = out;
      ret->in = in;
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
        auto body = allocator.alloc<Block>();
        body->list.push_back(condition);
        body->list.push_back(process(ast[2]));
        body->finalize();
        ret->body = body;
      }
      // loops do not automatically loop, add a branch back
      Block* block = blockify(ret->body);
      auto continuer = allocator.alloc<Break>();
      continuer->name = ret->in;
      block->list.push_back(continuer);
      ret->body = block;
      continueStack.pop_back();
      breakStack.pop_back();
      return ret;
    } else if (what == DO) {
      if (ast[1][0] == NUM && ast[1][1]->getNumber() == 0) {
        // one-time loop, unless there is a continue
        IString stop;
        if (!parentLabel.isNull()) {
          stop = getBreakLabelName(parentLabel);
          parentLabel = IString();
        } else {
          stop = getNextId("do-once");
        }
        IString more = getNextId("unlikely-continue");
        breakStack.push_back(stop);
        continueStack.push_back(more);
        auto child = process(ast[2]);
        continueStack.pop_back();
        breakStack.pop_back();
        // if we never continued, we don't need a loop
        BreakSeeker breakSeeker(more);
        breakSeeker.walk(child);
        if (breakSeeker.found == 0) {
          auto block = allocator.alloc<Block>();
          block->list.push_back(child);
          block->name = stop;
          block->finalize();
          return block;
        } else {
          auto loop = allocator.alloc<Loop>();
          loop->body = child;
          loop->out = stop;
          loop->in = more;
          return loop;
        }
      }
      // general do-while loop
      auto ret = allocator.alloc<Loop>();
      IString out, in;
      if (!parentLabel.isNull()) {
        out = getBreakLabelName(parentLabel);
        in = getContinueLabelName(parentLabel);
        parentLabel = IString();
      } else {
        out = getNextId("do-out");
        in = getNextId("do-in");
      }
      ret->out = out;
      ret->in = in;
      breakStack.push_back(out);
      continueStack.push_back(in);
      ret->body = process(ast[2]);
      continueStack.pop_back();
      breakStack.pop_back();
      Break *continuer = allocator.alloc<Break>();
      continuer->name = in;
      continuer->condition = process(ast[1]);
      Block *block = blockify(ret->body);
      block->list.push_back(continuer);
      ret->body = block;
      return ret;
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
        out = getNextId("for-out");
        in = getNextId("for-in");
      }
      ret->out = out;
      ret->in = in;
      breakStack.push_back(out);
      continueStack.push_back(in);
      Break *breakOut = allocator.alloc<Break>();
      breakOut->name = out;
      If *condition = allocator.alloc<If>();
      condition->condition = builder.makeUnary(EqZInt32, process(fcond));
      condition->ifTrue = breakOut;
      auto body = allocator.alloc<Block>();
      body->list.push_back(condition);
      body->list.push_back(process(fbody));
      body->list.push_back(process(finc));
      body->finalize();
      ret->body = body;
      // loops do not automatically loop, add a branch back
      Block* block = blockify(ret->body);
      auto continuer = allocator.alloc<Break>();
      continuer->name = ret->in;
      block->list.push_back(continuer);
      ret->body = block;
      continueStack.pop_back();
      breakStack.pop_back();
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
      ret->type = ret->ifTrue->type;
      return ret;
    } else if (what == SEQ) {
      // Some (x, y) patterns can be optimized, like bitcasts,
      //  (HEAP32[tempDoublePtr >> 2] = i, Math_fround(HEAPF32[tempDoublePtr >> 2])); // i32->f32
      //  (HEAP32[tempDoublePtr >> 2] = i, +HEAPF32[tempDoublePtr >> 2]); // i32->f32, no fround
      //  (HEAPF32[tempDoublePtr >> 2] = f, HEAP32[tempDoublePtr >> 2] | 0); // f32->i32
      if (ast[1][0] == ASSIGN && ast[1][2][0] == SUB && ast[1][2][1][0] == NAME && ast[1][2][2][0] == BINARY && ast[1][2][2][1] == RSHIFT &&
          ast[1][2][2][2][0] == NAME && ast[1][2][2][2][1] == tempDoublePtr && ast[1][2][2][3][0] == NUM && ast[1][2][2][3][1]->getNumber() == 2) {
        // (?[tempDoublePtr >> 2] = ?, ?)  so far
        auto heap = ast[1][2][1][1]->getIString();
        if (views.find(heap) != views.end()) {
          AsmType writeType = views[heap].type;
          AsmType readType = ASM_NONE;
          Ref readValue;
          if (ast[2][0] == BINARY && ast[2][1] == OR && ast[2][3][0] == NUM && ast[2][3][1]->getNumber() == 0) {
            readType = ASM_INT;
            readValue = ast[2][2];
          } else if (ast[2][0] == UNARY_PREFIX && ast[2][1] == PLUS) {
            readType = ASM_DOUBLE;
            readValue = ast[2][2];
          } else if (ast[2][0] == CALL && ast[2][1][0] == NAME && ast[2][1][1] == Math_fround) {
            readType = ASM_FLOAT;
            readValue = ast[2][2][0];
          }
          if (readType != ASM_NONE) {
            if (readValue[0] == SUB && readValue[1][0] == NAME && readValue[2][0] == BINARY && readValue[2][1] == RSHIFT &&
                readValue[2][2][0] == NAME && readValue[2][2][1] == tempDoublePtr && readValue[2][3][0] == NUM && readValue[2][3][1]->getNumber() == 2) {
              // pattern looks right!
              Ref writtenValue = ast[1][3];
              if (writeType == ASM_INT && (readType == ASM_FLOAT || readType == ASM_DOUBLE)) {
                auto conv = allocator.alloc<Unary>();
                conv->op = ReinterpretInt32;
                conv->value = process(writtenValue);
                conv->type = WasmType::f32;
                if (readType == ASM_DOUBLE) {
                  auto promote = allocator.alloc<Unary>();
                  promote->op = PromoteFloat32;
                  promote->value = conv;
                  promote->type = WasmType::f64;
                  return promote;
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
                conv->type = WasmType::i32;
                return conv;
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
        name = getNextId("switch");
      }
      breakStack.push_back(name);

      auto br = allocator.alloc<Switch>();
      br->condition = process(ast[1]);
      assert(br->condition->type == i32);

      Ref cases = ast[2];
      bool seen = false;
      int min = 0; // the lowest index we see; we will offset to it
      for (unsigned i = 0; i < cases->size(); i++) {
        Ref curr = cases[i];
        Ref condition = curr[0];
        if (!condition->isNull()) {
          assert(condition[0] == NUM || condition[0] == UNARY_PREFIX);
          int32_t index = getLiteral(condition).geti32();
          if (!seen) {
            seen = true;
            min = index;
          } else {
            if (index < min) min = index;
          }
        }
      }
      Binary* offsetor = allocator.alloc<Binary>();
      offsetor->op = BinaryOp::SubInt32;
      offsetor->left = br->condition;
      offsetor->right = builder.makeConst(Literal(min));
      offsetor->type = i32;
      br->condition = offsetor;

      auto top = allocator.alloc<Block>();
      top->list.push_back(br);
      top->finalize();

      for (unsigned i = 0; i < cases->size(); i++) {
        Ref curr = cases[i];
        Ref condition = curr[0];
        Ref body = curr[1];
        auto case_ = processStatements(body, 0);
        Name name;
        if (condition->isNull()) {
          name = br->default_ = getNextId("switch-default");
        } else {
          assert(condition[0] == NUM || condition[0] == UNARY_PREFIX);
          int32_t index = getLiteral(condition).geti32();
          assert(index >= min);
          index -= min;
          assert(index >= 0);
          size_t index_s = index;
          name = getNextId("switch-case");
          if (br->targets.size() <= index_s) {
            br->targets.resize(index_s+1);
          }
          br->targets[index_s] = name;
        }
        auto next = allocator.alloc<Block>();
        top->name = name;
        next->list.push_back(top);
        next->list.push_back(case_);
        next->finalize();
        top = next;
      }

      // ensure a default
      if (br->default_.isNull()) {
        br->default_ = getNextId("switch-default");
      }
      for (size_t i = 0; i < br->targets.size(); i++) {
        if (br->targets[i].isNull()) br->targets[i] = br->default_;
      }
      top->name = br->default_;

      breakStack.pop_back();

      // Create a topmost block for breaking out of the entire switch
      auto ret = allocator.alloc<Block>();
      ret->name = name;
      ret->list.push_back(top);
      return ret;
    }
    abort_on("confusing expression", ast);
    return (Expression*)nullptr; // avoid warning
  };

  // given HEAP32[addr >> 2], we need an absolute address, and would like to remove that shift.
  // if there is a shift, we can just look through it, etc.
  processUnshifted = [&](Ref ptr, unsigned bytes) {
    auto shifts = bytesToShift(bytes);
    if (ptr[0] == BINARY && ptr[1] == RSHIFT && ptr[3][0] == NUM && ptr[3][1]->getInteger() == shifts) {
      return process(ptr[2]); // look through it
    } else if (ptr[0] == NUM) {
      // constant, apply a shift (e.g. HEAP32[1] is address 4)
      unsigned addr = ptr[1]->getInteger();
      unsigned shifted = addr << shifts;
      return (Expression*)builder.makeConst(Literal(int32_t(shifted)));
    }
    abort_on("bad processUnshifted", ptr);
    return (Expression*)nullptr; // avoid warning
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

void Asm2WasmBuilder::optimize() {
  PassRunner passRunner(&wasm);
  passRunner.addDefaultOptimizationPasses();
  if (maxGlobal < 1024) {
    passRunner.add("post-emscripten");
  }
  passRunner.run();

  assert(WasmValidator().validate(wasm));
}

} // namespace wasm

#endif // wasm_asm2wasm_h
