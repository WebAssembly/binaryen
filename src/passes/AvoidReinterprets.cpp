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

// Avoids reinterprets by using more loads: if we load a value and
// reinterpret it, we could have loaded it with the other type
// anyhow. This uses more locals and loads, so it is not generally
// beneficial, unless reinterprets are very costly.

#include <ir/local-graph.h>
#include <ir/properties.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

static bool canReplaceWithReinterpret(Load* load) {
  // We can replace a full-size load with a valid pointer with
  // a reinterpret of the same address. A partial load would see
  // more bytes and possibly invalid data, and an unreachable
  // pointer is just not interesting to handle.
  return load->type != unreachable && load->bytes == getTypeSize(load->type);
}

static Load* getSingleLoad(LocalGraph* localGraph, LocalGet* get) {
  std::set<LocalGet*> seen;
  seen.insert(get);
  while (1) {
    auto& sets = localGraph->getSetses[get];
    if (sets.size() != 1) {
      return nullptr;
    }
    auto* set = *sets.begin();
    if (!set) {
      return nullptr;
    }
    auto* value = Properties::getFallthrough(set->value);
    if (auto* parentGet = value->dynCast<LocalGet>()) {
      if (seen.count(parentGet)) {
        // We are in a cycle of gets, in unreachable code.
        return nullptr;
      }
      get = parentGet;
      seen.insert(get);
      continue;
    }
    if (auto* load = value->dynCast<Load>()) {
      return load;
    }
    return nullptr;
  }
}

static bool isReinterpret(Unary* curr) {
  return curr->op == ReinterpretInt32 || curr->op == ReinterpretInt64 ||
         curr->op == ReinterpretFloat32 || curr->op == ReinterpretFloat64;
}

struct AvoidReinterprets : public WalkerPass<PostWalker<AvoidReinterprets>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new AvoidReinterprets; }

  struct Info {
    // Info used when analyzing.
    bool reinterpreted;
    // Info used when optimizing.
    Index ptrLocal;
    Index reinterpretedLocal;
  };
  std::map<Load*, Info> infos;

  LocalGraph* localGraph;

  void doWalkFunction(Function* func) {
    // prepare
    LocalGraph localGraph_(func);
    localGraph = &localGraph_;
    // walk
    PostWalker<AvoidReinterprets>::doWalkFunction(func);
    // optimize
    optimize(func);
  }

  void visitUnary(Unary* curr) {
    if (isReinterpret(curr)) {
      if (auto* get =
            Properties::getFallthrough(curr->value)->dynCast<LocalGet>()) {
        if (auto* load = getSingleLoad(localGraph, get)) {
          auto& info = infos[load];
          info.reinterpreted = true;
        }
      }
    }
  }

  void optimize(Function* func) {
    std::set<Load*> unoptimizables;
    for (auto& pair : infos) {
      auto* load = pair.first;
      auto& info = pair.second;
      if (info.reinterpreted && canReplaceWithReinterpret(load)) {
        // We should use another load here, to avoid reinterprets.
        info.ptrLocal = Builder::addVar(func, i32);
        info.reinterpretedLocal =
          Builder::addVar(func, reinterpretType(load->type));
      } else {
        unoptimizables.insert(load);
      }
    }
    for (auto* load : unoptimizables) {
      infos.erase(load);
    }
    // We now know which we can optimize, and how.
    struct FinalOptimizer : public PostWalker<FinalOptimizer> {
      std::map<Load*, Info>& infos;
      LocalGraph* localGraph;
      Module* module;

      FinalOptimizer(std::map<Load*, Info>& infos,
                     LocalGraph* localGraph,
                     Module* module)
        : infos(infos), localGraph(localGraph), module(module) {}

      void visitUnary(Unary* curr) {
        if (isReinterpret(curr)) {
          auto* value = Properties::getFallthrough(curr->value);
          if (auto* load = value->dynCast<Load>()) {
            // A reinterpret of a load - flip it right here if we can.
            if (canReplaceWithReinterpret(load)) {
              replaceCurrent(makeReinterpretedLoad(load, load->ptr));
            }
          } else if (auto* get = value->dynCast<LocalGet>()) {
            if (auto* load = getSingleLoad(localGraph, get)) {
              auto iter = infos.find(load);
              if (iter != infos.end()) {
                auto& info = iter->second;
                // A reinterpret of a get of a load - use the new local.
                Builder builder(*module);
                replaceCurrent(builder.makeLocalGet(
                  info.reinterpretedLocal, reinterpretType(load->type)));
              }
            }
          }
        }
      }

      void visitLoad(Load* curr) {
        auto iter = infos.find(curr);
        if (iter != infos.end()) {
          auto& info = iter->second;
          Builder builder(*module);
          auto* ptr = curr->ptr;
          curr->ptr = builder.makeLocalGet(info.ptrLocal, i32);
          // Note that the other load can have its sign set to false - if the
          // original were an integer, the other is a float anyhow; and if
          // original were a float, we don't know what sign to use.
          replaceCurrent(builder.makeBlock(
            {builder.makeLocalSet(info.ptrLocal, ptr),
             builder.makeLocalSet(
               info.reinterpretedLocal,
               makeReinterpretedLoad(curr,
                                     builder.makeLocalGet(info.ptrLocal, i32))),
             curr}));
        }
      }

      Load* makeReinterpretedLoad(Load* load, Expression* ptr) {
        Builder builder(*module);
        return builder.makeLoad(load->bytes,
                                false,
                                load->offset,
                                load->align,
                                ptr,
                                reinterpretType(load->type));
      }
    } finalOptimizer(infos, localGraph, getModule());

    finalOptimizer.walk(func->body);
  }
};

Pass* createAvoidReinterpretsPass() { return new AvoidReinterprets(); }

} // namespace wasm
