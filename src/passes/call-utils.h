/*
 * Copyright 2022 WebAssembly Community Group participants
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

#ifndef wasm_ir_function_h
#define wasm_ir_function_h

#include <variant>

#include "ir/debuginfo.h"
#include "ir/type-updating.h"
#include "wasm.h"

namespace wasm::CallUtils {

// Define a variant to describe the information we know about an indirect call,
// which is one of three things:
//  * Unknown: Nothing is known this call.
//  * Trap: This call target is invalid and will trap at runtime.
//  * Known: This call goes to a known static call target, which is provided.
struct Unknown : public std::monostate {};
struct Trap : public std::monostate {};
struct Known {
  Name target;
};
using IndirectCallInfo = std::variant<Unknown, Trap, Known>;

// Converts indirect calls that target selects between values into ifs over
// direct calls. For example, consider this input:
//
//  (call_ref
//    (select
//      (ref.func A)
//      (ref.func B)
//      (..condition..)
//    )
//  )
//
// We'll check if the input falls into such a pattern, and if so, return the new
// form:
//
//  (if
//    (..condition..)
//    (call $A)
//    (call $B)
//  )
//
// If we fail to find the expected pattern, or we decide it is not worth
// optimizing it for some reason, we return nullptr.
//
// If this returns the new form, it will modify the function as necessary,
// adding new locals etc., which later passes should optimize.
//
// |getCallInfo| is given one of the arms of the select and should return an
// IndirectCallInfo that says what we know about it. We may know nothing, or
// that it will trap, or that it will go to a known static target.
template<typename T>
inline Expression*
convertToDirectCalls(T* curr,
                     std::function<IndirectCallInfo(Expression*)> getCallInfo,
                     Function& func,
                     Module& wasm) {
  auto* select = curr->target->template dynCast<Select>();
  if (!select) {
    return nullptr;
  }

  if (select->type == Type::unreachable) {
    // Leave this for DCE.
    return nullptr;
  }

  // Check if we can find useful info for both arms: either known call targets,
  // or traps.
  // TODO: support more than 2 targets (with nested selects)
  auto ifTrueCallInfo = getCallInfo(select->ifTrue);
  auto ifFalseCallInfo = getCallInfo(select->ifFalse);
  if (std::get_if<Unknown>(&ifTrueCallInfo) ||
      std::get_if<Unknown>(&ifFalseCallInfo)) {
    // We know nothing about at least one arm, so give up.
    // TODO: Perhaps emitting a direct call for one arm is enough even if the
    //       other remains indirect?
    return nullptr;
  }

  auto& operands = curr->operands;

  // We must use the operands twice, and also must move the condition to
  // execute first, so we'll use locals for them all. First, see if any are
  // unreachable, and if so stop trying to optimize and leave this for DCE.
  for (auto* operand : operands) {
    if (operand->type == Type::unreachable ||
        !TypeUpdating::canHandleAsLocal(operand->type)) {
      return nullptr;
    }
  }

  Builder builder(wasm);
  std::vector<Expression*> blockContents;

  // None of the types are a problem, so we can proceed to add new vars as
  // needed and perform this optimization.
  std::vector<Index> operandLocals;
  for (auto* operand : operands) {
    auto currLocal = builder.addVar(&func, operand->type);
    operandLocals.push_back(currLocal);
    blockContents.push_back(builder.makeLocalSet(currLocal, operand));
  }

  // Build the calls.
  auto numOperands = operands.size();
  auto getOperands = [&]() {
    std::vector<Expression*> newOperands(numOperands);
    for (Index i = 0; i < numOperands; i++) {
      newOperands[i] =
        builder.makeLocalGet(operandLocals[i], operands[i]->type);
    }
    return newOperands;
  };

  auto makeCall = [&](IndirectCallInfo info) -> Expression* {
    Expression* ret;
    if (std::get_if<Trap>(&info)) {
      ret = builder.makeUnreachable();
    } else {
      ret = builder.makeCall(std::get<Known>(info).target,
                             getOperands(),
                             curr->type,
                             curr->isReturn);
    }
    debuginfo::copyOriginalToReplacement(curr, ret, &func);
    return ret;
  };
  auto* ifTrueCall = makeCall(ifTrueCallInfo);
  auto* ifFalseCall = makeCall(ifFalseCallInfo);

  // Create the if to pick the calls, and emit the final block.
  auto* iff = builder.makeIf(select->condition, ifTrueCall, ifFalseCall);
  blockContents.push_back(iff);
  return builder.makeBlock(blockContents);
}

} // namespace wasm::CallUtils

#endif // wasm_ir_function_h
