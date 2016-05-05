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
#include "wasm-traversal.h"
#include "mixed_arena.h"
#include "support/utilities.h"

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
  Module* wasm;
  MixedArena* allocator;
  std::vector<Pass*> passes;
  Pass* currPass;
  bool debug = false;

  PassRunner(Module* wasm) : wasm(wasm), allocator(&wasm->allocator) {}

  void setDebug(bool debug_) { debug = debug_; }

  void add(std::string passName) {
    auto pass = PassRegistry::get()->createPass(passName);
    if (!pass) Fatal() << "Could not find pass: " << passName << "\n";
    passes.push_back(pass);
  }

  template<class P>
  void add() {
    passes.push_back(new P());
  }

  template<class P, class Arg>
  void add(Arg& arg){
    passes.push_back(new P(arg));
  }

  // Adds the default set of optimization passes; this is
  // what -O does.
  void addDefaultOptimizationPasses();

  void run();

  // Get the last pass that was already executed of a certain type.
  template<class P>
  P* getLast();

  ~PassRunner();
};

//
// Core pass class
//
class Pass {
public:
  virtual ~Pass() {};
  // Override this to perform preparation work before the pass runs.
  virtual void prepare(PassRunner* runner, Module* module) {}
  virtual void run(PassRunner* runner, Module* module) = 0;
  // Override this to perform finalization work after the pass runs.
  virtual void finalize(PassRunner* runner, Module* module) {}

  std::string name;

protected:
  Pass() {}
  Pass(Pass &) {}
  Pass &operator=(const Pass&) = delete;
};

//
// Core pass class that uses AST walking. This class can be parameterized by
// different types of AST walkers.
//
template <typename WalkerType>
class WalkerPass : public Pass, public WalkerType {
public:
  void run(PassRunner* runner, Module* module) override {
    prepare(runner, module);
    WalkerType::startWalk(module);
    finalize(runner, module);
  }
};

// Standard passes. All passes in /passes/ are runnable from the shell,
// but registering them here in addition allows them to communicate
// e.g. through PassRunner::getLast

// Handles names in a module, in particular adding names without duplicates
class NameManager : public WalkerPass<PostWalker<NameManager, Visitor<NameManager>>> {
 public:
  Name getUnique(std::string prefix);
  // TODO: getUniqueInFunction

  // visitors
  void visitBlock(Block* curr);
  void visitLoop(Loop* curr);
  void visitBreak(Break* curr);
  void visitSwitch(Switch* curr);
  void visitCall(Call* curr);
  void visitCallImport(CallImport* curr);
  void visitFunctionType(FunctionType* curr);
  void visitFunction(Function* curr);
  void visitImport(Import* curr);
  void visitExport(Export* curr);

private:
  std::set<Name> names;
  size_t counter = 0;
};

// Prints out a module
class Printer : public Pass {
protected:
  std::ostream& o;

public:
  Printer() : o(std::cout) {}
  Printer(std::ostream& o) : o(o) {}

  void run(PassRunner* runner, Module* module) override;
};

} // namespace wasm

#endif // wasm_pass_h
