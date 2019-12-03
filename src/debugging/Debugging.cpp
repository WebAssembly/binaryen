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

#ifndef wasm_debugging_h
#define wasm_debugging_flat_h

#include "wasm.h"
#include "debugging/debugging.h"

namespace wasm {

namespace Debugging {

void DWARFInfo::dumpLines() {
  // TODO!
#if 0
  auto DumpLineSection = [&](DWARFDebugLine::SectionParser Parser,
                             DIDumpOptions DumpOpts,
                             Optional<uint64_t> DumpOffset) {
    while (!Parser.done()) {
      if (DumpOffset && Parser.getOffset() != *DumpOffset) {
        Parser.skip(dumpWarning);
        continue;
      }
      OS << "debug_line[" << format("0x%8.8" PRIx64, Parser.getOffset())
         << "]\n";
      if (DumpOpts.Verbose) {
        Parser.parseNext(dumpWarning, dumpWarning, &OS);
      } else {
        DWARFDebugLine::LineTable LineTable =
            Parser.parseNext(dumpWarning, dumpWarning);
        LineTable.dump(OS, DumpOpts);
      }
    }
  };

  if (const auto *Off = shouldDump(Explicit, ".debug_line", DIDT_ID_DebugLine,
                                   DObj->getLineSection().Data)) {
    DWARFDataExtractor LineData(*DObj, DObj->getLineSection(), isLittleEndian(),
                                0);
    DWARFDebugLine::SectionParser Parser(LineData, *this, compile_units(),
                                         type_units());
    DumpLineSection(Parser, DumpOpts, *Off);
  }
#endif
}

} // Debugging

} // namespace wasm

#endif // wasm_debugging_h
