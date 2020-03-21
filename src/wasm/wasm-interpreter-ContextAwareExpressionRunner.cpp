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

const Name ContextAwareExpressionRunner::NONCONSTANT_FLOW =
  "Binaryen|nonconstant";

ContextAwareExpressionRunner::ContextAwareExpressionRunner(Module* module,
                                                           Mode mode,
                                                           Index maxDepth,
                                                           GetValues* getValues)
  : ExpressionRunner<ContextAwareExpressionRunner>(maxDepth), module(module),
    getValues(getValues), mode(mode) {}

ContextAwareExpressionRunner::~ContextAwareExpressionRunner() {}

Module* ContextAwareExpressionRunner::getModule() { return module; }

bool ContextAwareExpressionRunner::setLocalValue(Index index,
                                                 Literals& values) {
  if (values.isConcrete()) {
    localValues[index] = values;
    return true;
  }
  localValues.erase(index);
  return false;
}

bool ContextAwareExpressionRunner::setLocalValue(Index index,
                                                 Expression* expr) {
  auto setFlow = visit(expr);
  if (!setFlow.breaking()) {
    return setLocalValue(index, setFlow.values);
  }
  return false;
}

bool ContextAwareExpressionRunner::setGlobalValue(Name name, Literals& values) {
  if (values.isConcrete()) {
    globalValues[name] = values;
    return true;
  }
  globalValues.erase(name);
  return false;
}

bool ContextAwareExpressionRunner::setGlobalValue(Name name, Expression* expr) {
  auto setFlow = visit(expr);
  if (!setFlow.breaking()) {
    return setGlobalValue(name, setFlow.values);
  }
  return false;
}

Flow ContextAwareExpressionRunner::visitLoop(Loop* curr) {
  // loops might be infinite, so must be careful
  // but we can't tell if non-infinite, since we don't have state, so loops
  // are just impossible to optimize for now
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitCall(Call* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitCallIndirect(CallIndirect* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitLocalGet(LocalGet* curr) {
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

Flow ContextAwareExpressionRunner::visitLocalSet(LocalSet* curr) {
  if (mode == Mode::EVALUATE) {
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

Flow ContextAwareExpressionRunner::visitGlobalGet(GlobalGet* curr) {
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

Flow ContextAwareExpressionRunner::visitGlobalSet(GlobalSet* curr) {
  if (mode == Mode::EVALUATE) {
    // If we are evaluating and not replacing the expression, remember the
    // constant value set, if any, for subsequent gets.
    assert(module->getGlobal(curr->name)->mutable_);
    if (setGlobalValue(curr->name, curr->value)) {
      return Flow();
    }
  }
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitLoad(Load* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitStore(Store* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitAtomicRMW(AtomicRMW* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitAtomicCmpxchg(AtomicCmpxchg* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitAtomicWait(AtomicWait* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitAtomicNotify(AtomicNotify* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitSIMDLoad(SIMDLoad* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitMemoryInit(MemoryInit* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitDataDrop(DataDrop* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitMemoryCopy(MemoryCopy* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitMemoryFill(MemoryFill* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitHost(Host* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitTry(Try* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitThrow(Throw* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitRethrow(Rethrow* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitBrOnExn(BrOnExn* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitPush(Push* curr) {
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitPop(Pop* curr) {
  return Flow(NONCONSTANT_FLOW);
}

void ContextAwareExpressionRunner::trap(const char* why) {
  throw NonconstantException();
}

} // namespace wasm
