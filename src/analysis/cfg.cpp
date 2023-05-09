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

#include <unordered_map>

#include "analysis/cfg.h"
#include "cfg/cfg-traversal.h"
#include "wasm-stack.h"

namespace wasm::analysis {

CFG CFG::fromFunction(Function* func) {
  struct CFGBuilder : CFGWalker<CFGBuilder,
                                UnifiedExpressionVisitor<CFGBuilder>,
                                std::vector<Expression*>> {
    void visitExpression(Expression* curr) {
      if (currBasicBlock) {
        currBasicBlock->contents.push_back(curr);
      }
    }
  };

  CFGBuilder builder;
  builder.walkFunction(func);

  std::unordered_map<CFGBuilder::BasicBlock*, size_t> blockIndices;
  for (size_t i = 0; i < builder.basicBlocks.size(); ++i) {
    blockIndices[builder.basicBlocks[i].get()] = i;
  }

  CFG cfg;
  for (auto& block : builder.basicBlocks) {
    cfg.blocks.emplace_back(std::move(block->contents));

    std::vector<size_t> preds;
    for (auto* pred : block->in) {
      preds.push_back(blockIndices.at(pred));
    }
    cfg.preds.emplace_back(std::move(preds));

    std::vector<size_t> succs;
    for (auto* succ : block->out) {
      succs.push_back(blockIndices.at(succ));
    }
    cfg.succs.emplace_back(std::move(succs));
  }

  return cfg;
}

void CFG::print(std::ostream& os, Module* wasm) {
  size_t start = 0;
  for (auto block : *this) {
    if (block != *begin()) {
      os << '\n';
    }
    block.print(os, wasm, start);
    start += block.size();
  }
}

void BasicBlock::print(std::ostream& os, Module* wasm, size_t start) {
  os << ";; preds: [";
  for (auto pred : preds()) {
    if (pred != *preds().begin()) {
      os << ", ";
    }
    os << pred.index;
  }
  os << "], succs: [";

  for (auto succ : succs()) {
    if (succ != *succs().begin()) {
      os << ", ";
    }
    os << succ.index;
  }
  os << "]\n";

  os << index << ":\n";
  size_t instIndex = start;
  for (auto* inst : *this) {
    os << "  " << instIndex++ << ": " << ShallowExpression{inst, wasm} << '\n';
  }
}

} // namespace wasm::analysis
