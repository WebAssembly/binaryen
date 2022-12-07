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
// Adds a new type for each struct/array.new. This is similar to SSA, which
// defines each value in its own SSA register as opposed to reusing a local;
// likewise, this defines a new type at each location that creates an instance.
// As with SSA, this then allows other passes to be more efficient:
//
//  x = struct.new $A (5);
//  print(x.value);
//
//  y = struct.new $A (11);
//  print(y.value);
//
// A type-based optimization on that will not be able to do much, as it will see
// that we write either 5 or 11 into the value of type $A. But after TypeSSA we
// have this:
//
//  x = struct.new $A.x (5);
//  print(x.value);
//
//  y = struct.new $A.y (11);
//  print(y.value);
//
// Now each place has its own type, and a single value is possible in each type,
// allowing us to infer what is printed.
//
// Note that the metaphor of SSA is not perfect here as we do not handle merges,
// that is, when there is a value that can read from more than one struct.new
// then we do nothing atm. We could create a phi there, but in general that
// would require multiple inheritance. TODO think more on that
//
// This pass works well with TypeMerging. See notes there for more.
//

#include "ir/find_all.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/possible-constant.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// A vector of struct.new or one of the variations on array.new.
using News = std::vector<Expression*>;

struct NewFinder : public PostWalker<NewFinder> {
  News news;

  void visitStructNew(StructNew* curr) { news.push_back(curr); }
  void visitArrayNew(ArrayNew* curr) { news.push_back(curr); }
  void visitArrayNewSeg(ArrayNewSeg* curr) { news.push_back(curr); }
  void visitArrayInit(ArrayInit* curr) { news.push_back(curr); }
};

struct TypeSSA : public Pass {
  // Only modifies struct/array.new types.
  bool requiresNonNullableLocalFixups() override { return false; }

  Module* module;

  void run(Module* module_) override {
    module = module_;

    if (!module->features.hasGC()) {
      return;
    }

    // First, find all the struct/array.news.

    ModuleUtils::ParallelFunctionAnalysis<News> analysis(
      *module, [&](Function* func, News& news) {
        if (func->imported()) {
          return;
        }

        NewFinder finder;
        finder.walk(func->body);
        news = std::move(finder.news);
      });

    // Also find news in the module scope.
    NewFinder moduleFinder;
    moduleFinder.walkModuleCode(module);

    // Process all the news to find the ones we want to modify, adding them to
    // newsToModify. Note that we must do so in a deterministic order.
    ModuleUtils::iterDefinedFunctions(
      *module, [&](Function* func) { processNews(analysis.map[func]); });
    processNews(moduleFinder.news);

    // Modify the ones we found are relevant. We must modify them all at once as
    // in the isorecursive type system we want to create a single new rec group
    // for them all (see below).
    modifyNews();
  }

  News newsToModify;

  // As we generate new names, use a consistent index.
  Index nameCounter = 0;

  void processNews(const News& news) {
    for (auto* curr : news) {
      if (isInteresting(curr)) {
        newsToModify.push_back(curr);
      }
    }
  }

  void modifyNews() {
    auto num = newsToModify.size();
    if (num == 0) {
      return;
    }

    // We collected all the instructions we want to create new types for. Now we
    // can create those new types, which we do all at once. It is important to
    // do so in the isorecursive type system as if we create a new singleton rec
    // group for each then all those will end up identical to each other, so
    // instead we'll make a single big rec group for them all at once.
    //
    // Our goal is to create a completely new/fresh/private type for each
    // instruction that we found. In the isorecursive type system there isn't an
    // explicit way to do so, but at least if the new rec group is very large
    // the risk of collision with another rec group in the program is small.
    // Note that the risk of collision with things outside of this module is
    // also a possibility, and so for that reason this pass is likely mostly
    // useful in the closed-world scenario.

    TypeBuilder builder(num);
    for (Index i = 0; i < num; i++) {
      auto* curr = newsToModify[i];
      auto oldType = curr->type.getHeapType();
      if (oldType.isStruct()) {
        builder[i] = oldType.getStruct();
      } else {
        builder[i] = oldType.getArray();
      }
      builder[i].subTypeOf(oldType);
    }
    builder.createRecGroup(0, num);
    auto result = builder.build();
    assert(!result.getError());
    auto newTypes = *result;
    assert(newTypes.size() == num);

    // The new types must not overlap with any existing ones. If they do, then
    // it would be unsafe to apply this optimization (if casts exist to the
    // existing types, the new types merged with them would now succeed on those
    // casts). We could try to create a "weird" rec group to avoid this (e.g. we
    // could make a rec group larger than any existing one, or with an initial
    // member that is "random"), but hopefully this is rare, so just error for
    // now.
    //
    // Note that it is enough to check one of the types: either the entire rec
    // group gets merged, so they are all merged, or not.
    std::vector<HeapType> typesVec = ModuleUtils::collectHeapTypes(*module);
    std::unordered_set<HeapType> typesSet(typesVec.begin(), typesVec.end());
    if (typesSet.count(newTypes[0])) {
      Fatal() << "Rec group collision in TypeSSA! Please file a bug";
    }
#ifndef NDEBUG
    // Verify the above assumption, just to be safe.
    for (auto newType : newTypes) {
      assert(!typesSet.count(newType));
    }
#endif

    // Success: we can apply the new types.

    // We'll generate nice names as we go, if we can, so first scan existing
    // ones to avoid collisions.
    std::unordered_set<Name> existingTypeNames;
    auto& typeNames = module->typeNames;
    for (auto& [type, info] : typeNames) {
      existingTypeNames.insert(info.name);
    }

    for (Index i = 0; i < num; i++) {
      auto* curr = newsToModify[i];
      auto oldType = curr->type.getHeapType();
      auto newType = newTypes[i];
      curr->type = Type(newType, NonNullable);

      // If the old type has a nice name, make a nice name for the new one.
      if (typeNames.count(oldType)) {
        auto intendedName = typeNames[oldType].name.toString() + '$' +
                            std::to_string(++nameCounter);
        auto newName =
          Names::getValidNameGivenExisting(intendedName, existingTypeNames);
        // Copy the old field names; only change the type's name itself.
        auto info = typeNames[oldType];
        info.name = newName;
        typeNames[newType] = info;
        existingTypeNames.insert(newName);
      }
    }
  }

