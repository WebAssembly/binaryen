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

namespace wasm {

// We use the following algorithm: we maintain a list of "preludes", code
// that runs right before an expression. When we visit an expression we
// must handle it and its preludes. If the expression has side effects,
// we reduce it to a get_local and add a prelude for that. We then handle
// the preludes, by moving them to the parent or handling them directly.
// we can move them to the parent if the parent is not a control flow
// structure.
// As a result, when we reach a node, we know its children have no
// side effects (they have been moved to a prelude), or we are a
// control flow structure (which allows children with side effects,
// e.g. a return as a block element).
struct FlattenControlFlow : public WalkerPass<ExpressionStackWalker<FlattenControlFlow, UnifiedExpressionVisitor<FlattenControlFlow>>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new FlattenControlFlow; }

  // For each expression, a bunch of expressions that should execute right before it
  std::unordered_map<Expression*, std::vector<Expression*>> preludes;

  void visitExpression(Expression* curr) {
    if (isControlFlowStructure(curr) {
      // handle control flow explicitly. our children do not have control flow,
      // but they do have preludes which we need to set up in the right place
      assert(preludes.find(curr) == preludes.end(); // no one should have given us preludes
      if (auto* block = curr->dynCast<Block>()) {
        // make a new list, where each item's preludes are added before it
        ExpressionList newList(getModule());
        for (auto* item : block->list) {
          auto iter = preludes.find(item);
          if (iter != preludes.end()) {
            auto& itemPreludes = *iter;
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
          if (auto iter = breakTemps.find(block->name)) {
            temp = *iter;
          } else {
            temp = builder->addVar(getFunction(), type);
          }
          auto*& last = block->list.back();
          if (isConcreteWasmType(last->type)) {
            last = builder->makeSetLocal(temp, last);
            block->finalize(none);
          }
          // the whole block is now a prelude
          preludes[block] = block;
          // and we leave just a get of the value
          replaceCurrent(builder->makeGetLocal(temp, type));
        }
      } else if (auto* iff = curr->dynCast<If>()) {
        // condition preludes go before the entire if
        auto* rep = getPreludesWithExpression(iff->condition);
        // arm preludes go in the arms. we must also remove an if value
        auto* originalIfTrue = iff->ifTrue;
        auto* originalIfFalse = iff->ifFalse;
        auto type = iff->type;
        if (isConcreteWasmType(type)) {
          Index temp = builder->addVar(getFunction(), type);
          if (isConcreteWasmType(iff->ifTrue->type)) {
            iff->ifTrue = builder->makeSetLocal(temp, iff->ifTrue);
          }
          if (isConcreteWasmType(iff->ifFalse->type)) {
            iff->ifFalse = builder->makeSetLocal(temp, iff->ifFalse);
          }
          // the whole if is now a prelude
          preludes[iff] = rep;
          // and we leave just a get of the value
          rep = builder->makeGetLocal(temp, type);
        }
        iff->ifTrue = getPreludesWithExpression(originalIfTrue, iff->ifTrue);
        iff->ifFalse = getPreludesWithExpression(originalIfFalse, iff->ifFalse);
        replaceCurrent(rep);
      } else if (auto* loop = curr->dynCast<Loop>()) {
// XXX return value
        loop->body = getPreludesWithExpression(loop->body);
      } else {
        WASM_UNREACHABLE();
      }
    }
    // continue for general handling of everything, control flow or otherwise
    curr = getCurrent(); // we may have replaced it
    // first, handle side effects, move them to the prelude
    if (EffectAnalyzer(getPassOptions(), curr).hasSideEffects()) {
      // we need to move the side effects to the prelude
      if (curr->type == unreachable || curr->type == nop) {
        preludes[curr].push_back(curr);
        // use a nop for unreachable too - never reached anyhow
        replaceCurrent(builder->makeNop());
      } else {
        // use a local
        auto type = curr->type;
        Index temp;
        if (auto* set = curr->dynCast<SetLocal>()) {
          temp = set->index;
          set->setTee(false);
          preludes[curr].push_back(curr);
        } else {
          temp = builder->addVar(getFunction(), type);
          preludes[curr].push_back(builder->makeSetLocal(temp, curr));
        }
        replaceCurrent(builder->makeGetLocal(temp, type);
      }
    }
    // next, finish up: migrate our preludes if we can
    auto iter = preludes.find(curr);
    if (iter != preludes.end()) {
      tryToPushPreludesToParent(*iter);
    }
  }

// XXX TODO: break temps
// XXX TODO: br_if, return values

  void visitFunction(Function* curr) {
    // the body may have preludes
XXX
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
    auto* ret = builder->makeBlock(*iter);
    iter->clear();
    ret->list.push_back(after);
    ret->finalize();
    return ret;
  }

  // given some preludes, move them to the parent if possible. otherwise,
  // leave them here, the parent will handle them for us
  void tryToPushPreludesToParent(std::vector<Expression*> ourPreludes) {
    auto* parent = getParent();
    if (parent && !isControlFlowStructure(parent)) {
      auto& parentPreludes = preludes[parent];
      for (auto* prelude : ourPreludes) {
        parentPreludes.push_back(prelude);
      }
      ourPreludes.clear();
    }
  }

/*
  // we get rid of block/if/loop values. this map tells us for
  // each break target what local index to use.
  // if this is a flowing value, there might not be a name assigned
  // (block ending, block with no name; or if value), so we use
  // the expr (and there will be exactly one set and get of it,
  // so we don't need a name)
  std::map<Name, Index> breakNameIndexes;

  void doWalkFunction(Function* func) {
    builder = make_unique<Builder>(*getModule());
    walk(func->body);
    if (func->result != none) {
      // if the body had a fallthrough, receive it and return it
      auto iter = breakExprIndexes.find(func->body);
      if (iter != breakExprIndexes.end()) {
        func->body = builder->makeSequence(
          func->body,
          builder->makeReturn(
            builder->makeGetLocal(iter->second, func->result)
          )
        );
      }
    }
  }

  // returns the index to assign values to for a break target. allocates
  // the local if this is the first time we see it.
  // expr is used if this is a flowing value.
  // name can be null if this is a purely flowing value
  Index getBreakTargetIndex(Name name, WasmType type, Expression* expr = nullptr) {
    assert(isConcreteWasmType(type)); // we shouldn't get here if the value ins't actually set
    if (name.is()) {
      auto iter = breakNameIndexes.find(name);
      if (iter == breakNameIndexes.end()) {
        Index index = builder->addVar(getFunction(), type);
        breakNameIndexes[name] = index;
        if (expr) {
          breakExprIndexes[expr] = index;
        }
        return index;
      }
      if (expr) {
        breakExprIndexes[expr] = iter->second;
      }
      return iter->second;
    } else {
      assert(expr);
      auto iter = breakExprIndexes.find(expr);
      if (iter == breakExprIndexes.end()) {
        Index index = builder->addVar(getFunction(), type);
        return breakExprIndexes[expr] = index;
      }
      return iter->second;
    }
  }

  // set the temp index for an expression (used when creating one manually, as
  // opposed to getBreakTargetIndex)
  void setExprIndex(Expression* expr, Index index) {
    assert(breakExprIndexes.count(expr) == 0);
    breakExprIndexes[expr] = index;
  }

  // When we reach a fallthrough value, it has already been flattened, and its value
  // assigned to the proper local. Or, it may not have needed to be flattened,
  // and we can just assign to a local. This method simply returns the fallthrough
  // replacement code.
  Expression* getFallthroughReplacement(Expression* child, Index myIndex) {
    auto iter = breakExprIndexes.find(child);
    if (iter != breakExprIndexes.end()) {
      // it was flattened and saved to a local
      return builder->makeSequence(
        child, // which no longer flows a value, now it sets the child index
        builder->makeSetLocal(
          myIndex,
          builder->makeGetLocal(iter->second, getFunction()->getLocalType(iter->second))
        )
      );
    }
    // a simple expression
    if (child->type == unreachable) {
      // no need to even set the local
      return child;
    } else {
      assert(!ControlFlowChecker::is(child));
      return builder->makeSetLocal(
        myIndex,
        child
      );
    }
  }

  // flattening fallthroughs makes them have type none. this gets their true type
  WasmType getFallthroughType(Expression* child) {
    auto iter = breakExprIndexes.find(child);
    if (iter != breakExprIndexes.end()) {
      // it was flattened and saved to a local
      return getFunction()->getLocalType(iter->second);
    }
    assert(child->type != none);
    return child->type;
  }

  // Splitter helper
  struct Splitter {
    // @param parent the parent class
    // @param node the node on which we operate
    // @param pre code we need to emit before the node itself (might be part of it we already removed)
    Splitter(FlattenControlFlow& parent, Expression* node, Expression* pre = nullptr) : parent(parent), node(node), pre(pre) {}

    ~Splitter() {
      finish();
    }

    FlattenControlFlow& parent;
    Expression* node;
    Expression* pre;

    std::vector<Expression**> children; // TODO: reuse in parent, avoiding mallocing on each node

    void setNode(Expression* replacement) {
      node = replacement;
    }
    void note(Expression*& child) {
      // we accept nullptr inputs, for a non-existing child
      if (!child) return;
      children.push_back(&child);
    }

    Expression* replacement; // the final replacement for the current node
    bool stop = false; // if a child is unreachable, we can stop

    void finish() {
      Builder* builder = parent.builder.get();
      auto finishBlock = [&](Block* block) {
        // finally, we just created a new block, ending in node. If node is e.g.
        // i32.add, then our block would return a value. so we must convert
        // this new block to return a value through a local
        parent.visitBlock(block);
        // the block is now done
        parent.replaceCurrent(block);
        // if the node was potentially a flowthrough value, then it has an entry
        // in breakExprIndexes, and since we are replacing it with this block,
        // we must note it's index as the same, so it is found by the parent.
        if (parent.breakExprIndexes.find(node) != parent.breakExprIndexes.end()) {
          parent.breakExprIndexes[block] = parent.breakExprIndexes[node];
        }
      };
      // first, scan the list
      bool hasControlFlowChild = false;
      bool hasUnreachableChild = false;
      for (auto** childp : children) {
        // it's enough to look at the child, ignoring the contents, as the contents
        // have already been processed before we got here, so they must have been
        // flattened if necessary.
        auto* child = *childp;
        if (ControlFlowChecker::is(child)) {
          hasControlFlowChild = true;
        }
        if (child->type == unreachable) {
          hasUnreachableChild = true;
        }
      }
      if (!hasControlFlowChild) {
        // nothing to do here.
        assert(!hasUnreachableChild); // all of them should be executed
        if (pre) {
          finishBlock(builder->makeSequence(pre, node));
        }
        return;
      }
      // we have at least one child we need to split out, so to preserve the order of operations,
      // split them all out
      std::vector<Index> tempIndexes;
      for (auto** childp : children) {
        auto* child = *childp;
        if (isConcreteWasmType(child->type)) {
          tempIndexes.push_back(builder->addVar(parent.getFunction(), child->type));
        } else {
          tempIndexes.push_back(-1);
        }
      }
      // create a new replacement block
      auto* block = builder->makeBlock();
      if (pre) block->list.push_back(pre);
      for (Index i = 0; i < children.size(); i++) {
        auto* child = *children[i];
        auto type = child->type;
        if (isConcreteWasmType(type)) {
          // set the child to a local, and use it later
          block->list.push_back(builder->makeSetLocal(tempIndexes[i], child));
          *children[i] = builder->makeGetLocal(tempIndexes[i], type);
        } else if (type == none) {
          // a nested none can not happen normally, here it occurs after we flattened a nested
          // we can use the local it already assigned to. TODO: don't even allocate one here
          block->list.push_back(child);
          assert(parent.breakExprIndexes.count(child) > 0);
          auto index = parent.breakExprIndexes[child];
          *children[i] = builder->makeGetLocal(
            index,
            parent.getFunction()->getLocalType(index)
          );
        } else if (type == unreachable) {
          block->list.push_back(child);
          break; // no need to push any more
        } else {
          WASM_UNREACHABLE();
        }
      }
      if (!hasUnreachableChild) {
        // we reached the end, so we need to emit the expression itself
        // (which has been modified to replace children usages with get_locals)
        block->list.push_back(node);
      }
      block->finalize();
      finishBlock(block);
    }
  };

  void visitBlock(Block* curr) {
    if (isConcreteWasmType(curr->type)) {
      curr->list.back() = getFallthroughReplacement(curr->list.back(), getBreakTargetIndex(curr->name, curr->type, curr));
      curr->finalize();
    }
  }
  void visitLoop(Loop* curr) {
    if (isConcreteWasmType(curr->type)) {
      curr->body = getFallthroughReplacement(curr->body, getBreakTargetIndex(Name(), curr->type, curr));
      curr->finalize();
    }
  }
  void visitIf(If* curr) {
    if (isConcreteWasmType(curr->type)) {
      auto targetIndex = getBreakTargetIndex(Name(), curr->type, curr);
      curr->ifTrue = getFallthroughReplacement(curr->ifTrue, targetIndex);
      curr->ifFalse = getFallthroughReplacement(curr->ifFalse, targetIndex);
      curr->finalize();
    }
    Splitter splitter(*this, curr);
    splitter.note(curr->condition);
  }
  void visitBreak(Break* curr) {
    Splitter splitter(*this, curr);
    if (curr->value) {
      if (curr->condition && isConcreteWasmType(curr->value->type)) {
        // we are flowing out a value. set up a local for that, in addition to
        // the one for the break target, we must assign to both
        auto flowIndex = getBreakTargetIndex(Name(), curr->value->type, curr);
        auto* set1 = builder->makeSetLocal(
            flowIndex,
            curr->value
        );
        splitter.note(set1->value); // the first use of the value is noted
        // the node no longer has a value
        curr->value = nullptr;
        curr->finalize();
        auto* set2 = builder->makeSetLocal(
          getBreakTargetIndex(curr->name, set1->value->type),
          builder->makeGetLocal(flowIndex, set1->value->type)
        );
        // replace the block with that set, a copy to the break target index,
        // and the node itself
        auto* rep = builder->makeBlock({
          set1,
          set2,
          curr
        });
        replaceCurrent(rep);
        setExprIndex(rep, set2->index);
        splitter.setNode(rep);
      } else if (curr->value->type == unreachable) {
        // we have a value, but it has unreachable type. we can just replace
        // ourselves with it, we won't reach a condition (if there is one) or the br
        // itself
        replaceCurrent(curr->value);
        return;
      }
    }
    splitter.note(curr->condition);
  }
  void visitSwitch(Switch* curr) {
    Block* preBlock = nullptr;
    Expression* processed = curr;
    // first of all, get rid of the value if there is one
    if (curr->value) {
      if (curr->value->type != unreachable) {
        auto type = getFallthroughType(curr->value);
        // we must assign the value to *all* the targets
        auto temp = builder->addVar(getFunction(), type);
        auto* value = getFallthroughReplacement(curr->value, temp);
        curr->value = nullptr;
        // the entire preBlock, including the value, will be before everything else
        preBlock = builder->makeBlock();
        preBlock->list.push_back(value);
        std::set<Name> names;
        for (auto target : curr->targets) {
          if (names.insert(target).second) {
            preBlock->list.push_back(
              builder->makeSetLocal(
                getBreakTargetIndex(target, type),
                builder->makeGetLocal(temp, type)
              )
            );
          }
        }
        if (names.insert(curr->default_).second) {
          preBlock->list.push_back(
            builder->makeSetLocal(
              getBreakTargetIndex(curr->default_, type),
              builder->makeGetLocal(temp, type)
            )
          );
        }
        preBlock->finalize();
      } else {
        // we have a value, but it has unreachable type. we can just replace
        // ourselves with it, we won't reach a condition (if there is one) or the br
        // itself
        replaceCurrent(curr->value);
        return;
      }
    }
    Splitter splitter(*this, processed, preBlock);
    splitter.note(curr->condition);
  }
  void visitCall(Call* curr) {
    Splitter splitter(*this, curr);
    for (auto*& operand : curr->operands) {
      splitter.note(operand);
    }
  }
  void visitCallImport(CallImport* curr) {
    Splitter splitter(*this, curr);
    for (auto*& operand : curr->operands) {
      splitter.note(operand);
    }
  }
  void visitCallIndirect(CallIndirect* curr) {
    Splitter splitter(*this, curr);
    for (auto*& operand : curr->operands) {
      splitter.note(operand);
    }
    splitter.note(curr->target);
  }
  void visitSetLocal(SetLocal* curr) {
    Splitter splitter(*this, curr);
    splitter.note(curr->value);
  }
  void visitSetGlobal(SetGlobal* curr) {
    Splitter splitter(*this, curr);
    splitter.note(curr->value);
  }
  void visitLoad(Load* curr) {
    Splitter splitter(*this, curr);
    splitter.note(curr->ptr);
  }
  void visitStore(Store* curr) {
    Splitter splitter(*this, curr);
    splitter.note(curr->ptr);
    splitter.note(curr->value);
  }
  void visitUnary(Unary* curr) {
    Splitter splitter(*this, curr);
    splitter.note(curr->value);
  }
  void visitBinary(Binary* curr) {
    Splitter splitter(*this, curr);
    splitter.note(curr->left);
    splitter.note(curr->right);
  }
  void visitSelect(Select* curr) {
    Splitter splitter(*this, curr);
    splitter.note(curr->ifTrue);
    splitter.note(curr->ifFalse);
    splitter.note(curr->condition);
  }
  void visitDrop(Drop* curr) {
    Splitter splitter(*this, curr);
    splitter.note(curr->value);
  }
  void visitReturn(Return* curr) {
    Splitter splitter(*this, curr);
    splitter.note(curr->value);
  }
  void visitHost(Host* curr) {
    Splitter splitter(*this, curr);
    for (auto*& operand : curr->operands) {
      splitter.note(operand);
    }
  }

  void visitFunction(Function* curr) {
    // removing breaks can alter types
    ReFinalize().walkFunctionInModule(curr, getModule());
  }
*/
};

Pass *createFlattenControlFlowPass() {
  return new FlattenControlFlow();
}

} // namespace wasm

