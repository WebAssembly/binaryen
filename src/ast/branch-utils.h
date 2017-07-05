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

#ifndef wasm_ast_branch_h
#define wasm_ast_branch_h

#include "wasm.h"
#include "wasm-traversal.h"

namespace wasm {

namespace BranchUtils {

// branches not actually taken (e.g. (br $out (unreachable)))
// are trivially ignored in our type system

inline bool isBranchTaken(Break* br) {
  return !(br->value     && br->value->type     == unreachable) &&
         !(br->condition && br->condition->type == unreachable);
}

inline bool isBranchTaken(Switch* sw) {
  return !(sw->value && sw->value->type     == unreachable) &&
                        sw->condition->type != unreachable;
}

// returns the set of targets to which we branch that are
// outside of a node
inline std::set<Name> getExitingBranches(Expression* ast) {
  struct Scanner : public PostWalker<Scanner> {
    std::set<Name> targets;

    void visitBreak(Break* curr) {
      targets.insert(curr->name);
    }
    void visitSwitch(Switch* curr) {
      for (auto target : targets) {
        targets.insert(target);
      }
      targets.insert(curr->default_);
    }
    void visitBlock(Block* curr) {
      if (curr->name.is()) {
        targets.erase(curr->name);
      }
    }
    void visitLoop(Loop* curr) {
      if (curr->name.is()) {
        targets.erase(curr->name);
      }
    }
  };
  Scanner scanner;
  scanner.walk(ast);
  // anything not erased is a branch out
  return scanner.targets;
}

// returns the list of all branch targets in a node

inline std::set<Name> getBranchTargets(Expression* ast) {
  struct Scanner : public PostWalker<Scanner> {
    std::set<Name> targets;

    void visitBlock(Block* curr) {
      if (curr->name.is()) {
        targets.insert(curr->name);
      }
    }
    void visitLoop(Loop* curr) {
      if (curr->name.is()) {
        targets.insert(curr->name);
      }
    }
  };
  Scanner scanner;
  scanner.walk(ast);
  return scanner.targets;
}

} // namespace BranchUtils

} // namespace wasm

#endif // wasm_ast_branch_h

