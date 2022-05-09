/*
 * Copyright 2017 WebAssembly Community Group participants
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

#ifndef wasm_ir_trapping_h
#define wasm_ir_trapping_h

#include <exception>

#include "pass.h"

namespace wasm {

enum class TrapMode { Allow, Clamp, JS };

inline void addTrapModePass(PassRunner& runner, TrapMode trapMode) {
  if (trapMode == TrapMode::Clamp) {
    runner.add("trap-mode-clamp");
  } else if (trapMode == TrapMode::JS) {
    runner.add("trap-mode-js");
  }
}

class TrappingFunctionContainer {
public:
  TrappingFunctionContainer(TrapMode mode, Module& wasm, bool immediate = false)
    : mode(mode), wasm(wasm), immediate(immediate) {}

  bool hasFunction(Name name) {
    return functions.find(name) != functions.end();
  }
  bool hasImport(Name name) { return imports.find(name) != imports.end(); }

  void addFunction(Function* function) {
    functions[function->name] = function;
    if (immediate) {
      wasm.addFunction(function);
    }
  }
  void addImport(Function* import) {
    imports[import->name] = import;
    if (immediate) {
      wasm.addFunction(import);
    }
  }

  void addToModule() {
    if (!immediate) {
      for (auto& [_, func] : functions) {
        wasm.addFunction(func);
      }
      for (auto& [_, func] : imports) {
        wasm.addFunction(func);
      }
    }
    functions.clear();
    imports.clear();
  }

  TrapMode getMode() { return mode; }

  Module& getModule() { return wasm; }

  std::map<Name, Function*>& getFunctions() { return functions; }

private:
  std::map<Name, Function*> functions;
  std::map<Name, Function*> imports;

  TrapMode mode;
  Module& wasm;
  bool immediate;
};

Expression* makeTrappingBinary(Binary* curr,
                               TrappingFunctionContainer& trappingFunctions);
Expression* makeTrappingUnary(Unary* curr,
                              TrappingFunctionContainer& trappingFunctions);

inline TrapMode trapModeFromString(std::string const& str) {
  if (str == "allow") {
    return TrapMode::Allow;
  } else if (str == "clamp") {
    return TrapMode::Clamp;
  } else if (str == "js") {
    return TrapMode::JS;
  } else {
    throw std::invalid_argument(
      "Unsupported trap mode \"" + str +
      "\". "
      "Valid modes are \"allow\", \"js\", and \"clamp\"");
  }
}

} // namespace wasm

#endif // wasm_ir_trapping_h
