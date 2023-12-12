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
// Flattens code into "Flat IR" form. See ir/flat.h.
//
// TODO: handle non-nullability. for example:
//
//      (module
//       (type $none (func))
//       (func $foo
//        (drop
//         (block (result funcref (ref $none))
//          (tuple.make 2
//           (ref.null func)
//           (ref.func $foo)
//          )
//         )
//        )
//       )
//      )
//
// The tuple has a non-nullable type, and so it cannot currently be set to a
// local, but in principle there's no reason it couldn't be. For now, error on
// this.

#include <ir/branch-utils.h>
#include <ir/effects.h>
#include <ir/eh-utils.h>
#include <ir/flat.h>
#include <ir/properties.h>
#include <ir/utils.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

// We use the following algorithm: we maintain a list of "preludes", code
// that runs right before an expression. When we visit an expression we
// must handle it and its preludes. If the expression has side effects,
// we reduce it to a local.get and add a prelude for that. We then handle
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
struct Flatten
  : public WalkerPass<
      ExpressionStackWalker<Flatten, UnifiedExpressionVisitor<Flatten>>> {
  bool isFunctionParallel() override { return true; }

  // Flattening splits the original locals into a great many other ones, losing
  // track of the originals that DWARF refers to.
  // FIXME DWARF updating does not handle local changes yet.
  bool invalidatesDWARF() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<Flatten>();
  }

  // For each expression, a bunch of expressions that should execute right
  // before it
  std::unordered_map<Expression*, std::vector<Expression*>> preludes;

  // Break values are sent through a temp local
  std::unordered_map<Name, Index> breakTemps;

  void visitExpression(Expression* curr) {
    std::vector<Expression*> ourPreludes;
    Builder builder(*getModule());

    // Nothing to do for constants and nop.
    if (Properties::isConstantExpression(curr) || curr->is<Nop>()) {
      return;
    }

    if (Properties::isControlFlowStructure(curr)) {
      // handle control flow explicitly. our children do not have control flow,
      // but they do have preludes which we need to set up in the right place

      // no one should have given us preludes, they are on the children
      assert(preludes.find(curr) == preludes.end());

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
        if (type.isConcrete()) {
          // if there is a temp index for breaking to the block, use that
          Index temp;
          auto iter = breakTemps.find(block->name);
          if (iter != breakTemps.end()) {
            temp = iter->second;
          } else {
            temp = builder.addVar(getFunction(), type);
          }
          auto*& last = block->list.back();
          if (last->type.isConcrete()) {
            last = builder.makeLocalSet(temp, last);
          }
          block->finalize(Type::none);
          // and we leave just a get of the value
          auto* rep = builder.makeLocalGet(temp, type);
          replaceCurrent(rep);
          // the whole block is now a prelude
          ourPreludes.push_back(block);
        }
        // the block now has no return value, and may have become unreachable
        block->finalize(Type::none);

      } else if (auto* iff = curr->dynCast<If>()) {
        // condition preludes go before the entire if
        auto* rep = getPreludesWithExpression(iff->condition, iff);
        // arm preludes go in the arms. we must also remove an if value
        auto* originalIfTrue = iff->ifTrue;
        auto* originalIfFalse = iff->ifFalse;
        auto type = iff->type;
        Expression* prelude = nullptr;
        if (type.isConcrete()) {
          Index temp = builder.addVar(getFunction(), type);
          if (iff->ifTrue->type.isConcrete()) {
            iff->ifTrue = builder.makeLocalSet(temp, iff->ifTrue);
          }
          if (iff->ifFalse && iff->ifFalse->type.isConcrete()) {
            iff->ifFalse = builder.makeLocalSet(temp, iff->ifFalse);
          }
          // the whole if (+any preludes from the condition) is now a prelude
          prelude = rep;
          // and we leave just a get of the value
          rep = builder.makeLocalGet(temp, type);
        }
        iff->ifTrue = getPreludesWithExpression(originalIfTrue, iff->ifTrue);
        if (iff->ifFalse) {
          iff->ifFalse =
            getPreludesWithExpression(originalIfFalse, iff->ifFalse);
        }
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
        if (type.isConcrete()) {
          Index temp = builder.addVar(getFunction(), type);
          loop->body = builder.makeLocalSet(temp, loop->body);
          // and we leave just a get of the value
          rep = builder.makeLocalGet(temp, type);
          // the whole if is now a prelude
          ourPreludes.push_back(loop);
          loop->type = Type::none;
        }
        loop->body = getPreludesWithExpression(originalBody, loop->body);
        loop->finalize();
        replaceCurrent(rep);

      } else if (auto* tryy = curr->dynCast<Try>()) {
        // remove a try value
        Expression* rep = tryy;
        auto* originalBody = tryy->body;
        std::vector<Expression*> originalCatchBodies(tryy->catchBodies.begin(),
                                                     tryy->catchBodies.end());
        auto type = tryy->type;
        if (type.isConcrete()) {
          Index temp = builder.addVar(getFunction(), type);
          if (tryy->body->type.isConcrete()) {
            tryy->body = builder.makeLocalSet(temp, tryy->body);
          }
          for (Index i = 0; i < tryy->catchBodies.size(); i++) {
            if (tryy->catchBodies[i]->type.isConcrete()) {
              tryy->catchBodies[i] =
                builder.makeLocalSet(temp, tryy->catchBodies[i]);
            }
          }
          // and we leave just a get of the value
          rep = builder.makeLocalGet(temp, type);
          // the whole try is now a prelude
          ourPreludes.push_back(tryy);
        }
        tryy->body = getPreludesWithExpression(originalBody, tryy->body);
        for (Index i = 0; i < tryy->catchBodies.size(); i++) {
          tryy->catchBodies[i] = getPreludesWithExpression(
            originalCatchBodies[i], tryy->catchBodies[i]);
        }
        tryy->finalize();
        replaceCurrent(rep);

      } else {
        WASM_UNREACHABLE("unexpected expr type");
      }

    } else {
      // for anything else, there may be existing preludes
      auto iter = preludes.find(curr);
      if (iter != preludes.end()) {
        ourPreludes.swap(iter->second);
      }

      // special handling
      if (auto* set = curr->dynCast<LocalSet>()) {
        if (set->isTee()) {
          // we disallow local.tee
          if (set->value->type == Type::unreachable) {
            replaceCurrent(set->value); // trivial, no set happens
          } else {
            // use a set in a prelude + a get
            set->makeSet();
            ourPreludes.push_back(set);
            Type localType = getFunction()->getLocalType(set->index);
            replaceCurrent(builder.makeLocalGet(set->index, localType));
          }
        }

      } else if (auto* br = curr->dynCast<Break>()) {
        if (br->value) {
          auto type = br->value->type;
          if (type.isConcrete()) {
            // we are sending a value. use a local instead
            Type blockType = findBreakTarget(br->name)->type;
            Index temp = getTempForBreakTarget(br->name, blockType);
            ourPreludes.push_back(builder.makeLocalSet(temp, br->value));

            // br_if leaves a value on the stack if not taken, which later can
            // be the last element of the enclosing innermost block and flow
            // out. The local we created using 'getTempForBreakTarget' returns
            // the return type of the block this branch is targetting, which may
            // not be the same with the innermost block's return type. For
            // example,
            // (block $any (result anyref)
            //   (block (result funcref)
            //     (local.tee $0
            //       (br_if $any
            //         (ref.null func)
            //         (i32.const 0)
            //       )
            //     )
            //   )
            // )
            // In this case we need two locals to store (ref.null); one with
            // funcref type that's for the target block ($label0) and one more
            // with anyref type in case for flowing out. Here we create the
            // second 'flowing out' local in case two block's types are
            // different.
            if (type != blockType) {
              temp = builder.addVar(getFunction(), type);
              ourPreludes.push_back(builder.makeLocalSet(
                temp, ExpressionManipulator::copy(br->value, *getModule())));
            }

            if (br->condition) {
              // the value must also flow out
              ourPreludes.push_back(br);
              if (br->type.isConcrete()) {
                replaceCurrent(builder.makeLocalGet(temp, type));
              } else {
                assert(br->type == Type::unreachable);
                replaceCurrent(builder.makeUnreachable());
              }
            }
            br->value = nullptr;
            br->finalize();
          } else {
            assert(type == Type::unreachable);
            // we don't need the br at all
            replaceCurrent(br->value);
          }
        }

      } else if (auto* sw = curr->dynCast<Switch>()) {
        if (sw->value) {
          auto type = sw->value->type;
          if (type.isConcrete()) {
            // we are sending a value. use a local instead
            Index temp = builder.addVar(getFunction(), type);
            ourPreludes.push_back(builder.makeLocalSet(temp, sw->value));
            // we don't know which break target will be hit - assign to them all
            auto names = BranchUtils::getUniqueTargets(sw);
            for (auto name : names) {
              ourPreludes.push_back(
                builder.makeLocalSet(getTempForBreakTarget(name, type),
                                     builder.makeLocalGet(temp, type)));
            }
            sw->value = nullptr;
            sw->finalize();
          } else {
            assert(type == Type::unreachable);
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
    if (curr->type == Type::unreachable) {
      ourPreludes.push_back(curr);
      replaceCurrent(builder.makeUnreachable());
    } else if (curr->type.isConcrete()) {
      // use a local
      auto type = curr->type;
      Index temp = builder.addVar(getFunction(), type);
      ourPreludes.push_back(builder.makeLocalSet(temp, curr));
      replaceCurrent(builder.makeLocalGet(temp, type));
    }

    // next, finish up: migrate our preludes if we can
    if (!ourPreludes.empty()) {
      auto* parent = getParent();
      if (parent && !Properties::isControlFlowStructure(parent)) {
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
    if (curr->body->type.isConcrete()) {
      curr->body = Builder(*getModule()).makeReturn(curr->body);
    }
    // the body may have preludes
    curr->body = getPreludesWithExpression(originalBody, curr->body);

    // Flatten can generate blocks within 'catch', making pops invalid. Fix them
    // up.
    EHUtils::handleBlockNestedPops(curr, *getModule());
  }

private:
  // gets an expression, either by itself, or in a block with its
  // preludes (which we use up) before it
  Expression* getPreludesWithExpression(Expression* curr) {
    return getPreludesWithExpression(curr, curr);
  }

  // gets an expression, either by itself, or in a block with some
  // preludes (which we use up) for another expression before it
  Expression* getPreludesWithExpression(Expression* preluder,
                                        Expression* after) {
    auto iter = preludes.find(preluder);
    if (iter == preludes.end()) {
      return after;
    }
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
      return breakTemps[name] =
               Builder(*getModule()).addVar(getFunction(), type);
    }
  }
};

Pass* createFlattenPass() { return new Flatten(); }

} // namespace wasm
