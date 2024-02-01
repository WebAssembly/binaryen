/*
 * Copyright 2022 WebAssembly Community Group participants
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

#include "ir/memory-utils.h"
#include "support/stdckdint.h"
#include "wasm.h"

namespace wasm::MemoryUtils {

bool flatten(Module& wasm) {
  // Flatten does not currently have support for multimemory
  if (wasm.memories.size() > 1) {
    return false;
  }
  // The presence of any instruction that cares about segment identity is a
  // problem because flattening gets rid of that (when it merges them all into
  // one big segment).
  struct Scanner : public WalkerPass<
                     PostWalker<Scanner, UnifiedExpressionVisitor<Scanner>>> {
    std::atomic<bool>& noticesSegmentIdentity;

    Scanner(std::atomic<bool>& noticesSegmentIdentity)
      : noticesSegmentIdentity(noticesSegmentIdentity) {}

    std::unique_ptr<Pass> create() override {
      return std::make_unique<Scanner>(noticesSegmentIdentity);
    }

    void visitExpression(Expression* curr) {
#define DELEGATE_ID curr->_id

#define DELEGATE_START(id) [[maybe_unused]] auto* cast = curr->cast<id>();

#define DELEGATE_GET_FIELD(id, field) cast->field

#define DELEGATE_FIELD_TYPE(id, field)
#define DELEGATE_FIELD_HEAPTYPE(id, field)
#define DELEGATE_FIELD_CHILD(id, field)
#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field)
#define DELEGATE_FIELD_INT(id, field)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)

#define DELEGATE_FIELD_NAME_KIND(id, field, kind)                              \
  if (kind == ModuleItemKind::DataSegment) {                                   \
    noticesSegmentIdentity = true;                                             \
  }

#include "wasm-delegations-fields.def"
    }
  };

  std::atomic<bool> noticesSegmentIdentity = false;
  PassRunner runner(&wasm);
  Scanner scanner(noticesSegmentIdentity);
  scanner.setPassRunner(&runner);
  scanner.run(&wasm);
  scanner.runOnModuleCode(&runner, &wasm);
  if (noticesSegmentIdentity) {
    return false;
  }

  auto& dataSegments = wasm.dataSegments;

  if (dataSegments.size() == 0) {
    return true;
  }

  std::vector<char> data;
  for (auto& segment : dataSegments) {
    if (segment->isPassive) {
      return false;
    }
    auto* offset = segment->offset->dynCast<Const>();
    if (!offset) {
      return false;
    }
  }
  for (auto& segment : dataSegments) {
    auto* offset = segment->offset->dynCast<Const>();
    Index start = offset->value.getInteger();
    Index size = segment->data.size();
    Index end;
    if (std::ckd_add(&end, start, size)) {
      return false;
    }
    if (end > data.size()) {
      data.resize(end);
    }
    std::copy(segment->data.begin(), segment->data.end(), data.begin() + start);
  }
  dataSegments[0]->offset->cast<Const>()->value = Literal(int32_t(0));
  dataSegments[0]->data.swap(data);
  wasm.removeDataSegments(
    [&](DataSegment* curr) { return curr->name != dataSegments[0]->name; });

  return true;
}

} // namespace wasm::MemoryUtils
