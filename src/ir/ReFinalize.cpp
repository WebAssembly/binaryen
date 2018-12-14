/*
 * Copyright 2018 WebAssembly Community Group participants
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

#include "ir/branch-utils.h"
#include "ir/find_all.h"
#include "ir/utils.h"

namespace wasm {

static Type getValueType(Expression* value) {
  return value ? value->type : none;
}

namespace {

// Handles a branch fixup for visitBlock: if the branch goes to the
// target name, give it a value which is unreachable.
template<typename T>
void handleBranchForVisitBlock(T* curr, Name name, Module* module) {
  if (BranchUtils::getUniqueTargets(curr).count(name)) {
    assert(!curr->value);
    Builder builder(*module);
    curr->value = builder.makeUnreachable();
  }
}

} // anonymous namespace

void ReFinalize::visitBlock(Block* curr) {
  if (curr->list.size() == 0) {
    curr->type = none;
    return;
  }
  auto old = curr->type;
  // do this quickly, without any validation
  // last element determines type
  curr->type = curr->list.back()->type;
  // if concrete, it doesn't matter if we have an unreachable child, and we
  // don't need to look at breaks
  if (isConcreteType(curr->type)) {
    // make sure our branches make sense for us - we may have just made ourselves
    // concrete for a value flowing out, while branches did not send a value. such
    // branches could not have been actually taken before, that is, there were in
    // unreachable code, but we do still need to fix them up here.
    if (!isConcreteType(old)) {
      auto iter = breakValues.find(curr->name);
      if (iter != breakValues.end()) {
        // there is a break to here
        auto type = iter->second;
        if (type == none) {
          // we need to fix this up. set the values to unreachables
          for (auto* br : FindAll<Break>(curr).list) {
            handleBranchForVisitBlock(br, curr->name, getModule());
          }
          for (auto* sw : FindAll<Switch>(curr).list) {
            handleBranchForVisitBlock(sw, curr->name, getModule());
          }
          // and we need to propagate that type out, re-walk
          ReFinalize fixer;
          fixer.setModule(getModule());
          Expression* temp = curr;
          fixer.walk(temp);
          assert(temp == curr);
        }
      }
    }
    return;
  }
  // otherwise, we have no final fallthrough element to determine the type,
  // could be determined by breaks
  if (curr->name.is()) {
    auto iter = breakValues.find(curr->name);
    if (iter != breakValues.end()) {
      // there is a break to here
      auto type = iter->second;
      assert(type != unreachable); // we would have removed such branches
      curr->type = type;
      return;
    }
  }
  if (curr->type == unreachable) return;
  // type is none, but we might be unreachable
  if (curr->type == none) {
    for (auto* child : curr->list) {
      if (child->type == unreachable) {
        curr->type = unreachable;
        break;
      }
    }
  }
}
void ReFinalize::visitIf(If* curr) { curr->finalize(); }
void ReFinalize::visitLoop(Loop* curr) { curr->finalize(); }
void ReFinalize::visitBreak(Break* curr) {
  curr->finalize();
  auto valueType = getValueType(curr->value);
  if (valueType == unreachable) {
    replaceUntaken(curr->value, curr->condition);
  } else {
    updateBreakValueType(curr->name, valueType);
  }
}
void ReFinalize::visitSwitch(Switch* curr) {
  curr->finalize();
  auto valueType = getValueType(curr->value);
  if (valueType == unreachable) {
    replaceUntaken(curr->value, curr->condition);
  } else {
    for (auto target : curr->targets) {
      updateBreakValueType(target, valueType);
    }
    updateBreakValueType(curr->default_, valueType);
  }
}
void ReFinalize::visitCall(Call* curr) { curr->finalize(); }
void ReFinalize::visitCallIndirect(CallIndirect* curr) { curr->finalize(); }
void ReFinalize::visitGetLocal(GetLocal* curr) { curr->finalize(); }
void ReFinalize::visitSetLocal(SetLocal* curr) { curr->finalize(); }
void ReFinalize::visitGetGlobal(GetGlobal* curr) { curr->finalize(); }
void ReFinalize::visitSetGlobal(SetGlobal* curr) { curr->finalize(); }
void ReFinalize::visitLoad(Load* curr) { curr->finalize(); }
void ReFinalize::visitStore(Store* curr) { curr->finalize(); }
void ReFinalize::visitAtomicRMW(AtomicRMW* curr) { curr->finalize(); }
void ReFinalize::visitAtomicCmpxchg(AtomicCmpxchg* curr) { curr->finalize(); }
void ReFinalize::visitAtomicWait(AtomicWait* curr) { curr->finalize(); }
void ReFinalize::visitAtomicWake(AtomicWake* curr) { curr->finalize(); }
void ReFinalize::visitSIMDExtract(SIMDExtract* curr) { curr->finalize(); }
void ReFinalize::visitSIMDReplace(SIMDReplace* curr) { curr->finalize(); }
void ReFinalize::visitSIMDShuffle(SIMDShuffle* curr) { curr->finalize(); }
void ReFinalize::visitSIMDBitselect(SIMDBitselect* curr) { curr->finalize(); }
void ReFinalize::visitSIMDShift(SIMDShift* curr) { curr->finalize(); }
void ReFinalize::visitConst(Const* curr) { curr->finalize(); }
void ReFinalize::visitUnary(Unary* curr) { curr->finalize(); }
void ReFinalize::visitBinary(Binary* curr) { curr->finalize(); }
void ReFinalize::visitSelect(Select* curr) { curr->finalize(); }
void ReFinalize::visitDrop(Drop* curr) { curr->finalize(); }
void ReFinalize::visitReturn(Return* curr) { curr->finalize(); }
void ReFinalize::visitHost(Host* curr) { curr->finalize(); }
void ReFinalize::visitNop(Nop* curr) { curr->finalize(); }
void ReFinalize::visitUnreachable(Unreachable* curr) { curr->finalize(); }

void ReFinalize::visitFunction(Function* curr) {
  // we may have changed the body from unreachable to none, which might be bad
  // if the function has a return value
  if (curr->result != none && curr->body->type == none) {
    Builder builder(*getModule());
    curr->body = builder.blockify(curr->body, builder.makeUnreachable());
  }
}

void ReFinalize::visitFunctionType(FunctionType* curr) { WASM_UNREACHABLE(); }
void ReFinalize::visitExport(Export* curr) { WASM_UNREACHABLE(); }
void ReFinalize::visitGlobal(Global* curr) { WASM_UNREACHABLE(); }
void ReFinalize::visitTable(Table* curr) { WASM_UNREACHABLE(); }
void ReFinalize::visitMemory(Memory* curr) { WASM_UNREACHABLE(); }
void ReFinalize::visitModule(Module* curr) { WASM_UNREACHABLE(); }

void ReFinalize::updateBreakValueType(Name name, Type type) {
  if (type != unreachable || breakValues.count(name) == 0) {
    breakValues[name] = type;
  }
}

// Replace an untaken branch/switch with an unreachable value.
// A condition may also exist and may or may not be unreachable.
void ReFinalize::replaceUntaken(Expression* value, Expression* condition) {
  assert(value->type == unreachable);
  auto* replacement = value;
  if (condition) {
    Builder builder(*getModule());
    // Even if we have
    //  (block
    //   (unreachable)
    //   (i32.const 1)
    //  )
    // we want the block type to be unreachable. That is valid as
    // the value is unreachable, and necessary since the type of
    // the condition did not have an impact before (the break/switch
    // type was unreachable), and might not fit in.
    if (isConcreteType(condition->type)) {
      condition = builder.makeDrop(condition);
    }
    replacement = builder.makeSequence(value, condition);
    assert(replacement->type);
  }
  replaceCurrent(replacement);
}

} // namespace wasm
