#include "stringify-walker.h"

namespace wasm {

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
  // Use a negative value to distinguish symbols for separators from symbols
  // for Expressions
  hashString.push_back((uint64_t)-nextVal);
  nextVal++;
}

void HashStringifyWalker::visitExpression(Expression* curr) {
  auto [it, inserted] = exprToCounter.insert({curr, nextVal});
  hashString.push_back(it->second);
  if (inserted) {
    nextVal++;
  }
}

} // namespace wasm
