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
// Write the module to binary, and load it from there. This is useful in
// testing to check for the effects of roundtripping in a single wasm-opt
// parameter.
//

#include "ir/module-utils.h"
#include "pass.h"
#include "wasm-binary.h"
#include "wasm.h"

namespace wasm {

struct RoundTrip : public Pass {
  // Reloading the wasm may alter function names etc., which means our global
  // function effect tracking can get confused, and effects may seem to appear.
  // To avoid that, mark this pass as adding effects, which will clear all
  // cached effects and such.
  bool addsEffects() override { return true; }

  void run(Module* module) override {
    BufferWithRandomAccess buffer;
    // Save features, which would not otherwise make it through a round trip if
    // the target features section has been stripped. We also need them in order
    // to tell the builder which features to build with.
    auto features = module->features;
    // Write, clear, and read the module
    WasmBinaryWriter(module, buffer, getPassOptions()).write();
    ModuleUtils::clearModule(*module);
    auto input = buffer.getAsChars();
    WasmBinaryReader parser(*module, features, input);
    parser.setDWARF(getPassOptions().debugInfo);
    try {
      parser.read();
    } catch (ParseException& p) {
      p.dump(std::cerr);
      std::cerr << '\n';
      Fatal() << "error in parsing wasm binary";
    }
  }
};

Pass* createRoundTripPass() { return new RoundTrip(); }

} // namespace wasm
