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

#include "wasm.h"
#include "wasm-binary.h"
#include "pass.h"

using namespace std;

namespace wasm {

struct Strip : public Pass {
  // A function that returns true if the method should be removed.
  typedef std::function<bool (UserSection&)> Decider;
  Decider decider;

  Strip(Decider decider) : decider(decider) {}

  void run(PassRunner* runner, Module* module) override {
    // Remove name and debug sections.
    auto& sections = module->userSections;
    sections.erase(
      std::remove_if(
        sections.begin(),
        sections.end(),
        decider
      ),
      sections.end()
    );
    // If we're cleaning up debug info, clear on the function and module too.
    UserSection temp;
    temp.name = BinaryConsts::UserSections::Name;
    if (decider(temp)) {
      module->clearDebugInfo();
      for (auto& func : module->functions) {
        func->clearNames();
        func->clearDebugInfo();
      }
    }
  }
};

Pass *createStripDebugPass() {
  return new Strip([&](const UserSection& curr) {
    return curr.name == BinaryConsts::UserSections::Name ||
           curr.name == BinaryConsts::UserSections::SourceMapUrl ||
           curr.name.find(".debug") == 0 ||
           curr.name.find("reloc..debug") == 0;
  });
}

Pass *createStripProducersPass() {
  return new Strip([&](const UserSection& curr) {
    return curr.name == BinaryConsts::UserSections::Producers;
  });
}

Pass *createStripTargetFeaturesPass() {
  return new Strip([&](const UserSection& curr) {
    return curr.name == BinaryConsts::UserSections::TargetFeatures;
  });
}
} // namespace wasm
