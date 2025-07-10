/*
 * Copyright 2025 WebAssembly Community Group participants
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
// Apply random branch hints. This is really only useful for fuzzing. The
// randomness here is deterministic, so that reducing can work.
//

#include "pass.h"
#include "support/hash.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct RandomizeBranchHints
  : public WalkerPass<
      PostWalker<RandomizeBranchHints,
                 UnifiedExpressionVisitor<RandomizeBranchHints>>> {

  uint64_t hash = 42;

  void visitExpression(Expression* curr) {
    // Add some deterministic randomness as we go.
    deterministic_hash_combine(hash, curr->_id);
  }

  void visitIf(If* curr) {
    deterministic_hash_combine(hash, 1337);
    processCondition(curr);
  }

  void visitBreak(Break* curr) {
    deterministic_hash_combine(hash, 99999);
    if (curr->condition) {
      processCondition(curr);
    }
  }

  // TODO: BrOn

  template<typename T> void processCondition(T* curr) {
    auto& likely = getFunction()->codeAnnotations[curr].branchLikely;
    switch (hash % 3) {
      case 0:
        likely = true;
        break;
      case 1:
        likely = false;
        break;
      case 2:
        likely = {};
        break;
    }
  }
};

Pass* createRandomizeBranchHintsPass() { return new RandomizeBranchHints(); }

} // namespace wasm
