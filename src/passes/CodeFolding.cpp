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

//
// Folds duplicate code together, saving space (and possibly phis in
// the wasm VM, which can save time).
//
// We fold tails of code where they merge and moving the code
// to the merge point is helpful. There are two cases here: (1) expressions,
// in which we merge to right after the expression itself, in these cases:
//  * blocks, we merge the fallthrough + the breaks
//  * if-else, we merge the arms
// and (2) the function body as a whole, in which we can merge returns or
// unreachables, putting the merged code at the end of the function body.
//
// For example, with an if-else, we might merge this:
//  (if (condition)
//    (block
//      A
//      C
//    )
//    (block
//      B
//      C
//    )
//  )
// to
//  (if (condition)
//    (block
//      A
//    )
//    (block
//      B
//    )
//  )
//  C
//
// Note that the merged code, C in the example above, can be anything,
// including code with control flow. If C is identical in all the locations,
// then it must be safe to merge (if it contains a branch to something
// higher up, then since our branch target names are unique, it must be
// to the same thing, and after merging it can still reach it).
//

#include <iterator>

#include "ir/branch-utils.h"
#include "ir/effects.h"
#include "ir/eh-utils.h"
#include "ir/find_all.h"
#include "ir/label-utils.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

static const Index WORTH_ADDING_BLOCK_TO_REMOVE_THIS_MUCH = 3;

struct ExpressionMarker
  : public PostWalker<ExpressionMarker,
                      UnifiedExpressionVisitor<ExpressionMarker>> {
  std::set<Expression*>& marked;

  ExpressionMarker(std::set<Expression*>& marked, Expression* expr)
    : marked(marked) {
    walk(expr);
  }

  void visitExpression(Expression* expr) { marked.insert(expr); }
};

