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
// WebAssembly-to-JS code translator. Converts wasm functions into
// valid JavaScript (with a somewhat asm.js-ish flavor).
//

#ifndef wasm_wasm2js_h
#define wasm_wasm2js_h

#include <cmath>
#include <numeric>

#include "asmjs/shared-constants.h"
#include "asmjs/asmangle.h"
#include "wasm.h"
#include "wasm-builder.h"
#include "wasm-io.h"
#include "wasm-validator.h"
#include "emscripten-optimizer/optimizer.h"
#include "mixed_arena.h"
#include "asm_v_wasm.h"
#include "abi/js.h"
#include "ir/find_all.h"
#include "ir/import-utils.h"
#include "ir/load-utils.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/table-utils.h"
#include "ir/utils.h"
#include "passes/passes.h"
#include "support/base64.h"

namespace wasm {

using namespace cashew;

IString ASM_FUNC("asmFunc"),
        ABORT_FUNC("abort"),
        FUNCTION_TABLE("FUNCTION_TABLE"),
        NO_RESULT("wasm2js$noresult"), // no result at all
        EXPRESSION_RESULT("wasm2js$expresult"); // result in an expression, no temp var

// Appends extra to block, flattening out if extra is a block as well
void flattenAppend(Ref ast, Ref extra) {
  int index;
  if (ast[0] == BLOCK || ast[0] == TOPLEVEL) index = 1;
  else if (ast[0] == DEFUN) index = 3;
  else abort();
  if (extra->isArray() && extra[0] == BLOCK) {
    for (size_t i = 0; i < extra[1]->size(); i++) {
      ast[index]->push_back(extra[1][i]);
    }
  } else {
    ast[index]->push_back(extra);
  }
}

// Appends extra to a chain of sequence elements
void sequenceAppend(Ref& ast, Ref extra) {
  if (!ast.get()) {
    ast = extra;
    return;
  }
  ast = ValueBuilder::makeSeq(ast, extra);
}

// Used when taking a wasm name and generating a JS identifier. Each scope here
// is used to ensure that all names have a unique name but the same wasm name
// within a scope always resolves to the same symbol.
enum class NameScope {
  Top,
  Local,
  Label,
  Max,
};

template<typename T>
static uint64_t constOffset(const T& segment) {
  auto* c = segment.offset->template dynCast<Const>();
  if (!c) {
    Fatal() << "non-constant offsets aren't supported yet\n";
    abort();
  }
  return c->value.getInteger();
}

//
// Wasm2JSBuilder - converts a WebAssembly module's functions into JS
//
// In general, JS (asm.js) => wasm is very straightforward, as can
// be seen in asm2wasm.h. Just a single pass, plus a little
// state bookkeeping (breakStack, etc.), and a few after-the
// fact corrections for imports, etc. However, wasm => JS
// is tricky because wasm has statements == expressions, or in
// other words, things like `break` and `if` can show up
// in places where JS can't handle them, like inside an
// a loop's condition check. For that reason we use flat IR here.
// We do optimize it later, to allow some nesting, but we avoid
// non-JS-compatible nesting like block return values control
// flow in an if condition, etc.
//

class Wasm2JSBuilder {
  MixedArena allocator;

public:
  struct Flags {
    bool debug = false;
    bool pedantic = false;
    bool allowAsserts = false;
    bool emscripten = false;
  };

  Wasm2JSBuilder(Flags f) : flags(f) {}

  Ref processWasm(Module* wasm, Name funcName = ASM_FUNC);
  Ref processFunction(Module* wasm, Function* func, bool standalone=false);
  Ref processStandaloneFunction(Module* wasm, Function* func) {
    return processFunction(wasm, func, true);
  }

  // The second pass on an expression: process it fully, generating
  // JS
  Ref processFunctionBody(Module* m, Function* func);

  // Get a temp var.
  IString getTemp(Type type, Function* func) {
    IString ret;
    if (frees[type].size() > 0) {
      ret = frees[type].back();
      frees[type].pop_back();
    } else {
      size_t index = temps[type]++;
      ret = IString((std::string("wasm2js_") + printType(type) + "$" +
                     std::to_string(index)).c_str(), false);
    }
    if (func->localIndices.find(ret) == func->localIndices.end()) {
      Builder::addVar(func, ret, type);
    }
    return ret;
  }

  // Free a temp var.
  void freeTemp(Type type, IString temp) {
    frees[type].push_back(temp);
  }

  // Generates a mangled name from `name` within the specified scope.
  //
  // The goal of this function is to ensure that all identifiers in JS ar
  // unique. Otherwise there can be clashes with locals and functions and cause
  // unwanted name shadowing.
  //
  // The returned string from this function is constant for a particular `name`
  // within a `scope`. Or in other words, the same `name` and `scope` pair will
  // always return the same result. If `scope` changes, however, the return
  // value may differ even if the same `name` is passed in.
  IString fromName(Name name, NameScope scope) {
    // TODO: checking names do not collide after mangling

    // First up check our cached of mangled names to avoid doing extra work
    // below
    auto &mangledScope = mangledNames[(int) scope];
    auto it = mangledScope.find(name.c_str());
    if (it != mangledScope.end()) {
      return it->second;
    }

    // This is the first time we've seen the `name` and `scope` pair. Generate a
    // globally unique name based on `name` and then register that in our cache
    // and return it.
    //
    // Identifiers here generated are of the form `${name}_${n}` where `_${n}`
    // is omitted if `n==0` and otherwise `n` is just looped over to find the
    // next unused identifier.
    IString ret;
    for (int i = 0;; i++) {
      std::ostringstream out;
      out << name.c_str();
      if (i > 0) {
        out << "_" << i;
      }
      auto mangled = asmangle(out.str());
      ret = IString(mangled.c_str(), false);
      if (!allMangledNames.count(ret)) {
        break;
      }

      // In the global scope that's how you refer to actual function exports, so
      // it's a bug currently if they're not globally unique. This should
      // probably be fixed via a different namespace for exports or something
      // like that.
      // XXX This is not actually a valid check atm, since functions are not in the
      //     global-most scope, but rather in the "asmFunc" scope which is inside it.
      //     Also, for emscripten style glue, we emit the exports as a return, so there
      //     is no name placed into the scope. For these reasons, just warn here, don't
      //     error.
      if (scope == NameScope::Top) {
        std::cerr << "wasm2js: warning: global scope may be colliding with other scope: " << mangled << '\n';
      }
    }
    allMangledNames.insert(ret);
    mangledScope[name.c_str()] = ret;
    return ret;
  }

  size_t getTableSize() {
    return tableSize;
  }

private:
  Flags flags;

  // How many temp vars we need
  std::vector<size_t> temps; // type => num temps
  // Which are currently free to use
  std::vector<std::vector<IString>> frees; // type => list of free names

  // Mangled names cache by interned names.
  // Utilizes the usually reused underlying cstring's pointer as the key.
  std::unordered_map<const char*, IString> mangledNames[(int) NameScope::Max];
  std::unordered_set<IString> allMangledNames;

  size_t tableSize;

  void addBasics(Ref ast);
  void addFunctionImport(Ref ast, Function* import);
  void addGlobalImport(Ref ast, Global* import);
  void addTable(Ref ast, Module* wasm);
  void addExports(Ref ast, Module* wasm);
  void addGlobal(Ref ast, Global* global);
  void addMemoryGrowthFuncs(Ref ast, Module* wasm);

