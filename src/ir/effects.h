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

#ifndef wasm_ir_effects_h
#define wasm_ir_effects_h

#include "ir/intrinsics.h"
#include "pass.h"
#include "wasm-traversal.h"

namespace wasm {

// Analyze various possible effects.

class EffectAnalyzer {
public:
  EffectAnalyzer(const PassOptions& passOptions,
                 Module& module,
                 Expression* ast = nullptr)
    : ignoreImplicitTraps(passOptions.ignoreImplicitTraps),
      trapsNeverHappen(passOptions.trapsNeverHappen), module(module),
      features(module.features) {
    if (ast) {
      walk(ast);
    }
  }

  bool ignoreImplicitTraps;
  bool trapsNeverHappen;
  Module& module;
  FeatureSet features;

  // Walk an expression and all its children.
  void walk(Expression* ast) {
    pre();
    InternalAnalyzer(*this).walk(ast);
    post();
  }

  // Visit an expression, without any children.
  void visit(Expression* ast) {
    pre();
    InternalAnalyzer(*this).visit(ast);
    post();
  }

  // Core effect tracking

  // Definitely branches out of this expression, or does a return, etc.
  // breakTargets tracks individual targets, which we may eventually see are
  // internal, while this is set when we see something that will definitely
  // not be internal, or is otherwise special like an infinite loop (which
  // does not technically branch "out", but it does break the normal assumption
  // of control flow proceeding normally).
  bool branchesOut = false;
  bool calls = false;
  std::set<Index> localsRead;
  std::set<Index> localsWritten;
  std::set<Name> mutableGlobalsRead;
  std::set<Name> globalsWritten;
  bool readsMemory = false;
  bool writesMemory = false;
  bool readsTable = false;
  bool writesTable = false;
  // TODO: More specific type-based alias analysis, and not just at the
  //       struct/array level.
  bool readsMutableStruct = false;
  bool writesStruct = false;
  bool readsArray = false;
  bool writesArray = false;
  // A trap, either from an unreachable instruction, or from an implicit trap
  // that we do not ignore (see below).
  //
  // Note that we ignore trap differences, so it is ok to reorder traps with
  // each other, but it is not ok to remove them or reorder them with other
  // effects in a noticeable way.
  //
  // Note also that we ignore runtime-dependent traps, such as hitting a
  // recursion limit or running out of memory. Such traps are not part of wasm's
  // official semantics, and they can occur anywhere: *any* instruction could in
  // theory be implemented by a VM call (as will be the case when running in an
  // interpreter), and such a call could run out of stack or memory in
  // principle. To put it another way, an i32 division by zero is the program
  // doing something bad that causes a trap, but the VM running out of memory is
  // the VM doing something bad - and therefore the VM behaving in a way that is
  // not according to the wasm semantics - and we do not model such things. Note
  // that as a result we do *not* mark things like GC allocation instructions as
  // having side effects, which has the nice benefit of making it possible to
  // eliminate an allocation whose result is not captured.
  bool trap = false;
  // A trap from an instruction like a load or div/rem, which may trap on corner
  // cases. If we do not ignore implicit traps then these are counted as a trap.
  bool implicitTrap = false;
  // An atomic load/store/RMW/Cmpxchg or an operator that has a defined ordering
  // wrt atomics (e.g. memory.grow)
  bool isAtomic = false;
  bool throws_ = false;
  // The nested depth of try-catch_all. If an instruction that may throw is
  // inside an inner try-catch_all, we don't mark it as 'throws_', because it
  // will be caught by an inner catch_all. We only count 'try's with a
  // 'catch_all' because instructions within a 'try' without a 'catch_all' can
  // still throw outside of the try.
  size_t tryDepth = 0;
  // The nested depth of catch. This is necessary to track danglng pops.
  size_t catchDepth = 0;
  // If this expression contains 'pop's that are not enclosed in 'catch' body.
  // For example, (drop (pop i32)) should set this to true.
  bool danglingPop = false;

  // Helper functions to check for various effect types

