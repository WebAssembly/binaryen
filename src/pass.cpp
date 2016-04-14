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
  add("remove-unused-brs");
  add("remove-unused-names");
  add("merge-blocks");
  add("optimize-instructions");
  add("simplify-locals");
  add("reorder-locals");
  add("vacuum");
}

void PassRunner::run(Module* module) {
  for (auto pass : passes) {
    currPass = pass;
    std::chrono::high_resolution_clock::time_point before;
    if (debug) {
      std::cerr << "[PassRunner] running pass: " << pass->name << std::endl;
      before = std::chrono::high_resolution_clock::now();
    }
    pass->run(this, module);
    if (debug) {
      std::chrono::high_resolution_clock::time_point after = std::chrono::high_resolution_clock::now();
      std::chrono::duration<double> diff = std::chrono::duration_cast<std::chrono::duration<double>>(after - before);
      std::cerr << "[PassRunner]   pass took " << diff.count() << " seconds." << std::endl;
    }
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
