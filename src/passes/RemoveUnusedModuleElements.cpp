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
// Removes module elements that are are never used: functions and globals,
// which may be imported or not, and function types (which we merge
// and remove if unneeded)
//


#include <memory>

#include "wasm.h"
#include "pass.h"
#include "ir/module-utils.h"
#include "ir/utils.h"
#include "asm_v_wasm.h"

namespace wasm {

enum class ModuleElementKind {
  Function,
  Global
};

typedef std::pair<ModuleElementKind, Name> ModuleElement;

// Finds reachabilities

struct ReachabilityAnalyzer : public PostWalker<ReachabilityAnalyzer> {
  Module* module;
  std::vector<ModuleElement> queue;
  std::set<ModuleElement> reachable;
  bool usesMemory = false;
  bool usesTable = false;

  ReachabilityAnalyzer(Module* module, const std::vector<ModuleElement>& roots) : module(module) {
    queue = roots;
    // Globals used in memory/table init expressions are also roots
    for (auto& segment : module->memory.segments) {
      walk(segment.offset);
    }
    for (auto& segment : module->table.segments) {
      walk(segment.offset);
    }
    // main loop
    while (queue.size()) {
      auto& curr = queue.back();
      queue.pop_back();
      if (reachable.count(curr) == 0) {
        reachable.insert(curr);
        if (curr.first == ModuleElementKind::Function) {
          // if not an import, walk it
          auto* func = module->getFunction(curr.second);
          if (!func->imported()) {
            walk(func->body);
          }
        } else {
          // if not imported, it has an init expression we need to walk
          auto* global = module->getGlobal(curr.second);
          if (!global->imported()) {
            walk(global->init);
          }
        }
      }
    }
  }

  void visitCall(Call* curr) {
    if (reachable.count(ModuleElement(ModuleElementKind::Function, curr->target)) == 0) {
      queue.emplace_back(ModuleElementKind::Function, curr->target);
    }
  }
  void visitCallIndirect(CallIndirect* curr) {
    usesTable = true;
  }

  void visitGetGlobal(GetGlobal* curr) {
    if (reachable.count(ModuleElement(ModuleElementKind::Global, curr->name)) == 0) {
      queue.emplace_back(ModuleElementKind::Global, curr->name);
    }
  }
  void visitSetGlobal(SetGlobal* curr) {
    if (reachable.count(ModuleElement(ModuleElementKind::Global, curr->name)) == 0) {
      queue.emplace_back(ModuleElementKind::Global, curr->name);
    }
  }

  void visitLoad(Load* curr) {
    usesMemory = true;
  }
  void visitStore(Store* curr) {
    usesMemory = true;
  }
  void visitAtomicCmpxchg(AtomicCmpxchg* curr) {
    usesMemory = true;
  }
  void visitAtomicRMW(AtomicRMW* curr) {
    usesMemory = true;
  }
  void visitAtomicWait(AtomicWait* curr) {
    usesMemory = true;
  }
  void visitAtomicWake(AtomicWake* curr) {
    usesMemory = true;
  }
  void visitHost(Host* curr) {
    if (curr->op == CurrentMemory || curr->op == GrowMemory) {
      usesMemory = true;
    }
  }
};

// Finds function type usage

struct FunctionTypeAnalyzer : public PostWalker<FunctionTypeAnalyzer> {
  std::vector<Function*> functionImports;
  std::vector<Function*> functions;
  std::vector<CallIndirect*> indirectCalls;

  void visitFunction(Function* curr) {
    if (curr->type.is()) {
      if (curr->imported()) {
        functionImports.push_back(curr);
      } else {
        functions.push_back(curr);
      }
    }
  }

  void visitCallIndirect(CallIndirect* curr) {
    indirectCalls.push_back(curr);
  }
};

struct RemoveUnusedModuleElements : public Pass {
  bool rootAllFunctions;

  RemoveUnusedModuleElements(bool rootAllFunctions) : rootAllFunctions(rootAllFunctions) {}

  void run(PassRunner* runner, Module* module) override {
    optimizeGlobalsAndFunctions(module);
    optimizeFunctionTypes(module);
  }

