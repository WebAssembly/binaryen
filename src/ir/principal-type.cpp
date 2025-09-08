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

#include <algorithm>
#include <iostream>

#include "principal-type.h"
#include "support/disjoint_sets.h"

namespace wasm {

namespace {

#ifndef NDEBUG

bool valid(const VarAbsHeapType& type) {
  if (!type.ht.isBasic()) {
    return false;
  }
  // Sharedness is represented in `share`, not `ht`.
  if (type.ht.isShared()) {
    return false;
  }
  return true;
}

bool valid(const VarDefHeapType& type) { return !type.ht.isBasic(); }

bool valid(const VarHeapType& type) {
  if (auto* t = std::get_if<VarAbsHeapType>(&type)) {
    return valid(*t);
  }
  if (auto* t = std::get_if<VarDefHeapType>(&type)) {
    return valid(*t);
  }
  return true;
}

bool valid(const VarRef& type) { return valid(type.ht); }

bool valid(const VarType& type) {
  if (auto* ref = std::get_if<VarRef>(&type)) {
    return valid(*ref);
  }
  if (auto* t = std::get_if<Type>(&type)) {
    return t->isSingle() || *t == Type::unreachable;
  }
  return true;
}

#endif // NDEBUG

// Convert a VarRef that does not use the extended type syntax into a normal
// Type.
VarType canonicalizeRef(const VarRef& ref) {
  const auto* null = std::get_if<Nullability>(&ref.null);
  if (!null) {
    return ref;
  }
  if (auto* t = std::get_if<VarAbsHeapType>(&ref.ht)) {
    if (auto* share = std::get_if<Shareability>(&t->share)) {
      assert(t->ht.isBasic());
      return Type(t->ht.getBasic(*share), *null);
    }
    return ref;
  }
  if (auto* t = std::get_if<VarDefHeapType>(&ref.ht)) {
    if (auto* exact = std::get_if<Exactness>(&t->exact)) {
      assert(!t->ht.isBasic());
      return Type(t->ht, *null, *exact);
    }
    return ref;
  }
  return ref;
}

// Convert a given reference type into a VarRef. The result will not use the
// extended type syntax.
VarRef asVarRef(Type type) {
  assert(type.isRef());
  auto null = type.getNullability();
  auto ht = type.getHeapType();
  if (ht.isBasic()) {
    return VarRef{null, VarAbsHeapType{ht.getShared(), ht.getBasic(Unshared)}};
  }
  return VarRef{null, VarDefHeapType{type.getExactness(), ht}};
}

// join: Update `value` to the least upper bound of `value` and `other`. Returns
// `true` iff the least upper bound exists.

bool join(VarNullability& value, const VarNullability& other) {
  assert(!std::get_if<Index>(&value) && !std::get_if<Index>(&other) &&
         "joining variables not yet supported");
  if (value == other) {
    return true;
  }
  value = Nullable;
  return true;
}

bool join(VarExactness& value, const VarExactness& other) {
  assert(!std::get_if<Index>(&value) && !std::get_if<Index>(&other) &&
         "joining variables not yet supported");
  if (value == other) {
    return true;
  }
  value = Inexact;
  return true;
}

bool join(VarSharedness& value, const VarSharedness& other) {
  assert(!std::get_if<Index>(&value) && !std::get_if<Index>(&other) &&
         "joining variables not yet supported");
  if (value == other || std::get_if<BottomShare>(&other)) {
    return true;
  }
  if (std::get_if<BottomShare>(&value)) {
    value = other;
    return true;
  }
  return false;
}

bool join(HeapType& value, const HeapType& other) {
  if (auto lub = HeapType::getLeastUpperBound(value, other)) {
    value = *lub;
    return true;
  }
  return false;
}

bool join(VarAbsHeapType& value, const VarAbsHeapType& other) {
  return join(value.share, other.share) && join(value.ht, other.ht);
}

bool join(VarDefHeapType& value, const VarDefHeapType& other) {
  if (value.ht != other.ht) {
    VarExactness inexact = Inexact;
    return join(value.ht, other.ht) && join(value.exact, inexact) &&
           join(inexact, other.exact);
  }
  return join(value.exact, other.exact);
}

bool join(VarAbsHeapType& value, const VarDefHeapType& other) {
  WASM_UNREACHABLE("TODO");
}

bool join(VarDefHeapType& value, const VarAbsHeapType& other) {
  WASM_UNREACHABLE("TODO");
}

bool join(VarHeapType& value, const VarHeapType& other) {
  assert(!std::get_if<Index>(&value) && !std::get_if<Index>(&other));
  if (value == other || std::get_if<BottomHeapType>(&other)) {
    return true;
  }
  if (std::get_if<BottomHeapType>(&value)) {
    value = other;
    return true;
  }
  auto* abs = std::get_if<VarAbsHeapType>(&value);
  auto* otherAbs = std::get_if<VarAbsHeapType>(&other);
  auto* def = std::get_if<VarDefHeapType>(&value);
  auto* otherDef = std::get_if<VarDefHeapType>(&other);
  if (abs && otherAbs) {
    return join(*abs, *otherAbs);
  }
  if (abs && otherDef) {
    return join(*abs, *otherDef);
  }
  if (def && otherAbs) {
    return join(*def, *otherAbs);
  }
  if (def && otherDef) {
    return join(*def, *otherDef);
  }
  WASM_UNREACHABLE("unexpected variant");
}

bool join(VarRef& value, const VarRef& other) {
  return join(value.null, other.null) && join(value.ht, other.ht);
}

bool join(Type& value, const Type& other) {
  value = Type::getLeastUpperBound(value, other);
  return value != Type::none;
}

bool join(VarRef& value, const Type& other) { WASM_UNREACHABLE("TODO"); }

bool join(VarType& value, const VarType& other) {
  assert(!std::get_if<Index>(&value) && !std::get_if<Index>(&other));
  if (value == other) {
    return true;
  }
  auto* ref = std::get_if<VarRef>(&value);
  auto* otherRef = std::get_if<VarRef>(&other);
  auto* type = std::get_if<Type>(&value);
  auto* otherType = std::get_if<Type>(&other);
  if (ref && otherRef) {
    if (!join(*ref, *otherRef)) {
      return false;
    }
    value = canonicalizeRef(*ref);
    return true;
  }
  if (ref && otherType) {
    if (!join(*ref, *otherType)) {
      return false;
    }
    value = canonicalizeRef(*ref);
    return true;
  }
  if (type && otherRef) {
    if (!type->isRef()) {
      return false;
    }
    auto r = asVarRef(*type);
    if (!join(r, *otherRef)) {
      return false;
    }
    value = canonicalizeRef(r);
    return true;
  }
  if (type && otherType) {
    return join(*type, *otherType);
  }
  WASM_UNREACHABLE("unexpected variant");
}

// Find the least upper bound where T is lifted so that nullopt is the bottom
// value.
template<typename T>
bool join(std::optional<T>& value, const std::optional<T>& other) {
  if (value && other) {
    return join(*value, *other);
  } else if (other && !value) {
    value = other;
  }
  return true;
}

// countVars: Count the number of distinct variables for each kind of variable.

struct VarCounts {
  Index nulls = 0;
  Index exacts = 0;
  Index shares = 0;
  Index heapTypes = 0;
  Index types = 0;
};

void countVar(Index* countp, Index i) {
  // Variables must be introduced sequentially starting at 0 so their count is
  // one greater than their max value.
  if (i >= *countp) {
    assert(*countp == i);
    ++*countp;
  }
}

void countVars(VarCounts& counts, const VarAbsHeapType& type) {
  if (auto* i = std::get_if<Index>(&type.share)) {
    countVar(&counts.shares, *i);
  }
}

void countVars(VarCounts& counts, const VarDefHeapType& type) {
  if (auto* i = std::get_if<Index>(&type.exact)) {
    countVar(&counts.exacts, *i);
  }
}

void countVars(VarCounts& counts, const VarHeapType& type) {
  if (auto* i = std::get_if<Index>(&type)) {
    countVar(&counts.heapTypes, *i);
  } else if (auto* t = std::get_if<VarAbsHeapType>(&type)) {
    countVars(counts, *t);
  } else if (auto* t = std::get_if<VarDefHeapType>(&type)) {
    countVars(counts, *t);
  }
}

void countVars(VarCounts& counts, const VarRef& ref) {
  if (auto* i = std::get_if<Index>(&ref.null)) {
    countVar(&counts.nulls, *i);
  }
  countVars(counts, ref.ht);
}

void countVars(VarCounts& counts, const VarType& type) {
  if (auto* i = std::get_if<Index>(&type)) {
    countVar(&counts.types, *i);
  } else if (auto* t = std::get_if<VarRef>(&type)) {
    countVars(counts, *t);
  }
}

void countVars(VarCounts& counts, const std::vector<VarType>& types) {
  for (const auto& type : types) {
    countVars(counts, type);
  }
}

void countVars(VarCounts& counts, const PrincipalType& type) {
  countVars(counts, type.rparams);
  countVars(counts, type.results);
}

// renumber: Replace variables with new variables given in `renumbering` or
// otherwise indexed sequentially starting at `base`.

// Sorted vector mapping original to renumbered variables.
using Renumbering = std::vector<std::pair<Index, Index>>;

struct Renumberings {
  Renumbering nulls;
  Renumbering exacts;
  Renumbering shares;
  Renumbering heapTypes;
  Renumbering types;
};

void renumber(Index base, Renumbering& renumbering, Index& i) {
  auto it = std::lower_bound(
    renumbering.begin(),
    renumbering.end(),
    std::pair{i, i},
    [&](const auto& a, const auto& b) { return a.first < b.first; });
  if (it != renumbering.end() && it->first == i) {
    i = it->second;
    return;
  }
  // We have not already renumbered this index. Insert a new mapping.
  Index fresh = base + renumbering.size();
  renumbering.insert(it, {i, fresh});
  i = fresh;
}

void renumber(const VarCounts& bases,
              Renumberings& renumberings,
              VarNullability& null) {
  if (auto* i = std::get_if<Index>(&null)) {
    renumber(bases.nulls, renumberings.nulls, *i);
  }
}

void renumber(const VarCounts& bases,
              Renumberings& renumberings,
              VarExactness& exact) {
  if (auto* i = std::get_if<Index>(&exact)) {
    renumber(bases.exacts, renumberings.exacts, *i);
  }
}

void renumber(const VarCounts& bases,
              Renumberings& renumberings,
              VarSharedness& share) {
  if (auto* i = std::get_if<Index>(&share)) {
    renumber(bases.shares, renumberings.shares, *i);
  }
}

void renumber(const VarCounts& bases,
              Renumberings& renumberings,
              VarAbsHeapType& type) {
  renumber(bases, renumberings, type.share);
}

void renumber(const VarCounts& bases,
              Renumberings& renumberings,
              VarDefHeapType& type) {
  renumber(bases, renumberings, type.exact);
}

void renumber(const VarCounts& bases,
              Renumberings& renumberings,
              VarHeapType& type) {
  if (auto* i = std::get_if<Index>(&type)) {
    renumber(bases.heapTypes, renumberings.heapTypes, *i);
  } else if (auto* t = std::get_if<VarAbsHeapType>(&type)) {
    renumber(bases, renumberings, *t);
  } else if (auto* t = std::get_if<VarDefHeapType>(&type)) {
    renumber(bases, renumberings, *t);
  }
}

void renumber(const VarCounts& bases,
              Renumberings& renumberings,
              VarRef& type) {
  renumber(bases, renumberings, type.null);
  renumber(bases, renumberings, type.ht);
}

void renumber(const VarCounts& bases,
              Renumberings& renumberings,
              VarType& type) {
  if (auto* i = std::get_if<Index>(&type)) {
    renumber(bases.types, renumberings.types, *i);
  } else if (auto* t = std::get_if<VarRef>(&type)) {
    renumber(bases, renumberings, *t);
  }
}

void renumberVars(const VarCounts& bases, PrincipalType& type) {
  Renumberings renumberings;
  for (auto& t : type.rparams) {
    renumber(bases, renumberings, t);
  }
  for (auto& t : type.results) {
    renumber(bases, renumberings, t);
  }
}

// Renumber the variables starting at zero for each index space.
void canonicalizeVars(PrincipalType& type) {
  VarCounts zeros;
  renumberVars(zeros, type);
}

// Variables can be assigned to values and also to other variables. The set of
// variables and values that are known to be equivalent to each other form an
// equivalence class, which we track here using a disjoint set data structure.
// The disjoint set indices are the same as variable indices.
template<typename T> struct AssignmentClasses {
  // Map each variable in an equivalence class to the representative variable.
  DisjointSets classes;
  // Map representative variables to the values of their classes.
  std::vector<std::optional<T>> values;

  bool assign(Index i, T value) {
    auto* other = std::get_if<Index>(&value);
    if (other && *other == i) {
      // Setting a variable equal to itself is a no-op.
      return true;
    }
    // Make sure we have a class for i.
    classes.reserve(i + 1);
    values.reserve(i + 1);
    while (values.size() <= i) {
      [[maybe_unused]] size_t set = classes.addSet();
      assert(set == values.size());
      values.push_back(std::nullopt);
    }
    size_t root = classes.getRoot(i);
    assert(root < values.size());
    // If the assigned value is not another variable, then merge it into the
    // current assigned value. If this is a forward assignment, meaning it's a
    // provided value being assigned to a required variable, then this merge is
    // a join (i.e. the least upper bound) and if it is a backward assignment,
    // meaning it's a required value being assigned to a provided variable, this
    // merge should be meet (i.e. the greatest lower bound). However,
    // WebAssembly does not currently have principal types that have more than
    // one instance of a variable in the produced types, so we can get away
    // without properly differentiating between forward and backward
    // assignments.
    if (!other) {
      return join(values[root], {value});
    }
    // Otherwise we have to join the two classes.
    size_t otherRoot = classes.getRoot(*other);
    assert(otherRoot < values.size());
    if (otherRoot == root) {
      // Already the same class.
      return true;
    }
    size_t newRoot = classes.getUnion(i, *other);
    assert(newRoot < values.size());
    // Join the values from the merged classes.
    return join(values[newRoot], values[newRoot == root ? otherRoot : root]);
  }

  T get(Index i) const {
    if (i >= values.size()) {
      return i;
    }
    Index root = classes.getRoot(i);
    assert(root < values.size());
    if (values[root]) {
      return *values[root];
    } else {
      // No assigned value, so return the representative variable.
      return root;
    }
  }

  bool operator==(const AssignmentClasses& other) const {
    // The maximum assigned variable should be the same.
    if (values.size() != other.values.size()) {
      return false;
    }
    // The equivalence classes and assigned values in this set of assignments
    // needs to match those in the other set of assignments. Two equivalent
    // equivalence classes might have different representative indices, but we
    // can check that both assignment sets agree that each variable and the
    // other set's representative element for that variable's equivalence class
    // are in the same class. If the classes are different in any way, there
    // will be an element for which this is not true.
    for (Index i = 0; i < values.size(); ++i) {
      auto root = classes.getRoot(i);
      assert(root < values.size());
      auto otherRoot = other.classes.getRoot(i);
      assert(otherRoot < other.values.size());
      // We only need to compare the values for each group once.
      if (i == root && values[root] != other.values[otherRoot]) {
        return false;
      }
      if (root == otherRoot) {
        continue;
      }
      if (root != classes.getRoot(otherRoot)) {
        return false;
      }
      if (otherRoot != other.classes.getRoot(root)) {
        return false;
      }
    }
    return true;
  }
};

// Assignments for all the kinds of variables that can appear in a principal
// type.
struct VarAssignments {
  AssignmentClasses<VarNullability> nulls;
  AssignmentClasses<VarExactness> exacts;
  AssignmentClasses<VarSharedness> shares;
  AssignmentClasses<VarHeapType> heapTypes;
  AssignmentClasses<VarType> types;

