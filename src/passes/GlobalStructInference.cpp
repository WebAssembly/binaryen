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

//
// Finds types which are only created in assignments to immutable globals. For
// such types we can replace a struct.get with this pattern:
//
//  (struct.get $foo i
//    (..ref..))
//  =>
//  (select
//    (value1)
//    (value2)
//    (ref.eq
//      (..ref..)
//      (global.get $global1)))
//
// That is a valid transformation if there are only two struct.news of $foo, it
// is created in two immutable globals $global1 and $global2, and the values of
// field |i| in them are value1 and value2 respectively (and there are no
// subtypes). In that situation, the reference must be one of those two, so we
// can compare the reference to the globals and pick the right value there.
//
// The benefit of this optimization is primarily in the case of constant values
// that we can heavily optimize, like function references (constant function
// refs let us inline, etc.). Function references cannot be directly compared,
// so we cannot use ConstantFieldPropagation or such with an extension to
// multiple values, as the select pattern shown above can't be used - it needs a
// comparison. But we can compare structs, so if the function references are in
// vtables, and the vtables follow the above pattern, then we can optimize.
//

#include "ir/find_all.h"
#include "ir/module-utils.h"
#include "ir/subtypes.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

struct GlobalStructInference : public Pass {
  // Maps optimizable struct types to the globals whose init is a struct.new of
  // them. If a global is not present here, it cannot be optimized.
  std::unordered_map<HeapType, std::vector<Name>> typeGlobals;

  void run(PassRunner* runner, Module* module) override {
    if (getTypeSystem() != TypeSystem::Nominal) {
      Fatal() << "GlobalStructInference requires nominal typing";
    }

    // First, find all the information we need. We need to know which struct
    // types are created in functions, because we will not be able to optimize
    // those.

    using HeapTypes = std::unordered_set<HeapType>;

    ModuleUtils::ParallelFunctionAnalysis<HeapTypes> analysis(
      *module, [&](Function* func, HeapTypes& types) {
        if (func->imported()) {
          return;
        }

        for (auto* structNew : FindAll<StructNew>(func->body).list) {
          auto type = structNew->type;
          if (type.isRef()) {
            types.insert(type.getHeapType());
          }
        }
      });

    // We cannot optimize types that appear in a struct.new in a function, which
    // we just collected and merge now.
    HeapTypes unoptimizable;

    for (auto& [func, types] : analysis.map) {
      for (auto type : types) {
        unoptimizable.insert(type);
      }
    }

    // Process the globals.
    for (auto& global : module->globals) {
      if (global->imported()) {
        continue;
      }

      // We cannot optimize a type that appears in a non-toplevel location in a
      // global init.
      for (auto* structNew : FindAll<StructNew>(global->init).list) {
        auto type = structNew->type;
        if (type.isRef() && structNew != global->init) {
          unoptimizable.insert(type.getHeapType());
        }
      }

      if (!global->init->type.isRef()) {
        continue;
      }

      auto type = global->init->type.getHeapType();

      // We cannot optimize mutable globals.
      if (global->mutable_) {
        unoptimizable.insert(type);
        continue;
      }

      // Finally, if this is a struct.new then it is one we can optimize; note
      // it.
      if (global->init->is<StructNew>()) {
        typeGlobals[type].push_back(global->name);
      }
    }

    // A struct.get might also read from any of the subtypes. As a result, an
    // unoptimizable type makes all its supertypes unoptimizable as well.
    // TODO: this could be specific per field (and not all supers have all
    //       fields)
    auto unoptimizableCopy = unoptimizable;
    for (auto type : unoptimizableCopy) {
      while (1) {
        typeGlobals.erase(type);
        auto super = type.getSuperType();
        if (!super) {
          break;
        }
        type = *super;
      }
    }

    // Similarly, propagate global names: if one type has [global1], then a get
    // of any supertype might access that, so propagate to them.
    auto typeGlobalsCopy = typeGlobals;
    for (auto& [type, globals] : typeGlobalsCopy) {
      auto curr = type;
      while (1) {
        auto super = curr.getSuperType();
        if (!super) {
          break;
        }
        curr = *super;
        for (auto global : globals) {
          typeGlobals[curr].push_back(global);
        }
      }
    }

    if (typeGlobals.empty()) {
      // We found nothing we can optimize.
      return;
    }

    // Optimize based on the above.
    struct FunctionOptimizer
      : public WalkerPass<PostWalker<FunctionOptimizer>> {
      bool isFunctionParallel() override { return true; }

      Pass* create() override { return new FunctionOptimizer(parent); }

      FunctionOptimizer(GlobalStructInference& parent) : parent(parent) {}

      void visitStructGet(StructGet* curr) {
        auto type = curr->ref->type;
        if (type == Type::unreachable) {
          return;
        }

        auto iter = parent.typeGlobals.find(type.getHeapType());
        if (iter == parent.typeGlobals.end()) {
          return;
        }

        auto& globals = iter->second;

        // TODO: more sizes
        if (globals.size() != 2) {
          return;
        }

        // Check if the relevant fields contain constants.
        auto& wasm = *getModule();
        auto field = curr->index;
        auto fieldType = type.getHeapType().getStruct().fields[field].type;
        std::vector<Literal> values;
        for (Index i = 0; i < globals.size(); i++) {
          auto* structNew = wasm.getGlobal(globals[i])->init->cast<StructNew>();
          if (structNew->isWithDefault()) {
            values.push_back(Literal::makeNull(fieldType));
          } else {
            auto* init = structNew->operands[field];
            if (!Properties::isConstantExpression(init)) {
              // Non-constant; give up entirely.
              return;
            }
            values.push_back(Properties::getLiteral(init));
          }
        }

        // Excellent, we can optimize here! Emit a select.
        //
        // Note that we must trap on null, so add a ref.as_non_null here.
        Builder builder(wasm);
        replaceCurrent(builder.makeSelect(
          builder.makeRefEq(builder.makeRefAs(RefAsNonNull, curr->ref),
                            builder.makeGlobalGet(
                              globals[0], wasm.getGlobal(globals[0])->type)),
          builder.makeConstantExpression(values[0]),
          builder.makeConstantExpression(values[1])));
      }

    private:
      GlobalStructInference& parent;
    };

    FunctionOptimizer(*this).run(runner, module);
  }
};

} // anonymous namespace

Pass* createGlobalStructInferencePass() { return new GlobalStructInference(); }

} // namespace wasm
