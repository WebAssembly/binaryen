/*
 * Copyright 2018 WebAssembly Community Group participants
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

#ifndef wasm_stack_h
#define wasm_stack_h

#include "ir/branch-utils.h"
#include "ir/module-utils.h"
#include "ir/properties.h"
#include "pass.h"
#include "support/insert_ordered.h"
#include "wasm-binary.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

// Stack IR: an IR that represents code at the wasm binary format level,
// that is, a stack machine. Binaryen IR is *almost* identical to this,
// but as documented in README.md, there are a few differences, intended
// to make Binaryen IR fast and flexible for maximal optimization. Stack
// IR, on the other hand, is designed to optimize a few final things that
// can only really be done when modeling the stack machine format precisely.

// Currently the benefits of Stack IR are minor, less than 1% reduction in
// code size. For that reason it is just a secondary IR, run optionally
// after the main IR has been optimized. However, if we improve Stack IR
// optimizations to a point where they have a significant impact, it's
// possible that could motivate investigating replacing the main IR with Stack
// IR (so that we have just a single IR).

// A StackIR instance (see wasm.h) contains a linear sequence of
// stack instructions. This representation is very simple: just a single vector
// of all instructions, in order.
//  * nullptr is allowed in the vector, representing something to skip.
//    This is useful as a common thing optimizations do is remove instructions,
//    so this way we can do so without compacting the vector all the time.

// Direct writing binaryen IR to binary is fast. Otherwise, StackIRGenerator
// lets you optimize the Stack IR before emitting stack IR to binary (but the
// cost is that the extra IR in the middle makes things 20% slower than emitting
// binaryen IR to binary directly).

// A Stack IR instruction. Most just directly reflect a Binaryen IR node,
// but we need extra ones for certain things.
class StackInst {
public:
  StackInst(MixedArena&) {}

  enum Op {
    Basic,         // an instruction directly corresponding to a
                   // non-control-flow Binaryen IR node
    BlockBegin,    // the beginning of a block
    BlockEnd,      // the ending of a block
    IfBegin,       // the beginning of a if
    IfElse,        // the else of a if
    IfEnd,         // the ending of a if
    LoopBegin,     // the beginning of a loop
    LoopEnd,       // the ending of a loop
    TryBegin,      // the beginning of a try
    Catch,         // the catch within a try
    CatchAll,      // the catch_all within a try
    Delegate,      // the delegate within a try
    TryEnd,        // the ending of a try
    TryTableBegin, // the beginning of a try_table
    TryTableEnd    // the ending of a try_table
  } op;

  Expression* origin; // the expression this originates from

  // the type - usually identical to the origin type, but e.g. wasm has no
  // unreachable blocks, they must be none
  Type type;
};

using StackIR = std::vector<StackInst*>;

class BinaryInstWriter : public OverriddenVisitor<BinaryInstWriter> {
public:
  BinaryInstWriter(WasmBinaryWriter& parent,
                   BufferWithRandomAccess& o,
                   Function* func,
                   bool sourceMap,
                   bool DWARF)
    : parent(parent), o(o), func(func), sourceMap(sourceMap), DWARF(DWARF) {}

  void visit(Expression* curr) {
    if (func && !sourceMap) {
      parent.writeDebugLocation(curr, func);
    }
    OverriddenVisitor<BinaryInstWriter>::visit(curr);
    if (func && !sourceMap) {
      parent.writeDebugLocationEnd(curr, func);
    }
  }

#define DELEGATE(CLASS_TO_VISIT)                                               \
  void visit##CLASS_TO_VISIT(CLASS_TO_VISIT* curr);

#include "wasm-delegations.def"

  void emitResultType(Type type);
  void emitIfElse(If* curr);
  void emitCatch(Try* curr, Index i);
  void emitCatchAll(Try* curr);
  void emitDelegate(Try* curr);
  // emit an end at the end of a block/loop/if/try
  void emitScopeEnd(Expression* curr);
  // emit an end at the end of a function
  void emitFunctionEnd();
  void emitUnreachable();
  void mapLocalsAndEmitHeader();

  MappedLocals mappedLocals;

private:
  void emitMemoryAccess(size_t alignment,
                        size_t bytes,
                        uint64_t offset,
                        Name memory);
  int32_t getBreakIndex(Name name);

  WasmBinaryWriter& parent;
  BufferWithRandomAccess& o;
  Function* func = nullptr;
  bool sourceMap;
  bool DWARF;

  std::vector<Name> breakStack;

  // The types of locals in the compact form, in order.
  std::vector<Type> localTypes;
  // type => number of locals of that type in the compact form
  std::unordered_map<Type, size_t> numLocalsByType;

  void noteLocalType(Type type, Index count = 1);

  // Keeps track of the binary index of the scratch locals used to lower
  // tuple.extract. If there are multiple scratch locals of the same type, they
  // are contiguous and this map holds the index of the first.
  InsertOrderedMap<Type, Index> scratchLocals;
  // Return the type and number of required scratch locals.
  InsertOrderedMap<Type, Index> countScratchLocals();

  // local.get, local.tee, and global.get expressions that will be followed by
  // tuple.extracts. We can optimize these by getting only the local for the
  // extracted index.
  std::unordered_map<Expression*, Index> extractedGets;

  // As an optimization, we do not need to use scratch locals for StringWTF16Get
  // and StringSliceWTF if their non-string operands are already LocalGets.
  // Record those LocalGets here.
  std::unordered_set<LocalGet*> deferredGets;

  // Track which br_ifs need handling of their output values, which is the case
  // when they have a value that is more refined than the wasm type system
  // allows atm (and they are not dropped, in which case the type would not
  // matter). See https://github.com/WebAssembly/binaryen/pull/6390 for more on
  // the difference. As a result of the difference, we will insert extra casts
  // to ensure validation in the wasm spec. The wasm spec will hopefully improve
  // to use the more refined type as well, which would remove the need for this
  // hack.
  //
  // Each br_if present as a key here is mapped to the unrefined type for it.
  // That is, the br_if has a type in Binaryen IR that is too refined, and the
  // map contains the unrefined one (which we need to know the local types, as
  // we'll stash the unrefined values and then cast them).
  std::unordered_map<Break*, Type> brIfsNeedingHandling;
};

// Takes binaryen IR and converts it to something else (binary or stack IR)
template<typename SubType>
class BinaryenIRWriter : public Visitor<BinaryenIRWriter<SubType>> {
public:
  BinaryenIRWriter(Function* func) : func(func) {}

  void write();

  // visits a node, emitting the proper code for it
  void visit(Expression* curr);

  void visitBlock(Block* curr);
  void visitIf(If* curr);
  void visitLoop(Loop* curr);
  void visitTry(Try* curr);
  void visitTryTable(TryTable* curr);

protected:
  Function* func = nullptr;

private:
  void emit(Expression* curr) { static_cast<SubType*>(this)->emit(curr); }
  void emitHeader() { static_cast<SubType*>(this)->emitHeader(); }
  void emitIfElse(If* curr) { static_cast<SubType*>(this)->emitIfElse(curr); }
  void emitCatch(Try* curr, Index i) {
    static_cast<SubType*>(this)->emitCatch(curr, i);
  }
  void emitCatchAll(Try* curr) {
    static_cast<SubType*>(this)->emitCatchAll(curr);
  }
  void emitDelegate(Try* curr) {
    static_cast<SubType*>(this)->emitDelegate(curr);
  }
  void emitScopeEnd(Expression* curr) {
    static_cast<SubType*>(this)->emitScopeEnd(curr);
  }
  void emitFunctionEnd() { static_cast<SubType*>(this)->emitFunctionEnd(); }
  void emitUnreachable() { static_cast<SubType*>(this)->emitUnreachable(); }
  void emitDebugLocation(Expression* curr) {
    static_cast<SubType*>(this)->emitDebugLocation(curr);
  }
  void visitPossibleBlockContents(Expression* curr);
};

template<typename SubType> void BinaryenIRWriter<SubType>::write() {
  assert(func && "BinaryenIRWriter: function is not set");
  emitHeader();
  visitPossibleBlockContents(func->body);
  emitFunctionEnd();
}

// Emits a node in a position that can contain a list of contents, like an if
// arm. This will emit the node, but if it is a block with no name, just emit
// its contents. This is ok to do because a list of contents is ok in the wasm
// binary format in such positions anyhow. When we read such code in Binaryen
// we will end up creating a block for it (note that while doing so we create a
// block without a name, since nothing branches to it, which makes it easy to
// handle in optimization passes and when writing the binary out again).
template<typename SubType>
void BinaryenIRWriter<SubType>::visitPossibleBlockContents(Expression* curr) {
  auto* block = curr->dynCast<Block>();
  // Even if the block has a name, check if the name is necessary (if it has no
  // uses, it is equivalent to not having one). Scanning the children of the
  // block means that this takes quadratic time, but it will be N^2 for a fairly
  // small N since the number of nested non-block control flow structures tends
  // to be very reasonable.
  if (!block || BranchUtils::BranchSeeker::has(block, block->name)) {
    visit(curr);
    return;
  }
  for (auto* child : block->list) {
    visit(child);
    // Since this child was unreachable, either this child or one of its
    // descendants was a source of unreachability that was actually
    // emitted. Subsequent children won't be reachable, so skip them.
    if (child->type == Type::unreachable) {
      break;
    }
  }
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visit(Expression* curr) {
  // We emit unreachable instructions that create unreachability, but not
  // unreachable instructions that just inherit unreachability from their
  // children, since the latter won't be reached. This (together with logic in
  // the control flow visitors) also ensures that the final instruction in each
  // unreachable block is a source of unreachability, which means we don't need
  // to emit an extra `unreachable` before the end of the block to prevent type
  // errors.
  bool hasUnreachableChild = false;
  for (auto* child : ValueChildIterator(curr)) {
    visit(child);
    if (child->type == Type::unreachable) {
      hasUnreachableChild = true;
      break;
    }
  }
  if (hasUnreachableChild) {
    // `curr` is not reachable, so don't emit it.
    return;
  }
  emitDebugLocation(curr);
  // Control flow requires special handling, but most instructions can be
  // emitted directly after their children.
  if (Properties::isControlFlowStructure(curr)) {
    Visitor<BinaryenIRWriter>::visit(curr);
  } else {
    emit(curr);
  }
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitBlock(Block* curr) {
  auto visitChildren = [this](Block* curr, Index from) {
    auto& list = curr->list;
    while (from < list.size()) {
      auto* child = list[from];
      visit(child);
      if (child->type == Type::unreachable) {
        break;
      }
      ++from;
    }
  };

  // A block with no name never needs to be emitted: we can just emit its
  // contents. In some cases that will end up as "stacky" code, which is valid
  // in wasm but not in Binaryen IR. This is similar to what we do in
  // visitPossibleBlockContents(), and like there, when we reload such a binary
  // we'll end up creating a block for it then.
  //
  // Note that in visitPossibleBlockContents() we also optimize the case of a
  // block with a name but the name actually has no uses - that handles more
  // cases, but it requires more work. It is reasonable to do it in
  // visitPossibleBlockContents() which handles the common cases of blocks that
  // are children of control flow structures (like an if arm); doing it here
  // would affect every block, including highly-nested block stacks, which would
  // end up as quadratic time. In optimized code the name will not exist if it's
  // not used anyhow, so a minor optimization for the unoptimized case that
  // leads to potential quadratic behavior is not worth it here.
  if (!curr->name.is()) {
    visitChildren(curr, 0);
    return;
  }

  auto afterChildren = [this](Block* curr) {
    emitScopeEnd(curr);
    if (curr->type == Type::unreachable) {
      // Since this block is unreachable, no instructions will be emitted after
      // it in its enclosing scope. That means that this block will be the last
      // instruction before the end of its parent scope, so its type must match
      // the type of its parent. But we don't have a concrete type for this
      // block and we don't know what type its parent expects, so we can't
      // ensure the types match. To work around this, we insert an `unreachable`
      // instruction after every unreachable control flow structure and depend
      // on its polymorphic behavior to paper over any type mismatches.
      emitUnreachable();
    }
  };

  // Handle very deeply nested blocks in the first position efficiently,
  // avoiding heavy recursion. We only start to do this if we see it will help
  // us (to avoid allocation of the vector).
  if (!curr->list.empty() && curr->list[0]->is<Block>()) {
    std::vector<Block*> parents;
    Block* child;
    while (!curr->list.empty() && (child = curr->list[0]->dynCast<Block>())) {
      parents.push_back(curr);
      emit(curr);
      curr = child;
      emitDebugLocation(curr);
    }
    // Emit the current block, which does not have a block as a child in the
    // first position.
    emit(curr);
    visitChildren(curr, 0);
    afterChildren(curr);
    bool childUnreachable = curr->type == Type::unreachable;
    // Finish the later parts of all the parent blocks.
    while (!parents.empty()) {
      auto* parent = parents.back();
      parents.pop_back();
      if (!childUnreachable) {
        visitChildren(parent, 1);
      }
      afterChildren(parent);
      childUnreachable = parent->type == Type::unreachable;
    }
    return;
  }
  // Simple case of not having a nested block in the first position.
  emit(curr);
  visitChildren(curr, 0);
  afterChildren(curr);
}

template<typename SubType> void BinaryenIRWriter<SubType>::visitIf(If* curr) {
  emit(curr);
  visitPossibleBlockContents(curr->ifTrue);

  if (curr->ifFalse) {
    emitIfElse(curr);
    visitPossibleBlockContents(curr->ifFalse);
  }

  emitScopeEnd(curr);
  if (curr->type == Type::unreachable) {
    // We already handled the case of the condition being unreachable in
    // `visit`.  Otherwise, we may still be unreachable, if we are an if-else
    // with both sides unreachable. Just like with blocks, we emit an extra
    // `unreachable` to work around potential type mismatches.
    assert(curr->ifFalse);
    emitUnreachable();
  }
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitLoop(Loop* curr) {
  emit(curr);
  visitPossibleBlockContents(curr->body);
  emitScopeEnd(curr);
  if (curr->type == Type::unreachable) {
    // we emitted a loop without a return type, so it must not be consumed
    emitUnreachable();
  }
}

template<typename SubType> void BinaryenIRWriter<SubType>::visitTry(Try* curr) {
  emit(curr);
  visitPossibleBlockContents(curr->body);
  for (Index i = 0; i < curr->catchTags.size(); i++) {
    emitCatch(curr, i);
    visitPossibleBlockContents(curr->catchBodies[i]);
  }
  if (curr->hasCatchAll()) {
    emitCatchAll(curr);
    visitPossibleBlockContents(curr->catchBodies.back());
  }
  if (curr->isDelegate()) {
    emitDelegate(curr);
    // Note that when we emit a delegate we do not need to also emit a scope
    // ending, as the delegate ends the scope.
  } else {
    emitScopeEnd(curr);
  }
  if (curr->type == Type::unreachable) {
    emitUnreachable();
  }
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitTryTable(TryTable* curr) {
  emit(curr);
  visitPossibleBlockContents(curr->body);
  emitScopeEnd(curr);
  if (curr->type == Type::unreachable) {
    emitUnreachable();
  }
}

// Binaryen IR to binary writer
class BinaryenIRToBinaryWriter
  : public BinaryenIRWriter<BinaryenIRToBinaryWriter> {
public:
  BinaryenIRToBinaryWriter(WasmBinaryWriter& parent,
                           BufferWithRandomAccess& o,
                           Function* func = nullptr,
                           bool sourceMap = false,
                           bool DWARF = false)
    : BinaryenIRWriter<BinaryenIRToBinaryWriter>(func), parent(parent),
      writer(parent, o, func, sourceMap, DWARF), sourceMap(sourceMap) {}

  void emit(Expression* curr) { writer.visit(curr); }
  void emitHeader() {
    if (func->prologLocation.size()) {
      parent.writeDebugLocation(*func->prologLocation.begin());
    }
    writer.mapLocalsAndEmitHeader();
  }
  void emitIfElse(If* curr) { writer.emitIfElse(curr); }
  void emitCatch(Try* curr, Index i) { writer.emitCatch(curr, i); }
  void emitCatchAll(Try* curr) { writer.emitCatchAll(curr); }
  void emitDelegate(Try* curr) { writer.emitDelegate(curr); }
  void emitScopeEnd(Expression* curr) { writer.emitScopeEnd(curr); }
  void emitFunctionEnd() {
    // Indicate the debug location corresponding to the end opcode
    // that terminates the function code.
    if (func->epilogLocation.size()) {
      parent.writeDebugLocation(*func->epilogLocation.begin());
    } else {
      // The end opcode has no debug location.
      parent.writeNoDebugLocation();
    }
    writer.emitFunctionEnd();
  }
  void emitUnreachable() { writer.emitUnreachable(); }
  void emitDebugLocation(Expression* curr) {
    if (sourceMap) {
      parent.writeDebugLocation(curr, func);
    }
  }

  MappedLocals& getMappedLocals() { return writer.mappedLocals; }

private:
  WasmBinaryWriter& parent;
  BinaryInstWriter writer;
  bool sourceMap;
};

// Binaryen IR to stack IR converter for an entire module. Generates all the
// StackIR in parallel, and then allows querying for the StackIR of individual
// functions.
class ModuleStackIR {
  ModuleUtils::ParallelFunctionAnalysis<StackIR> analysis;

public:
  ModuleStackIR(Module& wasm, const PassOptions& options);

  // Get StackIR for a function, if it exists. (This allows some functions to
  // have it and others not, if we add such capability in the future.)
  StackIR* getStackIROrNull(Function* func) {
    auto iter = analysis.map.find(func);
    if (iter == analysis.map.end()) {
      return nullptr;
    }
    return &iter->second;
  }
};

// Stack IR to binary writer
class StackIRToBinaryWriter {
public:
  StackIRToBinaryWriter(WasmBinaryWriter& parent,
                        BufferWithRandomAccess& o,
                        Function* func,
                        StackIR& stackIR,
                        bool sourceMap = false,
                        bool DWARF = false)
    : parent(parent), writer(parent, o, func, sourceMap, DWARF), func(func),
      stackIR(stackIR), sourceMap(sourceMap) {}

  void write();

  MappedLocals& getMappedLocals() { return writer.mappedLocals; }

private:
  WasmBinaryWriter& parent;
  BinaryInstWriter writer;
  Function* func;
  StackIR& stackIR;
  bool sourceMap;
};

// Stack IR optimizer
class StackIROptimizer {
  Function* func;
  StackIR& insts;
  const PassOptions& passOptions;
  FeatureSet features;

public:
  StackIROptimizer(Function* func,
                   StackIR& insts,
                   const PassOptions& passOptions,
                   FeatureSet features);

  void run();

private:
  void dce();
  void vacuum();
  void local2Stack();
  void removeUnneededBlocks();
  bool isControlFlowBarrier(StackInst* inst);
  bool isControlFlowBegin(StackInst* inst);
  bool isControlFlowEnd(StackInst* inst);
  bool isControlFlow(StackInst* inst);
  void removeAt(Index i);
  Index getNumConsumedValues(StackInst* inst);
  bool canRemoveSetGetPair(Index setIndex, Index getIndex);
  std::unordered_set<LocalGet*> findStringViewDeferredGets();
};

// Generate and emit StackIR.
std::ostream&
printStackIR(std::ostream& o, Module* module, const PassOptions& options);

} // namespace wasm

namespace std {
std::ostream& operator<<(std::ostream& o, wasm::StackInst& inst);
} // namespace std

#endif // wasm_stack_h
