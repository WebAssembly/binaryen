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

namespace wasm {

// Look for side effects, including control flow
// TODO: optimize

struct EffectAnalyzer : public PostWalker<EffectAnalyzer> {
  EffectAnalyzer(PassOptions& passOptions, Expression *ast = nullptr) {
    ignoreImplicitTraps = passOptions.ignoreImplicitTraps;
    debugInfo = passOptions.debugInfo;
    if (ast) analyze(ast);
  }

  bool ignoreImplicitTraps;
  bool debugInfo;

  void analyze(Expression *ast) {
    breakNames.clear();
    walk(ast);
    // if we are left with breaks, they are external
    if (breakNames.size() > 0) branches = true;
  }

  // Core effect tracking

  bool branches = false; // branches out of this expression, returns, infinite loops, etc
  bool calls = false;
  std::set<Index> localsRead;
  std::set<Index> localsWritten;
  std::set<Name> globalsRead;
  std::set<Name> globalsWritten;
  bool readsMemory = false;
  bool writesMemory = false;
  bool implicitTrap = false; // a load or div/rem, which may trap. we ignore trap
                             // differences, so it is ok to reorder these, but we can't
                             // remove them, as they count as side effects, and we
                             // can't move them in a way that would cause other noticeable
                             // (global) side effects
  bool isAtomic = false; // An atomic load/store/RMW/Cmpxchg or an operator that
                         // has a defined ordering wrt atomics (e.g. grow_memory)

  // Helper functions to check for various effect types

  bool accessesLocal() { return localsRead.size() + localsWritten.size() > 0; }
  bool accessesGlobal() { return globalsRead.size() + globalsWritten.size() > 0; }
  bool accessesMemory() { return calls || readsMemory || writesMemory; }

  bool hasGlobalSideEffects() { return calls || globalsWritten.size() > 0 || writesMemory || isAtomic; }
  bool hasSideEffects() { return hasGlobalSideEffects() || localsWritten.size() > 0 || branches || implicitTrap; }
  bool hasAnything() { return branches || calls || accessesLocal() || readsMemory || writesMemory || accessesGlobal() || implicitTrap || isAtomic; }

  bool noticesGlobalSideEffects() { return calls || readsMemory || isAtomic || globalsRead.size(); }

  // check if we break to anything external from ourselves
  bool hasExternalBreakTargets() { return !breakNames.empty(); }

  // checks if these effects would invalidate another set (e.g., if we write, we invalidate someone that reads, they can't be moved past us)
  bool invalidates(EffectAnalyzer& other) {
    if ((branches && other.hasSideEffects()) ||
        (other.branches && hasSideEffects()) ||
        ((writesMemory || calls) && other.accessesMemory()) ||
        (accessesMemory() && (other.writesMemory || other.calls))) {
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
      if (other.localsWritten.count(local)) return true;
    }
    if ((accessesGlobal() && other.calls) || (other.accessesGlobal() && calls)) {
      return true;
    }
    for (auto global : globalsWritten) {
      if (other.globalsWritten.count(global) || other.globalsRead.count(global)) {
        return true;
      }
    }
    for (auto global : globalsRead) {
      if (other.globalsWritten.count(global)) return true;
    }
    // we are ok to reorder implicit traps, but not conditionalize them
    if ((implicitTrap && other.branches) || (other.implicitTrap && branches)) {
      return true;
    }
    // we can't reorder an implicit trap in a way that alters global state
    if ((implicitTrap && other.hasGlobalSideEffects()) || (other.implicitTrap && hasGlobalSideEffects())) {
      return true;
    }
    return false;
  }

  void mergeIn(EffectAnalyzer& other) {
    branches = branches || other.branches;
    calls = calls || other.calls;
    readsMemory = readsMemory || other.readsMemory;
    writesMemory = writesMemory || other.writesMemory;
    implicitTrap = implicitTrap || other.implicitTrap;
    isAtomic = isAtomic || other.isAtomic;
    for (auto i : other.localsRead) localsRead.insert(i);
    for (auto i : other.localsWritten) localsWritten.insert(i);
    for (auto i : other.globalsRead) globalsRead.insert(i);
    for (auto i : other.globalsWritten) globalsWritten.insert(i);
  }

  // the checks above happen after the node's children were processed, in the order of execution
  // we must also check for control flow that happens before the children, i.e., loops
  bool checkPre(Expression* curr) {
    if (curr->is<Loop>()) {
      branches = true;
      return true;
    }
    return false;
  }

  bool checkPost(Expression* curr) {
    visit(curr);
    if (curr->is<Loop>()) {
      branches = true;
    }
    return hasAnything();
  }

