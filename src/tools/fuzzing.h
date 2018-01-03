/*
 * Copyright 2017 WebAssembly Community Group participants
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
// Translate a binary stream of bytes into a valid wasm module, *somehow*.
// This is helpful for fuzzing.
//

/*
high chance for set at start of loop
  high chance of get of a set local in the scope of that scope
    high chance of a tee in that case => loop var
*/

#include <wasm-builder.h>
#include <ir/literal-utils.h>

namespace wasm {

// helper structs, since list initialization has a fixed order of
// evaluation, avoiding UB

struct ThreeArgs {
  Expression *a;
  Expression *b;
  Expression *c;
};

struct UnaryArgs {
  UnaryOp a;
  Expression *b;
};

struct BinaryArgs {
  BinaryOp a;
  Expression *b;
  Expression *c;
};

// main reader

class TranslateToFuzzReader {
public:
  TranslateToFuzzReader(Module& wasm, std::string& filename) : wasm(wasm), builder(wasm) {
    auto input(read_file<std::vector<char>>(filename, Flags::Binary, Flags::Release));
    bytes.swap(input);
    pos = 0;
    finishedInput = false;
    // ensure *some* input to be read
    if (bytes.size() == 0) {
      bytes.push_back(0);
    }
  }

  void pickPasses(OptimizationOptions& options) {
    while (options.passes.size() < 20 && !finishedInput && !oneIn(3)) {
      switch (upTo(32)) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4: {
          options.passes.push_back("O");
          options.passOptions.optimizeLevel = upTo(4);
          options.passOptions.shrinkLevel = upTo(4);
          break;
        }
        case 5: options.passes.push_back("coalesce-locals"); break;
        case 6: options.passes.push_back("code-pushing"); break;
        case 7: options.passes.push_back("code-folding"); break;
        case 8: options.passes.push_back("dce"); break;
        case 9: options.passes.push_back("duplicate-function-elimination"); break;
        case 10: options.passes.push_back("flatten"); break;
        case 11: options.passes.push_back("inlining"); break;
        case 12: options.passes.push_back("inlining-optimizing"); break;
        case 13: options.passes.push_back("local-cse"); break;
        case 14: options.passes.push_back("memory-packing"); break;
        case 15: options.passes.push_back("merge-blocks"); break;
        case 16: options.passes.push_back("optimize-instructions"); break;
        case 17: options.passes.push_back("pick-load-signs"); break;
        case 18: options.passes.push_back("precompute"); break;
        case 19: options.passes.push_back("precompute-propagate"); break;
        case 20: options.passes.push_back("remove-unused-brs"); break;
        case 21: options.passes.push_back("remove-unused-module-elements"); break;
        case 22: options.passes.push_back("remove-unused-names"); break;
        case 23: options.passes.push_back("reorder-functions"); break;
        case 24: options.passes.push_back("reorder-locals"); break;
        case 25: {
          options.passes.push_back("flatten");
          options.passes.push_back("rereloop");
          break;
        }
        case 26: options.passes.push_back("simplify-locals"); break;
        case 27: options.passes.push_back("simplify-locals-notee"); break;
        case 28: options.passes.push_back("simplify-locals-nostructure"); break;
        case 29: options.passes.push_back("simplify-locals-notee-nostructure"); break;
        case 30: options.passes.push_back("ssa"); break;
        case 31: options.passes.push_back("vacuum"); break;
        default: WASM_UNREACHABLE();
      }
    }
    if (oneIn(2)) {
      options.passOptions.optimizeLevel = upTo(4);
    }
    if (oneIn(2)) {
      options.passOptions.shrinkLevel = upTo(4);
    }
    std::cout << "opt level: " << options.passOptions.optimizeLevel << '\n';
    std::cout << "shrink level: " << options.passOptions.shrinkLevel << '\n';
  }

  void build() {
    setupMemory();
    setupTable();
    setupGlobals();
    // keep adding functions until we run out of input
    while (!finishedInput) {
      auto* func = addFunction();
      addInvocations(func);
    }
    if (HANG_LIMIT > 0) {
      addHangLimitSupport();
    }
    if (DE_NAN) {
      addDeNanSupport();
    }
    finalizeTable();
  }

private:
  Module& wasm;
  Builder builder;
  std::vector<char> bytes; // the input bytes
  size_t pos; // the position in the input
  bool finishedInput; // whether we already cycled through all the input (if so, we should try to finish things off)

  // some things require luck, try them a few times
  static const int TRIES = 10;

  // beyond a nesting limit, greatly decrease the chance to continue to nest
  static const int NESTING_LIMIT = 11;

  // reduce the chance for a function to call itself by this factor
  static const int RECURSION_FACTOR = 10;

  // the maximum size of a block
  static const int BLOCK_FACTOR = 5;

  // the memory that we use, a small portion so that we have a good chance of
  // looking at writes (we also look outside of this region with small probability)
  // this should be a power of 2
  static const int USABLE_MEMORY = 16;

  // the number of runtime iterations (function calls, loop backbranches) we
  // allow before we stop execution with a trap, to prevent hangs. 0 means
  // no hang protection.
  static const int HANG_LIMIT = 10;

  // Optionally remove NaNs, which are a source of nondeterminism (which makes
  // cross-VM comparisons harder)
  static const bool DE_NAN = true;

  // Whether to emit atomics
  static const bool ATOMICS = true;

  // after we finish the input, we start going through it again, but xoring
  // so it's not identical
  int xorFactor = 0;

  int8_t get() {
    if (pos == bytes.size()) {
      // we ran out of input, go to the start for more stuff
      finishedInput = true;
      pos = 0;
      xorFactor++;
    }
    return bytes[pos++] ^ xorFactor;
  }

  int16_t get16() {
    auto temp = uint16_t(get()) << 8;
    return temp | uint16_t(get());
  }

  int32_t get32() {
    auto temp = uint32_t(get16()) << 16;
    return temp | uint32_t(get16());
  }

  int64_t get64() {
    auto temp = uint64_t(get32()) << 32;
    return temp | uint64_t(get32());
  }

