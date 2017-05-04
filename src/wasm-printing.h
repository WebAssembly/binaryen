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

#ifndef wasm_wasm_printing_h
#define wasm_wasm_printing_h

#include <ostream>

#include "wasm.h"
#include "pass.h"

namespace wasm {

struct WasmPrinter {
  static std::ostream& printModule(Module* module, std::ostream& o) {
    PassRunner passRunner(module);
    passRunner.setIsNested(true);
    passRunner.add<Printer>(&o);
    passRunner.run();
    return o;
  }

  static std::ostream& printModule(Module* module) {
    return printModule(module, std::cout);
  }

  static std::ostream& printExpression(Expression* expression, std::ostream& o, bool minify = false, bool full = false);
};

}

namespace std {

inline std::ostream& operator<<(std::ostream& o, wasm::Module* module) {
  return wasm::WasmPrinter::printModule(module, o);
}

inline std::ostream& operator<<(std::ostream& o, wasm::Expression* expression) {
  return wasm::WasmPrinter::printExpression(expression, o);
}

}

#endif // wasm_wasm_printing_h
