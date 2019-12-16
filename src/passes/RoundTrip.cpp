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

#ifdef _WIN32
#include <io.h>
#endif

#include <cstdlib>
#include <vector>

#include "ir/module-utils.h"
#include "pass.h"
#include "support/file.h"
#include "wasm-io.h"
#include "wasm.h"

using namespace std;

namespace wasm {

struct RoundTrip : public Pass {
  void run(PassRunner* runner, Module* module) override {
    std::string templateName = "byn_round_trip_XXXXXX";
    std::vector<char> buffer(templateName.begin(), templateName.end());
    buffer.push_back(0);
#ifndef _WIN32
    auto fd = mkstemp(buffer.data());
    WASM_UNUSED(fd);
    std::string tempName(buffer.begin(), buffer.end());
#else
    std::string tempName = _mktemp(buffer.data());
#endif
    // Write
    ModuleWriter writer;
    writer.setBinary(true);
    writer.setDebugInfo(runner->options.debugInfo);
    writer.write(*module, tempName);
    // Read
    ModuleUtils::clearModule(*module);
    ModuleReader reader;
    // TODO: enable debug info when relevant
    reader.read(tempName, *module);
    // Clean up
    std::remove(tempName.c_str());
  }
};

Pass* createRoundTripPass() { return new RoundTrip(); }

} // namespace wasm
