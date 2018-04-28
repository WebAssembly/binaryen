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
    // Optimize: Look for nodes that we can easily convert into
    // something simpler.
    // TODO: we can expressionify and run full normal opts on that,
    //       then ExpressionManipulator::copy(from->body, *module);
    //       the result if it's smaller.
    for (auto* set : builder.sets) {
      auto* node = builder.setNodeMap[set];
      if (node->isPhi()) {
        auto* firstValue = node->getValue(1);
        if (firstValue->isConst() &&
            DataFlow::allInputsIdentical(node)) {
          // Do it!
        }
      }
    }
  }
};

Pass *createDataFlowOptsPass() {
  return new DataFlowOpts();
}

} // namespace wasm

