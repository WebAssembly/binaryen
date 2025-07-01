/*
 * Copyright 2025 WebAssembly Community Group participants
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
// Instruments branch hints and their targets, adding logging that allows us to
// see if the hints were valid or not. We turn
//
//  @metadata.branch.hint B
//  if (condition) {
//    A;
//  } else {
//    B;
//  }
//
// into
//
//  @metadata.branch.hint B
//  if (temp = condition; log("if on line 123 predicts B"; temp) {
//    log("if on line 123 ended up true");
//    A;
//  } else {
//    B;
//  }
//
// That is, the logging identifies the if, logs the prediction (0 or 1) for that
// if, and then if the if were true, we log that, so by scanning all the
// loggings, we can see both the hint and what actually executed. Similarly, for
// br_if:
//
//  @metadata.branch.hint B
//  (br_if $target (condition))
//
// into
//
//  @metadata.branch.hint B
//  (br_if $target (temp = condition; log("br_if on line 456 predicts B"; temp))
//  log("if on line 123 ended up false");
//
// Note how in this case it is simpler to add the logging on the "false" case,
// since it is right after the br_if.
//
// The motivation for this pass is to fuzz branch hint updates: given a fuzz
// case, we can instrument it and view the loggings, then optimize the original,
// instrument that, and view those loggings. The amount of wrong predictions
// should not decrease (the amount of right ones might, since an if might be
// eliminated entirely by the optimizer).
//

#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct InstrumentBranchHints : public WalkerPass<PostWalker<InstrumentBranchHints>> {
  Name LOG_GUESS = "log_guess";
  Name LOG_TRUE = "log_true";
  Name LOG_FALSE = "log_false";

  Index branchId = 0;

  void visitIf(If* curr) {
    if (auto likely = getFunction()->codeAnnotations[curr].branchLikely) {
      Builder builder(*getModule());

      // Pick an ID for this branch and a temp local.
      auto temp = builder.addVar(getFunction(), Type::i32);
      auto id = branchId++;

      // Instrument the condition and the true branch.
      instrumentCondition(curr->condition, temp, id, *likely);

      // Log the true branch, which we can easily do by prepending in the ifTrue
      // arm.
      auto* idc = builder.makeConst(Literal(int32_t(id)));
      auto* logTrue = builder.makeCall(LOG_TRUE, { idc }, Type::none);
      curr->ifTrue = builder.makeSequence(logTrue, curr->ifTrue);
    }
  }

  void visitBreak(Break* curr) {
    if (auto likely = getFunction()->codeAnnotations[curr].branchLikely) {
      Builder builder(*getModule());

      // Pick an ID for this branch and a temp local.
      auto temp = builder.addVar(getFunction(), Type::i32);
      auto id = branchId++;

      // Instrument the condition and the true branch.
      instrumentCondition(curr->condition, temp, id, *likely);

      // Log the false branch, which we can easily do by appending right after
      // the break.
      auto* idc = builder.makeConst(Literal(int32_t(id)));
      auto* logFalse = builder.makeCall(LOG_FALSE, { idc }, Type::none);
      if (curr->type.isConcrete()) {
        // We must stash the result, log the false, then return the result,
        // using another temp var.
        auto tempValue = builder.addVar(getFunction(), curr->type);
        auto* set = builder.makeLocalSet(tempValue, curr);
        auto* get = builder.makeLocalGet(tempValue, curr->type);
        replaceCurrent(builder.makeBlock({ set, logFalse, get }));
      } else {
        // No return value to bother with, so this is simple.
        replaceCurrent(builder.makeSequence(curr, logFalse));
      }
    }
  }

  // Given the condition of a branch, modify it in place, adding proper logging.
  void instrumentCondition(Expression*& condition, Index tempLocal, Index id, bool likely) {
    Builder builder(*getModule());
    auto* set = builder.makeLocalSet(tempLocal, condition);
    auto* idc = builder.makeConst(Literal(int32_t(id)));
    auto* guess = builder.makeConst(Literal(int32_t(likely)));
    auto* logGuess = builder.makeCall(LOG_GUESS, { idc, guess }, Type::none);
    auto* get = builder.makeLocalGet(tempLocal, Type::i32);
    condition = builder.makeBlock({ set, logGuess, get });
  }

  void visitModule(Module* curr) {
    // Add imports.
    auto* logGuess =
      curr->addFunction(Builder::makeFunction(LOG_GUESS, Signature({Type::i32, Type::i32}, Type::none), {}));
    auto* logTrue =
      curr->addFunction(Builder::makeFunction(LOG_TRUE, Signature(Type::i32, Type::none), {}));
    auto* logFalse =
      curr->addFunction(Builder::makeFunction(LOG_FALSE, Signature(Type::i32, Type::none), {}));

    for (auto* func : {logGuess, logTrue, logFalse}) {
      func->module = "fuzzing-support";
      func->base = func->name;
    }
  }
};

Pass* createInstrumentBranchHintsPass() { return new InstrumentBranchHints(); }

} // namespace wasm
