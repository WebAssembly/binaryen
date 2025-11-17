/*
 * Copyright 2025 WebAssembly Community Group participants
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

#include "analysis/lattice.h"
#include "wasm-type.h"

#ifndef wasm_analysis_lattices_conetype_h
#define wasm_analysis_lattices_conetype_h

namespace wasm::analysis {

// The value type lattice augmented with subtyping depths on reference types. An
// element {(ref $foo), 1}, for example, represents the set of values that are
// exactly $foo or exactly one of $foo's immediate subtypes, but not any deeper
// type. Non-reference types and bottom references types always have a depth of
// 0.
struct ConeType {
  struct Element {
    Type type;
    Index depth;
    bool operator==(const Element& other) const {
      return type == other.type && depth == other.depth;
    }
    bool operator!=(const Element& other) const { return !(*this == other); }
    bool isBottom() const { return type == Type::unreachable; }
    bool isTop() const { return type == Type::none; }
  };

  // Used only for initializing depths for new elements.
  const std::unordered_map<HeapType, Index> typeDepths;

  ConeType(std::unordered_map<HeapType, Index>&& typeDepths)
    : typeDepths(std::move(typeDepths)) {}

  Element get(Type type) const noexcept {
    assert(!type.isTuple());
    if (!type.isRef() || type.isExact() || type.isNull() ||
        type.getHeapType().isMaybeShared(HeapType::i31)) {
      return Element{type, 0};
    }
    auto it = typeDepths.find(type.getHeapType());
    assert(it != typeDepths.end());
    return Element{type, it->second};
  }

  Element getBottom() const noexcept { return Element{Type::unreachable, 0}; }

  Element getTop() const noexcept { return Element{Type::none, 0}; }

  bool join(Element& joinee, const Element& joiner) const noexcept {
    auto lub = Type::getLeastUpperBound(joinee.type, joiner.type);
    bool changed = lub != joinee.type;
    if (!lub.isRef()) {
      joinee.type = lub;
      joinee.depth = 0;
      return changed;
    }
    Index joineeToLub = 0, joinerToLub = 0;
    if (!joinee.isBottom() && !joinee.type.isNull()) {
      joineeToLub = depthToSuper(joinee, lub);
    }
    if (!joiner.isBottom() && !joiner.type.isNull()) {
      joinerToLub = depthToSuper(joiner, lub);
    }
    Index newDepth =
      std::max(joinee.depth + joineeToLub, joiner.depth + joinerToLub);
    changed = changed || newDepth != joinee.depth;
    joinee.type = lub;
    joinee.depth = newDepth;
    return changed;
  }

  bool meet(Element& meetee, const Element& meeter) const noexcept {
    // Type::none does not behave like the top type in
    // Type::getGreatestLowerBound, so handle it separately first. Also handle
    // unreachables so we don't have to worry about them later.
    if (meetee.isBottom() || meeter.isTop()) {
      return false;
    }
    if (meetee.isTop() || meeter.isBottom()) {
      meetee = meeter;
      return true;
    }
    if (meetee.type == meeter.type) {
      auto newDepth = std::min(meetee.depth, meeter.depth);
      bool changed = newDepth != meetee.depth;
      meetee.depth = newDepth;
      return changed;
    }
    Index newDepth;
    auto glb = Type::getGreatestLowerBound(meetee.type, meeter.type);
    if (glb == Type::unreachable || glb.isNull()) {
      newDepth = 0;
    } else if (HeapType::isSubType(meetee.type.getHeapType(),
                                   meeter.type.getHeapType())) {
      auto diff = depthToSuper(meetee, meeter.type);
      if (meeter.depth < diff) {
        glb = glb.with(glb.getHeapType().getBottom());
        newDepth = 0;
      } else {
        newDepth = std::min(meeter.depth - diff, meetee.depth);
      }
    } else if (HeapType::isSubType(meeter.type.getHeapType(),
                                   meetee.type.getHeapType())) {
      auto diff = depthToSuper(meeter, meetee.type);
      if (meetee.depth < diff) {
        glb = glb.with(glb.getHeapType().getBottom());
        newDepth = 0;
      } else {
        newDepth = std::min(meetee.depth - diff, meeter.depth);
      }
    } else {
      WASM_UNREACHABLE("unexpected case");
    }
    bool changed = glb != meetee.type || newDepth != meetee.depth;
    meetee.type = glb;
    meetee.depth = newDepth;
    return changed;
  }

  analysis::LatticeComparison compare(const Element& a,
                                      const Element& b) const noexcept {
    if (a == b) {
      return analysis::EQUAL;
    }
    if (a.isBottom() || b.isTop()) {
      return analysis::LESS;
    }
    if (a.isTop() || b.isBottom()) {
      return analysis::GREATER;
    }
    if (a.type == b.type) {
      return a.depth < b.depth ? analysis::LESS : analysis::GREATER;
    }
    if (Type::isSubType(a.type, b.type)) {
      if (a.type.isNull()) {
        return analysis::LESS;
      }
      Index diff = depthToSuper(a, b.type);
      return a.depth + diff <= b.depth ? analysis::LESS : analysis::NO_RELATION;
    }
    if (Type::isSubType(b.type, a.type)) {
      if (b.type.isNull()) {
        return analysis::GREATER;
      }
      Index diff = depthToSuper(b, a.type);
      return b.depth + diff <= a.depth ? analysis::GREATER
                                       : analysis::NO_RELATION;
    }
    return analysis::NO_RELATION;
  }

private:
  Index depthToSuper(const Element& e, Type super) const noexcept {
    Index depth = 0;
    for (HeapType type = e.type.getHeapType(); type != super.getHeapType();
         type = *type.getSuperType()) {
      ++depth;
    }
    return depth;
  }
};

#if __cplusplus >= 202002L
static_assert(Lattice<ConeType>);
static_assert(FullLattice<ConeType>);
#endif

} // namespace wasm::analysis

#endif // wasm_analysis_lattices_conetype_h