/*
 * Copyright 2020 WebAssembly Community Group participants
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

// TODO: documentation

#include "ir/properties.h"
#include "pass.h"
#include "wasm-stack.h"

namespace wasm {

namespace {

struct Poppifier : PostWalker<Poppifier> {
  bool scanned = false;
  MixedArena& allocator;
  Poppifier(MixedArena& allocator) : allocator(allocator) {}

  static void scan(Poppifier* self, Expression** currp) {
    if (!self->scanned) {
      self->scanned = true;
      PostWalker<Poppifier>::scan(self, currp);
    } else {
      *currp = Builder(self->allocator).makePop((*currp)->type);
    }
  }

  // Replace the children of `expr` with pops.
  void poppify(Expression* expr) {
    scanned = false;
    walk(expr);
  }
};

struct Scope {
  enum Kind { Func, Block, Loop, If, Else, Try, Catch } kind;
  std::vector<Expression*> instrs;
  Scope(Kind kind) : kind(kind) {}
};

struct Stackifier : BinaryenIRWriter<Stackifier> {
  MixedArena& allocator;
  std::vector<Scope> scopeStack;

  Stackifier(Function* func, MixedArena& allocator)
    : BinaryenIRWriter<Stackifier>(func), allocator(allocator) {
    // Start with a scope to emit top-level instructions into
    scopeStack.emplace_back(Scope::Func);
  }

  void patchInstrs(Expression*& expr, const std::vector<Expression*>& instrs) {
    if (instrs.size() == 1) {
      expr = instrs[0];
    } else if (auto* block = expr->dynCast<Block>()) {
      block->list.set(instrs);
    } else {
      expr = Builder(allocator).makeBlock(instrs);
    }
  }

  void emit(Expression* curr) {
    // Control flow structures introduce new scopes. The instructions collected
    // for the new scope will be patched back into the original Expression when
    // the scope ends.
    if (Properties::isControlFlowStructure(curr)) {
      Scope::Kind kind;
      switch (curr->_id) {
        case Expression::BlockId:
          kind = Scope::Block;
          break;
        case Expression::LoopId:
          kind = Scope::Loop;
          break;
        case Expression::IfId:
          // The condition has already been emitted
          curr->cast<If>()->condition = Builder(allocator).makePop(Type::i32);
          kind = Scope::If;
          break;
        case Expression::TryId:
          kind = Scope::Try;
          break;
        default:
          WASM_UNREACHABLE("Unexpected control flow structure");
      }
      scopeStack.emplace_back(kind);
    } else {
      // TODO: Lower tuple instructions
      // Replace all children (which have already been emitted) with pops and
      // emit the current instruction into the current scope.
      Poppifier(allocator).poppify(curr);
      scopeStack.back().instrs.push_back(curr);
    }
  };

  void emitHeader() {}

  void emitIfElse(If* curr) {
    auto& scope = scopeStack.back();
    assert(scope.kind == Scope::If);
    patchInstrs(curr->ifTrue, scope.instrs);
    scope.instrs.clear();
    scope.kind = Scope::Else;
  }

  void emitCatch(Try* curr) {
    auto& scope = scopeStack.back();
    assert(scope.kind == Scope::Try);
    patchInstrs(curr->body, scope.instrs);
    scope.instrs.clear();
    scope.kind = Scope::Catch;
  }

  void emitScopeEnd(Expression* curr) {
    auto& scope = scopeStack.back();
    switch (scope.kind) {
      case Scope::Block:
        patchInstrs(curr, scope.instrs);
        break;
      case Scope::Loop:
        patchInstrs(curr->cast<Loop>()->body, scope.instrs);
        break;
      case Scope::If:
        patchInstrs(curr->cast<If>()->ifTrue, scope.instrs);
        break;
      case Scope::Else:
        patchInstrs(curr->cast<If>()->ifFalse, scope.instrs);
        break;
      case Scope::Catch:
        patchInstrs(curr->cast<Try>()->catchBody, scope.instrs);
        break;
      case Scope::Try:
        WASM_UNREACHABLE("try without catch");
      case Scope::Func:
        WASM_UNREACHABLE("unexpected end of function");
    }
    scopeStack.pop_back();
    scopeStack.back().instrs.push_back(curr);
  }

  void emitFunctionEnd() {
    auto& scope = scopeStack.back();
    assert(scope.kind == Scope::Func);
    // If there is only one instruction, it must already be the body so patching
    // it into itself could cause a cycle in the IR. But if there are multiple
    // instructions because the top-level expression in the original IR was not
    // a block, they need to be injected into a new block.
    if (scope.instrs.size() > 1) {
      patchInstrs(func->body, scope.instrs);
    } else if (scope.instrs.size() == 1) {
      assert(func->body == scope.instrs[0] ||
             (func->body->cast<Block>()->list.size() == 1 &&
              func->body->cast<Block>()->list[0] == scope.instrs[0]));
    }
  }

  void emitUnreachable() {
    scopeStack.back().instrs.push_back(Builder(allocator).makeUnreachable());
  }

  void emitDebugLocation(Expression* curr) {}
};

} // anonymous namespace

class StackifyPass : public Pass {
  bool isFunctionParallel() override { return true; }
  void
  runOnFunction(PassRunner* runner, Module* module, Function* func) override {
    if (!func->isStacky) {
      Stackifier(func, module->allocator).write();
      func->isStacky = true;
    }
  }
  Pass* create() override { return new StackifyPass(); }
};

Pass* createStackifyPass() { return new StackifyPass(); }

} // namespace wasm
