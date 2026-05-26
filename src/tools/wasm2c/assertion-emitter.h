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

#ifndef wasm_tools_wasm2c_assertion_emitter_h
#define wasm_tools_wasm2c_assertion_emitter_h

#include <string>

#include "parser/wat-parser.h"
#include "pass.h"
#include "tools/wasm2c/wasm2c-builder.h"

namespace wasm {

class AssertionEmitter {
public:
  AssertionEmitter(WATParser::WASTScript& script,
                   Wasm2CBuilder::Flags flags,
                   const PassOptions& options);

  void emit(std::ostream& cOut, const std::string& outputCPath);

private:
  WATParser::WASTScript& script;
  Wasm2CBuilder::Flags flags;
  PassOptions options;

  size_t moduleCounter = 0;
};

} // namespace wasm

#endif // wasm_tools_wasm2c_assertion_emitter_h
