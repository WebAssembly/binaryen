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

#include <mutex>
#include <set>
#include <sstream>
#include <unordered_set>

#include "ir/branch-utils.h"
#include "ir/features.h"
#include "ir/module-utils.h"
#include "ir/utils.h"
#include "support/colors.h"
#include "wasm-printing.h"
#include "wasm-validator.h"
#include "wasm.h"

namespace wasm {

// Print anything that can be streamed to an ostream
template<typename T,
         typename std::enable_if<!std::is_base_of<
           Expression,
           typename std::remove_pointer<T>::type>::value>::type* = nullptr>
inline std::ostream& printModuleComponent(T curr, std::ostream& stream) {
  stream << curr << std::endl;
  return stream;
}

// Extra overload for Expressions, to print type info too
inline std::ostream& printModuleComponent(Expression* curr,
                                          std::ostream& stream) {
  WasmPrinter::printExpression(curr, stream, false, true) << std::endl;
  return stream;
}

// For parallel validation, we have a helper struct for coordination
struct ValidationInfo {
  bool validateWeb;
  bool validateGlobally;
  bool quiet;

  std::atomic<bool> valid;

  // a stream of error test for each function. we print in the right order at
  // the end, for deterministic output
  // note errors are rare/unexpected, so it's ok to use a slow mutex here
  std::mutex mutex;
  std::unordered_map<Function*, std::unique_ptr<std::ostringstream>> outputs;

  ValidationInfo() { valid.store(true); }

  std::ostringstream& getStream(Function* func) {
    std::unique_lock<std::mutex> lock(mutex);
    auto iter = outputs.find(func);
    if (iter != outputs.end()) {
      return *(iter->second.get());
    }
    auto& ret = outputs[func] = make_unique<std::ostringstream>();
    return *ret.get();
  }

  // printing and error handling support

  template<typename T, typename S>
  std::ostream& fail(S text, T curr, Function* func) {
    valid.store(false);
    auto& stream = getStream(func);
    if (quiet) {
      return stream;
    }
    auto& ret = printFailureHeader(func);
    ret << text << ", on \n";
    return printModuleComponent(curr, ret);
  }

  std::ostream& printFailureHeader(Function* func) {
    auto& stream = getStream(func);
    if (quiet) {
      return stream;
    }
    Colors::red(stream);
    if (func) {
      stream << "[wasm-validator error in function ";
      Colors::green(stream);
      stream << func->name;
      Colors::red(stream);
      stream << "] ";
    } else {
      stream << "[wasm-validator error in module] ";
    }
    Colors::normal(stream);
    return stream;
  }

  // checking utilities

  template<typename T>
  bool shouldBeTrue(bool result,
                    T curr,
                    const char* text,
                    Function* func = nullptr) {
    if (!result) {
      fail("unexpected false: " + std::string(text), curr, func);
      return false;
    }
    return result;
  }
  template<typename T>
  bool shouldBeFalse(bool result,
                     T curr,
                     const char* text,
                     Function* func = nullptr) {
    if (result) {
      fail("unexpected true: " + std::string(text), curr, func);
      return false;
    }
    return result;
  }

  template<typename T, typename S>
  bool shouldBeEqual(
    S left, S right, T curr, const char* text, Function* func = nullptr) {
    if (left != right) {
      std::ostringstream ss;
      ss << left << " != " << right << ": " << text;
      fail(ss.str(), curr, func);
      return false;
    }
    return true;
  }

  template<typename T, typename S>
  bool shouldBeEqualOrFirstIsUnreachable(
    S left, S right, T curr, const char* text, Function* func = nullptr) {
    if (left != unreachable && left != right) {
      std::ostringstream ss;
      ss << left << " != " << right << ": " << text;
      fail(ss.str(), curr, func);
      return false;
    }
    return true;
  }

  template<typename T, typename S>
  bool shouldBeUnequal(
    S left, S right, T curr, const char* text, Function* func = nullptr) {
    if (left == right) {
      std::ostringstream ss;
      ss << left << " == " << right << ": " << text;
      fail(ss.str(), curr, func);
      return false;
    }
    return true;
  }

  void shouldBeIntOrUnreachable(Type ty,
                                Expression* curr,
                                const char* text,
                                Function* func = nullptr) {
    switch (ty) {
      case i32:
      case i64:
      case unreachable: {
        break;
      }
      default:
        fail(text, curr, func);
    }
  }
};

struct FunctionValidator : public WalkerPass<PostWalker<FunctionValidator>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new FunctionValidator(&info); }

  bool modifiesBinaryenIR() override { return false; }

  ValidationInfo& info;

  FunctionValidator(ValidationInfo* info) : info(*info) {}

  struct BreakInfo {
    enum { UnsetArity = Index(-1), PoisonArity = Index(-2) };

    Type type;
    Index arity;
    BreakInfo() : arity(UnsetArity) {}
    BreakInfo(Type type, Index arity) : type(type), arity(arity) {}

    bool hasBeenSet() {
      // Compare to the impossible value.
      return arity != UnsetArity;
    }
  };

  std::unordered_map<Name, BreakInfo> breakInfos;

  Type returnType = unreachable; // type used in returns

  // Binaryen IR requires that label names must be unique - IR generators must
  // ensure that
  std::unordered_set<Name> labelNames;

  void noteLabelName(Name name);

public:
  // visitors

  static void visitPreBlock(FunctionValidator* self, Expression** currp) {
    auto* curr = (*currp)->cast<Block>();
    if (curr->name.is()) {
      self->breakInfos[curr->name];
    }
  }

  void visitBlock(Block* curr);

  static void visitPreLoop(FunctionValidator* self, Expression** currp) {
    auto* curr = (*currp)->cast<Loop>();
    if (curr->name.is()) {
      self->breakInfos[curr->name];
    }
  }

  void visitLoop(Loop* curr);
  void visitIf(If* curr);

  // override scan to add a pre and a post check task to all nodes
  static void scan(FunctionValidator* self, Expression** currp) {
    PostWalker<FunctionValidator>::scan(self, currp);

    auto* curr = *currp;
    if (curr->is<Block>()) {
      self->pushTask(visitPreBlock, currp);
    }
    if (curr->is<Loop>()) {
      self->pushTask(visitPreLoop, currp);
    }
  }

  void noteBreak(Name name, Expression* value, Expression* curr);
  void noteBreak(Name name, Type valueType, Expression* curr);
  void visitBreak(Break* curr);
  void visitSwitch(Switch* curr);
  void visitCall(Call* curr);
  void visitCallIndirect(CallIndirect* curr);
  void visitConst(Const* curr);
  void visitLocalGet(LocalGet* curr);
  void visitLocalSet(LocalSet* curr);
  void visitGlobalGet(GlobalGet* curr);
  void visitGlobalSet(GlobalSet* curr);
  void visitLoad(Load* curr);
  void visitStore(Store* curr);
  void visitAtomicRMW(AtomicRMW* curr);
  void visitAtomicCmpxchg(AtomicCmpxchg* curr);
  void visitAtomicWait(AtomicWait* curr);
  void visitAtomicNotify(AtomicNotify* curr);
  void visitAtomicFence(AtomicFence* curr);
  void visitSIMDExtract(SIMDExtract* curr);
  void visitSIMDReplace(SIMDReplace* curr);
  void visitSIMDShuffle(SIMDShuffle* curr);
  void visitSIMDTernary(SIMDTernary* curr);
  void visitSIMDShift(SIMDShift* curr);
  void visitSIMDLoad(SIMDLoad* curr);
  void visitMemoryInit(MemoryInit* curr);
  void visitDataDrop(DataDrop* curr);
  void visitMemoryCopy(MemoryCopy* curr);
  void visitMemoryFill(MemoryFill* curr);
  void visitBinary(Binary* curr);
  void visitUnary(Unary* curr);
  void visitSelect(Select* curr);
  void visitDrop(Drop* curr);
  void visitReturn(Return* curr);
  void visitHost(Host* curr);
  void visitTry(Try* curr);
  void visitThrow(Throw* curr);
  void visitRethrow(Rethrow* curr);
  void visitBrOnExn(BrOnExn* curr);
  void visitFunction(Function* curr);

  // helpers
