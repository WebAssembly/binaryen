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
// Removes module elements that are are never used: functions, globals, and
// tags, which may be imported or not, and function types (which we merge and
// remove if unneeded)
//

#include <memory>

#include "ir/element-utils.h"
#include "ir/intrinsics.h"
#include "ir/module-utils.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

enum class ModuleElementKind { Function, Global, Tag, Table, ElementSegment };

typedef std::pair<ModuleElementKind, Name> ModuleElement;

// Finds reachabilities
// TODO: use Effects to determine if a memory is used
// This pass does not have multi-memories support

struct ReachabilityAnalyzer : public PostWalker<ReachabilityAnalyzer> {
  Module* module;
  std::vector<ModuleElement> queue;
  std::set<ModuleElement> reachable;
  bool usesMemory = false;

  // The signatures that we have seen a call_ref for. When we see a RefFunc of a
  // signature in here, we know it is reachable.
  std::unordered_set<HeapType> calledSignatures;

  // All the RefFuncs we've seen, grouped by heap type. When we see a CallRef of
  // one of the types here, we know all the RefFuncs corresponding to it are
  // reachable. This is the reverse side of calledSignatures: for a function to
  // be reached via a reference, we need the combination of a RefFunc of it as
  // well as a CallRef of that, and we may see them in any order. (Or, if the
  // RefFunc is in a table, we need a CallIndirect, which is handled in the
  // table logic.)
  //
  // After we see a call for a type, we can clear out the entry here for it, as
  // we'll have that type in calledSignatures, and so this contains only
  // RefFuncs that we have not seen a call for yet, hence "uncalledRefFuncMap."
  //
  // TODO: We assume a closed world in the GC space atm, but eventually should
  //       have a flag for that, and when the world is not closed we'd need to
  //       check for RefFuncs that flow out to exports or imports
  std::unordered_map<HeapType, std::unordered_set<Name>> uncalledRefFuncMap;

  ReachabilityAnalyzer(Module* module, const std::vector<ModuleElement>& roots)
    : module(module) {
    queue = roots;
    // Globals used in memory/table init expressions are also roots
    for (auto& segment : module->dataSegments) {
      if (!segment->isPassive) {
        walk(segment->offset);
      }
    }
    for (auto& segment : module->elementSegments) {
      if (segment->table.is()) {
        walk(segment->offset);
      }
    }

    // main loop
    while (queue.size()) {
      auto curr = queue.back();
      queue.pop_back();
      if (reachable.emplace(curr).second) {
        auto& [kind, value] = curr;
        if (kind == ModuleElementKind::Function) {
          // if not an import, walk it
          auto* func = module->getFunction(value);
          if (!func->imported()) {
            walk(func->body);
          }
        } else if (kind == ModuleElementKind::Global) {
          // if not imported, it has an init expression we need to walk
          auto* global = module->getGlobal(value);
          if (!global->imported()) {
            walk(global->init);
          }
        } else if (kind == ModuleElementKind::Table) {
          ModuleUtils::iterTableSegments(
            *module, curr.second, [&](ElementSegment* segment) {
              walk(segment->offset);
            });
        }
      }
    }
  }

  void maybeAdd(ModuleElement element) {
    if (reachable.count(element) == 0) {
      queue.emplace_back(element);
    }
  }

  // Add a reference to a table and all its segments and elements.
  void maybeAddTable(Name name) {
    maybeAdd(ModuleElement(ModuleElementKind::Table, name));
    ModuleUtils::iterTableSegments(*module, name, [&](ElementSegment* segment) {
      maybeAdd(ModuleElement(ModuleElementKind::ElementSegment, segment->name));
    });
  }

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
  void visitDataDrop(DataDrop* curr) { usesMemory = true; }
  void visitMemoryCopy(MemoryCopy* curr) { usesMemory = true; }
  void visitMemoryFill(MemoryFill* curr) { usesMemory = true; }
  void visitMemorySize(MemorySize* curr) { usesMemory = true; }
  void visitMemoryGrow(MemoryGrow* curr) { usesMemory = true; }
  void visitRefFunc(RefFunc* curr) {
    auto type = curr->type.getHeapType();
    if (calledSignatures.count(type)) {
      // We must not have a type in both calledSignatures and
      // uncalledRefFuncMap: once it is called, we do not track RefFuncs for it
      // any more.
      assert(uncalledRefFuncMap.count(type) == 0);

      // We've seen a RefFunc for this, so it is reachable.
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
};

struct RemoveUnusedModuleElements : public Pass {
  // This pass only removes module elements, it never modifies function
  // contents.
  bool requiresNonNullableLocalFixups() override { return false; }

  bool rootAllFunctions;

  RemoveUnusedModuleElements(bool rootAllFunctions)
    : rootAllFunctions(rootAllFunctions) {}

  void run(PassRunner* runner, Module* module) override {
    std::vector<ModuleElement> roots;
    // Module start is a root.
    if (module->start.is()) {
      auto startFunction = module->getFunction(module->start);
      // Can be skipped if the start function is empty.
      if (!startFunction->imported() && startFunction->body->is<Nop>()) {
        module->start.clear();
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
    // TODO: Compute this based on which ElementSegments are actually reachable,
    //       and which functions have a call_indirect of the proper type.
    ElementUtils::iterAllElementFunctionNames(module, [&](Name& name) {
      roots.emplace_back(ModuleElementKind::Function, name);
    });
    // Compute reachability starting from the root set.
    ReachabilityAnalyzer analyzer(module, roots);

    // RefFuncs that are never called are a special case: We cannot remove the
    // function, since then (ref.func $foo) would not validate. But if we know
    // it is never called, at least the contents do not matter, so we can
    // empty it out.
    std::unordered_set<Name> uncalledRefFuncs;
    for (auto& [type, targets] : analyzer.uncalledRefFuncMap) {
      for (auto target : targets) {
        uncalledRefFuncs.insert(target);
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
      if (analyzer.reachable.count(
            ModuleElement(ModuleElementKind::Function, curr->name))) {
        // This is reached.
        return false;
      }

      if (uncalledRefFuncs.count(curr->name)) {
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
      return analyzer.reachable.count(
               ModuleElement(ModuleElementKind::Global, curr->name)) == 0;
    });
    module->removeTags([&](Tag* curr) {
      return analyzer.reachable.count(
               ModuleElement(ModuleElementKind::Tag, curr->name)) == 0;
    });
    module->removeElementSegments([&](ElementSegment* curr) {
      return curr->data.empty() ||
             analyzer.reachable.count(ModuleElement(
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
             analyzer.reachable.count(
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