  std::set<Name> breakNames;

  void visitBreak(Break *curr) {
    breakNames.insert(curr->name);
  }
  void visitSwitch(Switch *curr) {
    for (auto name : curr->targets) {
      breakNames.insert(name);
    }
    breakNames.insert(curr->default_);
  }
  void visitBlock(Block* curr) {
    if (curr->name.is()) breakNames.erase(curr->name); // these were internal breaks
  }
  void visitLoop(Loop* curr) {
    if (curr->name.is()) breakNames.erase(curr->name); // these were internal breaks
    // if the loop is unreachable, then there is branching control flow:
    //  (1) if the body is unreachable because of a (return), uncaught (br) etc., then we
    //      already noted branching, so it is ok to mark it again  (if we have *caught*
    //      (br)s, then they did not lead to the loop body being unreachable).
    //      (same logic applies to blocks)
    //  (2) if the loop is unreachable because it only has branches up to the loop
    //      top, but no way to get out, then it is an infinite loop, and we consider
    //      that a branching side effect (note how the same logic does not apply to
    //      blocks).
    if (curr->type == unreachable) {
      branches = true;
    }
  }

  void visitCall(Call *curr) {
    calls = true;
    if (debugInfo) {
      // debugInfo call imports must be preserved very strongly, do not
      // move code around them
      // FIXME: we could check if the call is to an import
      branches = true;
    }
  }
  void visitCallIndirect(CallIndirect *curr) { calls = true; }
  void visitGetLocal(GetLocal *curr) {
    localsRead.insert(curr->index);
  }
  void visitSetLocal(SetLocal *curr) {
    localsWritten.insert(curr->index);
  }
  void visitGetGlobal(GetGlobal *curr) {
    globalsRead.insert(curr->name);
  }
  void visitSetGlobal(SetGlobal *curr) {
    globalsWritten.insert(curr->name);
  }
  void visitLoad(Load *curr) {
    readsMemory = true;
    isAtomic |= curr->isAtomic;
    if (!ignoreImplicitTraps) implicitTrap = true;
  }
  void visitStore(Store *curr) {
    writesMemory = true;
    isAtomic |= curr->isAtomic;
    if (!ignoreImplicitTraps) implicitTrap = true;
  }
  void visitAtomicRMW(AtomicRMW* curr) {
    readsMemory = true;
    writesMemory = true;
    isAtomic = true;
    if (!ignoreImplicitTraps) implicitTrap = true;
  }
  void visitAtomicCmpxchg(AtomicCmpxchg* curr) {
    readsMemory = true;
    writesMemory = true;
    isAtomic = true;
    if (!ignoreImplicitTraps) implicitTrap = true;
  }
  void visitAtomicWait(AtomicWait* curr) {
    readsMemory = true;
    // AtomicWait doesn't strictly write memory, but it does modify the waiters
    // list associated with the specified address, which we can think of as a
    // write.
    writesMemory = true;
    isAtomic = true;
    if (!ignoreImplicitTraps) implicitTrap = true;
  }
  void visitAtomicWake(AtomicWake* curr) {
    // AtomicWake doesn't strictly write memory, but it does modify the waiters
    // list associated with the specified address, which we can think of as a
    // write.
    readsMemory = true;
    writesMemory = true;
    isAtomic = true;
    if (!ignoreImplicitTraps) implicitTrap = true;
  };
  void visitUnary(Unary *curr) {
    if (!ignoreImplicitTraps) {
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
        default: {}
      }
    }
  }
  void visitBinary(Binary *curr) {
    if (!ignoreImplicitTraps) {
      switch (curr->op) {
        case DivSInt32:
        case DivUInt32:
        case RemSInt32:
        case RemUInt32:
        case DivSInt64:
        case DivUInt64:
        case RemSInt64:
        case RemUInt64: {
          implicitTrap = true;
          break;
        }
        default: {}
      }
    }
  }
  void visitReturn(Return *curr) { branches = true; }
  void visitHost(Host *curr) {
    calls = true;
    // grow_memory modifies the set of valid addresses, and thus can be modeled as modifying memory
    writesMemory = true;
    // Atomics are also sequentially consistent with grow_memory.
    isAtomic = true;
  }
  void visitUnreachable(Unreachable *curr) { branches = true; }

  // Helpers

  static bool canReorder(PassOptions& passOptions, Expression* a, Expression* b) {
    EffectAnalyzer aEffects(passOptions, a);
    EffectAnalyzer bEffects(passOptions, b);
    return !aEffects.invalidates(bEffects);
  }
};

} // namespace wasm

#endif // wasm_ir_effects_h
