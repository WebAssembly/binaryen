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
// Flattens code, removing nesting.e.g. an if return value would be
// converted to a local
//
//  (i32.add
//    (if (..condition..)
//      (..if true..)
//      (..if false..)
//    )
//    (i32.const 1)
//  )
// =>
//  (if (..condition..)
//    (set_local $temp
//      (..if true..)
//    )
//    (set_local $temp
//      (..if false..)
//    )
//  )
//  (i32.add
//    (get_local $temp)
//    (i32.const 1)
//  )
//
// Formally, this pass flattens in the precise sense of
// making the AST have these properties:
//
//  1. The operands of an instruction must be a get_local or a const.
//     anything else is written to a local earlier.
//  2. Disallow block, loop, and if return values, i.e., do not use
//     control flow to pass around values.
//  3. Disallow tee_local, setting a local is always done in a set_local
//     on a non-nested-expression location.
//

#include <wasm.h>
#include <pass.h>
#include <wasm-builder.h>
#include <ir/branch-utils.h>
#include <ir/effects.h>
#include <ir/utils.h>

namespace wasm {

// We use the following algorithm: we maintain a list of "preludes", code
// that runs right before an expression. When we visit an expression we
// must handle it and its preludes. If the expression has side effects,
// we reduce it to a get_local and add a prelude for that. We then handle
// the preludes, by moving them to the parent or handling them directly.
// we can move them to the parent if the parent is not a control flow
// structure. Otherwise, if the parent is a control flow structure, it
// will incorporate the preludes of its children accordingly.
// As a result, when we reach a node, we know its children have no
// side effects (they have been moved to a prelude), or we are a
// control flow structure (which allows children with side effects,
// e.g. a return as a block element).
// Once exception is that we allow an (unreachable) node, which is used
// when we move something unreachable to another place, and need a
// placeholder. We will never reach that (unreachable) anyhow
struct Flatten : public WalkerPass<ExpressionStackWalker<Flatten, UnifiedExpressionVisitor<Flatten>>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new Flatten; }

  // For each expression, a bunch of expressions that should execute right before it
  std::unordered_map<Expression*, std::vector<Expression*>> preludes;

  // Break values are sent through a temp local
  std::unordered_map<Name, Index> breakTemps;

  void visitExpression(Expression* curr) {
    std::vector<Expression*> ourPreludes;
    Builder builder(*getModule());

    if (isControlFlowStructure(curr)) {
      // handle control flow explicitly. our children do not have control flow,
      // but they do have preludes which we need to set up in the right place
      assert(preludes.find(curr) == preludes.end()); // no one should have given us preludes, they are on the children
      if (auto* block = curr->dynCast<Block>()) {
        // make a new list, where each item's preludes are added before it
        ExpressionList newList(getModule()->allocator);
        for (auto* item : block->list) {
          auto iter = preludes.find(item);
          if (iter != preludes.end()) {
            auto& itemPreludes = iter->second;
            for (auto* prelude : itemPreludes) {
              newList.push_back(prelude);
            }
            itemPreludes.clear();
          }
          newList.push_back(item);
        }
        block->list.swap(newList);
        // remove a block return value
        auto type = block->type;
        if (isConcreteType(type)) {
          // if there is a temp index for breaking to the block, use that
          Index temp;
          auto iter = breakTemps.find(block->name);
          if (iter != breakTemps.end()) {
            temp = iter->second;
          } else {
            temp = builder.addVar(getFunction(), type);
          }
          auto*& last = block->list.back();
          if (isConcreteType(last->type)) {
            last = builder.makeSetLocal(temp, last);
          }
          block->finalize(none);
          // and we leave just a get of the value
          auto* rep = builder.makeGetLocal(temp, type);
          replaceCurrent(rep);
          // the whole block is now a prelude
          ourPreludes.push_back(block);
        }
        // the block now has no return value, and may have become unreachable
        block->finalize(none);
      } else if (auto* iff = curr->dynCast<If>()) {
        // condition preludes go before the entire if
        auto* rep = getPreludesWithExpression(iff->condition, iff);
        // arm preludes go in the arms. we must also remove an if value
        auto* originalIfTrue = iff->ifTrue;
        auto* originalIfFalse = iff->ifFalse;
        auto type = iff->type;
        Expression* prelude = nullptr;
        if (isConcreteType(type)) {
          Index temp = builder.addVar(getFunction(), type);
          if (isConcreteType(iff->ifTrue->type)) {
            iff->ifTrue = builder.makeSetLocal(temp, iff->ifTrue);
          }
          if (iff->ifFalse && isConcreteType(iff->ifFalse->type)) {
            iff->ifFalse = builder.makeSetLocal(temp, iff->ifFalse);
          }
          // the whole if (+any preludes from the condition) is now a prelude
          prelude = rep;
          // and we leave just a get of the value
          rep = builder.makeGetLocal(temp, type);
        }
        iff->ifTrue = getPreludesWithExpression(originalIfTrue, iff->ifTrue);
        if (iff->ifFalse) iff->ifFalse = getPreludesWithExpression(originalIfFalse, iff->ifFalse);
        iff->finalize();
        if (prelude) {
          ReFinalizeNode().visit(prelude);
          ourPreludes.push_back(prelude);
        }
        replaceCurrent(rep);
      } else if (auto* loop = curr->dynCast<Loop>()) {
        // remove a loop value
        Expression* rep = loop;
        auto* originalBody = loop->body;
        auto type = loop->type;
        if (isConcreteType(type)) {
          Index temp = builder.addVar(getFunction(), type);
          loop->body = builder.makeSetLocal(temp, loop->body);
          // and we leave just a get of the value
          rep = builder.makeGetLocal(temp, type);
          // the whole if is now a prelude
          ourPreludes.push_back(loop);
          loop->type = none;
        }
        loop->body = getPreludesWithExpression(originalBody, loop->body);
        loop->finalize();
        replaceCurrent(rep);
      } else {
        WASM_UNREACHABLE();
      }
    } else {
      // for anything else, there may be existing preludes
      auto iter = preludes.find(curr);
      if (iter != preludes.end()) {
        ourPreludes.swap(iter->second);
      }
      // special handling
      if (auto* set = curr->dynCast<SetLocal>()) {
        if (set->isTee()) {
          // we disallow tee_local
          if (set->value->type == unreachable) {
            replaceCurrent(set->value); // trivial, no set happens
          } else {
            // use a set in a prelude + a get
            set->setTee(false);
            ourPreludes.push_back(set);
            replaceCurrent(builder.makeGetLocal(set->index, set->value->type));
          }
        }
      } else if (auto* br = curr->dynCast<Break>()) {
        if (br->value) {
          auto type = br->value->type;
          if (isConcreteType(type)) {
            // we are sending a value. use a local instead
            Index temp = getTempForBreakTarget(br->name, type);
            ourPreludes.push_back(builder.makeSetLocal(temp, br->value));
            if (br->condition) {
              // the value must also flow out
              ourPreludes.push_back(br);
              if (isConcreteType(br->type)) {
                replaceCurrent(builder.makeGetLocal(temp, type));
              } else {
                assert(br->type == unreachable);
                replaceCurrent(builder.makeUnreachable());
              }
            }
            br->value = nullptr;
            br->finalize();
          } else {
            assert(type == unreachable);
            // we don't need the br at all
            replaceCurrent(br->value);
          }
        }
      } else if (auto* sw = curr->dynCast<Switch>()) {
        if (sw->value) {
          auto type = sw->value->type;
          if (isConcreteType(type)) {
            // we are sending a value. use a local instead
            Index temp = builder.addVar(getFunction(), type);
            ourPreludes.push_back(builder.makeSetLocal(temp, sw->value));
            // we don't know which break target will be hit - assign to them all
            auto names = BranchUtils::getUniqueTargets(sw);
            for (auto name : names) {
              ourPreludes.push_back(builder.makeSetLocal(
                getTempForBreakTarget(name, type),
                builder.makeGetLocal(temp, type)
              ));
            }
            sw->value = nullptr;
            sw->finalize();
          } else {
            assert(type == unreachable);
            // we don't need the br at all
            replaceCurrent(sw->value);
          }
        }
      }
    }
    // continue for general handling of everything, control flow or otherwise
    curr = getCurrent(); // we may have replaced it
    // we have changed children
    ReFinalizeNode().visit(curr);
    // move everything to the prelude, if we need to: anything but constants
    if (!curr->is<Const>()) {
      if (curr->type == unreachable) {
        ourPreludes.push_back(curr);
        replaceCurrent(builder.makeUnreachable());
      } else if (curr->type == none) {
        if (!curr->is<Nop>()) {
          ourPreludes.push_back(curr);
          replaceCurrent(builder.makeNop());
        }
      } else {
        // use a local
        auto type = curr->type;
        Index temp = builder.addVar(getFunction(), type);
        ourPreludes.push_back(builder.makeSetLocal(temp, curr));
        replaceCurrent(builder.makeGetLocal(temp, type));
      }
    }
    // next, finish up: migrate our preludes if we can
    if (!ourPreludes.empty()) {
      auto* parent = getParent();
      if (parent && !isControlFlowStructure(parent)) {
        auto& parentPreludes = preludes[parent];
        for (auto* prelude : ourPreludes) {
          parentPreludes.push_back(prelude);
        }
      } else {
        // keep our preludes, parent will handle them
        preludes[getCurrent()].swap(ourPreludes);
      }
    }
  }

  void visitFunction(Function* curr) {
    auto* originalBody = curr->body;
    // if the body is a block with a result, turn that into a return
    if (isConcreteType(curr->body->type)) {
      curr->body = Builder(*getModule()).makeReturn(curr->body);
    }
    // the body may have preludes
    curr->body = getPreludesWithExpression(originalBody, curr->body);
  }

