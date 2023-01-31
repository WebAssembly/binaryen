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
// To do this optimally, we need to consider that an element may be in one of
// three states:
//
//  * No references at all. We can simply remove it.
//  * References, but no uses. We can't remove it, but we can change it (see
//    below).
//  * Uses (which imply references). We must keep it as it is.
//
// An example of something with a reference but *not* a use is a RefFunc to a
// function that has no corresponding CallRef to that type. We cannot just
// remove the function, since the RefFunc must refer to an actual entity in the
// IR, but we know it isn't actually used/called, so we can change it - we can
// empty out the body and put an unreachable there, for example. That is, a
// reference forces us to keep something in the IR to be referred to, but only
// a use actually makes us keep its contents as well.
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

// TODO: Add data segment, multiple memories (#5224)
// TODO: use Effects below to determine if a memory is used
// This pass does not have multi-memories support
enum class ModuleElementKind { Function, Global, Tag, Table, ElementSegment };

// An element in the module that we track: a kind (function, global, etc.) + the
// name of the particular element.
using ModuleElement = std::pair<ModuleElementKind, Name>;

// Visit or walk an expression to find what things are referenced.
struct ReferenceFinder : public PostWalker<ReferenceFinder> {
  // Our findings are placed in these data structures, which the user of this
  // code can then process.
  std::vector<ModuleElement> elements;
  std::vector<HeapType> callRefTypes;
  std::vector<Name> refFuncs;
  bool usesMemory = false;

  // Add an item to the output data structures.
  void note(ModuleElement element) { elements.push_back(element); }
  void noteCallRef(HeapType type) { callRefTypes.push_back(type); }
  void noteRefFunc(Name refFunc) { refFuncs.push_back(refFunc); }

  // Visitors

  void visitCall(Call* curr) {
    note(ModuleElement(ModuleElementKind::Function, curr->target));

    if (Intrinsics(*getModule()).isCallWithoutEffects(curr)) {
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
        Call call(getModule()->allocator);
        call.target = refFunc->func;
        visitCall(&call);
      } else {
        // All we can see is the type, so do a CallRef of that.
        CallRef callRef(getModule()->allocator);
        callRef.target = target;
        visitCallRef(&callRef);
      }
    }
  }

  void visitCallIndirect(CallIndirect* curr) {
    note(ModuleElement(ModuleElementKind::Table, curr->table));
  }

  void visitCallRef(CallRef* curr) {
    // Ignore unreachable code.
    if (!curr->target->type.isRef()) {
      return;
    }

    noteCallRef(curr->target->type.getHeapType());
  }

  void visitGlobalGet(GlobalGet* curr) {
    note(ModuleElement(ModuleElementKind::Global, curr->name));
  }
  void visitGlobalSet(GlobalSet* curr) {
    note(ModuleElement(ModuleElementKind::Global, curr->name));
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
  void visitRefFunc(RefFunc* curr) { noteRefFunc(curr->func); }
  void visitTableGet(TableGet* curr) {
    note(ModuleElement(ModuleElementKind::Table, curr->table));
  }
  void visitTableSet(TableSet* curr) {
    note(ModuleElement(ModuleElementKind::Table, curr->table));
  }
  void visitTableSize(TableSize* curr) {
    note(ModuleElement(ModuleElementKind::Table, curr->table));
  }
  void visitTableGrow(TableGrow* curr) {
    note(ModuleElement(ModuleElementKind::Table, curr->table));
  }
  void visitThrow(Throw* curr) {
    note(ModuleElement(ModuleElementKind::Tag, curr->tag));
  }
  void visitTry(Try* curr) {
    for (auto tag : curr->catchTags) {
      note(ModuleElement(ModuleElementKind::Tag, tag));
    }
  }
  void visitArrayNewSeg(ArrayNewSeg* curr) {
    switch (curr->op) {
      case NewData:
        // TODO: Replace this with a use of the specific data segment (#5224).
        usesMemory = true;
        return;
      case NewElem:
        auto segment = getModule()->elementSegments[curr->segment]->name;
        note(ModuleElement(ModuleElementKind::ElementSegment, segment));
        return;
    }
    WASM_UNREACHABLE("unexpected op");
  }
};

// Analyze a module to find what things are referenced and what things are used.
struct Analyzer {
  Module* module;
  const PassOptions& options;

