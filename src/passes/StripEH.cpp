/*
 * Copyright 2023 WebAssembly Community Group participants
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
// Removes all EH instructions and tags. Removes catch blocks and converts
// 'throw's into 'unreachable's. Any exception thrown will crash the program as
// they are now traps.
//

#include <ir/drop.h>
#include <ir/utils.h>

namespace wasm {

namespace {

struct StripEHImpl : public WalkerPass<PostWalker<StripEHImpl>> {
  bool isFunctionParallel() override { return true; }

  bool refinalize = false;

  std::unique_ptr<Pass> create() override {
    return std::make_unique<StripEHImpl>();
  }

  void visitThrow(Throw* curr) {
    auto& wasm = *getModule();
    Builder builder(wasm);
    replaceCurrent(getDroppedChildrenAndAppend(curr,
                                               wasm,
                                               getPassOptions(),
                                               builder.makeUnreachable(),
                                               DropMode::IgnoreParentEffects));
  }

  void visitTry(Try* curr) {
    replaceCurrent(curr->body);
    refinalize = true;
  }

  void visitFunction(Function* curr) {
    if (refinalize) {
      ReFinalize().walkFunctionInModule(curr, getModule());
    }
  }
};

struct StripEH : public Pass {
  void run(Module* wasm) override {
    PassRunner runner(wasm);
    // We run this as an inner pass to make it parallel. This StripEH pass
    // itself cannot be parallel because we need to disable the EH feature.
    runner.add(std::make_unique<StripEHImpl>());
    runner.setIsNested(true);
    runner.run();
    wasm->removeTags([](Tag*) { return true; });
    wasm->features.disable(FeatureSet::ExceptionHandling);
  }
};

} // anonymous namespace

Pass* createStripEHPass() { return new StripEH(); }

} // namespace wasm