  bool accessesLocal() const {
    return localsRead.size() + localsWritten.size() > 0;
  }
  bool accessesMutableGlobal() const {
    return globalsWritten.size() + mutableGlobalsRead.size() > 0;
  }
  bool accessesMemory() const { return calls || readsMemory || writesMemory; }
  bool accessesTable() const { return calls || readsTable || writesTable; }
  bool accessesMutableStruct() const {
    return calls || readsMutableStruct || writesStruct;
  }
  bool accessesArray() const { return calls || readsArray || writesArray; }
  bool throws() const { return throws_ || !delegateTargets.empty(); }
  // Check whether this may transfer control flow to somewhere outside of this
  // expression (aside from just flowing out normally). That includes a break
  // or a throw (if the throw is not known to be caught inside this expression;
  // note that if the throw is not caught in this expression then it might be
  // caught in this function but outside of this expression, or it might not be
  // caught in the function at all, which would mean control flow cannot be
  // transferred inside the function, but this expression does not know that).
  bool transfersControlFlow() const {
    return branchesOut || throws() || hasExternalBreakTargets();
  }

  // Changes something in globally-stored state.
  bool writesGlobalState() const {
    return globalsWritten.size() || writesMemory || writesTable ||
           writesStruct || writesArray || isAtomic || calls;
  }
  bool readsMutableGlobalState() const {
    return mutableGlobalsRead.size() || readsMemory || readsTable ||
           readsMutableStruct || readsArray || isAtomic || calls;
  }

  bool hasNonTrapSideEffects() const {
    return localsWritten.size() > 0 || danglingPop || writesGlobalState() ||
           throws() || transfersControlFlow();
  }

  bool hasSideEffects() const { return trap || hasNonTrapSideEffects(); }

  // Check if there are side effects, and they are of a kind that cannot be
  // removed by optimization passes.
  //
  // The difference between this and hasSideEffects is subtle, and only related
  // to trapsNeverHappen - if trapsNeverHappen then any trap we see is removable
  // by optimizations. In general, you should call hasSideEffects, and only call
  // this method if you are certain that it is a place that would not perform an
  // unsafe transformation with a trap. Specifically, if a pass calls this
  // and gets the result that there are no unremovable side effects, then it
  // must either
  //
  //  1. Remove any side effects present, if any, so they no longer exist.
  //  2. Keep the code exactly where it is.
  //
  // If instead of 1&2 a pass kept the side effect and also reordered the code
  // with other things, then that could be bad, as the side effect might have
  // been behind a condition that avoids it occurring.
  //
  // TODO: Go through the optimizer and use this in all places that do not move
  //       code around.
  bool hasUnremovableSideEffects() const {
    return hasNonTrapSideEffects() || (trap && !trapsNeverHappen);
  }

  bool hasAnything() const {
    return hasSideEffects() || accessesLocal() || readsMemory || readsTable ||
           accessesMutableGlobal();
  }

  // check if we break to anything external from ourselves
  bool hasExternalBreakTargets() const { return !breakTargets.empty(); }

  // checks if these effects would invalidate another set (e.g., if we write, we
  // invalidate someone that reads, they can't be moved past us)
  bool invalidates(const EffectAnalyzer& other) {
    if ((transfersControlFlow() && other.hasSideEffects()) ||
        (other.transfersControlFlow() && hasSideEffects()) ||
        ((writesMemory || calls) && other.accessesMemory()) ||
        ((other.writesMemory || other.calls) && accessesMemory()) ||
        ((writesTable || calls) && other.accessesTable()) ||
        ((other.writesTable || other.calls) && accessesTable()) ||
        ((writesStruct || calls) && other.accessesMutableStruct()) ||
        ((other.writesStruct || other.calls) && accessesMutableStruct()) ||
        ((writesArray || calls) && other.accessesArray()) ||
        ((other.writesArray || other.calls) && accessesArray()) ||
        (danglingPop || other.danglingPop)) {
      return true;
    }
    // All atomics are sequentially consistent for now, and ordered wrt other
    // memory references.
    if ((isAtomic && other.accessesMemory()) ||
        (other.isAtomic && accessesMemory())) {
      return true;
    }
    for (auto local : localsWritten) {
      if (other.localsRead.count(local) || other.localsWritten.count(local)) {
        return true;
      }
    }
    for (auto local : localsRead) {
      if (other.localsWritten.count(local)) {
        return true;
      }
    }
    if ((other.calls && accessesMutableGlobal()) ||
        (calls && other.accessesMutableGlobal())) {
      return true;
    }
    for (auto global : globalsWritten) {
      if (other.mutableGlobalsRead.count(global) ||
          other.globalsWritten.count(global)) {
        return true;
      }
    }
    for (auto global : mutableGlobalsRead) {
      if (other.globalsWritten.count(global)) {
        return true;
      }
    }
    // We are ok to reorder implicit traps, but not conditionalize them.
    if ((trap && other.transfersControlFlow()) ||
        (other.trap && transfersControlFlow())) {
      return true;
    }
    // Note that the above includes disallowing the reordering of a trap with an
    // exception (as an exception can transfer control flow inside the current
    // function, so transfersControlFlow would be true) - while we allow the
    // reordering of traps with each other, we do not reorder exceptions with
    // anything.
    assert(!((trap && other.throws()) || (throws() && other.trap)));
    // We can't reorder an implicit trap in a way that could alter what global
    // state is modified.
    if ((trap && other.writesGlobalState()) ||
        (other.trap && writesGlobalState())) {
      return true;
    }
    return false;
  }

