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
#include "asm_v_wasm.h"
#include "pass.h"

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
  AllocatingModule& wasm;

  MixedArena &allocator;

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
  int debug;

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
  IString Math_sqrt;

  // function types. we fill in this information as we see
  // uses, in the first pass

  std::map<IString, FunctionType> importedFunctionTypes;

  void noteImportedFunctionCall(Ref ast, WasmType resultType, AsmData *asmData) {
    assert(ast[0] == CALL && ast[1][0] == NAME);
    IString importName = ast[1][1]->getIString();
    FunctionType type;
    type.name = IString((std::string("type$") + importName.str).c_str(), false); // TODO: make a list of such types
    type.result = resultType;
    Ref args = ast[2];
    for (unsigned i = 0; i < args->size(); i++) {
      type.params.push_back(detectWasmType(args[i], asmData));
    }
    // if we already saw this signature, verify it's the same (or else handle that)
    if (importedFunctionTypes.find(importName) != importedFunctionTypes.end()) {
      FunctionType& previous = importedFunctionTypes[importName];
#if 0
      std::cout << "compare " << importName.str << "\nfirst: ";
      type.print(std::cout, 0);
      std::cout << "\nsecond: ";
      previous.print(std::cout, 0) << ".\n";
#endif
      if (type != previous) {
        // merge it in. we'll add on extra 0 parameters for ones not actually used, etc.
        for (size_t i = 0; i < type.params.size(); i++) {
          if (previous.params.size() > i) {
            if (previous.params[i] == none) {
              previous.params[i] = type.params[i]; // use a more concrete type
            }
          } else {
            previous.params.push_back(type.params[i]); // add a new param
          }
        }
        if (previous.result == none) {
          previous.result = type.result; // use a more concrete type
        }
      }
    } else {
      importedFunctionTypes[importName] = type;
    }
  }

  FunctionType* getFunctionType(Ref parent, ExpressionList& operands) {
    // generate signature
    WasmType result = !!parent ? detectWasmType(parent, nullptr) : none;
    return ensureFunctionType(getSig(result, operands), &wasm, allocator);
  }

