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

#ifndef wasm_ir_branch_h
#define wasm_ir_branch_h

#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace BranchUtils {

// Some branches are obviously not actually reachable (e.g. (br $out
// (unreachable)))

inline bool isBranchReachable(Break* br) {
  return !(br->value && br->value->type == unreachable) &&
         !(br->condition && br->condition->type == unreachable);
}

inline bool isBranchReachable(Switch* sw) {
  return !(sw->value && sw->value->type == unreachable) &&
         sw->condition->type != unreachable;
}

inline bool isBranchReachable(BrOnExn* br) {
  return br->exnref->type != unreachable;
}

inline bool isBranchReachable(Expression* expr) {
  if (auto* br = expr->dynCast<Break>()) {
    return isBranchReachable(br);
  } else if (auto* sw = expr->dynCast<Switch>()) {
    return isBranchReachable(sw);
  } else if (auto* br = expr->dynCast<BrOnExn>()) {
    return isBranchReachable(br);
  }
  WASM_UNREACHABLE("unexpected expression type");
}

inline std::set<Name> getUniqueTargets(Break* br) { return {br->name}; }

inline std::set<Name> getUniqueTargets(Switch* sw) {
  std::set<Name> ret;
  for (auto target : sw->targets) {
    ret.insert(target);
  }
  ret.insert(sw->default_);
  return ret;
}

inline std::set<Name> getUniqueTargets(BrOnExn* br) { return {br->name}; }

// If we branch to 'from', change that to 'to' instead.
inline bool replacePossibleTarget(Expression* branch, Name from, Name to) {
  bool worked = false;
  if (auto* br = branch->dynCast<Break>()) {
    if (br->name == from) {
      br->name = to;
      worked = true;
    }
  } else if (auto* sw = branch->dynCast<Switch>()) {
    for (auto& target : sw->targets) {
      if (target == from) {
        target = to;
        worked = true;
      }
    }
    if (sw->default_ == from) {
      sw->default_ = to;
      worked = true;
    }
  } else if (auto* br = branch->dynCast<BrOnExn>()) {
    if (br->name == from) {
      br->name = to;
      worked = true;
    }
  } else {
    WASM_UNREACHABLE("unexpected expression type");
  }
  return worked;
}

// returns the set of targets to which we branch that are
// outside of a node
inline std::set<Name> getExitingBranches(Expression* ast) {
  struct Scanner : public PostWalker<Scanner> {
    std::set<Name> targets;

    void visitBreak(Break* curr) { targets.insert(curr->name); }
    void visitSwitch(Switch* curr) {
      for (auto target : curr->targets) {
        targets.insert(target);
      }
      targets.insert(curr->default_);
    }
    void visitBrOnExn(BrOnExn* curr) { targets.insert(curr->name); }
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

// Finds if there are branches targeting a name. Note that since names are
// unique in our IR, we just need to look for the name, and do not need
// to analyze scoping.
struct BranchSeeker : public PostWalker<BranchSeeker> {
  Name target;

  Index found = 0;
  Type valueType;

  BranchSeeker(Name target) : target(target) {}

  void noteFound(Expression* value) { noteFound(value ? value->type : none); }

  void noteFound(Type type) {
    found++;
    if (found == 1) {
      valueType = unreachable;
    }
    if (type != unreachable) {
      valueType = type;
    }
  }

  void visitBreak(Break* curr) {
    // check the break
    if (curr->name == target) {
      noteFound(curr->value);
    }
  }

  void visitSwitch(Switch* curr) {
    // check the switch
    for (auto name : curr->targets) {
      if (name == target) {
        noteFound(curr->value);
      }
    }
    if (curr->default_ == target) {
      noteFound(curr->value);
    }
  }

  void visitBrOnExn(BrOnExn* curr) {
    // check the br_on_exn
    if (curr->name == target) {
      noteFound(curr->sent);
    }
  }

  static bool has(Expression* tree, Name target) {
    if (!target.is()) {
      return false;
    }
    BranchSeeker seeker(target);
    seeker.walk(tree);
    return seeker.found > 0;
  }

  static Index count(Expression* tree, Name target) {
    if (!target.is()) {
      return 0;
    }
    BranchSeeker seeker(target);
    seeker.walk(tree);
    return seeker.found;
  }
};

} // namespace BranchUtils

} // namespace wasm

#endif // wasm_ir_branch_h
