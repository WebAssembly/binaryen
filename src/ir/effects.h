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
  EffectAnalyzer(const PassOptions& passOptions, Module& module)
    : ignoreImplicitTraps(passOptions.ignoreImplicitTraps),
      trapsNeverHappen(passOptions.trapsNeverHappen), module(module),
      features(module.features) {}

  EffectAnalyzer(const PassOptions& passOptions,
                 Module& module,
                 Expression* ast)
    : EffectAnalyzer(passOptions, module) {
    walk(ast);
  }

  EffectAnalyzer(const PassOptions& passOptions, Module& module, Function* func)
    : EffectAnalyzer(passOptions, module) {
    walk(func);
  }

  bool ignoreImplicitTraps;
  bool trapsNeverHappen;
  Module& module;
  FeatureSet features;

  // Walk an expression and all its children.
  void walk(Expression* ast) {
    InternalAnalyzer(*this).walk(ast);
    post();
  }

  // Visit an expression, without any children.
  void visit(Expression* ast) {
    InternalAnalyzer(*this).visit(ast);
    post();
  }

  // Walk an entire function body. This will ignore effects that are not
  // noticeable from the perspective of the caller, that is, effects that are
  // only noticeable during the call, but "vanish" when the call stack is
  // unwound.
  //
  // Unlike walking just the body, walking the function will also
  // include the effects of any return calls the function makes. For that
  // reason, it is a bug if a user of this code calls walk(Expression*) and not
  // walk(Function*) if their intention is to scan an entire function body.
  // Putting it another way, a return_call is syntax sugar for a return and a
  // call, where the call executes at the function scope, so there is a
  // meaningful difference between scanning an expression and scanning
  // the entire function body.
  void walk(Function* func) {
    walk(func->body);

    // Effects of return-called functions will be visible to the caller.
    if (hasReturnCallThrow) {
      set(Bits::Throws);
    }

    // We can ignore branching out of the function body - this can only be
    // a return, and that is only noticeable in the function, not outside.
    set(Bits::BranchesOut, false);

    // When the function exits, changes to locals cannot be noticed any more.
    localsWritten.clear();
    localsRead.clear();
  }

  // Core effect tracking

  std::set<Index> localsRead;
  std::set<Index> localsWritten;
  std::set<Name> mutableGlobalsRead;
  std::set<Name> globalsWritten;

  // The nested depth of try-catch_all. If an instruction that may throw is
  // inside an inner try-catch_all, we don't mark it as 'throws_', because it
  // will be caught by an inner catch_all. We only count 'try's with a
  // 'catch_all' because instructions within a 'try' without a 'catch_all' can
  // still throw outside of the try.
  size_t tryDepth = 0;
  // The nested depth of catch. This is necessary to track danglng pops.
  size_t catchDepth = 0;

  struct Bits {
    enum : uint32_t {
      None = 0,
      // Definitely branches out of this expression, or does a return, etc.
      // breakTargets tracks individual targets, which we may eventually see are
      // internal, while this is set when we see something that will definitely
      // not be internal, or is otherwise special like an infinite loop (which
      // does not technically branch "out", but it does break the normal
      // assumption of control flow proceeding normally).
      BranchesOut = 1 << 0,
      Calls = 1 << 1,
      ReadsMemory = 1 << 2,
      WritesMemory = 1 << 3,
      ReadsTable = 1 << 4,
      WritesTable = 1 << 5,
      // TODO: More specific type-based alias analysis, and not just at the
      //       struct/array level.
      ReadsMutableStruct = 1 << 6,
      WritesStruct = 1 << 7,
      ReadsArray = 1 << 8,
      WritesArray = 1 << 9,
      // A trap, either from an unreachable instruction, or from an implicit
      // trap that we do not ignore (see below).
      //
      // Note that we ignore trap differences, so it is ok to reorder traps with
      // each other, but it is not ok to remove them or reorder them with other
      // effects in a noticeable way.
      //
      // Note also that we ignore *optional* runtime-specific traps: we only
      // consider as trapping something that will trap in *all* VMs, and *all*
      // the time. For example, a single allocation might trap in a VM in a
      // particular execution, if it happens to run out of memory just there,
      // but that is not enough for us to mark it as having a trap effect. (Note
      // that not marking each allocation as possibly trapping has the nice
      // benefit of making it possible to eliminate an allocation whose result
      // is not captured.) OTOH, we *do* mark a potentially infinite number of
      // allocations as trapping, as all VMs would trap eventually, and the same
      // for potentially infinite recursion, etc.
      Trap = 1 << 10,
      // A trap from an instruction like a load or div/rem, which may trap on
      // corner cases. If we do not ignore implicit traps then these are counted
      // as a trap.
      ImplicitTrap = 1 << 11,
      // An atomic load/store/RMW/Cmpxchg or an operator that has a defined
      // ordering wrt atomics (e.g. memory.grow)
      IsAtomic = 1 << 12,
      Throws = 1 << 13,

      // If this expression contains 'pop's that are not enclosed in 'catch'
      // body. For example, (drop (pop i32)) should set this to true.
      DanglingPop = 1 << 14,
      // Whether this code may "hang" and not eventually complete. An infinite
      // loop, or a continuation that is never continued, are examples of that.
      MayNotReturn = 1 << 15,

      // Since return calls return out of the body of the function before
      // performing their call, they are indistinguishable from normal returns
      // from the perspective of their surrounding code, and the return-callee's
      // effects only become visible when considering the effects of the whole
      // function containing the return call. To model this correctly, stash the
      // callee's effects on the side and only merge them in after walking a
      // full function body.
      //
      // We currently do this stashing only for the throw effect, but in
      // principle we could do it for all effects if it made a difference.
      // (Only throw is noticeable now because the only thing that can change
      // between doing the call here and doing it outside at the function exit
      // is the scoping of try-catch blocks. If future wasm scoping additions
      // are added, we may need more here.)
      HasReturnCallThrow = 1 << 16,
    };
  };
  uint32_t effectBits = Bits::None;

  void set(uint32_t bits, bool value = true) {
    if (value) {
      effectBits |= bits;
    } else {
      effectBits &= ~bits;
    }
  }

  bool get(uint32_t bits) const { return (effectBits & bits) != 0; }

  // Since return calls return out of the body of the function before performing
  // their call, they are indistinguishable from normal returns from the
  // perspective of their surrounding code, and the return-callee's effects only
  // become visible when considering the effects of the whole function
  // containing the return call. To model this correctly, stash the callee's
  // effects on the side and only merge them in after walking a full function
  // body.
  //
  // We currently do this stashing only for the throw effect, but in principle
  // we could do it for all effects if it made a difference. (Only throw is
  // noticeable now because the only thing that can change between doing the
  // call here and doing it outside at the function exit is the scoping of
  // try-catch blocks. If future wasm scoping additions are added, we may need
  // more here.)
  bool hasReturnCallThrow = false;

  // Helper functions to check for various effect types

  bool accessesLocal() const {
    return localsRead.size() + localsWritten.size() > 0;
  }
  bool accessesMutableGlobal() const {
    return globalsWritten.size() + mutableGlobalsRead.size() > 0;
  }
  bool accessesMemory() const {
    return get(Bits::Calls | Bits::ReadsMemory | Bits::WritesMemory);
  }
  bool accessesTable() const {
    return get(Bits::Calls | Bits::ReadsTable | Bits::WritesTable);
  }
  bool accessesMutableStruct() const {
    return get(Bits::Calls | Bits::ReadsMutableStruct | Bits::WritesStruct);
  }
  bool accessesArray() const {
    return get(Bits::Calls | Bits::ReadsArray | Bits::WritesArray);
  }
  bool throws() const { return get(Bits::Throws) || !delegateTargets.empty(); }
  bool traps() const { return get(Bits::Trap); }

  // Check whether this may transfer control flow to somewhere outside of this
  // expression (aside from just flowing out normally). That includes a break
  // or a throw (if the throw is not known to be caught inside this expression;
  // note that if the throw is not caught in this expression then it might be
  // caught in this function but outside of this expression, or it might not be
  // caught in the function at all, which would mean control flow cannot be
  // transferred inside the function, but this expression does not know that).
  bool transfersControlFlow() const {
    return get(Bits::BranchesOut) || throws() || hasExternalBreakTargets();
  }

  // Changes something in globally-stored state.
  bool writesGlobalState() const {
    return get(Bits::WritesMemory | Bits::WritesTable | Bits::WritesStruct |
               Bits::WritesArray | Bits::IsAtomic | Bits::Calls) ||
           globalsWritten.size();
  }
  bool readsMutableGlobalState() const {
    return get(Bits::ReadsMemory | Bits::ReadsTable | Bits::ReadsMutableStruct |
               Bits::ReadsArray | Bits::IsAtomic | Bits::Calls) ||
           mutableGlobalsRead.size();
  }

  bool hasNonTrapSideEffects() const {
    return get(Bits::DanglingPop | Bits::MayNotReturn) || writesGlobalState() ||
           throws() || transfersControlFlow() || localsWritten.size() > 0;
  }

  bool hasSideEffects() const { return hasNonTrapSideEffects() || traps(); }

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
    return hasNonTrapSideEffects() || (traps() && !trapsNeverHappen);
  }

  bool hasAnything() const {
    return hasSideEffects() || accessesLocal() || readsMutableGlobalState();
  }

  // check if we break to anything external from ourselves
  bool hasExternalBreakTargets() const { return !breakTargets.empty(); }

  // Checks if these effects would invalidate another set of effects (e.g., if
  // we write, we invalidate someone that reads).
  //
  // This assumes the things whose effects we are comparing will both execute,
  // at least if neither of them transfers control flow away. That is, we assume
  // that there is no transfer of control flow *between* them: we are comparing
  // things appear after each other, perhaps with some other code in the middle,
  // but that code does not transfer control flow. It is not valid to call this
  // method in other situations, like this:
  //
  //   A
  //   (br_if 0 (local.get 0)) ;; this may transfer control flow away
  //   B
  //
  // Calling this method in that situation is invalid because only A may
  // execute and not B. The following are examples of situations where it is
  // valid to call this method:
  //
  //   A
  //   ;; nothing in between them at all
  //   B
  //
  //   A
  //   (local.set 0 (i32.const 0)) ;; something in between without a possible
  //                               ;; control flow transfer
  //   B
  //
  // That the things being compared both execute only matters in the case of
  // traps-never-happen: in that mode we can move traps but only if doing so
  // would not make them start to appear when they did not. In the second
  // example we can't reorder A and B if B traps, but in the first example we
  // can reorder them even if B traps (even if A has a global effect like a
  // global.set, since we assume B does not trap in traps-never-happen).
  bool invalidates(const EffectAnalyzer& other) {
    if ((transfersControlFlow() && other.hasSideEffects()) ||
        (other.transfersControlFlow() && hasSideEffects()) ||
        (get(Bits::WritesMemory | Bits::Calls) && other.accessesMemory()) ||
        (other.get(Bits::WritesMemory | Bits::Calls) && accessesMemory()) ||
        (get(Bits::WritesTable | Bits::Calls) && other.accessesTable()) ||
        (other.get(Bits::WritesTable | Bits::Calls) && accessesTable()) ||
        (get(Bits::WritesStruct | Bits::Calls) &&
         other.accessesMutableStruct()) ||
        (other.get(Bits::WritesStruct | Bits::Calls) &&
         accessesMutableStruct()) ||
        (get(Bits::WritesArray | Bits::Calls) && other.accessesArray()) ||
        (other.get(Bits::WritesArray | Bits::Calls) && accessesArray()) ||
        get(Bits::DanglingPop) || other.get(Bits::DanglingPop)) {
      return true;
    }
    // All atomics are sequentially consistent for now, and ordered wrt other
    // memory references.
    if ((get(Bits::IsAtomic) && other.accessesMemory()) ||
        (other.get(Bits::IsAtomic) && accessesMemory())) {
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
    if ((other.get(Bits::Calls) && accessesMutableGlobal()) ||
        (get(Bits::Calls) && other.accessesMutableGlobal())) {
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
    // Note that the above includes disallowing the reordering of a trap with an
    // exception (as an exception can transfer control flow inside the current
    // function, so transfersControlFlow would be true) - while we allow the
    // reordering of traps with each other, we do not reorder exceptions with
    // anything.
    assert(!((traps() && other.throws()) || (throws() && other.traps())));
    // We can't reorder an implicit trap in a way that could alter what global
    // state is modified. However, in trapsNeverHappen mode we assume traps do
    // not occur in practice, which lets us ignore this, at least in the case
    // that the code executes. As mentioned above, we assume that there is no
    // transfer of control flow between the things we are comparing, so all we
    // need to do is check for such transfers in them.
    if (!trapsNeverHappen || transfersControlFlow() ||
        other.transfersControlFlow()) {
      if ((traps() && other.writesGlobalState()) ||
          (other.traps() && writesGlobalState())) {
        return true;
      }
    }
    return false;
  }

  void mergeIn(const EffectAnalyzer& other) {
    set(other.effectBits);
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
      set(Bits::BranchesOut);
      return true;
    }
    return false;
  }

  bool checkPost(Expression* curr) {
    visit(curr);
    if (curr->is<Loop>()) {
      set(Bits::BranchesOut);
    }
    return hasAnything();
  }

  std::set<Name> breakTargets;
  std::set<Name> delegateTargets;

private:
  struct InternalAnalyzer
    : public PostWalker<InternalAnalyzer, OverriddenVisitor<InternalAnalyzer>> {

    EffectAnalyzer& parent;
    uint32_t& effectBits;

    InternalAnalyzer(EffectAnalyzer& parent)
      : parent(parent), effectBits(parent.effectBits) {}

    void set(uint32_t bit, bool value = true) { parent.set(bit, value); }

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
      if (auto* tryTable = curr->dynCast<TryTable>()) {
        // We need to increment try depth before starting.
        self->pushTask(doEndTryTable, currp);
        self->pushTask(doVisitTryTable, currp);
        self->pushTask(scan, &tryTable->body);
        self->pushTask(doStartTryTable, currp);
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
          self->set(Bits::Throws);
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

    static void doStartTryTable(InternalAnalyzer* self, Expression** currp) {
      auto* curr = (*currp)->cast<TryTable>();
      // We only count 'try_table's with a 'catch_all' because instructions
      // within a 'try_table' without a 'catch_all' can still throw outside of
      // the try.
      if (curr->hasCatchAll()) {
        self->parent.tryDepth++;
      }
    }

    static void doEndTryTable(InternalAnalyzer* self, Expression** currp) {
      auto* curr = (*currp)->cast<TryTable>();
      if (curr->hasCatchAll()) {
        assert(self->parent.tryDepth > 0 && "try depth cannot be negative");
        self->parent.tryDepth--;
      }
    }

    void visitBlock(Block* curr) {
      if (curr->name.is()) {
        parent.breakTargets.erase(curr->name); // these were internal breaks
      }
    }
    void visitIf(If* curr) {}
    void visitLoop(Loop* curr) {
      if (curr->name.is() && parent.breakTargets.erase(curr->name) > 0) {
        set(Bits::MayNotReturn);
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

      // Get the target's effects, if they exist. Note that we must handle the
      // case of the function not yet existing (we may be executed in the middle
      // of a pass, which may have built up calls but not the targets of those
      // calls; in such a case, we do not find the targets and therefore assume
      // we know nothing about the effects, which is safe).
      const EffectAnalyzer* targetEffects = nullptr;
      if (auto* target = parent.module.getFunctionOrNull(curr->target)) {
        targetEffects = target->effects.get();
      }

      if (curr->isReturn) {
        set(Bits::BranchesOut);
        // When EH is enabled, any call can throw.
        if (parent.features.hasExceptionHandling() &&
            (!targetEffects || targetEffects->throws())) {
          parent.hasReturnCallThrow = true;
        }
      }

      if (targetEffects) {
        // We have effect information for this call target, and can just use
        // that. The one change we may want to make is to remove throws, if the
        // target function throws and we know that will be caught anyhow, the
        // same as the code below for the general path. We can always filter out
        // throws for return calls because they are already more precisely
        // captured by `BranchesOut`, which models the return, and
        // `hasReturnCallThrow`, which models the throw that will happen after
        // the return.
        if (targetEffects->get(Bits::Throws) &&
            (parent.tryDepth > 0 || curr->isReturn)) {
          auto filteredEffects = *targetEffects;
          filteredEffects.set(Bits::Throws, false);
          parent.mergeIn(filteredEffects);
        } else {
          // Just merge in all the effects.
          parent.mergeIn(*targetEffects);
        }
        return;
      }

      set(Bits::Calls);
      // When EH is enabled, any call can throw. Skip this for return calls
      // because the throw is already more precisely captured by the combination
      // of `HasReturnCallThrow` and `BranchesOut`.
      if (parent.features.hasExceptionHandling() && parent.tryDepth == 0 &&
          !curr->isReturn) {
        set(Bits::Throws);
      }
    }
    void visitCallIndirect(CallIndirect* curr) {
      set(Bits::Calls);
      if (curr->isReturn) {
        set(Bits::BranchesOut);
        if (parent.features.hasExceptionHandling()) {
          parent.hasReturnCallThrow = true;
        }
      }
      if (parent.features.hasExceptionHandling() &&
          (parent.tryDepth == 0 && !curr->isReturn)) {
        set(Bits::Throws);
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
      set(Bits::ReadsMemory);
      if (curr->isAtomic()) {
        set(Bits::IsAtomic);
      }
      set(Bits::ImplicitTrap);
    }
    void visitStore(Store* curr) {
      set(Bits::WritesMemory);
      if (curr->isAtomic()) {
        set(Bits::IsAtomic);
      }
      set(Bits::ImplicitTrap);
    }
    void visitAtomicRMW(AtomicRMW* curr) {
      set(Bits::ReadsMemory | Bits::WritesMemory | Bits::IsAtomic |
          Bits::ImplicitTrap);
    }
    void visitAtomicCmpxchg(AtomicCmpxchg* curr) {
      set(Bits::ReadsMemory | Bits::WritesMemory | Bits::IsAtomic |
          Bits::ImplicitTrap);
    }
    void visitAtomicWait(AtomicWait* curr) {
      // AtomicWait doesn't strictly write memory, but it does modify the
      // waiters list associated with the specified address, which we can think
      // of as a write.
      set(Bits::ReadsMemory | Bits::WritesMemory | Bits::IsAtomic |
          Bits::ImplicitTrap);
    }
    void visitAtomicNotify(AtomicNotify* curr) {
      // AtomicNotify doesn't strictly write memory, but it does modify the
      // waiters list associated with the specified address, which we can think
      // of as a write.
      set(Bits::ReadsMemory | Bits::WritesMemory | Bits::IsAtomic |
          Bits::ImplicitTrap);
    }
    void visitAtomicFence(AtomicFence* curr) {
      // AtomicFence should not be reordered with any memory operations, so we
      // set these to true.
      set(Bits::ReadsMemory | Bits::WritesMemory | Bits::IsAtomic);
    }
    void visitPause(Pause* curr) {
      // We don't want this to be moved out of loops, but it doesn't otherwises
      // matter much how it gets reordered. Say we transfer control as a coarse
      // approximation of this.
      set(Bits::BranchesOut);
    }
    void visitSIMDExtract(SIMDExtract* curr) {}
    void visitSIMDReplace(SIMDReplace* curr) {}
    void visitSIMDShuffle(SIMDShuffle* curr) {}
    void visitSIMDTernary(SIMDTernary* curr) {}
    void visitSIMDShift(SIMDShift* curr) {}
    void visitSIMDLoad(SIMDLoad* curr) {
      set(Bits::ReadsMemory | Bits::ImplicitTrap);
    }
    void visitSIMDLoadStoreLane(SIMDLoadStoreLane* curr) {
      if (curr->isLoad()) {
        set(Bits::ReadsMemory);
      } else {
        set(Bits::WritesMemory);
      }
      set(Bits::ImplicitTrap);
    }
    void visitMemoryInit(MemoryInit* curr) {
      set(Bits::WritesMemory | Bits::ImplicitTrap);
    }
    void visitDataDrop(DataDrop* curr) {
      // data.drop does not actually write memory, but it does alter the size of
      // a segment, which can be noticeable later by memory.init, so we need to
      // mark it as having a global side effect of some kind.
      set(Bits::WritesMemory | Bits::ImplicitTrap);
    }
    void visitMemoryCopy(MemoryCopy* curr) {
      set(Bits::ReadsMemory | Bits::WritesMemory | Bits::ImplicitTrap);
    }
    void visitMemoryFill(MemoryFill* curr) {
      set(Bits::WritesMemory | Bits::ImplicitTrap);
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
          set(Bits::ImplicitTrap);
          break;
        }
        default: {
        }
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
              set(Bits::ImplicitTrap);
            } else if ((curr->op == DivSInt32 || curr->op == DivSInt64) &&
                       c->value.getInteger() == -1LL) {
              set(Bits::ImplicitTrap);
            }
          } else {
            set(Bits::ImplicitTrap);
          }
          break;
        }
        default: {
        }
      }
    }
    void visitSelect(Select* curr) {}
    void visitDrop(Drop* curr) {}
    void visitReturn(Return* curr) { set(Bits::BranchesOut); }
    void visitMemorySize(MemorySize* curr) {
      // memory.size accesses the size of the memory, and thus can be modeled as
      // reading memory. It is also sequentially consistent with other atomic
      // operations.
      set(Bits::ReadsMemory | Bits::IsAtomic);
    }
    void visitMemoryGrow(MemoryGrow* curr) {
      // memory.grow technically does a read-modify-write operation on the
      // memory size in the successful case, modifying the set of valid
      // addresses, and just a read operation in the failure case. It is
      // also sequentially consistent with other atomic operations.
      // TODO: find out if calls is necessary here
      set(Bits::Calls | Bits::ReadsMemory | Bits::WritesMemory |
          Bits::IsAtomic);
    }
    void visitRefNull(RefNull* curr) {}
    void visitRefIsNull(RefIsNull* curr) {}
    void visitRefFunc(RefFunc* curr) {}
    void visitRefEq(RefEq* curr) {}
    void visitTableGet(TableGet* curr) {
      set(Bits::ReadsTable | Bits::ImplicitTrap);
    }
    void visitTableSet(TableSet* curr) {
      set(Bits::WritesTable | Bits::ImplicitTrap);
    }
    void visitTableSize(TableSize* curr) { set(Bits::ReadsTable); }
    void visitTableGrow(TableGrow* curr) {
      // table.grow technically does a read-modify-write operation on the
      // table size in the successful case, modifying the set of valid
      // indices, and just a read operation in the failure case
      set(Bits::ReadsTable | Bits::WritesTable);
    }
    void visitTableFill(TableFill* curr) {
      set(Bits::WritesTable | Bits::ImplicitTrap);
    }
    void visitTableCopy(TableCopy* curr) {
      set(Bits::ReadsTable | Bits::WritesTable | Bits::ImplicitTrap);
    }
    void visitTableInit(TableInit* curr) {
      set(Bits::WritesTable | Bits::ImplicitTrap);
    }
    void visitElemDrop(ElemDrop* curr) { set(Bits::WritesTable); }
    void visitTry(Try* curr) {
      if (curr->delegateTarget.is()) {
        parent.delegateTargets.insert(curr->delegateTarget);
      }
    }
    void visitTryTable(TryTable* curr) {
      for (auto name : curr->catchDests) {
        parent.breakTargets.insert(name);
      }
    }
    void visitThrow(Throw* curr) {
      if (parent.tryDepth == 0) {
        set(Bits::Throws);
      }
    }
    void visitRethrow(Rethrow* curr) {
      if (parent.tryDepth == 0) {
        set(Bits::Throws);
      }
    }
    void visitThrowRef(ThrowRef* curr) {
      if (parent.tryDepth == 0) {
        set(Bits::Throws);
      }
      // Traps when the arg is null.
      set(Bits::ImplicitTrap);
    }
    void visitNop(Nop* curr) {}
    void visitUnreachable(Unreachable* curr) { set(Bits::Trap); }
    void visitPop(Pop* curr) {
      if (parent.catchDepth == 0) {
        set(Bits::DanglingPop);
      }
    }
    void visitTupleMake(TupleMake* curr) {}
    void visitTupleExtract(TupleExtract* curr) {}
    void visitRefI31(RefI31* curr) {}
    void visitI31Get(I31Get* curr) {
      // traps when the ref is null
      if (curr->i31->type.isNullable()) {
        set(Bits::ImplicitTrap);
      }
    }
    void visitCallRef(CallRef* curr) {
      if (curr->isReturn) {
        set(Bits::BranchesOut);
        if (parent.features.hasExceptionHandling()) {
          parent.hasReturnCallThrow = true;
        }
      }
      if (curr->target->type.isNull()) {
        set(Bits::Trap);
        return;
      }
      // traps when the call target is null
      if (curr->target->type.isNullable()) {
        set(Bits::ImplicitTrap);
      }

      set(Bits::Calls);
      if (parent.features.hasExceptionHandling() &&
          (parent.tryDepth == 0 && !curr->isReturn)) {
        set(Bits::Throws);
      }
    }
    void visitRefTest(RefTest* curr) {}
    void maybeHandleDescriptor(Expression* desc) {
      if (desc) {
        // Traps when the descriptor is null.
        if (desc->type.isNull()) {
          set(Bits::Trap);
        } else if (desc->type.isNullable()) {
          set(Bits::ImplicitTrap);
        }
      }
    }
    void visitRefCast(RefCast* curr) {
      // Traps if the cast fails.
      set(Bits::ImplicitTrap);
      maybeHandleDescriptor(curr->desc);
    }
    void visitRefGetDesc(RefGetDesc* curr) {
      // Traps if the ref is null.
      set(Bits::ImplicitTrap);
    }
    void visitBrOn(BrOn* curr) {
      parent.breakTargets.insert(curr->name);
      maybeHandleDescriptor(curr->desc);
    }
    void visitStructNew(StructNew* curr) { maybeHandleDescriptor(curr->desc); }
    void visitStructGet(StructGet* curr) {
      if (curr->ref->type == Type::unreachable) {
        return;
      }
      if (curr->ref->type.isNull()) {
        set(Bits::Trap);
        return;
      }
      if (curr->ref->type.getHeapType()
            .getStruct()
            .fields[curr->index]
            .mutable_ == Mutable) {
        set(Bits::ReadsMutableStruct);
      }
      // traps when the arg is null
      if (curr->ref->type.isNullable()) {
        set(Bits::ImplicitTrap);
      }
      switch (curr->order) {
        case MemoryOrder::Unordered:
          break;
        case MemoryOrder::SeqCst:
          // Synchronizes with other threads.
          set(Bits::IsAtomic);
          break;
        case MemoryOrder::AcqRel:
          // Only synchronizes if other threads can read the field.
          if (curr->ref->type.getHeapType().isShared()) {
            set(Bits::IsAtomic);
          }
          break;
      }
    }
    void visitStructSet(StructSet* curr) {
      if (curr->ref->type.isNull()) {
        set(Bits::Trap);
        return;
      }
      set(Bits::WritesStruct);
      // traps when the arg is null
      if (curr->ref->type.isNullable()) {
        set(Bits::ImplicitTrap);
      }
      if (curr->order != MemoryOrder::Unordered) {
        set(Bits::IsAtomic);
      }
    }
    void visitStructRMW(StructRMW* curr) {
      if (curr->ref->type.isNull()) {
        set(Bits::Trap);
        return;
      }
      assert(curr->order != MemoryOrder::Unordered);
      set(Bits::ReadsMutableStruct | Bits::WritesStruct | Bits::IsAtomic);
      if (curr->ref->type.isNullable()) {
        set(Bits::ImplicitTrap);
      }
    }
    void visitStructCmpxchg(StructCmpxchg* curr) {
      if (curr->ref->type.isNull()) {
        set(Bits::Trap);
        return;
      }
      assert(curr->order != MemoryOrder::Unordered);
      set(Bits::ReadsMutableStruct | Bits::WritesStruct | Bits::IsAtomic);
      if (curr->ref->type.isNullable()) {
        set(Bits::ImplicitTrap);
      }
    }
    void visitStructWait(StructWait* curr) {
      // struct.wait mutates an opaque waiter queue which isn't visible in user
      // code. Model this as a struct write which prevents reorderings (since
      // isAtomic == true).
      // TODO: Implicit trap only if ref is nullable.
      set(Bits::IsAtomic | Bits::ImplicitTrap | Bits::MayNotReturn |
          Bits::WritesStruct);

      if (curr->ref->type == Type::unreachable) {
        return;
      }

      // If the ref isn't `unreachable`, then the field must exist and be a
      // packed waitqueue due to validation.
      assert(curr->ref->type.isStruct());
      assert(curr->index <
             curr->ref->type.getHeapType().getStruct().fields.size());
      assert(curr->ref->type.getHeapType()
               .getStruct()
               .fields.at(curr->index)
               .packedType == Field::PackedType::WaitQueue);

      if (curr->ref->type.getHeapType()
            .getStruct()
            .fields.at(curr->index)
            .mutable_ == Mutable) {
        set(Bits::ReadsMutableStruct);
      }
    }
    void visitStructNotify(StructNotify* curr) {
      // struct.notify mutates an opaque waiter queue which isn't visible in
      // user code. Model this as a struct write which prevents reorderings
      // (since isAtomic == true).
      // TODO: Implicit trap only if ref is nullable.
      set(Bits::IsAtomic | Bits::ImplicitTrap | Bits::WritesStruct);
    }
    void visitArrayNew(ArrayNew* curr) {}
    void visitArrayNewData(ArrayNewData* curr) {
      // Traps on out of bounds access to segments or access to dropped
      // segments.
      set(Bits::ImplicitTrap);
    }
    void visitArrayNewElem(ArrayNewElem* curr) {
      // Traps on out of bounds access to segments or access to dropped
      // segments.
      set(Bits::ImplicitTrap);
    }
    void visitArrayNewFixed(ArrayNewFixed* curr) {}
    void visitArrayGet(ArrayGet* curr) {
      if (curr->ref->type.isNull()) {
        set(Bits::Trap);
        return;
      }
      // Traps when the arg is null or the index out of bounds.
      set(Bits::ReadsArray | Bits::ImplicitTrap);
    }
    void visitArraySet(ArraySet* curr) {
      if (curr->ref->type.isNull()) {
        set(Bits::Trap);
        return;
      }
      // Traps when the arg is null or the index out of bounds.
      set(Bits::WritesArray | Bits::ImplicitTrap);
    }
    void visitArrayLen(ArrayLen* curr) {
      if (curr->ref->type.isNull()) {
        set(Bits::Trap);
        return;
      }
      // traps when the arg is null
      if (curr->ref->type.isNullable()) {
        set(Bits::ImplicitTrap);
      }
    }
    void visitArrayCopy(ArrayCopy* curr) {
      if (curr->destRef->type.isNull() || curr->srcRef->type.isNull()) {
        set(Bits::Trap);
        return;
      }
      // Traps when a ref is null, or when out of bounds.
      set(Bits::ReadsArray | Bits::WritesArray | Bits::ImplicitTrap);
    }
    void visitArrayFill(ArrayFill* curr) {
      if (curr->ref->type.isNull()) {
        set(Bits::Trap);
        return;
      }
      // Traps when the destination is null or when out of bounds.
      set(Bits::WritesArray | Bits::ImplicitTrap);
    }
    template<typename ArrayInit> void visitArrayInit(ArrayInit* curr) {
      if (curr->ref->type.isNull()) {
        set(Bits::Trap);
        return;
      }
      // Traps when the destination is null, when out of bounds in source or
      // destination, or when the source segment has been dropped.
      set(Bits::WritesArray | Bits::ImplicitTrap);
    }
    void visitArrayInitData(ArrayInitData* curr) { visitArrayInit(curr); }
    void visitArrayInitElem(ArrayInitElem* curr) { visitArrayInit(curr); }
    void visitArrayRMW(ArrayRMW* curr) {
      if (curr->ref->type.isNull()) {
        set(Bits::Trap);
        return;
      }
      // Traps when the arg is null or the index out of bounds.
      set(Bits::ReadsArray | Bits::WritesArray | Bits::ImplicitTrap |
          Bits::IsAtomic);
      assert(curr->order != MemoryOrder::Unordered);
    }
    void visitArrayCmpxchg(ArrayCmpxchg* curr) {
      if (curr->ref->type.isNull()) {
        set(Bits::Trap);
        return;
      }
      // Traps when the arg is null or the index out of bounds.
      set(Bits::ReadsArray | Bits::WritesArray | Bits::ImplicitTrap |
          Bits::IsAtomic);
      assert(curr->order != MemoryOrder::Unordered);
    }
    void visitRefAs(RefAs* curr) {
      if (curr->op == AnyConvertExtern || curr->op == ExternConvertAny) {
        // These conversions are infallible.
        return;
      }
      // traps when the arg is not valid
      set(Bits::ImplicitTrap);
      // Note: We could be more precise here and report the lack of a possible
      // trap if the input is non-nullable (and also of the right kind for
      // RefAsFunc etc.). However, we have optimization passes that will
      // remove a RefAs in such a case (in OptimizeInstructions, and also
      // Vacuum in trapsNeverHappen mode), so duplicating that code here would
      // only help until the next time those optimizations run. As a tradeoff,
      // we keep the code here simpler, but it does mean another optimization
      // cycle may be needed in some cases.
      // TODO: This seems like an unnecessary tradeoff.
    }
    void visitStringNew(StringNew* curr) {
      // Traps when ref is null.
      set(Bits::ImplicitTrap);
      if (curr->op != StringNewFromCodePoint) {
        set(Bits::ReadsArray);
      }
    }
    void visitStringConst(StringConst* curr) {}
    void visitStringMeasure(StringMeasure* curr) {
      // Traps when ref is null.
      set(Bits::ImplicitTrap);
    }
    void visitStringEncode(StringEncode* curr) {
      // Traps when ref is null or we write out of bounds.
      set(Bits::ImplicitTrap | Bits::WritesArray);
    }
    void visitStringConcat(StringConcat* curr) {
      // Traps when an input is null.
      set(Bits::ImplicitTrap);
    }
    void visitStringEq(StringEq* curr) {
      if (curr->op == StringEqCompare) {
        // Traps when either input is null.
        if (curr->left->type.isNullable() || curr->right->type.isNullable()) {
          set(Bits::ImplicitTrap);
        }
      }
    }
    void visitStringTest(StringTest* curr) {}
    void visitStringWTF16Get(StringWTF16Get* curr) {
      // Traps when ref is null.
      set(Bits::ImplicitTrap);
    }
    void visitStringSliceWTF(StringSliceWTF* curr) {
      // Traps when ref is null.
      set(Bits::ImplicitTrap);
    }
    void visitContNew(ContNew* curr) {
      // Traps when curr->func is null ref.
      set(Bits::ImplicitTrap);
    }
    void visitContBind(ContBind* curr) {
      // Traps when curr->cont is null ref. The input continuation is modified,
      // as it will trap if resumed. This is a globally-noticeable effect, which
      // we model as a call for now, but we could in theory use something more
      // refined here (|ModifiesContinuation| perhaps, to parallel
      // |WritesMemory| etc.).
      set(Bits::ImplicitTrap | Bits::Calls);
    }
    void visitSuspend(Suspend* curr) {
      // Similar to resume/call: Suspending means that we execute arbitrary
      // other code before we may resume here.
      set(Bits::Calls);
      if (parent.features.hasExceptionHandling() && parent.tryDepth == 0) {
        set(Bits::Throws);
      }

      // A suspend may go unhandled and therefore trap.
      set(Bits::ImplicitTrap);
    }
    void visitResume(Resume* curr) {
      // The call acts as a kitchen sink effect. `resume` instructions accept
      // nullable continuation references and trap on null.
      set(Bits::Calls | Bits::ImplicitTrap);

      if (parent.features.hasExceptionHandling() && parent.tryDepth == 0) {
        set(Bits::Throws);
      }
    }
    void visitResumeThrow(ResumeThrow* curr) {
      // The call acts as a kitchen sink effect. `resume_throw` instructions
      // accept nullable continuation references and trap on null.
      set(Bits::Calls | Bits::ImplicitTrap);

      if (parent.features.hasExceptionHandling() && parent.tryDepth == 0) {
        set(Bits::Throws);
      }
    }
    void visitStackSwitch(StackSwitch* curr) {
      // The call acts as a kitchen sink effect. `switch` instructions accept
      // nullable continuation references and trap on null.
      set(Bits::Calls | Bits::ImplicitTrap);

      if (parent.features.hasExceptionHandling() && parent.tryDepth == 0) {
        set(Bits::Throws);
      }
    }
  };

