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
// allocations alongside identity edges and escaping uses.
//
// Phase 2 solves a smallest fixed point over Flat<AllocId> origins (i.e. the
// flat lattice of all allocation sites) across all candidate allocations
// simultaneously:
//   - Top: unknown / nullable / multiple merged allocations.
//   - Val(a): definitely non-null reference to a single allocation `a`.
//   - Bot: unreachable.
//
// Phase 3 marks allocations escaped from escaping uses and identity-edge mixes
// (Val(a) flowing into Top).
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

// Lattice of origins used in Phase 2 origin analysis.
using OriginLattice = analysis::Flat<AllocId>;
using Origin = OriginLattice::Element;

// Metadata and lowered local variable assignments for a candidate allocation
// (either a struct.new* or array.new*).
struct AllocInfo {
  Expression* expr = nullptr;
  FieldList fields;
  bool escaped = false;

  // Populated before Phase 4 if we can optimize this allocation.
  std::vector<Index> fieldLocals;
  std::optional<Index> descLocal;

  std::optional<HeapType> getDescHeapType() const {
    return expr->type.getHeapType().getDescriptorType();
  }

  Type getDescLocalType() const {
    auto descHeapType = getDescHeapType();
    assert(descHeapType.has_value());
    return Type(*descHeapType, NonNullable, Exact);
  }
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
  // Maps tracked reference-typed expressions to their dataflow NodeId.
  std::unordered_map<Expression*, NodeId> exprNodes;
  // Current lattice value for each dataflow node, indexed by NodeId.
  std::vector<Origin> origins;
  // Directed edges (from, to) along which reference values flow unchanged.
  std::vector<std::pair<NodeId, NodeId>> identityEdges;
  // Nodes whose values flow into contexts that escape the function or alias
  // heap memory.
  std::vector<NodeId> escapingNodes;

  AnalysisState() {
    // Node 0 (TopNode) is a shared sentinel node with fixed origin Top
    // representing expressions absent from exprNodes that can never produce a
    // candidate allocation (e.g. call, global.get, struct.get, or ref.null).
    origins.push_back(originLattice.getTop());
  }

