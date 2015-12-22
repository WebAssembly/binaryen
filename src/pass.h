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

#ifndef wasm_pass_h
#define wasm_pass_h

#include <functional>

#include "wasm.h"
#include "mixed_arena.h"

namespace wasm {

class Pass;

//
// Global registry of all passes in /passes/
//
struct PassRegistry {
  static PassRegistry* get();

  typedef std::function<Pass* ()> Creator;

  void registerPass(const char* name, const char *description, Creator create);
  Pass* createPass(std::string name);
  std::vector<std::string> getRegisteredNames();
  std::string getPassDescription(std::string name);

private:
  struct PassInfo {
    std::string description;
    Creator create;
    PassInfo() {}
    PassInfo(std::string description, Creator create) : description(description), create(create) {}
  };
  std::map<std::string, PassInfo> passInfos;
};

//
// Utility class to register a pass. See pass files for usage.
//
template<class P>
struct RegisterPass {
  RegisterPass(const char* name, const char *description) {
    PassRegistry::get()->registerPass(name, description, []() {
      return new P();
    });
  }
};

//
// Runs a set of passes, in order
//
struct PassRunner {
  MixedArena* allocator;
  std::vector<Pass*> passes;
  Pass* currPass;

  PassRunner(MixedArena* allocator) : allocator(allocator) {}

  void add(std::string passName);

  template<class P>
  void add();

  void run(Module* module);

  // Get the last pass that was already executed of a certain type.
  template<class P>
  P* getLast();

  ~PassRunner();
};

//
// Core pass class
//
class Pass : public WasmWalker {
 public:
  // Override this to perform preparation work before the pass runs
  virtual void prepare(PassRunner* runner, Module* module) {}

  void run(PassRunner* runner, Module* module) {
    prepare(runner, module);
    startWalk(module);
  }
};

// Standard passes. All passes in /passes/ are runnable from the shell,
// but registering them here in addition allows them to communicate
// e.g. through PassRunner::getLast

// Handles names in a module, in particular adding names without duplicates
class NameManager : public Pass {
 public:
  Name getUnique(std::string prefix);
  // TODO: getUniqueInFunction

  // visitors
  void visitBlock(Block* curr) override;
  void visitLoop(Loop* curr) override;
  void visitBreak(Break* curr) override;
  void visitSwitch(Switch* curr) override;
  void visitCall(Call* curr) override;
  void visitCallImport(CallImport* curr) override;
  void visitFunctionType(FunctionType* curr) override;
  void visitFunction(Function* curr) override;
  void visitImport(Import* curr) override;
  void visitExport(Export* curr) override;

private:
  std::set<Name> names;
  size_t counter = 0;
};

} // namespace wasm

#endif // wasm_pass_h
