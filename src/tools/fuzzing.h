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

#include "ir/branch-utils.h"
#include "ir/memory-utils.h"
#include "support/insert_ordered.h"
#include "tools/fuzzing/random.h"
#include <ir/eh-utils.h>
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
  TranslateToFuzzReader(Module& wasm, std::vector<char>&& input);
  TranslateToFuzzReader(Module& wasm, std::string& filename);

  void pickPasses(OptimizationOptions& options);
  void setAllowMemory(bool allowMemory_) { allowMemory = allowMemory_; }
  void setAllowOOB(bool allowOOB_) { allowOOB = allowOOB_; }

  void build();

  Module& wasm;

private:
  Builder builder;
  Random random;

  // Whether to emit memory operations like loads and stores.
  bool allowMemory = true;

  // Whether to emit loads, stores, and call_indirects that may be out
  // of bounds (which traps in wasm, and is undefined behavior in C).
  bool allowOOB = true;

  // Whether to emit atomic waits (which in single-threaded mode, may hang...)
  static const bool ATOMIC_WAITS = false;

  // The chance to emit a logging operation for a none expression. We
  // randomize this in each function.
  unsigned LOGGING_PERCENT = 0;

  Name HANG_LIMIT_GLOBAL;

  Name funcrefTableName;

  std::unordered_map<Type, std::vector<Name>> globalsByType;

  std::vector<Type> loggableTypes;

  Index numAddedFunctions = 0;

  // RAII helper for managing the state used to create a single function.
  struct FunctionCreationContext {
    TranslateToFuzzReader& parent;
    Function* func;
    std::vector<Expression*> breakableStack; // things we can break to
    Index labelIndex = 0;

    // a list of things relevant to computing the odds of an infinite loop,
    // which we try to minimize the risk of
    std::vector<Expression*> hangStack;

    // type => list of locals with that type
    std::unordered_map<Type, std::vector<Index>> typeLocals;

    FunctionCreationContext(TranslateToFuzzReader& parent, Function* func)
      : parent(parent), func(func) {
      parent.funcContext = this;
    }

    ~FunctionCreationContext();
  };

  FunctionCreationContext* funcContext = nullptr;

  int nesting = 0;

  // Generating random data is common enough that it's worth having helpers that
  // forward to `random`.
  int8_t get() { return random.get(); }
  int16_t get16() { return random.get16(); }
  int32_t get32() { return random.get32(); }
  int64_t get64() { return random.get64(); }
  float getFloat() { return random.getFloat(); }
  double getDouble() { return random.getDouble(); }
  Index upTo(Index x) { return random.upTo(x); }
  bool oneIn(Index x) { return random.oneIn(x); }
  Index upToSquared(Index x) { return random.upToSquared(x); }

  // Pick from a vector-like container or a fixed list.
  template<typename T> const typename T::value_type& pick(const T& vec) {
    return random.pick(vec);
  }
  template<typename T, typename... Args> T pick(T first, Args... args) {
    return random.pick(first, args...);
  }
  // Pick from options associated with features.
  template<typename T> using FeatureOptions = Random::FeatureOptions<T>;
  template<typename T> const T pick(FeatureOptions<T>& picker) {
    return random.pick(picker);
  }

  // Setup methods
  void setupMemory();
  void setupHeapTypes();
  void setupTables();
  void setupGlobals();
  void setupTags();
  void finalizeMemory();
  void finalizeTable();
  void prepareHangLimitSupport();
  void addHangLimitSupport();
  void addImportLoggingSupport();

  // Special expression makers
  Expression* makeHangLimitCheck();
  Expression* makeLogging();
  Expression* makeMemoryHashLogging();

  // Function creation
  Function* addFunction();
  void addHangLimitChecks(Function* func);

  // Recombination and mutation

  // Recombination and mutation can replace a node with another node of the same
  // type, but should not do so for certain types that are dangerous. For
  // example, it would be bad to add a non-nullable reference to a tuple, as
  // that would force us to use temporary locals for the tuple, but non-nullable
  // references cannot always be stored in locals. Also, the 'pop' pseudo
  // instruction for EH is supposed to exist only at the beginning of a 'catch'
  // block, so it shouldn't be moved around or deleted freely.
  bool canBeArbitrarilyReplaced(Expression* curr) {
    return curr->type.isDefaultable() &&
           !EHUtils::containsValidDanglingPop(curr);
  }
  void recombine(Function* func);
  void mutate(Function* func);
  // Fix up changes that may have broken validation - types are correct in our
  // modding, but not necessarily labels.
  void fixLabels(Function* func);
  void modifyInitialFunctions();

  // Initial wasm contents may have come from a test that uses the drop pattern:
  //
  //  (drop ..something interesting..)
  //
  // The dropped interesting thing is optimized to some other interesting thing
  // by a pass, and we verify it is the expected one. But this does not use the
  // value in a way the fuzzer can notice. Replace some drops with a logging
  // operation instead.
  void dropToLog(Function* func);

  // the fuzzer external interface sends in zeros (simpler to compare
  // across invocations from JS or wasm-opt etc.). Add invocations in
  // the wasm, so they run everywhere
  void addInvocations(Function* func);

  Name makeLabel() {
    return std::string("label$") + std::to_string(funcContext->labelIndex++);
  }

  // Expression making methods. Always call the toplevel make(type) command, not
  // the specific ones.
  Expression* make(Type type);
  Expression* _makeConcrete(Type type);
  Expression* _makenone();
  Expression* _makeunreachable();

  // Make something with no chance of infinite recursion.
  Expression* makeTrivial(Type type);

  // Specific expression creators
  Expression* makeBlock(Type type);
  Expression* makeLoop(Type type);
  Expression* makeCondition();
  // Make something, with a good chance of it being a block
  Expression* makeMaybeBlock(Type type);
  Expression* buildIf(const struct ThreeArgs& args, Type type);
  Expression* makeIf(Type type);
  Expression* makeBreak(Type type);
  Expression* makeCall(Type type);
  Expression* makeCallIndirect(Type type);
  Expression* makeCallRef(Type type);
  Expression* makeLocalGet(Type type);
  Expression* makeLocalSet(Type type);
  // Some globals are for internal use, and should not be modified by random
  // fuzz code.
  bool isValidGlobal(Name name);

  Expression* makeGlobalGet(Type type);
  Expression* makeGlobalSet(Type type);
  Expression* makeTupleMake(Type type);
  Expression* makeTupleExtract(Type type);
  Expression* makePointer();
  Expression* makeNonAtomicLoad(Type type);
  Expression* makeLoad(Type type);
  Expression* makeNonAtomicStore(Type type);
  Expression* makeStore(Type type);
  // Makes a small change to a constant value.
  Literal tweak(Literal value);
  Literal makeLiteral(Type type);
  Expression* makeRefFuncConst(Type type);

  // Emit a constant expression for a given type, as best we can. We may not be
  // able to emit a literal Const, like say if the type is a function reference
  // then we may emit a RefFunc, but also we may have other requirements, like
  // we may add a GC cast to fixup the type.
  Expression* makeConst(Type type);

  // Like makeConst, but for a type that is a reference type. One function
  // handles basic types, and the other compound ones.
  Expression* makeConstBasicRef(Type type);
  Expression* makeConstCompoundRef(Type type);

  Expression* buildUnary(const UnaryArgs& args);
  Expression* makeUnary(Type type);
  Expression* buildBinary(const BinaryArgs& args);
  Expression* makeBinary(Type type);
  Expression* buildSelect(const ThreeArgs& args, Type type);
  Expression* makeSelect(Type type);
  Expression* makeSwitch(Type type);
  Expression* makeDrop(Type type);
  Expression* makeReturn(Type type);
  Expression* makeNop(Type type);
  Expression* makeUnreachable(Type type);
  Expression* makeAtomic(Type type);
  Expression* makeSIMD(Type type);
  Expression* makeSIMDExtract(Type type);
  Expression* makeSIMDReplace();
  Expression* makeSIMDShuffle();
  Expression* makeSIMDTernary();
  Expression* makeSIMDShift();
  Expression* makeSIMDLoad();
  Expression* makeBulkMemory(Type type);
  // TODO: support other RefIs variants, and rename this
  Expression* makeRefIsNull(Type type);
  Expression* makeRefEq(Type type);
  Expression* makeI31New(Type type);
  Expression* makeI31Get(Type type);
  Expression* makeMemoryInit();
  Expression* makeDataDrop();
  Expression* makeMemoryCopy();
  Expression* makeMemoryFill();

  // Getters for Types
  Type getSingleConcreteType();
  Type getReferenceType();
  Type getEqReferenceType();
  Type getMVPType();
  Type getTupleType();
  Type getConcreteType();
  Type getControlFlowType();
  Type getStorableType();
  Type getLoggableType();
  bool isLoggableType(Type type);
  Nullability getSubType(Nullability nullability);
  HeapType getSubType(HeapType type);
  Type getSubType(Type type);

  // Utilities
  Name getTargetName(Expression* target);
  Type getTargetType(Expression* target);

  // statistical distributions

  // 0 to the limit, logarithmic scale
  Index logify(Index x) {
    return std::floor(std::log(std::max(Index(1) + x, Index(1))));
  }
};

} // namespace wasm

// XXX Switch class has a condition?! is it real? should the node type be the
// value type if it exists?!

// TODO copy an existing function and replace just one node in it
