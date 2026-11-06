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

#include <optional>
#include <unordered_map>
#include <variant>
#include <vector>

#include "ir/branch-utils.h"
#include "ir/child-typer.h"
#include "ir/glbs.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace {

// Find the most general supertype of a signature type that does not change
// parameter types (which are contravariant and would restrict argument
// generalization) and whose result type satisfies `resultReq`, if any.
HeapType generalizeCallRefTarget(HeapType sigType,
                                 std::optional<Type> resultReq = std::nullopt) {
  auto sig = sigType.getSignature();
  auto numParams = sig.params.size();
  auto targetReq = sigType;
  while (true) {
    auto candidateReq = targetReq.getDeclaredSuperType();
    if (!candidateReq) {
      break;
    }
    auto candidateSig = candidateReq->getSignature();
    if (resultReq && !Type::isSubType(candidateSig.results, *resultReq)) {
      break;
    }
    for (size_t i = 0; i < numParams; ++i) {
      if (candidateSig.params[i] != sig.params[i]) {
        return targetReq;
      }
    }
    targetReq = *candidateReq;
  }
  return targetReq;
}

// Find the most general supertype of a struct type that still has a field at
// `index` whose type satisfies `reqFieldType`, if any.
HeapType generalizeStructType(HeapType type,
                              Index index,
                              std::optional<Type> reqFieldType = std::nullopt) {
  while (true) {
    auto candidateType = type.getDeclaredSuperType();
    if (!candidateType) {
      break;
    }
    const auto& candidateFields = candidateType->getStruct().fields;
    if (candidateFields.size() <= index) {
      break;
    }
    if (reqFieldType) {
      auto candidateFieldType = candidateFields[index].type;
      if (!Type::isSubType(candidateFieldType, *reqFieldType)) {
        break;
      }
    }
    type = *candidateType;
  }
  return type;
}

// Find the most general supertype of an array type whose element type satisfies
// `reqElemType`, if any.
HeapType generalizeArrayType(HeapType type,
                             std::optional<Type> reqElemType = std::nullopt) {
  while (true) {
    auto candidateType = type.getDeclaredSuperType();
    if (!candidateType) {
      break;
    }
    if (reqElemType) {
      auto candidateElemType = candidateType->getArray().element.type;
      if (!Type::isSubType(candidateElemType, *reqElemType)) {
        break;
      }
    }
    type = *candidateType;
  }
  return type;
}

// Use ChildTyper to find all subtyping constraints on expressions and locals,
// and compute the greatest lower bound (GLB) of the required supertypes for
// each local so that each local is given the least-refined valid type.
//
// TODO: handle ref.as_non_null, br_on_null, publish, br_if, etc. better: we do
//       not need to consider their results fixed.
struct Generalizer : public ChildTyper<Generalizer> {

  using Super = ChildTyper<Generalizer>;

  // For each expression and local, track the GLB of all types it is required to
  // be a subtype of.
  std::unordered_map<Expression*, GLBFinder> exprGLBs;
  std::vector<GLBFinder> localGLBs;

  // Map from an expression to the sub-expressions whose types flow out of it
  // (or depend on its required output type, as in RefAs).
  std::unordered_map<Expression*, std::vector<Expression*>> exprSubs;

  // For each local, the values assigned to it via local.set / local.tee.
  std::vector<std::vector<Expression*>> localSetValues;

  // We use a worklist of things to process: expressions and local indexes.
  using WorkItem = std::variant<Expression*, Index>;
  std::vector<WorkItem> worklist;

  Expression* currExpr = nullptr;

  struct Walker : ControlFlowWalker<Walker, UnifiedExpressionVisitor<Walker>> {
    Generalizer& generalizer;
    Walker(Generalizer& generalizer) : generalizer(generalizer) {}
    void visitExpression(Expression* curr) {
      generalizer.currExpr = curr;
      generalizer.visit(curr);
    }
  } walker{*this};

  Generalizer(Module& wasm, Function* func)
    : Super(wasm, func), localGLBs(func->getNumLocals()),
      localSetValues(func->getNumLocals()) {}

  void walk() {
    addConstraint(func->body, func->getResults());
    walker.walkFunctionInModule(func, &wasm);
  }

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

  Type getLabelType(Name label) { return walker.findBreakTarget(label)->type; }

  void noteUnknown() {
    for (auto* child : ChildIterator(currExpr)) {
      addConstraint(child, child->type);
    }
  }

