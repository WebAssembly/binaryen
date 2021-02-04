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

// TODO Generate exception handling instructions

#include "ir/memory-utils.h"
#include <ir/find_all.h>
#include <ir/literal-utils.h>
#include <ir/manipulation.h>
#include <ir/names.h>
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

  void setAllowMemory(bool allowMemory_) { allowMemory = allowMemory_; }

  void setAllowOOB(bool allowOOB_) { allowOOB = allowOOB_; }

  void build() {
    if (HANG_LIMIT > 0) {
      prepareHangLimitSupport();
    }
    if (allowMemory) {
      setupMemory();
    }
    setupTable();
    setupGlobals();
    if (wasm.features.hasExceptionHandling()) {
      setupEvents();
    }
    modifyInitialFunctions();
    addImportLoggingSupport();
    // keep adding functions until we run out of input
    while (!finishedInput) {
      auto* func = addFunction();
      addInvocations(func);
    }
    if (HANG_LIMIT > 0) {
      addHangLimitSupport();
    }
    if (allowMemory) {
      finalizeMemory();
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

  // The maximum number of globals in a module.
  static const int MAX_GLOBALS = 20;

  // The maximum number of tuple elements.
  static const int MAX_TUPLE_SIZE = 6;

  // some things require luck, try them a few times
  static const int TRIES = 10;

  // beyond a nesting limit, greatly decrease the chance to continue to nest
  static const int NESTING_LIMIT = 11;

  // the maximum size of a block
  static const int BLOCK_FACTOR = 5;

  // the memory that we use, a small portion so that we have a good chance of
  // looking at writes (we also look outside of this region with small
  // probability) this should be a power of 2
  const Address USABLE_MEMORY = 16;

  // the number of runtime iterations (function calls, loop backbranches) we
  // allow before we stop execution with a trap, to prevent hangs. 0 means
  // no hang protection.
  static const int HANG_LIMIT = 10;

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

  Type getSubType(Type type) {
    if (type.isTuple()) {
      std::vector<Type> types;
      for (const auto& t : type) {
        types.push_back(getSubType(t));
      }
      return Type(types);
    }
    if (type.isFunction() && type != Type::funcref) {
      // TODO: specific typed function references types.
      return type;
    }
    SmallVector<Type, 2> options;
    options.push_back(type); // includes itself
    // TODO: interesting uses of typed function types
    // TODO: interesting subtypes of compound types
    if (type.isBasic()) {
      switch (type.getBasic()) {
        case Type::anyref:
          if (wasm.features.hasReferenceTypes()) {
            options.push_back(Type::funcref);
            options.push_back(Type::externref);
            if (wasm.features.hasGC()) {
              options.push_back(Type::eqref);
              // TODO: i31ref, dataref, etc.
            }
          }
          break;
        case Type::eqref:
          if (wasm.features.hasGC()) {
            // TODO: i31ref, dataref, etc.
          }
          break;
        default:
          break;
      }
    }
    return pick(options);
  }

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
          segment.offset = builder.makeConst(int32_t(memCovered));
          memCovered += segSize;
        }
        wasm.memory.segments.push_back(segment);
      }
    } else {
      // init some data
      wasm.memory.segments.emplace_back(builder.makeConst(int32_t(0)));
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
      builder.makeLocalSet(0, builder.makeConst(uint32_t(5381))));
    auto zero = Literal::makeFromInt32(0, wasm.memory.indexType);
    for (Index i = 0; i < USABLE_MEMORY; i++) {
      contents.push_back(builder.makeLocalSet(
        0,
        builder.makeBinary(
          XorInt32,
          builder.makeBinary(
            AddInt32,
            builder.makeBinary(ShlInt32,
                               builder.makeLocalGet(0, Type::i32),
                               builder.makeConst(uint32_t(5))),
            builder.makeLocalGet(0, Type::i32)),
          builder.makeLoad(
            1, false, i, 1, builder.makeConst(zero), Type::i32))));
    }
    contents.push_back(builder.makeLocalGet(0, Type::i32));
    auto* body = builder.makeBlock(contents);
    auto* hasher = wasm.addFunction(builder.makeFunction(
      "hashMemory", Signature(Type::none, Type::i32), {Type::i32}, body));
    wasm.addExport(
      builder.makeExport(hasher->name, hasher->name, ExternalKind::Function));
    // Export memory so JS fuzzing can use it
    if (!wasm.getExportOrNull("memory")) {
      wasm.addExport(builder.makeExport("memory", "0", ExternalKind::Memory));
    }
  }

  void setupTable() {
    wasm.table.exists = true;
    wasm.table.initial = wasm.table.max = 0;
    wasm.table.segments.emplace_back(builder.makeConst(int32_t(0)));
  }

  std::map<Type, std::vector<Name>> globalsByType;

  void setupGlobals() {
    // If there were initial wasm contents, there may be imported globals. That
    // would be a problem in the fuzzer harness as we'd error if we do not
    // provide them (and provide the proper type, etc.).
    // Avoid that, so that all the standard fuzzing infrastructure can always
    // run the wasm.
    for (auto& global : wasm.globals) {
      if (global->imported()) {
        // Remove import info from imported globals, and give them a simple
        // initializer.
        global->module = global->base = Name();
        global->init = makeConst(global->type);
      } else {
        // If the initialization referred to an imported global, it no longer
        // can point to the same global after we make it a non-imported global
        // (as wasm doesn't allow that - you can only use an imported one).
        if (global->init->is<GlobalGet>()) {
          global->init = makeConst(global->type);
        }
      }
    }
    for (size_t index = upTo(MAX_GLOBALS); index > 0; --index) {
      auto type = getConcreteType();
      auto global =
        builder.makeGlobal(Names::getValidGlobalName(wasm, "global$"),
                           type,
                           makeConst(type),
                           Builder::Mutable);
      globalsByType[type].push_back(global->name);
      wasm.addGlobal(std::move(global));
    }
  }

  void setupEvents() {
    Index num = upTo(3);
    for (size_t i = 0; i < num; i++) {
      auto event =
        builder.makeEvent(Names::getValidEventName(wasm, "event$"),
                          WASM_EVENT_ATTRIBUTE_EXCEPTION,
                          Signature(getControlFlowType(), Type::none));
      wasm.addEvent(std::move(event));
    }
  }

  void finalizeMemory() {
    for (auto& segment : wasm.memory.segments) {
      Address maxOffset = segment.data.size();
      if (!segment.isPassive) {
        if (auto* offset = segment.offset->dynCast<GlobalGet>()) {
          // Using a non-imported global in a segment offset is not valid in
          // wasm. This can occur due to us making what used to be an imported
          // global, in initial contents, be not imported any more. To fix that,
          // replace such invalid things with a constant.
          // Note that it is still possible in theory to have imported globals
          // here, as we only do the above for initial contents. While the
          // fuzzer doesn't do so as of the time of this comment, do a check
          // for full generality, so that this code essentially does "if this
          // is invalid wasm, fix it up."
          if (!wasm.getGlobal(offset->name)->imported()) {
            // TODO: It would be better to avoid segment overlap so that
            //       MemoryPacking can run.
            segment.offset =
              builder.makeConst(Literal::makeFromInt32(0, Type::i32));
          }
        }
        if (auto* offset = segment.offset->dynCast<Const>()) {
          maxOffset = maxOffset + offset->value.getInteger();
        }
      }
      wasm.memory.initial = std::max(
        wasm.memory.initial,
        Address((maxOffset + Memory::kPageSize - 1) / Memory::kPageSize));
    }
    wasm.memory.initial = std::max(wasm.memory.initial, USABLE_MEMORY);
    // Avoid an unlimited memory size, which would make fuzzing very difficult
    // as different VMs will run out of system memory in different ways.
    if (wasm.memory.max == Memory::kUnlimitedSize) {
      wasm.memory.max = wasm.memory.initial;
    }
    if (wasm.memory.max <= wasm.memory.initial) {
      // To allow growth to work (which a testcase may assume), try to make the
      // maximum larger than the initial.
      // TODO: scan the wasm for grow instructions?
      wasm.memory.max =
        std::min(Address(wasm.memory.initial + 1), Address(Memory::kMaxSize32));
    }
    // Avoid an imported memory (which the fuzz harness would need to handle).
    wasm.memory.module = wasm.memory.base = Name();
  }

  void finalizeTable() {
    for (auto& segment : wasm.table.segments) {
      // If the offset is a global that was imported (which is ok) but no
      // longer is (not ok) we need to change that.
      if (auto* offset = segment.offset->dynCast<GlobalGet>()) {
        if (!wasm.getGlobal(offset->name)->imported()) {
          // TODO: the segments must not overlap...
          segment.offset =
            builder.makeConst(Literal::makeFromInt32(0, Type::i32));
        }
      }
      Address maxOffset = segment.data.size();
      if (auto* offset = segment.offset->dynCast<Const>()) {
        maxOffset = maxOffset + offset->value.getInteger();
      }
      wasm.table.initial = std::max(wasm.table.initial, maxOffset);
    }
    wasm.table.max =
      oneIn(2) ? Address(Table::kUnlimitedSize) : wasm.table.initial;
    // Avoid an imported table (which the fuzz harness would need to handle).
    wasm.table.module = wasm.table.base = Name();
  }

  Name HANG_LIMIT_GLOBAL;

  void prepareHangLimitSupport() {
    HANG_LIMIT_GLOBAL = Names::getValidGlobalName(wasm, "hangLimit");
  }

  void addHangLimitSupport() {
    auto glob = builder.makeGlobal(HANG_LIMIT_GLOBAL,
                                   Type::i32,
                                   builder.makeConst(int32_t(HANG_LIMIT)),
                                   Builder::Mutable);
    wasm.addGlobal(std::move(glob));

    Name exportName = "hangLimitInitializer";
    auto funcName = Names::getValidFunctionName(wasm, exportName);
    auto* func = new Function;
    func->name = funcName;
    func->sig = Signature(Type::none, Type::none);
    func->body = builder.makeGlobalSet(HANG_LIMIT_GLOBAL,
                                       builder.makeConst(int32_t(HANG_LIMIT)));
    wasm.addFunction(func);

    if (wasm.getExportOrNull(exportName)) {
      // We must export our actual hang limit function - remove anything
      // previously existing.
      wasm.removeExport(exportName);
    }
    auto* export_ = new Export;
    export_->name = exportName;
    export_->value = func->name;
    export_->kind = ExternalKind::Function;
    wasm.addExport(export_);
  }

  void addImportLoggingSupport() {
    for (auto type : getLoggableTypes()) {
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
                          builder.makeGlobalGet(HANG_LIMIT_GLOBAL, Type::i32)),
        makeTrivial(Type::unreachable)),
      builder.makeGlobalSet(
        HANG_LIMIT_GLOBAL,
        builder.makeBinary(BinaryOp::SubInt32,
                           builder.makeGlobalGet(HANG_LIMIT_GLOBAL, Type::i32),
                           builder.makeConst(int32_t(1)))));
  }

  // function generation state

  struct FunctionCreationContext {
    TranslateToFuzzReader& parent;

    Function* func;

    std::vector<Expression*> breakableStack; // things we can break to
    Index labelIndex = 0;

    // a list of things relevant to computing the odds of an infinite loop,
    // which we try to minimize the risk of
    std::vector<Expression*> hangStack;

    // type => list of locals with that type
    std::map<Type, std::vector<Index>> typeLocals;

    FunctionCreationContext(TranslateToFuzzReader& parent, Function* func)
      : parent(parent), func(func) {
      parent.funcContext = this;
    }

    ~FunctionCreationContext() {
      if (parent.HANG_LIMIT > 0) {
        parent.addHangLimitChecks(func);
      }
      assert(breakableStack.empty());
      assert(hangStack.empty());
      parent.funcContext = nullptr;
    }
  };

  FunctionCreationContext* funcContext = nullptr;

  Index numAddedFunctions = 0;

  Function* addFunction() {
    LOGGING_PERCENT = upToSquared(100);
    auto* func = new Function;
    func->name = Names::getValidFunctionName(wasm, "func");
    FunctionCreationContext context(*this, func);
    assert(funcContext->typeLocals.empty());
    Index numParams = upToSquared(MAX_PARAMS);
    std::vector<Type> params;
    params.reserve(numParams);
    for (Index i = 0; i < numParams; i++) {
      auto type = getSingleConcreteType();
      funcContext->typeLocals[type].push_back(params.size());
      params.push_back(type);
    }
    func->sig = Signature(Type(params), getControlFlowType());
    Index numVars = upToSquared(MAX_VARS);
    for (Index i = 0; i < numVars; i++) {
      auto type = getConcreteType();
      if (type.isRef() && !type.isNullable()) {
        // We can't use a nullable type as a var, which is null-initialized.
        continue;
      }
      funcContext->typeLocals[type].push_back(params.size() +
                                              func->vars.size());
      func->vars.push_back(type);
    }
    // with small chance, make the body unreachable
    auto bodyType = func->sig.results;
    if (oneIn(10)) {
      bodyType = Type::unreachable;
    }
    // with reasonable chance make the body a block
    if (oneIn(2)) {
      func->body = makeBlock(bodyType);
    } else {
      func->body = make(bodyType);
    }
    // Our OOB checks are already in the code, and if we recombine/mutate we
    // may end up breaking them. TODO: do them after the fact, like with the
    // hang limit checks.
    if (allowOOB) {
      // Recombinations create duplicate code patterns.
      recombine(func);
      // Mutations add random small changes, which can subtly break duplicate
      // code patterns.
      mutate(func);
      // TODO: liveness operations on gets, with some prob alter a get to one
      // with more possible sets.
      // Recombination, mutation, etc. can break validation; fix things up
      // after.
      fixLabels(func);
    }
    // Add hang limit checks after all other operations on the function body.
    wasm.addFunction(func);
    // export some, but not all (to allow inlining etc.). make sure to
    // export at least one, though, to keep each testcase interesting
    if ((numAddedFunctions == 0 || oneIn(2)) &&
        !wasm.getExportOrNull(func->name)) {
      auto* export_ = new Export;
      export_->name = func->name;
      export_->value = func->name;
      export_->kind = ExternalKind::Function;
      wasm.addExport(export_);
    }
    // add some to the table
    while (oneIn(3) && !finishedInput) {
      wasm.table.segments[0].data.push_back(func->name);
    }
    numAddedFunctions++;
    return func;
  }

  void addHangLimitChecks(Function* func) {
    // loop limit
    FindAll<Loop> loops(func->body);
    for (auto* loop : loops.list) {
      loop->body =
        builder.makeSequence(makeHangLimitCheck(), loop->body, loop->type);
    }
    // recursion limit
    func->body =
      builder.makeSequence(makeHangLimitCheck(), func->body, func->sig.results);
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
          // For constants, perform only a small tweaking in some cases.
          if (auto* c = curr->dynCast<Const>()) {
            if (parent.oneIn(2)) {
              c->value = parent.tweak(c->value);
              return;
            }
          }
          // TODO: more minor tweaks to immediates, like making a load atomic or
          // not, changing an offset, etc.
          // Perform a general replacement.
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
    struct Fixer
      : public ControlFlowWalker<Fixer, UnifiedExpressionVisitor<Fixer>> {
      Module& wasm;
      TranslateToFuzzReader& parent;

      Fixer(Module& wasm, TranslateToFuzzReader& parent)
        : wasm(wasm), parent(parent) {}

      // Track seen names to find duplication, which is invalid.
      std::set<Name> seen;

      void visitExpression(Expression* curr) {
        // Note all scope names, and fix up all uses.

#define DELEGATE_ID curr->_id

#define DELEGATE_START(id)                                                     \
  auto* cast = curr->cast<id>();                                               \
  WASM_UNUSED(cast);

#define DELEGATE_GET_FIELD(id, name) cast->name

#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, name)                                \
  if (cast->name.is()) {                                                       \
    if (seen.count(cast->name)) {                                              \
      replace();                                                               \
    } else {                                                                   \
      seen.insert(cast->name);                                                 \
    }                                                                          \
  }

#define DELEGATE_FIELD_SCOPE_NAME_USE(id, name) replaceIfInvalid(cast->name);

#define DELEGATE_FIELD_CHILD(id, name)
#define DELEGATE_FIELD_OPTIONAL_CHILD(id, name)
#define DELEGATE_FIELD_INT(id, name)
#define DELEGATE_FIELD_INT_ARRAY(id, name)
#define DELEGATE_FIELD_LITERAL(id, name)
#define DELEGATE_FIELD_NAME(id, name)
#define DELEGATE_FIELD_NAME_VECTOR(id, name)
#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, name)
#define DELEGATE_FIELD_SIGNATURE(id, name)
#define DELEGATE_FIELD_TYPE(id, name)
#define DELEGATE_FIELD_ADDRESS(id, name)

#include "wasm-delegations-fields.h"
      }

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
          if (auto* block = curr->dynCast<Block>()) {
            if (name == block->name) {
              return true;
            }
          } else if (auto* loop = curr->dynCast<Loop>()) {
            if (name == loop->name) {
              return true;
            }
          } else {
            // an if or a try, ignorable
            assert(curr->is<If>() || curr->is<Try>());
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

  void modifyInitialFunctions() {
    if (wasm.functions.empty()) {
      return;
    }
    // Pick a chance to fuzz the contents of a function.
    const int RESOLUTION = 10;
    auto chance = upTo(RESOLUTION + 1);
    for (auto& ref : wasm.functions) {
      auto* func = ref.get();
      FunctionCreationContext context(*this, func);
      if (func->imported()) {
        // We can't allow extra imports, as the fuzzing infrastructure wouldn't
        // know what to provide.
        func->module = func->base = Name();
        func->body = make(func->sig.results);
      }
      // Optionally, fuzz the function contents.
      if (upTo(RESOLUTION) >= chance) {
        dropToLog(func);
        // TODO add some locals? and the rest of addFunction's operations?
        // TODO: interposition, replace initial a(b) with a(RANDOM_THING(b))
        // TODO: if we add OOB checks after creation, then we can do it on
        //       initial contents too, and it may be nice to *not* run these
        //       passes, like we don't run them on new functions. But, we may
        //       still want to run them some of the time, at least, so that we
        //       check variations on initial testcases even at the risk of OOB.
        recombine(func);
        mutate(func);
        fixLabels(func);
      }
    }
    // Remove a start function - the fuzzing harness expects code to run only
    // from exports.
    wasm.start = Name();
  }

  // Initial wasm contents may have come from a test that uses the drop pattern:
  //
  //  (drop ..something interesting..)
  //
  // The dropped interesting thing is optimized to some other interesting thing
  // by a pass, and we verify it is the expected one. But this does not use the
  // value in a way the fuzzer can notice. Replace some drops with a logging
  // operation instead.
  void dropToLog(Function* func) {
    // Don't always do this.
    if (oneIn(2)) {
      return;
    }
    struct Modder : public PostWalker<Modder> {
      Module& wasm;
      TranslateToFuzzReader& parent;

      Modder(Module& wasm, TranslateToFuzzReader& parent)
        : wasm(wasm), parent(parent) {}

      void visitDrop(Drop* curr) {
        if (parent.isLoggableType(curr->value->type) && parent.oneIn(2)) {
          replaceCurrent(parent.builder.makeCall(std::string("log-") +
                                                   curr->value->type.toString(),
                                                 {curr->value},
                                                 Type::none));
        }
      }
    };
    Modder modder(wasm, *this);
    modder.walk(func->body);
  }

  // the fuzzer external interface sends in zeros (simpler to compare
  // across invocations from JS or wasm-opt etc.). Add invocations in
  // the wasm, so they run everywhere
  void addInvocations(Function* func) {
    Name name = func->name.str + std::string("_invoker");
    if (wasm.getFunctionOrNull(name) || wasm.getExportOrNull(name)) {
      return;
    }
    std::vector<Expression*> invocations;
    while (oneIn(2) && !finishedInput) {
      std::vector<Expression*> args;
      for (const auto& type : func->sig.params) {
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
    invoker->name = name;
    invoker->sig = Signature(Type::none, Type::none);
    invoker->body = builder.makeBlock(invocations);
    wasm.addFunction(invoker);
    auto* export_ = new Export;
    export_->name = name;
    export_->value = name;
    export_->kind = ExternalKind::Function;
    wasm.addExport(export_);
  }

  Name makeLabel() {
    return std::string("label$") + std::to_string(funcContext->labelIndex++);
  }

  // Weighting for the core make* methods. Some nodes are important enough that
  // we should do them quite often.
  static const size_t VeryImportant = 4;
  static const size_t Important = 2;

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
      } else if (type == Type::none) {
        if (oneIn(2)) {
          return makeNop(type);
        } else {
          return makeLocalSet(type);
        }
      }
      assert(type == Type::unreachable);
      return makeTrivial(type);
    }
    nesting++;
    Expression* ret = nullptr;
    if (type.isConcrete()) {
      ret = _makeConcrete(type);
    } else if (type == Type::none) {
      ret = _makenone();
    } else {
      assert(type == Type::unreachable);
      ret = _makeunreachable();
    }
    // we should create the right type of thing
    assert(Type::isSubType(ret->type, type));
    nesting--;
    return ret;
  }

  Expression* _makeConcrete(Type type) {
    bool canMakeControlFlow = !type.isTuple() || wasm.features.hasMultivalue();
    using Self = TranslateToFuzzReader;
    FeatureOptions<Expression* (Self::*)(Type)> options;
    using WeightedOption = decltype(options)::WeightedOption;
    options.add(FeatureSet::MVP,
                WeightedOption{&Self::makeLocalGet, VeryImportant},
                WeightedOption{&Self::makeLocalSet, VeryImportant},
                WeightedOption{&Self::makeGlobalGet, Important},
                WeightedOption{&Self::makeConst, Important});
    if (canMakeControlFlow) {
      options
        .add(FeatureSet::MVP,
             WeightedOption{&Self::makeBlock, Important},
             WeightedOption{&Self::makeIf, Important},
             WeightedOption{&Self::makeLoop, Important},
             WeightedOption{&Self::makeBreak, Important},
             &Self::makeCall,
             &Self::makeCallIndirect)
        .add(FeatureSet::TypedFunctionReferences | FeatureSet::ReferenceTypes,
             &Self::makeCallRef);
    }
    if (type.isSingle()) {
      options
        .add(FeatureSet::MVP,
             WeightedOption{&Self::makeUnary, Important},
             WeightedOption{&Self::makeBinary, Important},
             &Self::makeSelect)
        .add(FeatureSet::Multivalue, &Self::makeTupleExtract);
    }
    if (type.isSingle() && !type.isRef() && !type.isRtt()) {
      options.add(FeatureSet::MVP, {&Self::makeLoad, Important});
      options.add(FeatureSet::SIMD, &Self::makeSIMD);
    }
    if (type.isInteger()) {
      options.add(FeatureSet::Atomics, &Self::makeAtomic);
    }
    if (type == Type::i32) {
      options.add(FeatureSet::ReferenceTypes, &Self::makeRefIsNull);
      options.add(FeatureSet::ReferenceTypes | FeatureSet::GC,
                  &Self::makeRefEq);
      //  TODO: makeI31Get
    }
    if (type.isTuple()) {
      options.add(FeatureSet::Multivalue, &Self::makeTupleMake);
    }
    if (type == Type::i31ref) {
      options.add(FeatureSet::ReferenceTypes | FeatureSet::GC,
                  &Self::makeI31New);
    }
    // TODO: struct.get and other GC things
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
    using Self = TranslateToFuzzReader;
    auto options = FeatureOptions<Expression* (Self::*)(Type)>();
    using WeightedOption = decltype(options)::WeightedOption;
    options
      .add(FeatureSet::MVP,
           WeightedOption{&Self::makeLocalSet, VeryImportant},
           WeightedOption{&Self::makeBlock, Important},
           WeightedOption{&Self::makeIf, Important},
           WeightedOption{&Self::makeLoop, Important},
           WeightedOption{&Self::makeBreak, Important},
           WeightedOption{&Self::makeStore, Important},
           &Self::makeCall,
           &Self::makeCallIndirect,
           &Self::makeDrop,
           &Self::makeNop,
           &Self::makeGlobalSet)
      .add(FeatureSet::BulkMemory, &Self::makeBulkMemory)
      .add(FeatureSet::Atomics, &Self::makeAtomic)
      .add(FeatureSet::TypedFunctionReferences | FeatureSet::ReferenceTypes,
           &Self::makeCallRef);
    return (this->*pick(options))(Type::none);
  }

  Expression* _makeunreachable() {
    using Self = TranslateToFuzzReader;
    auto options = FeatureOptions<Expression* (Self::*)(Type)>();
    using WeightedOption = decltype(options)::WeightedOption;
    options
      .add(FeatureSet::MVP,
           WeightedOption{&Self::makeLocalSet, VeryImportant},
           WeightedOption{&Self::makeBlock, Important},
           WeightedOption{&Self::makeIf, Important},
           WeightedOption{&Self::makeLoop, Important},
           WeightedOption{&Self::makeBreak, Important},
           WeightedOption{&Self::makeStore, Important},
           WeightedOption{&Self::makeUnary, Important},
           WeightedOption{&Self::makeBinary, Important},
           WeightedOption{&Self::makeUnreachable, Important},
           &Self::makeCall,
           &Self::makeCallIndirect,
           &Self::makeSelect,
           &Self::makeSwitch,
           &Self::makeDrop,
           &Self::makeReturn)
      .add(FeatureSet::TypedFunctionReferences | FeatureSet::ReferenceTypes,
           &Self::makeCallRef);
    return (this->*pick(options))(Type::unreachable);
  }

  // make something with no chance of infinite recursion
  Expression* makeTrivial(Type type) {
    if (type.isConcrete()) {
      if (oneIn(2)) {
        return makeLocalGet(type);
      } else {
        return makeConst(type);
      }
    } else if (type == Type::none) {
      return makeNop(type);
    }
    assert(type == Type::unreachable);
    Expression* ret = nullptr;
    if (funcContext->func->sig.results.isConcrete()) {
      ret = makeTrivial(funcContext->func->sig.results);
    }
    return builder.makeReturn(ret);
  }

  // specific expression creators

  Expression* makeBlock(Type type) {
    auto* ret = builder.makeBlock();
    ret->type = type; // so we have it during child creation
    ret->name = makeLabel();
    funcContext->breakableStack.push_back(ret);
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
      ret->list.push_back(make(Type::none));
      num--;
    }
    // give a chance to make the final element an unreachable break, instead
    // of concrete - a common pattern (branch to the top of a loop etc.)
    if (!finishedInput && type.isConcrete() && oneIn(2)) {
      ret->list.push_back(makeBreak(Type::unreachable));
    } else {
      ret->list.push_back(make(type));
    }
    funcContext->breakableStack.pop_back();
    if (type.isConcrete()) {
      ret->finalize(type);
    } else {
      ret->finalize();
    }
    if (ret->type != type) {
      // e.g. we might want an unreachable block, but a child breaks to it
      assert(type == Type::unreachable && ret->type == Type::none);
      return builder.makeSequence(ret, make(Type::unreachable));
    }
    return ret;
  }

  Expression* makeLoop(Type type) {
    auto* ret = wasm.allocator.alloc<Loop>();
    ret->type = type; // so we have it during child creation
    ret->name = makeLabel();
    funcContext->breakableStack.push_back(ret);
    funcContext->hangStack.push_back(ret);
    // either create random content, or do something more targeted
    if (oneIn(2)) {
      ret->body = makeMaybeBlock(type);
    } else {
      // ensure a branch back. also optionally create some loop vars
      std::vector<Expression*> list;
      list.push_back(makeMaybeBlock(Type::none)); // primary contents
      // possible branch back
      list.push_back(builder.makeBreak(ret->name, nullptr, makeCondition()));
      list.push_back(make(type)); // final element, so we have the right type
      ret->body = builder.makeBlock(list, type);
    }
    funcContext->breakableStack.pop_back();
    funcContext->hangStack.pop_back();
    ret->finalize(type);
    return ret;
  }

  Expression* makeCondition() {
    // we want a 50-50 chance for the condition to be taken, for interesting
    // execution paths. by itself, there is bias (e.g. most consts are "yes")
    // so even that out with noise
    auto* ret = make(Type::i32);
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

  Expression* buildIf(const struct ThreeArgs& args, Type type) {
    return builder.makeIf(args.a, args.b, args.c, type);
  }

  Expression* makeIf(Type type) {
    auto* condition = makeCondition();
    funcContext->hangStack.push_back(nullptr);
    auto* ret =
      buildIf({condition, makeMaybeBlock(type), makeMaybeBlock(type)}, type);
    funcContext->hangStack.pop_back();
    return ret;
  }

  Expression* makeBreak(Type type) {
    if (funcContext->breakableStack.empty()) {
      return makeTrivial(type);
    }
    Expression* condition = nullptr;
    if (type != Type::unreachable) {
      funcContext->hangStack.push_back(nullptr);
      condition = makeCondition();
    }
    // we need to find a proper target to break to; try a few times
    int tries = TRIES;
    while (tries-- > 0) {
      auto* target = pick(funcContext->breakableStack);
      auto name = getTargetName(target);
      auto valueType = getTargetType(target);
      if (type.isConcrete()) {
        // we are flowing out a value
        if (valueType != type) {
          // we need to break to a proper place
          continue;
        }
        auto* ret = builder.makeBreak(name, make(type), condition);
        funcContext->hangStack.pop_back();
        return ret;
      } else if (type == Type::none) {
        if (valueType != Type::none) {
          // we need to break to a proper place
          continue;
        }
        auto* ret = builder.makeBreak(name, nullptr, condition);
        funcContext->hangStack.pop_back();
        return ret;
      } else {
        assert(type == Type::unreachable);
        if (valueType != Type::none) {
          // we need to break to a proper place
          continue;
        }
        // we are about to make an *un*conditional break. if it is
        // to a loop, we prefer there to be a condition along the
        // way, to reduce the chance of infinite looping
        size_t conditions = 0;
        int i = funcContext->hangStack.size();
        while (--i >= 0) {
          auto* item = funcContext->hangStack[i];
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
    if (type != Type::unreachable) {
      funcContext->hangStack.pop_back();
    }
    return makeTrivial(type);
  }

  Expression* makeCall(Type type) {
    int tries = TRIES;
    bool isReturn;
    while (tries-- > 0) {
      Function* target = funcContext->func;
      if (!wasm.functions.empty() && !oneIn(wasm.functions.size())) {
        target = pick(wasm.functions).get();
      }
      isReturn = type == Type::unreachable && wasm.features.hasTailCall() &&
                 funcContext->func->sig.results == target->sig.results;
      if (target->sig.results != type && !isReturn) {
        continue;
      }
      // we found one!
      std::vector<Expression*> args;
      for (const auto& argType : target->sig.params) {
        args.push_back(make(argType));
      }
      return builder.makeCall(target->name, args, type, isReturn);
    }
    // we failed to find something
    return makeTrivial(type);
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
      isReturn = type == Type::unreachable && wasm.features.hasTailCall() &&
                 funcContext->func->sig.results == targetFn->sig.results;
      if (targetFn->sig.results == type || isReturn) {
        break;
      }
      i++;
      if (i == data.size()) {
        i = 0;
      }
      if (i == start) {
        return makeTrivial(type);
      }
    }
    // with high probability, make sure the type is valid  otherwise, most are
    // going to trap
    Expression* target;
    if (!allowOOB || !oneIn(10)) {
      target = builder.makeConst(int32_t(i));
    } else {
      target = make(Type::i32);
    }
    std::vector<Expression*> args;
    for (const auto& type : targetFn->sig.params) {
      args.push_back(make(type));
    }
    return builder.makeCallIndirect(target, args, targetFn->sig, isReturn);
  }

  Expression* makeCallRef(Type type) {
    // look for a call target with the right type
    Function* target;
    bool isReturn;
    size_t i = 0;
    while (1) {
      if (i == TRIES || wasm.functions.empty()) {
        // We can't find a proper target, give up.
        return makeTrivial(type);
      }
      // TODO: handle unreachable
      target = wasm.functions[upTo(wasm.functions.size())].get();
      isReturn = type == Type::unreachable && wasm.features.hasTailCall() &&
                 funcContext->func->sig.results == target->sig.results;
      if (target->sig.results == type || isReturn) {
        break;
      }
      i++;
    }
    std::vector<Expression*> args;
    for (const auto& type : target->sig.params) {
      args.push_back(make(type));
    }
    auto targetType = Type(HeapType(target->sig), Nullable);
    // TODO: half the time make a completely random item with that type.
    return builder.makeCallRef(
      builder.makeRefFunc(target->name, targetType), args, type, isReturn);
  }

  Expression* makeLocalGet(Type type) {
    auto& locals = funcContext->typeLocals[type];
    if (locals.empty()) {
      return makeConst(type);
    }
    return builder.makeLocalGet(pick(locals), type);
  }

  Expression* makeLocalSet(Type type) {
    bool tee = type != Type::none;
    Type valueType;
    if (tee) {
      valueType = type;
    } else {
      valueType = getConcreteType();
    }
    auto& locals = funcContext->typeLocals[valueType];
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

  // Some globals are for internal use, and should not be modified by random
  // fuzz code.
  bool isValidGlobal(Name name) { return name != HANG_LIMIT_GLOBAL; }

  Expression* makeGlobalGet(Type type) {
    auto it = globalsByType.find(type);
    if (it == globalsByType.end() || it->second.empty()) {
      return makeConst(type);
    }
    auto name = pick(it->second);
    if (isValidGlobal(name)) {
      return builder.makeGlobalGet(name, type);
    } else {
      return makeTrivial(type);
    }
  }

  Expression* makeGlobalSet(Type type) {
    assert(type == Type::none);
    type = getConcreteType();
    auto it = globalsByType.find(type);
    if (it == globalsByType.end() || it->second.empty()) {
      return makeTrivial(Type::none);
    }
    auto name = pick(it->second);
    if (isValidGlobal(name)) {
      return builder.makeGlobalSet(name, make(type));
    } else {
      return makeTrivial(Type::none);
    }
  }

  Expression* makeTupleMake(Type type) {
    assert(wasm.features.hasMultivalue());
    assert(type.isTuple());
    std::vector<Expression*> elements;
    for (const auto& t : type) {
      elements.push_back(make(t));
    }
    return builder.makeTupleMake(std::move(elements));
  }

  Expression* makeTupleExtract(Type type) {
    assert(wasm.features.hasMultivalue());
    assert(type.isSingle() && type.isConcrete());
    Type tupleType = getTupleType();

    // Find indices from which we can extract `type`
    std::vector<size_t> extractIndices;
    size_t i = 0;
    for (const auto& t : tupleType) {
      if (t == type) {
        extractIndices.push_back(i);
      }
      ++i;
    }

    // If there are none, inject one
    if (extractIndices.size() == 0) {
      std::vector<Type> newElements(tupleType.begin(), tupleType.end());
      size_t injected = upTo(newElements.size());
      newElements[injected] = type;
      tupleType = Type(newElements);
      extractIndices.push_back(injected);
    }

    Index index = pick(extractIndices);
    Expression* child = make(tupleType);
    return builder.makeTupleExtract(child, index);
  }

  Expression* makePointer() {
    auto* ret = make(wasm.memory.indexType);
    // with high probability, mask the pointer so it's in a reasonable
    // range. otherwise, most pointers are going to be out of range and
    // most memory ops will just trap
    if (!allowOOB || !oneIn(10)) {
      if (wasm.memory.is64()) {
        ret = builder.makeBinary(
          AndInt64, ret, builder.makeConst(int64_t(USABLE_MEMORY - 1)));
      } else {
        ret = builder.makeBinary(
          AndInt32, ret, builder.makeConst(int32_t(USABLE_MEMORY - 1)));
      }
    }
    return ret;
  }

  Expression* makeNonAtomicLoad(Type type) {
    auto offset = logify(get());
    auto ptr = makePointer();
    switch (type.getBasic()) {
      case Type::i32: {
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
      case Type::i64: {
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
      case Type::f32: {
        return builder.makeLoad(4, false, offset, pick(1, 2, 4), ptr, type);
      }
      case Type::f64: {
        return builder.makeLoad(8, false, offset, pick(1, 2, 4, 8), ptr, type);
      }
      case Type::v128: {
        if (!wasm.features.hasSIMD()) {
          return makeTrivial(type);
        }
        return builder.makeLoad(
          16, false, offset, pick(1, 2, 4, 8, 16), ptr, type);
      }
      case Type::funcref:
      case Type::externref:
      case Type::anyref:
      case Type::eqref:
      case Type::i31ref:
      case Type::dataref:
      case Type::none:
      case Type::unreachable:
        WASM_UNREACHABLE("invalid type");
    }
    WASM_UNREACHABLE("invalid type");
  }

  Expression* makeLoad(Type type) {
    // reference types cannot be stored in memory
    if (!allowMemory || type.isRef()) {
      return makeTrivial(type);
    }
    auto* ret = makeNonAtomicLoad(type);
    if (type != Type::i32 && type != Type::i64) {
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
    if (type == Type::unreachable) {
      // make a normal store, then make it unreachable
      auto* ret = makeNonAtomicStore(getStorableType());
      auto* store = ret->dynCast<Store>();
      if (!store) {
        return ret;
      }
      switch (upTo(3)) {
        case 0:
          store->ptr = make(Type::unreachable);
          break;
        case 1:
          store->value = make(Type::unreachable);
          break;
        case 2:
          store->ptr = make(Type::unreachable);
          store->value = make(Type::unreachable);
          break;
      }
      store->finalize();
      return store;
    }
    // the type is none or unreachable. we also need to pick the value
    // type.
    if (type == Type::none) {
      type = getStorableType();
    }
    auto offset = logify(get());
    auto ptr = makePointer();
    auto value = make(type);
    switch (type.getBasic()) {
      case Type::i32: {
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
      case Type::i64: {
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
      case Type::f32: {
        return builder.makeStore(4, offset, pick(1, 2, 4), ptr, value, type);
      }
      case Type::f64: {
        return builder.makeStore(8, offset, pick(1, 2, 4, 8), ptr, value, type);
      }
      case Type::v128: {
        if (!wasm.features.hasSIMD()) {
          return makeTrivial(type);
        }
        return builder.makeStore(
          16, offset, pick(1, 2, 4, 8, 16), ptr, value, type);
      }
      case Type::funcref:
      case Type::externref:
      case Type::anyref:
      case Type::eqref:
      case Type::i31ref:
      case Type::dataref:
      case Type::none:
      case Type::unreachable:
        WASM_UNREACHABLE("invalid type");
    }
    WASM_UNREACHABLE("invalid type");
  }

  Expression* makeStore(Type type) {
    if (!allowMemory || type.isRef()) {
      return makeTrivial(type);
    }
    auto* ret = makeNonAtomicStore(type);
    auto* store = ret->dynCast<Store>();
    if (!store) {
      return ret;
    }
    if (store->value->type != Type::i32 && store->value->type != Type::i64) {
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

  // Makes a small change to a constant value.
  Literal tweak(Literal value) {
    auto type = value.type;
    if (type.isVector()) {
      // TODO: tweak each lane?
      return value;
    }
    // +- 1
    switch (upTo(5)) {
      case 0:
        value = value.add(Literal::makeNegOne(type));
        break;
      case 1:
        value = value.add(Literal::makeOne(type));
        break;
      default: {
      }
    }
    // For floats, optionally add a non-integer adjustment in +- [-1, 1]
    if (type.isFloat() && oneIn(2)) {
      const int RANGE = 1000;
      auto RANGE_LITERAL = Literal::makeFromInt32(RANGE, type);
      // adjustment -> [0, 2 * RANGE]
      auto adjustment = Literal::makeFromInt32(upTo(2 * RANGE + 1), type);
      // adjustment -> [-RANGE, RANGE]
      adjustment = adjustment.sub(RANGE_LITERAL);
      // adjustment -> [-1, 1]
      adjustment = adjustment.div(RANGE_LITERAL);
      value = value.add(adjustment);
    }
    // Flip sign.
    if (oneIn(2)) {
      value = value.mul(Literal::makeNegOne(type));
    }
    return value;
  }

  Literal makeLiteral(Type type) {
    if (type == Type::v128) {
      // generate each lane individually for random lane interpretation
      switch (upTo(6)) {
        case 0:
          return Literal(std::array<Literal, 16>{{makeLiteral(Type::i32),
                                                  makeLiteral(Type::i32),
                                                  makeLiteral(Type::i32),
                                                  makeLiteral(Type::i32),
                                                  makeLiteral(Type::i32),
                                                  makeLiteral(Type::i32),
                                                  makeLiteral(Type::i32),
                                                  makeLiteral(Type::i32),
                                                  makeLiteral(Type::i32),
                                                  makeLiteral(Type::i32),
                                                  makeLiteral(Type::i32),
                                                  makeLiteral(Type::i32),
                                                  makeLiteral(Type::i32),
                                                  makeLiteral(Type::i32),
                                                  makeLiteral(Type::i32),
                                                  makeLiteral(Type::i32)}});
        case 1:
          return Literal(std::array<Literal, 8>{{makeLiteral(Type::i32),
                                                 makeLiteral(Type::i32),
                                                 makeLiteral(Type::i32),
                                                 makeLiteral(Type::i32),
                                                 makeLiteral(Type::i32),
                                                 makeLiteral(Type::i32),
                                                 makeLiteral(Type::i32),
                                                 makeLiteral(Type::i32)}});
        case 2:
          return Literal(std::array<Literal, 4>{{makeLiteral(Type::i32),
                                                 makeLiteral(Type::i32),
                                                 makeLiteral(Type::i32),
                                                 makeLiteral(Type::i32)}});
        case 3:
          return Literal(std::array<Literal, 2>{
            {makeLiteral(Type::i64), makeLiteral(Type::i64)}});
        case 4:
          return Literal(std::array<Literal, 4>{{makeLiteral(Type::f32),
                                                 makeLiteral(Type::f32),
                                                 makeLiteral(Type::f32),
                                                 makeLiteral(Type::f32)}});
        case 5:
          return Literal(std::array<Literal, 2>{
            {makeLiteral(Type::f64), makeLiteral(Type::f64)}});
        default:
          WASM_UNREACHABLE("unexpected value");
      }
    }

    switch (upTo(4)) {
      case 0: {
        // totally random, entire range
        switch (type.getBasic()) {
          case Type::i32:
            return Literal(get32());
          case Type::i64:
            return Literal(get64());
          case Type::f32:
            return Literal(getFloat());
          case Type::f64:
            return Literal(getDouble());
          case Type::v128:
          case Type::funcref:
          case Type::externref:
          case Type::anyref:
          case Type::eqref:
          case Type::i31ref:
          case Type::dataref:
          case Type::none:
          case Type::unreachable:
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
        switch (type.getBasic()) {
          case Type::i32:
            return Literal(int32_t(small));
          case Type::i64:
            return Literal(int64_t(small));
          case Type::f32:
            return Literal(float(small));
          case Type::f64:
            return Literal(double(small));
          case Type::v128:
          case Type::funcref:
          case Type::externref:
          case Type::anyref:
          case Type::eqref:
          case Type::i31ref:
          case Type::dataref:
          case Type::none:
          case Type::unreachable:
            WASM_UNREACHABLE("unexpected type");
        }
        break;
      }
      case 2: {
        // special values
        Literal value;
        switch (type.getBasic()) {
          case Type::i32:
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
          case Type::i64:
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
          case Type::f32:
            value = Literal(pick<float>(0.0f,
                                        -0.0f,
                                        std::numeric_limits<float>::min(),
                                        std::numeric_limits<float>::max(),
                                        std::numeric_limits<int32_t>::min(),
                                        std::numeric_limits<int32_t>::max(),
                                        std::numeric_limits<int64_t>::min(),
                                        std::numeric_limits<int64_t>::max(),
                                        std::numeric_limits<uint32_t>::max(),
                                        std::numeric_limits<uint64_t>::max()));
            break;
          case Type::f64:
            value = Literal(pick<double>(0.0,
                                         -0.0,
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
          case Type::v128:
          case Type::funcref:
          case Type::externref:
          case Type::anyref:
          case Type::eqref:
          case Type::i31ref:
          case Type::dataref:
          case Type::none:
          case Type::unreachable:
            WASM_UNREACHABLE("unexpected type");
        }
        return tweak(value);
      }
      case 3: {
        // powers of 2
        Literal value;
        switch (type.getBasic()) {
          case Type::i32:
            value = Literal(int32_t(1) << upTo(32));
            break;
          case Type::i64:
            value = Literal(int64_t(1) << upTo(64));
            break;
          case Type::f32:
            value = Literal(float(int64_t(1) << upTo(64)));
            break;
          case Type::f64:
            value = Literal(double(int64_t(1) << upTo(64)));
            break;
          case Type::v128:
          case Type::funcref:
          case Type::externref:
          case Type::anyref:
          case Type::eqref:
          case Type::i31ref:
          case Type::dataref:
          case Type::none:
          case Type::unreachable:
            WASM_UNREACHABLE("unexpected type");
        }
        return tweak(value);
      }
    }
    WASM_UNREACHABLE("invalid value");
  }

  Expression* makeConst(Type type) {
    if (type.isRef()) {
      assert(wasm.features.hasReferenceTypes());
      // Check if we can use ref.func.
      // 'func' is the pointer to the last created function and can be null when
      // we set up globals (before we create any functions), in which case we
      // can't use ref.func.
      if (type == Type::funcref && funcContext && oneIn(2)) {
        // First set to target to the last created function, and try to select
        // among other existing function if possible
        Function* target = funcContext->func;
        if (!wasm.functions.empty() && !oneIn(wasm.functions.size())) {
          target = pick(wasm.functions).get();
        }
        auto type = Type(HeapType(target->sig), Nullable);
        return builder.makeRefFunc(target->name, type);
      }
      if (type == Type::i31ref) {
        return builder.makeI31New(makeConst(Type::i32));
      }
      if (oneIn(2) && type.isNullable()) {
        return builder.makeRefNull(type);
      }
      if (type == Type::dataref) {
        WASM_UNREACHABLE("TODO: dataref");
      }
      // TODO: randomize the order
      for (auto& func : wasm.functions) {
        // FIXME: RefFunc type should be non-nullable, but we emit nullable
        //        types for now.
        if (type == Type(HeapType(func->sig), Nullable)) {
          return builder.makeRefFunc(func->name, type);
        }
      }
      // We failed to find a function, so create a null reference if we can.
      if (type.isNullable()) {
        return builder.makeRefNull(type);
      }
      // Last resort: create a function.
      auto* func = wasm.addFunction(builder.makeFunction(
        Names::getValidFunctionName(wasm, "ref_func_target"),
        type.getHeapType().getSignature(),
        {},
        builder.makeUnreachable()));
      return builder.makeRefFunc(func->name, type);
    }
    if (type.isRtt()) {
      Expression* ret = builder.makeRttCanon(type.getHeapType());
      if (type.getRtt().hasDepth()) {
        for (Index i = 0; i < type.getRtt().depth; i++) {
          ret = builder.makeRttSub(type.getHeapType(), ret);
        }
      }
      return ret;
    }
    if (type.isTuple()) {
      std::vector<Expression*> operands;
      for (const auto& t : type) {
        operands.push_back(makeConst(t));
      }
      return builder.makeTupleMake(std::move(operands));
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
    assert(!type.isTuple());
    if (type == Type::unreachable) {
      if (auto* unary = makeUnary(getSingleConcreteType())->dynCast<Unary>()) {
        return builder.makeUnary(unary->op, make(Type::unreachable));
      }
      // give up
      return makeTrivial(type);
    }
    // There are no unary ops for reference or RTT types.
    if (type.isRef() || type.isRtt()) {
      return makeTrivial(type);
    }
    switch (type.getBasic()) {
      case Type::i32: {
        auto singleConcreteType = getSingleConcreteType();
        TODO_SINGLE_COMPOUND(singleConcreteType);
        switch (singleConcreteType.getBasic()) {
          case Type::i32: {
            auto op = pick(
              FeatureOptions<UnaryOp>()
                .add(FeatureSet::MVP, EqZInt32, ClzInt32, CtzInt32, PopcntInt32)
                .add(FeatureSet::SignExt, ExtendS8Int32, ExtendS16Int32));
            return buildUnary({op, make(Type::i32)});
          }
          case Type::i64:
            return buildUnary({pick(EqZInt64, WrapInt64), make(Type::i64)});
          case Type::f32: {
            auto op = pick(FeatureOptions<UnaryOp>()
                             .add(FeatureSet::MVP,
                                  TruncSFloat32ToInt32,
                                  TruncUFloat32ToInt32,
                                  ReinterpretFloat32)
                             .add(FeatureSet::TruncSat,
                                  TruncSatSFloat32ToInt32,
                                  TruncSatUFloat32ToInt32));
            return buildUnary({op, make(Type::f32)});
          }
          case Type::f64: {
            auto op = pick(FeatureOptions<UnaryOp>()
                             .add(FeatureSet::MVP,
                                  TruncSFloat64ToInt32,
                                  TruncUFloat64ToInt32)
                             .add(FeatureSet::TruncSat,
                                  TruncSatSFloat64ToInt32,
                                  TruncSatUFloat64ToInt32));
            return buildUnary({op, make(Type::f64)});
          }
          case Type::v128: {
            assert(wasm.features.hasSIMD());
            return buildUnary({pick(AnyTrueVecI8x16,
                                    AllTrueVecI8x16,
                                    AnyTrueVecI16x8,
                                    AllTrueVecI16x8,
                                    AnyTrueVecI32x4,
                                    AllTrueVecI32x4),
                               make(Type::v128)});
          }
          case Type::funcref:
          case Type::externref:
          case Type::anyref:
          case Type::eqref:
          case Type::i31ref:
          case Type::dataref:
            return makeTrivial(type);
          case Type::none:
          case Type::unreachable:
            WASM_UNREACHABLE("unexpected type");
        }
        WASM_UNREACHABLE("invalid type");
      }
      case Type::i64: {
        switch (upTo(4)) {
          case 0: {
            auto op =
              pick(FeatureOptions<UnaryOp>()
                     .add(FeatureSet::MVP, ClzInt64, CtzInt64, PopcntInt64)
                     .add(FeatureSet::SignExt,
                          ExtendS8Int64,
                          ExtendS16Int64,
                          ExtendS32Int64));
            return buildUnary({op, make(Type::i64)});
          }
          case 1:
            return buildUnary(
              {pick(ExtendSInt32, ExtendUInt32), make(Type::i32)});
          case 2: {
            auto op = pick(FeatureOptions<UnaryOp>()
                             .add(FeatureSet::MVP,
                                  TruncSFloat32ToInt64,
                                  TruncUFloat32ToInt64)
                             .add(FeatureSet::TruncSat,
                                  TruncSatSFloat32ToInt64,
                                  TruncSatUFloat32ToInt64));
            return buildUnary({op, make(Type::f32)});
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
            return buildUnary({op, make(Type::f64)});
          }
        }
        WASM_UNREACHABLE("invalid value");
      }
      case Type::f32: {
        switch (upTo(4)) {
          case 0:
            return buildUnary({pick(NegFloat32,
                                    AbsFloat32,
                                    CeilFloat32,
                                    FloorFloat32,
                                    TruncFloat32,
                                    NearestFloat32,
                                    SqrtFloat32),
                               make(Type::f32)});
          case 1:
            return buildUnary({pick(ConvertUInt32ToFloat32,
                                    ConvertSInt32ToFloat32,
                                    ReinterpretInt32),
                               make(Type::i32)});
          case 2:
            return buildUnary(
              {pick(ConvertUInt64ToFloat32, ConvertSInt64ToFloat32),
               make(Type::i64)});
          case 3:
            return buildUnary({DemoteFloat64, make(Type::f64)});
        }
        WASM_UNREACHABLE("invalid value");
      }
      case Type::f64: {
        switch (upTo(4)) {
          case 0:
            return buildUnary({pick(NegFloat64,
                                    AbsFloat64,
                                    CeilFloat64,
                                    FloorFloat64,
                                    TruncFloat64,
                                    NearestFloat64,
                                    SqrtFloat64),
                               make(Type::f64)});
          case 1:
            return buildUnary(
              {pick(ConvertUInt32ToFloat64, ConvertSInt32ToFloat64),
               make(Type::i32)});
          case 2:
            return buildUnary({pick(ConvertUInt64ToFloat64,
                                    ConvertSInt64ToFloat64,
                                    ReinterpretInt64),
                               make(Type::i64)});
          case 3:
            return buildUnary({PromoteFloat32, make(Type::f32)});
        }
        WASM_UNREACHABLE("invalid value");
      }
      case Type::v128: {
        assert(wasm.features.hasSIMD());
        switch (upTo(5)) {
          case 0:
            return buildUnary(
              {pick(SplatVecI8x16, SplatVecI16x8, SplatVecI32x4),
               make(Type::i32)});
          case 1:
            return buildUnary({SplatVecI64x2, make(Type::i64)});
          case 2:
            return buildUnary({SplatVecF32x4, make(Type::f32)});
          case 3:
            return buildUnary({SplatVecF64x2, make(Type::f64)});
          case 4:
            return buildUnary({pick(NotVec128,
                                    // TODO: i8x16.popcnt once merged
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
                               make(Type::v128)});
        }
        WASM_UNREACHABLE("invalid value");
      }
      case Type::funcref:
      case Type::externref:
      case Type::anyref:
      case Type::eqref:
      case Type::i31ref:
      case Type::dataref:
      case Type::none:
      case Type::unreachable:
        WASM_UNREACHABLE("unexpected type");
    }
    WASM_UNREACHABLE("invalid type");
  }

  Expression* buildBinary(const BinaryArgs& args) {
    return builder.makeBinary(args.a, args.b, args.c);
  }

  Expression* makeBinary(Type type) {
    assert(!type.isTuple());
    if (type == Type::unreachable) {
      if (auto* binary =
            makeBinary(getSingleConcreteType())->dynCast<Binary>()) {
        return buildBinary(
          {binary->op, make(Type::unreachable), make(Type::unreachable)});
      }
      // give up
      return makeTrivial(type);
    }
    // There are no binary ops for reference or RTT types.
    if (type.isRef() || type.isRtt()) {
      return makeTrivial(type);
    }
    switch (type.getBasic()) {
      case Type::i32: {
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
                                make(Type::i32),
                                make(Type::i32)});
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
                                make(Type::i64),
                                make(Type::i64)});
          case 2:
            return buildBinary({pick(EqFloat32,
                                     NeFloat32,
                                     LtFloat32,
                                     LeFloat32,
                                     GtFloat32,
                                     GeFloat32),
                                make(Type::f32),
                                make(Type::f32)});
          case 3:
            return buildBinary({pick(EqFloat64,
                                     NeFloat64,
                                     LtFloat64,
                                     LeFloat64,
                                     GtFloat64,
                                     GeFloat64),
                                make(Type::f64),
                                make(Type::f64)});
        }
        WASM_UNREACHABLE("invalid value");
      }
      case Type::i64: {
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
                            make(Type::i64),
                            make(Type::i64)});
      }
      case Type::f32: {
        return buildBinary({pick(AddFloat32,
                                 SubFloat32,
                                 MulFloat32,
                                 DivFloat32,
                                 CopySignFloat32,
                                 MinFloat32,
                                 MaxFloat32),
                            make(Type::f32),
                            make(Type::f32)});
      }
      case Type::f64: {
        return buildBinary({pick(AddFloat64,
                                 SubFloat64,
                                 MulFloat64,
                                 DivFloat64,
                                 CopySignFloat64,
                                 MinFloat64,
                                 MaxFloat64),
                            make(Type::f64),
                            make(Type::f64)});
      }
      case Type::v128: {
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
                                 // TODO: avgr_u
                                 // TODO: q15mulr_sat_s
                                 // TODO: extmul
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
                            make(Type::v128),
                            make(Type::v128)});
      }
      case Type::funcref:
      case Type::externref:
      case Type::anyref:
      case Type::eqref:
      case Type::i31ref:
      case Type::dataref:
      case Type::none:
      case Type::unreachable:
        WASM_UNREACHABLE("unexpected type");
    }
    WASM_UNREACHABLE("invalid type");
  }

  Expression* buildSelect(const ThreeArgs& args, Type type) {
    return builder.makeSelect(args.a, args.b, args.c, type);
  }

  Expression* makeSelect(Type type) {
    Type subType1 = getSubType(type);
    Type subType2 = getSubType(type);
    return buildSelect({make(Type::i32), make(subType1), make(subType2)}, type);
  }

  Expression* makeSwitch(Type type) {
    assert(type == Type::unreachable);
    if (funcContext->breakableStack.empty()) {
      return make(type);
    }
    // we need to find proper targets to break to; try a bunch
    int tries = TRIES;
    std::vector<Name> names;
    Type valueType = Type::unreachable;
    while (tries-- > 0) {
      auto* target = pick(funcContext->breakableStack);
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
    auto temp1 = make(Type::i32),
         temp2 = valueType.isConcrete() ? make(valueType) : nullptr;
    return builder.makeSwitch(names, default_, temp1, temp2);
  }

  Expression* makeDrop(Type type) {
    return builder.makeDrop(
      make(type == Type::unreachable ? type : getConcreteType()));
  }

  Expression* makeReturn(Type type) {
    return builder.makeReturn(funcContext->func->sig.results.isConcrete()
                                ? make(funcContext->func->sig.results)
                                : nullptr);
  }

  Expression* makeNop(Type type) {
    assert(type == Type::none);
    return builder.makeNop();
  }

  Expression* makeUnreachable(Type type) {
    assert(type == Type::unreachable);
    return builder.makeUnreachable();
  }

  Expression* makeAtomic(Type type) {
    assert(wasm.features.hasAtomics());
    if (!allowMemory) {
      return makeTrivial(type);
    }
    wasm.memory.shared = true;
    if (type == Type::none) {
      return builder.makeAtomicFence();
    }
    if (type == Type::i32 && oneIn(2)) {
      if (ATOMIC_WAITS && oneIn(2)) {
        auto* ptr = makePointer();
        auto expectedType = pick(Type::i32, Type::i64);
        auto* expected = make(expectedType);
        auto* timeout = make(Type::i64);
        return builder.makeAtomicWait(
          ptr, expected, timeout, expectedType, logify(get()));
      } else {
        auto* ptr = makePointer();
        auto* count = make(Type::i32);
        return builder.makeAtomicNotify(ptr, count, logify(get()));
      }
    }
    Index bytes;
    switch (type.getBasic()) {
      case Type::i32: {
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
      case Type::i64: {
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
      return builder.makeAtomicRMW(
        pick(RMWAdd, RMWSub, RMWAnd, RMWOr, RMWXor, RMWXchg),
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
    if (type.isRef()) {
      return makeTrivial(type);
    }
    if (type != Type::v128) {
      return makeSIMDExtract(type);
    }
    // TODO: Add SIMDLoadStoreLane once it is generally available
    switch (upTo(7)) {
      case 0:
        return makeUnary(Type::v128);
      case 1:
        return makeBinary(Type::v128);
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
    switch (type.getBasic()) {
      case Type::i32:
        op = pick(ExtractLaneSVecI8x16,
                  ExtractLaneUVecI8x16,
                  ExtractLaneSVecI16x8,
                  ExtractLaneUVecI16x8,
                  ExtractLaneVecI32x4);
        break;
      case Type::i64:
        op = ExtractLaneVecI64x2;
        break;
      case Type::f32:
        op = ExtractLaneVecF32x4;
        break;
      case Type::f64:
        op = ExtractLaneVecF64x2;
        break;
      case Type::v128:
      case Type::funcref:
      case Type::externref:
      case Type::anyref:
      case Type::eqref:
      case Type::i31ref:
      case Type::dataref:
      case Type::none:
      case Type::unreachable:
        WASM_UNREACHABLE("unexpected type");
    }
    Expression* vec = make(Type::v128);
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
    Expression* vec = make(Type::v128);
    uint8_t index;
    Type lane_t;
    switch (op) {
      case ReplaceLaneVecI8x16:
        index = upTo(16);
        lane_t = Type::i32;
        break;
      case ReplaceLaneVecI16x8:
        index = upTo(8);
        lane_t = Type::i32;
        break;
      case ReplaceLaneVecI32x4:
        index = upTo(4);
        lane_t = Type::i32;
        break;
      case ReplaceLaneVecI64x2:
        index = upTo(2);
        lane_t = Type::i64;
        break;
      case ReplaceLaneVecF32x4:
        index = upTo(4);
        lane_t = Type::f32;
        break;
      case ReplaceLaneVecF64x2:
        index = upTo(2);
        lane_t = Type::f64;
        break;
      default:
        WASM_UNREACHABLE("unexpected op");
    }
    Expression* value = make(lane_t);
    return builder.makeSIMDReplace(op, vec, index, value);
  }

  Expression* makeSIMDShuffle() {
    Expression* left = make(Type::v128);
    Expression* right = make(Type::v128);
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
    Expression* a = make(Type::v128);
    Expression* b = make(Type::v128);
    Expression* c = make(Type::v128);
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
    Expression* vec = make(Type::v128);
    Expression* shift = make(Type::i32);
    return builder.makeSIMDShift(op, vec, shift);
  }

  Expression* makeSIMDLoad() {
    // TODO: add Load{32,64}Zero if merged to proposal
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
      case Load32Zero:
      case Load64Zero:
        WASM_UNREACHABLE("Unexpected SIMD loads");
    }
    Expression* ptr = makePointer();
    return builder.makeSIMDLoad(op, offset, align, ptr);
  }

  Expression* makeBulkMemory(Type type) {
    if (!allowMemory) {
      return makeTrivial(type);
    }
    assert(wasm.features.hasBulkMemory());
    assert(type == Type::none);
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

  // TODO: support other RefIs variants, and rename this
  Expression* makeRefIsNull(Type type) {
    assert(type == Type::i32);
    assert(wasm.features.hasReferenceTypes());
    return builder.makeRefIs(RefIsNull, make(getReferenceType()));
  }

  Expression* makeRefEq(Type type) {
    assert(type == Type::i32);
    assert(wasm.features.hasReferenceTypes() && wasm.features.hasGC());
    auto* left = make(getEqReferenceType());
    auto* right = make(getEqReferenceType());
    return builder.makeRefEq(left, right);
  }

  Expression* makeI31New(Type type) {
    assert(type == Type::i31ref);
    assert(wasm.features.hasReferenceTypes() && wasm.features.hasGC());
    auto* value = make(Type::i32);
    return builder.makeI31New(value);
  }

  Expression* makeI31Get(Type type) {
    assert(type == Type::i32);
    assert(wasm.features.hasReferenceTypes() && wasm.features.hasGC());
    auto* i31 = make(Type::i31ref);
    return builder.makeI31Get(i31, bool(oneIn(2)));
  }

  Expression* makeMemoryInit() {
    if (!allowMemory) {
      return makeTrivial(Type::none);
    }
    uint32_t segment = upTo(wasm.memory.segments.size());
    size_t totalSize = wasm.memory.segments[segment].data.size();
    size_t offsetVal = upTo(totalSize);
    size_t sizeVal = upTo(totalSize - offsetVal);
    Expression* dest = makePointer();
    Expression* offset = builder.makeConst(int32_t(offsetVal));
    Expression* size = builder.makeConst(int32_t(sizeVal));
    return builder.makeMemoryInit(segment, dest, offset, size);
  }

  Expression* makeDataDrop() {
    if (!allowMemory) {
      return makeTrivial(Type::none);
    }
    return builder.makeDataDrop(upTo(wasm.memory.segments.size()));
  }

  Expression* makeMemoryCopy() {
    if (!allowMemory) {
      return makeTrivial(Type::none);
    }
    Expression* dest = makePointer();
    Expression* source = makePointer();
    Expression* size = make(wasm.memory.indexType);
    return builder.makeMemoryCopy(dest, source, size);
  }

  Expression* makeMemoryFill() {
    if (!allowMemory) {
      return makeTrivial(Type::none);
    }
    Expression* dest = makePointer();
    Expression* value = make(Type::i32);
    Expression* size = make(wasm.memory.indexType);
    return builder.makeMemoryFill(dest, value, size);
  }

  // special makers

  Expression* makeLogging() {
    auto type = getLoggableType();
    return builder.makeCall(
      std::string("log-") + type.toString(), {make(type)}, Type::none);
  }

  Expression* makeMemoryHashLogging() {
    auto* hash = builder.makeCall(std::string("hashMemory"), {}, Type::i32);
    return builder.makeCall(std::string("log-i32"), {hash}, Type::none);
  }

  // special getters
  std::vector<Type> getSingleConcreteTypes() {
    return items(
      FeatureOptions<Type>()
        .add(FeatureSet::MVP, Type::i32, Type::i64, Type::f32, Type::f64)
        .add(FeatureSet::SIMD, Type::v128)
        .add(FeatureSet::ReferenceTypes, Type::funcref, Type::externref)
        .add(FeatureSet::ReferenceTypes | FeatureSet::GC,
             Type::anyref,
             Type::eqref));
    // TODO: emit typed function references types
    // TODO: i31ref, dataref
  }

  Type getSingleConcreteType() { return pick(getSingleConcreteTypes()); }

  std::vector<Type> getReferenceTypes() {
    return items(
      FeatureOptions<Type>()
        .add(FeatureSet::ReferenceTypes, Type::funcref, Type::externref)
        .add(FeatureSet::ReferenceTypes | FeatureSet::GC,
             Type::anyref,
             Type::eqref));
    // TODO: i31ref, dataref
  }

  Type getReferenceType() { return pick(getReferenceTypes()); }

  std::vector<Type> getEqReferenceTypes() {
    return items(FeatureOptions<Type>().add(
      FeatureSet::ReferenceTypes | FeatureSet::GC, Type::eqref));
    // TODO: i31ref, dataref
  }

  Type getEqReferenceType() { return pick(getEqReferenceTypes()); }

  Type getMVPType() {
    return pick(items(FeatureOptions<Type>().add(
      FeatureSet::MVP, Type::i32, Type::i64, Type::f32, Type::f64)));
  }

  Type getTupleType() {
    std::vector<Type> elements;
    size_t maxElements = 2 + upTo(MAX_TUPLE_SIZE - 1);
    for (size_t i = 0; i < maxElements; ++i) {
      auto type = getSingleConcreteType();
      // Don't add a non-nullable type into a tuple, as currently we can't spill
      // them into locals (that would require a "let").
      if (!type.isNullable()) {
        elements.push_back(type);
      }
    }
    while (elements.size() < 2) {
      elements.push_back(getMVPType());
    }
    return Type(elements);
  }

  Type getConcreteType() {
    if (wasm.features.hasMultivalue() && oneIn(5)) {
      return getTupleType();
    } else {
      return getSingleConcreteType();
    }
  }

  Type getControlFlowType() {
    if (oneIn(10)) {
      return Type::none;
    } else {
      return getConcreteType();
    }
  }

  Type getStorableType() {
    return pick(
      FeatureOptions<Type>()
        .add(FeatureSet::MVP, Type::i32, Type::i64, Type::f32, Type::f64)
        .add(FeatureSet::SIMD, Type::v128));
  }

  // - funcref cannot be logged because referenced functions can be inlined or
  // removed during optimization
  // - there's no point in logging externref or anyref because these are opaque
  // - don't bother logging tuples
  std::vector<Type> loggableTypes;

  const std::vector<Type>& getLoggableTypes() {
    if (loggableTypes.empty()) {
      loggableTypes = items(
        FeatureOptions<Type>()
          .add(FeatureSet::MVP, Type::i32, Type::i64, Type::f32, Type::f64)
          .add(FeatureSet::SIMD, Type::v128));
    }
    return loggableTypes;
  }

  Type getLoggableType() { return pick(getLoggableTypes()); }

  bool isLoggableType(Type type) {
    const auto& types = getLoggableTypes();
    return std::find(types.begin(), types.end(), type) != types.end();
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

  // pick from a vector-like container
  template<typename T> const typename T::value_type& pick(const T& vec) {
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
    FeatureOptions<T>& add(FeatureSet feature, T option, Ts... rest) {
      options[feature].push_back(option);
      return add(feature, rest...);
    }

    struct WeightedOption {
      T option;
      size_t weight;
    };

    template<typename... Ts>
    FeatureOptions<T>&
    add(FeatureSet feature, WeightedOption weightedOption, Ts... rest) {
      for (size_t i = 0; i < weightedOption.weight; i++) {
        options[feature].push_back(weightedOption.option);
      }
      return add(feature, rest...);
    }

    FeatureOptions<T>& add(FeatureSet feature) { return *this; }

    std::map<FeatureSet, std::vector<T>> options;
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
      return Type::none;
    }
    WASM_UNREACHABLE("unexpected expr type");
  }
};

} // namespace wasm

// XXX Switch class has a condition?! is it real? should the node type be the
// value type if it exists?!

// TODO copy an existing function and replace just one node in it