  float getFloat() {
    return Literal(get32()).reinterpretf32();
  }

  double getDouble() {
    return Literal(get64()).reinterpretf64();
  }

  void setupMemory() {
    wasm.memory.exists = true;
    // use one page
    wasm.memory.initial = wasm.memory.max = 1;
    // init some data
    wasm.memory.segments.emplace_back(builder.makeConst(Literal(int32_t(0))));
    auto num = upTo(USABLE_MEMORY * 2);
    for (size_t i = 0; i < num; i++) {
      auto value = upTo(512);
      wasm.memory.segments[0].data.push_back(value >= 256 ? 0 : (value & 0xff));
    }
  }

  void setupTable() {
    wasm.table.exists = true;
    wasm.table.segments.emplace_back(builder.makeConst(Literal(int32_t(0))));
  }

  std::map<WasmType, std::vector<Name>> globalsByType;

  void setupGlobals() {
    size_t index = 0;
    for (auto type : { i32, i64, f32, f64 }) {
      auto num = upTo(3);
      for (size_t i = 0; i < num; i++) {
        auto* glob = builder.makeGlobal(
          std::string("global$") + std::to_string(index++),
          type,
          makeConst(type),
          Builder::Mutable
        );
        wasm.addGlobal(glob);
        globalsByType[type].push_back(glob->name);
      }
    }
  }

  void finalizeTable() {
    wasm.table.initial = wasm.table.segments[0].data.size();
    wasm.table.max = oneIn(2) ? Address(Table::kMaxSize) : wasm.table.initial;
  }

  const Name HANG_LIMIT_GLOBAL = "hangLimit";

  void addHangLimitSupport() {
    auto* glob = builder.makeGlobal(
      HANG_LIMIT_GLOBAL,
      i32,
      builder.makeConst(Literal(int32_t(HANG_LIMIT))),
      Builder::Mutable
    );
    wasm.addGlobal(glob);

    auto* func = new Function;
    func->name = "hangLimitInitializer";
    func->result = none;
    func->body = builder.makeSetGlobal(glob->name,
      builder.makeConst(Literal(int32_t(HANG_LIMIT)))
    );
    wasm.addFunction(func);

    auto* export_ = new Export;
    export_->name = func->name;
    export_->value = func->name;
    export_->kind = ExternalKind::Function;
    wasm.addExport(export_);
  }

  Expression* makeHangLimitCheck() {
    return builder.makeSequence(
      builder.makeIf(
        builder.makeUnary(
          UnaryOp::EqZInt32,
          builder.makeGetGlobal(HANG_LIMIT_GLOBAL, i32)
        ),
        makeTrivial(unreachable)
      ),
      builder.makeSetGlobal(
        HANG_LIMIT_GLOBAL,
        builder.makeBinary(
          BinaryOp::SubInt32,
          builder.makeGetGlobal(HANG_LIMIT_GLOBAL, i32),
          builder.makeConst(Literal(int32_t(1)))
        )
      )
    );
  }

  void addDeNanSupport() {
    auto add = [&](Name name, WasmType type, Literal literal, BinaryOp op) {
      auto* func = new Function;
      func->name = name;
      func->params.push_back(type);
      func->result = type;
      func->body = builder.makeIf(
        builder.makeBinary(
          op,
          builder.makeGetLocal(0, type),
          builder.makeGetLocal(0, type)
        ),
        builder.makeGetLocal(0, type),
        builder.makeConst(literal)
      );
      wasm.addFunction(func);
    };
    add("deNan32", f32, Literal(float(0)), EqFloat32);
    add("deNan64", f64, Literal(double(0)), EqFloat64);
  }

  Expression* makeDeNanOp(Expression* expr) {
    if (!DE_NAN) return expr;
    if (expr->type == f32) {
      return builder.makeCall("deNan32", { expr }, f32);
    } else if (expr->type == f64) {
      return builder.makeCall("deNan64", { expr }, f64);
    }
    return expr; // unreachable etc. is fine
  }

  // function generation state

  Function* func;
  std::vector<Expression*> breakableStack; // things we can break to
  Index labelIndex;

  // a list of things relevant to computing the odds of an infinite loop,
  // which we try to minimize the risk of
  std::vector<Expression*> hangStack;

  std::map<WasmType, std::vector<Index>> typeLocals; // type => list of locals with that type

  Function* addFunction() {
    Index num = wasm.functions.size();
    func = new Function;
    func->name = std::string("func_") + std::to_string(num);
    func->result = getReachableType();
    assert(typeLocals.empty());
    Index numParams = upToSquared(5);
    for (Index i = 0; i < numParams; i++) {
      auto type = getConcreteType();
      typeLocals[type].push_back(func->params.size());
      func->params.push_back(type);
    }
    Index numVars = upToSquared(10);
    for (Index i = 0; i < numVars; i++) {
      auto type = getConcreteType();
      typeLocals[type].push_back(func->params.size() + func->vars.size());
      func->vars.push_back(type);
    }
    labelIndex = 0;
    assert(breakableStack.empty());
    assert(hangStack.empty());
    // with small chance, make the body unreachable
    auto bodyType = func->result;
    if (oneIn(10)) {
      bodyType = unreachable;
    }
    // with reasonable chance make the body a block
    if (oneIn(2)) {
      func->body = makeBlock(bodyType);
    } else {
      func->body = make(bodyType);
    }
    if (HANG_LIMIT > 0) {
      func->body = builder.makeSequence(
        makeHangLimitCheck(),
        func->body
      );
    }
    assert(breakableStack.empty());
    assert(hangStack.empty());
    wasm.addFunction(func);
    // export some, but not all (to allow inlining etc.). make sure to
    // export at least one, though, to keep each testcase interesting
    if (num == 0 || oneIn(2)) {
      func->type = ensureFunctionType(getSig(func), &wasm)->name;
      auto* export_ = new Export;
      export_->name = func->name;
      export_->value = func->name;
      export_->kind = ExternalKind::Function;
      wasm.addExport(export_);
    }
    // add some to the table
    while (oneIn(3)) {
      wasm.table.segments[0].data.push_back(func->name);
    }
    // cleanup
    typeLocals.clear();
    return func;
  }

