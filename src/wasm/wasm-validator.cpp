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

#include "wasm.h"
#include "wasm-printing.h"
#include "wasm-validator.h"
#include "ir/utils.h"
#include "ir/branch-utils.h"
#include "ir/module-utils.h"
#include "support/colors.h"


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

// For parallel validation, we have a helper struct for coordination
struct ValidationInfo {
  bool validateWeb;
  bool validateGlobally;
  FeatureSet features;
  bool quiet;

  std::atomic<bool> valid;

  // a stream of error test for each function. we print in the right order at
  // the end, for deterministic output
  // note errors are rare/unexpected, so it's ok to use a slow mutex here
  std::mutex mutex;
  std::unordered_map<Function*, std::unique_ptr<std::ostringstream>> outputs;

  ValidationInfo() {
    valid.store(true);
  }

  std::ostringstream& getStream(Function* func) {
    std::unique_lock<std::mutex> lock(mutex);
    auto iter = outputs.find(func);
    if (iter != outputs.end()) return *(iter->second.get());
    auto& ret = outputs[func] = make_unique<std::ostringstream>();
    return *ret.get();
  }

  // printing and error handling support

  template <typename T, typename S>
  std::ostream& fail(S text, T curr, Function* func) {
    valid.store(false);
    auto& stream = getStream(func);
    if (quiet) return stream;
    auto& ret = printFailureHeader(func);
    ret << text << ", on \n";
    return printModuleComponent(curr, ret);
  }

