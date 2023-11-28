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

// A generic CFG / basic block utility. Unlike the utilities in src/cfg/, this
// is a generic representation of a CFG rather than a generic builder of
// CFG-like objects. It lives here in src/analysis/ because it is primarily
// meant for use in the static analysis framework. Other Binaryen code will find
// it more idiomatic to use the utilities in src/cfg/.

#ifndef wasm_analysis_cfg_h
#define wasm_analysis_cfg_h

#include <iostream>
#include <vector>

#include "wasm.h"

namespace wasm::analysis {

struct CFG;

struct BasicBlock {
  using iterator = std::vector<Expression*>::const_iterator;

  // Iterate through instructions.
  iterator begin() const { return insts.cbegin(); }
  iterator end() const { return insts.cend(); }
  size_t size() const { return insts.size(); }

  using reverse_iterator = std::vector<Expression*>::const_reverse_iterator;
  reverse_iterator rbegin() const { return insts.rbegin(); }
  reverse_iterator rend() const { return insts.rend(); }

  const std::vector<const BasicBlock*>& preds() const { return predecessors; }
  const std::vector<const BasicBlock*>& succs() const { return successors; }

  void print(std::ostream& os, Module* wasm = nullptr, size_t start = 0) const;

  Index getIndex() const { return index; }

  bool isEntry() const { return entry; }
  bool isExit() const { return exit; }

private:
  Index index;
  bool entry = false;
  bool exit = false;
  std::vector<Expression*> insts;
  std::vector<const BasicBlock*> predecessors;
  std::vector<const BasicBlock*> successors;

  friend CFG;
};

struct CFG {
  // Iterate through basic blocks.
  using iterator = std::vector<BasicBlock>::const_iterator;
  iterator begin() const { return blocks.cbegin(); }
  iterator end() const { return blocks.cend(); }
  size_t size() const { return blocks.size(); }

  using reverse_iterator = std::vector<BasicBlock>::const_reverse_iterator;
  reverse_iterator rbegin() const { return blocks.rbegin(); }
  reverse_iterator rend() const { return blocks.rend(); }

  const BasicBlock& operator[](size_t i) const { return *(begin() + i); }

  static CFG fromFunction(Function* func);

  void print(std::ostream& os, Module* wasm = nullptr) const;

private:
  std::vector<BasicBlock> blocks;

  friend BasicBlock;
};

// A helper class that computes block indexes for a CFG and allows querying of
// them.
struct CFGBlockIndexes {
  CFGBlockIndexes(const CFG& cfg);

  // Gets the index of the basic block in which the instruction resides.
  Index get(Expression* expr) const {
    auto iter = map.find(expr);
    if (iter == map.end()) {
      // There is no entry for this, which can be the case for control flow
      // structures, or for unreachable code.
      return InvalidBlock;
    }
    return iter->second;
  }

  enum { InvalidBlock = Index(-1) };

private:
  std::unordered_map<Expression*, Index> map;
};

} // namespace wasm::analysis

#endif // wasm_analysis_cfg_h
