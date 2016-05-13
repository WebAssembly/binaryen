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
    shouldBeTrue(curr->condition->type == unreachable || curr->condition->type == i32, curr, "if condition must be i32");
  }
  void visitLoop(Loop *curr) {
    if (curr->in.is()) {
      LoopChildChecker childChecker(curr->in);
      childChecker.walk(curr->body);
      shouldBeTrue(childChecker.valid, curr, "loop must return none");
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
    for (size_t i = 0; i < curr->operands.size(); i++) {
      shouldBeTrue(curr->operands[i]->type == target->params[i], curr, "call param types must match");
    }
  }
  void visitCallImport(CallImport *curr) {
    auto* target = getModule()->getImport(curr->target)->type;
    for (size_t i = 0; i < curr->operands.size(); i++) {
      shouldBeTrue(curr->operands[i]->type == target->params[i], curr, "call param types must match");
    }
  }
  void visitSetLocal(SetLocal *curr) {
    if (curr->value->type != unreachable) {
      shouldBeEqual(curr->type, curr->value->type, curr, "set_local type must be correct");
    }
  }
  void visitLoad(Load *curr) {
    validateAlignment(curr->align);
    shouldBeEqual(curr->ptr->type, i32, curr, "load pointer type must be i32");
  }
  void visitStore(Store *curr) {
    validateAlignment(curr->align);
    shouldBeEqual(curr->ptr->type, i32, curr, "store pointer type must be i32");
    shouldBeEqual(curr->value->type, curr->type, curr, "store value type must match");
  }
  void visitBinary(Binary *curr) {
    if (curr->left->type != unreachable && curr->right->type != unreachable) {
      shouldBeEqual(curr->left->type, curr->right->type, curr, "binary child types must be equal");
    }
  }
  void visitUnary(Unary *curr) {
    switch (curr->op) {
      case Clz:
      case Ctz:
      case Popcnt:
      case Neg:
      case Abs:
      case Ceil:
      case Floor:
      case Trunc:
      case Nearest:
      case Sqrt: {
        if (curr->value->type != unreachable) {
          shouldBeEqual(curr->value->type, curr->type, curr, "non-conversion unaries must return the same type");
        }
        break;
      }
      case EqZ: {
        shouldBeEqual(curr->type, i32, curr, "relational unaries must return i32");
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

  void visitFunction(Function *curr) {
    // if function has no result, it is ignored
    // if body is unreachable, it might be e.g. a return
    if (curr->result != none && curr->body->type != unreachable) {
      shouldBeEqual(curr->result, curr->body->type, curr->body, "function result must match, if function returns");
    }
  }
  void visitMemory(Memory *curr) {
    shouldBeFalse(curr->initial > curr->max, "memory", "memory max >= initial");
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

  // the "in" label has a none type, since no one can receive its value. make sure no one breaks to it with a value.
  struct LoopChildChecker : public PostWalker<LoopChildChecker, Visitor<LoopChildChecker>> {
    Name in;
    bool valid = true;

    LoopChildChecker(Name in) : in(in) {}

    void visitBreak(Break *curr) {
      if (curr->name == in && curr->value) {
        valid = false;
      }
    }
  };

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
