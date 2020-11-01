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

#include "pass.h"
#include "wasm-traversal.h"

namespace wasm {

// Look for side effects, including control flow
// TODO: optimize

struct EffectAnalyzer
  : public PostWalker<EffectAnalyzer, OverriddenVisitor<EffectAnalyzer>> {
  EffectAnalyzer(const PassOptions& passOptions,
                 FeatureSet features,
                 Expression* ast = nullptr)
    : ignoreImplicitTraps(passOptions.ignoreImplicitTraps),
      debugInfo(passOptions.debugInfo), features(features) {
    if (ast) {
      analyze(ast);
    }
    if (ignoreImplicitTraps) {
      implicitTrap = false;
    }
  }

  bool ignoreImplicitTraps;
  bool debugInfo;
  FeatureSet features;

  void analyze(Expression* ast) {
    breakTargets.clear();
    walk(ast);
    assert(tryDepth == 0);
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
  std::set<Name> globalsRead;
  std::set<Name> globalsWritten;
  bool readsMemory = false;
  bool writesMemory = false;
  // a load or div/rem, which may trap. we ignore trap differences, so it is ok
  // to reorder these, but we can't remove them, as they count as side effects,
  // and we can't move them in a way that would cause other noticeable (global)
  // side effects
  bool implicitTrap = false;
  // An atomic load/store/RMW/Cmpxchg or an operator that has a defined ordering
  // wrt atomics (e.g. memory.grow)
  bool isAtomic = false;
  bool throws = false;
  // The nested depth of try. If an instruction that may throw is inside an
  // inner try, we don't mark it as 'throws', because it will be caught by an
  // inner catch.
  size_t tryDepth = 0;
  // The nested depth of catch. This is necessary to track danglng pops.
  size_t catchDepth = 0;
  // If this expression contains 'exnref.pop's that are not enclosed in 'catch'
  // body. For example, (drop (exnref.pop)) should set this to true.
  bool danglingPop = false;

  static void scan(EffectAnalyzer* self, Expression** currp) {
    Expression* curr = *currp;
    // We need to decrement try depth before catch starts, so handle it
    // separately
    if (curr->is<Try>()) {
      self->pushTask(doVisitTry, currp);
      self->pushTask(doEndCatch, currp);
      self->pushTask(scan, &curr->cast<Try>()->catchBody);
      self->pushTask(doStartCatch, currp);
      self->pushTask(scan, &curr->cast<Try>()->body);
      self->pushTask(doStartTry, currp);
      return;
    }
    PostWalker<EffectAnalyzer, OverriddenVisitor<EffectAnalyzer>>::scan(self,
                                                                        currp);
  }

  static void doStartTry(EffectAnalyzer* self, Expression** currp) {
    self->tryDepth++;
  }

  static void doStartCatch(EffectAnalyzer* self, Expression** currp) {
    assert(self->tryDepth > 0 && "try depth cannot be negative");
    self->tryDepth--;
    self->catchDepth++;
  }

  static void doEndCatch(EffectAnalyzer* self, Expression** currp) {
    assert(self->catchDepth > 0 && "catch depth cannot be negative");
    self->catchDepth--;
  }

  // Helper functions to check for various effect types

  bool accessesLocal() const {
    return localsRead.size() + localsWritten.size() > 0;
  }
  bool accessesGlobal() const {
    return globalsRead.size() + globalsWritten.size() > 0;
  }
  bool accessesMemory() const { return calls || readsMemory || writesMemory; }
  // Check whether this may transfer control flow to somewhere outside of this
  // expression (aside from just flowing out normally). That includes a break
  // or a throw (if the throw is not known to be caught inside this expression;
  // note that if the throw is not caught in this expression then it might be
  // caught in this function but outside of this expression, or it might not be
  // caught in the function at all, which would mean control flow cannot be
  // transferred inside the function, but this expression does not know that).
  bool transfersControlFlow() const {
    return branchesOut || throws || hasExternalBreakTargets();
  }

  bool hasGlobalSideEffects() const {
    return calls || globalsWritten.size() > 0 || writesMemory || isAtomic ||
           throws;
  }
  bool hasSideEffects() const {
    return implicitTrap || localsWritten.size() > 0 || danglingPop ||
           hasGlobalSideEffects() || transfersControlFlow();
  }
  bool hasAnything() const {
    return readsMemory || isAtomic || accessesLocal() || hasSideEffects() ||
           accessesGlobal();
  }

  bool noticesGlobalSideEffects() const {
    return calls || readsMemory || isAtomic || globalsRead.size();
  }

  // check if we break to anything external from ourselves
  bool hasExternalBreakTargets() const { return !breakTargets.empty(); }

  // checks if these effects would invalidate another set (e.g., if we write, we
  // invalidate someone that reads, they can't be moved past us)
  bool invalidates(const EffectAnalyzer& other) {
    if ((transfersControlFlow() && other.hasSideEffects()) ||
        (other.transfersControlFlow() && hasSideEffects()) ||
        ((writesMemory || calls) && other.accessesMemory()) ||
        (accessesMemory() && (other.writesMemory || other.calls)) ||
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
      if (other.localsWritten.count(local) || other.localsRead.count(local)) {
        return true;
      }
    }
    for (auto local : localsRead) {
      if (other.localsWritten.count(local)) {
        return true;
      }
    }
    if ((accessesGlobal() && other.calls) ||
        (other.accessesGlobal() && calls)) {
      return true;
    }
    for (auto global : globalsWritten) {
      if (other.globalsWritten.count(global) ||
          other.globalsRead.count(global)) {
        return true;
      }
    }
    for (auto global : globalsRead) {
      if (other.globalsWritten.count(global)) {
        return true;
      }
    }
    // we are ok to reorder implicit traps, but not conditionalize them
    if ((implicitTrap && other.transfersControlFlow()) ||
        (other.implicitTrap && transfersControlFlow())) {
      return true;
    }
    // we can't reorder an implicit trap in a way that alters global state
    if ((implicitTrap && other.hasGlobalSideEffects()) ||
        (other.implicitTrap && hasGlobalSideEffects())) {
      return true;
    }
    return false;
  }

  void mergeIn(EffectAnalyzer& other) {
    branchesOut = branchesOut || other.branchesOut;
    calls = calls || other.calls;
    readsMemory = readsMemory || other.readsMemory;
    writesMemory = writesMemory || other.writesMemory;
    implicitTrap = implicitTrap || other.implicitTrap;
    isAtomic = isAtomic || other.isAtomic;
    throws = throws || other.throws;
    danglingPop = danglingPop || other.danglingPop;
    for (auto i : other.localsRead) {
      localsRead.insert(i);
    }
    for (auto i : other.localsWritten) {
      localsWritten.insert(i);
    }
    for (auto i : other.globalsRead) {
      globalsRead.insert(i);
    }
    for (auto i : other.globalsWritten) {
      globalsWritten.insert(i);
    }
    for (auto i : other.breakTargets) {
      breakTargets.insert(i);
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

  void visitBlock(Block* curr) {
    if (curr->name.is()) {
      breakTargets.erase(curr->name); // these were internal breaks
    }
  }
  void visitIf(If* curr) {}
  void visitLoop(Loop* curr) {
    if (curr->name.is()) {
      breakTargets.erase(curr->name); // these were internal breaks
    }
    // if the loop is unreachable, then there is branching control flow:
    //  (1) if the body is unreachable because of a (return), uncaught (br)
    //      etc., then we already noted branching, so it is ok to mark it again
    //      (if we have *caught* (br)s, then they did not lead to the loop body
    //      being unreachable). (same logic applies to blocks)
    //  (2) if the loop is unreachable because it only has branches up to the
    //      loop top, but no way to get out, then it is an infinite loop, and we
    //      consider that a branching side effect (note how the same logic does
    //      not apply to blocks).
    if (curr->type == Type::unreachable) {
      branchesOut = true;
    }
  }
  void visitBreak(Break* curr) { breakTargets.insert(curr->name); }
  void visitSwitch(Switch* curr) {
    for (auto name : curr->targets) {
      breakTargets.insert(name);
    }
    breakTargets.insert(curr->default_);
  }

  void visitCall(Call* curr) {
    calls = true;
    // When EH is enabled, any call can throw.
    if (features.hasExceptionHandling() && tryDepth == 0) {
      throws = true;
    }
    if (curr->isReturn) {
      branchesOut = true;
    }
    if (debugInfo) {
      // debugInfo call imports must be preserved very strongly, do not
      // move code around them
      // FIXME: we could check if the call is to an import
      branchesOut = true;
    }
  }
  void visitCallIndirect(CallIndirect* curr) {
    calls = true;
    if (features.hasExceptionHandling() && tryDepth == 0) {
      throws = true;
    }
    if (curr->isReturn) {
      branchesOut = true;
    }
  }
  void visitLocalGet(LocalGet* curr) { localsRead.insert(curr->index); }
  void visitLocalSet(LocalSet* curr) { localsWritten.insert(curr->index); }
  void visitGlobalGet(GlobalGet* curr) { globalsRead.insert(curr->name); }
  void visitGlobalSet(GlobalSet* curr) { globalsWritten.insert(curr->name); }
  void visitLoad(Load* curr) {
    readsMemory = true;
    isAtomic |= curr->isAtomic;
    implicitTrap = true;
  }
  void visitStore(Store* curr) {
    writesMemory = true;
    isAtomic |= curr->isAtomic;
    implicitTrap = true;
  }
  void visitAtomicRMW(AtomicRMW* curr) {
    readsMemory = true;
    writesMemory = true;
    isAtomic = true;
    implicitTrap = true;
  }
  void visitAtomicCmpxchg(AtomicCmpxchg* curr) {
    readsMemory = true;
    writesMemory = true;
    isAtomic = true;
    implicitTrap = true;
  }
  void visitAtomicWait(AtomicWait* curr) {
    readsMemory = true;
    // AtomicWait doesn't strictly write memory, but it does modify the waiters
    // list associated with the specified address, which we can think of as a
    // write.
    writesMemory = true;
    isAtomic = true;
    implicitTrap = true;
  }
  void visitAtomicNotify(AtomicNotify* curr) {
    // AtomicNotify doesn't strictly write memory, but it does modify the
    // waiters list associated with the specified address, which we can think of
    // as a write.
    readsMemory = true;
    writesMemory = true;
    isAtomic = true;
    implicitTrap = true;
  }
  void visitAtomicFence(AtomicFence* curr) {
    // AtomicFence should not be reordered with any memory operations, so we set
    // these to true.
    readsMemory = true;
    writesMemory = true;
    isAtomic = true;
  }
  void visitSIMDExtract(SIMDExtract* curr) {}
  void visitSIMDReplace(SIMDReplace* curr) {}
  void visitSIMDShuffle(SIMDShuffle* curr) {}
  void visitSIMDTernary(SIMDTernary* curr) {}
  void visitSIMDShift(SIMDShift* curr) {}
  void visitSIMDLoad(SIMDLoad* curr) {
    readsMemory = true;
    implicitTrap = true;
  }
  void visitSIMDLoadStoreLane(SIMDLoadStoreLane* curr) {
    if (curr->isLoad()) {
      readsMemory = true;
    } else {
      writesMemory = true;
    }
    implicitTrap = true;
  }
  void visitMemoryInit(MemoryInit* curr) {
    writesMemory = true;
    implicitTrap = true;
  }
  void visitDataDrop(DataDrop* curr) {
    // data.drop does not actually write memory, but it does alter the size of
    // a segment, which can be noticeable later by memory.init, so we need to
    // mark it as having a global side effect of some kind.
    writesMemory = true;
    implicitTrap = true;
  }
  void visitMemoryCopy(MemoryCopy* curr) {
    readsMemory = true;
    writesMemory = true;
    implicitTrap = true;
  }
  void visitMemoryFill(MemoryFill* curr) {
    writesMemory = true;
    implicitTrap = true;
  }
  void visitConst(Const* curr) {}
  void visitUnary(Unary* curr) {
    if (!ignoreImplicitTraps && !implicitTrap) {
      switch (curr->op) {
        case TruncSFloat32ToInt32:
        case TruncSFloat32ToInt64:
        case TruncUFloat32ToInt32:
        case TruncUFloat32ToInt64:
        case TruncSFloat64ToInt32:
        case TruncSFloat64ToInt64:
        case TruncUFloat64ToInt32:
        case TruncUFloat64ToInt64: {
          implicitTrap = true;
          break;
        }
        default: {
        }
      }
    }
  }
  void visitBinary(Binary* curr) {
    if (!ignoreImplicitTraps && !implicitTrap) {
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
          // signed operations
          implicitTrap = true;
          if (auto* c = curr->right->dynCast<Const>()) {
            implicitTrap = c->value.isZero() ||
                           ((curr->op == DivSInt32 || curr->op == DivSInt64 ||
                             curr->op == RemSInt32 || curr->op == RemSInt64) &&
                            c->value.getInteger() == -1LL);
          }
          break;
        }
        default: {
        }
      }
    }
  }
  void visitSelect(Select* curr) {}
  void visitDrop(Drop* curr) {}
  void visitReturn(Return* curr) { branchesOut = true; }
  void visitMemorySize(MemorySize* curr) {
    // memory.size accesses the size of the memory, and thus can be modeled as
    // reading memory
    readsMemory = true;
    // Atomics are sequentially consistent with memory.size.
    isAtomic = true;
  }
  void visitMemoryGrow(MemoryGrow* curr) {
    calls = true;
    // memory.grow technically does a read-modify-write operation on the memory
    // size in the successful case, modifying the set of valid addresses, and
    // just a read operation in the failure case
    readsMemory = true;
    writesMemory = true;
    // Atomics are also sequentially consistent with memory.grow.
    isAtomic = true;
  }
  void visitRefNull(RefNull* curr) {}
  void visitRefIsNull(RefIsNull* curr) {}
  void visitRefFunc(RefFunc* curr) {}
  void visitRefEq(RefEq* curr) {}
  void visitTry(Try* curr) {}
  void visitThrow(Throw* curr) {
    if (tryDepth == 0) {
      throws = true;
    }
  }
  void visitRethrow(Rethrow* curr) {
    if (tryDepth == 0) {
      throws = true;
    }
    // rethrow traps when the arg is null
    implicitTrap = true;
  }
  void visitBrOnExn(BrOnExn* curr) {
    breakTargets.insert(curr->name);
    // br_on_exn traps when the arg is null
    implicitTrap = true;
  }
  void visitNop(Nop* curr) {}
  void visitUnreachable(Unreachable* curr) { branchesOut = true; }
  void visitPop(Pop* curr) {
    if (catchDepth == 0) {
      danglingPop = true;
    }
  }
  void visitTupleMake(TupleMake* curr) {}
  void visitTupleExtract(TupleExtract* curr) {}
  void visitI31New(I31New* curr) {}
  void visitI31Get(I31Get* curr) {}
  void visitRefTest(RefTest* curr) { WASM_UNREACHABLE("TODO (gc): ref.test"); }
  void visitRefCast(RefCast* curr) { WASM_UNREACHABLE("TODO (gc): ref.cast"); }
  void visitBrOnCast(BrOnCast* curr) {
    WASM_UNREACHABLE("TODO (gc): br_on_cast");
  }
  void visitRttCanon(RttCanon* curr) {
    WASM_UNREACHABLE("TODO (gc): rtt.canon");
  }
  void visitRttSub(RttSub* curr) { WASM_UNREACHABLE("TODO (gc): rtt.sub"); }
  void visitStructNew(StructNew* curr) {
    WASM_UNREACHABLE("TODO (gc): struct.new");
  }
  void visitStructGet(StructGet* curr) {
    WASM_UNREACHABLE("TODO (gc): struct.get");
  }
  void visitStructSet(StructSet* curr) {
    WASM_UNREACHABLE("TODO (gc): struct.set");
  }
  void visitArrayNew(ArrayNew* curr) {
    WASM_UNREACHABLE("TODO (gc): array.new");
  }
  void visitArrayGet(ArrayGet* curr) {
    WASM_UNREACHABLE("TODO (gc): array.get");
  }
  void visitArraySet(ArraySet* curr) {
    WASM_UNREACHABLE("TODO (gc): array.set");
  }
  void visitArrayLen(ArrayLen* curr) {
    WASM_UNREACHABLE("TODO (gc): array.len");
  }

  // Helpers

  static bool canReorder(const PassOptions& passOptions,
                         FeatureSet features,
                         Expression* a,
                         Expression* b) {
    EffectAnalyzer aEffects(passOptions, features, a);
    EffectAnalyzer bEffects(passOptions, features, b);
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
    ImplicitTrap = 1 << 8,
    IsAtomic = 1 << 9,
    Throws = 1 << 10,
    DanglingPop = 1 << 11,
    Any = (1 << 12) - 1
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
    if (globalsRead.size() > 0) {
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
    if (implicitTrap) {
      effects |= SideEffects::ImplicitTrap;
    }
    if (isAtomic) {
      effects |= SideEffects::IsAtomic;
    }
    if (throws) {
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
};

} // namespace wasm

#endif // wasm_ir_effects_h
