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
  assert((uint32_t)nextSeparatorVal >= nextVal);
  hashString.push_back((uint32_t)nextSeparatorVal);
  nextSeparatorVal--;
}

void HashStringifyWalker::visitExpression(Expression* curr) {
  auto [it, inserted] = exprToCounter.insert({curr, nextVal});
  hashString.push_back(it->second);
  if (inserted) {
    nextVal++;
  }
}

std::vector<SuffixTree::RepeatedSubstring> StringifyProcessor::dedupe(const std::vector<SuffixTree::RepeatedSubstring> substrings) {
  std::set<uint32_t> seen;
  std::vector<SuffixTree::RepeatedSubstring> result;
  for (auto substring : substrings) {
    std::vector <uint32_t> idxToInsert;
    bool seenEndIdx = false;
    for (auto startIdx : substring.StartIndices) {
      // We are using the end index to ensure that each repeated substring
      // reported by the SuffixTree is unique. This is because LLVM's SuffixTree
      // reports back repeat sequences that are substrings of longer repeat sequences with the same endIdx, and we generally prefer to outline longer repeat sequences.
      uint32_t endIdx = substring.Length + startIdx;
      if (auto found = seen.find(endIdx); found != seen.end()) {
        seenEndIdx = true;
        continue;
      }
      idxToInsert.push_back(endIdx);
    }
    if (!seenEndIdx) {
      seen.insert(idxToInsert.begin(), idxToInsert.end());
      result.push_back(substring);
    }
  }

  return result;
}

} // namespace wasm
