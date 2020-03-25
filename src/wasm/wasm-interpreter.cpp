/*
 * Copyright 2020 WebAssembly Community Group participants
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

#include "wasm-interpreter.h"

namespace wasm {

#ifdef WASM_INTERPRETER_DEBUG
int Indenter::indentLevel = 0;

Indenter::Indenter(const char* entry) : entryName(entry) { ++indentLevel; }
Indenter::~Indenter() {
  print();
  std::cout << "exit " << entryName << '\n';
  --indentLevel;
}
void Indenter::print() {
  std::cout << indentLevel << ':';
  for (int i = 0; i <= indentLevel; ++i) {
    std::cout << ' ';
  }
}
#endif // WASM_INTERPRETER_DEBUG

//
// LinearExpressionRunner
//

const Name LinearExpressionRunner::NONCONSTANT_FLOW = "Binaryen|nonconstant";

LinearExpressionRunner::LinearExpressionRunner(Module* module,
                                               Flags flags,
                                               Index maxDepth)
  : ExpressionRunner<LinearExpressionRunner>(maxDepth), module(module),
    flags(flags) {
  // Trap instead of aborting if we hit an invalid expression.
  trapIfInvalid = true;
}

Module* LinearExpressionRunner::getModule() { return module; }

void LinearExpressionRunner::setGetValues(GetValues* values) {
  getValues = values;
}

bool LinearExpressionRunner::setLocalValue(Index index, Literals& values) {
  if (values.isConcrete()) {
    localValues[index] = values;
    return true;
  }
  localValues.erase(index);
  return false;
}

bool LinearExpressionRunner::setLocalValue(Index index, Expression* expr) {
  auto setFlow = visit(expr);
  if (!setFlow.breaking()) {
    return setLocalValue(index, setFlow.values);
  }
  return false;
}

bool LinearExpressionRunner::setGlobalValue(Name name, Literals& values) {
  if (values.isConcrete()) {
    globalValues[name] = values;
    return true;
  }
  globalValues.erase(name);
  return false;
}

bool LinearExpressionRunner::setGlobalValue(Name name, Expression* expr) {
  auto setFlow = visit(expr);
  if (!setFlow.breaking()) {
    return setGlobalValue(name, setFlow.values);
  }
  return false;
}

Flow LinearExpressionRunner::visitLoop(Loop* curr) {
  // loops might be infinite, so must be careful
  // but we can't tell if non-infinite, since we don't have state, so loops
  // are just impossible to optimize for now
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitCall(Call* curr) {
  // Traverse into functions using the same mode, which we can also do
  // when replacing as long as the function does not have any side effects.
  // Might yield something useful for simple functions like `clamp`, sometimes
  // even if arguments are only partially constant or not constant at all.
  if (flags & FlagValues::TRAVERSE_CALLS) {
    auto* func = module->getFunction(curr->target);
    if (!func->imported()) {
      if (func->sig.results.isConcrete()) {
        auto numOperands = curr->operands.size();
        assert(numOperands == func->getNumParams());
        LinearExpressionRunner runner(module, flags, maxDepth);
        runner.depth = depth + 1;
        for (Index i = 0; i < numOperands; ++i) {
          auto argFlow = visit(curr->operands[i]);
          if (!argFlow.breaking() && argFlow.values.isConcrete()) {
            runner.localValues[i] = std::move(argFlow.values);
          }
        }
        auto retFlow = runner.visit(func->body);
        if (retFlow.breakTo == RETURN_FLOW) {
          return Flow(std::move(retFlow.values));
        } else if (!retFlow.breaking()) {
          return retFlow;
        }
      }
    }
  }
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitCallIndirect(CallIndirect* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitLocalGet(LocalGet* curr) {
  // Check if a constant value has been set in the context of this runner.
  auto iter = localValues.find(curr->index);
  if (iter != localValues.end()) {
    return Flow(std::move(iter->second));
  }
  // If not the case, see if the calling pass did compute the value of this
  // specific `local.get` in an earlier step already. This is a fallback
  // targeting the precompute pass specifically, which already did this work,
  // but is not applicable when the runner is used via the C-API for example.
  if (getValues != nullptr) {
    auto iter = getValues->find(curr);
    if (iter != getValues->end()) {
      auto values = iter->second;
      if (values.isConcrete()) {
        return Flow(std::move(values));
      }
    }
  }
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitLocalSet(LocalSet* curr) {
  if (!(flags & FlagValues::PRESERVE_SIDEEFFECTS)) {
    // If we are evaluating and not replacing the expression, see if there is
    // a value flowing through a tee.
    if (curr->type.isConcrete()) {
      assert(curr->isTee());
      return visit(curr->value);
    }
    // Otherwise remember the constant value set, if any, for subsequent gets.
    if (setLocalValue(curr->index, curr->value)) {
      return Flow();
    }
  }
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitGlobalGet(GlobalGet* curr) {
  auto* global = module->getGlobal(curr->name);
  // Check if the global has an immutable value anyway
  if (!global->imported() && !global->mutable_) {
    return visit(global->init);
  }
  // Check if a constant value has been set in the context of this runner.
  auto iter = globalValues.find(curr->name);
  if (iter != globalValues.end()) {
    return Flow(std::move(iter->second));
  }
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitGlobalSet(GlobalSet* curr) {
  if (!(flags & FlagValues::PRESERVE_SIDEEFFECTS)) {
    // If we are evaluating and not replacing the expression, remember the
    // constant value set, if any, for subsequent gets.
    auto* global = module->getGlobal(curr->name);
    assert(global->mutable_);
    if (setGlobalValue(curr->name, curr->value)) {
      return Flow();
    }
  }
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitLoad(Load* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitStore(Store* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitAtomicRMW(AtomicRMW* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitAtomicCmpxchg(AtomicCmpxchg* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitAtomicWait(AtomicWait* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitAtomicNotify(AtomicNotify* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitSIMDLoad(SIMDLoad* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitMemoryInit(MemoryInit* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitDataDrop(DataDrop* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitMemoryCopy(MemoryCopy* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitMemoryFill(MemoryFill* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitHost(Host* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitTry(Try* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitThrow(Throw* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitRethrow(Rethrow* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitBrOnExn(BrOnExn* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitPush(Push* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow LinearExpressionRunner::visitPop(Pop* curr) {
  return Flow(NONCONSTANT_FLOW);
}

void LinearExpressionRunner::trap(const char* why) {
  throw NonconstantException();
}

} // namespace wasm
