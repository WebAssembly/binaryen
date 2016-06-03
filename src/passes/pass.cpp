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

#include <pass.h>

namespace wasm {

// PassRegistry

PassRegistry* PassRegistry::get() {
  static PassRegistry* manager = nullptr;
  if (!manager) {
    manager = new PassRegistry();
  }
  return manager;
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

void PassRunner::addDefaultOptimizationPasses() {
  add("duplicate-function-elimination");
  add("dce");
  add("remove-unused-brs");
  add("remove-unused-names");
  add("optimize-instructions");
  add("simplify-locals");
  add("vacuum"); // previous pass creates garbage
  add("coalesce-locals");
  add("vacuum"); // previous pass creates garbage
  add("reorder-locals");
  add("merge-blocks");
  add("optimize-instructions");
  add("vacuum"); // should not be needed, last few passes do not create garbage, but just to be safe
  add("duplicate-function-elimination"); // optimizations show more functions as duplicate
}

void PassRunner::addDefaultFunctionOptimizationPasses() {
  add("dce");
  add("remove-unused-brs");
  add("remove-unused-names");
  add("optimize-instructions");
  add("simplify-locals");
  add("vacuum"); // previous pass creates garbage
  add("coalesce-locals");
  add("vacuum"); // previous pass creates garbage
  add("reorder-locals");
  add("merge-blocks");
  add("optimize-instructions");
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
      pass->run(this, wasm);
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
            Function* func = wasm->functions[index].get();
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
