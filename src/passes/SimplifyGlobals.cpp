/*
 * Copyright 2019 WebAssembly Community Group participants
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
// Simplify and optimize globals and their use.
//
//  * Turns never-written and unwritable (not imported or exported)
//    globals immutable.
//  * If an immutable global is a copy of another, use the earlier one,
//    to allow removal of the copies later.
//

#include <atomic>

#include "pass.h"
#include "wasm.h"

namespace wasm {

namespace {

struct GlobalInfo {
  bool imported = false;
  bool exported = false;
  std::atomic<bool> written;
};

using GlobalInfoMap = std::map<Name, GlobalInfo>;

struct GlobalUseScanner : public WalkerPass<PostWalker<GlobalUseScanner>> {
  bool isFunctionParallel() override { return true; }

  GlobalUseScanner(GlobalInfoMap* infos) : infos(infos) {}

  GlobalUseScanner* create() override { return new GlobalUseScanner(infos); }

  void visitSetGlobal(SetGlobal* curr) { (*infos)[curr->name].written = true; }

private:
  GlobalInfoMap* infos;
};

using NameNameMap = std::map<Name, Name>;

struct GlobalUseModifier : public WalkerPass<PostWalker<GlobalUseModifier>> {
  bool isFunctionParallel() override { return true; }

  GlobalUseModifier(NameNameMap* copiedParentMap)
    : copiedParentMap(copiedParentMap) {}

  GlobalUseModifier* create() override {
    return new GlobalUseModifier(copiedParentMap);
  }

  void visitGetGlobal(GetGlobal* curr) {
    auto iter = copiedParentMap->find(curr->name);
    if (iter != copiedParentMap->end()) {
      curr->name = iter->second;
    }
  }

private:
  NameNameMap* copiedParentMap;
};

} // anonymous namespace

struct SimplifyGlobals : public Pass {
  void run(PassRunner* runner, Module* module) override {
    // First, find out all the relevant info.
    GlobalInfoMap map;
    for (auto& global : module->globals) {
      auto& info = map[global->name];
      if (global->imported()) {
        info.imported = true;
      }
    }
    for (auto& ex : module->exports) {
      if (ex->kind == ExternalKind::Global) {
        map[ex->value].exported = true;
      }
    }
    {
      PassRunner subRunner(module, runner->options);
      subRunner.add<GlobalUseScanner>(&map);
      subRunner.run();
    }
    // We now know which are immutable in practice.
    for (auto& global : module->globals) {
      auto& info = map[global->name];
      if (global->mutable_ && !info.imported && !info.exported &&
          !info.written) {
        global->mutable_ = false;
      }
    }
    // Optimize uses of immutable globals, prefer the earlier import when
    // there is a copy.
    NameNameMap copiedParentMap;
    for (auto& global : module->globals) {
      auto child = global->name;
      if (!global->mutable_ && !global->imported()) {
        if (auto* get = global->init->dynCast<GetGlobal>()) {
          auto parent = get->name;
          if (!module->getGlobal(get->name)->mutable_) {
            copiedParentMap[child] = parent;
          }
        }
      }
    }
    if (!copiedParentMap.empty()) {
      // Go all the way back.
      for (auto& global : module->globals) {
        auto child = global->name;
        if (copiedParentMap.count(child)) {
          while (copiedParentMap.count(copiedParentMap[child])) {
            copiedParentMap[child] = copiedParentMap[copiedParentMap[child]];
          }
        }
      }
      // Apply to the gets.
      PassRunner subRunner(module, runner->options);
      subRunner.add<GlobalUseModifier>(&copiedParentMap);
      subRunner.run();
    }
  }
};

Pass* createSimplifyGlobalsPass() { return new SimplifyGlobals(); }

} // namespace wasm
