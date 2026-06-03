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
// Finds ranges of values for locals, and uses them. For example:
//
//  if (x > 10) {
//    assert(x > 0); // redundant and can be removed.
//  }
//
// TODO: Compare locals, inferring that x <= y in some range (necessary for
//       software bounds check removal.
// TODO: Look not just at integers but also references
//

#include <variant>

#include "cfg/cfg-traversal.h"
#include "ir/local-graph.h"
#include "ir/properties.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "support/utilities.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

struct Unknown : public std::monostate {};

// In each range of values, one of the values. This can be either a literal like
// i32(0), or a local index (i.e., a reference to another local, showing that
// this one is related to them somehow: one of ==, <, >=, etc.), or something
// unknown.
using Value = std::variant<Literal, Index, Unknown>;

// A range of values, [min, max] (inclusive).
// TODO: support more clever things like unions
struct Span {
  Value min = Unknown;
  Value max = Unknown;

  bool isUnknown() { return min == Unknown && max == Unknown; }

  static Span unknown() { return Span{Unknown, Unknown}; }
};

// The span of values we inferred for locals. In the code below, we consider
// missing indexes to have no known span for them (i.e., we do not need to write
// an Unknown, and can just leave them empty).
using LocalSpans = std::unordered_map<Index, Span>;

// In each basic block we will store the relevant operations, which are all
// local gets and sets, branches, and uses of them.
struct Info {
  std::vector<Expression**> actions; // XXX just *?

  // We track them local spans at
  // the start and at the end of the block (for the values in the middle, we
  // need to traverse the actions and see how they are modified).
  // XXX do we need both?
  LocalSpans localSpansStart, localSpansEnd;
};

