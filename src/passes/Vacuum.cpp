/*
 * Copyright 2016 WebAssembly Community Group participants
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
// Removes obviously unneeded code
//

#include <wasm.h>
#include <pass.h>
#include <ast_utils.h>
#include <wasm-builder.h>

namespace wasm {

struct Vacuum : public WalkerPass<ExpressionStackWalker<Vacuum, Visitor<Vacuum>>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new Vacuum; }

  // returns nullptr if curr is dead, curr if it must stay as is, or another node if it can be replaced
  Expression* optimize(Expression* curr, bool resultUsed) {
    while (1) {
      switch (curr->_id) {
        case Expression::Id::NopId: return nullptr; // never needed

        case Expression::Id::BlockId: return curr; // not always needed, but handled in visitBlock()
        case Expression::Id::IfId: return curr; // not always needed, but handled in visitIf()
        case Expression::Id::LoopId: return curr; // not always needed, but handled in visitLoop()
        case Expression::Id::DropId: return curr; // not always needed, but handled in visitDrop()

        case Expression::Id::BreakId:
        case Expression::Id::SwitchId:
        case Expression::Id::CallId:
        case Expression::Id::CallImportId:
        case Expression::Id::CallIndirectId:
        case Expression::Id::SetLocalId:
        case Expression::Id::LoadId:
        case Expression::Id::StoreId:
        case Expression::Id::ReturnId:
        case Expression::Id::GetGlobalId:
        case Expression::Id::SetGlobalId:
        case Expression::Id::HostId:
        case Expression::Id::UnreachableId: return curr; // always needed

        case Expression::Id::ConstId:
        case Expression::Id::GetLocalId:
        case Expression::Id::UnaryId:
        case Expression::Id::BinaryId:
        case Expression::Id::SelectId: {
          if (resultUsed) {
            return curr; // used, keep it
          }
          // result is not used, perhaps it is dead
          if (curr->is<Const>() || curr->is<GetLocal>()) {
            return nullptr;
          }
          // for unary, binary, and select, we need to check their arguments for side effects
          if (auto* unary = curr->dynCast<Unary>()) {
            if (EffectAnalyzer(unary->value).hasSideEffects()) {
              curr = unary->value;
              continue;
            } else {
              return nullptr;
            }
          } else if (auto* binary = curr->dynCast<Binary>()) {
            if (EffectAnalyzer(binary->left).hasSideEffects()) {
              if (EffectAnalyzer(binary->right).hasSideEffects()) {
                return curr; // leave them
              } else {
                curr = binary->left;
                continue;
              }
            } else {
              if (EffectAnalyzer(binary->right).hasSideEffects()) {
                curr = binary->right;
                continue;
              } else {
                return nullptr;
              }
            }
          } else {
            // TODO: if two have side effects, we could replace the select with say an add?
            auto* select = curr->cast<Select>();
            if (EffectAnalyzer(select->ifTrue).hasSideEffects()) {
              if (EffectAnalyzer(select->ifFalse).hasSideEffects()) {
                return curr; // leave them
              } else {
                if (EffectAnalyzer(select->condition).hasSideEffects()) {
                  return curr; // leave them
                } else {
                  curr = select->ifTrue;
                  continue;
                }
              }
            } else {
              if (EffectAnalyzer(select->ifFalse).hasSideEffects()) {
                if (EffectAnalyzer(select->condition).hasSideEffects()) {
                  return curr; // leave them
                } else {
                  curr = select->ifFalse;
                  continue;
                }
              } else {
                if (EffectAnalyzer(select->condition).hasSideEffects()) {
                  curr = select->condition;
                  continue;
                } else {
                  return nullptr;
                }
              }
            }
          }
        }

        default: WASM_UNREACHABLE();
      }
    }
  }

  void visitBlock(Block *curr) {
    // compress out nops and other dead code
    bool resultUsed = ExpressionAnalyzer::isResultUsed(expressionStack, getFunction());
    int skip = 0;
    auto& list = curr->list;
    size_t size = list.size();
    bool needResize = false;
    for (size_t z = 0; z < size; z++) {
      auto* optimized = optimize(list[z], z == size - 1 && resultUsed);
      if (!optimized) {
        skip++;
        needResize = true;
      } else {
        if (optimized != list[z]) {
          list[z] = optimized;
        }
        if (skip > 0) {
          list[z - skip] = list[z];
        }
        // if this is an unconditional br, the rest is dead code
        Break* br = list[z - skip]->dynCast<Break>();
        Switch* sw = list[z - skip]->dynCast<Switch>();
        if ((br && !br->condition) || sw) {
          list.resize(z - skip + 1);
          needResize = false;
          break;
        }
      }
    }
    if (needResize) {
      list.resize(size - skip);
    }
    if (!curr->name.is()) {
      if (list.size() == 1) {
        // just one element. replace the block, either with it or with a nop if it's not needed
        if (resultUsed || EffectAnalyzer(list[0]).hasSideEffects()) {
          replaceCurrent(list[0]);
        } else {
          ExpressionManipulator::nop(curr);
        }
      } else if (list.size() == 0) {
        ExpressionManipulator::nop(curr);
      }
    }
  }

  void visitIf(If* curr) {
    if (curr->ifFalse) {
      if (curr->ifFalse->is<Nop>()) {
        curr->ifFalse = nullptr;
      } else if (curr->ifTrue->is<Nop>()) {
        curr->ifTrue = curr->ifFalse;
        curr->ifFalse = nullptr;
        curr->condition = Builder(*getModule()).makeUnary(EqZInt32, curr->condition);
      }
    }
    if (!curr->ifFalse) {
      // no else
      if (curr->ifTrue->is<Nop>()) {
        // no nothing
        replaceCurrent(Builder(*getModule()).makeDrop(curr->condition));
      }
    }
  }

  void visitLoop(Loop* curr) {
    if (curr->body->is<Nop>()) ExpressionManipulator::nop(curr);
  }

  void visitDrop(Drop* curr) {
    // if the drop input has no side effects, it can be wiped out
    if (!EffectAnalyzer(curr->value).hasSideEffects()) {
      ExpressionManipulator::nop(curr);
      return;
    }
    // sink a drop into an arm of an if-else if the other arm ends in an unreachable, as it if is a branch, this can make that branch optimizable and more vaccuming possible
    auto* iff = curr->value->dynCast<If>();
    if (iff && iff->ifFalse && isConcreteWasmType(iff->type)) {
      // reuse the drop in both cases
      if (iff->ifTrue->type == unreachable) {
        assert(isConcreteWasmType(iff->ifFalse->type));
        curr->value = iff->ifFalse;
        iff->ifFalse = curr;
        iff->type = none;
        replaceCurrent(iff);
      } else if (iff->ifFalse->type == unreachable) {
        assert(isConcreteWasmType(iff->ifTrue->type));
        curr->value = iff->ifTrue;
        iff->ifTrue = curr;
        iff->type = none;
        replaceCurrent(iff);
      }
    }
  }

  void visitFunction(Function* curr) {
    auto* optimized = optimize(curr->body, curr->result != none);
    if (optimized) {
      curr->body = optimized;
    } else {
      ExpressionManipulator::nop(curr->body);
    }
    if (curr->result == none && !EffectAnalyzer(curr->body).hasSideEffects()) {
      ExpressionManipulator::nop(curr->body);
    }
  }
};

Pass *createVacuumPass() {
  return new Vacuum();
}

} // namespace wasm