  NodeId getNode(Expression* curr) {
    assert(curr);
    assert(curr->type.isRef());
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

  void join(Expression* curr, Origin val) {
    originLattice.join(origins[getNode(curr)], val);
  }

  void joinTop(Expression* curr) { join(curr, originLattice.getTop()); }

  void addIdentityEdge(NodeId fromNode, NodeId toNode) {
    if (fromNode == TopNode) {
      originLattice.join(origins[toNode], originLattice.getTop());
    } else {
      identityEdges.emplace_back(fromNode, toNode);
    }
  }

  void addIdentityEdge(Expression* from, NodeId toNode) {
    // Since we are building up the graph via a post-order traversal, we will
    // have visited a child node (i.e. `from`) before its parent (i.e.
    // `toNode`). If the child is not already in the graph, then it must be
    // something we can't analyze, so we represent it as Top.
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

// Phase 1: Single post-order walk over the function body to collect candidate
// allocations, dataflow edges, and escaping uses.
struct GraphBuilder
  : public ControlFlowWalker<GraphBuilder,
                             UnifiedExpressionVisitor<GraphBuilder>> {
  AnalysisState& state;
  Function* func;
  Module& wasm;
  // Reference-typed local.gets collected during the walk to connect to their
  // reaching local.sets in build().
  std::vector<LocalGet*> refLocalGets;

  GraphBuilder(AnalysisState& state, Function* func, Module& wasm)
    : state(state), func(func), wasm(wasm) {}

  void build() {
    walk(func->body);

    if (state.allocs.empty()) {
      // Nothing to optimize.
      return;
    }

    // Values returned out of the function body escape.
    state.escapeIfRef(func->body);

    // Connect local.gets to reaching local.sets via LazyLocalGraph.
    LazyLocalGraph localGraph(func, &wasm);
    for (auto* get : refLocalGets) {
      for (LocalSet* set : localGraph.getSets(get)) {
        if (!set) {
          // Reading entry/default local value violates the single-live-instance
          // invariant (e.g. a value from an earlier loop iteration or param).
          state.joinTop(get);
        } else {
          assert(set->value->type.isRef() && "unexpected unreachable set");
          state.addIdentityEdge(set->value, get);
        }
      }
    }
  }

  void visitExpression(Expression* curr) {
    // Default to assuming all reference-typed children escape.
    for (auto* child : ChildIterator(curr)) {
      state.escapeIfRef(child);
    }
    // Unhandled scope-branching instructions (e.g. TryTable, BrOn) can send
    // values to enclosing ref-typed Blocks. Initialize those target Blocks with
    // Top so any candidate allocations flowing into them are treated as
    // escaping.
    // TODO: Model BrOn* and TryTable dataflow edges directly instead of
    // conservatively initializing target blocks with Top.
    BranchUtils::operateOnScopeNameUsesAndSentTypes(
      curr, [&](Name& name, Type sentType) {
        if (sentType.isRef()) {
          auto* target = findBreakTarget(name);
          assert(target);
          assert(target->type.isRef());
          state.joinTop(target);
        }
      });
  }

  AllocId addCandidateAlloc(Expression* curr, const FieldList& fields) {
    assert(state.allocs.size() < std::numeric_limits<AllocId>::max());
    auto id = AllocId(state.allocs.size());
    auto& info = state.allocs.emplace_back();
    info.expr = curr;
    info.fields.assign(fields.begin(), fields.end());
    state.join(curr, state.originLattice.get(id));
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
      assert(!curr->desc || curr->desc->type.isRef());
      addCandidateAlloc(curr, curr->type.getHeapType().getStruct().fields);
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
    // In Binaryen IR, a local.tee is a LocalSet whose expression type is
    // the local's type rather than Type::none. Its write to the local is
    // wired to reaching local.gets via LazyLocalGraph in build(), while its
    // fallthrough value flows to its parent expression via this identity
    // edge.
    if (curr->isTee() && curr->value->type.isRef()) {
      state.addIdentityEdge(curr->value, curr);
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
};

// Phase 2: Solve smallest fixed point over Flat<AllocId> origins to find which
// allocation each Expression's value comes from (possibly none or many).
void computeOrigins(AnalysisState& state) {
  size_t numNodes = state.origins.size();
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

  // Skip sink nodes that have no outgoing identity edges to propagate into.
  std::vector<bool> inWorklist(numNodes, false);
  std::vector<NodeId> worklist;
  auto pushNode = [&](NodeId u) {
    if (outOffsets[u] != outOffsets[u + 1]) {
      if (!inWorklist[u]) {
        inWorklist[u] = true;
        worklist.push_back(u);
      }
    }
  };

  // Start at node 1 because TopNode (0) never has outgoing edges.
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
  }
}

// Phase 3: Compute escaped allocations and return whether any remain unescaped
// and can be optimized. Return true if we find something to optimize.
bool computeEscapes(AnalysisState& state) {
  for (NodeId u : state.escapingNodes) {
    if (const auto* alloc = state.origins[u].getVal()) {
      state.allocs[*alloc].escaped = true;
    }
  }

  // Mixing check: if an allocation flows into an identity edge whose target
  // became Top (e.g. mixed with null or another allocation), mark it escaped.
  for (const auto& [u, v] : state.identityEdges) {
    if (const auto* alloc = state.origins[u].getVal()) {
      if (state.origins[v].isTop()) {
        state.allocs[*alloc].escaped = true;
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
// post-order walk.
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
      // We will optimize this allocation. Create locals for its fields and
      // descriptor.
      info.fieldLocals.reserve(info.fields.size());
      for (const auto& field : info.fields) {
        info.fieldLocals.push_back(builder.addVar(func, field.type));
      }
      if (info.getDescHeapType()) {
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

  // If `curr` evaluates exclusively to a single non-escaping candidate
  // allocation, return its ID; otherwise return nullopt.
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

  // Create the null value with which we will replace an optimized allocation.
  Expression* makeOptimizedNull(AllocId alloc) {
    return builder.makeRefNull(
      state.allocs[alloc].expr->type.getHeapType().getBottom());
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
    auto alloc = getOptimizedAlloc(curr);
    if (!alloc) {
      return;
    }
    const auto& info = state.allocs[*alloc];
    assert(info.expr == curr);
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
    auto alloc = getOptimizedAlloc(curr);
    if (!alloc) {
      return;
    }
    const auto& info = state.allocs[*alloc];
    assert(info.expr == curr);
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
    auto alloc = getOptimizedAlloc(curr);
    if (!alloc) {
      return;
    }
    const auto& info = state.allocs[*alloc];
    assert(info.expr == curr);
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
      int32_t res =
        Type::isSubType(state.allocs[*alloc].expr->type, curr->castType);
      replaceCurrent(builder.makeSequence(builder.makeDrop(curr->ref),
                                          builder.makeConst(res)));
    }
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
    AnalysisState state;
    GraphBuilder(state, func, wasm).build();
    if (state.allocs.empty()) {
      // Nothing to do.
      return;
    }
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