  void note(Expression** childp, Constraints type) {
    auto* child = *childp;
    if (!child->type.isRef()) {
      return;
    }
    assert(type.size() == 1);
    if (auto* t = std::get_if<Type>(&type[0])) {
      addConstraint(child, *t);
    } else if (auto* ref = std::get_if<VarRef>(&type[0])) {
      auto* nullp = std::get_if<Nullability>(&ref->null);
      auto null = nullp ? *nullp : Nullable;
      if (std::holds_alternative<Index>(ref->ht)) {
        addConstraint(child, Type(child->type.getHeapType().getTop(), null));
      } else if (auto* abs = std::get_if<VarAbsHeapType>(&ref->ht)) {
        auto* sharep = std::get_if<Shareability>(&abs->share);
        auto share = sharep ? *sharep : child->type.getHeapType().getShared();
        addConstraint(child, Type(abs->ht.getBasic(share), null));
      } else if (auto* def = std::get_if<VarDefHeapType>(&ref->ht)) {
        auto* exactp = std::get_if<Exactness>(&def->exact);
        auto exact = exactp ? *exactp : Inexact;
        addConstraint(child, Type(def->ht, null, exact));
      } else {
        WASM_UNREACHABLE("unexpected bottom heap type");
      }
    } else {
      // Unconstrained type variable (e.g. drop).
      assert(std::holds_alternative<Index>(type[0]));
    }
  }

  // Control flow handling. TODO: Perhaps find a way to do this in ChildTyper,
  // or a helper that extends ChildTyper?
  void visitBlock(Block* curr) {
    if (!curr->list.empty()) {
      exprSubs[curr].push_back(curr->list.back());
    }
  }

  void visitIf(If* curr) {
    if (curr->ifFalse && curr->type != Type::unreachable) {
      exprSubs[curr].push_back(curr->ifTrue);
      exprSubs[curr].push_back(curr->ifFalse);
    }
  }

  void visitLoop(Loop* curr) { exprSubs[curr].push_back(curr->body); }

  void visitBreak(Break* curr) {
    if (curr->value) {
      exprSubs[walker.findBreakTarget(curr->name)].push_back(curr->value);
      if (curr->condition && curr->type != Type::unreachable) {
        exprSubs[curr].push_back(curr->value);
      }
    }
  }

  void visitSwitch(Switch* curr) {
    if (curr->value) {
      for (auto name : BranchUtils::getUniqueTargets(curr)) {
        exprSubs[walker.findBreakTarget(name)].push_back(curr->value);
      }
    }
  }

  void visitSelect(Select* curr) {
    exprSubs[curr].push_back(curr->ifTrue);
    exprSubs[curr].push_back(curr->ifFalse);
  }

  void visitTry(Try* curr) {
    exprSubs[curr].push_back(curr->body);
    for (auto* body : curr->catchBodies) {
      exprSubs[curr].push_back(body);
    }
  }

  void visitTryTable(TryTable* curr) { exprSubs[curr].push_back(curr->body); }

