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

//
// NameManager
//

#include <wasm.h>
#include <pass.h>

namespace wasm {

Name NameManager::getUnique(std::string prefix) {
  while (1) {
    Name curr = cashew::IString((prefix + std::to_string(counter++)).c_str(), false);
    if (names.find(curr) == names.end()) {
      names.insert(curr);
      return curr;
    }
  }
}

void NameManager::visitBlock(Block* curr) {
  names.insert(curr->name);
}
void NameManager::visitLoop(Loop* curr) {
  names.insert(curr->out);
  names.insert(curr->in);
}
void NameManager::visitBreak(Break* curr) {
  names.insert(curr->name);
}
void NameManager::visitSwitch(Switch* curr) {
  names.insert(curr->default_);
  for (auto& target : curr->targets) {
    names.insert(target);
  }
}
void NameManager::visitCall(Call* curr) {
  names.insert(curr->target);
}
void NameManager::visitCallImport(CallImport* curr) {
  names.insert(curr->target);
}
void NameManager::visitFunctionType(FunctionType* curr) {
  names.insert(curr->name);
}
void NameManager::visitFunction(Function* curr) {
  names.insert(curr->name);
  for (Index i = 0; i < curr->getNumLocals(); i++) {
    Name name = curr->tryLocalName(i);
    if (name.is()) {
      names.insert(name);
    }
  }
}
void NameManager::visitImport(Import* curr) {
  names.insert(curr->name);
}
void NameManager::visitExport(Export* curr) {
  names.insert(curr->name);
}

static RegisterPass<NameManager> registerPass("name-manager", "utility pass to manage names in modules");

} // namespace wasm
