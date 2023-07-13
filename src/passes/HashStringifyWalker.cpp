#include "stringify-walker.h"

namespace wasm {

// This custom hasher conforms to std::hash<Key>. Its purpose is to provide
// a custom hash for if expressions, so the if-condition of the if expression is
// not included in the hash for the if expression. This is needed because in the
// binary format, the if-condition comes before and is consumed by the if. To
// match the binary format, we hash the if condition before and separately from
// the rest of the if expression.
size_t StringifyHasher::operator()(Expression* curr) const {
  if (Properties::isControlFlowStructure(curr)) {
    if (auto* iff = curr->dynCast<If>()) {
      size_t digest = wasm::hash(iff->_id);
      rehash(digest, ExpressionAnalyzer::hash(iff->ifTrue));
      if (iff->ifFalse) {
        rehash(digest, ExpressionAnalyzer::hash(iff->ifFalse));
      }
      return digest;
    }

    return ExpressionAnalyzer::hash(curr);
  }

  return ExpressionAnalyzer::shallowHash(curr);
}

// This custom equator conforms to std::equal_to<Key>. Similar to
// StringifyHasher, it's purpose is to not include the if-condition when
// evaluating the equality of two if expressions.
bool StringifyEquator::operator()(Expression* lhs, Expression* rhs) const {
  if (Properties::isControlFlowStructure(lhs) &&
      Properties::isControlFlowStructure(rhs)) {
    auto* iffl = lhs->dynCast<If>();
    auto* iffr = rhs->dynCast<If>();

    if (iffl && iffr) {
      return ExpressionAnalyzer::equal(iffl->ifTrue, iffr->ifTrue) &&
             ExpressionAnalyzer::equal(iffl->ifFalse, iffr->ifFalse);
    }

    return ExpressionAnalyzer::equal(lhs, rhs);
  }

  return ExpressionAnalyzer::shallowEqual(lhs, rhs);
}

void HashStringifyWalker::addUniqueSymbol() {
  // Using a negative value to distinguish symbols for separators from symbols
  // for Expressions
  hashString.push_back((uint64_t)-monotonic);
  monotonic++;
}

void HashStringifyWalker::visitExpression(Expression* curr) {
  auto [it, inserted] = exprToCounter.insert({curr, monotonic});
  if (inserted) {
    hashString.push_back(monotonic);
    monotonic++;
  } else {
    hashString.push_back(it->second);
  }
}

} // namespace wasm
