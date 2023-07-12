#include "stringify-walker.h"

#ifndef wasm_passes_hash_stringify_walker_impl_h
#define wasm_passes_hash_stringify_walker_impl_h

namespace wasm {

void HashStringifyWalker::addUniqueSymbol() {
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

#endif // wasm_passes_hash_stringify_walker_impl_h
