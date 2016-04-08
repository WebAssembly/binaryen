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

#ifndef wasm_ast_utils_h
#define wasm_ast_utils_h

#include "wasm.h"
#include "wasm-traversal.h"

namespace wasm {

struct BreakSeeker : public WasmWalker<BreakSeeker> {
  Name target; // look for this one
  size_t found;

  BreakSeeker(Name target) : target(target), found(false) {}

  void visitBreak(Break *curr) {
    if (curr->name == target) found++;
  }

  static bool has(Expression* tree, Name target) {
    BreakSeeker breakSeeker(target);
    breakSeeker.walk(tree);
    return breakSeeker.found > 0;
  }
};

// Look for side effects, including control flow
// TODO: look at individual locals

struct EffectAnalyzer : public WasmWalker<EffectAnalyzer> {
  bool branches = false;
  bool calls = false;
  bool readsLocal = false;
  bool writesLocal = false;
  bool readsMemory = false;
  bool writesMemory = false;

  bool accessesLocal() { return readsLocal || writesLocal; }
  bool accessesMemory() { return calls || readsMemory || writesMemory; }
  bool hasSideEffects() { return calls || writesLocal || writesMemory; }

  // checks if these effects would invalidate another set (e.g., if we write, we invalidate someone that reads, they can't be moved past us)
  bool invalidates(EffectAnalyzer& other) {
    return branches || other.branches
                    || ((writesMemory || calls) && other.accessesMemory())       || (writesLocal && other.accessesLocal())
                    || (accessesMemory() && (other.writesMemory || other.calls)) || (accessesLocal() && other.writesLocal);
  }

  void visitBlock(Block *curr) { branches = true; }
  void visitIf(If *curr) { branches = true; }
  void visitBreak(Break *curr) { branches = true; }
  void visitSwitch(Switch *curr) { branches = true; }
  void visitCall(Call *curr) { calls = true; }
  void visitCallImport(CallImport *curr) { calls = true; }
  void visitCallIndirect(CallIndirect *curr) { calls = true; }
  void visitGetLocal(GetLocal *curr) { readsLocal = true; }
  void visitSetLocal(SetLocal *curr) { writesLocal = true; }
  void visitLoad(Load *curr) { readsMemory = true; }
  void visitStore(Store *curr) { writesMemory = true; }
  void visitReturn(Return *curr) { branches = true; }
  void visitHost(Host *curr) { calls = true; }
  void visitUnreachable(Unreachable *curr) { branches = true; }
};

struct ExpressionManipulator {
  // Nop is the smallest node, so we can always nop-ify another node in our arena
  static void nop(Expression* target) {
    *static_cast<Nop*>(target) = Nop();
  }
};

} // namespace wasm

#endif // wasm_ast_utils_h