public:
 Asm2WasmBuilder(AllocatingModule& wasm, bool memoryGrowth, int debug)
     : wasm(wasm),
       allocator(wasm.allocator),
       nextGlobal(8),
       maxGlobal(1000),
       memoryGrowth(memoryGrowth),
       debug(debug) {}

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

  BinaryOp parseAsmBinaryOp(IString op, Ref left, Ref right, AsmData *asmData) {
    if (op == PLUS) return BinaryOp::Add;
    if (op == MINUS) return BinaryOp::Sub;
    if (op == MUL) return BinaryOp::Mul;
    if (op == AND) return BinaryOp::And;
    if (op == OR) return BinaryOp::Or;
    if (op == XOR) return BinaryOp::Xor;
    if (op == LSHIFT) return BinaryOp::Shl;
    if (op == RSHIFT) return BinaryOp::ShrS;
    if (op == TRSHIFT) return BinaryOp::ShrU;
    if (op == EQ) return BinaryOp::Eq;
    if (op == NE) return BinaryOp::Ne;
    WasmType leftType = detectWasmType(left, asmData);
#if 0
    std::cout << "CHECK\n";
    left->stringify(std::cout);
    std::cout << " => " << printWasmType(leftType);
    std::cout << '\n';
    right->stringify(std::cout);
    std::cout << " => " << printWasmType(detectWasmType(right, asmData)) << "\n";
#endif
    bool isInteger = leftType == WasmType::i32;
    bool isUnsigned = isUnsignedCoercion(left) || isUnsignedCoercion(right);
    if (op == DIV) {
      if (isInteger) {
        return isUnsigned ? BinaryOp::DivU : BinaryOp::DivS;
      }
      return BinaryOp::Div;
    }
    if (op == MOD) {
      if (isInteger) {
        return isUnsigned ? BinaryOp::RemU : BinaryOp::RemS;
      }
      return BinaryOp::RemS; // XXX no floating-point remainder op, this must be handled by the caller
    }
    if (op == GE) {
      if (isInteger) {
        return isUnsigned ? BinaryOp::GeU : BinaryOp::GeS;
      }
      return BinaryOp::Ge;
    }
    if (op == GT) {
      if (isInteger) {
        return isUnsigned ? BinaryOp::GtU : BinaryOp::GtS;
      }
      return BinaryOp::Gt;
    }
    if (op == LE) {
      if (isInteger) {
        return isUnsigned ? BinaryOp::LeU : BinaryOp::LeS;
      }
      return BinaryOp::Le;
    }
    if (op == LT) {
      if (isInteger) {
        return isUnsigned ? BinaryOp::LtU : BinaryOp::LtS;
      }
      return BinaryOp::Lt;
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
        if (type == i32) return ensureFunctionType("ii", &wasm, allocator);
        if (type == f32) return ensureFunctionType("ff", &wasm, allocator);
        if (type == f64) return ensureFunctionType("dd", &wasm, allocator);
      }
    }
    return nullptr;
  }

  Block* blockify(Expression* expression) {
    if (expression->is<Block>()) return expression->dyn_cast<Block>();
    auto ret = allocator.alloc<Block>();
    ret->list.push_back(expression);
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
    }
    auto import = allocator.alloc<Import>();
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
        Ref value = pair[1];
        assert(value[0] == NAME);
        auto export_ = allocator.alloc<Export>();
        export_->name = key;
        export_->value = value[1]->getIString();
        wasm.addExport(export_);
      }
    }
  }

  // second pass. first, function imports

  std::vector<IString> toErase;

  for (auto& pair : wasm.importsMap) {
    IString name = pair.first;
    Import& import = *pair.second;
    if (importedFunctionTypes.find(name) != importedFunctionTypes.end()) {
      // special math builtins
      FunctionType* builtin = getBuiltinFunctionType(import.module, import.base);
      if (builtin) {
        import.type = builtin;
        continue;
      }
      import.type = ensureFunctionType(getSig(&importedFunctionTypes[name]), &wasm, allocator);
    } else if (import.module != ASM2WASM) { // special-case the special module
      // never actually used
      toErase.push_back(name);
    }
  }

  for (auto curr : toErase) {
    wasm.removeImport(curr);
  }

  // finalize indirect calls

  for (auto& pair : callIndirects) {
    CallIndirect* call = pair.first;
    IString tableName = pair.second;
    assert(functionTableStarts.find(tableName) != functionTableStarts.end());
    auto sub = allocator.alloc<Binary>();
    // note that the target is already masked, so we just offset it, we don't need to guard against overflow (which would be an error anyhow)
    sub->op = Add;
    sub->left = call->target;
    sub->right = allocator.alloc<Const>()->set(Literal((int32_t)functionTableStarts[tableName]));
    sub->type = WasmType::i32;
    call->target = sub;
  }

  // apply memory growth, if relevant
  if (memoryGrowth) {
    // create and export a function that just calls memory growth
    auto growWasmMemory = allocator.alloc<Function>();
    growWasmMemory->name = GROW_WASM_MEMORY;
    growWasmMemory->params.emplace_back(NEW_SIZE, i32); // the new size
    auto get = allocator.alloc<GetLocal>();
    get->name = NEW_SIZE;
    auto grow = allocator.alloc<Host>();
    grow->op = GrowMemory;
    grow->operands.push_back(get);
    growWasmMemory->body = grow;
    wasm.addFunction(growWasmMemory);
    auto export_ = allocator.alloc<Export>();
    export_->name = export_->value = GROW_WASM_MEMORY;
    wasm.addExport(export_);
  }

}

