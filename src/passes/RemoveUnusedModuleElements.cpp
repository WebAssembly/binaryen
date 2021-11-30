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
#include "ir/module-utils.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm.h"

namespace wasm {

enum class ModuleElementKind { Function, Global, Tag, Table, ElementSegment };

typedef std::pair<ModuleElementKind, Name> ModuleElement;

// Finds reachabilities
// TODO: use Effects to determine if a memory is used

struct ReachabilityAnalyzer : public PostWalker<ReachabilityAnalyzer> {
  Module* module;
  std::vector<ModuleElement> queue;
  std::set<ModuleElement> reachable;
  bool usesMemory = false;

  ReachabilityAnalyzer(Module* module, const std::vector<ModuleElement>& roots)
    : module(module) {
    queue = roots;
    // Globals used in memory/table init expressions are also roots
    for (auto& segment : module->memory.segments) {
      if (!segment.isPassive) {
        walk(segment.offset);
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
  }
  void visitCallIndirect(CallIndirect* curr) { maybeAddTable(curr->table); }

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
    maybeAdd(ModuleElement(ModuleElementKind::Function, curr->func));
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
    if (module->memory.imported()) {
      importsMemory = true;
    }
    // For now, all functions that can be called indirectly are marked as roots.
    ElementUtils::iterAllElementFunctionNames(module, [&](Name& name) {
      roots.emplace_back(ModuleElementKind::Function, name);
    });
    // Compute reachability starting from the root set.
    ReachabilityAnalyzer analyzer(module, roots);
    // Remove unreachable elements.
    module->removeFunctions([&](Function* curr) {
      return analyzer.reachable.count(
               ModuleElement(ModuleElementKind::Function, curr->name)) == 0;
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
        module->memory.segments.clear();
      }
      if (module->memory.segments.empty()) {
        module->memory.exists = false;
        module->memory.module = module->memory.base = Name();
        module->memory.initial = 0;
        module->memory.max = 0;
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