  void visitLocalSet(LocalSet* curr) {
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

  void visitBrOn(BrOn* curr) {
    // Note immediate constraints (including descriptor constraints).
    Super::visitBrOn(curr);
    if (curr->desc && curr->desc->type.isBottomRef()) {
      return;
    }
    switch (curr->op) {
      case BrOnNull:
        // If we do not branch, we flow out the non-null input.
        if (curr->type.isRef()) {
          addConstraint(curr->ref, curr->type.with(Nullable));
        }
        break;
      case BrOnNonNull: {
        // If we branch, we send the non-null input to the target.
        auto* breakTarget = walker.findBreakTarget(curr->name);
        if (breakTarget->type.isRef()) {
          addConstraint(curr->ref, breakTarget->type.with(Nullable));
        }
        break;
      }
      case BrOnCast:
      case BrOnCastDescEq:
        // If we do not branch, we flow out the original input when the cast
        // fails. If the cast type is nullable then nulls take the branch, so
        // the fallthrough value is made non-nullable.
        if (curr->type.isRef()) {
          auto type = curr->type;
          if (curr->castType.isNullableRef()) {
            type = type.with(Nullable);
          }
          addConstraint(curr->ref, type);
        }
        break;
      case BrOnCastFail:
      case BrOnCastDescEqFail: {
        // We send the original input along when the cast fails, so the input
        // must be sendable to the target. If the cast type is nullable then
        // nulls do not fail the cast, so the sent value is non-nullable.
        auto* breakTarget = walker.findBreakTarget(curr->name);
        if (breakTarget->type.isRef()) {
          auto type = breakTarget->type;
          if (curr->castType.isNullableRef()) {
            type = type.with(Nullable);
          }
          addConstraint(curr->ref, type);
        }
        break;
      }
    }
  }

  void visitPublish(Publish* curr) {
    // TODO: Propagate output constraints back to the input, like RefAs.
    addConstraint(curr->ref, curr->ref->type);
  }

  void visitTupleMake(TupleMake* curr) {
    // TODO: Track constraints on tuple elements.
    for (auto* op : curr->operands) {
      addConstraint(op, op->type);
    }
  }

  void visitCallRef(CallRef* curr) {
    if (!curr->target->type.isSignature()) {
      Super::visitCallRef(curr);
      return;
    }
    auto sigType = curr->target->type.getHeapType();
    std::optional<Type> resultReq;
    if (curr->isReturn) {
      resultReq = func->getResults();
    }
    auto generalized = generalizeCallRefTarget(sigType, resultReq);
    Super::visitCallRef(curr, generalized);
  }

  void visitStructGet(StructGet* curr) {
    if (!curr->ref->type.isStruct()) {
      Super::visitStructGet(curr);
      return;
    }
    auto generalized =
      generalizeStructType(curr->ref->type.getHeapType(), curr->index);
    Super::visitStructGet(curr, generalized);
  }

  void visitStructSet(StructSet* curr) {
    if (!curr->ref->type.isStruct()) {
      Super::visitStructSet(curr);
      return;
    }
    auto generalized =
      generalizeStructType(curr->ref->type.getHeapType(), curr->index);
    Super::visitStructSet(curr, generalized);
  }

  void visitArrayGet(ArrayGet* curr) {
    if (!curr->ref->type.isArray()) {
      Super::visitArrayGet(curr);
      return;
    }
    auto generalized = generalizeArrayType(curr->ref->type.getHeapType());
    Super::visitArrayGet(curr, generalized);
  }

  void visitArraySet(ArraySet* curr) {
    if (!curr->ref->type.isArray()) {
      Super::visitArraySet(curr);
      return;
    }
    auto generalized = generalizeArrayType(curr->ref->type.getHeapType());
    Super::visitArraySet(curr, generalized);
  }

  void visitArrayCopy(ArrayCopy* curr) {
    if (!curr->destRef->type.isArray() || !curr->srcRef->type.isArray()) {
      Super::visitArrayCopy(curr);
      return;
    }
    auto destGen = generalizeArrayType(curr->destRef->type.getHeapType());
    auto elemType = destGen.getArray().element.type;
    std::optional<Type> reqElemType;
    if (elemType.isRef()) {
      reqElemType = elemType;
    }
    auto srcGen =
      generalizeArrayType(curr->srcRef->type.getHeapType(), reqElemType);
    Super::visitArrayCopy(curr, destGen, srcGen);
  }

  void visitArrayFill(ArrayFill* curr) {
    if (!curr->ref->type.isArray()) {
      Super::visitArrayFill(curr);
      return;
    }
    auto generalized = generalizeArrayType(curr->ref->type.getHeapType());
    Super::visitArrayFill(curr, generalized);
  }

  void visitArrayInitData(ArrayInitData* curr) {
    if (!curr->ref->type.isArray()) {
      Super::visitArrayInitData(curr);
      return;
    }
    auto generalized = generalizeArrayType(curr->ref->type.getHeapType());
    Super::visitArrayInitData(curr, generalized);
  }

  void visitArrayInitElem(ArrayInitElem* curr) {
    if (!curr->ref->type.isArray()) {
      Super::visitArrayInitElem(curr);
      return;
    }
    auto generalized = generalizeArrayType(curr->ref->type.getHeapType());
    Super::visitArrayInitElem(curr, generalized);
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
              type =
                Type(HeapTypes::ext.getBasic(share), type.getNullability());
              break;
            case ExternConvertAny:
              type =
                Type(HeapTypes::any.getBasic(share), type.getNullability());
              break;
          }
        } else if (auto* get = expr->dynCast<StructGet>()) {
          if (get->ref->type.isStruct()) {
            auto generalized = generalizeStructType(
              get->ref->type.getHeapType(), get->index, type);
            addConstraint(get->ref, Type(generalized, Nullable));
          }
        } else if (auto* get = expr->dynCast<ArrayGet>()) {
          if (get->ref->type.isArray()) {
            auto generalized =
              generalizeArrayType(get->ref->type.getHeapType(), type);
            addConstraint(get->ref, Type(generalized, Nullable));
          }
        } else if (auto* call = expr->dynCast<CallRef>()) {
          if (call->target->type.isSignature()) {
            auto generalized =
              generalizeCallRefTarget(call->target->type.getHeapType(), type);
            addConstraint(call->target, Type(generalized, Nullable));
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
    // become invalid after this optimization because ChildTyper does not
    // constrain unreachable expressions in all cases.
    PassRunner runner(getPassRunner());
    runner.add("dce");
    runner.runOnFunction(func);

    Generalizer generalizer(*wasm, func);
    generalizer.walk();
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
