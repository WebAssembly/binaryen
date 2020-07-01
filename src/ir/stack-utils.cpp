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

#include "stack-utils.h"

namespace wasm {

namespace StackUtils {

bool mayBeUnreachable(Expression* curr) {
  switch (curr->_id) {
    case Expression::Id::BreakId:
      return curr->cast<Break>()->condition == nullptr;
    case Expression::Id::CallId:
      return curr->cast<Call>()->isReturn;
    case Expression::Id::CallIndirectId:
      return curr->cast<CallIndirect>()->isReturn;
    case Expression::Id::ReturnId:
    case Expression::Id::SwitchId:
    case Expression::Id::UnreachableId:
    case Expression::Id::ThrowId:
    case Expression::Id::RethrowId:
      return true;
    default:
      return false;
  }
}

void compact(Block* block) {
  size_t newIndex = 0;
  for (size_t i = 0, size = block->list.size(); i < size; ++i) {
    if (!block->list[i]->is<Nop>()) {
      block->list[newIndex++] = block->list[i];
    }
  }
  block->list.resize(newIndex);
}

void lowerUnreachables(Function* func, Module* module) {
  struct UnreachableLowerer
    : Walker<UnreachableLowerer, Visitor<UnreachableLowerer>> {
    // Implementation details
    static void scan(UnreachableLowerer* self, Expression** currp) {
      // Visit only control flow children, since we know all other children will
      // be pops and we are not interested in those. Also pre-visit nodes
      // instead of post-visiting them because type inference depends on parents
      // being typed first.
      Expression* curr = *currp;
      switch (curr->_id) {
        case Expression::Id::BlockId: {
          // Visit children only through the first unreachable, since any
          // further children will be discarded before we could visit them.
          for (auto*& child : curr->cast<Block>()->list) {
            self->pushTask(scan, &child);
            if (child->type == Type::unreachable) {
              break;
            }
          }
          self->pushTask(doVisitBlock, currp);
          break;
        }
        case Expression::Id::IfId:
          self->maybePushTask(scan, &curr->cast<If>()->ifFalse);
          self->pushTask(scan, &curr->cast<If>()->ifTrue);
          self->pushTask(doVisitIf, currp);
          break;
        case Expression::Id::LoopId:
          self->pushTask(scan, &curr->cast<Loop>()->body);
          self->pushTask(doVisitLoop, currp);
          break;
        case Expression::Id::TryId:
          self->pushTask(scan, &curr->cast<Try>()->catchBody);
          self->pushTask(scan, &curr->cast<Try>()->body);
          self->pushTask(scan, &curr->cast<Try>()->body);
          break;
        default:
          break;
      }
    }
    void visitBlock(Block* curr) {
      if (curr->type == Type::unreachable) {
      }
      size_t numReachable = 0;
      for (; numReachable < curr->list.size(); ++numReachable) {
        if (curr->list[numReachable]->type == Type::unreachable) {
          break;
        }
      }
      if (numReachable == curr->list.size()) {
        return;
      }
      // Keep the first unreachable child and nothing after it
      curr->list.resize(numReachable + 1);
      auto* unreachable = curr->list[numReachable];
      // If it is control flow, figure out what type it should have
      if (Properties::isControlFlowStructure(unreachable)) {
        // If `unreachable` consumes any values (besides an i32 if it is an If)
        // or if it produces multiple values and multivalue is not enabled, then
        // append an `unreachable` to the list after all to make the typing work
        // out. Otherwise, update the type accordingly.
        // TODO: Implement control flow input types for use here.
        StackFlow flow(curr);
        auto sig = flow.getSignature(unreachable);
        bool needsExtraUnreachable;
        if (unreachable->is<If>()) {
          needsExtraUnreachable = sig.params != Type::i32;
        } else {
          needsExtraUnreachable = sig.params != Type::none;
        }
        if (!getModule()->features.hasMultivalue() && sig.results.isMulti()) {
          needsExtraUnreachable = true;
        }
        if (needsExtraUnreachable) {
          curr->list.push_back(Builder(*getModule()).makeUnreachable());
          unreachable->type = Type::none;
        } else {
          unreachable->type = sig.results;
        }
      }
    }

    void visitIf(If* curr) {
      // The If type must be a supertype of the individual arm types, so just
      // reuse it for both arms. This can save space in the type section.
      curr->ifTrue->type = curr->type;
      if (curr->ifFalse) {
        curr->ifFalse->type = curr->type;
      }
    }

    void visitLoop(Loop* curr) { curr->body->type = curr->type; }

    void visitTry(Try* curr) {
      curr->body->type = curr->type;
      curr->catchBody->type = curr->type;
    }
  };

  func->body->type = func->sig.results;
  UnreachableLowerer().walkFunctionInModule(func, module);

#ifndef NDEBUG
  // Assert that only instructions that never return have unreachable type
  struct AssertValidUnreachableTypes
    : PostWalker<AssertValidUnreachableTypes,
                 UnifiedExpressionVisitor<AssertValidUnreachableTypes>> {
    void visitExpression(Expression* curr) {
      if (curr->type == Type::unreachable) {
        assert(StackUtils::mayBeUnreachable(curr) &&
               "Unexpected unreachable instruction");
      }
    }
  } asserter;
  asserter.walkFunction(func);
#endif // NDEBUG
}

} // namespace StackUtils

StackSignature::StackSignature(Expression* expr) {
  params = Type::none;
  if (Properties::isControlFlowStructure(expr)) {
    if (expr->is<If>()) {
      params = Type::i32;
    }
  } else {
    std::vector<Type> inputs;
    for (auto* child : ChildIterator(expr)) {
      if (child->type == Type::unreachable) {
        // This instruction won't consume values from before the unreachable
        inputs.clear();
        continue;
      }
      // Children might be tuple pops, so expand their types
      const auto& types = child->type.expand();
      inputs.insert(inputs.end(), types.begin(), types.end());
    }
    params = Type(inputs);
  }
  if (expr->type == Type::unreachable) {
    unreachable = true;
    results = Type::none;
  } else {
    unreachable = false;
    results = expr->type;
  }
}

bool StackSignature::composes(const StackSignature& next) const {
  // TODO
  return true;
}

bool StackSignature::satisfies(Signature sig) const {
  if (unreachable) {
    // The unreachable can consume and produce any additional types needed by
    // `sig`, so truncate `sig`'s params and results to compare only the parts
    // we need to match.
    if (sig.params.size() > params.size()) {
      size_t diff = sig.params.size() - params.size();
      const auto& types = sig.params.expand();
      std::vector<Type> truncatedParams(types.begin(), types.end() - diff);
      sig.params = Type(truncatedParams);
    }
    if (sig.results.size() > results.size()) {
      size_t diff = sig.results.size() - results.size();
      const auto& types = sig.results.expand();
      std::vector<Type> truncatedResults(types.begin() + diff, types.end());
      sig.results = Type(truncatedResults);
    }
  }
  return Type::isSubType(sig.params, params) &&
         Type::isSubType(results, sig.results);
}

StackSignature& StackSignature::operator+=(const StackSignature& next) {
  assert(composes(next));
  std::vector<Type> stack = results.expand();
  size_t required = next.params.size();
  // Consume stack values according to next's parameters
  if (stack.size() >= required) {
    stack.resize(stack.size() - required);
  } else {
    if (!unreachable) {
      const std::vector<Type>& currParams = params.expand();
      const std::vector<Type>& nextParams = next.params.expand();
      // Prepend the unsatisfied params of `next` to the current params
      size_t unsatisfied = required - stack.size();
      std::vector<Type> newParams(nextParams.begin(),
                                  nextParams.begin() + unsatisfied);
      newParams.insert(newParams.end(), currParams.begin(), currParams.end());
      params = Type(newParams);
    }
    stack.clear();
  }
  // Add stack values according to next's results
  if (next.unreachable) {
    results = next.results;
    unreachable = true;
  } else {
    const auto& nextResults = next.results.expand();
    stack.insert(stack.end(), nextResults.begin(), nextResults.end());
    results = Type(stack);
  }
  return *this;
}

StackSignature StackSignature::operator+(const StackSignature& next) const {
  StackSignature sig = *this;
  sig += next;
  return sig;
}

StackFlow::StackFlow(Block* curr) {
  std::vector<Location> values;
  Expression* lastUnreachable = nullptr;

  auto process = [&](Expression* expr, StackSignature sig) {
    const auto& params = sig.params.expand();
    const auto& results = sig.results.expand();
    // Unreachable instructions consume all available values
    size_t consumed =
      sig.unreachable ? std::max(values.size(), params.size()) : params.size();
    // Consume values
    assert(params.size() <= consumed);
    for (Index i = 0; i < consumed; ++i) {
      bool unreachable = i < consumed - params.size();
      if (values.size() + i < consumed) {
        // This value comes from the polymorphic stack of the last unreachable
        assert(consumed == params.size());
        auto& currDests = dests[lastUnreachable];
        Index destIndex(currDests.size());
        Type type = params[i];
        srcs[expr].push_back({lastUnreachable, destIndex, type, unreachable});
        currDests.push_back({expr, i, type, unreachable});
      } else {
        // A normal value from the value stack
        auto& src = values[values.size() + i - consumed];
        srcs[expr].push_back({src.expr, src.index, src.type, unreachable});
        dests[src.expr][src.index] = {expr, i, src.type, unreachable};
      }
    }
    values.resize(values.size() >= consumed ? values.size() - consumed : 0);
    // Produce values
    for (Index i = 0; i < results.size(); ++i) {
      values.push_back({expr, i, results[i], false});
    }
    // Update the last unreachable instruction
    if (sig.unreachable) {
      lastUnreachable = expr;
    }
  };

  for (auto* expr : curr->list) {
    StackSignature sig(expr);
    assert((sig.params.size() <= values.size() || lastUnreachable) &&
           "Block inputs not yet supported");
    srcs[expr] = std::vector<Location>();
    dests[expr] = std::vector<Location>(sig.results.size());
    process(expr, sig);
  }

  // Set the block as the destination for its return values
  assert(curr->type != Type::unreachable);
  process(curr, StackSignature(curr->type, Type::none));
}

StackSignature StackFlow::getSignature(Expression* expr) {
  auto exprSrcs = srcs.find(expr);
  auto exprDests = dests.find(expr);
  assert(exprSrcs != srcs.end() && exprDests != dests.end());
  std::vector<Type> params, results;
  for (auto& src : exprSrcs->second) {
    params.push_back(src.type);
  }
  for (auto& dest : exprDests->second) {
    results.push_back(dest.type);
  }
  bool unreachable = expr->type == Type::unreachable;
  return StackSignature(Type(params), Type(results), unreachable);
}

} // namespace wasm