  void mergeIn(EffectAnalyzer& other) {
    branchesOut = branchesOut || other.branchesOut;
    calls = calls || other.calls;
    readsMemory = readsMemory || other.readsMemory;
    writesMemory = writesMemory || other.writesMemory;
    readsTable = readsTable || other.readsTable;
    writesTable = writesTable || other.writesTable;
    readsMutableStruct = readsMutableStruct || other.readsMutableStruct;
    writesStruct = writesStruct || other.writesStruct;
    readsArray = readsArray || other.readsArray;
    writesArray = writesArray || other.writesArray;
    trap = trap || other.trap;
    implicitTrap = implicitTrap || other.implicitTrap;
    trapsNeverHappen = trapsNeverHappen || other.trapsNeverHappen;
    isAtomic = isAtomic || other.isAtomic;
    throws_ = throws_ || other.throws_;
    danglingPop = danglingPop || other.danglingPop;
    for (auto i : other.localsRead) {
      localsRead.insert(i);
    }
    for (auto i : other.localsWritten) {
      localsWritten.insert(i);
    }
    for (auto i : other.mutableGlobalsRead) {
      mutableGlobalsRead.insert(i);
    }
    for (auto i : other.globalsWritten) {
      globalsWritten.insert(i);
    }
    for (auto i : other.breakTargets) {
      breakTargets.insert(i);
    }
    for (auto i : other.delegateTargets) {
      delegateTargets.insert(i);
    }
  }

  // the checks above happen after the node's children were processed, in the
  // order of execution we must also check for control flow that happens before
  // the children, i.e., loops
  bool checkPre(Expression* curr) {
    if (curr->is<Loop>()) {
      branchesOut = true;
      return true;
    }
    return false;
  }

  bool checkPost(Expression* curr) {
    visit(curr);
    if (curr->is<Loop>()) {
      branchesOut = true;
    }
    return hasAnything();
  }