  // An interesting *.new, which we think is worth creating a new type for, is
  // one that can be optimized better with a new type. That means it must have
  // something interesting for optimizations to work with.
  //
  // TODO: We may add new optimizations in the future that can benefit from more
  //       things, so it may be interesting to experiment with considering all
  //       news as "interesting" when we add major new type-based optimization
  //       passes.
  bool isInteresting(Expression* curr) {
    if (curr->type == Type::unreachable) {
      // This is dead code anyhow.
      return false;
    }

    // Look for at least one interesting operand. We will consider each operand
    // against the declared type, that is, the type declared for where it is
    // stored. If it has more information than the declared type then it is
    // interesting.
    auto isInterestingRelevantTo = [&](Expression* operand, Type declaredType) {
      if (operand->type != declaredType) {
        // Excellent, this field has an interesting type - more refined than the
        // declared type, and which optimizations might benefit from.
        //
        // TODO: If we add GUFA integration, we could check for an exact type
        //       here - even if the type is not more refined, but it is more
        //       precise, that is interesting.
        return true;
      }

      // TODO: fallthrough
      PossibleConstantValues value;
      value.note(operand, *module);
      if (value.isConstantLiteral() || value.isConstantGlobal()) {
        // This is a constant that passes may benefit from.
        return true;
      }

      return false;
    };

    auto type = curr->type.getHeapType();

    if (auto* structNew = curr->dynCast<StructNew>()) {
      if (structNew->isWithDefault()) {
        // This starts with all default values - zeros and nulls - and that
        // might be useful.
        //
        // (An item whose fields are all bottom types only has a single possible
        // value in each field anyhow, so that is not interesting, but also
        // unreasonable to occur in practice as other optimizations should
        // handle it.)
        return true;
      }

      auto& fields = type.getStruct().fields;
      for (Index i = 0; i < fields.size(); i++) {
        assert(i <= structNew->operands.size());
        if (isInterestingRelevantTo(structNew->operands[i], fields[i].type)) {
          return true;
        }
      }
    } else if (auto* arrayNew = curr->dynCast<ArrayNew>()) {
      if (arrayNew->isWithDefault()) {
        return true;
      }

      auto element = type.getArray().element;
      if (isInterestingRelevantTo(arrayNew->init, element.type)) {
        return true;
      }
    } else if (curr->is<ArrayNewSeg>()) {
      // TODO: If the element segment is immutable perhaps we could inspect it.
      return true;
    } else if (auto* arrayInit = curr->dynCast<ArrayInit>()) {
      // All the items must be interesting for us to consider this interesting,
      // as we only track a single value for all indexes in the array, so one
      // boring value means it is all boring.
      //
      // Note that we consider the empty array to be interesting (though atm no
      // pass tracks the length - we might add one later though).
      auto element = type.getArray().element;
      for (auto* value : arrayInit->values) {
        if (!isInterestingRelevantTo(value, element.type)) {
          return false;
        }
      }
      return true;
    } else {
      WASM_UNREACHABLE("unknown new");
    }

    // Nothing interesting.
    return false;
  }
};

} // anonymous namespace

Pass* createTypeSSAPass() { return new TypeSSA(); }

} // namespace wasm