private:
  std::ostream& getStream() { return info.getStream(getFunction()); }

  template<typename T>
  bool shouldBeTrue(bool result, T curr, const char* text) {
    return info.shouldBeTrue(result, curr, text, getFunction());
  }
  template<typename T>
  bool shouldBeFalse(bool result, T curr, const char* text) {
    return info.shouldBeFalse(result, curr, text, getFunction());
  }

  template<typename T, typename S>
  bool shouldBeEqual(S left, S right, T curr, const char* text) {
    return info.shouldBeEqual(left, right, curr, text, getFunction());
  }

  template<typename T, typename S>
  bool
  shouldBeEqualOrFirstIsUnreachable(S left, S right, T curr, const char* text) {
    return info.shouldBeEqualOrFirstIsUnreachable(
      left, right, curr, text, getFunction());
  }

  template<typename T, typename S>
  bool shouldBeUnequal(S left, S right, T curr, const char* text) {
    return info.shouldBeUnequal(left, right, curr, text, getFunction());
  }

  void shouldBeIntOrUnreachable(Type ty, Expression* curr, const char* text) {
    return info.shouldBeIntOrUnreachable(ty, curr, text, getFunction());
  }

  void validateAlignment(
    size_t align, Type type, Index bytes, bool isAtomic, Expression* curr);
  void validateMemBytes(uint8_t bytes, Type type, Expression* curr);
};

void FunctionValidator::noteLabelName(Name name) {
  if (!name.is()) {
    return;
  }
  bool inserted;
  std::tie(std::ignore, inserted) = labelNames.insert(name);
  shouldBeTrue(
    inserted,
    name,
    "names in Binaryen IR must be unique - IR generators must ensure that");
}

void FunctionValidator::visitBlock(Block* curr) {
  // if we are break'ed to, then the value must be right for us
  if (curr->name.is()) {
    noteLabelName(curr->name);
    auto iter = breakInfos.find(curr->name);
    assert(iter != breakInfos.end()); // we set it ourselves
    auto& info = iter->second;
    if (info.hasBeenSet()) {
      if (curr->type.isConcrete()) {
        shouldBeTrue(info.arity != 0,
                     curr,
                     "break arities must be > 0 if block has a value");
      } else {
        shouldBeTrue(info.arity == 0,
                     curr,
                     "break arities must be 0 if block has no value");
      }
      // none or unreachable means a poison value that we should ignore - if
      // consumed, it will error
      if (info.type.isConcrete() && curr->type.isConcrete()) {
        shouldBeEqual(
          curr->type,
          info.type,
          curr,
          "block+breaks must have right type if breaks return a value");
      }
      if (curr->type.isConcrete() && info.arity && info.type != unreachable) {
        shouldBeEqual(curr->type,
                      info.type,
                      curr,
                      "block+breaks must have right type if breaks have arity");
      }
      shouldBeTrue(
        info.arity != BreakInfo::PoisonArity, curr, "break arities must match");
      if (curr->list.size() > 0) {
        auto last = curr->list.back()->type;
        if (last.isConcrete() && info.type != unreachable) {
          shouldBeEqual(last,
                        info.type,
                        curr,
                        "block+breaks must have right type if block ends with "
                        "a reachable value");
        }
        if (last == none) {
          shouldBeTrue(info.arity == Index(0),
                       curr,
                       "if block ends with a none, breaks cannot send a value "
                       "of any type");
        }
      }
    }
    breakInfos.erase(iter);
  }
  if (curr->list.size() > 1) {
    for (Index i = 0; i < curr->list.size() - 1; i++) {
      if (!shouldBeTrue(
            !curr->list[i]->type.isConcrete(),
            curr,
            "non-final block elements returning a value must be drop()ed "
            "(binaryen's autodrop option might help you)") &&
          !info.quiet) {
        getStream() << "(on index " << i << ":\n"
                    << curr->list[i] << "\n), type: " << curr->list[i]->type
                    << "\n";
      }
    }
  }
  if (curr->list.size() > 0) {
    auto backType = curr->list.back()->type;
    if (!curr->type.isConcrete()) {
      shouldBeFalse(backType.isConcrete(),
                    curr,
                    "if block is not returning a value, final element should "
                    "not flow out a value");
    } else {
      if (backType.isConcrete()) {
        shouldBeEqual(
          curr->type,
          backType,
          curr,
          "block with value and last element with value must match types");
      } else {
        shouldBeUnequal(
          backType,
          none,
          curr,
          "block with value must not have last element that is none");
      }
    }
  }
  if (curr->type.isConcrete()) {
    shouldBeTrue(
      curr->list.size() > 0, curr, "block with a value must not be empty");
  }
}

void FunctionValidator::visitLoop(Loop* curr) {
  if (curr->name.is()) {
    noteLabelName(curr->name);
    auto iter = breakInfos.find(curr->name);
    assert(iter != breakInfos.end()); // we set it ourselves
    auto& info = iter->second;
    if (info.hasBeenSet()) {
      shouldBeEqual(
        info.arity, Index(0), curr, "breaks to a loop cannot pass a value");
    }
    breakInfos.erase(iter);
  }
  if (curr->type == none) {
    shouldBeFalse(curr->body->type.isConcrete(),
                  curr,
                  "bad body for a loop that has no value");
  }
}

void FunctionValidator::visitIf(If* curr) {
  shouldBeTrue(curr->condition->type == unreachable ||
                 curr->condition->type == i32,
               curr,
               "if condition must be valid");
  if (!curr->ifFalse) {
    shouldBeFalse(curr->ifTrue->type.isConcrete(),
                  curr,
                  "if without else must not return a value in body");
    if (curr->condition->type != unreachable) {
      shouldBeEqual(curr->type,
                    none,
                    curr,
                    "if without else and reachable condition must be none");
    }
  } else {
    if (curr->type != unreachable) {
      shouldBeEqualOrFirstIsUnreachable(
        curr->ifTrue->type,
        curr->type,
        curr,
        "returning if-else's true must have right type");
      shouldBeEqualOrFirstIsUnreachable(
        curr->ifFalse->type,
        curr->type,
        curr,
        "returning if-else's false must have right type");
    } else {
      if (curr->condition->type != unreachable) {
        shouldBeEqual(curr->ifTrue->type,
                      unreachable,
                      curr,
                      "unreachable if-else must have unreachable true");
        shouldBeEqual(curr->ifFalse->type,
                      unreachable,
                      curr,
                      "unreachable if-else must have unreachable false");
      }
    }
    if (curr->ifTrue->type.isConcrete()) {
      shouldBeEqual(curr->type,
                    curr->ifTrue->type,
                    curr,
                    "if type must match concrete ifTrue");
      shouldBeEqualOrFirstIsUnreachable(curr->ifFalse->type,
                                        curr->ifTrue->type,
                                        curr,
                                        "other arm must match concrete ifTrue");
    }
    if (curr->ifFalse->type.isConcrete()) {
      shouldBeEqual(curr->type,
                    curr->ifFalse->type,
                    curr,
                    "if type must match concrete ifFalse");
      shouldBeEqualOrFirstIsUnreachable(
        curr->ifTrue->type,
        curr->ifFalse->type,
        curr,
        "other arm must match concrete ifFalse");
    }
  }
}

void FunctionValidator::noteBreak(Name name,
                                  Expression* value,
                                  Expression* curr) {
  if (value) {
    shouldBeUnequal(value->type, none, curr, "breaks must have a valid value");
  }
  noteBreak(name, value ? value->type : none, curr);
}

void FunctionValidator::noteBreak(Name name, Type valueType, Expression* curr) {
  Index arity = 0;
  if (valueType != none) {
    arity = 1;
  }
  auto iter = breakInfos.find(name);
  if (!shouldBeTrue(
        iter != breakInfos.end(), curr, "all break targets must be valid")) {
    return;
  }
  auto& info = iter->second;
  if (!info.hasBeenSet()) {
    info = BreakInfo(valueType, arity);
  } else {
    if (info.type == unreachable) {
      info.type = valueType;
    } else if (valueType != unreachable) {
      if (valueType != info.type) {
        info.type = none; // a poison value that must not be consumed
      }
    }
    if (arity != info.arity) {
      info.arity = BreakInfo::PoisonArity;
    }
  }
}
void FunctionValidator::visitBreak(Break* curr) {
  noteBreak(curr->name, curr->value, curr);
  if (curr->value) {
    shouldBeTrue(
      curr->value->type != none, curr, "break value must not have none type");
  }
  if (curr->condition) {
    shouldBeTrue(curr->condition->type == unreachable ||
                   curr->condition->type == i32,
                 curr,
                 "break condition must be i32");
  }
}

void FunctionValidator::visitSwitch(Switch* curr) {
  for (auto& target : curr->targets) {
    noteBreak(target, curr->value, curr);
  }
  noteBreak(curr->default_, curr->value, curr);
  shouldBeTrue(curr->condition->type == unreachable ||
                 curr->condition->type == i32,
               curr,
               "br_table condition must be i32");
}

