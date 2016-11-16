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
// which may be imported or not.
//


#include <memory>

#include "wasm.h"
#include "pass.h"
#include "ast_utils.h"

namespace wasm {

enum class ModuleElementKind {
  Function,
  Global
};

typedef std::pair<ModuleElementKind, Name> ModuleElement;

// Finds reachabilities

struct ReachabilityAnalyzer : public PostWalker<ReachabilityAnalyzer, Visitor<ReachabilityAnalyzer>> {
  Module* module;
  std::vector<ModuleElement> queue;
  std::set<ModuleElement> reachable;

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
          auto* func = module->checkFunction(curr.second);
          if (func) {
            walk(func->body);
          }
        } else {
          // if not imported, it has an init expression we need to walk
          auto* glob = module->checkGlobal(curr.second);
          if (glob) {
            walk(glob->init);
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
  void visitCallImport(CallImport* curr) {
    if (reachable.count(ModuleElement(ModuleElementKind::Function, curr->target)) == 0) {
      queue.emplace_back(ModuleElementKind::Function, curr->target);
    }
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
};

struct RemoveUnusedModuleElements : public Pass {
  void run(PassRunner* runner, Module* module) override {
    std::vector<ModuleElement> roots;
    // Module start is a root.
    if (module->start.is()) {
      roots.emplace_back(ModuleElementKind::Function, module->start);
    }
    // Exports are roots.
    for (auto& curr : module->exports) {
      if (curr->kind == ExternalKind::Function) {
        roots.emplace_back(ModuleElementKind::Function, curr->value);
      } else if (curr->kind == ExternalKind::Global) {
        roots.emplace_back(ModuleElementKind::Global, curr->value);
      }
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
    {
      auto& v = module->imports;
      v.erase(std::remove_if(v.begin(), v.end(), [&](const std::unique_ptr<Import>& curr) {
        if (curr->kind == ExternalKind::Function) {
          return analyzer.reachable.count(ModuleElement(ModuleElementKind::Function, curr->name)) == 0;
        } else if (curr->kind == ExternalKind::Global) {
          return analyzer.reachable.count(ModuleElement(ModuleElementKind::Global, curr->name)) == 0;
        }
        return false;
      }), v.end());
    }
    module->updateMaps();
  }
};

Pass* createRemoveUnusedModuleElementsPass() {
  return new RemoveUnusedModuleElements();
}

} // namespace wasm
