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

namespace wasm {

StackSignature::StackSignature(Expression* expr) {
  std::vector<Type> inputs;
  for (auto* child : ValueChildIterator(expr)) {
    assert(child->type.isConcrete());
    // Children might be tuples, so expand their types.
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

} // namespace wasm
