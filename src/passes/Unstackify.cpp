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

#include "ir/iteration.h"
#include "ir/properties.h"
#include "pass.h"
#include "wasm-builder.h"

namespace wasm {

namespace {

struct Unstackifier
  : PostWalker<Unstackifier, UnifiedExpressionVisitor<Unstackifier>> {
  using Super =
    PostWalker<Unstackifier, UnifiedExpressionVisitor<Unstackifier>>;

  Unstackifier(Function* func, MixedArena& allocator)
    : func(func), allocator(allocator) {}

  // Unstackify `root` in place
  void unstackify(Expression* root);

  static void scan(Unstackifier* self, Expression** currp);
  static void doPreVisitExpression(Unstackifier* self, Expression** currp);

  void preVisitExpression(Expression* curr);
  void visitExpression(Expression* curr);

private:
  Expression* root = nullptr;
  Function* func;
  MixedArena& allocator;

  std::vector<Expression*> expressionStack;
  void pushExpression(Expression* curr);
  Expression* popNonVoidExpression();
  Expression* popExpression();
  Expression* popExpression(Type type);
  // Expression* popBlockOrSingleton(Type type, unsigned numPops);

  // Keep track of the number of expressions on the stack at the beginning of
  // each block so we know how many should be implicitly dropped when we get to
  // the end of a block.
  std::vector<size_t> scopeStack;
  void startScope();
  size_t endScope();
};

void Unstackifier::pushExpression(Expression* curr) {
  if (curr->type.isMulti()) {
    // Store tuple to local and push individual extracted values
    Builder builder(allocator);
    Index tuple = builder.addVar(func, curr->type);
    expressionStack.push_back(builder.makeLocalSet(tuple, curr));
    const auto& types = curr->type.expand();
    for (Index i = 0; i < types.size(); ++i) {
      expressionStack.push_back(
        builder.makeTupleExtract(builder.makeLocalGet(tuple, curr->type), i));
    }
  } else {
    expressionStack.push_back(curr);
  }
}

Expression* Unstackifier::popExpression() {
  // In unreachable code, trying to pop past the polymorphic stack area
  // results in receiving unreachables
  if (expressionStack.empty()) {
    assert(false && "Empty expression stack"); // TODO: determine if dead
    return allocator.alloc<Unreachable>();
  }
  auto* popped = expressionStack.back();
  expressionStack.pop_back();
  assert(!popped->type.isMulti());
  return popped;
}

Expression* Unstackifier::popNonVoidExpression() {
  auto* ret = popExpression();
  if (ret->type != Type::none) {
    return ret;
  }

  // Pop expressions until we find a non-none typed expression
  std::vector<Expression*> expressions;
  while (true) {
    auto* curr = popExpression();
    if (curr->type == Type::unreachable) {
      // The previously popped expressions won't be reached, so we can just
      // return this one.
      return curr;
    }
    expressions.push_back(curr);
    if (curr->type != Type::none) {
      break;
    }
  }

  // Create a block to hold all the popped expressions
  Builder builder(allocator);
  auto* block = builder.makeBlock();
  for (auto it = expressions.rbegin(); it != expressions.rend(); ++it) {
    block->list.push_back(*it);
  }

  // Add a variable to retrieve the concrete value at the end of the block
  auto type = block->list[0]->type;
  assert(type.isConcrete());
  auto local = builder.addVar(func, type);
  block->list[0] = builder.makeLocalSet(local, block->list[0]);
  block->list.push_back(builder.makeLocalGet(local, type));
  block->type = type;
  return block;
}

Expression* Unstackifier::popExpression(Type type) {
  if (type == Type::none || type == Type::unreachable) {
    auto* ret = popExpression();
    assert(Type::isSubType(ret->type, type) || ret->type == Type::unreachable);
    return ret;
  }
  if (type.isSingle()) {
    auto* ret = popNonVoidExpression();
    assert(Type::isSubType(ret->type, type) || ret->type == Type::unreachable);
    return ret;
  }

  assert(type.isMulti() && "Unexpected popped type");

  // Construct a tuple with the correct number of elements
  auto numElems = type.size();
  Builder builder(allocator);
  std::vector<Expression*> elements;
  elements.resize(numElems);
  for (size_t i = 0; i < numElems; i++) {
    auto* elem = popNonVoidExpression();
    if (elem->type == Type::unreachable) {
      // All the previously-popped items cannot be reached, so ignore them. We
      // cannot continue popping because there might not be enough items on the
      // expression stack after an unreachable expression. Any remaining
      // elements can stay unperturbed on the stack and will be explicitly
      // dropped when the current block is finished.
      return elem;
    }
    elements[numElems - i - 1] = elem;
  }
  return Builder(allocator).makeTupleMake(std::move(elements));
}

// TODO: properly adapt WasmBinaryBuilder::getBlockOrSingleton
// Expression* Unstackifier::popBlockOrSingleton(Type type, bool withExnRef) {
// }

void Unstackifier::scan(Unstackifier* self, Expression** currp) {
  Super::scan(self, currp);
  self->pushTask(Unstackifier::doPreVisitExpression, currp);
}

void Unstackifier::doPreVisitExpression(Unstackifier* self,
                                        Expression** currp) {
  self->preVisitExpression(*currp);
}

void Unstackifier::startScope() {
  scopeStack.push_back(expressionStack.size());
}

size_t Unstackifier::endScope() {
  assert(scopeStack.size() > 0);
  auto ret = scopeStack.back();
  scopeStack.pop_back();
  return ret;
}

void Unstackifier::preVisitExpression(Expression* curr) {
  if (curr->is<Block>()) {
    // Record the number of expressions going into the current block
    startScope();
  } else if (!Properties::isControlFlowStructure(curr)) {
    // Adjust the expression stack so that the child pops are filled in the
    // correct order. Otherwise the order of children would be reversed. Control
    // flow children are not pops, so do not need to be reversed (except `if`
    // conditions, but reversing the single condition would not do anything).
    auto numChildren = ChildIterator(curr).size();
    std::reverse(expressionStack.end() - numChildren, expressionStack.end());
  }
}

void Unstackifier::visitExpression(Expression* curr) {
  // Replace pops with their corresponding expressions
  if (auto* pop = curr->dynCast<Pop>()) {
    replaceCurrent(popExpression(pop->type));
    return;
  }

  // We have finished processing this instruction's children. Manually pull in
  // any control flow children that would not have been pops.
  if (auto* if_ = curr->dynCast<If>()) {
    if (if_->ifFalse) {
      if_->ifFalse = popExpression(if_->type);
    }
    if_->ifTrue = popExpression(if_->type);
  } else if (auto* loop = curr->dynCast<Loop>()) {
    loop->body = popExpression(loop->type);
  } else if (auto* try_ = curr->dynCast<Try>()) {
    try_->catchBody = popExpression(try_->type);
    try_->body = popExpression(try_->type);
  } else if (auto* block = curr->dynCast<Block>()) {
    // Replace block contents with their unstackified forms
    Expression* results = nullptr;
    if (block->type.isConcrete()) {
      results = popExpression(block->type);
    }

    auto numExpressions = endScope();
    assert(expressionStack.size() >= numExpressions);
    block->list.clear();
    for (size_t i = numExpressions; i < expressionStack.size(); ++i) {
      auto* item = expressionStack[i];
      // Make implicit drops explicit
      if (item->type.isConcrete()) {
        item = Builder(allocator).makeDrop(item);
      }
      block->list.push_back(item);
    }
    if (results != nullptr) {
      block->list.push_back(results);
    }
    expressionStack.resize(numExpressions);
  }

  // This expression has been fully stackified. If we are not done, make it
  // available to be the child of a future expression.
  if (curr != root) {
    pushExpression(curr);
  }
}

void Unstackifier::unstackify(Expression* root) {
  // Don't set the function on the parent walker to avoid changing debuginfo
  this->root = root;
  walk(root);
  this->root = nullptr;

  assert(scopeStack.size() == 0);
  assert(expressionStack.size() == 0);
}

} // anonymous namespace

class UnstackifyPass : public Pass {
  bool isFunctionParallel() override { return true; }
  void
  runOnFunction(PassRunner* runner, Module* module, Function* func) override {
    if (func->isStacky) {
      Unstackifier(func, module->allocator).unstackify(func->body);
      func->isStacky = false;
    }
  }
  Pass* create() override { return new UnstackifyPass(); }
};

Pass* createUnstackifyPass() { return new UnstackifyPass(); }

} // namespace wasm
