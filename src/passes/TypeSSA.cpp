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
#include "ir/utils.h"
#include "pass.h"
#include "support/hash.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// Given some TypeBuilder items that we want to build new types with, this
// function builds the types in a new rec group.
//
// This is almost the same as just calling build(), but there is a risk of a
// collision with an existing rec group. This function handles that by finding a
// way to ensure that the new types are in fact in a new rec group.
//
// TODO: Move this outside if we find more uses.
std::vector<HeapType> ensureTypesAreInNewRecGroup(RecGroup recGroup,
                                                  Module& wasm) {
  auto num = recGroup.size();

  std::vector<HeapType> types;
  types.reserve(num);
  for (auto type : recGroup) {
    types.push_back(type);
  }

  // Find all the heap types present before we create the new ones. The new
  // types must not appear in |existingSet|.
  std::vector<HeapType> existing = ModuleUtils::collectHeapTypes(wasm);
  std::unordered_set<HeapType> existingSet(existing.begin(), existing.end());

  // Check for a collision with an existing rec group. Note that it is enough to
  // check one of the types: either the entire rec group gets merged, so they
  // are all merged, or not.
  if (existingSet.count(types[0])) {
    // Unfortunately there is a conflict. Handle it by adding a "hash" - a
    // "random" extra item in the rec group that is so outlandish it will
    // surely (?) never collide with anything. We must loop while doing so,
    // until we find a hash that does not collide.
    auto hashSize = num + 10;
    size_t random = num;
    while (1) {
      // Make a builder and add a slot for the hash.
      TypeBuilder builder(num + 1);
      for (Index i = 0; i < num; i++) {
        builder[i].copy(types[i]);
      }

      // Implement the hash as a struct with "random" fields, and add it.
      Struct hashStruct;
      for (Index i = 0; i < hashSize; i++) {
        // TODO: a denser encoding?
        auto type = (random & 1) ? Type::i32 : Type::f64;
        hash_combine(random, hashSize + i);
        hashStruct.fields.push_back(Field(type, Mutable));
      }
      builder[num] = hashStruct;

      // Build and hope for the best.
      builder.createRecGroup(0, num + 1);
      auto result = builder.build();
      assert(!result.getError());
      types = *result;
      assert(types.size() == num + 1);

      if (existingSet.count(types[0])) {
        // There is still a collision. Exponentially use larger hashes to
        // quickly find one that works. Note that we also use different
        // pseudorandom values while doing so in the for-loop above.
        hashSize *= 2;
      } else {
        // Success! Leave the loop.
        break;
      }
    }
  }

#ifndef NDEBUG
  // Verify the lack of a collision, just to be safe.
  for (auto newType : types) {
    assert(!existingSet.count(newType));
  }
#endif

  return types;
}

// A vector of struct.new or one of the variations on array.new.
using News = std::vector<Expression*>;

struct NewFinder : public PostWalker<NewFinder> {
  News news;

  void visitStructNew(StructNew* curr) { news.push_back(curr); }
  void visitArrayNew(ArrayNew* curr) { news.push_back(curr); }
  void visitArrayNewData(ArrayNewData* curr) { news.push_back(curr); }
  void visitArrayNewElem(ArrayNewElem* curr) { news.push_back(curr); }
  void visitArrayNewFixed(ArrayNewFixed* curr) { news.push_back(curr); }
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

    // Finally, refinalize to propagate the new types to parents.
    ReFinalize().run(getPassRunner(), module);
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
    // (If a collision does happen, though, then that is very dangerous, as
    // casts on the new types could succeed in ways the program doesn't expect.)
    // Note that the risk of collision with things outside of this module is
    // also a possibility, and so for that reason this pass is likely mostly
    // useful in the closed-world scenario.

    TypeBuilder builder(num);
    for (Index i = 0; i < num; i++) {
      auto* curr = newsToModify[i];
      auto oldType = curr->type.getHeapType();
      switch (oldType.getKind()) {
        case HeapTypeKind::Struct:
          builder[i] = oldType.getStruct();
          break;
        case HeapTypeKind::Array:
          builder[i] = oldType.getArray();
          break;
        case HeapTypeKind::Func:
        case HeapTypeKind::Cont:
        case HeapTypeKind::Basic:
          WASM_UNREACHABLE("unexpected kind");
      }
      builder[i].subTypeOf(oldType);
      builder[i].setShared(oldType.getShared());
      builder[i].setOpen();
    }
    builder.createRecGroup(0, num);
    auto result = builder.build();
    assert(!result.getError());
    auto newTypes = *result;
    assert(newTypes.size() == num);

    // Make sure this is actually a new rec group.
    auto recGroup = newTypes[0].getRecGroup();
    newTypes = ensureTypesAreInNewRecGroup(recGroup, *module);

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
        auto intendedName = typeNames[oldType].name.toString() + '_' +
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

    if (!curr->type.getHeapType().isOpen()) {
      // We can't create new subtypes of a final type anyway.
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
    } else if (curr->is<ArrayNewData>() || curr->is<ArrayNewElem>()) {
      // TODO: If the segment is immutable perhaps we could inspect it.
      return true;
    } else if (auto* arrayInit = curr->dynCast<ArrayNewFixed>()) {
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
