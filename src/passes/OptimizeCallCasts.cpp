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

//
// Given a function and all the calls to it, see if there are arguments that
// are always immediately cast to a subtype. If so, then we can move the cast
// to the callers, like this:
//
//   foo(x1);
//   foo(x2);
//   function foo(x : X) {
//     cast<Y>(x); // immediately cast the input X to a subtype Y
//
// This pattern is common in object-oriented code from Java and Kotlin etc.,
// where an itable method implementation will cast the input type to the
// proper type for the class.
//
// This may increase code size (but it does not add more work at runtime) so
// whether we do this depends on the opt/shrink levels.
//
// Returns whether we optimized.
//
// TODO: Add similar code in OptimizeCallCasts as well, for entire type sets.
//

#include "ir/module-utils.h"
#include "pass.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

namespace {

struct OptimizeCallCasts : public Pass {
  // Only changes heap types and parameter types (but not locals).
  // XXX
  bool requiresNonNullableLocalFixups() override { return false; }

  // Maps each heap type to the possible refinement of the types in their
  // signatures. We will fill this during analysis and then use it while doing
  // an update of the types. If a type has no improvement that we can find, it
  // will not appear in this map.
  std::unordered_map<HeapType, Signature> newSignatures;

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      return;
    }

    // First, find all the information we need. Start by collecting inside each
    // function in parallel.

    struct Info {
      // The calls.
      std::vector<Call*> calls;

      // A map of param indexes to the types they are definitely cast to if the
      // function is entered.
      std::unordered_map<Index, Type> castParams;
    };

    ModuleUtils::ParallelFunctionAnalysis<Info> analysis(
      *module, [&](Function* func, Info& info) {
        if (func->imported()) {
          return;
        }

        struct Scanner : public LinearExecutionWalker<Scanner> {
          Info& info;

          Scanner(Info& info) : info(info) {}

          // We start in the entry block. TODO: Scan further, noting dominance
          // etc.
          bool inEntry = true;

          static void doNoteNonLinear(SubType* self, Expression** currp) {
            // This is the end of the first basic block.
            inEntry = false;
          }

          void visitCall(Call* curr) {
            info.calls.push_back(curr);
          }

          void visitRefCast(RefCast* curr) {
            if (!inEntry) {
              return;
            }
            if (auto* get = curr->value->dynCast<LocalGet>()) {
              if (curr->type != get->type &&
                  Type::isSubType(curr->type, get->type)) {
                info.castParams[get->index] = curr->type;
                // Note that if we see more than one cast we keep the last one. This
                // is not important in optimized code, as the most refined cast
                // would be the only one to exist there.
              }
            }
          }
        };

        Scanner scanner(info);
        scanner.walk(func);
      });

    // Find all the calls going to each function.
    std::unordered_map<Name, std::vector<Call*>> funcCalls;

    for (auto& [func, info] : analysis.map) {
      for (auto* call : info.calls) {
        funcCalls[call->target].push_back(call);
      }
    }

    // Optimize casts using all that we've found.
    for (auto& [func, info] : analysis.map) {
      
      for (auto& [index, type] : info.castParams) {
      }
    }


    // TODO: we could do this only in relevant functions perhaps
    // XXX?
    ReFinalize().run(getPassRunner(), module);
  }
};

} // anonymous namespace

Pass* createOptimizeCallCastsPass() { return new OptimizeCallCasts(); }

} // namespace wasm