  std::ostream& printFailureHeader(Function* func) {
    auto& stream = getStream(func);
    if (quiet) return stream;
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
  bool shouldBeTrue(bool result, T curr, const char* text, Function* func = nullptr) {
    if (!result) {
      fail("unexpected false: " + std::string(text), curr, func);
      return false;
    }
    return result;
  }
  template<typename T>
  bool shouldBeFalse(bool result, T curr, const char* text, Function* func = nullptr) {
    if (result) {
      fail("unexpected true: " + std::string(text), curr, func);
      return false;
    }
    return result;
  }

  template<typename T, typename S>
  bool shouldBeEqual(S left, S right, T curr, const char* text, Function* func = nullptr) {
    if (left != right) {
      std::ostringstream ss;
      ss << left << " != " << right << ": " << text;
      fail(ss.str(), curr, func);
      return false;
    }
    return true;
  }

  template<typename T, typename S>
  bool shouldBeEqualOrFirstIsUnreachable(S left, S right, T curr, const char* text, Function* func = nullptr) {
    if (left != unreachable && left != right) {
      std::ostringstream ss;
      ss << left << " != " << right << ": " << text;
      fail(ss.str(), curr, func);
      return false;
    }
    return true;
  }

  template<typename T, typename S>
  bool shouldBeUnequal(S left, S right, T curr, const char* text, Function* func = nullptr) {
    if (left == right) {
      std::ostringstream ss;
      ss << left << " == " << right << ": " << text;
      fail(ss.str(), curr, func);
      return false;
    }
    return true;
  }

  void shouldBeIntOrUnreachable(Type ty, Expression* curr, const char* text, Function* func = nullptr) {
    switch (ty) {
      case i32:
      case i64:
      case unreachable: {
        break;
      }
      default: fail(text, curr, func);
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
    enum {
      UnsetArity = Index(-1),
      PoisonArity = Index(-2)
    };

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

  std::unordered_set<Name> labelNames; // Binaryen IR requires that label names must be unique - IR generators must ensure that

  void noteLabelName(Name name);

public:
  // visitors

  static void visitPreBlock(FunctionValidator* self, Expression** currp) {
    auto* curr = (*currp)->cast<Block>();
    if (curr->name.is()) self->breakInfos[curr->name];
  }

  void visitBlock(Block* curr);

  static void visitPreLoop(FunctionValidator* self, Expression** currp) {
    auto* curr = (*currp)->cast<Loop>();
    if (curr->name.is()) self->breakInfos[curr->name];
  }

  void visitLoop(Loop* curr);
  void visitIf(If* curr);

  // override scan to add a pre and a post check task to all nodes
  static void scan(FunctionValidator* self, Expression** currp) {
    PostWalker<FunctionValidator>::scan(self, currp);

    auto* curr = *currp;
    if (curr->is<Block>()) self->pushTask(visitPreBlock, currp);
    if (curr->is<Loop>()) self->pushTask(visitPreLoop, currp);
  }

  void noteBreak(Name name, Expression* value, Expression* curr);
  void visitBreak(Break* curr);
  void visitSwitch(Switch* curr);
  void visitCall(Call* curr);
  void visitCallIndirect(CallIndirect* curr);
  void visitGetLocal(GetLocal* curr);
  void visitSetLocal(SetLocal* curr);
  void visitGetGlobal(GetGlobal* curr);
  void visitSetGlobal(SetGlobal* curr);
  void visitLoad(Load* curr);
  void visitStore(Store* curr);
  void visitAtomicRMW(AtomicRMW* curr);
  void visitAtomicCmpxchg(AtomicCmpxchg* curr);
  void visitAtomicWait(AtomicWait* curr);
  void visitAtomicWake(AtomicWake* curr);
  void visitBinary(Binary* curr);
  void visitUnary(Unary* curr);
  void visitSelect(Select* curr);
  void visitDrop(Drop* curr);
  void visitReturn(Return* curr);
  void visitHost(Host* curr);
  void visitFunction(Function* curr);

  // helpers
private:
  std::ostream& getStream() {
    return info.getStream(getFunction());
  }

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
  bool shouldBeEqualOrFirstIsUnreachable(S left, S right, T curr, const char* text) {
    return info.shouldBeEqualOrFirstIsUnreachable(left, right, curr, text, getFunction());
  }

  template<typename T, typename S>
  bool shouldBeUnequal(S left, S right, T curr, const char* text) {
    return info.shouldBeUnequal(left, right, curr, text, getFunction());
  }

  void shouldBeIntOrUnreachable(Type ty, Expression* curr, const char* text) {
    return info.shouldBeIntOrUnreachable(ty, curr, text, getFunction());
  }

  void validateAlignment(size_t align, Type type, Index bytes, bool isAtomic,
                         Expression* curr);
  void validateMemBytes(uint8_t bytes, Type type, Expression* curr);
};

void FunctionValidator::noteLabelName(Name name) {
  if (!name.is()) return;
  bool inserted;
  std::tie(std::ignore, inserted) = labelNames.insert(name);
  shouldBeTrue(inserted, name, "names in Binaryen IR must be unique - IR generators must ensure that");
}

void FunctionValidator::visitBlock(Block* curr) {
  // if we are break'ed to, then the value must be right for us
  if (curr->name.is()) {
    noteLabelName(curr->name);
    auto iter = breakInfos.find(curr->name);
    assert(iter != breakInfos.end()); // we set it ourselves
    auto& info = iter->second;
    if (info.hasBeenSet()) {
      if (isConcreteType(curr->type)) {
        shouldBeTrue(info.arity != 0, curr, "break arities must be > 0 if block has a value");
      } else {
        shouldBeTrue(info.arity == 0, curr, "break arities must be 0 if block has no value");
      }
      // none or unreachable means a poison value that we should ignore - if consumed, it will error
      if (isConcreteType(info.type) && isConcreteType(curr->type)) {
        shouldBeEqual(curr->type, info.type, curr, "block+breaks must have right type if breaks return a value");
      }
      if (isConcreteType(curr->type) && info.arity && info.type != unreachable) {
        shouldBeEqual(curr->type, info.type, curr, "block+breaks must have right type if breaks have arity");
      }
      shouldBeTrue(info.arity != BreakInfo::PoisonArity, curr, "break arities must match");
      if (curr->list.size() > 0) {
        auto last = curr->list.back()->type;
        if (isConcreteType(last) && info.type != unreachable) {
          shouldBeEqual(last, info.type, curr, "block+breaks must have right type if block ends with a reachable value");
        }
        if (last == none) {
          shouldBeTrue(info.arity == Index(0), curr, "if block ends with a none, breaks cannot send a value of any type");
        }
      }
    }
    breakInfos.erase(iter);
  }
  if (curr->list.size() > 1) {
    for (Index i = 0; i < curr->list.size() - 1; i++) {
      if (!shouldBeTrue(!isConcreteType(curr->list[i]->type), curr, "non-final block elements returning a value must be drop()ed (binaryen's autodrop option might help you)") && !info.quiet) {
        getStream() << "(on index " << i << ":\n" << curr->list[i] << "\n), type: " << curr->list[i]->type << "\n";
      }
    }
  }
  if (curr->list.size() > 0) {
    auto backType = curr->list.back()->type;
    if (!isConcreteType(curr->type)) {
      shouldBeFalse(isConcreteType(backType), curr, "if block is not returning a value, final element should not flow out a value");
    } else {
      if (isConcreteType(backType)) {
        shouldBeEqual(curr->type, backType, curr, "block with value and last element with value must match types");
      } else {
        shouldBeUnequal(backType, none, curr, "block with value must not have last element that is none");
      }
    }
  }
  if (isConcreteType(curr->type)) {
    shouldBeTrue(curr->list.size() > 0, curr, "block with a value must not be empty");
  }
}

void FunctionValidator::visitLoop(Loop* curr) {
  if (curr->name.is()) {
    noteLabelName(curr->name);
    auto iter = breakInfos.find(curr->name);
    assert(iter != breakInfos.end()); // we set it ourselves
    auto& info = iter->second;
    if (info.hasBeenSet()) {
      shouldBeEqual(info.arity, Index(0), curr, "breaks to a loop cannot pass a value");
    }
    breakInfos.erase(iter);
  }
  if (curr->type == none) {
    shouldBeFalse(isConcreteType(curr->body->type), curr, "bad body for a loop that has no value");
  }
}

void FunctionValidator::visitIf(If* curr) {
  shouldBeTrue(curr->condition->type == unreachable || curr->condition->type == i32, curr, "if condition must be valid");
  if (!curr->ifFalse) {
    shouldBeFalse(isConcreteType(curr->ifTrue->type), curr, "if without else must not return a value in body");
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
    if (isConcreteType(curr->ifTrue->type)) {
      shouldBeEqual(curr->type, curr->ifTrue->type, curr, "if type must match concrete ifTrue");
      shouldBeEqualOrFirstIsUnreachable(curr->ifFalse->type, curr->ifTrue->type, curr, "other arm must match concrete ifTrue");
    }
    if (isConcreteType(curr->ifFalse->type)) {
      shouldBeEqual(curr->type, curr->ifFalse->type, curr, "if type must match concrete ifFalse");
      shouldBeEqualOrFirstIsUnreachable(curr->ifTrue->type, curr->ifFalse->type, curr, "other arm must match concrete ifFalse");
    }
  }
}

void FunctionValidator::noteBreak(Name name, Expression* value, Expression* curr) {
  Type valueType = none;
  Index arity = 0;
  if (value) {
    valueType = value->type;
    shouldBeUnequal(valueType, none, curr, "breaks must have a valid value");
    arity = 1;
  }
  auto iter = breakInfos.find(name);
  if (!shouldBeTrue(iter != breakInfos.end(), curr, "all break targets must be valid")) return;
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
  if (curr->condition) {
    shouldBeTrue(curr->condition->type == unreachable || curr->condition->type == i32, curr, "break condition must be i32");
  }
}

void FunctionValidator::visitSwitch(Switch* curr) {
  for (auto& target : curr->targets) {
    noteBreak(target, curr->value, curr);
  }
  noteBreak(curr->default_, curr->value, curr);
  shouldBeTrue(curr->condition->type == unreachable || curr->condition->type == i32, curr, "br_table condition must be i32");
}

void FunctionValidator::visitCall(Call* curr) {
  if (!info.validateGlobally) return;
  auto* target = getModule()->getFunctionOrNull(curr->target);
  if (!shouldBeTrue(!!target, curr, "call target must exist")) return;
  if (!shouldBeTrue(curr->operands.size() == target->params.size(), curr, "call param number must match")) return;
  for (size_t i = 0; i < curr->operands.size(); i++) {
    if (!shouldBeEqualOrFirstIsUnreachable(curr->operands[i]->type, target->params[i], curr, "call param types must match") && !info.quiet) {
      getStream() << "(on argument " << i << ")\n";
    }
  }
}

void FunctionValidator::visitCallIndirect(CallIndirect* curr) {
  if (!info.validateGlobally) return;
  auto* type = getModule()->getFunctionTypeOrNull(curr->fullType);
  if (!shouldBeTrue(!!type, curr, "call_indirect type must exist")) return;
  shouldBeEqualOrFirstIsUnreachable(curr->target->type, i32, curr, "indirect call target must be an i32");
  if (!shouldBeTrue(curr->operands.size() == type->params.size(), curr, "call param number must match")) return;
  for (size_t i = 0; i < curr->operands.size(); i++) {
    if (!shouldBeEqualOrFirstIsUnreachable(curr->operands[i]->type, type->params[i], curr, "call param types must match") && !info.quiet) {
      getStream() << "(on argument " << i << ")\n";
    }
  }
}

void FunctionValidator::visitGetLocal(GetLocal* curr) {
  shouldBeTrue(curr->index < getFunction()->getNumLocals(), curr, "get_local index must be small enough");
  shouldBeTrue(isConcreteType(curr->type), curr, "get_local must have a valid type - check what you provided when you constructed the node");
  shouldBeTrue(curr->type == getFunction()->getLocalType(curr->index), curr, "get_local must have proper type");
}

void FunctionValidator::visitSetLocal(SetLocal* curr) {
  shouldBeTrue(curr->index < getFunction()->getNumLocals(), curr, "set_local index must be small enough");
  if (curr->value->type != unreachable) {
    if (curr->type != none) { // tee is ok anyhow
      shouldBeEqualOrFirstIsUnreachable(curr->value->type, curr->type, curr, "set_local type must be correct");
    }
    shouldBeEqual(getFunction()->getLocalType(curr->index), curr->value->type, curr, "set_local type must match function");
  }
}

void FunctionValidator::visitGetGlobal(GetGlobal* curr) {
  if (!info.validateGlobally) return;
  shouldBeTrue(getModule()->getGlobalOrNull(curr->name), curr, "get_global name must be valid");
}

void FunctionValidator::visitSetGlobal(SetGlobal* curr) {
  if (!info.validateGlobally) return;
  auto* global = getModule()->getGlobalOrNull(curr->name);
  if (shouldBeTrue(global, curr, "set_global name must be valid (and not an import; imports can't be modified)")) {
    shouldBeTrue(global->mutable_, curr, "set_global global must be mutable");
    shouldBeEqualOrFirstIsUnreachable(curr->value->type, global->type, curr, "set_global value must have right type");
  }
}

void FunctionValidator::visitLoad(Load* curr) {
  if (curr->isAtomic) shouldBeTrue(info.features & Feature::Atomics, curr, "Atomic operation (atomics are disabled)");
  shouldBeFalse(curr->isAtomic && !getModule()->memory.shared, curr, "Atomic operation with non-shared memory");
  validateMemBytes(curr->bytes, curr->type, curr);
  validateAlignment(curr->align, curr->type, curr->bytes, curr->isAtomic, curr);
  shouldBeEqualOrFirstIsUnreachable(curr->ptr->type, i32, curr, "load pointer type must be i32");
  if (curr->isAtomic) {
    shouldBeFalse(curr->signed_, curr, "atomic loads must be unsigned");
    shouldBeIntOrUnreachable(curr->type, curr, "atomic loads must be of integers");
  }
}

void FunctionValidator::visitStore(Store* curr) {
  if (curr->isAtomic) shouldBeTrue(info.features & Feature::Atomics, curr, "Atomic operation (atomics are disabled)");
  shouldBeFalse(curr->isAtomic && !getModule()->memory.shared, curr, "Atomic operation with non-shared memory");
  validateMemBytes(curr->bytes, curr->valueType, curr);
  validateAlignment(curr->align, curr->type, curr->bytes, curr->isAtomic, curr);
  shouldBeEqualOrFirstIsUnreachable(curr->ptr->type, i32, curr, "store pointer type must be i32");
  shouldBeUnequal(curr->value->type, none, curr, "store value type must not be none");
  shouldBeEqualOrFirstIsUnreachable(curr->value->type, curr->valueType, curr, "store value type must match");
  if (curr->isAtomic) {
    shouldBeIntOrUnreachable(curr->valueType, curr, "atomic stores must be of integers");
  }
}

void FunctionValidator::visitAtomicRMW(AtomicRMW* curr) {
  shouldBeTrue(info.features & Feature::Atomics, curr, "Atomic operation (atomics are disabled)");
  shouldBeFalse(!getModule()->memory.shared, curr, "Atomic operation with non-shared memory");
  validateMemBytes(curr->bytes, curr->type, curr);
  shouldBeEqualOrFirstIsUnreachable(curr->ptr->type, i32, curr, "AtomicRMW pointer type must be i32");
  shouldBeEqualOrFirstIsUnreachable(curr->type, curr->value->type, curr, "AtomicRMW result type must match operand");
  shouldBeIntOrUnreachable(curr->type, curr, "Atomic operations are only valid on int types");
}

void FunctionValidator::visitAtomicCmpxchg(AtomicCmpxchg* curr) {
  shouldBeTrue(info.features & Feature::Atomics, curr, "Atomic operation (atomics are disabled)");
  shouldBeFalse(!getModule()->memory.shared, curr, "Atomic operation with non-shared memory");
  validateMemBytes(curr->bytes, curr->type, curr);
  shouldBeEqualOrFirstIsUnreachable(curr->ptr->type, i32, curr, "cmpxchg pointer type must be i32");
  if (curr->expected->type != unreachable && curr->replacement->type != unreachable) {
    shouldBeEqual(curr->expected->type, curr->replacement->type, curr, "cmpxchg operand types must match");
  }
  shouldBeEqualOrFirstIsUnreachable(curr->type, curr->expected->type, curr, "Cmpxchg result type must match expected");
  shouldBeEqualOrFirstIsUnreachable(curr->type, curr->replacement->type, curr, "Cmpxchg result type must match replacement");
  shouldBeIntOrUnreachable(curr->expected->type, curr, "Atomic operations are only valid on int types");
}

void FunctionValidator::visitAtomicWait(AtomicWait* curr) {
  shouldBeTrue(info.features & Feature::Atomics, curr, "Atomic operation (atomics are disabled)");
  shouldBeFalse(!getModule()->memory.shared, curr, "Atomic operation with non-shared memory");
  shouldBeEqualOrFirstIsUnreachable(curr->type, i32, curr, "AtomicWait must have type i32");
  shouldBeEqualOrFirstIsUnreachable(curr->ptr->type, i32, curr, "AtomicWait pointer type must be i32");
  shouldBeIntOrUnreachable(curr->expected->type, curr, "AtomicWait expected type must be int");
  shouldBeEqualOrFirstIsUnreachable(curr->expected->type, curr->expectedType, curr, "AtomicWait expected type must match operand");
  shouldBeEqualOrFirstIsUnreachable(curr->timeout->type, i64, curr, "AtomicWait timeout type must be i64");
}

void FunctionValidator::visitAtomicWake(AtomicWake* curr) {
  shouldBeTrue(info.features & Feature::Atomics, curr, "Atomic operation (atomics are disabled)");
  shouldBeFalse(!getModule()->memory.shared, curr, "Atomic operation with non-shared memory");
  shouldBeEqualOrFirstIsUnreachable(curr->type, i32, curr, "AtomicWake must have type i32");
  shouldBeEqualOrFirstIsUnreachable(curr->ptr->type, i32, curr, "AtomicWake pointer type must be i32");
  shouldBeEqualOrFirstIsUnreachable(curr->wakeCount->type, i32, curr, "AtomicWake wakeCount type must be i32");
}

void FunctionValidator::validateMemBytes(uint8_t bytes, Type type, Expression* curr) {
  switch (bytes) {
    case 1:
    case 2:
    case 4: break;
    case 8: {
      // if we have a concrete type for the load, then we know the size of the mem operation and
      // can validate it
      if (type != unreachable) {
        shouldBeEqual(getTypeSize(type), 8U, curr, "8-byte mem operations are only allowed with 8-byte wasm types");
      }
      break;
    }
    default: info.fail("Memory operations must be 1,2,4, or 8 bytes", curr, getFunction());
  }
}

void FunctionValidator::visitBinary(Binary* curr) {
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

void FunctionValidator::visitUnary(Unary* curr) {
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

void FunctionValidator::visitSelect(Select* curr) {
  shouldBeUnequal(curr->ifTrue->type, none, curr, "select left must be valid");
  shouldBeUnequal(curr->ifFalse->type, none, curr, "select right must be valid");
  shouldBeTrue(curr->condition->type == unreachable || curr->condition->type == i32, curr, "select condition must be valid");
  if (curr->ifTrue->type != unreachable && curr->ifFalse->type != unreachable) {
    shouldBeEqual(curr->ifTrue->type, curr->ifFalse->type, curr, "select sides must be equal");
  }
}

void FunctionValidator::visitDrop(Drop* curr) {
  shouldBeTrue(isConcreteType(curr->value->type) || curr->value->type == unreachable, curr, "can only drop a valid value");
}

void FunctionValidator::visitReturn(Return* curr) {
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

void FunctionValidator::visitHost(Host* curr) {
  switch (curr->op) {
    case GrowMemory: {
      shouldBeEqual(curr->operands.size(), size_t(1), curr, "grow_memory must have 1 operand");
      shouldBeEqualOrFirstIsUnreachable(curr->operands[0]->type, i32, curr, "grow_memory must have i32 operand");
      break;
    }
    case CurrentMemory: break;
    default: WASM_UNREACHABLE();
  }
}

void FunctionValidator::visitFunction(Function* curr) {
  for (auto type : curr->params) {
    shouldBeTrue(isConcreteType(type), curr, "params must be concretely typed");
  }
  for (auto type : curr->vars) {
    shouldBeTrue(isConcreteType(type), curr, "vars must be concretely typed");
  }
  // if function has no result, it is ignored
  // if body is unreachable, it might be e.g. a return
  if (curr->body->type != unreachable) {
    shouldBeEqual(curr->result, curr->body->type, curr->body, "function body type must match, if function returns");
  }
  if (returnType != unreachable) {
    shouldBeEqual(curr->result, returnType, curr->body, "function result must match, if function has returns");
  }
  shouldBeTrue(breakInfos.empty(), curr->body, "all named break targets must exist");
  returnType = unreachable;
  labelNames.clear();
  // if function has a named type, it must match up with the function's params and result
  if (info.validateGlobally && curr->type.is()) {
    auto* ft = getModule()->getFunctionType(curr->type);
    shouldBeTrue(ft->params == curr->params, curr->name, "function params must match its declared type");
    shouldBeTrue(ft->result == curr->result, curr->name, "function result must match its declared type");
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

void FunctionValidator::validateAlignment(size_t align, Type type, Index bytes,
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
    default: {}
  }
}

static void validateBinaryenIR(Module& wasm, ValidationInfo& info) {
  struct BinaryenIRValidator : public PostWalker<BinaryenIRValidator, UnifiedExpressionVisitor<BinaryenIRValidator>> {
    ValidationInfo& info;

    std::unordered_set<Expression*> seen;

    BinaryenIRValidator(ValidationInfo& info) : info(info) {}

    void visitExpression(Expression* curr) {
      auto scope = getFunction() ? getFunction()->name : Name("(global scope)");
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
        if (!(isConcreteType(oldType) && newType == unreachable)) {
          std::ostringstream ss;
          ss << "stale type found in " << scope << " on " << curr << "\n(marked as " << printType(oldType) << ", should be " << printType(newType) << ")\n";
          info.fail(ss.str(), curr, getFunction());
        }
        curr->type = oldType;
      }
      // check if a node is a duplicate - expressions must not be seen more than once
      bool inserted;
      std::tie(std::ignore, inserted) = seen.insert(curr);
      if (!inserted) {
        std::ostringstream ss;
        ss << "expression seen more than once in the tree in " << scope << " on " << curr << '\n';
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
      auto* functionType = module.getFunctionType(curr->type);
      info.shouldBeUnequal(functionType->result, i64, curr->name, "Imported function must not have i64 return type");
      for (Type param : functionType->params) {
        info.shouldBeUnequal(param, i64, curr->name, "Imported function must not have i64 parameters");
      }
    }
  });
}

static void validateExports(Module& module, ValidationInfo& info) {
  for (auto& curr : module.exports) {
    if (curr->kind == ExternalKind::Function) {
      if (info.validateWeb) {
        Function* f = module.getFunction(curr->value);
        info.shouldBeUnequal(f->result, i64, f->name, "Exported function must not have i64 return type");
        for (auto param : f->params) {
          info.shouldBeUnequal(param, i64, f->name, "Exported function must not have i64 parameters");
        }
      }
    }
  }
  std::unordered_set<Name> exportNames;
  for (auto& exp : module.exports) {
    Name name = exp->value;
    if (exp->kind == ExternalKind::Function) {
      info.shouldBeTrue(module.getFunctionOrNull(name), name, "module function exports must be found");
    } else if (exp->kind == ExternalKind::Global) {
      info.shouldBeTrue(module.getGlobalOrNull(name), name, "module global exports must be found");
    } else if (exp->kind == ExternalKind::Table) {
      info.shouldBeTrue(name == Name("0") || name == module.table.name, name, "module table exports must be found");
    } else if (exp->kind == ExternalKind::Memory) {
      info.shouldBeTrue(name == Name("0") || name == module.memory.name, name, "module memory exports must be found");
    } else {
      WASM_UNREACHABLE();
    }
    Name exportName = exp->name;
    info.shouldBeFalse(exportNames.count(exportName) > 0, exportName, "module exports must be unique");
    exportNames.insert(exportName);
  }
}

static void validateGlobals(Module& module, ValidationInfo& info) {
  ModuleUtils::iterDefinedGlobals(module, [&](Global* curr) {
    info.shouldBeTrue(curr->init != nullptr, curr->name, "global init must be non-null");
    info.shouldBeTrue(curr->init->is<Const>() || curr->init->is<GetGlobal>(), curr->name, "global init must be valid");
    if (!info.shouldBeEqual(curr->type, curr->init->type, curr->init, "global init must have correct type") && !info.quiet) {
      info.getStream(nullptr) << "(on global " << curr->name << ")\n";
    }
  });
}

static void validateMemory(Module& module, ValidationInfo& info) {
  auto& curr = module.memory;
  info.shouldBeFalse(curr.initial > curr.max, "memory", "memory max >= initial");
  info.shouldBeTrue(!curr.hasMax() || curr.max <= Memory::kMaxSize, "memory", "max memory must be <= 4GB, or unlimited");
  info.shouldBeTrue(!curr.shared || curr.hasMax(), "memory", "shared memory must have max size");
  if (curr.shared) info.shouldBeTrue(info.features & Feature::Atomics, "memory", "memory is shared, but atomics are disabled");
  for (auto& segment : curr.segments) {
    if (!info.shouldBeEqual(segment.offset->type, i32, segment.offset, "segment offset should be i32")) continue;
    info.shouldBeTrue(checkOffset(segment.offset, segment.data.size(), curr.initial * Memory::kPageSize), segment.offset, "segment offset should be reasonable");
    Index size = segment.data.size();
    // If the memory is imported we don't actually know its initial size.
    // Specifically wasm dll's import a zero sized memory which is perfectly
    // valid.
    if (!curr.imported()) {
      info.shouldBeTrue(size <= curr.initial * Memory::kPageSize, segment.data.size(), "segment size should fit in memory (initial)");
    }
    if (segment.offset->is<Const>()) {
      Index start = segment.offset->cast<Const>()->value.geti32();
      Index end = start + size;
      info.shouldBeTrue(end <= curr.initial * Memory::kPageSize, segment.data.size(), "segment size should fit in memory (end)");
    }
  }
}

static void validateTable(Module& module, ValidationInfo& info) {
  auto& curr = module.table;
  for (auto& segment : curr.segments) {
    info.shouldBeEqual(segment.offset->type, i32, segment.offset, "segment offset should be i32");
    info.shouldBeTrue(checkOffset(segment.offset, segment.data.size(), module.table.initial * Table::kPageSize), segment.offset, "segment offset should be reasonable");
    for (auto name : segment.data) {
      info.shouldBeTrue(module.getFunctionOrNull(name), name, "segment name should be valid");
    }
  }
}

static void validateModule(Module& module, ValidationInfo& info) {
  // start
  if (module.start.is()) {
    auto func = module.getFunctionOrNull(module.start);
    if (info.shouldBeTrue(func != nullptr, module.start, "start must be found")) {
      info.shouldBeTrue(func->params.size() == 0, module.start, "start must have 0 params");
      info.shouldBeTrue(func->result == none, module.start, "start must not return a value");
    }
  }
}

// TODO: If we want the validator to be part of libwasm rather than libpasses, then
// Using PassRunner::getPassDebug causes a circular dependence. We should fix that,
// perhaps by moving some of the pass infrastructure into libsupport.
bool WasmValidator::validate(Module& module, FeatureSet features, Flags flags) {
  ValidationInfo info;
  info.validateWeb = (flags & Web) != 0;
  info.validateGlobally = (flags & Globally) != 0;
  info.features = features;
  info.quiet = (flags & Quiet) != 0;
  // parallel wasm logic validation
  PassRunner runner(&module);
  runner.add<FunctionValidator>(&info);
  runner.setIsNested(true);
  runner.run();
  // validate globally
  if (info.validateGlobally) {
    validateImports(module, info);
    validateExports(module, info);
    validateGlobals(module, info);
    validateMemory(module, info);
    validateTable(module, info);
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
