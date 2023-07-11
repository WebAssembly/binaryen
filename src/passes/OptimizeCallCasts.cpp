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

    auto& options = getPassOptions();
    if (options.shrinkLevel || options.optimizeLevel < 3) {
      // We are not optimizing aggressively for speed, leave.
      return;
    }

    // First, find all the information we need. Start by collecting inside each
    // function in parallel.

    struct Info {
      // A map of param indexes to the types they are definitely cast to if the
      // function is entered.
      std::unordered_map<Index, Type> castParams;

      // If we end up optimizing a function, we'll create a refined copy of it
      // (see below), and place the name for it here. If this is null, then we
      // did not optimize.
      Name refinedName;
    };

    using InfoMap = ModuleUtils::ParallelFunctionAnalysis<Info>::Map;

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

          void visitRefCast(RefCast* curr) {
            if (!inEntry) {
              return;
            }
            if (auto* get = curr->value->dynCast<LocalGet>()) {
              if (curr->type != get->type &&
                  Type::isSubType(curr->type, get->type) &&
                  info.castParams.count(get->index) == 0) {
                info.castParams[get->index] = curr->type;
                // Note that if we see more than one cast we keep the first one.
                // This is not important in optimized code, as the most refined
                // cast would be the only one to exist there.
              }
            }
          }
        };

        Scanner scanner(info);
        scanner.walk(func);
      });

    // Optimize casts using all that we've found. First, create the refined
    // versions of functions where we found we could optimize.
    bool optimized = false;
    for (auto& [func, info] : analysis.map) {
      if (info.castParams.empty()) {
        continue;
      }

      // Great, we can optimize! Create a copy of the function to modify, which
      // allows other uses of the function (exports, ref.funcs) to not be
      // affected by what we do, which is to refine the parameter and remove
      // the cast in the function. That is, we go from
      //
      //   foo(x1);
      //   foo(x2);
      //   call_ref(x3, foo);
      //   function foo(x : X) {
      //     cast<Y>(x);
      //     [..]
      //
      // to
      //
      //   foo_refined(x1);               ;; These changes to use foo_refined.
      //   foo_refined(x2);
      //   call_ref(x3, foo);             ;; This is unchanged.
      //   function foo(x : X) {          ;; This function is unchanged.
      //     cast<Y>(x);
      //     [..]
      //   function foo_refined(y : Y) {  ;; This is the refined copy.
      //     [..]
      Name refinedName = Names::getValidFunctionName(*module, func->name);
      auto* copy = ModuleUtils::copyFunction(func, *module, refinedName);
      info.refinedName = refinedName;

      // Generate the refined param types and apply them.
      auto params = func->getParams();
      std::vector<Type> newParams;
      for (Index i = 0; i < params.size(); i++) {
        auto iter = info.castParams.find(i);
        if (iter != info.castParams.end()) {
          newParams.push_back(iter->second);
        } else {
          newParams.push_back(params[i]);
        }
      }
      TypeUpdating::updateParamTypes(func, newParams, *module);

      optimized = true;
    }

    if (!optimized) {
      return;
    }

    // We've created refined versions of the functions we found cast params in.
    // The last step is to optimize calls to the original functions to point to
    // the refined versions, and to add casts.
    //
    // Note that we don't remove the cast in each refined function. Since we
    // refined the parameter, other optimizations can trivially remove them
    // later (since those casts are from the same type to the same type, now).
    struct OptimizeCalls : public WalkerPass<PostWalker<OptimizeCalls>> {
      bool isFunctionParallel() override { return true; }

      const InfoMap& map;

      OptimizeCalls(const InfoMap& map) : map(map) {}

      std::unique_ptr<Pass> create() override {
        return std::make_unique<OptimizeCalls>(map);
      }

      void visitCall(Call* curr) {
        const auto& info = map[curr->target];

        if (info.refinedName.isNull()) {
          return;
        }

        // This is a call we want to optimize. First, switch it to the refined
        // target.
        curr->target = info.refinedName;

        // Next, add casts of the refined parameters. One thing we need to be
        // careful with is transfers of control flow, like this:
        //
        //  (call $foo
        //    (A)
        //    (br_if ..)
        //    (B)
        //  )
        //
        // If the br_if is taken then we never reach B or the call itself, in
        // which case it could be invalid to perform a cast (perhaps the br_if
        // is branching away because the call would trap on the cast). To handle
        // this, if there is a dangerous transfer of control flow then capture
        // all parameters into locals, and use local.gets on the call itself;
        // then adding a cost on one of those local.gets is always safe as the
        // potential control flow transfer happened before.
        bool transfers = false;
        for (auto* operand : curr->operands) {
          if (EffectAnalyzer(getPassOptions(), *getModule(), operand).transfersControlFlow()) {
            transfers = true;
          }
        }
        Builder builder(*getModule());
        if (transfers) {
          std::vector<Expression*> items;
          for (auto*& operand : curr->operands) {
            if (operand->type == Type::unreachable) {
              // We can't assign this value to a local, but it does not matter.
              items.push_back(operand);
              operand = builder.makeUnreachable();
            } else {
              auto local = builder.addVar(getFunction(), operand->type);
              items.push_back(builder.makeLocalSet(local, operand));
              operand = builder.makeLocalGet(local, operand->type);
            }
          }
        }

        for (Index i = 0; i < curr->operands.size(); i++) {
          auto iter = info.castParams.find(i);
          if (iter != info.castParams.end()) {
            auto castType = iter->second;
            curr->operands[i] = builder.makeRefCast(curr->operands[i], castType);
          }
        }
      }
      // Test a recursive call XXX
    };

    PassRunner nestedRunner(getPassRunner());
    runner.add(std::make_unique<OptimizeCalls>());
    runner.setIsNested(true);
    runner.run();
  }
};

} // anonymous namespace

Pass* createOptimizeCallCastsPass() { return new OptimizeCallCasts(); }

} // namespace wasm