void FunctionValidator::visitCall(Call* curr) {
  shouldBeTrue(!curr->isReturn || getModule()->features.hasTailCall(),
               curr,
               "return_call requires tail calls to be enabled");
  if (!info.validateGlobally) {
    return;
  }
  auto* target = getModule()->getFunctionOrNull(curr->target);
  if (!shouldBeTrue(!!target, curr, "call target must exist")) {
    return;
  }
  const std::vector<Type> params = target->sig.params.expand();
  if (!shouldBeTrue(curr->operands.size() == params.size(),
                    curr,
                    "call param number must match")) {
    return;
  }
  for (size_t i = 0; i < curr->operands.size(); i++) {
    if (!shouldBeEqualOrFirstIsUnreachable(curr->operands[i]->type,
                                           params[i],
                                           curr,
                                           "call param types must match") &&
        !info.quiet) {
      getStream() << "(on argument " << i << ")\n";
    }
  }
  if (curr->isReturn) {
    shouldBeEqual(curr->type,
                  unreachable,
                  curr,
                  "return_call should have unreachable type");
    shouldBeEqual(
      getFunction()->sig.results,
      target->sig.results,
      curr,
      "return_call callee return type must match caller return type");
  } else {
    if (curr->type == unreachable) {
      bool hasUnreachableOperand =
        std::any_of(curr->operands.begin(),
                    curr->operands.end(),
                    [](Expression* op) { return op->type == unreachable; });
      shouldBeTrue(
        hasUnreachableOperand,
        curr,
        "calls may only be unreachable if they have unreachable operands");
    } else {
      shouldBeEqual(curr->type,
                    target->sig.results,
                    curr,
                    "call type must match callee return type");
    }
  }
}

void FunctionValidator::visitCallIndirect(CallIndirect* curr) {
  shouldBeTrue(!curr->isReturn || getModule()->features.hasTailCall(),
               curr,
               "return_call_indirect requires tail calls to be enabled");
  if (!info.validateGlobally) {
    return;
  }
  const std::vector<Type>& params = curr->sig.params.expand();
  shouldBeEqualOrFirstIsUnreachable(
    curr->target->type, i32, curr, "indirect call target must be an i32");
  if (!shouldBeTrue(curr->operands.size() == params.size(),
                    curr,
                    "call param number must match")) {
    return;
  }
  for (size_t i = 0; i < curr->operands.size(); i++) {
    if (!shouldBeEqualOrFirstIsUnreachable(curr->operands[i]->type,
                                           params[i],
                                           curr,
                                           "call param types must match") &&
        !info.quiet) {
      getStream() << "(on argument " << i << ")\n";
    }
  }
  if (curr->isReturn) {
    shouldBeEqual(curr->type,
                  unreachable,
                  curr,
                  "return_call_indirect should have unreachable type");
    shouldBeEqual(
      getFunction()->sig.results,
      curr->sig.results,
      curr,
      "return_call_indirect callee return type must match caller return type");
  } else {
    if (curr->type == unreachable) {
      if (curr->target->type != unreachable) {
        bool hasUnreachableOperand =
          std::any_of(curr->operands.begin(),
                      curr->operands.end(),
                      [](Expression* op) { return op->type == unreachable; });
        shouldBeTrue(hasUnreachableOperand,
                     curr,
                     "call_indirects may only be unreachable if they have "
                     "unreachable operands");
      }
    } else {
      shouldBeEqual(curr->type,
                    curr->sig.results,
                    curr,
                    "call_indirect type must match callee return type");
    }
  }
}

void FunctionValidator::visitConst(Const* curr) {
  shouldBeTrue(getFeatures(curr->type) <= getModule()->features,
               curr,
               "all used features should be allowed");
}

void FunctionValidator::visitLocalGet(LocalGet* curr) {
  shouldBeTrue(curr->type.isConcrete(),
               curr,
               "local.get must have a valid type - check what you provided "
               "when you constructed the node");
  if (shouldBeTrue(curr->index < getFunction()->getNumLocals(),
                   curr,
                   "local.get index must be small enough")) {
    shouldBeTrue(curr->type == getFunction()->getLocalType(curr->index),
                 curr,
                 "local.get must have proper type");
  }
}

void FunctionValidator::visitLocalSet(LocalSet* curr) {
  if (shouldBeTrue(curr->index < getFunction()->getNumLocals(),
                   curr,
                   "local.set index must be small enough")) {
    if (curr->value->type != unreachable) {
      if (curr->type != none) { // tee is ok anyhow
        shouldBeEqual(getFunction()->getLocalType(curr->index),
                      curr->type,
                      curr,
                      "local.set type must be correct");
      }
      shouldBeEqual(curr->value->type,
                    getFunction()->getLocalType(curr->index),
                    curr,
                    "local.set's value type must be correct");
    }
  }
}

void FunctionValidator::visitGlobalGet(GlobalGet* curr) {
  if (!info.validateGlobally) {
    return;
  }
  shouldBeTrue(getModule()->getGlobalOrNull(curr->name),
               curr,
               "global.get name must be valid");
}

void FunctionValidator::visitGlobalSet(GlobalSet* curr) {
  if (!info.validateGlobally) {
    return;
  }
  auto* global = getModule()->getGlobalOrNull(curr->name);
  if (shouldBeTrue(global,
                   curr,
                   "global.set name must be valid (and not an import; imports "
                   "can't be modified)")) {
    shouldBeTrue(global->mutable_, curr, "global.set global must be mutable");
    shouldBeEqualOrFirstIsUnreachable(curr->value->type,
                                      global->type,
                                      curr,
                                      "global.set value must have right type");
  }
}

void FunctionValidator::visitLoad(Load* curr) {
  shouldBeTrue(
    getModule()->memory.exists, curr, "Memory operations require a memory");
  if (curr->isAtomic) {
    shouldBeTrue(getModule()->features.hasAtomics(),
                 curr,
                 "Atomic operation (atomics are disabled)");
    shouldBeTrue(curr->type == i32 || curr->type == i64 ||
                   curr->type == unreachable,
                 curr,
                 "Atomic load should be i32 or i64");
  }
  if (curr->type == v128) {
    shouldBeTrue(getModule()->features.hasSIMD(),
                 curr,
                 "SIMD operation (SIMD is disabled)");
  }
  shouldBeFalse(curr->isAtomic && !getModule()->memory.shared,
                curr,
                "Atomic operation with non-shared memory");
  validateMemBytes(curr->bytes, curr->type, curr);
  validateAlignment(curr->align, curr->type, curr->bytes, curr->isAtomic, curr);
  shouldBeEqualOrFirstIsUnreachable(
    curr->ptr->type, i32, curr, "load pointer type must be i32");
  if (curr->isAtomic) {
    shouldBeFalse(curr->signed_, curr, "atomic loads must be unsigned");
    shouldBeIntOrUnreachable(
      curr->type, curr, "atomic loads must be of integers");
  }
}

void FunctionValidator::visitStore(Store* curr) {
  shouldBeTrue(
    getModule()->memory.exists, curr, "Memory operations require a memory");
  if (curr->isAtomic) {
    shouldBeTrue(getModule()->features.hasAtomics(),
                 curr,
                 "Atomic operation (atomics are disabled)");
    shouldBeTrue(curr->valueType == i32 || curr->valueType == i64 ||
                   curr->valueType == unreachable,
                 curr,
                 "Atomic store should be i32 or i64");
  }
  if (curr->valueType == v128) {
    shouldBeTrue(getModule()->features.hasSIMD(),
                 curr,
                 "SIMD operation (SIMD is disabled)");
  }
  shouldBeFalse(curr->isAtomic && !getModule()->memory.shared,
                curr,
                "Atomic operation with non-shared memory");
  validateMemBytes(curr->bytes, curr->valueType, curr);
  validateAlignment(
    curr->align, curr->valueType, curr->bytes, curr->isAtomic, curr);
  shouldBeEqualOrFirstIsUnreachable(
    curr->ptr->type, i32, curr, "store pointer type must be i32");
  shouldBeUnequal(
    curr->value->type, none, curr, "store value type must not be none");
  shouldBeEqualOrFirstIsUnreachable(
    curr->value->type, curr->valueType, curr, "store value type must match");
  if (curr->isAtomic) {
    shouldBeIntOrUnreachable(
      curr->valueType, curr, "atomic stores must be of integers");
  }
}

void FunctionValidator::visitAtomicRMW(AtomicRMW* curr) {
  shouldBeTrue(
    getModule()->memory.exists, curr, "Memory operations require a memory");
  shouldBeTrue(getModule()->features.hasAtomics(),
               curr,
               "Atomic operation (atomics are disabled)");
  shouldBeFalse(!getModule()->memory.shared,
                curr,
                "Atomic operation with non-shared memory");
  validateMemBytes(curr->bytes, curr->type, curr);
  shouldBeEqualOrFirstIsUnreachable(
    curr->ptr->type, i32, curr, "AtomicRMW pointer type must be i32");
  shouldBeEqualOrFirstIsUnreachable(curr->type,
                                    curr->value->type,
                                    curr,
                                    "AtomicRMW result type must match operand");
  shouldBeIntOrUnreachable(
    curr->type, curr, "Atomic operations are only valid on int types");
}

