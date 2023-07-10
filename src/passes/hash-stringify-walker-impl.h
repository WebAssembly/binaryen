#include "support/hash.h"

#ifndef wasm_passes_hash_stringify_walker_impl_h
#define wasm_passes_hash_stringify_walker_impl_h

namespace wasm {

void HashStringifyWalker::addUniqueSymbol() {
  hashString.push_back(monotonic);
  os << monotonic << " - unique" << std::endl;
  monotonic++;
}

void HashStringifyWalker::visitExpression(Expression* curr) {
  auto it = exprToCounter.find(curr);
  uint64_t counterUsed;
  if (it != exprToCounter.end()) {
    hashString.push_back(it->second);
    counterUsed = it->second;
  } else {
    exprToCounter[curr] = monotonic;
    counterUsed = monotonic;
    monotonic++;
  }

  os << counterUsed << " - " << ShallowExpression{curr, getModule()}
         << std::endl;
}

} // namespace wasm

#endif // wasm_passes_hash_stringify_walker_impl_h
