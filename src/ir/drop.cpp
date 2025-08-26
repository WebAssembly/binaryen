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

#include "ir/drop.h"
#include "ir/branch-utils.h"
#include "ir/effects.h"
#include "ir/iteration.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

Expression* getDroppedChildrenAndAppend(Expression* parent,
                                        Module& wasm,
                                        const PassOptions& options,
                                        Expression* last,
                                        DropMode mode) {
  // We check for shallow effects here, since we may be able to remove |parent|
  // itself but keep its children around - we don't want effects in the children
  // to stop us from improving the code. Note that there are cases where the
  // combined parent+children has fewer effects than parent itself, such as if
  // parent is a block and the child branches to it, but in such cases we cannot
  // remove parent anyhow (those cases are ruled out below), so looking at
  // non-shallow effects would never help us (and would be slower to run).
  bool keepParent = false;
  if (mode == DropMode::NoticeParentEffects) {
    ShallowEffectAnalyzer effects(options, wasm, parent);
    // Ignore a trap, as the unreachable replacement would trap too.
    if (last->is<Unreachable>()) {
      effects.trap = false;
    }
    keepParent = effects.hasUnremovableSideEffects();
  }

  // We cannot remove
  // 1. Expressions with unremovable side effects
  // 2. if: 'if's contains conditional expressions
  // 3. try: Removing a try could leave a pop without a proper parent
  // 4. pop: Pops are struturally necessary in catch bodies
  // 5. Branch targets: We will need the target for the branches to it to
  //                    validate.
  Builder builder(wasm);
  if (keepParent || parent->is<If>() || parent->is<Try>() ||
      parent->is<Pop>() || BranchUtils::getDefinedName(parent).is()) {
    // If parent is concrete we must drop it. Or, if it is unreachable or none,
    // then we can leave it as it is.
    if (parent->type.isConcrete()) {
      parent = builder.makeDrop(parent);
    }
    return builder.makeSequence(parent, last);
  }

  std::vector<Expression*> contents;
  for (auto* child : ChildIterator(parent)) {
    if (!EffectAnalyzer(options, wasm, child).hasUnremovableSideEffects()) {
      continue;
    }
    // See above.
    if (child->type.isConcrete()) {
      contents.push_back(builder.makeDrop(child));
    } else {
      contents.push_back(child);
    }
  }
  if (contents.empty()) {
    return last;
  }
  contents.push_back(last);
  return builder.makeBlock(contents);
}

} // namespace wasm