void FunctionValidator::visitAtomicCmpxchg(AtomicCmpxchg* curr) {
  shouldBeTrue(
    getModule()->memory.exists, curr, "Memory operations require a memory");
  shouldBeTrue(getModule()->features.hasAtomics(),
               curr,
               "Atomic operation (atomics are disabled)");
  shouldBeFalse(!getModule()->memory.shared,
                curr,
                "Atomic operation with non-shared memory");
  validateMemBytes(curr->bytes, curr->type, curr);
  shouldBeEqualOrFirstIsUnreachable(
    curr->ptr->type, i32, curr, "cmpxchg pointer type must be i32");
  if (curr->expected->type != unreachable &&
      curr->replacement->type != unreachable) {
    shouldBeEqual(curr->expected->type,
                  curr->replacement->type,
                  curr,
                  "cmpxchg operand types must match");
  }
  shouldBeEqualOrFirstIsUnreachable(curr->type,
                                    curr->expected->type,
                                    curr,
                                    "Cmpxchg result type must match expected");
  shouldBeEqualOrFirstIsUnreachable(
    curr->type,
    curr->replacement->type,
    curr,
    "Cmpxchg result type must match replacement");
  shouldBeIntOrUnreachable(curr->expected->type,
                           curr,
                           "Atomic operations are only valid on int types");
}

void FunctionValidator::visitAtomicWait(AtomicWait* curr) {
  shouldBeTrue(
    getModule()->memory.exists, curr, "Memory operations require a memory");
  shouldBeTrue(getModule()->features.hasAtomics(),
               curr,
               "Atomic operation (atomics are disabled)");
  shouldBeFalse(!getModule()->memory.shared,
                curr,
                "Atomic operation with non-shared memory");
  shouldBeEqualOrFirstIsUnreachable(
    curr->type, i32, curr, "AtomicWait must have type i32");
  shouldBeEqualOrFirstIsUnreachable(
    curr->ptr->type, i32, curr, "AtomicWait pointer type must be i32");
  shouldBeIntOrUnreachable(
    curr->expected->type, curr, "AtomicWait expected type must be int");
  shouldBeEqualOrFirstIsUnreachable(
    curr->expected->type,
    curr->expectedType,
    curr,
    "AtomicWait expected type must match operand");
  shouldBeEqualOrFirstIsUnreachable(
    curr->timeout->type, i64, curr, "AtomicWait timeout type must be i64");
}

void FunctionValidator::visitAtomicNotify(AtomicNotify* curr) {
  shouldBeTrue(
    getModule()->memory.exists, curr, "Memory operations require a memory");
  shouldBeTrue(getModule()->features.hasAtomics(),
               curr,
               "Atomic operation (atomics are disabled)");
  shouldBeFalse(!getModule()->memory.shared,
                curr,
                "Atomic operation with non-shared memory");
  shouldBeEqualOrFirstIsUnreachable(
    curr->type, i32, curr, "AtomicNotify must have type i32");
  shouldBeEqualOrFirstIsUnreachable(
    curr->ptr->type, i32, curr, "AtomicNotify pointer type must be i32");
  shouldBeEqualOrFirstIsUnreachable(
    curr->notifyCount->type,
    i32,
    curr,
    "AtomicNotify notifyCount type must be i32");
}

void FunctionValidator::visitAtomicFence(AtomicFence* curr) {
  shouldBeTrue(
    getModule()->memory.exists, curr, "Memory operations require a memory");
  shouldBeTrue(getModule()->features.hasAtomics(),
               curr,
               "Atomic operation (atomics are disabled)");
  shouldBeFalse(!getModule()->memory.shared,
                curr,
                "Atomic operation with non-shared memory");
  shouldBeTrue(curr->order == 0,
               curr,
               "Currently only sequentially consistent atomics are supported, "
               "so AtomicFence's order should be 0");
}

void FunctionValidator::visitSIMDExtract(SIMDExtract* curr) {
  shouldBeTrue(
    getModule()->features.hasSIMD(), curr, "SIMD operation (SIMD is disabled)");
  shouldBeEqualOrFirstIsUnreachable(
    curr->vec->type, v128, curr, "extract_lane must operate on a v128");
  Type lane_t = none;
  size_t lanes = 0;
  switch (curr->op) {
    case ExtractLaneSVecI8x16:
    case ExtractLaneUVecI8x16:
      lane_t = i32;
      lanes = 16;
      break;
    case ExtractLaneSVecI16x8:
    case ExtractLaneUVecI16x8:
      lane_t = i32;
      lanes = 8;
      break;
    case ExtractLaneVecI32x4:
      lane_t = i32;
      lanes = 4;
      break;
    case ExtractLaneVecI64x2:
      lane_t = i64;
      lanes = 2;
      break;
    case ExtractLaneVecF32x4:
      lane_t = f32;
      lanes = 4;
      break;
    case ExtractLaneVecF64x2:
      lane_t = f64;
      lanes = 2;
      break;
  }
  shouldBeEqualOrFirstIsUnreachable(
    curr->type,
    lane_t,
    curr,
    "extract_lane must have same type as vector lane");
  shouldBeTrue(curr->index < lanes, curr, "invalid lane index");
}

void FunctionValidator::visitSIMDReplace(SIMDReplace* curr) {
  shouldBeTrue(
    getModule()->features.hasSIMD(), curr, "SIMD operation (SIMD is disabled)");
  shouldBeEqualOrFirstIsUnreachable(
    curr->type, v128, curr, "replace_lane must have type v128");
  shouldBeEqualOrFirstIsUnreachable(
    curr->vec->type, v128, curr, "replace_lane must operate on a v128");
  Type lane_t = none;
  size_t lanes = 0;
  switch (curr->op) {
    case ReplaceLaneVecI8x16:
      lane_t = i32;
      lanes = 16;
      break;
    case ReplaceLaneVecI16x8:
      lane_t = i32;
      lanes = 8;
      break;
    case ReplaceLaneVecI32x4:
      lane_t = i32;
      lanes = 4;
      break;
    case ReplaceLaneVecI64x2:
      lane_t = i64;
      lanes = 2;
      break;
    case ReplaceLaneVecF32x4:
      lane_t = f32;
      lanes = 4;
      break;
    case ReplaceLaneVecF64x2:
      lane_t = f64;
      lanes = 2;
      break;
  }
  shouldBeEqualOrFirstIsUnreachable(
    curr->value->type, lane_t, curr, "unexpected value type");
  shouldBeTrue(curr->index < lanes, curr, "invalid lane index");
}

void FunctionValidator::visitSIMDShuffle(SIMDShuffle* curr) {
  shouldBeTrue(
    getModule()->features.hasSIMD(), curr, "SIMD operation (SIMD is disabled)");
  shouldBeEqualOrFirstIsUnreachable(
    curr->type, v128, curr, "v128.shuffle must have type v128");
  shouldBeEqualOrFirstIsUnreachable(
    curr->left->type, v128, curr, "expected operand of type v128");
  shouldBeEqualOrFirstIsUnreachable(
    curr->right->type, v128, curr, "expected operand of type v128");
  for (uint8_t index : curr->mask) {
    shouldBeTrue(index < 32, curr, "Invalid lane index in mask");
  }
}

void FunctionValidator::visitSIMDTernary(SIMDTernary* curr) {
  shouldBeTrue(
    getModule()->features.hasSIMD(), curr, "SIMD operation (SIMD is disabled)");
  shouldBeEqualOrFirstIsUnreachable(
    curr->type, v128, curr, "SIMD ternary must have type v128");
  shouldBeEqualOrFirstIsUnreachable(
    curr->a->type, v128, curr, "expected operand of type v128");
  shouldBeEqualOrFirstIsUnreachable(
    curr->b->type, v128, curr, "expected operand of type v128");
  shouldBeEqualOrFirstIsUnreachable(
    curr->c->type, v128, curr, "expected operand of type v128");
}

void FunctionValidator::visitSIMDShift(SIMDShift* curr) {
  shouldBeTrue(
    getModule()->features.hasSIMD(), curr, "SIMD operation (SIMD is disabled)");
  shouldBeEqualOrFirstIsUnreachable(
    curr->type, v128, curr, "vector shift must have type v128");
  shouldBeEqualOrFirstIsUnreachable(
    curr->vec->type, v128, curr, "expected operand of type v128");
  shouldBeEqualOrFirstIsUnreachable(
    curr->shift->type, i32, curr, "expected shift amount to have type i32");
}

