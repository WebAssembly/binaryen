/*
 * Copyright 2016 WebAssembly Community Group participants
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

#include "wasm-emscripten.h"

#include <sstream>

#include "asm_v_wasm.h"
#include "asmjs/shared-constants.h"
#include "ir/import-utils.h"
#include "ir/literal-utils.h"
#include "ir/module-utils.h"
#include "shared-constants.h"
#include "support/debug.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

#define DEBUG_TYPE "emscripten"

namespace wasm {

void addExportedFunction(Module& wasm, Function* function) {
  wasm.addFunction(function);
  auto export_ = new Export;
  export_->name = export_->value = function->name;
  export_->kind = ExternalKind::Function;
  wasm.addExport(export_);
}

// TODO(sbc): There should probably be a better way to do this.
bool isExported(Module& wasm, Name name) {
  for (auto& ex : wasm.exports) {
    if (ex->value == name) {
      return true;
    }
  }
  return false;
}

Global* getStackPointerGlobal(Module& wasm) {
  // Assumption: The stack pointer is either imported as __stack_pointer or
  // we just assume it's the first non-imported global.
  // TODO(sbc): Find a better way to discover the stack pointer.  Perhaps the
  // linker could export it by name?
  for (auto& g : wasm.globals) {
    if (g->imported() && g->base == STACK_POINTER) {
      return g.get();
    }
  }
  for (auto& g : wasm.globals) {
    if (!g->imported()) {
      return g.get();
    }
  }
  return nullptr;
}

const Address UNKNOWN_OFFSET(uint32_t(-1));

std::string escape(std::string code) {
  // replace newlines quotes with escaped newlines
  size_t curr = 0;
  while ((curr = code.find("\\n", curr)) != std::string::npos) {
    code = code.replace(curr, 2, "\\\\n");
    curr += 3; // skip this one
  }
  curr = 0;
  while ((curr = code.find("\\t", curr)) != std::string::npos) {
    code = code.replace(curr, 2, "\\\\t");
    curr += 3; // skip this one
  }
  // replace double quotes with escaped single quotes
  curr = 0;
  while ((curr = code.find('"', curr)) != std::string::npos) {
    if (curr == 0 || code[curr - 1] != '\\') {
      code = code.replace(curr,
                          1,
                          "\\"
                          "\"");
      curr += 2; // skip this one
    } else {     // already escaped, escape the slash as well
      code = code.replace(curr,
                          1,
                          "\\"
                          "\\"
                          "\"");
      curr += 3; // skip this one
    }
  }
  return code;
}

class StringConstantTracker {
public:
  StringConstantTracker(Module& wasm) : wasm(wasm) { calcSegmentOffsets(); }

  const char* stringAtAddr(Address address) {
    for (unsigned i = 0; i < wasm.dataSegments.size(); ++i) {
      auto& segment = wasm.dataSegments[i];
      Address offset = segmentOffsets[i];
      if (offset != UNKNOWN_OFFSET && address >= offset &&
          address < offset + segment->data.size()) {
        return &segment->data[address - offset];
      }
    }
    Fatal() << "unable to find data for ASM/EM_JS const at: " << address;
    return nullptr;
  }

  std::vector<Address> segmentOffsets; // segment index => address offset

private:
  void calcSegmentOffsets() {
    std::unordered_map<Name, Address> passiveOffsets;
    if (wasm.features.hasBulkMemory()) {
      // Fetch passive segment offsets out of memory.init instructions
      struct OffsetSearcher : PostWalker<OffsetSearcher> {
        std::unordered_map<Name, Address>& offsets;
        OffsetSearcher(std::unordered_map<Name, Address>& offsets)
          : offsets(offsets) {}
        void visitMemoryInit(MemoryInit* curr) {
          // The desitination of the memory.init is either a constant
          // or the result of an addition with __memory_base in the
          // case of PIC code.
          auto* dest = curr->dest->dynCast<Const>();
          if (!dest) {
            auto* add = curr->dest->dynCast<Binary>();
            if (!add) {
              return;
            }
            dest = add->left->dynCast<Const>();
            if (!dest) {
              return;
            }
          }
          auto it = offsets.find(curr->segment);
          if (it != offsets.end()) {
            Fatal() << "Cannot get offset of passive segment initialized "
                       "multiple times";
          }
          offsets[curr->segment] = dest->value.getInteger();
        }
      } searcher(passiveOffsets);
      searcher.walkModule(&wasm);
    }
    for (unsigned i = 0; i < wasm.dataSegments.size(); ++i) {
      auto& segment = wasm.dataSegments[i];
      if (segment->isPassive) {
        auto it = passiveOffsets.find(segment->name);
        if (it != passiveOffsets.end()) {
          segmentOffsets.push_back(it->second);
        } else {
          // This was a non-constant offset (perhaps TLS)
          segmentOffsets.push_back(UNKNOWN_OFFSET);
        }
      } else if (auto* addrConst = segment->offset->dynCast<Const>()) {
        auto address = addrConst->value.getUnsigned();
        segmentOffsets.push_back(address);
      } else {
        // TODO(sbc): Wasm shared libraries have data segments with non-const
        // offset.
        segmentOffsets.push_back(0);
      }
    }
  }

  Module& wasm;
};

struct AsmConst {
  Address id;
  std::string code;
};

} // namespace wasm
