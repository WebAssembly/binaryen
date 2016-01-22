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

typedef std::map<Name, Const *> State;

// Simple data-flow pass that propagates constants through locals.
// TODO: Create a generic data-flow optimization pass, and make this class
// derive from it.
struct ConstantPropagation : public WalkerPass<PreWalker<ConstantPropagation>> {
  State state;

  // State at the end of block expressions.
  std::map<Expression *, State> tails;

  // State at the beginning of loop expressions. Although we collect and merge
  // states at loop headers, we don't actually use them yet.
  std::map<Expression *, State> heads;

  // Scope stack of all scope expressions.
  std::vector<Expression *> scope;

  ConstantPropagation() {}

  // Find out which locals are assigned and erase them from the parent state.
  struct EraseLocals : public WalkerPass<PreWalker<EraseLocals>> {
    ConstantPropagation &parent;
    EraseLocals(ConstantPropagation &parent) : parent(parent) {}
    void visitSetLocal(SetLocal *set) {
      tryVisit(&set->value);
      parent.state.erase(set->name);
    }
  };

  // Checks if an expression can falls through, in other words are there any
  // unconditional branches to an outer scope.
  struct CheckFallthrough : public WalkerPass<PreWalker<CheckFallthrough>> {
    ConstantPropagation &parent;
    Expression *outer;
    bool fallthrough = true;
    CheckFallthrough(ConstantPropagation &parent, Expression *outer)
        : parent(parent), outer(outer) {
      // Outer scope should be on the scope stack at this point.
      assert(std::find(parent.scope.begin(), parent.scope.end(), outer) !=
             parent.scope.end());
    }
    void visitBreak(Break *curr) {
      tryVisit(&curr->condition);
      tryVisit(&curr->value);
      // Conditional breaks always fallthrough.
      if (curr->condition) {
        return;
      }
      Expression *expr = nullptr;
      for (auto i = parent.scope.rbegin(); i != parent.scope.rend(); i++) {
        expr = *i;
        if (expr == outer) {
          fallthrough = false;
          return;
        }
        if (expr->is<Loop>()) {
          if (expr->cast<Loop>()->out == curr->name ||
              expr->cast<Loop>()->in == curr->name) {
            break;
          }
        } else if (expr->is<Block>() &&
                   expr->cast<Block>()->name == curr->name) {
          break;
        } else if (expr->is<Switch>() &&
                   expr->cast<Switch>()->name == curr->name) {
          break;
        }
      }
    }
  };

  // Pretty print states.
  void printState(std::string name, State &state) {
    std::cout << name << ": ";
    for (auto i = state.begin(); i != state.end();) {
      auto x = i++;
      std::cout << x->first << " <= " << x->second;
      if (i != state.end()) {
        std::cout << ", ";
      }
    }
    std::cout << "\n";
  }

  void visitLoop(Loop *curr) {
    scope.push_back(curr);
    // Erase from the state any locals that are written in the loop body.
    EraseLocals(*this).tryVisit(&curr->body);
    tryVisit(&curr->body);
    // If the loop has an tail state then it must be the target of a break. We
    // need to merge the tail state into the fallthrough state.
    if (tails.count(curr)) {
      mergeState(state, tails[curr]);
    }
    scope.pop_back();
  }

  void visitIf(If *curr) {
    tryVisit(&curr->condition);
    auto copy = state;
    tryVisit(&curr->ifTrue);
    if (curr->ifFalse) {
      auto left = state;
      state = copy;
      tryVisit(&curr->ifFalse);
      mergeState(state, left);
    } else {
      mergeState(state, copy);
    }
  }

  void visitSwitch(Switch *curr) {
    tryVisit(&curr->value);
    auto copy = state;
    scope.push_back(curr);
    for (auto &case_ : curr->cases) {
      tryVisit(&case_.body);
      CheckFallthrough check(*this, curr);
      check.tryVisit(&case_.body);
      if (check.fallthrough) {
        // Merge fallthrough state with the copy we made earlier.
        mergeState(state, copy);
      } else {
        // The previous case block has no fallthrough, thus we can continue
        // with the copy we made earlier.
        state = copy;
      }
    }
    // If the switch has an tail state then it must be the target of a break. We
    // need to merge the tail state into the fallthrough state.
    if (tails.count(curr)) {
      mergeState(state, tails[curr]);
    }
    scope.pop_back();
  }

  void visitBlock(Block *curr) {
    scope.push_back(curr);
    ExpressionList &list = curr->list;
    for (size_t z = 0; z < list.size(); z++) {
      tryVisit(&list[z]);
    }
    // If the block has an tail state then it must be the target of a break. We
    // need to merge the tail state into the fallthrough state.
    if (tails.count(curr)) {
      mergeState(state, tails[curr]);
    }
    scope.pop_back();
  }

  void visitBreak(Break *curr) {
    tryVisit(&curr->condition);
    tryVisit(&curr->value);
    propagateState(curr->name, state);
  }

  // Propagates the state to the enclosing block, loop or tableswitch label.
  void propagateState(Name name, State &state) {
    std::map<Expression *, State> *map = nullptr;
    Expression *expr = nullptr;
    for (auto i = scope.rbegin(); i != scope.rend(); i++) {
      expr = *i;
      if (expr->is<Loop>()) {
        if (expr->cast<Loop>()->out == name) {
          map = &heads;
        } else if (expr->cast<Loop>()->in == name) {
          map = &tails;
        }
      } else if (expr->is<Block>() && expr->cast<Block>()->name == name) {
        map = &tails;
      } else if (expr->is<Switch>() && expr->cast<Switch>()->name == name) {
        map = &tails;
      }
      if (map) {
        break;
      }
    }
    // We must find at least one label.
    assert(map);
    // Set or merge state.
    if (map->count(expr) == 0) {
      (*map)[expr] = state;
    } else {
      mergeState((*map)[expr], state);
    }
  }

  void mergeState(State &a, State &b) {
    // Merge states by computing the intersection. Can't use range-for here
    // because we need to remove elements from the map while iterating.
    for (auto i = a.cbegin(); i != a.cend();) {
      if (b.count(i->first) == 0 || b[i->first]->value != a[i->first]->value) {
        a.erase(i++);
      } else {
        ++i;
      }
    }
  }

  void visitSetLocal(SetLocal *set) {
    tryVisit(&set->value);
    auto value = set->value->dyn_cast<Const>();
    if (value) {
      state[set->name] = value;
    } else {
      state.erase(set->name);
    }
  }

  void visitGetLocal(GetLocal *get) {
    if (state.count(get->name) == 1) {
      replaceCurrent(state[get->name]);
    }
  }
};

static RegisterPass<ConstantPropagation> registerPass("constant-propagation",
                                                      "propagates constants");

} // namespace wasm