private:
  bool isControlFlowStructure(Expression* curr) {
    return curr->is<Block>() || curr->is<If>() || curr->is<Loop>();
  }

  // gets an expression, either by itself, or in a block with its
  // preludes (which we use up) before it
  Expression* getPreludesWithExpression(Expression* curr) {
    return getPreludesWithExpression(curr, curr);
  }

  // gets an expression, either by itself, or in a block with some
  // preludes (which we use up) for another expression before it
  Expression* getPreludesWithExpression(Expression* preluder, Expression* after) {
    auto iter = preludes.find(preluder);
    if (iter == preludes.end()) return after;
    // we have preludes
    auto& thePreludes = iter->second;
    auto* ret = Builder(*getModule()).makeBlock(thePreludes);
    thePreludes.clear();
    ret->list.push_back(after);
    ret->finalize();
    return ret;
  }

  // get the temp local to be used for breaks to that target. allocates
  // one if there isn't one yet
  Index getTempForBreakTarget(Name name, Type type) {
    auto iter = breakTemps.find(name);
    if (iter != breakTemps.end()) {
      return iter->second;
    } else {
      return breakTemps[name] = Builder(*getModule()).addVar(getFunction(), type);
    }
  }
};

Pass *createFlattenPass() {
  return new Flatten();
}

} // namespace wasm