  // the fuzzer external interface sends in zeros (simpler to compare
  // across invocations from JS or wasm-opt etc.). Add invocations in
  // the wasm, so they run everywhere
  void addInvocations(Function* func) {
    std::vector<Expression*> invocations;
    while (oneIn(2) && !finishedInput) {
      std::vector<Expression*> args;
      for (auto type : func->params) {
        args.push_back(makeConst(type));
      }
      Expression* invoke = builder.makeCall(func->name, args, func->result);
      if (isConcreteWasmType(func->result)) {
        invoke = builder.makeDrop(invoke);
      }
      invocations.push_back(invoke);
    }
    if (invocations.empty()) return;
    auto* invoker = new Function;
    invoker->name = func->name.str + std::string("_invoker");
    invoker->result = none;
    invoker->body = builder.makeBlock(invocations);
    wasm.addFunction(invoker);
    invoker->type = ensureFunctionType(getSig(invoker), &wasm)->name;
    auto* export_ = new Export;
    export_->name = invoker->name;
    export_->value = invoker->name;
    export_->kind = ExternalKind::Function;
    wasm.addExport(export_);
  }

  Name makeLabel() {
    return std::string("label$") + std::to_string(labelIndex++);
  }

  // always call the toplevel make(type) command, not the internal specific ones

  int nesting = 0;

  Expression* make(WasmType type) {
    // when we should stop, emit something small (but not necessarily trivial)
    if (finishedInput ||
        nesting >= 5 * NESTING_LIMIT || // hard limit
        (nesting >= NESTING_LIMIT && !oneIn(3))) {
      if (isConcreteWasmType(type)) {
        if (oneIn(2)) {
          return makeConst(type);
        } else {
          return makeGetLocal(type);
        }
      } else if (type == none) {
        if (oneIn(2)) {
          return makeNop(type);
        } else {
          return makeSetLocal(type);
        }
      }
      assert(type == unreachable);
      return makeTrivial(type);
    }
    nesting++;
    Expression* ret;
    switch (type) {
      case i32:
      case i64:
      case f32:
      case f64: ret = _makeConcrete(type); break;
      case none: ret = _makenone(); break;
      case unreachable: ret = _makeunreachable(); break;
      default: WASM_UNREACHABLE();
    }
    assert(ret->type == type); // we should create the right type of thing
    nesting--;
    return ret;
  }

  Expression* _makeConcrete(WasmType type) {
    auto choice = upTo(100);
    if (choice < 10) return makeConst(type);
    if (choice < 30) return makeSetLocal(type);
    if (choice < 50) return makeGetLocal(type);
    if (choice < 60) return makeBlock(type);
    if (choice < 70) return makeIf(type);
    if (choice < 80) return makeLoop(type);
    if (choice < 90) return makeBreak(type);
    switch (upTo(15)) {
      case 0: return makeBlock(type);
      case 1: return makeIf(type);
      case 2: return makeLoop(type);
      case 3: return makeBreak(type);
      case 4: return makeCall(type);
      case 5: return makeCallIndirect(type);
      case 6: return makeGetLocal(type);
      case 7: return makeSetLocal(type);
      case 8: return makeLoad(type);
      case 9: return makeConst(type);
      case 10: return makeUnary(type);
      case 11: return makeBinary(type);
      case 12: return makeSelect(type);
      case 13: return makeGetGlobal(type);
      case 14: return makeAtomic(type);
    }
    WASM_UNREACHABLE();
  }

  Expression* _makenone() {
    auto choice = upTo(100);
    if (choice < 50) return makeSetLocal(none);
    if (choice < 60) return makeBlock(none);
    if (choice < 70) return makeIf(none);
    if (choice < 80) return makeLoop(none);
    if (choice < 90) return makeBreak(none);
    switch (upTo(11)) {
      case 0: return makeBlock(none);
      case 1: return makeIf(none);
      case 2: return makeLoop(none);
      case 3: return makeBreak(none);
      case 4: return makeCall(none);
      case 5: return makeCallIndirect(none);
      case 6: return makeSetLocal(none);
      case 7: return makeStore(none);
      case 8: return makeDrop(none);
      case 9: return makeNop(none);
      case 10: return makeSetGlobal(none);
    }
    WASM_UNREACHABLE();
  }

  Expression* _makeunreachable() {
    switch (upTo(15)) {
      case 0: return makeBlock(unreachable);
      case 1: return makeIf(unreachable);
      case 2: return makeLoop(unreachable);
      case 3: return makeBreak(unreachable);
      case 4: return makeCall(unreachable);
      case 5: return makeCallIndirect(unreachable);
      case 6: return makeSetLocal(unreachable);
      case 7: return makeStore(unreachable);
      case 8: return makeUnary(unreachable);
      case 9: return makeBinary(unreachable);
      case 10: return makeSelect(unreachable);
      case 11: return makeSwitch(unreachable);
      case 12: return makeDrop(unreachable);
      case 13: return makeReturn(unreachable);
      case 14: return makeUnreachable(unreachable);
    }
    WASM_UNREACHABLE();
  }

  // make something with no chance of infinite recursion
  Expression* makeTrivial(WasmType type) {
    if (isConcreteWasmType(type)) {
      if (oneIn(2)) {
        return makeGetLocal(type);
      } else {
        return makeConst(type);
      }
    } else if (type == none) {
      return makeNop(type);
    }
    assert(type == unreachable);
    Expression* ret = nullptr;
    if (isConcreteWasmType(func->result)) {
      ret = makeTrivial(func->result);
    }
    return builder.makeReturn(ret);
  }

  // specific expression creators

