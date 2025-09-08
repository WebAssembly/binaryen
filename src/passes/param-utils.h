/*
 * Copyright 2022 WebAssembly Community Group participants
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

#ifndef wasm_pass_param_utils_h
#define wasm_pass_param_utils_h

#include "pass.h"
#include "support/sorted_vector.h"
#include "wasm.h"

// Helper code for passes that manipulate function parameters, specifically
// checking if they are used and removing them if so. This is closely tied to
// the internals of those passes, and so is not in /ir/ (it would be inside the
// pass .cpp file, but there is more than one).

namespace wasm::ParamUtils {

// Find which parameters are actually used in the function, that is, that the
// values arriving in the parameter are read. This ignores values set in the
// function, like this:
//
// function foo(x) {
//   x = 10;
//   bar(x); // read of a param index, but not the param value passed in.
// }
//
// This is an actual use:
//
// function foo(x) {
//   bar(x); // read of a param value
// }
std::unordered_set<Index> getUsedParams(Function* func, Module* module);

// The outcome of an attempt to remove a parameter(s).
enum RemovalOutcome {
  // We removed successfully.
  Success = 0,
  // We failed, but only because of fixable nested effects. The caller can move
  // those effects out (e.g. using ChildLocalizer, or the helper localizeCallsTo
  // below) and repeat.
  Failure = 1,
};

// Try to remove a parameter from a set of functions and replace it with a local
// instead. This may not succeed if the parameter type cannot be used in a
// local, or if we hit another limitation, in which case this returns false and
// does nothing. If we succeed then the parameter is removed both from the
// functions and from the calls to it, which are passed in (the caller must
// ensure to pass in all relevant calls and call_refs).
//
// This does not check if removing the parameter would change the semantics
// (say, if the parameter's value is used), which the caller is assumed to do.
//
// This assumes that the set of functions all have the same signature. The main
// use cases are either to send a single function, or to send a set of functions
// that all have the same heap type (and so if they all do not use some
// parameter, it can be removed from them all).
//
// This does *not* update the types in call_refs. It is assumed that the caller
// will be updating types, which is simpler as there may be other locations that
// need adjusting and it is easier to do it all in one place. Also, the caller
// can update all the types at once throughout the program after making
// multiple calls to removeParameter().
RemovalOutcome removeParameter(const std::vector<Function*>& funcs,
                               Index index,
                               const std::vector<Call*>& calls,
                               const std::vector<CallRef*>& callRefs,
                               Module* module,
                               PassRunner* runner);

// The same as removeParameter, but gets a sorted list of indexes. It tries to
// remove them all, and returns which we removed, as well as an indication as
// to whether we might remove more if effects were not in the way (specifically,
// we return Success if we removed any index, Failure if we removed none, and
// FailureDueToEffects if at least one index could have been removed but for
// effects).
std::pair<SortedVector, RemovalOutcome>
removeParameters(const std::vector<Function*>& funcs,
                 SortedVector indexes,
                 const std::vector<Call*>& calls,
                 const std::vector<CallRef*>& callRefs,
                 Module* module,
                 PassRunner* runner);

// Given a set of functions and the calls and call_refs that reach them, find
// which parameters are passed the same constant value in all the calls. For
// each such parameter, apply it inside the function, that is, do a local.set of
// that value in the function. The parameter's incoming value is then ignored,
// which allows other optimizations to remove it.
//
// Returns the indexes that were optimized.
SortedVector applyConstantValues(const std::vector<Function*>& funcs,
                                 const std::vector<Call*>& calls,
                                 const std::vector<CallRef*>& callRefs,
                                 Module* module);

// Helper that localizes all calls to a set of targets, in an entire module.
// This basically calls ChildLocalizer in each function, on the relevant calls.
// This is useful when we get FailureDueToEffects, see above.
//
// The set of targets can be function names (the individual functions we want to
// handle calls towards) or heap types (which will then include all functions
// with those types).
//
// The onChange() callback is called when we modify a function.
void localizeCallsTo(const std::unordered_set<Name>& callTargets,
                     Module& wasm,
                     PassRunner* runner,
                     std::function<void(Function*)> onChange);
void localizeCallsTo(const std::unordered_set<HeapType>& callTargets,
                     Module& wasm,
                     PassRunner* runner);

} // namespace wasm::ParamUtils

#endif // wasm_pass_param_utils_h
