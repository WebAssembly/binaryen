#include "stringify-walker.h"

#ifndef wasm_passes_hash_stringify_walker_impl_h
#define wasm_passes_hash_stringify_walker_impl_h

namespace wasm {

void HashStringifyWalker::addUniqueSymbol() {
  hashString.push_back((uint64_t)-monotonic);
  monotonic++;
}

void HashStringifyWalker::visitExpression(Expression* curr) {
  auto it = exprToCounter.find(curr);
  if (it != exprToCounter.end()) {
    hashString.push_back(it->second);
  } else {
    hashString.push_back(monotonic);
    exprToCounter[curr] = monotonic;
    monotonic++;
  }
}

} // namespace wasm

#endif // wasm_passes_hash_stringify_walker_impl_h
