/*
 * Copyright 2017 WebAssembly Community Group participants
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

#ifndef wasm_ir_local_graph_h
#define wasm_ir_local_graph_h

#include "support/small_set.h"
#include "wasm.h"

namespace wasm {

//
// Finds the connections between local.gets and local.sets, creating
// a graph of those ties. This is useful for "ssa-style" optimization,
// in which you want to know exactly which sets are relevant for a
// a get, so it is as if each get has just one set, logically speaking
// (see the SSA pass for actually creating new local indexes based
// on this).
//
// Note that this is not guaranteed to be precise in unreachable code. That is,
// we do not make the effort to represent the exact sets for each get, and may
// overestimate them (specifically, we may mark the entry value as possible,
// even if unreachability prevents that; doing so helps simplify and optimize
// the code, which we think is worthwhile for the possible annoyance in
// debugging etc.; and it has no downside for optimization, since unreachable
// code will be removed anyhow).
//
// There are two options here, the normal LocalGraph which is eager and computes
// everything up front, which is faster if most things end up needed, and a lazy
// one which computes on demand, which can be much faster if we only need a
// small subset of queries.
//

// Base class for both LocalGraph and LazyLocalGraph (not meant for direct use).
struct LocalGraphBase {
protected:
  // If a module is passed in, it is used to find which features are needed in
  // the computation (for example, if exception handling is disabled, then we
  // can generate a simpler CFG, as calls cannot throw).
  LocalGraphBase(Function* func, Module* module = nullptr)
    : func(func), module(module) {}

public:
  // A set of sets, returned from the query about which sets can be read from a
  // get. Typically only one or two apply there, so this is a small set.
  using Sets = SmallSet<LocalSet*, 2>;

  // Where each get and set is.
  using Locations = std::map<Expression*, Expression**>;

  // A map of each get to the sets relevant to it (i.e., that it can read from).
  using GetSetsMap = std::unordered_map<LocalGet*, Sets>;

  // Sets of gets or sets, that are influenced, returned from get*Influences().
  using SetInfluences = std::unordered_set<LocalGet*>;
  using GetInfluences = std::unordered_set<LocalSet*>;

  using SetInfluencesMap = std::unordered_map<LocalSet*, SetInfluences>;
  using GetInfluencesMap = std::unordered_map<LocalGet*, GetInfluences>;

protected:
  Function* func;
  Module* module;

  std::set<Index> SSAIndexes;
};

struct LocalGraph : public LocalGraphBase {
  LocalGraph(Function* func, Module* module = nullptr);

  // Get the sets relevant for a local.get.
  //
  // A nullptr set means there is no local.set for that value, which means it is
  // the initial value from the function entry: 0 for a var, the received value
  // for a param.
  //
  // Often there is a single set, or a phi or two items, so we use a small set.
  const Sets& getSets(LocalGet* get) const {
    auto iter = getSetsMap.find(get);
    if (iter == getSetsMap.end()) {
      // A missing entry means there is nothing there (and we saved a little
      // space by not putting something there).
      //
      // Use a canonical constant empty set to avoid allocation.
      static const Sets empty;
      return empty;
    }
    return iter->second;
  }

  // We compute the locations of gets and sets while doing the main computation
  // and make it accessible for users, for easy replacing of things without
  // extra work.
  Locations locations;

  // Checks if two gets are equivalent, that is, definitely have the same
  // value.
  bool equivalent(LocalGet* a, LocalGet* b);

  // Optional: compute the influence graphs between sets and gets (useful for
  // algorithms that propagate changes). Set influences are the gets that can
  // read from it; get influences are the sets that can (directly) read from it.
  void computeSetInfluences();
  void computeGetInfluences();

  void computeInfluences() {
    computeSetInfluences();
    computeGetInfluences();
  }

  const SetInfluences& getSetInfluences(LocalSet* set) const {
    auto iter = setInfluences.find(set);
    if (iter == setInfluences.end()) {
      // Use a canonical constant empty set to avoid allocation.
      static const SetInfluences empty;
      return empty;
    }
    return iter->second;
  }
  const GetInfluences& getGetInfluences(LocalGet* get) const {
    auto iter = getInfluences.find(get);
    if (iter == getInfluences.end()) {
      // Use a canonical constant empty set to avoid allocation.
      static const GetInfluences empty;
      return empty;
    }
    return iter->second;
  }

  // Optional: Compute the local indexes that are SSA, in the sense of
  //  * a single set for all the gets for that local index
  //  * the set dominates all the gets (logically implied by the former
  //  property)
  //  * no other set (aside from the zero-init)
  // The third property is not exactly standard SSA, but is useful since we are
  // not in SSA form in our IR. To see why it matters, consider these:
  //
  // x = 0 // zero init
  // [..]
  // x = 10
  // y = x + 20
  // x = 30 // !!!
  // f(y)
  //
  // The !!! line violates that property - it is another set for x, and it may
  // interfere say with replacing f(y) with f(x + 20). Instead, if we know the
  // only other possible set for x is the zero init, then things like the !!!
  // line cannot exist, and it is valid to replace f(y) with f(x + 20). (This
  // could be simpler, but in wasm the zero init always exists.)

  void computeSSAIndexes();

  bool isSSA(Index x);

private:
  GetSetsMap getSetsMap;

  SetInfluencesMap setInfluences;
  GetInfluencesMap getInfluences;
};

// The internal implementation of the flow analysis used to compute things. This
// must be declared in the header so that LazyLocalGraph can declare a unique
// ptr to it, below.
struct LocalGraphFlower;

struct LazyLocalGraph : public LocalGraphBase {
  LazyLocalGraph(Function* func, Module* module = nullptr);
  ~LazyLocalGraph();

  // Similar APIs as in LocalGraph, but lazy versions. Each of them does a
  // lookup, and if there is a missing entry then we did not do the computation
  // yet, and then we do it and memoize it.
  const Sets& getSets(LocalGet* get) const {
    auto iter = getSetsMap.find(get);
    if (iter == getSetsMap.end()) {
      computeGetSets(get);
      iter = getSetsMap.find(get);
      assert(iter != getSetsMap.end());
    }
    return iter->second;
  }
  const SetInfluences& getSetInfluences(LocalSet* set) const {
    auto iter = setInfluences.find(set);
    if (iter == setInfluences.end()) {
      computeSetInfluences(set);
      iter = setInfluences.find(set);
      assert(iter != setInfluences.end());
    }
    return iter->second;
  }
  const GetInfluences& getGetInfluences(LocalGet* get) const {
    if (!getInfluences) {
      computeGetInfluences();
      assert(getInfluences);
    }
    return (*getInfluences)[get];
  }
  bool isSSA(Index index) const {
    auto iter = SSAIndexes.find(index);
    if (iter == SSAIndexes.end()) {
      auto ret = computeSSA(index);
      // The result must have been memoized.
      assert(SSAIndexes.count(index));
      return ret;
    }
    return iter->second;
  }

  const Locations& getLocations() const {
    if (!locations) {
      computeLocations();
      assert(locations);
    }
    return *locations;
  }

private:
  // These data structures are mutable so that we can memoize.
  mutable GetSetsMap getSetsMap;

  mutable SetInfluencesMap setInfluences;
  // The entire |getInfluences| is computed once the first request for one
  // arrives, so the entire thing is either present or not, unlike setInfluences
  // which is fine-grained. The difference is that the influences of a get may
  // include sets of other indexes, so there is no simple way to lazify that
  // computation.
  mutable std::optional<GetInfluencesMap> getInfluences;
  // A map if indexes to a bool indicating if the index is SSA. If there is no
  // entry, it has not yet been computed.
  mutable std::unordered_map<Index, bool> SSAIndexes;
  mutable std::optional<Locations> locations;

  // Compute the sets for a get and store them on getSetsMap.
  void computeGetSets(LocalGet* get) const;
  // Compute influences for a set and store them on setInfluences.
  void computeSetInfluences(LocalSet* set) const;
  // Compute influences for all gets and store them on getInfluences.
  void computeGetInfluences() const;
  // Compute whether an index is SSA and store that on SSAIndexes.
  bool computeSSA(Index index) const;
  // Compute locations and store them on getInfluences.
  void computeLocations() const;

  // This remains alive as long as we are, so that we can compute things lazily.
  // It is mutable as when we construct this is an internal detail, that does
  // not cause observable differences in API calls.
  mutable std::unique_ptr<LocalGraphFlower> flower;

  // We create |flower| lazily.
  void makeFlower() const;
};

} // namespace wasm

#endif // wasm_ir_local_graph_h
