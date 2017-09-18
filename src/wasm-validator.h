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
#include <sstream>
#include <unordered_set>

#include "wasm.h"
#include "wasm-printing.h"

namespace wasm {

// Print anything that can be streamed to an ostream
template <typename T,
  typename std::enable_if<
    !std::is_base_of<Expression, typename std::remove_pointer<T>::type>::value
  >::type* = nullptr>
inline std::ostream& printModuleComponent(T curr, std::ostream& stream) {
  stream << curr << std::endl;
  return stream;
}
// Extra overload for Expressions, to print type info too
inline std::ostream& printModuleComponent(Expression* curr, std::ostream& stream) {
  WasmPrinter::printExpression(curr, stream, false, true) << std::endl;
  return stream;
}

struct WasmValidator : public PostWalker<WasmValidator> {
  bool valid = true;

  // what to validate, see comment up top
  bool validateWeb = false;
  bool validateGlobally = true;

  bool quiet = false; // whether to log errors verbosely

  struct BreakInfo {
    WasmType type;
    Index arity;
    BreakInfo() {}
    BreakInfo(WasmType type, Index arity) : type(type), arity(arity) {}
  };

  std::map<Name, Expression*> breakTargets;
  std::map<Expression*, BreakInfo> breakInfos;

  WasmType returnType = unreachable; // type used in returns

  std::set<Name> labelNames; // Binaryen IR requires that label names must be unique - IR generators must ensure that

  std::unordered_set<Expression*> seenExpressions; // expressions must not appear twice

  void noteLabelName(Name name);

public:
  // TODO: If we want the validator to be part of libwasm rather than libpasses, then
  // Using PassRunner::getPassDebug causes a circular dependence. We should fix that,
  // perhaps by moving some of the pass infrastructure into libsupport.
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
    if (!valid && !quiet) {
      WasmPrinter::printModule(&module, std::cerr);
    }
    return valid;
  }

  // visitors

  static void visitPreBlock(WasmValidator* self, Expression** currp) {
    auto* curr = (*currp)->cast<Block>();
    if (curr->name.is()) self->breakTargets[curr->name] = curr;
  }

  void visitBlock(Block *curr);

  static void visitPreLoop(WasmValidator* self, Expression** currp) {
    auto* curr = (*currp)->cast<Loop>();
    if (curr->name.is()) self->breakTargets[curr->name] = curr;
  }

  void visitLoop(Loop *curr);
  void visitIf(If *curr);

  // override scan to add a pre and a post check task to all nodes
  static void scan(WasmValidator* self, Expression** currp) {
    PostWalker<WasmValidator>::scan(self, currp);

    auto* curr = *currp;
    if (curr->is<Block>()) self->pushTask(visitPreBlock, currp);
    if (curr->is<Loop>()) self->pushTask(visitPreLoop, currp);
  }

  void noteBreak(Name name, Expression* value, Expression* curr);
  void visitBreak(Break *curr);
  void visitSwitch(Switch *curr);
  void visitCall(Call *curr);
  void visitCallImport(CallImport *curr);
  void visitCallIndirect(CallIndirect *curr);
  void visitGetLocal(GetLocal* curr);
  void visitSetLocal(SetLocal *curr);
  void visitLoad(Load *curr);
  void visitStore(Store *curr);
  void visitAtomicRMW(AtomicRMW *curr);
  void visitAtomicCmpxchg(AtomicCmpxchg *curr);
  void visitAtomicWait(AtomicWait *curr);
  void visitAtomicWake(AtomicWake *curr);
  void visitBinary(Binary *curr);
  void visitUnary(Unary *curr);
  void visitSelect(Select* curr);
  void visitDrop(Drop* curr);
  void visitReturn(Return* curr);
  void visitHost(Host* curr);
  void visitImport(Import* curr);
  void visitExport(Export* curr);
  void visitGlobal(Global* curr);
  void visitFunction(Function *curr);

  void visitMemory(Memory *curr);
  void visitTable(Table* curr);
  void visitModule(Module *curr);

  void doWalkFunction(Function* func) {
    PostWalker<WasmValidator>::doWalkFunction(func);
  }

  // helpers
 private:
  template <typename T, typename S>
  std::ostream& fail(S text, T curr);
  std::ostream& printFailureHeader();

  template<typename T>
  bool shouldBeTrue(bool result, T curr, const char* text) {
    if (!result) {
      fail("unexpected false: " + std::string(text), curr);
      return false;
    }
    return result;
  }
  template<typename T>
  bool shouldBeFalse(bool result, T curr, const char* text) {
    if (result) {
      fail("unexpected true: " + std::string(text), curr);
      return false;
    }
    return result;
  }

  template<typename T, typename S>
  bool shouldBeEqual(S left, S right, T curr, const char* text) {
    if (left != right) {
      std::ostringstream ss;
      ss << left << " != " << right << ": " << text;
      fail(ss.str(), curr);
      return false;
    }
    return true;
  }

  template<typename T, typename S>
  bool shouldBeEqualOrFirstIsUnreachable(S left, S right, T curr, const char* text) {
    if (left != unreachable && left != right) {
      std::ostringstream ss;
      ss << left << " != " << right << ": " << text;
      fail(ss.str(), curr);
      return false;
    }
    return true;
  }

  template<typename T, typename S>
  bool shouldBeUnequal(S left, S right, T curr, const char* text) {
    if (left == right) {
      std::ostringstream ss;
      ss << left << " == " << right << ": " << text;
      fail(ss.str(), curr);
      return false;
    }
    return true;
  }

  void shouldBeIntOrUnreachable(WasmType ty, Expression* curr, const char* text);
  void validateAlignment(size_t align, WasmType type, Index bytes, bool isAtomic,
                         Expression* curr);
  void validateMemBytes(uint8_t bytes, WasmType type, Expression* curr);
  void validateBinaryenIR(Module& wasm);
};

} // namespace wasm

#endif // wasm_wasm_validator_h
