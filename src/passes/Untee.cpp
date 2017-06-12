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

//
// Removes tee_locals, replacing them with gets and sets.
//
// This makes the code "flatter", with less nested side
// effects. That can make some passes, like CodePushing,
// more effective.
//

#include <wasm.h>
#include <pass.h>
#include <wasm-builder.h>

namespace wasm {

struct Untee : public WalkerPass<PostWalker<Untee>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new Untee; }

  void visitSetLocal(SetLocal *curr) {
    if (curr->isTee()) {
      if (curr->value->type == unreachable) {
        // we don't reach the tee, just remove it
        replaceCurrent(curr->value);
      } else {
        // a normal tee. replace with set and get
        Builder builder(*getModule());
        replaceCurrent(
          builder.makeSequence(
            curr,
            builder.makeGetLocal(curr->index, curr->value->type)
          )
        );
        curr->setTee(false);
      }
    }
  }
};

Pass *createUnteePass() {
  return new Untee();
}

} // namespace wasm

