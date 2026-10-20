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
// GlobalStructInference: Analyze struct usage globally, in particular, structs
// created (perhaps only) in globals.
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
// This also optimizes some related things - reads from structs created in
// globals - that benefit from the infrastructure here (see unnesting, below),
// even without this type-based approach, and even in open world.
//
// TODO: Only do the case with a select when shrinkLevel == 0?
//

#include <variant>

#include "ir/bits.h"
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

static const Index DescriptorIndex = -1;

struct GlobalStructInference : public Pass {
  // Only modifies struct.get operations.
  bool requiresNonNullableLocalFixups() override { return false; }

  GlobalStructInference(bool optimizeToDescCasts)
    : optimizeToDescCasts(optimizeToDescCasts) {}

  // Maps struct types that have at least one top-level immutable eqref
  // struct.new global (in themselves or a subtype) to those globals and any
  // other struct.news of the type (or a subtype) in the module.
  //
  // This is filled in when in closed world. In open world, we cannot do such
  // type-based inference, and this remains empty.
  struct TypeInfo {
    std::vector<Name> globals;
    std::vector<StructNew*> otherStructNews;
  };
  std::unordered_map<HeapType, TypeInfo> typeInfos;

  // Whether to optimize ref.cast to ref.cast_desc_eq. This increases code size,
  // so it may not always be beneficial (perhaps running it late in the
  // pipeline, and before type-merging, could make sense).
  bool optimizeToDescCasts;

