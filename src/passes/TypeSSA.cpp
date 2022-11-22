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

  void visitStructNew(StructNew* curr) {
    news.structNews.push_back(curr);
  }

  // TODO arrays
};

struct TypeSSA : public Pass {
  // Only modifies struct/array.new types.
  bool requiresNonNullableLocalFixups() override { return false; }

  // Maps optimizable struct types to the globals whose init is a struct.new of
  // them. If a global is not present here, it cannot be optimized.
  std::unordered_map<HeapType, std::vector<Name>> typeGlobals;

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      return;
    }
    if (getTypeSystem() != TypeSystem::Nominal &&
        getTypeSystem() != TypeSystem::Isorecursive) {
      Fatal() << "TypeSSA requires nominal/isorecursive typing";
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
    moduleFinder.runOnModuleCode(getPassRunner(), module);

    // Process all the news. Note that we must do so in a deterministic order.
    ModuleUtils::iterImportedFunctions(*module, [&](Function* func) {
      processNews(analysis.map[func].news);
    });
    processNews(moduleFinder.news);
  }

  void processNews(const News& news) {
    for (auto* curr : news.structNews) {
  bool isInteresting() {
    // Must be a more refined type than the default, or a literal, or (if we
    // add GUFA) be an ExactType.
  }
    }
    // TODO: arrays
  }
};

} // anonymous namespace

Pass* createTypeSSAPass() { return new TypeSSA(); }

} // namespace wasm
