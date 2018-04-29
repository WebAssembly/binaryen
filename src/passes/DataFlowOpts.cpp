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

  void doWalkFunction(Function* func) {
    // Build the data-flow IR.
    DataFlow::Builder builder(func);
    // Generate the influences between the nodes.
    // influences[x] = vector of nodes it influences, i.e.,
    //                 that use it, so that if x changes,
    //                 so might they
    std::unordered_map<DataFlow::Node*, std::vector<DataFlow::Node*>> influences;
    for (auto& node : builder.nodes) {
      for (auto* value : node->values) {
        influences[value].push_back(node.get());
      }
    }
    // Propagate optimizations through the graph.
    std::unordered_set<DataFlow::Node*> optimized; // which nodes we optimized
    std::unordered_set<DataFlow::Node*> work; // the work left to do
    for (auto& node : builder.nodes) {
      work.insert(node.get()); // we should try to optimize each node
    }
    while (!work.empty()) {
      auto iter = work.begin();
      auto* node = *iter;
      work.erase(iter);
      // Try to optimize it. If we succeeded, add the things it influences.
      if (optimize(node)) {
        optimized.insert(node);
        auto iter = influences.find(node);
        if (iter != influences.end()) {
          auto& toAdd = iter->second;
          for (auto* add : toAdd) {
            work.insert(add);
          }
        }
      }
    }
    // After updating the DataFlow IR, we can update the sets in
    // the wasm.
    for (auto* set : builder.sets) {
      auto* node = builder.setNodeMap[set];
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
      if (node->isExpr()) {
//        auto* expr = node->expr;
//        if (auto* binary = expr->dynCast<Binary>()) {
//          binary->right = make a another use of left
// ExpressionManipulator::binary->left
//          return true;
//        }
      } else if (node->isPhi()) {
        return replaceWithValue(node, node->getValue(1));
      }
    }
    return false;
  }

  // Replaces a node with the value from another node. Returns true if
  // we succeeded.
  // This replaces the node itself in-place.
  bool replaceWithValue(DataFlow::Node* node, DataFlow::Node* with) {
    if (with->isConst()) {
      auto* copy = ExpressionManipulator::copy(with->expr, *getModule());
      *node = DataFlow::Node(DataFlow::Node::Type::Expr);
      node->expr = copy;
      return true;
    }
    // TODO: if it's an expression, it's assigned to a local, and we can
    //       get_local it.
    return false;
  }
};

Pass *createDataFlowOptsPass() {
  return new DataFlowOpts();
}

} // namespace wasm

