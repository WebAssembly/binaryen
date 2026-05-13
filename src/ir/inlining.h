/*
 * Copyright 2026 WebAssembly Community Group participants
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

#ifndef wasm_ir_inlining_h
#define wasm_ir_inlining_h

#include "wasm.h"

namespace wasm::Inlining {

struct InliningAction {
  // The call to inline into.
  Expression** callSite;

  // The contents to be inlined.
  Function* contents;

  // Whether the call is inside a try-catch, which makes things like
  // return_calls more complicated.
  bool insideATry;

  // An optional name hint can be provided, which will then be used in the name
  // of the block we put the inlined code in. Using a unique name hint in each
  // inlining can reduce the risk of name overlaps (which cause fixup work in
  // UniqueNameMapper::uniquify).
  Index nameHint = 0;

  InliningAction(Expression** callSite,
                 Function* contents,
                 bool insideATry,
                 Index nameHint = 0)
    : callSite(callSite), contents(contents), insideATry(insideATry),
      nameHint(nameHint) {}
};

// Inline into a function.
void doInlining(Module* module,
                Function* into,
                const InliningAction& action,
                PassOptions& options);

} // namespace wasm::Inlining

#endif // wasm_ir_inlining_h