  Expression* makeBlock(WasmType type) {
    auto* ret = builder.makeBlock();
    ret->type = type; // so we have it during child creation
    ret->name = makeLabel();
    breakableStack.push_back(ret);
    Index num = upToSquared(BLOCK_FACTOR - 1); // we add another later
    if (nesting >= NESTING_LIMIT / 2) {
      // smaller blocks past the limit
      num /= 2;
      if (nesting >= NESTING_LIMIT && oneIn(2)) {
        // smaller blocks past the limit
        num /= 2;
      }
    }
    // not likely to have a block of size 1
    if (num == 0 && !oneIn(10)) {
      num++;
    }
    while (num > 0 && !finishedInput) {
      ret->list.push_back(make(none));
      num--;
    }
    // give a chance to make the final element an unreachable break, instead
    // of concrete - a common pattern (branch to the top of a loop etc.)
    if (!finishedInput && isConcreteWasmType(type) && oneIn(2)) {
      ret->list.push_back(makeBreak(unreachable));
    } else {
      ret->list.push_back(make(type));
    }
    breakableStack.pop_back();
    if (isConcreteWasmType(type)) {
      ret->finalize(type);
    } else {
      ret->finalize();
    }
    if (ret->type != type) {
      // e.g. we might want an unreachable block, but a child breaks to it
      assert(type == unreachable && ret->type == none);
      return builder.makeSequence(ret, make(unreachable));
    }
    return ret;
  }

  Expression* makeLoop(WasmType type) {
    auto* ret = wasm.allocator.alloc<Loop>();
    ret->type = type; // so we have it during child creation
    ret->name = makeLabel();
    breakableStack.push_back(ret);
    hangStack.push_back(ret);
    // either create random content, or do something more targeted
    if (oneIn(2)) {
      ret->body = makeMaybeBlock(type);
    } else {
      // ensure a branch back. also optionally create some loop vars
      std::vector<Expression*> list;
      list.push_back(makeMaybeBlock(none)); // primary contents
      list.push_back(builder.makeBreak(ret->name, nullptr, makeCondition())); // possible branch back
      list.push_back(make(type)); // final element, so we have the right type
      ret->body = builder.makeBlock(list);
    }
    breakableStack.pop_back();
    hangStack.pop_back();
    if (HANG_LIMIT > 0) {
      ret->body = builder.makeSequence(
        makeHangLimitCheck(),
        ret->body
      );
    }
    ret->finalize();
    return ret;
  }

  Expression* makeCondition() {
    // we want a 50-50 chance for the condition to be taken, for interesting
    // execution paths. by itself, there is bias (e.g. most consts are "yes")
    // so even that out with noise
    auto* ret = make(i32);
    if (oneIn(2)) {
      ret = builder.makeUnary(UnaryOp::EqZInt32, ret);
    }
    return ret;
  }

  // make something, with a good chance of it being a block
  Expression* makeMaybeBlock(WasmType type) {
    // if past the limit, prefer not to emit blocks
    if (nesting >= NESTING_LIMIT || oneIn(3)) {
      return make(type);
    } else {
      return makeBlock(type);
    }
  }

  Expression* makeIf(WasmType type) {
    auto* condition = makeCondition();
    hangStack.push_back(nullptr);
    auto* ret = makeIf({ condition, makeMaybeBlock(type), makeMaybeBlock(type) });
    hangStack.pop_back();
    return ret;
  }

  Expression* makeIf(const struct ThreeArgs& args) {
    return builder.makeIf(args.a, args.b, args.c);
  }

  Expression* makeBreak(WasmType type) {
    if (breakableStack.empty()) return makeTrivial(type);
    Expression* condition = nullptr;
    if (type != unreachable) {
      hangStack.push_back(nullptr);
      condition = makeCondition();
    }
    // we need to find a proper target to break to; try a few times
    int tries = TRIES;
    while (tries-- > 0) {
      auto* target = vectorPick(breakableStack);
      auto name = getTargetName(target);
      auto valueType = getTargetType(target);
      if (isConcreteWasmType(type)) {
        // we are flowing out a value
        if (valueType != type) {
          // we need to break to a proper place
          continue;
        }
        auto* ret = builder.makeBreak(name, make(type), condition);
        hangStack.pop_back();
        return ret;
      } else if (type == none) {
        if (valueType != none) {
          // we need to break to a proper place
          continue;
        }
        auto* ret = builder.makeBreak(name, nullptr, condition);
        hangStack.pop_back();
        return ret;
      } else {
        assert(type == unreachable);
        if (valueType != none) {
          // we need to break to a proper place
          continue;
        }
        // we are about to make an *un*conditional break. if it is
        // to a loop, we prefer there to be a condition along the
        // way, to reduce the chance of infinite looping
        size_t conditions = 0;
        int i = hangStack.size();
        while (--i >= 0) {
          auto* item = hangStack[i];
          if (item == nullptr) {
            conditions++;
          } else if (auto* loop = item->cast<Loop>()) {
            if (loop->name == name) {
              // we found the target, no more conditions matter
              break;
            }
          }
        }
        switch (conditions) {
          case 0: {
            if (!oneIn(4)) continue;
            break;
          }
          case 1: {
            if (!oneIn(2)) continue;
            break;
          }
          default: {
            if (oneIn(conditions + 1)) continue;
          }
        }
        return builder.makeBreak(name);
      }
    }
    // we failed to find something
    if (type != unreachable) {
      hangStack.pop_back();
    }
    return makeTrivial(type);
  }

  Expression* makeCall(WasmType type) {
    // seems ok, go on
    int tries = TRIES;
    while (tries-- > 0) {
      Function* target = func;
      if (!wasm.functions.empty() && !oneIn(wasm.functions.size())) {
        target = vectorPick(wasm.functions).get();
      }
      if (target->result != type) continue;
      // reduce the odds of recursion dramatically, to limit infinite loops
      if (target == func && !oneIn(RECURSION_FACTOR * TRIES)) continue;
      // we found one!
      std::vector<Expression*> args;
      for (auto argType : target->params) {
        args.push_back(make(argType));
      }
      return builder.makeCall(target->name, args, type);
    }
    // we failed to find something
    return make(type);
  }