struct CodeFolding : public WalkerPass<ControlFlowWalker<CodeFolding>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<CodeFolding>();
  }

  // information about a "tail" - code that reaches a point that we can
  // merge (e.g., a branch and some code leading up to it)
  struct Tail {
    Expression* expr; // nullptr if this is a fallthrough
    Block* block; // the enclosing block of code we hope to merge at its tail
    Expression** pointer; // for an expr with no parent block, the location it
                          // is at, so we can replace it

    // For a fallthrough
    Tail(Block* block) : expr(nullptr), block(block), pointer(nullptr) {}
    // For a break
    Tail(Expression* expr, Block* block)
      : expr(expr), block(block), pointer(nullptr) {
      validate();
    }
    Tail(Expression* expr, Expression** pointer)
      : expr(expr), block(nullptr), pointer(pointer) {}

    bool isFallthrough() const { return expr == nullptr; }

    void validate() const {
      if (expr && block) {
        assert(block->list.back() == expr);
      }
    }
  };

  // state

  // Set when we optimized and believe another pass is warranted.
  bool anotherPass;
  // Set when we optimized in a manner that requires EH fixups specifically,
  // which is generally the case when we wrap things in a block.
  bool needEHFixups;

  // pass state

  std::map<Name, std::vector<Tail>> breakTails; // break target name => tails
                                                // that reach it
  std::vector<Tail> unreachableTails; // tails leading to (unreachable)
  std::vector<Tail> returnTails;      // tails leading to (return)
  std::set<Name> unoptimizables;      // break target names that we can't handle
  std::set<Expression*> modifieds;    // modified code should not be processed
                                      // again, wait for next pass

  // walking

  void visitBreak(Break* curr) {
    if (curr->condition || curr->value) {
      unoptimizables.insert(curr->name);
    } else {
      // we can only optimize if we are at the end of the parent block,
      // and if the parent block does not return a value (we can't move
      // elements out of it if there is a value being returned)
      Block* parent = controlFlowStack.back()->dynCast<Block>();
      if (parent && curr == parent->list.back() &&
          !parent->list.back()->type.isConcrete()) {
        breakTails[curr->name].push_back(Tail(curr, parent));
      } else {
        unoptimizables.insert(curr->name);
      }
    }
  }

  void visitSwitch(Switch* curr) {
    for (auto target : curr->targets) {
      unoptimizables.insert(target);
    }
    unoptimizables.insert(curr->default_);
  }

  void visitUnreachable(Unreachable* curr) {
    // we can only optimize if we are at the end of the parent block
    if (!controlFlowStack.empty()) {
      Block* parent = controlFlowStack.back()->dynCast<Block>();
      if (parent && curr == parent->list.back()) {
        unreachableTails.push_back(Tail(curr, parent));
      }
    }
  }

  void handleReturn(Expression* curr) {
    if (!controlFlowStack.empty()) {
      // we can easily optimize if we are at the end of the parent block
      Block* parent = controlFlowStack.back()->dynCast<Block>();
      if (parent && curr == parent->list.back()) {
        returnTails.push_back(Tail(curr, parent));
        return;
      }
    }
    // otherwise, if we have a large value, it might be worth optimizing us as
    // well
    returnTails.push_back(Tail(curr, getCurrentPointer()));
  }

  void visitReturn(Return* curr) { handleReturn(curr); }

  void visitCall(Call* curr) {
    if (curr->isReturn) {
      handleReturn(curr);
    }
  }

  void visitCallIndirect(CallIndirect* curr) {
    if (curr->isReturn) {
      handleReturn(curr);
    }
  }

  void visitCallRef(CallRef* curr) {
    if (curr->isReturn) {
      handleReturn(curr);
    }
  }

  void visitBlock(Block* curr) {
    if (curr->list.empty()) {
      return;
    }
    if (!curr->name.is()) {
      return;
    }
    if (unoptimizables.count(curr->name) > 0) {
      return;
    }
    // we can't optimize a fallthrough value
    if (curr->list.back()->type.isConcrete()) {
      return;
    }
    auto iter = breakTails.find(curr->name);
    if (iter == breakTails.end()) {
      return;
    }
    // looks promising
    auto& tails = iter->second;
    // see if there is a fallthrough
    bool hasFallthrough = true;
    for (auto* child : curr->list) {
      if (child->type == Type::unreachable) {
        hasFallthrough = false;
      }
    }
    if (hasFallthrough) {
      tails.push_back({Tail(curr)});
    }
    optimizeExpressionTails(tails, curr);
  }

  void visitIf(If* curr) {
    if (!curr->ifFalse) {
      return;
    }
    // if both sides are identical, this is easy to fold
    if (ExpressionAnalyzer::equal(curr->ifTrue, curr->ifFalse)) {
      Builder builder(*getModule());
      // remove if (4 bytes), remove one arm, add drop (1), add block (3),
      // so this must be a net savings
      markAsModified(curr);
      auto* ret =
        builder.makeSequence(builder.makeDrop(curr->condition), curr->ifTrue);
      // we must ensure we present the same type as the if had
      ret->finalize(curr->type);
      replaceCurrent(ret);
      needEHFixups = true;
    } else {
      // if both are blocks, look for a tail we can merge
      auto* left = curr->ifTrue->dynCast<Block>();
      auto* right = curr->ifFalse->dynCast<Block>();
      // If one is a block and the other isn't, and the non-block is a tail
      // of the other, we can fold that - for our convenience, we just add
      // a block and run the rest of the optimization mormally.
      auto maybeAddBlock = [this](Block* block, Expression*& other) -> Block* {
        // if other is a suffix of the block, wrap it in a block
        if (block->list.empty() ||
            !ExpressionAnalyzer::equal(other, block->list.back())) {
          return nullptr;
        }
        // do it, assign to the out param `other`, and return the block
        Builder builder(*getModule());
        auto* ret = builder.makeBlock(other);
        other = ret;
        return ret;
      };
      if (left && !right) {
        right = maybeAddBlock(left, curr->ifFalse);
      } else if (!left && right) {
        left = maybeAddBlock(right, curr->ifTrue);
      }
      // we need nameless blocks, as if there is a name, someone might branch
      // to the end, skipping the code we want to merge
      if (left && right && !left->name.is() && !right->name.is()) {
        std::vector<Tail> tails = {Tail(left), Tail(right)};
        optimizeExpressionTails(tails, curr);
      }
    }
  }

  void doWalkFunction(Function* func) {
    anotherPass = true;
    while (anotherPass) {
      anotherPass = false;
      needEHFixups = false;
      super::doWalkFunction(func);
      optimizeTerminatingTails(unreachableTails);
      // optimize returns at the end, so we can benefit from a fallthrough if
      // there is a value TODO: separate passes for them?
      optimizeTerminatingTails(returnTails);
      // TODO add fallthrough for returns
      // TODO optimize returns not in blocks, a big return value can be worth it
      // clean up
      breakTails.clear();
      unreachableTails.clear();
      returnTails.clear();
      unoptimizables.clear();
      modifieds.clear();
      if (needEHFixups) {
        EHUtils::handleBlockNestedPops(func, *getModule());
      }
      // if we did any work, types may need to be propagated
      if (anotherPass) {
        ReFinalize().walkFunctionInModule(func, getModule());
      }
    }
  }