  Wasm2JSBuilder() = delete;
  Wasm2JSBuilder(const Wasm2JSBuilder &) = delete;
  Wasm2JSBuilder &operator=(const Wasm2JSBuilder&) = delete;
};

Ref Wasm2JSBuilder::processWasm(Module* wasm, Name funcName) {
  // Ensure the scratch memory helpers.
  // If later on they aren't needed, we'll clean them up.
  ABI::wasm2js::ensureScratchMemoryHelpers(wasm);

  PassRunner runner(wasm);
  runner.add<AutoDrop>();
  runner.add("legalize-js-interface");
  // First up remove as many non-JS operations we can, including things like
  // 64-bit integer multiplication/division, `f32.nearest` instructions, etc.
  // This may inject intrinsics which use i64 so it needs to be run before the
  // i64-to-i32 lowering pass.
  runner.add("remove-non-js-ops");
  // Currently the i64-to-32 lowering pass requires that `flatten` be run before
  // it to produce correct code. For some more details about this see #1480
  runner.add("flatten");
  runner.add("i64-to-i32-lowering");
  runner.add("flatten");
  runner.add("simplify-locals-notee-nostructure");
  runner.add("reorder-locals");
  runner.add("vacuum");
  runner.add("remove-unused-module-elements");
  runner.setDebug(flags.debug);
  runner.run();

  // Make sure we didn't corrupt anything if we're in --allow-asserts mode (aka
  // tests)
#ifndef NDEBUG
  if (!WasmValidator().validate(*wasm)) {
    WasmPrinter::printModule(wasm);
    Fatal() << "error in validating wasm2js output";
  }
#endif

  Ref ret = ValueBuilder::makeToplevel();
  Ref asmFunc = ValueBuilder::makeFunction(funcName);
  ret[1]->push_back(asmFunc);
  ValueBuilder::appendArgumentToFunction(asmFunc, GLOBAL);
  ValueBuilder::appendArgumentToFunction(asmFunc, ENV);
  ValueBuilder::appendArgumentToFunction(asmFunc, BUFFER);
  asmFunc[3]->push_back(ValueBuilder::makeStatement(ValueBuilder::makeString(ALMOST_ASM)));
  // add memory import
  if (wasm->memory.exists && wasm->memory.imported()) {
    Ref theVar = ValueBuilder::makeVar();
    asmFunc[3]->push_back(theVar);
    ValueBuilder::appendToVar(theVar,
      "memory",
      ValueBuilder::makeDot(
        ValueBuilder::makeName(ENV),
        ValueBuilder::makeName("memory")
      )
    );
  }
  // create heaps, etc
  addBasics(asmFunc[3]);
  ModuleUtils::iterImportedFunctions(*wasm, [&](Function* import) {
    addFunctionImport(asmFunc[3], import);
  });
  ModuleUtils::iterImportedGlobals(*wasm, [&](Global* import) {
    addGlobalImport(asmFunc[3], import);
  });
  // figure out the table size
  tableSize = std::accumulate(wasm->table.segments.begin(),
                              wasm->table.segments.end(),
                              0, [&](size_t size, Table::Segment seg) -> size_t {
                                return size + seg.data.size() + constOffset(seg);
                              });
  size_t pow2ed = 1;
  while (pow2ed < tableSize) {
    pow2ed <<= 1;
  }
  tableSize = pow2ed;

  // make sure exports get their expected names
  for (auto& e : wasm->exports) {
    if (e->kind == ExternalKind::Function) {
      fromName(e->name, NameScope::Top);
    }
  }
  for (auto& f : wasm->functions) {
    fromName(f->name, NameScope::Top);
  }
  fromName(WASM_FETCH_HIGH_BITS, NameScope::Top);
  // globals
  bool generateFetchHighBits = false;
  ModuleUtils::iterDefinedGlobals(*wasm, [&](Global* global) {
    addGlobal(asmFunc[3], global);
    if (flags.allowAsserts && global->name == INT64_TO_32_HIGH_BITS) {
      generateFetchHighBits = true;
    }
  });
  if (flags.emscripten) {
    asmFunc[3]->push_back(ValueBuilder::makeName("// EMSCRIPTEN_START_FUNCS"));
  }
  // functions
  ModuleUtils::iterDefinedFunctions(*wasm, [&](Function* func) {
    asmFunc[3]->push_back(processFunction(wasm, func));
  });
  if (generateFetchHighBits) {
    Builder builder(allocator);
    std::vector<Type> params;
    std::vector<Type> vars;
    asmFunc[3]->push_back(processFunction(wasm, builder.makeFunction(
      WASM_FETCH_HIGH_BITS,
      std::move(params),
      i32,
      std::move(vars),
      builder.makeReturn(builder.makeGetGlobal(INT64_TO_32_HIGH_BITS, i32))
    )));
    auto e = new Export();
    e->name = WASM_FETCH_HIGH_BITS;
    e->value = WASM_FETCH_HIGH_BITS;
    e->kind = ExternalKind::Function;
    wasm->addExport(e);
  }
  if (flags.emscripten) {
    asmFunc[3]->push_back(ValueBuilder::makeName("// EMSCRIPTEN_END_FUNCS"));
  }

  addTable(asmFunc[3], wasm);
  // memory XXX
  addExports(asmFunc[3], wasm);
  return ret;
}

void Wasm2JSBuilder::addBasics(Ref ast) {
  // heaps, var HEAP8 = new global.Int8Array(buffer); etc
  auto addHeap = [&](IString name, IString view) {
    Ref theVar = ValueBuilder::makeVar();
    ast->push_back(theVar);
    ValueBuilder::appendToVar(theVar,
      name,
      ValueBuilder::makeNew(
        ValueBuilder::makeCall(
          ValueBuilder::makeDot(
            ValueBuilder::makeName(GLOBAL),
            view
          ),
          ValueBuilder::makeName(BUFFER)
        )
      )
    );
  };
  addHeap(HEAP8,  INT8ARRAY);
  addHeap(HEAP16, INT16ARRAY);
  addHeap(HEAP32, INT32ARRAY);
  addHeap(HEAPU8,  UINT8ARRAY);
  addHeap(HEAPU16, UINT16ARRAY);
  addHeap(HEAPU32, UINT32ARRAY);
  addHeap(HEAPF32, FLOAT32ARRAY);
  addHeap(HEAPF64, FLOAT64ARRAY);
  // core asm.js imports
  auto addMath = [&](IString name, IString base) {
    Ref theVar = ValueBuilder::makeVar();
    ast->push_back(theVar);
    ValueBuilder::appendToVar(theVar,
      name,
      ValueBuilder::makeDot(
        ValueBuilder::makeDot(
          ValueBuilder::makeName(GLOBAL),
          MATH
        ),
        base
      )
    );
  };
  addMath(MATH_IMUL, IMUL);
  addMath(MATH_FROUND, FROUND);
  addMath(MATH_ABS, ABS);
  addMath(MATH_CLZ32, CLZ32);
  addMath(MATH_MIN, MIN);
  addMath(MATH_MAX, MAX);
  addMath(MATH_FLOOR, FLOOR);
  addMath(MATH_CEIL, CEIL);
  addMath(MATH_SQRT, SQRT);
  // abort function
  Ref abortVar = ValueBuilder::makeVar();
  ast->push_back(abortVar);
  ValueBuilder::appendToVar(abortVar,
    "abort",
    ValueBuilder::makeDot(
      ValueBuilder::makeName(ENV),
      ABORT_FUNC
    )
  );
  // TODO: this shouldn't be needed once we stop generating literal asm.js code
  // NaN and Infinity variables
  Ref nanVar = ValueBuilder::makeVar();
  ast->push_back(nanVar);
  ValueBuilder::appendToVar(nanVar,
    "nan",
    ValueBuilder::makeDot(ValueBuilder::makeName(GLOBAL), "NaN")
  );
  Ref infinityVar = ValueBuilder::makeVar();
  ast->push_back(infinityVar);
  ValueBuilder::appendToVar(infinityVar,
    "infinity",
    ValueBuilder::makeDot(ValueBuilder::makeName(GLOBAL), "Infinity")
  );
}

void Wasm2JSBuilder::addFunctionImport(Ref ast, Function* import) {
  // The scratch memory helpers are emitted in the glue, see code and comments below.
  if (ABI::wasm2js::isScratchMemoryHelper(import->base)) {
    return;
  }
  Ref theVar = ValueBuilder::makeVar();
  ast->push_back(theVar);
  Ref module = ValueBuilder::makeName(ENV); // TODO: handle nested module imports
  ValueBuilder::appendToVar(theVar,
    fromName(import->name, NameScope::Top),
    ValueBuilder::makeDot(
      module,
      fromName(import->base, NameScope::Top)
    )
  );
}

void Wasm2JSBuilder::addGlobalImport(Ref ast, Global* import) {
  Ref theVar = ValueBuilder::makeVar();
  ast->push_back(theVar);
  Ref module = ValueBuilder::makeName(ENV); // TODO: handle nested module imports
  Ref value = ValueBuilder::makeDot(
    module,
    fromName(import->base, NameScope::Top)
  );
  if (import->type == i32) {
    value = makeAsmCoercion(value, ASM_INT);
  }
  ValueBuilder::appendToVar(theVar,
    fromName(import->name, NameScope::Top),
    value
  );
}

void Wasm2JSBuilder::addTable(Ref ast, Module* wasm) {
  // Emit a simple flat table as a JS array literal. Otherwise,
  // emit assignments separately for each index.
  FlatTable flat(wasm->table);
  assert(flat.valid); // TODO: non-flat tables
  if (!wasm->table.imported()) {
    Ref theVar = ValueBuilder::makeVar();
    ast->push_back(theVar);
    Ref theArray = ValueBuilder::makeArray();
    ValueBuilder::appendToVar(theVar, FUNCTION_TABLE, theArray);
    Name null("null");
    for (auto& name : flat.names) {
      if (name.is()) {
        name = fromName(name, NameScope::Top);
      } else {
        name = null;
      }
      ValueBuilder::appendToArray(theArray, ValueBuilder::makeName(name));
    }
  } else {
    // TODO: optimize for size
    for (auto& segment : wasm->table.segments) {
      auto offset = segment.offset;
      Index start = offset->cast<Const>()->value.geti32();
      for (Index i = 0; i < segment.data.size(); i++) {
        ast->push_back(ValueBuilder::makeStatement(
          ValueBuilder::makeBinary(
            ValueBuilder::makeSub(
              ValueBuilder::makeName(FUNCTION_TABLE),
              ValueBuilder::makeInt(start + i)
            ),
            SET,
            ValueBuilder::makeName(fromName(segment.data[i], NameScope::Top))
          )
        ));
      }
    }
  }
}

void Wasm2JSBuilder::addExports(Ref ast, Module* wasm) {
  Ref exports = ValueBuilder::makeObject();
  for (auto& export_ : wasm->exports) {
    if (export_->kind == ExternalKind::Function) {
      ValueBuilder::appendToObject(
        exports,
        fromName(export_->name, NameScope::Top),
        ValueBuilder::makeName(fromName(export_->value, NameScope::Top))
      );
    }
    if (export_->kind == ExternalKind::Memory) {
      Ref descs = ValueBuilder::makeObject();
      Ref growDesc = ValueBuilder::makeObject();
      ValueBuilder::appendToObject(
        descs,
        IString("grow"),
        growDesc);
      ValueBuilder::appendToObject(
        growDesc,
        IString("value"),
        ValueBuilder::makeName(WASM_GROW_MEMORY));
      Ref bufferDesc = ValueBuilder::makeObject();
      Ref bufferGetter = ValueBuilder::makeFunction(IString(""));
      bufferGetter[3]->push_back(ValueBuilder::makeReturn(
        ValueBuilder::makeName(BUFFER)
      ));
      ValueBuilder::appendToObject(
        bufferDesc,
        IString("get"),
        bufferGetter);
      ValueBuilder::appendToObject(
        descs,
        IString("buffer"),
        bufferDesc);
      Ref memory = ValueBuilder::makeCall(
        ValueBuilder::makeDot(ValueBuilder::makeName(IString("Object")), IString("create")),
        ValueBuilder::makeDot(ValueBuilder::makeName(IString("Object")), IString("prototype")));
      ValueBuilder::appendToCall(
        memory,
        descs);
      ValueBuilder::appendToObject(
        exports,
        fromName(export_->name, NameScope::Top),
        memory);
    }
  }
  if (wasm->memory.exists && wasm->memory.max > wasm->memory.initial) {
    addMemoryGrowthFuncs(ast, wasm);
  }
  ast->push_back(ValueBuilder::makeStatement(ValueBuilder::makeReturn(exports)));
}

void Wasm2JSBuilder::addGlobal(Ref ast, Global* global) {
  if (auto* const_ = global->init->dynCast<Const>()) {
    Ref theValue;
    switch (const_->type) {
      case Type::i32: {
        theValue = ValueBuilder::makeInt(const_->value.geti32());
        break;
      }
      case Type::f32: {
        theValue = ValueBuilder::makeCall(MATH_FROUND,
          makeAsmCoercion(ValueBuilder::makeDouble(const_->value.getf32()), ASM_DOUBLE)
        );
        break;
      }
      case Type::f64: {
        theValue = makeAsmCoercion(ValueBuilder::makeDouble(const_->value.getf64()), ASM_DOUBLE);
        break;
      }
      default: {
        assert(false && "Top const type not supported");
      }
    }
    Ref theVar = ValueBuilder::makeVar();
    ast->push_back(theVar);
    ValueBuilder::appendToVar(theVar,
      fromName(global->name, NameScope::Top),
      theValue
    );
  } else if (auto* get = global->init->dynCast<GetGlobal>()) {
    Ref theVar = ValueBuilder::makeVar();
    ast->push_back(theVar);
    ValueBuilder::appendToVar(theVar,
      fromName(global->name, NameScope::Top),
      ValueBuilder::makeName(fromName(get->name, NameScope::Top))
    );
  } else {
    assert(false && "Top init type not supported");
  }
}

Ref Wasm2JSBuilder::processFunction(Module* m, Function* func, bool standaloneFunction) {
  if (standaloneFunction) {
    // We are only printing a function, not a whole module. Prepare it for
    // translation now (if there were a module, we'd have done this for all
    // functions in parallel, earlier).
    PassRunner runner(m);
    // We only run a subset of all passes here. TODO: create a full valid module
    // for each assertion body.
    runner.add("flatten");
    runner.add("simplify-locals-notee-nostructure");
    runner.add("reorder-locals");
    runner.add("vacuum");
    runner.runOnFunction(func);
  }

  // We will be symbolically referring to all variables in the function, so make
  // sure that everything has a name and it's unique.
  Names::ensureNames(func);
  Ref ret = ValueBuilder::makeFunction(fromName(func->name, NameScope::Top));
  frees.clear();
  frees.resize(std::max(i32, std::max(f32, f64)) + 1);
  temps.clear();
  temps.resize(std::max(i32, std::max(f32, f64)) + 1);
  temps[i32] = temps[f32] = temps[f64] = 0;
  // arguments
  for (Index i = 0; i < func->getNumParams(); i++) {
    IString name = fromName(func->getLocalNameOrGeneric(i), NameScope::Local);
    ValueBuilder::appendArgumentToFunction(ret, name);
    ret[3]->push_back(
      ValueBuilder::makeStatement(
        ValueBuilder::makeBinary(
          ValueBuilder::makeName(name), SET,
          makeAsmCoercion(
            ValueBuilder::makeName(name),
            wasmToAsmType(func->getLocalType(i))
          )
        )
      )
    );
  }
  Ref theVar = ValueBuilder::makeVar();
  size_t theVarIndex = ret[3]->size();
  ret[3]->push_back(theVar);
  // body
  flattenAppend(ret, processFunctionBody(m, func));
  // vars, including new temp vars
  for (Index i = func->getVarIndexBase(); i < func->getNumLocals(); i++) {
    ValueBuilder::appendToVar(
      theVar,
      fromName(func->getLocalNameOrGeneric(i), NameScope::Local),
      makeAsmCoercedZero(wasmToAsmType(func->getLocalType(i)))
    );
  }
  if (theVar[1]->size() == 0) {
    ret[3]->splice(theVarIndex, 1);
  }
  // checks
  assert(frees[i32].size() == temps[i32]); // all temp vars should be free at the end
  assert(frees[f32].size() == temps[f32]); // all temp vars should be free at the end
  assert(frees[f64].size() == temps[f64]); // all temp vars should be free at the end
  return ret;
}

Ref Wasm2JSBuilder::processFunctionBody(Module* m, Function* func) {
  struct ExpressionProcessor : public Visitor<ExpressionProcessor, Ref> {
    Wasm2JSBuilder* parent;
    IString result; // TODO: remove
    Function* func;
    Module* module;
    MixedArena allocator;
    ExpressionProcessor(Wasm2JSBuilder* parent, Module* m, Function* func)
      : parent(parent), func(func), module(m) {}

    // A scoped temporary variable.
    struct ScopedTemp {
      Wasm2JSBuilder* parent;
      Type type;
      IString temp; // TODO: switch to indexes; avoid names
      bool needFree;
      // @param possible if provided, this is a variable we can use as our temp. it has already been
      //                 allocated in a higher scope, and we can just assign to it as our result is
      //                 going there anyhow.
      ScopedTemp(Type type, Wasm2JSBuilder* parent, Function* func,
                 IString possible = NO_RESULT) : parent(parent), type(type) {
        assert(possible != EXPRESSION_RESULT);
        if (possible == NO_RESULT) {
          temp = parent->getTemp(type, func);
          needFree = true;
        } else {
          temp = possible;
          needFree = false;
        }
      }
      ~ScopedTemp() {
        if (needFree) {
          parent->freeTemp(type, temp);
        }
      }

      IString getName() {
        return temp;
      }
      Ref getAstName() {
        return ValueBuilder::makeName(temp);
      }
    };

    Ref visit(Expression* curr, IString nextResult) {
      IString old = result;
      result = nextResult;
      Ref ret = Visitor::visit(curr);
      result = old; // keep it consistent for the rest of this frame, which may call visit on multiple children
      return ret;
    }

    Ref visit(Expression* curr, ScopedTemp& temp) {
      return visit(curr, temp.temp);
    }

    Ref visitAndAssign(Expression* curr, IString result) {
      Ref ret = visit(curr, result);
      // if it's not already a statement, then it's an expression, and we need to assign it
      // (if it is a statement, it already assigns to the result var)
      if (result != NO_RESULT) {
        ret = ValueBuilder::makeStatement(
            ValueBuilder::makeBinary(ValueBuilder::makeName(result), SET, ret));
      }
      return ret;
    }

    Ref visitAndAssign(Expression* curr, ScopedTemp& temp) {
      return visitAndAssign(curr, temp.getName());
    }

    // Expressions with control flow turn into a block, which we must
    // then handle, even if we are an expression.
    bool isBlock(Ref ast) {
      return !!ast && ast->isArray() && ast[0] == BLOCK;
    }

    Ref blockify(Ref ast) {
      if (isBlock(ast)) return ast;
      Ref ret = ValueBuilder::makeBlock();
      ret[1]->push_back(ValueBuilder::makeStatement(ast));
      return ret;
    }

    // For spooky return-at-a-distance/break-with-result, this tells us
    // what the result var is for a specific label.
    std::map<Name, IString> breakResults;

    // Breaks to the top of a loop should be emitted as continues, to that loop's main label
    std::unordered_set<Name> continueLabels;

    IString fromName(Name name, NameScope scope) {
      return parent->fromName(name, scope);
    }

    // Visitors

    Ref visitBlock(Block* curr) {
      breakResults[curr->name] = result;
      Ref ret = ValueBuilder::makeBlock();
      size_t size = curr->list.size();
      auto noResults = result == NO_RESULT ? size : size-1;
      for (size_t i = 0; i < noResults; i++) {
        flattenAppend(ret, ValueBuilder::makeStatement(visit(curr->list[i], NO_RESULT)));
      }
      if (result != NO_RESULT) {
        flattenAppend(ret, visitAndAssign(curr->list[size-1], result));
      }
      if (curr->name.is()) {
        ret = ValueBuilder::makeLabel(fromName(curr->name, NameScope::Label), ret);
      }
      return ret;
    }

    Ref visitIf(If* curr) {
      IString temp;
      Ref condition = visit(curr->condition, EXPRESSION_RESULT);
      Ref ifTrue = ValueBuilder::makeStatement(visitAndAssign(curr->ifTrue, result));
      Ref ifFalse;
      if (curr->ifFalse) {
        ifFalse = ValueBuilder::makeStatement(visitAndAssign(curr->ifFalse, result));
      }
      if (temp.isNull()) {
        return ValueBuilder::makeIf(condition, ifTrue, ifFalse); // simple if
      }
      condition = blockify(condition);
      // just add an if to the block
      condition[1]->push_back(ValueBuilder::makeIf(ValueBuilder::makeName(temp), ifTrue, ifFalse));
      return condition;
    }

    Ref visitLoop(Loop* curr) {
      Name asmLabel = curr->name;
      continueLabels.insert(asmLabel);
      Ref body = blockify(visit(curr->body, result));
      flattenAppend(body, ValueBuilder::makeBreak(fromName(asmLabel, NameScope::Label)));
      Ref ret = ValueBuilder::makeDo(body, ValueBuilder::makeInt(1));
      return ValueBuilder::makeLabel(fromName(asmLabel, NameScope::Label), ret);
    }

    Ref makeBreakOrContinue(Name name) {
      if (continueLabels.count(name)) {
        return ValueBuilder::makeContinue(fromName(name, NameScope::Label));
      } else {
        return ValueBuilder::makeBreak(fromName(name, NameScope::Label));
      }
    }

    Ref visitBreak(Break* curr) {
      if (curr->condition) {
        // we need an equivalent to an if here, so use that code
        Break fakeBreak = *curr;
        fakeBreak.condition = nullptr;
        If fakeIf(allocator);
        fakeIf.condition = curr->condition;
        fakeIf.ifTrue = &fakeBreak;
        return visit(&fakeIf, result);
      }
      Ref theBreak = makeBreakOrContinue(curr->name);
      if (!curr->value) return theBreak;
      // generate the value, including assigning to the result, and then do the break
      Ref ret = visitAndAssign(curr->value, breakResults[curr->name]);
      ret = blockify(ret);
      ret[1]->push_back(theBreak);
      return ret;
    }

    Expression* defaultBody = nullptr; // default must be last in asm.js

    Ref visitSwitch(Switch* curr) {
      assert(!curr->value);
      Ref ret = ValueBuilder::makeBlock();
      Ref condition = visit(curr->condition, EXPRESSION_RESULT);
      Ref theSwitch =
        ValueBuilder::makeSwitch(makeAsmCoercion(condition, ASM_INT));
      ret[1]->push_back(theSwitch);
      for (size_t i = 0; i < curr->targets.size(); i++) {
        ValueBuilder::appendCaseToSwitch(theSwitch, ValueBuilder::makeNum(i));
        ValueBuilder::appendCodeToSwitch(theSwitch, blockify(makeBreakOrContinue(curr->targets[i])), false);
      }
      ValueBuilder::appendDefaultToSwitch(theSwitch);
      ValueBuilder::appendCodeToSwitch(theSwitch, blockify(makeBreakOrContinue(curr->default_)), false);
      return ret;
    }

    Ref visitCall(Call* curr) {
      Ref theCall = ValueBuilder::makeCall(fromName(curr->target, NameScope::Top));
      for (auto operand : curr->operands) {
        theCall[2]->push_back(
          makeAsmCoercion(visit(operand, EXPRESSION_RESULT),
                          wasmToAsmType(operand->type)));
      }
      return makeAsmCoercion(theCall, wasmToAsmType(curr->type));
    }

    Ref visitCallIndirect(CallIndirect* curr) {
      // TODO: the codegen here is a pessimization of what the ideal codegen
      // looks like. Eventually if necessary this should be tightened up in the
      // case that the argument expression doesn't have any side effects.
      Ref ret;
      ScopedTemp idx(i32, parent, func);
      std::vector<ScopedTemp*> temps; // TODO: utility class, with destructor?
      for (auto& operand : curr->operands) {
        temps.push_back(new ScopedTemp(operand->type, parent, func));
        IString temp = temps.back()->temp;
        sequenceAppend(ret, visitAndAssign(operand, temp));
      }
      sequenceAppend(ret, visitAndAssign(curr->target, idx));
      Ref theCall = ValueBuilder::makeCall(ValueBuilder::makeSub(
        ValueBuilder::makeName(FUNCTION_TABLE),
        idx.getAstName()
      ));
      for (size_t i = 0; i < temps.size(); i++) {
        IString temp = temps[i]->temp;
        auto &operand = curr->operands[i];
        theCall[2]->push_back(makeAsmCoercion(ValueBuilder::makeName(temp), wasmToAsmType(operand->type)));
      }
      theCall = makeAsmCoercion(theCall, wasmToAsmType(curr->type));
      sequenceAppend(ret, theCall);
      for (auto temp : temps) {
        delete temp;
      }
      return ret;
    }

    // TODO: remove
    Ref makeSetVar(Expression* curr, Expression* value, Name name, NameScope scope) {
      return ValueBuilder::makeBinary(
        ValueBuilder::makeName(fromName(name, scope)), SET,
        visit(value, EXPRESSION_RESULT)
      );
    }

    Ref visitGetLocal(GetLocal* curr) {
      return ValueBuilder::makeName(
        fromName(func->getLocalNameOrGeneric(curr->index), NameScope::Local)
      );
    }

    Ref visitSetLocal(SetLocal* curr) {
      return makeSetVar(
        curr,
        curr->value,
        func->getLocalNameOrGeneric(curr->index),
        NameScope::Local
      );
    }

    Ref visitGetGlobal(GetGlobal* curr) {
      return ValueBuilder::makeName(fromName(curr->name, NameScope::Top));
    }

    Ref visitSetGlobal(SetGlobal* curr) {
      return makeSetVar(curr, curr->value, curr->name, NameScope::Top);
    }

    Ref visitLoad(Load* curr) {
      if (curr->align != 0 && curr->align < curr->bytes) {
        // set the pointer to a local
        ScopedTemp temp(i32, parent, func);
        SetLocal set(allocator);
        set.index = func->getLocalIndex(temp.getName());
        set.value = curr->ptr;
        Ref ptrSet = visit(&set, NO_RESULT);
        GetLocal get(allocator);
        get.index = func->getLocalIndex(temp.getName());
        // fake loads
        Load load = *curr;
        load.ptr = &get;
        load.bytes = 1; // do the worst
        load.signed_ = false;
        Ref rest;
        switch (curr->type) {
          case i32: {
            rest = makeAsmCoercion(visit(&load, EXPRESSION_RESULT), ASM_INT);
            for (size_t i = 1; i < curr->bytes; i++) {
              ++load.offset;
              Ref add = makeAsmCoercion(visit(&load, EXPRESSION_RESULT), ASM_INT);
              add = ValueBuilder::makeBinary(add, LSHIFT, ValueBuilder::makeNum(8*i));
              rest = ValueBuilder::makeBinary(rest, OR, add);
            }
            break;
          }
          default: {
            std::cerr << "Unhandled type in load: " << curr->type << std::endl;
            abort();
          }
        }
        return ValueBuilder::makeSeq(ptrSet, rest);
      }
      // normal load
      Ref ptr = makePointer(curr->ptr, curr->offset);
      Ref ret;
      switch (curr->type) {
        case i32: {
          switch (curr->bytes) {
            case 1:
              ret = ValueBuilder::makeSub(
                  ValueBuilder::makeName(LoadUtils::isSignRelevant(curr) && curr->signed_ ? HEAP8 : HEAPU8),
                  ValueBuilder::makePtrShift(ptr, 0));
              break;
            case 2:
              ret = ValueBuilder::makeSub(
                  ValueBuilder::makeName(LoadUtils::isSignRelevant(curr) && curr->signed_ ? HEAP16 : HEAPU16),
                  ValueBuilder::makePtrShift(ptr, 1));
              break;
            case 4:
              ret = ValueBuilder::makeSub(
                  ValueBuilder::makeName(HEAP32),
                  ValueBuilder::makePtrShift(ptr, 2));
              break;
            default: {
              std::cerr << "Unhandled number of bytes in i32 load: "
                        << curr->bytes << std::endl;
              abort();
            }
          }
          break;
        }
        case f32:
          ret = ValueBuilder::makeSub(ValueBuilder::makeName(HEAPF32),
                                      ValueBuilder::makePtrShift(ptr, 2));
          break;
        case f64:
          ret = ValueBuilder::makeSub(ValueBuilder::makeName(HEAPF64),
                                      ValueBuilder::makePtrShift(ptr, 3));
          break;
        default: {
          std::cerr << "Unhandled type in load: " << curr->type << std::endl;
          abort();
        }
      }
      return makeAsmCoercion(ret, wasmToAsmType(curr->type));
    }

    Ref visitStore(Store* curr) {
      if (module->memory.initial < module->memory.max && curr->type != unreachable) {
        // In JS, if memory grows then it is dangerous to write
        //  HEAP[f()] = ..
        // or
        //  HEAP[..] = f()
        // since if the call swaps HEAP (in a growth operation) then
        // we will not actually write to the new version (since the
        // semantics of JS mean we already looked at HEAP and have
        // decided where to assign to).
        if (!FindAll<Call>(curr->ptr).list.empty() ||
            !FindAll<Call>(curr->value).list.empty() ||
            !FindAll<CallIndirect>(curr->ptr).list.empty() ||
            !FindAll<CallIndirect>(curr->value).list.empty() ||
            !FindAll<Host>(curr->ptr).list.empty() ||
            !FindAll<Host>(curr->value).list.empty()) {
          Ref ret;
          ScopedTemp ptr(i32, parent, func);
          sequenceAppend(ret, visitAndAssign(curr->ptr, ptr));
          ScopedTemp value(curr->value->type, parent, func);
          sequenceAppend(ret, visitAndAssign(curr->value, value));
          GetLocal getPtr;
          getPtr.index = func->getLocalIndex(ptr.getName());
          getPtr.type = i32;
          GetLocal getValue;
          getValue.index = func->getLocalIndex(value.getName());
          getValue.type = curr->value->type;
          Store fakeStore = *curr;
          fakeStore.ptr = &getPtr;
          fakeStore.value = &getValue;
          sequenceAppend(ret, visitStore(&fakeStore));
          return ret;
        }
      }
      // FIXME if memory growth, store ptr cannot contain a function call
      //       also other stores to memory, check them, all makeSub's
      if (curr->align != 0 && curr->align < curr->bytes) {
        // set the pointer to a local
        ScopedTemp temp(i32, parent, func);
        SetLocal set(allocator);
        set.index = func->getLocalIndex(temp.getName());
        set.value = curr->ptr;
        Ref ptrSet = visit(&set, NO_RESULT);
        GetLocal get(allocator);
        get.index = func->getLocalIndex(temp.getName());
        // set the value to a local
        ScopedTemp tempValue(curr->value->type, parent, func);
        SetLocal setValue(allocator);
        setValue.index = func->getLocalIndex(tempValue.getName());
        setValue.value = curr->value;
        Ref valueSet = visit(&setValue, NO_RESULT);
        GetLocal getValue(allocator);
        getValue.index = func->getLocalIndex(tempValue.getName());
        // fake stores
        Store store = *curr;
        store.ptr = &get;
        store.bytes = 1; // do the worst
        Ref rest;
        switch (curr->valueType) {
          case i32: {
            Const _255(allocator);
            _255.value = Literal(int32_t(255));
            _255.type = i32;
            for (size_t i = 0; i < curr->bytes; i++) {
              Const shift(allocator);
              shift.value = Literal(int32_t(8*i));
              shift.type = i32;
              Binary shifted(allocator);
              shifted.op = ShrUInt32;
              shifted.left = &getValue;
              shifted.right = &shift;
              shifted.type = i32;
              Binary anded(allocator);
              anded.op = AndInt32;
              anded.left = i > 0 ? static_cast<Expression*>(&shifted) : static_cast<Expression*>(&getValue);
              anded.right = &_255;
              anded.type = i32;
              store.value = &anded;
              Ref part = visit(&store, NO_RESULT);
              if (i == 0) {
                rest = part;
              } else {
                rest = ValueBuilder::makeSeq(rest, part);
              }
              ++store.offset;
            }
            break;
          }
          default: {
            std::cerr << "Unhandled type in store: " <<  curr->valueType
                      << std::endl;
            abort();
          }
        }
        return ValueBuilder::makeSeq(ValueBuilder::makeSeq(ptrSet, valueSet), rest);
      }
      // normal store
      Ref ptr = makePointer(curr->ptr, curr->offset);
      Ref value = visit(curr->value, EXPRESSION_RESULT);
      Ref ret;
      switch (curr->valueType) {
        case i32: {
          switch (curr->bytes) {
            case 1: ret = ValueBuilder::makeSub(ValueBuilder::makeName(HEAP8),  ValueBuilder::makePtrShift(ptr, 0)); break;
            case 2: ret = ValueBuilder::makeSub(ValueBuilder::makeName(HEAP16), ValueBuilder::makePtrShift(ptr, 1)); break;
            case 4: ret = ValueBuilder::makeSub(ValueBuilder::makeName(HEAP32), ValueBuilder::makePtrShift(ptr, 2)); break;
            default: abort();
          }
          break;
        }
        case f32: ret = ValueBuilder::makeSub(ValueBuilder::makeName(HEAPF32), ValueBuilder::makePtrShift(ptr, 2)); break;
        case f64: ret = ValueBuilder::makeSub(ValueBuilder::makeName(HEAPF64), ValueBuilder::makePtrShift(ptr, 3)); break;
        default: {
          std::cerr << "Unhandled type in store: " << curr->valueType
                    << std::endl;
          abort();
        }
      }
      return ValueBuilder::makeBinary(ret, SET, value);
    }

    Ref visitDrop(Drop* curr) {
      return visitAndAssign(curr->value, result);
    }

    Ref visitConst(Const* curr) {
      switch (curr->type) {
        case i32: return ValueBuilder::makeInt(curr->value.geti32());
        // An i64 argument translates to two actual arguments to asm.js
        // functions, so we do a bit of a hack here to get our one `Ref` to look
        // like two function arguments.
        case i64: {
          auto lo = (unsigned) curr->value.geti64();
          auto hi = (unsigned) (curr->value.geti64() >> 32);
          std::ostringstream out;
          out << lo << "," << hi;
          std::string os = out.str();
          IString name(os.c_str(), false);
          return ValueBuilder::makeName(name);
        }
        case f32: {
          Ref ret = ValueBuilder::makeCall(MATH_FROUND);
          Const fake(allocator);
          fake.value = Literal(double(curr->value.getf32()));
          fake.type = f64;
          ret[2]->push_back(visitConst(&fake));
          return ret;
        }
        case f64: {
          double d = curr->value.getf64();
          if (d == 0 && std::signbit(d)) { // negative zero
            return ValueBuilder::makeUnary(PLUS, ValueBuilder::makeUnary(MINUS, ValueBuilder::makeDouble(0)));
          }
          return ValueBuilder::makeUnary(PLUS, ValueBuilder::makeDouble(curr->value.getf64()));
        }
        default: abort();
      }
    }

    Ref visitUnary(Unary* curr) {
      // normal unary
      switch (curr->type) {
        case i32: {
          switch (curr->op) {
            case ClzInt32:
              return ValueBuilder::makeCall(
                MATH_CLZ32,
                visit(curr->value, EXPRESSION_RESULT)
              );
            case CtzInt32:
            case PopcntInt32:
              std::cerr << "i32 unary should have been removed: " << curr
                        << std::endl;
              WASM_UNREACHABLE();
            case EqZInt32:
              return ValueBuilder::makeBinary(
                  makeAsmCoercion(visit(curr->value,
                                        EXPRESSION_RESULT), ASM_INT), EQ,
                  makeAsmCoercion(ValueBuilder::makeInt(0), ASM_INT));
            case ReinterpretFloat32: {
              ABI::wasm2js::ensureScratchMemoryHelpers(module, ABI::wasm2js::SCRATCH_STORE_F32);
              ABI::wasm2js::ensureScratchMemoryHelpers(module, ABI::wasm2js::SCRATCH_LOAD_I32);

              Ref store = ValueBuilder::makeCall(
                ABI::wasm2js::SCRATCH_STORE_F32,
                visit(curr->value, EXPRESSION_RESULT)
              );
              Ref load = ValueBuilder::makeCall(ABI::wasm2js::SCRATCH_LOAD_I32, ValueBuilder::makeInt(0));
              return ValueBuilder::makeSeq(store, load);
            }
            // generate (~~expr), what Emscripten does
            case TruncSFloat32ToInt32:
            case TruncSFloat64ToInt32:
              return ValueBuilder::makeUnary(
                  B_NOT,
                  ValueBuilder::makeUnary(
                    B_NOT,
                    visit(curr->value, EXPRESSION_RESULT)
                  ));

            // generate (~~expr >>> 0), what Emscripten does
            case TruncUFloat32ToInt32:
            case TruncUFloat64ToInt32:
              return ValueBuilder::makeBinary(
                ValueBuilder::makeUnary(
                  B_NOT,
                  ValueBuilder::makeUnary(
                    B_NOT,
                    visit(curr->value, EXPRESSION_RESULT)
                  )
                ),
                TRSHIFT,
                ValueBuilder::makeNum(0)
              );

            default: {
              std::cerr << "Unhandled unary i32 operator: " << curr
                        << std::endl;
              abort();
            }
          }
        }
        case f32:
        case f64: {
          Ref ret;
          switch (curr->op) {
            case NegFloat32:
            case NegFloat64:
              ret = ValueBuilder::makeUnary(
                MINUS,
                visit(curr->value, EXPRESSION_RESULT)
              );
              break;
            case AbsFloat32:
            case AbsFloat64:
              ret = ValueBuilder::makeCall(
                MATH_ABS,
                visit(curr->value, EXPRESSION_RESULT)
              );
              break;
            case CeilFloat32:
            case CeilFloat64:
              ret = ValueBuilder::makeCall(
                MATH_CEIL,
                visit(curr->value, EXPRESSION_RESULT)
              );
              break;
            case FloorFloat32:
            case FloorFloat64:
              ret = ValueBuilder::makeCall(
                MATH_FLOOR,
                visit(curr->value, EXPRESSION_RESULT)
              );
              break;
            case SqrtFloat32:
            case SqrtFloat64:
              ret = ValueBuilder::makeCall(
                MATH_SQRT,
                visit(curr->value, EXPRESSION_RESULT)
              );
              break;
            case PromoteFloat32:
              return makeAsmCoercion(visit(curr->value, EXPRESSION_RESULT),
                                     ASM_DOUBLE);
            case DemoteFloat64:
              return makeAsmCoercion(visit(curr->value, EXPRESSION_RESULT),
                                     ASM_FLOAT);
            case ReinterpretInt32: {
              ABI::wasm2js::ensureScratchMemoryHelpers(module, ABI::wasm2js::SCRATCH_STORE_I32);
              ABI::wasm2js::ensureScratchMemoryHelpers(module, ABI::wasm2js::SCRATCH_LOAD_F32);

              Ref store = ValueBuilder::makeCall(
                ABI::wasm2js::SCRATCH_STORE_I32,
                ValueBuilder::makeNum(0),
                visit(curr->value, EXPRESSION_RESULT)
              );
              Ref load = ValueBuilder::makeCall(ABI::wasm2js::SCRATCH_LOAD_F32);
              return ValueBuilder::makeSeq(store, load);
            }
            // Coerce the integer to a float as emscripten does
            case ConvertSInt32ToFloat32:
              return makeAsmCoercion(
                makeAsmCoercion(visit(curr->value, EXPRESSION_RESULT), ASM_INT),
                ASM_FLOAT
              );
            case ConvertSInt32ToFloat64:
              return makeAsmCoercion(
                makeAsmCoercion(visit(curr->value, EXPRESSION_RESULT), ASM_INT),
                ASM_DOUBLE
              );

            // Generate (expr >>> 0), followed by a coercion
            case ConvertUInt32ToFloat32:
              return makeAsmCoercion(
                ValueBuilder::makeBinary(
                  visit(curr->value, EXPRESSION_RESULT),
                  TRSHIFT,
                  ValueBuilder::makeInt(0)
                ),
                ASM_FLOAT
              );
            case ConvertUInt32ToFloat64:
              return makeAsmCoercion(
                ValueBuilder::makeBinary(
                  visit(curr->value, EXPRESSION_RESULT),
                  TRSHIFT,
                  ValueBuilder::makeInt(0)
                ),
                ASM_DOUBLE
              );
            // TODO: more complex unary conversions
            case NearestFloat32:
            case NearestFloat64:
            case TruncFloat32:
            case TruncFloat64:
              std::cerr << "operation should have been removed in previous passes"
                        << std::endl;
              WASM_UNREACHABLE();

            default:
              std::cerr << "Unhandled unary float operator: " << curr
                        << std::endl;
              abort();
          }
          if (curr->type == f32) { // doubles need much less coercing
            return makeAsmCoercion(ret, ASM_FLOAT);
          }
          return ret;
        }
        default: {
          std::cerr << "Unhandled type in unary: " << curr << std::endl;
          abort();
        }
      }
    }

    Ref visitBinary(Binary* curr) {
      // normal binary
      Ref left = visit(curr->left, EXPRESSION_RESULT);
      Ref right = visit(curr->right, EXPRESSION_RESULT);
      Ref ret;
      switch (curr->type) {
        case i32: {
          switch (curr->op) {
            case AddInt32:
              ret = ValueBuilder::makeBinary(left, PLUS, right);
              break;
            case SubInt32:
              ret = ValueBuilder::makeBinary(left, MINUS, right);
              break;
            case MulInt32: {
              if (curr->type == i32) {
                // TODO: when one operand is a small int, emit a multiply
                return ValueBuilder::makeCall(MATH_IMUL, left, right);
              } else {
                return ValueBuilder::makeBinary(left, MUL, right);
              }
            }
            case DivSInt32:
              ret = ValueBuilder::makeBinary(makeSigning(left, ASM_SIGNED), DIV,
                                             makeSigning(right, ASM_SIGNED));
              break;
            case DivUInt32:
              ret = ValueBuilder::makeBinary(makeSigning(left, ASM_UNSIGNED), DIV,
                                             makeSigning(right, ASM_UNSIGNED));
              break;
            case RemSInt32:
              ret = ValueBuilder::makeBinary(makeSigning(left, ASM_SIGNED), MOD,
                                             makeSigning(right, ASM_SIGNED));
              break;
            case RemUInt32:
              ret = ValueBuilder::makeBinary(makeSigning(left, ASM_UNSIGNED), MOD,
                                             makeSigning(right, ASM_UNSIGNED));
              break;
            case AndInt32:
              ret = ValueBuilder::makeBinary(left, AND, right);
              break;
            case OrInt32:
              ret = ValueBuilder::makeBinary(left, OR, right);
              break;
            case XorInt32:
              ret = ValueBuilder::makeBinary(left, XOR, right);
              break;
            case ShlInt32:
              ret = ValueBuilder::makeBinary(left, LSHIFT, right);
              break;
            case ShrUInt32:
              ret = ValueBuilder::makeBinary(left, TRSHIFT, right);
              break;
            case ShrSInt32:
              ret = ValueBuilder::makeBinary(left, RSHIFT, right);
              break;
            case EqInt32: {
              return ValueBuilder::makeBinary(makeSigning(left, ASM_SIGNED), EQ,
                                              makeSigning(right, ASM_SIGNED));
            }
            case NeInt32: {
              return ValueBuilder::makeBinary(makeSigning(left, ASM_SIGNED), NE,
                                              makeSigning(right, ASM_SIGNED));
            }
            case LtSInt32:
              return ValueBuilder::makeBinary(makeSigning(left, ASM_SIGNED), LT,
                                              makeSigning(right, ASM_SIGNED));
            case LtUInt32:
              return ValueBuilder::makeBinary(makeSigning(left, ASM_UNSIGNED), LT,
                                              makeSigning(right, ASM_UNSIGNED));
            case LeSInt32:
              return ValueBuilder::makeBinary(makeSigning(left, ASM_SIGNED), LE,
                                              makeSigning(right, ASM_SIGNED));
            case LeUInt32:
              return ValueBuilder::makeBinary(makeSigning(left, ASM_UNSIGNED), LE,
                                              makeSigning(right, ASM_UNSIGNED));
            case GtSInt32:
              return ValueBuilder::makeBinary(makeSigning(left, ASM_SIGNED), GT,
                                              makeSigning(right, ASM_SIGNED));
            case GtUInt32:
              return ValueBuilder::makeBinary(makeSigning(left, ASM_UNSIGNED), GT,
                                              makeSigning(right, ASM_UNSIGNED));
            case GeSInt32:
              return ValueBuilder::makeBinary(makeSigning(left, ASM_SIGNED), GE,
                                              makeSigning(right, ASM_SIGNED));
            case GeUInt32:
              return ValueBuilder::makeBinary(makeSigning(left, ASM_UNSIGNED), GE,
                                              makeSigning(right, ASM_UNSIGNED));
            case EqFloat32:
            case EqFloat64:
              return ValueBuilder::makeBinary(left, EQ, right);
            case NeFloat32:
            case NeFloat64:
              return ValueBuilder::makeBinary(left, NE, right);
            case GeFloat32:
            case GeFloat64:
              return ValueBuilder::makeBinary(left, GE, right);
            case GtFloat32:
            case GtFloat64:
              return ValueBuilder::makeBinary(left, GT, right);
            case LeFloat32:
            case LeFloat64:
              return ValueBuilder::makeBinary(left, LE, right);
            case LtFloat32:
            case LtFloat64:
              return ValueBuilder::makeBinary(left, LT, right);
            case RotLInt32:
            case RotRInt32:
              std::cerr << "should be removed already" << std::endl;
              WASM_UNREACHABLE();
            default: {
              std::cerr << "Unhandled i32 binary operator: " << curr << std::endl;
              abort();
            }
          }
          break;
        }
        case f32:
        case f64:
	  switch (curr->op) {
	    case AddFloat32:
	    case AddFloat64:
	      ret = ValueBuilder::makeBinary(left, PLUS, right);
              break;
            case SubFloat32:
            case SubFloat64:
              ret = ValueBuilder::makeBinary(left, MINUS, right);
              break;
            case MulFloat32:
            case MulFloat64:
              ret = ValueBuilder::makeBinary(left, MUL, right);
              break;
            case DivFloat32:
            case DivFloat64:
              ret = ValueBuilder::makeBinary(left, DIV, right);
              break;
            case MinFloat32:
            case MinFloat64:
              ret = ValueBuilder::makeCall(MATH_MIN, left, right);
              break;
            case MaxFloat32:
            case MaxFloat64:
              ret = ValueBuilder::makeCall(MATH_MAX, left, right);
              break;
            case CopySignFloat32:
            case CopySignFloat64:
            default:
              std::cerr << "Unhandled binary float operator: " << curr << std::endl;
              abort();
          }
          if (curr->type == f32) {
            return makeAsmCoercion(ret, ASM_FLOAT);
          }
          return ret;
        default:
          std::cerr << "Unhandled type in binary: " << curr << std::endl;
          abort();
      }
      return makeAsmCoercion(ret, wasmToAsmType(curr->type));
    }

    Ref visitSelect(Select* curr) {
      // normal select
      ScopedTemp tempIfTrue(curr->type, parent, func),
          tempIfFalse(curr->type, parent, func),
          tempCondition(i32, parent, func);
      Ref ifTrue = visit(curr->ifTrue, EXPRESSION_RESULT);
      Ref ifFalse = visit(curr->ifFalse, EXPRESSION_RESULT);
      Ref condition = visit(curr->condition, EXPRESSION_RESULT);
      return
        ValueBuilder::makeSeq(
          ValueBuilder::makeBinary(tempIfTrue.getAstName(), SET, ifTrue),
          ValueBuilder::makeSeq(
            ValueBuilder::makeBinary(tempIfFalse.getAstName(), SET, ifFalse),
            ValueBuilder::makeSeq(
              ValueBuilder::makeBinary(tempCondition.getAstName(), SET, condition),
              ValueBuilder::makeConditional(
                tempCondition.getAstName(),
                tempIfTrue.getAstName(),
                tempIfFalse.getAstName()
              )
            )
          )
        );
    }

    Ref visitReturn(Return* curr) {
      if (!curr->value) {
        return ValueBuilder::makeReturn(Ref());
      }
      Ref val = makeAsmCoercion(
        visit(curr->value, EXPRESSION_RESULT),
        wasmToAsmType(curr->value->type)
      );
      return ValueBuilder::makeReturn(val);
    }

    Ref visitHost(Host* curr) {
      Ref call;
      if (curr->op == HostOp::GrowMemory) {
        call = ValueBuilder::makeCall(WASM_GROW_MEMORY,
          makeAsmCoercion(
            visit(curr->operands[0], EXPRESSION_RESULT),
            wasmToAsmType(curr->operands[0]->type)));
      } else if (curr->op == HostOp::CurrentMemory) {
        call = ValueBuilder::makeCall(WASM_CURRENT_MEMORY);
      } else {
        return ValueBuilder::makeCall(ABORT_FUNC);
      }
      return call;
    }

    Ref visitNop(Nop* curr) {
      return ValueBuilder::makeToplevel();
    }

    Ref visitUnreachable(Unreachable* curr) {
      return ValueBuilder::makeCall(ABORT_FUNC);
    }

  private:
    Ref makePointer(Expression* ptr, Address offset) {
      auto ret = visit(ptr, EXPRESSION_RESULT);
      if (offset) {
        ret = makeAsmCoercion(
            ValueBuilder::makeBinary(ret, PLUS, ValueBuilder::makeNum(offset)),
            ASM_INT);
      }
      return ret;
    }
  };

  return ExpressionProcessor(this, m, func).visit(func->body, NO_RESULT);
}

void Wasm2JSBuilder::addMemoryGrowthFuncs(Ref ast, Module* wasm) {
  Ref growMemoryFunc = ValueBuilder::makeFunction(WASM_GROW_MEMORY);
  ValueBuilder::appendArgumentToFunction(growMemoryFunc, IString("pagesToAdd"));

  growMemoryFunc[3]->push_back(
    ValueBuilder::makeStatement(
      ValueBuilder::makeBinary(
        ValueBuilder::makeName(IString("pagesToAdd")), SET,
        makeAsmCoercion(
          ValueBuilder::makeName(IString("pagesToAdd")),
          AsmType::ASM_INT
        )
      )
    )
  );

  Ref oldPages = ValueBuilder::makeVar();
  growMemoryFunc[3]->push_back(oldPages);
  ValueBuilder::appendToVar(
    oldPages,
    IString("oldPages"),
    makeAsmCoercion(ValueBuilder::makeCall(WASM_CURRENT_MEMORY), AsmType::ASM_INT));

  Ref newPages = ValueBuilder::makeVar();
  growMemoryFunc[3]->push_back(newPages);
  ValueBuilder::appendToVar(
    newPages,
    IString("newPages"),
    makeAsmCoercion(ValueBuilder::makeBinary(
      ValueBuilder::makeName(IString("oldPages")),
      PLUS,
      ValueBuilder::makeName(IString("pagesToAdd"))
    ), AsmType::ASM_INT));

  Ref block = ValueBuilder::makeBlock();
  growMemoryFunc[3]->push_back(ValueBuilder::makeIf(
    ValueBuilder::makeBinary(
      ValueBuilder::makeBinary(
        ValueBuilder::makeName(IString("oldPages")),
        LT,
        ValueBuilder::makeName(IString("newPages"))
      ),
      IString("&&"),
      ValueBuilder::makeBinary(
        ValueBuilder::makeName(IString("newPages")),
        LT,
        ValueBuilder::makeInt(Memory::kMaxSize)
      )
    ), block, NULL));

  Ref newBuffer = ValueBuilder::makeVar();
  ValueBuilder::appendToBlock(block, newBuffer);
  ValueBuilder::appendToVar(
    newBuffer,
    IString("newBuffer"),
    ValueBuilder::makeNew(ValueBuilder::makeCall(
      ARRAY_BUFFER,
      ValueBuilder::makeCall(
        MATH_IMUL,
        ValueBuilder::makeName(IString("newPages")),
        ValueBuilder::makeInt(Memory::kPageSize)))));

  Ref newHEAP8 = ValueBuilder::makeVar();
  ValueBuilder::appendToBlock(block, newHEAP8);
  ValueBuilder::appendToVar(
    newHEAP8,
    IString("newHEAP8"),
    ValueBuilder::makeNew(
      ValueBuilder::makeCall(
        ValueBuilder::makeDot(
          ValueBuilder::makeName(GLOBAL),
          INT8ARRAY
        ),
        ValueBuilder::makeName(IString("newBuffer"))
      )
    ));

  ValueBuilder::appendToBlock(block,
    ValueBuilder::makeCall(
      ValueBuilder::makeDot(
        ValueBuilder::makeName(IString("newHEAP8")),
        IString("set")
      ),
      ValueBuilder::makeName(HEAP8)
    )
  );

  ValueBuilder::appendToBlock(block,
    ValueBuilder::makeBinary(
      ValueBuilder::makeName(HEAP8),
      SET,
      ValueBuilder::makeName(IString("newHEAP8"))
    )
  );

  auto setHeap = [&](IString name, IString view) {
    ValueBuilder::appendToBlock(block,
      ValueBuilder::makeBinary(
        ValueBuilder::makeName(name),
        SET,
        ValueBuilder::makeNew(
          ValueBuilder::makeCall(
            ValueBuilder::makeDot(
              ValueBuilder::makeName(GLOBAL),
              view
            ),
            ValueBuilder::makeName(IString("newBuffer"))
          )
        )
      )
    );
  };

  setHeap(HEAP16, INT16ARRAY);
  setHeap(HEAP32, INT32ARRAY);
  setHeap(HEAPU8,  UINT8ARRAY);
  setHeap(HEAPU16, UINT16ARRAY);
  setHeap(HEAPU32, UINT32ARRAY);
  setHeap(HEAPF32, FLOAT32ARRAY);
  setHeap(HEAPF64, FLOAT64ARRAY);

  ValueBuilder::appendToBlock(block,
    ValueBuilder::makeBinary(
      ValueBuilder::makeName(BUFFER),
      SET,
      ValueBuilder::makeName(IString("newBuffer"))
    )
  );

  // apply the changes to the memory import
  if (wasm->memory.imported()) {
    ValueBuilder::appendToBlock(block,
      ValueBuilder::makeBinary(
        ValueBuilder::makeDot(
          ValueBuilder::makeName("memory"),
          ValueBuilder::makeName(BUFFER)
        ),
        SET,
        ValueBuilder::makeName(IString("newBuffer"))
      )
    );
  }

  growMemoryFunc[3]->push_back(
    ValueBuilder::makeReturn(
      ValueBuilder::makeName(IString("oldPages"))));

  Ref currentMemoryFunc = ValueBuilder::makeFunction(WASM_CURRENT_MEMORY);
  currentMemoryFunc[3]->push_back(ValueBuilder::makeReturn(
    makeAsmCoercion(
      ValueBuilder::makeBinary(
        ValueBuilder::makeDot(
          ValueBuilder::makeName(BUFFER),
          IString("byteLength")
        ),
        DIV,
        ValueBuilder::makeInt(Memory::kPageSize)
      ),
      AsmType::ASM_INT
    )
  ));
  ast->push_back(growMemoryFunc);
  ast->push_back(currentMemoryFunc);
}

// Wasm2JSGlue emits the core of the module - the functions etc. that would
// be the asm.js function in an asm.js world. This class emits the rest of the
// "glue" around that.
class Wasm2JSGlue {
public:
  Wasm2JSGlue(Module& wasm, Output& out, Wasm2JSBuilder::Flags flags, Name moduleName) : wasm(wasm), out(out), flags(flags), moduleName(moduleName) {}

