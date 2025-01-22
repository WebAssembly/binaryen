/*
 * Copyright 2025 WebAssembly Community Group participants
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

#ifndef interpreter_store_h
#define interpreter_store_h

#include <cassert>
#include <vector>

#include "expression-iterator.h"
#include "literal.h"

namespace wasm::interpreter {

// A frame of execution for a function call.
struct Frame {
  // TODO: Reference to current instance to find referenced functions, globals,
  // tables, memories, etc.

  std::vector<Literal> locals;
  std::vector<Literal> valueStack;
  ExpressionIterator exprs;

  // TODO: Map loops to ExpressionIterators so we can branch backwards.

  // Helpers to push and pop the current value stack.
  Literal pop() {
    assert(valueStack.size());
    Literal val = valueStack.back();
    valueStack.pop_back();
    return val;
  }

  void push(Literal val) { valueStack.push_back(val); }
};

// The WebAssembly store, which maintains the state for a universe of linked
// WebAssembly instances.
// TODO: generalize this so different users can override memory loads and
// stores, etc.
struct WasmStore {
  // TODO: Storage for memories, tables, globals, heap objects, etc.
  // TODO: Map instances and import names to other instances to find imports.
  std::vector<Frame> callStack;

  Frame& getFrame() {
    assert(!callStack.empty());
    return callStack.back();
  }

  // Helpers to push and pop the current value stack.
  Literal pop() { return getFrame().pop(); }
  void push(Literal val) { getFrame().push(val); }
};

} // namespace wasm::interpreter

#endif // interpreter_store_h
