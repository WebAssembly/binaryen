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

#ifndef wasm_analysis_cfg_h
#define wasm_analysis_cfg_h

#include <iostream>
#include <vector>

#include "wasm.h"

namespace wasm::analysis {

struct BasicBlock;

struct CFG {
  // Iterate through basic blocks.
  struct iterator;
  iterator begin() const;
  iterator end() const;
  size_t size() const;

  static CFG fromFunction(Function* func);

  void print(std::ostream& os, Module* wasm = nullptr);

private:
  std::vector<std::vector<Expression*>> blocks;
  std::vector<std::vector<size_t>> succs;
  std::vector<std::vector<size_t>> preds;
  friend BasicBlock;
};

struct BasicBlock {
  using iterator = std::vector<Expression*>::const_iterator;

  // Iterate through instructions.
  iterator begin() const;
  iterator end() const;
  size_t size() const;

  // Iterables for predecessor and successor blocks.
  struct Predecessors;
  struct Successors;
  Predecessors preds() const;
  Successors succs() const;

  bool operator==(const BasicBlock& other) const;
  bool operator!=(const BasicBlock& other) const;

  void print(std::ostream& os, Module* wasm = nullptr, size_t start = 0);

private:
  const CFG* cfg;
  size_t index;

  BasicBlock(const CFG* cfg, size_t index) : cfg(cfg), index(index) {}
  friend CFG;
};

} // namespace wasm::analysis

#include "cfg-impl.h"

#endif // wasm_analysis_cfg_h
