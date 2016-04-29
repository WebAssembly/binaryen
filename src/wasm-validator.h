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
      } else {
        shouldBeEqual(valueType, breakTypes[name], name.str, "breaks to same target must have same type (ignoring unreachable)");
      }
    }
  }
  void visitBreak(Break *curr) {
    noteBreak(curr->name, curr->value);
  }
  void visitSwitch(Switch *curr) {
    for (auto& target : curr->targets) {
      noteBreak(target, curr->value);
    }
    noteBreak(curr->default_, curr->value);
  }
  void visitSetLocal(SetLocal *curr) {
    shouldBeTrue(curr->type == curr->value->type, curr, "set_local type might be correct");
  }
  void visitLoad(Load *curr) {
    validateAlignment(curr->align);
  }
  void visitStore(Store *curr) {
    validateAlignment(curr->align);
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
        //if (curr->value->type != unreachable) {
          shouldBeEqual(curr->value->type, curr->type, curr, "non-conversion unaries must return the same type");
        //}
        break;
      }
      case EqZ: {
        shouldBeEqual(curr->type, i32, curr, "relational unaries must return i32");
        break;
      }
      case ExtendSInt32:
      case ExtendUInt32:
      case WrapInt64:
      case TruncSFloat32:
      case TruncUFloat32:
      case TruncSFloat64:
      case TruncUFloat64:
      case ReinterpretFloat:
      case ConvertUInt32:
      case ConvertSInt32:
      case ConvertUInt64:
      case ConvertSInt64:
      case PromoteFloat32:
      case DemoteFloat64:
      case ReinterpretInt: {
        //if (curr->value->type != unreachable) {
          shouldBeUnequal(curr->value->type, curr->type, curr, "conversion unaries must not return the same type");
        //}
        break;
      }
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
      if (shouldBeTrue(func, curr->start, "start must be found")) {
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
      fail() << "unexpected false: " << text << ", on " << curr << std::endl;
      valid = false;
      return false;
    }
    return result;
  }
  template<typename T>
  bool shouldBeFalse(bool result, T curr, const char* text) {
    if (result) {
      fail() << "unexpected true: " << text << ", on " << curr << std::endl;
      valid = false;
      return false;
    }
    return result;
  }

  template<typename T, typename S>
  bool shouldBeEqual(S left, S right, T curr, const char* text) {
    if (left != right) {
      fail() << "" << left << " != " << right << ": " << text << ", on " << curr << std::endl;
      valid = false;
      return false;
    }
    return true;
  }
  template<typename T, typename S, typename U>
  bool shouldBeEqual(S left, S right, T curr, U other, const char* text) {
    if (left != right) {
      fail() << "" << left << " != " << right << ": " << text << ", on " << curr << " / " << other << std::endl;
      valid = false;
      return false;
    }
    return true;
  }

  template<typename T, typename S>
  bool shouldBeUnequal(S left, S right, T curr, const char* text) {
    if (left == right) {
      fail() << "" << left << " == " << right << ": " << text << ", on " << curr << std::endl;
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
