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

#include "wasm-validator.h"

#include "ast_utils.h"
#include "ast/branch-utils.h"
#include "support/colors.h"


namespace wasm {
void WasmValidator::noteLabelName(Name name) {
  if (!name.is()) return;
  shouldBeTrue(labelNames.find(name) == labelNames.end(), name, "names in Binaryen IR must be unique - IR generators must ensure that");
  labelNames.insert(name);
}

void WasmValidator::visitBlock(Block *curr) {
  // if we are break'ed to, then the value must be right for us
  if (curr->name.is()) {
    noteLabelName(curr->name);
    if (breakInfos.count(curr) > 0) {
      auto& info = breakInfos[curr];
      if (isConcreteWasmType(curr->type)) {
        shouldBeTrue(info.arity != 0, curr, "break arities must be > 0 if block has a value");
      } else {
        shouldBeTrue(info.arity == 0, curr, "break arities must be 0 if block has no value");
      }
      // none or unreachable means a poison value that we should ignore - if consumed, it will error
      if (isConcreteWasmType(info.type) && isConcreteWasmType(curr->type)) {
        shouldBeEqual(curr->type, info.type, curr, "block+breaks must have right type if breaks return a value");
      }
      if (isConcreteWasmType(curr->type) && info.arity && info.type != unreachable) {
        shouldBeEqual(curr->type, info.type, curr, "block+breaks must have right type if breaks have arity");
      }
      shouldBeTrue(info.arity != Index(-1), curr, "break arities must match");
      if (curr->list.size() > 0) {
        auto last = curr->list.back()->type;
        if (isConcreteWasmType(last) && info.type != unreachable) {
          shouldBeEqual(last, info.type, curr, "block+breaks must have right type if block ends with a reachable value");
        }
        if (last == none) {
          shouldBeTrue(info.arity == Index(0), curr, "if block ends with a none, breaks cannot send a value of any type");
        }
      }
    }
    breakTargets.erase(curr->name);
  }
  if (curr->list.size() > 1) {
    for (Index i = 0; i < curr->list.size() - 1; i++) {
      if (!shouldBeTrue(!isConcreteWasmType(curr->list[i]->type), curr, "non-final block elements returning a value must be drop()ed (binaryen's autodrop option might help you)") && !quiet) {
        std::cerr << "(on index " << i << ":\n" << curr->list[i] << "\n), type: " << curr->list[i]->type << "\n";
      }
    }
  }
  if (curr->list.size() > 0) {
    auto backType = curr->list.back()->type;
    if (!isConcreteWasmType(curr->type)) {
      shouldBeFalse(isConcreteWasmType(backType), curr, "if block is not returning a value, final element should not flow out a value");
    } else {
      if (isConcreteWasmType(backType)) {
        shouldBeEqual(curr->type, backType, curr, "block with value and last element with value must match types");
      } else {
        shouldBeUnequal(backType, none, curr, "block with value must not have last element that is none");
      }
    }
  }
  if (isConcreteWasmType(curr->type)) {
    shouldBeTrue(curr->list.size() > 0, curr, "block with a value must not be empty");
  }
}

void WasmValidator::visitLoop(Loop *curr) {
  if (curr->name.is()) {
    noteLabelName(curr->name);
    breakTargets.erase(curr->name);
    if (breakInfos.count(curr) > 0) {
      auto& info = breakInfos[curr];
      shouldBeEqual(info.arity, Index(0), curr, "breaks to a loop cannot pass a value");
    }
  }
  if (curr->type == none) {
    shouldBeFalse(isConcreteWasmType(curr->body->type), curr, "bad body for a loop that has no value");
  }
}

void WasmValidator::visitIf(If *curr) {
  shouldBeTrue(curr->condition->type == unreachable || curr->condition->type == i32, curr, "if condition must be valid");
  if (!curr->ifFalse) {
    shouldBeFalse(isConcreteWasmType(curr->ifTrue->type), curr, "if without else must not return a value in body");
    if (curr->condition->type != unreachable) {
      shouldBeEqual(curr->type, none, curr, "if without else and reachable condition must be none");
    }
  } else {
    if (curr->type != unreachable) {
      shouldBeEqualOrFirstIsUnreachable(curr->ifTrue->type, curr->type, curr, "returning if-else's true must have right type");
      shouldBeEqualOrFirstIsUnreachable(curr->ifFalse->type, curr->type, curr, "returning if-else's false must have right type");
    } else {
      if (curr->condition->type != unreachable) {
        shouldBeEqual(curr->ifTrue->type, unreachable, curr, "unreachable if-else must have unreachable true");
        shouldBeEqual(curr->ifFalse->type, unreachable, curr, "unreachable if-else must have unreachable false");
      }
    }
    if (isConcreteWasmType(curr->ifTrue->type)) {
      shouldBeEqual(curr->type, curr->ifTrue->type, curr, "if type must match concrete ifTrue");
      shouldBeEqualOrFirstIsUnreachable(curr->ifFalse->type, curr->ifTrue->type, curr, "other arm must match concrete ifTrue");
    }
    if (isConcreteWasmType(curr->ifFalse->type)) {
      shouldBeEqual(curr->type, curr->ifFalse->type, curr, "if type must match concrete ifFalse");
      shouldBeEqualOrFirstIsUnreachable(curr->ifTrue->type, curr->ifFalse->type, curr, "other arm must match concrete ifFalse");
    }
  }
}

void WasmValidator::noteBreak(Name name, Expression* value, Expression* curr) {
  WasmType valueType = none;
  Index arity = 0;
  if (value) {
    valueType = value->type;
    shouldBeUnequal(valueType, none, curr, "breaks must have a valid value");
    arity = 1;
  }
  if (!shouldBeTrue(breakTargets.count(name) > 0, curr, "all break targets must be valid")) return;
  auto* target = breakTargets[name];
  if (breakInfos.count(target) == 0) {
    breakInfos[target] = BreakInfo(valueType, arity);
  } else {
    auto& info = breakInfos[target];
    if (info.type == unreachable) {
      info.type = valueType;
    } else if (valueType != unreachable) {
      if (valueType != info.type) {
        info.type = none; // a poison value that must not be consumed
      }
    }
    if (arity != info.arity) {
      info.arity = Index(-1); // a poison value
    }
  }
}
void WasmValidator::visitBreak(Break *curr) {
  noteBreak(curr->name, curr->value, curr);
  if (curr->condition) {
    shouldBeTrue(curr->condition->type == unreachable || curr->condition->type == i32, curr, "break condition must be i32");
  }
}

void WasmValidator::visitSwitch(Switch *curr) {
  for (auto& target : curr->targets) {
    noteBreak(target, curr->value, curr);
  }
  noteBreak(curr->default_, curr->value, curr);
  shouldBeTrue(curr->condition->type == unreachable || curr->condition->type == i32, curr, "br_table condition must be i32");
}
void WasmValidator::visitCall(Call *curr) {
  if (!validateGlobally) return;
  auto* target = getModule()->getFunctionOrNull(curr->target);
  if (!shouldBeTrue(!!target, curr, "call target must exist")) {
    if (getModule()->getImportOrNull(curr->target) && !quiet) {
      std::cerr << "(perhaps it should be a CallImport instead of Call?)\n";
    }
    return;
  }
  if (!shouldBeTrue(curr->operands.size() == target->params.size(), curr, "call param number must match")) return;
  for (size_t i = 0; i < curr->operands.size(); i++) {
    if (!shouldBeEqualOrFirstIsUnreachable(curr->operands[i]->type, target->params[i], curr, "call param types must match") && !quiet) {
      std::cerr << "(on argument " << i << ")\n";
    }
  }
}
void WasmValidator::visitCallImport(CallImport *curr) {
  if (!validateGlobally) return;
  auto* import = getModule()->getImportOrNull(curr->target);
  if (!shouldBeTrue(!!import, curr, "call_import target must exist")) return;
  if (!shouldBeTrue(!!import->functionType.is(), curr, "called import must be function")) return;
  auto* type = getModule()->getFunctionType(import->functionType);
  if (!shouldBeTrue(curr->operands.size() == type->params.size(), curr, "call param number must match")) return;
  for (size_t i = 0; i < curr->operands.size(); i++) {
    if (!shouldBeEqualOrFirstIsUnreachable(curr->operands[i]->type, type->params[i], curr, "call param types must match") && !quiet) {
      std::cerr << "(on argument " << i << ")\n";
    }
  }
}
void WasmValidator::visitCallIndirect(CallIndirect *curr) {
  if (!validateGlobally) return;
  auto* type = getModule()->getFunctionTypeOrNull(curr->fullType);
  if (!shouldBeTrue(!!type, curr, "call_indirect type must exist")) return;
  shouldBeEqualOrFirstIsUnreachable(curr->target->type, i32, curr, "indirect call target must be an i32");
  if (!shouldBeTrue(curr->operands.size() == type->params.size(), curr, "call param number must match")) return;
  for (size_t i = 0; i < curr->operands.size(); i++) {
    if (!shouldBeEqualOrFirstIsUnreachable(curr->operands[i]->type, type->params[i], curr, "call param types must match") && !quiet) {
      std::cerr << "(on argument " << i << ")\n";
    }
  }
}
void WasmValidator::visitGetLocal(GetLocal* curr) {
  shouldBeTrue(isConcreteWasmType(curr->type), curr, "get_local must have a valid type - check what you provided when you constructed the node");
}
void WasmValidator::visitSetLocal(SetLocal *curr) {
  shouldBeTrue(curr->index < getFunction()->getNumLocals(), curr, "set_local index must be small enough");
  if (curr->value->type != unreachable) {
    if (curr->type != none) { // tee is ok anyhow
      shouldBeEqualOrFirstIsUnreachable(curr->value->type, curr->type, curr, "set_local type must be correct");
    }
    shouldBeEqual(getFunction()->getLocalType(curr->index), curr->value->type, curr, "set_local type must match function");
  }
}
void WasmValidator::visitLoad(Load *curr) {
  if (curr->isAtomic && !getModule()->memory.shared) fail("Atomic operation with non-shared memory", curr);
  validateMemBytes(curr->bytes, curr->type, curr);
  validateAlignment(curr->align, curr->type, curr->bytes, curr->isAtomic, curr);
  shouldBeEqualOrFirstIsUnreachable(curr->ptr->type, i32, curr, "load pointer type must be i32");
}
void WasmValidator::visitStore(Store *curr) {
  if (curr->isAtomic && !getModule()->memory.shared) fail("Atomic operation with non-shared memory", curr);
  validateMemBytes(curr->bytes, curr->valueType, curr);
  validateAlignment(curr->align, curr->type, curr->bytes, curr->isAtomic, curr);
  shouldBeEqualOrFirstIsUnreachable(curr->ptr->type, i32, curr, "store pointer type must be i32");
  shouldBeUnequal(curr->value->type, none, curr, "store value type must not be none");
  shouldBeEqualOrFirstIsUnreachable(curr->value->type, curr->valueType, curr, "store value type must match");
}
void WasmValidator::shouldBeIntOrUnreachable(WasmType ty, Expression* curr, const char* text) {
  switch (ty) {
    case i32:
    case i64:
    case unreachable: {
      break;
    }
    default: fail(text, curr);
  }
}
void WasmValidator::visitAtomicRMW(AtomicRMW* curr) {
  if (!getModule()->memory.shared) fail("Atomic operation with non-shared memory", curr);
  validateMemBytes(curr->bytes, curr->type, curr);
  shouldBeEqualOrFirstIsUnreachable(curr->ptr->type, i32, curr, "AtomicRMW pointer type must be i32");
  shouldBeEqualOrFirstIsUnreachable(curr->value->type, curr->type, curr, "AtomicRMW result type must match operand");
  shouldBeIntOrUnreachable(curr->type, curr, "Atomic operations are only valid on int types");
}
void WasmValidator::visitAtomicCmpxchg(AtomicCmpxchg* curr) {
  if (!getModule()->memory.shared) fail("Atomic operation with non-shared memory", curr);
  validateMemBytes(curr->bytes, curr->type, curr);
  shouldBeEqualOrFirstIsUnreachable(curr->ptr->type, i32, curr, "cmpxchg pointer type must be i32");
  if (curr->expected->type != unreachable && curr->replacement->type != unreachable) {
    shouldBeEqual(curr->expected->type, curr->replacement->type, curr, "cmpxchg operand types must match");
  }
  shouldBeEqualOrFirstIsUnreachable(curr->expected->type, curr->type, curr, "Cmpxchg result type must match expected");
  shouldBeEqualOrFirstIsUnreachable(curr->replacement->type, curr->type, curr, "Cmpxchg result type must match replacement");
  shouldBeIntOrUnreachable(curr->expected->type, curr, "Atomic operations are only valid on int types");
}
void WasmValidator::visitAtomicWait(AtomicWait* curr) {
  if (!getModule()->memory.shared) fail("Atomic operation with non-shared memory", curr);
  shouldBeEqualOrFirstIsUnreachable(curr->type, i32, curr, "AtomicWait must have type i32");
  shouldBeEqualOrFirstIsUnreachable(curr->ptr->type, i32, curr, "AtomicWait pointer type must be i32");
  shouldBeIntOrUnreachable(curr->expected->type, curr, "AtomicWait expected type must be int");
  shouldBeEqualOrFirstIsUnreachable(curr->expected->type, curr->expectedType, curr, "AtomicWait expected type must match operand");
  shouldBeEqualOrFirstIsUnreachable(curr->timeout->type, i64, curr, "AtomicWait timeout type must be i64");
}
void WasmValidator::visitAtomicWake(AtomicWake* curr) {
  if (!getModule()->memory.shared) fail("Atomic operation with non-shared memory", curr);
  shouldBeEqualOrFirstIsUnreachable(curr->type, i32, curr, "AtomicWake must have type i32");
  shouldBeEqualOrFirstIsUnreachable(curr->ptr->type, i32, curr, "AtomicWake pointer type must be i32");
  shouldBeEqualOrFirstIsUnreachable(curr->wakeCount->type, i32, curr, "AtomicWake wakeCount type must be i32");
}
void WasmValidator::validateMemBytes(uint8_t bytes, WasmType type, Expression* curr) {
  switch (bytes) {
    case 1:
    case 2:
    case 4: break;
    case 8: {
      // if we have a concrete type for the load, then we know the size of the mem operation and
      // can validate it
      if (type != unreachable) {
        shouldBeEqual(getWasmTypeSize(type), 8U, curr, "8-byte mem operations are only allowed with 8-byte wasm types");
      }
      break;
    }
    default: fail("Memory operations must be 1,2,4, or 8 bytes", curr);
  }
}
void WasmValidator::visitBinary(Binary *curr) {
  if (curr->left->type != unreachable && curr->right->type != unreachable) {
    shouldBeEqual(curr->left->type, curr->right->type, curr, "binary child types must be equal");
  }
  switch (curr->op) {
    case AddInt32:
    case SubInt32:
    case MulInt32:
    case DivSInt32:
    case DivUInt32:
    case RemSInt32:
    case RemUInt32:
    case AndInt32:
    case OrInt32:
    case XorInt32:
    case ShlInt32:
    case ShrUInt32:
    case ShrSInt32:
    case RotLInt32:
    case RotRInt32:
    case EqInt32:
    case NeInt32:
    case LtSInt32:
    case LtUInt32:
    case LeSInt32:
    case LeUInt32:
    case GtSInt32:
    case GtUInt32:
    case GeSInt32:
    case GeUInt32: {
      shouldBeEqualOrFirstIsUnreachable(curr->left->type, i32, curr, "i32 op");
      break;
    }
    case AddInt64:
    case SubInt64:
    case MulInt64:
    case DivSInt64:
    case DivUInt64:
    case RemSInt64:
    case RemUInt64:
    case AndInt64:
    case OrInt64:
    case XorInt64:
    case ShlInt64:
    case ShrUInt64:
    case ShrSInt64:
    case RotLInt64:
    case RotRInt64:
    case EqInt64:
    case NeInt64:
    case LtSInt64:
    case LtUInt64:
    case LeSInt64:
    case LeUInt64:
    case GtSInt64:
    case GtUInt64:
    case GeSInt64:
    case GeUInt64: {
      shouldBeEqualOrFirstIsUnreachable(curr->left->type, i64, curr, "i64 op");
      break;
    }
    case AddFloat32:
    case SubFloat32:
    case MulFloat32:
    case DivFloat32:
    case CopySignFloat32:
    case MinFloat32:
    case MaxFloat32:
    case EqFloat32:
    case NeFloat32:
    case LtFloat32:
    case LeFloat32:
    case GtFloat32:
    case GeFloat32: {
      shouldBeEqualOrFirstIsUnreachable(curr->left->type, f32, curr, "f32 op");
      break;
    }
    case AddFloat64:
    case SubFloat64:
    case MulFloat64:
    case DivFloat64:
    case CopySignFloat64:
    case MinFloat64:
    case MaxFloat64:
    case EqFloat64:
    case NeFloat64:
    case LtFloat64:
    case LeFloat64:
    case GtFloat64:
    case GeFloat64: {
      shouldBeEqualOrFirstIsUnreachable(curr->left->type, f64, curr, "f64 op");
      break;
    }
    default: WASM_UNREACHABLE();
  }
}
void WasmValidator::visitUnary(Unary *curr) {
  shouldBeUnequal(curr->value->type, none, curr, "unaries must not receive a none as their input");
  if (curr->value->type == unreachable) return; // nothing to check
  switch (curr->op) {
    case ClzInt32:
    case CtzInt32:
    case PopcntInt32: {
      shouldBeEqual(curr->value->type, i32, curr, "i32 unary value type must be correct");
      break;
    }
    case ClzInt64:
    case CtzInt64:
    case PopcntInt64: {
      shouldBeEqual(curr->value->type, i64, curr, "i64 unary value type must be correct");
      break;
    }
    case NegFloat32:
    case AbsFloat32:
    case CeilFloat32:
    case FloorFloat32:
    case TruncFloat32:
    case NearestFloat32:
    case SqrtFloat32: {
      shouldBeEqual(curr->value->type, f32, curr, "f32 unary value type must be correct");
      break;
    }
    case NegFloat64:
    case AbsFloat64:
    case CeilFloat64:
    case FloorFloat64:
    case TruncFloat64:
    case NearestFloat64:
    case SqrtFloat64: {
      shouldBeEqual(curr->value->type, f64, curr, "f64 unary value type must be correct");
      break;
    }
    case EqZInt32: {
      shouldBeTrue(curr->value->type == i32, curr, "i32.eqz input must be i32");
      break;
    }
    case EqZInt64: {
      shouldBeTrue(curr->value->type == i64, curr, "i64.eqz input must be i64");
      break;
    }
    case ExtendSInt32:
    case ExtendUInt32:
    case ExtendS8Int32:
    case ExtendS16Int32: {
      shouldBeEqual(curr->value->type, i32, curr, "extend type must be correct"); break;
    }
    case ExtendS8Int64:
    case ExtendS16Int64:
    case ExtendS32Int64: {
      shouldBeEqual(curr->value->type, i64, curr, "extend type must be correct"); break;
    }
    case WrapInt64:              shouldBeEqual(curr->value->type, i64, curr, "wrap type must be correct"); break;
    case TruncSFloat32ToInt32:   shouldBeEqual(curr->value->type, f32, curr, "trunc type must be correct"); break;
    case TruncSFloat32ToInt64:   shouldBeEqual(curr->value->type, f32, curr, "trunc type must be correct"); break;
    case TruncUFloat32ToInt32:   shouldBeEqual(curr->value->type, f32, curr, "trunc type must be correct"); break;
    case TruncUFloat32ToInt64:   shouldBeEqual(curr->value->type, f32, curr, "trunc type must be correct"); break;
    case TruncSFloat64ToInt32:   shouldBeEqual(curr->value->type, f64, curr, "trunc type must be correct"); break;
    case TruncSFloat64ToInt64:   shouldBeEqual(curr->value->type, f64, curr, "trunc type must be correct"); break;
    case TruncUFloat64ToInt32:   shouldBeEqual(curr->value->type, f64, curr, "trunc type must be correct"); break;
    case TruncUFloat64ToInt64:   shouldBeEqual(curr->value->type, f64, curr, "trunc type must be correct"); break;
    case ReinterpretFloat32:     shouldBeEqual(curr->value->type, f32, curr, "reinterpret/f32 type must be correct"); break;
    case ReinterpretFloat64:     shouldBeEqual(curr->value->type, f64, curr, "reinterpret/f64 type must be correct"); break;
    case ConvertUInt32ToFloat32: shouldBeEqual(curr->value->type, i32, curr, "convert type must be correct"); break;
    case ConvertUInt32ToFloat64: shouldBeEqual(curr->value->type, i32, curr, "convert type must be correct"); break;
    case ConvertSInt32ToFloat32: shouldBeEqual(curr->value->type, i32, curr, "convert type must be correct"); break;
    case ConvertSInt32ToFloat64: shouldBeEqual(curr->value->type, i32, curr, "convert type must be correct"); break;
    case ConvertUInt64ToFloat32: shouldBeEqual(curr->value->type, i64, curr, "convert type must be correct"); break;
    case ConvertUInt64ToFloat64: shouldBeEqual(curr->value->type, i64, curr, "convert type must be correct"); break;
    case ConvertSInt64ToFloat32: shouldBeEqual(curr->value->type, i64, curr, "convert type must be correct"); break;
    case ConvertSInt64ToFloat64: shouldBeEqual(curr->value->type, i64, curr, "convert type must be correct"); break;
    case PromoteFloat32:         shouldBeEqual(curr->value->type, f32, curr, "promote type must be correct"); break;
    case DemoteFloat64:          shouldBeEqual(curr->value->type, f64, curr, "demote type must be correct"); break;
    case ReinterpretInt32:       shouldBeEqual(curr->value->type, i32, curr, "reinterpret/i32 type must be correct"); break;
    case ReinterpretInt64:       shouldBeEqual(curr->value->type, i64, curr, "reinterpret/i64 type must be correct"); break;
    default: abort();
  }
}
void WasmValidator::visitSelect(Select* curr) {
  shouldBeUnequal(curr->ifTrue->type, none, curr, "select left must be valid");
  shouldBeUnequal(curr->ifFalse->type, none, curr, "select right must be valid");
  shouldBeTrue(curr->condition->type == unreachable || curr->condition->type == i32, curr, "select condition must be valid");
  if (curr->ifTrue->type != unreachable && curr->ifFalse->type != unreachable) {
    shouldBeEqual(curr->ifTrue->type, curr->ifFalse->type, curr, "select sides must be equal");
  }
}

void WasmValidator::visitDrop(Drop* curr) {
  shouldBeTrue(isConcreteWasmType(curr->value->type) || curr->value->type == unreachable, curr, "can only drop a valid value");
}

void WasmValidator::visitReturn(Return* curr) {
  if (curr->value) {
    if (returnType == unreachable) {
      returnType = curr->value->type;
    } else if (curr->value->type != unreachable) {
      shouldBeEqual(curr->value->type, returnType, curr, "function results must match");
    }
  } else {
    returnType = none;
  }
}

void WasmValidator::visitHost(Host* curr) {
  switch (curr->op) {
    case GrowMemory: {
      shouldBeEqual(curr->operands.size(), size_t(1), curr, "grow_memory must have 1 operand");
      shouldBeEqualOrFirstIsUnreachable(curr->operands[0]->type, i32, curr, "grow_memory must have i32 operand");
      break;
    }
    case PageSize:
    case CurrentMemory:
    case HasFeature: break;
    default: WASM_UNREACHABLE();
  }
}

void WasmValidator::visitImport(Import* curr) {
  if (!validateGlobally) return;
  if (curr->kind == ExternalKind::Function) {
    if (validateWeb) {
      auto* functionType = getModule()->getFunctionType(curr->functionType);
      shouldBeUnequal(functionType->result, i64, curr->name, "Imported function must not have i64 return type");
      for (WasmType param : functionType->params) {
        shouldBeUnequal(param, i64, curr->name, "Imported function must not have i64 parameters");
      }
    }
  }
  if (curr->kind == ExternalKind::Table) {
    shouldBeTrue(getModule()->table.imported, curr->name, "Table import record exists but table is not marked as imported");
  }
  if (curr->kind == ExternalKind::Memory) {
    shouldBeTrue(getModule()->memory.imported, curr->name, "Memory import record exists but memory is not marked as imported");
  }
}

void WasmValidator::visitExport(Export* curr) {
  if (!validateGlobally) return;
  if (curr->kind == ExternalKind::Function) {
    if (validateWeb) {
      Function* f = getModule()->getFunction(curr->value);
      shouldBeUnequal(f->result, i64, f->name, "Exported function must not have i64 return type");
      for (auto param : f->params) {
        shouldBeUnequal(param, i64, f->name, "Exported function must not have i64 parameters");
      }
    }
  }
}

void WasmValidator::visitGlobal(Global* curr) {
  if (!validateGlobally) return;
  shouldBeTrue(curr->init != nullptr, curr->name, "global init must be non-null");
  shouldBeTrue(curr->init->is<Const>() || curr->init->is<GetGlobal>(), curr->name, "global init must be valid");
  if (!shouldBeEqual(curr->type, curr->init->type, curr->init, "global init must have correct type") && !quiet) {
    std::cerr << "(on global " << curr->name << ")\n";
  }
}

void WasmValidator::visitFunction(Function *curr) {
  // if function has no result, it is ignored
  // if body is unreachable, it might be e.g. a return
  if (curr->body->type != unreachable) {
    shouldBeEqual(curr->result, curr->body->type, curr->body, "function body type must match, if function returns");
  }
  if (returnType != unreachable) {
    shouldBeEqual(curr->result, returnType, curr->body, "function result must match, if function has returns");
  }
  shouldBeTrue(breakTargets.empty(), curr->body, "all named break targets must exist");
  returnType = unreachable;
  labelNames.clear();
  // expressions must not be seen more than once
  struct Walker : public PostWalker<Walker, UnifiedExpressionVisitor<Walker>> {
    std::unordered_set<Expression*>& seen;
    std::vector<Expression*> dupes;

    Walker(std::unordered_set<Expression*>& seen) : seen(seen) {}

    void visitExpression(Expression* curr) {
      if (seen.find(curr) == seen.end()) {
        seen.insert(curr);
      } else {
        dupes.push_back(curr);
      }
    }
  };
  Walker walker(seenExpressions);
  walker.walk(curr->body);
  for (auto* bad : walker.dupes) {
    fail("expression seen more than once in the tree", bad);
  }
}

static bool checkOffset(Expression* curr, Address add, Address max) {
  if (curr->is<GetGlobal>()) return true;
  auto* c = curr->dynCast<Const>();
  if (!c) return false;
  uint64_t raw = c->value.getInteger();
  if (raw > std::numeric_limits<Address::address_t>::max()) {
    return false;
  }
  if (raw + uint64_t(add) > std::numeric_limits<Address::address_t>::max()) {
    return false;
  }
  Address offset = raw;
  return offset + add <= max;
}

void WasmValidator::visitMemory(Memory *curr) {
  shouldBeFalse(curr->initial > curr->max, "memory", "memory max >= initial");
  shouldBeTrue(curr->max <= Memory::kMaxSize, "memory", "max memory must be <= 4GB");
  Index mustBeGreaterOrEqual = 0;
  for (auto& segment : curr->segments) {
    if (!shouldBeEqual(segment.offset->type, i32, segment.offset, "segment offset should be i32")) continue;
    shouldBeTrue(checkOffset(segment.offset, segment.data.size(), getModule()->memory.initial * Memory::kPageSize), segment.offset, "segment offset should be reasonable");
    Index size = segment.data.size();
    shouldBeTrue(size <= curr->initial * Memory::kPageSize, segment.data.size(), "segment size should fit in memory");
    if (segment.offset->is<Const>()) {
      Index start = segment.offset->cast<Const>()->value.geti32();
      Index end = start + size;
      shouldBeTrue(end <= curr->initial * Memory::kPageSize, segment.data.size(), "segment size should fit in memory");
      shouldBeTrue(start >= mustBeGreaterOrEqual, segment.data.size(), "segment size should fit in memory");
      mustBeGreaterOrEqual = end;
    }
  }
}
void WasmValidator::visitTable(Table* curr) {
  for (auto& segment : curr->segments) {
    shouldBeEqual(segment.offset->type, i32, segment.offset, "segment offset should be i32");
    shouldBeTrue(checkOffset(segment.offset, segment.data.size(), getModule()->table.initial * Table::kPageSize), segment.offset, "segment offset should be reasonable");
    for (auto name : segment.data) {
      shouldBeTrue(getModule()->getFunctionOrNull(name) || getModule()->getImportOrNull(name), name, "segment name should be valid");
    }
  }
}
void WasmValidator::visitModule(Module *curr) {
  if (!validateGlobally) return;
  // exports
  std::set<Name> exportNames;
  for (auto& exp : curr->exports) {
    Name name = exp->value;
    if (exp->kind == ExternalKind::Function) {
      bool found = false;
      for (auto& func : curr->functions) {
        if (func->name == name) {
          found = true;
          break;
        }
      }
      shouldBeTrue(found, name, "module function exports must be found");
    } else if (exp->kind == ExternalKind::Global) {
      shouldBeTrue(curr->getGlobalOrNull(name), name, "module global exports must be found");
    } else if (exp->kind == ExternalKind::Table) {
      shouldBeTrue(name == Name("0") || name == curr->table.name, name, "module table exports must be found");
    } else if (exp->kind == ExternalKind::Memory) {
      shouldBeTrue(name == Name("0") || name == curr->memory.name, name, "module memory exports must be found");
    } else {
      WASM_UNREACHABLE();
    }
    Name exportName = exp->name;
    shouldBeFalse(exportNames.count(exportName) > 0, exportName, "module exports must be unique");
    exportNames.insert(exportName);
  }
  // start
  if (curr->start.is()) {
    auto func = curr->getFunctionOrNull(curr->start);
    if (shouldBeTrue(func != nullptr, curr->start, "start must be found")) {
      shouldBeTrue(func->params.size() == 0, curr, "start must have 0 params");
      shouldBeTrue(func->result == none, curr, "start must not return a value");
    }
  }
}

void WasmValidator::validateAlignment(size_t align, WasmType type, Index bytes,
                                      bool isAtomic, Expression* curr) {
  if (isAtomic) {
    shouldBeEqual(align, (size_t)bytes, curr, "atomic accesses must have natural alignment");
    return;
  }
  switch (align) {
    case 1:
    case 2:
    case 4:
    case 8: break;
    default:{
      fail("bad alignment: " + std::to_string(align), curr);
      break;
    }
  }
  shouldBeTrue(align <= bytes, curr, "alignment must not exceed natural");
  switch (type) {
    case i32:
    case f32: {
      shouldBeTrue(align <= 4, curr, "alignment must not exceed natural");
      break;
    }
    case i64:
    case f64: {
      shouldBeTrue(align <= 8, curr, "alignment must not exceed natural");
      break;
    }
    default: {}
  }
}

void WasmValidator::validateBinaryenIR(Module& wasm) {
  struct BinaryenIRValidator : public PostWalker<BinaryenIRValidator, UnifiedExpressionVisitor<BinaryenIRValidator>> {
    WasmValidator& parent;

    BinaryenIRValidator(WasmValidator& parent) : parent(parent) {}

    void visitExpression(Expression* curr) {
      // check if a node type is 'stale', i.e., we forgot to finalize() the node.
      auto oldType = curr->type;
      ReFinalizeNode().visit(curr);
      auto newType = curr->type;
      if (newType != oldType) {
        // We accept concrete => undefined,
        // e.g.
        //
        //  (drop (block (result i32) (unreachable)))
        //
        // The block has an added type, not derived from the ast itself, so it is
        // ok for it to be either i32 or unreachable.
        if (!(isConcreteWasmType(oldType) && newType == unreachable)) {
          parent.printFailureHeader() << "stale type found in " << (getFunction() ? getFunction()->name : Name("(global scope)")) << " on " << curr << "\n(marked as " << printWasmType(oldType) << ", should be " << printWasmType(newType) << ")\n";
          parent.valid = false;
        }
        curr->type = oldType;
      }
    }
  };
  BinaryenIRValidator binaryenIRValidator(*this);
  binaryenIRValidator.walkModule(&wasm);
}

template <typename T, typename S>
std::ostream& WasmValidator::fail(S text, T curr) {
  valid = false;
  if (quiet) return std::cerr;
  auto& ret = printFailureHeader() << text << ", on \n";
  return printModuleComponent(curr, ret);
}

std::ostream& WasmValidator::printFailureHeader() {
  if (quiet) return std::cerr;
  Colors::red(std::cerr);
  if (getFunction()) {
    std::cerr << "[wasm-validator error in function ";
    Colors::green(std::cerr);
    std::cerr << getFunction()->name;
    Colors::red(std::cerr);
    std::cerr << "] ";
  } else {
    std::cerr << "[wasm-validator error in module] ";
  }
  Colors::normal(std::cerr);
  return std::cerr;
}


} // namespace wasm