  std::set<Name> breakTargets;
  std::set<Name> delegateTargets;

private:
  struct InternalAnalyzer
    : public PostWalker<InternalAnalyzer, OverriddenVisitor<InternalAnalyzer>> {

    EffectAnalyzer& parent;

    InternalAnalyzer(EffectAnalyzer& parent) : parent(parent) {}

    static void scan(InternalAnalyzer* self, Expression** currp) {
      Expression* curr = *currp;
      // We need to decrement try depth before catch starts, so handle it
      // separately
      if (curr->is<Try>()) {
        self->pushTask(doVisitTry, currp);
        self->pushTask(doEndCatch, currp);
        auto& catchBodies = curr->cast<Try>()->catchBodies;
        for (int i = int(catchBodies.size()) - 1; i >= 0; i--) {
          self->pushTask(scan, &catchBodies[i]);
        }
        self->pushTask(doStartCatch, currp);
        self->pushTask(scan, &curr->cast<Try>()->body);
        self->pushTask(doStartTry, currp);
        return;
      }
      PostWalker<InternalAnalyzer, OverriddenVisitor<InternalAnalyzer>>::scan(
        self, currp);
    }

    static void doStartTry(InternalAnalyzer* self, Expression** currp) {
      Try* curr = (*currp)->cast<Try>();
      // We only count 'try's with a 'catch_all' because instructions within a
      // 'try' without a 'catch_all' can still throw outside of the try.
      if (curr->hasCatchAll()) {
        self->parent.tryDepth++;
      }
    }

    static void doStartCatch(InternalAnalyzer* self, Expression** currp) {
      Try* curr = (*currp)->cast<Try>();
      // This is conservative. When an inner try-delegate targets the current
      // expression, even if the try-delegate's body can't throw, we consider
      // the current expression can throw for simplicity, unless the current
      // expression is not inside a try-catch_all. It is hard to figure out
      // whether the original try-delegate's body throws or not at this point.
      if (curr->name.is()) {
        if (self->parent.delegateTargets.count(curr->name) &&
            self->parent.tryDepth == 0) {
          self->parent.throws_ = true;
        }
        self->parent.delegateTargets.erase(curr->name);
      }
      // We only count 'try's with a 'catch_all' because instructions within a
      // 'try' without a 'catch_all' can still throw outside of the try.
      if (curr->hasCatchAll()) {
        assert(self->parent.tryDepth > 0 && "try depth cannot be negative");
        self->parent.tryDepth--;
      }
      self->parent.catchDepth++;
    }

    static void doEndCatch(InternalAnalyzer* self, Expression** currp) {
      assert(self->parent.catchDepth > 0 && "catch depth cannot be negative");
      self->parent.catchDepth--;
    }

    void visitBlock(Block* curr) {
      if (curr->name.is()) {
        parent.breakTargets.erase(curr->name); // these were internal breaks
      }
    }
    void visitIf(If* curr) {}
    void visitLoop(Loop* curr) {
      if (curr->name.is()) {
        parent.breakTargets.erase(curr->name); // these were internal breaks
      }
      // if the loop is unreachable, then there is branching control flow:
      //  (1) if the body is unreachable because of a (return), uncaught (br)
      //      etc., then we already noted branching, so it is ok to mark it
      //      again (if we have *caught* (br)s, then they did not lead to the
      //      loop body being unreachable). (same logic applies to blocks)
      //  (2) if the loop is unreachable because it only has branches up to the
      //      loop top, but no way to get out, then it is an infinite loop, and
      //      we consider that a branching side effect (note how the same logic
      //      does not apply to blocks).
      if (curr->type == Type::unreachable) {
        parent.branchesOut = true;
      }
    }
    void visitBreak(Break* curr) { parent.breakTargets.insert(curr->name); }
    void visitSwitch(Switch* curr) {
      for (auto name : curr->targets) {
        parent.breakTargets.insert(name);
      }
      parent.breakTargets.insert(curr->default_);
    }

    void visitCall(Call* curr) {
      // call.without.effects has no effects.
      if (Intrinsics(parent.module).isCallWithoutEffects(curr)) {
        return;
      }

      parent.calls = true;
      // When EH is enabled, any call can throw.
      if (parent.features.hasExceptionHandling() && parent.tryDepth == 0) {
        parent.throws_ = true;
      }
      if (curr->isReturn) {
        parent.branchesOut = true;
      }
    }
    void visitCallIndirect(CallIndirect* curr) {
      parent.calls = true;
      if (parent.features.hasExceptionHandling() && parent.tryDepth == 0) {
        parent.throws_ = true;
      }
      if (curr->isReturn) {
        parent.branchesOut = true;
      }
    }
    void visitLocalGet(LocalGet* curr) {
      parent.localsRead.insert(curr->index);
    }
    void visitLocalSet(LocalSet* curr) {
      parent.localsWritten.insert(curr->index);
    }
    void visitGlobalGet(GlobalGet* curr) {
      if (parent.module.getGlobal(curr->name)->mutable_ == Mutable) {
        parent.mutableGlobalsRead.insert(curr->name);
      }
    }
    void visitGlobalSet(GlobalSet* curr) {
      parent.globalsWritten.insert(curr->name);
    }
    void visitLoad(Load* curr) {
      parent.readsMemory = true;
      parent.isAtomic |= curr->isAtomic;
      parent.implicitTrap = true;
    }
    void visitStore(Store* curr) {
      parent.writesMemory = true;
      parent.isAtomic |= curr->isAtomic;
      parent.implicitTrap = true;
    }
    void visitAtomicRMW(AtomicRMW* curr) {
      parent.readsMemory = true;
      parent.writesMemory = true;
      parent.isAtomic = true;
      parent.implicitTrap = true;
    }
    void visitAtomicCmpxchg(AtomicCmpxchg* curr) {
      parent.readsMemory = true;
      parent.writesMemory = true;
      parent.isAtomic = true;
      parent.implicitTrap = true;
    }
    void visitAtomicWait(AtomicWait* curr) {
      parent.readsMemory = true;
      // AtomicWait doesn't strictly write memory, but it does modify the
      // waiters list associated with the specified address, which we can think
      // of as a write.
      parent.writesMemory = true;
      parent.isAtomic = true;
      parent.implicitTrap = true;
    }
    void visitAtomicNotify(AtomicNotify* curr) {
      // AtomicNotify doesn't strictly write memory, but it does modify the
      // waiters list associated with the specified address, which we can think
      // of as a write.
      parent.readsMemory = true;
      parent.writesMemory = true;
      parent.isAtomic = true;
      parent.implicitTrap = true;
    }
    void visitAtomicFence(AtomicFence* curr) {
      // AtomicFence should not be reordered with any memory operations, so we
      // set these to true.
      parent.readsMemory = true;
      parent.writesMemory = true;
      parent.isAtomic = true;
    }
    void visitSIMDExtract(SIMDExtract* curr) {}
    void visitSIMDReplace(SIMDReplace* curr) {}
    void visitSIMDShuffle(SIMDShuffle* curr) {}
    void visitSIMDTernary(SIMDTernary* curr) {}
    void visitSIMDShift(SIMDShift* curr) {}
    void visitSIMDLoad(SIMDLoad* curr) {
      parent.readsMemory = true;
      parent.implicitTrap = true;
    }
    void visitSIMDLoadStoreLane(SIMDLoadStoreLane* curr) {
      if (curr->isLoad()) {
        parent.readsMemory = true;
      } else {
        parent.writesMemory = true;
      }
      parent.implicitTrap = true;
    }
    void visitMemoryInit(MemoryInit* curr) {
      parent.writesMemory = true;
      parent.implicitTrap = true;
    }
    void visitDataDrop(DataDrop* curr) {
      // data.drop does not actually write memory, but it does alter the size of
      // a segment, which can be noticeable later by memory.init, so we need to
      // mark it as having a global side effect of some kind.
      parent.writesMemory = true;
      parent.implicitTrap = true;
    }
    void visitMemoryCopy(MemoryCopy* curr) {
      parent.readsMemory = true;
      parent.writesMemory = true;
      parent.implicitTrap = true;
    }
    void visitMemoryFill(MemoryFill* curr) {
      parent.writesMemory = true;
      parent.implicitTrap = true;
    }
    void visitConst(Const* curr) {}
    void visitUnary(Unary* curr) {
      switch (curr->op) {
        case TruncSFloat32ToInt32:
        case TruncSFloat32ToInt64:
        case TruncUFloat32ToInt32:
        case TruncUFloat32ToInt64:
        case TruncSFloat64ToInt32:
        case TruncSFloat64ToInt64:
        case TruncUFloat64ToInt32:
        case TruncUFloat64ToInt64: {
          parent.implicitTrap = true;
          break;
        }
        default: {}
      }
    }
    void visitBinary(Binary* curr) {
      switch (curr->op) {
        case DivSInt32:
        case DivUInt32:
        case RemSInt32:
        case RemUInt32:
        case DivSInt64:
        case DivUInt64:
        case RemSInt64:
        case RemUInt64: {
          // div and rem may contain implicit trap only if RHS is
          // non-constant or constant which equal zero or -1 for
          // signed divisions. Reminder traps only with zero
          // divider.
          if (auto* c = curr->right->dynCast<Const>()) {
            if (c->value.isZero()) {
              parent.implicitTrap = true;
            } else if ((curr->op == DivSInt32 || curr->op == DivSInt64) &&
                       c->value.getInteger() == -1LL) {
              parent.implicitTrap = true;
            }
          } else {
            parent.implicitTrap = true;
          }
          break;
        }
        default: {}
      }
    }
    void visitSelect(Select* curr) {}
    void visitDrop(Drop* curr) {}
    void visitReturn(Return* curr) { parent.branchesOut = true; }
    void visitMemorySize(MemorySize* curr) {
      // memory.size accesses the size of the memory, and thus can be modeled as
      // reading memory
      parent.readsMemory = true;
      // Atomics are sequentially consistent with memory.size.
      parent.isAtomic = true;
    }
    void visitMemoryGrow(MemoryGrow* curr) {
      // TODO: find out if calls is necessary here
      parent.calls = true;
      // memory.grow technically does a read-modify-write operation on the
      // memory size in the successful case, modifying the set of valid
      // addresses, and just a read operation in the failure case
      parent.readsMemory = true;
      parent.writesMemory = true;
      // Atomics are also sequentially consistent with memory.grow.
      parent.isAtomic = true;
    }
    void visitRefNull(RefNull* curr) {}
    void visitRefIs(RefIs* curr) {}
    void visitRefFunc(RefFunc* curr) {}
    void visitRefEq(RefEq* curr) {}
    void visitTableGet(TableGet* curr) {
      parent.readsTable = true;
      parent.implicitTrap = true;
    }
    void visitTableSet(TableSet* curr) {
      parent.writesTable = true;
      parent.implicitTrap = true;
    }
    void visitTableSize(TableSize* curr) { parent.readsTable = true; }
    void visitTableGrow(TableGrow* curr) {
      // table.grow technically does a read-modify-write operation on the
      // table size in the successful case, modifying the set of valid
      // indices, and just a read operation in the failure case
      parent.readsTable = true;
      parent.writesTable = true;
    }
    void visitTry(Try* curr) {
      if (curr->delegateTarget.is()) {
        parent.delegateTargets.insert(curr->delegateTarget);
      }
    }
    void visitThrow(Throw* curr) {
      if (parent.tryDepth == 0) {
        parent.throws_ = true;
      }
    }
    void visitRethrow(Rethrow* curr) {
      if (parent.tryDepth == 0) {
        parent.throws_ = true;
      }
      // traps when the arg is null
      parent.implicitTrap = true;
    }
    void visitNop(Nop* curr) {}
    void visitUnreachable(Unreachable* curr) { parent.trap = true; }
    void visitPop(Pop* curr) {
      if (parent.catchDepth == 0) {
        parent.danglingPop = true;
      }
    }
    void visitTupleMake(TupleMake* curr) {}
    void visitTupleExtract(TupleExtract* curr) {}
    void visitI31New(I31New* curr) {}
    void visitI31Get(I31Get* curr) {}
    void visitCallRef(CallRef* curr) {
      parent.calls = true;
      if (parent.features.hasExceptionHandling() && parent.tryDepth == 0) {
        parent.throws_ = true;
      }
      if (curr->isReturn) {
        parent.branchesOut = true;
      }
      // traps when the arg is null
      parent.implicitTrap = true;
    }
    void visitRefTest(RefTest* curr) {}
    void visitRefCast(RefCast* curr) {
      // Traps if the ref is not null and it has an invalid rtt.
      parent.implicitTrap = true;
    }
    void visitBrOn(BrOn* curr) { parent.breakTargets.insert(curr->name); }
    void visitRttCanon(RttCanon* curr) {}
    void visitRttSub(RttSub* curr) {}
    void visitStructNew(StructNew* curr) {}
    void visitStructGet(StructGet* curr) {
      if (curr->ref->type == Type::unreachable) {
        return;
      }
      if (curr->ref->type.getHeapType()
            .getStruct()
            .fields[curr->index]
            .mutable_ == Mutable) {
        parent.readsMutableStruct = true;
      }
      // traps when the arg is null
      if (curr->ref->type.isNullable()) {
        parent.implicitTrap = true;
      }
    }
    void visitStructSet(StructSet* curr) {
      parent.writesStruct = true;
      // traps when the arg is null
      if (curr->ref->type.isNullable()) {
        parent.implicitTrap = true;
      }
    }
    void visitArrayNew(ArrayNew* curr) {}
    void visitArrayInit(ArrayInit* curr) {}
    void visitArrayGet(ArrayGet* curr) {
      parent.readsArray = true;
      // traps when the arg is null or the index out of bounds
      parent.implicitTrap = true;
    }
    void visitArraySet(ArraySet* curr) {
      parent.writesArray = true;
      // traps when the arg is null or the index out of bounds
      parent.implicitTrap = true;
    }
    void visitArrayLen(ArrayLen* curr) {
      // traps when the arg is null
      if (curr->ref->type.isNullable()) {
        parent.implicitTrap = true;
      }
    }
    void visitArrayCopy(ArrayCopy* curr) {
      parent.readsArray = true;
      parent.writesArray = true;
      // traps when a ref is null, or when out of bounds.
      parent.implicitTrap = true;
    }
    void visitRefAs(RefAs* curr) {
      // traps when the arg is not valid
      parent.implicitTrap = true;
      // Note: We could be more precise here and report the lack of a possible
      // trap if the input is non-nullable (and also of the right kind for
      // RefAsFunc etc.). However, we have optimization passes that will
      // remove a RefAs in such a case (in OptimizeInstructions, and also
      // Vacuum in trapsNeverHappen mode), so duplicating that code here would
      // only help until the next time those optimizations run. As a tradeoff,
      // we keep the code here simpler, but it does mean another optimization
      // cycle may be needed in some cases.
    }
  };

public:
  // Helpers