  void emitPre();
  void emitPost();

private:
  Module& wasm;
  Output& out;
  Wasm2JSBuilder::Flags flags;
  Name moduleName;

  void emitPreEmscripten();
  void emitPreES6();
  void emitPostEmscripten();
  void emitPostES6();

  void emitMemory(std::string buffer, std::string segmentWriter);
  void emitScratchMemorySupport();
};

void Wasm2JSGlue::emitPre() {
  if (flags.emscripten) {
    emitPreEmscripten();
  } else {
    emitPreES6();
  }

  emitScratchMemorySupport();
}

void Wasm2JSGlue::emitPreEmscripten() {
  out << "function instantiate(asmLibraryArg, wasmMemory, FUNCTION_TABLE) {\n\n";
}

void Wasm2JSGlue::emitPreES6() {
  std::unordered_map<Name, Name> baseModuleMap;

  auto noteImport = [&](Name module, Name base) {
    // Right now codegen requires a flat namespace going into the module,
    // meaning we don't support importing the same name from multiple namespaces yet.
    if (baseModuleMap.count(base) && baseModuleMap[base] != module) {
      Fatal() << "the name " << base << " cannot be imported from "
              << "two different modules yet\n";
      abort();
    }
    baseModuleMap[base] = module;

    out << "import { "
        << base.str
        << " } from '"
        << module.str
        << "';\n";
  };

  ImportInfo imports(wasm);

  ModuleUtils::iterImportedGlobals(wasm, [&](Global* import) {
    noteImport(import->module, import->base);
  });
  ModuleUtils::iterImportedFunctions(wasm, [&](Function* import) {
    // The scratch memory helpers are emitted in the glue, see code and comments below.
    if (ABI::wasm2js::isScratchMemoryHelper(import->base)) {
      return;
    }
    noteImport(import->module, import->base);
  });

  out << '\n';
}

void Wasm2JSGlue::emitPost() {
  if (flags.emscripten) {
    emitPostEmscripten();
  } else {
    emitPostES6();
  }
}

void Wasm2JSGlue::emitPostEmscripten() {
  emitMemory("wasmMemory.buffer", "writeSegment");

  out << "return asmFunc({\n"
      << "    'Int8Array': Int8Array,\n"
      << "    'Int16Array': Int16Array,\n"
      << "    'Int32Array': Int32Array,\n"
      << "    'Uint8Array': Uint8Array,\n"
      << "    'Uint16Array': Uint16Array,\n"
      << "    'Uint32Array': Uint32Array,\n"
      << "    'Float32Array': Float32Array,\n"
      << "    'Float64Array': Float64Array,\n"
      << "    'NaN': NaN,\n"
      << "    'Infinity': Infinity,\n"
      << "    'Math': Math\n"
      << "  },\n"
      << "  asmLibraryArg,\n"
      << "  wasmMemory.buffer\n"
      << ")"
      << "\n"
      << "\n"
      << "}";
}

void Wasm2JSGlue::emitPostES6() {
  // Create an initial `ArrayBuffer` and populate it with static data.
  // Currently we use base64 encoding to encode static data and we decode it at
  // instantiation time.
  //
  // Note that the translation here expects that the lower values of this memory
  // can be used for conversions, so make sure there's at least one page.
  {
    auto pages = wasm.memory.initial == 0 ? 1 : wasm.memory.initial.addr;
    out << "const mem" << moduleName.str << " = new ArrayBuffer("
      << pages * Memory::kPageSize
      << ");\n";
  }

  emitMemory(std::string("mem") + moduleName.str,
             std::string("assign") + moduleName.str);

  // Actually invoke the `asmFunc` generated function, passing in all global
  // values followed by all imports
  out << "const ret" << moduleName.str << " = " << moduleName.str << "({"
    << "Math,"
    << "Int8Array,"
    << "Uint8Array,"
    << "Int16Array,"
    << "Uint16Array,"
    << "Int32Array,"
    << "Uint32Array,"
    << "Float32Array,"
    << "Float64Array,"
    << "NaN,"
    << "Infinity"
    << "}, {";

  out << "abort:function() { throw new Error('abort'); }";

  ModuleUtils::iterImportedFunctions(wasm, [&](Function* import) {
    // The scratch memory helpers are emitted in the glue, see code and comments below.
    if (ABI::wasm2js::isScratchMemoryHelper(import->base)) {
      return;
    }
    out << "," << import->base.str;
  });
  out << "},mem" << moduleName.str << ");\n";

  if (flags.allowAsserts) {
    return;
  }

  // And now that we have our returned instance, export all our functions
  // that are hanging off it.
  for (auto& exp : wasm.exports) {
    switch (exp->kind) {
      case ExternalKind::Function:
      case ExternalKind::Memory:
        break;

      // Exported globals and function tables aren't supported yet
      default:
        continue;
    }
    std::ostringstream export_name;
    for (auto *ptr = exp->name.str; *ptr; ptr++) {
      if (*ptr == '-') {
        export_name << '_';
      } else {
        export_name << *ptr;
      }
    }
    out << "export const "
      << asmangle(exp->name.str)
      << " = ret"
      << moduleName.str
      << "."
      << asmangle(exp->name.str)
      << ";\n";
  }
}

void Wasm2JSGlue::emitMemory(std::string buffer, std::string segmentWriter) {
  if (wasm.memory.segments.empty()) return;

  auto expr = R"(
    function(mem) {
      const _mem = new Uint8Array(mem);
      return function(offset, s) {
        if (typeof Buffer === 'undefined') {
          const bytes = atob(s);
          for (let i = 0; i < bytes.length; i++)
            _mem[offset + i] = bytes.charCodeAt(i);
        } else {
          const bytes = Buffer.from(s, 'base64');
          for (let i = 0; i < bytes.length; i++)
            _mem[offset + i] = bytes[i];
        }
      }
    }
  )";

