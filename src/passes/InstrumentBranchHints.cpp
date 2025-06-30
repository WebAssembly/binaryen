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
  void visitIf(If* curr) {
  }

  void visitBreak(Break* curr) {
  }
};

Pass* createInstrumentBranchHintsPass() { return new InstrumentBranchHints(); }

} // namespace wasm
