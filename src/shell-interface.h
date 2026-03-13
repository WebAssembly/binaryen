/*
 * Copyright 2016 WebAssembly Community Group participants
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
// Implementation of the shell interpreter execution environment
//

#ifndef wasm_shell_interface_h
#define wasm_shell_interface_h

#include "asmjs/shared-constants.h"
#include "interpreter/exception.h"
#include "ir/module-utils.h"
#include "shared-constants.h"
#include "support/name.h"
#include "support/utilities.h"
#include "wasm-interpreter.h"
#include "wasm.h"

namespace wasm {

struct ShellExternalInterface : ModuleRunner::ExternalInterface {
  std::map<Name, std::shared_ptr<ModuleRunner>> linkedInstances;

  ShellExternalInterface(
    std::map<Name, std::shared_ptr<ModuleRunner>> linkedInstances_ = {}) {
    linkedInstances.swap(linkedInstances_);
  }
  virtual ~ShellExternalInterface() = default;

  ModuleRunner* getImportInstanceOrNull(Importable* import) {
    auto it = linkedInstances.find(import->module);
    if (it == linkedInstances.end()) {
      return nullptr;
    }
    return it->second.get();
  }

  ModuleRunner* getImportInstance(Importable* import) {
    auto* ret = getImportInstanceOrNull(import);
    if (!ret) {
      Fatal() << "getImportInstance: unknown import: " << import->module.str
              << "." << import->base.str;
    }
    return ret;
  }

  Literal getImportedFunction(Function* import) override {
    // TODO: We should perhaps restrict the types with which the well-known
    // functions can be imported.
    if (import->module == SPECTEST && import->base.startsWith(PRINT)) {
      // Use a null instance because these are host functions.
      return Literal(
        std::make_shared<FuncData>(import->name,
                                   nullptr,
                                   [](const Literals& arguments) -> Flow {
                                     for (auto argument : arguments) {
                                       std::cout << argument << " : "
                                                 << argument.type << '\n';
                                     }
                                     return Flow();
                                   }),
        import->type);
    } else if (import->module == ENV && import->base == EXIT) {
      return Literal(std::make_shared<FuncData>(import->name,
                                                nullptr,
                                                [](const Literals&) -> Flow {
                                                  // XXX hack for torture tests
                                                  std::cout << "exit()\n";
                                                  throw ExitException();
                                                }),
                     import->type);
    } else if (auto* inst = getImportInstanceOrNull(import)) {
      return inst->getExportedFunction(import->base);
    }
    // This is not a known import. Create a literal for it, which is good enough
    // if it is never called (see the ref_func.wast spec test, which does that).
    std::cerr << "warning: getImportedFunction: unknown import: "
              << import->module.str << "." << import->name.str << '\n';
    return Literal::makeFunc(import->name, import->type);
  }

  void trap(std::string_view why) override {
    std::cout << "[trap " << why << "]\n";
    throw TrapException();
  }

  void hostLimit(std::string_view why) override {
    std::cout << "[host limit " << why << "]\n";
    throw HostLimitException();
  }
  void throwException(const WasmException& exn) override { throw exn; }
};

} // namespace wasm

#endif // wasm_shell_interface_h
