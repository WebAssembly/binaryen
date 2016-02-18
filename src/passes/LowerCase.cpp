/*
 * Copyright 2015 WebAssembly Community Group participants
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
// Lowers switch cases out into blocks,
//
/*
    (tableswitch $switch$0
      (i32.sub
        (get_local $x)
        (i32.const 1)
      )
      (table (case $switch-case$1) (case $switch-case$2)) (case $switch-default$3)
      (case $switch-case$1
        (return
          (i32.const 1)
        )
      )
      (case $switch-case$2
        (return
          (i32.const 2)
        )
      )
      (case $switch-default$3
        (nop)
      )
    )

  into

    (block $forswitch$switch$0
      (block $switch-case$3
        (block $switch-case$2
          (block $switch-case$1
            (tableswitch $switch$0
              (i32.sub
                (get_local $x)
                (i32.const 1)
              )
              (table (br $switch-case$1) (br $switch-case$2)) (br $switch-default$3)
            )
          )
          (return
            (i32.const 1)
          )
        )
        (return
          (i32.const 2)
        )
      )
      (nop)
    )
*/


#include <memory>

#include <wasm.h>
#include <pass.h>

namespace wasm {

struct LowerCase : public WalkerPass<WasmWalker<LowerCase, void>> {
  MixedArena* allocator;

  void prepare(PassRunner* runner, Module *module) override {
    allocator = runner->allocator;
  }

  void visitSwitch(Switch *curr) {
    if (curr->cases.size() == 0) return;
    auto top = allocator->alloc<Block>();
    top->list.push_back(curr);
    for (auto& c : curr->cases) {
      top->name = c.name;
      auto next = allocator->alloc<Block>();
      next->list.push_back(top);
      next->list.push_back(c.body);
      top = next;
    }
    curr->cases.clear();
    top->name = Name(std::string("forswitch$") + curr->name.str);
    replaceCurrent(top);
  }
};

static RegisterPass<LowerCase> registerPass("lower-case", "lowers cases into blocks");

} // namespace wasm