void FunctionValidator::visitSIMDLoad(SIMDLoad* curr) {
  shouldBeTrue(
    getModule()->memory.exists, curr, "Memory operations require a memory");
  shouldBeTrue(
    getModule()->features.hasSIMD(), curr, "SIMD operation (SIMD is disabled)");
  shouldBeEqualOrFirstIsUnreachable(
    curr->type, v128, curr, "load_splat must have type v128");
  shouldBeEqualOrFirstIsUnreachable(
    curr->ptr->type, i32, curr, "load_splat address must have type i32");
  Type memAlignType = none;
  switch (curr->op) {
    case LoadSplatVec8x16:
    case LoadSplatVec16x8:
    case LoadSplatVec32x4:
      memAlignType = i32;
      break;
    case LoadSplatVec64x2:
    case LoadExtSVec8x8ToVecI16x8:
    case LoadExtUVec8x8ToVecI16x8:
    case LoadExtSVec16x4ToVecI32x4:
    case LoadExtUVec16x4ToVecI32x4:
    case LoadExtSVec32x2ToVecI64x2:
    case LoadExtUVec32x2ToVecI64x2:
      memAlignType = i64;
      break;
  }
  Index bytes = curr->getMemBytes();
  validateAlignment(curr->align, memAlignType, bytes, /*isAtomic=*/false, curr);
}

void FunctionValidator::visitMemoryInit(MemoryInit* curr) {
  shouldBeTrue(getModule()->features.hasBulkMemory(),
               curr,
               "Bulk memory operation (bulk memory is disabled)");
  shouldBeEqualOrFirstIsUnreachable(
    curr->type, none, curr, "memory.init must have type none");
  shouldBeEqualOrFirstIsUnreachable(
    curr->dest->type, i32, curr, "memory.init dest must be an i32");
  shouldBeEqualOrFirstIsUnreachable(
    curr->offset->type, i32, curr, "memory.init offset must be an i32");
  shouldBeEqualOrFirstIsUnreachable(
    curr->size->type, i32, curr, "memory.init size must be an i32");
  if (!shouldBeTrue(getModule()->memory.exists,
                    curr,
                    "Memory operations require a memory")) {
    return;
  }
  shouldBeTrue(curr->segment < getModule()->memory.segments.size(),
               curr,
               "memory.init segment index out of bounds");
}

void FunctionValidator::visitDataDrop(DataDrop* curr) {
  shouldBeTrue(getModule()->features.hasBulkMemory(),
               curr,
               "Bulk memory operation (bulk memory is disabled)");
  shouldBeEqualOrFirstIsUnreachable(
    curr->type, none, curr, "data.drop must have type none");
  if (!shouldBeTrue(getModule()->memory.exists,
                    curr,
                    "Memory operations require a memory")) {
    return;
  }
  shouldBeTrue(curr->segment < getModule()->memory.segments.size(),
               curr,
               "data.drop segment index out of bounds");
}

void FunctionValidator::visitMemoryCopy(MemoryCopy* curr) {
  shouldBeTrue(getModule()->features.hasBulkMemory(),
               curr,
               "Bulk memory operation (bulk memory is disabled)");
  shouldBeEqualOrFirstIsUnreachable(
    curr->type, none, curr, "memory.copy must have type none");
  shouldBeEqualOrFirstIsUnreachable(
    curr->dest->type, i32, curr, "memory.copy dest must be an i32");
  shouldBeEqualOrFirstIsUnreachable(
    curr->source->type, i32, curr, "memory.copy source must be an i32");
  shouldBeEqualOrFirstIsUnreachable(
    curr->size->type, i32, curr, "memory.copy size must be an i32");
  shouldBeTrue(
    getModule()->memory.exists, curr, "Memory operations require a memory");
}

void FunctionValidator::visitMemoryFill(MemoryFill* curr) {
  shouldBeTrue(getModule()->features.hasBulkMemory(),
               curr,
               "Bulk memory operation (bulk memory is disabled)");
  shouldBeEqualOrFirstIsUnreachable(
    curr->type, none, curr, "memory.fill must have type none");
  shouldBeEqualOrFirstIsUnreachable(
    curr->dest->type, i32, curr, "memory.fill dest must be an i32");
  shouldBeEqualOrFirstIsUnreachable(
    curr->value->type, i32, curr, "memory.fill value must be an i32");
  shouldBeEqualOrFirstIsUnreachable(
    curr->size->type, i32, curr, "memory.fill size must be an i32");
  shouldBeTrue(
    getModule()->memory.exists, curr, "Memory operations require a memory");
}

void FunctionValidator::validateMemBytes(uint8_t bytes,
                                         Type type,
                                         Expression* curr) {
  switch (type) {
    case i32:
      shouldBeTrue(bytes == 1 || bytes == 2 || bytes == 4,
                   curr,
                   "expected i32 operation to touch 1, 2, or 4 bytes");
      break;
    case i64:
      shouldBeTrue(bytes == 1 || bytes == 2 || bytes == 4 || bytes == 8,
                   curr,
                   "expected i64 operation to touch 1, 2, 4, or 8 bytes");
      break;
    case f32:
      shouldBeEqual(
        bytes, uint8_t(4), curr, "expected f32 operation to touch 4 bytes");
      break;
    case f64:
      shouldBeEqual(
        bytes, uint8_t(8), curr, "expected f64 operation to touch 8 bytes");
      break;
    case v128:
      shouldBeEqual(
        bytes, uint8_t(16), curr, "expected v128 operation to touch 16 bytes");
      break;
    case anyref: // anyref cannot be stored in memory
    case exnref: // exnref cannot be stored in memory
    case none:
      WASM_UNREACHABLE("unexpected type");
    case unreachable:
      break;
  }
}

void FunctionValidator::visitBinary(Binary* curr) {
  if (curr->left->type != unreachable && curr->right->type != unreachable) {
    shouldBeEqual(curr->left->type,
                  curr->right->type,
                  curr,
                  "binary child types must be equal");
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
    case EqVecI8x16:
    case NeVecI8x16:
    case LtSVecI8x16:
    case LtUVecI8x16:
    case LeSVecI8x16:
    case LeUVecI8x16:
    case GtSVecI8x16:
    case GtUVecI8x16:
    case GeSVecI8x16:
    case GeUVecI8x16:
    case EqVecI16x8:
    case NeVecI16x8:
    case LtSVecI16x8:
    case LtUVecI16x8:
    case LeSVecI16x8:
    case LeUVecI16x8:
    case GtSVecI16x8:
    case GtUVecI16x8:
    case GeSVecI16x8:
    case GeUVecI16x8:
    case EqVecI32x4:
    case NeVecI32x4:
    case LtSVecI32x4:
    case LtUVecI32x4:
    case LeSVecI32x4:
    case LeUVecI32x4:
    case GtSVecI32x4:
    case GtUVecI32x4:
    case GeSVecI32x4:
    case GeUVecI32x4:
    case EqVecF32x4:
    case NeVecF32x4:
    case LtVecF32x4:
    case LeVecF32x4:
    case GtVecF32x4:
    case GeVecF32x4:
    case EqVecF64x2:
    case NeVecF64x2:
    case LtVecF64x2:
    case LeVecF64x2:
    case GtVecF64x2:
    case GeVecF64x2:
    case AndVec128:
    case OrVec128:
    case XorVec128:
    case AndNotVec128:
    case AddVecI8x16:
    case AddSatSVecI8x16:
    case AddSatUVecI8x16:
    case SubVecI8x16:
    case SubSatSVecI8x16:
    case SubSatUVecI8x16:
    case MulVecI8x16:
    case MinSVecI8x16:
    case MinUVecI8x16:
    case MaxSVecI8x16:
    case MaxUVecI8x16:
    case AddVecI16x8:
    case AddSatSVecI16x8:
    case AddSatUVecI16x8:
    case SubVecI16x8:
    case SubSatSVecI16x8:
    case SubSatUVecI16x8:
    case MulVecI16x8:
    case MinSVecI16x8:
    case MinUVecI16x8:
    case MaxSVecI16x8:
    case MaxUVecI16x8:
    case AddVecI32x4:
    case SubVecI32x4:
    case MulVecI32x4:
    case MinSVecI32x4:
    case MinUVecI32x4:
    case MaxSVecI32x4:
    case MaxUVecI32x4:
    case DotSVecI16x8ToVecI32x4:
    case AddVecI64x2:
    case SubVecI64x2:
    case AddVecF32x4:
    case SubVecF32x4:
    case MulVecF32x4:
    case DivVecF32x4:
    case MinVecF32x4:
    case MaxVecF32x4:
    case AddVecF64x2:
    case SubVecF64x2:
    case MulVecF64x2:
    case DivVecF64x2:
    case MinVecF64x2:
    case MaxVecF64x2:
    case NarrowSVecI16x8ToVecI8x16:
    case NarrowUVecI16x8ToVecI8x16:
    case NarrowSVecI32x4ToVecI16x8:
    case NarrowUVecI32x4ToVecI16x8:
    case SwizzleVec8x16: {
      shouldBeEqualOrFirstIsUnreachable(
        curr->left->type, v128, curr, "v128 op");
      shouldBeEqualOrFirstIsUnreachable(
        curr->right->type, v128, curr, "v128 op");
      break;
    }
    case InvalidBinary:
      WASM_UNREACHABLE("invliad binary op");
  }
  shouldBeTrue(Features::get(curr->op) <= getModule()->features,
               curr,
               "all used features should be allowed");
}