  Expression* makeCallIndirect(WasmType type) {
    auto& data = wasm.table.segments[0].data;
    if (data.empty()) return make(type);
    // look for a call target with the right type
    Index start = upTo(data.size());
    Index i = start;
    Function* func;
    while (1) {
      // TODO: handle unreachable
      func = wasm.getFunction(data[i]);
      if (func->result == type) {
        break;
      }
      i++;
      if (i == data.size()) i = 0;
      if (i == start) return make(type);
    }
    // with high probability, make sure the type is valid  otherwise, most are
    // going to trap
    Expression* target;
    if (!oneIn(10)) {
      target = builder.makeConst(Literal(int32_t(i)));
    } else {
      target = make(i32);
    }
    std::vector<Expression*> args;
    for (auto type : func->params) {
      args.push_back(make(type));
    }
    func->type = ensureFunctionType(getSig(func), &wasm)->name;
    return builder.makeCallIndirect(
      func->type,
      target,
      args,
      func->result
    );
  }

  Expression* makeGetLocal(WasmType type) {
    auto& locals = typeLocals[type];
    if (locals.empty()) return makeConst(type);
    return builder.makeGetLocal(vectorPick(locals), type);
  }

  Expression* makeSetLocal(WasmType type) {
    bool tee = type != none;
    WasmType valueType;
    if (tee) {
      valueType = type;
    } else {
      valueType = getConcreteType();
    }
    auto& locals = typeLocals[valueType];
    if (locals.empty()) return makeTrivial(type);
    auto* value = make(valueType);
    if (tee) {
      return builder.makeTeeLocal(vectorPick(locals), value);
    } else {
      return builder.makeSetLocal(vectorPick(locals), value);
    }
  }

  Expression* makeGetGlobal(WasmType type) {
    auto& globals = globalsByType[type];
    if (globals.empty()) return makeConst(type);
    return builder.makeGetGlobal(vectorPick(globals), type);
  }

  Expression* makeSetGlobal(WasmType type) {
    assert(type == none);
    type = getConcreteType();
    auto& globals = globalsByType[type];
    if (globals.empty()) return makeTrivial(none);
    auto* value = make(type);
    return builder.makeSetGlobal(vectorPick(globals), value);
  }

  Expression* makePointer() {
    auto* ret = make(i32);
    // with high probability, mask the pointer so it's in a reasonable
    // range. otherwise, most pointers are going to be out of range and
    // most memory ops will just trap
    if (!oneIn(10)) {
      ret = builder.makeBinary(AndInt32,
        ret,
        builder.makeConst(Literal(int32_t(USABLE_MEMORY - 1)))
      );
    }
    return ret;
  }

  Load* makeNonAtomicLoad(WasmType type) {
    auto offset = logify(get());
    auto ptr = makePointer();
    switch (type) {
      case i32: {
        bool signed_ = get() & 1;
        switch (upTo(3)) {
          case 0: return builder.makeLoad(1, signed_, offset, 1, ptr, type);
          case 1: return builder.makeLoad(2, signed_, offset, pick(1, 2), ptr, type);
          case 2: return builder.makeLoad(4, signed_, offset, pick(1, 2, 4), ptr, type);
        }
        WASM_UNREACHABLE();
      }
      case i64: {
        bool signed_ = get() & 1;
        switch (upTo(4)) {
          case 0: return builder.makeLoad(1, signed_, offset, 1, ptr, type);
          case 1: return builder.makeLoad(2, signed_, offset, pick(1, 2), ptr, type);
          case 2: return builder.makeLoad(4, signed_, offset, pick(1, 2, 4), ptr, type);
          case 3: return builder.makeLoad(8, signed_, offset, pick(1, 2, 4, 8), ptr, type);
        }
        WASM_UNREACHABLE();
      }
      case f32: {
        return builder.makeLoad(4, false, offset, pick(1, 2, 4), ptr, type);
      }
      case f64: {
        return builder.makeLoad(8, false, offset, pick(1, 2, 4, 8), ptr, type);
      }
      default: WASM_UNREACHABLE();
    }
  }

  Expression* makeLoad(WasmType type) {
    auto* ret = makeNonAtomicLoad(type);
    if (type != i32 && type != i64) return ret;
    if (!ATOMICS || oneIn(2)) return ret;
    // make it atomic
    wasm.memory.shared = true;
    ret->isAtomic = true;
    ret->signed_ = false;
    ret->align = ret->bytes;
    return ret;
  }

  Store* makeNonAtomicStore(WasmType type) {
    if (type == unreachable) {
      // make a normal store, then make it unreachable
      auto* ret = makeNonAtomicStore(getConcreteType());
      switch (upTo(3)) {
        case 0: ret->ptr = make(unreachable); break;
        case 1: ret->value = make(unreachable); break;
        case 2: ret->ptr = make(unreachable); ret->value = make(unreachable); break;
      }
      ret->finalize();
      return ret;
    }
    // the type is none or unreachable. we also need to pick the value
    // type.
    if (type == none) {
      type = getConcreteType();
    }
    auto offset = logify(get());
    auto ptr = makePointer();
    auto value = make(type);
    switch (type) {
      case i32: {
        switch (upTo(3)) {
          case 0: return builder.makeStore(1, offset, 1, ptr, value, type);
          case 1: return builder.makeStore(2, offset, pick(1, 2), ptr, value, type);
          case 2: return builder.makeStore(4, offset, pick(1, 2, 4), ptr, value, type);
        }
        WASM_UNREACHABLE();
      }
      case i64: {
        switch (upTo(4)) {
          case 0: return builder.makeStore(1, offset, 1, ptr, value, type);
          case 1: return builder.makeStore(2, offset, pick(1, 2), ptr, value, type);
          case 2: return builder.makeStore(4, offset, pick(1, 2, 4), ptr, value, type);
          case 3: return builder.makeStore(8, offset, pick(1, 2, 4, 8), ptr, value, type);
        }
        WASM_UNREACHABLE();
      }
      case f32: {
        return builder.makeStore(4, offset, pick(1, 2, 4), ptr, value, type);
      }
      case f64: {
        return builder.makeStore(8, offset, pick(1, 2, 4, 8), ptr, value, type);
      }
      default: WASM_UNREACHABLE();
    }
  }

