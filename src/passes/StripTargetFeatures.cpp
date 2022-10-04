/*
 * Copyright 2019 WebAssembly Community Group participants
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

#include "pass.h"

namespace wasm {

struct StripTargetFeatures : public Pass {
  bool requiresNonNullableLocalFixups() override { return false; }

  bool isStripped = false;
  StripTargetFeatures(bool isStripped) : isStripped(isStripped) {}
  void run(Module* module) override {
    module->hasFeaturesSection = !isStripped;
  }
};

Pass* createStripTargetFeaturesPass() { return new StripTargetFeatures(true); }
Pass* createEmitTargetFeaturesPass() { return new StripTargetFeatures(false); }

} // namespace wasm
