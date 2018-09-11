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
// WebAssembly-to-asm.js translator. Uses the Emscripten optimizer
// infrastructure.
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
#include "ir/import-utils.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/utils.h"
#include "passes/passes.h"

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
// Wasm2JSBuilder - converts a WebAssembly module into asm.js
//
// In general, asm.js => wasm is very straightforward, as can
// be seen in asm2wasm.h. Just a single pass, plus a little
// state bookkeeping (breakStack, etc.), and a few after-the
// fact corrections for imports, etc. However, wasm => asm.js
// is tricky because wasm has statements == expressions, or in
// other words, things like `break` and `if` can show up
// in places where asm.js can't handle them, like inside an
// a loop's condition check.
//
// We therefore need the ability to lower an expression into
// a block of statements, and we keep statementizing until we
// reach a context in which we can emit those statments. This
// requires that we create temp variables to store values
// that would otherwise flow directly into their targets if
// we were an expression (e.g. if a loop's condition check
// is a bunch of statements, we execute those statements,
// then use the computed value in the loop's condition;
// we might also be able to avoid an assign to a temp var
// at the end of those statements, and put just that
// value in the loop's condition).
//
// It is possible to do this in a single pass, if we just
// allocate temp vars freely. However, pathological cases
// can easily show bad behavior here, with many unnecessary
// temp vars. We could rely on optimization passes like
// Emscripten's eliminate/registerize pair, but we want
// wasm2js to be fairly fast to run, as it might run on
// the client.
//
// The approach taken here therefore performs 2 passes on
// each function. First, it finds which expression will need to
// be statementized. It also sees which labels can receive a break
// with a value. Given that information, in the second pass we can
// allocate // temp vars in an efficient manner, as we know when we
// need them and when their use is finished. They are allocated
// using an RAII class, so that they are automatically freed
// when the scope ends. This means that a node cannot allocate
// its own temp var; instead, the parent - which knows the
// child will return a value in a temp var - allocates it,
// and tells the child what temp var to emit to. The child
// can then pass forward that temp var to its children,
// optimizing away unnecessary forwarding.


class Wasm2JSBuilder {
  MixedArena allocator;

public:
  struct Flags {
    bool debug = false;
    bool pedantic = false;
    bool allowAsserts = false;
  };

  Wasm2JSBuilder(Flags f) : flags(f) {}

  Ref processWasm(Module* wasm, Name funcName = ASM_FUNC);
  Ref processFunction(Module* wasm, Function* func);

  // The first pass on an expression: scan it to see whether it will
  // need to be statementized, and note spooky returns of values at
  // a distance (aka break with a value).
  void scanFunctionBody(Expression* curr);

  // The second pass on an expression: process it fully, generating
  // asm.js
  // @param result Whether the context we are in receives a value,
  //               and its type, or if not, then we can drop our return,
  //               if we have one.
  Ref processFunctionBody(Module* m, Function* func, IString result);

  Ref processAsserts(Module* wasm, Element& e, SExpressionWasmBuilder& sexpBuilder);

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
      if (scope == NameScope::Top) {
        Fatal() << "global scope is colliding with other scope: " << mangled << '\n';
        abort();
      }
    }
    allMangledNames.insert(ret);
    mangledScope[name.c_str()] = ret;
    return ret;
  }

  void setStatement(Expression* curr) {
    willBeStatement.insert(curr);
  }

  bool isStatement(Expression* curr) {
    return curr && willBeStatement.find(curr) != willBeStatement.end();
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

  // Expressions that will be a statement.
  std::set<Expression*> willBeStatement;

  // Mangled names cache by interned names.
  // Utilizes the usually reused underlying cstring's pointer as the key.
  std::unordered_map<const char*, IString> mangledNames[(int) NameScope::Max];
  std::unordered_set<IString> allMangledNames;

  // All our function tables have the same size TODO: optimize?
  size_t tableSize;

  bool almostASM = false;

  void addEsmImports(Ref ast, Module* wasm);
  void addEsmExportsAndInstantiate(Ref ast, Module* wasm, Name funcName);
  void addBasics(Ref ast);
  void addFunctionImport(Ref ast, Function* import);
  void addTables(Ref ast, Module* wasm);
  void addExports(Ref ast, Module* wasm);
  void addGlobal(Ref ast, Global* global);
  void setNeedsAlmostASM(const char *reason);
  void addMemoryGrowthFuncs(Ref ast);
  bool isAssertHandled(Element& e);
  Ref makeAssertReturnFunc(SExpressionWasmBuilder& sexpBuilder,
                           Module* wasm,
                           Builder& wasmBuilder,
                           Element& e,
                           Name testFuncName,
                           Name asmModule);
  Ref makeAssertReturnNanFunc(SExpressionWasmBuilder& sexpBuilder,
                              Module* wasm,
                              Builder& wasmBuilder,
                              Element& e,
                              Name testFuncName,
                              Name asmModule);
  Ref makeAssertTrapFunc(SExpressionWasmBuilder& sexpBuilder,
                         Module* wasm,
                         Builder& wasmBuilder,
                         Element& e,
                         Name testFuncName,
                         Name asmModule);
  Wasm2JSBuilder() = delete;
  Wasm2JSBuilder(const Wasm2JSBuilder &) = delete;
  Wasm2JSBuilder &operator=(const Wasm2JSBuilder&) = delete;
};

