/*
 * Copyright 2024 WebAssembly Community Group participants
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
// DebugLocationPropagation aim to pass debug location from a parent node
// to child nodes which has no debug location. This is useful for compilers
// that use Binaryen API to generate WebAssembly modules.
//

#include "pass.h"
#include "wasm-traversal.h"
#include "wasm.h"
#include <cassert>
#include <unordered_map>

namespace wasm {

template<typename SubType, typename VisitorType = Visitor<SubType>>
struct PreWalker : public Walker<SubType, VisitorType> {
  static void scan(SubType* self, Expression** currp) {
    Expression* curr = *currp;

#define DELEGATE_ID curr->_id

#define DELEGATE_START(id) [[maybe_unused]] auto* cast = curr->cast<id>();

#define DELEGATE_GET_FIELD(id, field) cast->field

#define DELEGATE_FIELD_CHILD(id, field)                                        \
  self->pushTask(SubType::scan, &cast->field);

#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field)                               \
  self->maybePushTask(SubType::scan, &cast->field);

#define DELEGATE_FIELD_INT(id, field)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field)
#define DELEGATE_FIELD_TYPE(id, field)
#define DELEGATE_FIELD_HEAPTYPE(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)

#define DELEGATE_END(id) self->pushTask(SubType::doVisit##id, currp);

#include "wasm-delegations-fields.def"
  }
};

using DebugLocationStack = SmallVector<Function::DebugLocation*, 10>;

struct DebugLocationPropagation
  : public WalkerPass<
      PreWalker<DebugLocationPropagation,
                UnifiedExpressionVisitor<DebugLocationPropagation>>> {
  DebugLocationStack debugLocationStack;

  bool isFunctionParallel() override { return false; }

  static void doPostVisit(DebugLocationPropagation* self, Expression** currp) {
    self->debugLocationStack.pop_back();
  }

  static void scan(DebugLocationPropagation* self, Expression** currp) {
    self->pushTask(DebugLocationPropagation::doPostVisit, currp);

    PreWalker<DebugLocationPropagation,
              UnifiedExpressionVisitor<DebugLocationPropagation>>::scan(self,
                                                                        currp);
  }

  void visitExpression(Expression* curr) {
    auto& currFuncDebugLocations = getFunction()->debugLocations;
    const auto currDebugLocation = currFuncDebugLocations.find(curr);
    if (currDebugLocation != currFuncDebugLocations.end()) {
      debugLocationStack.push_back(&currDebugLocation->second);
      return;
    }
    Function::DebugLocation* parentDebugLocation = getParentDebugLocation();
    if (parentDebugLocation != nullptr) {
      currFuncDebugLocations[curr] = *parentDebugLocation;
    }
    debugLocationStack.push_back(parentDebugLocation);
  }

  Function::DebugLocation* getParentDebugLocation() {
    if (debugLocationStack.empty()) {
      return nullptr;
    }
    assert(debugLocationStack.size() >= 1);
    return debugLocationStack.back();
  }
};

Pass* createDebugLocationPropagationPass() {
  return new DebugLocationPropagation();
}

} // namespace wasm