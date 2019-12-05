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

#include "wasm.h"
#include "debugging/debugging.h"
#include "llvm/include/llvm/DebugInfo/DWARFContext.h"

namespace wasm {

namespace Debugging {

void DWARFInfo::dump() {
  std::cout << "DWARFInfo::dump()\n";
  llvm::StringMap<std::unique_ptr<llvm::MemoryBuffer>> sections;
  for (auto& section : wasm.userSections) {
    if (Name(section.name).startsWith(".debug_")) {
      std::cout << "  debug section " << section.name << " (" << section.data.size() << " bytes)\n";
      sections[section.name] = llvm::MemoryBuffer::getMemBufferCopy(llvm::StringRef(section.data.data(), section.data.size()));
    }
  }
  uint8_t addrSize = 4;
  auto context = llvm::DWARFContext::create(sections, addrSize);
  llvm::DIDumpOptions options;
  options.Verbose = true;
  context->dump(llvm::errs(), options);
  std::cout << "DWARFInfo::dump() complete\n";
}

} // Debugging

} // namespace wasm

// FIXME src/llvm/Config/ is dubious
