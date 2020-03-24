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
// ContextAwareExpressionRunner
//

const Name ContextAwareExpressionRunner::NONCONSTANT_FLOW =
  "Binaryen|nonconstant";

ContextAwareExpressionRunner::ContextAwareExpressionRunner(Module* module,
                                                           Flags flags,
                                                           Index maxDepth,
                                                           GetValues* getValues)
  : ExpressionRunner<ContextAwareExpressionRunner>(maxDepth), module(module),
    getValues(getValues), flags(flags) {
  // Trap instead of aborting if we hit an invalid expression.
  trapIfInvalid = true;
}

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
  // Traverse into functions using the same mode, which we can also do
  // when replacing as long as the function does not have any side effects.
  // Might yield something useful for simple functions like `clamp`, sometimes
  // even if arguments are only partially constant or not constant at all.

  // Only traverse into functions if not in a function-parallel scenario, where
  // functions may or may not have been optimized already to something we can
  // traverse successfully.
  if (!(flags & FlagValues::PARALLEL)) {
    // Note that we are not a validator, so we skip calls to functions that do
    // not exist yet or where the signature does not match.
    auto* func = module->getFunctionOrNull(curr->target);
    if (func != nullptr && !func->imported()) {
      if (func->sig.results.isConcrete()) {
        auto numOperands = curr->operands.size();
        if (numOperands == func->getNumParams()) {
          ContextAwareExpressionRunner runner(module, flags, maxDepth);
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
  }
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
  if (!(flags & FlagValues::REPLACE)) {
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
  auto* global = module->getGlobalOrNull(curr->name);
  if (global != nullptr) {
    // Check if the global has an immutable value anyway
    if (!global->imported() && !global->mutable_) {
      return visit(global->init);
    }
    // Check if a constant value has been set in the context of this runner.
    auto iter = globalValues.find(curr->name);
    if (iter != globalValues.end()) {
      return Flow(std::move(iter->second));
    }
  }
  return Flow(NONCONSTANT_FLOW);
}

Flow ContextAwareExpressionRunner::visitGlobalSet(GlobalSet* curr) {
  if (!(flags & FlagValues::REPLACE)) {
    // If we are evaluating and not replacing the expression, remember the
    // constant value set, if any, for subsequent gets.
    auto* global = module->getGlobalOrNull(curr->name);
    if (global != nullptr && global->mutable_) {
      if (setGlobalValue(curr->name, curr->value)) {
        return Flow();
      }
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