Ref Wasm2JSBuilder::processWasm(Module* wasm, Name funcName) {
  PassRunner runner(wasm);
  runner.add<AutoDrop>();
  // First up remove as many non-JS operations we can, including things like
  // 64-bit integer multiplication/division, `f32.nearest` instructions, etc.
  // This may inject intrinsics which use i64 so it needs to be run before the
  // i64-to-i32 lowering pass.
  runner.add("remove-non-js-ops");
  // Currently the i64-to-32 lowering pass requires that `flatten` be run before
  // it produce correct code. For some more details about this see #1480
  runner.add("flatten");
  runner.add("i64-to-i32-lowering");
  runner.add("flatten");
  runner.add("simplify-locals-notee-nostructure");
  runner.add("reorder-locals");
  runner.add("vacuum");
  runner.setDebug(flags.debug);
  runner.run();

  // Make sure we didn't corrupt anything if we're in --allow-asserts mode (aka
  // tests)
#ifndef NDEBUG
  if (!WasmValidator().validate(*wasm)) {
    WasmPrinter::printModule(wasm);
    Fatal() << "error in validating input";
  }
#endif

  Ref ret = ValueBuilder::makeToplevel();
  addEsmImports(ret, wasm);
  Ref asmFunc = ValueBuilder::makeFunction(funcName);
  ret[1]->push_back(asmFunc);
  addEsmExportsAndInstantiate(ret, wasm, funcName);
  ValueBuilder::appendArgumentToFunction(asmFunc, GLOBAL);
  ValueBuilder::appendArgumentToFunction(asmFunc, ENV);
  ValueBuilder::appendArgumentToFunction(asmFunc, BUFFER);
  asmFunc[3]->push_back(ValueBuilder::makeStatement(ValueBuilder::makeString(USE_ASM)));
  // create heaps, etc
  addBasics(asmFunc[3]);
  ModuleUtils::iterImportedFunctions(*wasm, [&](Function* import) {
    addFunctionImport(asmFunc[3], import);
  });
  ModuleUtils::iterImportedGlobals(*wasm, [&](Global* import) {
    addGlobal(asmFunc[3], import);
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
      builder.makeGetGlobal(INT64_TO_32_HIGH_BITS, i32)
    )));
    auto e = new Export();
    e->name = WASM_FETCH_HIGH_BITS;
    e->value = WASM_FETCH_HIGH_BITS;
    e->kind = ExternalKind::Function;
    wasm->addExport(e);
  }

  addTables(asmFunc[3], wasm);
  // memory XXX
  addExports(asmFunc[3], wasm);
  return ret;
}

void Wasm2JSBuilder::addEsmImports(Ref ast, Module* wasm) {
  std::unordered_map<Name, Name> nameMap;

  ImportInfo imports(*wasm);
  if (imports.getNumImportedGlobals() > 0) {
    Fatal() << "non-function imports aren't supported yet\n";
    abort();
  }
  ModuleUtils::iterImportedFunctions(*wasm, [&](Function* import) {
    // Right now codegen requires a flat namespace going into the module,
    // meaning we don't importing the same name from multiple namespaces yet.
    if (nameMap.count(import->base) && nameMap[import->base] != import->module) {
        Fatal() << "the name " << import->base << " cannot be imported from "
            << "two different modules yet\n";
        abort();
    }

    nameMap[import->base] = import->module;

    std::ostringstream out;
    out << "import { "
      << import->base.str
      << " } from '"
      << import->module.str
      << "'";
    std::string os = out.str();
    IString name(os.c_str(), false);
    flattenAppend(ast, ValueBuilder::makeName(name));
  });
}

static std::string base64Encode(std::vector<char> &data) {
  std::string ret;
  size_t i = 0;

  const char* alphabet =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    "abcdefghijklmnopqrstuvwxyz"
    "0123456789+/";

  while (i + 3 <= data.size()) {
    uint32_t bits =
      (((uint32_t)(uint8_t) data[i + 0]) << 16) |
      (((uint32_t)(uint8_t) data[i + 1]) << 8) |
      (((uint32_t)(uint8_t) data[i + 2]) << 0);
    ret += alphabet[(bits >> 18) & 0x3f];
    ret += alphabet[(bits >> 12) & 0x3f];
    ret += alphabet[(bits >> 6) & 0x3f];
    ret += alphabet[(bits >> 0) & 0x3f];
    i += 3;
  }

  if (i + 2 == data.size()) {
    uint32_t bits =
      (((uint32_t)(uint8_t) data[i + 0]) << 8) |
      (((uint32_t)(uint8_t) data[i + 1]) << 0);
    ret += alphabet[(bits >> 10) & 0x3f];
    ret += alphabet[(bits >> 4) & 0x3f];
    ret += alphabet[(bits << 2) & 0x3f];
    ret += '=';
  } else if (i + 1 == data.size()) {
    uint32_t bits = (uint32_t)(uint8_t) data[i + 0];
    ret += alphabet[(bits >> 2) & 0x3f];
    ret += alphabet[(bits << 4) & 0x3f];
    ret += '=';
    ret += '=';
  } else {
    assert(i == data.size());
  }

  return ret;
}