private:
  // check if we can move a list of items out of another item. we can't do so
  // if one of the items has a branch to something inside outOf that is not
  // inside that item
  bool canMove(const std::vector<Expression*>& items, Expression* outOf) {
    auto allTargets = BranchUtils::getBranchTargets(outOf);
    for (auto* item : items) {
      auto exiting = BranchUtils::getExitingBranches(item);
      std::vector<Name> intersection;
      std::set_intersection(allTargets.begin(),
                            allTargets.end(),
                            exiting.begin(),
                            exiting.end(),
                            std::back_inserter(intersection));
      if (intersection.size() > 0) {
        // anything exiting that is in all targets is something bad
        return false;
      }
      if (getModule()->features.hasExceptionHandling()) {
        EffectAnalyzer effects(getPassOptions(), *getModule(), item);
        // Pop instructions are pseudoinstructions used only after 'catch' to
        // simulate its behavior. We cannot move expressions containing pops if
        // they are not enclosed in a 'catch' body, because a pop instruction
        // should follow right after 'catch'.
        if (effects.danglingPop) {
          return false;
        }
        // When an expression can throw and it is within a try scope, taking it
        // out of the try scope changes the program's behavior, because the
        // expression that would otherwise have been caught by the try now
        // throws up to the next try scope or even up to the caller. We restrict
        // the move if 'outOf' contains a 'try' anywhere in it. This is a
        // conservative approximation because there can be cases that 'try' is
        // within the expression that may throw so it is safe to take the
        // expression out.
        if (effects.throws() && !FindAll<Try>(outOf).list.empty()) {
          return false;
        }
      }
    }
    return true;
  }

  // optimize tails that reach the outside of an expression. code that is
  // identical in all paths leading to the block exit can be merged.
  template<typename T>
  void optimizeExpressionTails(std::vector<Tail>& tails, T* curr) {
    if (tails.size() < 2) {
      return;
    }
    // see if anything is untoward, and we should not do this
    for (auto& tail : tails) {
      if (tail.expr && modifieds.count(tail.expr) > 0) {
        return;
      }
      if (modifieds.count(tail.block) > 0) {
        return;
      }
      // if we were not modified, then we should be valid for processing
      tail.validate();
    }
    // we can ignore the final br in a tail
    auto effectiveSize = [&](const Tail& tail) {
      auto ret = tail.block->list.size();
      if (!tail.isFallthrough()) {
        ret--;
      }
      return ret;
    };
    // the mergeable items do not include the final br in a tail
    auto getMergeable = [&](const Tail& tail, Index num) {
      return tail.block->list[effectiveSize(tail) - num - 1];
    };
    // we are going to remove duplicate elements and add a block.
    // so for this to make sense, we need the size of the duplicate
    // elements to be worth that extra block (although, there is
    // some chance the block would get merged higher up, see later)
    std::vector<Expression*> mergeable; // the elements we can merge
    Index num = 0;   // how many elements back from the tail to look at
    Index saved = 0; // how much we can save
    while (1) {
      // check if this num is still relevant
      bool stop = false;
      for (auto& tail : tails) {
        assert(tail.block);
        if (num >= effectiveSize(tail)) {
          // one of the lists is too short
          stop = true;
          break;
        }
      }
      if (stop) {
        break;
      }
      auto* item = getMergeable(tails[0], num);
      for (auto& tail : tails) {
        if (!ExpressionAnalyzer::equal(item, getMergeable(tail, num))) {
          // one of the lists has a different item
          stop = true;
          break;
        }
      }
      if (stop) {
        break;
      }
      // we may have found another one we can merge - can we move it?
      if (!canMove({item}, curr)) {
        break;
      }
      // we found another one we can merge
      mergeable.push_back(item);
      num++;
      saved += Measurer::measure(item);
    }
    if (saved == 0) {
      return;
    }
    // we may be able to save enough.
    if (saved < WORTH_ADDING_BLOCK_TO_REMOVE_THIS_MUCH) {
      // it's not obvious we can save enough. see if we get rid
      // of a block, that would justify this
      bool willEmptyBlock = false;
      for (auto& tail : tails) {
        // it is enough to zero out the block, or leave just one
        // element, as then the block can be replaced with that
        if (num >= tail.block->list.size() - 1) {
          willEmptyBlock = true;
          break;
        }
      }
      if (!willEmptyBlock) {
        // last chance, if our parent is a block, then it should be
        // fine to create a new block here, it will be merged up
        // we are an if or a block, at the top
        assert(curr == controlFlowStack.back());
        if (controlFlowStack.size() <= 1) {
          return; // no parent at all
          // TODO: if we are the toplevel in the function, then in the binary
          //       format we might avoid emitting a block, so the same logic
          //       applies here?
        }
        auto* parent =
          controlFlowStack[controlFlowStack.size() - 2]->dynCast<Block>();
        if (!parent) {
          return; // parent is not a block
        }
        bool isChild = false;
        for (auto* child : parent->list) {
          if (child == curr) {
            isChild = true;
            break;
          }
        }
        if (!isChild) {
          return; // not a child, something in between
        }
      }
    }
    // this is worth doing, do it!
    for (auto& tail : tails) {
      // remove the items we are merging / moving
      // first, mark them as modified, so we don't try to handle them
      // again in this pass, which might be buggy
      markAsModified(tail.block);
      // we must preserve the br if there is one
      Expression* last = nullptr;
      if (!tail.isFallthrough()) {
        last = tail.block->list.back();
        tail.block->list.pop_back();
      }
      for (Index i = 0; i < mergeable.size(); i++) {
        tail.block->list.pop_back();
      }
      if (!tail.isFallthrough()) {
        tail.block->list.push_back(last);
      }
      // the block type may change if we removed unreachable stuff,
      // but in general it should remain the same, as if it had a
      // forced type it should remain, *and*, we don't have a
      // fallthrough value (we would never get here), so a concrete
      // type was not from that. I.e., any type on the block is
      // either forced and/or from breaks with a value, so the
      // type cannot be changed by moving code out.
      tail.block->finalize(tail.block->type);
    }
    // since we managed a merge, then it might open up more opportunities later
    anotherPass = true;
    // make a block with curr + the merged code
    Builder builder(*getModule());
    auto* block = builder.makeBlock();
    block->list.push_back(curr);
    while (!mergeable.empty()) {
      block->list.push_back(mergeable.back());
      mergeable.pop_back();
    }
    auto oldType = curr->type;
    // NB: we template-specialize so that this calls the proper finalizer for
    //     the type
    curr->finalize();
    // ensure the replacement has the same type, so the outside is not surprised
    block->finalize(oldType);
    replaceCurrent(block);
    needEHFixups = true;
  }

  // optimize tails that terminate control flow in this function, so we
  // are (1) merge just a few of them, we don't need all like with the
  // branches to a block, and (2) we do it on the function body.
  // num is the depth, i.e., how many tail items we can merge. 0 means
  // we are just starting; num > 0 means that tails is guaranteed to be
  // equal in the last num items, so we can merge there, but we look for
  // deeper merges first.
  // returns whether we optimized something.
  bool optimizeTerminatingTails(std::vector<Tail>& tails, Index num = 0) {
    if (tails.size() < 2) {
      return false;
    }
    // remove things that are untoward and cannot be optimized
    tails.erase(
      std::remove_if(tails.begin(),
                     tails.end(),
                     [&](Tail& tail) {
                       if (tail.expr && modifieds.count(tail.expr) > 0) {
                         return true;
                       }
                       if (tail.block && modifieds.count(tail.block) > 0) {
                         return true;
                       }
                       // if we were not modified, then we should be valid for
                       // processing
                       tail.validate();
                       return false;
                     }),
      tails.end());
    // now let's try to find subsets that are mergeable. we don't look hard
    // for the most optimal; further passes may find more
    // effectiveSize: TODO: special-case fallthrough, matters for returns
    auto effectiveSize = [&](Tail& tail) -> Index {
      if (tail.block) {
        return tail.block->list.size();
      } else {
        return 1;
      }
    };
    // getItem: returns the relevant item from the tail. this includes the
    //          final item
    //          TODO: special-case fallthrough, matters for returns
    auto getItem = [&](Tail& tail, Index num) {
      if (tail.block) {
        return tail.block->list[effectiveSize(tail) - num - 1];
      } else {
        return tail.expr;
      }
    };
    // gets the tail elements of a certain depth
    auto getTailItems = [&](Index num, std::vector<Tail>& tails) {
      std::vector<Expression*> items;
      for (Index i = 0; i < num; i++) {
        auto item = getItem(tails[0], i);
        items.push_back(item);
      }
      return items;
    };
    // estimate if a merging is worth the cost
    auto worthIt = [&](Index num, std::vector<Tail>& tails) {
      auto items = getTailItems(num, tails); // the elements we can merge
      Index saved = 0;                       // how much we can save
      for (auto* item : items) {
        saved += Measurer::measure(item) * (tails.size() - 1);
      }
      // compure the cost: in non-fallthroughs, we are replacing the final
      // element with a br; for a fallthrough, if there is one, we must
      // add a return element (for the function body, so it doesn't reach us)
      // TODO: handle fallthroughts for return
      Index cost = tails.size();
      // we also need to add two blocks: for us to break to, and to contain
      // that block and the merged code. very possibly one of the blocks
      // can be removed, though
      cost += WORTH_ADDING_BLOCK_TO_REMOVE_THIS_MUCH;
      // if we cannot merge to the end, then we definitely need 2 blocks,
      // and a branch
      // TODO: efficiency, entire body
      if (!canMove(items, getFunction()->body)) {
        cost += 1 + WORTH_ADDING_BLOCK_TO_REMOVE_THIS_MUCH;
        // TODO: to do this, we need to maintain a map of element=>parent,
        //       so that we can insert the new blocks in the right place
        //       for now, just don't do this optimization
        return false;
      }
      // is it worth it?
      return saved > cost;
    };
    // let's see if we can merge deeper than num, to num + 1
    auto next = tails;
    // remove tails that are too short, or that we hit an item we can't handle
    next.erase(std::remove_if(next.begin(),
                              next.end(),
                              [&](Tail& tail) {
                                if (effectiveSize(tail) < num + 1) {
                                  return true;
                                }
                                auto* newItem = getItem(tail, num);
                                // ignore tails that break to outside blocks. we
                                // want to move code to the very outermost
                                // position, so such code cannot be moved
                                // TODO: this should not be a problem in
                                //       *non*-terminating tails, but
                                //       double-verify that
                                if (EffectAnalyzer(
                                      getPassOptions(), *getModule(), newItem)
                                      .hasExternalBreakTargets()) {
                                  return true;
                                }
                                return false;
                              }),
               next.end());
    // if we have enough to investigate, do so
    if (next.size() >= 2) {
      // now we want to find a mergeable item - any item that is equal among a
      // subset
      std::map<Expression*, size_t> hashes; // expression => hash value
      // hash value => expressions with that hash
      std::map<size_t, std::vector<Expression*>> hashed;
      for (auto& tail : next) {
        auto* item = getItem(tail, num);
        auto hash = hashes[item] = ExpressionAnalyzer::hash(item);
        hashed[hash].push_back(item);
      }
      // look at each hash value exactly once. we do this in a deterministic
      // order by iterating over a vector retaining insertion order.
      std::set<size_t> seen;
      for (auto& tail : next) {
        auto* item = getItem(tail, num);
        auto digest = hashes[item];
        if (!seen.emplace(digest).second) {
          continue;
        }

        auto& items = hashed[digest];
        if (items.size() == 1) {
          continue;
        }
        assert(items.size() > 0);
        // look for an item that has another match.
        while (items.size() >= 2) {
          auto first = items[0];
          std::vector<Expression*> others;
          items.erase(
            std::remove_if(items.begin(),
                           items.end(),
                           [&](Expression* item) {
                             if (item ==
                                   first || // don't bother comparing the first
                                 ExpressionAnalyzer::equal(item, first)) {
                               // equal, keep it
                               return false;
                             } else {
                               // unequal, look at it later
                               others.push_back(item);
                               return true;
                             }
                           }),
            items.end());
          if (items.size() >= 2) {
            // possible merge here, investigate it
            auto* correct = items[0];
            auto explore = next;
            explore.erase(std::remove_if(explore.begin(),
                                         explore.end(),
                                         [&](Tail& tail) {
                                           auto* item = getItem(tail, num);
                                           return !ExpressionAnalyzer::equal(
                                             item, correct);
                                         }),
                          explore.end());
            // try to optimize this deeper tail. if we succeed, then stop here,
            // as the changes may influence us. we leave further opts to further
            // passes (as this is rare in practice, it's generally not a perf
            // issue, but TODO optimize)
            if (optimizeTerminatingTails(explore, num + 1)) {
              return true;
            }
          }
          items.swap(others);
        }
      }
    }
    // we explored deeper (higher num) options, but perhaps there
    // was nothing there while there is something we can do at this level
    // but if we are at num == 0, then we found nothing at all
    if (num == 0) {
      return false;
    }
    // if not worth it, stop
    if (!worthIt(num, tails)) {
      return false;
    }
    // this is worth doing, do it!
    auto mergeable = getTailItems(num, tails); // the elements we can merge
    // since we managed a merge, then it might open up more opportunities later
    anotherPass = true;
    Builder builder(*getModule());
    // TODO: don't create one per merge, linear in function size
    LabelUtils::LabelManager labels(getFunction());
    Name innerName = labels.getUnique("folding-inner");
    for (auto& tail : tails) {
      // remove the items we are merging / moving, and add a break
      // also mark as modified, so we don't try to handle them
      // again in this pass, which might be buggy
      if (tail.block) {
        markAsModified(tail.block);
        for (Index i = 0; i < mergeable.size(); i++) {
          tail.block->list.pop_back();
        }
        tail.block->list.push_back(builder.makeBreak(innerName));
        tail.block->finalize(tail.block->type);
      } else {
        markAsModified(tail.expr);
        *tail.pointer = builder.makeBreak(innerName);
      }
    }
    // make a block with the old body + the merged code
    auto* old = getFunction()->body;
    auto* inner = builder.makeBlock();
    inner->name = innerName;
    if (old->type == Type::unreachable) {
      // the old body is not flowed out of anyhow, so just put it there
      inner->list.push_back(old);
    } else {
      // otherwise, we must not flow out to the merged code
      if (old->type == Type::none) {
        inner->list.push_back(old);
        inner->list.push_back(builder.makeReturn());
      } else {
        // looks like we must return this. but if it's a toplevel block
        // then it might be marked as having a type, but not actually
        // returning it (we marked it as such for wasm type-checking
        // rules, and now it won't be toplevel in the function, it can
        // change)
        auto* toplevel = old->dynCast<Block>();
        if (toplevel) {
          toplevel->finalize();
        }
        if (old->type != Type::unreachable) {
          inner->list.push_back(builder.makeReturn(old));
        } else {
          inner->list.push_back(old);
        }
      }
    }
    inner->finalize();
    auto* outer = builder.makeBlock();
    outer->list.push_back(inner);
    while (!mergeable.empty()) {
      outer->list.push_back(mergeable.back());
      mergeable.pop_back();
    }
    // ensure the replacement has the same type, so the outside is not surprised
    outer->finalize(getFunction()->getResults());
    getFunction()->body = outer;
    needEHFixups = true;
    return true;
  }

  void markAsModified(Expression* curr) {
    ExpressionMarker marker(modifieds, curr);
  }
};

Pass* createCodeFoldingPass() { return new CodeFolding(); }

} // namespace wasm
