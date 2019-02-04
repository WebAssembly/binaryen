/*
 * Copyright 2019 WebAssembly Community Group participants
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

#ifndef wasm_ir_inlining_h
#define wasm_ir_inlining_h

#include "wasm.h"
#include "wasm-builder.h"
#include "ir/literal-utils.h"

namespace wasm {

// Core inlining logic. Modifies the caller (adding locals as needed), and returns the inlined code.
static Expression* doInlining(Module* module, Function* caller, Call* call) {
  auto* callee = module->getFunction(call->target);
  Builder builder(*module);
  auto* block = Builder(*module).makeBlock();
  block->name = Name(std::string("__inlined_func$") + callee->name.str);
  // set up a locals mapping
  struct Updater : public PostWalker<Updater> {
    std::map<Index, Index> localMapping;
    Name returnName;
    Builder* builder;

    void visitReturn(Return* curr) {
      replaceCurrent(builder->makeBreak(returnName, curr->value));
    }
    void visitGetLocal(GetLocal* curr) {
      curr->index = localMapping[curr->index];
    }
    void visitSetLocal(SetLocal* curr) {
      curr->index = localMapping[curr->index];
    }
  } updater;
  updater.returnName = block->name;
  updater.builder = &builder;
  for (Index i = 0; i < callee->getNumLocals(); i++) {
    updater.localMapping[i] = builder.addVar(caller, callee->getLocalType(i));
  }
  // assign the operands into the params
  for (Index i = 0; i < callee->params.size(); i++) {
    block->list.push_back(builder.makeSetLocal(updater.localMapping[i], call->operands[i]));
  }
  // zero out the vars (as we may be in a loop, and may depend on their zero-init value
  for (Index i = 0; i < callee->vars.size(); i++) {
    block->list.push_back(builder.makeSetLocal(updater.localMapping[callee->getVarIndexBase() + i], LiteralUtils::makeZero(callee->vars[i], *module)));
  }
  // generate and update the inlined contents
  auto* contents = ExpressionManipulator::copy(callee->body, *module);
  updater.walk(contents);
  block->list.push_back(contents);
  block->type = call->type;
  // if the function returned a value, we just set the block containing the
  // inlined code to have that type. or, if the function was void and
  // contained void, that is fine too. a bad case is a void function in which
  // we have unreachable code, so we would be replacing a void call with an
  // unreachable; we need to handle
  if (contents->type == unreachable && block->type == none) {
    // make the block reachable by adding a break to it
    block->list.push_back(builder.makeBreak(block->name));
  }
  return block;
}

} // namespace wasm

#endif // wasm_ir_inlining_h
