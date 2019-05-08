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

#include <ir/local-graph.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

// Avoids reinterprets by using more loads: if we load a value and
// reinterpret it, we could have loaded it with the other type
// anyhow. This uses more locals and loads, so it is not generally
// beneficial, unless reinterprets are very costly.

struct AvoidReinterprets
  : public WalkerPass<ExpressionStackWalker<AvoidReinterprets>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new AvoidReinterprets; }

  struct Info {
    // Info used when analyzing.
    Index reinterpretUsages = 0;
    Index totalUsages = 0;
    // Info used when optimizing.
    Type reinterpretedType;
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
    ExpressionStackWalker<AvoidReinterprets>::doWalkFunction(func);
    // optimize
    optimize(func);
  }

  void visitGetLocal(GetLocal* curr) {
    auto& sets = localGraph->getSetses[curr];
    if (sets.size() != 1) {
      return;
    }
    auto* set = *sets.begin();
    auto* load = set->value->dynCast<Load>();
    if (!load) {
      return;
    }
    auto& info = infos[load];
    info.totalUsages++;
    if (expressionStack.size() >= 1) {
      auto* parent = expressionStack[expressionStack.size() - 1];
      if (auto* unary = parent->dynCast<Unary>()) {
        if (unary->op == ReinterpretInt32 || unary->op == ReinterpretInt64 ||
            unary->op == ReinterpretFloat32 ||
            unary->op == ReinterpretFloat64) {
          info.reinterpretUsages++;
        }
      }
    }
  }

  void optimize(Function* func) {
    std::set<Load*> unoptimizables;
    for (auto& pair : infos) {
      auto* load = pair.first;
      auto& info = pair.second;
      if (info.reinterpretUsages > 0 && load->type != unreachable) {
        // We should use another load here, to avoid reinterprets.
        info.reinterpretedType = reinterpretType(load->type);
        info.ptrLocal = Builder::addVar(func, i32);
        info.reinterpretedLocal = Builder::addVar(func, info.reinterpretedType);
      } else {
        unoptimizables.insert(load);
      }
    }
    for (auto* load : unoptimizables) {
      infos.erase(load);
    }
    // We now know which we can optimize, and how.
    if (!infos.empty()) {
      struct AddLoads : public PostWalker<AddLoads> {
        std::map<Load*, Info>& infos;
        LocalGraph* localGraph;
        Module* module;

        AddLoads(std::map<Load*, Info>& infos,
                 LocalGraph* localGraph,
                 Module* module)
          : infos(infos), localGraph(localGraph), module(module) {}

        void visitLoad(Load* curr) {
          auto iter = infos.find(curr);
          if (iter != infos.end()) {
            auto& info = iter->second;
            Builder builder(*module);
            auto* ptr = curr->ptr;
            curr->ptr = builder.makeGetLocal(info.ptrLocal, i32);
            // Note that the other load can have its sign set to false - if the
            // original were an integer, the other is a float anyhow; and if
            // original were a float, we don't know what sign to use.
            replaceCurrent(builder.makeBlock({
              builder.makeSetLocal(info.ptrLocal, ptr),
              builder.makeSetLocal(info.reinterpretedLocal, builder.makeLoad(curr->bytes, false, curr->offset, curr->align, builder.makeGetLocal(info.ptrLocal, i32), info.reinterpretedType)),
              curr
            }));
          }
        }
      } adder(infos, localGraph, getModule());
      adder.walk(func->body);
    }
  }
};

Pass* createAvoidReinterpretsPass() { return new AvoidReinterprets(); }

} // namespace wasm
