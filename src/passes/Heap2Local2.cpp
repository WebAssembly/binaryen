/*
 * Copyright 2026 WebAssembly Community Group participants
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

//
// Replace non-escaping GC allocations with local variables in a single
// function-wide analysis and rewrite.
//
// Phase 1 builds a dataflow graph over reference expressions in a function,
// collecting candidate StructNew, fixed-size ArrayNew, and ArrayNewFixed
// allocations alongside identity edges, cast sites, atomic cmpxchg sites, and
// escaping uses.
//
// Phase 2 solves a smallest fixed point over Flat<AllocId> origins (i.e. the
// flat lattice of all allocation sites) across all candidate allocations
// simultaneously:
//   - Bot: unreachable or statically trapping cast output.
//   - Val(a): definitely non-null reference to a single allocation `a`.
//   - Top: unknown / nullable / multiple merged allocations.
//
// Phase 3 propagates escapes over cmpxchg (expected -> replacement) edges,
// escaping uses, and identity-edge mixes (Val(a) flowing into Top).
//
// Phase 4 rewrites every non-escaping allocation and all expressions it flows
// into in a single post-order pass, followed by ReFinalize and
// TypeUpdating::handleNonDefaultableLocals.
//

#include <cstdint>
#include <limits>
#include <optional>
#include <unordered_map>
#include <utility>
#include <vector>

#include "analysis/lattices/flat.h"
#include "ir/abstract.h"
#include "ir/bits.h"
#include "ir/branch-utils.h"
#include "ir/iteration.h"
#include "ir/local-graph.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/small_vector.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace {

// Fixed arrays larger than this are rarely profitable to expand into locals,
// and valid Wasm can ask for huge constant sizes like (array.new (i32.const
// -1)).
constexpr uint32_t MaxArraySize = 20;

// Refer to candidate allocation sites and dataflow graph nodes by dense integer
// indices rather than pointers so the fixed-point and escape passes can store
// per-node and per-allocation state in compact flat vectors.
using AllocId = uint32_t;
using NodeId = uint32_t;
constexpr NodeId TopNode = 0;
constexpr NodeId InvalidNode = NodeId(-1);

using OriginLattice = analysis::Flat<AllocId>;
using Origin = OriginLattice::Element;

// Metadata and lowered local variable assignments for a candidate allocation.
struct AllocInfo {
  Expression* expr = nullptr;
  Type type;
  FieldList fields;
  std::optional<HeapType> descHeapType;
  bool escaped = false;

  // Populated before Phase 4 if we can optimize this allocation.
  std::vector<Index> fieldLocals;
  std::optional<Index> descLocal;

  Type getDescLocalType() const {
    assert(descHeapType.has_value());
    return Type(*descHeapType, NonNullable, Exact);
  }
};

// A ref.cast or ref.cast_desc_eq expression tracked during origin propagation.
// Casts do not escape their inputs, but depending on the input origin,
// descriptor reachability, and target subtype check they either propagate an
// allocation origin, trap (Bot), or produce Top, so Phase 2 must re-evaluate
// them as input origins are discovered rather than using plain identity edges.
struct CastSite {
  RefCast* expr;
  NodeId refNode;
  // InvalidNode when !expr->desc or when expr->desc is mapped to TopNode.
  NodeId descNode;
  NodeId outNode;
};

// An atomic cmpxchg site linking expected and replacement origins. If the
// expected allocation does not escape, it can never reside in the heap field
// being compared, so the comparison always fails at runtime and replacement is
// never written to memory. If expected escapes, however, it could match the
// heap value at runtime and cause cmpxchg to store replacement into the heap,
// forcing replacement to escape as well.
struct CmpxchgSite {
  NodeId expNode;
  NodeId repNode;
};

// Shared per-function state populated by GraphBuilder (Phase 1) and consumed by
// origin propagation (Phase 2), escape analysis (Phase 3), and IR rewriting
// (Phase 4).
struct AnalysisState {
  // Flat lattice over AllocId values (Bot < Val(alloc) < Top).
  OriginLattice originLattice;
  // Metadata and lowered local indices for each candidate allocation, indexed
  // by AllocId.
  std::vector<AllocInfo> allocs;
  // Maps each candidate allocation expression to its index in allocs.
  std::unordered_map<Expression*, AllocId> allocIds;
  // Maps tracked reference-typed expressions to their dataflow NodeId.
  std::unordered_map<Expression*, NodeId> exprNodes;
  // Current lattice value for each dataflow node, indexed by NodeId.
  std::vector<Origin> origins;
  // Directed edges (from, to) along which reference values flow unchanged.
  std::vector<std::pair<NodeId, NodeId>> identityEdges;
  // Nodes whose values flow into contexts that escape the function or alias
  // heap memory.
  std::vector<NodeId> escapingNodes;
  // Tracked ref.cast and ref.cast_desc_eq sites re-evaluated in Phase 2 as
  // their input origins move up the lattice.
  std::vector<CastSite> castSites;
  // Tracked cmpxchg sites where an escaping expected value forces replacement
  // to escape.
  std::vector<CmpxchgSite> cmpxchgSites;

  AnalysisState() {
    // Node 0 (TopNode) is a shared sentinel node with fixed origin Top
    // representing expressions absent from exprNodes that can never produce a
    // candidate allocation (e.g. call, global.get, struct.get, or ref.null).
    origins.push_back(originLattice.getTop());
  }

  NodeId getNode(Expression* curr) {
    assert(curr);
    assert(curr->type.isRef());
    assert(origins.size() < InvalidNode);
    auto [it, inserted] = exprNodes.emplace(curr, NodeId(origins.size()));
    if (inserted) {
      origins.push_back(originLattice.getBottom());
    }
    return it->second;
  }

  NodeId getNodeOrTop(Expression* curr) const {
    assert(curr);
    assert(curr->type.isRef());
    auto it = exprNodes.find(curr);
    return it != exprNodes.end() ? it->second : TopNode;
  }

  void seedOrigin(Expression* curr, Origin val) {
    originLattice.join(origins[getNode(curr)], val);
  }

  void seedTop(Expression* curr) { seedOrigin(curr, originLattice.getTop()); }

  void addIdentityEdge(NodeId fromNode, NodeId toNode) {
    if (fromNode == TopNode) {
      originLattice.join(origins[toNode], originLattice.getTop());
    } else {
      identityEdges.emplace_back(fromNode, toNode);
    }
  }

  void addIdentityEdge(Expression* from, NodeId toNode) {
    addIdentityEdge(getNodeOrTop(from), toNode);
  }

  void addIdentityEdge(NodeId fromNode, Expression* to) {
    addIdentityEdge(fromNode, getNode(to));
  }

  void addIdentityEdge(Expression* from, Expression* to) {
    addIdentityEdge(getNodeOrTop(from), getNode(to));
  }

  void escapeIfRef(Expression* curr) {
    if (curr->type.isRef()) {
      NodeId node = getNodeOrTop(curr);
      if (node != TopNode) {
        escapingNodes.push_back(node);
      }
    }
  }
};

// Lightweight pre-pass that stops as soon as any candidate allocation exists.
// Most functions contain no candidate allocations, so this avoids paying
// ControlFlowWalker and AnalysisState hash-map overhead for them.
struct CandidateFinder : public PostWalker<CandidateFinder> {
  bool found = false;

  static void scan(CandidateFinder* self, Expression** currp) {
    if (self->found) {
      return;
    }
    PostWalker<CandidateFinder>::scan(self, currp);
  }

  void visitStructNew(StructNew* curr) {
    if (curr->type != Type::unreachable) {
      found = true;
    }
  }

  void visitArrayNew(ArrayNew* curr) {
    if (curr->type != Type::unreachable) {
      if (auto* c = curr->size->dynCast<Const>()) {
        if (c->value.getUnsigned() < MaxArraySize) {
          found = true;
        }
      }
    }
  }

  void visitArrayNewFixed(ArrayNewFixed* curr) {
    if (curr->type != Type::unreachable) {
      if (curr->values.size() < MaxArraySize) {
        found = true;
      }
    }
  }
};

// Phase 1: Single post-order walk over the function body to collect candidate
// allocations, dataflow edges, casts, cmpxchg sites, and escaping uses.
struct GraphBuilder
  : public ControlFlowWalker<GraphBuilder,
                             UnifiedExpressionVisitor<GraphBuilder>> {
  AnalysisState& state;
  Function* func;
  Module& wasm;
  // Whether any local.set writes a reference, used to skip LazyLocalGraph
  // construction when no reference locals are written.
  bool hasRefLocalSet = false;
  // Reference-typed local.gets collected during the walk to connect to their
  // reaching local.sets in build().
  std::vector<LocalGet*> refLocalGets;

  GraphBuilder(AnalysisState& state, Function* func, Module& wasm)
    : state(state), func(func), wasm(wasm) {}

  void build() {
    walk(func->body);
    // Guaranteed by the CandidateFinder pre-pass.
    assert(!state.allocs.empty());

    // Values returned out of the function body escape.
    state.escapeIfRef(func->body);

    // Connect local.gets to reaching local.sets via LazyLocalGraph. If there
    // are no reference-typed local.sets in the function, every reachable
    // reference local.get must read either a function parameter or a default
    // null local initializer, neither of which can be a candidate allocation.
    // Seed them directly with Top to avoid constructing LazyLocalGraph.
    if (!hasRefLocalSet) {
      for (auto* get : refLocalGets) {
        state.seedTop(get);
      }
      return;
    }

    LazyLocalGraph localGraph(func, &wasm);
    for (auto* get : refLocalGets) {
      for (LocalSet* set : localGraph.getSets(get)) {
        if (!set) {
          // Reading entry/default local value violates the single-live-instance
          // invariant (e.g. a value from an earlier loop iteration or param).
          state.seedTop(get);
        } else {
          assert(set->value->type.isRef() && "unexpected unreachable set");
          state.addIdentityEdge(set->value, get);
        }
      }
    }
  }

  AllocId
  addCandidateAlloc(Expression* curr,
                    const FieldList& fields,
                    std::optional<HeapType> descHeapType = std::nullopt) {
    assert(state.allocs.size() < std::numeric_limits<AllocId>::max());
    AllocId id = AllocId(state.allocs.size());
    auto& info = state.allocs.emplace_back();
    info.expr = curr;
    info.type = curr->type;
    info.fields.assign(fields.begin(), fields.end());
    info.descHeapType = descHeapType;
    state.allocIds[curr] = id;
    state.seedOrigin(curr, state.originLattice.get(id));
    return id;
  }

  void visitStructNew(StructNew* curr) {
    // TODO: Track field, element, and descriptor edges to optimize nested
    // allocations.
    for (auto* op : curr->operands) {
      state.escapeIfRef(op);
    }
    if (curr->desc) {
      state.escapeIfRef(curr->desc);
    }
    // We still visit and escape operands above even when curr is unreachable,
    // because a later unreachable operand lets earlier operands execute before
    // trapping. Only register reachable struct.new instructions as candidates.
    if (curr->type != Type::unreachable) {
      std::optional<HeapType> descHeapType =
        curr->type.getHeapType().getDescriptorType();
      assert(bool(curr->desc) == descHeapType.has_value());
      assert(!curr->desc || curr->desc->type.isRef());
      addCandidateAlloc(
        curr, curr->type.getHeapType().getStruct().fields, descHeapType);
    }
  }

  void visitArrayNew(ArrayNew* curr) {
    // Escape init even if curr is unreachable (init executes before a trap in
    // size).
    if (curr->init) {
      state.escapeIfRef(curr->init);
    }
    if (curr->type != Type::unreachable) {
      if (auto* c = curr->size->dynCast<Const>()) {
        uint32_t size = c->value.getUnsigned();
        if (size < MaxArraySize) {
          FieldList fields(size, curr->type.getHeapType().getArray().element);
          addCandidateAlloc(curr, fields);
        }
      }
    }
  }

  void visitArrayNewFixed(ArrayNewFixed* curr) {
    // Escape element operands even if curr is unreachable (earlier operands
    // execute before an unreachable operand traps).
    for (auto* val : curr->values) {
      state.escapeIfRef(val);
    }
    if (curr->type != Type::unreachable) {
      if (curr->values.size() < MaxArraySize) {
        FieldList fields(curr->values.size(),
                         curr->type.getHeapType().getArray().element);
        addCandidateAlloc(curr, fields);
      }
    }
  }

  // Block and Loop fallthroughs are wired directly rather than via
  // Properties::getImmediateFallthrough, which conservatively rejects all named
  // blocks and loops.
  void visitBlock(Block* curr) {
    if (curr->type.isRef()) {
      assert(!curr->list.empty());
      if (curr->list.back()->type.isRef()) {
        state.addIdentityEdge(curr->list.back(), curr);
      }
    }
  }

  void visitLoop(Loop* curr) {
    if (curr->type.isRef()) {
      if (curr->body->type.isRef()) {
        state.addIdentityEdge(curr->body, curr);
      }
    }
  }

  void visitIf(If* curr) {
    if (curr->type.isRef()) {
      assert(curr->ifFalse);
      NodeId outNode = state.getNode(curr);
      if (curr->ifTrue->type.isRef()) {
        state.addIdentityEdge(curr->ifTrue, outNode);
      }
      if (curr->ifFalse->type.isRef()) {
        state.addIdentityEdge(curr->ifFalse, outNode);
      }
    }
  }

  void visitSelect(Select* curr) {
    if (curr->type.isRef()) {
      assert(curr->ifTrue->type.isRef());
      assert(curr->ifFalse->type.isRef());
      NodeId outNode = state.getNode(curr);
      state.addIdentityEdge(curr->ifTrue, outNode);
      state.addIdentityEdge(curr->ifFalse, outNode);
    }
  }

  void visitBreak(Break* curr) {
    if (curr->value && curr->value->type.isRef()) {
      auto* target = findBreakTarget(curr->name);
      assert(target);
      assert(target->type.isRef());
      NodeId valNode = state.getNodeOrTop(curr->value);
      state.addIdentityEdge(valNode, target);
      // Reachable ref-typed br_if also returns its value (unconditional br has
      // unreachable type).
      if (curr->type.isRef()) {
        state.addIdentityEdge(valNode, curr);
      }
    }
  }

  void visitSwitch(Switch* curr) {
    if (curr->value && curr->value->type.isRef()) {
      NodeId valNode = state.getNodeOrTop(curr->value);
      for (Name name : BranchUtils::getUniqueTargets(curr)) {
        auto* target = findBreakTarget(name);
        assert(target);
        assert(target->type.isRef());
        state.addIdentityEdge(valNode, target);
      }
    }
  }

  void visitLocalSet(LocalSet* curr) {
    if (curr->value->type.isRef()) {
      hasRefLocalSet = true;
      // In Binaryen IR, a local.tee is a LocalSet whose expression type is
      // the local's type rather than Type::none. Its write to the local is
      // wired to reaching local.gets via LazyLocalGraph in build(), while its
      // fallthrough value flows to its parent expression via this identity
      // edge.
      if (curr->isTee()) {
        state.addIdentityEdge(curr->value, curr);
      }
    }
  }

  void visitLocalGet(LocalGet* curr) {
    if (curr->type.isRef()) {
      refLocalGets.push_back(curr);
      state.getNode(curr);
    }
  }

  void visitRefAs(RefAs* curr) {
    if (curr->op == RefAsNonNull) {
      if (curr->type.isRef()) {
        assert(curr->value->type.isRef());
        state.addIdentityEdge(curr->value, curr);
      }
    } else {
      visitExpression(curr);
    }
  }

  void visitRefCast(RefCast* curr) {
    // Neither ref nor desc escapes through ref.cast{,_desc_eq}; if the cast
    // is already unreachable, Optimizer skips it and WasmValidator accepts
    // optimized children that become bottom nullref.
    if (curr->type.isRef()) {
      assert(curr->ref->type.isRef());
      NodeId refNode = state.getNodeOrTop(curr->ref);
      if (refNode == TopNode) {
        return;
      }
      NodeId descNode = InvalidNode;
      if (curr->desc) {
        assert(curr->desc->type.isRef());
        NodeId maybeDesc = state.getNodeOrTop(curr->desc);
        if (maybeDesc != TopNode) {
          descNode = maybeDesc;
        }
      }
      state.castSites.push_back({curr, refNode, descNode, state.getNode(curr)});
    }
  }

  void handleCmpxchg(Expression* cmpxchg,
                     Expression* expected,
                     Expression* replacement) {
    if (!replacement->type.isRef()) {
      return;
    }
    NodeId repNode = state.getNodeOrTop(replacement);
    if (repNode == TopNode) {
      return;
    }
    if (cmpxchg->type == Type::unreachable || !expected->type.isRef()) {
      // Optimizer skips unreachable cmpxchg instructions while WasmValidator
      // still checks replacement against a reachable ref's field/element type;
      // and when ref is a bottom nullref, validation accepts a non-reference
      // expected operand while finalize() sets the cmpxchg result type from
      // replacement->type.
      state.escapingNodes.push_back(repNode);
      return;
    }
    NodeId expNode = state.getNodeOrTop(expected);
    if (expNode == TopNode) {
      state.escapingNodes.push_back(repNode);
    } else {
      state.cmpxchgSites.push_back({expNode, repNode});
    }
  }

  void visitGlobalSet(GlobalSet* curr) { state.escapeIfRef(curr->value); }
  void visitReturn(Return* curr) {
    if (curr->value) {
      state.escapeIfRef(curr->value);
    }
  }
  void visitCall(Call* curr) {
    for (auto* op : curr->operands) {
      state.escapeIfRef(op);
    }
  }

  // These instructions only inspect or consume their reference operands without
  // letting them escape; overriding them prevents visitExpression from marking
  // their reference children as escaping.
  void visitDrop(Drop* curr) {}
  void visitRefIsNull(RefIsNull* curr) {}
  void visitRefEq(RefEq* curr) {}
  void visitRefTest(RefTest* curr) {}
  void visitRefGetDesc(RefGetDesc* curr) {}
  void visitStructGet(StructGet* curr) {}

  void visitStructSet(StructSet* curr) { state.escapeIfRef(curr->value); }

  void visitStructRMW(StructRMW* curr) { state.escapeIfRef(curr->value); }

  void visitStructCmpxchg(StructCmpxchg* curr) {
    handleCmpxchg(curr, curr->expected, curr->replacement);
  }

  void visitArrayGet(ArrayGet* curr) {
    if (!curr->index->is<Const>()) {
      state.escapeIfRef(curr->ref);
    }
  }

  void visitArraySet(ArraySet* curr) {
    if (!curr->index->is<Const>()) {
      state.escapeIfRef(curr->ref);
    }
    state.escapeIfRef(curr->value);
  }

  void visitArrayRMW(ArrayRMW* curr) {
    if (!curr->index->is<Const>()) {
      state.escapeIfRef(curr->ref);
    }
    state.escapeIfRef(curr->value);
  }

  void visitArrayCmpxchg(ArrayCmpxchg* curr) {
    if (!curr->index->is<Const>()) {
      state.escapeIfRef(curr->ref);
    }
    // Note: expected never escapes even when index is non-constant.
    handleCmpxchg(curr, curr->expected, curr->replacement);
  }

  void visitExpression(Expression* curr) {
    for (auto* child : ChildIterator(curr)) {
      state.escapeIfRef(child);
    }
    // Unhandled scope-branching instructions (e.g. TryTable, BrOn) can send
    // values to enclosing ref-typed Blocks. Seed those target Blocks with Top
    // so any candidate allocations flowing into them are treated as escaping.
    // TODO: Model BrOn* and TryTable dataflow edges directly instead of
    // conservatively seeding target blocks with Top.
    BranchUtils::operateOnScopeNameUsesAndSentTypes(
      curr, [&](Name& name, Type sentType) {
        if (sentType.isRef()) {
          auto* target = findBreakTarget(name);
          assert(target);
          assert(target->type.isRef());
          state.seedTop(target);
        }
      });
  }
};

// Phase 2: Solve smallest fixed point over Flat<AllocId> origins.
void computeOrigins(AnalysisState& state) {
  size_t numNodes = state.origins.size();
  assert(state.identityEdges.size() < InvalidNode);
  // Build a compressed-sparse-row (CSR) forward-adjacency table from
  // state.identityEdges: first count outgoing edges per node and compute prefix
  // sums in outOffsets so node u's targets live in [outOffsets[u],
  // outOffsets[u + 1]).
  std::vector<NodeId> outOffsets(numNodes + 1, 0);
  for (const auto& [u, v] : state.identityEdges) {
    ++outOffsets[u + 1];
  }
  for (size_t u = 0; u < numNodes; ++u) {
    outOffsets[u + 1] += outOffsets[u];
  }
  // Populate each source node's slice in outTargets. nextTargetIdx[u] starts
  // at outOffsets[u] and advances as targets of u are written, tracking the
  // next slot to fill (i.e. outOffsets[u] plus the number of targets populated
  // for u so far).
  std::vector<NodeId> outTargets(state.identityEdges.size());
  std::vector<NodeId> nextTargetIdx(outOffsets.begin(),
                                    outOffsets.begin() + numNodes);
  for (const auto& [u, v] : state.identityEdges) {
    outTargets[nextTargetIdx[u]++] = v;
  }

  std::vector<SmallVector<Index, 1>> nodeCasts;
  if (!state.castSites.empty()) {
    nodeCasts.resize(numNodes);
    for (Index i = 0; i < state.castSites.size(); ++i) {
      const auto& site = state.castSites[i];
      nodeCasts[site.refNode].push_back(i);
      if (site.descNode != InvalidNode) {
        nodeCasts[site.descNode].push_back(i);
      }
    }
  }

  // Used by pushNode below to skip sink nodes that have no outgoing identity
  // edges or dependent casts to propagate into.
  auto hasOutgoing = [&](NodeId u) {
    if (outOffsets[u] != outOffsets[u + 1]) {
      return true;
    }
    if (!nodeCasts.empty()) {
      if (!nodeCasts[u].empty()) {
        return true;
      }
    }
    return false;
  };

  std::vector<bool> inWorklist(numNodes, false);
  std::vector<NodeId> worklist;
  auto pushNode = [&](NodeId u) {
    if (hasOutgoing(u)) {
      if (!inWorklist[u]) {
        inWorklist[u] = true;
        worklist.push_back(u);
      }
    }
  };

  // Start at node 1 because TopNode (0) never has outgoing edges or casts.
  for (NodeId u = 1; u < numNodes; ++u) {
    if (!state.origins[u].isBottom()) {
      pushNode(u);
    }
  }

  while (!worklist.empty()) {
    NodeId u = worklist.back();
    worklist.pop_back();
    inWorklist[u] = false;

    Origin uOrigin = state.origins[u];
    for (NodeId i = outOffsets[u], end = outOffsets[u + 1]; i < end; ++i) {
      NodeId v = outTargets[i];
      if (state.originLattice.join(state.origins[v], uOrigin)) {
        pushNode(v);
      }
    }

    // Node u may be the ref or desc input to one or more casts. Re-evaluate
    // those casts now that u's origin has been refined so any newly reachable
    // or widened cast result propagates to site.outNode.
    if (!nodeCasts.empty()) {
      for (Index castIdx : nodeCasts[u]) {
        const auto& site = state.castSites[castIdx];
        const auto& refOrigin = state.origins[site.refNode];
        if (refOrigin.isBottom()) {
          continue;
        }
        if (site.descNode != InvalidNode &&
            state.origins[site.descNode].isBottom()) {
          continue;
        }
        Origin out = state.originLattice.getBottom();
        if (refOrigin.isTop()) {
          out = state.originLattice.getTop();
        } else if (const auto* alloc = refOrigin.getVal()) {
          if (Type::isSubType(state.allocs[*alloc].type, site.expr->type)) {
            // Every subtype of a type with a descriptor also has a descriptor
            // (and a StructNew of that type must supply one).
            assert(!site.expr->desc ||
                   state.allocs[*alloc].descHeapType.has_value());
            out = state.originLattice.get(*alloc);
          }
        }
        if (state.originLattice.join(state.origins[site.outNode], out)) {
          pushNode(site.outNode);
        }
      }
    }
  }
}

// Phase 3: Compute escaped allocations and return whether any remain
// unescaped and can be optimized.
bool computeEscapes(AnalysisState& state) {
  size_t numAllocs = state.allocs.size();
  // Conditional escape adjacency list: escapeAdj[u] lists replacement
  // allocations v that must escape if expected allocation u escapes in a
  // cmpxchg. Lazily allocated since candidate-to-candidate cmpxchg is rare.
  std::vector<std::vector<AllocId>> escapeAdj;
  std::vector<AllocId> worklist;

  auto addEscapeEdge = [&](AllocId from, AllocId to) {
    if (escapeAdj.empty()) {
      escapeAdj.resize(numAllocs);
    }
    escapeAdj[from].push_back(to);
  };

  auto markEscaped = [&](AllocId alloc) {
    if (!state.allocs[alloc].escaped) {
      state.allocs[alloc].escaped = true;
      worklist.push_back(alloc);
    }
  };

  for (const auto& site : state.cmpxchgSites) {
    const auto* repAlloc = state.origins[site.repNode].getVal();
    if (!repAlloc) {
      continue;
    }
    const auto& expOrigin = state.origins[site.expNode];
    if (expOrigin.isTop()) {
      // Expected may be an arbitrary heap reference that matches the stored
      // value at runtime, so replacement may be written to the heap.
      markEscaped(*repAlloc);
    } else if (const auto* expAlloc = expOrigin.getVal()) {
      // If expAlloc ends up escaping, expected remains a live heap reference
      // that could match the field at runtime and cause cmpxchg to write
      // replacement to the heap, so repAlloc must escape too. When expOrigin is
      // Bottom, expected never produces a value so cmpxchg never writes
      // replacement.
      if (*expAlloc != *repAlloc) {
        addEscapeEdge(*expAlloc, *repAlloc);
      }
    }
  }

  for (NodeId u : state.escapingNodes) {
    if (const auto* alloc = state.origins[u].getVal()) {
      markEscaped(*alloc);
    }
  }

  // Mixing check: if an allocation flows into an identity edge whose target
  // became Top (e.g. mixed with null or another allocation), mark it escaped.
  for (const auto& [u, v] : state.identityEdges) {
    if (const auto* alloc = state.origins[u].getVal()) {
      if (state.origins[v].isTop()) {
        markEscaped(*alloc);
      }
    }
  }

  if (!escapeAdj.empty()) {
    while (!worklist.empty()) {
      AllocId alloc = worklist.back();
      worklist.pop_back();
      for (AllocId dep : escapeAdj[alloc]) {
        markEscaped(dep);
      }
    }
  }

  for (const auto& info : state.allocs) {
    if (!info.escaped) {
      return true;
    }
  }
  return false;
}

// Phase 4: Rewrite all non-escaping allocations and their uses in one
// post-order walk. Allocates per-field and descriptor locals for each
// non-escaping allocation, lowers allocations to local sets returning a bottom
// ref.null, rewrites uses, and finishes with ReFinalize (which widens
// control-flow and br_if types to allow the ref.null values) and
// handleNonDefaultableLocals.
struct Optimizer : public PostWalker<Optimizer> {
  AnalysisState& state;
  Function* func;
  Module& wasm;
  Builder builder;

  Optimizer(AnalysisState& state, Function* func, Module& wasm)
    : state(state), func(func), wasm(wasm), builder(wasm) {}

  void optimize() {
    for (auto& info : state.allocs) {
      if (info.escaped) {
        continue;
      }
      info.fieldLocals.reserve(info.fields.size());
      for (const auto& field : info.fields) {
        info.fieldLocals.push_back(builder.addVar(func, field.type));
      }
      if (info.descHeapType) {
        info.descLocal = builder.addVar(func, info.getDescLocalType());
      }
    }

    walk(func->body);

    ReFinalize().walkFunctionInModule(func, &wasm);
    TypeUpdating::handleNonDefaultableLocals(func, wasm);
  }

  Expression* replaceCurrent(Expression* rep) {
    // Preserve the old expression's dataflow node on its replacement so
    // ancestor visitors later in the post-order walk still see the same origin
    // for values flowing out of rewritten subexpressions.
    if (auto it = state.exprNodes.find(getCurrent());
        it != state.exprNodes.end()) {
      NodeId node = it->second;
      state.exprNodes[rep] = node;
    }
    return PostWalker<Optimizer>::replaceCurrent(rep);
  }

  std::optional<AllocId> getOptimizedAlloc(Expression* curr) {
    auto it = state.exprNodes.find(curr);
    if (it == state.exprNodes.end()) {
      return std::nullopt;
    }
    if (const auto* alloc = state.origins[it->second].getVal()) {
      if (!state.allocs[*alloc].escaped) {
        return *alloc;
      }
    }
    return std::nullopt;
  }

  // Returns true when `curr` is either a non-escaping allocation (which can
  // never reside in a heap field or element) or has Bottom origin (dynamically
  // unreachable, so a consuming cmpxchg never executes).
  bool cannotMatchHeap(Expression* curr) {
    if (getOptimizedAlloc(curr)) {
      return true;
    }
    auto it = state.exprNodes.find(curr);
    return it != state.exprNodes.end() && state.origins[it->second].isBottom();
  }

  std::optional<AllocId> getOptimizedCandidate(Expression* curr) {
    auto it = state.allocIds.find(curr);
    if (it == state.allocIds.end() || state.allocs[it->second].escaped) {
      return std::nullopt;
    }
    return it->second;
  }

  Expression* makeOptimizedNull(AllocId alloc) {
    return builder.makeRefNull(
      state.allocs[alloc].type.getHeapType().getBottom());
  }

  void visitLocalSet(LocalSet* curr) {
    if (getOptimizedAlloc(curr->value)) {
      if (curr->isTee()) {
        replaceCurrent(curr->value);
      } else {
        assert(curr->type == Type::none);
        replaceCurrent(builder.makeDrop(curr->value));
      }
    }
  }

  void visitLocalGet(LocalGet* curr) {
    if (auto alloc = getOptimizedAlloc(curr)) {
      assert(curr->type != Type::unreachable);
      replaceCurrent(makeOptimizedNull(*alloc));
    }
  }

  void visitStructNew(StructNew* curr) {
    auto alloc = getOptimizedCandidate(curr);
    if (!alloc) {
      return;
    }
    const auto& info = state.allocs[*alloc];
    SmallVector<Expression*, 8> contents;
    SmallVector<Index, 8> tempIndexes;

    // Evaluate all operands and the descriptor into fresh temporary locals
    // before writing the allocation's field/descriptor locals, so earlier
    // reads or traps in later operands (e.g. inside a loop iteration) observe
    // the previous instance's state intact.
    if (!curr->isWithDefault()) {
      tempIndexes.reserve(info.fields.size());
      for (Index i = 0; i < info.fields.size(); ++i) {
        Index temp = builder.addVar(func, info.fields[i].type);
        tempIndexes.push_back(temp);
        contents.push_back(builder.makeLocalSet(temp, curr->operands[i]));
      }
    }
    std::optional<Index> tempDesc;
    if (curr->desc) {
      Type descLocalType = info.getDescLocalType();
      tempDesc = builder.addVar(func, descLocalType);
      Expression* desc = curr->desc;
      if (desc->type.isNullableRef()) {
        desc = builder.makeRefAs(RefAsNonNull, desc);
      }
      contents.push_back(builder.makeLocalSet(*tempDesc, desc));
    }

    for (Index i = 0; i < info.fields.size(); ++i) {
      Expression* val =
        curr->isWithDefault()
          ? builder.makeConstantExpression(
              Literal::makeZero(info.fields[i].type))
          : builder.makeLocalGet(tempIndexes[i], info.fields[i].type);
      contents.push_back(builder.makeLocalSet(info.fieldLocals[i], val));
    }
    if (curr->desc) {
      contents.push_back(builder.makeLocalSet(
        *info.descLocal,
        builder.makeLocalGet(*tempDesc, info.getDescLocalType())));
    }
    contents.push_back(makeOptimizedNull(*alloc));
    replaceCurrent(builder.makeBlock(contents));
  }

  void visitArrayNew(ArrayNew* curr) {
    auto alloc = getOptimizedCandidate(curr);
    if (!alloc) {
      return;
    }
    const auto& info = state.allocs[*alloc];
    Type elemType = curr->type.getHeapType().getArray().element.type;

    if (curr->isWithDefault()) {
      SmallVector<Expression*, 8> contents;
      for (Index local : info.fieldLocals) {
        contents.push_back(builder.makeLocalSet(
          local, builder.makeConstantExpression(Literal::makeZero(elemType))));
      }
      contents.push_back(makeOptimizedNull(*alloc));
      replaceCurrent(builder.makeBlock(contents));
      return;
    }

    if (info.fields.empty()) {
      replaceCurrent(builder.makeSequence(builder.makeDrop(curr->init),
                                          makeOptimizedNull(*alloc)));
      return;
    }

    // Store curr->init into a temp once so it executes once and before any
    // element local is overwritten.
    Index initTemp = builder.addVar(func, elemType);
    SmallVector<Expression*, 8> contents;
    contents.push_back(builder.makeLocalSet(initTemp, curr->init));
    for (Index local : info.fieldLocals) {
      contents.push_back(
        builder.makeLocalSet(local, builder.makeLocalGet(initTemp, elemType)));
    }
    contents.push_back(makeOptimizedNull(*alloc));
    replaceCurrent(builder.makeBlock(contents));
  }

  void visitArrayNewFixed(ArrayNewFixed* curr) {
    auto alloc = getOptimizedCandidate(curr);
    if (!alloc) {
      return;
    }
    const auto& info = state.allocs[*alloc];
    Type elemType = curr->type.getHeapType().getArray().element.type;
    SmallVector<Index, 8> tempIndexes;
    SmallVector<Expression*, 8> contents;
    tempIndexes.reserve(info.fields.size());

    // Evaluate all element operands into temps before overwriting element
    // locals so earlier values remain intact if a later operand traps or reads
    // them.
    for (Index i = 0; i < info.fields.size(); ++i) {
      Index temp = builder.addVar(func, elemType);
      tempIndexes.push_back(temp);
      contents.push_back(builder.makeLocalSet(temp, curr->values[i]));
    }
    for (Index i = 0; i < info.fields.size(); ++i) {
      contents.push_back(builder.makeLocalSet(
        info.fieldLocals[i], builder.makeLocalGet(tempIndexes[i], elemType)));
    }
    contents.push_back(makeOptimizedNull(*alloc));
    replaceCurrent(builder.makeBlock(contents));
  }

  void visitRefAs(RefAs* curr) {
    if (curr->op == RefAsNonNull && getOptimizedAlloc(curr->value)) {
      assert(curr->type != Type::unreachable);
      replaceCurrent(curr->value);
    }
  }

  void visitRefIsNull(RefIsNull* curr) {
    if (getOptimizedAlloc(curr->value)) {
      assert(curr->type != Type::unreachable);
      replaceCurrent(builder.makeSequence(builder.makeDrop(curr->value),
                                          builder.makeConst(int32_t(0))));
    }
  }

  void visitRefEq(RefEq* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    auto lhsAlloc = getOptimizedAlloc(curr->left);
    auto rhsAlloc = getOptimizedAlloc(curr->right);
    if (lhsAlloc || rhsAlloc) {
      bool same = lhsAlloc && rhsAlloc && *lhsAlloc == *rhsAlloc;
      replaceCurrent(builder.makeBlock({builder.makeDrop(curr->left),
                                        builder.makeDrop(curr->right),
                                        builder.makeConst(int32_t(same))}));
    }
  }

  void visitRefTest(RefTest* curr) {
    if (auto alloc = getOptimizedAlloc(curr->ref)) {
      assert(curr->type != Type::unreachable);
      int32_t res = Type::isSubType(state.allocs[*alloc].type, curr->castType);
      replaceCurrent(builder.makeSequence(builder.makeDrop(curr->ref),
                                          builder.makeConst(res)));
    }
  }

  void visitRefCast(RefCast* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    auto refAlloc = getOptimizedAlloc(curr->ref);
    if (!curr->desc) {
      if (refAlloc) {
        if (Type::isSubType(state.allocs[*refAlloc].type, curr->type)) {
          replaceCurrent(curr->ref);
        } else {
          replaceCurrent(builder.makeSequence(builder.makeDrop(curr->ref),
                                              builder.makeUnreachable()));
        }
      }
      return;
    }

    auto descAlloc = getOptimizedAlloc(curr->desc);
    if (!refAlloc && !descAlloc) {
      return;
    }

    auto descTrap = [&]() {
      replaceCurrent(builder.makeBlock({builder.makeDrop(curr->ref),
                                        builder.makeDrop(curr->desc),
                                        builder.makeUnreachable()}));
    };

    if (!refAlloc) {
      // `desc` is an optimized allocation, so no non-null ref can share it.
      if (curr->type.isNullableRef() && curr->ref->type != Type::unreachable) {
        // Stash `ref` in a scratch local before evaluating `desc` to preserve
        // operand evaluation order while keeping only a null check on `ref`.
        Type refType = curr->ref->type;
        Index scratch = builder.addVar(func, refType);
        replaceCurrent(
          builder.makeBlock({builder.makeLocalSet(scratch, curr->ref),
                             builder.makeDrop(curr->desc),
                             curr}));
        curr->desc = nullptr;
        curr->type = curr->type.with(curr->type.getHeapType().getBottom());
        curr->ref = builder.makeLocalGet(scratch, refType);
      } else {
        descTrap();
      }
      return;
    }

    // `ref` is an optimized non-escaping allocation and `curr->desc` is
    // present: if `desc` is also an optimized allocation (so they cannot share
    // an identity) or Phase 2 left the cast output Bot, the cast always traps.
    // Otherwise emit a runtime ref.eq against the allocation's stored
    // descriptor local.
    const auto& info = state.allocs[*refAlloc];
    auto outIt = state.exprNodes.find(curr);
    assert(outIt != state.exprNodes.end());
    if (descAlloc || state.origins[outIt->second].isBottom()) {
      descTrap();
      return;
    }
    assert(Type::isSubType(info.type, curr->type));
    assert(info.descHeapType.has_value());

    replaceCurrent(builder.makeSequence(
      builder.makeDrop(curr->ref),
      builder.makeIf(
        builder.makeRefEq(
          curr->desc,
          builder.makeLocalGet(*info.descLocal, info.getDescLocalType())),
        makeOptimizedNull(*refAlloc),
        builder.makeUnreachable())));
  }

  void visitRefGetDesc(RefGetDesc* curr) {
    if (auto alloc = getOptimizedAlloc(curr->ref)) {
      const auto& info = state.allocs[*alloc];
      assert(curr->type != Type::unreachable);
      assert(info.descLocal.has_value());
      replaceCurrent(builder.makeSequence(
        builder.makeDrop(curr->ref),
        builder.makeLocalGet(*info.descLocal, info.getDescLocalType())));
    }
  }

  void visitStructGet(StructGet* curr) {
    if (auto alloc = getOptimizedAlloc(curr->ref)) {
      assert(curr->type != Type::unreachable);
      const auto& info = state.allocs[*alloc];
      const auto& field = info.fields[curr->index];
      Expression* value =
        builder.makeLocalGet(info.fieldLocals[curr->index], field.type);
      value = Bits::makePackedFieldGet(value, field, curr->signed_, wasm);
      replaceCurrent(builder.makeSequence(builder.makeDrop(curr->ref), value));
    }
  }

  void visitStructSet(StructSet* curr) {
    if (auto alloc = getOptimizedAlloc(curr->ref)) {
      replaceCurrent(builder.makeSequence(
        builder.makeDrop(curr->ref),
        builder.makeLocalSet(state.allocs[*alloc].fieldLocals[curr->index],
                             curr->value)));
    }
  }

  void emitRMW(Expression* ref,
               Expression* value,
               AtomicRMWOp op,
               Index local,
               Type type) {
    // Capture `value` and the old field value in scratch locals to preserve
    // operand evaluation order and return the pre-RMW value.
    Index oldScratch = builder.addVar(func, type);
    Index valScratch = builder.addVar(func, type);
    Abstract::Op binop = Abstract::Add;
    Expression* newVal = nullptr;

    switch (op) {
      case RMWAdd:
        binop = Abstract::Add;
        break;
      case RMWSub:
        binop = Abstract::Sub;
        break;
      case RMWAnd:
        binop = Abstract::And;
        break;
      case RMWOr:
        binop = Abstract::Or;
        break;
      case RMWXor:
        binop = Abstract::Xor;
        break;
      case RMWXchg:
        newVal = builder.makeLocalGet(valScratch, type);
        break;
      default:
        WASM_UNREACHABLE("unexpected rmw op");
    }
    if (!newVal) {
      newVal = builder.makeBinary(Abstract::getBinary(type, binop),
                                  builder.makeLocalGet(local, type),
                                  builder.makeLocalGet(valScratch, type));
    }

    replaceCurrent(builder.makeBlock(
      {builder.makeDrop(ref),
       builder.makeLocalSet(valScratch, value),
       builder.makeLocalSet(oldScratch, builder.makeLocalGet(local, type)),
       builder.makeLocalSet(local, newVal),
       builder.makeLocalGet(oldScratch, type)}));
  }

  void visitStructRMW(StructRMW* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    if (auto alloc = getOptimizedAlloc(curr->ref)) {
      const auto& info = state.allocs[*alloc];
      [[maybe_unused]] const auto& field = info.fields[curr->index];
      assert(!field.isPacked());
      emitRMW(curr->ref,
              curr->value,
              curr->op,
              info.fieldLocals[curr->index],
              field.type);
    }
  }

  void emitOptimizedRefCmpxchg(Expression* ref,
                               Expression* expected,
                               Expression* replacement,
                               bool expCannotMatch,
                               Index local,
                               Type localType) {
    if (expCannotMatch) {
      // `expected` is non-escaping or dynamically unreachable, so the
      // comparison never succeeds.
      replaceCurrent(
        builder.makeBlock({builder.makeDrop(ref),
                           builder.makeDrop(expected),
                           builder.makeDrop(replacement),
                           builder.makeLocalGet(local, localType)}));
      return;
    }

    Type expectedType = localType;
    if (localType.isRef()) {
      expectedType = Type(
        HeapTypes::eq.getBasic(localType.getHeapType().getShared()), Nullable);
    }
    // Stash `expected`, `replacement`, and the pre-cmpxchg field value in
    // scratch locals so operand evaluation order is preserved if `replacement`
    // traps or reads/mutates `local`.
    Index oldScratch = builder.addVar(func, localType);
    Index expectedScratch = builder.addVar(func, expectedType);
    Index replacementScratch = builder.addVar(func, localType);

    Expression* pred =
      localType.isRef()
        ? static_cast<Expression*>(builder.makeRefEq(
            builder.makeLocalGet(local, localType),
            builder.makeLocalGet(expectedScratch, expectedType)))
        : builder.makeBinary(
            Abstract::getBinary(localType, Abstract::Eq),
            builder.makeLocalGet(local, localType),
            builder.makeLocalGet(expectedScratch, expectedType));

    replaceCurrent(builder.makeBlock(
      {builder.makeDrop(ref),
       builder.makeLocalSet(expectedScratch, expected),
       builder.makeLocalSet(replacementScratch, replacement),
       builder.makeLocalSet(oldScratch, builder.makeLocalGet(local, localType)),
       builder.makeIf(
         pred,
         builder.makeLocalSet(
           local, builder.makeLocalGet(replacementScratch, localType))),
       builder.makeLocalGet(oldScratch, localType)}));
  }

  void visitStructCmpxchg(StructCmpxchg* curr) {
    if (curr->type == Type::unreachable ||
        curr->ref->type == Type::unreachable) {
      return;
    }
    auto refAlloc = getOptimizedAlloc(curr->ref);
    bool expCannotMatch = cannotMatchHeap(curr->expected);
    if (refAlloc) {
      const auto& info = state.allocs[*refAlloc];
      assert(!info.fields[curr->index].isPacked());
      emitOptimizedRefCmpxchg(curr->ref,
                              curr->expected,
                              curr->replacement,
                              expCannotMatch,
                              info.fieldLocals[curr->index],
                              info.fields[curr->index].type);
      return;
    }
    if (!expCannotMatch) {
      return;
    }
    // `curr->ref` is unoptimized while `curr->expected` is a non-escaping
    // allocation or dynamically unreachable, so `expected` cannot match the
    // heap struct field. The comparison never succeeds, reducing the cmpxchg to
    // a plain struct.get after evaluating `ref`, `expected`, and `replacement`
    // in order (`refScratch` keeps `ref` evaluated before dropping `expected`
    // and `replacement`).
    Type refType = curr->ref->type.with(Nullable);
    Index refScratch = builder.addVar(func, refType);
    replaceCurrent(builder.makeBlock(
      {builder.makeLocalSet(refScratch, curr->ref),
       builder.makeDrop(curr->expected),
       builder.makeDrop(curr->replacement),
       builder.makeStructGet(curr->index,
                             builder.makeLocalGet(refScratch, refType),
                             curr->order,
                             curr->type)}));
  }

  void visitArrayGet(ArrayGet* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    if (auto alloc = getOptimizedAlloc(curr->ref)) {
      Index idx = curr->index->cast<Const>()->value.getUnsigned();
      const auto& info = state.allocs[*alloc];
      if (idx >= info.fields.size()) {
        replaceCurrent(builder.makeSequence(builder.makeDrop(curr->ref),
                                            builder.makeUnreachable()));
        return;
      }
      const auto& elem = info.fields[idx];
      Expression* value =
        builder.makeLocalGet(info.fieldLocals[idx], elem.type);
      value = Bits::makePackedFieldGet(value, elem, curr->signed_, wasm);
      replaceCurrent(builder.makeSequence(builder.makeDrop(curr->ref), value));
    }
  }

  void visitArraySet(ArraySet* curr) {
    if (auto alloc = getOptimizedAlloc(curr->ref)) {
      Index idx = curr->index->cast<Const>()->value.getUnsigned();
      const auto& info = state.allocs[*alloc];
      if (idx >= info.fields.size()) {
        replaceCurrent(builder.makeBlock({builder.makeDrop(curr->ref),
                                          builder.makeDrop(curr->value),
                                          builder.makeUnreachable()}));
        return;
      }
      replaceCurrent(builder.makeSequence(
        builder.makeDrop(curr->ref),
        builder.makeLocalSet(info.fieldLocals[idx], curr->value)));
    }
  }

  void visitArrayRMW(ArrayRMW* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    if (auto alloc = getOptimizedAlloc(curr->ref)) {
      Index idx = curr->index->cast<Const>()->value.getUnsigned();
      const auto& info = state.allocs[*alloc];
      if (idx >= info.fields.size()) {
        replaceCurrent(builder.makeBlock({builder.makeDrop(curr->ref),
                                          builder.makeDrop(curr->value),
                                          builder.makeUnreachable()}));
        return;
      }
      assert(!info.fields[idx].isPacked());
      emitRMW(curr->ref,
              curr->value,
              curr->op,
              info.fieldLocals[idx],
              info.fields[idx].type);
    }
  }

  void visitArrayCmpxchg(ArrayCmpxchg* curr) {
    if (curr->type == Type::unreachable ||
        curr->ref->type == Type::unreachable) {
      return;
    }
    auto refAlloc = getOptimizedAlloc(curr->ref);
    bool expCannotMatch = cannotMatchHeap(curr->expected);
    if (refAlloc) {
      Index idx = curr->index->cast<Const>()->value.getUnsigned();
      const auto& info = state.allocs[*refAlloc];
      if (idx >= info.fields.size()) {
        replaceCurrent(builder.makeBlock({builder.makeDrop(curr->ref),
                                          builder.makeDrop(curr->expected),
                                          builder.makeDrop(curr->replacement),
                                          builder.makeUnreachable()}));
        return;
      }
      assert(!info.fields[idx].isPacked());
      emitOptimizedRefCmpxchg(curr->ref,
                              curr->expected,
                              curr->replacement,
                              expCannotMatch,
                              info.fieldLocals[idx],
                              info.fields[idx].type);
      return;
    }
    if (!expCannotMatch) {
      return;
    }
    // `curr->ref` is unoptimized while `curr->expected` is a non-escaping
    // allocation or dynamically unreachable, so `expected` cannot match the
    // element in memory. Stash `ref` and `index` in scratch locals to preserve
    // evaluation order across the dropped `expected` and `replacement`, then
    // read the element directly.
    Type refType = curr->ref->type.with(Nullable);
    Index refScratch = builder.addVar(func, refType);
    Index indexScratch = builder.addVar(func, Type::i32);
    replaceCurrent(builder.makeBlock(
      {builder.makeLocalSet(refScratch, curr->ref),
       builder.makeLocalSet(indexScratch, curr->index),
       builder.makeDrop(curr->expected),
       builder.makeDrop(curr->replacement),
       builder.makeArrayGet(builder.makeLocalGet(refScratch, refType),
                            builder.makeLocalGet(indexScratch, Type::i32),
                            curr->order,
                            curr->type)}));
  }
};

struct Heap2Local2 : public WalkerPass<PostWalker<Heap2Local2>> {
  bool isFunctionParallel() override { return true; }

  // Optimizer updates non-nullable local uses right after optimizing.
  bool requiresNonNullableLocalFixups() override { return false; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<Heap2Local2>();
  }

  void doWalkFunction(Function* func) {
    Module& wasm = *getModule();
    if (!wasm.features.hasGC()) {
      return;
    }
    CandidateFinder finder;
    finder.walk(func->body);
    if (!finder.found) {
      return;
    }
    AnalysisState state;
    GraphBuilder(state, func, wasm).build();
    computeOrigins(state);
    if (!computeEscapes(state)) {
      return;
    }
    Optimizer(state, func, wasm).optimize();
  }
};

} // anonymous namespace

Pass* createHeap2Local2Pass() { return new Heap2Local2(); }

} // namespace wasm
