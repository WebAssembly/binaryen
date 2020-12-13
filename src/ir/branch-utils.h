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

#include "ir/iteration.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace BranchUtils {

// Some branches are obviously not actually reachable (e.g. (br $out
// (unreachable)))

inline bool isBranchReachable(Expression* expr) {
  // If any child is unreachable, the branch is not taken. Note that expr itself
  // may be unreachable regardless (as in the case of a simple Break with no
  // condition, which is still taken).
  for (auto child : ChildIterator(expr)) {
    if (child->type == Type::unreachable) {
      return false;
    }
  }
  return true;
}

using NameSet = std::set<Name>;

inline NameSet getUniqueTargets(Expression* expr) {
  NameSet ret;

#define DELEGATE_ID expr->_id

#define DELEGATE_START(id)                                                     \
  auto* cast = expr->cast<id>();                                               \
  WASM_UNUSED(cast);

#define DELEGATE_GET_FIELD(id, name) cast->name

#define DELEGATE_FIELD_SCOPE_NAME_USE(id, name)                                \
  ret.insert(cast->name);

#define DELEGATE_FIELD_CHILD(id, name)
#define DELEGATE_FIELD_INT(id, name)
#define DELEGATE_FIELD_LITERAL(id, name)
#define DELEGATE_FIELD_NAME(id, name)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, name)
#define DELEGATE_FIELD_SIGNATURE(id, name)
#define DELEGATE_FIELD_TYPE(id, name)
#define DELEGATE_FIELD_ADDRESS(id, name)
#define DELEGATE_FIELD_CHILD_VECTOR(id, name)
#define DELEGATE_FIELD_INT_ARRAY(id, name)

#include "wasm-delegations-fields.h"

  return ret;
}
// If we branch to 'from', change that to 'to' instead.
inline bool replacePossibleTarget(Expression* branch, Name from, Name to) {
  bool worked = false;

#define DELEGATE_ID branch->_id

#define DELEGATE_START(id)                                                     \
  auto* cast = branch->cast<id>();                                             \
  WASM_UNUSED(cast);

#define DELEGATE_GET_FIELD(id, name) cast->name

#define DELEGATE_FIELD_SCOPE_NAME_USE(id, name)                                \
  if (cast->name == from) {                                                    \
    cast->name = to;                                                           \
    worked = true;                                                             \
  }

#define DELEGATE_FIELD_CHILD(id, name)
#define DELEGATE_FIELD_INT(id, name)
#define DELEGATE_FIELD_LITERAL(id, name)
#define DELEGATE_FIELD_NAME(id, name)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, name)
#define DELEGATE_FIELD_SIGNATURE(id, name)
#define DELEGATE_FIELD_TYPE(id, name)
#define DELEGATE_FIELD_ADDRESS(id, name)
#define DELEGATE_FIELD_CHILD_VECTOR(id, name)
#define DELEGATE_FIELD_INT_ARRAY(id, name)

#include "wasm-delegations-fields.h"

  return worked;
}

// returns the set of targets to which we branch that are
// outside of a node
inline NameSet getExitingBranches(Expression* ast) {
  struct Scanner : public PostWalker<Scanner> {
    NameSet targets;

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

inline NameSet getBranchTargets(Expression* ast) {
  struct Scanner : public PostWalker<Scanner> {
    NameSet targets;

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

  void noteFound(Expression* value) {
    noteFound(value ? value->type : Type::none);
  }

  void noteFound(Type type) {
    found++;
    if (found == 1) {
      valueType = Type::unreachable;
    }
    if (type != Type::unreachable) {
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

// Accumulates all the branches in an entire tree.
struct BranchAccumulator
  : public PostWalker<BranchAccumulator,
                      UnifiedExpressionVisitor<BranchAccumulator>> {
  NameSet branches;

  void visitExpression(Expression* curr) {
    auto selfBranches = getUniqueTargets(curr);
    branches.insert(selfBranches.begin(), selfBranches.end());
  }
};

// A helper structure for the common case of post-walking some IR while querying
// whether a branch is present. We can cache results for children in order to
// avoid quadratic time searches.
// We assume that a node will be scanned *once* here. That means that if we
// scan a node, we can discard all information for its children. This avoids
// linearly increasing memory usage over time.
class BranchSeekerCache {
  // Maps all the branches present in an expression and all its nested children.
  std::unordered_map<Expression*, NameSet> branches;

public:
  const NameSet& getBranches(Expression* curr) {
    auto iter = branches.find(curr);
    if (iter != branches.end()) {
      return iter->second;
    }
    NameSet currBranches;
    auto add = [&](NameSet& moreBranches) {
      // Make sure to do a fast swap for the first set of branches to arrive.
      // This helps the case of the first child being a block with a very large
      // set of names.
      if (currBranches.empty()) {
        currBranches.swap(moreBranches);
      } else {
        currBranches.insert(moreBranches.begin(), moreBranches.end());
      }
    };
    // Add from the children, which are hopefully cached.
    for (auto child : ChildIterator(curr)) {
      auto iter = branches.find(child);
      if (iter != branches.end()) {
        add(iter->second);
        // We are scanning the parent, which means we assume the child will
        // never be visited again.
        branches.erase(iter);
      } else {
        // The child was not cached. Scan it manually.
        BranchAccumulator childBranches;
        childBranches.walk(child);
        add(childBranches.branches);
        // Don't bother caching anything - we are scanning the parent, so the
        // child will presumably not be scanned again.
      }
    }
    // Finish with the parent's own branches.
    auto selfBranches = getUniqueTargets(curr);
    add(selfBranches);
    return branches[curr] = std::move(currBranches);
  }

  bool hasBranch(Expression* curr, Name target) {
    bool result = getBranches(curr).count(target);
#ifdef BRANCH_UTILS_DEBUG
    assert(bresult == BranchSeeker::has(curr, target));
#endif
    return result;
  }
};

} // namespace BranchUtils

} // namespace wasm

#endif // wasm_ir_branch_h
