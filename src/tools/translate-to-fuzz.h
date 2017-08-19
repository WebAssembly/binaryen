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

#include <wasm-builder.h>

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
  TranslateToFuzzReader(Module& wasm) : wasm(wasm), builder(wasm) {}

  void read(std::string& filename) {
    auto input(read_file<std::vector<char>>(filename, Flags::Binary, Flags::Release));
    bytes.swap(input);
    pos = 0;
    finishedInput = false;
    // ensure *some* input to be read
    if (bytes.size() == 0) {
      bytes.push_back(0);
    }
    build();
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
  static const int USABLE_MEMORY = 32;

  // the number of runtime iterations (function calls, loop backbranches) we
  // allow before we stop execution with a trap, to prevent hangs. 0 means
  // no hang protection.
  static const int HANG_LIMIT = 100;

  // Optionally remove NaNs, which are a source of nondeterminism (which makes
  // cross-VM comparisons harder)
  static const bool DE_NAN = true;

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

  void build() {
    setupMemory();
    // keep adding functions until we run out of input
    while (!finishedInput) {
      addFunction();
    }
    if (HANG_LIMIT > 0) {
      addHangLimitSupport();
    }
    if (DE_NAN) {
      addDeNanSupport();
    }
  }

  void setupMemory() {
    wasm.memory.exists = true;
    // use one page
    wasm.memory.initial = wasm.memory.max = 1;
  }

  const Name HANG_LIMIT_GLOBAL = "hangLimit";

  void addHangLimitSupport() {
    auto* glob = new Global;
    glob->name = HANG_LIMIT_GLOBAL;
    glob->type = i32;
    glob->init = builder.makeConst(Literal(int32_t(HANG_LIMIT)));
    glob->mutable_ = true;
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

  void addFunction() {
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
    // with reasonable chance make the body a block
    if (oneIn(2)) {
      func->body = makeBlock(func->result);
    } else {
      // with very small chance, make the body unreachable
      if (oneIn(20)) {
        func->body = make(unreachable);
      } else {
        func->body = make(func->result);
      }
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
      auto* export_ = new Export;
      export_->name = func->name;
      export_->value = func->name;
      export_->kind = ExternalKind::Function;
      wasm.addExport(export_);
    }
    // cleanup
    typeLocals.clear();
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
      case i32: ret = _makei32(); break;
      case i64: ret = _makei64(); break;
      case f32: ret = _makef32(); break;
      case f64: ret = _makef64(); break;
      case none: ret = _makenone(); break;
      case unreachable: ret = _makeunreachable(); break;
      default: WASM_UNREACHABLE();
    }
    nesting--;
    return ret;
  }

  Expression* _makei32() {
    switch (upTo(13)) {
      case 0: return makeBlock(i32);
      case 1: return makeIf(i32);
      case 2: return makeLoop(i32);
      case 3: return makeBreak(i32);
      case 4: return makeCall(i32);
      case 5: return makeCallIndirect(i32);
      case 6: return makeGetLocal(i32);
      case 7: return makeSetLocal(i32);
      case 8: return makeLoad(i32);
      case 9: return makeConst(i32);
      case 10: return makeUnary(i32);
      case 11: return makeBinary(i32);
      case 12: return makeSelect(i32);
    }
    WASM_UNREACHABLE();
  }

  Expression* _makei64() {
    switch (upTo(13)) {
      case 0: return makeBlock(i64);
      case 1: return makeIf(i64);
      case 2: return makeLoop(i64);
      case 3: return makeBreak(i64);
      case 4: return makeCall(i64);
      case 5: return makeCallIndirect(i64);
      case 6: return makeGetLocal(i64);
      case 7: return makeSetLocal(i64);
      case 8: return makeLoad(i64);
      case 9: return makeConst(i64);
      case 10: return makeUnary(i64);
      case 11: return makeBinary(i64);
      case 12: return makeSelect(i64);
    }
    WASM_UNREACHABLE();
  }

  Expression* _makef32() {
    switch (upTo(13)) {
      case 0: return makeBlock(f32);
      case 1: return makeIf(f32);
      case 2: return makeLoop(f32);
      case 3: return makeBreak(f32);
      case 4: return makeCall(f32);
      case 5: return makeCallIndirect(f32);
      case 6: return makeGetLocal(f32);
      case 7: return makeSetLocal(f32);
      case 8: return makeLoad(f32);
      case 9: return makeConst(f32);
      case 10: return makeUnary(f32);
      case 11: return makeBinary(f32);
      case 12: return makeSelect(f32);
    }
    WASM_UNREACHABLE();
  }

  Expression* _makef64() {
    switch (upTo(13)) {
      case 0: return makeBlock(f64);
      case 1: return makeIf(f64);
      case 2: return makeLoop(f64);
      case 3: return makeBreak(f64);
      case 4: return makeCall(f64);
      case 5: return makeCallIndirect(f64);
      case 6: return makeGetLocal(f64);
      case 7: return makeSetLocal(f64);
      case 8: return makeLoad(f64);
      case 9: return makeConst(f64);
      case 10: return makeUnary(f64);
      case 11: return makeBinary(f64);
      case 12: return makeSelect(f64);
    }
    WASM_UNREACHABLE();
  }

  Expression* _makenone() {
    switch (upTo(10)) {
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
      return makeConst(type);
    } else if (type == none) {
      return makeNop(type);
    }
    assert(type == unreachable);
    return builder.makeReturn(
      isConcreteWasmType(func->result) ? makeConst(func->result) : nullptr
    );
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
    ret->body = makeMaybeBlock(type);
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
          case 0: if (!oneIn(4)) continue;
          case 1: if (!oneIn(2)) continue;
          default: if (oneIn(conditions + 1)) continue;
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
    return make(type); // TODO
  }

  Expression* makeGetLocal(WasmType type) {
    auto& locals = typeLocals[type];
    if (locals.empty()) return makeTrivial(type);
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

  Expression* makeLoad(WasmType type) {
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

  Store* makeStore(WasmType type) {
    if (type == unreachable) {
      // make a normal store, then make it unreachable
      auto* ret = makeStore(getConcreteType());
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

  Expression* makeConst(WasmType type) {
    Literal value;
    switch (upTo(3)) {
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
        int32_t small;
        switch (upTo(4)) {
          case 0: small = int8_t(get()); break;
          case 1: small = uint8_t(get()); break;
          case 2: small = int16_t(get16()); break;
          case 3: small = uint16_t(get16()); break;
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
          case i32: value = Literal(pick<int32_t>(0, -1, 1,
                                                  std::numeric_limits<int8_t>::min(),  std::numeric_limits<int8_t>::max(),
                                                  std::numeric_limits<int16_t>::min(), std::numeric_limits<int16_t>::max(),
                                                  std::numeric_limits<int32_t>::min(), std::numeric_limits<int32_t>::max(),
                                                  std::numeric_limits<uint8_t>::max(),
                                                  std::numeric_limits<uint16_t>::max(),
                                                  std::numeric_limits<uint32_t>::max())); break;
          case i64: value = Literal(pick<int64_t>(0, -1, 1,
                                                  std::numeric_limits<int8_t>::min(),  std::numeric_limits<int8_t>::max(),
                                                  std::numeric_limits<int16_t>::min(), std::numeric_limits<int16_t>::max(),
                                                  std::numeric_limits<int32_t>::min(), std::numeric_limits<int32_t>::max(),
                                                  std::numeric_limits<int64_t>::min(), std::numeric_limits<int64_t>::max(),
                                                  std::numeric_limits<uint8_t>::max(),
                                                  std::numeric_limits<uint16_t>::max(),
                                                  std::numeric_limits<uint32_t>::max(),
                                                  std::numeric_limits<uint64_t>::max())); break;
          case f32: value = Literal(pick<float>(0, -1, 1,
                                                std::numeric_limits<float>::min(),  std::numeric_limits<float>::max(),
                                                std::numeric_limits<int32_t>::min(), std::numeric_limits<int32_t>::max(),
                                                std::numeric_limits<int64_t>::min(), std::numeric_limits<int64_t>::max(),
                                                std::numeric_limits<uint32_t>::max(),
                                                std::numeric_limits<uint64_t>::max())); break;
          case f64: value = Literal(pick<double>(0, -1, 1,
                                                 std::numeric_limits<float>::min(),  std::numeric_limits<float>::max(),
                                                 std::numeric_limits<double>::min(),  std::numeric_limits<double>::max(),
                                                 std::numeric_limits<int32_t>::min(), std::numeric_limits<int32_t>::max(),
                                                 std::numeric_limits<int64_t>::min(), std::numeric_limits<int64_t>::max(),
                                                 std::numeric_limits<uint32_t>::max(),
                                                 std::numeric_limits<uint64_t>::max())); break;
          default: WASM_UNREACHABLE();
        }
        break;
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
          case 0: return makeUnary({ pick(EqZInt32, ClzInt32, CtzInt32, PopcntInt32), make(i32) });
          case 1: return makeUnary({ pick(EqZInt64, WrapInt64), make(i64) });
          case 2: return makeUnary({ pick(TruncSFloat32ToInt32, TruncUFloat32ToInt32, ReinterpretFloat32), make(f32) });
          case 3: return makeUnary({ pick(TruncSFloat64ToInt32, TruncUFloat64ToInt32), make(f64) });
        }
        WASM_UNREACHABLE();
      }
      case i64: {
        switch (upTo(4)) {
          case 0: return makeUnary({ pick(ClzInt64, CtzInt64, PopcntInt64), make(i64) });
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

  // apply upTo twice, generating a skewed distribution towards
  // low values
  Index upToSquared(Index x) {
    return upTo(upTo(x));
  }

  // pick from a vector
  template<typename T>
  const T& vectorPick(const std::vector<T>& vec) {
    // TODO: get32?
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

  template<typename T, typename... Args>
  T pickGivenNum(size_t num, T first, Args... args) {
    if (num == 0) return first;
    return pickGivenNum<T>(num - 1, args...);
  }

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
