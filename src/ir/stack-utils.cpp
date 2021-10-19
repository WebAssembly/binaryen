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
#include "ir/iteration.h"
#include "ir/properties.h"

namespace wasm {

namespace StackUtils {

void removeNops(Block* block) {
  size_t newIndex = 0;
  for (size_t i = 0, size = block->list.size(); i < size; ++i) {
    if (!block->list[i]->is<Nop>()) {
      block->list[newIndex++] = block->list[i];
    }
  }
  block->list.resize(newIndex);
}

bool mayBeUnreachable(Expression* expr) {
  if (Properties::isControlFlowStructure(expr)) {
    return true;
  }
  switch (expr->_id) {
    case Expression::Id::BreakId:
      return expr->cast<Break>()->condition == nullptr;
    case Expression::Id::CallId:
      return expr->cast<Call>()->isReturn;
    case Expression::Id::CallIndirectId:
      return expr->cast<CallIndirect>()->isReturn;
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

} // namespace StackUtils

StackSignature::StackSignature(Expression* expr) {
  std::vector<Type> inputs;
  for (auto* child : ValueChildIterator(expr)) {
    assert(child->type.isConcrete());
    // Children might be tuple pops, so expand their types
    inputs.insert(inputs.end(), child->type.begin(), child->type.end());
  }
  params = Type(inputs);
  if (expr->type == Type::unreachable) {
    kind = Polymorphic;
    results = Type::none;
  } else {
    kind = Fixed;
    results = expr->type;
  }
}

bool StackSignature::composes(const StackSignature& next) const {
  auto checked = std::min(results.size(), next.params.size());
  return std::equal(results.end() - checked,
                    results.end(),
                    next.params.end() - checked,
                    [](const Type& produced, const Type& consumed) {
                      return Type::isSubType(produced, consumed);
                    });
}

StackSignature& StackSignature::operator+=(const StackSignature& next) {
  assert(composes(next));
  std::vector<Type> stack(results.begin(), results.end());
  size_t required = next.params.size();
  // Consume stack values according to next's parameters
  if (stack.size() >= required) {
    stack.resize(stack.size() - required);
  } else {
    if (kind == Fixed) {
      // Prepend the unsatisfied params of `next` to the current params
      size_t unsatisfied = required - stack.size();
      std::vector<Type> newParams(next.params.begin(),
                                  next.params.begin() + unsatisfied);
      newParams.insert(newParams.end(), params.begin(), params.end());
      params = Type(newParams);
    }
    stack.clear();
  }
  // Add stack values according to next's results
  if (next.kind == Polymorphic) {
    results = next.results;
    kind = Polymorphic;
  } else {
    stack.insert(stack.end(), next.results.begin(), next.results.end());
    results = Type(stack);
  }
  return *this;
}

StackSignature StackSignature::operator+(const StackSignature& next) const {
  StackSignature sig = *this;
  sig += next;
  return sig;
}

bool StackSignature::isSubType(StackSignature a, StackSignature b) {
  if (a.params.size() > b.params.size() ||
      a.results.size() > b.results.size()) {
    // `a` consumes or produces more values than `b` can provides or expects.
    return false;
  }
  if (a.kind == Fixed && b.kind == Polymorphic) {
    // Non-polymorphic sequences cannot be typed as being polymorphic.
    return false;
  }
  bool paramSuffixMatches =
    std::equal(a.params.begin(),
               a.params.end(),
               b.params.end() - a.params.size(),
               [](const Type& consumed, const Type& provided) {
                 return Type::isSubType(provided, consumed);
               });
  if (!paramSuffixMatches) {
    return false;
  }
  bool resultSuffixMatches =
    std::equal(a.results.begin(),
               a.results.end(),
               b.results.end() - a.results.size(),
               [](const Type& produced, const Type& expected) {
                 return Type::isSubType(produced, expected);
               });
  if (!resultSuffixMatches) {
    return false;
  }
  if (a.kind == Polymorphic) {
    // The polymorphism can consume any additional provided params and produce
    // any additional expected results, so we are done.
    return true;
  }
  // Any additional provided params will pass through untouched, so they must be
  // compatible with the additional produced results.
  return std::equal(b.params.begin(),
                    b.params.end() - a.params.size(),
                    b.results.begin(),
                    b.results.end() - a.results.size(),
                    [](const Type& provided, const Type& expected) {
                      return Type::isSubType(provided, expected);
                    });
}

bool StackSignature::haveLeastUpperBound(StackSignature a, StackSignature b) {
  // If a signature is polymorphic, the LUB could extend its params and results
  // arbitrarily. Otherwise, the LUB must extend its params and results
  // uniformly so that each additional param is a subtype of the corresponding
  // additional result.
  auto extensionCompatible = [](auto self, auto other) -> bool {
    if (self.kind == Polymorphic) {
      return true;
    }
    // If no extension, then no problem.
    if (self.params.size() >= other.params.size() &&
        self.results.size() >= other.results.size()) {
      return true;
    }
    auto extSize = other.params.size() - self.params.size();
    if (extSize != other.results.size() - self.results.size()) {
      return false;
    }
    return std::equal(other.params.begin(),
                      other.params.begin() + extSize,
                      other.results.begin(),
                      other.results.begin() + extSize,
                      [](const Type& param, const Type& result) {
                        return Type::isSubType(param, result);
                      });
  };
  if (!extensionCompatible(a, b) || !extensionCompatible(b, a)) {
    return false;
  }

  auto valsCompatible = [](auto as, auto bs, auto compatible) -> bool {
    // Canonicalize so the as are shorter and any unshared prefix is on bs.
    if (bs.size() < as.size()) {
      std::swap(as, bs);
    }
    // Check that shared values after the unshared prefix have are compatible.
    size_t diff = bs.size() - as.size();
    for (size_t i = 0, shared = as.size(); i < shared; ++i) {
      if (!compatible(as[i], bs[i + diff])) {
        return false;
      }
    }
    return true;
  };

  bool paramsOk = valsCompatible(a.params, b.params, [](Type a, Type b) {
    assert(a == b && "TODO: calculate greatest lower bound to handle "
                     "contravariance correctly");
    return true;
  });
  bool resultsOk = valsCompatible(a.results, b.results, [](Type a, Type b) {
    return Type::getLeastUpperBound(a, b) != Type::none;
  });
  return paramsOk && resultsOk;
}

StackSignature StackSignature::getLeastUpperBound(StackSignature a,
                                                  StackSignature b) {
  assert(haveLeastUpperBound(a, b));

  auto combineVals = [](auto as, auto bs, auto combine) -> std::vector<Type> {
    // Canonicalize so the as are shorter and any unshared prefix is on bs.
    if (bs.size() < as.size()) {
      std::swap(as, bs);
    }
    // Combine shared values after the unshared prefix.
    size_t diff = bs.size() - as.size();
    std::vector<Type> vals(bs.begin(), bs.begin() + diff);
    for (size_t i = 0, shared = as.size(); i < shared; ++i) {
      vals.push_back(combine(as[i], bs[i + diff]));
    }
    return vals;
  };

  auto params = combineVals(a.params, b.params, [&](Type a, Type b) {
    assert(a == b && "TODO: calculate greatest lower bound to handle "
                     "contravariance correctly");
    return a;
  });

  auto results = combineVals(a.results, b.results, [&](Type a, Type b) {
    return Type::getLeastUpperBound(a, b);
  });

  Kind kind =
    a.kind == Polymorphic && b.kind == Polymorphic ? Polymorphic : Fixed;
  return StackSignature{Type(params), Type(results), kind};
}

StackFlow::StackFlow(Block* block) {
  // Encapsulates the logic for treating the block and its children
  // uniformly. The end of the block is treated as if it consumed values
  // corresponding to the its result type and produced no values, which is why
  // the block's result type is used as the params of its processed stack
  // signature.
  auto processBlock = [&block](auto process) {
    // TODO: Once we support block parameters, set up the stack by calling
    // `process` before iterating through the block.
    for (auto* expr : block->list) {
      process(expr, StackSignature(expr));
    }
    auto kind = block->type == Type::unreachable ? StackSignature::Polymorphic
                                                 : StackSignature::Fixed;
    Type params = block->type == Type::unreachable ? Type::none : block->type;
    process(block, StackSignature(params, Type::none, kind));
  };

  // We need to make an initial pass through the block to figure out how many
  // values each unreachable instruction produces.
  std::unordered_map<Expression*, size_t> producedByUnreachable;
  {
    size_t stackSize = 0;
    size_t produced = 0;
    Expression* lastUnreachable = nullptr;
    processBlock([&](Expression* expr, const StackSignature sig) {
      // Consume params
      if (sig.params.size() > stackSize) {
        // We need more values than are available, so they must come from the
        // last unreachable.
        assert(lastUnreachable);
        produced += sig.params.size() - stackSize;
        stackSize = 0;
      } else {
        stackSize -= sig.params.size();
      }

      // Handle unreachable or produce results
      if (sig.kind == StackSignature::Polymorphic) {
        if (lastUnreachable) {
          producedByUnreachable[lastUnreachable] = produced;
          produced = 0;
        }
        assert(produced == 0);
        lastUnreachable = expr;
        stackSize = 0;
      } else {
        stackSize += sig.results.size();
      }
    });

    // Finish record for final unreachable
    if (lastUnreachable) {
      producedByUnreachable[lastUnreachable] = produced;
    }
  }

  // Take another pass through the block, recording srcs and dests.
  std::vector<Location> values;
  Expression* lastUnreachable = nullptr;
  processBlock([&](Expression* expr, const StackSignature sig) {
    assert((sig.params.size() <= values.size() || lastUnreachable) &&
           "Block inputs not yet supported");

    // Unreachable instructions consume all available values
    size_t consumed = sig.kind == StackSignature::Polymorphic
                        ? std::max(values.size(), sig.params.size())
                        : sig.params.size();

    // We previously calculated how many values unreachable instructions produce
    size_t produced = sig.kind == StackSignature::Polymorphic
                        ? producedByUnreachable[expr]
                        : sig.results.size();

    srcs[expr] = std::vector<Location>(consumed);
    dests[expr] = std::vector<Location>(produced);

    // Figure out what kind of unreachable values we have
    assert(sig.params.size() <= consumed);
    size_t unreachableBeyondStack = 0;
    size_t unreachableFromStack = 0;
    if (consumed > values.size()) {
      assert(consumed == sig.params.size());
      unreachableBeyondStack = consumed - values.size();
    } else if (consumed > sig.params.size()) {
      assert(consumed == values.size());
      unreachableFromStack = consumed - sig.params.size();
    }

    // Consume values
    for (Index i = 0; i < consumed; ++i) {
      if (i < unreachableBeyondStack) {
        // This value comes from the polymorphic stack of the last unreachable
        // because the stack did not have enough values to satisfy this
        // instruction.
        assert(lastUnreachable);
        assert(producedByUnreachable[lastUnreachable] >=
               unreachableBeyondStack);
        Index destIndex =
          producedByUnreachable[lastUnreachable] - unreachableBeyondStack + i;
        Type type = sig.params[i];
        srcs[expr][i] = {lastUnreachable, destIndex, type, true};
        dests[lastUnreachable][destIndex] = {expr, i, type, false};
      } else {
        // A normal value from the value stack
        bool unreachable = i < unreachableFromStack;
        auto& src = values[values.size() + i - consumed];
        srcs[expr][i] = src;
        dests[src.expr][src.index] = {expr, i, src.type, unreachable};
      }
    }

    // Update available values
    if (unreachableBeyondStack) {
      producedByUnreachable[lastUnreachable] -= unreachableBeyondStack;
      values.resize(0);
    } else {
      values.resize(values.size() - consumed);
    }

    // Produce values
    for (Index i = 0; i < sig.results.size(); ++i) {
      values.push_back({expr, i, sig.results[i], false});
    }

    // Update the last unreachable instruction
    if (sig.kind == StackSignature::Polymorphic) {
      assert(producedByUnreachable[lastUnreachable] == 0);
      lastUnreachable = expr;
    }
  });
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
  auto kind = expr->type == Type::unreachable ? StackSignature::Polymorphic
                                              : StackSignature::Fixed;
  return StackSignature(Type(params), Type(results), kind);
}

} // namespace wasm
