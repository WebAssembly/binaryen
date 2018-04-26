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

#ifndef wasm_ir_label_h
#define wasm_ir_label_h

#include "wasm.h"
#include "wasm-traversal.h"

namespace wasm {

namespace LabelUtils {

// Handles branch/loop labels in a function; makes it easy to add new
// ones without duplicates
class LabelManager : public PostWalker<LabelManager> {
public:
  LabelManager(Function* func) {
    walkFunction(func);
  }

  Name getUnique(std::string prefix) {
    while (1) {
      auto curr = Name(prefix + std::to_string(counter++));
      if (labels.find(curr) == labels.end()) {
        labels.insert(curr);
        return curr;
      }
    }
  }

  void visitBlock(Block* curr) {
    labels.insert(curr->name);
  }
  void visitLoop(Loop* curr) {
    labels.insert(curr->name);
  }

private:
  std::set<Name> labels;
  size_t counter = 0;
};

} // namespace LabelUtils

} // namespace wasm

#endif // wasm_ir_label_h

