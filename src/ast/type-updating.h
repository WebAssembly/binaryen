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

#ifndef wasm_ast_type_updating_h
#define wasm_ast_type_updating_h

#include "wasm-traversal.h"

namespace wasm {

// a class that tracks type dependencies between nodes, letting you
// update types efficiently when removing and altering code.
// altering code can alter types in the following way:
//   * removing a break can make a block unreachable, if nothing else
//     reaches it
//   * altering the type of a child to unreachable can make the parent
//     unreachable
struct TypeUpdater : public ExpressionStackWalker<TypeUpdater, UnifiedExpressionVisitor<TypeUpdater>> {
  // Part 1: Scanning

  // track names to their blocks, so that when we remove a break to
  // a block, we know how to find it if we need to update it
  struct BlockInfo {
    Block* block = nullptr;
    Index numBreaks = 0;
  };
  std::map<Name, BlockInfo> blockInfos;

  // track the parent of each node, as child type changes may lead to
  // unreachability
  std::map<Expression*, Expression*> parents;

  void visitExpression(Expression* curr) {
    if (expressionStack.size() > 1) {
      parents[curr] = expressionStack[expressionStack.size() - 2];
    } else {
      parents[curr] = nullptr; // this is the top level
    }
    // discover block/break relationships
    if (auto* block = curr->dynCast<Block>()) {
      if (block->name.is()) {
        blockInfos[block->name].block = block;
      }
    } else if (auto* br = curr->dynCast<Break>()) {
      blockInfos[br->name].numBreaks++;
    } else if (auto* sw = curr->dynCast<Switch>()) {
      std::set<Name> seen;
      for (auto target : sw->targets) {
        if (seen.insert(target).second) {
          blockInfos[target].numBreaks++;
        }
      }
      if (seen.insert(sw->default_).second) {
        blockInfos[sw->default_].numBreaks++;
      }
    }
  }

  // Part 2: Updating

  // Node replacements, additions, removals and type changes should be noted. An
  // exception is nodes you know will never be looked at again.

  // note the replacement of one node with another. this should be called
  // after performing the replacement.
  // this does *not* look into the node. you should do so yourself if necessary
  // does this handle recursion? do we look into child nodes that are rmeovd/added?
  void noteReplacement(Expression* from, Expression* to) {
    auto parent = parents[from];
    noteRemoval(from);
    noteAddition(to, parent, from);
  }

  // note the removal of a node
  void noteRemoval(Expression* curr) {
    noteRemovalOrAddition(curr, nullptr);
  }

  // note the removal of a node and all its children
  void noteRecursiveRemoval(Expression* curr) {
    struct Recurser : public PostWalker<Recurser, UnifiedExpressionVisitor<Recurser>> {
      TypeUpdater& parent;

      Recurser(TypeUpdater& parent, Expression* root) : parent(parent) {
        walk(root);
      }

      void visitExpression(Expression* curr) {
        parent.noteRemoval(curr);
      }
    };

    Recurser(*this, curr);
  }

  void noteAddition(Expression* curr, Expression* parent, Expression* previous = nullptr) {
    noteRemovalOrAddition(curr, parent);
    // if we didn't replace with the exact same type, propagate types up
    if (!(previous && previous->type == curr->type)) {
      propagateTypesUp(curr);
    }
  }

  // if parent is nullptr, this is a removal
  void noteRemovalOrAddition(Expression* curr, Expression* parent) {
    parents[curr] = parent;
    int change = parent ? +1 : -1;
    if (auto* br = curr->dynCast<Break>()) {
      if (!(br->value     && br->value->type     == unreachable) &&
          !(br->condition && br->condition->type == unreachable)) {
        noteBreakChange(br->name, change, br->value);
      }
    } else if (auto* sw = curr->dynCast<Switch>()) {
      if (!(sw->value     && sw->value->type     == unreachable) &&
                             sw->condition->type != unreachable) {
        applySwitchChanges(sw, change);
      }
    }
  }

