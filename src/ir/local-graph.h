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
struct LocalGraph {
  // A LocalGraph can be instantiated in either eager or lazy mode. In eager
  // mode we compute all possible results of getSets() in advance, which is a
  // little more efficient if they are all needed. In lazy mode they are
  // computed on demand, which is better if only a few will be queried.
  enum Mode { Eager, Lazy };

  // If a module is passed in, it is used to find which features are needed in
  // the computation (for example, if exception handling is disabled, then we
  // can generate a simpler CFG, as calls cannot throw).
  LocalGraph(Function* func, Module* module = nullptr, Mode mode = Mode::Eager);
  ~LocalGraph();

  // Generic form of a getter that works differently in lazy vs eager mode.
  template<typename Key, typename Result, typename Storage, typename ComputeLazily>
  const Result& getLazilyOrEagerly(Key* get, Result& empty, Storage& storage, ComputeLazily computeLazily) const {
    auto iter = storage.find(get);
    if (iter == storage.end()) {
      if (mode == Mode::Lazy) {
        // In lazy mode, a missing entry means we did not do the computation
        // yet. Do it now.
        computeLazily(get);
        iter = storage.find(get);
        assert(iter != storage.end());
      } else {
        // In eager mode, a missing entry means there is nothing there (and we
        // saved a little space by not putting something there).
        return empty;
      }
    }
    return iter->second;
  }

  // Get the sets relevant for a local.get.
  //
  // A nullptr set means there is no local.set for that value, which means it is
  // the initial value from the function entry: 0 for a var, the received value
  // for a param.
  //
  // Often there is a single set, or a phi or two items, so we use a small set.
  using Sets = SmallSet<LocalSet*, 2>;

  const Sets& getSets(LocalGet* get) const {
    return getLazilyOrEagerly(get, emptySets, getSetsMap, [this](LocalGet* get) {
      computeGetSets(get);
    });
  }

  // Where each get and set is. We compute this while doing the main computation
  // and make it accessible for users, for easy replacing of things without
  // extra work.
  using Locations = std::map<Expression*, Expression**>;
  Locations locations;

  // Checks if two gets are equivalent, that is, definitely have the same
  // value.
  bool equivalent(LocalGet* a, LocalGet* b);

  // Optional: compute the influence graphs between sets and gets (useful for
  // algorithms that propagate changes). How this works depends on the laziness
  // mode, like getSets, and using the same flag (that is, the entire LocalGraph
  // is either in eager or lazy mode). Specifically, when in eager mode, one
  // must call the relevant compute*Influences() method before calling
  // get*Influences(). In lazy mode, one can query without any such initial
  // work, and it will be computed and memoized.
  void computeSetInfluences();
  void computeGetInfluences();
  void computeInfluences() {
    computeSetInfluences();
    computeGetInfluences();
  }

  using SetInfluences = std::unordered_set<LocalGet*>;
  using GetInfluences = std::unordered_set<LocalSet*>;

  const SetInfluences& getSetInfluences(LocalSet* set) const {
    // Use a canonical constant empty set to avoid allocation.
    return getLazilyOrEagerly(set, emptySetInfluences, setInfluences, [this](LocalSet* set) {
      computeSetInfluences(set);
    });
  }

  const GetInfluences& getGetInfluences(LocalGet* get) const {
    // Use a canonical constant empty set to avoid allocation.
    return getLazilyOrEagerly(get, emptyGetInfluences, getInfluences, [this](LocalGet* get) {
      computeGetInfluences(get);
    });
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

  // Defined publicly as other utilities need similar data layouts.
  using GetSetsMap = std::unordered_map<LocalGet*, Sets>;

private:
  Mode mode;
  Function* func;
  std::set<Index> SSAIndexes;

  // A map of each get to the sets relevant to it. This is mutable so that
  // getSets() can be const: in eager mode no changes to this are ever made in
  // getSets(), while in lazy mode any changes are just memoization.
  mutable GetSetsMap getSetsMap;

  // The internal implementation of the flow analysis used to compute
  // getSetsMap.
  struct LocalGraphFlower;
  std::unique_ptr<LocalGraphFlower> flower;

  // Compute the sets for a get and store them on getSetsMap.
  void computeGetSets(LocalGet* get) const;

  // Maps of each get to the sets it influences (i.e., sets that read that get).
  // Similar to getSetsMap, this is mutable as the only change is memoization.
  mutable std::unordered_map<LocalGet*, GetInfluences> getInfluences;
  // Maps of each set to the gets it influences (i.e., that can read that set;
  // the inverse of getSetsMap).
  // Similar to getSetsMap, this is mutable as the only change is memoization.
  mutable std::unordered_map<LocalSet*, SetInfluences> setInfluences;

  // Compute the influences of a set/get and store them set/getInfluences.
  void computeSetInfluences(LocalSet* set) const;
  void computeGetInfluences(LocalGet* set) const;

  // Use canonical constant empty sets to avoid allocation.
  static const Sets empty;
  static const SetInfluences emptySetInfluences;
  static const GetInfluences emptyGetInfluences;
};

} // namespace wasm

#endif // wasm_ir_local_graph_h
