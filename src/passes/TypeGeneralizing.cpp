/*
 * Copyright 2023 WebAssembly Community Group participants
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
// Generalize the types of locals as much as possible, both to eliminate
// unnecessarily refined types from the type section and (TODO) to weaken casts
// that cast to unnecessarily refined types. If the casts are weakened enough,
// they will be able to be removed by OptimizeInstructions.
//
// Uses SubtypingDiscoverer to find all subtyping constraints on expressions and
// locals, and computes the greatest lower bound (GLB) of the required supertypes
// for each local so that each local is given the least-refined valid type.
//

#include <unordered_map>
#include <variant>
#include <vector>

#include "ir/glbs.h"
#include "ir/subtype-exprs.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace {

struct Generalizer
  : public ControlFlowWalker<Generalizer, SubtypingDiscoverer<Generalizer>> {
  Function* func;

  // For each expression and local, track the GLB of all types it is required to
  // be a subtype of.
  std::unordered_map<Expression*, GLBFinder> exprGLBs;
  std::vector<GLBFinder> localGLBs;

  // Map from an expression to the sub-expressions whose types flow out of it
  // (or depend on its required output type, as in RefAs).
  std::unordered_map<Expression*, std::vector<Expression*>> exprSubs;

  // For each local, the values assigned to it via local.set / local.tee.
  std::vector<std::vector<Expression*>> localSetValues;

  using WorkItem = std::variant<Expression*, Index>;
  std::vector<WorkItem> worklist;

  Generalizer(Function* func)
    : func(func), localGLBs(func->getNumLocals()),
      localSetValues(func->getNumLocals()) {}

  void addConstraint(Expression* expr, Type type) {
    if (!expr->type.isRef() || !type.isRef()) {
      return;
    }
    auto& glb = exprGLBs[expr];
    auto old = glb.getGLB();
    glb.note(type);
    if (glb.getGLB() != old) {
      worklist.push_back(expr);
    }
  }

  void addConstraint(Index local, Type type) {
    if (!func->isVar(local) || !func->getLocalType(local).isRef() ||
        !type.isRef()) {
      return;
    }
    auto& glb = localGLBs[local];
    auto old = glb.getGLB();
    glb.note(type);
    if (glb.getGLB() != old) {
      worklist.push_back(local);
    }
  }

  void noteSubtype(Type sub, Type super) {}
  void noteSubtype(HeapType sub, HeapType super) {}
  void noteSubtype(Type sub, Expression* super) {}
  void noteSubtype(Expression* sub, Type super) { addConstraint(sub, super); }
  void noteSubtype(Expression* sub, Expression* super) {
    exprSubs[super].push_back(sub);
  }
  void noteNonFlowSubtype(Expression* sub, Type super) {
    addConstraint(sub, super);
  }
  void noteCast(HeapType src, Type dst) {}
  void noteCast(Expression* src, Type dst) {}
  void noteCast(Expression* src, Expression* dst) {}

  void visitLocalGet(LocalGet* curr) {}

  void visitLocalSet(LocalSet* curr) {
    auto* func = getFunction();
    auto localType = func->getLocalType(curr->index);
    if (func->isParam(curr->index)) {
      // Parameters have fixed types.
      addConstraint(curr->value, localType);
    } else if (localType.isRef()) {
      localSetValues[curr->index].push_back(curr->value);
    }
  }

  void visitRefAs(RefAs* curr) {
    // All RefAs ops have output types that depend on their input types, and we
    // will refinalize them if their input types generalize. Propagate any
    // requirement on the output back to the input.
    exprSubs[curr].push_back(curr->value);
  }

  void propagate() {
    while (!worklist.empty()) {
      auto item = worklist.back();
      worklist.pop_back();
      if (auto* exprPtr = std::get_if<Expression*>(&item)) {
        auto* expr = *exprPtr;
        auto type = exprGLBs[expr].getGLB();
        if (auto* get = expr->dynCast<LocalGet>()) {
          addConstraint(get->index, type);
        } else if (auto* set = expr->dynCast<LocalSet>()) {
          if (set->isTee()) {
            addConstraint(set->index, type);
          }
        } else if (auto* as = expr->dynCast<RefAs>()) {
          auto share = type.getHeapType().getShared();
          switch (as->op) {
            case RefAsNonNull:
              type = type.with(Nullable);
              break;
            case AnyConvertExtern:
              type = Type(HeapTypes::ext.getBasic(share), type.getNullability());
              break;
            case ExternConvertAny:
              type = Type(HeapTypes::any.getBasic(share), type.getNullability());
              break;
          }
        }
        if (auto it = exprSubs.find(expr); it != exprSubs.end()) {
          for (auto* sub : it->second) {
            addConstraint(sub, type);
          }
        }
      } else {
        auto local = std::get<Index>(item);
        auto type = localGLBs[local].getGLB();
        for (auto* val : localSetValues[local]) {
          addConstraint(val, type);
        }
      }
    }
  }
};

struct TypeGeneralizing : WalkerPass<PostWalker<TypeGeneralizing>> {
  std::vector<Type> localTypes;
  bool refinalize = false;

  bool isFunctionParallel() override { return true; }
  std::unique_ptr<Pass> create() override {
    return std::make_unique<TypeGeneralizing>();
  }

  void runOnFunction(Module* wasm, Function* func) override {
    // First, remove unreachable code. If we didn't, the unreachable code could
    // become invalid after this optimization because SubtypingDiscoverer does
    // not constrain unreachable expressions in all cases.
    PassRunner runner(getPassRunner());
    runner.add("dce");
    runner.runOnFunction(func);

    Generalizer generalizer(func);
    generalizer.walkFunctionInModule(func, wasm);
    generalizer.propagate();

    // Optimize local types. TODO: Optimize casts as well.
    auto numLocals = func->getNumLocals();
    auto numParams = func->getNumParams();
    localTypes.resize(numLocals);
    for (Index i = 0; i < numParams; ++i) {
      localTypes[i] = func->getLocalType(i);
    }
    for (Index i = numParams; i < numLocals; ++i) {
      auto origType = func->getLocalType(i);
      if (origType.isRef()) {
        auto& glb = generalizer.localGLBs[i];
        auto newType = glb.noted()
                         ? glb.getGLB()
                         : Type(origType.getHeapType().getTop(), Nullable);
        localTypes[i] = newType;
        func->vars[i - numParams] = newType;
      } else {
        localTypes[i] = origType;
      }
    }

    // Update gets and sets accordingly.
    Super::runOnFunction(wasm, func);

    if (refinalize) {
      ReFinalize().walkFunctionInModule(func, wasm);
    }
  }

  void visitLocalGet(LocalGet* curr) {
    if (localTypes[curr->index] != curr->type) {
      curr->type = localTypes[curr->index];
      refinalize = true;
    }
  }

  void visitLocalSet(LocalSet* curr) {
    if (curr->isTee() && localTypes[curr->index] != curr->type) {
      curr->type = localTypes[curr->index];
      refinalize = true;
    }
  }
};

} // anonymous namespace

Pass* createTypeGeneralizingPass() { return new TypeGeneralizing; }

} // namespace wasm
