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

void PassRunner::run() {
  std::chrono::high_resolution_clock::time_point beforeEverything;
  size_t padding = 0;
  if (debug) {
    std::cerr << "[PassRunner] running passes..." << std::endl;
    beforeEverything = std::chrono::high_resolution_clock::now();
    for (auto pass : passes) {
      padding = std::max(padding, pass->name.size());
    }
  }
  for (auto pass : passes) {
    currPass = pass;
    std::chrono::high_resolution_clock::time_point before;
    if (debug) {
      std::cerr << "[PassRunner]   running pass: " << pass->name << "... ";
      for (size_t i = 0; i < padding - pass->name.size(); i++) {
        std::cerr << ' ';
      }
      before = std::chrono::high_resolution_clock::now();
    }
    pass->run(this, wasm);
    if (debug) {
      auto after = std::chrono::high_resolution_clock::now();
      std::chrono::duration<double> diff = after - before;
      std::cerr << diff.count() << " seconds." << std::endl;
    }
  }
  if (debug) {
    auto after = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> diff = after - beforeEverything;
    std::cerr << "[PassRunner] passes took " << diff.count() << " seconds." << std::endl;
  }
}

template<class P>
P* PassRunner::getLast() {
  bool found = false;
  P* ret;
  for (int i = passes.size() - 1; i >= 0; i--) {
    if (found && (ret = dynamic_cast<P*>(passes[i]))) {
      return ret;
    }
    if (passes[i] == currPass) {
      found = true;
    }
  }
  return nullptr;
}

PassRunner::~PassRunner() {
  for (auto pass : passes) {
    delete pass;
  }
}

} // namespace wasm
