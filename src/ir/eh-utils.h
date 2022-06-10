/*
 * Copyright 2021 WebAssembly Community Group participants
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

#ifndef wasm_ir_eh_h
#define wasm_ir_eh_h

#include "support/small_vector.h"
#include "wasm.h"

namespace wasm {

namespace EHUtils {

// Returns true if a 'pop' instruction exists in a valid location, which means
// right after a 'catch' instruction in binary writing order.
// - This assumes there should be at least a single pop. So given a catch body
//   whose tag type is void or a catch_all's body, this returns false.
// - This returns true even if there are more pops after the first one within a
//   catch body, which is invalid. That will be taken care of in validation.
bool containsValidDanglingPop(Expression* catchBody);

// Given a 'Try' expression, fixes up 'pop's nested in blocks, which are
// currently not supported without block param types, by creating a new local,
// putting a (local.set $new (pop type)) right after 'catch', and putting a
// '(local.get $new)' where the 'pop' used to be.
void handleBlockNestedPop(Try* try_, Function* func, Module& wasm);

// Calls handleBlockNestedPop for each 'Try's in a given function.
void handleBlockNestedPops(Function* func, Module& wasm);

// Given a catch body, find the pop corresponding to the catch. There might be
// pops nested inside a try inside this catch, and we must ignore them, like
// here:
//
//  (catch
//    (pop) ;; we want this for the outer catch
//    (try
//      (catch
//        (pop) ;; but we do not want this for the outer catch
//
// If there is no pop, which can happen if the tag has no params, then nullptr
// is returned.
Pop* findPop(Expression* expr);

// Like findPop(), but it does *not* assume that the module validates. A catch
// might therefore have any number of pops. This function is primarily useful in
// the validator - normally you should call findPop(), above.
SmallVector<Pop*, 1> findPops(Expression* expr);

} // namespace EHUtils

} // namespace wasm

#endif // wasm_ir_eh_h