  // const assign$name = ($expr)(mem$name);
  out << "const " << segmentWriter
      << " = (" << expr << ")(" << buffer << ");\n";

  for (auto& seg : wasm.memory.segments) {
    assert(!seg.isPassive && "passive segments not implemented yet");
    out << segmentWriter << "("
      << constOffset(seg)
      << ", \""
      << base64Encode(seg.data)
      << "\");\n";
  }
}

void Wasm2JSGlue::emitScratchMemorySupport() {
  // The scratch memory helpers are emitted here the glue. We may also want to
  // emit them inline at some point. (The reason they are imports is so that
  // they appear as "intrinsics" placeholders, and not normal functions that
  // the optimizer might want to do something with.)
  bool needScratchMemory = false;
  ModuleUtils::iterImportedFunctions(wasm, [&](Function* import) {
    if (ABI::wasm2js::isScratchMemoryHelper(import->base)) {
      needScratchMemory = true;
    }
  });
  if (!needScratchMemory) return;

  out << R"(
  var scratchBuffer = new ArrayBuffer(8);
  var i32ScratchView = new Int32Array(scratchBuffer);
  var f32ScratchView = new Float32Array(scratchBuffer);
  var f64ScratchView = new Float64Array(scratchBuffer);
  )";

  ModuleUtils::iterImportedFunctions(wasm, [&](Function* import) {
    if (import->base == ABI::wasm2js::SCRATCH_STORE_I32) {
      out << R"(
  function wasm2js_scratch_store_i32(index, value) {
    i32ScratchView[index] = value;
  }
      )";
    } else if (import->base == ABI::wasm2js::SCRATCH_LOAD_I32) {
      out << R"(
  function wasm2js_scratch_load_i32(index) {
    return i32ScratchView[index];
  }
      )";
    } else if (import->base == ABI::wasm2js::SCRATCH_STORE_I64) {
      out << R"(
  function legalimport$wasm2js_scratch_store_i64(low, high) {
    i32ScratchView[0] = low;
    i32ScratchView[1] = high;
  }
      )";
    } else if (import->base == ABI::wasm2js::SCRATCH_LOAD_I64) {
      out << R"(
  function legalimport$wasm2js_scratch_load_i64() {
    if (typeof setTempRet0 === 'function') setTempRet0(i32ScratchView[1]);
    return i32ScratchView[0];
  }
      )";
    } else if (import->base == ABI::wasm2js::SCRATCH_STORE_F32) {
      out << R"(
  function wasm2js_scratch_store_f32(value) {
    f32ScratchView[0] = value;
  }
      )";
    } else if (import->base == ABI::wasm2js::SCRATCH_LOAD_F32) {
      out << R"(
  function wasm2js_scratch_load_f32() {
    return f32ScratchView[0];
  }
      )";
    } else if (import->base == ABI::wasm2js::SCRATCH_STORE_F64) {
      out << R"(
  function wasm2js_scratch_store_f64(value) {
    f64ScratchView[0] = value;
  }
      )";
    } else if (import->base == ABI::wasm2js::SCRATCH_LOAD_F64) {
      out << R"(
  function wasm2js_scratch_load_f64() {
    return f64ScratchView[0];
  }
      )";
    }
  });
  out << '\n';
}

} // namespace wasm

#endif // wasm_wasm2js_h