  Store* makeStore(WasmType type) {
    auto* ret = makeNonAtomicStore(type);
    if (ret->value->type != i32 && ret->value->type != i64) return ret;
    if (!ATOMICS || oneIn(2)) return ret;
    // make it atomic
    wasm.memory.shared = true;
    ret->isAtomic = true;
    ret->align = ret->bytes;
    return ret;
  }

  Expression* makeConst(WasmType type) {
    Literal value;
    switch (upTo(4)) {
      case 0: {
        // totally random, entire range
        switch (type) {
          case i32: value = Literal(get32()); break;
          case i64: value = Literal(get64()); break;
          case f32: value = Literal(getFloat()); break;
          case f64: value = Literal(getDouble()); break;
          default: WASM_UNREACHABLE();
        }
        break;
      }
      case 1: {
        // small range
        int64_t small;
        switch (upTo(6)) {
          case 0: small = int8_t(get()); break;
          case 1: small = uint8_t(get()); break;
          case 2: small = int16_t(get16()); break;
          case 3: small = uint16_t(get16()); break;
          case 4: small = int32_t(get32()); break;
          case 5: small = uint32_t(get32()); break;
          default: WASM_UNREACHABLE();
        }
        switch (type) {
          case i32: value = Literal(int32_t(small)); break;
          case i64: value = Literal(int64_t(small)); break;
          case f32: value = Literal(float(small)); break;
          case f64: value = Literal(double(small)); break;
          default: WASM_UNREACHABLE();
        }
        break;
      }
      case 2: {
        // special values
        switch (type) {
          case i32: value = Literal(pick<int32_t>(0,
                                                  std::numeric_limits<int8_t>::min(),  std::numeric_limits<int8_t>::max(),
                                                  std::numeric_limits<int16_t>::min(), std::numeric_limits<int16_t>::max(),
                                                  std::numeric_limits<int32_t>::min(), std::numeric_limits<int32_t>::max(),
                                                  std::numeric_limits<uint8_t>::max(),
                                                  std::numeric_limits<uint16_t>::max(),
                                                  std::numeric_limits<uint32_t>::max())); break;
          case i64: value = Literal(pick<int64_t>(0,
                                                  std::numeric_limits<int8_t>::min(),  std::numeric_limits<int8_t>::max(),
                                                  std::numeric_limits<int16_t>::min(), std::numeric_limits<int16_t>::max(),
                                                  std::numeric_limits<int32_t>::min(), std::numeric_limits<int32_t>::max(),
                                                  std::numeric_limits<int64_t>::min(), std::numeric_limits<int64_t>::max(),
                                                  std::numeric_limits<uint8_t>::max(),
                                                  std::numeric_limits<uint16_t>::max(),
                                                  std::numeric_limits<uint32_t>::max(),
                                                  std::numeric_limits<uint64_t>::max())); break;
          case f32: value = Literal(pick<float>(0,
                                                std::numeric_limits<float>::min(),  std::numeric_limits<float>::max(),
                                                std::numeric_limits<int32_t>::min(), std::numeric_limits<int32_t>::max(),
                                                std::numeric_limits<int64_t>::min(), std::numeric_limits<int64_t>::max(),
                                                std::numeric_limits<uint32_t>::max(),
                                                std::numeric_limits<uint64_t>::max())); break;
          case f64: value = Literal(pick<double>(0,
                                                 std::numeric_limits<float>::min(),  std::numeric_limits<float>::max(),
                                                 std::numeric_limits<double>::min(),  std::numeric_limits<double>::max(),
                                                 std::numeric_limits<int32_t>::min(), std::numeric_limits<int32_t>::max(),
                                                 std::numeric_limits<int64_t>::min(), std::numeric_limits<int64_t>::max(),
                                                 std::numeric_limits<uint32_t>::max(),
                                                 std::numeric_limits<uint64_t>::max())); break;
          default: WASM_UNREACHABLE();
        }
        // tweak around special values
        if (oneIn(3)) { // +- 1
          value = value.add(LiteralUtils::makeLiteralFromInt32(upTo(3) - 1, type));
        }
        if (oneIn(2)) { // flip sign
          value = value.mul(LiteralUtils::makeLiteralFromInt32(-1, type));
        }
        break;
      }
      case 3: {
        // powers of 2
        switch (type) {
          case i32: value = Literal(int32_t(1) << upTo(32)); break;
          case i64: value = Literal(int64_t(1) << upTo(64)); break;
          case f32: value = Literal(float(int64_t(1) << upTo(64))); break;
          case f64: value = Literal(double(int64_t(1) << upTo(64))); break;
          default: WASM_UNREACHABLE();
        }
        // maybe negative
        if (oneIn(2)) {
          value = value.mul(LiteralUtils::makeLiteralFromInt32(-1, type));
        }
      }
    }
    auto* ret = wasm.allocator.alloc<Const>();
    ret->value = value;
    ret->type = value.type;
    return ret;
  }

  Expression* makeUnary(const UnaryArgs& args) {
    return builder.makeUnary(args.a, args.b);
  }