Function* Asm2WasmBuilder::processFunction(Ref ast) {
  //if (ast[1] != IString("qta")) return nullptr;

  if (debug) {
    std::cout << "\nfunc: " << ast[1]->getIString().str << '\n';
    if (debug >= 2) {
      ast->stringify(std::cout);
      std::cout << '\n';
    }
  }

  auto function = allocator.alloc<Function>();
  function->name = ast[1]->getIString();
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

  IStringSet functionVariables; // params or locals 

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
    function->params.emplace_back(name, asmToWasmType(asmType));
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
      function->locals.emplace_back(name, asmToWasmType(asmType));
      functionVariables.insert(name);
      asmData.addVar(name, asmType);
    }
    start++;
  }

  bool addedI32Temp = false;
  auto ensureI32Temp = [&]() {
    if (addedI32Temp) return;
    addedI32Temp = true;
    function->locals.emplace_back(I32_TEMP, i32);
    functionVariables.insert(I32_TEMP);
    asmData.addVar(I32_TEMP, ASM_INT);
  };

  bool seenReturn = false; // function->result is updated if we see a return
  bool needTopmost = false; // we label the topmost b lock if we need one for a return
  // processors
  std::function<Expression* (Ref, unsigned)> processStatements;
  std::function<Expression* (Ref, unsigned)> processUnshifted;

  std::function<Expression* (Ref)> process = [&](Ref ast) -> Expression* {
    AstStackHelper astStackHelper(ast); // TODO: only create one when we need it?
    if (debug >= 2) {
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
          ret->name = ast[2][1]->getIString();
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
        auto ptr = allocator.alloc<Const>();
        ptr->value.type = WasmType::i32; // XXX for wasm64, need 64
        ptr->value.i32 = global.address;
        ret->ptr = ptr;
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
      BinaryOp binary = parseAsmBinaryOp(ast[1]->getIString(), ast[2], ast[3], &asmData);
      auto ret = allocator.alloc<Binary>();
      ret->op = binary;
      ret->left = process(ast[2]);
      ret->right = process(ast[3]);
      ret->finalize();
      if (binary == BinaryOp::RemS && isWasmTypeFloat(ret->type)) {
        // WebAssembly does not have floating-point remainder, we have to emit a call to a special import of ours
        CallImport *call = allocator.alloc<CallImport>();
        call->target = F64_REM;
        call->operands.push_back(ret->left);
        call->operands.push_back(ret->right);
        call->type = f64;
        static bool addedImport = false;
        if (!addedImport) {
          addedImport = true;
          auto import = allocator.alloc<Import>(); // f64-rem = asm2wasm.f64-rem;
          import->name = F64_REM;
          import->module = ASM2WASM;
          import->base = F64_REM;
          import->type = ensureFunctionType("ddd", &wasm, allocator);
          wasm.addImport(import);
        }
        return call;
      }
      return ret;
    } else if (what == NUM) {
      auto ret = allocator.alloc<Const>();
      double num = ast[1]->getNumber();
      if (isSInteger32(num)) {
        ret->value.type = WasmType::i32;
        ret->value.i32 = toSInteger32(num);
      } else if (isUInteger32(num)) {
        ret->value.type = WasmType::i32;
        ret->value.i32 = toUInteger32(num);
      } else {
        ret->value.type = WasmType::f64;
        ret->value.f64 = num;
      }
      ret->type = ret->value.type;
      return ret;
    } else if (what == NAME) {
      IString name = ast[1]->getIString();
      if (functionVariables.has(name)) {
        // var in scope
        auto ret = allocator.alloc<GetLocal>();
        ret->name = name;
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
          auto import = allocator.alloc<Import>(); // debugger = asm2wasm.debugger;
          import->name = DEBUGGER;
          import->module = ASM2WASM;
          import->base = DEBUGGER;
          import->type = ensureFunctionType("v", &wasm, allocator);
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
      auto ptr = allocator.alloc<Const>();
      ptr->value.type = WasmType::i32; // XXX for wasm64, need 64
      ptr->value.i32 = global.address;
      ret->ptr = ptr;
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
          return allocator.alloc<Const>()->set(literal);
        }
        auto ret = process(ast[2]); // we are a +() coercion
        if (ret->type == i32) {
          auto conv = allocator.alloc<Unary>();
          conv->op = isUnsignedCoercion(ast[2]) ? ConvertUInt32 : ConvertSInt32;
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
          ret->op = Sub;
          ret->left = allocator.alloc<Const>()->set(Literal((int32_t)0));
          ret->right = process(ast[2]);
          ret->type = WasmType::i32;
          return ret;
        }
        auto ret = allocator.alloc<Unary>();
        ret->op = Neg;
        ret->value = process(ast[2]);
        if (asmType == ASM_DOUBLE) {
          ret->type = WasmType::f64;
        } else if (asmType == ASM_FLOAT) {
          ret->type = WasmType::f32;
        } else {
          abort();
        }
        return ret;
      } else if (ast[1] == B_NOT) {
        // ~, might be ~~ as a coercion or just a not
        if (ast[2][0] == UNARY_PREFIX && ast[2][1] == B_NOT) {
#if 0
          auto ret = allocator.alloc<Unary>();
          ret->op = TruncSFloat64; // equivalent to U, except for error handling, which asm.js doesn't have anyhow
          ret->value = process(ast[2][2]);
          ret->type = WasmType::i32;
          return ret;
#endif
          // WebAssembly traps on float-to-int overflows, but asm.js wouldn't, so we must emulate that
          CallImport *ret = allocator.alloc<CallImport>();
          ret->target = F64_TO_INT;
          ret->operands.push_back(process(ast[2][2]));
          ret->type = i32;
          static bool addedImport = false;
          if (!addedImport) {
            addedImport = true;
            auto import = allocator.alloc<Import>(); // f64-to-int = asm2wasm.f64-to-int;
            import->name = F64_TO_INT;
            import->module = ASM2WASM;
            import->base = F64_TO_INT;
            import->type = ensureFunctionType("id", &wasm, allocator);
            wasm.addImport(import);
          }
          return ret;
        }
        // no bitwise unary not, so do xor with -1
        auto ret = allocator.alloc<Binary>();
        ret->op = Xor;
        ret->left = process(ast[2]);
        ret->right = allocator.alloc<Const>()->set(Literal(int32_t(-1)));
        ret->type = WasmType::i32;
        return ret;
      } else if (ast[1] == L_NOT) {
        // no logical unary not, so do == 0
        auto ret = allocator.alloc<Binary>();
        ret->op = Eq;
        ret->left = process(ast[2]);
        ret->right = allocator.alloc<Const>()->set(Literal(0));
        assert(ret->left->type == ret->right->type);
        ret->finalize();
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
          ret->op = Mul;
          ret->left = process(ast[2][0]);
          ret->right = process(ast[2][1]);
          ret->type = WasmType::i32;
          return ret;
        }
        if (name == Math_clz32) {
          assert(ast[2]->size() == 1);
          auto ret = allocator.alloc<Unary>();
          ret->op = Clz;
          ret->value = process(ast[2][0]);
          ret->type = WasmType::i32;
          return ret;
        }
        if (name == Math_fround) {
          assert(ast[2]->size() == 1);
          Literal lit = checkLiteral(ast[2][0]);
          if (lit.type == i32) {
            return allocator.alloc<Const>()->set(Literal((float)lit.geti32()));
          } else if (lit.type == f64) {
            return allocator.alloc<Const>()->set(Literal((float)lit.getf64()));
          }
          auto ret = allocator.alloc<Unary>();
          ret->value = process(ast[2][0]);
          if (ret->value->type == f64) {
            ret->op = DemoteFloat64;
          } else if (ret->value->type == i32) {
            ret->op = ConvertSInt32;
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
            set->name = I32_TEMP;
            set->value = value;
            set->type = i32;
            auto get = [&]() {
              auto ret = allocator.alloc<GetLocal>();
              ret->name = I32_TEMP;
              ret->type = i32;
              return ret;
            };
            auto isNegative = allocator.alloc<Binary>();
            isNegative->op = LtS;
            isNegative->left = get();
            isNegative->right = allocator.alloc<Const>()->set(0);
            isNegative->finalize();
            auto block = allocator.alloc<Block>();
            block->list.push_back(set);
            auto flip = allocator.alloc<Binary>();
            flip->op = Sub;
            flip->left = allocator.alloc<Const>()->set(0);
            flip->right = get();
            flip->type = i32;
            auto select = allocator.alloc<Select>();
            select->condition = isNegative;
            select->ifTrue = flip;
            select->ifFalse = get();
            select->type = i32;
            block->list.push_back(select);
            block->type = i32;
            return block;
          } else if (value->type == f32 || value->type == f64) {
            auto ret = allocator.alloc<Unary>();
            ret->op = Abs;
            ret->value = value;
            ret->type = value->type;
            return ret;
          } else {
            abort();
          }
        }
        if (name == Math_floor || name == Math_sqrt) {
          // overloaded on type: f32 or f64
          Expression* value = process(ast[2][0]);
          if (value->type == f32 || value->type == f64) {
            auto ret = allocator.alloc<Unary>();
            ret->op = name == Math_floor ? Floor : Sqrt;
            ret->value = value;
            ret->type = value->type;
            return ret;
          } else {
            abort();
          }
        }
        Call* ret;
        if (wasm.importsMap.find(name) != wasm.importsMap.end()) {
          Ref parent = astStackHelper.getParent();
          WasmType type = !!parent ? detectWasmType(parent, &asmData) : none;
          ret = allocator.alloc<CallImport>();
          noteImportedFunctionCall(ast, type, &asmData);
        } else {
          ret = allocator.alloc<Call>();
        }
        ret->target = name;
        Ref args = ast[2];
        for (unsigned i = 0; i < args->size(); i++) {
          ret->operands.push_back(process(args[i]));
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
      needTopmost = true;
      auto ret = allocator.alloc<Break>();
      ret->name = TOPMOST;
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
        Block* block = ret->dyn_cast<Block>();
        if (block && block->name.isNull()) {
          block->name = name;
        } else {
          block = allocator.alloc<Block>();
          block->name = name;
          block->list.push_back(ret);
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
        condition->condition = process(ast[1]);
        condition->ifTrue = allocator.alloc<Nop>();
        condition->ifFalse = breakOut;
        auto body = allocator.alloc<Block>();
        body->list.push_back(condition);
        body->list.push_back(process(ast[2]));
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
        // one-time loop
        auto block = allocator.alloc<Block>();
        IString stop;
        if (!parentLabel.isNull()) {
          stop = getBreakLabelName(parentLabel);
          parentLabel = IString();
        } else {
          stop = getNextId("do-once");
        }
        block->name = stop;
        breakStack.push_back(stop);
        continueStack.push_back(IMPOSSIBLE_CONTINUE);
        block->list.push_back(process(ast[2]));
        continueStack.pop_back();
        breakStack.pop_back();
        return block;
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
      condition->condition = process(fcond);
      condition->ifTrue = allocator.alloc<Nop>();
      condition->ifFalse = breakOut;
      auto body = allocator.alloc<Block>();
      body->list.push_back(condition);
      body->list.push_back(process(fbody));
      body->list.push_back(process(finc));
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
      auto ret = allocator.alloc<Block>();
      ret->list.push_back(process(ast[1]));
      ret->list.push_back(process(ast[2]));
      ret->type = ret->list[1]->type;
      return ret;
    } else if (what == SWITCH) {
      IString name;
      if (!parentLabel.isNull()) {
        name = getBreakLabelName(parentLabel);
        parentLabel = IString();
      } else {
        name = getNextId("switch");
      }
      breakStack.push_back(name);
      auto ret = allocator.alloc<Switch>();
      ret->name = name;
      ret->value = process(ast[1]);
      assert(ret->value->type == i32);
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
      offsetor->op = BinaryOp::Sub;
      offsetor->left = ret->value;
      offsetor->right = allocator.alloc<Const>()->set(Literal(min));
      offsetor->type = i32;
      ret->value = offsetor;
      for (unsigned i = 0; i < cases->size(); i++) {
        Ref curr = cases[i];
        Ref condition = curr[0];
        Ref body = curr[1];
        Switch::Case case_;
        case_.body = processStatements(body, 0);
        if (condition->isNull()) {
          case_.name = ret->default_ = getNextId("switch-default");
        } else {
          assert(condition[0] == NUM || condition[0] == UNARY_PREFIX);
          int32_t index = getLiteral(condition).geti32();
          assert(index >= min);
          index -= min;
          assert(index >= 0);
          size_t index_s = index;
          case_.name = getNextId("switch-case");
          if (ret->targets.size() <= index_s) {
            ret->targets.resize(index_s+1);
          }
          ret->targets[index_s] = case_.name;
        }
        ret->cases.push_back(case_);
      }
      // ensure a default
      if (ret->default_.isNull()) {
        Switch::Case defaultCase;
        defaultCase.name = ret->default_ = getNextId("switch-default");
        defaultCase.body = allocator.alloc<Nop>(); // ok if others fall through to this
        ret->cases.push_back(defaultCase);
      }
      for (size_t i = 0; i < ret->targets.size(); i++) {
        if (ret->targets[i].isNull()) ret->targets[i] = ret->default_;
      }
      // finalize
      breakStack.pop_back();
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
      auto ret = allocator.alloc<Const>();
      ret->value.type = WasmType::i32;
      ret->value.i32 = shifted;
      return (Expression*)ret;
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
    return block;
  };
  // body
  function->body = processStatements(body, start);
  if (needTopmost) {
    Block* topmost = function->body->dyn_cast<Block>();
    // if there's no block there, or there is a block but it already has a name, we need a new block.
    if (!topmost || topmost->name.is()) {
      topmost = allocator.alloc<Block>();
      topmost->list.push_back(function->body);
      function->body = topmost;
    }
    topmost->name = TOPMOST;
  }
  // cleanups/checks
  assert(breakStack.size() == 0 && continueStack.size() == 0);
  assert(parentLabel.isNull());

  return function;
}

void Asm2WasmBuilder::optimize() {
  // Optimization passes. Note: no effort is made to free nodes that are no longer held on to.

  struct BlockBreakOptimizer : public WasmWalker<BlockBreakOptimizer> {
    void visitBlock(Block *curr) {
      // if the block ends in a break on this very block, then just put the value there
      Break *last = curr->list[curr->list.size()-1]->dyn_cast<Break>();
      if (last && last->value && last->name == curr->name) {
        curr->list[curr->list.size()-1] = last->value;
      }
      if (curr->list.size() > 1) return; // no hope to remove the block
      // just one element; maybe we can return just the element
      if (curr->name.isNull()) {
        replaceCurrent(curr->list[0]); // cannot break into it
        return;
      }
      // we might be broken to, but maybe there isn't a break (and we may have removed it, leading to this)

      struct BreakSeeker : public WasmWalker<BreakSeeker> {
        IString target; // look for this one
        size_t found;

        BreakSeeker(IString target) : target(target), found(false) {}

        void visitBreak(Break *curr) {
          if (curr->name == target) found++;
        }
      };

      // look for any breaks to this block
      BreakSeeker breakSeeker(curr->name);
      Expression *child = curr->list[0];
      breakSeeker.walk(child);
      if (breakSeeker.found == 0) {
        replaceCurrent(child); // no breaks to here, so eliminate the block
      }
    }
  };

  BlockBreakOptimizer blockBreakOptimizer;
  for (auto pair : wasm.functionsMap) {
    blockBreakOptimizer.startWalk(pair.second);
  }

  // Standard passes

  PassRunner passRunner(&allocator);
  passRunner.add("remove-unused-brs");
  passRunner.add("remove-unused-names");
  passRunner.add("merge-blocks");
  passRunner.add("simplify-locals");
  passRunner.run(&wasm);
}

} // namespace wasm

#endif // wasm_asm2wasm_h
