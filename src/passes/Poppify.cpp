/*
 * Copyright 2021 WebAssembly Community Group participants
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

// Poppify.cpp - Transform Binaryen IR to Poppy IR.
//
// Poppy IR represents stack machine code using normal Binaryen IR types by
// imposing the following constraints:
//
//  1. Function bodies and children of control flow (except If conditions) must
//     be blocks.
//
//  2. Blocks may have any Expressions as children. The sequence of instructions
//     in a block follows the same validation rules as in WebAssembly. That
//     means that any expression may have a concrete type, not just the final
//     expression in the block.
//
//  3. All other children must be Pops, which are used to determine the input
//     stack type of each instruction. Pops may not have `unreachable` type.
//     Pops must correspond to the results of previous expressions or block
//     inputs in a stack discipline.
//
//  4. Only control flow structures and instructions that have polymorphic
//     unreachable behavior in WebAssembly may have unreachable type. Blocks may
//     be unreachable when they are not branch targets and when they have an
//     unreachable child. Note that this means a block may be unreachable even
//     if it would otherwise have a concrete type, unlike in Binaryen IR. For
//     example, this block could have unreachable type in Poppy IR but would
//     have to have type i32 in Binaryen IR:
//
//       (block
//         (unreachable)
//         (i32.const 1)
//       )
//
// As an example of Poppification, the following Binaryen IR Function:
//
//   (func $foo (result i32)
//    (i32.add
//     (i32.const 42)
//     (i32.const 5)
//    )
//   )
//
// would look like this in Poppy IR:
//
//   (func $foo (result i32)
//    (block
//     (i32.const 42)
//     (i32.const 5)
//     (i32.add
//      (pop i32)
//      (pop i32)
//     )
//    )
//   )
//
// Notice that the sequence of instructions in the block is now identical to the
// sequence of instructions in a WebAssembly binary. Also note that Poppy IR's
// validation rules are largely additional on top of the normal Binaryen IR
// validation rules, with the only exceptions being block body validation and
// block unreachability rules.
//

#include "ir/names.h"
#include "ir/properties.h"
#include "ir/stack-utils.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-stack.h"

namespace wasm {

namespace {

// Generate names for the elements of tuple globals
Name getGlobalElem(Module* module, Name global, Index i) {
  return Names::getValidGlobalName(*module,
                                   global.toString() + '$' + std::to_string(i));
}

struct Poppifier : BinaryenIRWriter<Poppifier> {
  // Collects instructions to be inserted into a block at a certain scope, as
  // well as what kind of scope it is, which determines how the instructions are
  // inserted.
  struct Scope {
    enum Kind { Func, Block, Loop, If, Else, Try, Catch } kind;
    std::vector<Expression*> instrs;
    Scope(Kind kind) : kind(kind) {}
  };

  Module* module;
  Builder builder;
  std::vector<Scope> scopeStack;

  // Maps tuple locals to the new locals that will hold their elements
  std::unordered_map<Index, std::vector<Index>> tupleVars;

  // Records the scratch local to be used for tuple.extracts of each type
  std::unordered_map<Type, Index> scratchLocals;

  Poppifier(Function* func, Module* module);

  Index getScratchLocal(Type type);

  // Replace `expr`'s children with Pops of the correct type.
  void poppify(Expression* expr);

  // Pops the current scope off the scope stack and replaces `expr` with a block
  // containing the instructions from that scope.
  void patchScope(Expression*& expr);

  // BinaryenIRWriter methods
  void emit(Expression* curr);
  void emitHeader() {}
  void emitIfElse(If* curr);
  void emitCatch(Try* curr, Index i);
  void emitCatchAll(Try* curr);
  void emitDelegate(Try* curr);
  void emitScopeEnd(Expression* curr);
  void emitFunctionEnd();
  void emitUnreachable();
  void emitDebugLocation(Expression* curr) {}

  // Tuple lowering methods
  void emitTupleExtract(TupleExtract* curr);
  void emitDrop(Drop* curr);
  void emitLocalGet(LocalGet* curr);
  void emitLocalSet(LocalSet* curr);
  void emitGlobalGet(GlobalGet* curr);
  void emitGlobalSet(GlobalSet* curr);
};

Poppifier::Poppifier(Function* func, Module* module)
  : BinaryenIRWriter<Poppifier>(func), module(module), builder(*module) {
  // Start with a scope to emit top-level instructions into
  scopeStack.emplace_back(Scope::Func);

  // Map each tuple local to a set of expanded locals
  for (Index i = func->getNumParams(), end = func->getNumLocals(); i < end;
       ++i) {
    Type localType = func->getLocalType(i);
    if (localType.isTuple()) {
      auto& vars = tupleVars[i];
      for (auto type : localType) {
        vars.push_back(builder.addVar(func, type));
      }
    }
  }
}

Index Poppifier::getScratchLocal(Type type) {
  // If there is no scratch local for `type`, allocate a new one
  auto insert = scratchLocals.insert({type, Index(-1)});
  if (insert.second) {
    insert.first->second = builder.addVar(func, type);
  }
  return insert.first->second;
}

void Poppifier::patchScope(Expression*& expr) {
  auto scope = std::move(scopeStack.back());
  auto& instrs = scope.instrs;
  scopeStack.pop_back();
  if (auto* block = expr->dynCast<Block>()) {
    // Reuse blocks, but do not patch a block into itself, which would otherwise
    // happen when emitting if/else or try/catch arms and function bodies.
    if (instrs.size() == 0 || instrs[0] != block) {
      block->list.set(instrs);
    }
  } else {
    // Otherwise create a new block, even if we have just a single
    // expression. We want blocks in every new scope rather than other
    // instructions because Poppy IR optimizations only look at the children of
    // blocks.
    expr = builder.makeBlock(instrs, expr->type);
  }
}

void Poppifier::emit(Expression* curr) {
  // Control flow structures introduce new scopes. The instructions collected
  // for the new scope will be patched back into the original Expression when
  // the scope ends.
  if (Properties::isControlFlowStructure(curr)) {
    Scope::Kind kind;
    switch (curr->_id) {
      case Expression::BlockId: {
        kind = Scope::Block;
        break;
      }
      case Expression::LoopId: {
        kind = Scope::Loop;
        break;
      }
      case Expression::IfId:
        // The condition has already been emitted
        curr->cast<If>()->condition = builder.makePop(Type::i32);
        kind = Scope::If;
        break;
      case Expression::TryId:
        kind = Scope::Try;
        break;
      default:
        WASM_UNREACHABLE("Unexpected control flow structure");
    }
    scopeStack.emplace_back(kind);
  } else if (curr->is<Pop>()) {
    // Turns into nothing when poppified
    return;
  } else if (curr->is<TupleMake>()) {
    // Turns into nothing when poppified
    return;
  } else if (auto* extract = curr->dynCast<TupleExtract>()) {
    emitTupleExtract(extract);
  } else if (auto* drop = curr->dynCast<Drop>()) {
    emitDrop(drop);
  } else if (auto* get = curr->dynCast<LocalGet>()) {
    emitLocalGet(get);
  } else if (auto* set = curr->dynCast<LocalSet>()) {
    emitLocalSet(set);
  } else if (auto* get = curr->dynCast<GlobalGet>()) {
    emitGlobalGet(get);
  } else if (auto* set = curr->dynCast<GlobalSet>()) {
    emitGlobalSet(set);
  } else {
    // Replace all children (which have already been emitted) with pops and emit
    // the current instruction into the current scope.
    poppify(curr);
    scopeStack.back().instrs.push_back(curr);
  }
};

void Poppifier::emitIfElse(If* curr) {
  [[maybe_unused]] auto& scope = scopeStack.back();
  assert(scope.kind == Scope::If);
  patchScope(curr->ifTrue);
  scopeStack.emplace_back(Scope::Else);
}

void Poppifier::emitCatch(Try* curr, Index i) {
  [[maybe_unused]] auto& scope = scopeStack.back();
  if (i == 0) {
    assert(scope.kind == Scope::Try);
    patchScope(curr->body);
  } else {
    assert(scope.kind == Scope::Catch);
    patchScope(curr->catchBodies[i - 1]);
  }
  scopeStack.emplace_back(Scope::Catch);
}

void Poppifier::emitCatchAll(Try* curr) {
  [[maybe_unused]] auto& scope = scopeStack.back();
  if (curr->catchBodies.size() == 1) {
    assert(scope.kind == Scope::Try);
    patchScope(curr->body);
  } else {
    assert(scope.kind == Scope::Catch);
    patchScope(curr->catchBodies[curr->catchBodies.size() - 2]);
  }
  scopeStack.emplace_back(Scope::Catch);
}

void Poppifier::emitDelegate(Try* curr) {
  [[maybe_unused]] auto& scope = scopeStack.back();
  assert(scope.kind == Scope::Try);
  patchScope(curr->body);
  scopeStack.back().instrs.push_back(curr);
}

void Poppifier::emitScopeEnd(Expression* curr) {
  switch (scopeStack.back().kind) {
    case Scope::Block:
      patchScope(curr);
      break;
    case Scope::Loop:
      patchScope(curr->cast<Loop>()->body);
      break;
    case Scope::If:
      patchScope(curr->cast<If>()->ifTrue);
      break;
    case Scope::Else:
      patchScope(curr->cast<If>()->ifFalse);
      break;
    case Scope::Catch:
      patchScope(curr->cast<Try>()->catchBodies.back());
      break;
    case Scope::Try:
      WASM_UNREACHABLE("try without catch");
    case Scope::Func:
      WASM_UNREACHABLE("unexpected end of function");
  }
  scopeStack.back().instrs.push_back(curr);
}

void Poppifier::emitFunctionEnd() {
  [[maybe_unused]] auto& scope = scopeStack.back();
  assert(scope.kind == Scope::Func);
  patchScope(func->body);
}

void Poppifier::emitUnreachable() {
  // TODO: Try making this a nop
  auto& instrs = scopeStack.back().instrs;
  instrs.push_back(builder.makeUnreachable());
}

void Poppifier::emitTupleExtract(TupleExtract* curr) {
  auto& instrs = scopeStack.back().instrs;
  auto types = curr->tuple->type;
  // Drop all the values after the one we want
  for (size_t i = types.size() - 1; i > curr->index; --i) {
    instrs.push_back(builder.makeDrop(builder.makePop(types[i])));
  }
  // If the extracted value is the only one left, we're done
  if (curr->index == 0) {
    return;
  }
  // Otherwise, save it to a scratch local and drop the other values
  auto type = types[curr->index];
  Index scratch = getScratchLocal(type);
  instrs.push_back(builder.makeLocalSet(scratch, builder.makePop(type)));
  for (size_t i = curr->index - 1; i != size_t(-1); --i) {
    instrs.push_back(builder.makeDrop(builder.makePop(types[i])));
  }
  // Retrieve the saved value
  instrs.push_back(builder.makeLocalGet(scratch, type));
}

void Poppifier::emitDrop(Drop* curr) {
  auto& instrs = scopeStack.back().instrs;
  if (curr->value->type.isTuple()) {
    // Drop each element individually
    auto types = curr->value->type;
    for (auto it = types.rbegin(), end = types.rend(); it != end; ++it) {
      instrs.push_back(builder.makeDrop(builder.makePop(*it)));
    }
  } else {
    poppify(curr);
    instrs.push_back(curr);
  }
}

void Poppifier::emitLocalGet(LocalGet* curr) {
  auto& instrs = scopeStack.back().instrs;
  if (curr->type.isTuple()) {
    auto types = func->getLocalType(curr->index);
    const auto& elems = tupleVars[curr->index];
    for (size_t i = 0; i < types.size(); ++i) {
      instrs.push_back(builder.makeLocalGet(elems[i], types[i]));
    }
  } else {
    instrs.push_back(curr);
  }
}

void Poppifier::emitLocalSet(LocalSet* curr) {
  auto& instrs = scopeStack.back().instrs;
  if (curr->value->type.isTuple()) {
    auto types = func->getLocalType(curr->index);
    const auto& elems = tupleVars[curr->index];
    // Add the unconditional sets
    for (size_t i = types.size() - 1; i >= 1; --i) {
      instrs.push_back(
        builder.makeLocalSet(elems[i], builder.makePop(types[i])));
    }
    if (curr->isTee()) {
      // Use a tee followed by gets to retrieve the tuple
      instrs.push_back(
        builder.makeLocalTee(elems[0], builder.makePop(types[0]), types[0]));
      for (size_t i = 1; i < types.size(); ++i) {
        instrs.push_back(builder.makeLocalGet(elems[i], types[i]));
      }
    } else {
      // Otherwise just add the last set
      instrs.push_back(
        builder.makeLocalSet(elems[0], builder.makePop(types[0])));
    }
  } else {
    poppify(curr);
    instrs.push_back(curr);
  }
}

void Poppifier::emitGlobalGet(GlobalGet* curr) {
  auto& instrs = scopeStack.back().instrs;
  if (curr->type.isTuple()) {
    auto types = module->getGlobal(curr->name)->type;
    for (Index i = 0; i < types.size(); ++i) {
      instrs.push_back(
        builder.makeGlobalGet(getGlobalElem(module, curr->name, i), types[i]));
    }
  } else {
    instrs.push_back(curr);
  }
}

void Poppifier::emitGlobalSet(GlobalSet* curr) {
  auto& instrs = scopeStack.back().instrs;
  if (curr->value->type.isTuple()) {
    auto types = module->getGlobal(curr->name)->type;
    for (Index i = types.size(); i > 0; --i) {
      instrs.push_back(
        builder.makeGlobalSet(getGlobalElem(module, curr->name, i - 1),
                              builder.makePop(types[i - 1])));
    }
  } else {
    poppify(curr);
    instrs.push_back(curr);
  }
}

void Poppifier::poppify(Expression* expr) {
  struct Poppifier : PostWalker<Poppifier> {
    bool scanned = false;
    Builder builder;
    Poppifier(Builder& builder) : builder(builder) {}

    static void scan(Poppifier* self, Expression** currp) {
      if (!self->scanned) {
        self->scanned = true;
        PostWalker<Poppifier>::scan(self, currp);
      } else {
        *currp = self->builder.makePop((*currp)->type);
      }
    }
  } poppifier(builder);
  poppifier.walk(expr);
}

class PoppifyFunctionsPass : public Pass {
  bool isFunctionParallel() override { return true; }
  void runOnFunction(Module* module, Function* func) override {
    if (func->profile != IRProfile::Poppy) {
      Poppifier(func, module).write();
      func->profile = IRProfile::Poppy;
    }
  }
  std::unique_ptr<Pass> create() override {
    return std::make_unique<PoppifyFunctionsPass>();
  }
};

} // anonymous namespace

class PoppifyPass : public Pass {
  void run(Module* module) {
    PassRunner subRunner(getPassRunner());
    subRunner.add(std::make_unique<PoppifyFunctionsPass>());
    // TODO: Enable this once it handles Poppy blocks correctly
    // subRunner.add(std::make_unique<ReFinalize>());
    subRunner.run();
    lowerTupleGlobals(module);
  }

  void lowerTupleGlobals(Module* module) {
    Builder builder(*module);
    std::vector<std::unique_ptr<Global>> newGlobals;
    for (int g = module->globals.size() - 1; g >= 0; --g) {
      const auto& global = *module->globals[g];
      if (!global.type.isTuple()) {
        continue;
      }
      assert(!global.imported());
      for (Index i = 0; i < global.type.size(); ++i) {
        Expression* init;
        if (global.init == nullptr) {
          init = nullptr;
        } else if (auto* make = global.init->dynCast<TupleMake>()) {
          init = make->operands[i];
        } else if (auto* get = global.init->dynCast<GlobalGet>()) {
          init = builder.makeGlobalGet(getGlobalElem(module, get->name, i),
                                       global.type[i]);
        } else {
          WASM_UNREACHABLE("Unexpected tuple global initializer");
        }
        auto mutability =
          global.mutable_ ? Builder::Mutable : Builder::Immutable;
        newGlobals.emplace_back(
          builder.makeGlobal(getGlobalElem(module, global.name, i),
                             global.type[i],
                             init,
                             mutability));
      }
      module->removeGlobal(global.name);
    }
    while (newGlobals.size()) {
      module->addGlobal(std::move(newGlobals.back()));
      newGlobals.pop_back();
    }
    module->updateMaps();
  }
};

Pass* createPoppifyPass() { return new PoppifyPass; }

} // namespace wasm