void FunctionValidator::visitUnary(Unary* curr) {
  shouldBeUnequal(curr->value->type,
                  none,
                  curr,
                  "unaries must not receive a none as their input");
  if (curr->value->type == unreachable) {
    return; // nothing to check
  }
  switch (curr->op) {
    case ClzInt32:
    case CtzInt32:
    case PopcntInt32: {
      shouldBeEqual(
        curr->value->type, i32, curr, "i32 unary value type must be correct");
      break;
    }
    case ClzInt64:
    case CtzInt64:
    case PopcntInt64: {
      shouldBeEqual(
        curr->value->type, i64, curr, "i64 unary value type must be correct");
      break;
    }
    case NegFloat32:
    case AbsFloat32:
    case CeilFloat32:
    case FloorFloat32:
    case TruncFloat32:
    case NearestFloat32:
    case SqrtFloat32: {
      shouldBeEqual(
        curr->value->type, f32, curr, "f32 unary value type must be correct");
      break;
    }
    case NegFloat64:
    case AbsFloat64:
    case CeilFloat64:
    case FloorFloat64:
    case TruncFloat64:
    case NearestFloat64:
    case SqrtFloat64: {
      shouldBeEqual(
        curr->value->type, f64, curr, "f64 unary value type must be correct");
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
      shouldBeEqual(
        curr->value->type, i32, curr, "extend type must be correct");
      break;
    }
    case ExtendS8Int64:
    case ExtendS16Int64:
    case ExtendS32Int64: {
      shouldBeEqual(
        curr->value->type, i64, curr, "extend type must be correct");
      break;
    }
    case WrapInt64: {
      shouldBeEqual(curr->value->type, i64, curr, "wrap type must be correct");
      break;
    }
    case TruncSFloat32ToInt32:
    case TruncSFloat32ToInt64:
    case TruncUFloat32ToInt32:
    case TruncUFloat32ToInt64: {
      shouldBeEqual(curr->value->type, f32, curr, "trunc type must be correct");
      break;
    }
    case TruncSatSFloat32ToInt32:
    case TruncSatSFloat32ToInt64:
    case TruncSatUFloat32ToInt32:
    case TruncSatUFloat32ToInt64: {
      shouldBeEqual(curr->value->type, f32, curr, "trunc type must be correct");
      break;
    }
    case TruncSFloat64ToInt32:
    case TruncSFloat64ToInt64:
    case TruncUFloat64ToInt32:
    case TruncUFloat64ToInt64: {
      shouldBeEqual(curr->value->type, f64, curr, "trunc type must be correct");
      break;
    }
    case TruncSatSFloat64ToInt32:
    case TruncSatSFloat64ToInt64:
    case TruncSatUFloat64ToInt32:
    case TruncSatUFloat64ToInt64: {
      shouldBeEqual(curr->value->type, f64, curr, "trunc type must be correct");
      break;
    }
    case ReinterpretFloat32: {
      shouldBeEqual(
        curr->value->type, f32, curr, "reinterpret/f32 type must be correct");
      break;
    }
    case ReinterpretFloat64: {
      shouldBeEqual(
        curr->value->type, f64, curr, "reinterpret/f64 type must be correct");
      break;
    }
    case ConvertUInt32ToFloat32:
    case ConvertUInt32ToFloat64:
    case ConvertSInt32ToFloat32:
    case ConvertSInt32ToFloat64: {
      shouldBeEqual(
        curr->value->type, i32, curr, "convert type must be correct");
      break;
    }
    case ConvertUInt64ToFloat32:
    case ConvertUInt64ToFloat64:
    case ConvertSInt64ToFloat32:
    case ConvertSInt64ToFloat64: {
      shouldBeEqual(
        curr->value->type, i64, curr, "convert type must be correct");
      break;
    }
    case PromoteFloat32: {
      shouldBeEqual(
        curr->value->type, f32, curr, "promote type must be correct");
      break;
    }
    case DemoteFloat64: {
      shouldBeEqual(
        curr->value->type, f64, curr, "demote type must be correct");
      break;
    }
    case ReinterpretInt32: {
      shouldBeEqual(
        curr->value->type, i32, curr, "reinterpret/i32 type must be correct");
      break;
    }
    case ReinterpretInt64: {
      shouldBeEqual(
        curr->value->type, i64, curr, "reinterpret/i64 type must be correct");
      break;
    }
    case SplatVecI8x16:
    case SplatVecI16x8:
    case SplatVecI32x4:
      shouldBeEqual(curr->type, v128, curr, "expected splat to have v128 type");
      shouldBeEqual(curr->value->type, i32, curr, "expected i32 splat value");
      break;
    case SplatVecI64x2:
      shouldBeEqual(curr->type, v128, curr, "expected splat to have v128 type");
      shouldBeEqual(curr->value->type, i64, curr, "expected i64 splat value");
      break;
    case SplatVecF32x4:
      shouldBeEqual(curr->type, v128, curr, "expected splat to have v128 type");
      shouldBeEqual(curr->value->type, f32, curr, "expected f32 splat value");
      break;
    case SplatVecF64x2:
      shouldBeEqual(curr->type, v128, curr, "expected splat to have v128 type");
      shouldBeEqual(curr->value->type, f64, curr, "expected i64 splat value");
      break;
    case NotVec128:
    case NegVecI8x16:
    case NegVecI16x8:
    case NegVecI32x4:
    case NegVecI64x2:
    case AbsVecF32x4:
    case NegVecF32x4:
    case SqrtVecF32x4:
    case AbsVecF64x2:
    case NegVecF64x2:
    case SqrtVecF64x2:
    case TruncSatSVecF32x4ToVecI32x4:
    case TruncSatUVecF32x4ToVecI32x4:
    case TruncSatSVecF64x2ToVecI64x2:
    case TruncSatUVecF64x2ToVecI64x2:
    case ConvertSVecI32x4ToVecF32x4:
    case ConvertUVecI32x4ToVecF32x4:
    case ConvertSVecI64x2ToVecF64x2:
    case ConvertUVecI64x2ToVecF64x2:
    case WidenLowSVecI8x16ToVecI16x8:
    case WidenHighSVecI8x16ToVecI16x8:
    case WidenLowUVecI8x16ToVecI16x8:
    case WidenHighUVecI8x16ToVecI16x8:
    case WidenLowSVecI16x8ToVecI32x4:
    case WidenHighSVecI16x8ToVecI32x4:
    case WidenLowUVecI16x8ToVecI32x4:
    case WidenHighUVecI16x8ToVecI32x4:
      shouldBeEqual(curr->type, v128, curr, "expected v128 type");
      shouldBeEqual(curr->value->type, v128, curr, "expected v128 operand");
      break;
    case AnyTrueVecI8x16:
    case AllTrueVecI8x16:
    case AnyTrueVecI16x8:
    case AllTrueVecI16x8:
    case AnyTrueVecI32x4:
    case AllTrueVecI32x4:
    case AnyTrueVecI64x2:
    case AllTrueVecI64x2:
      shouldBeEqual(
        curr->type, i32, curr, "expected boolean reduction to have i32 type");
      shouldBeEqual(curr->value->type, v128, curr, "expected v128 operand");
      break;
    case InvalidUnary:
      WASM_UNREACHABLE("invalid unary op");
  }
  shouldBeTrue(Features::get(curr->op) <= getModule()->features,
               curr,
               "all used features should be allowed");
}

void FunctionValidator::visitSelect(Select* curr) {
  shouldBeUnequal(curr->ifTrue->type, none, curr, "select left must be valid");
  shouldBeUnequal(
    curr->ifFalse->type, none, curr, "select right must be valid");
  shouldBeTrue(curr->condition->type == unreachable ||
                 curr->condition->type == i32,
               curr,
               "select condition must be valid");
  if (curr->ifTrue->type != unreachable && curr->ifFalse->type != unreachable) {
    shouldBeEqual(curr->ifTrue->type,
                  curr->ifFalse->type,
                  curr,
                  "select sides must be equal");
  }
}

