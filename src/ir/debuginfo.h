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

#ifndef wasm_ir_debuginfo_h
#define wasm_ir_debuginfo_h

#include "wasm.h"

namespace wasm::debuginfo {

// Given an original expression and another that replaces it, copy the debuginfo
// from the former to the latter. Note the expression may not be an exclusive
// replacement of the other (the other may be replaced by several expressions,
// all of whom may end up with the same debug info).
inline void copyOriginalToReplacement(Expression* original,
                                      Expression* replacement,
                                      Function* func) {
  auto& debugLocations = func->debugLocations;
  // Early exit if there is no debug info at all. Also, leave if we already
  // have debug info on the new replacement, which we don't want to trample:
  // if there is no debug info we do want to copy, as a replacement operation
  // suggests the new code plays the same role (it is an optimized version of
  // the old), but if the code is already annotated, trust that.
  if (debugLocations.empty() || debugLocations.count(replacement)) {
    return;
  }

  auto iter = debugLocations.find(original);
  if (iter != debugLocations.end()) {
    debugLocations[replacement] = iter->second;
    // Note that we do *not* erase the debug info of the expression being
    // replaced, because it may still exist: we might replace
    //
    //  (call
    //    (block ..
    //
    // with
    //
    //  (block
    //    (call ..
    //
    // We still want the call here to have its old debug info.
    //
    // (In most cases, of course, we do remove the replaced expression,
    // which means we accumulate unused garbage in debugLocations, but
    // that's not that bad; we use arena allocation for Expressions, after
    // all.)
  }
}

// Given an expression and a copy of it in another function, copy the debug
// info into the second function.
void copyBetweenFunctions(Expression* origin,
                          Expression* copy,
                          Function* originFunc,
                          Function* copyFunc);
} // namespace wasm::debuginfo

#endif // wasm_ir_debuginfo_h
