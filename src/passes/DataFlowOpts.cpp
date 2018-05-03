#include <wasm-printing.h>
/*
 * Copyright 2018 WebAssembly Community Group participants
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
// Optimize using the DataFlow SSA IR.
//
// This needs 'flatten' to be run before it, and you should run full
// regular opts afterwards to clean up the flattening. For example,
// you might use it like this:
//
//    --flatten --dfo -Os
//

#include "wasm.h"
#include "pass.h"
#include "wasm-builder.h"
#include "ir/utils.h"
#include "dataflow/node.h"
#include "dataflow/graph.h"
#include "dataflow/utils.h"

namespace wasm {

struct DataFlowOpts : public WalkerPass<PostWalker<DataFlowOpts>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new DataFlowOpts; }

  // nodeUsers[x] = { y, z, .. }
  // where y, z etc. are nodes that use x, that is, x is in their
  // values vector.
  std::unordered_map<DataFlow::Node*, std::unordered_set<DataFlow::Node*>> nodeUsers;

  // The optimization work left to do: nodes that we need to look at.
  std::unordered_set<DataFlow::Node*> workLeft;

  DataFlow::Graph graph;

  void doWalkFunction(Function* func) {
    // Build the data-flow IR.
    graph.build(func);
    // Generate the uses between the nodes.
    for (auto& node : graph.nodes) {
      for (auto* value : node->values) {
        nodeUsers[value].insert(node.get());
      }
    }
    // Propagate optimizations through the graph.
    std::unordered_set<DataFlow::Node*> optimized; // which nodes we optimized
    for (auto& node : graph.nodes) {
      workLeft.insert(node.get()); // we should try to optimize each node
    }
    while (!workLeft.empty()) {
      auto iter = workLeft.begin();
      auto* node = *iter;
      workLeft.erase(iter);
      workOn(node);
    }
    // After updating the DataFlow IR, we can update the sets in
    // the wasm.
    for (auto* set : graph.sets) {
      auto* node = graph.setNodeMap[set];
      auto iter = optimized.find(node);
      if (iter != optimized.end()) {
        set->value = regenerate(node);
      }
    }
  }

  void workOn(DataFlow::Node* node) {
    if (node->isConst()) return;
    // If there are no uses, there is no point to work.
    auto iter = nodeUsers.find(node);
    if (iter == nodeUsers.end()) return;
    if (iter->second.empty()) return;
    // Optimize: Look for nodes that we can easily convert into
    // something simpler.
    // TODO: we can expressionify and run full normal opts on that,
    //       then copy the result if it's smaller.
    if (node->isPhi() && DataFlow::allInputsIdentical(node)) {
      // Note we don't need to check for effects when replacing, as in
      // flattened IR expression children are get_locals or consts.
      auto* value = node->getValue(1);
      if (value->isConst()) {
        replaceAllUsesWith(node, value);
      }
    } else if (node->isExpr() && DataFlow::allInputsConstant(node)) {
      assert(!node->isConst());
      // If this is a concrete value (not e.g. an eqz of unreachable),
      // it can definitely be precomputed into a constant.
      if (isConcreteType(node->expr->type)) {
        // This can be precomputed.
        // TODO not just all-constant inputs? E.g. i32.mul of 0 and X.
        Module temp;
        Builder builder(temp);
        auto* func = builder.makeFunction("temp", std::vector<Type>{}, none, std::vector<Type>{}, node->expr);
        PassRunner runner(&temp);
        runner.setIsNested(true);
        runner.add("precompute");
        runner.runOnFunction(func);
        node->expr = func->body;
        assert(node->isConst());
        // Finish up.
        planWorkOnUsers(node);
        for (auto* value : node->values) {
          nodeUsers[value].erase(node);
        }
        node->values.clear();
      }
    }
  }

  void planWorkOnUsers(DataFlow::Node* node) {
    auto& users = nodeUsers[node];
    for (auto* user : users) {
      workLeft.insert(user);
    }
  }
  // Replaces all uses of a node with another value. This both modifies
  // the DataFlow IR to make the other users point to this one, and
  // updates the underlying Binaryen IR as well.
  // After this change, the original node has no users.
  void replaceAllUsesWith(DataFlow::Node* node, DataFlow::Node* with) {
    if (with == node) {
      return; // nothing to do
    }
    // Const nodes are trivial to replace, but other stuff is trickier -
    // in particular phis.
    assert(with->isConst()); // TODO
    // All the users should be worked on later, as we will update them.
    planWorkOnUsers(node);
    auto& users = nodeUsers[node];
    for (auto* user : users) {
      // Add the user to the work left to do, as we are modifying it.
      // Replacing in the DataFlow IR is simple - just replace it,
      // in all the indexes it appears.
      std::vector<Index> indexes;
      for (Index i = 0; i < user->values.size(); i++) {
        if (user->values[i] == node) {
          user->values[i] = with;
          indexes.push_back(i);
        }
      }
      assert(!indexes.empty());
      // `with` now has another user.
      nodeUsers[with].insert(user);
      // Replacing in the Binaryen IR requires more care
      switch (user->type) {
        case DataFlow::Node::Type::Expr: {
          auto* expr = user->expr;
          if (auto* unary = expr->dynCast<Unary>()) {
            assert(indexes.size() == 1 && indexes[0] == 0);
            unary->value = makeUse(with);
          } else if (auto* binary = expr->dynCast<Binary>()) {
            for (auto index : indexes) {
              if (index == 0) {
                binary->left = makeUse(with);
              } else if (index == 1) {
                binary->right = makeUse(with);
              } else {
std::cout << "p1\n";
                WASM_UNREACHABLE();
              }
            }
          } else if (auto* select = expr->dynCast<Select>()) {
            for (auto index : indexes) {
              if (index == 0) {
                select->condition = makeUse(with);
              } else if (index == 1) {
                select->ifTrue = makeUse(with);
              } else if (index == 2) {
                select->ifFalse = makeUse(with);
              } else {
std::cout << "p2\n";
                WASM_UNREACHABLE();
              }
            }
          } else {
std::cout << "p3\n";
            WASM_UNREACHABLE();
          }
          break;
        }
        case DataFlow::Node::Type::Phi: {
          // Nothing to do: a phi is not in the Binaryen IR.
          // If the entire phi can become a constant, that will be
          // propagated when we process that phi later.
          break;
        }
        default:
std::cout << "p4\n";
 WASM_UNREACHABLE();
      }
    }
    // No one is a user of this node after we replaced all the uses.
    users.clear();
  }

  // Creates an expression that uses a node. Generally, a node represents
  // a value in a local, so we create a get_local for it.
  Expression* makeUse(DataFlow::Node* node) {
std::cout << "make a use of ";
dump(node, std::cout);
    Builder builder(*getModule());
    if (node->isPhi()) {
      // The index is the wasm local that we assign to when implementing
      // the phi; get from there.
      auto index = node->index;
      return builder.makeGetLocal(index, getFunction()->getLocalType(index));
    } else if (node->isConst()) {
      return builder.makeConst(node->expr->cast<Const>()->value);
    } else if (node->isExpr()) {
      // Find the set we are a value of.
      auto index = graph.getSet(node)->index;
std::cout << "making a use of an expression which was set to local " << index << '\n';
      return builder.makeGetLocal(index, getFunction()->getLocalType(index));
    } else {
std::cout << "p5\n";
dump(node, std::cout);
      WASM_UNREACHABLE(); // TODO
    }
  }

  // Given a node, regenerate an expression for it that can fit in a
  // the set_local for that node.
  Expression* regenerate(DataFlow::Node* node) {
    if (node->isExpr()) {
      // TODO: do we need to look deeply?
      return node->expr;
    }
    // This is not an expression, so we just need to use it.
    return makeUse(node);
  }
};

Pass *createDataFlowOptsPass() {
  return new DataFlowOpts();
}

} // namespace wasm

