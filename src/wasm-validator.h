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

namespace wasm {

struct WasmValidator : public PostWalker<WasmValidator> {
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
      if (breakTypes.count(curr->name) > 0) {
        shouldBeTrue(curr->type == breakTypes[curr->name]);
        breakTypes.erase(curr->name);
      }
    }
  }
  void visitLoop(Loop *curr) {
    if (curr->in.is()) {
      LoopChildChecker childChecker(curr->in);
      childChecker.walk(curr->body);
      shouldBeTrue(childChecker.valid);
    }
  }
  void visitBreak(Break *curr) {
    WasmType valueType = none;
    if (curr->value) {
      valueType = curr->value->type;
    }
    if (breakTypes.count(curr->name) == 0) {
      breakTypes[curr->name] = valueType;
    } else {
      shouldBeTrue(valueType == breakTypes[curr->name]);
    }
  }
  void visitSetLocal(SetLocal *curr) {
    shouldBeTrue(curr->type == curr->value->type);
  }
  void visitLoad(Load *curr) {
    validateAlignment(curr->align);
  }
  void visitStore(Store *curr) {
    validateAlignment(curr->align);
  }
  void visitSwitch(Switch *curr) {
  }
  void visitUnary(Unary *curr) {
    shouldBeTrue(curr->value->type == curr->type);
  }

  void visitFunction(Function *curr) {
    shouldBeTrue(curr->result == curr->body->type);
  }
  void visitMemory(Memory *curr) {
    shouldBeFalse(curr->initial > curr->max);
    size_t top = 0;
    for (auto segment : curr->segments) {
      shouldBeFalse(segment.offset < top);
      top = segment.offset + segment.size;
    }
    shouldBeFalse(top > curr->initial);
  }
  void visitModule(Module *curr) {
    // exports
    for (auto& exp : curr->exports) {
      Name name = exp->name;
      bool found = false;
      for (auto& func : curr->functions) {
        if (func->name == name) {
          found = true;
          break;
        }
      }
      shouldBeTrue(found);
    }
    // start
    if (curr->start.is()) {
      auto func = curr->checkFunction(curr->start);
      if (shouldBeTrue(func)) {
        shouldBeTrue(func->params.size() == 0); // must be nullary
      }
    }
  }

private:

  // the "in" label has a none type, since no one can receive its value. make sure no one breaks to it with a value.
  struct LoopChildChecker : public PostWalker<LoopChildChecker> {
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

  bool shouldBeTrue(bool result) {
    if (!result) valid = false;
    return result;
  }
  bool shouldBeFalse(bool result) {
    if (result) valid = false;
    return result;
  }

  void validateAlignment(size_t align) {
    switch (align) {
      case 1:
      case 2:
      case 4:
      case 8: break;
      default:{
        valid = false;
        break;
      }
    }
  }
};

} // namespace wasm

#endif // wasm_wasm_validator_h