  std::unique_ptr<SubTypes> subTypes;

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      return;
    }

    if (optimizeToDescCasts) {
      // We need subtypes to know when to optimize to a desc cast.
      subTypes = std::make_unique<SubTypes>(*module);
    }

    if (getPassOptions().worldMode == WorldMode::Closed) {
      analyzeClosedWorld(module);
    }

    optimize(module);
  }

  void analyzeClosedWorld(Module* module) {
    // First, find all immutable, equality-comparable globals initialized to a
    // top-level struct.new, and propagate them to supertypes.
    std::unordered_set<StructNew*> globalStructNews;
    for (auto& global : module->globals) {
      if (global->imported() || global->mutable_) {
        continue;
      }
      auto* structNew = global->init->dynCast<StructNew>();
      if (!structNew || !structNew->type.isRef()) {
        continue;
      }
      auto type = structNew->type.getHeapType();
      // The global's declared type must be equality comparable.
      if (auto eq = wasm::HeapTypes::eq.getBasic(type.getShared());
          !Type::isSubType(global->type, Type(eq, Nullable))) {
        continue;
      }

      globalStructNews.insert(structNew);
      auto curr = type;
      while (1) {
        typeInfos[curr].globals.push_back(global->name);
        auto super = curr.getDeclaredSuperType();
        if (!super) {
          break;
        }
        curr = *super;
      }
    }

    if (typeInfos.empty()) {
      return;
    }

    // Record any other struct.new of a tracked type (or subtype): in functions,
    // nested in global initializers, in mutable or non-eqref globals, or in
    // table/element initializers. We cannot refer to these instances via
    // global.get, nor un-nest their fields, so they will only allow optimizing
    // fields where they have a constant value that does not need to be
    // selected via ref.eq on that instance.
    auto noteOtherStructNew = [&](StructNew* structNew) {
      if (!structNew->type.isRef()) {
        return;
      }
      auto curr = structNew->type.getHeapType();
      while (1) {
        if (auto iter = typeInfos.find(curr); iter != typeInfos.end()) {
          iter->second.otherStructNews.push_back(structNew);
        }
        auto super = curr.getDeclaredSuperType();
        if (!super) {
          break;
        }
        curr = *super;
      }
    };

    using StructNews = std::vector<StructNew*>;
    ModuleUtils::ParallelFunctionAnalysis<StructNews> analysis(
      *module, [&](Function* func, StructNews& structNews) {
        if (func->imported()) {
          return;
        }
        for (auto* structNew : FindAll<StructNew>(func->body).list) {
          if (structNew->type.isRef()) {
            structNews.push_back(structNew);
          }
        }
      });

    for (auto& func : module->functions) {
      for (auto* structNew : analysis.map[func.get()]) {
        noteOtherStructNew(structNew);
      }
    }

    for (auto& global : module->globals) {
      if (global->imported()) {
        continue;
      }
      for (auto* structNew : FindAll<StructNew>(global->init).list) {
        if (!globalStructNews.contains(structNew)) {
          noteOtherStructNew(structNew);
        }
      }
    }

    for (auto& table : module->tables) {
      if (table->init) {
        for (auto* structNew : FindAll<StructNew>(table->init).list) {
          noteOtherStructNew(structNew);
        }
      }
    }
    for (auto& segment : module->elementSegments) {
      for (auto* item : segment->data) {
        for (auto* structNew : FindAll<StructNew>(item).list) {
          noteOtherStructNew(structNew);
        }
      }
    }

    for (auto& [type, info] : typeInfos) {
      std::sort(info.globals.begin(), info.globals.end());
    }
  }

  void optimize(Module* module) {
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
      // Whether any non-global struct.new (or mutable/non-eqref global) has
      // this Value. Such instances cannot be compared via ref.eq against a
      // global.
      bool hasOtherInstances = false;

      bool hasSingleGlobal() const {
        return globals.size() == 1 && !hasOtherInstances;
      }

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

      // As we prepare to un-nest globals, we create global.gets of the global
      // that we will un-nest the content to. That global does not yet exist,
      // and we note such globals as we go so we ignore them (they are invalid
      // IR until the global is created, later in this pass).
      std::unordered_set<GlobalGet*> unnestingGlobalGets;

      void visitStructGet(StructGet* curr) {
        optimize(curr, curr->ref, curr->index);
      }

      void visitRefGetDesc(RefGetDesc* curr) {
        optimize(curr, curr->ref, DescriptorIndex);
      }

      // Optimize an expression |curr| that reads from a reference |ref|, and a
      // particular field index (which might be DescriptorIndex);
      void optimize(Expression* curr, Expression*& ref, Index fieldIndex) {
        auto type = ref->type;
        if (type == Type::unreachable) {
          return;
        }

        // We must ignore the case of a non-struct heap type, that is, a bottom
        // type (which is all that is left after we've already ruled out
        // unreachable).
        auto heapType = type.getHeapType();
        if (!heapType.isStruct()) {
          return;
        }

        // The field must be immutable.
        std::optional<Field> field;
        if (fieldIndex != DescriptorIndex) {
          field = heapType.getStruct().fields[fieldIndex];
          if (field->mutable_ == Mutable) {
            return;
          }
        }

        auto& wasm = *getModule();

        // This is a read of an immutable field. See if it is a trivial case, of
        // a read from an immutable global.
        if (auto* get = ref->dynCast<GlobalGet>()) {
          // The global.get must be valid, and not in the process of being
          // rewritten to point to a new un-nested global.
          if (!unnestingGlobalGets.contains(get)) {
            auto* global = wasm.getGlobal(get->name);
            if (!global->mutable_ && !global->imported()) {
              if (auto* structNew = global->init->dynCast<StructNew>()) {
                auto value = readFromStructNew(structNew, fieldIndex, field);
                // We know the exact global being read here.
                value.globals.push_back(global->name);
                replaceCurrent(getReadValue(value, fieldIndex, field, curr));
                return;
              }
            }
          }
        }

        auto iter = parent.typeInfos.find(heapType);
        if (iter == parent.typeInfos.end()) {
          return;
        }

        const auto& [globals, otherStructNews] = iter->second;
        if (globals.size() == 0) {
          return;
        }

        Builder builder(wasm);

        if (globals.size() == 1 && otherStructNews.empty()) {
          // Leave it to other passes to infer the constant value of the field,
          // if there is one: just change the reference to the global, which
          // will unlock those other optimizations. Note we must trap if the ref
          // is null, so add RefAsNonNull here.
          auto global = globals[0];
          auto globalType = wasm.getGlobal(global)->type;
          // Find the type the read would have if we used the global directly
          // without a cast.
          Type newType = Type::none;
          if (field) {
            if (globalType.isStruct()) {
              const auto& fields = globalType.getHeapType().getStruct().fields;
              if (fieldIndex < fields.size()) {
                newType = fields[fieldIndex].type;
              }
            }
          } else if (auto desc = globalType.getHeapType().getDescriptorType()) {
            newType = Type(*desc, NonNullable, globalType.getExactness());
          }
          Expression* get = builder.makeGlobalGet(global, globalType);
          if (!Type::isSubType(newType, curr->type)) {
            // Reading from the global's type directly would either be invalid
            // or produce a less refined type, so cast to the original operand
            // type.
            get = builder.makeRefCast(
              get, ref->type.withInexactIfNoCustomDescs(wasm.features));
          } else if (newType != curr->type) {
            // The read will now produce a more refined type, which could change
            // parent types.
            refinalize = true;
          }
          // No need to worry about atomic gets here. We will still read from
          // the same memory location as before and preserve all side effects
          // (including synchronization) that were previously present. The
          // memory location is immutable anyway, so there cannot be any writes
          // to synchronize with in the first place.
          ref = builder.makeSequence(
            builder.makeDrop(builder.makeRefAs(RefAsNonNull, ref)), get);
          return;
        }

        // TODO: SmallVector?
        std::vector<Value> values;

        auto addValue = [&](Value& value, std::optional<Name> global) {
          // If the value is constant, it may be grouped as mentioned before.
          // See if it matches anything we've seen before.
          if (value.isConstant()) {
            for (auto& oldValue : values) {
              if (oldValue.isConstant() &&
                  oldValue.getConstant() == value.getConstant()) {
                // Add us to this group.
                if (global) {
                  oldValue.globals.push_back(*global);
                } else {
                  oldValue.hasOtherInstances = true;
                }
                return true;
              }
            }
          }
          // This is a new value, so create a new group, unless we've seen too
          // many unique values. In that case, give up.
          if (values.size() == 2) {
            return false;
          }
          if (global) {
            value.globals.push_back(*global);
          } else {
            value.hasOtherInstances = true;
          }
          values.push_back(value);
          return true;
        };

        // Scan the relevant struct.new operands.
        for (Index i = 0; i < globals.size(); i++) {
          Name global = globals[i];
          auto* structNew = wasm.getGlobal(global)->init->cast<StructNew>();
          // Find the value read from the struct.new.
          auto value = readFromStructNew(structNew, fieldIndex, field);
          if (!addValue(value, global)) {
            return;
          }
        }

        for (auto* structNew : otherStructNews) {
          auto value = readFromStructNew(structNew, fieldIndex, field);
          if (!value.isConstant() || !addValue(value, std::nullopt)) {
            return;
          }
        }

        // We have at least one global, and so must have at least one value. And
        // we have already exited if we have more than 2 values (see the early
        // return above) so that only leaves 1 and 2.
        if (values.size() == 1) {
          // The case of 1 value is simple: trap if the ref is null, and
          // otherwise return the value. Since the field is immutable, there
          // cannot have been any writes to it we must synchronize with, so we
          // do not need a fence.
          replaceCurrent(builder.makeSequence(
            builder.makeDrop(builder.makeRefAs(RefAsNonNull, ref)),
            getReadValue(values[0], fieldIndex, field, curr)));
          return;
        }
        assert(values.size() == 2);

        // We have two values. Check that we can pick between them using a
        // single comparison. While doing so, ensure that the index we can check
        // on is 0, that is, the first value has a single global (and no other
        // instances).
        if (values[0].hasSingleGlobal()) {
          // The checked global is already in index 0.
        } else if (values[1].hasSingleGlobal()) {
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
        auto* left = getReadValue(values[0], fieldIndex, field, curr);
        auto* right = getReadValue(values[1], fieldIndex, field, curr);
        // Note that we must trap on null, so add a ref.as_non_null here. As
        // before, the get cannot have synchronized with anything.
        Expression* getGlobal =
          builder.makeGlobalGet(checkGlobal, wasm.getGlobal(checkGlobal)->type);
        replaceCurrent(builder.makeSelect(
          builder.makeRefEq(builder.makeRefAs(RefAsNonNull, ref), getGlobal),
          left,
          right));
      }

      void visitRefCast(RefCast* curr) {
        // When we see (ref.cast $T), and the type has a descriptor, and that
        // descriptor only has a single global, then we can do
        // (ref.cast_desc_eq) using the descriptor. Descriptor casts are usually
        // more efficient than normal ones (and even more so if we get lucky and
        // are in a loop, where the global.get of the descriptor can be
        // hoisted).
        // TODO: only do this when shrinkLevel == 0?
        if (!parent.optimizeToDescCasts) {
          return;
        }

        // Check if we have a descriptor.
        auto type = curr->type;
        if (type == Type::unreachable) {
          return;
        }
        auto heapType = type.getHeapType();
        auto desc = heapType.getDescriptorType();
        if (!desc) {
          return;
        }

        // Check if the type has no (relevant) subtypes, as a ref.cast_desc_eq
        // will find precisely that type and nothing else.
        if (!type.isExact() &&
            !parent.subTypes->getStrictSubTypes(heapType).empty()) {
          return;
        }

        // Check if we have a single global for the descriptor.
        auto iter = parent.typeInfos.find(*desc);
        if (iter == parent.typeInfos.end()) {
          return;
        }
        const auto& [globals, otherStructNews] = iter->second;
        if (globals.size() != 1 || !otherStructNews.empty()) {
          return;
        }

        // We can optimize!
        auto global = globals[0];
        auto& wasm = *getModule();
        Builder builder(wasm);
        auto* getGlobal =
          builder.makeGlobalGet(global, wasm.getGlobal(global)->type);
        auto* castDesc = builder.makeRefCast(curr->ref, getGlobal, curr->type);
        replaceCurrent(castDesc);
      }

      void visitFunction(Function* func) {
        if (refinalize) {
          ReFinalize().walkFunctionInModule(func, getModule());
        }
      }

      Value readFromStructNew(StructNew* structNew,
                              Index fieldIndex,
                              std::optional<Field>& field) {
        // Find the value read from the struct and represent it as a Value.
        Value value;
        PossibleConstantValues constant;
        if (field && structNew->isWithDefault()) {
          constant.note(Literal::makeZero(field->type));
          value.content = constant;
        } else {
          Expression* operand;
          if (field) {
            operand = structNew->operands[fieldIndex];
          } else {
            operand = structNew->desc;
          }
          constant.note(operand, *getModule());
          if (constant.isConstant()) {
            value.content = constant;
          } else {
            value.content = operand;
          }
        }
        return value;
      }

      // Given a Value, returns what we should read for it.
      Expression* getReadValue(const Value& value,
                               Index fieldIndex,
                               std::optional<Field>& field,
                               Expression* curr) {
        auto& wasm = *getModule();
        Builder builder(wasm);

        Expression* ret;
        if (value.isConstant()) {
          // This is known to be a constant, so simply emit an expression for
          // that constant, and handle if the field is packed.
          ret = value.getConstant().makeExpression(wasm);
          if (field) {
            ret = Bits::makePackedFieldGet(
              ret, *field, curr->cast<StructGet>()->signed_, wasm);
          }
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
          unnestingGlobalGets.insert(get);

          ret = get;
        }

        // We must add a cast to non-null in some cases: A read of a null
        // descriptor returns a non-null value, so if there was a null in the
        // global, that would not validate by itself.
        if (ret->type.isNullableRef() && curr->type.isNonNullableRef()) {
          ret = builder.makeRefAs(RefAsNonNull, ret);
        }

        // If the type is more refined, we must refinalize. For example, we
        // might have a struct.get that normally returns anyref, and know that
        // field contains null, so we return nullref.
        if (ret->type != curr->type) {
          refinalize = true;
        }

        // This value replaces the struct.get, so it should have the same
        // source location.
        debuginfo::copyOriginalToReplacement(curr, ret, getFunction());

        return ret;
      }
    };

    // Find the optimization opportunities in parallel.
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
        assert(index < structNew->operands.size() || index == DescriptorIndex);
        auto*& operand = index != DescriptorIndex ? structNew->operands[index]
                                                  : structNew->desc;

        // If we already un-nested this then we don't need to repeat that work.
        if (auto* nestedGet = operand->dynCast<GlobalGet>()) {
          // We already un-nested, and this global.get refers to the new global.
          // Simply copy the target.
          get->name = nestedGet->name;
          assert(get->type == nestedGet->type);
        } else {
          // Add a new global, initialized to the operand.
          std::string indexName =
            index != DescriptorIndex ? std::to_string(index) : "desc";
          auto newName = Names::getValidGlobalName(
            *module, global->name.toString() + ".unnested." + indexName);
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

Pass* createGlobalStructInferencePass() {
  return new GlobalStructInference(false);
}
Pass* createGlobalStructInferenceDescCastPass() {
  return new GlobalStructInference(true);
}

} // namespace wasm