  Expression* makeUnary(WasmType type) {
    if (type == unreachable) {
      if (auto* unary = makeUnary(getConcreteType())->dynCast<Unary>()) {
        return makeDeNanOp(builder.makeUnary(unary->op, make(unreachable)));
      }
      // give up
      return makeTrivial(type);
    }
    switch (type) {
      case i32: {
        switch (upTo(4)) {
          case 0: return makeUnary({ pick(EqZInt32, ClzInt32, CtzInt32, PopcntInt32, ExtendS8Int32, ExtendS16Int32), make(i32) });
          case 1: return makeUnary({ pick(EqZInt64, WrapInt64), make(i64) });
          case 2: return makeUnary({ pick(TruncSFloat32ToInt32, TruncUFloat32ToInt32, ReinterpretFloat32), make(f32) });
          case 3: return makeUnary({ pick(TruncSFloat64ToInt32, TruncUFloat64ToInt32), make(f64) });
        }
        WASM_UNREACHABLE();
      }
      case i64: {
        switch (upTo(4)) {
          case 0: return makeUnary({ pick(ClzInt64, CtzInt64, PopcntInt64, ExtendS8Int64, ExtendS16Int64, ExtendS32Int64), make(i64) });
          case 1: return makeUnary({ pick(ExtendSInt32, ExtendUInt32), make(i32) });
          case 2: return makeUnary({ pick(TruncSFloat32ToInt64, TruncUFloat32ToInt64), make(f32) });
          case 3: return makeUnary({ pick(TruncSFloat64ToInt64, TruncUFloat64ToInt64, ReinterpretFloat64), make(f64) });
        }
        WASM_UNREACHABLE();
      }
      case f32: {
        switch (upTo(4)) {
          case 0: return makeDeNanOp(makeUnary({ pick(NegFloat32, AbsFloat32, CeilFloat32, FloorFloat32, TruncFloat32, NearestFloat32, SqrtFloat32), make(f32) }));
          case 1: return makeDeNanOp(makeUnary({ pick(ConvertUInt32ToFloat32, ConvertSInt32ToFloat32, ReinterpretInt32), make(i32) }));
          case 2: return makeDeNanOp(makeUnary({ pick(ConvertUInt64ToFloat32, ConvertSInt64ToFloat32), make(i64) }));
          case 3: return makeDeNanOp(makeUnary({ DemoteFloat64, make(f64) }));
        }
        WASM_UNREACHABLE();
      }
      case f64: {
        switch (upTo(4)) {
          case 0: return makeDeNanOp(makeUnary({ pick(NegFloat64, AbsFloat64, CeilFloat64, FloorFloat64, TruncFloat64, NearestFloat64, SqrtFloat64), make(f64) }));
          case 1: return makeDeNanOp(makeUnary({ pick(ConvertUInt32ToFloat64, ConvertSInt32ToFloat64), make(i32) }));
          case 2: return makeDeNanOp(makeUnary({ pick(ConvertUInt64ToFloat64, ConvertSInt64ToFloat64, ReinterpretInt64), make(i64) }));
          case 3: return makeDeNanOp(makeUnary({ PromoteFloat32, make(f32) }));
        }
        WASM_UNREACHABLE();
      }
      default: WASM_UNREACHABLE();
    }
    WASM_UNREACHABLE();
  }

  Expression* makeBinary(const BinaryArgs& args) {
    return builder.makeBinary(args.a, args.b, args.c);
  }

  Expression* makeBinary(WasmType type) {
    if (type == unreachable) {
      if (auto* binary = makeBinary(getConcreteType())->dynCast<Binary>()) {
        return makeDeNanOp(makeBinary({ binary->op, make(unreachable), make(unreachable) }));
      }
      // give up
      return makeTrivial(type);
    }
    switch (type) {
      case i32: {
        switch (upTo(4)) {
          case 0: return makeBinary({ pick(AddInt32, SubInt32, MulInt32, DivSInt32, DivUInt32, RemSInt32, RemUInt32, AndInt32, OrInt32, XorInt32, ShlInt32, ShrUInt32, ShrSInt32, RotLInt32, RotRInt32, EqInt32, NeInt32, LtSInt32, LtUInt32, LeSInt32, LeUInt32, GtSInt32, GtUInt32, GeSInt32, GeUInt32), make(i32), make(i32) });
          case 1: return makeBinary({ pick(EqInt64, NeInt64, LtSInt64, LtUInt64, LeSInt64, LeUInt64, GtSInt64, GtUInt64, GeSInt64, GeUInt64), make(i64), make(i64) });
          case 2: return makeBinary({ pick(EqFloat32, NeFloat32, LtFloat32, LeFloat32, GtFloat32, GeFloat32), make(f32), make(f32) });
          case 3: return makeBinary({ pick(EqFloat64, NeFloat64, LtFloat64, LeFloat64, GtFloat64, GeFloat64), make(f64), make(f64) });
        }
        WASM_UNREACHABLE();
      }
      case i64: {
        return makeBinary({ pick(AddInt64, SubInt64, MulInt64, DivSInt64, DivUInt64, RemSInt64, RemUInt64, AndInt64, OrInt64, XorInt64, ShlInt64, ShrUInt64, ShrSInt64, RotLInt64, RotRInt64), make(i64), make(i64) });
      }
      case f32: {
        return makeDeNanOp(makeBinary({ pick(AddFloat32, SubFloat32, MulFloat32, DivFloat32, CopySignFloat32, MinFloat32, MaxFloat32), make(f32), make(f32) }));
      }
      case f64: {
        return makeDeNanOp(makeBinary({ pick(AddFloat64, SubFloat64, MulFloat64, DivFloat64, CopySignFloat64, MinFloat64, MaxFloat64), make(f64), make(f64) }));
      }
      default: WASM_UNREACHABLE();
    }
    WASM_UNREACHABLE();
  }

  Expression* makeSelect(const ThreeArgs& args) {
    return builder.makeSelect(args.a, args.b, args.c);
  }

  Expression* makeSelect(WasmType type) {
    return makeDeNanOp(makeSelect({ make(i32), make(type), make(type) }));
  }

  Expression* makeSwitch(WasmType type) {
    assert(type == unreachable);
    if (breakableStack.empty()) return make(type);
    // we need to find proper targets to break to; try a bunch
    int tries = TRIES;
    std::vector<Name> names;
    WasmType valueType = unreachable;
    while (tries-- > 0) {
      auto* target = vectorPick(breakableStack);
      auto name = getTargetName(target);
      auto currValueType = getTargetType(target);
      if (names.empty()) {
        valueType = currValueType;
      } else {
        if (valueType != currValueType) {
          continue; // all values must be the same
        }
      }
      names.push_back(name);
    }
    if (names.size() < 2) {
      // we failed to find enough
      return make(type);
    }
    auto default_ = names.back();
    names.pop_back();
    auto temp1 = make(i32), temp2 = isConcreteWasmType(valueType) ? make(valueType) : nullptr;
    return builder.makeSwitch(names, default_, temp1, temp2);
  }

