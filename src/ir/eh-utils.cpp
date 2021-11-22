/*
 * Copyright 2021 WebAssembly Community Group participants
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

#include "ir/eh-utils.h"
#include "ir/branch-utils.h"

namespace wasm {

namespace EHUtils {

bool isPopValid(Expression* catchBody) {
  Expression* firstChild = nullptr;
  auto* block = catchBody->dynCast<Block>();
  if (!block) {
    firstChild = catchBody;
  } else {
    // When there are multiple expressions within a catch body, an implicit
    // block is created within it for convenience purposes, and if there are no
    // branches that targets the block, it will be omitted when written back.
    // But if there is a branch targetting this block, this block cannot be
    // removed, and 'pop''s location will be like
    // (catch $e
    //   (block $l0
    //     (pop i32) ;; within a block!
    //     (br $l0)
    //     ...
    //   )
    // )
    // which is invalid.
    if (BranchUtils::BranchSeeker::has(block, block->name)) {
      return false;
    }
    // There should be a pop somewhere
    if (block->list.empty()) {
      return false;
    }
    firstChild = *block->list.begin();
  }

  // Go down the line for the first child until we reach a leaf. A pop should be
  // in that first-decendent line.
  while (true) {
    if (firstChild->is<Pop>()) {
      return true;
    }
    // We use ValueChildIterator in order not to go into block/loop/try/if
    // bodies, because a pop cannot be in those control flow expressions.
    ValueChildIterator it(firstChild);
    if (it.begin() == it.end()) {
      return false;
    }
    firstChild = *it.begin();
  }
}

} // namespace EHUtils

} // namespace wasm
