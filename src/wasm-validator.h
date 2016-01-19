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

struct WasmValidator : public WasmWalker<WasmValidator> {
  bool valid;

public:
  bool validate(Module& module) {
    valid = true;
    startWalk(&module);
    return valid;
  }

  // visitors

  void visitLoop(Loop *curr) {
    if (curr->in.is()) {
      LoopChildChecker childChecker(curr->in);
      childChecker.walk(curr->body);
      shouldBeTrue(childChecker.valid);
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
    std::set<Name> inTable;
    for (auto target : curr->targets) {
      if (target.is()) {
        inTable.insert(target);
      }
    }
    for (auto& c : curr->cases) {
      shouldBeFalse(c.name.is() && inTable.find(c.name) == inTable.end());
    }
    shouldBeFalse(curr->default_.is() && inTable.find(curr->default_) == inTable.end());
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
  }

private:

  // the "in" label has a none type, since no one can receive its value. make sure no one breaks to it with a value.
  struct LoopChildChecker : public WasmWalker<LoopChildChecker> {
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

  void shouldBeTrue(bool result) {
    if (!result) valid = false;
  }
  void shouldBeFalse(bool result) {
    if (result) valid = false;
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
