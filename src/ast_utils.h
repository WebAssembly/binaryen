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

struct BreakSeeker : public PostWalker<BreakSeeker, Visitor<BreakSeeker>> {
  Name target; // look for this one XXX looking by name may fall prey to duplicate names
  size_t found;

  BreakSeeker(Name target) : target(target), found(false) {}

  void visitBreak(Break *curr) {
    if (curr->name == target) found++;
  }

  void visitSwitch(Switch *curr) {
    for (auto name : curr->targets) {
      if (name == target) found++;
    }
    if (curr->default_ == target) found++;
  }

  static bool has(Expression* tree, Name target) {
    BreakSeeker breakSeeker(target);
    breakSeeker.walk(tree);
    return breakSeeker.found > 0;
  }
};

// Look for side effects, including control flow
// TODO: optimize

struct EffectAnalyzer : public PostWalker<EffectAnalyzer, Visitor<EffectAnalyzer>> {
  EffectAnalyzer() {}
  EffectAnalyzer(Expression *ast) {
    walk(ast);
    // if we are left with breaks, they are external
    if (breakNames.size() > 0) branches = true;
  }

  bool branches = false; // branches out of this expression
  bool calls = false;
  std::set<Index> localsRead;
  std::set<Index> localsWritten;
  bool readsMemory = false;
  bool writesMemory = false;

  bool accessesLocal() { return localsRead.size() + localsWritten.size() > 0; }
  bool accessesMemory() { return calls || readsMemory || writesMemory; }
  bool hasSideEffects() { return calls || localsWritten.size() > 0 || writesMemory || branches; }
  bool hasAnything() { return branches || calls || accessesLocal() || readsMemory || writesMemory; }

  // checks if these effects would invalidate another set (e.g., if we write, we invalidate someone that reads, they can't be moved past us)
  bool invalidates(EffectAnalyzer& other) {
    if (branches || other.branches
                 || ((writesMemory || calls) && other.accessesMemory())
                 || (accessesMemory() && (other.writesMemory || other.calls))) {
      return true;
    }
    assert(localsWritten.size() + localsRead.size() <= 1); // the code below is fast on that case, of one element vs many
    for (auto local : localsWritten) {
      if (other.localsWritten.count(local) || other.localsRead.count(local)) {
        return true;
      }
    }
    for (auto local : localsRead) {
      if (other.localsWritten.count(local)) return true;
    }
    return false;
  }

  // the checks above happen after the node's children were processed, in the order of execution
  // we must also check for control flow that happens before the children, i.e., loops
  bool checkPre(Expression* curr) {
    if (curr->is<Loop>()) {
      branches = true;
      return true;
    }
    return false;
  }

  bool checkPost(Expression* curr) {
    visit(curr);
    return hasAnything();
  }

  std::set<Name> breakNames;

  void visitBreak(Break *curr) {
    breakNames.insert(curr->name);
  }
  void visitSwitch(Switch *curr) {
    for (auto name : curr->targets) {
      breakNames.insert(name);
    }
    breakNames.insert(curr->default_);
  }
  void visitBlock(Block* curr) {
    if (curr->name.is()) breakNames.erase(curr->name); // these were internal breaks
  }
  void visitLoop(Loop* curr) {
    if (curr->in.is()) breakNames.erase(curr->in); // these were internal breaks
    if (curr->out.is()) breakNames.erase(curr->out); // these were internal breaks
  }

  void visitCall(Call *curr) { calls = true; }
  void visitCallImport(CallImport *curr) { calls = true; }
  void visitCallIndirect(CallIndirect *curr) { calls = true; }
  void visitGetLocal(GetLocal *curr) {
    localsRead.insert(curr->index);
  }
  void visitSetLocal(SetLocal *curr) {
    localsWritten.insert(curr->index);
  }
  void visitLoad(Load *curr) { readsMemory = true; }
  void visitStore(Store *curr) { writesMemory = true; }
  void visitReturn(Return *curr) { branches = true; }
  void visitHost(Host *curr) { calls = true; }
  void visitUnreachable(Unreachable *curr) { branches = true; }
};

// Meausure the size of an AST
struct Measurer : public PostWalker<Measurer, UnifiedExpressionVisitor<Measurer>> {
  size_t size = 0;

  void visitExpression(Expression* curr) {
    size++;
  }

  static bool measure(Expression* tree) {
    Measurer measurer;
    measurer.walk(tree);
    return !!measurer.size;
  }
};

// Manipulate expressions

struct ExpressionManipulator {
  // Re-use a node's memory. This helps avoid allocation when optimizing.
  template<typename InputType, typename OutputType>
  static OutputType* convert(InputType *input) {
    static_assert(sizeof(OutputType) <= sizeof(InputType),
                  "Can only convert to a smaller size Expression node");
    input->~InputType(); // arena-allocaed, so no destructor, but avoid UB.
    OutputType* output = (OutputType*)(input);
    new (output) OutputType;
    return output;
  }

  // Convenience method for nop, which is a common conversion
  template<typename InputType>
  static void nop(InputType* target) {
    convert<InputType, Nop>(target);
  }

  // Convert a node that allocates
  template<typename InputType, typename OutputType>
  static OutputType* convert(InputType *input, MixedArena& allocator) {
    assert(sizeof(OutputType) <= sizeof(InputType));
    input->~InputType(); // arena-allocaed, so no destructor, but avoid UB.
    OutputType* output = (OutputType*)(input);
    new (output) OutputType(allocator);
    return output;
  }
};

struct ExpressionAnalyzer {
  // Given a stack of expressions, checks if the topmost is used as a result.
  // For example, if the parent is a block and the node is before the last position,
  // it is not used.
  static bool isResultUsed(std::vector<Expression*> stack, Function* func) {
    for (int i = int(stack.size()) - 2; i >= 0; i--) {
      auto* curr = stack[i];
      auto* above = stack[i + 1];
      // only if and block can drop values
      if (curr->is<Block>()) {
        auto* block = curr->cast<Block>();
        for (size_t j = 0; j < block->list.size() - 1; j++) {
          if (block->list[j] == above) return false;
        }
        assert(block->list.back() == above);
        // continue down
      } else if (curr->is<If>()) {
        auto* iff = curr->cast<If>();
        if (above == iff->condition) return true;
        if (!iff->ifFalse) return false;
        assert(above == iff->ifTrue || above == iff->ifFalse);
        // continue down
      } else {
        return true; // all other node types use the result
      }
    }
    // The value might be used, so it depends on if the function returns
    return func->result != none;
  }
};

} // namespace wasm

#endif // wasm_ast_utils_h
