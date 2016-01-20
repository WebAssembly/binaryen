/*
 * Copyright 2015 WebAssembly Community Group participants
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

#include <pass.h>
#include <wasm.h>

namespace wasm {

// Simple data-flow optimization that propagates constants through locals.
struct ConstantPropagation : public WalkerPass<PreWalker<ConstantPropagation>> {
  std::vector<std::map<Name, Const *>> stack;

  ConstantPropagation() { stack.push_back(std::map<Name, Const *>()); }

  void printStack() {
    std::cout << "Stack:\n";
    int depth = 0;
    for (auto &state : stack) {
      std::cout << depth++ << ": ";
      printState(state);
    }
  }

  void printState(std::map<Name, Const *> &state) {
    for (auto i = state.begin(); i != state.end();) {
      auto x = i++;
      std::cout << x->first << " <= " << x->second;
      if (i != state.end()) {
        std::cout << ", ";
      }
    }
    std::cout << "\n";
  }

  // TODO: Handle all other control flow.

  void visitIf(If *curr) {
    tryVisit(&curr->condition);

    // Take a state snapshot after the condition.
    auto state = stack.back();

    // Visit ifTrue.
    stack.push_back(state);
    tryVisit(&curr->ifTrue);
    auto a = stack.back();
    stack.pop_back();

    // Visit ifFalse.
    stack.push_back(state);
    if (curr->ifFalse) {
      tryVisit(&curr->ifFalse);
    }
    auto b = stack.back();
    stack.pop_back();

    // Merge exit states by computing the intersection. Can't use range-for
    // here because we need to remove elements from the map while iterating.
    for (auto i = b.cbegin(); i != b.cend();) {
      // TODO: Make sure that (xxx.const ...) expressions overload the ==
      // operator.
      if (a.count(i->first) == 0 || a[i->first] != b[i->first]) {
        b.erase(i++);
      } else {
        ++i;
      }
    }

    stack.pop_back();
    stack.push_back(b);
  }

  void visitSetLocal(SetLocal *set) {
    tryVisit(&set->value);
    auto value = set->value->dyn_cast<Const>();
    if (value) {
      stack.back()[set->name] = value;
      // std::cout << "set " << set->name << " <= " << value << "\n";
    } else {
      stack.back().erase(set->name);
    }
    // printStack();
  }

  void visitGetLocal(GetLocal *get) {
    auto state = stack.back();
    // std::cout << "get " << get->name << " " << state[get->name] << "\n";
    if (state.count(get->name) == 1) {
      replaceCurrent(state[get->name]);
    }
  }
};

static RegisterPass<ConstantPropagation> registerPass("constant-propagation",
                                                      "propagates constants");

} // namespace wasm
