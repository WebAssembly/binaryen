/*
 * Copyright 2026 WebAssembly Community Group participants
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

#ifndef wasm_wasm2c_wasm2c_builder_h
#define wasm_wasm2c_wasm2c_builder_h

#include <iostream>
#include <string>

#include "parser/wat-parser.h"
#include "parsing.h"
#include "pass.h"
#include "wasm-io.h"
#include "wasm-validator.h"
#include "wasm.h"

namespace wasm {

class Wasm2CBuilder {
public:
  struct Flags {
    bool debug = false;
    std::string moduleName = "";
    std::string headerName = "";
  };

  Wasm2CBuilder(Flags f) : flags(f) {}

  void processWasm(Module* wasm, std::ostream& cOut, std::ostream& hOut);

private:
  Flags flags;
  Module* module = nullptr;
};

} // namespace wasm

#endif // wasm_wasm2c_wasm2c_builder_h
