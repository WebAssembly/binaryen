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

void removeNops(Block* block) {
  size_t newIndex = 0;
  for (size_t i = 0, size = block->list.size(); i < size; ++i) {
    if (!block->list[i]->is<Nop>()) {
      block->list[newIndex++] = block->list[i];
    }
  }
  block->list.resize(newIndex);
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
      assert(child->type.isConcrete());
      // Children might be tuple pops, so expand their types
      inputs.insert(inputs.end(), child->type.begin(), child->type.end());
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
  auto checked = std::min(results.size(), next.params.size());
  return std::equal(results.end() - checked,
                    results.end(),
                    next.params.end() - checked,
                    [](const Type& produced, const Type& consumed) {
                      return Type::isSubType(produced, consumed);
                    });
}

bool StackSignature::satisfies(Signature sig) const {
  if (sig.params.size() < params.size() ||
      sig.results.size() < results.size()) {
    // Not enough values provided or too many produced
    return false;
  }
  bool paramSuffixMatches =
    std::equal(params.begin(),
               params.end(),
               sig.params.end() - params.size(),
               [](const Type& consumed, const Type& provided) {
                 return Type::isSubType(provided, consumed);
               });
  if (!paramSuffixMatches) {
    return false;
  }
  bool resultSuffixMatches =
    std::equal(results.begin(),
               results.end(),
               sig.results.end() - results.size(),
               [](const Type& produced, const Type& expected) {
                 return Type::isSubType(produced, expected);
               });
  if (!resultSuffixMatches) {
    return false;
  }
  if (unreachable) {
    // The unreachable can consume any additional provided params and produce
    // any additional expected results, so we are done.
    return true;
  }
  // Any additional provided params will pass through untouched, so they must be
  // equivalent to the additional produced results.
  return std::equal(sig.params.begin(),
                    sig.params.end() - params.size(),
                    sig.results.begin(),
                    sig.results.end() - results.size(),
                    [](const Type& produced, const Type& expected) {
                      return Type::isSubType(produced, expected);
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
    if (!unreachable) {
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
  if (next.unreachable) {
    results = next.results;
    unreachable = true;
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

StackFlow::StackFlow(Block* block) {
  // Encapsulates the logic for treating the block and its children
  // uniformly. The end of the block is treated as if it consumed values
  // corresponding to the its result type and produced no values, which is why
  // the block's result type is used as the params of its processed stack
  // signature.
  auto processBlock = [&block](auto process) {
    for (auto* expr : block->list) {
      process(expr, StackSignature(expr));
    }
    bool unreachable = block->type == Type::unreachable;
    Type params = unreachable ? Type::none : block->type;
    process(block, StackSignature(params, Type::none, unreachable));
  };

  // We need to make an initial pass through the block to figure out how many
  // values each unreachable instruction produces.
  std::unordered_map<Expression*, size_t> producedByUnreachable;
  {
    size_t stackSize = 0;
    size_t produced = 0;
    Expression* lastUnreachable = nullptr;
    processBlock([&](Expression* expr, StackSignature sig) {
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
      if (sig.unreachable) {
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
  processBlock([&](Expression* expr, StackSignature sig) {
    assert((sig.params.size() <= values.size() || lastUnreachable) &&
           "Block inputs not yet supported");

    // Unreachable instructions consume all available values
    size_t consumed = sig.unreachable
                        ? std::max(values.size(), sig.params.size())
                        : sig.params.size();

    // We previously calculated how many values unreachable instructions produce
    size_t produced =
      sig.unreachable ? producedByUnreachable[expr] : sig.results.size();

    srcs[expr] = std::vector<Location>(consumed);
    dests[expr] = std::vector<Location>(produced);

    // Consume values
    assert(sig.params.size() <= consumed);
    size_t unreachableConsumed =
      consumed > values.size() ? consumed - values.size() : 0;
    for (Index i = 0; i < consumed; ++i) {
      if (i < unreachableConsumed) {
        // This value comes from the polymorphic stack of the last unreachable
        // because the stack did not have enough values to satisfy this
        // instruction.
        assert(consumed == sig.params.size());
        assert(lastUnreachable);
        assert(producedByUnreachable[lastUnreachable] >= unreachableConsumed);
        Index destIndex =
          producedByUnreachable[lastUnreachable] - unreachableConsumed + i;
        Type type = sig.params[i];
        srcs[expr][i] = {lastUnreachable, destIndex, type, true};
        dests[lastUnreachable][destIndex] = {expr, i, type, false};
      } else {
        // A normal value from the value stack
        bool unreachable = sig.params.size() + i < consumed;
        auto& src = values[values.size() + i - consumed];
        srcs[expr][i] = {src.expr, src.index, src.type, false};
        dests[src.expr][src.index] = {expr, i, src.type, unreachable};
      }
    }
    // Update available values
    if (unreachableConsumed) {
      producedByUnreachable[lastUnreachable] -= unreachableConsumed;
      values.resize(0);
    } else {
      values.resize(values.size() - consumed);
    }
    // Produce values
    for (Index i = 0; i < sig.results.size(); ++i) {
      values.push_back({expr, i, sig.results[i], false});
    }
    // Update the last unreachable instruction
    if (sig.unreachable) {
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
  bool unreachable = expr->type == Type::unreachable;
  return StackSignature(Type(params), Type(results), unreachable);
}

} // namespace wasm