  bool operator==(const VarAssignments& other) const {
    return nulls == other.nulls && exacts == other.exacts &&
           shares == other.shares && heapTypes == other.heapTypes &&
           types == other.types;
  }

  bool operator!=(const VarAssignments& other) const {
    return !(*this == other);
  }
};

// apply: replace variables with their assigned values according to
// `assignments`.

void apply(const VarAssignments& assignments, VarNullability& null) {
  if (auto* i = std::get_if<Index>(&null)) {
    null = assignments.nulls.get(*i);
  }
}

void apply(const VarAssignments& assignments, VarExactness& exact) {
  if (auto* i = std::get_if<Index>(&exact)) {
    exact = assignments.exacts.get(*i);
  }
}

void apply(const VarAssignments& assignments, VarSharedness& share) {
  if (auto* i = std::get_if<Index>(&share)) {
    share = assignments.shares.get(*i);
  }
}

void apply(const VarAssignments& assignments, VarAbsHeapType& type) {
  apply(assignments, type.share);
}

void apply(const VarAssignments& assignments, VarDefHeapType& type) {
  apply(assignments, type.exact);
}

void apply(const VarAssignments& assignments, VarHeapType& type) {
  if (auto* i = std::get_if<Index>(&type)) {
    type = assignments.heapTypes.get(*i);
  }
  if (auto* t = std::get_if<VarAbsHeapType>(&type)) {
    apply(assignments, *t);
  } else if (auto* t = std::get_if<VarDefHeapType>(&type)) {
    apply(assignments, *t);
  }
}

void apply(const VarAssignments& assignments, VarRef& ref) {
  apply(assignments, ref.null);
  apply(assignments, ref.ht);
}

void apply(const VarAssignments& assignments, VarType& type) {
  if (auto* i = std::get_if<Index>(&type)) {
    type = assignments.types.get(*i);
  }
  if (auto* t = std::get_if<VarRef>(&type)) {
    apply(assignments, *t);
    type = canonicalizeRef(*t);
  }
}

void apply(const VarAssignments& assignments, PrincipalType& type) {
  for (auto& t : type.rparams) {
    apply(assignments, t);
  }
  for (auto& t : type.results) {
    apply(assignments, t);
  }
}

// matchBottom: join the bottom value into the assignment in `assignments` for
// any variables appearing in the second parameter. Returns `true` if this
// succeeds. TODO: This currently always succeeds, but if we supported repeated
// variables in outputs properly, we would need to avoid mixing left assignment
// and right assignment, so this would be able to fail.

bool matchBottom(VarAssignments& assignments, const VarNullability& null) {
  if (auto* i = std::get_if<Index>(&null)) {
    return assignments.nulls.assign(*i, NonNullable);
  }
  return true;
}

bool matchBottom(VarAssignments& assignments, const VarSharedness& share) {
  if (auto* i = std::get_if<Index>(&share)) {
    return assignments.shares.assign(*i, BottomShare{});
  }
  return true;
}

bool matchBottom(VarAssignments& assignments, const VarExactness& exact) {
  if (auto* i = std::get_if<Index>(&exact)) {
    return assignments.exacts.assign(*i, Exact);
  }
  return true;
}

bool matchBottom(VarAssignments& assignments, const VarAbsHeapType& type) {
  return matchBottom(assignments, type.share);
}

bool matchBottom(VarAssignments& assignments, const VarDefHeapType& type) {
  return matchBottom(assignments, type.exact);
}

bool matchBottom(VarAssignments& assignments, const VarHeapType& type) {
  if (auto* i = std::get_if<Index>(&type)) {
    return assignments.heapTypes.assign(*i, BottomHeapType{});
  } else if (auto* t = std::get_if<VarAbsHeapType>(&type)) {
    return matchBottom(assignments, *t);
  } else if (auto* t = std::get_if<VarDefHeapType>(&type)) {
    return matchBottom(assignments, *t);
  } else {
    assert(std::get_if<BottomHeapType>(&type));
    return true;
  }
}

bool matchBottom(VarAssignments& assignments, const VarRef& ref) {
  return matchBottom(assignments, ref.null) && matchBottom(assignments, ref.ht);
}

// match: Record the variable assignments necessary to make `a` match `b` (i.e.
// to ensure `a` <: `b`).

bool match(VarAssignments& assignments,
           const VarNullability& a,
           const VarNullability& b) {
  if (auto* i = std::get_if<Index>(&a)) {
    return assignments.nulls.assign(*i, b);
  }
  if (auto* i = std::get_if<Index>(&b)) {
    return assignments.nulls.assign(*i, a);
  }
  return std::get<Nullability>(a) == NonNullable ||
         std::get<Nullability>(b) == Nullable;
}

bool match(VarAssignments& assignments,
           const VarSharedness& a,
           const VarSharedness& b) {
  if (auto* i = std::get_if<Index>(&a)) {
    return assignments.shares.assign(*i, b);
  }
  if (auto* i = std::get_if<Index>(&b)) {
    return assignments.shares.assign(*i, a);
  }
  if (std::get_if<BottomShare>(&a)) {
    return true;
  }
  if (std::get_if<BottomShare>(&b)) {
    return false;
  }
  return std::get<Shareability>(a) == std::get<Shareability>(b);
}

bool match(VarAssignments& assignments,
           const VarAbsHeapType& a,
           const VarAbsHeapType& b) {
  return HeapType::isSubType(a.ht, b.ht) &&
         match(assignments, a.share, b.share);
}

bool match(VarAssignments& assignments,
           const VarDefHeapType& a,
           const VarDefHeapType& b) {
  if (!HeapType::isSubType(a.ht, b.ht)) {
    return false;
  }
  bool sameType = a.ht == b.ht;
  auto* exactA = std::get_if<Exactness>(&a.exact);
  auto* exactB = std::get_if<Exactness>(&b.exact);
  if (exactB && *exactB == Exact && !sameType) {
    return false;
  }
  auto* indexA = std::get_if<Index>(&a.exact);
  auto* indexB = std::get_if<Index>(&b.exact);
  if (indexA || indexB) {
    if (indexA &&
        !assignments.exacts.assign(*indexA, sameType ? b.exact : Inexact)) {
      return false;
    }
    if (indexB &&
        !assignments.exacts.assign(*indexB, sameType ? a.exact : Inexact)) {
      return false;
    }
    return true;
  }
  assert(exactA && exactB);
  return *exactA == Exact || *exactB == Inexact;
}

bool match(VarAssignments& assignments,
           const VarAbsHeapType& a,
           const VarDefHeapType& b) {
  auto* shareA = std::get_if<Shareability>(&a.share);
  HeapType htA = a.ht.getBasic(shareA ? *shareA : b.ht.getShared());
  if (!HeapType::isSubType(htA, b.ht)) {
    return false;
  }
  if (auto* i = std::get_if<Index>(&a.share)) {
    if (!assignments.shares.assign(*i, b.ht.getShared())) {
      return false;
    }
  }
  if (auto* i = std::get_if<Index>(&b.exact)) {
    if (!assignments.exacts.assign(*i, Exact)) {
      return false;
    }
  }
  return true;
}

bool match(VarAssignments& assignments,
           const VarDefHeapType& a,
           const VarAbsHeapType& b) {
  if (std::get_if<BottomShare>(&b.share)) {
    return false;
  }
  auto* shareB = std::get_if<Shareability>(&b.share);
  HeapType htB = b.ht.getBasic(shareB ? *shareB : a.ht.getShared());
  if (!HeapType::isSubType(a.ht, htB)) {
    return false;
  }
  if (auto* i = std::get_if<Index>(&a.exact)) {
    if (!assignments.exacts.assign(*i, Inexact)) {
      return false;
    }
  }
  if (auto* i = std::get_if<Index>(&b.share)) {
    if (!assignments.shares.assign(*i, a.ht.getShared())) {
      return false;
    }
  }
  return true;
}

bool match(VarAssignments& assignments,
           const VarHeapType& a,
           const VarHeapType& b) {
  if (auto* i = std::get_if<Index>(&a)) {
    return assignments.heapTypes.assign(*i, b);
  }
  if (auto* i = std::get_if<Index>(&b)) {
    return assignments.heapTypes.assign(*i, a);
  }
  if (std::get_if<BottomHeapType>(&a)) {
    return matchBottom(assignments, b);
  }
  if (std::get_if<BottomHeapType>(&b)) {
    return false;
  }
  auto* absA = std::get_if<VarAbsHeapType>(&a);
  auto* absB = std::get_if<VarAbsHeapType>(&b);
  auto* defA = std::get_if<VarDefHeapType>(&a);
  auto* defB = std::get_if<VarDefHeapType>(&b);
  if (absA && absB) {
    return match(assignments, *absA, *absB);
  }
  if (absA && defB) {
    return match(assignments, *absA, *defB);
  }
  if (defA && absB) {
    return match(assignments, *defA, *absB);
  }
  if (defA && defB) {
    return match(assignments, *defA, *defB);
  }
  WASM_UNREACHABLE("unexpected variants");
}

bool match(VarAssignments& assignments, const VarRef& a, const VarRef& b) {
  return match(assignments, a.null, b.null) && match(assignments, a.ht, b.ht);
}

// Update the assignments as necessary to make a <: b, returning true iff this
// is possible. Otherwise the assignments may be partially modified.
bool match(VarAssignments& assignments, const VarType& a, const VarType& b) {
  assert(valid(a) && valid(b));
  if (auto* i = std::get_if<Index>(&a)) {
    return assignments.types.assign(*i, b);
  }
  if (auto* i = std::get_if<Index>(&b)) {
    return assignments.types.assign(*i, a);
  }

  auto* refA = std::get_if<VarRef>(&a);
  assert(!refA || a == canonicalizeRef(*refA));
  auto* refB = std::get_if<VarRef>(&b);
  assert(!refB || b == canonicalizeRef(*refB));

  if (refA && refB) {
    return match(assignments, *refA, *refB);
  }

  auto* typeA = std::get_if<Type>(&a);
  auto* typeB = std::get_if<Type>(&b);

  if (typeA && typeB) {
    return Type::isSubType(*typeA, *typeB);
  }

  if (typeA && *typeA == Type::unreachable) {
    assert(refB);
    return matchBottom(assignments, *refB);
  }

  if (typeA) {
    assert(refB);
    if (!typeA->isRef()) {
      return false;
    }
    return match(assignments, asVarRef(*typeA), *refB);
  }

  assert(refA && typeB);
  if (!typeB->isRef()) {
    return false;
  }
  return match(assignments, *refA, asVarRef(*typeB));
}

// print: print a principal type to `o`. Used for debugging and producing
// helpful error messages in tests.

void print(std::ostream& o, const VarNullability& null) {
  if (auto* i = std::get_if<Index>(&null)) {
    o << "n" << *i;
  } else if (std::get<Nullability>(null) == Nullable) {
    o << "null ";
  }
}

void print(std::ostream& o, const VarAbsHeapType& type) {
  bool hasParen = false;
  if (auto* i = std::get_if<Index>(&type.share)) {
    o << "(s" << *i << " ";
    hasParen = true;
  } else if (std::get_if<BottomShare>(&type.share)) {
    o << "(bot-share ";
    hasParen = true;
  } else if (std::get<Shareability>(type.share) == Shared) {
    o << "(shared ";
    hasParen = true;
  }
  o << type.ht;
  if (hasParen) {
    o << ")";
  }
}

void print(std::ostream& o, const VarDefHeapType& type) {
  bool hasParen = false;
  if (auto* i = std::get_if<Index>(&type.exact)) {
    o << "(e" << *i << " ";
    hasParen = true;
  } else if (std::get<Exactness>(type.exact) == Exact) {
    o << "(exact ";
    hasParen = true;
  }
  o << type.ht;
  if (hasParen) {
    o << ")";
  }
}

void print(std::ostream& o, const VarHeapType& type) {
  if (auto* i = std::get_if<Index>(&type)) {
    o << "ht" << *i;
  } else if (auto* t = std::get_if<VarAbsHeapType>(&type)) {
    print(o, *t);
  } else if (auto* t = std::get_if<VarDefHeapType>(&type)) {
    print(o, *t);
  } else {
    assert(std::get_if<BottomHeapType>(&type));
    o << "bot";
  }
}

void print(std::ostream& o, const VarRef& ref) {
  o << "(ref ";
  print(o, ref.null);
  print(o, ref.ht);
  o << ")";
}

void print(std::ostream& o, const VarType& type) {
  if (auto* i = std::get_if<Index>(&type)) {
    o << "t" << *i;
  } else if (auto* t = std::get_if<VarRef>(&type)) {
    print(o, *t);
  } else {
    o << std::get<Type>(type);
  }
}

void print(std::ostream& o, const PrincipalType& type) {
  o << "[";
  for (auto it = type.rparams.rbegin(); it != type.rparams.rend(); ++it) {
    if (it != type.rparams.rbegin()) {
      o << " ";
    }
    print(o, *it);
  }
  o << ']';
  if (type.unreachable) {
    o << '*';
  }
  o << "->[";
  for (auto it = type.results.begin(); it != type.results.end(); ++it) {
    if (it != type.results.begin()) {
      o << " ";
    }
    print(o, *it);
  }
  o << "]";
}

} // anonymous namespace

bool PrincipalType::compose(const PrincipalType& next) {
  assert(&next != this);

  // Renumber the variables in this type to ensure they're distinct from the
  // variables in `next`. `counts` will end up with the total counts across both
  // types.
  VarCounts counts;
  countVars(counts, next);
  renumberVars(counts, *this);

  // Match up the provided and required types, collecting values for and
  // unifying variables.
  Index numProvided = results.size();
  Index numRequired = next.rparams.size();
  Index numMatched = std::min(numProvided, numRequired);
  VarAssignments assignments;
  for (Index i = 0; i < numMatched; ++i) {
    const auto& provided = results[numProvided - i - 1];
    const auto& required = next.rparams[i];
    if (!match(assignments, provided, required)) {
      // Undo our previous renumbering of indices.
      canonicalizeVars(*this);
      return false;
    }
  }

  // The matched provided and required types are consistent, so from this point
  // we know the composition will succeed and we can start mutating things. The
  // matched provided types are annihilated by the matched required types.
  results.resize(numProvided - numMatched);

  // Any extra required parameters are prepended to the current parameters (i.e.
  // appended to the reversed list of parameters), unless they would be
  // satisfied by popping from an unreachable stack instead.
  if (numRequired > numMatched) {
    if (unreachable) {
      for (Index i = numMatched; i < numRequired; ++i) {
        const auto& required = next.rparams[i];
        [[maybe_unused]] bool assigned =
          match(assignments, Type(Type::unreachable), required);
        assert(assigned);
      }
    } else {
      rparams.reserve(rparams.size() + (numRequired - numMatched));
      for (Index i = numMatched; i < numRequired; ++i) {
        rparams.push_back(next.rparams[i]);
      }
    }
  }

  if (next.unreachable) {
    // The existing results do not make it past the following unreachable.
    results.clear();
    unreachable = true;
  }

  // Append the new results.
  for (const VarType& result : next.results) {
    results.push_back(result);
  }

  apply(assignments, *this);
  // If a type variable was instantiated with bottom type (i.e. unreachable) due
  // to popping from an unreachabile stack, the result type may end with some
  // number of unreachables. This is nonsensical, since `unreachable` is not a
  // concrete type. We could have alternatively left the variables
  // uninstantiated, but it would have no corresponding introduction on the left
  // hand side of the type. Even better is to canonicalize to empty results.
  // Since the new principal type is unreachable, this has the same semantics as
  // having an unconstrained result variable.
  if (!results.empty()) {
    auto& last = results[results.size() - 1];
    if (auto* t = std::get_if<Type>(&last); t && *t == Type::unreachable) {
      results.clear();
    }
  }

  canonicalizeVars(*this);
  return true;
}

std::optional<Signature> PrincipalType::getSignature() const {
  std::vector<Type> sigParams, sigResults;
  for (auto it = rparams.rbegin(); it != rparams.rend(); ++it) {
    auto item = *it;
    if (auto* type = std::get_if<Type>(&item)) {
      sigParams.push_back(*type);
    } else {
      return {};
    }
  }
  for (auto& result : results) {
    if (auto* type = std::get_if<Type>(&result)) {
      sigResults.push_back(*type);
    } else {
      return {};
    }
  }
  return Signature(sigParams, sigResults);
}

bool PrincipalType::matches(Type type, VarType constraint) {
  VarAssignments assignments;
  return match(assignments, VarType{type}, constraint);
}

std::ostream& operator<<(std::ostream& o, const PrincipalType& type) {
  print(o, type);
  return o;
}

} // namespace wasm