  static bool canReorder(const PassOptions& passOptions,
                         Module& module,
                         Expression* a,
                         Expression* b) {
    EffectAnalyzer aEffects(passOptions, module, a);
    EffectAnalyzer bEffects(passOptions, module, b);
    return !aEffects.invalidates(bEffects);
  }

  // C-API

  enum SideEffects : uint32_t {
    None = 0,
    Branches = 1 << 0,
    Calls = 1 << 1,
    ReadsLocal = 1 << 2,
    WritesLocal = 1 << 3,
    ReadsGlobal = 1 << 4,
    WritesGlobal = 1 << 5,
    ReadsMemory = 1 << 6,
    WritesMemory = 1 << 7,
    ReadsTable = 1 << 8,
    WritesTable = 1 << 9,
    ImplicitTrap = 1 << 10,
    IsAtomic = 1 << 11,
    Throws = 1 << 12,
    DanglingPop = 1 << 13,
    TrapsNeverHappen = 1 << 14,
    Any = (1 << 15) - 1
  };
  uint32_t getSideEffects() const {
    uint32_t effects = 0;
    if (branchesOut || hasExternalBreakTargets()) {
      effects |= SideEffects::Branches;
    }
    if (calls) {
      effects |= SideEffects::Calls;
    }
    if (localsRead.size() > 0) {
      effects |= SideEffects::ReadsLocal;
    }
    if (localsWritten.size() > 0) {
      effects |= SideEffects::WritesLocal;
    }
    if (mutableGlobalsRead.size()) {
      effects |= SideEffects::ReadsGlobal;
    }
    if (globalsWritten.size() > 0) {
      effects |= SideEffects::WritesGlobal;
    }
    if (readsMemory) {
      effects |= SideEffects::ReadsMemory;
    }
    if (writesMemory) {
      effects |= SideEffects::WritesMemory;
    }
    if (readsTable) {
      effects |= SideEffects::ReadsTable;
    }
    if (writesTable) {
      effects |= SideEffects::WritesTable;
    }
    if (implicitTrap) {
      effects |= SideEffects::ImplicitTrap;
    }
    if (trapsNeverHappen) {
      effects |= SideEffects::TrapsNeverHappen;
    }
    if (isAtomic) {
      effects |= SideEffects::IsAtomic;
    }
    if (throws_) {
      effects |= SideEffects::Throws;
    }
    if (danglingPop) {
      effects |= SideEffects::DanglingPop;
    }
    return effects;
  }

  void ignoreBranches() {
    branchesOut = false;
    breakTargets.clear();
  }

private:
  void pre() {
    breakTargets.clear();
    delegateTargets.clear();
  }

  void post() {
    assert(tryDepth == 0);

    if (ignoreImplicitTraps) {
      implicitTrap = false;
    } else if (implicitTrap) {
      trap = true;
    }
  }
};

// Calculate effects only on the node itself (shallowly), and not on
// children.
class ShallowEffectAnalyzer : public EffectAnalyzer {
public:
  ShallowEffectAnalyzer(const PassOptions& passOptions,
                        Module& module,
                        Expression* ast = nullptr)
    : EffectAnalyzer(passOptions, module) {
    if (ast) {
      visit(ast);
    }
  }
};

} // namespace wasm

#endif // wasm_ir_effects_h
