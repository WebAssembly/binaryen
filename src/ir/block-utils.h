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

#ifndef wasm_ir_block_h
#define wasm_ir_block_h

#include "literal.h"
#include "wasm.h"
#include "ir/branch-utils.h"
#include "ir/effects.h"

namespace wasm {

namespace BlockUtils {
  // if a block has just one element, it can often be replaced
  // with that content
  template<typename T>
  inline Expression* simplifyToContents(Block* block, T* parent, bool allowTypeChange = false) {
    auto& list = block->list;
    if (list.size() == 1 && !BranchUtils::BranchSeeker::hasNamed(list[0], block->name)) {
      // just one element. try to replace the block
      auto* singleton = list[0];
      auto sideEffects = EffectAnalyzer(parent->getPassOptions(), singleton).hasSideEffects();
      if (!sideEffects && !isConcreteType(singleton->type)) {
        // no side effects, and singleton is not returning a value, so we can throw away
        // the block and its contents, basically
        return Builder(*parent->getModule()).replaceWithIdenticalType(block);
      } else if (block->type == singleton->type || allowTypeChange) {
        return singleton;
      } else {
        // (side effects +) type change, must be block with declared value but inside is unreachable
        // (if both concrete, must match, and since no name on block, we can't be
        // branched to, so if singleton is unreachable, so is the block)
        assert(isConcreteType(block->type) && singleton->type == unreachable);
        // we could replace with unreachable, but would need to update all
        // the parent's types
      }
    } else if (list.size() == 0) {
      ExpressionManipulator::nop(block);
    }
    return block;
  }

  // similar, but when we allow the type to change while doing so
  template<typename T>
  inline Expression* simplifyToContentsWithPossibleTypeChange(Block* block, T* parent) {
    return simplifyToContents(block, parent, true);
  }
};

} // namespace wasm

#endif // wasm_ir_block_h

