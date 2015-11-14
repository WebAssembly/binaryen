
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
  return passInfos[name].create();
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

void PassRunner::add(std::string passName) {
  passes.push_back(PassRegistry::get()->createPass(passName));
}

template<class P>
void PassRunner::add() {
  passes.push_back(new P());
}

void PassRunner::run(Module* module) {
  for (auto pass : passes) {
    currPass = pass;
    pass->run(this, module);
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
    delete(pass);
  }
}

} // namespace wasm

