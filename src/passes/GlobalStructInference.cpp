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

#include <variant>

#include "ir/debuginfo.h"
#include "ir/find_all.h"
#include "ir/module-utils.h"
#include "ir/names.h"
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

    // We are looking for the case where we can pick between two values using a
    // single comparison. More than two values, or more than a single
    // comparison, lead to tradeoffs that may not be worth it.
    //
    // Note that situation may involve more than two globals. For example we may
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
    //
    // To discover these situations, we compute and group the possible values
    // that can be read from a particular struct.get, using the following data
    // structure.
    struct Value {
      // A value is either a constant, or if not, then we point to whatever
      // expression it is.
      std::variant<PossibleConstantValues, Expression*> content;
      // The list of globals that have this Value. In the example from above,
      // the Value for 42 would list globals = [$global0, $global1].
      // TODO: SmallVector?
      std::vector<Name> globals;

      bool isConstant() const {
        return std::get_if<PossibleConstantValues>(&content);
      }

      const PossibleConstantValues& getConstant() const {
        assert(isConstant());
        return std::get<PossibleConstantValues>(content);
      }

      Expression* getExpression() const {
        assert(!isConstant());
        return std::get<Expression*>(content);
      }
    };

    // Constant expressions are easy to handle, and we can emit a select as in
    // the last example. But we can handle non-constant ones too, by un-nesting
    // the relevant global. Imagine we have this:
    //
    //  (global $g (struct.new $S
    //    (struct.new $T ..)
    //
    // We have a nested struct.new here. That is not a constant value, but we
    // can turn it into a global.get:
    //
    //  (global $g.nested (struct.new $T ..)
    //  (global $g (struct.new $S
    //    (global.get $g.nested)
    //
    // After this un-nesting we end up with a global.get of an immutable global,
    // which is constant. Note that this adds a global and may increase code
    // size slightly, but if it lets us infer constant values that may lead to
    // devirtualization and other large benefits. Later passes can also re-nest.
    //
    // We do most of our optimization work in parallel, but we cannot add
    // globals in parallel, so instead we note the places we need to un-nest in
    // this data structure and process them at the end.
    struct GlobalToUnnest {
      // The global we want to refer to a nested part of, by un-nesting it. The
      // global contains a struct.new, and we want to refer to one of the
      // operands of the struct.new directly, which we can do by moving it out
      // to its own new global.
      Name global;
      // The index of the struct.new in the global named |global|.
      Index index;
      // The global.get that should refer to the new global. At the end, after
      // we create a new global and have a name for it, we update this get to
      // point to it.
      GlobalGet* get;
    };
    using GlobalsToUnnest = std::vector<GlobalToUnnest>;

    struct FunctionOptimizer : PostWalker<FunctionOptimizer> {
    private:
      GlobalStructInference& parent;
      GlobalsToUnnest& globalsToUnnest;

    public:
      FunctionOptimizer(GlobalStructInference& parent,
                        GlobalsToUnnest& globalsToUnnest)
        : parent(parent), globalsToUnnest(globalsToUnnest) {}

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
            constant.note(Literal::makeZero(fieldType));
            value.content = constant;
          } else {
            Expression* operand = structNew->operands[fieldIndex];
            constant.note(operand, wasm);
            if (constant.isConstant()) {
              value.content = constant;
            } else {
              value.content = operand;
            }
          }

          // If the value is constant, it may be grouped as mentioned before.
          // See if it matches anything we've seen before.
          bool grouped = false;
          if (value.isConstant()) {
            for (auto& oldValue : values) {
              if (oldValue.isConstant() &&
                  oldValue.getConstant() == value.getConstant()) {
                // Add us to this group.
                oldValue.globals.push_back(global);
                grouped = true;
                break;
              }
            }
          }
          if (!grouped) {
            // This is a new value, so create a new group, unless we've seen too
            // many unique values. In that case, give up.
            if (values.size() == 2) {
              return;
            }
            value.globals.push_back(global);
            values.push_back(value);
          }
        }

        // Helper for optimization: Given a Value, returns what we should read
        // for it.
        auto getReadValue = [&](const Value& value) -> Expression* {
          Expression* ret;
          if (value.isConstant()) {
            // This is known to be a constant, so simply emit an expression for
            // that constant.
            ret = value.getConstant().makeExpression(wasm);
          } else {
            // Otherwise, this is non-constant, so we are in the situation where
            // we want to un-nest the value out of the struct.new it is in. Note
            // that for later work, as we cannot add a global in parallel.

            // There can only be one global in a value that is not constant,
            // which is the global we want to read from.
            assert(value.globals.size() == 1);

            // Create a global.get with temporary name, leaving only the
            // updating of the name to later work.
            auto* get = builder.makeGlobalGet(value.globals[0],
                                              value.getExpression()->type);

            globalsToUnnest.emplace_back(
              GlobalToUnnest{value.globals[0], fieldIndex, get});

            ret = get;
          }

          // This value replaces the struct.get, so it should have the same
          // source location.
          debuginfo::copyOriginalToReplacement(curr, ret, getFunction());

          return ret;
        };

        // We have some globals (at least 2), and so must have at least one
        // value. And we have already exited if we have more than 2 values (see
        // the early return above) so that only leaves 1 and 2.
        if (values.size() == 1) {
          // The case of 1 value is simple: trap if the ref is null, and
          // otherwise return the value.
          replaceCurrent(builder.makeSequence(
            builder.makeDrop(builder.makeRefAs(RefAsNonNull, curr->ref)),
            getReadValue(values[0])));
          return;
        }
        assert(values.size() == 2);

        // We have two values. Check that we can pick between them using a
        // single comparison. While doing so, ensure that the index we can check
        // on is 0, that is, the first value has a single global.
        if (values[0].globals.size() == 1) {
          // The checked global is already in index 0.
        } else if (values[1].globals.size() == 1) {
          // Flip so the value to check is in index 0.
          std::swap(values[0], values[1]);
        } else {
          // Both indexes have more than one option, so we'd need more than one
          // comparison. Give up.
          return;
        }

        // Excellent, we can optimize here! Emit a select.

        auto checkGlobal = values[0].globals[0];
        // Compute the left and right values before the next line, as the order
        // of their execution matters (they may note globals for un-nesting).
        auto* left = getReadValue(values[0]);
        auto* right = getReadValue(values[1]);
        // Note that we must trap on null, so add a ref.as_non_null here.
        replaceCurrent(builder.makeSelect(
          builder.makeRefEq(builder.makeRefAs(RefAsNonNull, curr->ref),
                            builder.makeGlobalGet(
                              checkGlobal, wasm.getGlobal(checkGlobal)->type)),
          left,
          right));
      }

      void visitFunction(Function* func) {
        if (refinalize) {
          ReFinalize().walkFunctionInModule(func, getModule());
        }
      }
    };

    // Find the optimization opportunitites in parallel.
    ModuleUtils::ParallelFunctionAnalysis<GlobalsToUnnest> optimization(
      *module, [&](Function* func, GlobalsToUnnest& globalsToUnnest) {
        if (func->imported()) {
          return;
        }

        FunctionOptimizer optimizer(*this, globalsToUnnest);
        optimizer.walkFunctionInModule(func, module);
      });

    // Un-nest any globals as needed, using the deterministic order of the
    // functions in the module.
    Builder builder(*module);
    auto addedGlobals = false;
    for (auto& func : module->functions) {
      // Each work item here is a global with a struct.new, from which we want
      // to read a particular index, from a particular global.get.
      for (auto& [globalName, index, get] : optimization.map[func.get()]) {
        auto* global = module->getGlobal(globalName);
        auto* structNew = global->init->cast<StructNew>();
        assert(index < structNew->operands.size());
        auto*& operand = structNew->operands[index];

        // If we already un-nested this then we don't need to repeat that work.
        if (auto* nestedGet = operand->dynCast<GlobalGet>()) {
          // We already un-nested, and this global.get refers to the new global.
          // Simply copy the target.
          get->name = nestedGet->name;
          assert(get->type == nestedGet->type);
        } else {
          // Add a new global, initialized to the operand.
          auto newName = Names::getValidGlobalName(
            *module,
            global->name.toString() + ".unnested." + std::to_string(index));
          module->addGlobal(builder.makeGlobal(
            newName, get->type, operand, Builder::Immutable));
          // Replace the operand with a get of that new global, and update the
          // original get to read the same.
          operand = builder.makeGlobalGet(newName, get->type);
          get->name = newName;
          addedGlobals = true;
        }
      }
    }

    if (addedGlobals) {
      // Sort the globals so that added ones appear before their uses.
      PassRunner runner(module);
      runner.add("reorder-globals-always");
      runner.setIsNested(true);
      runner.run();
    }
  }
};

} // anonymous namespace

Pass* createGlobalStructInferencePass() { return new GlobalStructInference(); }

} // namespace wasm
