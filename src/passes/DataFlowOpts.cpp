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
#include "dataflow/builder.h"
#include "dataflow/utils.h"

namespace wasm {

struct DataFlowOpts : public WalkerPass<PostWalker<DataFlowOpts>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new DataFlowOpts; }

  // nodeUsers[x] = vector of nodes that use it, i.e., refer to it,
  //                so that if x changes, so might they
  std::unordered_map<DataFlow::Node*, std::vector<DataFlow::Node*>> nodeUsers;

  DataFlow::Builder dataFlow;

  void doWalkFunction(Function* func) {
    // Build the data-flow IR.
    dataFlow.build(func);
    // Generate the uses between the nodes.
    for (auto& node : dataFlow.nodes) {
      for (auto* value : node->values) {
        nodeUsers[value].push_back(node.get());
      }
    }
    // Propagate optimizations through the graph.
    std::unordered_set<DataFlow::Node*> optimized; // which nodes we optimized
    std::unordered_set<DataFlow::Node*> work; // the work left to do
    for (auto& node : dataFlow.nodes) {
      work.insert(node.get()); // we should try to optimize each node
    }
    while (!work.empty()) {
      auto iter = work.begin();
      auto* node = *iter;
      work.erase(iter);
      // Try to optimize it. If we succeeded, add the things it influences.
      if (optimize(node)) {
        optimized.insert(node);
        auto iter = nodeUsers.find(node);
        if (iter != nodeUsers.end()) {
          auto& toAdd = iter->second;
          for (auto* add : toAdd) {
            work.insert(add);
          }
        }
      }
    }
    // After updating the DataFlow IR, we can update the sets in
    // the wasm.
    for (auto* set : dataFlow.sets) {
      auto* node = dataFlow.setNodeMap[set];
      auto iter = optimized.find(node);
      if (iter != optimized.end()) {
        // Simply apply the optimized expression from the node.
        assert(node->isExpr()); // we optimize to an expression
        set->value = node->expr;
      }
    }
  }

  bool optimize(DataFlow::Node* node) {
    // Optimize: Look for nodes that we can easily convert into
    // something simpler.
    // TODO: we can expressionify and run full normal opts on that,
    //       then copy the result if it's smaller.
    if (DataFlow::allInputsIdentical(node)) {
      // Note we don't need to check for effects when replacing, as in
      // flattened IR expression children are get_locals or consts.
      if (node->isPhi()) {
        replaceAllUsesWith(node, node->getValue(1));
        return true;
      }
    }
    return false;
  }

  // Replaces all uses of a node with another value. This both modifies
  // the DataFlow IR to make the other users point to this one, and
  // updates the underlying Binaryen IR as well
  void replaceAllUsesWith(DataFlow::Node* node, DataFlow::Node* with) {
std::cout << "opt!\n";
    auto& users = nodeUsers[node];
    for (auto* user : users) {
std::cout << "  user!\n";
      // Replacing in the DataFlow IR is simple - just replace it,
      // in all the indexes it appears.
      std::vector<Index> indexes;
      for (Index i = 0; i < user->values.size(); i++) {
        if (user->values[i] == node) {
          user->values[i] = with;
          indexes.push_back(i);
        }
      }
// TODO: update the 
uses, this value now has more and the other lost some
//
      assert(!indexes.empty());
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
                WASM_UNREACHABLE();
              }
            }
          } else {
            WASM_UNREACHABLE();
          }
          break;
        }
        case DataFlow::Node::Type::Phi: {
          // Nothing to do: a phi is not in the Binaryen IR
          // FIXME: don't we need to forward?
          break;
        }
        default: WASM_UNREACHABLE();
      }
    }
  }

  // Creates an expression that uses a node. Generally, a node represents
  // a value in a local, so we create a get_local for it.
  Expression* makeUse(DataFlow::Node* node) {
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
      auto iter = dataFlow.nodeParentMap.find(node);
      assert(iter != dataFlow.nodeParentMap.end());
      auto* set = iter->second->dynCast<SetLocal>();
      assert(set);
      auto index = set->index;
      return builder.makeGetLocal(index, getFunction()->getLocalType(index));
    } else {
      WASM_UNREACHABLE(); // TODO
    }
  }
};

Pass *createDataFlowOptsPass() {
  return new DataFlowOpts();
}

} // namespace wasm

