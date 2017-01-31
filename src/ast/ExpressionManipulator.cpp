#include "ast_utils.h"

namespace wasm {

Expression* ExpressionManipulator::flexibleCopy(Expression* original, Module& wasm, CustomCopier custom) {
    struct Copier : public Visitor<Copier, Expression*> {
      Module& wasm;
      CustomCopier custom;

      Builder builder;

      Copier(Module& wasm, CustomCopier custom) : wasm(wasm), custom(custom), builder(wasm) {}

      Expression* copy(Expression* curr) {
        if (!curr) return nullptr;
        auto* ret = custom(curr);
        if (ret) return ret;
        return Visitor<Copier, Expression*>::visit(curr);
      }

      Expression* visitBlock(Block *curr) {
        auto* ret = builder.makeBlock();
        for (Index i = 0; i < curr->list.size(); i++) {
          ret->list.push_back(copy(curr->list[i]));
        }
        ret->name = curr->name;
        ret->finalize(curr->type);
        return ret;
      }
      Expression* visitIf(If *curr) {
        return builder.makeIf(copy(curr->condition), copy(curr->ifTrue), copy(curr->ifFalse));
      }
      Expression* visitLoop(Loop *curr) {
        return builder.makeLoop(curr->name, copy(curr->body));
      }
      Expression* visitBreak(Break *curr) {
        return builder.makeBreak(curr->name, copy(curr->value), copy(curr->condition));
      }
      Expression* visitSwitch(Switch *curr) {
        return builder.makeSwitch(curr->targets, curr->default_, copy(curr->condition), copy(curr->value));
      }
      Expression* visitCall(Call *curr) {
        auto* ret = builder.makeCall(curr->target, {}, curr->type);
        for (Index i = 0; i < curr->operands.size(); i++) {
          ret->operands.push_back(copy(curr->operands[i]));
        }
        return ret;
      }
      Expression* visitCallImport(CallImport *curr) {
        auto* ret = builder.makeCallImport(curr->target, {}, curr->type);
        for (Index i = 0; i < curr->operands.size(); i++) {
          ret->operands.push_back(copy(curr->operands[i]));
        }
        return ret;
      }
      Expression* visitCallIndirect(CallIndirect *curr) {
        auto* ret = builder.makeCallIndirect(curr->fullType, copy(curr->target), {}, curr->type);
        for (Index i = 0; i < curr->operands.size(); i++) {
          ret->operands.push_back(copy(curr->operands[i]));
        }
        return ret;
      }
      Expression* visitGetLocal(GetLocal *curr) {
        return builder.makeGetLocal(curr->index, curr->type);
      }
      Expression* visitSetLocal(SetLocal *curr) {
        if (curr->isTee()) {
          return builder.makeTeeLocal(curr->index, copy(curr->value));
        } else {
          return builder.makeSetLocal(curr->index, copy(curr->value));
        }
      }
      Expression* visitGetGlobal(GetGlobal *curr) {
        return builder.makeGetGlobal(curr->name, curr->type);
      }
      Expression* visitSetGlobal(SetGlobal *curr) {
        return builder.makeSetGlobal(curr->name, copy(curr->value));
      }
      Expression* visitLoad(Load *curr) {
        return builder.makeLoad(curr->bytes, curr->signed_, curr->offset, curr->align, copy(curr->ptr), curr->type);
      }
      Expression* visitStore(Store *curr) {
        return builder.makeStore(curr->bytes, curr->offset, curr->align, copy(curr->ptr), copy(curr->value), curr->valueType);
      }
      Expression* visitConst(Const *curr) {
        return builder.makeConst(curr->value);
      }
      Expression* visitUnary(Unary *curr) {
        return builder.makeUnary(curr->op, copy(curr->value));
      }
      Expression* visitBinary(Binary *curr) {
        return builder.makeBinary(curr->op, copy(curr->left), copy(curr->right));
      }
      Expression* visitSelect(Select *curr) {
        return builder.makeSelect(copy(curr->condition), copy(curr->ifTrue), copy(curr->ifFalse));
      }
      Expression* visitDrop(Drop *curr) {
        return builder.makeDrop(copy(curr->value));
      }
      Expression* visitReturn(Return *curr) {
        return builder.makeReturn(copy(curr->value));
      }
      Expression* visitHost(Host *curr) {
        assert(curr->operands.size() == 0);
        return builder.makeHost(curr->op, curr->nameOperand, {});
      }
      Expression* visitNop(Nop *curr) {
        return builder.makeNop();
      }
      Expression* visitUnreachable(Unreachable *curr) {
        return builder.makeUnreachable();
      }
    };

    Copier copier(wasm, custom);
    return copier.copy(original);
  }


  // Splice an item into the middle of a block's list
void ExpressionManipulator::spliceIntoBlock(Block* block, Index index, Expression* add) {
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
  }

}
