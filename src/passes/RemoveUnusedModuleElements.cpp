/*
 * Copyright 2016 WebAssembly Community Group participants
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
// Removes module elements that are not needed: functions, globals, tags, etc.
// Basically "global dead code elimination" but not just for code.
//
// To do this properly, we need to consider that an element may be in one of
// three states:
//
//  * No references at all. We can simply remove it.
//  * References, but no uses. We can't remove it, but we can change it.
//  * Uses (which implies references). We must keep it.
//
// An example of something with a reference but *not* a use is a RefFunc to a
// function that has no corresponding CallRef to that type. We cannot just
// remove the function, since the RefFunc must refer to an actual entity in the
// IR, but we know it isn't actually used/called, so we can change it - we can
// empty out the body and put an unreachable there, for example. That is, a
// reference forces us to keep something in the IR to be referred to, (but only
// a use actually makes us keep its contents as well.
//

#include <memory>

#include "ir/element-utils.h"
#include "ir/find_all.h"
#include "ir/intrinsics.h"
#include "ir/module-utils.h"
#include "ir/subtypes.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

// TODO: Add data segment, multiple memories (#5224)
enum class ModuleElementKind { Function, Global, Tag, Table, ElementSegment };

using ModuleElement = std::pair<ModuleElementKind, Name>;

// Finds reachabilities
// TODO: use Effects to determine if a memory is used
// This pass does not have multi-memories support

struct ReachabilityAnalyzer : public Visitor<ReachabilityAnalyzer> {
  Module* module;
  const PassOptions& options;

  // The set of all used things we've seen so far.
  std::unordered_set<ModuleElement> used;

  // Things for whom there is a reference, but may be unused. It is ok for a
  // thing to appear both in |used| and here; we will check |used| first anyhow.
  // (That is, we don't need to be careful to remove things from here if they
  // begin as referenced and later become used.)
  std::unordered_set<ModuleElement> referenced;

  // A queue of used module elements that we need to process. These appear
  // in |used|, and the work we do when we pop them from the queue is to
  // look at the things they reach that might become referenced or used.
  std::vector<ModuleElement> moduleQueue;

  // A stack of used expressions to walk. We do *not* use the normal
  // walking mechanism because we need more control. Specifically, we may defer
  // certain walks, such as this:
  //
  //   new Foo{ &func1 }
  // i.e.
  //   (struct.new $Foo (ref.func $func1))
  //
  // If we walked the child immediately then we would make $func1 used. But
  // that function is only reached if we actually read that field from the
  // struct. We perform that analysis in readStructFields /
  // unreadStructFieldExprMap, below.
  std::vector<Expression*> expressionQueue;

  bool usesMemory = false;

  // The signatures that we have seen a call_ref for. When we see a RefFunc of a
  // signature in here, we know it is used; otherwise it may only be referred
  // to.
  std::unordered_set<HeapType> calledSignatures;

  // All the RefFuncs we've seen, grouped by heap type. When we see a CallRef of
  // one of the types here, we know all the RefFuncs corresponding to it are
  // used. This is the reverse side of calledSignatures: for a function to
  // be reached via a reference, we need the combination of a RefFunc of it as
  // well as a CallRef of that, and we may see them in any order. (Or, if the
  // RefFunc is in a table, we need a CallIndirect, which is handled in the
  // table logic.)
  //
  // After we see a call for a type, we can clear out the entry here for it, as
  // we'll have that type in calledSignatures, and so this contains only
  // RefFuncs that we have not seen a call for yet, hence "uncalledRefFuncMap."
  //
  // We can only do this when assuming a closed world. TODO: In an open world we
  // could carefully track which types actually escape out to exports or
  // imports.
  std::unordered_map<HeapType, std::unordered_set<Name>> uncalledRefFuncMap;

  // A pair of a struct type and a field index, together defining a field in a
  // particular type.
  using StructField = std::pair<HeapType, Index>;

  // Similar to calledSignatures/uncalledRefFuncMap, we store the StructFields
  // we've seen reads from, and also expressions stored in such fields that could be
  // read if ever we see a read of that field in the future. That is, for an
  // expression stored into a struct field to be read, we need to both see that
  // expression written to the field, and see some other place read that field
  // (similar to with functions that we need to see the RefFunc and also a
  // CallRef that can actually call it).
  std::unordered_set<StructField> readStructFields;
  std::unordered_map<StructField, std::vector<Expression*>>
    unreadStructFieldExprMap;

  ReachabilityAnalyzer(Module* module,
                       const PassOptions& options,
                       const std::vector<ModuleElement>& roots)
    : module(module), options(options) {

    for (auto& element : roots) {
      used.insert(element);
      moduleQueue.push_back(element);
    }

    // Globals used in memory/table init expressions are also roots
    for (auto& segment : module->dataSegments) {
      if (!segment->isPassive) {
        expressionQueue.push_back(segment->offset);
      }
    }
    for (auto& segment : module->elementSegments) {
      if (segment->table.is()) {
        expressionQueue.push_back(segment->offset);
      }
    }

    // Main loop on both the module queue and the expression stack.
    while (expressionQueue.size() || moduleQueue.size()) {
      while (expressionQueue.size()) {
        auto* curr = expressionQueue.back();
        expressionQueue.pop_back();

        visit(curr);
        maybeWalkChildren(curr);
      }

      while (moduleQueue.size()) {
        auto curr = moduleQueue.back();
        moduleQueue.pop_back();

        assert(used.count(curr));
        auto& [kind, value] = curr;
        if (kind == ModuleElementKind::Function) {
          // if not an import, walk it
          auto* func = module->getFunction(value);
          if (!func->imported()) {
            expressionQueue.push_back(func->body);
          }
        } else if (kind == ModuleElementKind::Global) {
          // if not imported, it has an init expression we can walk
          auto* global = module->getGlobal(value);
          if (!global->imported()) {
            expressionQueue.push_back(global->init);
          }
        } else if (kind == ModuleElementKind::Table) {
          ModuleUtils::iterTableSegments(
            *module, value, [&](ElementSegment* segment) {
              expressionQueue.push_back(segment->offset);
            });
        }
      }
    }
  }

  void maybeAdd(ModuleElement element) {
    if (used.emplace(element).second) {
      moduleQueue.emplace_back(element);
    }
  }

  // Add a reference to a table and all its segments and elements.
  void maybeAddTable(Name name) {
    maybeAdd(ModuleElement(ModuleElementKind::Table, name));
    ModuleUtils::iterTableSegments(*module, name, [&](ElementSegment* segment) {
      maybeAdd(ModuleElement(ModuleElementKind::ElementSegment, segment->name));
    });
  }

  void maybeWalkChildren(Expression* curr) {
    auto walkChildren = [&]() {
      for (auto* child : ChildIterator(curr)) {
        expressionQueue.push_back(child);
      }
    };

    // For now, the only special handling we have is fields of struct.new, which
    // we defer walking of to when we know there is a read that can actually
    // read them, see comments above on |expressionQueue|.

    if (!options.closedWorld) {
      // If we are in open world then we cannot optimize based on which struct
      // fields we see read, since reads can happen on the outside.
      walkChildren();
      return;
    }

    auto* new_ = curr->dynCast<StructNew>();
    if (!new_) {
      walkChildren();
      return;
    }

    auto type = curr->type.getHeapType();
    for (Index i = 0; i < new_->operands.size(); i++) {
      // TODO: We could recurse into nested StructNew operations. For now,
      //       just look at the top level. That is enough for a vtable.
      auto* operand = new_->operands[i];
      auto sf = StructField{type, i};
      if (readStructFields.count(sf) ||
          EffectAnalyzer(options, *module, operand).hasSideEffects()) {
        // This data can be read, so just walk it. Or, this has side effects,
        // which is tricky to reason about - the side effects must happen even
        // if we never read the struct field - so give up and walk it.
        expressionQueue.push_back(operand);
      } else {
        // This data does not need to be read now, but might be read later. Note
        // it as unread.
        unreadStructFieldExprMap[sf].push_back(operand);

        // We also must note any relevant references here as potentially
        // dangling: they cannot be simply removed if they have no other
        // references.
        addReference(operand);
      }
    }
  }

  // Add references to all things referred to by an expression, without
  // necessarily making them used.
  //
  // This is only called on things without side effects (if there are such
  // effects then we would have had to assume the worst earlier, and not get
  // here).
  void addReference(Expression* curr) {
    // Some module elements can be "emptied out", like a function which we can
    // set its body to an unreachable without breaking validation. But others
    // require more care.
    for (auto* refFunc : FindAll<RefFunc>(curr).list) {
      referenced.insert(
        ModuleElement(ModuleElementKind::Function, refFunc->func));
    }
    for (auto* refGlobal : FindAll<GlobalGet>(curr).list) {
      // We could try to empty the global out, for example, replace it with a
      // null if it is non-nullable, or replace all gets of it with something
      // else. TODO For now, just make it used.
      maybeAdd(ModuleElement(ModuleElementKind::Global, refGlobal->name));
    }
    // As side effects are assumed to not exist, global.set is not an issue.
  }

  // Visitors

  void visitCall(Call* curr) {
    maybeAdd(ModuleElement(ModuleElementKind::Function, curr->target));

    if (Intrinsics(*module).isCallWithoutEffects(curr)) {
      // A call-without-effects receives a function reference and calls it, the
      // same as a CallRef. When we have a flag for non-closed-world, we should
      // handle this automatically by the reference flowing out to an import,
      // which is what binaryen intrinsics look like. For now, to support use
      // cases of a closed world but that also use this intrinsic, handle the
      // intrinsic specifically here. (Without that, the closed world assumption
      // makes us ignore the function ref that flows to an import, so we are not
      // aware that it is actually called.)
      auto* target = curr->operands.back();
      if (auto* refFunc = target->dynCast<RefFunc>()) {
        // We can see exactly where this goes.
        Call call(module->allocator);
        call.target = refFunc->func;
        visitCall(&call);
      } else {
        // All we can see is the type, so do a CallRef of that.
        CallRef callRef(module->allocator);
        callRef.target = target;
        visitCallRef(&callRef);
      }
    }
  }

  void visitCallIndirect(CallIndirect* curr) { maybeAddTable(curr->table); }

  void visitCallRef(CallRef* curr) {
    // Ignore unreachable code.
    if (!curr->target->type.isRef()) {
      return;
    }

    auto type = curr->target->type.getHeapType();

    // Call all the functions of that signature. We can then forget about
    // them, as this signature will be marked as called.
    auto iter = uncalledRefFuncMap.find(type);
    if (iter != uncalledRefFuncMap.end()) {
      // We must not have a type in both calledSignatures and
      // uncalledRefFuncMap: once it is called, we do not track RefFuncs for
      // it any more.
      assert(calledSignatures.count(type) == 0);

      for (Name target : iter->second) {
        maybeAdd(ModuleElement(ModuleElementKind::Function, target));
      }

      uncalledRefFuncMap.erase(iter);
    }

    calledSignatures.insert(type);
  }

  void visitGlobalGet(GlobalGet* curr) {
    maybeAdd(ModuleElement(ModuleElementKind::Global, curr->name));
  }
  void visitGlobalSet(GlobalSet* curr) {
    maybeAdd(ModuleElement(ModuleElementKind::Global, curr->name));
  }

  void visitLoad(Load* curr) { usesMemory = true; }
  void visitStore(Store* curr) { usesMemory = true; }
  void visitAtomicCmpxchg(AtomicCmpxchg* curr) { usesMemory = true; }
  void visitAtomicRMW(AtomicRMW* curr) { usesMemory = true; }
  void visitAtomicWait(AtomicWait* curr) { usesMemory = true; }
  void visitAtomicNotify(AtomicNotify* curr) { usesMemory = true; }
  void visitAtomicFence(AtomicFence* curr) { usesMemory = true; }
  void visitMemoryInit(MemoryInit* curr) { usesMemory = true; }
  void visitDataDrop(DataDrop* curr) {
    // TODO: Replace this with a use of a data segment (#5224).
    usesMemory = true;
  }
  void visitMemoryCopy(MemoryCopy* curr) { usesMemory = true; }
  void visitMemoryFill(MemoryFill* curr) { usesMemory = true; }
  void visitMemorySize(MemorySize* curr) { usesMemory = true; }
  void visitMemoryGrow(MemoryGrow* curr) { usesMemory = true; }
  void visitRefFunc(RefFunc* curr) {
    if (!options.closedWorld) {
      // The world is open, so assume the worst and something (inside or outside
      // of the module) can call this.
      maybeAdd(ModuleElement(ModuleElementKind::Function, curr->func));
      return;
    }
    auto type = curr->type.getHeapType();
    if (calledSignatures.count(type)) {
      // We must not have a type in both calledSignatures and
      // uncalledRefFuncMap: once it is called, we do not track RefFuncs for it
      // any more.
      assert(uncalledRefFuncMap.count(type) == 0);

      // We've seen a RefFunc for this, so it is used.
      maybeAdd(ModuleElement(ModuleElementKind::Function, curr->func));
    } else {
      // We've never seen a CallRef for this, but might see one later.
      uncalledRefFuncMap[type].insert(curr->func);
    }
  }
  void visitTableGet(TableGet* curr) { maybeAddTable(curr->table); }
  void visitTableSet(TableSet* curr) { maybeAddTable(curr->table); }
  void visitTableSize(TableSize* curr) { maybeAddTable(curr->table); }
  void visitTableGrow(TableGrow* curr) { maybeAddTable(curr->table); }
  void visitThrow(Throw* curr) {
    maybeAdd(ModuleElement(ModuleElementKind::Tag, curr->tag));
  }
  void visitTry(Try* curr) {
    for (auto tag : curr->catchTags) {
      maybeAdd(ModuleElement(ModuleElementKind::Tag, tag));
    }
  }

  // We'll compute SubTypes if we need them.
  std::unique_ptr<SubTypes> subTypes;

  void visitStructGet(StructGet* curr) {
    if (curr->ref->type == Type::unreachable) {
      return;
    }

    auto type = curr->ref->type.getHeapType();
    if (type.isBottom()) {
      return;
    }

    if (!readStructFields.count({type, curr->index})) {
      // This is the first time we see a read of this data. Note that it is
      // read, and also all subtypes since we might be reading from them as
      // well.
      if (!subTypes) {
        subTypes = std::make_unique<SubTypes>(*module);
      }
      subTypes->iterSubTypes(type, [&](HeapType type, Index depth) {
        auto sf = StructField{type, curr->index};
        readStructFields.insert(sf);

        // Walk all the unread data we've queued: we queued it for the
        // possibility of it ever being read, which just happened.
        auto iter = unreadStructFieldExprMap.find(sf);
        if (iter != unreadStructFieldExprMap.end()) {
          for (auto* expr : iter->second) {
            expressionQueue.push_back(expr);
          }
          // TODO erase?
        }
      });
    }
  }

  void visitArrayNewSeg(ArrayNewSeg* curr) {
    switch (curr->op) {
      case NewData:
        // TODO: Replace this with a use of the specific data segment (#5224).
        usesMemory = true;
        return;
      case NewElem:
        auto segment = module->elementSegments[curr->segment]->name;
        maybeAdd(ModuleElement(ModuleElementKind::ElementSegment, segment));
        return;
    }
    WASM_UNREACHABLE("unexpected op");
  }
};

struct RemoveUnusedModuleElements : public Pass {
  // This pass only removes module elements, it never modifies function
  // contents.
  bool requiresNonNullableLocalFixups() override { return false; }

  bool rootAllFunctions;

  RemoveUnusedModuleElements(bool rootAllFunctions)
    : rootAllFunctions(rootAllFunctions) {}

  void run(Module* module) override {
    std::vector<ModuleElement> roots;
    // Module start is a root.
    if (module->start.is()) {
      auto startFunction = module->getFunction(module->start);
      // Can be skipped if the start function is empty.
      if (!startFunction->imported() && startFunction->body->is<Nop>()) {
        module->start = Name{};
      } else {
        roots.emplace_back(ModuleElementKind::Function, module->start);
      }
    }
    // If told to, root all the functions
    if (rootAllFunctions) {
      ModuleUtils::iterDefinedFunctions(*module, [&](Function* func) {
        roots.emplace_back(ModuleElementKind::Function, func->name);
      });
    }
    ModuleUtils::iterActiveElementSegments(
      *module, [&](ElementSegment* segment) {
        auto table = module->getTable(segment->table);
        if (table->imported() && !segment->data.empty()) {
          roots.emplace_back(ModuleElementKind::ElementSegment, segment->name);
        }
      });
    // Exports are roots.
    bool exportsMemory = false;
    for (auto& curr : module->exports) {
      if (curr->kind == ExternalKind::Function) {
        roots.emplace_back(ModuleElementKind::Function, curr->value);
      } else if (curr->kind == ExternalKind::Global) {
        roots.emplace_back(ModuleElementKind::Global, curr->value);
      } else if (curr->kind == ExternalKind::Tag) {
        roots.emplace_back(ModuleElementKind::Tag, curr->value);
      } else if (curr->kind == ExternalKind::Table) {
        roots.emplace_back(ModuleElementKind::Table, curr->value);
        ModuleUtils::iterTableSegments(
          *module, curr->value, [&](ElementSegment* segment) {
            roots.emplace_back(ModuleElementKind::ElementSegment,
                               segment->name);
          });
      } else if (curr->kind == ExternalKind::Memory) {
        exportsMemory = true;
      }
    }
    // Check for special imports, which are roots.
    bool importsMemory = false;
    if (!module->memories.empty() && module->memories[0]->imported()) {
      importsMemory = true;
    }
    // For now, all functions that can be called indirectly are marked as roots.
    // TODO: Compute this based on which ElementSegments are actually used,
    //       and which functions have a call_indirect of the proper type.
    ElementUtils::iterAllElementFunctionNames(module, [&](Name& name) {
      roots.emplace_back(ModuleElementKind::Function, name);
    });
    // Compute reachability starting from the root set.
    auto& options = getPassOptions();
    ReachabilityAnalyzer analyzer(module, options, roots);

    // RefFuncs that are never called are a special case: We cannot remove the
    // function, since then (ref.func $foo) would not validate. But if we know
    // it is never called, at least the contents do not matter, so we can
    // empty it out.
    //
    // We can only do this in a closed world, as otherwise function references
    // may be called outside of the module (if they escape, which we could in
    // principle track, see the TODO earlier in this file). So in the case of an
    // open world we should not have noted anything in uncalledRefFuncMap
    // earlier and not do any related optimizations there.
    assert(options.closedWorld || analyzer.uncalledRefFuncMap.empty());
    for (auto& [type, targets] : analyzer.uncalledRefFuncMap) {
      for (auto target : targets) {
        analyzer.referenced.insert(ModuleElement(ModuleElementKind::Function, target));
      }

      // We cannot have a type in both this map and calledSignatures.
      assert(analyzer.calledSignatures.count(type) == 0);
    }

#ifndef NDEBUG
    for (auto type : analyzer.calledSignatures) {
      assert(analyzer.uncalledRefFuncMap.count(type) == 0);
    }
#endif
    // Remove unreachable elements.
    module->removeFunctions([&](Function* curr) {
      auto element =
        ModuleElement(ModuleElementKind::Function, curr->name);
      if (analyzer.used.count(element)) {
        // This is reached.
        return false;
      }

      if (analyzer.referenced.count(element)) {
        // This is not reached, but has a reference. See comment above on
        // uncalledRefFuncs.
        if (!curr->imported()) {
          curr->body = Builder(*module).makeUnreachable();
        }
        return false;
      }

      // The function is not reached and has no reference; remove it.
      return true;
    });
    module->removeGlobals([&](Global* curr) {
      return analyzer.used.count(
               ModuleElement(ModuleElementKind::Global, curr->name)) == 0;
    });
    module->removeTags([&](Tag* curr) {
      return analyzer.used.count(
               ModuleElement(ModuleElementKind::Tag, curr->name)) == 0;
    });
    module->removeElementSegments([&](ElementSegment* curr) {
      return analyzer.used.count(ModuleElement(
               ModuleElementKind::ElementSegment, curr->name)) == 0;
    });
    // Since we've removed all empty element segments, here we mark all tables
    // that have a segment left.
    std::unordered_set<Name> nonemptyTables;
    ModuleUtils::iterActiveElementSegments(
      *module,
      [&](ElementSegment* segment) { nonemptyTables.insert(segment->table); });
    module->removeTables([&](Table* curr) {
      return (nonemptyTables.count(curr->name) == 0 || !curr->imported()) &&
             analyzer.used.count(
               ModuleElement(ModuleElementKind::Table, curr->name)) == 0;
    });
    // TODO: After removing elements, we may be able to remove more things, and
    //       should continue to work. (For example, after removing a reference
    //       to a function from an element segment, we may be able to remove
    //       that function, etc.)

    // Handle the memory
    if (!exportsMemory && !analyzer.usesMemory) {
      if (!importsMemory) {
        // The memory is unobservable to the outside, we can remove the
        // contents.
        module->removeDataSegments([&](DataSegment* curr) { return true; });
      }
      if (module->dataSegments.empty() && !module->memories.empty()) {
        module->removeMemory(module->memories[0]->name);
      }
    }
  }
};

Pass* createRemoveUnusedModuleElementsPass() {
  return new RemoveUnusedModuleElements(false);
}

Pass* createRemoveUnusedNonFunctionModuleElementsPass() {
  return new RemoveUnusedModuleElements(true);
}

} // namespace wasm
