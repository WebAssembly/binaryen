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
// such types we can replace a struct.get with a global.get when there is a
// single possible global, or if there are two then with this pattern:
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
// is created in two immutable globals $global1 and $global2, the field is
// immutable, the values of field |i| in them are value1 and value2
// respectively, and $foo has no subtypes. In that situation, the reference must
// be one of those two, so we can compare the reference to the globals and pick
// the right value there. (We can also handle subtypes, if we look at their
// values as well, see below.)
//
// The benefit of this optimization is primarily in the case of constant values
// that we can heavily optimize, like function references (constant function
// refs let us inline, etc.). Function references cannot be directly compared,
// so we cannot use ConstantFieldPropagation or such with an extension to
// multiple values, as the select pattern shown above can't be used - it needs a
// comparison. But we can compare structs, so if the function references are in
// vtables, and the vtables follow the above pattern, then we can optimize.
//
// TODO: Only do the case with a select when shrinkLevel == 0?
//

#include "ir/find_all.h"
#include "ir/module-utils.h"
#include "ir/possible-constant.h"
#include "ir/subtypes.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

struct GlobalStructInference : public Pass {
  // Only modifies struct.get operations.
  bool requiresNonNullableLocalFixups() override { return false; }

  // Maps optimizable struct types to the globals whose init is a struct.new of
  // them.
  //
  // We will remove unoptimizable types from here, so in practice, if a type is
  // optimizable it will have an entry here, and not if not.
  std::unordered_map<HeapType, std::vector<Name>> typeGlobals;

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      return;
    }

    if (!getPassOptions().closedWorld) {
      Fatal() << "GSI requires --closed-world";
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

      // The global's declared type must match the init's type. If not, say if
      // we had a global declared as type |any| but that contains (ref $A), then
      // that is not something we can optimize, as ref.eq on a global.get of
      // that global will not validate. (This should not be a problem after
      // GlobalSubtyping runs, which will specialize the type of the global.)
      if (global->type != global->init->type) {
        unoptimizable.insert(type);
        continue;
      }

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
    // Iterate on a copy to avoid invalidation as we insert.
    auto unoptimizableCopy = unoptimizable;
    for (auto type : unoptimizableCopy) {
      while (1) {
        unoptimizable.insert(type);

        // Also erase the globals, as we will never read them anyhow. This can
        // allow us to skip unneeded work, when we check if typeGlobals is
        // empty, below.
        typeGlobals.erase(type);

        auto super = type.getDeclaredSuperType();
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
        auto super = curr.getDeclaredSuperType();
        if (!super) {
          break;
        }
        curr = *super;

        // As above, avoid adding pointless data for anything unoptimizable.
        if (!unoptimizable.count(curr)) {
          for (auto global : globals) {
            typeGlobals[curr].push_back(global);
          }
        }
      }
    }

    if (typeGlobals.empty()) {
      // We found nothing we can optimize.
      return;
    }

    // The above loop on typeGlobalsCopy is on an unsorted data structure, and
    // that can lead to nondeterminism in typeGlobals. Sort the vectors there to
    // ensure determinism.
    for (auto& [type, globals] : typeGlobals) {
      std::sort(globals.begin(), globals.end());
    }

    // We are looking for the case where we can pick between two values
    // using a single comparison. More than two values, or more than a
    // single comparison, add tradeoffs that may not be worth it, and a
    // single value (or no value) is already handled by other passes.
    //
    // That situation may involve more than two globals. For example we may
    // have three relevant globals, but two may have the same value. In that
    // case we can compare against the third:
    //
    //  $global0: (struct.new $Type (i32.const 42))
    //  $global1: (struct.new $Type (i32.const 42))
    //  $global2: (struct.new $Type (i32.const 1337))
    //
    // (struct.get $Type (ref))
    //   =>
    // (select
    //   (i32.const 1337)
    //   (i32.const 42)
    //   (ref.eq (ref) $global2))

    // First, find the values that would be read, and the globals
    // corresponding to them. If the values are constant then we can "group"
    // them together: imagine we have 3 globals, but two would read the
    // constant 42, then we just need a single check against the other
    // global in order to know which value is read (either 42, or the value
    // of the other global).
    struct Value {
      // The pointer to the expression. This is nullptr for
      // struct.new_default (in which case |constant| below would be a zero
      // literal for the proper type). We must track Expression** here as we
      // may need to modify it later: consider if the global we read from is
      //
      //  (global $g (struct.new $S
      //    (struct.new $T ..)
      //
      // We have a nested struct.new here. That is not a constant value, but
      // we can turn it into a global.get:
      //
      //  (global $g.nested (struct.new $T ..)
      //  (global $g (struct.new $S
      //    (global.get $g.nested)
      //
      // This un-nesting adds globals and may increase code size slightly,
      // but if it lets us infer constant values that may lead to
      // devirtualization and other large benefits. Later passes can also
      // re-nest.
      //
      // As mentioned before we can group constants, but if we un-nest like
      // this then there is no constant value, and each such Value ends up
      // in its own group.
      Expression** ptr;
      // The possible constant value represented there.
      PossibleConstantValues constant;
      // The globals that have this Value.
      // TODO: SmallVector?
      std::vector<Name> globals;
    };

    // Optimize based on the above. Define a walker that finds the places to
    // optimize, which we will run in parallel later. The walker will only find
    // the work we need to do, and leave the actual work for a non-parallel
    // phase after, as that work may involve global changes.
    struct WorkItem {
      // The pointer to the struct.get we want to optimize/replace.
      Expression** structGetPtr;
      // Information about the possible values being read here.
      std::vector<Value> values;
    };
    using Work = std::vector<WorkItem>;

    struct FunctionOptimizer : PostWalker<FunctionOptimizer> {
    private:
      GlobalStructInference& parent;
      Work& work;

    public:
      FunctionOptimizer(GlobalStructInference& parent, Work& work) : parent(parent), work(work) {}

      bool refinalize = false;

      void visitStructGet(StructGet* curr) {
        auto type = curr->ref->type;
        if (type == Type::unreachable) {
          return;
        }

        // We must ignore the case of a non-struct heap type, that is, a bottom
        // type (which is all that is left after we've already ruled out
        // unreachable). Such things will not be in typeGlobals, which we are
        // checking now anyhow.
        auto heapType = type.getHeapType();
        auto iter = parent.typeGlobals.find(heapType);
        if (iter == parent.typeGlobals.end()) {
          return;
        }

        // This cannot be a bottom type as we found it in the typeGlobals map,
        // which only contains types of struct.news.
        assert(heapType.isStruct());

        // The field must be immutable.
        auto fieldIndex = curr->index;
        auto& field = heapType.getStruct().fields[fieldIndex];
        if (field.mutable_ == Mutable) {
          return;
        }

        const auto& globals = iter->second;
        if (globals.size() == 0) {
          return;
        }

        auto& wasm = *getModule();
        Builder builder(wasm);

        if (globals.size() == 1) {
          // Leave it to other passes to infer the constant value of the field,
          // if there is one: just change the reference to the global, which
          // will unlock those other optimizations. Note we must trap if the ref
          // is null, so add RefAsNonNull here.
          auto global = globals[0];
          auto globalType = wasm.getGlobal(global)->type;
          if (globalType != curr->ref->type) {
            // The struct.get will now read from something of the type of the
            // global, which is different, so the field being read might be
            // refined, which could change the struct.get's type.
            refinalize = true;
          }
          curr->ref = builder.makeSequence(
            builder.makeDrop(builder.makeRefAs(RefAsNonNull, curr->ref)),
            builder.makeGlobalGet(global, globalType));
          return;
        }

        // TODO: SmallVector?
        std::vector<Value> values;

        // Scan the relevant struct.new operands.
        auto fieldType = field.type;
        for (Index i = 0; i < globals.size(); i++) {
          Name global = globals[i];
          auto* structNew = wasm.getGlobal(global)->init->cast<StructNew>();
          // The value that is read from this struct.new.
          Value value;

          // Find the value read from the struct and represent it as a Value.
          PossibleConstantValues constant;
          if (structNew->isWithDefault()) {
            value.ptr = nullptr;
            value.constant.note(Literal::makeZero(fieldType));
          } else {
            value.ptr = &structNew->operands[fieldIndex];
            value.constant.note(*value);
          }

          // If the value is constant, it may be grouped as mentioned before.
          // See if it matches anything we've seen before.
          bool grouped = false;
          if (value.constant.isConstant()) {
            for (auto& oldValue : values) {
              if (value.constant == oldValue.constant) {
                // Add us to this group.
                oldValue.globals.push_back(global);
                grouped = true;
                break;
              }
            }
          }
          if (!grouped) {
            // This is a new value, so create a new group, unless we've seen too
            // many unique values.
            if (values.size() == 2) {
              // Adding this value would mean we have too many, so give up.
              return;
            }
            value.globals.push_back(global);
            values.push_back(value);
          }
        }

        // We have some globals (at least 2), and so must have at least one
        // value. And we have already exited if we have more than 2 values (see
        // the early return above) so that only leaves 1 and 2. The case of one
        // value can always be optimized (just read the one possible value), but
        // with two we need to be more careful.
        auto numValues = values.size();
        assert(numValues == 1 || numValues == 2);
        if (numValues == 2 && values[0].globals.size() > 1 &&
            values[1].globals.size() > 1) {
          // Both values have more than one global, so we'd need more than one
          // comparison. That is, we cannot just check if we are reading from
          // global1 or global2. Give up.
          return;
        }

        // We ruled out all the problems, and can optimize! Stash the work for
        // later.
        work.emplace_back({getCurrentPointer(), std::move(values)});
      }

      void visitFunction(Function* func) {
        if (refinalize) {
          ReFinalize().walkFunctionInModule(func, getModule());
        }
      }
    };

    // Find the optimization opportunitites in parallel.
    ModuleUtils::ParallelFunctionAnalysis<Work> optimization(
      *module, [&](Function* func, Work& work) {
        if (func->imported()) {
          return;
        }

        FunctionOptimizer optimizer(*this, work);
        optimizer.walkFunction(func);
      });

    // Optimize the opportunities we found. Use the deterministic order of the
    // functions in the module.
    for (auto& func : module->functions) {
      auto& work = optimization.map[func.get()];
      for (auto& [structGetPtr, values] : work) {
XXX
        if (values.size() == 1) {
          // The case of 1 value is simple: trap if the ref is null, and
          // otherwise return the value.
          replaceCurrent(builder.makeSequence(
            builder.makeDrop(builder.makeRefAs(RefAsNonNull, curr->ref)),
            values[0].makeExpression(wasm)));
          return;
        }
        assert(values.size() == 2);

        // We have two values. Check that we can pick between them using a
        // single comparison. While doing so, ensure that the index we can check
        // on is 0, that is, the first value has a single global.
        if (globalsForValue[0].size() == 1) {
          // The checked global is already in index 0.
        } else if (globalsForValue[1].size() == 1) {
          std::swap(values[0], values[1]);
          std::swap(globalsForValue[0], globalsForValue[1]);
        } else {
abort();
          // Both indexes have more than one option, so we'd need more than one
          // comparison. Give up.
          return;
        }

        // Excellent, we can optimize here! Emit a select.
        //
        // Note that we must trap on null, so add a ref.as_non_null here.
        auto checkGlobal = globalsForValue[0][0];
        replaceCurrent(builder.makeSelect(
          builder.makeRefEq(builder.makeRefAs(RefAsNonNull, curr->ref),
                            builder.makeGlobalGet(
                              checkGlobal, wasm.getGlobal(checkGlobal)->type)),
          values[0].makeExpression(wasm),
          values[1].makeExpression(wasm)));

  }
};

} // anonymous namespace

Pass* createGlobalStructInferencePass() { return new GlobalStructInference(); }

} // namespace wasm