  // The set of all used things we've seen used so far.
  std::unordered_set<ModuleElement> used;

  // Things for whom there is a reference, but may be unused. It is ok for a
  // thing to appear both in |used| and here; we will check |used| first anyhow.
  // (That is, we don't need to be careful to remove things from here if they
  // begin as referenced and later become used; and we don't need to add things
  // to here if they are both used and referenced.)
  std::unordered_set<ModuleElement> referenced;

  // A queue of used module elements that we need to process. These appear in
  // |used|, and the work we do when we pop them from the queue is to look at
  // the things they reach that might become referenced or used.
  std::vector<ModuleElement> moduleQueue;

  // A stack of used expressions to walk. We do *not* use the normal
  // walking mechanism because we need more control. Specifically, we may defer
  // certain walks, such as this:
  //
  //   (struct.new $Foo
  //     (global.get $bar)
  //   )
  //
  // If we walked the child immediately then we would make $bar used. But that
  // global is only used if we actually read that field from the struct. We
  // perform that analysis in readStructFields  unreadStructFieldExprMap, below.
  // TODO: this is not implemented yet
  std::vector<Expression*> expressionQueue;

  bool usesMemory = false;

  // The signatures that we have seen a call_ref for. When we see a RefFunc of a
  // signature in here, we know it is used; otherwise it may only be referred
  // to.
  std::unordered_set<HeapType> calledSignatures;

  // All the RefFuncs we've seen, grouped by heap type. When we see a CallRef of
  // one of the types here, we know all the RefFuncs corresponding to it are
  // used. This is the reverse side of calledSignatures: for a function to
  // be used via a reference, we need the combination of a RefFunc of it as
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

  Analyzer(Module* module,
           const PassOptions& options,
           const std::vector<ModuleElement>& roots)
    : module(module), options(options) {

    // All roots are used.
    for (auto& element : roots) {
      use(element);
    }

    // Globals used in memory/table init expressions are also roots.
    for (auto& segment : module->dataSegments) {
      if (!segment->isPassive) {
        use(segment->offset);
      }
    }
    for (auto& segment : module->elementSegments) {
      if (segment->table.is()) {
        use(segment->offset);
      }
    }

    // Main loop on both the module and the expression queues.
    while (processExpressions() || processModule()) {
    }
  }

  // Process expressions in the expression queue while we have any, visiting
  // them (using their contents) and adding children. Returns whether we did any
  // work.
  bool processExpressions() {
    bool worked = false;
    while (expressionQueue.size()) {
      worked = true;

      auto* curr = expressionQueue.back();
      expressionQueue.pop_back();

      // Find references in this expression, and apply them. Anything found here
      // is used.
      ReferenceFinder finder;
      finder.setModule(module);
      finder.visit(curr);
      for (auto element : finder.elements) {
        use(element);
      }
      for (auto type : finder.callRefTypes) {
        useCallRefType(type);
      }
      for (auto func : finder.refFuncs) {
        useRefFunc(func);
      }
      if (finder.usesMemory) {
        usesMemory = true;
      }

      // Scan the children to continue our work.
      scanChildren(curr);
    }
    return worked;
  }

  void useCallRefType(HeapType type) {
    // Call all the functions of that signature. We can then forget about
    // them, as this signature will be marked as called.
    auto iter = uncalledRefFuncMap.find(type);
    if (iter != uncalledRefFuncMap.end()) {
      // We must not have a type in both calledSignatures and
      // uncalledRefFuncMap: once it is called, we do not track RefFuncs for
      // it any more.
      assert(calledSignatures.count(type) == 0);

      for (Name target : iter->second) {
        use(ModuleElement(ModuleElementKind::Function, target));
      }

      uncalledRefFuncMap.erase(iter);
    }

    calledSignatures.insert(type);
  }

