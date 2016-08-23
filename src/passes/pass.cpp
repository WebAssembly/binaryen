/*
 * Copyright 2015 WebAssembly Community Group participants
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

#include <chrono>

#include <passes/passes.h>
#include <pass.h>

namespace wasm {

// PassRegistry

PassRegistry::PassRegistry() {
  registerPasses();
}

static PassRegistry singleton;

PassRegistry* PassRegistry::get() {
  return &singleton;
}

void PassRegistry::registerPass(const char* name, const char *description, Creator create) {
  assert(passInfos.find(name) == passInfos.end());
  passInfos[name] = PassInfo(description, create);
}

Pass* PassRegistry::createPass(std::string name) {
  if (passInfos.find(name) == passInfos.end()) return nullptr;
  auto ret = passInfos[name].create();
  ret->name = name;
  return ret;
}

std::vector<std::string> PassRegistry::getRegisteredNames() {
  std::vector<std::string> ret;
  for (auto pair : passInfos) {
    ret.push_back(pair.first);
  }
  return ret;
}

std::string PassRegistry::getPassDescription(std::string name) {
  assert(passInfos.find(name) != passInfos.end());
  return passInfos[name].description;
}

// PassRunner

void PassRegistry::registerPasses() {
  registerPass("coalesce-locals", "reduce # of locals by coalescing", createCoalesceLocalsPass);
  registerPass("coalesce-locals-learning", "reduce # of locals by coalescing and learning", createCoalesceLocalsWithLearningPass);
  registerPass("dce", "removes unreachable code", createDeadCodeEliminationPass);
  registerPass("duplicate-function-elimination", "removes duplicate functions", createDuplicateFunctionEliminationPass);
  registerPass("merge-blocks", "merges blocks to their parents", createMergeBlocksPass);
  registerPass("metrics", "reports metrics", createMetricsPass);
  registerPass("nm", "name list", createNameListPass);
  registerPass("name-manager", "utility pass to manage names in modules", createNameManagerPass);
  registerPass("optimize-instructions", "optimizes instruction combinations", createOptimizeInstructionsPass);
  registerPass("post-emscripten", "miscellaneous optimizations for Emscripten-generated code", createPostEmscriptenPass);
  registerPass("print", "print in s-expression format", createPrinterPass);
  registerPass("print-minified", "print in minified s-expression format", createMinifiedPrinterPass);
  registerPass("print-full", "print in full s-expression format", createFullPrinterPass);
  registerPass("remove-imports", "removes imports and replaces them with nops", createRemoveImportsPass);
  registerPass("remove-memory", "removes memory segments", createRemoveMemoryPass);
  registerPass("remove-unused-brs", "removes breaks from locations that are not needed", createRemoveUnusedBrsPass);
  registerPass("remove-unused-functions", "removes unused functions", createRemoveUnusedFunctionsPass);
  registerPass("remove-unused-names", "removes names from locations that are never branched to", createRemoveUnusedNamesPass);
  registerPass("reorder-functions", "sorts functions by access frequency", createReorderFunctionsPass);
  registerPass("reorder-locals", "sorts locals by access frequency", createReorderLocalsPass);
  registerPass("simplify-locals", "miscellaneous locals-related optimizations", createSimplifyLocalsPass);
  registerPass("vacuum", "removes obviously unneeded code", createVacuumPass);
  registerPass("precompute", "computes compile-time evaluatable expressions", createPrecomputePass);
//  registerPass("lower-i64", "lowers i64 into pairs of i32s", createLowerInt64Pass);
}

void PassRunner::addDefaultOptimizationPasses() {
  add("duplicate-function-elimination");
  add("dce");
  add("remove-unused-brs");
  add("remove-unused-names");
  add("optimize-instructions");
  add("precompute");
  add("simplify-locals");
  add("vacuum"); // previous pass creates garbage
  add("remove-unused-brs"); // simplify-locals opens opportunities for phi optimizations
  add("coalesce-locals");
  add("vacuum"); // previous pass creates garbage
  add("reorder-locals");
  add("merge-blocks");
  add("optimize-instructions");
  add("precompute");
  add("vacuum"); // should not be needed, last few passes do not create garbage, but just to be safe
  add("duplicate-function-elimination"); // optimizations show more functions as duplicate
}

void PassRunner::addDefaultFunctionOptimizationPasses() {
  add("dce");
  add("remove-unused-brs");
  add("remove-unused-names");
  add("optimize-instructions");
  add("precompute");
  add("simplify-locals");
  add("vacuum"); // previous pass creates garbage
  add("remove-unused-brs"); // simplify-locals opens opportunities for phi optimizations
  add("coalesce-locals");
  add("vacuum"); // previous pass creates garbage
  add("reorder-locals");
  add("merge-blocks");
  add("optimize-instructions");
  add("precompute");
  add("vacuum"); // should not be needed, last few passes do not create garbage, but just to be safe
}

void PassRunner::addDefaultGlobalOptimizationPasses() {
  add("duplicate-function-elimination");
}

void PassRunner::run() {
  if (debug) {
    // for debug logging purposes, run each pass in full before running the other
    std::chrono::high_resolution_clock::time_point beforeEverything;
    size_t padding = 0;
    std::cerr << "[PassRunner] running passes..." << std::endl;
    beforeEverything = std::chrono::high_resolution_clock::now();
    for (auto pass : passes) {
      padding = std::max(padding, pass->name.size());
    }
    for (auto* pass : passes) {
      currPass = pass;
      std::chrono::high_resolution_clock::time_point before;
      std::cerr << "[PassRunner]   running pass: " << pass->name << "... ";
      for (size_t i = 0; i < padding - pass->name.size(); i++) {
        std::cerr << ' ';
      }
      before = std::chrono::high_resolution_clock::now();
      if (pass->isFunctionParallel()) {
        // function-parallel passes should get a new instance per function
        for (auto& func : wasm->functions) {
          runPassOnFunction(pass, func.get());
        }
      } else {
        pass->run(this, wasm);
      }
      auto after = std::chrono::high_resolution_clock::now();
      std::chrono::duration<double> diff = after - before;
      std::cerr << diff.count() << " seconds." << std::endl;
    }
    auto after = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> diff = after - beforeEverything;
    std::cerr << "[PassRunner] passes took " << diff.count() << " seconds." << std::endl;
  } else {
    // non-debug normal mode, run them in an optimal manner - for locality it is better
    // to run as many passes as possible on a single function before moving to the next
    std::vector<Pass*> stack;
    auto flush = [&]() {
      if (stack.size() > 0) {
        // run the stack of passes on all the functions, in parallel
        size_t num = ThreadPool::get()->size();
        std::vector<std::function<ThreadWorkState ()>> doWorkers;
        std::atomic<size_t> nextFunction;
        nextFunction.store(0);
        size_t numFunctions = wasm->functions.size();
        for (size_t i = 0; i < num; i++) {
          doWorkers.push_back([&]() {
            auto index = nextFunction.fetch_add(1);
            // get the next task, if there is one
            if (index >= numFunctions) {
              return ThreadWorkState::Finished; // nothing left
            }
            Function* func = this->wasm->functions[index].get();
            // do the current task: run all passes on this function
            for (auto* pass : stack) {
              runPassOnFunction(pass, func);
            }
            if (index + 1 == numFunctions) {
              return ThreadWorkState::Finished; // we did the last one
            }
            return ThreadWorkState::More;
          });
        }
        ThreadPool::get()->work(doWorkers);
      }
      stack.clear();
    };
    for (auto* pass : passes) {
      if (pass->isFunctionParallel()) {
        stack.push_back(pass);
      } else {
        flush();
        pass->run(this, wasm);
      }
    }
    flush();
  }
}

void PassRunner::runFunction(Function* func) {
  if (debug) {
    std::cerr << "[PassRunner] running passes on function " << func->name << std::endl;
  }
  for (auto* pass : passes) {
    runPassOnFunction(pass, func);
  }
}

PassRunner::~PassRunner() {
  for (auto pass : passes) {
    delete pass;
  }
}

void PassRunner::runPassOnFunction(Pass* pass, Function* func) {
  // function-parallel passes get a new instance per function
  if (pass->isFunctionParallel()) {
    auto instance = std::unique_ptr<Pass>(pass->create());
    instance->runFunction(this, wasm, func);
  } else {
    pass->runFunction(this, wasm, func);
  }
}

} // namespace wasm