void FunctionValidator::visitDrop(Drop* curr) {
  shouldBeTrue(curr->value->type.isConcrete() ||
                 curr->value->type == unreachable,
               curr,
               "can only drop a valid value");
}

void FunctionValidator::visitReturn(Return* curr) {
  if (curr->value) {
    if (returnType == unreachable) {
      returnType = curr->value->type;
    } else if (curr->value->type != unreachable) {
      shouldBeEqual(
        curr->value->type, returnType, curr, "function results must match");
    }
  } else {
    returnType = none;
  }
}

void FunctionValidator::visitHost(Host* curr) {
  shouldBeTrue(
    getModule()->memory.exists, curr, "Memory operations require a memory");
  switch (curr->op) {
    case MemoryGrow: {
      shouldBeEqual(curr->operands.size(),
                    size_t(1),
                    curr,
                    "memory.grow must have 1 operand");
      shouldBeEqualOrFirstIsUnreachable(curr->operands[0]->type,
                                        i32,
                                        curr,
                                        "memory.grow must have i32 operand");
      break;
    }
    case MemorySize:
      break;
  }
}

void FunctionValidator::visitTry(Try* curr) {
  if (curr->type != unreachable) {
    shouldBeEqualOrFirstIsUnreachable(
      curr->body->type,
      curr->type,
      curr->body,
      "try's type does not match try body's type");
    shouldBeEqualOrFirstIsUnreachable(
      curr->catchBody->type,
      curr->type,
      curr->catchBody,
      "try's type does not match catch's body type");
  }
  if (curr->body->type.isConcrete()) {
    shouldBeEqualOrFirstIsUnreachable(
      curr->catchBody->type,
      curr->body->type,
      curr->catchBody,
      "try's body type must match catch's body type");
  }
  if (curr->catchBody->type.isConcrete()) {
    shouldBeEqualOrFirstIsUnreachable(
      curr->body->type,
      curr->catchBody->type,
      curr->body,
      "try's body type must match catch's body type");
  }
}

void FunctionValidator::visitThrow(Throw* curr) {
  if (!info.validateGlobally) {
    return;
  }
  shouldBeEqual(
    curr->type, unreachable, curr, "throw's type must be unreachable");
  auto* event = getModule()->getEventOrNull(curr->event);
  if (!shouldBeTrue(!!event, curr, "throw's event must exist")) {
    return;
  }
  if (!shouldBeTrue(curr->operands.size() == event->sig.params.size(),
                    curr,
                    "event's param numbers must match")) {
    return;
  }
  const std::vector<Type>& paramTypes = event->sig.params.expand();
  for (size_t i = 0; i < curr->operands.size(); i++) {
    if (!shouldBeEqualOrFirstIsUnreachable(curr->operands[i]->type,
                                           paramTypes[i],
                                           curr->operands[i],
                                           "event param types must match") &&
        !info.quiet) {
      getStream() << "(on argument " << i << ")\n";
    }
  }
}

void FunctionValidator::visitRethrow(Rethrow* curr) {
  shouldBeEqual(
    curr->type, unreachable, curr, "rethrow's type must be unreachable");
  shouldBeEqual(curr->exnref->type,
                exnref,
                curr->exnref,
                "rethrow's argument must be exnref type");
}

void FunctionValidator::visitBrOnExn(BrOnExn* curr) {
  Event* event = getModule()->getEventOrNull(curr->event);
  shouldBeTrue(event != nullptr, curr, "br_on_exn's event must exist");
  shouldBeTrue(event->sig.params == curr->sent,
               curr,
               "br_on_exn's event params and event's params are different");
  noteBreak(curr->name, curr->sent, curr);
  shouldBeTrue(curr->exnref->type == unreachable ||
                 curr->exnref->type == exnref,
               curr,
               "br_on_exn's argument must be unreachable or exnref type");
  if (curr->exnref->type == unreachable) {
    shouldBeTrue(curr->type == unreachable,
                 curr,
                 "If exnref argument's type is unreachable, br_on_exn should "
                 "be unreachable too");
  } else {
    shouldBeTrue(curr->type == exnref,
                 curr,
                 "br_on_exn's type should be exnref unless its exnref argument "
                 "is unreachable");
  }
}

void FunctionValidator::visitFunction(Function* curr) {
  shouldBeTrue(!curr->sig.results.isMulti(),
               curr->body,
               "Multivalue functions not allowed yet");
  FeatureSet features;
  for (auto type : curr->sig.params.expand()) {
    features |= getFeatures(type);
    shouldBeTrue(type.isConcrete(), curr, "params must be concretely typed");
  }
  for (auto type : curr->sig.results.expand()) {
    features |= getFeatures(type);
    shouldBeTrue(type.isConcrete(), curr, "results must be concretely typed");
  }
  for (auto type : curr->vars) {
    features |= getFeatures(type);
    shouldBeTrue(type.isConcrete(), curr, "vars must be concretely typed");
  }
  shouldBeTrue(features <= getModule()->features,
               curr,
               "all used types should be allowed");
  // if function has no result, it is ignored
  // if body is unreachable, it might be e.g. a return
  if (curr->body->type != unreachable) {
    shouldBeEqual(curr->sig.results,
                  curr->body->type,
                  curr->body,
                  "function body type must match, if function returns");
  }
  if (returnType != unreachable) {
    shouldBeEqual(curr->sig.results,
                  returnType,
                  curr->body,
                  "function result must match, if function has returns");
  }
  shouldBeTrue(
    breakInfos.empty(), curr->body, "all named break targets must exist");
  returnType = unreachable;
  labelNames.clear();
  // validate optional local names
  std::set<Name> seen;
  for (auto& pair : curr->localNames) {
    Name name = pair.second;
    shouldBeTrue(seen.insert(name).second, name, "local names must be unique");
  }
}

