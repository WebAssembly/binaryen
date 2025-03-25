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

#include "ir/memory-utils.h"
#include "pass.h"
#include "wasm.h"

//
// Attempt to merge segments to fit within a specified limit.
//
// By default this limit is equal to the one commonly used by wasm VMs
// (see wasm-limits.h), but it can be changed with the option below:
//
//   --pass-arg=limit-segments@max-data-segments
//
//       Specify a custom maximum number of data segments.
//

namespace wasm {

struct LimitSegments : public Pass {
  void run(Module* module) override {
    Index maxDataSegments;
    if (hasArgument("limit-segments")) {
      maxDataSegments = std::stoul(getArgument("limit-segments", ""));
    } else {
      maxDataSegments = WebLimitations::MaxDataSegments;
    }
    if (!MemoryUtils::ensureLimitedSegments(*module, maxDataSegments)) {
      std::cerr << "Unable to merge segments. "
                << "wasm VMs may not accept this binary" << std::endl;
    }
  }
};

Pass* createLimitSegmentsPass() { return new LimitSegments(); }

} // namespace wasm