public:
  // Helpers

  // See comment on invalidate() for the assumptions on the inputs here.
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
    if (get(Bits::BranchesOut) || hasExternalBreakTargets()) {
      effects |= SideEffects::Branches;
    }
    if (get(Bits::Calls)) {
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
    if (get(Bits::ReadsMemory)) {
      effects |= SideEffects::ReadsMemory;
    }
    if (get(Bits::WritesMemory)) {
      effects |= SideEffects::WritesMemory;
    }
    if (get(Bits::ReadsTable)) {
      effects |= SideEffects::ReadsTable;
    }
    if (get(Bits::WritesTable)) {
      effects |= SideEffects::WritesTable;
    }
    if (get(Bits::ImplicitTrap)) {
      effects |= SideEffects::ImplicitTrap;
    }
    if (trapsNeverHappen) {
      effects |= SideEffects::TrapsNeverHappen;
    }
    if (get(Bits::IsAtomic)) {
      effects |= SideEffects::IsAtomic;
    }
    if (get(Bits::Throws)) {
      effects |= SideEffects::Throws;
    }
    if (get(Bits::DanglingPop)) {
      effects |= SideEffects::DanglingPop;
    }
    return effects;
  }

  // Ignores all forms of control flow transfers: breaks, returns, and
  // exceptions. (Note that traps are not considered relevant here - a trap does
  // not just transfer control flow, but can be seen as halting the entire
  // program.)
  //
  // This function matches transfersControlFlow(), that is, after calling this
  // method transfersControlFlow() will always return false.
  void ignoreControlFlowTransfers() {
    set(Bits::BranchesOut | Bits::Throws, false);
    breakTargets.clear();
    delegateTargets.clear();
    assert(!transfersControlFlow());
  }

private:
  void post() {
    assert(tryDepth == 0);

    if (ignoreImplicitTraps) {
      set(Bits::ImplicitTrap, false);
    } else if (get(Bits::ImplicitTrap)) {
      set(Bits::Trap);
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

namespace std {
std::ostream& operator<<(std::ostream& o, wasm::EffectAnalyzer& effects);
} // namespace std

#endif // wasm_ir_effects_h
