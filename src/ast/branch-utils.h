/*
 * Copyright 2017 WebAssembly Community Group participants
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

#ifndef wasm_ast_branch_h
#define wasm_ast_branch_h

#include "wasm.h"

namespace wasm {

namespace BranchUtils {

// branches not actually taken (e.g. (br $out (unreachable)))
// are trivially ignored in our type system

inline bool isBranchTaken(Break* br) {
  return !(br->value     && br->value->type     == unreachable) &&
         !(br->condition && br->condition->type == unreachable);
}

inline bool isBranchTaken(Switch* sw) {
  return !(sw->value && sw->value->type     == unreachable) &&
                        sw->condition->type != unreachable;
}

} // namespace BranchUtils

} // namespace wasm

#endif // wasm_ast_branch_h