void Wasm2JSBuilder::addEsmExportsAndInstantiate(Ref ast, Module *wasm, Name funcName) {
  // Create an initial `ArrayBuffer` and populate it with static data.
  // Currently we use base64 encoding to encode static data and we decode it at
  // instantiation time.
  //
  // Note that the translation here expects that the lower values of this memory
  // can be used for conversions, so make sure there's at least one page.
  {
    auto pages = wasm->memory.initial == 0 ? 1 : wasm->memory.initial.addr;
    std::ostringstream out;
    out << "const mem" << funcName.str << " = new ArrayBuffer("
      << pages * Memory::kPageSize
      << ")";
    std::string os = out.str();
    IString name(os.c_str(), false);
    flattenAppend(ast, ValueBuilder::makeName(name));
  }

  if (wasm->memory.segments.size() > 0) {
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
    std::ostringstream out;
    out << "const assign" << funcName.str
      << " = (" << expr << ")(mem" << funcName.str << ")";
    std::string os = out.str();
    IString name(os.c_str(), false);
    flattenAppend(ast, ValueBuilder::makeName(name));
  }
  for (auto& seg : wasm->memory.segments) {
    std::ostringstream out;
    out << "assign" << funcName.str << "("
      << constOffset(seg)
      << ", \""
      << base64Encode(seg.data)
      << "\")";
    std::string os = out.str();
    IString name(os.c_str(), false);
    flattenAppend(ast, ValueBuilder::makeName(name));
  }

  // Actually invoke the `asmFunc` generated function, passing in all global
  // values followed by all imports (imported via addEsmImports above)
  std::ostringstream construct;
  construct << "const ret" << funcName.str << " = " << funcName.str << "({"
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

  construct << "abort:function() { throw new Error('abort'); }";

  ModuleUtils::iterImportedFunctions(*wasm, [&](Function* import) {
    construct << "," << import->base.str;
  });
  construct << "},mem" << funcName.str << ")";
  std::string sconstruct = construct.str();
  IString name(sconstruct.c_str(), false);
  flattenAppend(ast, ValueBuilder::makeName(name));

  if (flags.allowAsserts) {
    return;
  }

  // And now that we have our returned instance, export all our functions
  // that are hanging off it.
  for (auto& exp : wasm->exports) {
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
    std::ostringstream out;
    out << "export const "
      << fromName(exp->name, NameScope::Top).str
      << " = ret"
      << funcName.str
      << "."
      << fromName(exp->name, NameScope::Top).str;
    std::string os = out.str();
    IString name(os.c_str(), false);
    flattenAppend(ast, ValueBuilder::makeName(name));
  }
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

void Wasm2JSBuilder::addTables(Ref ast, Module* wasm) {
  std::map<std::string, std::vector<IString>> tables; // asm.js tables, sig => contents of table
  for (Table::Segment& seg : wasm->table.segments) {
    for (size_t i = 0; i < seg.data.size(); i++) {
      Name name = seg.data[i];
      auto func = wasm->getFunction(name);
      std::string sig = getSig(func);
      auto& table = tables[sig];
      if (table.size() == 0) {
        // fill it with the first of its type seen. we have to fill with something; and for asm2wasm output, the first is the null anyhow
        table.resize(tableSize);
        for (size_t j = 0; j < tableSize; j++) {
          table[j] = fromName(name, NameScope::Top);
        }
      } else {
        table[i + constOffset(seg)] = fromName(name, NameScope::Top);
      }
    }
  }
  for (auto& pair : tables) {
    auto& sig = pair.first;
    auto& table = pair.second;
    std::string stable = std::string("FUNCTION_TABLE_") + sig;
    IString asmName = IString(stable.c_str(), false);
    // add to asm module
    Ref theVar = ValueBuilder::makeVar();
    ast->push_back(theVar);
    Ref theArray = ValueBuilder::makeArray();
    ValueBuilder::appendToVar(theVar, asmName, theArray);
    for (auto& name : table) {
      ValueBuilder::appendToArray(theArray, ValueBuilder::makeName(name));
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
      setNeedsAlmostASM("memory export");
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
  if (almostASM) {
    // replace "use asm"
    ast[0] = ValueBuilder::makeStatement(ValueBuilder::makeString(ALMOST_ASM));
    addMemoryGrowthFuncs(ast);
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
  } else {
    assert(false && "Top init type not supported");
  }
}

static bool expressionEndsInReturn(Expression *e) {
  if (e->is<Return>()) {
    return true;
  }
  if (!e->is<Block>()) {
    return false;
  }
  ExpressionList* stats = &static_cast<Block*>(e)->list;
  return expressionEndsInReturn((*stats)[stats->size()-1]);
}

Ref Wasm2JSBuilder::processFunction(Module* m, Function* func) {
  if (flags.debug) {
    static int fns = 0;
    std::cerr << "processFunction " << (fns++) << " " << func->name
              << std::endl;
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
  auto appendFinalReturn = [&] (Ref retVal) {
    flattenAppend(
      ret,
      ValueBuilder::makeReturn(
        makeAsmCoercion(retVal, wasmToAsmType(func->result))
      )
    );
  };
  scanFunctionBody(func->body);
  bool endsInReturn = expressionEndsInReturn(func->body);
  if (endsInReturn) {
    // return already taken care of
    flattenAppend(ret, processFunctionBody(m, func, NO_RESULT));
  } else if (isStatement(func->body)) {
    // store result in variable then return it
    IString result =
      func->result != none ? getTemp(func->result, func) : NO_RESULT;
    flattenAppend(ret, processFunctionBody(m, func, result));
    if (func->result != none) {
      appendFinalReturn(ValueBuilder::makeName(result));
      freeTemp(func->result, result);
    }
  } else if (func->result != none) {
    // whole thing is an expression, just return body
    appendFinalReturn(processFunctionBody(m, func, EXPRESSION_RESULT));
  } else {
    // func has no return
    flattenAppend(ret, processFunctionBody(m, func, NO_RESULT));
  }
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
  // cleanups
  willBeStatement.clear();
  return ret;
}

void Wasm2JSBuilder::scanFunctionBody(Expression* curr) {
  struct ExpressionScanner : public PostWalker<ExpressionScanner> {
    Wasm2JSBuilder* parent;

    ExpressionScanner(Wasm2JSBuilder* parent) : parent(parent) {}

    // Visitors

    void visitBlock(Block* curr) {
      parent->setStatement(curr);
    }
    void visitIf(If* curr) {
      parent->setStatement(curr);
    }
    void visitLoop(Loop* curr) {
      parent->setStatement(curr);
    }
    void visitBreak(Break* curr) {
      parent->setStatement(curr);
    }
    void visitSwitch(Switch* curr) {
      parent->setStatement(curr);
    }
    void visitCall(Call* curr) {
      for (auto item : curr->operands) {
        if (parent->isStatement(item)) {
          parent->setStatement(curr);
          break;
        }
      }
    }
    void visitCallIndirect(CallIndirect* curr) {
      // TODO: this is a pessimization that probably wants to get tweaked in
      // the future. If none of the arguments have any side effects then we
      // should be able to safely have tighter codegen.
      parent->setStatement(curr);
    }
    void visitSetLocal(SetLocal* curr) {
      if (parent->isStatement(curr->value)) {
        parent->setStatement(curr);
      }
    }
    void visitLoad(Load* curr) {
      if (parent->isStatement(curr->ptr)) {
        parent->setStatement(curr);
      }
    }
    void visitStore(Store* curr) {
      parent->setStatement(curr);
    }
    void visitUnary(Unary* curr) {
      if (parent->isStatement(curr->value)) {
        parent->setStatement(curr);
      }
    }
    void visitBinary(Binary* curr) {
      if (parent->isStatement(curr->left) || parent->isStatement(curr->right)) {
        parent->setStatement(curr);
      }
    }
    void visitSelect(Select* curr) {
      if (parent->isStatement(curr->ifTrue) || parent->isStatement(curr->ifFalse) || parent->isStatement(curr->condition)) {
        parent->setStatement(curr);
      }
    }
    void visitReturn(Return* curr) {
      parent->setStatement(curr);
    }
    void visitHost(Host* curr) {
      for (auto item : curr->operands) {
        if (parent->isStatement(item)) {
          parent->setStatement(curr);
          break;
        }
      }
    }
  };
  ExpressionScanner(this).walk(curr);
}

Ref Wasm2JSBuilder::processFunctionBody(Module* m, Function* func, IString result) {
  struct ExpressionProcessor : public Visitor<ExpressionProcessor, Ref> {
    Wasm2JSBuilder* parent;
    IString result;
    Function* func;
    Module* module;
    MixedArena allocator;
    ExpressionProcessor(Wasm2JSBuilder* parent, Module* m, Function* func)
      : parent(parent), func(func), module(m) {}

    // A scoped temporary variable.
    struct ScopedTemp {
      Wasm2JSBuilder* parent;
      Type type;
      IString temp;
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

    // this result is for an asm expression slot, but it might be a statement
    Ref visitForExpression(Expression* curr, Type type, IString& tempName) {
      if (isStatement(curr)) {
        ScopedTemp temp(type, parent, func);
        tempName = temp.temp;
        return visit(curr, temp);
      } else {
        return visit(curr, EXPRESSION_RESULT);
      }
    }

    Ref visitAndAssign(Expression* curr, IString result) {
      Ref ret = visit(curr, result);
      // if it's not already a statement, then it's an expression, and we need to assign it
      // (if it is a statement, it already assigns to the result var)
      if (!isStatement(curr) && result != NO_RESULT) {
        ret = ValueBuilder::makeStatement(
            ValueBuilder::makeBinary(ValueBuilder::makeName(result), SET, ret));
      }
      return ret;
    }

    Ref visitAndAssign(Expression* curr, ScopedTemp& temp) {
      return visitAndAssign(curr, temp.getName());
    }

    bool isStatement(Expression* curr) {
      return parent->isStatement(curr);
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
      Ref condition = visitForExpression(curr->condition, i32, temp);
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
      Ref theBreak;
      auto iter = continueLabels.find(curr->name);
      if (iter == continueLabels.end()) {
        theBreak = ValueBuilder::makeBreak(fromName(curr->name, NameScope::Label));
      } else {
        theBreak = ValueBuilder::makeContinue(fromName(curr->name, NameScope::Label));
      }
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
      Ref condition;
      if (isStatement(curr->condition)) {
        ScopedTemp temp(i32, parent, func);
        flattenAppend(ret[2], visit(curr->condition, temp));
        condition = temp.getAstName();
      } else {
        condition = visit(curr->condition, EXPRESSION_RESULT);
      }
      Ref theSwitch =
        ValueBuilder::makeSwitch(makeAsmCoercion(condition, ASM_INT));
      ret[1]->push_back(theSwitch);
      for (size_t i = 0; i < curr->targets.size(); i++) {
        ValueBuilder::appendCaseToSwitch(theSwitch, ValueBuilder::makeNum(i));
        ValueBuilder::appendCodeToSwitch(theSwitch, blockify(ValueBuilder::makeBreak(fromName(curr->targets[i], NameScope::Label))), false);
      }
      ValueBuilder::appendDefaultToSwitch(theSwitch);
      ValueBuilder::appendCodeToSwitch(theSwitch, blockify(ValueBuilder::makeBreak(fromName(curr->default_, NameScope::Label))), false);
      return ret;
    }

    Ref makeStatementizedCall(ExpressionList& operands,
                              Ref ret,
                              std::function<Ref()> genTheCall,
                              IString result,
                              Type type) {
      std::vector<ScopedTemp*> temps; // TODO: utility class, with destructor?
      for (auto& operand : operands) {
        temps.push_back(new ScopedTemp(operand->type, parent, func));
        IString temp = temps.back()->temp;
        flattenAppend(ret, visitAndAssign(operand, temp));
      }
      Ref theCall = genTheCall();
      for (size_t i = 0; i < temps.size(); i++) {
        IString temp = temps[i]->temp;
        auto &operand = operands[i];
        theCall[2]->push_back(makeAsmCoercion(ValueBuilder::makeName(temp), wasmToAsmType(operand->type)));
      }
      theCall = makeAsmCoercion(theCall, wasmToAsmType(type));
      if (result != NO_RESULT) {
        theCall = ValueBuilder::makeStatement(
            ValueBuilder::makeBinary(
                ValueBuilder::makeName(result), SET, theCall));
      }
      flattenAppend(ret, theCall);
      for (auto temp : temps) {
        delete temp;
      }
      return ret;
    }

    Ref visitGenericCall(Expression* curr, Name target,
                         ExpressionList& operands) {
      Ref theCall = ValueBuilder::makeCall(fromName(target, NameScope::Top));
      if (!isStatement(curr)) {
        // none of our operands is a statement; go right ahead and create a
        // simple expression
        for (auto operand : operands) {
          theCall[2]->push_back(
            makeAsmCoercion(visit(operand, EXPRESSION_RESULT),
                            wasmToAsmType(operand->type)));
        }
        return makeAsmCoercion(theCall, wasmToAsmType(curr->type));
      }
      // we must statementize them all
      return makeStatementizedCall(operands, ValueBuilder::makeBlock(),
                                   [&]() { return theCall; },
                                   result, curr->type);
    }

    Ref visitCall(Call* curr) {
      return visitGenericCall(curr, curr->target, curr->operands);
    }

    Ref visitCallIndirect(CallIndirect* curr) {
      // TODO: the codegen here is a pessimization of what the ideal codegen
      // looks like. Eventually if necessary this should be tightened up in the
      // case that the argument expression don't have any side effects.
      assert(isStatement(curr));
      std::string stable = std::string("FUNCTION_TABLE_") +
        getSig(module->getFunctionType(curr->fullType));
      IString table = IString(stable.c_str(), false);
      Ref ret = ValueBuilder::makeBlock();
      ScopedTemp idx(i32, parent, func);
      return makeStatementizedCall(
        curr->operands,
        ret,
        [&]() {
          flattenAppend(ret, visitAndAssign(curr->target, idx));
          return ValueBuilder::makeCall(ValueBuilder::makeSub(
            ValueBuilder::makeName(table),
            ValueBuilder::makeBinary(idx.getAstName(), AND, ValueBuilder::makeInt(parent->getTableSize()-1))
          ));
        },
        result,
        curr->type
      );
    }

    Ref makeSetVar(Expression* curr, Expression* value, Name name, NameScope scope) {
      if (!isStatement(curr)) {
        return ValueBuilder::makeBinary(
          ValueBuilder::makeName(fromName(name, scope)), SET,
          visit(value, EXPRESSION_RESULT)
        );
      }
      // if result was provided, our child can just assign there.
      // Otherwise, allocate a temp for it to assign to.
      ScopedTemp temp(value->type, parent, func, result);
      Ref ret = blockify(visit(value, temp));
      // the output was assigned to result, so we can just assign it to our target
      ret[1]->push_back(
        ValueBuilder::makeStatement(
          ValueBuilder::makeBinary(
            ValueBuilder::makeName(fromName(name, scope)), SET,
            temp.getAstName()
          )
        )
      );
      return ret;
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
      if (isStatement(curr)) {
        ScopedTemp temp(i32, parent, func);
        GetLocal fakeLocal(allocator);
        fakeLocal.index = func->getLocalIndex(temp.getName());
        Load fakeLoad = *curr;
        fakeLoad.ptr = &fakeLocal;
        Ref ret = blockify(visitAndAssign(curr->ptr, temp));
        flattenAppend(ret, visitAndAssign(&fakeLoad, result));
        return ret;
      }
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
      Ref ptr = visit(curr->ptr, EXPRESSION_RESULT);
      if (curr->offset) {
        ptr = makeAsmCoercion(
            ValueBuilder::makeBinary(ptr, PLUS, ValueBuilder::makeNum(curr->offset)),
            ASM_INT);
      }
      Ref ret;
      switch (curr->type) {
        case i32: {
          switch (curr->bytes) {
            case 1:
              ret = ValueBuilder::makeSub(
                  ValueBuilder::makeName(curr->signed_ ? HEAP8 : HEAPU8 ),
                  ValueBuilder::makePtrShift(ptr, 0));
              break;
            case 2:
              ret = ValueBuilder::makeSub(
                  ValueBuilder::makeName(curr->signed_ ? HEAP16 : HEAPU16),
                  ValueBuilder::makePtrShift(ptr, 1));
              break;
            case 4:
              ret = ValueBuilder::makeSub(
                  ValueBuilder::makeName(curr->signed_ ? HEAP32 : HEAPU32),
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
      if (isStatement(curr)) {
        ScopedTemp tempPtr(i32, parent, func);
        ScopedTemp tempValue(curr->valueType, parent, func);
        GetLocal fakeLocalPtr(allocator);
        fakeLocalPtr.index = func->getLocalIndex(tempPtr.getName());
        fakeLocalPtr.type = curr->ptr->type;
        GetLocal fakeLocalValue(allocator);
        fakeLocalValue.index = func->getLocalIndex(tempValue.getName());
        fakeLocalValue.type = curr->value->type;
        Store fakeStore = *curr;
        fakeStore.ptr = &fakeLocalPtr;
        fakeStore.value = &fakeLocalValue;
        Ref ret = blockify(visitAndAssign(curr->ptr, tempPtr));
        flattenAppend(ret, visitAndAssign(curr->value, tempValue));
        flattenAppend(ret, visitAndAssign(&fakeStore, result));
        return ret;
      }
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
      Ref ptr = visit(curr->ptr, EXPRESSION_RESULT);
      if (curr->offset) {
        ptr = makeAsmCoercion(ValueBuilder::makeBinary(ptr, PLUS, ValueBuilder::makeNum(curr->offset)), ASM_INT);
      }
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
      assert(!isStatement(curr));
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
      if (isStatement(curr)) {
        ScopedTemp temp(curr->value->type, parent, func);
        GetLocal fakeLocal(allocator);
        fakeLocal.index = func->getLocalIndex(temp.getName());
        Unary fakeUnary = *curr;
        fakeUnary.value = &fakeLocal;
        Ref ret = blockify(visitAndAssign(curr->value, temp));
        flattenAppend(ret, visitAndAssign(&fakeUnary, result));
        return ret;
      }
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
              // Naively assume that the address 0 and the next 4 bytes are
              // permanently unused by the source program, which is definitely
              // true for languages like C/C++/Rust
              Ref zero = ValueBuilder::makeInt(0);
              Ref ret = ValueBuilder::makeSub(ValueBuilder::makeName(HEAPF32), zero);
              Ref value = visit(curr->value, EXPRESSION_RESULT);
              Ref store = ValueBuilder::makeBinary(ret, SET, value);
              return ValueBuilder::makeSeq(
                store,
                makeAsmCoercion(
                  ValueBuilder::makeSub(ValueBuilder::makeName(HEAP32), zero),
                  ASM_INT
                )
              );
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
              // Like above, assume address 0 is unused.
              Ref zero = ValueBuilder::makeInt(0);
              Ref ret = ValueBuilder::makeSub(ValueBuilder::makeName(HEAP32), zero);
              Ref value = visit(curr->value, EXPRESSION_RESULT);
              Ref store = ValueBuilder::makeBinary(ret, SET, value);
              return ValueBuilder::makeSeq(
                store,
                ValueBuilder::makeSub(ValueBuilder::makeName(HEAPF32), zero)
              );
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
      if (isStatement(curr)) {
        ScopedTemp tempLeft(curr->left->type, parent, func);
        GetLocal fakeLocalLeft(allocator);
        fakeLocalLeft.index = func->getLocalIndex(tempLeft.getName());
        ScopedTemp tempRight(curr->right->type, parent, func);
        GetLocal fakeLocalRight(allocator);
        fakeLocalRight.index = func->getLocalIndex(tempRight.getName());
        Binary fakeBinary = *curr;
        fakeBinary.left = &fakeLocalLeft;
        fakeBinary.right = &fakeLocalRight;
        Ref ret = blockify(visitAndAssign(curr->left, tempLeft));
        flattenAppend(ret, visitAndAssign(curr->right, tempRight));
        flattenAppend(ret, visitAndAssign(&fakeBinary, result));
        return ret;
      }
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
              // TODO: check if this condition is still valid/necessary
              if (curr->left->type == i32) {
                return ValueBuilder::makeBinary(makeSigning(left, ASM_SIGNED), EQ,
                                                makeSigning(right, ASM_SIGNED));
              } else {
                return ValueBuilder::makeBinary(left, EQ, right);
              }
            }
            case NeInt32: {
              if (curr->left->type == i32) {
                return ValueBuilder::makeBinary(makeSigning(left, ASM_SIGNED), NE,
                                                makeSigning(right, ASM_SIGNED));
              } else {
                return ValueBuilder::makeBinary(left, NE, right);
              }
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
      if (isStatement(curr)) {
        ScopedTemp tempIfTrue(curr->ifTrue->type, parent, func);
        GetLocal fakeLocalIfTrue(allocator);
        fakeLocalIfTrue.index = func->getLocalIndex(tempIfTrue.getName());
        ScopedTemp tempIfFalse(curr->ifFalse->type, parent, func);
        GetLocal fakeLocalIfFalse(allocator);
        fakeLocalIfFalse.index = func->getLocalIndex(tempIfFalse.getName());
        ScopedTemp tempCondition(i32, parent, func);
        GetLocal fakeCondition(allocator);
        fakeCondition.index = func->getLocalIndex(tempCondition.getName());
        Select fakeSelect = *curr;
        fakeSelect.ifTrue = &fakeLocalIfTrue;
        fakeSelect.ifFalse = &fakeLocalIfFalse;
        fakeSelect.condition = &fakeCondition;
        Ref ret = blockify(visitAndAssign(curr->ifTrue, tempIfTrue));
        flattenAppend(ret, visitAndAssign(curr->ifFalse, tempIfFalse));
        flattenAppend(ret, visitAndAssign(curr->condition, tempCondition));
        flattenAppend(ret, visitAndAssign(&fakeSelect, result));
        return ret;
      }
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
      if (curr->value == nullptr) {
        return ValueBuilder::makeReturn(Ref());
      }
      if (isStatement(curr->value)) {
        ScopedTemp temp(curr->value->type, parent, func);
        Ref ret = ValueBuilder::makeBlock();
        flattenAppend(ret, visitAndAssign(curr->value, temp));
        Ref coerced = makeAsmCoercion(
          temp.getAstName(),
          wasmToAsmType(curr->value->type)
        );
        flattenAppend(ret, ValueBuilder::makeReturn(coerced));
        return ret;
      } else {
        Ref val = makeAsmCoercion(
          visit(curr->value, NO_RESULT),
          wasmToAsmType(curr->value->type)
        );
        return ValueBuilder::makeReturn(val);
      }
    }

    Ref visitHost(Host* curr) {
      Ref call;
      if (curr->op == HostOp::GrowMemory) {
        parent->setNeedsAlmostASM("grow_memory op");
        call = ValueBuilder::makeCall(WASM_GROW_MEMORY,
          makeAsmCoercion(
            visit(curr->operands[0], EXPRESSION_RESULT),
            wasmToAsmType(curr->operands[0]->type)));
      } else if (curr->op == HostOp::CurrentMemory) {
        parent->setNeedsAlmostASM("current_memory op");
        call = ValueBuilder::makeCall(WASM_CURRENT_MEMORY);
      } else {
        return ValueBuilder::makeCall(ABORT_FUNC);
      }
      if (isStatement(curr)) {
        return ValueBuilder::makeBinary(ValueBuilder::makeName(result), SET, call);
      } else {
        return call;
      }
    }

    Ref visitNop(Nop* curr) {
      return ValueBuilder::makeToplevel();
    }

    Ref visitUnreachable(Unreachable* curr) {
      return ValueBuilder::makeCall(ABORT_FUNC);
    }
  };
  return ExpressionProcessor(this, m, func).visit(func->body, result);
}

static void makeHelpers(Ref ret, Name funcName, Name moduleName, bool first) {
  if (first) {
    // TODO: nan and infinity shouldn't be needed once literal asm.js code isn't
    // generated
    flattenAppend(ret, ValueBuilder::makeName(R"(
      var nan = NaN;
      var infinity = Infinity;
    )"));

    // When equating floating point values in spec tests we want to use bitwise
    // equality like wasm does. Unfortunately though NaN makes this tricky. JS
    // implementations like Spidermonkey and JSC will canonicalize NaN loads from
    // `Float32Array`, but V8 will not. This means that NaN representations are
    // kind of all over the place and difficult to bitwise equate.
    //
    // To work around this problem we just use a small shim which considers all
    // NaN representations equivalent and otherwise tests for bitwise equality.
    flattenAppend(ret, ValueBuilder::makeName(R"(
      function f32Equal(a, b) {
         var i = new Int32Array(1);
         var f = new Float32Array(i.buffer);
         f[0] = a;
         var ai = f[0];
         f[0] = b;
         var bi = f[0];

         return (isNaN(a) && isNaN(b)) || a == b;
      }

      function f64Equal(a, b) {
         var i = new Int32Array(2);
         var f = new Float64Array(i.buffer);
         f[0] = a;
         var ai1 = i[0];
         var ai2 = i[1];
         f[0] = b;
         var bi1 = i[0];
         var bi2 = i[1];

         return (isNaN(a) && isNaN(b)) || (ai1 == bi1 && ai2 == bi2);
      }

      function i64Equal(actual_lo, actual_hi, expected_lo, expected_hi) {
         return actual_lo == (expected_lo | 0) && actual_hi == (expected_hi | 0);
      }
    )"));
  }
}

static void prefixCalls(Ref asmjs, Name asmModule) {
  if (asmjs->isArray()) {
    ArrayStorage& arr = asmjs->getArray();
    for (Ref& r : arr) {
      prefixCalls(r, asmModule);
    }
    if (arr.size() > 0 && arr[0]->isString() && arr[0]->getIString() == CALL) {
      assert(arr.size() >= 2);
      if (arr[1]->getIString() == "f32Equal" ||
          arr[1]->getIString() == "f64Equal" ||
          arr[1]->getIString() == "i64Equal" ||
          arr[1]->getIString() == "isNaN") {
        // ...
      } else if (arr[1]->getIString() == "Math_fround") {
        arr[1]->setString("Math.fround");
      } else {
        Ref prefixed = ValueBuilder::makeDot(ValueBuilder::makeName(asmModule),
                                             arr[1]->getIString());
        arr[1]->setArray(prefixed->getArray());
      }
    }
  }

  if (asmjs->isAssign()) {
    prefixCalls(asmjs->asAssign()->target(), asmModule);
    prefixCalls(asmjs->asAssign()->value(), asmModule);
  }
  if (asmjs->isAssignName()) {
    prefixCalls(asmjs->asAssignName()->value(), asmModule);
  }
}

Ref Wasm2JSBuilder::makeAssertReturnFunc(SExpressionWasmBuilder& sexpBuilder,
                                          Module* wasm,
                                          Builder& wasmBuilder,
                                          Element& e,
                                          Name testFuncName,
                                          Name asmModule) {
  Expression* actual = sexpBuilder.parseExpression(e[1]);
  Expression* body = nullptr;
  if (e.size() == 2) {
    if  (actual->type == none) {
      body = wasmBuilder.blockify(
        actual,
        wasmBuilder.makeConst(Literal(uint32_t(1)))
      );
    } else {
      body = actual;
    }
  } else if (e.size() == 3) {
    Expression* expected = sexpBuilder.parseExpression(e[2]);
    Type resType = expected->type;
    actual->type = resType;
    switch (resType) {
      case i32:
        body = wasmBuilder.makeBinary(EqInt32, actual, expected);
        break;

      case i64:
        body = wasmBuilder.makeCall(
          "i64Equal",
          {actual, wasmBuilder.makeCall(WASM_FETCH_HIGH_BITS, {}, i32), expected},
          i32
        );
        break;

      case f32: {
        body = wasmBuilder.makeCall("f32Equal", {actual, expected}, i32);
        break;
      }
      case f64: {
        body = wasmBuilder.makeCall("f64Equal", {actual, expected}, i32);
        break;
      }

      default: {
        std::cerr << "Unhandled type in assert: " << resType << std::endl;
        abort();
      }
    }
  } else {
    assert(false && "Unexpected number of parameters in assert_return");
  }
  std::unique_ptr<Function> testFunc(
    wasmBuilder.makeFunction(
      testFuncName,
      std::vector<NameType>{},
      body->type,
      std::vector<NameType>{},
      body
    )
  );
  Ref jsFunc = processFunction(wasm, testFunc.get());
  prefixCalls(jsFunc, asmModule);
  return jsFunc;
}

Ref Wasm2JSBuilder::makeAssertReturnNanFunc(SExpressionWasmBuilder& sexpBuilder,
                                             Module* wasm,
                                             Builder& wasmBuilder,
                                             Element& e,
                                             Name testFuncName,
                                             Name asmModule) {
  Expression* actual = sexpBuilder.parseExpression(e[1]);
  Expression* body = wasmBuilder.makeCall("isNaN", {actual}, i32);
  std::unique_ptr<Function> testFunc(
    wasmBuilder.makeFunction(
      testFuncName,
      std::vector<NameType>{},
      body->type,
      std::vector<NameType>{},
      body
    )
  );
  Ref jsFunc = processFunction(wasm, testFunc.get());
  prefixCalls(jsFunc, asmModule);
  return jsFunc;
}

Ref Wasm2JSBuilder::makeAssertTrapFunc(SExpressionWasmBuilder& sexpBuilder,
                                        Module* wasm,
                                        Builder& wasmBuilder,
                                        Element& e,
                                        Name testFuncName,
                                        Name asmModule) {
  Name innerFuncName("f");
  Expression* expr = sexpBuilder.parseExpression(e[1]);
  std::unique_ptr<Function> exprFunc(
    wasmBuilder.makeFunction(innerFuncName,
                             std::vector<NameType>{},
                             expr->type,
                             std::vector<NameType>{},
                             expr)
  );
  IString expectedErr = e[2]->str();
  Ref innerFunc = processFunction(wasm, exprFunc.get());
  prefixCalls(innerFunc, asmModule);
  Ref outerFunc = ValueBuilder::makeFunction(testFuncName);
  outerFunc[3]->push_back(innerFunc);
  Ref tryBlock = ValueBuilder::makeBlock();
  ValueBuilder::appendToBlock(tryBlock, ValueBuilder::makeCall(innerFuncName));
  Ref catchBlock = ValueBuilder::makeBlock();
  ValueBuilder::appendToBlock(
    catchBlock,
    ValueBuilder::makeReturn(
      ValueBuilder::makeCall(
        ValueBuilder::makeDot(
          ValueBuilder::makeName(IString("e")),
          ValueBuilder::makeName(IString("message")),
          ValueBuilder::makeName(IString("includes"))
        ),
        ValueBuilder::makeString(expectedErr)
      )
    )
  );
  outerFunc[3]->push_back(ValueBuilder::makeTry(
      tryBlock,
      ValueBuilder::makeName((IString("e"))),
      catchBlock));
  outerFunc[3]->push_back(ValueBuilder::makeReturn(ValueBuilder::makeInt(0)));
  return outerFunc;
}

void Wasm2JSBuilder::setNeedsAlmostASM(const char *reason) {
  if (!almostASM) {
    almostASM = true;
    std::cerr << "Switching to \"almost asm\" mode, reason: " << reason << std::endl;
  }
}

void Wasm2JSBuilder::addMemoryGrowthFuncs(Ref ast) {
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

bool Wasm2JSBuilder::isAssertHandled(Element& e) {
  return e.isList() && e.size() >= 2 && e[0]->isStr()
      && (e[0]->str() == Name("assert_return") ||
          e[0]->str() == Name("assert_return_nan") ||
          (flags.pedantic && e[0]->str() == Name("assert_trap")))
      && e[1]->isList() && e[1]->size() >= 2 && (*e[1])[0]->isStr()
      && (*e[1])[0]->str() == Name("invoke");
}

Ref Wasm2JSBuilder::processAsserts(Module* wasm,
                                    Element& root,
                                    SExpressionWasmBuilder& sexpBuilder) {
  Builder wasmBuilder(sexpBuilder.getAllocator());
  Ref ret = ValueBuilder::makeBlock();
  std::stringstream asmModuleS;
  asmModuleS << "ret" << ASM_FUNC.c_str();
  Name asmModule(asmModuleS.str().c_str());
  makeHelpers(ret, ASM_FUNC, asmModule, true);
  for (size_t i = 1; i < root.size(); ++i) {
    Element& e = *root[i];
    if (e.isList() && e.size() >= 1 && e[0]->isStr() && e[0]->str() == Name("module")) {
      std::stringstream funcNameS;
      funcNameS << ASM_FUNC.c_str() << i;
      std::stringstream moduleNameS;
      moduleNameS << "ret" << ASM_FUNC.c_str() << i;
      Name funcName(funcNameS.str().c_str());
      asmModule = Name(moduleNameS.str().c_str());
      Module wasm;
      SExpressionWasmBuilder builder(wasm, e);
      flattenAppend(ret, processWasm(&wasm, funcName));
      makeHelpers(ret, funcName, asmModule, false);
      continue;
    }
    if (!isAssertHandled(e)) {
      std::cerr << "skipping " << e << std::endl;
      continue;
    }
    Name testFuncName(IString(("check" + std::to_string(i)).c_str(), false));
    bool isReturn = (e[0]->str() == Name("assert_return"));
    bool isReturnNan = (e[0]->str() == Name("assert_return_nan"));
    Element& testOp = *e[1];
    // Replace "invoke" with "call"
    testOp[0]->setString(IString("call"), false, false);
    // Need to claim dollared to get string as function target
    testOp[1]->setString(testOp[1]->str(), /*dollared=*/true, false);

    Ref testFunc = isReturn ?
        makeAssertReturnFunc(sexpBuilder, wasm, wasmBuilder, e, testFuncName, asmModule) :
        (isReturnNan ?
          makeAssertReturnNanFunc(sexpBuilder, wasm, wasmBuilder, e, testFuncName, asmModule) :
          makeAssertTrapFunc(sexpBuilder, wasm, wasmBuilder, e, testFuncName, asmModule));

    flattenAppend(ret, testFunc);
    std::stringstream failFuncName;
    failFuncName << "fail" << std::to_string(i);
    IString testName = fromName(testFuncName, NameScope::Top);
    flattenAppend(
      ret,
      ValueBuilder::makeIf(
        ValueBuilder::makeUnary(L_NOT, ValueBuilder::makeCall(testName)),
        ValueBuilder::makeCall(IString(failFuncName.str().c_str(), false)),
        Ref()
      )
    );
  }
  return ret;
}


} // namespace wasm

#endif // wasm_wasm2js_h
