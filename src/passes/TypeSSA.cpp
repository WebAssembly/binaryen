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

#include "ir/find_all.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/possible-constant.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

struct News {
  std::vector<StructNew*> structNews;
  // TODO: arrayNews of all kinds
};

struct NewFinder : public PostWalker<NewFinder> {
  News news;

  void visitStructNew(StructNew* curr) { news.structNews.push_back(curr); }

  // TODO arrays
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

    // Process all the news. Note that we must do so in a deterministic order.
    ModuleUtils::iterDefinedFunctions(
      *module, [&](Function* func) { processNews(analysis.map[func]); });
    processNews(moduleFinder.news);
  }

  // As we generate new names, use a consistent index.
  Index nameCounter = 0;

  void processNews(const News& news) {
    // We'll generate nice names as we go, if we can.
    std::unordered_set<Name> existingTypeNames;
    auto& typeNames = module->typeNames;
    for (auto& [type, info] : typeNames) {
      existingTypeNames.insert(info.name);
    }

    for (auto* curr : news.structNews) {
      if (isInteresting(curr)) {
        // This is interesting; create a new type and use it. The new type is
        // identical to the existing one, and a subtype of it, so the only
        // difference between them is nominal - which is enough for optimization
        // passes to learn different things about the two.
        auto oldType = curr->type.getHeapType();
        TypeBuilder builder(1);
        builder.setHeapType(0, oldType.getStruct());
        builder.setSubType(0, oldType);
        auto result = builder.build();
        assert(!result.getError());
        auto newType = (*result)[0];
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
    // TODO: arrays
  }

  // An interesting StructNew, which we think is worth creating a new type for,
  // is one that can be optimized better with a new type. That means it must
  // have something interesting for optimizations to work with.
  bool isInteresting(StructNew* curr) {
    if (curr->type == Type::unreachable) {
      // This is dead code anyhow.
      return false;
    }

    if (curr->isWithDefault()) {
      // This starts with all default values - zeros and nulls - and that might
      // be useful.
      return true;
    }

    // Look for at least one interesting operand.
    auto& fields = curr->type.getHeapType().getStruct().fields;
    for (Index i = 0; i < fields.size(); i++) {
      assert(i <= curr->operands.size());
      auto* operand = curr->operands[i];
      if (operand->type != fields[i].type) {
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
    }

    // Nothing interesting.
    return false;
  }
};

} // anonymous namespace

Pass* createTypeSSAPass() { return new TypeSSA(); }

} // namespace wasm