  void applySwitchChanges(Switch* sw, int change) {
    std::set<Name> seen;
    for (auto target : sw->targets) {
      if (seen.insert(target).second) {
        noteBreakChange(target, change, sw->value);
      }
    }
    if (seen.insert(sw->default_).second) {
      noteBreakChange(sw->default_, change, sw->value);
    }
  }

  // note the addition of a node
  void noteBreakChange(Name name, int change, Expression* value) {
    auto iter = blockInfos.find(name);
    if (iter == blockInfos.end()) {
      return; // we can ignore breaks to loops
    }
    auto& info = iter->second;
    info.numBreaks += change;
    if (info.numBreaks == 0) {
      // dropped to 0! the block may now be unreachable. that
      // requires that it doesn't have a fallthrough
      makeBlockUnreachableIfNoFallThrough(info.block);
    } else if (change == 1 && info.numBreaks == 1) {
      // bumped to 1! the block may now be reachable
      auto* block = info.block;
      if (block->type != unreachable) {
        return; // was already reachable, had a fallthrough
      }
      changeTypeTo(block, value ? value->type : none);
    }
  }

  // alters the type of a node to a new type.
  // this propagates the type change through all the parents.
  void changeTypeTo(Expression* curr, WasmType newType) {
    if (curr->type == newType) return; // nothing to do
    curr->type = newType;
    propagateTypesUp(curr);
  }

  // given a node that has a new type, or is a new node, update
  // all the parents accordingly. the existence of the node and
  // any changes to it already occurred, this just updates the
  // parents following that. i.e., nothing is done to the
  // node we start on, it's done.
  // the one thing we need to do here is propagate unreachability,
  // no other change is possible
  void propagateTypesUp(Expression* curr) {
    if (curr->type != unreachable) return;
    while (1) {
      auto* child = curr;
      curr = parents[child];
      if (!curr) return;
      // if a child of a break/switch is now unreachable, the
      // break may no longer be taken. note that if we get here,
      // this is an actually new unreachable child of the
      // node, so if there is just 1 such child, it is us, and
      // we are newly unreachable
      if (auto* br = curr->dynCast<Break>()) {
        int unreachableChildren = 0;
        if (br->value && br->value->type == unreachable) unreachableChildren++;
        if (br->condition && br->condition->type == unreachable) unreachableChildren++;
        if (unreachableChildren == 1) {
          // the break is no longer taken
          noteBreakChange(br->name, -1, br->value);
        }
      } else if (auto* sw = curr->dynCast<Switch>()) {
        int unreachableChildren = 0;
        if (sw->value && sw->value->type == unreachable) unreachableChildren++;
        if (sw->condition->type == unreachable) unreachableChildren++;
        if (unreachableChildren == 1) {
          applySwitchChanges(sw, -1);
        }
      }
      // get ready to apply unreachability to this node
      if (curr->type == unreachable) {
        return; // already unreachable, stop here
      }
      // most nodes become unreachable if a child is unreachable,
      // but an exception exists
      if (auto* iff = curr->dynCast<If>()) {
        // may not be unreachable if just one side is
        iff->finalize();
        if (curr->type != unreachable) {
          return; // did not turn
        }
      } else {
        curr->type = unreachable;
      }
    }
  }

  // efficiently update the type of a block, given the data we know. this
  // can remove a concrete type and turn the block unreachable when it is
  // unreachable, and it does this efficiently, without scanning the full
  // contents
  void maybeUpdateTypeToUnreachable(Block* curr) {
    if (!isConcreteWasmType(curr->type)) {
      return; // nothing concrete to change to unreachable
    }
    if (curr->name.is() && blockInfos[curr->name].numBreaks > 0) {
      return;// has a break, not unreachable
    }
    // look for a fallthrough
    makeBlockUnreachableIfNoFallThrough(curr);
  }

  void makeBlockUnreachableIfNoFallThrough(Block* curr) {
    if (curr->type == unreachable) {
      return; // no change possible
    }
    for (auto* child : curr->list) {
      if (child->type == unreachable) {
        // no fallthrough, this block is now unreachable
        changeTypeTo(curr, unreachable);
        return;
      }
    }
  }
};

} // namespace wasm

#endif // wasm_ast_type_updating_h
