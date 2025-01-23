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
// Emits the data segments to a file. The file contains data from address base
// onwards (we must pass in base, as we can't tell it from the wasm - the
// first segment may start after a run of zeros, but we need those zeros in
// the file.
//

#include "pass.h"
#include "support/file.h"
#include "wasm-features.h"
#include "wasm.h"

namespace wasm {

struct SeparateDataSegments : public Pass {
  bool modifiesBinaryenIR() override { return false; }

  void run(Module* module) override {
    std::string outfileName =
      getArgument("separate-data-segments",
                  "SeparateDataSegments usage: wasm-opt "
                  "--separate-data-segments@FILENAME");
    Output outfile(outfileName, Flags::Binary);
    std::string baseStr =
      getArgument("separate-data-segments-global-base",
                  "SeparateDataSegments usage: wasm-opt "
                  "--pass-arg=separate-data-segments-global-base@NUMBER");
    Address base = std::stoi(baseStr);
    size_t lastEnd = 0;
    for (auto& seg : module->dataSegments) {
      if (seg->isPassive) {
        Fatal() << "separating passive segments not implemented";
      }
      if (!seg->offset->is<Const>()) {
        Fatal() << "separating relocatable segments not implemented";
      }
      size_t offset = seg->offset->cast<Const>()->value.getInteger();
      offset -= base;
      size_t fill = offset - lastEnd;
      if (fill > 0) {
        std::vector<char> buf(fill);
        outfile.write(buf.data(), fill);
      }
      outfile.write(seg->data.data(), seg->data.size());
      lastEnd = offset + seg->data.size();
    }
    module->dataSegments.clear();
    // Remove the start/stop symbols that the PostEmscripten uses to remove
    // em_asm/em_js data.  Since we just removed all the data segments from the
    // file there is nothing more for that pass to do.
    // TODO(sbc): Fix the ordering so that the removal the EM_ASM/EM_JS data
    // comes before this pass.
    module->removeExport("__start_em_asm");
    module->removeExport("__stop_em_asm");
    module->removeExport("__start_em_js");
    module->removeExport("__stop_em_js");
  }
};

Pass* createSeparateDataSegmentsPass() { return new SeparateDataSegments(); }

} // namespace wasm
