/*
 * Copyright 2015 WebAssembly Community Group participants
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
// Simple WebAssembly module validator.
//
// There are some options regarding how to validate:
//
//  * validateWeb: The Web platform doesn't have i64 values, so it is illegal
//                 to import or export such a value. When this option is set,
//                 such imports/exports are validation errors.
//
//  * validateGlobally: Binaryen supports building modules in parallel, which
//                      means you can add and optimize a function before the
//                      module is complete, for example, you can add function A
//                      with a call to function B before function B exists.
//                      When validateGlobally is disabled, we don't look at
//                      global correctness, and instead only check inside
//                      each function (so in the example above we wouldn't care
//                      about function B not existing yet, but we would care
//                      if e.g. inside function A an i32.add receives an i64).
//

#ifndef wasm_wasm_validator_h
#define wasm_wasm_validator_h

#include <set>

#include "support/colors.h"
#include "wasm.h"
#include "wasm-printing.h"
#include "ast_utils.h"
#include "ast/branch-utils.h"

namespace wasm {

struct WasmValidator : public PostWalker<WasmValidator> {
  bool valid = true;

  // what to validate, see comment up top
  bool validateWeb = false;
  bool validateGlobally = true;

  struct BreakInfo {
    WasmType type;
    Index arity;
    BreakInfo() {}
    BreakInfo(WasmType type, Index arity) : type(type), arity(arity) {}
  };

  std::map<Name, std::vector<Expression*>> breakTargets; // more than one block/loop may use a label name, so stack them
  std::map<Expression*, BreakInfo> breakInfos;

  WasmType returnType = unreachable; // type used in returns

  std::set<Name> labelNames; // Binaryen IR requires that label names must be unique - IR generators must ensure that

  void noteLabelName(Name name) {
    if (!name.is()) return;
    shouldBeTrue(labelNames.find(name) == labelNames.end(), name, "names in Binaryen IR must be unique - IR generators must ensure that");
    labelNames.insert(name);
  }

public:
  bool validate(Module& module, bool validateWeb_ = false, bool validateGlobally_ = true) {
    validateWeb = validateWeb_;
    validateGlobally = validateGlobally_;
    // wasm logic validation
    walkModule(&module);
    // validate additional internal IR details when in pass-debug mode
    if (PassRunner::getPassDebug()) {
      validateBinaryenIR(module);
    }
    // print if an error occurred
    if (!valid) {
      WasmPrinter::printModule(&module, std::cerr);
    }
    return valid;
  }

  // visitors

  static void visitPreBlock(WasmValidator* self, Expression** currp) {
    auto* curr = (*currp)->cast<Block>();
    if (curr->name.is()) self->breakTargets[curr->name].push_back(curr);
  }

  void visitBlock(Block *curr) {
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
      breakTargets[curr->name].pop_back();
    }
    if (curr->list.size() > 1) {
      for (Index i = 0; i < curr->list.size() - 1; i++) {
        if (!shouldBeTrue(!isConcreteWasmType(curr->list[i]->type), curr, "non-final block elements returning a value must be drop()ed (binaryen's autodrop option might help you)")) {
          std::cerr << "(on index " << i << ":\n" << curr->list[i] << "\n), type: " << curr->list[i]->type << "\n";
        }
      }
    }
    if (curr->list.size() > 0) {
      auto backType = curr->list.back()->type;
      if (!isConcreteWasmType(curr->type)) {
        if (isConcreteWasmType(backType)) {
          shouldBeTrue(curr->type == unreachable, curr, "block with no value and a last element with a value must be unreachable");
        }
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

  static void visitPreLoop(WasmValidator* self, Expression** currp) {
    auto* curr = (*currp)->cast<Loop>();
    if (curr->name.is()) self->breakTargets[curr->name].push_back(curr);
  }

  void visitLoop(Loop *curr) {
    if (curr->name.is()) {
      noteLabelName(curr->name);
      breakTargets[curr->name].pop_back();
      if (breakInfos.count(curr) > 0) {
        auto& info = breakInfos[curr];
        shouldBeEqual(info.arity, Index(0), curr, "breaks to a loop cannot pass a value");
      }
    }
    if (curr->type == none) {
      shouldBeFalse(isConcreteWasmType(curr->body->type), curr, "bad body for a loop that has no value");
    }
  }

  void visitIf(If *curr) {
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
    }
  }

  // override scan to add a pre and a post check task to all nodes
  static void scan(WasmValidator* self, Expression** currp) {
    PostWalker<WasmValidator>::scan(self, currp);

    auto* curr = *currp;
    if (curr->is<Block>()) self->pushTask(visitPreBlock, currp);
    if (curr->is<Loop>()) self->pushTask(visitPreLoop, currp);
  }

  void noteBreak(Name name, Expression* value, Expression* curr) {
    WasmType valueType = none;
    Index arity = 0;
    if (value) {
      valueType = value->type;
      shouldBeUnequal(valueType, none, curr, "breaks must have a valid value");
      arity = 1;
    }
    if (!shouldBeTrue(breakTargets[name].size() > 0, curr, "all break targets must be valid")) return;
    auto* target = breakTargets[name].back();
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
  void visitBreak(Break *curr) {
    // note breaks (that are actually taken)
    if (BranchUtils::isBranchTaken(curr)) {
      noteBreak(curr->name, curr->value, curr);
    }
    if (curr->condition) {
      shouldBeTrue(curr->condition->type == unreachable || curr->condition->type == i32, curr, "break condition must be i32");
    }
  }
  void visitSwitch(Switch *curr) {
    // note breaks (that are actually taken)
    if (BranchUtils::isBranchTaken(curr)) {
      for (auto& target : curr->targets) {
        noteBreak(target, curr->value, curr);
      }
      noteBreak(curr->default_, curr->value, curr);
    }
    shouldBeTrue(curr->condition->type == unreachable || curr->condition->type == i32, curr, "br_table condition must be i32");
  }
  void visitCall(Call *curr) {
    if (!validateGlobally) return;
    auto* target = getModule()->getFunctionOrNull(curr->target);
    if (!shouldBeTrue(!!target, curr, "call target must exist")) return;
    if (!shouldBeTrue(curr->operands.size() == target->params.size(), curr, "call param number must match")) return;
    for (size_t i = 0; i < curr->operands.size(); i++) {
      if (!shouldBeEqualOrFirstIsUnreachable(curr->operands[i]->type, target->params[i], curr, "call param types must match")) {
        std::cerr << "(on argument " << i << ")\n";
      }
    }
  }
  void visitCallImport(CallImport *curr) {
    if (!validateGlobally) return;
    auto* import = getModule()->getImportOrNull(curr->target);
    if (!shouldBeTrue(!!import, curr, "call_import target must exist")) return;
    if (!shouldBeTrue(!!import->functionType.is(), curr, "called import must be function")) return;
    auto* type = getModule()->getFunctionType(import->functionType);
    if (!shouldBeTrue(curr->operands.size() == type->params.size(), curr, "call param number must match")) return;
    for (size_t i = 0; i < curr->operands.size(); i++) {
      if (!shouldBeEqualOrFirstIsUnreachable(curr->operands[i]->type, type->params[i], curr, "call param types must match")) {
        std::cerr << "(on argument " << i << ")\n";
      }
    }
  }
  void visitCallIndirect(CallIndirect *curr) {
    if (!validateGlobally) return;
    auto* type = getModule()->getFunctionTypeOrNull(curr->fullType);
    if (!shouldBeTrue(!!type, curr, "call_indirect type must exist")) return;
    shouldBeEqualOrFirstIsUnreachable(curr->target->type, i32, curr, "indirect call target must be an i32");
    if (!shouldBeTrue(curr->operands.size() == type->params.size(), curr, "call param number must match")) return;
    for (size_t i = 0; i < curr->operands.size(); i++) {
      if (!shouldBeEqualOrFirstIsUnreachable(curr->operands[i]->type, type->params[i], curr, "call param types must match")) {
        std::cerr << "(on argument " << i << ")\n";
      }
    }
  }
  void visitGetLocal(GetLocal* curr) {
    shouldBeTrue(isConcreteWasmType(curr->type), curr, "get_local must have a valid type - check what you provided when you constructed the node");
  }
  void visitSetLocal(SetLocal *curr) {
    shouldBeTrue(curr->index < getFunction()->getNumLocals(), curr, "set_local index must be small enough");
    if (curr->value->type != unreachable) {
      if (curr->type != none) { // tee is ok anyhow
        shouldBeEqualOrFirstIsUnreachable(curr->value->type, curr->type, curr, "set_local type must be correct");
      }
      shouldBeEqual(getFunction()->getLocalType(curr->index), curr->value->type, curr, "set_local type must match function");
    }
  }
  void visitLoad(Load *curr) {
    validateAlignment(curr->align, curr->type, curr->bytes);
    shouldBeEqualOrFirstIsUnreachable(curr->ptr->type, i32, curr, "load pointer type must be i32");
  }
  void visitStore(Store *curr) {
    validateAlignment(curr->align, curr->type, curr->bytes);
    shouldBeEqualOrFirstIsUnreachable(curr->ptr->type, i32, curr, "store pointer type must be i32");
    shouldBeUnequal(curr->value->type, none, curr, "store value type must not be none");
    shouldBeEqualOrFirstIsUnreachable(curr->value->type, curr->valueType, curr, "store value type must match");
  }
  void visitBinary(Binary *curr) {
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
  void visitUnary(Unary *curr) {
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
      case ExtendSInt32:           shouldBeEqual(curr->value->type, i32, curr, "extend type must be correct"); break;
      case ExtendUInt32:           shouldBeEqual(curr->value->type, i32, curr, "extend type must be correct"); break;
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
  void visitSelect(Select* curr) {
    shouldBeUnequal(curr->ifTrue->type, none, curr, "select left must be valid");
    shouldBeUnequal(curr->ifFalse->type, none, curr, "select right must be valid");
    shouldBeTrue(curr->condition->type == unreachable || curr->condition->type == i32, curr, "select condition must be valid");
    if (curr->ifTrue->type != unreachable && curr->ifFalse->type != unreachable) {
      shouldBeEqual(curr->ifTrue->type, curr->ifFalse->type, curr, "select sides must be equal");
    }
  }

  void visitDrop(Drop* curr) {
    shouldBeTrue(isConcreteWasmType(curr->value->type) || curr->value->type == unreachable, curr, "can only drop a valid value");
  }

  void visitReturn(Return* curr) {
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

  void visitHost(Host* curr) {
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

  void visitImport(Import* curr) {
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

  void visitExport(Export* curr) {
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

  void visitGlobal(Global* curr) {
    if (!validateGlobally) return;
    shouldBeTrue(curr->init != nullptr, curr->name, "global init must be non-null");
    shouldBeTrue(curr->init->is<Const>() || curr->init->is<GetGlobal>(), curr->name, "global init must be valid");
    if (!shouldBeEqual(curr->type, curr->init->type, curr->init, "global init must have correct type")) {
      std::cerr << "(on global " << curr->name << '\n';
    }
  }

  void visitFunction(Function *curr) {
    // if function has no result, it is ignored
    // if body is unreachable, it might be e.g. a return
    if (curr->body->type != unreachable) {
      shouldBeEqual(curr->result, curr->body->type, curr->body, "function body type must match, if function returns");
    }
    if (returnType != unreachable) {
      shouldBeEqual(curr->result, returnType, curr->body, "function result must match, if function has returns");
    }
    returnType = unreachable;
    labelNames.clear();
  }

  bool checkOffset(Expression* curr, Address add, Address max) {
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

  void visitMemory(Memory *curr) {
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
  void visitTable(Table* curr) {
    for (auto& segment : curr->segments) {
      shouldBeEqual(segment.offset->type, i32, segment.offset, "segment offset should be i32");
      shouldBeTrue(checkOffset(segment.offset, segment.data.size(), getModule()->table.initial * Table::kPageSize), segment.offset, "segment offset should be reasonable");
    }
  }
  void visitModule(Module *curr) {
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

  void doWalkFunction(Function* func) {
    PostWalker<WasmValidator>::doWalkFunction(func);
  }

  // helpers

  std::ostream& fail() {
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

  template<typename T>
  bool shouldBeTrue(bool result, T curr, const char* text) {
    if (!result) {
      fail() << "unexpected false: " << text << ", on \n" << curr << std::endl;
      valid = false;
      return false;
    }
    return result;
  }
  template<typename T>
  bool shouldBeFalse(bool result, T curr, const char* text) {
    if (result) {
      fail() << "unexpected true: " << text << ", on \n" << curr << std::endl;
      valid = false;
      return false;
    }
    return result;
  }

  template<typename T, typename S>
  bool shouldBeEqual(S left, S right, T curr, const char* text) {
    if (left != right) {
      fail() << "" << left << " != " << right << ": " << text << ", on \n";
      WasmPrinter::printExpression(curr, std::cerr, false, true) << std::endl;
      valid = false;
      return false;
    }
    return true;
  }
  template<typename T, typename S, typename U>
  bool shouldBeEqual(S left, S right, T curr, U other, const char* text) {
    if (left != right) {
      fail() << "" << left << " != " << right << ": " << text << ", on \n" << curr << " / " << other << std::endl;
      valid = false;
      return false;
    }
    return true;
  }

  template<typename T, typename S>
  bool shouldBeEqualOrFirstIsUnreachable(S left, S right, T curr, const char* text) {
    if (left != unreachable && left != right) {
      fail() << "" << left << " != " << right << ": " << text << ", on \n";
      WasmPrinter::printExpression(curr, std::cerr, false, true) << std::endl;
      valid = false;
      return false;
    }
    return true;
  }

  template<typename T, typename S>
  bool shouldBeUnequal(S left, S right, T curr, const char* text) {
    if (left == right) {
      fail() << "" << left << " == " << right << ": " << text << ", on \n" << curr << std::endl;
      valid = false;
      return false;
    }
    return true;
  }

  void validateAlignment(size_t align, WasmType type, Index bytes) {
    switch (align) {
      case 1:
      case 2:
      case 4:
      case 8: break;
      default:{
        fail() << "bad alignment: " << align << std::endl;
        valid = false;
        break;
      }
    }
    shouldBeTrue(align <= bytes, align, "alignment must not exceed natural");
    switch (type) {
      case i32:
      case f32: {
        shouldBeTrue(align <= 4, align, "alignment must not exceed natural");
        break;
      }
      case i64:
      case f64: {
        shouldBeTrue(align <= 8, align, "alignment must not exceed natural");
        break;
      }
      default: {}
    }
  }

  void validateBinaryenIR(Module& wasm) {
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
            parent.fail() << "stale type found in " << (getFunction() ? getFunction()->name : Name("(global scope)")) << " on " << curr << "\n(marked as " << printWasmType(oldType) << ", should be " << printWasmType(newType) << ")\n";
            parent.valid = false;
          }
          curr->type = oldType;
        }
      }
    };
    BinaryenIRValidator binaryenIRValidator(*this);
    binaryenIRValidator.walkModule(&wasm);
  }
};

} // namespace wasm

#endif // wasm_wasm_validator_h