static bool checkOffset(Expression* curr, Address add, Address max) {
  if (curr->is<GlobalGet>()) {
    return true;
  }
  auto* c = curr->dynCast<Const>();
  if (!c) {
    return false;
  }
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

void FunctionValidator::validateAlignment(
  size_t align, Type type, Index bytes, bool isAtomic, Expression* curr) {
  if (isAtomic) {
    shouldBeEqual(align,
                  (size_t)bytes,
                  curr,
                  "atomic accesses must have natural alignment");
    return;
  }
  switch (align) {
    case 1:
    case 2:
    case 4:
    case 8:
    case 16:
      break;
    default: {
      info.fail("bad alignment: " + std::to_string(align), curr, getFunction());
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
    case v128:
    case unreachable:
      break;
    case anyref: // anyref cannot be stored in memory
    case exnref: // exnref cannot be stored in memory
    case none:
      WASM_UNREACHABLE("invalid type");
  }
}

static void validateBinaryenIR(Module& wasm, ValidationInfo& info) {
  struct BinaryenIRValidator
    : public PostWalker<BinaryenIRValidator,
                        UnifiedExpressionVisitor<BinaryenIRValidator>> {
    ValidationInfo& info;

    std::unordered_set<Expression*> seen;

    BinaryenIRValidator(ValidationInfo& info) : info(info) {}

    void visitExpression(Expression* curr) {
      auto scope = getFunction() ? getFunction()->name : Name("(global scope)");
      // check if a node type is 'stale', i.e., we forgot to finalize() the
      // node.
      auto oldType = curr->type;
      ReFinalizeNode().visit(curr);
      auto newType = curr->type;
      if (newType != oldType) {
        // We accept concrete => undefined,
        // e.g.
        //
        //  (drop (block (result i32) (unreachable)))
        //
        // The block has an added type, not derived from the ast itself, so it
        // is ok for it to be either i32 or unreachable.
        if (!(oldType.isConcrete() && newType == unreachable)) {
          std::ostringstream ss;
          ss << "stale type found in " << scope << " on " << curr
             << "\n(marked as " << oldType << ", should be " << newType
             << ")\n";
          info.fail(ss.str(), curr, getFunction());
        }
        curr->type = oldType;
      }
      // check if a node is a duplicate - expressions must not be seen more than
      // once
      bool inserted;
      std::tie(std::ignore, inserted) = seen.insert(curr);
      if (!inserted) {
        std::ostringstream ss;
        ss << "expression seen more than once in the tree in " << scope
           << " on " << curr << '\n';
        info.fail(ss.str(), curr, getFunction());
      }
    }
  };
  BinaryenIRValidator binaryenIRValidator(info);
  binaryenIRValidator.walkModule(&wasm);
}

// Main validator class

static void validateImports(Module& module, ValidationInfo& info) {
  ModuleUtils::iterImportedFunctions(module, [&](Function* curr) {
    if (info.validateWeb) {
      for (Type param : curr->sig.params.expand()) {
        info.shouldBeUnequal(param,
                             i64,
                             curr->name,
                             "Imported function must not have i64 parameters");
      }
      for (Type result : curr->sig.results.expand()) {
        info.shouldBeUnequal(result,
                             i64,
                             curr->name,
                             "Imported function must not have i64 results");
      }
    }
  });
  if (!module.features.hasMutableGlobals()) {
    ModuleUtils::iterImportedGlobals(module, [&](Global* curr) {
      info.shouldBeFalse(
        curr->mutable_, curr->name, "Imported global cannot be mutable");
    });
  }
}

static void validateExports(Module& module, ValidationInfo& info) {
  for (auto& curr : module.exports) {
    if (curr->kind == ExternalKind::Function) {
      if (info.validateWeb) {
        Function* f = module.getFunction(curr->value);
        for (auto param : f->sig.params.expand()) {
          info.shouldBeUnequal(
            param,
            i64,
            f->name,
            "Exported function must not have i64 parameters");
        }
        for (auto result : f->sig.results.expand()) {
          info.shouldBeUnequal(result,
                               i64,
                               f->name,
                               "Exported function must not have i64 results");
        }
      }
    } else if (curr->kind == ExternalKind::Global &&
               !module.features.hasMutableGlobals()) {
      if (Global* g = module.getGlobalOrNull(curr->value)) {
        info.shouldBeFalse(
          g->mutable_, g->name, "Exported global cannot be mutable");
      }
    }
  }
  std::unordered_set<Name> exportNames;
  for (auto& exp : module.exports) {
    Name name = exp->value;
    if (exp->kind == ExternalKind::Function) {
      info.shouldBeTrue(module.getFunctionOrNull(name),
                        name,
                        "module function exports must be found");
    } else if (exp->kind == ExternalKind::Global) {
      info.shouldBeTrue(module.getGlobalOrNull(name),
                        name,
                        "module global exports must be found");
    } else if (exp->kind == ExternalKind::Table) {
      info.shouldBeTrue(name == Name("0") || name == module.table.name,
                        name,
                        "module table exports must be found");
    } else if (exp->kind == ExternalKind::Memory) {
      info.shouldBeTrue(name == Name("0") || name == module.memory.name,
                        name,
                        "module memory exports must be found");
    } else if (exp->kind == ExternalKind::Event) {
      info.shouldBeTrue(module.getEventOrNull(name),
                        name,
                        "module event exports must be found");
    } else {
      WASM_UNREACHABLE("invalid ExternalKind");
    }
    Name exportName = exp->name;
    info.shouldBeFalse(exportNames.count(exportName) > 0,
                       exportName,
                       "module exports must be unique");
    exportNames.insert(exportName);
  }
}

static void validateGlobals(Module& module, ValidationInfo& info) {
  ModuleUtils::iterDefinedGlobals(module, [&](Global* curr) {
    info.shouldBeTrue(getFeatures(curr->type) <= module.features,
                      curr->name,
                      "all used types should be allowed");
    info.shouldBeTrue(
      curr->init != nullptr, curr->name, "global init must be non-null");
    assert(curr->init);
    info.shouldBeTrue(curr->init->is<Const>() || curr->init->is<GlobalGet>(),
                      curr->name,
                      "global init must be valid");
    if (!info.shouldBeEqual(curr->type,
                            curr->init->type,
                            curr->init,
                            "global init must have correct type") &&
        !info.quiet) {
      info.getStream(nullptr) << "(on global " << curr->name << ")\n";
    }
  });
}

static void validateMemory(Module& module, ValidationInfo& info) {
  auto& curr = module.memory;
  info.shouldBeFalse(
    curr.initial > curr.max, "memory", "memory max >= initial");
  info.shouldBeTrue(curr.initial <= Memory::kMaxSize,
                    "memory",
                    "initial memory must be <= 4GB");
  info.shouldBeTrue(!curr.hasMax() || curr.max <= Memory::kMaxSize,
                    "memory",
                    "max memory must be <= 4GB, or unlimited");
  info.shouldBeTrue(!curr.shared || curr.hasMax(),
                    "memory",
                    "shared memory must have max size");
  if (curr.shared) {
    info.shouldBeTrue(module.features.hasAtomics(),
                      "memory",
                      "memory is shared, but atomics are disabled");
  }
  for (auto& segment : curr.segments) {
    Index size = segment.data.size();
    if (segment.isPassive) {
      info.shouldBeTrue(module.features.hasBulkMemory(),
                        segment.offset,
                        "nonzero segment flags (bulk memory is disabled)");
      info.shouldBeEqual(segment.offset,
                         (Expression*)nullptr,
                         segment.offset,
                         "passive segment should not have an offset");
    } else {
      if (!info.shouldBeEqual(segment.offset->type,
                              i32,
                              segment.offset,
                              "segment offset should be i32")) {
        continue;
      }
      info.shouldBeTrue(checkOffset(segment.offset,
                                    segment.data.size(),
                                    curr.initial * Memory::kPageSize),
                        segment.offset,
                        "segment offset should be reasonable");
      if (segment.offset->is<Const>()) {
        Index start = segment.offset->cast<Const>()->value.geti32();
        Index end = start + size;
        info.shouldBeTrue(end <= curr.initial * Memory::kPageSize,
                          segment.data.size(),
                          "segment size should fit in memory (end)");
      }
    }
    // If the memory is imported we don't actually know its initial size.
    // Specifically wasm dll's import a zero sized memory which is perfectly
    // valid.
    if (!curr.imported()) {
      info.shouldBeTrue(size <= curr.initial * Memory::kPageSize,
                        segment.data.size(),
                        "segment size should fit in memory (initial)");
    }
  }
}

static void validateTable(Module& module, ValidationInfo& info) {
  auto& curr = module.table;
  for (auto& segment : curr.segments) {
    info.shouldBeEqual(segment.offset->type,
                       i32,
                       segment.offset,
                       "segment offset should be i32");
    info.shouldBeTrue(checkOffset(segment.offset,
                                  segment.data.size(),
                                  module.table.initial * Table::kPageSize),
                      segment.offset,
                      "segment offset should be reasonable");
    for (auto name : segment.data) {
      info.shouldBeTrue(
        module.getFunctionOrNull(name), name, "segment name should be valid");
    }
  }
}

static void validateEvents(Module& module, ValidationInfo& info) {
  if (!module.events.empty()) {
    info.shouldBeTrue(module.features.hasExceptionHandling(),
                      module.events[0]->name,
                      "Module has events (event-handling is disabled)");
  }
  for (auto& curr : module.events) {
    info.shouldBeEqual(curr->attribute,
                       (unsigned)0,
                       curr->attribute,
                       "Currently only attribute 0 is supported");
    info.shouldBeEqual(curr->sig.results,
                       Type(Type::none),
                       curr->name,
                       "Event type's result type should be none");
    for (auto type : curr->sig.params.expand()) {
      info.shouldBeTrue(type.isInteger() || type.isFloat(),
                        curr->name,
                        "Values in an event should have integer or float type");
    }
  }
}

static void validateModule(Module& module, ValidationInfo& info) {
  // start
  if (module.start.is()) {
    auto func = module.getFunctionOrNull(module.start);
    if (info.shouldBeTrue(
          func != nullptr, module.start, "start must be found")) {
      info.shouldBeTrue(func->sig.params == Type::none,
                        module.start,
                        "start must have 0 params");
      info.shouldBeTrue(func->sig.results == Type::none,
                        module.start,
                        "start must not return a value");
    }
  }
}

// TODO: If we want the validator to be part of libwasm rather than libpasses,
// then Using PassRunner::getPassDebug causes a circular dependence. We should
// fix that, perhaps by moving some of the pass infrastructure into libsupport.
bool WasmValidator::validate(Module& module, Flags flags) {
  ValidationInfo info;
  info.validateWeb = (flags & Web) != 0;
  info.validateGlobally = (flags & Globally) != 0;
  info.quiet = (flags & Quiet) != 0;
  // parallel wasm logic validation
  PassRunner runner(&module);
  FunctionValidator(&info).run(&runner, &module);
  // validate globally
  if (info.validateGlobally) {
    validateImports(module, info);
    validateExports(module, info);
    validateGlobals(module, info);
    validateMemory(module, info);
    validateTable(module, info);
    validateEvents(module, info);
    validateModule(module, info);
  }
  // validate additional internal IR details when in pass-debug mode
  if (PassRunner::getPassDebug()) {
    validateBinaryenIR(module, info);
  }
  // print all the data
  if (!info.valid.load() && !info.quiet) {
    for (auto& func : module.functions) {
      std::cerr << info.getStream(func.get()).str();
    }
    std::cerr << info.getStream(nullptr).str();
  }
  return info.valid.load();
}

} // namespace wasm