  void useRefFunc(Name func) {
    if (!options.closedWorld) {
      // The world is open, so assume the worst and something (inside or outside
      // of the module) can call this.
      use(ModuleElement(ModuleElementKind::Function, func));
      return;
    }

    // Otherwise, we are in a closed world, and so we can try to optimize the
    // case where the target function is referenced but not used.
    auto element = ModuleElement(ModuleElementKind::Function, func);

    auto type = module->getFunction(func)->type;
    if (calledSignatures.count(type)) {
      // We must not have a type in both calledSignatures and
      // uncalledRefFuncMap: once it is called, we do not track RefFuncs for it
      // any more.
      assert(uncalledRefFuncMap.count(type) == 0);

      // We've seen a RefFunc for this, so it is used.
      use(element);
    } else {
      // We've never seen a CallRef for this, but might see one later.
      uncalledRefFuncMap[type].insert(func);

      referenced.insert(element);
    }
  }

  // As processExpressions, but for module elements.
  bool processModule() {
    bool worked = false;
    while (moduleQueue.size()) {
      worked = true;

      auto curr = moduleQueue.back();
      moduleQueue.pop_back();

      assert(used.count(curr));
      auto& [kind, value] = curr;
      if (kind == ModuleElementKind::Function) {
        // if not an import, walk it
        auto* func = module->getFunction(value);
        if (!func->imported()) {
          use(func->body);
        }
      } else if (kind == ModuleElementKind::Global) {
        // if not imported, it has an init expression we can walk
        auto* global = module->getGlobal(value);
        if (!global->imported()) {
          use(global->init);
        }
      } else if (kind == ModuleElementKind::Table) {
        ModuleUtils::iterTableSegments(
          *module, value, [&](ElementSegment* segment) {
            use(segment->offset);
            use(
              ModuleElement(ModuleElementKind::ElementSegment, segment->name));
          });
      }
    }
    return worked;
  }

  // Mark something as used, if it hasn't already been, and if so add it to the
  // queue so we can process the things it can reach.
  void use(ModuleElement element) {
    auto [_, inserted] = used.emplace(element);
    if (inserted) {
      moduleQueue.emplace_back(element);
    }
  }

  void use(Expression* curr) {
    // For expressions we do not need to check if they have already been seen:
    // the tree structure guarantees that traversing children, recursively, will
    // only visit each expression once, since each expression has a single
    // parent.
    expressionQueue.emplace_back(curr);
  }

  // Add the children of a used expression to be walked, if we should do so.
  void scanChildren(Expression* curr) {
    for (auto* child : ChildIterator(curr)) {
      use(child);
    }
  }
};

struct RemoveUnusedModuleElements : public Pass {
  // This pass only removes module elements, it never modifies function
  // contents (except to replace an entire body with unreachable, which does not
  // cause any need for local fixups).
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
    // If told to, root all the functions.
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

    // Analyze the module.
    auto& options = getPassOptions();
    Analyzer analyzer(module, options, roots);

    // Remove unneeded elements.
    auto needed = [&](ModuleElement element) {
      // We need to emit something in the output if it has either a reference or
      // a use. Situations where we can do better (for the case of a reference
      // without any use) are handled separately below.
      return analyzer.used.count(element) || analyzer.referenced.count(element);
    };

    module->removeFunctions([&](Function* curr) {
      auto element = ModuleElement(ModuleElementKind::Function, curr->name);
      if (analyzer.used.count(element)) {
        // This is used.
        return false;
      }

      if (analyzer.referenced.count(element)) {
        // This is not used, but has a reference. See comment above on
        // uncalledRefFuncs.
        if (!curr->imported()) {
          curr->body = Builder(*module).makeUnreachable();
        }
        return false;
      }

      // The function is not used or referenced; remove it entirely.
      return true;
    });
    module->removeGlobals([&](Global* curr) {
      return !needed(ModuleElement(ModuleElementKind::Global, curr->name));
    });
    module->removeTags([&](Tag* curr) {
      return !needed(ModuleElement(ModuleElementKind::Tag, curr->name));
    });
    module->removeElementSegments([&](ElementSegment* curr) {
      return !needed(
        ModuleElement(ModuleElementKind::ElementSegment, curr->name));
    });
    // Since we've removed all empty element segments, here we mark all tables
    // that have a segment left.
    std::unordered_set<Name> nonemptyTables;
    ModuleUtils::iterActiveElementSegments(
      *module,
      [&](ElementSegment* segment) { nonemptyTables.insert(segment->table); });
    module->removeTables([&](Table* curr) {
      return (nonemptyTables.count(curr->name) == 0 || !curr->imported()) &&
             !needed(ModuleElement(ModuleElementKind::Table, curr->name));
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
