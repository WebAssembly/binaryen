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

//
// Print out the feature options corresponding to enabled features
//

#include "pass.h"
#include "wasm-features.h"
#include "wasm.h"

namespace wasm {

struct PrintFeatures : public Pass {
  bool modifiesBinaryenIR() override { return false; }

  void run(Module* module) override {
    module->features.iterFeatures([](FeatureSet::Feature f) {
      std::cout << "--enable-" << FeatureSet::toString(f) << std::endl;
    });
  }
};

Pass* createPrintFeaturesPass() { return new PrintFeatures(); }

} // namespace wasm
