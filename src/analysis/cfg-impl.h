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

#include "cfg.h"

namespace wasm::analysis {

struct BasicBlock::Predecessors {
  struct iterator;
  iterator begin() const;
  iterator end() const;

  bool operator==(const Predecessors& other) const {
    return cfg == other.cfg && index == other.index;
  }
  bool operator!=(const Predecessors& other) const { return !(*this == other); }

private:
  const CFG* cfg;
  size_t index;

  Predecessors(const CFG* cfg, size_t index) : cfg(cfg), index(index) {}
  friend BasicBlock;
};

struct BasicBlock::Successors {
  struct iterator;
  iterator begin() const;
  iterator end() const;

  bool operator==(const Successors& other) const {
    return cfg == other.cfg && index == other.index;
  }

private:
  const CFG* cfg;
  size_t index;
  Successors(const CFG* cfg, size_t index) : cfg(cfg), index(index) {}
  friend BasicBlock;
};

struct CFG::iterator : ParentIndexIterator<const CFG*, iterator> {
  using value_type = BasicBlock;
  using pointer = BasicBlock*;
  using reference = BasicBlock&;
  BasicBlock operator*() const { return BasicBlock(parent, index); }
  iterator(const CFG* cfg, size_t index)
    : ParentIndexIterator<const CFG*, iterator>{cfg, index} {}
};

struct BasicBlock::Predecessors::iterator
  : ParentIndexIterator<Predecessors, iterator> {
  using value_type = BasicBlock;
  using pointer = BasicBlock*;
  using reference = BasicBlock&;
  BasicBlock operator*() {
    return BasicBlock(parent.cfg, parent.cfg->preds[parent.index][index]);
  }
};

struct BasicBlock::Successors::iterator
  : ParentIndexIterator<Successors, iterator> {
  using value_type = BasicBlock;
  using pointer = BasicBlock*;
  using reference = BasicBlock&;
  BasicBlock operator*() {
    return BasicBlock(parent.cfg, parent.cfg->succs[parent.index][index]);
  }
};

inline CFG::iterator CFG::begin() const { return iterator(this, 0); }

inline CFG::iterator CFG::end() const { return iterator(this, blocks.size()); }

inline size_t CFG::size() const { return blocks.size(); }

inline BasicBlock::iterator BasicBlock::begin() const {
  return cfg->blocks[index].cbegin();
}

inline BasicBlock::iterator BasicBlock::end() const {
  return cfg->blocks[index].cend();
}

inline size_t BasicBlock::size() const { return cfg->blocks[index].size(); }

inline BasicBlock::Predecessors::iterator
BasicBlock::Predecessors::begin() const {
  return iterator{*this, 0};
}

inline BasicBlock::Predecessors::iterator
BasicBlock::Predecessors::end() const {
  return iterator{*this, cfg->preds[index].size()};
}

inline BasicBlock::Successors::iterator BasicBlock::Successors::begin() const {
  return iterator{*this, 0};
}

inline BasicBlock::Successors::iterator BasicBlock::Successors::end() const {
  return iterator{*this, cfg->succs[index].size()};
}

inline BasicBlock::Predecessors BasicBlock::preds() const {
  return Predecessors{cfg, index};
}

inline BasicBlock::Successors BasicBlock::succs() const {
  return Successors{cfg, index};
}

inline bool BasicBlock::operator==(const BasicBlock& other) const {
  return cfg == other.cfg && index == other.index;
}

inline bool BasicBlock::operator!=(const BasicBlock& other) const {
  return !(*this == other);
}

} // namespace wasm::analysis
