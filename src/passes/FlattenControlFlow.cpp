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
// Flattens control flow, e.g.
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
// Formally, this pass flattens control flow in the precise sense of
// making the AST have these properties:
//
//  1. Control flow structures (block, loop, if) and control flow
//     operations (br, br_if, br_table, return, unreachable) may
//     only be block children, a loop body, or an if-true or if-false.
//     (I.e., they cannot be nested inside an i32.add, a drop, a
//     call, an if-condition, etc.)
//  2. Disallow block, loop, and if return values, i.e., do not use
//     control flow to pass around values.
//
// Note that we do still allow normal arbitrary nesting of expressions
// *without* control flow (i.e., this is not a reduction to 3-address
// code form). We also allow nesting of control flow, but just nested
// in other control flow, like an if in the true arm of an if, and
// so forth. What we achieve here is that when you see an expression,
// you know it has no control flow inside it, it will be fully
// executed.
//

#include <wasm.h>
#include <pass.h>
#include <wasm-builder.h>
#include <ast_utils.h>
#include <ast/effects.h>

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
struct FlattenControlFlow : public WalkerPass<ExpressionStackWalker<FlattenControlFlow, UnifiedExpressionVisitor<FlattenControlFlow>>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new FlattenControlFlow; }

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
        if (isConcreteWasmType(type)) {
          // if there is a temp index for breaking to the block, use that
          Index temp;
          auto iter = breakTemps.find(block->name);
          if (iter != breakTemps.end()) {
            temp = iter->second;
          } else {
            temp = builder.addVar(getFunction(), type);
          }
          auto*& last = block->list.back();
          if (isConcreteWasmType(last->type)) {
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
        if (isConcreteWasmType(type)) {
          Index temp = builder.addVar(getFunction(), type);
          if (isConcreteWasmType(iff->ifTrue->type)) {
            iff->ifTrue = builder.makeSetLocal(temp, iff->ifTrue);
          }
          if (iff->ifFalse && isConcreteWasmType(iff->ifFalse->type)) {
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
        if (isConcreteWasmType(type)) {
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
      // we have changed children, potentially moving unreachable code outside
      if (curr->type == unreachable) {
        ReFinalizeNode().visit(curr);
      }
      // special handling
      if (auto* br = curr->dynCast<Break>()) {
        if (br->value) {
          auto type = br->value->type;
          if (isConcreteWasmType(type)) {
            // we are sending a value. use a local instead
            Index temp = getTempForBreakTarget(br->name, type);
            ourPreludes.push_back(builder.makeSetLocal(temp, br->value));
            if (br->condition) {
              // the value must also flow out
              ourPreludes.push_back(br);
              replaceCurrent(builder.makeGetLocal(temp, type));
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
          if (isConcreteWasmType(type)) {
            // we are sending a value. use a local instead
            Index temp = builder.addVar(getFunction(), type);
            ourPreludes.push_back(builder.makeSetLocal(temp, sw->value));
            // we don't know which break target will be hit - assign to them all
            std::unordered_set<Name> names;
            for (auto target : sw->targets) {
              names.insert(target);
            }
            names.insert(sw->default_);
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
    // handle side effects and control flow, things we need to be
    // in the prelude
    if (isControlFlowStructure(curr) || EffectAnalyzer(getPassOptions(), curr).hasSideEffects()) {
      // we need to move the side effects to the prelude
      if (curr->type == unreachable) {
        if (!curr->is<Unreachable>()) {
          ourPreludes.push_back(curr);
          replaceCurrent(builder.makeUnreachable());
        }
      } else if (curr->type == none) {
        if (!curr->is<Nop>()) {
          ourPreludes.push_back(curr);
          replaceCurrent(builder.makeNop());
        }
      } else {
        // use a local
        auto type = curr->type;
        Index temp;
        if (auto* set = curr->dynCast<SetLocal>()) {
          temp = set->index;
          set->setTee(false);
          ourPreludes.push_back(set);
        } else {
          temp = builder.addVar(getFunction(), type);
          ourPreludes.push_back(builder.makeSetLocal(temp, curr));
        }
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
    // the body may have preludes
    curr->body = getPreludesWithExpression(curr->body);
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
  Index getTempForBreakTarget(Name name, WasmType type) {
    auto iter = breakTemps.find(name);
    if (iter != breakTemps.end()) {
      return iter->second;
    } else {
      return breakTemps[name] = Builder(*getModule()).addVar(getFunction(), type);
    }
  }
};

Pass *createFlattenControlFlowPass() {
  return new FlattenControlFlow();
}

} // namespace wasm

