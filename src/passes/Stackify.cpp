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

Name getGlobalElem(Name global, Index i) {
  return Name(std::string(global.c_str()) + '$' + std::to_string(i));
}

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

  // Maps tuple locals to the new locals that will hold their elements
  std::unordered_map<Index, std::vector<Index>> tupleVars;

  // Records the scratch local to be used for tuple.extracts of each type
  std::unordered_map<Type, Index> scratchLocals;

  Stackifier(Function* func, MixedArena& allocator);

  Index getScratchLocal(Type type);
  void patchInstrs(Expression*& expr);

  // BinaryIRWriter methods
  void emit(Expression* curr);
  void emitHeader() {}
  void emitIfElse(If* curr);
  void emitCatch(Try* curr);
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

Stackifier::Stackifier(Function* func, MixedArena& allocator)
  : BinaryenIRWriter<Stackifier>(func), allocator(allocator) {
  // Start with a scope to emit top-level instructions into
  scopeStack.emplace_back(Scope::Func);

  // Map each tuple local to a set of expanded locals
  for (size_t i = 0, end = func->vars.size(); i < end; ++i) {
    if (func->vars[i].isMulti()) {
      auto& vars = tupleVars[Index(i)];
      for (auto type : func->vars[i].expand()) {
        vars.push_back(Builder(allocator).addVar(func, type));
      }
    }
  }
}

Index Stackifier::getScratchLocal(Type type) {
  // If there is no scratch local for `type`, allocate a new one
  auto insert = scratchLocals.insert({type, Index(-1)});
  if (insert.second) {
    insert.first->second = Builder(allocator).addVar(func, type);
  }
  return insert.first->second;
}

void Stackifier::patchInstrs(Expression*& expr) {
  Builder builder(allocator);
  auto& instrs = scopeStack.back().instrs;
  if (auto* block = expr->dynCast<Block>()) {
    // Conservatively keep blocks to avoid dropping important labels, but do
    // not patch a block into itself, which would otherwise happen when
    // emitting if/else or try/catch arms and function bodies.
    if (instrs.size() != 1 || instrs[0] != block) {
      block->list.set(instrs);
    }
  } else if (instrs.size() == 1) {
    // Otherwise do not insert blocks containing single instructions
    assert(expr == instrs[0] && "not actually sure about this");
    expr = instrs[0];
  } else {
    expr = builder.makeBlock(instrs, expr->type);
  }
  instrs.clear();
}

void Stackifier::emit(Expression* curr) {
  Builder builder(allocator);
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
  } else if (curr->is<TupleMake>()) {
    // Turns into nothing when stackified
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
    // Replace all children (which have already been emitted) with pops and
    // emit the current instruction into the current scope.
    Poppifier(allocator).poppify(curr);
    scopeStack.back().instrs.push_back(curr);
  }
};

void Stackifier::emitIfElse(If* curr) {
  auto& scope = scopeStack.back();
  assert(scope.kind == Scope::If);
  patchInstrs(curr->ifTrue);
  scope.kind = Scope::Else;
}

void Stackifier::emitCatch(Try* curr) {
  auto& scope = scopeStack.back();
  assert(scope.kind == Scope::Try);
  patchInstrs(curr->body);
  scope.kind = Scope::Catch;
}

void Stackifier::emitScopeEnd(Expression* curr) {
  auto& scope = scopeStack.back();
  switch (scope.kind) {
    case Scope::Block:
      patchInstrs(curr);
      break;
    case Scope::Loop:
      patchInstrs(curr->cast<Loop>()->body);
      break;
    case Scope::If:
      patchInstrs(curr->cast<If>()->ifTrue);
      break;
    case Scope::Else:
      patchInstrs(curr->cast<If>()->ifFalse);
      break;
    case Scope::Catch:
      patchInstrs(curr->cast<Try>()->catchBody);
      break;
    case Scope::Try:
      WASM_UNREACHABLE("try without catch");
    case Scope::Func:
      WASM_UNREACHABLE("unexpected end of function");
  }
  scopeStack.pop_back();
  scopeStack.back().instrs.push_back(curr);
}

void Stackifier::emitFunctionEnd() {
  auto& scope = scopeStack.back();
  assert(scope.kind == Scope::Func);
  patchInstrs(func->body);
}

void Stackifier::emitUnreachable() {
  Builder builder(allocator);
  auto& instrs = scopeStack.back().instrs;
  instrs.push_back(builder.makeUnreachable());
}

