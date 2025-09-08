/*
 * Copyright 2023 WebAssembly Community Group participants
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

#include <cassert>

#include "ir/child-typer.h"
#include "ir/eh-utils.h"
#include "ir/names.h"
#include "ir/principal-type.h"
#include "ir/properties.h"
#include "ir/utils.h"
#include "wasm-ir-builder.h"

#define IR_BUILDER_DEBUG 0

#if IR_BUILDER_DEBUG
#define DBG(statement) statement
#else
#define DBG(statement)
#endif

using namespace std::string_literals;

namespace wasm {

namespace {

Result<> validateTypeAnnotation(Type type, Expression* child) {
  if (!Type::isSubType(child->type, type)) {
    return Err{"invalid type on stack"};
  }
  return Ok{};
}

Result<> validateTypeAnnotation(HeapType type, Expression* child) {
  return validateTypeAnnotation(Type(type, Nullable), child);
}

} // anonymous namespace

Result<Index> IRBuilder::addScratchLocal(Type type) {
  if (!func) {
    return Err{"scratch local required, but there is no function context"};
  }
  Name name = Names::getValidLocalName(*func, "scratch");
  return Builder::addVar(func, name, type);
}

MaybeResult<IRBuilder::HoistedVal> IRBuilder::hoistLastValue() {
  auto& stack = getScope().exprStack;
  int index = stack.size() - 1;
  for (; index >= 0; --index) {
    if (stack[index]->type != Type::none) {
      break;
    }
  }
  if (index < 0) {
    // There is no value-producing or unreachable expression.
    return {};
  }
  if (unsigned(index) == stack.size() - 1) {
    // Value-producing expression already on top of the stack.
    return HoistedVal{Index(index), nullptr};
  }
  auto*& expr = stack[index];
  auto type = expr->type;
  if (type == Type::unreachable) {
    // Make sure the top of the stack also has an unreachable expression.
    if (stack.back()->type != Type::unreachable) {
      pushSynthetic(builder.makeUnreachable());
    }
    return HoistedVal{Index(index), nullptr};
  }
  // Hoist with a scratch local.
  auto scratchIdx = addScratchLocal(type);
  CHECK_ERR(scratchIdx);
  expr = builder.makeLocalSet(*scratchIdx, expr);
  auto* get = builder.makeLocalGet(*scratchIdx, type);
  pushSynthetic(get);
  return HoistedVal{Index(index), get};
}

Result<> IRBuilder::packageHoistedValue(const HoistedVal& hoisted,
                                        size_t sizeHint) {
  auto& scope = getScope();
  assert(!scope.exprStack.empty());

  auto packageAsBlock = [&](Type type) {
    // Create a block containing the producer of the hoisted value, the final
    // get of the hoisted value, and everything in between. Record the fact that
    // we are synthesizing a block to help us determine later whether we need to
    // run the nested pop fixup.
    scopeStack[0].noteSyntheticBlock();
    std::vector<Expression*> exprs(scope.exprStack.begin() + hoisted.valIndex,
                                   scope.exprStack.end());
    auto* block = builder.makeBlock(exprs, type);
    scope.exprStack.resize(hoisted.valIndex);
    pushSynthetic(block);
  };

  auto type = scope.exprStack.back()->type;

  if (type.size() == sizeHint || type.size() <= 1) {
    if (hoisted.get) {
      packageAsBlock(type);
    }
    return Ok{};
  }

  // We need to break up the hoisted tuple. Create and push an expression
  // setting the tuple to a local and returning its first element, then push
  // additional gets of each of its subsequent elements. Reuse the scratch local
  // we used for hoisting, if it exists.
  Index scratchIdx;
  if (hoisted.get) {
    // Update the get on top of the stack to just return the first element.
    scope.exprStack.back() = builder.makeTupleExtract(hoisted.get, 0);
    packageAsBlock(type[0]);
    scratchIdx = hoisted.get->index;
  } else {
    auto scratch = addScratchLocal(type);
    CHECK_ERR(scratch);
    scope.exprStack.back() = builder.makeTupleExtract(
      builder.makeLocalTee(*scratch, scope.exprStack.back(), type), 0);
    scratchIdx = *scratch;
  }
  for (Index i = 1, size = type.size(); i < size; ++i) {
    pushSynthetic(
      builder.makeTupleExtract(builder.makeLocalGet(scratchIdx, type), i));
  }
  return Ok{};
}

void IRBuilder::push(Expression* expr, Origin origin) {
  auto& scope = getScope();
  if (expr->type == Type::unreachable) {
    scope.unreachable = true;
  }
  scope.exprStack.push_back(expr);

  if (origin == Origin::Binary) {
    applyDebugLoc(expr);
    if (binaryPos && func && lastBinaryPos != *binaryPos) {
      auto span =
        BinaryLocations::Span{BinaryLocation(lastBinaryPos - codeSectionOffset),
                              BinaryLocation(*binaryPos - codeSectionOffset)};
      // Some expressions already have their start noted, and we are just seeing
      // their last segment (like an Else).
      auto [iter, inserted] = func->expressionLocations.insert({expr, span});
      if (!inserted) {
        // Just update the end.
        iter->second.end = span.end;
        // The true start from before is before the start of the current
        // segment.
        assert(iter->second.start < span.start);
      }
      lastBinaryPos = *binaryPos;
    }
  }

  DBG(std::cerr << "After pushing " << ShallowExpression{expr} << ":\n");
  DBG(dump());
}

Result<Expression*> IRBuilder::build() {
  if (scopeStack.empty()) {
    return builder.makeBlock();
  }
  if (scopeStack.size() > 1 || !scopeStack.back().isNone()) {
    return Err{"unfinished block context"};
  }
  if (scopeStack.back().exprStack.size() > 1) {
    return Err{"unused expressions without block context"};
  }
  assert(scopeStack.back().exprStack.size() == 1);
  auto* expr = scopeStack.back().exprStack.back();
  scopeStack.clear();
  labelDepths.clear();
  return expr;
}

void IRBuilder::setDebugLocation(
  const std::optional<Function::DebugLocation>& loc) {
  if (loc) {
    DBG(std::cerr << "setting debugloc " << loc->fileIndex << ":"
                  << loc->lineNumber << ":" << loc->columnNumber << "\n";);
  } else {
    DBG(std::cerr << "setting debugloc to none\n";);
  }
  if (loc) {
    debugLoc = *loc;
  } else {
    debugLoc = NoDebug();
  }
}

void IRBuilder::applyDebugLoc(Expression* expr) {
  if (!std::get_if<CanReceiveDebug>(&debugLoc)) {
    if (func) {
      if (auto* loc = std::get_if<Function::DebugLocation>(&debugLoc)) {
        DBG(std::cerr << "applying debugloc " << loc->fileIndex << ":"
                      << loc->lineNumber << ":" << loc->columnNumber
                      << " to expression " << ShallowExpression{expr} << "\n");
        func->debugLocations[expr] = *loc;
      } else {
        assert(std::get_if<NoDebug>(&debugLoc));
        DBG(std::cerr << "applying debugloc to expression "
                      << ShallowExpression{expr} << "\n");
        func->debugLocations[expr] = std::nullopt;
      }
    }
    debugLoc = CanReceiveDebug();
  }
}

void IRBuilder::dump() {
#if IR_BUILDER_DEBUG
  std::cerr << "Scope stack";
  if (func) {
    std::cerr << " in function $" << func->name;
  }
  std::cerr << ":\n";

  for (auto& scope : scopeStack) {
    std::cerr << "  scope ";
    if (scope.isNone()) {
      std::cerr << "none";
    } else if (auto* f = scope.getFunction()) {
      std::cerr << "func " << f->name;
    } else if (scope.getBlock()) {
      std::cerr << "block";
    } else if (scope.getIf()) {
      std::cerr << "if";
    } else if (scope.getElse()) {
      std::cerr << "else";
    } else if (scope.getLoop()) {
      std::cerr << "loop";
    } else if (auto* tryy = scope.getTry()) {
      std::cerr << "try";
      if (tryy->name) {
        std::cerr << " " << tryy->name;
      }
    } else if (auto* tryy = scope.getCatch()) {
      std::cerr << "catch";
      if (tryy->name) {
        std::cerr << " " << tryy->name;
      }
    } else if (auto* tryy = scope.getCatchAll()) {
      std::cerr << "catch_all";
      if (tryy->name) {
        std::cerr << " " << tryy->name;
      }
    } else {
      WASM_UNREACHABLE("unexpected scope");
    }

    if (auto name = scope.getOriginalLabel()) {
      std::cerr << " (original label: " << name << ")";
    }

    if (scope.label) {
      std::cerr << " (label: " << scope.label << ")";
    }

    if (scope.branchLabel) {
      std::cerr << " (branch label: " << scope.branchLabel << ")";
    }

    if (scope.unreachable) {
      std::cerr << " (unreachable)";
    }

    std::cerr << ":\n";

    for (auto* expr : scope.exprStack) {
      std::cerr << "    " << ShallowExpression{expr} << "\n";
    }
  }
#endif // IR_BUILDER_DEBUG
}

struct IRBuilder::ChildPopper
  : UnifiedExpressionVisitor<ChildPopper, Result<>> {

  struct ConstraintCollector;
  using Constraints = ChildTyper<ConstraintCollector>::Constraints;

  struct Child {
    Expression** childp;
    Constraints constraint;
  };

  struct ConstraintCollector : ChildTyper<ConstraintCollector> {
    IRBuilder& builder;
    std::vector<Child>& children;

    ConstraintCollector(IRBuilder& builder, std::vector<Child>& children)
      : ChildTyper(builder.wasm, builder.func), builder(builder),
        children(children) {}

    void note(Expression** childp, Constraints type) {
      children.push_back({childp, type});
    }

    Type getLabelType(Name label) {
      WASM_UNREACHABLE("labels should be explicitly provided");
    };

    void visitIf(If* curr) {
      // Skip the control flow children because we only want to pop the
      // condition.
      children.push_back({&curr->condition, {Type(Type::i32)}});
    }

    // It is a bug if we ever have insufficient type information.
    void noteUnknown() {
      WASM_UNREACHABLE("unexpected insufficient type information");
    }
  };

  IRBuilder& builder;

  ChildPopper(IRBuilder& builder) : builder(builder) {}

private:
  Result<> popConstrainedChildren(std::vector<Child>& children) {
    auto& scope = builder.getScope();

    // The index of the shallowest unreachable instruction on the stack, found
    // by checkNeedsUnreachableFallback.
    std::optional<size_t> unreachableIndex;

    // Whether popping the children past the unreachable would produce a type
    // mismatch or try to pop from an empty stack.
    bool needUnreachableFallback = false;

    // We only need to check requirements if there is an unreachable.
    // Otherwise the validator will catch any problems.
    if (scope.unreachable) {
      needUnreachableFallback =
        checkNeedsUnreachableFallback(children, unreachableIndex);
    }

    // We have checked all the constraints, so we are ready to pop children.
    for (int i = children.size() - 1; i >= 0; --i) {
      if (needUnreachableFallback &&
          scope.exprStack.size() == *unreachableIndex + 1 && i > 0) {
        // The next item on the stack is the unreachable instruction we must
        // not pop past. We cannot insert unreachables in front of it because
        // it might be a branch we actually have to execute, so this next item
        // must be child 0. But we are not ready to pop child 0 yet, so
        // synthesize an unreachable instead of popping. The deeper
        // instructions that would otherwise have been popped will remain on
        // the stack to become prior children of future expressions or to be
        // implicitly dropped at the end of the scope.
        *children[i].childp = builder.builder.makeUnreachable();
        continue;
      }

      // Pop a child normally.
      auto val = pop(children[i].constraint.size());
      CHECK_ERR(val);
      *children[i].childp = *val;
    }
    return Ok{};
  }

  bool checkNeedsUnreachableFallback(const std::vector<Child>& children,
                                     std::optional<size_t>& unreachableIndex) {
    auto& scope = builder.getScope();

    // Two-part indices into the stack of available expressions and the vector
    // of requirements, allowing them to move independently with the granularity
    // of a single tuple element.
    size_t stackIndex = scope.exprStack.size();
    size_t stackTupleIndex = 0;
    size_t childIndex = children.size();
    size_t childTupleIndex = 0;

    // Check whether the values on the stack will be able to meet the given
    // requirements.
    while (true) {
      // Advance to the next requirement.
      if (childTupleIndex > 0) {
        --childTupleIndex;
      } else {
        if (childIndex == 0) {
          // We have examined all the requirements.
          break;
        }
        --childIndex;
        childTupleIndex = children[childIndex].constraint.size() - 1;
      }

      // Advance to the next available value on the stack.
      while (true) {
        if (stackTupleIndex > 0) {
          --stackTupleIndex;
        } else {
          if (stackIndex == 0) {
            // No more available values. This is valid iff we are reaching past
            // an unreachable, but we still need the fallback behavior to ensure
            // the input unreachable instruction is executed first. If we are
            // not reaching past an unreachable, the error will be caught when
            // we pop.
            return true;
          }
          --stackIndex;
          stackTupleIndex = scope.exprStack[stackIndex]->type.size() - 1;
        }

        // Skip expressions that don't produce values.
        if (scope.exprStack[stackIndex]->type == Type::none) {
          stackTupleIndex = 0;
          continue;
        }
        break;
      }

      // We have an available type and a constraint. Only check constraints if
      // we are past an unreachable, since otherwise we can leave problems to be
      // caught by the validator later.
      auto type = scope.exprStack[stackIndex]->type[stackTupleIndex];
      if (unreachableIndex) {
        auto constraint = children[childIndex].constraint[childTupleIndex];
        if (!PrincipalType::matches(type, constraint)) {
          return true;
        }
      }

      // No problems for children after this unreachable.
      if (type == Type::unreachable) {
        unreachableIndex = stackIndex;
      }
    }
    return false;
  }

  Result<Expression*> pop(size_t size) {
    assert(size >= 1);
    auto& scope = builder.getScope();

    // Find the suffix of expressions that do not produce values.
    auto hoisted = builder.hoistLastValue();
    CHECK_ERR(hoisted);
    if (!hoisted) {
      // There are no expressions that produce values.
      if (scope.unreachable) {
        return builder.builder.makeUnreachable();
      }
      return Err{"popping from empty stack"};
    }

    CHECK_ERR(builder.packageHoistedValue(*hoisted, size));

    auto* ret = scope.exprStack.back();
    // If the top value has the correct size, we can pop it and be done.
    // Unreachable values satisfy any size.
    if (ret->type.size() == size || ret->type == Type::unreachable) {
      scope.exprStack.pop_back();
      return ret;
    }

    // The last value-producing expression did not produce exactly the right
    // number of values, so we need to construct a tuple piecewise instead.
    assert(size > 1);
    std::vector<Expression*> elems;
    elems.resize(size);
    for (int i = size - 1; i >= 0; --i) {
      auto elem = pop(1);
      CHECK_ERR(elem);
      elems[i] = *elem;
    }
    return builder.builder.makeTupleMake(elems);
  }

public:
  Result<> visitExpression(Expression* expr) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visit(expr);
    return popConstrainedChildren(children);
  }

  Result<> visitAtomicCmpxchg(AtomicCmpxchg* curr,
                              std::optional<Type> type = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitAtomicCmpxchg(curr, type);
    return popConstrainedChildren(children);
  }

  Result<> visitStructGet(StructGet* curr,
                          std::optional<HeapType> ht = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitStructGet(curr, ht);
    return popConstrainedChildren(children);
  }

  Result<> visitStructSet(StructSet* curr,
                          std::optional<HeapType> ht = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitStructSet(curr, ht);
    return popConstrainedChildren(children);
  }

  Result<> visitStructRMW(StructRMW* curr,
                          std::optional<HeapType> ht = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitStructRMW(curr, ht);
    return popConstrainedChildren(children);
  }

  Result<> visitStructCmpxchg(StructCmpxchg* curr,
                              std::optional<HeapType> ht = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitStructCmpxchg(curr, ht);
    return popConstrainedChildren(children);
  }

  Result<> visitArrayGet(ArrayGet* curr,
                         std::optional<HeapType> ht = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitArrayGet(curr, ht);
    return popConstrainedChildren(children);
  }

  Result<> visitArraySet(ArraySet* curr,
                         std::optional<HeapType> ht = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitArraySet(curr, ht);
    return popConstrainedChildren(children);
  }

  Result<> visitArrayCopy(ArrayCopy* curr,
                          std::optional<HeapType> dest = std::nullopt,
                          std::optional<HeapType> src = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitArrayCopy(curr, dest, src);
    return popConstrainedChildren(children);
  }

  Result<> visitArrayFill(ArrayFill* curr,
                          std::optional<HeapType> ht = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitArrayFill(curr, ht);
    return popConstrainedChildren(children);
  }

  Result<> visitArrayInitData(ArrayInitData* curr,
                              std::optional<HeapType> ht = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitArrayInitData(curr, ht);
    return popConstrainedChildren(children);
  }

  Result<> visitArrayInitElem(ArrayInitElem* curr,
                              std::optional<HeapType> ht = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitArrayInitElem(curr, ht);
    return popConstrainedChildren(children);
  }

  Result<> visitArrayRMW(ArrayRMW* curr,
                         std::optional<HeapType> ht = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitArrayRMW(curr, ht);
    return popConstrainedChildren(children);
  }

  Result<> visitArrayCmpxchg(ArrayCmpxchg* curr,
                             std::optional<HeapType> ht = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitArrayCmpxchg(curr, ht);
    return popConstrainedChildren(children);
  }

  Result<> visitCallRef(CallRef* curr,
                        std::optional<HeapType> ht = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitCallRef(curr, ht);
    return popConstrainedChildren(children);
  }

  Result<> visitRefGetDesc(RefGetDesc* curr,
                           std::optional<HeapType> ht = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitRefGetDesc(curr, ht);
    return popConstrainedChildren(children);
  }

  Result<> visitBreak(Break* curr,
                      std::optional<Type> labelType = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitBreak(curr, labelType);
    return popConstrainedChildren(children);
  }

  Result<> visitSwitch(Switch* curr,
                       std::optional<Type> labelType = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitSwitch(curr, labelType);
    return popConstrainedChildren(children);
  }

  Result<> visitDrop(Drop* curr, std::optional<Index> arity = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitDrop(curr, arity);
    return popConstrainedChildren(children);
  }

  Result<> visitTupleExtract(TupleExtract* curr,
                             std::optional<Index> arity = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitTupleExtract(curr, arity);
    return popConstrainedChildren(children);
  }

  Result<> visitContBind(ContBind* curr,
                         std::optional<HeapType> src = std::nullopt,
                         std::optional<HeapType> dest = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitContBind(curr, src, dest);
    return popConstrainedChildren(children);
  }

  Result<> visitResume(Resume* curr,
                       std::optional<HeapType> ct = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitResume(curr, ct);
    return popConstrainedChildren(children);
  }

  Result<> visitResumeThrow(ResumeThrow* curr,
                            std::optional<HeapType> ct = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitResumeThrow(curr, ct);
    return popConstrainedChildren(children);
  }

  Result<> visitStackSwitch(StackSwitch* curr,
                            std::optional<HeapType> ct = std::nullopt) {
    std::vector<Child> children;
    ConstraintCollector{builder, children}.visitStackSwitch(curr, ct);
    return popConstrainedChildren(children);
  }
};

Result<> IRBuilder::visit(Expression* curr) {
  // Call either `visitExpression` or an expression-specific override.
  auto val = UnifiedExpressionVisitor<IRBuilder, Result<>>::visit(curr);
  CHECK_ERR(val);
  if (auto* block = curr->dynCast<Block>()) {
    block->finalize(block->type);
  } else {
    // TODO: Call more efficient versions of finalize() that take the known type
    // for other kinds of nodes as well, as done above.
    ReFinalizeNode{}.visit(curr);
  }
  push(curr);
  return Ok{};
}

// Handle the common case of instructions with a constant number of children
// uniformly.
Result<> IRBuilder::visitExpression(Expression* curr) {
  if (Properties::isControlFlowStructure(curr) && !curr->is<If>()) {
    // Control flow structures (besides `if`, handled separately) do not consume
    // stack values.
    return Ok{};
  }
  return ChildPopper{*this}.visit(curr);
}

Result<Type> IRBuilder::getLabelType(Index label) {
  auto scope = getScope(label);
  CHECK_ERR(scope);
  return (*scope)->getLabelType();
}

Result<Type> IRBuilder::getLabelType(Name labelName) {
  auto label = getLabelIndex(labelName);
  CHECK_ERR(label);
  return getLabelType(*label);
}

Result<> IRBuilder::visitBreakWithType(Break* curr, Type type) {
  CHECK_ERR(ChildPopper{*this}.visitBreak(curr, type));
  curr->finalize();
  push(curr);
  return Ok{};
}

Result<> IRBuilder::visitSwitchWithType(Switch* curr, Type type) {
  CHECK_ERR(ChildPopper{*this}.visitSwitch(curr, type));
  curr->finalize();
  push(curr);
  return Ok{};
}

Result<> IRBuilder::visitFunctionStart(Function* func) {
  if (!scopeStack.empty()) {
    return Err{"unexpected start of function"};
  }
  if (auto* loc = std::get_if<Function::DebugLocation>(&debugLoc)) {
    func->prologLocation = *loc;
  }
  debugLoc = CanReceiveDebug();
  scopeStack.push_back(ScopeCtx::makeFunc(func));
  this->func = func;

  if (binaryPos) {
    lastBinaryPos = *binaryPos;
  }

  return Ok{};
}

Result<> IRBuilder::visitBlockStart(Block* curr, Type inputType) {
  applyDebugLoc(curr);
  return pushScope(ScopeCtx::makeBlock(curr, inputType));
}

Result<> IRBuilder::visitIfStart(If* iff, Name label, Type inputType) {
  applyDebugLoc(iff);
  CHECK_ERR(visitIf(iff));
  return pushScope(ScopeCtx::makeIf(iff, label, inputType));
}

Result<> IRBuilder::visitLoopStart(Loop* loop, Type inputType) {
  applyDebugLoc(loop);
  return pushScope(ScopeCtx::makeLoop(loop, inputType));
}

Result<> IRBuilder::visitTryStart(Try* tryy, Name label, Type inputType) {
  applyDebugLoc(tryy);
  return pushScope(ScopeCtx::makeTry(tryy, label, inputType));
}

Result<>
IRBuilder::visitTryTableStart(TryTable* trytable, Name label, Type inputType) {
  applyDebugLoc(trytable);
  return pushScope(ScopeCtx::makeTryTable(trytable, label, inputType));
}

Result<Expression*> IRBuilder::finishScope(Block* block) {
#if IR_BUILDER_DEBUG
  if (auto* loc = std::get_if<Function::DebugLocation>(&debugLoc)) {
    std::cerr << "discarding debugloc " << loc->fileIndex << ":"
              << loc->lineNumber << ":" << loc->columnNumber << "\n";
  }
#endif
  debugLoc = CanReceiveDebug();

  if (scopeStack.empty() || scopeStack.back().isNone()) {
    return Err{"unexpected end of scope"};
  }

  auto& scope = scopeStack.back();
  auto type = scope.getResultType();

  if (scope.unreachable) {
    // Drop everything before the last unreachable.
    bool sawUnreachable = false;
    for (int i = scope.exprStack.size() - 1; i >= 0; --i) {
      if (sawUnreachable) {
        scope.exprStack[i] = builder.dropIfConcretelyTyped(scope.exprStack[i]);
      } else if (scope.exprStack[i]->type == Type::unreachable) {
        sawUnreachable = true;
      }
    }
  }

  if (type.isConcrete()) {
    auto hoisted = hoistLastValue();
    CHECK_ERR(hoisted);
    if (!hoisted) {
      return Err{"popping from empty stack"};
    }

    if (type.isTuple()) {
      auto hoistedType = scope.exprStack.back()->type;
      if (hoistedType != Type::unreachable &&
          hoistedType.size() != type.size()) {
        // We cannot propagate the hoisted value directly because it does not
        // have the correct number of elements. Repackage it.
        CHECK_ERR(packageHoistedValue(*hoisted, hoistedType.size()));
        CHECK_ERR(makeTupleMake(type.size()));
      }
    }
  }

  Expression* ret = nullptr;
  if (scope.exprStack.size() == 0) {
    // No expressions for this scope, but we need something. If we were given a
    // block, we can empty it out and return it, but otherwise create a new
    // empty block.
    if (block) {
      block->list.clear();
      ret = block;
    } else {
      ret = builder.makeBlock();
    }
  } else if (scope.exprStack.size() == 1) {
    // We can put our single expression directly into the surrounding scope.
    if (block) {
      block->list.resize(1);
      block->list[0] = scope.exprStack.back();
      ret = block;
    } else {
      ret = scope.exprStack.back();
    }
  } else {
    // More than one expression, so we need a block. Allocate one if we weren't
    // already given one.
    if (block) {
      block->list.set(scope.exprStack);
    } else {
      block = builder.makeBlock(scope.exprStack, type);
    }
    ret = block;
  }

  // If this scope had a label, remove it from the context.
  if (auto label = scope.getOriginalLabel()) {
    labelDepths.at(label).pop_back();
  }

  scopeStack.pop_back();
  return ret;
}

Result<> IRBuilder::visitElse() {
  auto scope = getScope();
  auto* iff = scope.getIf();
  if (!iff) {
    return Err{"unexpected else"};
  }
  auto expr = finishScope();
  CHECK_ERR(expr);
  iff->ifTrue = *expr;

  if (binaryPos && func) {
    func->delimiterLocations[iff][BinaryLocations::Else] =
      lastBinaryPos - codeSectionOffset;

    // Note the start of the if (which will be lost as the If is closed and the
    // Else begins, but the if spans them both).
    func->expressionLocations[iff].start = scope.startPos - codeSectionOffset;
  }

  return pushScope(ScopeCtx::makeElse(std::move(scope)));
}

void setCatchBody(Try* tryy, Expression* expr, Index index) {
  // Indexes are managed manually to support Outlining.
  // Its prepopulated try catchBodies and catchTags vectors
  // cannot be appended to, as in the case of the empty try
  // used during parsing.
  if (tryy->catchBodies.size() < index) {
    tryy->catchBodies.resize(tryy->catchBodies.size() + 1);
  }
  // The first time visitCatch is called: the body of the
  // try is set and catchBodies is not appended to, but the tag
  // for the following catch is appended. So, catchTags uses
  // index as-is, but catchBodies uses index-1.
  tryy->catchBodies[index - 1] = expr;
}

Result<> IRBuilder::visitCatch(Name tag) {
  auto scope = getScope();
  bool wasTry = true;
  auto* tryy = scope.getTry();
  if (!tryy) {
    wasTry = false;
    tryy = scope.getCatch();
  }
  if (!tryy) {
    return Err{"unexpected catch"};
  }
  auto index = scope.getIndex();
  auto expr = finishScope();
  CHECK_ERR(expr);
  if (wasTry) {
    tryy->body = *expr;
  } else {
    setCatchBody(tryy, *expr, index);
  }
  if (tryy->catchTags.size() == index) {
    tryy->catchTags.resize(tryy->catchTags.size() + 1);
  }
  tryy->catchTags[index] = tag;

  if (binaryPos && func) {
    auto& delimiterLocs = func->delimiterLocations[tryy];
    delimiterLocs[delimiterLocs.size()] = lastBinaryPos - codeSectionOffset;
    // TODO: As in visitElse, we likely need to stash the Try start. Here we
    //       also need to account for multiple catches.
  }

  CHECK_ERR(pushScope(ScopeCtx::makeCatch(std::move(scope), tryy)));
  // Push a pop for the exception payload if necessary.
  auto params = wasm.getTag(tag)->params();
  if (params != Type::none) {
    // Note that we have a pop to help determine later whether we need to run
    // the fixup for pops within blocks.
    scopeStack[0].notePop();
    pushSynthetic(builder.makePop(params));
  }

  return Ok{};
}

Result<> IRBuilder::visitCatchAll() {
  auto scope = getScope();
  bool wasTry = true;
  auto* tryy = scope.getTry();
  if (!tryy) {
    wasTry = false;
    tryy = scope.getCatch();
  }
  if (!tryy) {
    return Err{"unexpected catch"};
  }
  auto index = scope.getIndex();
  auto expr = finishScope();
  CHECK_ERR(expr);
  if (wasTry) {
    tryy->body = *expr;
  } else {
    setCatchBody(tryy, *expr, index);
  }

  if (binaryPos && func) {
    auto& delimiterLocs = func->delimiterLocations[tryy];
    delimiterLocs[delimiterLocs.size()] = lastBinaryPos - codeSectionOffset;
  }

  return pushScope(ScopeCtx::makeCatchAll(std::move(scope), tryy));
}

Result<> IRBuilder::visitDelegate(Index label) {
  auto& scope = getScope();
  auto* tryy = scope.getTry();
  if (!tryy) {
    return Err{"unexpected delegate"};
  }
  // In Binaryen IR, delegates can only target try or function scopes directly.
  // Search upward to find the nearest enclosing try or function scope. Since
  // the given label is relative the parent scope of the try, start by adjusting
  // it to be relative to the try scope.
  ++label;
  for (size_t size = scopeStack.size(); label < size; ++label) {
    auto& delegateScope = scopeStack[size - label - 1];
    if (delegateScope.getTry()) {
      auto delegateName = getDelegateLabelName(label);
      CHECK_ERR(delegateName);
      tryy->delegateTarget = *delegateName;
      break;
    } else if (delegateScope.getFunction()) {
      tryy->delegateTarget = DELEGATE_CALLER_TARGET;
      break;
    }
  }
  if (label == scopeStack.size()) {
    return Err{"unexpected delegate"};
  }
  // Delegate ends the try.
  return visitEnd();
}

Result<> IRBuilder::visitEnd() {
  auto scope = getScope();
  if (scope.isNone()) {
    return Err{"unexpected end"};
  }
  if (auto* func = scope.getFunction()) {
    if (auto* loc = std::get_if<Function::DebugLocation>(&debugLoc)) {
      func->epilogLocation = *loc;
    }
  }
  debugLoc = CanReceiveDebug();
  auto expr = finishScope(scope.getBlock());
  CHECK_ERR(expr);

  bool isTry = scope.getTry() || scope.getCatch() || scope.getCatchAll();
  auto& label = isTry ? scope.branchLabel : scope.label;
  auto blockType = scope.getResultType();

  // If the scope expression cannot be directly labeled, we may need to wrap it
  // in a block.
  auto maybeWrapForLabel = [&](Expression* curr) -> Expression* {
    if (!label) {
      return curr;
    }
    curr = fixExtraOutput(scope, label, curr);
    // We can re-use unnamed blocks instead of wrapping them.
    if (auto* block = curr->dynCast<Block>(); block && !block->name) {
      block->name = label;
      block->type = blockType;
      return block;
    }
    auto* block = builder.makeBlock();
    block->name = label;
    block->list.push_back(curr);
    block->finalize(blockType,
                    scope.labelUsed ? Block::HasBreak : Block::NoBreak);
    return block;
  };

  // The binary position we record for the block instruction should start at the
  // beginning of the block, not at the beginning of the `end`.
  lastBinaryPos = scope.startPos;

  if (auto* func = scope.getFunction()) {
    func->body = maybeWrapForLabel(*expr);
    labelDepths.clear();
    if (scope.needsPopFixup()) {
      // We may be in the binary parser, where pops need to be fixed up before
      // we know that EH will be enabled.
      EHUtils::handleBlockNestedPops(
        func, wasm, EHUtils::FeaturePolicy::RunIfNoEH);
    }
    this->func = nullptr;
    blockHint = 0;
    labelHint = 0;
  } else if (auto* block = scope.getBlock()) {
    assert(*expr == block);
    block->name = Name();
    block = fixExtraOutput(scope, label, block)->cast<Block>();
    block->name = label;
    block->finalize(block->type,
                    scope.labelUsed ? Block::HasBreak : Block::NoBreak);
    push(block);
  } else if (auto* loop = scope.getLoop()) {
    loop->body = fixExtraOutput(scope, label, *expr);
    loop->name = scope.label;
    if (scope.inputType != Type::none && scope.labelUsed) {
      // Branches to this loop carry values, but Binaryen IR does not support
      // that. Fix this by trampolining the branches through new code that sets
      // the branch value to the appropriate scratch local.
      fixLoopWithInput(loop, scope.inputType, scope.inputLocal);
    }
    loop->finalize(loop->type);
    push(loop);
  } else if (auto* iff = scope.getIf()) {
    iff->ifTrue = *expr;
    if (scope.inputType != Type::none) {
      // Normally an if without an else must have type none, but if there is an
      // input parameter, the empty else arm must propagate its value.
      // Synthesize an else arm that loads the value from the scratch local.
      iff->ifFalse = builder.makeLocalGet(scope.inputLocal, scope.inputType);
    } else {
      iff->ifFalse = nullptr;
    }
    iff->finalize(iff->type);
    push(maybeWrapForLabel(iff));
  } else if (auto* iff = scope.getElse()) {
    iff->ifFalse = *expr;
    iff->finalize(iff->type);
    push(maybeWrapForLabel(iff));
  } else if (auto* tryy = scope.getTry()) {
    tryy->body = *expr;
    tryy->name = scope.label;
    tryy->finalize(tryy->type);
    push(maybeWrapForLabel(tryy));
  } else if (Try * tryy;
             (tryy = scope.getCatch()) || (tryy = scope.getCatchAll())) {
    auto index = scope.getIndex();
    setCatchBody(tryy, *expr, index);
    tryy->name = scope.label;
    tryy->finalize(tryy->type);
    push(maybeWrapForLabel(tryy));
  } else if (auto* trytable = scope.getTryTable()) {
    trytable->body = *expr;
    trytable->finalize(trytable->type, &wasm);
    push(maybeWrapForLabel(trytable));
  } else {
    WASM_UNREACHABLE("unexpected scope kind");
  }
  return Ok{};
}

Result<std::pair<Index, Name>>
IRBuilder::getExtraOutputLocalAndLabel(Index label, size_t extraArity) {
  auto scope = getScope(label);
  CHECK_ERR(scope);
  auto& s = **scope;
  auto i = extraArity - 1;
  if (s.outputLabels.size() < extraArity) {
    s.outputLocals.resize(extraArity);
    s.outputLabels.resize(extraArity);
  }
  if (!s.outputLabels[i]) {
    auto labelType = s.getLabelType();
    auto it = labelType.begin();
    Type extraType = Tuple(it, it + extraArity);
    auto local = addScratchLocal(extraType);
    CHECK_ERR(local);
    auto name = getLabelName(label);
    s.outputLocals[i] = *local;
    s.outputLabels[i] = makeFresh(*name);
  }

  return std::make_pair(s.outputLocals[i], s.outputLabels[i]);
}

// If there are branches to this scope that carried extra values in scratch
// locals, we need to set up the trampolines those branches will go to. The
// trampolines get the values out of the scratch locals and onto the stack in
// the correct order.
Expression*
IRBuilder::fixExtraOutput(ScopeCtx& scope, Name label, Expression* curr) {
  // Add a trampoline branch target. Reuse unnamed blocks.
  auto addTrampoline =
    [&](Type receivedType, Name trampolineLabel, Name skipLabel) {
      if (auto* block = curr->dynCast<Block>(); block && !block->name) {
        block->name = trampolineLabel;
        if (block->list.back()->type == Type::none) {
          block->list.push_back(builder.makeBreak(skipLabel));
        } else {
          block->list.back() = builder.makeBreak(skipLabel, block->list.back());
        }
        block->type = receivedType;
      } else {
        assert(curr->type != Type::none);
        curr = builder.makeBlock(
          trampolineLabel, {builder.makeBreak(skipLabel, curr)}, receivedType);
      }
    };

  auto labelType = scope.getLabelType();
  Name fallthroughLabel;
  for (Index i = 0; i < scope.outputLabels.size(); ++i) {
    auto extraLabel = scope.outputLabels[i];
    if (!extraLabel) {
      continue;
    }

    auto extraLocal = scope.outputLocals[i];
    auto extraType = func->getLocalType(extraLocal);
    Type receivedType =
      Tuple(labelType.begin() + extraType.size(), labelType.end());

    // For normal blocks, the original fallthrough values can be sent to the
    // scope label and they will end up in the right place, but for loops, the
    // fallthrough values should _not_ go to the scope label. We will add a new
    // branch target at the end to send the fallthrough values to.
    if (scope.getLoop() && !fallthroughLabel) {
      fallthroughLabel = makeFresh(label);
      addTrampoline(receivedType, extraLabel, fallthroughLabel);
    } else {
      addTrampoline(receivedType, extraLabel, label);
    }

    // If all the received values are in the scratch local, just fetch them out.
    if (receivedType == Type::none) {
      assert(extraType == labelType);
      curr = builder.makeSequence(
        curr, builder.makeLocalGet(extraLocal, extraType), extraType);
      continue;
    }

    // Otherwise, we have to reorder the received values past the extra values
    // from the scratch local using an additional scratch local.
    auto receivedLocal = *addScratchLocal(receivedType);
    curr = builder.makeLocalSet(receivedLocal, curr);

    // Concatenate the extra values and received values into a tuple.
    std::vector<Expression*> elems;
    if (extraType.isSingle()) {
      elems.push_back(builder.makeLocalGet(extraLocal, extraType));
    } else {
      for (Index j = 0; j < extraType.size(); ++j) {
        elems.push_back(builder.makeTupleExtract(
          builder.makeLocalGet(extraLocal, extraType), j));
      }
    }
    if (receivedType.isSingle()) {
      elems.push_back(builder.makeLocalGet(receivedLocal, receivedType));
    } else {
      for (Index j = 0; j < receivedType.size(); ++j) {
        elems.push_back(builder.makeTupleExtract(
          builder.makeLocalGet(receivedLocal, receivedType), j));
      }
    }

    curr = builder.makeSequence(curr, builder.makeTupleMake(elems), labelType);
  }

  if (fallthroughLabel) {
    // The loop fallthrough values need to propagate to one final trampoline.
    addTrampoline(scope.getResultType(), fallthroughLabel, label);
  }
  return curr;
}

// Branches to this loop need to be trampolined through code that sets the value
// carried by the branch to the appropriate scratch local before branching to
// the loop. Transform this:
//
//   (loop $l (param t1) (result t2) ...)
//
// to this:
//
//  (loop $l0 (result t2)
//    (block $l1 (result t2)
//      (local.set $scratch ;; set the branch values to the scratch local
//        (block $l (result t1)
//          (br $l1 ;; exit the loop with the fallthrough value, if any.
//            ...   ;; contains branches to $l
//          )
//        )
//      )
//      (br $l0) ;; continue the loop
//    )
//  )
void IRBuilder::fixLoopWithInput(Loop* loop, Type inputType, Index scratch) {
  auto l = loop->name;
  auto l0 = makeFresh(l, 0);
  auto l1 = makeFresh(l, 1);

  Block* inner =
    loop->type == Type::none
      ? builder.blockifyWithName(
          loop->body, l, builder.makeBreak(l1), inputType)
      : builder.makeBlock(l, {builder.makeBreak(l1, loop->body)}, inputType);

  Block* outer = builder.makeBlock(
    l1,
    {builder.makeLocalSet(scratch, inner), builder.makeBreak(l0)},
    loop->type);

  loop->body = outer;
  loop->name = l0;
}

Result<Index> IRBuilder::getLabelIndex(Name label, bool inDelegate) {
  auto it = labelDepths.find(label);
  if (it == labelDepths.end() || it->second.empty()) {
    return Err{"unexpected label '"s + label.toString() + "'"};
  }
  auto index = scopeStack.size() - it->second.back();
  if (inDelegate) {
    if (index == 0) {
      // The real label we're referencing, if it exists, has been shadowed by
      // the `try`. Get the previous label with this name instead. For example:
      //
      // block $l
      //  try $l
      //  delegate $l
      // end
      //
      // The `delegate $l` should target the block, not the try, even though a
      // normal branch to $l in the try's scope would target the try.
      if (it->second.size() <= 1) {
        return Err{"unexpected self-referencing label '"s + label.toString() +
                   "'"};
      }
      index = scopeStack.size() - it->second[it->second.size() - 2];
      assert(index != 0);
    }
    // Adjust the index to be relative to the try.
    --index;
  }
  return index;
}

Result<Name> IRBuilder::getLabelName(Index label, bool forDelegate) {
  auto scope = getScope(label);
  CHECK_ERR(scope);

  // For normal branches to try blocks, we need to use the secondary label.
  bool useTryBranchLabel =
    !forDelegate &&
    ((*scope)->getTry() || (*scope)->getCatch() || (*scope)->getCatchAll());
  auto& scopeLabel =
    useTryBranchLabel ? (*scope)->branchLabel : (*scope)->label;

  if (!scopeLabel) {
    // The scope does not already have a name, so we need to create one.
    if ((*scope)->getBlock()) {
      scopeLabel = makeFresh("block", blockHint++);
    } else {
      scopeLabel = makeFresh("label", labelHint++);
    }
  }
  if (!forDelegate) {
    (*scope)->labelUsed = true;
  }
  return scopeLabel;
}

Result<> IRBuilder::makeNop() {
  push(builder.makeNop());
  return Ok{};
}

Result<> IRBuilder::makeBlock(Name label, Signature sig) {
  auto* block = wasm.allocator.alloc<Block>();
  block->name = label;
  block->type = sig.results;
  return visitBlockStart(block, sig.params);
}

Result<>
IRBuilder::makeIf(Name label, Signature sig, std::optional<bool> likely) {
  auto* iff = wasm.allocator.alloc<If>();
  iff->type = sig.results;
  addBranchHint(iff, likely);
  return visitIfStart(iff, label, sig.params);
}

Result<> IRBuilder::makeLoop(Name label, Signature sig) {
  auto* loop = wasm.allocator.alloc<Loop>();
  loop->name = label;
  loop->type = sig.results;
  return visitLoopStart(loop, sig.params);
}

Result<> IRBuilder::makeBreak(Index label,
                              bool isConditional,
                              std::optional<bool> likely) {
  auto name = getLabelName(label);
  CHECK_ERR(name);
  auto labelType = getLabelType(label);
  CHECK_ERR(labelType);

  Break curr;
  curr.name = *name;
  // Use a dummy condition value if we need to pop a condition.
  curr.condition = isConditional ? &curr : nullptr;
  CHECK_ERR(ChildPopper{*this}.visitBreak(&curr, *labelType));
  auto* br = builder.makeBreak(curr.name, curr.value, curr.condition);
  addBranchHint(br, likely);
  push(br);

  return Ok{};
}

Result<> IRBuilder::makeSwitch(const std::vector<Index>& labels,
                               Index defaultLabel) {
  auto defaultType = getLabelType(defaultLabel);
  CHECK_ERR(defaultType);

  std::vector<Name> names;
  names.reserve(labels.size());
  Type glbLabelType = *defaultType;
  for (auto label : labels) {
    auto name = getLabelName(label);
    CHECK_ERR(name);
    names.push_back(*name);
    auto type = getLabelType(label);
    CHECK_ERR(type);
    glbLabelType = Type::getGreatestLowerBound(glbLabelType, *type);
  }

  auto defaultName = getLabelName(defaultLabel);
  CHECK_ERR(defaultName);

  Switch curr(wasm.allocator);
  CHECK_ERR(ChildPopper{*this}.visitSwitch(&curr, glbLabelType));
  push(builder.makeSwitch(names, *defaultName, curr.condition, curr.value));
  return Ok{};
}

Result<> IRBuilder::makeCall(Name func,
                             bool isReturn,
                             std::optional<std::uint8_t> inline_) {
  auto sig = wasm.getFunction(func)->getSig();
  Call curr(wasm.allocator);
  curr.target = func;
  curr.operands.resize(sig.params.size());
  CHECK_ERR(visitCall(&curr));
  auto* call =
    builder.makeCall(curr.target, curr.operands, sig.results, isReturn);
  push(call);
  addInlineHint(call, inline_);
  return Ok{};
}

Result<> IRBuilder::makeCallIndirect(Name table,
                                     HeapType type,
                                     bool isReturn,
                                     std::optional<std::uint8_t> inline_) {
  if (!type.isSignature()) {
    return Err{"expected function type annotation on call_indirect"};
  }
  CallIndirect curr(wasm.allocator);
  curr.heapType = type;
  curr.operands.resize(type.getSignature().params.size());
  CHECK_ERR(visitCallIndirect(&curr));
  auto* call =
    builder.makeCallIndirect(table, curr.target, curr.operands, type, isReturn);
  push(call);
  addInlineHint(call, inline_);
  return Ok{};
}

Result<> IRBuilder::makeLocalGet(Index local) {
  if (!func) {
    return Err{"local.get is only valid in a function context"};
  }
  push(builder.makeLocalGet(local, func->getLocalType(local)));
  return Ok{};
}

Result<> IRBuilder::makeLocalSet(Index local) {
  if (!func) {
    return Err{"local.set is only valid in a function context"};
  }
  LocalSet curr;
  curr.index = local;
  CHECK_ERR(visitLocalSet(&curr));
  push(builder.makeLocalSet(local, curr.value));
  return Ok{};
}

Result<> IRBuilder::makeLocalTee(Index local) {
  if (!func) {
    return Err{"local.tee is only valid in a function context"};
  }
  LocalSet curr;
  curr.index = local;
  CHECK_ERR(visitLocalSet(&curr));
  push(builder.makeLocalTee(local, curr.value, func->getLocalType(local)));
  return Ok{};
}

Result<> IRBuilder::makeGlobalGet(Name global) {
  push(builder.makeGlobalGet(global, wasm.getGlobal(global)->type));
  return Ok{};
}

Result<> IRBuilder::makeGlobalSet(Name global) {
  GlobalSet curr;
  curr.name = global;
  CHECK_ERR(visitGlobalSet(&curr));
  push(builder.makeGlobalSet(global, curr.value));
  return Ok{};
}

Result<> IRBuilder::makeLoad(unsigned bytes,
                             bool signed_,
                             Address offset,
                             unsigned align,
                             Type type,
                             Name mem) {
  Load curr;
  curr.memory = mem;
  CHECK_ERR(visitLoad(&curr));
  push(builder.makeLoad(bytes, signed_, offset, align, curr.ptr, type, mem));
  return Ok{};
}

Result<> IRBuilder::makeStore(
  unsigned bytes, Address offset, unsigned align, Type type, Name mem) {
  Store curr;
  curr.memory = mem;
  curr.valueType = type;
  CHECK_ERR(visitStore(&curr));
  push(
    builder.makeStore(bytes, offset, align, curr.ptr, curr.value, type, mem));
  return Ok{};
}

Result<>
IRBuilder::makeAtomicLoad(unsigned bytes, Address offset, Type type, Name mem) {
  Load curr;
  curr.memory = mem;
  CHECK_ERR(visitLoad(&curr));
  push(builder.makeAtomicLoad(bytes, offset, curr.ptr, type, mem));
  return Ok{};
}

Result<> IRBuilder::makeAtomicStore(unsigned bytes,
                                    Address offset,
                                    Type type,
                                    Name mem) {
  Store curr;
  curr.memory = mem;
  curr.valueType = type;
  CHECK_ERR(visitStore(&curr));
  push(builder.makeAtomicStore(bytes, offset, curr.ptr, curr.value, type, mem));
  return Ok{};
}

Result<> IRBuilder::makeAtomicRMW(
  AtomicRMWOp op, unsigned bytes, Address offset, Type type, Name mem) {
  AtomicRMW curr;
  curr.memory = mem;
  curr.type = type;
  CHECK_ERR(visitAtomicRMW(&curr));
  push(
    builder.makeAtomicRMW(op, bytes, offset, curr.ptr, curr.value, type, mem));
  return Ok{};
}

Result<> IRBuilder::makeAtomicCmpxchg(unsigned bytes,
                                      Address offset,
                                      Type type,
                                      Name mem) {
  AtomicCmpxchg curr;
  curr.memory = mem;
  CHECK_ERR(ChildPopper{*this}.visitAtomicCmpxchg(&curr, type));
  push(builder.makeAtomicCmpxchg(
    bytes, offset, curr.ptr, curr.expected, curr.replacement, type, mem));
  return Ok{};
}

Result<> IRBuilder::makeAtomicWait(Type type, Address offset, Name mem) {
  AtomicWait curr;
  curr.memory = mem;
  curr.expectedType = type;
  CHECK_ERR(visitAtomicWait(&curr));
  push(builder.makeAtomicWait(
    curr.ptr, curr.expected, curr.timeout, type, offset, mem));
  return Ok{};
}

Result<> IRBuilder::makeAtomicNotify(Address offset, Name mem) {
  AtomicNotify curr;
  curr.memory = mem;
  CHECK_ERR(visitAtomicNotify(&curr));
  push(builder.makeAtomicNotify(curr.ptr, curr.notifyCount, offset, mem));
  return Ok{};
}

Result<> IRBuilder::makeAtomicFence() {
  push(builder.makeAtomicFence());
  return Ok{};
}

Result<> IRBuilder::makePause() {
  push(builder.makePause());
  return Ok{};
}

Result<> IRBuilder::makeSIMDExtract(SIMDExtractOp op, uint8_t lane) {
  SIMDExtract curr;
  CHECK_ERR(visitSIMDExtract(&curr));
  push(builder.makeSIMDExtract(op, curr.vec, lane));
  return Ok{};
}

Result<> IRBuilder::makeSIMDReplace(SIMDReplaceOp op, uint8_t lane) {
  SIMDReplace curr;
  curr.op = op;
  CHECK_ERR(visitSIMDReplace(&curr));
  push(builder.makeSIMDReplace(op, curr.vec, lane, curr.value));
  return Ok{};
}

Result<> IRBuilder::makeSIMDShuffle(const std::array<uint8_t, 16>& lanes) {
  SIMDShuffle curr;
  CHECK_ERR(visitSIMDShuffle(&curr));
  push(builder.makeSIMDShuffle(curr.left, curr.right, lanes));
  return Ok{};
}

Result<> IRBuilder::makeSIMDTernary(SIMDTernaryOp op) {
  SIMDTernary curr;
  CHECK_ERR(visitSIMDTernary(&curr));
  push(builder.makeSIMDTernary(op, curr.a, curr.b, curr.c));
  return Ok{};
}

Result<> IRBuilder::makeSIMDShift(SIMDShiftOp op) {
  SIMDShift curr;
  CHECK_ERR(visitSIMDShift(&curr));
  push(builder.makeSIMDShift(op, curr.vec, curr.shift));
  return Ok{};
}

Result<> IRBuilder::makeSIMDLoad(SIMDLoadOp op,
                                 Address offset,
                                 unsigned align,
                                 Name mem) {
  SIMDLoad curr;
  curr.memory = mem;
  CHECK_ERR(visitSIMDLoad(&curr));
  push(builder.makeSIMDLoad(op, offset, align, curr.ptr, mem));
  return Ok{};
}

Result<> IRBuilder::makeSIMDLoadStoreLane(SIMDLoadStoreLaneOp op,
                                          Address offset,
                                          unsigned align,
                                          uint8_t lane,
                                          Name mem) {
  SIMDLoadStoreLane curr;
  curr.memory = mem;
  CHECK_ERR(visitSIMDLoadStoreLane(&curr));
  push(builder.makeSIMDLoadStoreLane(
    op, offset, align, lane, curr.ptr, curr.vec, mem));
  return Ok{};
}

Result<> IRBuilder::makeMemoryInit(Name data, Name mem) {
  MemoryInit curr;
  curr.memory = mem;
  CHECK_ERR(visitMemoryInit(&curr));
  push(builder.makeMemoryInit(data, curr.dest, curr.offset, curr.size, mem));
  return Ok{};
}

Result<> IRBuilder::makeDataDrop(Name data) {
  push(builder.makeDataDrop(data));
  return Ok{};
}

Result<> IRBuilder::makeMemoryCopy(Name destMem, Name srcMem) {
  MemoryCopy curr;
  curr.destMemory = destMem;
  curr.sourceMemory = srcMem;
  CHECK_ERR(visitMemoryCopy(&curr));
  push(
    builder.makeMemoryCopy(curr.dest, curr.source, curr.size, destMem, srcMem));
  return Ok{};
}

Result<> IRBuilder::makeMemoryFill(Name mem) {
  MemoryFill curr;
  curr.memory = mem;
  CHECK_ERR(visitMemoryFill(&curr));
  push(builder.makeMemoryFill(curr.dest, curr.value, curr.size, mem));
  return Ok{};
}

Result<> IRBuilder::makeConst(Literal val) {
  push(builder.makeConst(val));
  return Ok{};
}

Result<> IRBuilder::makeUnary(UnaryOp op) {
  Unary curr;
  curr.op = op;
  CHECK_ERR(visitUnary(&curr));
  push(builder.makeUnary(op, curr.value));
  return Ok{};
}

Result<> IRBuilder::makeBinary(BinaryOp op) {
  Binary curr;
  curr.op = op;
  CHECK_ERR(visitBinary(&curr));
  push(builder.makeBinary(op, curr.left, curr.right));
  return Ok{};
}

Result<> IRBuilder::makeSelect(std::optional<Type> type) {
  Select curr;
  CHECK_ERR(visitSelect(&curr));
  auto* built = builder.makeSelect(curr.condition, curr.ifTrue, curr.ifFalse);
  if (type && !Type::isSubType(built->type, *type)) {
    return Err{"select type does not match expected type"};
  }
  push(built);
  return Ok{};
}

Result<> IRBuilder::makeDrop() {
  Drop curr;
  CHECK_ERR(ChildPopper{*this}.visitDrop(&curr, 1));
  push(builder.makeDrop(curr.value));
  return Ok{};
}

Result<> IRBuilder::makeReturn() {
  if (!func) {
    return Err{"return is only valid in a function context"};
  }
  Return curr;
  CHECK_ERR(visitReturn(&curr));
  push(builder.makeReturn(curr.value));
  return Ok{};
}

Result<> IRBuilder::makeMemorySize(Name mem) {
  push(builder.makeMemorySize(mem));
  return Ok{};
}

Result<> IRBuilder::makeMemoryGrow(Name mem) {
  MemoryGrow curr;
  curr.memory = mem;
  CHECK_ERR(visitMemoryGrow(&curr));
  push(builder.makeMemoryGrow(curr.delta, mem));
  return Ok{};
}

Result<> IRBuilder::makeUnreachable() {
  push(builder.makeUnreachable());
  return Ok{};
}

Result<> IRBuilder::makePop(Type type) {
  // We don't actually want to create a new Pop expression here because we
  // already create them automatically when starting a legacy catch block that
  // needs one. Just verify that the Pop we are being asked to make is the same
  // type as the Pop we have already made.
  auto& scope = getScope();
  if (!scope.getCatch() || scope.exprStack.size() != 1 ||
      !scope.exprStack[0]->is<Pop>()) {
    return Err{
      "pop instructions may only appear at the beginning of catch blocks"};
  }
  auto expectedType = scope.exprStack[0]->type;
  if (!Type::isSubType(expectedType, type)) {
    return Err{std::string("Expected pop of type ") + expectedType.toString()};
  }
  return Ok{};
}

Result<> IRBuilder::makeRefNull(HeapType type) {
  push(builder.makeRefNull(type));
  return Ok{};
}

Result<> IRBuilder::makeRefIsNull() {
  RefIsNull curr;
  CHECK_ERR(visitRefIsNull(&curr));
  push(builder.makeRefIsNull(curr.value));
  return Ok{};
}

Result<> IRBuilder::makeRefFunc(Name func) {
  push(builder.makeRefFunc(func, wasm.getFunction(func)->type));
  return Ok{};
}

Result<> IRBuilder::makeRefEq() {
  RefEq curr;
  CHECK_ERR(visitRefEq(&curr));
  push(builder.makeRefEq(curr.left, curr.right));
  return Ok{};
}

Result<> IRBuilder::makeTableGet(Name table) {
  TableGet curr;
  curr.table = table;
  CHECK_ERR(visitTableGet(&curr));
  auto type = wasm.getTable(table)->type;
  push(builder.makeTableGet(table, curr.index, type));
  return Ok{};
}

Result<> IRBuilder::makeTableSet(Name table) {
  TableSet curr;
  curr.table = table;
  CHECK_ERR(visitTableSet(&curr));
  push(builder.makeTableSet(table, curr.index, curr.value));
  return Ok{};
}

Result<> IRBuilder::makeTableSize(Name table) {
  push(builder.makeTableSize(table));
  return Ok{};
}

Result<> IRBuilder::makeTableGrow(Name table) {
  TableGrow curr;
  curr.table = table;
  CHECK_ERR(visitTableGrow(&curr));
  push(builder.makeTableGrow(table, curr.value, curr.delta));
  return Ok{};
}

Result<> IRBuilder::makeTableFill(Name table) {
  TableFill curr;
  curr.table = table;
  CHECK_ERR(visitTableFill(&curr));
  push(builder.makeTableFill(table, curr.dest, curr.value, curr.size));
  return Ok{};
}

Result<> IRBuilder::makeTableCopy(Name destTable, Name srcTable) {
  TableCopy curr;
  curr.destTable = destTable;
  curr.sourceTable = srcTable;
  CHECK_ERR(visitTableCopy(&curr));
  push(builder.makeTableCopy(
    curr.dest, curr.source, curr.size, destTable, srcTable));
  return Ok{};
}

Result<> IRBuilder::makeTableInit(Name elem, Name table) {
  TableInit curr;
  curr.table = table;
  CHECK_ERR(visitTableInit(&curr));
  push(builder.makeTableInit(elem, curr.dest, curr.offset, curr.size, table));
  return Ok{};
}

Result<> IRBuilder::makeElemDrop(Name segment) {
  push(builder.makeElemDrop(segment));
  return Ok{};
}

Result<> IRBuilder::makeTry(Name label, Signature sig) {
  auto* tryy = wasm.allocator.alloc<Try>();
  tryy->type = sig.results;
  return visitTryStart(tryy, label, sig.params);
}

Result<> IRBuilder::makeTryTable(Name label,
                                 Signature sig,
                                 const std::vector<Name>& tags,
                                 const std::vector<Index>& labels,
                                 const std::vector<bool>& isRefs) {
  auto* trytable = wasm.allocator.alloc<TryTable>();
  trytable->type = sig.results;
  trytable->catchTags.set(tags);
  trytable->catchRefs.set(isRefs);
  trytable->catchDests.reserve(labels.size());
  for (auto label : labels) {
    auto name = getLabelName(label);
    CHECK_ERR(name);
    trytable->catchDests.push_back(*name);
  }
  return visitTryTableStart(trytable, label, sig.params);
}

Result<> IRBuilder::makeThrow(Name tag) {
  Throw curr(wasm.allocator);
  curr.tag = tag;
  curr.operands.resize(wasm.getTag(tag)->params().size());
  CHECK_ERR(visitThrow(&curr));
  push(builder.makeThrow(tag, curr.operands));
  return Ok{};
}

Result<> IRBuilder::makeRethrow(Index label) {
  // Rethrow references `Try` labels directly, just like `delegate`.
  auto name = getDelegateLabelName(label);
  CHECK_ERR(name);
  push(builder.makeRethrow(*name));
  return Ok{};
}

Result<> IRBuilder::makeThrowRef() {
  ThrowRef curr;
  CHECK_ERR(visitThrowRef(&curr));
  push(builder.makeThrowRef(curr.exnref));
  return Ok{};
}

Result<> IRBuilder::makeTupleMake(uint32_t arity) {
  if (arity < 2) {
    return Err{"tuple arity must be at least 2"};
  }
  TupleMake curr(wasm.allocator);
  curr.operands.resize(arity);
  CHECK_ERR(visitTupleMake(&curr));
  push(builder.makeTupleMake(curr.operands));
  return Ok{};
}

Result<> IRBuilder::makeTupleExtract(uint32_t arity, uint32_t index) {
  if (index >= arity) {
    return Err{"tuple index out of bounds"};
  }
  if (arity < 2) {
    return Err{"tuple arity must be at least 2"};
  }
  TupleExtract curr;
  CHECK_ERR(ChildPopper{*this}.visitTupleExtract(&curr, arity));
  push(builder.makeTupleExtract(curr.tuple, index));
  return Ok{};
}

Result<> IRBuilder::makeTupleDrop(uint32_t arity) {
  if (arity < 2) {
    return Err{"tuple arity must be at least 2"};
  }
  Drop curr;
  CHECK_ERR(ChildPopper{*this}.visitDrop(&curr, arity));
  push(builder.makeDrop(curr.value));
  return Ok{};
}

Result<> IRBuilder::makeRefI31(Shareability share) {
  RefI31 curr;
  CHECK_ERR(visitRefI31(&curr));
  push(builder.makeRefI31(curr.value, share));
  return Ok{};
}

Result<> IRBuilder::makeI31Get(bool signed_) {
  I31Get curr;
  CHECK_ERR(visitI31Get(&curr));
  push(builder.makeI31Get(curr.i31, signed_));
  return Ok{};
}

Result<> IRBuilder::makeCallRef(HeapType type,
                                bool isReturn,
                                std::optional<std::uint8_t> inline_) {
  if (!type.isSignature()) {
    return Err{"expected function type annotation on call_ref"};
  }
  CallRef curr(wasm.allocator);
  if (!type.isSignature()) {
    return Err{"expected function type"};
  }
  auto sig = type.getSignature();
  curr.operands.resize(type.getSignature().params.size());
  CHECK_ERR(ChildPopper{*this}.visitCallRef(&curr, type));
  CHECK_ERR(validateTypeAnnotation(type, curr.target));
  auto* call =
    builder.makeCallRef(curr.target, curr.operands, sig.results, isReturn);
  push(call);
  addInlineHint(call, inline_);
  return Ok{};
}

Result<> IRBuilder::makeRefTest(Type type) {
  RefTest curr;
  curr.castType = type;
  CHECK_ERR(visitRefTest(&curr));
  push(builder.makeRefTest(curr.ref, type));
  return Ok{};
}

Result<> IRBuilder::makeRefCast(Type type, bool isDesc) {
  std::optional<HeapType> descriptor;
  if (isDesc) {
    assert(type.isRef());
    descriptor = type.getHeapType().getDescriptorType();
    if (!descriptor) {
      return Err{"cast target must have descriptor"};
    }
  }

  RefCast curr;
  curr.type = type;
  // Placeholder value to differentiate ref.cast_desc.
  curr.desc = isDesc ? &curr : nullptr;
  CHECK_ERR(visitRefCast(&curr));

  if (isDesc) {
    CHECK_ERR(
      validateTypeAnnotation(type.with(*descriptor).with(Nullable), curr.desc));
  }

  push(builder.makeRefCast(curr.ref, curr.desc, type));
  return Ok{};
}

Result<> IRBuilder::makeRefGetDesc(HeapType type) {
  RefGetDesc curr;
  if (!type.getDescriptorType()) {
    return Err{"expected type with descriptor"};
  }
  CHECK_ERR(ChildPopper{*this}.visitRefGetDesc(&curr, type));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  push(builder.makeRefGetDesc(curr.ref));
  return Ok{};
}

Result<> IRBuilder::makeBrOn(
  Index label, BrOnOp op, Type in, Type out, std::optional<bool> likely) {
  std::optional<HeapType> descriptor;
  if (op == BrOnCastDesc || op == BrOnCastDescFail) {
    assert(out.isRef());
    descriptor = out.getHeapType().getDescriptorType();
    if (!descriptor) {
      return Err{"cast target must have descriptor"};
    }
  }

  BrOn curr;
  curr.op = op;
  curr.castType = out;
  curr.desc = nullptr;
  CHECK_ERR(visitBrOn(&curr));

  // Validate type immediates before we forget them.
  switch (op) {
    case BrOnNull:
    case BrOnNonNull:
      break;
    case BrOnCastDesc:
    case BrOnCastDescFail: {
      CHECK_ERR(validateTypeAnnotation(out.with(*descriptor).with(Nullable),
                                       curr.desc));
    }
      [[fallthrough]];
    case BrOnCast:
    case BrOnCastFail:
      assert(in.isRef());
      CHECK_ERR(validateTypeAnnotation(in, curr.ref));
  }

  // Extra values need to be sent in a scratch local.
  auto labelType = getLabelType(label);
  CHECK_ERR(labelType);
  auto extraArity = labelType->size();
  switch (op) {
    case BrOnNull:
      // Modeled as sending no values.
      break;
    case BrOnNonNull:
    case BrOnCast:
    case BrOnCastFail:
    case BrOnCastDesc:
    case BrOnCastDescFail:
      // Modeled as sending one value.
      if (extraArity == 0) {
        return Err{"br_on target does not expect a value"};
      }
      extraArity -= 1;
      break;
  }

  // Before we can put the extra values into the output scratch local, we need
  // to stash the value under test in another scratch local. Find the type of
  // that local.
  Type testType;
  switch (op) {
    case BrOnNull:
    case BrOnNonNull:
      testType = curr.ref->type;
      break;
    case BrOnCast:
    case BrOnCastFail:
    case BrOnCastDesc:
    case BrOnCastDescFail:
      testType = in;
      break;
  }

  // If the value under test is unreachable, then we can proceed without putting
  // anything in locals since the branch will never be taken. The extra values
  // will just be dropped. We can't leave this optimization to DCE because we
  // wouldn't know what type to use for the scratch local if we tried to
  // continue.
  if (!extraArity || testType == Type::unreachable) {
    auto name = getLabelName(label);
    CHECK_ERR(name);

    auto* br = builder.makeBrOn(op, *name, curr.ref, out, curr.desc);
    addBranchHint(br, likely);
    push(br);
    return Ok{};
  }

  auto testLocal = addScratchLocal(testType);
  CHECK_ERR(testLocal);

  // Put the value under test back on the stack and stash it.
  getScope().exprStack.push_back(curr.ref);
  CHECK_ERR(makeLocalSet(*testLocal));

  // Now we can stash the extra values.
  auto info = getExtraOutputLocalAndLabel(label, extraArity);
  CHECK_ERR(info);
  auto [extraLocal, extraLabel] = *info;
  CHECK_ERR(makeLocalSet(extraLocal));

  // Restore the test value.
  CHECK_ERR(makeLocalGet(*testLocal));

  // Perform the branch.
  CHECK_ERR(visitBrOn(&curr));
  auto* br = builder.makeBrOn(op, extraLabel, curr.ref, out, curr.desc);
  addBranchHint(br, likely);
  push(br);

  // If the branch wasn't taken, we need to leave the extra values on the
  // stack. For all instructions except br_on_non_null the extra values need
  // to be under the result value. br_on_non_null does not have a result
  // value, so it is simpler.
  if (op == BrOnNonNull) {
    CHECK_ERR(makeLocalGet(extraLocal));
    return Ok{};
  }

  Type resultType;
  switch (op) {
    case BrOnNull:
      resultType = Type(testType.getHeapType(), NonNullable);
      break;
    case BrOnNonNull:
      WASM_UNREACHABLE("unexpected op");
    case BrOnCast:
    case BrOnCastDesc:
      if (out.isNullable()) {
        resultType = Type(in.getHeapType(), NonNullable);
      } else {
        resultType = in;
      }
      break;
    case BrOnCastFail:
    case BrOnCastDescFail:
      if (in.isNonNullable()) {
        resultType = Type(out.getHeapType(), NonNullable);
      } else {
        resultType = out;
      }
      break;
  }

  auto resultLocal = addScratchLocal(resultType);
  CHECK_ERR(resultLocal);

  CHECK_ERR(makeLocalSet(*resultLocal));
  CHECK_ERR(makeLocalGet(extraLocal));
  CHECK_ERR(makeLocalGet(*resultLocal));
  return Ok{};
}

Result<> IRBuilder::makeStructNew(HeapType type) {
  if (!type.isStruct()) {
    return Err{"expected struct type annotation on struct.new"};
  }
  StructNew curr(wasm.allocator);
  curr.type = Type(type, NonNullable, Exact);
  curr.operands.resize(type.getStruct().fields.size());
  CHECK_ERR(visitStructNew(&curr));
  push(builder.makeStructNew(type, std::move(curr.operands), curr.desc));
  return Ok{};
}

Result<> IRBuilder::makeStructNewDefault(HeapType type) {
  StructNew curr(wasm.allocator);
  curr.type = Type(type, NonNullable, Exact);
  CHECK_ERR(visitStructNew(&curr));
  push(builder.makeStructNew(type, {}, curr.desc));
  return Ok{};
}

Result<> IRBuilder::makeStructGet(HeapType type,
                                  Index field,
                                  bool signed_,
                                  MemoryOrder order) {
  const auto& fields = type.getStruct().fields;
  StructGet curr;
  CHECK_ERR(ChildPopper{*this}.visitStructGet(&curr, type));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  push(
    builder.makeStructGet(field, curr.ref, order, fields[field].type, signed_));
  return Ok{};
}

Result<>
IRBuilder::makeStructSet(HeapType type, Index field, MemoryOrder order) {
  if (!type.isStruct()) {
    return Err{"expected struct type annotation on struct.set"};
  }
  StructSet curr;
  curr.index = field;
  CHECK_ERR(ChildPopper{*this}.visitStructSet(&curr, type));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  push(builder.makeStructSet(field, curr.ref, curr.value, order));
  return Ok{};
}

Result<> IRBuilder::makeStructRMW(AtomicRMWOp op,
                                  HeapType type,
                                  Index field,
                                  MemoryOrder order) {
  if (!type.isStruct()) {
    return Err{"expected struct type annotation on struct.atomic.rmw"};
  }
  StructRMW curr;
  curr.index = field;
  CHECK_ERR(ChildPopper{*this}.visitStructRMW(&curr, type));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  push(builder.makeStructRMW(op, field, curr.ref, curr.value, order));
  return Ok{};
}

Result<>
IRBuilder::makeStructCmpxchg(HeapType type, Index field, MemoryOrder order) {
  if (!type.isStruct()) {
    return Err{"expected struct type annotation on struct.atomic.rmw"};
  }
  StructCmpxchg curr;
  curr.index = field;
  CHECK_ERR(ChildPopper{*this}.visitStructCmpxchg(&curr, type));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  push(builder.makeStructCmpxchg(
    field, curr.ref, curr.expected, curr.replacement, order));
  return Ok{};
}

Result<> IRBuilder::makeArrayNew(HeapType type) {
  if (!type.isArray()) {
    return Err{"expected array type annotation on array.new"};
  }
  ArrayNew curr;
  curr.type = Type(type, NonNullable, Exact);
  // Differentiate from array.new_default with dummy initializer.
  curr.init = (Expression*)0x01;
  CHECK_ERR(visitArrayNew(&curr));
  push(builder.makeArrayNew(type, curr.size, curr.init));
  return Ok{};
}

Result<> IRBuilder::makeArrayNewDefault(HeapType type) {
  ArrayNew curr;
  curr.init = nullptr;
  CHECK_ERR(visitArrayNew(&curr));
  push(builder.makeArrayNew(type, curr.size));
  return Ok{};
}

Result<> IRBuilder::makeArrayNewData(HeapType type, Name data) {
  ArrayNewData curr;
  CHECK_ERR(visitArrayNewData(&curr));
  push(builder.makeArrayNewData(type, data, curr.offset, curr.size));
  return Ok{};
}

Result<> IRBuilder::makeArrayNewElem(HeapType type, Name elem) {
  ArrayNewElem curr;
  CHECK_ERR(visitArrayNewElem(&curr));
  push(builder.makeArrayNewElem(type, elem, curr.offset, curr.size));
  return Ok{};
}

Result<> IRBuilder::makeArrayNewFixed(HeapType type, uint32_t arity) {
  if (!type.isArray()) {
    return Err{"expected array type annotation on array.new_fixed"};
  }
  ArrayNewFixed curr(wasm.allocator);
  curr.type = Type(type, NonNullable);
  curr.values.resize(arity);
  CHECK_ERR(visitArrayNewFixed(&curr));
  push(builder.makeArrayNewFixed(type, curr.values));
  return Ok{};
}

Result<>
IRBuilder::makeArrayGet(HeapType type, bool signed_, MemoryOrder order) {
  ArrayGet curr;
  CHECK_ERR(ChildPopper{*this}.visitArrayGet(&curr, type));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  push(builder.makeArrayGet(
    curr.ref, curr.index, order, type.getArray().element.type, signed_));
  return Ok{};
}

Result<> IRBuilder::makeArraySet(HeapType type, MemoryOrder order) {
  if (!type.isArray()) {
    return Err{"expected array type annotation on array.set"};
  }
  ArraySet curr;
  CHECK_ERR(ChildPopper{*this}.visitArraySet(&curr, type));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  push(builder.makeArraySet(curr.ref, curr.index, curr.value, order));
  return Ok{};
}

Result<> IRBuilder::makeArrayLen() {
  ArrayLen curr;
  CHECK_ERR(visitArrayLen(&curr));
  push(builder.makeArrayLen(curr.ref));
  return Ok{};
}

Result<> IRBuilder::makeArrayCopy(HeapType destType, HeapType srcType) {
  ArrayCopy curr;
  CHECK_ERR(ChildPopper{*this}.visitArrayCopy(&curr, destType, srcType));
  CHECK_ERR(validateTypeAnnotation(destType, curr.destRef));
  CHECK_ERR(validateTypeAnnotation(srcType, curr.srcRef));
  push(builder.makeArrayCopy(
    curr.destRef, curr.destIndex, curr.srcRef, curr.srcIndex, curr.length));
  return Ok{};
}

Result<> IRBuilder::makeArrayFill(HeapType type) {
  if (!type.isArray()) {
    return Err{"expected array type annotation on array.fill"};
  }
  ArrayFill curr;
  CHECK_ERR(ChildPopper{*this}.visitArrayFill(&curr, type));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  push(builder.makeArrayFill(curr.ref, curr.index, curr.value, curr.size));
  return Ok{};
}

Result<> IRBuilder::makeArrayInitData(HeapType type, Name data) {
  ArrayInitData curr;
  CHECK_ERR(ChildPopper{*this}.visitArrayInitData(&curr, type));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  push(builder.makeArrayInitData(
    data, curr.ref, curr.index, curr.offset, curr.size));
  return Ok{};
}

Result<> IRBuilder::makeArrayInitElem(HeapType type, Name elem) {
  // Validate the elem type, too, before we potentially forget the type
  // annotation.
  if (!type.isArray()) {
    return Err{"expected array type annotation on array.init_elem"};
  }
  if (!Type::isSubType(wasm.getElementSegment(elem)->type,
                       type.getArray().element.type)) {
    return Err{"element segment type must be a subtype of array element type "
               "on array.init_elem"};
  }
  ArrayInitElem curr;
  CHECK_ERR(ChildPopper{*this}.visitArrayInitElem(&curr, type));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  push(builder.makeArrayInitElem(
    elem, curr.ref, curr.index, curr.offset, curr.size));
  return Ok{};
}

Result<>
IRBuilder::makeArrayRMW(AtomicRMWOp op, HeapType type, MemoryOrder order) {
  if (!type.isArray()) {
    return Err{"expected array type annotation on array.atomic.rmw"};
  }
  ArrayRMW curr;
  CHECK_ERR(ChildPopper{*this}.visitArrayRMW(&curr, type));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  push(builder.makeArrayRMW(op, curr.ref, curr.index, curr.value, order));
  return Ok{};
}

Result<> IRBuilder::makeArrayCmpxchg(HeapType type, MemoryOrder order) {
  if (!type.isArray()) {
    return Err{"expected array type annotation on array.atomic.rmw"};
  }
  ArrayCmpxchg curr;
  CHECK_ERR(ChildPopper{*this}.visitArrayCmpxchg(&curr, type));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  push(builder.makeArrayCmpxchg(
    curr.ref, curr.index, curr.expected, curr.replacement, order));
  return Ok{};
}

Result<> IRBuilder::makeRefAs(RefAsOp op) {
  RefAs curr;
  curr.op = op;
  CHECK_ERR(visitRefAs(&curr));
  push(builder.makeRefAs(op, curr.value));
  return Ok{};
}

Result<> IRBuilder::makeStringNew(StringNewOp op) {
  StringNew curr;
  curr.op = op;
  if (op == StringNewFromCodePoint) {
    CHECK_ERR(visitStringNew(&curr));
    push(builder.makeStringNew(op, curr.ref));
    return Ok{};
  }
  CHECK_ERR(visitStringNew(&curr));
  push(builder.makeStringNew(op, curr.ref, curr.start, curr.end));
  return Ok{};
}

Result<> IRBuilder::makeStringConst(Name string) {
  push(builder.makeStringConst(string));
  return Ok{};
}

Result<> IRBuilder::makeStringMeasure(StringMeasureOp op) {
  StringMeasure curr;
  curr.op = op;
  CHECK_ERR(visitStringMeasure(&curr));
  push(builder.makeStringMeasure(op, curr.ref));
  return Ok{};
}

Result<> IRBuilder::makeStringEncode(StringEncodeOp op) {
  StringEncode curr;
  curr.op = op;
  CHECK_ERR(visitStringEncode(&curr));
  push(builder.makeStringEncode(op, curr.str, curr.array, curr.start));
  return Ok{};
}

Result<> IRBuilder::makeStringConcat() {
  StringConcat curr;
  CHECK_ERR(visitStringConcat(&curr));
  push(builder.makeStringConcat(curr.left, curr.right));
  return Ok{};
}

Result<> IRBuilder::makeStringEq(StringEqOp op) {
  StringEq curr;
  CHECK_ERR(visitStringEq(&curr));
  push(builder.makeStringEq(op, curr.left, curr.right));
  return Ok{};
}

Result<> IRBuilder::makeStringTest() {
  StringTest curr;
  CHECK_ERR(visitStringTest(&curr));
  push(builder.makeStringTest(curr.ref));
  return Ok{};
}

Result<> IRBuilder::makeStringWTF16Get() {
  StringWTF16Get curr;
  CHECK_ERR(visitStringWTF16Get(&curr));
  push(builder.makeStringWTF16Get(curr.ref, curr.pos));
  return Ok{};
}

Result<> IRBuilder::makeStringSliceWTF() {
  StringSliceWTF curr;
  CHECK_ERR(visitStringSliceWTF(&curr));
  push(builder.makeStringSliceWTF(curr.ref, curr.start, curr.end));
  return Ok{};
}

Result<> IRBuilder::makeContNew(HeapType type) {
  if (!type.isContinuation()) {
    return Err{"expected continuation type"};
  }
  ContNew curr;
  curr.type = Type(type, NonNullable);
  CHECK_ERR(visitContNew(&curr));

  push(builder.makeContNew(type, curr.func));
  return Ok{};
}

Result<> IRBuilder::makeContBind(HeapType sourceType, HeapType targetType) {
  if (!sourceType.isContinuation() || !targetType.isContinuation()) {
    return Err{"expected continuation type annotations on cont.bind"};
  }
  ContBind curr(wasm.allocator);

  curr.type = Type(targetType, NonNullable);
  size_t sourceParams =
    sourceType.getContinuation().type.getSignature().params.size();
  size_t targetParams =
    targetType.getContinuation().type.getSignature().params.size();
  if (sourceParams < targetParams) {
    return Err{"incompatible continuation types in cont.bind: source type " +
               sourceType.toString() + " has fewer parameters than target " +
               targetType.toString()};
  }
  curr.operands.resize(sourceParams - targetParams);
  CHECK_ERR(ChildPopper{*this}.visitContBind(&curr, sourceType, targetType));
  CHECK_ERR(validateTypeAnnotation(sourceType, curr.cont));
  CHECK_ERR(validateTypeAnnotation(targetType, &curr));

  push(builder.makeContBind(targetType, std::move(curr.operands), curr.cont));
  return Ok{};
}

Result<> IRBuilder::makeSuspend(Name tag) {
  Suspend curr(wasm.allocator);
  curr.tag = tag;
  curr.operands.resize(wasm.getTag(tag)->params().size());
  CHECK_ERR(visitSuspend(&curr));

  std::vector<Expression*> operands(curr.operands.begin(), curr.operands.end());
  push(builder.makeSuspend(tag, operands));
  return Ok{};
}

struct ResumeTable {
  std::vector<Name> targets;
  std::vector<Type> sentTypes;
};

static Result<ResumeTable>
makeResumeTable(const std::vector<std::optional<Index>>& labels,
                std::function<Result<Name>(Index)> getLabelName,
                std::function<Result<Type>(Index)> getLabelType) {
  std::vector<Name> targets;
  targets.reserve(labels.size());

  std::vector<Type> sentTypes;
  sentTypes.reserve(sentTypes.size());

  for (Index i = 0; i < labels.size(); i++) {
    Name target;
    Type sentType;
    if (labels[i].has_value()) {
      // (on $tag $label) clause
      Index labelIndex = labels[i].value();
      Result<Name> name = getLabelName(labelIndex);
      CHECK_ERR(name);
      target = *name;

      Result<Type> targetType = getLabelType(labelIndex);
      CHECK_ERR(targetType);
      if (targetType->isContinuation()) {
        sentType = *targetType;
      } else if (targetType->isTuple() &&
                 targetType->getTuple().back().isContinuation()) {
        // The continuation type is expected to be the last element of
        // a multi-valued block.
        sentType = *targetType;
      } else {
        return Err{"expected continuation type"};
      }
    } else {
      // (on $tag switch) clause
      target = Name();
      sentType = Type::none;
    }
    targets.push_back(target);
    sentTypes.push_back(sentType);
  }
  return ResumeTable{std::move(targets), std::move(sentTypes)};
}

Result<>
IRBuilder::makeResume(HeapType ct,
                      const std::vector<Name>& tags,
                      const std::vector<std::optional<Index>>& labels) {
  if (tags.size() != labels.size()) {
    return Err{"the sizes of tags and labels must be equal"};
  }
  if (!ct.isContinuation()) {
    return Err{"expected continuation type annotation on resume"};
  }

  Resume curr(wasm.allocator);
  auto contSig = ct.getContinuation().type.getSignature();
  curr.operands.resize(contSig.params.size());

  Result<ResumeTable> resumetable = makeResumeTable(
    labels,
    [this](Index i) { return this->getLabelName(i); },
    [this](Index i) { return this->getLabelType(i); });
  CHECK_ERR(resumetable);
  CHECK_ERR(ChildPopper{*this}.visitResume(&curr, ct));
  CHECK_ERR(validateTypeAnnotation(ct, curr.cont));

  push(builder.makeResume(tags,
                          resumetable->targets,
                          resumetable->sentTypes,
                          std::move(curr.operands),
                          curr.cont));

  return Ok{};
}

Result<>
IRBuilder::makeResumeThrow(HeapType ct,
                           Name tag,
                           const std::vector<Name>& tags,
                           const std::vector<std::optional<Index>>& labels) {
  if (tags.size() != labels.size()) {
    return Err{"the sizes of tags and labels must be equal"};
  }
  if (!ct.isContinuation()) {
    return Err{"expected continuation type annotation on resume_throw"};
  }

  ResumeThrow curr(wasm.allocator);
  curr.tag = tag;
  curr.operands.resize(wasm.getTag(tag)->params().size());

  Result<ResumeTable> resumetable = makeResumeTable(
    labels,
    [this](Index i) { return this->getLabelName(i); },
    [this](Index i) { return this->getLabelType(i); });
  CHECK_ERR(resumetable);
  CHECK_ERR(ChildPopper{*this}.visitResumeThrow(&curr, ct));
  CHECK_ERR(validateTypeAnnotation(ct, curr.cont));

  push(builder.makeResumeThrow(tag,
                               tags,
                               resumetable->targets,
                               resumetable->sentTypes,
                               std::move(curr.operands),
                               curr.cont));
  return Ok{};
}

Result<> IRBuilder::makeStackSwitch(HeapType ct, Name tag) {
  if (!ct.isContinuation()) {
    return Err{"expected continuation type annotation on switch"};
  }
  StackSwitch curr(wasm.allocator);
  curr.tag = tag;
  auto nparams = ct.getContinuation().type.getSignature().params.size();
  if (nparams < 1) {
    return Err{"arity mismatch: the continuation argument must have, at least, "
               "unary arity"};
  }

  // The continuation argument of the continuation is synthetic,
  // i.e. it is provided by the runtime.
  curr.operands.resize(nparams - 1);

  CHECK_ERR(ChildPopper{*this}.visitStackSwitch(&curr, ct));
  CHECK_ERR(validateTypeAnnotation(ct, curr.cont));

  push(builder.makeStackSwitch(tag, std::move(curr.operands), curr.cont));
  return Ok{};
}

void IRBuilder::addBranchHint(Expression* expr, std::optional<bool> likely) {
  if (likely) {
    // Branches are only possible inside functions.
    assert(func);
    func->codeAnnotations[expr].branchLikely = likely;
  }
}

void IRBuilder::addInlineHint(Expression* expr,
                              std::optional<uint8_t> inline_) {
  if (inline_) {
    // Branches are only possible inside functions.
    assert(func);
    func->codeAnnotations[expr].inline_ = inline_;
  }
}

} // namespace wasm
