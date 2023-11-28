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

  size_t numBlocks = builder.basicBlocks.size();

  CFG cfg;
  cfg.blocks = std::vector<BasicBlock>(numBlocks);

  // From here the addresses of the new basic blocks are stable.
  std::unordered_map<CFGBuilder::BasicBlock*, BasicBlock*> oldToNewBlocks;
  for (size_t i = 0; i < numBlocks; ++i) {
    oldToNewBlocks[builder.basicBlocks[i].get()] = &cfg.blocks[i];
  }

  for (size_t i = 0; i < numBlocks; ++i) {
    auto& oldBlock = *builder.basicBlocks[i];
    auto& newBlock = cfg.blocks[i];
    newBlock.index = i;
    newBlock.insts = std::move(oldBlock.contents);
    newBlock.predecessors.reserve(oldBlock.in.size());
    for (auto* oldPred : oldBlock.in) {
      newBlock.predecessors.push_back(oldToNewBlocks.at(oldPred));
    }
    newBlock.successors.reserve(oldBlock.out.size());
    for (auto* oldSucc : oldBlock.out) {
      newBlock.successors.push_back(oldToNewBlocks.at(oldSucc));
    }
  }

  assert(!cfg.blocks.empty());
  cfg.blocks[0].entry = true;
  if (builder.exit) {
    oldToNewBlocks.at(builder.exit)->exit = true;
  }

  // Move-construct a new CFG to get mandatory copy elision, preserving basic
  // block addresses through the return.
  return CFG(std::move(cfg));
}

void CFG::print(std::ostream& os, Module* wasm) const {
  size_t start = 0;
  for (auto& block : *this) {
    if (&block != &*begin()) {
      os << '\n';
    }
    block.print(os, wasm, start);
    start += block.size();
  }
}

void BasicBlock::print(std::ostream& os, Module* wasm, size_t start) const {
  os << ";; preds: [";
  for (const auto* pred : preds()) {
    if (pred != *preds().begin()) {
      os << ", ";
    }
    os << pred->index;
  }
  os << "], succs: [";

  for (const auto* succ : succs()) {
    if (succ != *succs().begin()) {
      os << ", ";
    }
    os << succ->index;
  }
  os << "]\n";

  if (isEntry()) {
    os << ";; entry\n";
  }

  if (isExit()) {
    os << ";; exit\n";
  }

  os << index << ":\n";
  size_t instIndex = start;
  for (auto* inst : *this) {
    os << "  " << instIndex++ << ": " << ShallowExpression{inst, wasm} << '\n';
  }
}

CFGBlockIndexes::CFGBlockIndexes(const CFG& cfg) {
  for (auto& block : cfg) {
    for (auto* expr : block) {
      map[expr] = block.getIndex();
    }
  }
}

} // namespace wasm::analysis
