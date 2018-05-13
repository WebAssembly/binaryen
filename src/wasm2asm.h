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

#ifndef wasm_wasm2asm_h
#define wasm_wasm2asm_h

#include <cmath>
#include <numeric>

#include "asmjs/shared-constants.h"
#include "asmjs/asmangle.h"
#include "wasm.h"
#include "wasm-builder.h"
#include "emscripten-optimizer/optimizer.h"
#include "mixed_arena.h"
#include "asm_v_wasm.h"
#include "ir/utils.h"
#include "passes/passes.h"

namespace wasm {

using namespace cashew;

IString ASM_FUNC("asmFunc"),
        ABORT_FUNC("abort"),
        FUNCTION_TABLE("FUNCTION_TABLE"),
        NO_RESULT("wasm2asm$noresult"), // no result at all
        EXPRESSION_RESULT("wasm2asm$expresult"); // result in an expression, no temp var

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

//
// Wasm2AsmBuilder - converts a WebAssembly module into asm.js
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
// wasm2asm to be fairly fast to run, as it might run on
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


class Wasm2AsmBuilder {
  MixedArena allocator;

public:
  struct Flags {
    bool debug = false;
    bool pedantic = false;
    bool allowAsserts = false;
  };

  Wasm2AsmBuilder(Flags f) : flags(f) {}

  Ref processWasm(Module* wasm);
  Ref processFunction(Function* func);

  // The first pass on an expression: scan it to see whether it will
  // need to be statementized, and note spooky returns of values at
  // a distance (aka break with a value).
  void scanFunctionBody(Expression* curr);

  // The second pass on an expression: process it fully, generating
  // asm.js
  // @param result Whether the context we are in receives a value,
  //               and its type, or if not, then we can drop our return,
  //               if we have one.
  Ref processFunctionBody(Function* func, IString result);

  Ref processAsserts(Element& e, SExpressionWasmBuilder& sexpBuilder);

