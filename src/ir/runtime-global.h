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

#ifndef wasm_ir_runtime_global_h
#define wasm_ir_runtime_global_h

#include "literal.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

class RuntimeGlobal {
public:
  RuntimeGlobal(Type type, Mutability mutable_, Literals literals = {})
    : literals(literals), type(type), mutable_(mutable_) {}

  Literals literals;

  Type getType() const { return type; }
  Mutability getMutable() const { return mutable_; }

  bool isSubType(const Global& global) const;

private:
  const Type type;
  const Mutability mutable_;
};

} // namespace wasm

#endif // wasm_ir_runtime_global_h
