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

// TODO Complete exnref type support. Its support is partialy implemented
// and the type is currently not generated in fuzzed programs yet.

#include "ir/memory-utils.h"
#include <ir/find_all.h>
#include <ir/literal-utils.h>
#include <ir/manipulation.h>
#include <ir/utils.h>
#include <support/file.h>
#include <tools/optimization-options.h>
#include <wasm-builder.h>

namespace wasm {

// helper structs, since list initialization has a fixed order of
// evaluation, avoiding UB

struct ThreeArgs {
  Expression* a;
  Expression* b;
  Expression* c;
};

struct UnaryArgs {
  UnaryOp a;
  Expression* b;
};

struct BinaryArgs {
  BinaryOp a;
  Expression* b;
  Expression* c;
};

// main reader

class TranslateToFuzzReader {
public:
  TranslateToFuzzReader(Module& wasm, std::string& filename)
    : wasm(wasm), builder(wasm) {
    auto input(read_file<std::vector<char>>(filename, Flags::Binary));
    readData(input);
  }

  TranslateToFuzzReader(Module& wasm, std::vector<char> input)
    : wasm(wasm), builder(wasm) {
    readData(input);
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
        case 5:
          options.passes.push_back("coalesce-locals");
          break;
        case 6:
          options.passes.push_back("code-pushing");
          break;
        case 7:
          options.passes.push_back("code-folding");
          break;
        case 8:
          options.passes.push_back("dce");
          break;
        case 9:
          options.passes.push_back("duplicate-function-elimination");
          break;
        case 10:
          options.passes.push_back("flatten");
          break;
        case 11:
          options.passes.push_back("inlining");
          break;
        case 12:
          options.passes.push_back("inlining-optimizing");
          break;
        case 13:
          options.passes.push_back("local-cse");
          break;
        case 14:
          options.passes.push_back("memory-packing");
          break;
        case 15:
          options.passes.push_back("merge-blocks");
          break;
        case 16:
          options.passes.push_back("optimize-instructions");
          break;
        case 17:
          options.passes.push_back("pick-load-signs");
          break;
        case 18:
          options.passes.push_back("precompute");
          break;
        case 19:
          options.passes.push_back("precompute-propagate");
          break;
        case 20:
          options.passes.push_back("remove-unused-brs");
          break;
        case 21:
          options.passes.push_back("remove-unused-module-elements");
          break;
        case 22:
          options.passes.push_back("remove-unused-names");
          break;
        case 23:
          options.passes.push_back("reorder-functions");
          break;
        case 24:
          options.passes.push_back("reorder-locals");
          break;
        case 25: {
          options.passes.push_back("flatten");
          options.passes.push_back("rereloop");
          break;
        }
        case 26:
          options.passes.push_back("simplify-locals");
          break;
        case 27:
          options.passes.push_back("simplify-locals-notee");
          break;
        case 28:
          options.passes.push_back("simplify-locals-nostructure");
          break;
        case 29:
          options.passes.push_back("simplify-locals-notee-nostructure");
          break;
        case 30:
          options.passes.push_back("ssa");
          break;
        case 31:
          options.passes.push_back("vacuum");
          break;
        default:
          WASM_UNREACHABLE("unexpected value");
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

  void setAllowNaNs(bool allowNaNs_) { allowNaNs = allowNaNs_; }

  void setAllowMemory(bool allowMemory_) { allowMemory = allowMemory_; }

  void setAllowOOB(bool allowOOB_) { allowOOB = allowOOB_; }

  void build() {
    if (allowMemory) {
      setupMemory();
    }
    setupTable();
    setupGlobals();
    if (wasm.features.hasExceptionHandling()) {
      setupEvents();
    }
    addImportLoggingSupport();
    // keep adding functions until we run out of input
    while (!finishedInput) {
      auto* func = addFunction();
      addInvocations(func);
    }
    if (HANG_LIMIT > 0) {
      addHangLimitSupport();
    }
    if (!allowNaNs) {
      addDeNanSupport();
    }
    finalizeTable();
  }

private:
  Module& wasm;
  Builder builder;
  std::vector<char> bytes; // the input bytes
  size_t pos;              // the position in the input
  // whether we already cycled through all the input (if so, we should try to
  // finish things off)
  bool finishedInput;

  // The maximum amount of params to each function.
  static const int MAX_PARAMS = 10;

  // The maximum amount of vars in each function.
  static const int MAX_VARS = 20;

  // some things require luck, try them a few times
  static const int TRIES = 10;

  // beyond a nesting limit, greatly decrease the chance to continue to nest
  static const int NESTING_LIMIT = 11;

  // the maximum size of a block
  static const int BLOCK_FACTOR = 5;

  // the memory that we use, a small portion so that we have a good chance of
  // looking at writes (we also look outside of this region with small
  // probability) this should be a power of 2
  static const int USABLE_MEMORY = 16;

  // the number of runtime iterations (function calls, loop backbranches) we
  // allow before we stop execution with a trap, to prevent hangs. 0 means
  // no hang protection.
  static const int HANG_LIMIT = 10;

  // Optionally remove NaNs, which are a source of nondeterminism (which makes
  // cross-VM comparisons harder)
  // TODO: de-NaN SIMD values
  bool allowNaNs = true;

  // Whether to emit memory operations like loads and stores.
  bool allowMemory = true;

  // Whether to emit loads, stores, and call_indirects that may be out
  // of bounds (which traps in wasm, and is undefined behavior in C).
  bool allowOOB = true;

  // Whether to emit atomic waits (which in single-threaded mode, may hang...)
  static const bool ATOMIC_WAITS = false;

  // After we finish the input, we start going through it again, but xoring
  // so it's not identical
  int xorFactor = 0;

  // The chance to emit a logging operation for a none expression. We
  // randomize this in each function.
  unsigned LOGGING_PERCENT = 0;

  void readData(std::vector<char> input) {
    bytes.swap(input);
    pos = 0;
    finishedInput = false;
    // ensure *some* input to be read
    if (bytes.size() == 0) {
      bytes.push_back(0);
    }
  }

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

  float getFloat() { return Literal(get32()).reinterpretf32(); }

  double getDouble() { return Literal(get64()).reinterpretf64(); }

  void setupMemory() {
    // Add memory itself
    MemoryUtils::ensureExists(wasm.memory);
    if (wasm.features.hasBulkMemory()) {
      size_t memCovered = 0;
      // need at least one segment for memory.inits
      size_t numSegments = upTo(8) + 1;
      for (size_t i = 0; i < numSegments; i++) {
        Memory::Segment segment;
        segment.isPassive = bool(upTo(2));
        size_t segSize = upTo(USABLE_MEMORY * 2);
        segment.data.resize(segSize);
        for (size_t j = 0; j < segSize; j++) {
          segment.data[j] = upTo(512);
        }
        if (!segment.isPassive) {
          segment.offset = builder.makeConst(Literal(int32_t(memCovered)));
          memCovered += segSize;
        }
        wasm.memory.segments.push_back(segment);
      }
    } else {
      // init some data
      wasm.memory.segments.emplace_back(builder.makeConst(Literal(int32_t(0))));
      auto num = upTo(USABLE_MEMORY * 2);
      for (size_t i = 0; i < num; i++) {
        auto value = upTo(512);
        wasm.memory.segments[0].data.push_back(value >= 256 ? 0
                                                            : (value & 0xff));
      }
    }
    // Add memory hasher helper (for the hash, see hash.h). The function looks
    // like:
    // function hashMemory() {
    //   hash = 5381;
    //   hash = ((hash << 5) + hash) ^ mem[0];
    //   hash = ((hash << 5) + hash) ^ mem[1];
    //   ..
    //   return hash;
    // }
    std::vector<Expression*> contents;
    contents.push_back(
      builder.makeLocalSet(0, builder.makeConst(Literal(uint32_t(5381)))));
    for (Index i = 0; i < USABLE_MEMORY; i++) {
      contents.push_back(builder.makeLocalSet(
        0,
        builder.makeBinary(
          XorInt32,
          builder.makeBinary(
            AddInt32,
            builder.makeBinary(ShlInt32,
                               builder.makeLocalGet(0, i32),
                               builder.makeConst(Literal(uint32_t(5)))),
            builder.makeLocalGet(0, i32)),
          builder.makeLoad(
            1, false, i, 1, builder.makeConst(Literal(uint32_t(0))), i32))));
    }
    contents.push_back(builder.makeLocalGet(0, i32));
    auto* body = builder.makeBlock(contents);
    auto* hasher = wasm.addFunction(builder.makeFunction(
      "hashMemory", Signature(Type::none, Type::i32), {i32}, body));
    wasm.addExport(
      builder.makeExport(hasher->name, hasher->name, ExternalKind::Function));
    // Export memory so JS fuzzing can use it
    wasm.addExport(builder.makeExport("memory", "0", ExternalKind::Memory));
  }

  void setupTable() {
    wasm.table.exists = true;
    wasm.table.segments.emplace_back(builder.makeConst(Literal(int32_t(0))));
  }

  std::map<Type, std::vector<Name>> globalsByType;

  void setupGlobals() {
    size_t index = 0;
    for (auto type : getConcreteTypes()) {
      auto num = upTo(3);
      for (size_t i = 0; i < num; i++) {
        auto* glob =
          builder.makeGlobal(std::string("global$") + std::to_string(index++),
                             type,
                             makeConst(type),
                             Builder::Mutable);
        wasm.addGlobal(glob);
        globalsByType[type].push_back(glob->name);
      }
    }
  }

  void setupEvents() {
    Index num = upTo(3);
    for (size_t i = 0; i < num; i++) {
      // Events should have void return type and at least one param type
      std::vector<Type> params;
      Index numValues = upToSquared(MAX_PARAMS - 1);
      for (Index i = 0; i < numValues + 1; i++) {
        params.push_back(pick(i32, i64, f32, f64));
      }
      auto* event = builder.makeEvent(std::string("event$") + std::to_string(i),
                                      WASM_EVENT_ATTRIBUTE_EXCEPTION,
                                      Signature(Type(params), Type::none));
      wasm.addEvent(event);
    }
  }

  void finalizeTable() {
    wasm.table.initial = wasm.table.segments[0].data.size();
    wasm.table.max =
      oneIn(2) ? Address(Table::kUnlimitedSize) : wasm.table.initial;
  }

  const Name HANG_LIMIT_GLOBAL = "hangLimit";

  void addHangLimitSupport() {
    auto* glob =
      builder.makeGlobal(HANG_LIMIT_GLOBAL,
                         i32,
                         builder.makeConst(Literal(int32_t(HANG_LIMIT))),
                         Builder::Mutable);
    wasm.addGlobal(glob);

    auto* func = new Function;
    func->name = "hangLimitInitializer";
    func->sig = Signature(Type::none, Type::none);
    func->body = builder.makeGlobalSet(
      glob->name, builder.makeConst(Literal(int32_t(HANG_LIMIT))));
    wasm.addFunction(func);

    auto* export_ = new Export;
    export_->name = func->name;
    export_->value = func->name;
    export_->kind = ExternalKind::Function;
    wasm.addExport(export_);
  }

  void addImportLoggingSupport() {
    for (auto type : getConcreteTypes()) {
      auto* func = new Function;
      Name name = std::string("log-") + type.toString();
      func->name = name;
      func->module = "fuzzing-support";
      func->base = name;
      func->sig = Signature(type, Type::none);
      wasm.addFunction(func);
    }
  }

  Expression* makeHangLimitCheck() {
    return builder.makeSequence(
      builder.makeIf(
        builder.makeUnary(UnaryOp::EqZInt32,
                          builder.makeGlobalGet(HANG_LIMIT_GLOBAL, i32)),
        makeTrivial(unreachable)),
      builder.makeGlobalSet(
        HANG_LIMIT_GLOBAL,
        builder.makeBinary(BinaryOp::SubInt32,
                           builder.makeGlobalGet(HANG_LIMIT_GLOBAL, i32),
                           builder.makeConst(Literal(int32_t(1))))));
  }

  void addDeNanSupport() {
    auto add = [&](Name name, Type type, Literal literal, BinaryOp op) {
      auto* func = new Function;
      func->name = name;
      func->sig = Signature(type, type);
      func->body = builder.makeIf(
        builder.makeBinary(
          op, builder.makeLocalGet(0, type), builder.makeLocalGet(0, type)),
        builder.makeLocalGet(0, type),
        builder.makeConst(literal));
      wasm.addFunction(func);
    };
    add("deNan32", f32, Literal(float(0)), EqFloat32);
    add("deNan64", f64, Literal(double(0)), EqFloat64);
  }

  Expression* makeDeNanOp(Expression* expr) {
    if (allowNaNs) {
      return expr;
    }
    if (expr->type == f32) {
      return builder.makeCall("deNan32", {expr}, f32);
    } else if (expr->type == f64) {
      return builder.makeCall("deNan64", {expr}, f64);
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

  std::map<Type, std::vector<Index>>
    typeLocals; // type => list of locals with that type

  Function* addFunction() {
    LOGGING_PERCENT = upToSquared(100);
    Index num = wasm.functions.size();
    func = new Function;
    func->name = std::string("func_") + std::to_string(num);
    assert(typeLocals.empty());
    Index numParams = upToSquared(MAX_PARAMS);
    std::vector<Type> params;
    params.reserve(numParams);
    for (Index i = 0; i < numParams; i++) {
      auto type = getConcreteType();
      typeLocals[type].push_back(params.size());
      params.push_back(type);
    }
    func->sig = Signature(Type(params), getReachableType());
    Index numVars = upToSquared(MAX_VARS);
    for (Index i = 0; i < numVars; i++) {
      auto type = getConcreteType();
      typeLocals[type].push_back(params.size() + func->vars.size());
      func->vars.push_back(type);
    }
    labelIndex = 0;
    assert(breakableStack.empty());
    assert(hangStack.empty());
    // with small chance, make the body unreachable
    auto bodyType = func->sig.results;
    if (oneIn(10)) {
      bodyType = unreachable;
    }
    // with reasonable chance make the body a block
    if (oneIn(2)) {
      func->body = makeBlock(bodyType);
    } else {
      func->body = make(bodyType);
    }
    // Recombinations create duplicate code patterns.
    recombine(func);
    // Mutations add random small changes, which can subtly break duplicate code
    // patterns.
    mutate(func);
    // TODO: liveness operations on gets, with some prob alter a get to one with
    //       more possible sets
    // Recombination, mutation, etc. can break validation; fix things up after.
    fixLabels(func);
    // Add hang limit checks after all other operations on the function body.
    if (HANG_LIMIT > 0) {
      addHangLimitChecks(func);
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
    // add some to the table
    while (oneIn(3)) {
      wasm.table.segments[0].data.push_back(func->name);
    }
    // cleanup
    typeLocals.clear();
    return func;
  }

  void addHangLimitChecks(Function* func) {
    // loop limit
    FindAll<Loop> loops(func->body);
    for (auto* loop : loops.list) {
      loop->body = builder.makeSequence(makeHangLimitCheck(), loop->body);
    }
    // recursion limit
    func->body = builder.makeSequence(makeHangLimitCheck(), func->body);
  }

  void recombine(Function* func) {
    // Don't always do this.
    if (oneIn(2)) {
      return;
    }
    // First, scan and group all expressions by type.
    struct Scanner
      : public PostWalker<Scanner, UnifiedExpressionVisitor<Scanner>> {
      // A map of all expressions, categorized by type.
      std::map<Type, std::vector<Expression*>> exprsByType;

      void visitExpression(Expression* curr) {
        exprsByType[curr->type].push_back(curr);
      }
    };
    Scanner scanner;
    scanner.walk(func->body);
    // Potentially trim the list of possible picks, so replacements are more
    // likely to collide.
    for (auto& pair : scanner.exprsByType) {
      if (oneIn(2)) {
        continue;
      }
      auto& list = pair.second;
      std::vector<Expression*> trimmed;
      size_t num = upToSquared(list.size());
      for (size_t i = 0; i < num; i++) {
        trimmed.push_back(pick(list));
      }
      if (trimmed.empty()) {
        trimmed.push_back(pick(list));
      }
      list.swap(trimmed);
    }
    // Replace them with copies, to avoid a copy into one altering another copy
    for (auto& pair : scanner.exprsByType) {
      for (auto*& item : pair.second) {
        item = ExpressionManipulator::copy(item, wasm);
      }
    }
    // Second, with some probability replace an item with another item having
    // the same type. (This is not always valid due to nesting of labels, but
    // we'll fix that up later.)
    struct Modder
      : public PostWalker<Modder, UnifiedExpressionVisitor<Modder>> {
      Module& wasm;
      Scanner& scanner;
      TranslateToFuzzReader& parent;

      Modder(Module& wasm, Scanner& scanner, TranslateToFuzzReader& parent)
        : wasm(wasm), scanner(scanner), parent(parent) {}

      void visitExpression(Expression* curr) {
        if (parent.oneIn(10)) {
          // Replace it!
          auto& candidates = scanner.exprsByType[curr->type];
          assert(!candidates.empty()); // this expression itself must be there
          replaceCurrent(
            ExpressionManipulator::copy(parent.pick(candidates), wasm));
        }
      }
    };
    Modder modder(wasm, scanner, *this);
    modder.walk(func->body);
  }

  void mutate(Function* func) {
    // Don't always do this.
    if (oneIn(2)) {
      return;
    }
    struct Modder
      : public PostWalker<Modder, UnifiedExpressionVisitor<Modder>> {
      Module& wasm;
      TranslateToFuzzReader& parent;

      Modder(Module& wasm, TranslateToFuzzReader& parent)
        : wasm(wasm), parent(parent) {}

      void visitExpression(Expression* curr) {
        if (parent.oneIn(10)) {
          // Replace it!
          // (This is not always valid due to nesting of labels, but
          // we'll fix that up later.)
          replaceCurrent(parent.make(curr->type));
        }
      }
    };
    Modder modder(wasm, *this);
    modder.walk(func->body);
  }

  // Fix up changes that may have broken validation - types are correct in our
  // modding, but not necessarily labels.
  void fixLabels(Function* func) {
    struct Fixer : public ControlFlowWalker<Fixer> {
      Module& wasm;
      TranslateToFuzzReader& parent;

      Fixer(Module& wasm, TranslateToFuzzReader& parent)
        : wasm(wasm), parent(parent) {}

      // Track seen names to find duplication, which is invalid.
      std::set<Name> seen;

      void visitBlock(Block* curr) {
        if (curr->name.is()) {
          if (seen.count(curr->name)) {
            replace();
          } else {
            seen.insert(curr->name);
          }
        }
      }

      void visitLoop(Loop* curr) {
        if (curr->name.is()) {
          if (seen.count(curr->name)) {
            replace();
          } else {
            seen.insert(curr->name);
          }
        }
      }

      void visitSwitch(Switch* curr) {
        for (auto name : curr->targets) {
          if (replaceIfInvalid(name)) {
            return;
          }
        }
        replaceIfInvalid(curr->default_);
      }

      void visitBreak(Break* curr) { replaceIfInvalid(curr->name); }

      bool replaceIfInvalid(Name target) {
        if (!hasBreakTarget(target)) {
          // There is no valid parent, replace with something trivially safe.
          replace();
          return true;
        }
        return false;
      }

      void replace() { replaceCurrent(parent.makeTrivial(getCurrent()->type)); }

      bool hasBreakTarget(Name name) {
        if (controlFlowStack.empty()) {
          return false;
        }
        Index i = controlFlowStack.size() - 1;
        while (1) {
          auto* curr = controlFlowStack[i];
          if (Block* block = curr->template dynCast<Block>()) {
            if (name == block->name) {
              return true;
            }
          } else if (Loop* loop = curr->template dynCast<Loop>()) {
            if (name == loop->name) {
              return true;
            }
          } else {
            // an if, ignorable
            assert(curr->template is<If>());
          }
          if (i == 0) {
            return false;
          }
          i--;
        }
      }
    };
    Fixer fixer(wasm, *this);
    fixer.walk(func->body);
    ReFinalize().walkFunctionInModule(func, &wasm);
  }

  // the fuzzer external interface sends in zeros (simpler to compare
  // across invocations from JS or wasm-opt etc.). Add invocations in
  // the wasm, so they run everywhere
  void addInvocations(Function* func) {
    std::vector<Expression*> invocations;
    while (oneIn(2) && !finishedInput) {
      std::vector<Expression*> args;
      for (auto type : func->sig.params.expand()) {
        args.push_back(makeConst(type));
      }
      Expression* invoke =
        builder.makeCall(func->name, args, func->sig.results);
      if (func->sig.results.isConcrete()) {
        invoke = builder.makeDrop(invoke);
      }
      invocations.push_back(invoke);
      // log out memory in some cases
      if (oneIn(2)) {
        invocations.push_back(makeMemoryHashLogging());
      }
    }
    if (invocations.empty()) {
      return;
    }
    auto* invoker = new Function;
    invoker->name = func->name.str + std::string("_invoker");
    invoker->sig = Signature(Type::none, Type::none);
    invoker->body = builder.makeBlock(invocations);
    wasm.addFunction(invoker);
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

  Expression* make(Type type) {
    // when we should stop, emit something small (but not necessarily trivial)
    if (finishedInput || nesting >= 5 * NESTING_LIMIT || // hard limit
        (nesting >= NESTING_LIMIT && !oneIn(3))) {
      if (type.isConcrete()) {
        if (oneIn(2)) {
          return makeConst(type);
        } else {
          return makeLocalGet(type);
        }
      } else if (type == none) {
        if (oneIn(2)) {
          return makeNop(type);
        } else {
          return makeLocalSet(type);
        }
      }
      assert(type == unreachable);
      return makeTrivial(type);
    }
    nesting++;
    Expression* ret = nullptr;
    switch (type) {
      case i32:
      case i64:
      case f32:
      case f64:
      case v128:
      case anyref:
      case exnref:
        ret = _makeConcrete(type);
        break;
      case none:
        ret = _makenone();
        break;
      case unreachable:
        ret = _makeunreachable();
        break;
    }
    assert(ret->type == type); // we should create the right type of thing
    nesting--;
    return ret;
  }

  Expression* _makeConcrete(Type type) {
    auto choice = upTo(100);
    if (choice < 10) {
      return makeConst(type);
    }
    if (choice < 30) {
      return makeLocalSet(type);
    }
    if (choice < 50) {
      return makeLocalGet(type);
    }
    if (choice < 60) {
      return makeBlock(type);
    }
    if (choice < 70) {
      return makeIf(type);
    }
    if (choice < 80) {
      return makeLoop(type);
    }
    if (choice < 90) {
      return makeBreak(type);
    }
    using Self = TranslateToFuzzReader;
    auto options = FeatureOptions<Expression* (Self::*)(Type)>()
                     .add(FeatureSet::MVP,
                          &Self::makeBlock,
                          &Self::makeIf,
                          &Self::makeLoop,
                          &Self::makeBreak,
                          &Self::makeCall,
                          &Self::makeCallIndirect,
                          &Self::makeLocalGet,
                          &Self::makeLocalSet,
                          &Self::makeLoad,
                          &Self::makeConst,
                          &Self::makeUnary,
                          &Self::makeBinary,
                          &Self::makeSelect,
                          &Self::makeGlobalGet)
                     .add(FeatureSet::SIMD, &Self::makeSIMD);
    if (type == i32 || type == i64) {
      options.add(FeatureSet::Atomics, &Self::makeAtomic);
    }
    return (this->*pick(options))(type);
  }

  Expression* _makenone() {
    auto choice = upTo(100);
    if (choice < LOGGING_PERCENT) {
      if (choice < LOGGING_PERCENT / 2) {
        return makeLogging();
      } else {
        return makeMemoryHashLogging();
      }
    }
    choice = upTo(100);
    if (choice < 50) {
      return makeLocalSet(none);
    }
    if (choice < 60) {
      return makeBlock(none);
    }
    if (choice < 70) {
      return makeIf(none);
    }
    if (choice < 80) {
      return makeLoop(none);
    }
    if (choice < 90) {
      return makeBreak(none);
    }
    using Self = TranslateToFuzzReader;
    auto options = FeatureOptions<Expression* (Self::*)(Type)>()
                     .add(FeatureSet::MVP,
                          &Self::makeBlock,
                          &Self::makeIf,
                          &Self::makeLoop,
                          &Self::makeBreak,
                          &Self::makeCall,
                          &Self::makeCallIndirect,
                          &Self::makeLocalSet,
                          &Self::makeStore,
                          &Self::makeDrop,
                          &Self::makeNop,
                          &Self::makeGlobalSet)
                     .add(FeatureSet::BulkMemory, &Self::makeBulkMemory)
                     .add(FeatureSet::Atomics, &Self::makeAtomic);
    return (this->*pick(options))(none);
  }

  Expression* _makeunreachable() {
    switch (upTo(15)) {
      case 0:
        return makeBlock(unreachable);
      case 1:
        return makeIf(unreachable);
      case 2:
        return makeLoop(unreachable);
      case 3:
        return makeBreak(unreachable);
      case 4:
        return makeCall(unreachable);
      case 5:
        return makeCallIndirect(unreachable);
      case 6:
        return makeLocalSet(unreachable);
      case 7:
        return makeStore(unreachable);
      case 8:
        return makeUnary(unreachable);
      case 9:
        return makeBinary(unreachable);
      case 10:
        return makeSelect(unreachable);
      case 11:
        return makeSwitch(unreachable);
      case 12:
        return makeDrop(unreachable);
      case 13:
        return makeReturn(unreachable);
      case 14:
        return makeUnreachable(unreachable);
    }
    WASM_UNREACHABLE("unexpected value");
  }

  // make something with no chance of infinite recursion
  Expression* makeTrivial(Type type) {
    if (type.isConcrete()) {
      if (oneIn(2)) {
        return makeLocalGet(type);
      } else {
        return makeConst(type);
      }
    } else if (type == none) {
      return makeNop(type);
    }
    assert(type == unreachable);
    Expression* ret = nullptr;
    if (func->sig.results.isConcrete()) {
      ret = makeTrivial(func->sig.results);
    }
    return builder.makeReturn(ret);
  }

  // specific expression creators

  Expression* makeBlock(Type type) {
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
    if (!finishedInput && type.isConcrete() && oneIn(2)) {
      ret->list.push_back(makeBreak(unreachable));
    } else {
      ret->list.push_back(make(type));
    }
    breakableStack.pop_back();
    if (type.isConcrete()) {
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

  Expression* makeLoop(Type type) {
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
      // possible branch back
      list.push_back(builder.makeBreak(ret->name, nullptr, makeCondition()));
      list.push_back(make(type)); // final element, so we have the right type
      ret->body = builder.makeBlock(list);
    }
    breakableStack.pop_back();
    hangStack.pop_back();
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
  Expression* makeMaybeBlock(Type type) {
    // if past the limit, prefer not to emit blocks
    if (nesting >= NESTING_LIMIT || oneIn(3)) {
      return make(type);
    } else {
      return makeBlock(type);
    }
  }

  Expression* buildIf(const struct ThreeArgs& args) {
    return builder.makeIf(args.a, args.b, args.c);
  }

  Expression* makeIf(Type type) {
    auto* condition = makeCondition();
    hangStack.push_back(nullptr);
    auto* ret =
      buildIf({condition, makeMaybeBlock(type), makeMaybeBlock(type)});
    hangStack.pop_back();
    return ret;
  }

  Expression* makeBreak(Type type) {
    if (breakableStack.empty()) {
      return makeTrivial(type);
    }
    Expression* condition = nullptr;
    if (type != unreachable) {
      hangStack.push_back(nullptr);
      condition = makeCondition();
    }
    // we need to find a proper target to break to; try a few times
    int tries = TRIES;
    while (tries-- > 0) {
      auto* target = pick(breakableStack);
      auto name = getTargetName(target);
      auto valueType = getTargetType(target);
      if (type.isConcrete()) {
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
            if (!oneIn(4)) {
              continue;
            }
            break;
          }
          case 1: {
            if (!oneIn(2)) {
              continue;
            }
            break;
          }
          default: {
            if (oneIn(conditions + 1)) {
              continue;
            }
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

  Expression* makeCall(Type type) {
    // seems ok, go on
    int tries = TRIES;
    bool isReturn;
    while (tries-- > 0) {
      Function* target = func;
      if (!wasm.functions.empty() && !oneIn(wasm.functions.size())) {
        target = pick(wasm.functions).get();
      }
      isReturn = type == Type::unreachable && wasm.features.hasTailCall() &&
                 func->sig.results == target->sig.results;
      if (target->sig.results != type && !isReturn) {
        continue;
      }
      // we found one!
      std::vector<Expression*> args;
      for (auto argType : target->sig.params.expand()) {
        args.push_back(make(argType));
      }
      return builder.makeCall(target->name, args, type, isReturn);
    }
    // we failed to find something
    return make(type);
  }

  Expression* makeCallIndirect(Type type) {
    auto& data = wasm.table.segments[0].data;
    if (data.empty()) {
      return make(type);
    }
    // look for a call target with the right type
    Index start = upTo(data.size());
    Index i = start;
    Function* targetFn;
    bool isReturn;
    while (1) {
      // TODO: handle unreachable
      targetFn = wasm.getFunction(data[i]);
      isReturn = type == unreachable && wasm.features.hasTailCall() &&
                 func->sig.results == targetFn->sig.results;
      if (targetFn->sig.results == type || isReturn) {
        break;
      }
      i++;
      if (i == data.size()) {
        i = 0;
      }
      if (i == start) {
        return make(type);
      }
    }
    // with high probability, make sure the type is valid  otherwise, most are
    // going to trap
    Expression* target;
    if (!allowOOB || !oneIn(10)) {
      target = builder.makeConst(Literal(int32_t(i)));
    } else {
      target = make(i32);
    }
    std::vector<Expression*> args;
    for (auto type : targetFn->sig.params.expand()) {
      args.push_back(make(type));
    }
    return builder.makeCallIndirect(target, args, targetFn->sig, isReturn);
  }

  Expression* makeLocalGet(Type type) {
    auto& locals = typeLocals[type];
    if (locals.empty()) {
      return makeConst(type);
    }
    return builder.makeLocalGet(pick(locals), type);
  }

  Expression* makeLocalSet(Type type) {
    bool tee = type != none;
    Type valueType;
    if (tee) {
      valueType = type;
    } else {
      valueType = getConcreteType();
    }
    auto& locals = typeLocals[valueType];
    if (locals.empty()) {
      return makeTrivial(type);
    }
    auto* value = make(valueType);
    if (tee) {
      return builder.makeLocalTee(pick(locals), value, valueType);
    } else {
      return builder.makeLocalSet(pick(locals), value);
    }
  }

  Expression* makeGlobalGet(Type type) {
    auto& globals = globalsByType[type];
    if (globals.empty()) {
      return makeConst(type);
    }
    return builder.makeGlobalGet(pick(globals), type);
  }

  Expression* makeGlobalSet(Type type) {
    assert(type == none);
    type = getConcreteType();
    auto& globals = globalsByType[type];
    if (globals.empty()) {
      return makeTrivial(none);
    }
    auto* value = make(type);
    return builder.makeGlobalSet(pick(globals), value);
  }

  Expression* makePointer() {
    auto* ret = make(i32);
    // with high probability, mask the pointer so it's in a reasonable
    // range. otherwise, most pointers are going to be out of range and
    // most memory ops will just trap
    if (!allowOOB || !oneIn(10)) {
      ret = builder.makeBinary(
        AndInt32, ret, builder.makeConst(Literal(int32_t(USABLE_MEMORY - 1))));
    }
    return ret;
  }

  Expression* makeNonAtomicLoad(Type type) {
    auto offset = logify(get());
    auto ptr = makePointer();
    switch (type) {
      case i32: {
        bool signed_ = get() & 1;
        switch (upTo(3)) {
          case 0:
            return builder.makeLoad(1, signed_, offset, 1, ptr, type);
          case 1:
            return builder.makeLoad(2, signed_, offset, pick(1, 2), ptr, type);
          case 2:
            return builder.makeLoad(
              4, signed_, offset, pick(1, 2, 4), ptr, type);
        }
        WASM_UNREACHABLE("unexpected value");
      }
      case i64: {
        bool signed_ = get() & 1;
        switch (upTo(4)) {
          case 0:
            return builder.makeLoad(1, signed_, offset, 1, ptr, type);
          case 1:
            return builder.makeLoad(2, signed_, offset, pick(1, 2), ptr, type);
          case 2:
            return builder.makeLoad(
              4, signed_, offset, pick(1, 2, 4), ptr, type);
          case 3:
            return builder.makeLoad(
              8, signed_, offset, pick(1, 2, 4, 8), ptr, type);
        }
        WASM_UNREACHABLE("unexpected value");
      }
      case f32: {
        return builder.makeLoad(4, false, offset, pick(1, 2, 4), ptr, type);
      }
      case f64: {
        return builder.makeLoad(8, false, offset, pick(1, 2, 4, 8), ptr, type);
      }
      case v128: {
        if (!wasm.features.hasSIMD()) {
          return makeTrivial(type);
        }
        return builder.makeLoad(
          16, false, offset, pick(1, 2, 4, 8, 16), ptr, type);
      }
      case anyref: // anyref cannot be loaded from memory
      case exnref: // exnref cannot be loaded from memory
      case none:
      case unreachable:
        WASM_UNREACHABLE("invalid type");
    }
    WASM_UNREACHABLE("invalid type");
  }

  Expression* makeLoad(Type type) {
    // exnref type cannot be stored in memory
    if (!allowMemory || type == exnref) {
      return makeTrivial(type);
    }
    auto* ret = makeNonAtomicLoad(type);
    if (type != i32 && type != i64) {
      return ret;
    }
    if (!wasm.features.hasAtomics() || oneIn(2)) {
      return ret;
    }
    // make it atomic
    auto* load = ret->cast<Load>();
    wasm.memory.shared = true;
    load->isAtomic = true;
    load->signed_ = false;
    load->align = load->bytes;
    return load;
  }

  Expression* makeNonAtomicStore(Type type) {
    if (type == unreachable) {
      // make a normal store, then make it unreachable
      auto* ret = makeNonAtomicStore(getConcreteType());
      auto* store = ret->dynCast<Store>();
      if (!store) {
        return ret;
      }
      switch (upTo(3)) {
        case 0:
          store->ptr = make(unreachable);
          break;
        case 1:
          store->value = make(unreachable);
          break;
        case 2:
          store->ptr = make(unreachable);
          store->value = make(unreachable);
          break;
      }
      store->finalize();
      return store;
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
          case 0:
            return builder.makeStore(1, offset, 1, ptr, value, type);
          case 1:
            return builder.makeStore(2, offset, pick(1, 2), ptr, value, type);
          case 2:
            return builder.makeStore(
              4, offset, pick(1, 2, 4), ptr, value, type);
        }
        WASM_UNREACHABLE("invalid value");
      }
      case i64: {
        switch (upTo(4)) {
          case 0:
            return builder.makeStore(1, offset, 1, ptr, value, type);
          case 1:
            return builder.makeStore(2, offset, pick(1, 2), ptr, value, type);
          case 2:
            return builder.makeStore(
              4, offset, pick(1, 2, 4), ptr, value, type);
          case 3:
            return builder.makeStore(
              8, offset, pick(1, 2, 4, 8), ptr, value, type);
        }
        WASM_UNREACHABLE("invalid value");
      }
      case f32: {
        return builder.makeStore(4, offset, pick(1, 2, 4), ptr, value, type);
      }
      case f64: {
        return builder.makeStore(8, offset, pick(1, 2, 4, 8), ptr, value, type);
      }
      case v128: {
        if (!wasm.features.hasSIMD()) {
          return makeTrivial(type);
        }
        return builder.makeStore(
          16, offset, pick(1, 2, 4, 8, 16), ptr, value, type);
      }
      case anyref: // anyref cannot be stored in memory
      case exnref: // exnref cannot be stored in memory
      case none:
      case unreachable:
        WASM_UNREACHABLE("invalid type");
    }
    WASM_UNREACHABLE("invalid type");
  }

  Expression* makeStore(Type type) {
    // exnref type cannot be stored in memory
    if (!allowMemory || type.isRef()) {
      return makeTrivial(type);
    }
    auto* ret = makeNonAtomicStore(type);
    auto* store = ret->dynCast<Store>();
    if (!store) {
      return ret;
    }
    if (store->value->type != i32 && store->value->type != i64) {
      return store;
    }
    if (!wasm.features.hasAtomics() || oneIn(2)) {
      return store;
    }
    // make it atomic
    wasm.memory.shared = true;
    store->isAtomic = true;
    store->align = store->bytes;
    return store;
  }

  Literal makeArbitraryLiteral(Type type) {
    if (type == v128) {
      // generate each lane individually for random lane interpretation
      switch (upTo(6)) {
        case 0:
          return Literal(std::array<Literal, 16>{{makeLiteral(i32),
                                                  makeLiteral(i32),
                                                  makeLiteral(i32),
                                                  makeLiteral(i32),
                                                  makeLiteral(i32),
                                                  makeLiteral(i32),
                                                  makeLiteral(i32),
                                                  makeLiteral(i32),
                                                  makeLiteral(i32),
                                                  makeLiteral(i32),
                                                  makeLiteral(i32),
                                                  makeLiteral(i32),
                                                  makeLiteral(i32),
                                                  makeLiteral(i32),
                                                  makeLiteral(i32),
                                                  makeLiteral(i32)}});
        case 1:
          return Literal(std::array<Literal, 8>{{makeLiteral(i32),
                                                 makeLiteral(i32),
                                                 makeLiteral(i32),
                                                 makeLiteral(i32),
                                                 makeLiteral(i32),
                                                 makeLiteral(i32),
                                                 makeLiteral(i32),
                                                 makeLiteral(i32)}});
        case 2:
          return Literal(std::array<Literal, 4>{{makeLiteral(i32),
                                                 makeLiteral(i32),
                                                 makeLiteral(i32),
                                                 makeLiteral(i32)}});
        case 3:
          return Literal(
            std::array<Literal, 2>{{makeLiteral(i64), makeLiteral(i64)}});
        case 4:
          return Literal(std::array<Literal, 4>{{makeLiteral(f32),
                                                 makeLiteral(f32),
                                                 makeLiteral(f32),
                                                 makeLiteral(f32)}});
        case 5:
          return Literal(
            std::array<Literal, 2>{{makeLiteral(f64), makeLiteral(f64)}});
        default:
          WASM_UNREACHABLE("unexpected value");
      }
    }

    switch (upTo(4)) {
      case 0: {
        // totally random, entire range
        switch (type) {
          case i32:
            return Literal(get32());
          case i64:
            return Literal(get64());
          case f32:
            return Literal(getFloat());
          case f64:
            return Literal(getDouble());
          case v128:
          case anyref: // anyref cannot have literals
          case exnref: // exnref cannot have literals
          case none:
          case unreachable:
            WASM_UNREACHABLE("invalid type");
        }
        break;
      }
      case 1: {
        // small range
        int64_t small;
        switch (upTo(6)) {
          case 0:
            small = int8_t(get());
            break;
          case 1:
            small = uint8_t(get());
            break;
          case 2:
            small = int16_t(get16());
            break;
          case 3:
            small = uint16_t(get16());
            break;
          case 4:
            small = int32_t(get32());
            break;
          case 5:
            small = uint32_t(get32());
            break;
          default:
            WASM_UNREACHABLE("invalid value");
        }
        switch (type) {
          case i32:
            return Literal(int32_t(small));
          case i64:
            return Literal(int64_t(small));
          case f32:
            return Literal(float(small));
          case f64:
            return Literal(double(small));
          case v128:
          case anyref: // anyref cannot have literals
          case exnref: // exnref cannot have literals
          case none:
          case unreachable:
            WASM_UNREACHABLE("unexpected type");
        }
        break;
      }
      case 2: {
        // special values
        Literal value;
        switch (type) {
          case i32:
            value =
              Literal(pick<int32_t>(0,
                                    std::numeric_limits<int8_t>::min(),
                                    std::numeric_limits<int8_t>::max(),
                                    std::numeric_limits<int16_t>::min(),
                                    std::numeric_limits<int16_t>::max(),
                                    std::numeric_limits<int32_t>::min(),
                                    std::numeric_limits<int32_t>::max(),
                                    std::numeric_limits<uint8_t>::max(),
                                    std::numeric_limits<uint16_t>::max(),
                                    std::numeric_limits<uint32_t>::max()));
            break;
          case i64:
            value =
              Literal(pick<int64_t>(0,
                                    std::numeric_limits<int8_t>::min(),
                                    std::numeric_limits<int8_t>::max(),
                                    std::numeric_limits<int16_t>::min(),
                                    std::numeric_limits<int16_t>::max(),
                                    std::numeric_limits<int32_t>::min(),
                                    std::numeric_limits<int32_t>::max(),
                                    std::numeric_limits<int64_t>::min(),
                                    std::numeric_limits<int64_t>::max(),
                                    std::numeric_limits<uint8_t>::max(),
                                    std::numeric_limits<uint16_t>::max(),
                                    std::numeric_limits<uint32_t>::max(),
                                    std::numeric_limits<uint64_t>::max()));
            break;
          case f32:
            value = Literal(pick<float>(0,
                                        std::numeric_limits<float>::min(),
                                        std::numeric_limits<float>::max(),
                                        std::numeric_limits<int32_t>::min(),
                                        std::numeric_limits<int32_t>::max(),
                                        std::numeric_limits<int64_t>::min(),
                                        std::numeric_limits<int64_t>::max(),
                                        std::numeric_limits<uint32_t>::max(),
                                        std::numeric_limits<uint64_t>::max()));
            break;
          case f64:
            value = Literal(pick<double>(0,
                                         std::numeric_limits<float>::min(),
                                         std::numeric_limits<float>::max(),
                                         std::numeric_limits<double>::min(),
                                         std::numeric_limits<double>::max(),
                                         std::numeric_limits<int32_t>::min(),
                                         std::numeric_limits<int32_t>::max(),
                                         std::numeric_limits<int64_t>::min(),
                                         std::numeric_limits<int64_t>::max(),
                                         std::numeric_limits<uint32_t>::max(),
                                         std::numeric_limits<uint64_t>::max()));
            break;
          case v128:
          case anyref: // anyref cannot have literals
          case exnref: // exnref cannot have literals
          case none:
          case unreachable:
            WASM_UNREACHABLE("unexpected type");
        }
        // tweak around special values
        if (oneIn(3)) { // +- 1
          value = value.add(Literal::makeFromInt32(upTo(3) - 1, type));
        }
        if (oneIn(2)) { // flip sign
          value = value.mul(Literal::makeFromInt32(-1, type));
        }
        return value;
      }
      case 3: {
        // powers of 2
        Literal value;
        switch (type) {
          case i32:
            value = Literal(int32_t(1) << upTo(32));
            break;
          case i64:
            value = Literal(int64_t(1) << upTo(64));
            break;
          case f32:
            value = Literal(float(int64_t(1) << upTo(64)));
            break;
          case f64:
            value = Literal(double(int64_t(1) << upTo(64)));
            break;
          case v128:
          case anyref: // anyref cannot have literals
          case exnref: // exnref cannot have literals
          case none:
          case unreachable:
            WASM_UNREACHABLE("unexpected type");
        }
        // maybe negative
        if (oneIn(2)) {
          value = value.mul(Literal::makeFromInt32(-1, type));
        }
        return value;
      }
    }
    WASM_UNREACHABLE("invalide value");
  }

  Literal makeLiteral(Type type) {
    auto ret = makeArbitraryLiteral(type);
    if (!allowNaNs && ret.isNaN()) {
      ret = Literal::makeFromInt32(0, type);
    }
    return ret;
  }

  Expression* makeConst(Type type) {
    switch (type) {
      case anyref:
        // There's no anyref.const.
        // TODO We should return a nullref once we implement instructions for
        // reference types proposal.
        assert(false && "anyref const is not implemented yet");
      case exnref:
        // There's no exnref.const.
        // TODO We should return a nullref once we implement instructions for
        // reference types proposal.
        assert(false && "exnref const is not implemented yet");
      default:
        break;
    }

    auto* ret = wasm.allocator.alloc<Const>();
    ret->value = makeLiteral(type);
    ret->type = type;
    return ret;
  }

  Expression* buildUnary(const UnaryArgs& args) {
    return builder.makeUnary(args.a, args.b);
  }

  Expression* makeUnary(Type type) {
    if (type == unreachable) {
      if (auto* unary = makeUnary(getConcreteType())->dynCast<Unary>()) {
        return makeDeNanOp(builder.makeUnary(unary->op, make(unreachable)));
      }
      // give up
      return makeTrivial(type);
    }
    // There's no binary ops for exnref
    if (type == exnref) {
      makeTrivial(type);
    }

    switch (type) {
      case i32: {
        switch (getConcreteType()) {
          case i32: {
            auto op = pick(
              FeatureOptions<UnaryOp>()
                .add(FeatureSet::MVP, EqZInt32, ClzInt32, CtzInt32, PopcntInt32)
                .add(FeatureSet::SignExt, ExtendS8Int32, ExtendS16Int32));
            return buildUnary({op, make(i32)});
          }
          case i64:
            return buildUnary({pick(EqZInt64, WrapInt64), make(i64)});
          case f32: {
            auto op = pick(FeatureOptions<UnaryOp>()
                             .add(FeatureSet::MVP,
                                  TruncSFloat32ToInt32,
                                  TruncUFloat32ToInt32,
                                  ReinterpretFloat32)
                             .add(FeatureSet::TruncSat,
                                  TruncSatSFloat32ToInt32,
                                  TruncSatUFloat32ToInt32));
            return buildUnary({op, make(f32)});
          }
          case f64: {
            auto op = pick(FeatureOptions<UnaryOp>()
                             .add(FeatureSet::MVP,
                                  TruncSFloat64ToInt32,
                                  TruncUFloat64ToInt32)
                             .add(FeatureSet::TruncSat,
                                  TruncSatSFloat64ToInt32,
                                  TruncSatUFloat64ToInt32));
            return buildUnary({op, make(f64)});
          }
          case v128: {
            assert(wasm.features.hasSIMD());
            return buildUnary({pick(AnyTrueVecI8x16,
                                    AllTrueVecI8x16,
                                    AnyTrueVecI16x8,
                                    AllTrueVecI16x8,
                                    AnyTrueVecI32x4,
                                    AllTrueVecI32x4,
                                    AnyTrueVecI64x2,
                                    AllTrueVecI64x2),
                               make(v128)});
          }
          case anyref: // there's no unary ops for anyref
          case exnref: // there's no unary ops for exnref
          case none:
          case unreachable:
            WASM_UNREACHABLE("unexpected type");
        }
        WASM_UNREACHABLE("invalid type");
      }
      case i64: {
        switch (upTo(4)) {
          case 0: {
            auto op =
              pick(FeatureOptions<UnaryOp>()
                     .add(FeatureSet::MVP, ClzInt64, CtzInt64, PopcntInt64)
                     .add(FeatureSet::SignExt,
                          ExtendS8Int64,
                          ExtendS16Int64,
                          ExtendS32Int64));
            return buildUnary({op, make(i64)});
          }
          case 1:
            return buildUnary({pick(ExtendSInt32, ExtendUInt32), make(i32)});
          case 2: {
            auto op = pick(FeatureOptions<UnaryOp>()
                             .add(FeatureSet::MVP,
                                  TruncSFloat32ToInt64,
                                  TruncUFloat32ToInt64)
                             .add(FeatureSet::TruncSat,
                                  TruncSatSFloat32ToInt64,
                                  TruncSatUFloat32ToInt64));
            return buildUnary({op, make(f32)});
          }
          case 3: {
            auto op = pick(FeatureOptions<UnaryOp>()
                             .add(FeatureSet::MVP,
                                  TruncSFloat64ToInt64,
                                  TruncUFloat64ToInt64,
                                  ReinterpretFloat64)
                             .add(FeatureSet::TruncSat,
                                  TruncSatSFloat64ToInt64,
                                  TruncSatUFloat64ToInt64));
            return buildUnary({op, make(f64)});
          }
        }
        WASM_UNREACHABLE("invalid value");
      }
      case f32: {
        switch (upTo(4)) {
          case 0:
            return makeDeNanOp(buildUnary({pick(NegFloat32,
                                                AbsFloat32,
                                                CeilFloat32,
                                                FloorFloat32,
                                                TruncFloat32,
                                                NearestFloat32,
                                                SqrtFloat32),
                                           make(f32)}));
          case 1:
            return makeDeNanOp(buildUnary({pick(ConvertUInt32ToFloat32,
                                                ConvertSInt32ToFloat32,
                                                ReinterpretInt32),
                                           make(i32)}));
          case 2:
            return makeDeNanOp(
              buildUnary({pick(ConvertUInt64ToFloat32, ConvertSInt64ToFloat32),
                          make(i64)}));
          case 3:
            return makeDeNanOp(buildUnary({DemoteFloat64, make(f64)}));
        }
        WASM_UNREACHABLE("invalid value");
      }
      case f64: {
        switch (upTo(4)) {
          case 0:
            return makeDeNanOp(buildUnary({pick(NegFloat64,
                                                AbsFloat64,
                                                CeilFloat64,
                                                FloorFloat64,
                                                TruncFloat64,
                                                NearestFloat64,
                                                SqrtFloat64),
                                           make(f64)}));
          case 1:
            return makeDeNanOp(
              buildUnary({pick(ConvertUInt32ToFloat64, ConvertSInt32ToFloat64),
                          make(i32)}));
          case 2:
            return makeDeNanOp(buildUnary({pick(ConvertUInt64ToFloat64,
                                                ConvertSInt64ToFloat64,
                                                ReinterpretInt64),
                                           make(i64)}));
          case 3:
            return makeDeNanOp(buildUnary({PromoteFloat32, make(f32)}));
        }
        WASM_UNREACHABLE("invalid value");
      }
      case v128: {
        assert(wasm.features.hasSIMD());
        switch (upTo(5)) {
          case 0:
            return buildUnary(
              {pick(SplatVecI8x16, SplatVecI16x8, SplatVecI32x4), make(i32)});
          case 1:
            return buildUnary({SplatVecI64x2, make(i64)});
          case 2:
            return buildUnary({SplatVecF32x4, make(f32)});
          case 3:
            return buildUnary({SplatVecF64x2, make(f64)});
          case 4:
            return buildUnary({pick(NotVec128,
                                    NegVecI8x16,
                                    NegVecI16x8,
                                    NegVecI32x4,
                                    NegVecI64x2,
                                    AbsVecF32x4,
                                    NegVecF32x4,
                                    SqrtVecF32x4,
                                    AbsVecF64x2,
                                    NegVecF64x2,
                                    SqrtVecF64x2,
                                    TruncSatSVecF32x4ToVecI32x4,
                                    TruncSatUVecF32x4ToVecI32x4,
                                    TruncSatSVecF64x2ToVecI64x2,
                                    TruncSatUVecF64x2ToVecI64x2,
                                    ConvertSVecI32x4ToVecF32x4,
                                    ConvertUVecI32x4ToVecF32x4,
                                    ConvertSVecI64x2ToVecF64x2,
                                    ConvertUVecI64x2ToVecF64x2,
                                    WidenLowSVecI8x16ToVecI16x8,
                                    WidenHighSVecI8x16ToVecI16x8,
                                    WidenLowUVecI8x16ToVecI16x8,
                                    WidenHighUVecI8x16ToVecI16x8,
                                    WidenLowSVecI16x8ToVecI32x4,
                                    WidenHighSVecI16x8ToVecI32x4,
                                    WidenLowUVecI16x8ToVecI32x4,
                                    WidenHighUVecI16x8ToVecI32x4),
                               make(v128)});
        }
        WASM_UNREACHABLE("invalid value");
      }
      case anyref: // there's no unary ops for anyref
      case exnref: // there's no unary ops for exnref
      case none:
      case unreachable:
        WASM_UNREACHABLE("unexpected type");
    }
    WASM_UNREACHABLE("invalid type");
  }

  Expression* buildBinary(const BinaryArgs& args) {
    return builder.makeBinary(args.a, args.b, args.c);
  }

  Expression* makeBinary(Type type) {
    if (type == unreachable) {
      if (auto* binary = makeBinary(getConcreteType())->dynCast<Binary>()) {
        return makeDeNanOp(
          buildBinary({binary->op, make(unreachable), make(unreachable)}));
      }
      // give up
      return makeTrivial(type);
    }
    // There's no binary ops for exnref
    if (type.isRef()) {
      makeTrivial(type);
    }

    switch (type) {
      case i32: {
        switch (upTo(4)) {
          case 0:
            return buildBinary({pick(AddInt32,
                                     SubInt32,
                                     MulInt32,
                                     DivSInt32,
                                     DivUInt32,
                                     RemSInt32,
                                     RemUInt32,
                                     AndInt32,
                                     OrInt32,
                                     XorInt32,
                                     ShlInt32,
                                     ShrUInt32,
                                     ShrSInt32,
                                     RotLInt32,
                                     RotRInt32,
                                     EqInt32,
                                     NeInt32,
                                     LtSInt32,
                                     LtUInt32,
                                     LeSInt32,
                                     LeUInt32,
                                     GtSInt32,
                                     GtUInt32,
                                     GeSInt32,
                                     GeUInt32),
                                make(i32),
                                make(i32)});
          case 1:
            return buildBinary({pick(EqInt64,
                                     NeInt64,
                                     LtSInt64,
                                     LtUInt64,
                                     LeSInt64,
                                     LeUInt64,
                                     GtSInt64,
                                     GtUInt64,
                                     GeSInt64,
                                     GeUInt64),
                                make(i64),
                                make(i64)});
          case 2:
            return buildBinary({pick(EqFloat32,
                                     NeFloat32,
                                     LtFloat32,
                                     LeFloat32,
                                     GtFloat32,
                                     GeFloat32),
                                make(f32),
                                make(f32)});
          case 3:
            return buildBinary({pick(EqFloat64,
                                     NeFloat64,
                                     LtFloat64,
                                     LeFloat64,
                                     GtFloat64,
                                     GeFloat64),
                                make(f64),
                                make(f64)});
        }
        WASM_UNREACHABLE("invalid value");
      }
      case i64: {
        return buildBinary({pick(AddInt64,
                                 SubInt64,
                                 MulInt64,
                                 DivSInt64,
                                 DivUInt64,
                                 RemSInt64,
                                 RemUInt64,
                                 AndInt64,
                                 OrInt64,
                                 XorInt64,
                                 ShlInt64,
                                 ShrUInt64,
                                 ShrSInt64,
                                 RotLInt64,
                                 RotRInt64),
                            make(i64),
                            make(i64)});
      }
      case f32: {
        return makeDeNanOp(buildBinary({pick(AddFloat32,
                                             SubFloat32,
                                             MulFloat32,
                                             DivFloat32,
                                             CopySignFloat32,
                                             MinFloat32,
                                             MaxFloat32),
                                        make(f32),
                                        make(f32)}));
      }
      case f64: {
        return makeDeNanOp(buildBinary({pick(AddFloat64,
                                             SubFloat64,
                                             MulFloat64,
                                             DivFloat64,
                                             CopySignFloat64,
                                             MinFloat64,
                                             MaxFloat64),
                                        make(f64),
                                        make(f64)}));
      }
      case v128: {
        assert(wasm.features.hasSIMD());
        return buildBinary({pick(EqVecI8x16,
                                 NeVecI8x16,
                                 LtSVecI8x16,
                                 LtUVecI8x16,
                                 GtSVecI8x16,
                                 GtUVecI8x16,
                                 LeSVecI8x16,
                                 LeUVecI8x16,
                                 GeSVecI8x16,
                                 GeUVecI8x16,
                                 EqVecI16x8,
                                 NeVecI16x8,
                                 LtSVecI16x8,
                                 LtUVecI16x8,
                                 GtSVecI16x8,
                                 GtUVecI16x8,
                                 LeSVecI16x8,
                                 LeUVecI16x8,
                                 GeSVecI16x8,
                                 GeUVecI16x8,
                                 EqVecI32x4,
                                 NeVecI32x4,
                                 LtSVecI32x4,
                                 LtUVecI32x4,
                                 GtSVecI32x4,
                                 GtUVecI32x4,
                                 LeSVecI32x4,
                                 LeUVecI32x4,
                                 GeSVecI32x4,
                                 GeUVecI32x4,
                                 EqVecF32x4,
                                 NeVecF32x4,
                                 LtVecF32x4,
                                 GtVecF32x4,
                                 LeVecF32x4,
                                 GeVecF32x4,
                                 EqVecF64x2,
                                 NeVecF64x2,
                                 LtVecF64x2,
                                 GtVecF64x2,
                                 LeVecF64x2,
                                 GeVecF64x2,
                                 AndVec128,
                                 OrVec128,
                                 XorVec128,
                                 AndNotVec128,
                                 AddVecI8x16,
                                 AddSatSVecI8x16,
                                 AddSatUVecI8x16,
                                 SubVecI8x16,
                                 SubSatSVecI8x16,
                                 SubSatUVecI8x16,
                                 MulVecI8x16,
                                 MinSVecI8x16,
                                 MinUVecI8x16,
                                 MaxSVecI8x16,
                                 MaxUVecI8x16,
                                 AddVecI16x8,
                                 AddSatSVecI16x8,
                                 AddSatUVecI16x8,
                                 SubVecI16x8,
                                 SubSatSVecI16x8,
                                 SubSatUVecI16x8,
                                 MulVecI16x8,
                                 MinSVecI16x8,
                                 MinUVecI16x8,
                                 MaxSVecI16x8,
                                 MaxUVecI16x8,
                                 AddVecI32x4,
                                 SubVecI32x4,
                                 MulVecI32x4,
                                 MinSVecI32x4,
                                 MinUVecI32x4,
                                 MaxSVecI32x4,
                                 MaxUVecI32x4,
                                 DotSVecI16x8ToVecI32x4,
                                 AddVecI64x2,
                                 SubVecI64x2,
                                 AddVecF32x4,
                                 SubVecF32x4,
                                 MulVecF32x4,
                                 DivVecF32x4,
                                 MinVecF32x4,
                                 MaxVecF32x4,
                                 AddVecF64x2,
                                 SubVecF64x2,
                                 MulVecF64x2,
                                 DivVecF64x2,
                                 MinVecF64x2,
                                 MaxVecF64x2,
                                 NarrowSVecI16x8ToVecI8x16,
                                 NarrowUVecI16x8ToVecI8x16,
                                 NarrowSVecI32x4ToVecI16x8,
                                 NarrowUVecI32x4ToVecI16x8,
                                 SwizzleVec8x16),
                            make(v128),
                            make(v128)});
      }
      case anyref: // there's no binary ops for anyref
      case exnref: // there's no binary ops for exnref
      case none:
      case unreachable:
        WASM_UNREACHABLE("unexpected type");
    }
    WASM_UNREACHABLE("invalid type");
  }

  Expression* buildSelect(const ThreeArgs& args) {
    return builder.makeSelect(args.a, args.b, args.c);
  }

  Expression* makeSelect(Type type) {
    return makeDeNanOp(buildSelect({make(i32), make(type), make(type)}));
  }

  Expression* makeSwitch(Type type) {
    assert(type == unreachable);
    if (breakableStack.empty()) {
      return make(type);
    }
    // we need to find proper targets to break to; try a bunch
    int tries = TRIES;
    std::vector<Name> names;
    Type valueType = unreachable;
    while (tries-- > 0) {
      auto* target = pick(breakableStack);
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
    auto temp1 = make(i32),
         temp2 = valueType.isConcrete() ? make(valueType) : nullptr;
    return builder.makeSwitch(names, default_, temp1, temp2);
  }

  Expression* makeDrop(Type type) {
    return builder.makeDrop(
      make(type == unreachable ? type : getConcreteType()));
  }

  Expression* makeReturn(Type type) {
    return builder.makeReturn(
      func->sig.results.isConcrete() ? make(func->sig.results) : nullptr);
  }

  Expression* makeNop(Type type) {
    assert(type == none);
    return builder.makeNop();
  }

  Expression* makeUnreachable(Type type) {
    assert(type == unreachable);
    return builder.makeUnreachable();
  }

  Expression* makeAtomic(Type type) {
    assert(wasm.features.hasAtomics());
    if (!allowMemory) {
      return makeTrivial(type);
    }
    wasm.memory.shared = true;
    if (type == none) {
      return builder.makeAtomicFence();
    }
    if (type == i32 && oneIn(2)) {
      if (ATOMIC_WAITS && oneIn(2)) {
        auto* ptr = makePointer();
        auto expectedType = pick(i32, i64);
        auto* expected = make(expectedType);
        auto* timeout = make(i64);
        return builder.makeAtomicWait(
          ptr, expected, timeout, expectedType, logify(get()));
      } else {
        auto* ptr = makePointer();
        auto* count = make(i32);
        return builder.makeAtomicNotify(ptr, count, logify(get()));
      }
    }
    Index bytes;
    switch (type) {
      case i32: {
        switch (upTo(3)) {
          case 0:
            bytes = 1;
            break;
          case 1:
            bytes = pick(1, 2);
            break;
          case 2:
            bytes = pick(1, 2, 4);
            break;
          default:
            WASM_UNREACHABLE("invalide value");
        }
        break;
      }
      case i64: {
        switch (upTo(4)) {
          case 0:
            bytes = 1;
            break;
          case 1:
            bytes = pick(1, 2);
            break;
          case 2:
            bytes = pick(1, 2, 4);
            break;
          case 3:
            bytes = pick(1, 2, 4, 8);
            break;
          default:
            WASM_UNREACHABLE("invalide value");
        }
        break;
      }
      default:
        WASM_UNREACHABLE("unexpected type");
    }
    auto offset = logify(get());
    auto* ptr = makePointer();
    if (oneIn(2)) {
      auto* value = make(type);
      return builder.makeAtomicRMW(pick(AtomicRMWOp::Add,
                                        AtomicRMWOp::Sub,
                                        AtomicRMWOp::And,
                                        AtomicRMWOp::Or,
                                        AtomicRMWOp::Xor,
                                        AtomicRMWOp::Xchg),
                                   bytes,
                                   offset,
                                   ptr,
                                   value,
                                   type);
    } else {
      auto* expected = make(type);
      auto* replacement = make(type);
      return builder.makeAtomicCmpxchg(
        bytes, offset, ptr, expected, replacement, type);
    }
  }

  Expression* makeSIMD(Type type) {
    assert(wasm.features.hasSIMD());
    if (type != v128) {
      return makeSIMDExtract(type);
    }
    switch (upTo(7)) {
      case 0:
        return makeUnary(v128);
      case 1:
        return makeBinary(v128);
      case 2:
        return makeSIMDReplace();
      case 3:
        return makeSIMDShuffle();
      case 4:
        return makeSIMDTernary();
      case 5:
        return makeSIMDShift();
      case 6:
        return makeSIMDLoad();
    }
    WASM_UNREACHABLE("invalid value");
  }

  Expression* makeSIMDExtract(Type type) {
    auto op = static_cast<SIMDExtractOp>(0);
    switch (type) {
      case i32:
        op = pick(ExtractLaneSVecI8x16,
                  ExtractLaneUVecI8x16,
                  ExtractLaneSVecI16x8,
                  ExtractLaneUVecI16x8,
                  ExtractLaneVecI32x4);
        break;
      case i64:
        op = ExtractLaneVecI64x2;
        break;
      case f32:
        op = ExtractLaneVecF32x4;
        break;
      case f64:
        op = ExtractLaneVecF64x2;
        break;
      case v128:
      case anyref:
      case exnref:
      case none:
      case unreachable:
        WASM_UNREACHABLE("unexpected type");
    }
    Expression* vec = make(v128);
    uint8_t index = 0;
    switch (op) {
      case ExtractLaneSVecI8x16:
      case ExtractLaneUVecI8x16:
        index = upTo(16);
        break;
      case ExtractLaneSVecI16x8:
      case ExtractLaneUVecI16x8:
        index = upTo(8);
        break;
      case ExtractLaneVecI32x4:
      case ExtractLaneVecF32x4:
        index = upTo(4);
        break;
      case ExtractLaneVecI64x2:
      case ExtractLaneVecF64x2:
        index = upTo(2);
        break;
    }
    return builder.makeSIMDExtract(op, vec, index);
  }

  Expression* makeSIMDReplace() {
    SIMDReplaceOp op = pick(ReplaceLaneVecI8x16,
                            ReplaceLaneVecI16x8,
                            ReplaceLaneVecI32x4,
                            ReplaceLaneVecI64x2,
                            ReplaceLaneVecF32x4,
                            ReplaceLaneVecF64x2);
    Expression* vec = make(v128);
    uint8_t index;
    Type lane_t;
    switch (op) {
      case ReplaceLaneVecI8x16:
        index = upTo(16);
        lane_t = i32;
        break;
      case ReplaceLaneVecI16x8:
        index = upTo(8);
        lane_t = i32;
        break;
      case ReplaceLaneVecI32x4:
        index = upTo(4);
        lane_t = i32;
        break;
      case ReplaceLaneVecI64x2:
        index = upTo(2);
        lane_t = i64;
        break;
      case ReplaceLaneVecF32x4:
        index = upTo(4);
        lane_t = f32;
        break;
      case ReplaceLaneVecF64x2:
        index = upTo(2);
        lane_t = f64;
        break;
      default:
        WASM_UNREACHABLE("unexpected op");
    }
    Expression* value = make(lane_t);
    return builder.makeSIMDReplace(op, vec, index, value);
  }

  Expression* makeSIMDShuffle() {
    Expression* left = make(v128);
    Expression* right = make(v128);
    std::array<uint8_t, 16> mask;
    for (size_t i = 0; i < 16; ++i) {
      mask[i] = upTo(32);
    }
    return builder.makeSIMDShuffle(left, right, mask);
  }

  Expression* makeSIMDTernary() {
    // TODO: Enable qfma/qfms once it is implemented in V8 and the interpreter
    // SIMDTernaryOp op = pick(Bitselect,
    //                         QFMAF32x4,
    //                         QFMSF32x4,
    //                         QFMAF64x2,
    //                         QFMSF64x2);
    SIMDTernaryOp op = Bitselect;
    Expression* a = make(v128);
    Expression* b = make(v128);
    Expression* c = make(v128);
    return builder.makeSIMDTernary(op, a, b, c);
  }

  Expression* makeSIMDShift() {
    SIMDShiftOp op = pick(ShlVecI8x16,
                          ShrSVecI8x16,
                          ShrUVecI8x16,
                          ShlVecI16x8,
                          ShrSVecI16x8,
                          ShrUVecI16x8,
                          ShlVecI32x4,
                          ShrSVecI32x4,
                          ShrUVecI32x4,
                          ShlVecI64x2,
                          ShrSVecI64x2,
                          ShrUVecI64x2);
    Expression* vec = make(v128);
    Expression* shift = make(i32);
    return builder.makeSIMDShift(op, vec, shift);
  }

  Expression* makeSIMDLoad() {
    SIMDLoadOp op = pick(LoadSplatVec8x16,
                         LoadSplatVec16x8,
                         LoadSplatVec32x4,
                         LoadSplatVec64x2,
                         LoadExtSVec8x8ToVecI16x8,
                         LoadExtUVec8x8ToVecI16x8,
                         LoadExtSVec16x4ToVecI32x4,
                         LoadExtUVec16x4ToVecI32x4,
                         LoadExtSVec32x2ToVecI64x2,
                         LoadExtUVec32x2ToVecI64x2);
    Address offset = logify(get());
    Address align;
    switch (op) {
      case LoadSplatVec8x16:
        align = 1;
        break;
      case LoadSplatVec16x8:
        align = pick(1, 2);
        break;
      case LoadSplatVec32x4:
        align = pick(1, 2, 4);
        break;
      case LoadSplatVec64x2:
      case LoadExtSVec8x8ToVecI16x8:
      case LoadExtUVec8x8ToVecI16x8:
      case LoadExtSVec16x4ToVecI32x4:
      case LoadExtUVec16x4ToVecI32x4:
      case LoadExtSVec32x2ToVecI64x2:
      case LoadExtUVec32x2ToVecI64x2:
        align = pick(1, 2, 4, 8);
        break;
    }
    Expression* ptr = makePointer();
    return builder.makeSIMDLoad(op, offset, align, ptr);
  }

  Expression* makeBulkMemory(Type type) {
    if (!allowMemory) {
      return makeTrivial(type);
    }
    assert(wasm.features.hasBulkMemory());
    assert(type == none);
    switch (upTo(4)) {
      case 0:
        return makeMemoryInit();
      case 1:
        return makeDataDrop();
      case 2:
        return makeMemoryCopy();
      case 3:
        return makeMemoryFill();
    }
    WASM_UNREACHABLE("invalid value");
  }

  Expression* makeMemoryInit() {
    if (!allowMemory) {
      return makeTrivial(none);
    }
    uint32_t segment = upTo(wasm.memory.segments.size());
    size_t totalSize = wasm.memory.segments[segment].data.size();
    size_t offsetVal = upTo(totalSize);
    size_t sizeVal = upTo(totalSize - offsetVal);
    Expression* dest = makePointer();
    Expression* offset = builder.makeConst(Literal(int32_t(offsetVal)));
    Expression* size = builder.makeConst(Literal(int32_t(sizeVal)));
    return builder.makeMemoryInit(segment, dest, offset, size);
  }

  Expression* makeDataDrop() {
    if (!allowMemory) {
      return makeTrivial(none);
    }
    return builder.makeDataDrop(upTo(wasm.memory.segments.size()));
  }

  Expression* makeMemoryCopy() {
    if (!allowMemory) {
      return makeTrivial(none);
    }
    Expression* dest = makePointer();
    Expression* source = makePointer();
    Expression* size = make(i32);
    return builder.makeMemoryCopy(dest, source, size);
  }

  Expression* makeMemoryFill() {
    if (!allowMemory) {
      return makeTrivial(none);
    }
    Expression* dest = makePointer();
    Expression* value = makePointer();
    Expression* size = make(i32);
    return builder.makeMemoryFill(dest, value, size);
  }

  // special makers

  Expression* makeLogging() {
    auto type = getConcreteType();
    return builder.makeCall(
      std::string("log-") + type.toString(), {make(type)}, none);
  }

  Expression* makeMemoryHashLogging() {
    auto* hash = builder.makeCall(std::string("hashMemory"), {}, i32);
    return builder.makeCall(std::string("log-i32"), {hash}, none);
  }

  // special getters

  Type getReachableType() {
    return pick(FeatureOptions<Type>()
                  .add(FeatureSet::MVP, i32, i64, f32, f64, none)
                  .add(FeatureSet::SIMD, v128));
  }

  std::vector<Type> getConcreteTypes() {
    return items(FeatureOptions<Type>()
                   .add(FeatureSet::MVP, i32, i64, f32, f64)
                   .add(FeatureSet::SIMD, v128));
  }

  Type getConcreteType() { return pick(getConcreteTypes()); }

  // statistical distributions

  // 0 to the limit, logarithmic scale
  Index logify(Index x) {
    return std::floor(std::log(std::max(Index(1) + x, Index(1))));
  }

  // one of the integer values in [0, x)
  // this isn't a perfectly uniform distribution, but it's fast
  // and reasonable
  Index upTo(Index x) {
    if (x == 0) {
      return 0;
    }
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

  bool oneIn(Index x) { return upTo(x) == 0; }

  bool onceEvery(Index x) {
    static int counter = 0;
    counter++;
    return counter % x == 0;
  }

  // apply upTo twice, generating a skewed distribution towards
  // low values
  Index upToSquared(Index x) { return upTo(upTo(x)); }

  // pick from a vector
  template<typename T> const T& pick(const std::vector<T>& vec) {
    assert(!vec.empty());
    auto index = upTo(vec.size());
    return vec[index];
  }

  // pick from a fixed list
  template<typename T, typename... Args> T pick(T first, Args... args) {
    auto num = sizeof...(Args) + 1;
    auto temp = upTo(num);
    return pickGivenNum<T>(temp, first, args...);
  }

  template<typename T> T pickGivenNum(size_t num, T first) {
    assert(num == 0);
    return first;
  }

// Trick to avoid a bug in GCC 7.x.
// Upstream bug report: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82800
#define GCC_VERSION                                                            \
  (__GNUC__ * 10000 + __GNUC_MINOR__ * 100 + __GNUC_PATCHLEVEL__)
#if GCC_VERSION > 70000 && GCC_VERSION < 70300
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wmaybe-uninitialized"
#endif

  template<typename T, typename... Args>
  T pickGivenNum(size_t num, T first, Args... args) {
    if (num == 0) {
      return first;
    }
    return pickGivenNum<T>(num - 1, args...);
  }

#if GCC_VERSION > 70000 && GCC_VERSION < 70300
#pragma GCC diagnostic pop
#endif

  template<typename T> struct FeatureOptions {
    template<typename... Ts>
    FeatureOptions<T>& add(FeatureSet::Feature feature, T option, Ts... rest) {
      options[feature].push_back(option);
      return add(feature, rest...);
    }

    FeatureOptions<T>& add(FeatureSet::Feature feature) { return *this; }

    std::map<FeatureSet::Feature, std::vector<T>> options;
  };

  template<typename T> std::vector<T> items(FeatureOptions<T>& picker) {
    std::vector<T> matches;
    for (const auto& item : picker.options) {
      if (wasm.features.has(item.first)) {
        matches.reserve(matches.size() + item.second.size());
        matches.insert(matches.end(), item.second.begin(), item.second.end());
      }
    }
    return matches;
  }

  template<typename T> const T pick(FeatureOptions<T>& picker) {
    return pick(items(picker));
  }

  // utilities

  Name getTargetName(Expression* target) {
    if (auto* block = target->dynCast<Block>()) {
      return block->name;
    } else if (auto* loop = target->dynCast<Loop>()) {
      return loop->name;
    }
    WASM_UNREACHABLE("unexpected expr type");
  }

  Type getTargetType(Expression* target) {
    if (auto* block = target->dynCast<Block>()) {
      return block->type;
    } else if (target->is<Loop>()) {
      return none;
    }
    WASM_UNREACHABLE("unexpected expr type");
  }
};

} // namespace wasm

// XXX Switch class has a condition?! is it real? should the node type be the
// value type if it exists?!

// TODO copy an existing function and replace just one node in it