  void optimizeGlobalsAndFunctions(Module* module) {
    std::vector<ModuleElement> roots;
    // Module start is a root.
    if (module->start.is()) {
      auto startFunction = module->getFunction(module->start);
      // Can be skipped if the start function is empty.
      if (startFunction->body->is<Nop>()) {
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
    // Exports are roots.
    bool exportsMemory = false;
    bool exportsTable = false;
    for (auto& curr : module->exports) {
      if (curr->kind == ExternalKind::Function) {
        roots.emplace_back(ModuleElementKind::Function, curr->value);
      } else if (curr->kind == ExternalKind::Global) {
        roots.emplace_back(ModuleElementKind::Global, curr->value);
      } else if (curr->kind == ExternalKind::Memory) {
        exportsMemory = true;
      } else if (curr->kind == ExternalKind::Table) {
        exportsTable = true;
      }
    }
    // Check for special imports, which are roots.
    bool importsMemory = false;
    bool importsTable = false;
    if (module->memory.imported()) {
      importsMemory = true;
    }
    if (module->table.imported()) {
      importsTable = true;
    }
    // For now, all functions that can be called indirectly are marked as roots.
    for (auto& segment : module->table.segments) {
      for (auto& curr : segment.data) {
        roots.emplace_back(ModuleElementKind::Function, curr);
      }
    }
    // Compute reachability starting from the root set.
    ReachabilityAnalyzer analyzer(module, roots);
    // Remove unreachable elements.
    {
      auto& v = module->functions;
      v.erase(std::remove_if(v.begin(), v.end(), [&](const std::unique_ptr<Function>& curr) {
        return analyzer.reachable.count(ModuleElement(ModuleElementKind::Function, curr->name)) == 0;
      }), v.end());
    }
    {
      auto& v = module->globals;
      v.erase(std::remove_if(v.begin(), v.end(), [&](const std::unique_ptr<Global>& curr) {
        return analyzer.reachable.count(ModuleElement(ModuleElementKind::Global, curr->name)) == 0;
      }), v.end());
    }
    module->updateMaps();
    // Handle the memory and table
    if (!exportsMemory && !analyzer.usesMemory) {
      if (!importsMemory) {
        // The memory is unobservable to the outside, we can remove the contents.
        module->memory.segments.clear();
      }
      if (module->memory.segments.empty()) {
        module->memory.exists = false;
        module->memory.module = module->memory.base = Name();
        module->memory.initial = 0;
        module->memory.max = 0;
      }
    }
    if (!exportsTable && !analyzer.usesTable) {
      if (!importsTable) {
        // The table is unobservable to the outside, we can remove the contents.
        module->table.segments.clear();
      }
      if (module->table.segments.empty()) {
        module->table.exists = false;
        module->table.module = module->table.base = Name();
        module->table.initial = 0;
        module->table.max = 0;
      }
    }
  }

  void optimizeFunctionTypes(Module* module) {
    FunctionTypeAnalyzer analyzer;
    analyzer.walkModule(module);
    // maps each string signature to a single canonical function type
    std::unordered_map<std::string, FunctionType*> canonicals;
    std::unordered_set<FunctionType*> needed;
    auto canonicalize = [&](Name name) {
      if (!name.is()) return name;
      FunctionType* type = module->getFunctionType(name);
      auto sig = getSig(type);
      auto iter = canonicals.find(sig);
      if (iter == canonicals.end()) {
        needed.insert(type);
        canonicals[sig] = type;
        return type->name;
      } else {
        return iter->second->name;
      }
    };
    // canonicalize all uses of function types
    for (auto* import : analyzer.functionImports) {
      import->type = canonicalize(import->type);
    }
    for (auto* func : analyzer.functions) {
      func->type = canonicalize(func->type);
    }
    for (auto* call : analyzer.indirectCalls) {
      call->fullType = canonicalize(call->fullType);
    }
    // remove no-longer used types
    module->functionTypes.erase(std::remove_if(module->functionTypes.begin(), module->functionTypes.end(), [&needed](std::unique_ptr<FunctionType>& type) {
      return needed.count(type.get()) == 0;
    }), module->functionTypes.end());
    module->updateMaps();
  }
};

Pass* createRemoveUnusedModuleElementsPass() {
  return new RemoveUnusedModuleElements(false);
}

Pass* createRemoveUnusedNonFunctionModuleElementsPass() {
  return new RemoveUnusedModuleElements(true);
}

} // namespace wasm