  Expression* makeDrop(WasmType type) {
    return builder.makeDrop(make(type == unreachable ? type : getConcreteType()));
  }

  Expression* makeReturn(WasmType type) {
    return builder.makeReturn(isConcreteWasmType(func->result) ? make(func->result) : nullptr);
  }

  Expression* makeNop(WasmType type) {
    assert(type == none);
    return builder.makeNop();
  }

  Expression* makeUnreachable(WasmType type) {
    assert(type == unreachable);
    return builder.makeUnreachable();
  }

  Expression* makeAtomic(WasmType type) {
    if (!ATOMICS || (type != i32 && type != i64)) return makeTrivial(type);
    wasm.memory.shared = true;
    if (type == i32 && oneIn(2)) {
      if (oneIn(2)) {
        auto* ptr = makePointer();
        auto expectedType = pick(i32, i64);
        auto* expected = make(expectedType);
        auto* timeout = make(i64);
        return builder.makeAtomicWait(ptr, expected, timeout, expectedType);
      } else {
        auto* ptr = makePointer();
        auto* count = make(i32);
        return builder.makeAtomicWake(ptr, count);
      }
    }
    Index bytes;
    switch (type) {
      case i32: {
        switch (upTo(3)) {
          case 0: bytes = 1; break;
          case 1: bytes = pick(1, 2); break;
          case 2: bytes = pick(1, 2, 4); break;
          default: WASM_UNREACHABLE();
        }
        break;
      }
      case i64: {
        switch (upTo(4)) {
          case 0: bytes = 1; break;
          case 1: bytes = pick(1, 2); break;
          case 2: bytes = pick(1, 2, 4); break;
          case 3: bytes = pick(1, 2, 4, 8); break;
          default: WASM_UNREACHABLE();
        }
        break;
      }
      default: WASM_UNREACHABLE();
    }
    auto offset = logify(get());
    auto* ptr = makePointer();
    if (oneIn(2)) {
      auto* value = make(type);
      return builder.makeAtomicRMW(pick(AtomicRMWOp::Add, AtomicRMWOp::Sub, AtomicRMWOp::And, AtomicRMWOp::Or, AtomicRMWOp::Xor, AtomicRMWOp::Xchg),
                                   bytes, offset, ptr, value, type);
    } else {
      auto* expected = make(type);
      auto* replacement = make(type);
      return builder.makeAtomicCmpxchg(bytes, offset, ptr, expected, replacement, type);
    }
  }

  // special getters

  WasmType getType() {
    switch (upTo(6)) {
      case 0: return i32;
      case 1: return i64;
      case 2: return f32;
      case 3: return f64;
      case 4: return none;
      case 5: return unreachable;
    }
    WASM_UNREACHABLE();
  }

  WasmType getReachableType() {
    switch (upTo(5)) {
      case 0: return i32;
      case 1: return i64;
      case 2: return f32;
      case 3: return f64;
      case 4: return none;
    }
    WASM_UNREACHABLE();
  }

  WasmType getConcreteType() {
    switch (upTo(4)) {
      case 0: return i32;
      case 1: return i64;
      case 2: return f32;
      case 3: return f64;
    }
    WASM_UNREACHABLE();
  }

  // statistical distributions

  // 0 to the limit, logarithmic scale
  Index logify(Index x) {
    return std::floor(std::log(std::max(Index(1) + x, Index(1))));
  }

  // one of the integer values in [0, x)
  // this isn't a perfectly uniform distribution, but it's fast
  // and reasonable
  Index upTo(Index x) {
    if (x == 0) return 0;
    Index raw;
    if (x <= 255) {
      raw = get();
    } else if (x <= 65535) {
      raw = get16();
    } else {
      raw = get32();
    }
    auto ret = raw % x;
    // use extra bits as "noise" for later
    xorFactor += raw / x;
    return ret;
  }

  bool oneIn(Index x) {
    return upTo(x) == 0;
  }

  bool onceEvery(Index x) {
    static int counter = 0;
    counter++;
    return counter % x == 0;
  }

  // apply upTo twice, generating a skewed distribution towards
  // low values
  Index upToSquared(Index x) {
    return upTo(upTo(x));
  }

  // pick from a vector
  template<typename T>
  const T& vectorPick(const std::vector<T>& vec) {
    assert(!vec.empty());
    auto index = upTo(vec.size());
    return vec[index];
  }

  // pick from a fixed list
  template<typename T, typename... Args>
  T pick(T first, Args... args) {
    auto num = sizeof...(Args) + 1;
    auto temp = upTo(num);
    return pickGivenNum<T>(temp, first, args...);
  }

  template<typename T>
  T pickGivenNum(size_t num, T first) {
    assert(num == 0);
    return first;
  }

  // Trick to avoid a bug in GCC 7.x.
  // Upstream bug report: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82800
  #define GCC_VERSION (__GNUC__ * 10000 \
                     + __GNUC_MINOR__ * 100 \
                     + __GNUC_PATCHLEVEL__)
  #if GCC_VERSION > 70000 && GCC_VERSION < 70300
    #pragma GCC diagnostic push
    #pragma GCC diagnostic ignored "-Wmaybe-uninitialized"
  #endif

  template<typename T, typename... Args>
  T pickGivenNum(size_t num, T first, Args... args) {
    if (num == 0) return first;
    return pickGivenNum<T>(num - 1, args...);
  }

  #if GCC_VERSION > 70000 && GCC_VERSION < 70300
    #pragma GCC diagnostic pop
  #endif

  // utilities

  Name getTargetName(Expression* target) {
    if (auto* block = target->dynCast<Block>()) {
      return block->name;
    } else if (auto* loop = target->dynCast<Loop>()) {
      return loop->name;
    }
    WASM_UNREACHABLE();
  }

  WasmType getTargetType(Expression* target) {
    if (auto* block = target->dynCast<Block>()) {
      return block->type;
    } else if (target->is<Loop>()) {
      return none;
    }
    WASM_UNREACHABLE();
  }
};

} // namespace wasm

// XXX Switch class has a condition?! is it real? should the node type be the value type if it exists?!
