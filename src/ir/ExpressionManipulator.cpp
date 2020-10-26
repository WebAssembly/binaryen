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

#include "ir/load-utils.h"
#include "ir/utils.h"

namespace wasm {

namespace ExpressionManipulator {

Expression*
flexibleCopy(Expression* original, Module& wasm, CustomCopier custom) {
  struct Copier : public OverriddenVisitor<Copier, Expression*> {
    Module& wasm;
    CustomCopier custom;

    Builder builder;

    Copier(Module& wasm, CustomCopier custom)
      : wasm(wasm), custom(custom), builder(wasm) {}

    Expression* copy(Expression* curr) {
      if (!curr) {
        return nullptr;
      }
      auto* ret = custom(curr);
      if (ret) {
        return ret;
      }
      return OverriddenVisitor<Copier, Expression*>::visit(curr);
    }

    Expression* visitBlock(Block* curr) {
      ExpressionList list(wasm.allocator);
      for (Index i = 0; i < curr->list.size(); i++) {
        list.push_back(copy(curr->list[i]));
      }
      return builder.makeBlock(curr->name, list, curr->type);
    }
    Expression* visitIf(If* curr) {
      return builder.makeIf(copy(curr->condition),
                            copy(curr->ifTrue),
                            copy(curr->ifFalse),
                            curr->type);
    }
    Expression* visitLoop(Loop* curr) {
      return builder.makeLoop(curr->name, copy(curr->body), curr->type);
    }
    Expression* visitBreak(Break* curr) {
      return builder.makeBreak(
        curr->name, copy(curr->value), copy(curr->condition));
    }
    Expression* visitSwitch(Switch* curr) {
      return builder.makeSwitch(curr->targets,
                                curr->default_,
                                copy(curr->condition),
                                copy(curr->value));
    }
    Expression* visitCall(Call* curr) {
      auto* ret =
        builder.makeCall(curr->target, {}, curr->type, curr->isReturn);
      for (Index i = 0; i < curr->operands.size(); i++) {
        ret->operands.push_back(copy(curr->operands[i]));
      }
      return ret;
    }
    Expression* visitCallIndirect(CallIndirect* curr) {
      std::vector<Expression*> copiedOps;
      for (auto op : curr->operands) {
        copiedOps.push_back(copy(op));
      }
      return builder.makeCallIndirect(
        copy(curr->target), copiedOps, curr->sig, curr->isReturn);
    }
    Expression* visitLocalGet(LocalGet* curr) {
      return builder.makeLocalGet(curr->index, curr->type);
    }
    Expression* visitLocalSet(LocalSet* curr) {
      if (curr->isTee()) {
        return builder.makeLocalTee(curr->index, copy(curr->value), curr->type);
      } else {
        return builder.makeLocalSet(curr->index, copy(curr->value));
      }
    }
    Expression* visitGlobalGet(GlobalGet* curr) {
      return builder.makeGlobalGet(curr->name, curr->type);
    }
    Expression* visitGlobalSet(GlobalSet* curr) {
      return builder.makeGlobalSet(curr->name, copy(curr->value));
    }
    Expression* visitLoad(Load* curr) {
      if (curr->isAtomic) {
        return builder.makeAtomicLoad(
          curr->bytes, curr->offset, copy(curr->ptr), curr->type);
      }
      return builder.makeLoad(curr->bytes,
                              LoadUtils::isSignRelevant(curr) ? curr->signed_
                                                              : false,
                              curr->offset,
                              curr->align,
                              copy(curr->ptr),
                              curr->type);
    }
    Expression* visitStore(Store* curr) {
      if (curr->isAtomic) {
        return builder.makeAtomicStore(curr->bytes,
                                       curr->offset,
                                       copy(curr->ptr),
                                       copy(curr->value),
                                       curr->valueType);
      }
      return builder.makeStore(curr->bytes,
                               curr->offset,
                               curr->align,
                               copy(curr->ptr),
                               copy(curr->value),
                               curr->valueType);
    }
    Expression* visitAtomicRMW(AtomicRMW* curr) {
      return builder.makeAtomicRMW(curr->op,
                                   curr->bytes,
                                   curr->offset,
                                   copy(curr->ptr),
                                   copy(curr->value),
                                   curr->type);
    }
    Expression* visitAtomicCmpxchg(AtomicCmpxchg* curr) {
      return builder.makeAtomicCmpxchg(curr->bytes,
                                       curr->offset,
                                       copy(curr->ptr),
                                       copy(curr->expected),
                                       copy(curr->replacement),
                                       curr->type);
    }
    Expression* visitAtomicWait(AtomicWait* curr) {
      return builder.makeAtomicWait(copy(curr->ptr),
                                    copy(curr->expected),
                                    copy(curr->timeout),
                                    curr->expectedType,
                                    curr->offset);
    }
    Expression* visitAtomicNotify(AtomicNotify* curr) {
      return builder.makeAtomicNotify(
        copy(curr->ptr), copy(curr->notifyCount), curr->offset);
    }
    Expression* visitAtomicFence(AtomicFence* curr) {
      return builder.makeAtomicFence();
    }
    Expression* visitSIMDExtract(SIMDExtract* curr) {
      return builder.makeSIMDExtract(curr->op, copy(curr->vec), curr->index);
    }
    Expression* visitSIMDReplace(SIMDReplace* curr) {
      return builder.makeSIMDReplace(
        curr->op, copy(curr->vec), curr->index, copy(curr->value));
    }
    Expression* visitSIMDShuffle(SIMDShuffle* curr) {
      return builder.makeSIMDShuffle(
        copy(curr->left), copy(curr->right), curr->mask);
    }
    Expression* visitSIMDTernary(SIMDTernary* curr) {
      return builder.makeSIMDTernary(
        curr->op, copy(curr->a), copy(curr->b), copy(curr->c));
    }
    Expression* visitSIMDShift(SIMDShift* curr) {
      return builder.makeSIMDShift(
        curr->op, copy(curr->vec), copy(curr->shift));
    }
    Expression* visitSIMDLoad(SIMDLoad* curr) {
      return builder.makeSIMDLoad(
        curr->op, curr->offset, curr->align, copy(curr->ptr));
    }
    Expression* visitSIMDLoadStoreLane(SIMDLoadStoreLane* curr) {
      return builder.makeSIMDLoadStoreLane(curr->op,
                                           curr->offset,
                                           curr->align,
                                           curr->index,
                                           copy(curr->ptr),
                                           copy(curr->vec));
    }
    Expression* visitConst(Const* curr) {
      return builder.makeConst(curr->value);
    }
    Expression* visitMemoryInit(MemoryInit* curr) {
      return builder.makeMemoryInit(
        curr->segment, copy(curr->dest), copy(curr->offset), copy(curr->size));
    }
    Expression* visitDataDrop(DataDrop* curr) {
      return builder.makeDataDrop(curr->segment);
    }
    Expression* visitMemoryCopy(MemoryCopy* curr) {
      return builder.makeMemoryCopy(
        copy(curr->dest), copy(curr->source), copy(curr->size));
    }
    Expression* visitMemoryFill(MemoryFill* curr) {
      return builder.makeMemoryFill(
        copy(curr->dest), copy(curr->value), copy(curr->size));
    }
    Expression* visitUnary(Unary* curr) {
      return builder.makeUnary(curr->op, copy(curr->value));
    }
    Expression* visitBinary(Binary* curr) {
      return builder.makeBinary(curr->op, copy(curr->left), copy(curr->right));
    }
    Expression* visitSelect(Select* curr) {
      return builder.makeSelect(copy(curr->condition),
                                copy(curr->ifTrue),
                                copy(curr->ifFalse),
                                curr->type);
    }
    Expression* visitDrop(Drop* curr) {
      return builder.makeDrop(copy(curr->value));
    }
    Expression* visitReturn(Return* curr) {
      return builder.makeReturn(copy(curr->value));
    }
    Expression* visitMemorySize(MemorySize* curr) {
      return builder.makeMemorySize();
    }
    Expression* visitMemoryGrow(MemoryGrow* curr) {
      return builder.makeMemoryGrow(copy(curr->delta));
    }
    Expression* visitRefNull(RefNull* curr) {
      return builder.makeRefNull(curr->type);
    }
    Expression* visitRefIsNull(RefIsNull* curr) {
      return builder.makeRefIsNull(copy(curr->value));
    }
    Expression* visitRefFunc(RefFunc* curr) {
      return builder.makeRefFunc(curr->func);
    }
    Expression* visitRefEq(RefEq* curr) {
      return builder.makeRefEq(copy(curr->left), copy(curr->right));
    }
    Expression* visitTry(Try* curr) {
      return builder.makeTry(
        copy(curr->body), copy(curr->catchBody), curr->type);
    }
    Expression* visitThrow(Throw* curr) {
      std::vector<Expression*> operands;
      for (Index i = 0; i < curr->operands.size(); i++) {
        operands.push_back(copy(curr->operands[i]));
      }
      return builder.makeThrow(curr->event, std::move(operands));
    }
    Expression* visitRethrow(Rethrow* curr) {
      return builder.makeRethrow(copy(curr->exnref));
    }
    Expression* visitBrOnExn(BrOnExn* curr) {
      return builder.makeBrOnExn(
        curr->name, curr->event, copy(curr->exnref), curr->sent);
    }
    Expression* visitNop(Nop* curr) { return builder.makeNop(); }
    Expression* visitUnreachable(Unreachable* curr) {
      return builder.makeUnreachable();
    }
    Expression* visitPop(Pop* curr) { return builder.makePop(curr->type); }
    Expression* visitTupleMake(TupleMake* curr) {
      std::vector<Expression*> operands;
      for (auto* op : curr->operands) {
        operands.push_back(copy(op));
      }
      return builder.makeTupleMake(std::move(operands));
    }
    Expression* visitTupleExtract(TupleExtract* curr) {
      return builder.makeTupleExtract(copy(curr->tuple), curr->index);
    }
    Expression* visitI31New(I31New* curr) {
      return builder.makeI31New(copy(curr->value));
    }
    Expression* visitI31Get(I31Get* curr) {
      return builder.makeI31Get(copy(curr->i31), curr->signed_);
    }
    Expression* visitRefTest(RefTest* curr) {
      WASM_UNREACHABLE("TODO (gc): ref.test");
    }
    Expression* visitRefCast(RefCast* curr) {
      WASM_UNREACHABLE("TODO (gc): ref.cast");
    }
    Expression* visitBrOnCast(BrOnCast* curr) {
      WASM_UNREACHABLE("TODO (gc): br_on_cast");
    }
    Expression* visitRttCanon(RttCanon* curr) {
      WASM_UNREACHABLE("TODO (gc): rtt.canon");
    }
    Expression* visitRttSub(RttSub* curr) {
      WASM_UNREACHABLE("TODO (gc): rtt.sub");
    }
    Expression* visitStructNew(StructNew* curr) {
      WASM_UNREACHABLE("TODO (gc): struct.new");
    }
    Expression* visitStructGet(StructGet* curr) {
      WASM_UNREACHABLE("TODO (gc): struct.get");
    }
    Expression* visitStructSet(StructSet* curr) {
      WASM_UNREACHABLE("TODO (gc): struct.set");
    }
    Expression* visitArrayNew(ArrayNew* curr) {
      WASM_UNREACHABLE("TODO (gc): array.new");
    }
    Expression* visitArrayGet(ArrayGet* curr) {
      WASM_UNREACHABLE("TODO (gc): array.get");
    }
    Expression* visitArraySet(ArraySet* curr) {
      WASM_UNREACHABLE("TODO (gc): array.set");
    }
    Expression* visitArrayLen(ArrayLen* curr) {
      WASM_UNREACHABLE("TODO (gc): array.len");
    }
  };

  Copier copier(wasm, custom);
  return copier.copy(original);
}

// Splice an item into the middle of a block's list
void spliceIntoBlock(Block* block, Index index, Expression* add) {
  auto& list = block->list;
  if (index == list.size()) {
    list.push_back(add); // simple append
  } else {
    // we need to make room
    list.push_back(nullptr);
    for (Index i = list.size() - 1; i > index; i--) {
      list[i] = list[i - 1];
    }
    list[index] = add;
  }
  block->finalize(block->type);
}

} // namespace ExpressionManipulator

} // namespace wasm
