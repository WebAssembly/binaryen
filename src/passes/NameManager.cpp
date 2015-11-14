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
void NameManager::visitLabel(Label* curr) {
  names.insert(curr->name);
}
void NameManager::visitBreak(Break* curr) {
  names.insert(curr->name);
}
void NameManager::visitSwitch(Switch* curr) {
  names.insert(curr->name);
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
  for (auto& param : curr->params) {
    names.insert(param.name);
  }
  for (auto& local : curr->locals) {
    names.insert(local.name);
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

