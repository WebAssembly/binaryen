
//
// Simple WebAssembly module validator.
//

#include "wasm.h"

namespace wasm {

struct WasmValidator : public WasmWalker {
  bool valid;

public:
  bool validate(Module& module) {
    valid = true;
    startWalk(&module);
    return valid;
  }

  // visitors

  void visitLoop(Loop *curr) override {
    if (curr->in.is()) {
      // the "in" label has a none type, since no one can receive its value. make sure no one breaks to it with a value.
      struct ChildChecker : public WasmWalker {
        Name in;
        bool valid = true;

        ChildChecker(Name in) : in(in) {}

        void visitBreak(Break *curr) override {
          if (curr->name == in && curr->value) {
            valid = false;
          }
        }
      };
      ChildChecker childChecker(curr->in);
      childChecker.walk(curr->body);
      shouldBeTrue(childChecker.valid);
    }
  }
  void visitSetLocal(SetLocal *curr) override {
    shouldBeTrue(curr->type == curr->value->type);
  }
  void visitLoad(Load *curr) override {
    validateAlignment(curr->align);
  }
  void visitStore(Store *curr) override {
    validateAlignment(curr->align);
  }
  void visitSwitch(Switch *curr) override {
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
  void visitUnary(Unary *curr) override {
    shouldBeTrue(curr->value->type == curr->type);
  }
  void visitMemory(Memory *curr) override {
    shouldBeFalse(curr->initial > curr->max);
    size_t top = 0;
    for (auto segment : curr->segments) {
      shouldBeFalse(segment.offset < top);
      top = segment.offset + segment.size;
    }
    shouldBeFalse(top > curr->initial);
  }
  void visitModule(Module *curr) override {
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

