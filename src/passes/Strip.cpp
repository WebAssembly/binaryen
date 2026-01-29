/*
 * Copyright 2018 WebAssembly Community Group participants
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
// Similar to strip-ing a native binary, this family of passes can
// removes debug info and other things.
//

#include <functional>

#include "pass.h"
#include "wasm-binary.h"
#include "wasm.h"

namespace wasm {

struct Strip : public Pass {
  bool requiresNonNullableLocalFixups() override { return false; }

  // A function that returns true if the method should be removed.
  using Decider = std::function<bool(CustomSection&)>;
  Decider decider;

  Strip(Decider decider) : decider(decider) {}

  void run(Module* module) override {
    // Remove name and debug sections.
    auto& sections = module->customSections;
    sections.erase(std::remove_if(sections.begin(), sections.end(), decider),
                   sections.end());
    // If we're cleaning up debug info, clear on the function and module too.
    CustomSection temp;
    temp.name = BinaryConsts::CustomSections::Name;
    if (decider(temp)) {
      module->clearDebugInfo();
      for (auto& func : module->functions) {
        func->clearNames();
        func->clearDebugInfo();
      }
    }
  }
};

Pass* createStripDebugPass() {
  return new Strip([&](const CustomSection& curr) {
    return curr.name == BinaryConsts::CustomSections::Name ||
           curr.name == BinaryConsts::CustomSections::SourceMapUrl ||
           curr.name.find(".debug") == 0 || curr.name.find("reloc..debug") == 0;
  });
}

Pass* createStripDWARFPass() {
  return new Strip([&](const CustomSection& curr) {
    return curr.name.find(".debug") == 0 || curr.name.find("reloc..debug") == 0;
  });
}

Pass* createStripProducersPass() {
  return new Strip([&](const CustomSection& curr) {
    return curr.name == BinaryConsts::CustomSections::Producers;
  });
}

} // namespace wasm