void Stackifier::emitTupleExtract(TupleExtract* curr) {
  Builder builder(allocator);
  auto& instrs = scopeStack.back().instrs;
  const auto& types = curr->tuple->type.expand();
  // Drop all the values after the one we want
  for (size_t i = types.size() - 1; i > curr->index; --i) {
    instrs.push_back(builder.makeDrop(builder.makePop(types[i])));
  }
  // If the extracted value is the only one left, we're done
  if (curr->index == 0) {
    return;
  }
  // Otherwise, save it to a scratch local and drop the others values
  auto type = types[curr->index];
  Index scratch = getScratchLocal(type);
  instrs.push_back(builder.makeLocalSet(scratch, builder.makePop(type)));
  for (size_t i = curr->index - 1; i != size_t(-1); --i) {
    instrs.push_back(builder.makeDrop(builder.makePop(types[i])));
  }
  // Retrieve the saved value
  instrs.push_back(builder.makeLocalGet(scratch, type));
}

void Stackifier::emitDrop(Drop* curr) {
  Builder builder(allocator);
  auto& instrs = scopeStack.back().instrs;
  if (curr->value->type.isMulti()) {
    // Drop each element individually
    const auto& types = curr->value->type.expand();
    for (auto it = types.rbegin(), end = types.rend(); it != end; ++it) {
      instrs.push_back(builder.makeDrop(builder.makePop(*it)));
    }
  } else {
    curr->value = builder.makePop(curr->value->type);
    instrs.push_back(curr);
  }
}

void Stackifier::emitLocalGet(LocalGet* curr) {
  Builder builder(allocator);
  auto& instrs = scopeStack.back().instrs;
  if (curr->type.isMulti()) {
    const auto& types = curr->type.expand();
    const auto& elems = tupleVars[curr->index];
    for (size_t i = 0; i < types.size(); ++i) {
      instrs.push_back(builder.makeLocalGet(elems[i], types[i]));
    }
  } else {
    instrs.push_back(curr);
  }
}

void Stackifier::emitLocalSet(LocalSet* curr) {
  Builder builder(allocator);
  auto& instrs = scopeStack.back().instrs;
  if (curr->value->type.isMulti()) {
    const auto& types = curr->value->type.expand();
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
    curr->value = builder.makePop(curr->value->type);
    instrs.push_back(curr);
  }
}

void Stackifier::emitGlobalGet(GlobalGet* curr) {
  Builder builder(allocator);
  auto& instrs = scopeStack.back().instrs;
  if (curr->type.isMulti()) {
    const auto& types = curr->type.expand();
    for (Index i = 0; i < types.size(); ++i) {
      instrs.push_back(
        builder.makeGlobalGet(getGlobalElem(curr->name, i), types[i]));
    }
  } else {
    instrs.push_back(curr);
  }
}

void Stackifier::emitGlobalSet(GlobalSet* curr) {
  Builder builder(allocator);
  auto& instrs = scopeStack.back().instrs;
  if (curr->value->type.isMulti()) {
    const auto& types = curr->value->type.expand();
    for (Index i = types.size(); i > 0; --i) {
      instrs.push_back(builder.makeGlobalSet(getGlobalElem(curr->name, i - 1),
                                             builder.makePop(types[i - 1])));
    }
  } else {
    curr->value = builder.makePop(curr->value->type);
    instrs.push_back(curr);
  }
}

class StackifyFunctionsPass : public Pass {
  bool isFunctionParallel() override { return true; }
  void
  runOnFunction(PassRunner* runner, Module* module, Function* func) override {
    if (!func->isStacky) {
      Stackifier(func, module->allocator).write();
      func->isStacky = true;
    }
  }
  Pass* create() override { return new StackifyFunctionsPass(); }
};

} // anonymous namespace

class StackifyPass : public Pass {
  void run(PassRunner* runner, Module* module) {
    lowerTupleGlobals(module);
    PassRunner subRunner(runner);
    subRunner.add(std::make_unique<StackifyFunctionsPass>());
    subRunner.run();
  }

  void lowerTupleGlobals(Module* module) {
    Builder builder(*module);
    for (int g = module->globals.size() - 1; g >= 0; --g) {
      auto& global = *module->globals[g];
      if (global.type.isMulti()) {
        assert(!global.imported());
        const auto& types = global.type.expand();
        for (Index i = 0; i < types.size(); ++i) {
          Expression* init = global.init == nullptr
                               ? nullptr
                               : global.init->cast<TupleMake>()->operands[i];
          auto mutability =
            global.mutable_ ? Builder::Mutable : Builder::Immutable;
          auto* elem = builder.makeGlobal(
            getGlobalElem(global.name, i), types[i], init, mutability);
          module->addGlobal(elem);
        }
        module->removeGlobal(global.name);
      }
    }
  }
};

Pass* createStackifyPass() { return new StackifyPass; }

} // namespace wasm
