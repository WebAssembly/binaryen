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

#ifndef wasm_wasm_validator_h
#define wasm_wasm_validator_h

#include "wasm.h"
#include "wasm-printing.h"

namespace wasm {

struct WasmValidator : public PostWalker<WasmValidator, Visitor<WasmValidator>> {
  bool valid;

  std::map<Name, WasmType> breakTypes; // breaks to a label must all have the same type, and the right type
  WasmType returnType = unreachable; // type used in returns

public:
  bool validate(Module& module) {
    valid = true;
    startWalk(&module);
    return valid;
  }

  // visitors

  void visitBlock(Block *curr) {
    // if we are break'ed to, then the value must be right for us
    if (curr->name.is()) {
      // none or unreachable means a poison value that we should ignore - if consumed, it will error
      if (breakTypes.count(curr->name) > 0 && isConcreteWasmType(breakTypes[curr->name]) && isConcreteWasmType(curr->type)) {
        shouldBeEqual(curr->type, breakTypes[curr->name], curr, "block+breaks must have right type if breaks return a value");
      }
      breakTypes.erase(curr->name);
    }
  }
  void visitIf(If *curr) {
    shouldBeTrue(curr->condition->type == unreachable || curr->condition->type == i32 || curr->condition->type == i64, curr, "if condition must be valid");
  }
  void visitLoop(Loop *curr) {
    if (curr->in.is()) {
      breakTypes.erase(curr->in);
    }
    if (curr->out.is()) {
      breakTypes.erase(curr->out);
    }
  }
  void noteBreak(Name name, Expression* value) {
    WasmType valueType = none;
    if (value) {
      valueType = value->type;
    }
    if (breakTypes.count(name) == 0) {
      breakTypes[name] = valueType;
    } else {
      if (breakTypes[name] == unreachable) {
        breakTypes[name] = valueType;
      } else if (valueType != unreachable) {
        if (valueType != breakTypes[name]) {
          breakTypes[name] = none; // a poison value that must not be consumed
        }
      }
    }
  }
  void visitBreak(Break *curr) {
    noteBreak(curr->name, curr->value);
    if (curr->condition) {
      shouldBeTrue(curr->condition->type == unreachable || curr->condition->type == i32, curr, "break condition must be i32");
    }
  }
  void visitSwitch(Switch *curr) {
    for (auto& target : curr->targets) {
      noteBreak(target, curr->value);
    }
    noteBreak(curr->default_, curr->value);
    shouldBeTrue(curr->condition->type == unreachable || curr->condition->type == i32, curr, "br_table condition must be i32");
  }
  void visitCall(Call *curr) {
    auto* target = getModule()->getFunction(curr->target);
    shouldBeTrue(curr->operands.size() == target->params.size(), curr, "call param number must match");
    for (size_t i = 0; i < curr->operands.size(); i++) {
      shouldBeEqualOrFirstIsUnreachable(curr->operands[i]->type, target->params[i], curr, "call param types must match");
    }
  }
  void visitCallImport(CallImport *curr) {
    auto* target = getModule()->getImport(curr->target)->type;
    shouldBeTrue(curr->operands.size() == target->params.size(), curr, "call param number must match");
    for (size_t i = 0; i < curr->operands.size(); i++) {
      shouldBeEqualOrFirstIsUnreachable(curr->operands[i]->type, target->params[i], curr, "call param types must match");
    }
  }
  void visitCallIndirect(CallIndirect *curr) {
    auto* type = curr->fullType;
    shouldBeEqualOrFirstIsUnreachable(curr->target->type, i32, curr, "indirect call target must be an i32");
    shouldBeTrue(curr->operands.size() == type->params.size(), curr, "call param number must match");
    for (size_t i = 0; i < curr->operands.size(); i++) {
      shouldBeEqualOrFirstIsUnreachable(curr->operands[i]->type, type->params[i], curr, "call param types must match");
    }
  }
  void visitSetLocal(SetLocal *curr) {
    if (curr->value->type != unreachable) {
      shouldBeEqualOrFirstIsUnreachable(curr->value->type, curr->type, curr, "set_local type must be correct");
    }
  }
  void visitLoad(Load *curr) {
    validateAlignment(curr->align);
    shouldBeEqualOrFirstIsUnreachable(curr->ptr->type, i32, curr, "load pointer type must be i32");
  }
  void visitStore(Store *curr) {
    validateAlignment(curr->align);
    shouldBeEqualOrFirstIsUnreachable(curr->ptr->type, i32, curr, "store pointer type must be i32");
    shouldBeEqualOrFirstIsUnreachable(curr->value->type, curr->type, curr, "store value type must match");
  }
  void visitBinary(Binary *curr) {
    if (curr->left->type != unreachable && curr->right->type != unreachable) {
      shouldBeEqual(curr->left->type, curr->right->type, curr, "binary child types must be equal");
    }
  }
  void visitUnary(Unary *curr) {
    shouldBeUnequal(curr->value->type, none, curr, "unaries must not receive a none as their input");
    switch (curr->op) {
      case EqZInt32:
      case EqZInt64: {
        shouldBeEqual(curr->type, i32, curr, "eqz must return i32");
        break;
      }
      default: {}
    }
    if (curr->value->type == unreachable) return;
    switch (curr->op) {
      case ClzInt32:
      case CtzInt32:
      case PopcntInt32:
      case NegFloat32:
      case AbsFloat32:
      case CeilFloat32:
      case FloorFloat32:
      case TruncFloat32:
      case NearestFloat32:
      case SqrtFloat32:
      case ClzInt64:
      case CtzInt64:
      case PopcntInt64:
      case NegFloat64:
      case AbsFloat64:
      case CeilFloat64:
      case FloorFloat64:
      case TruncFloat64:
      case NearestFloat64:
      case SqrtFloat64: {
        if (curr->value->type != unreachable) {
          shouldBeEqual(curr->value->type, curr->type, curr, "non-conversion unaries must return the same type");
        }
        break;
      }
      case EqZInt32:
      case EqZInt64: {
        shouldBeTrue(curr->value->type == i32 || curr->value->type == i64, curr, "eqz input must be i32 or i64");
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

  void visitReturn(Return* curr) {
    if (curr->value) {
      if (returnType == unreachable) {
        returnType = curr->value->type;
      } else if (curr->value->type != unreachable && returnType != curr->value->type) {
        returnType = none; // poison
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

  void visitFunction(Function *curr) {
    // if function has no result, it is ignored
    // if body is unreachable, it might be e.g. a return
    if (curr->result != none) {
      if (curr->body->type != unreachable) {
        shouldBeEqual(curr->result, curr->body->type, curr->body, "function body type must match, if function returns");
      }
      if (returnType != unreachable) {
        shouldBeEqual(curr->result, returnType, curr->body, "function result must match, if function returns");
      }
    }
    returnType = unreachable;
  }
  void visitMemory(Memory *curr) {
    shouldBeFalse(curr->initial > curr->max, "memory", "memory max >= initial");
    shouldBeTrue(curr->max <= Memory::kMaxSize, "memory", "total memory must be <= 4GB");
    size_t top = 0;
    for (auto& segment : curr->segments) {
      shouldBeFalse(segment.offset < top, "memory", "segment offset is small enough");
      top = segment.offset + segment.data.size();
    }
    shouldBeFalse(top > curr->initial * Memory::kPageSize, "memory", "total segments must be small enough");
  }
  void visitModule(Module *curr) {
    // exports
    std::set<Name> exportNames;
    for (auto& exp : curr->exports) {
      Name name = exp->value;
      bool found = false;
      for (auto& func : curr->functions) {
        if (func->name == name) {
          found = true;
          break;
        }
      }
      shouldBeTrue(found, name, "module exports must be found");
      Name exportName = exp->name;
      shouldBeFalse(exportNames.count(exportName) > 0, exportName, "module exports must be unique");
      exportNames.insert(exportName);
    }
    // start
    if (curr->start.is()) {
      auto func = curr->checkFunction(curr->start);
      if (shouldBeTrue(func != nullptr, curr->start, "start must be found")) {
        shouldBeTrue(func->params.size() == 0, curr, "start must have 0 params");
        shouldBeTrue(func->result == none, curr, "start must not return a value");
      }
    }
  }

  void walk(Expression*& root) {
    //std::cerr << "start a function " << getFunction()->name << "\n";
    PostWalker<WasmValidator, Visitor<WasmValidator>>::walk(root);
    shouldBeTrue(breakTypes.size() == 0, "break targets", "all break targets must be valid");
  }

private:

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
      fail() << "" << left << " != " << right << ": " << text << ", on \n" << curr << std::endl;
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
      fail() << "" << left << " != " << right << ": " << text << ", on \n" << curr << std::endl;
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

  void validateAlignment(size_t align) {
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
  }
};

} // namespace wasm

#endif // wasm_wasm_validator_h