struct RangeAnalysis
  : public WalkerPass<
      CFGWalker<RangeAnalysis, Info>> {
  bool isFunctionParallel() override { return true; }

  // Locals are not modified here.
  bool requiresNonNullableLocalFixups() override { return false; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<RangeAnalysis>();
  }

  using Super = WalkerPass<CFGWalker<RangeAnalysis, Info>>;

  // Branches outside of the function can be ignored, as we only look at local
  // state in the function.
  bool ignoreBranchesOutsideOfFunc = true;

  // Store the actions we care about.
  void addAction() {
    if (currBasicBlock) {
      currBasicBlock->contents.actions.push_back(getCurrentPointer());
    }
  }

  void visitLocalGet(LocalGet* curr) { addAction(); } // XXX needed?
  void visitLocalSet(LocalSet* curr) { addAction(); }
  void visitUnary(Unary* curr) { addAction(); }
  void visitBinary(Binary* curr) { addAction(); }

  // Track the branches we reason about. CFGWalker builds a CFG, and we want to
  // add information on top of that about which branch is due to which
  // instruction. For example, if block A branches to B and C, we want to know
  // if A ends in a br_if, so we can apply its condition to the branches to B
  // (if the condition is true) and C (if false).

  // Maps each branching instruction to the basic block right before the
  // branchings. For example, for an If, this is the block that branches to the
  // ifTrue and ifFalse blocks.
  std::unordered_map<If*, BasicBlock*> brancherBlocks;

  static void doStartIfTrue(SubType* self, Expression** currp) {
    // We are right after the condition, so we are in the block before the If's
    // branching.
    self->brancherBlocks[*currp] = self->currBasicBlock;

    Super::doStartIfTrue(self, currp);
  }

#if 0
  static void doEndBranch(SubType* self, Expression** currp) {
    // We are right after the condition, so we are in the block before the If's
    // branching.
    XXX maybe leave for laterself->brancherBlocks[*currp] = self->currBasicBlock;
    Super::doEndBranch(self, currp);
  }
#endif

  // We start with the relevant locals, i.e. which we could optimize: for
  // example, if we see (i32.eqz (local.get $x)) then we know that information
  // about $x might resolve the eqz, and we compute it and things related to
  // it.
  std::unordered_set<Index> relevantLocals;

  void visitFunction(Function* curr) {
    // Now that the walk is complete and we have a CFG, find things to optimize.

    auto maybeAdd = [&](Expression* value) {
      // Given a value flowing into something we can optimize, see if there is a
      // local there, and if so, mark it as relevant.
      // TODO: handle tee
      // TODO: handle fallthrough values
      if (auto* get = value->dynCast<LocalGet>()) {
        relevantLocals.insert(get->index);
      }
    };

    for (auto& block : basicBlocks) {
      for (auto** currp : block->contents.actions) {
        auto* curr = *currp;
        // TODO: specific unary/binary ops
        if (auto* unary = curr->dynCast<Unary>()) {
          maybeAdd(unary->value);
        } else if (auto* binary = curr->dynCast<Binary>()) {
          maybeAdd(binary->left);
          maybeAdd(binary->right);
        }
      }
    }

    // Values can flow between locals: if x is relevant, and y is written to it,
    // we must consider y relevant too. TODO?

    if (!relevantLocals.empty()) {
      flow();
      optimize();
    }
  }

  // Flow spans around until we have inferred all we can about the ranges of
  // values in each location.
  void flow() {
    // Start from all the blocks, and keep going while we find something new.
    UniqueDeferredQueue<BasicBlock*> work;
    for (auto& block : basicBlocks) {
      work.push(block.get());
    }
    while (!work.empty()) {
      auto* block = work.pop();

      // Merge incoming data.
      LocalSpans localSpans = mergeIncoming(block);

      // Go through the block, applying things.
      for (auto** currp : block->contents.actions) {
        auto* curr = *currp;
        if (auto* set = curr->dynCast<LocalSet>()) {
          if (relevantLocals.contains(set->index)) {
            Value value;
            // TODO: fallthrough, tee chains, etc. For that we must track values
            // by Expression*, as e.g. reading a local, then setting it, should
            // read the original flowing value.
            if (auto* get = set->value->dynCast<LocalGet>()) {
              value = get->index;
            } else if (auto* c = set->value->dynCast<Const>()) {
              value = c->value;
            } else {
              // Nothing is known.
              localSpans.erase(set->index);
              continue;
            }
            // Both the min and max are equal to what we found.
            localSpans[set->index] = Span{value, value};
          }
        }
      }

      // We now know the values at the end of the block. If something changed,
      // flow it onward.
      if (localSpans != block->localSpansEnd) {
        block->localSpansEnd = std::move(localSpans);
        for (auto* out : block->out) {
          work.push(out);
        }
      }
    }
  }

  // After inferring all we can, apply it to optimize the code.
  void optimize() {
    struct Optimizer : public PostWalker<Optimizer> {
      RangeAnalysis& parent;

      Optimizer(RangeAnalysis& parent) : parent(parent) {}

      void visitBinary(Binary* curr) {
      }
    } optimizer(*this);
    optimizer.walk(getFunction());
  }

  // Merge incoming data to a block, by looking at the data arriving from each
  // of the predecessor blocks.
  LocalSpans mergeIncoming(BasicBlock* block) {
    LocalSpans localSpans;
    // For each relevant local, merge its spans.
    for (auto local : relevantLocals) {
      Span mergedSpan;
      for (auto* pred : block->in) {
        auto span = getSpanFromPredToSucc(pred, block, local);
        if (span.isUnknown()) {
          // Unknown, so the entire merge is unknown.
          mergedSpan = Span::unknown();
          break;
        }
        if (mergedSpan.isUnknown()) {
          // This is the first item. Copy it.
          mergedSpan = span;
        } else {
          // Merge in new data alongside existing.
          mergedSpan = merge(mergedSpan, span);
        }
      }
    }
  }

  // Given a source (predecessor) and a target (successor) block, find the span
  // of a particular local as it arrives to that target from that successor.
  Span getSpanFromPredToSucc(BasicBlock* pred, BasicBlock* block, Index local) {
    auto iter = pred->localSpansEnd.find(local);
    if (iter == pred->localSpansEnd.end()) {
      return Span::unknown();
    }

    ..
  }

  enum MinMax { Min, Max };

  // Merge two spans. This is a merge of two spans from two different
  // predecessor blocks, so the result is a span large enough to contain them
  // both, as all values in either one are possible.
  //
  // Note that this is a monotonic operation, to avoid infinite loops.
  Span merge(Span a, Span b) {
    return Span{merge(a.min, b.min, Min), merge(a.max, b.max, Max)};
  }

//using Value = std::variant<Literal, Index, Unknown>;
  Value merge(Value a, Value b, MinMax op) {
    Value ret;
    std::visit(overloaded{
      [&](Literal& lit1) {
        std::visit(overloaded{
          [&](Literal& lit2) {
            if (lit1 == lit2) {
              // Equal literals.
              ret = lit1;
            } else if (lit1.type.isNumber()) {
              // Numbers can be ordered.
              assert(lit2.type == lit1.type);
              if (lit1.le(lit2)) {
                ret = (op == Min) ? lit1 : lit2;
              } else {
                ret = (op == Min) ? lit2 : lit1;
              }
            } else {
              // Anything else (function reference, etc.) is unknown.
              ret = Span::unknown();
            }
          },
          [&](Index& local2) {
            // Mix of literal and local. We don't know what to make of this.
            // TODO: consider trees of constraints and using a solver
            ret = Span::unknown();
          },
          [&](Unknown& unknown2) {
            ret = unknown;
          },
        }, b);
      },
      [&](Index& local1) {
        std::visit(overloaded{
          [&](Literal& lit2) {
            // Mix of literal and local, as above.
            ret = Span::unknown();
          },
          [&](Index& local2) {
            // Two locals. If equal, we know the outcome.
            ret = (local1 == local2) ? local1 : Span::unknown();
          },
          [&](Unknown& unknown2) {
            ret = unknown;
          },
        }, b);
      },
      [&](Unknown& unknown1) {
        // It doesn't even matter what b is.
        ret = unknown;
      },
    }, a);
    return ret;
  }

  /*
  // A local graph that is constructed the first time we need it.
  std::optional<LazyLocalGraph> localGraph;
      if (!localGraph) {
      localGraph.emplace(getFunction(), getModule(), StructSet::SpecificId);
    }
*/
};

} // anonymous namespace

Pass* createRangeAnalysisPass() { return new RangeAnalysis(); }

} // namespace wasm
