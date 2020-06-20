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

void compact(Block* block) {
  size_t newIndex = 0;
  for (size_t i = 0, size = block->list.size(); i < size; ++i) {
    if (!block->list[i]->is<Nop>()) {
      block->list[newIndex++] = block->list[i];
    }
  }
  block->list.resize(newIndex);
}

Signature getStackSignature(Expression* curr) {
  Type input = Type::none;
  if (Properties::isControlFlowStructure(curr)) {
    if (curr->is<If>()) {
      input = Type::i32;
    }
  } else {
    std::vector<Type> inputs;
    for (auto* child : ChildIterator(curr)) {
      const auto& types = child->type.expand();
      inputs.insert(inputs.end(), types.begin(), types.end());
    }
    input = Type(inputs);
  }
  return Signature(input, curr->type);
}

StackFlow::StackFlow(Block* curr) {
  std::vector<Location> values;
  bool unreachable = false;
  for (auto* expr : curr->list) {
    size_t consumed = getStackSignature(expr).params.size();
    size_t produced = expr->type == Type::unreachable ? 0 : expr->type.size();
    srcs[expr] = std::vector<Location>(consumed);
    dests[expr] = std::vector<Location>(produced);
    if (unreachable) {
      continue;
    }
    assert(consumed <= values.size() && "block parameters not implemented");
    for (Index i = 0; i < consumed; ++i) {
      auto& src = values[values.size() - consumed + i];
      srcs[expr][i] = src;
      dests[src.expr][src.index] = {expr, i};
    }
    values.resize(values.size() - consumed);
    for (Index i = 0; i < produced; ++i) {
      values.push_back({expr, i});
    }
    if (expr->type == Type::unreachable) {
      unreachable = true;
    }
  }
  // If the end of the block can be reached, set the block as the destination
  // for its return values
  if (!unreachable) {
    assert(values.size() == curr->type.size());
    for (Index i = 0, size = values.size(); i < size; ++i) {
      auto& loc = values[i];
      dests[loc.expr][loc.index] = {curr, i};
    }
  }
}

} // namespace StackUtils

} // namespace wasm
