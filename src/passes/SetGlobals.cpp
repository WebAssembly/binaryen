/*
 * Copyright 2021 WebAssembly Community Group participants
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

// Assigns values to specified globals. This can be useful to perform a minor
// customization of an existing wasm file.

#include "pass.h"
#include "support/string.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct SetGlobals : public Pass {
  // Only modifies globals.
  bool requiresNonNullableLocalFixups() override { return false; }

  void run(Module* module) override {
    Name input =
      getArgument("set-globals",
                  "SetGlobals usage:  wasm-opt --pass-arg=set-globals@x=y,z=w");

    // The input is a set of X=Y pairs separated by commas.
    String::Split pairs(input.toString(), ",");
    for (auto& pair : pairs) {
      String::Split nameAndValue(pair, "=");
      auto name = nameAndValue[0];
      auto value = nameAndValue[1];
      auto* glob = module->getGlobalOrNull(name);
      if (!glob) {
        Fatal() << "Could not find global: " << name;
      }
      // Parse the input.
      Literal lit;
      if (glob->type == Type::i32) {
        lit = Literal(int32_t(stoi(value)));
      } else if (glob->type == Type::i64) {
        lit = Literal(int64_t(stoll(value)));
      } else {
        Fatal() << "global's type is not supported: " << name;
      }
      // The global now has a value, and is not imported.
      glob->init = Builder(*module).makeConst(lit);
      glob->module = glob->base = Name();
    }
  }
};

// declare pass

Pass* createSetGlobalsPass() { return new SetGlobals(); }

} // namespace wasm
