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

#include "wasm-stack.h"

namespace wasm {

void StackIR::optimize(Function* func) {
  class Optimizer {
    StackIR& insts;
    Function* func;

  public:
    Optimizer(StackIR& insts, Function* func) : insts(insts), func(func) {}
    void run() {
      dce();
      stackifyLocalPairs();
      removeUnneededBlocks();
    }

  private:
    // Passes.

    // Remove unreachable code.
    void dce() {
      bool inUnreachableCode = false;
      for (Index i = 0; i < insts.size(); i++) {
        auto* inst = insts[i];
        if (!inst) continue;
        if (inUnreachableCode) {
          // Does the unreachable code end here?
          if (isControlFlowBarrier(inst)) {
            inUnreachableCode = false;
          } else {
            // We can remove this.
            removeAt(i);
          }
        } else if (inst->type == unreachable) {
          inUnreachableCode = true;
        }
      }
    }

    // If ordered properly, we can avoid a set_local/get_local pair,
    // and use the value directly from the stack, for example
    //    [..produce a value on the stack..]
    //    set_local $x
    //    [..much code..]
    //    get_local $x
    //    call $foo ;; use the value, foo(value)
    // As long as the code in between does not modify $x, and has
    // no control flow branching out, we can remove both the set
    // and the get.
    // We can also leave a value on the stack to flow it out of
    // a block, loop, if, or function body. TODO: verify this
    // happens automatically here
    void stackifyLocalPairs() {
    }

    // There may be unnecessary blocks we can remove: blocks
    // without branches to them are always ok to remove.
    // TODO: a branch to a block in an if body can become
    //       a branch to that if body
    void removeUnneededBlocks() {
    }

    // Utilities.

    // A control flow "barrier" - a point where stack machine
    // unreachability ends.
    bool isControlFlowBarrier(StackInst* inst) {
      switch (inst->op) {
        case StackInst::BlockEnd:
        case StackInst::IfElse:
        case StackInst::IfEnd:
        case StackInst::LoopEnd: {
          return true;
        }
        default: {
          return false;
        }
      }
    }

    // A control flow ending.
    bool isControlFlowEnding(StackInst* inst) {
      switch (inst->op) {
        case StackInst::BlockEnd:
        case StackInst::IfEnd:
        case StackInst::LoopEnd: {
          return true;
        }
        default: {
          return false;
        }
      }
    }

    // Remove the instruction at index i. If the instruction
    // is control flow, and so has been expanded to multiple
    // instructions, remove them as well.
    void removeAt(Index i) {
      auto* inst = insts[i];
      insts[i] = nullptr;
      if (inst->op == StackInst::Basic) {
        return; // that was it
      }
      auto* origin = inst->origin;
      while (1) {
        i++;
        assert(i < insts.size());
        inst = insts[i];
        insts[i] = nullptr;
        if (inst->origin == origin && isControlFlowEnding(inst)) {
          return; // that's it, we removed it all
        }
      }
    }

    void dump(std::string description) {
      std::cout << description << '\n';
      for (auto* inst : insts) {
        std::cout << ' ' << *inst << '\n';
      }
    }
  };

  Optimizer(*this, func).run();
}

} // namespace wasm