  // Get a temp var.
  IString getTemp(Type type, Function* func) {
    IString ret;
    if (frees[type].size() > 0) {
      ret = frees[type].back();
      frees[type].pop_back();
    } else {
      size_t index = temps[type]++;
      ret = IString((std::string("wasm2asm_") + printType(type) + "$" +
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

  IString fromName(Name name) {
    // TODO: checking names do not collide after mangling
    auto it = mangledNames.find(name.c_str());
    if (it != mangledNames.end()) {
      return it->second;
    }
    auto mangled = asmangle(std::string(name.c_str()));
    IString ret(mangled.c_str(), false);
    mangledNames[name.c_str()] = ret;
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
  std::unordered_map<const char*, IString> mangledNames;

  // All our function tables have the same size TODO: optimize?
  size_t tableSize;

  bool almostASM = false;

  void addBasics(Ref ast);
  void addImport(Ref ast, Import* import);
  void addTables(Ref ast, Module* wasm);
  void addExports(Ref ast, Module* wasm);
  void addGlobal(Ref ast, Global* global);
  void addWasmCompatibilityFuncs(Module* wasm);
  void setNeedsAlmostASM(const char *reason);
  void addMemoryGrowthFuncs(Ref ast);
  bool isAssertHandled(Element& e);
  Ref makeAssertReturnFunc(SExpressionWasmBuilder& sexpBuilder,
                           Builder& wasmBuilder,
                           Element& e, Name testFuncName);
  Ref makeAssertReturnNanFunc(SExpressionWasmBuilder& sexpBuilder,
                              Builder& wasmBuilder,
                              Element& e, Name testFuncName);
  Ref makeAssertTrapFunc(SExpressionWasmBuilder& sexpBuilder,
                         Builder& wasmBuilder,
                         Element& e, Name testFuncName);
  Wasm2AsmBuilder() = delete;
  Wasm2AsmBuilder(const Wasm2AsmBuilder &) = delete;
  Wasm2AsmBuilder &operator=(const Wasm2AsmBuilder&) = delete;
};

static Function* makeCtzFunc(MixedArena& allocator, UnaryOp op) {
  assert(op == CtzInt32 || op == CtzInt64);
  Builder b(allocator);
  // if eqz(x) then 32 else (32 - clz(x ^ (x - 1)))
  bool is32Bit = (op == CtzInt32);
  Name funcName    = is32Bit ? Name(WASM_CTZ32) : Name(WASM_CTZ64);
  BinaryOp subOp   = is32Bit ? SubInt32    : SubInt64;
  BinaryOp xorOp   = is32Bit ? XorInt32    : XorInt64;
  UnaryOp  clzOp   = is32Bit ? ClzInt32    : ClzInt64;
  UnaryOp  eqzOp   = is32Bit ? EqZInt32    : EqZInt64;
  Type argType = is32Bit ? i32         : i64;
  Binary* xorExp = b.makeBinary(
    xorOp,
    b.makeGetLocal(0, i32),
    b.makeBinary(
      subOp,
      b.makeGetLocal(0, i32),
      b.makeConst(is32Bit ? Literal(int32_t(1)) : Literal(int64_t(1)))
    )
  );
  Binary* subExp = b.makeBinary(
    subOp,
    b.makeConst(is32Bit ? Literal(int32_t(32 - 1)) : Literal(int64_t(64 - 1))),
    b.makeUnary(clzOp, xorExp)
  );
  If* body = b.makeIf(
    b.makeUnary(
      eqzOp,
      b.makeGetLocal(0, i32)
    ),
    b.makeConst(is32Bit ? Literal(int32_t(32)) : Literal(int64_t(64))),
    subExp
  );
  return b.makeFunction(
    funcName,
    std::vector<NameType>{NameType("x", argType)},
    argType,
    std::vector<NameType>{},
    body
  );
}

static Function* makePopcntFunc(MixedArena& allocator, UnaryOp op) {
  assert(op == PopcntInt32 || op == PopcntInt64);
  Builder b(allocator);
  // popcnt implemented as:
  // int c; for (c = 0; x != 0; c++) { x = x & (x - 1) }; return c
  bool is32Bit = (op == PopcntInt32);
  Name funcName    = is32Bit ? Name(WASM_POPCNT32) : Name(WASM_POPCNT64);
  BinaryOp addOp   = is32Bit ? AddInt32       : AddInt64;
  BinaryOp subOp   = is32Bit ? SubInt32       : SubInt64;
  BinaryOp andOp   = is32Bit ? AndInt32       : AndInt64;
  UnaryOp  eqzOp   = is32Bit ? EqZInt32       : EqZInt64;
  Type argType = is32Bit ? i32            : i64;
  Name loopName("l");
  Name blockName("b");
  Break* brIf = b.makeBreak(
    blockName,
    b.makeGetLocal(1, i32),
    b.makeUnary(
      eqzOp,
      b.makeGetLocal(0, argType)
    )
  );
  SetLocal* update = b.makeSetLocal(
    0,
    b.makeBinary(
      andOp,
      b.makeGetLocal(0, argType),
      b.makeBinary(
        subOp,
        b.makeGetLocal(0, argType),
        b.makeConst(is32Bit ? Literal(int32_t(1)) : Literal(int64_t(1)))
      )
    )
  );
  SetLocal* inc = b.makeSetLocal(
    1,
    b.makeBinary(
      addOp,
      b.makeGetLocal(1, argType),
      b.makeConst(Literal(1))
    )
  );
  Break* cont = b.makeBreak(loopName);
  Loop* loop = b.makeLoop(loopName, b.blockify(brIf, update, inc, cont));
  Block* loopBlock = b.blockifyWithName(loop, blockName);
  SetLocal* initCount = b.makeSetLocal(1, b.makeConst(Literal(0)));
  return b.makeFunction(
    funcName,
    std::vector<NameType>{NameType("x", argType)},
    argType,
    std::vector<NameType>{NameType("count", argType)},
    b.blockify(initCount, loopBlock)
  );
}

Function* makeRotFunc(MixedArena& allocator, BinaryOp op) {
  assert(op == RotLInt32 || op == RotRInt32 ||
         op == RotLInt64 || op == RotRInt64);
  Builder b(allocator);
  // left rotate is:
  // (((((~0) >>> k) & x) << k) | ((((~0) << (w - k)) & x) >>> (w - k)))
  // where k is shift modulo w. reverse shifts for right rotate
  bool is32Bit = (op == RotLInt32 || op == RotRInt32);
  bool isLRot  = (op == RotLInt32 || op == RotLInt64);
  static Name names[2][2] = {{Name(WASM_ROTR64), Name(WASM_ROTR32)},
                             {Name(WASM_ROTL64), Name(WASM_ROTL32)}};
  static BinaryOp shifters[2][2] = {{ShrUInt64, ShrUInt32},
                                    {ShlInt64, ShlInt32}};
  Name funcName = names[isLRot][is32Bit];
  BinaryOp lshift = shifters[isLRot][is32Bit];
  BinaryOp rshift = shifters[!isLRot][is32Bit];
  BinaryOp orOp    = is32Bit ? OrInt32  : OrInt64;
  BinaryOp andOp   = is32Bit ? AndInt32 : AndInt64;
  BinaryOp subOp   = is32Bit ? SubInt32 : SubInt64;
  Type argType = is32Bit ? i32      : i64;
  Literal widthMask =
      is32Bit ? Literal(int32_t(32 - 1)) : Literal(int64_t(64 - 1));
  Literal width =
      is32Bit ? Literal(int32_t(32)) : Literal(int64_t(64));
  auto shiftVal = [&]() {
    return b.makeBinary(
      andOp,
      b.makeGetLocal(1, argType),
      b.makeConst(widthMask)
    );
  };
  auto widthSub = [&]() {
    return b.makeBinary(subOp, b.makeConst(width), shiftVal());
  };
  auto fullMask = [&]() {
    return b.makeConst(is32Bit ? Literal(~int32_t(0)) : Literal(~int64_t(0)));
  };
  Binary* maskRShift = b.makeBinary(rshift, fullMask(), shiftVal());
  Binary* lowMask = b.makeBinary(andOp, maskRShift, b.makeGetLocal(0, argType));
  Binary* lowShift = b.makeBinary(lshift, lowMask, shiftVal());
  Binary* maskLShift = b.makeBinary(lshift, fullMask(), widthSub());
  Binary* highMask =
      b.makeBinary(andOp, maskLShift, b.makeGetLocal(0, argType));
  Binary* highShift = b.makeBinary(rshift, highMask, widthSub());
  Binary* body = b.makeBinary(orOp, lowShift, highShift);
  return b.makeFunction(
    funcName,
    std::vector<NameType>{NameType("x", argType),
          NameType("k", argType)},
    argType,
    std::vector<NameType>{},
    body
  );
}

void Wasm2AsmBuilder::addWasmCompatibilityFuncs(Module* wasm) {
  wasm->addFunction(makeCtzFunc(wasm->allocator, CtzInt32));
  wasm->addFunction(makePopcntFunc(wasm->allocator, PopcntInt32));
  wasm->addFunction(makeRotFunc(wasm->allocator, RotLInt32));
  wasm->addFunction(makeRotFunc(wasm->allocator, RotRInt32));
}

Ref Wasm2AsmBuilder::processWasm(Module* wasm) {
  addWasmCompatibilityFuncs(wasm);
  PassRunner runner(wasm);
  runner.add<AutoDrop>();
  runner.add("remove-copysign"); // must be before i64-to-i32
  runner.add("i64-to-i32-lowering");
  runner.add("flatten");
  runner.add("simplify-locals-notee-nostructure");
  runner.add("reorder-locals");
  runner.add("vacuum");
  runner.setDebug(flags.debug);
  runner.run();
  Ref ret = ValueBuilder::makeToplevel();
  Ref asmFunc = ValueBuilder::makeFunction(ASM_FUNC);
  ret[1]->push_back(asmFunc);
  ValueBuilder::appendArgumentToFunction(asmFunc, GLOBAL);
  ValueBuilder::appendArgumentToFunction(asmFunc, ENV);
  ValueBuilder::appendArgumentToFunction(asmFunc, BUFFER);
  asmFunc[3]->push_back(ValueBuilder::makeStatement(ValueBuilder::makeString(USE_ASM)));
  // create heaps, etc
  addBasics(asmFunc[3]);
  for (auto& import : wasm->imports) {
    addImport(asmFunc[3], import.get());
  }
  // figure out the table size
  tableSize = std::accumulate(wasm->table.segments.begin(),
                              wasm->table.segments.end(),
                              0, [&](size_t size, Table::Segment seg) -> size_t {
                                return size + seg.data.size();
                              });
  size_t pow2ed = 1;
  while (pow2ed < tableSize) {
    pow2ed <<= 1;
  }
  tableSize = pow2ed;
  // globals
  bool generateFetchHighBits = false;
  for (auto& global : wasm->globals) {
    addGlobal(asmFunc[3], global.get());
    if (flags.allowAsserts && global->name == INT64_TO_32_HIGH_BITS) {
      generateFetchHighBits = true;
    }
  }
  // functions
  for (auto& func : wasm->functions) {
    asmFunc[3]->push_back(processFunction(func.get()));
  }
  if (generateFetchHighBits) {
    Builder builder(allocator);
    std::vector<Type> params;
    std::vector<Type> vars;
    asmFunc[3]->push_back(processFunction(builder.makeFunction(
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

void Wasm2AsmBuilder::addBasics(Ref ast) {
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
}

void Wasm2AsmBuilder::addImport(Ref ast, Import* import) {
  Ref theVar = ValueBuilder::makeVar();
  ast->push_back(theVar);
  Ref module = ValueBuilder::makeName(ENV); // TODO: handle nested module imports
  ValueBuilder::appendToVar(theVar,
    fromName(import->name),
    ValueBuilder::makeDot(
      module,
      fromName(import->base)
    )
  );
}

void Wasm2AsmBuilder::addTables(Ref ast, Module* wasm) {
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
          table[j] = fromName(name);
        }
      } else {
        table[i] = fromName(name);
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

void Wasm2AsmBuilder::addExports(Ref ast, Module* wasm) {
  Ref exports = ValueBuilder::makeObject();
  for (auto& export_ : wasm->exports) {
    if (export_->kind == ExternalKind::Function) {
      ValueBuilder::appendToObject(
        exports,
        fromName(export_->name),
        ValueBuilder::makeName(fromName(export_->value))
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
        fromName(export_->name),
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

void Wasm2AsmBuilder::addGlobal(Ref ast, Global* global) {
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
        assert(false && "Global const type not supported");
      }
    }
    Ref theVar = ValueBuilder::makeVar();
    ast->push_back(theVar);
    ValueBuilder::appendToVar(theVar,
      fromName(global->name),
      theValue
    );
  } else {
    assert(false && "Global init type not supported");
  }
}

Ref Wasm2AsmBuilder::processFunction(Function* func) {
  if (flags.debug) {
    static int fns = 0;
    std::cerr << "processFunction " << (fns++) << " " << func->name
              << std::endl;
  }
  Ref ret = ValueBuilder::makeFunction(fromName(func->name));
  frees.clear();
  frees.resize(std::max(i32, std::max(f32, f64)) + 1);
  temps.clear();
  temps.resize(std::max(i32, std::max(f32, f64)) + 1);
  temps[i32] = temps[f32] = temps[f64] = 0;
  // arguments
  for (Index i = 0; i < func->getNumParams(); i++) {
    IString name = fromName(func->getLocalNameOrGeneric(i));
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
  bool isBodyBlock = func->body->is<Block>();
  ExpressionList* stats = isBodyBlock ?
      &static_cast<Block*>(func->body)->list : nullptr;
  bool endsInReturn =
      (isBodyBlock && ((*stats)[stats->size()-1]->is<Return>())) ||
    func->body->is<Return>();
  if (endsInReturn) {
    // return already taken care of
    flattenAppend(ret, processFunctionBody(func, NO_RESULT));
  } else if (isStatement(func->body)) {
    // store result in variable then return it
    IString result =
      func->result != none ? getTemp(func->result, func) : NO_RESULT;
    flattenAppend(ret, processFunctionBody(func, result));
    if (func->result != none) {
      appendFinalReturn(ValueBuilder::makeName(result));
      freeTemp(func->result, result);
    }
  } else if (func->result != none) {
    // whole thing is an expression, just return body
    appendFinalReturn(processFunctionBody(func, EXPRESSION_RESULT));
  } else {
    // func has no return
    flattenAppend(ret, processFunctionBody(func, NO_RESULT));
  }
  // vars, including new temp vars
  for (Index i = func->getVarIndexBase(); i < func->getNumLocals(); i++) {
    ValueBuilder::appendToVar(
      theVar,
      fromName(func->getLocalNameOrGeneric(i)),
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

void Wasm2AsmBuilder::scanFunctionBody(Expression* curr) {
  struct ExpressionScanner : public PostWalker<ExpressionScanner> {
    Wasm2AsmBuilder* parent;

    ExpressionScanner(Wasm2AsmBuilder* parent) : parent(parent) {}

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
    void visitCallImport(CallImport* curr) {
      for (auto item : curr->operands) {
        if (parent->isStatement(item)) {
          parent->setStatement(curr);
          break;
        }
      }
    }
    void visitCallIndirect(CallIndirect* curr) {
      if (parent->isStatement(curr->target)) {
        parent->setStatement(curr);
        return;
      }
      for (auto item : curr->operands) {
        if (parent->isStatement(item)) {
          parent->setStatement(curr);
          break;
        }
      }
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
      if (parent->isStatement(curr->ptr) || parent->isStatement(curr->value)) {
        parent->setStatement(curr);
      }
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

Ref Wasm2AsmBuilder::processFunctionBody(Function* func, IString result) {
  struct ExpressionProcessor : public Visitor<ExpressionProcessor, Ref> {
    Wasm2AsmBuilder* parent;
    IString result;
    Function* func;
    MixedArena allocator;
    ExpressionProcessor(Wasm2AsmBuilder* parent, Function* func) : parent(parent), func(func) {}

    // A scoped temporary variable.
    struct ScopedTemp {
      Wasm2AsmBuilder* parent;
      Type type;
      IString temp;
      bool needFree;
      // @param possible if provided, this is a variable we can use as our temp. it has already been
      //                 allocated in a higher scope, and we can just assign to it as our result is
      //                 going there anyhow.
      ScopedTemp(Type type, Wasm2AsmBuilder* parent, Function* func,
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

    IString fromName(Name name) {
      return parent->fromName(name);
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
        ret = ValueBuilder::makeLabel(fromName(curr->name), ret);
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
      flattenAppend(body, ValueBuilder::makeBreak(fromName(asmLabel)));
      Ref ret = ValueBuilder::makeDo(body, ValueBuilder::makeInt(1));
      return ValueBuilder::makeLabel(fromName(asmLabel), ret);
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
        theBreak = ValueBuilder::makeBreak(fromName(curr->name));
      } else {
        theBreak = ValueBuilder::makeContinue(fromName(curr->name));
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
        ValueBuilder::appendCodeToSwitch(theSwitch, blockify(ValueBuilder::makeBreak(fromName(curr->targets[i]))), false);
      }
      ValueBuilder::appendDefaultToSwitch(theSwitch);
      ValueBuilder::appendCodeToSwitch(theSwitch, blockify(ValueBuilder::makeBreak(fromName(curr->default_))), false);
      return ret;
    }

    Ref makeStatementizedCall(ExpressionList& operands, Ref ret, Ref theCall, IString result, Type type) {
      std::vector<ScopedTemp*> temps; // TODO: utility class, with destructor?
      for (auto& operand : operands) {
        temps.push_back(new ScopedTemp(operand->type, parent, func));
        IString temp = temps.back()->temp;
        flattenAppend(ret, visitAndAssign(operand, temp));
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
      Ref theCall = ValueBuilder::makeCall(fromName(target));
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
      return makeStatementizedCall(operands, ValueBuilder::makeBlock(), theCall,
                                   result, curr->type);
    }

    Ref visitCall(Call* curr) {
      return visitGenericCall(curr, curr->target, curr->operands);
    }

    Ref visitCallImport(CallImport* curr) {
      return visitGenericCall(curr, curr->target, curr->operands);
    }

    Ref visitCallIndirect(CallIndirect* curr) {
      std::string stable = std::string("FUNCTION_TABLE_") + curr->fullType.c_str();
      IString table = IString(stable.c_str(), false);
      auto makeTableCall = [&](Ref target) {
        return ValueBuilder::makeCall(ValueBuilder::makeSub(
          ValueBuilder::makeName(table),
          ValueBuilder::makeBinary(target, AND, ValueBuilder::makeInt(parent->getTableSize()-1))
        ));
      };
      if (!isStatement(curr)) {
        // none of our operands is a statement; go right ahead and create a simple expression
        Ref theCall = makeTableCall(visit(curr->target, EXPRESSION_RESULT));
        for (auto operand : curr->operands) {
          theCall[2]->push_back(makeAsmCoercion(visit(operand, EXPRESSION_RESULT), wasmToAsmType(operand->type)));
        }
        return makeAsmCoercion(theCall, wasmToAsmType(curr->type));
      }
      // we must statementize them all
      Ref ret = ValueBuilder::makeBlock();
      ScopedTemp temp(i32, parent, func);
      flattenAppend(ret, visit(curr->target, temp));
      Ref theCall = makeTableCall(temp.getAstName());
      return makeStatementizedCall(curr->operands, ret, theCall, result, curr->type);
    }

    Ref makeSetVar(Expression* curr, Expression* value, Name name) {
      if (!isStatement(curr)) {
        return ValueBuilder::makeBinary(
          ValueBuilder::makeName(fromName(name)), SET,
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
            ValueBuilder::makeName(fromName(name)), SET,
            temp.getAstName()
          )
        )
      );
      return ret;
    }

    Ref visitGetLocal(GetLocal* curr) {
      return ValueBuilder::makeName(
        fromName(func->getLocalNameOrGeneric(curr->index))
      );
    }

    Ref visitSetLocal(SetLocal* curr) {
      return makeSetVar(curr, curr->value, func->getLocalNameOrGeneric(curr->index));
    }

    Ref visitGetGlobal(GetGlobal* curr) {
      return ValueBuilder::makeName(fromName(curr->name));
    }

    Ref visitSetGlobal(SetGlobal* curr) {
      return makeSetVar(curr, curr->value, curr->name);
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
        GetLocal fakeLocalValue(allocator);
        fakeLocalValue.index = func->getLocalIndex(tempValue.getName());
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
          unsigned lo = (unsigned) curr->value.geti64();
          unsigned hi = (unsigned) (curr->value.geti64() >> 32);
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
              return makeSigning(
                ValueBuilder::makeCall(
                  WASM_CTZ32,
                  visit(curr->value, EXPRESSION_RESULT)
                ),
                ASM_SIGNED
              );
            case PopcntInt32:
              return makeSigning(
                ValueBuilder::makeCall(
                  WASM_POPCNT32,
                  visit(curr->value, EXPRESSION_RESULT)
                ),
                ASM_SIGNED
              );
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
                ValueBuilder::makeSub(ValueBuilder::makeName(HEAP32), zero)
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
            case TruncFloat32:
            case TruncFloat64:
              ret = ValueBuilder::makeCall(
                MATH_TRUNC,
                visit(curr->value, EXPRESSION_RESULT)
              );
              break;
            case NearestFloat32:
            case NearestFloat64:
              ret = ValueBuilder::makeCall(
                MATH_NEAREST,
                visit(curr->value,EXPRESSION_RESULT)
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
            case RotLInt32:
              return makeSigning(ValueBuilder::makeCall(WASM_ROTL32, left, right),
                                 ASM_SIGNED);
            case RotRInt32:
              return makeSigning(ValueBuilder::makeCall(WASM_ROTR32, left, right),
                                 ASM_SIGNED);
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
      Ref ifTrue = visit(curr->ifTrue, EXPRESSION_RESULT);
      Ref ifFalse = visit(curr->ifFalse, EXPRESSION_RESULT);
      Ref condition = visit(curr->condition, EXPRESSION_RESULT);
      ScopedTemp tempIfTrue(curr->type, parent, func),
          tempIfFalse(curr->type, parent, func),
          tempCondition(i32, parent, func);
      return
        ValueBuilder::makeSeq(
          ValueBuilder::makeBinary(tempCondition.getAstName(), SET, condition),
          ValueBuilder::makeSeq(
            ValueBuilder::makeBinary(tempIfTrue.getAstName(), SET, ifTrue),
            ValueBuilder::makeSeq(
              ValueBuilder::makeBinary(tempIfFalse.getAstName(), SET, ifFalse),
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
      Ref val = (curr->value == nullptr) ?
          Ref() :
          makeAsmCoercion(
            visit(curr->value, NO_RESULT),
            wasmToAsmType(curr->value->type)
          );
      return ValueBuilder::makeReturn(val);
    }

    Ref visitHost(Host* curr) {
      if (curr->op == HostOp::GrowMemory) {
        parent->setNeedsAlmostASM("grow_memory op");
        return ValueBuilder::makeCall(WASM_GROW_MEMORY,
          makeAsmCoercion(
            visit(curr->operands[0], EXPRESSION_RESULT),
            wasmToAsmType(curr->operands[0]->type)));
      }
      if (curr->op == HostOp::CurrentMemory) {
        parent->setNeedsAlmostASM("current_memory op");
        return ValueBuilder::makeCall(WASM_CURRENT_MEMORY);
      }
      return ValueBuilder::makeCall(ABORT_FUNC);
    }

    Ref visitNop(Nop* curr) {
      return ValueBuilder::makeToplevel();
    }

    Ref visitUnreachable(Unreachable* curr) {
      return ValueBuilder::makeCall(ABORT_FUNC);
    }
  };
  return ExpressionProcessor(this, func).visit(func->body, result);
}

static void makeInstantiation(Ref ret) {
  // var __array_buffer = new ArrayBuffer(..)
  Ref mem = ValueBuilder::makeNew(
      ValueBuilder::makeCall(ARRAY_BUFFER, ValueBuilder::makeInt(0x10000)));
  Ref arrayBuffer = ValueBuilder::makeVar();
  Name buffer("__array_buffer");
  ValueBuilder::appendToVar(arrayBuffer, buffer, mem);
  flattenAppend(ret, arrayBuffer);

  // var HEAP32 = new Int32Array(__array_buffer);
  Ref heap32Array = ValueBuilder::makeNew(
      ValueBuilder::makeCall(INT32ARRAY, ValueBuilder::makeName(buffer)));
  Ref heap32 = ValueBuilder::makeVar();
  ValueBuilder::appendToVar(heap32, HEAP32, heap32Array);
  flattenAppend(ret, heap32);

  // var HEAPF32 = new Float32Array(__array_buffer);
  Ref heapf32Array = ValueBuilder::makeNew(
      ValueBuilder::makeCall(FLOAT32ARRAY, ValueBuilder::makeName(buffer)));
  Ref heapf32 = ValueBuilder::makeVar();
  ValueBuilder::appendToVar(heapf32, HEAPF32, heapf32Array);
  flattenAppend(ret, heapf32);

  // var HEAPF64 = new Float64Array(__array_buffer);
  Ref heapf64Array = ValueBuilder::makeNew(
      ValueBuilder::makeCall(FLOAT64ARRAY, ValueBuilder::makeName(buffer)));
  Ref heapf64 = ValueBuilder::makeVar();
  ValueBuilder::appendToVar(heapf64, HEAPF64, heapf64Array);
  flattenAppend(ret, heapf64);

  Ref lib = ValueBuilder::makeObject();
  auto insertItem = [&](IString item) {
    ValueBuilder::appendToObject(lib, item, ValueBuilder::makeName(item));
  };
  insertItem(MATH);
  insertItem(INT8ARRAY);
  insertItem(INT16ARRAY);
  insertItem(INT32ARRAY);
  insertItem(UINT8ARRAY);
  insertItem(UINT16ARRAY);
  insertItem(UINT32ARRAY);
  insertItem(FLOAT32ARRAY);
  insertItem(FLOAT64ARRAY);
  Ref env = ValueBuilder::makeObject();
  Ref call = ValueBuilder::makeCall(IString(ASM_FUNC), lib, env,
      ValueBuilder::makeName(buffer));
  Ref module = ValueBuilder::makeVar();
  ValueBuilder::appendToVar(module, ASM_MODULE, call);
  flattenAppend(ret, module);

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
  )"));
  flattenAppend(ret, ValueBuilder::makeName(R"(
    function f64Equal(a, b) {
       var i = new Int32Array(2);
       var f = new Float64Array(i.buffer);
       f[0] = a;
       var ai1 = f[0];
       var ai2 = f[1];
       f[0] = b;
       var bi1 = f[0];
       var bi2 = f[1];

       return (isNaN(a) && isNaN(b)) || (ai1 == bi1 && ai2 == bi2);
    }
  )"));

  // 64-bit numbers get a different ABI w/ wasm2asm, and in general you can't
  // actually export them from wasm at the boundary. We hack around this though
  // to get the spec tests working.
  flattenAppend(ret, ValueBuilder::makeName(R"(
    function i64Equal(actual_lo, expected_lo, expected_hi) {
       return actual_lo == (expected_lo | 0) &&
          asmModule.__wasm_fetch_high_bits() == (expected_hi | 0);
    }
  )"));
}

static void prefixCalls(Ref asmjs) {
  if (asmjs->isArray()) {
    ArrayStorage& arr = asmjs->getArray();
    for (Ref& r : arr) {
      prefixCalls(r);
    }
    if (arr.size() > 0 && arr[0]->isString() && arr[0]->getIString() == CALL) {
      assert(arr.size() >= 2);
      if (arr[1]->getIString() == "f32Equal" ||
          arr[1]->getIString() == "f64Equal" ||
          arr[1]->getIString() == "i64Equal") {
        // ...
      } else if (arr[1]->getIString() == "Math_fround") {
        arr[1]->setString("Math.fround");
      } else {
        Name name = arr[1]->getIString() == "isNaN" ? "Math" : ASM_MODULE;
        Ref prefixed = ValueBuilder::makeDot(ValueBuilder::makeName(name),
                                             arr[1]->getIString());
        arr[1]->setArray(prefixed->getArray());
      }
    }
  }

  if (asmjs->isAssign()) {
    prefixCalls(asmjs->asAssign()->target());
    prefixCalls(asmjs->asAssign()->value());
  }
}

Ref Wasm2AsmBuilder::makeAssertReturnFunc(SExpressionWasmBuilder& sexpBuilder,
                                          Builder& wasmBuilder,
                                          Element& e, Name testFuncName) {
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
        body = wasmBuilder.makeCall("i64Equal", {actual, expected}, i32);
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
  Ref jsFunc = processFunction(testFunc.get());
  prefixCalls(jsFunc);
  return jsFunc;
}

Ref Wasm2AsmBuilder::makeAssertReturnNanFunc(SExpressionWasmBuilder& sexpBuilder,
                                             Builder& wasmBuilder,
                                             Element& e, Name testFuncName) {
  Expression* actual = sexpBuilder.parseExpression(e[1]);
  Expression* body = wasmBuilder.makeCallImport("isNaN", {actual}, i32);
  std::unique_ptr<Function> testFunc(
    wasmBuilder.makeFunction(
      testFuncName,
      std::vector<NameType>{},
      body->type,
      std::vector<NameType>{},
      body
    )
  );
  Ref jsFunc = processFunction(testFunc.get());
  prefixCalls(jsFunc);
  return jsFunc;
}

Ref Wasm2AsmBuilder::makeAssertTrapFunc(SExpressionWasmBuilder& sexpBuilder,
                                        Builder& wasmBuilder,
                                        Element& e, Name testFuncName) {
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
  Ref innerFunc = processFunction(exprFunc.get());
  prefixCalls(innerFunc);
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

void Wasm2AsmBuilder::setNeedsAlmostASM(const char *reason) {
  if (!almostASM) {
    almostASM = true;
    std::cerr << "Switching to \"almost asm\" mode, reason: " << reason << std::endl;
  }
}

void Wasm2AsmBuilder::addMemoryGrowthFuncs(Ref ast) {
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

bool Wasm2AsmBuilder::isAssertHandled(Element& e) {
  return e.isList() && e.size() >= 2 && e[0]->isStr()
      && (e[0]->str() == Name("assert_return") ||
          e[0]->str() == Name("assert_return_nan") ||
          (flags.pedantic && e[0]->str() == Name("assert_trap")))
      && e[1]->isList() && e[1]->size() >= 2 && (*e[1])[0]->isStr()
      && (*e[1])[0]->str() == Name("invoke");
}

Ref Wasm2AsmBuilder::processAsserts(Element& root,
                                   SExpressionWasmBuilder& sexpBuilder) {
  Builder wasmBuilder(sexpBuilder.getAllocator());
  Ref ret = ValueBuilder::makeBlock();
  makeInstantiation(ret);
  for (size_t i = 1; i < root.size(); ++i) {
    Element& e = *root[i];
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
        makeAssertReturnFunc(sexpBuilder, wasmBuilder, e, testFuncName) :
        (isReturnNan ?
          makeAssertReturnNanFunc(sexpBuilder, wasmBuilder, e, testFuncName) :
          makeAssertTrapFunc(sexpBuilder, wasmBuilder, e, testFuncName));

    flattenAppend(ret, testFunc);
    std::stringstream failFuncName;
    failFuncName << "fail" << std::to_string(i);
    flattenAppend(
      ret,
      ValueBuilder::makeIf(
        ValueBuilder::makeUnary(L_NOT, ValueBuilder::makeCall(testFuncName)),
        ValueBuilder::makeCall(IString(failFuncName.str().c_str(), false)),
        Ref()
      )
    );
  }
  return ret;
}


} // namespace wasm

#endif // wasm_wasm2asm_h
