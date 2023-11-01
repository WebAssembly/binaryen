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

#include "analysis/cfg.h"
#include "analysis/lattice.h"
#include "analysis/lattices/inverted.h"
#include "analysis/lattices/shared.h"
#include "analysis/lattices/stack.h"
#include "analysis/lattices/tuple.h"
#include "analysis/lattices/valtype.h"
#include "analysis/lattices/vector.h"
#include "analysis/monotone-analyzer.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-traversal.h"
#include "wasm.h"

#define TYPE_GENERALIZING_DEBUG 0

#if TYPE_GENERALIZING_DEBUG
#define DBG(statement) statement
#else
#define DBG(statement)
#endif

// Generalize the types of program locations as much as possible, both to
// eliminate unnecessarily refined types from the type section and (TODO) to
// weaken casts that cast to unnecessarily refined types. If the casts are
// weakened enough, they will be able to be removed by OptimizeInstructions.
//
// Perform a backward analysis tracking requirements on the types of program
// locations (currently just locals and stack values) to discover how much the
// type of each location can be generalized without breaking validation or
// changing program behavior.

namespace wasm {

namespace {

using namespace analysis;

// We will learn stricter and stricter requirements as we perform the analysis,
// so more specific types need to be higher up the lattice.
using TypeRequirement = Inverted<ValType>;

// Record a type requirement for each local variable. Shared the requirements
// across basic blocks.
using LocalTypeRequirements = Shared<Vector<TypeRequirement>>;

// The type requirements for each reference-typed value on the stack at a
// particular location.
using ValueStackTypeRequirements = Stack<TypeRequirement>;

// The full lattice used for the analysis.
using StateLattice =
  analysis::Tuple<LocalTypeRequirements, ValueStackTypeRequirements>;

// Equip the state lattice with helpful accessors.
struct State : StateLattice {
  using Element = StateLattice::Element;

  static constexpr int LocalsIndex = 0;
  static constexpr int StackIndex = 1;

  State(Function* func) : StateLattice{Shared{initLocals(func)}, initStack()} {}

  void push(Element& elem, Type type) const noexcept {
    stackLattice().push(stack(elem), std::move(type));
  }

  Type pop(Element& elem) const noexcept {
    return stackLattice().pop(stack(elem));
  }

  void clearStack(Element& elem) const noexcept {
    stack(elem) = stackLattice().getBottom();
  }

  const std::vector<Type>& getLocals(Element& elem) const noexcept {
    return *locals(elem);
  }

  const std::vector<Type>& getLocals() const noexcept {
    return *locals(getBottom());
  }

  Type getLocal(Element& elem, Index i) const noexcept {
    return getLocals(elem)[i];
  }

  void updateLocal(Element& elem, Index i, Type type) const noexcept {
    localsLattice().join(
      locals(elem),
      Vector<TypeRequirement>::SingletonElement(i, std::move(type)));
  }

private:
  static LocalTypeRequirements initLocals(Function* func) noexcept {
    return Shared{Vector{Inverted{ValType{}}, func->getNumLocals()}};
  }

  static ValueStackTypeRequirements initStack() noexcept {
    return Stack{Inverted{ValType{}}};
  }

  const LocalTypeRequirements& localsLattice() const noexcept {
    return std::get<LocalsIndex>(lattices);
  }

  const ValueStackTypeRequirements& stackLattice() const noexcept {
    return std::get<StackIndex>(lattices);
  }

  typename LocalTypeRequirements::Element&
  locals(Element& elem) const noexcept {
    return std::get<LocalsIndex>(elem);
  }

  const typename LocalTypeRequirements::Element&
  locals(const Element& elem) const noexcept {
    return std::get<LocalsIndex>(elem);
  }

  typename ValueStackTypeRequirements::Element&
  stack(Element& elem) const noexcept {
    return std::get<StackIndex>(elem);
  }

  const typename ValueStackTypeRequirements::Element&
  stack(const Element& elem) const noexcept {
    return std::get<StackIndex>(elem);
  }
};

struct TransferFn : OverriddenVisitor<TransferFn> {
  Module& wasm;
  Function* func;
  State lattice;
  typename State::Element* state = nullptr;

  TransferFn(Module& wasm, Function* func)
    : wasm(wasm), func(func), lattice(func) {}

  Type pop() noexcept { return lattice.pop(*state); }
  void push(Type type) noexcept { lattice.push(*state, type); }
  void clearStack() noexcept { lattice.clearStack(*state); }
  Type getLocal(Index i) noexcept { return lattice.getLocal(*state, i); }
  void updateLocal(Index i, Type type) noexcept {
    // TODO: Collect possible successor blocks that might depend on an updated
    // local requirement here.
    return lattice.updateLocal(*state, i, type);
  }

  void dumpState() {
#if TYPE_GENERALIZING_DEBUG
    std::cerr << "locals: ";
    for (size_t i = 0, n = lattice.getLocals(*state).size(); i < n; ++i) {
      if (i != 0) {
        std::cerr << ", ";
      }
      std::cerr << getLocal(i);
    }
    std::cerr << "\nstack: ";
    auto& stack = std::get<1>(*state);
    for (size_t i = 0, n = stack.size(); i < n; ++i) {
      if (i != 0) {
        std::cerr << ", ";
      }
      std::cerr << stack[i];
    }
    std::cerr << "\n";
#endif // TYPE_GENERALIZING_DEBUG
  }

  std::vector<const BasicBlock*>
  transfer(const BasicBlock& bb, typename State::Element& elem) noexcept {
    DBG(std::cerr << "transferring bb " << bb.getIndex() << "\n");
    state = &elem;
    // This is a backward analysis: The constraints on a type depend on how it
    // will be used in the future. Traverse the basic block in reverse.
    dumpState();
    if (bb.isExit()) {
      DBG(std::cerr << "visiting exit\n");
      visitFunctionExit();
      dumpState();
    }
    for (auto it = bb.rbegin(); it != bb.rend(); ++it) {
      DBG(std::cerr << "visiting " << ShallowExpression{*it} << "\n");
      visit(*it);
      dumpState();
    }
    DBG(std::cerr << "\n");

    state = nullptr;

    // Return the blocks that may need to be re-analyzed.
    const auto& preds = bb.preds();
    std::vector<const BasicBlock*> dependents;
    dependents.reserve(preds.size());
    dependents.insert(dependents.end(), preds.begin(), preds.end());
    return dependents;
  }

  void visitFunctionExit() {
    // We cannot change the types of parameters, so require that they have their
    // original types.
    Index i = 0;
    Index numParams = func->getNumParams();
    Index numLocals = func->getNumLocals();
    for (; i < numParams; ++i) {
      updateLocal(i, func->getLocalType(i));
    }
    // We also cannot change the types of any other non-ref locals. For
    // reference-typed locals, we cannot generalize beyond their top type.
    for (; i < numLocals; ++i) {
      auto type = func->getLocalType(i);
      // TODO: Support optimizing tuple locals.
      if (type.isRef()) {
        updateLocal(i, Type(type.getHeapType().getTop(), Nullable));
      } else {
        updateLocal(i, type);
      }
    }
    // We similarly cannot change the types of results. Push requirements that
    // the stack end up with the correct type.
    if (auto result = func->getResults(); result.isRef()) {
      push(result);
    }
  }

  void visitNop(Nop* curr) {}
  void visitBlock(Block* curr) {}
  void visitIf(If* curr) {}
  void visitLoop(Loop* curr) {}
  void visitBreak(Break* curr) {
    // TODO: pop extra elements off stack, keeping only those at the top that
    // will be sent along.
    WASM_UNREACHABLE("TODO");
  }

  void visitSwitch(Switch* curr) {
    // TODO: pop extra elements off stack, keeping only those at the top that
    // will be sent along.
    WASM_UNREACHABLE("TODO");
  }

  void visitCall(Call* curr) {
    // TODO: pop ref types from results, push ref types from params
    WASM_UNREACHABLE("TODO");
  }

  void visitCallIndirect(CallIndirect* curr) {
    // TODO: pop ref types from results, push ref types from params
    WASM_UNREACHABLE("TODO");
  }

  void visitLocalGet(LocalGet* curr) {
    if (!curr->type.isRef()) {
      return;
    }
    // Propagate the requirement on the local.get output to the local.
    updateLocal(curr->index, pop());
  }

  void visitLocalSet(LocalSet* curr) {
    if (!curr->value->type.isRef()) {
      return;
    }
    if (curr->isTee()) {
      // Same as the local.get.
      updateLocal(curr->index, pop());
    }
    // Propagate the requirement on the local to our input value.
    push(getLocal(curr->index));
  }

  void visitGlobalGet(GlobalGet* curr) { WASM_UNREACHABLE("TODO"); }
  void visitGlobalSet(GlobalSet* curr) { WASM_UNREACHABLE("TODO"); }
  void visitLoad(Load* curr) { WASM_UNREACHABLE("TODO"); }
  void visitStore(Store* curr) { WASM_UNREACHABLE("TODO"); }
  void visitAtomicRMW(AtomicRMW* curr) { WASM_UNREACHABLE("TODO"); }
  void visitAtomicCmpxchg(AtomicCmpxchg* curr) { WASM_UNREACHABLE("TODO"); }
  void visitAtomicWait(AtomicWait* curr) { WASM_UNREACHABLE("TODO"); }
  void visitAtomicNotify(AtomicNotify* curr) { WASM_UNREACHABLE("TODO"); }
  void visitAtomicFence(AtomicFence* curr) { WASM_UNREACHABLE("TODO"); }
  void visitSIMDExtract(SIMDExtract* curr) { WASM_UNREACHABLE("TODO"); }
  void visitSIMDReplace(SIMDReplace* curr) { WASM_UNREACHABLE("TODO"); }
  void visitSIMDShuffle(SIMDShuffle* curr) { WASM_UNREACHABLE("TODO"); }
  void visitSIMDTernary(SIMDTernary* curr) { WASM_UNREACHABLE("TODO"); }
  void visitSIMDShift(SIMDShift* curr) { WASM_UNREACHABLE("TODO"); }
  void visitSIMDLoad(SIMDLoad* curr) { WASM_UNREACHABLE("TODO"); }
  void visitSIMDLoadStoreLane(SIMDLoadStoreLane* curr) {
    WASM_UNREACHABLE("TODO");
  }
  void visitMemoryInit(MemoryInit* curr) { WASM_UNREACHABLE("TODO"); }
  void visitDataDrop(DataDrop* curr) { WASM_UNREACHABLE("TODO"); }
  void visitMemoryCopy(MemoryCopy* curr) { WASM_UNREACHABLE("TODO"); }
  void visitMemoryFill(MemoryFill* curr) { WASM_UNREACHABLE("TODO"); }
  void visitConst(Const* curr) {}
  void visitUnary(Unary* curr) {}
  void visitBinary(Binary* curr) {}
  void visitSelect(Select* curr) { WASM_UNREACHABLE("TODO"); }
  void visitDrop(Drop* curr) {
    if (curr->type.isRef()) {
      pop();
    }
  }
  void visitReturn(Return* curr) { WASM_UNREACHABLE("TODO"); }
  void visitMemorySize(MemorySize* curr) { WASM_UNREACHABLE("TODO"); }
  void visitMemoryGrow(MemoryGrow* curr) { WASM_UNREACHABLE("TODO"); }
  void visitUnreachable(Unreachable* curr) {
    // Require nothing about values flowing into an unreachable.
    clearStack();
  }
  void visitPop(Pop* curr) { WASM_UNREACHABLE("TODO"); }
  void visitRefNull(RefNull* curr) { WASM_UNREACHABLE("TODO"); }
  void visitRefIsNull(RefIsNull* curr) { WASM_UNREACHABLE("TODO"); }
  void visitRefFunc(RefFunc* curr) { WASM_UNREACHABLE("TODO"); }
  void visitRefEq(RefEq* curr) { WASM_UNREACHABLE("TODO"); }
  void visitTableGet(TableGet* curr) { WASM_UNREACHABLE("TODO"); }
  void visitTableSet(TableSet* curr) { WASM_UNREACHABLE("TODO"); }
  void visitTableSize(TableSize* curr) { WASM_UNREACHABLE("TODO"); }
  void visitTableGrow(TableGrow* curr) { WASM_UNREACHABLE("TODO"); }
  void visitTableFill(TableFill* curr) { WASM_UNREACHABLE("TODO"); }
  void visitTry(Try* curr) { WASM_UNREACHABLE("TODO"); }
  void visitThrow(Throw* curr) { WASM_UNREACHABLE("TODO"); }
  void visitRethrow(Rethrow* curr) { WASM_UNREACHABLE("TODO"); }
  void visitTupleMake(TupleMake* curr) { WASM_UNREACHABLE("TODO"); }
  void visitTupleExtract(TupleExtract* curr) { WASM_UNREACHABLE("TODO"); }
  void visitRefI31(RefI31* curr) { pop(); }
  void visitI31Get(I31Get* curr) {
    // Do not allow relaxing to nullable if the input is already non-nullable.
    if (curr->i31->type.isNonNullable()) {
      push(Type(HeapType::i31, NonNullable));
    } else {
      push(Type(HeapType::i31, Nullable));
    }
  }
  void visitCallRef(CallRef* curr) { WASM_UNREACHABLE("TODO"); }
  void visitRefTest(RefTest* curr) { WASM_UNREACHABLE("TODO"); }
  void visitRefCast(RefCast* curr) { WASM_UNREACHABLE("TODO"); }
  void visitBrOn(BrOn* curr) { WASM_UNREACHABLE("TODO"); }
  void visitStructNew(StructNew* curr) { WASM_UNREACHABLE("TODO"); }
  void visitStructGet(StructGet* curr) { WASM_UNREACHABLE("TODO"); }
  void visitStructSet(StructSet* curr) { WASM_UNREACHABLE("TODO"); }
  void visitArrayNew(ArrayNew* curr) { WASM_UNREACHABLE("TODO"); }
  void visitArrayNewData(ArrayNewData* curr) { WASM_UNREACHABLE("TODO"); }
  void visitArrayNewElem(ArrayNewElem* curr) { WASM_UNREACHABLE("TODO"); }
  void visitArrayNewFixed(ArrayNewFixed* curr) { WASM_UNREACHABLE("TODO"); }
  void visitArrayGet(ArrayGet* curr) { WASM_UNREACHABLE("TODO"); }
  void visitArraySet(ArraySet* curr) { WASM_UNREACHABLE("TODO"); }
  void visitArrayLen(ArrayLen* curr) { WASM_UNREACHABLE("TODO"); }
  void visitArrayCopy(ArrayCopy* curr) { WASM_UNREACHABLE("TODO"); }
  void visitArrayFill(ArrayFill* curr) { WASM_UNREACHABLE("TODO"); }
  void visitArrayInitData(ArrayInitData* curr) { WASM_UNREACHABLE("TODO"); }
  void visitArrayInitElem(ArrayInitElem* curr) { WASM_UNREACHABLE("TODO"); }
  void visitRefAs(RefAs* curr) { WASM_UNREACHABLE("TODO"); }
  void visitStringNew(StringNew* curr) { WASM_UNREACHABLE("TODO"); }
  void visitStringConst(StringConst* curr) { WASM_UNREACHABLE("TODO"); }
  void visitStringMeasure(StringMeasure* curr) { WASM_UNREACHABLE("TODO"); }
  void visitStringEncode(StringEncode* curr) { WASM_UNREACHABLE("TODO"); }
  void visitStringConcat(StringConcat* curr) { WASM_UNREACHABLE("TODO"); }
  void visitStringEq(StringEq* curr) { WASM_UNREACHABLE("TODO"); }
  void visitStringAs(StringAs* curr) { WASM_UNREACHABLE("TODO"); }
  void visitStringWTF8Advance(StringWTF8Advance* curr) {
    WASM_UNREACHABLE("TODO");
  }
  void visitStringWTF16Get(StringWTF16Get* curr) { WASM_UNREACHABLE("TODO"); }
  void visitStringIterNext(StringIterNext* curr) { WASM_UNREACHABLE("TODO"); }
  void visitStringIterMove(StringIterMove* curr) { WASM_UNREACHABLE("TODO"); }
  void visitStringSliceWTF(StringSliceWTF* curr) { WASM_UNREACHABLE("TODO"); }
  void visitStringSliceIter(StringSliceIter* curr) { WASM_UNREACHABLE("TODO"); }
};

struct TypeGeneralizing : WalkerPass<PostWalker<TypeGeneralizing>> {
  std::vector<Type> localTypes;
  bool refinalize = false;

  bool isFunctionParallel() override { return true; }
  std::unique_ptr<Pass> create() {
    return std::make_unique<TypeGeneralizing>();
  }

  void runOnFunction(Module* wasm, Function* func) override {
    TransferFn txfn(*wasm, func);
    auto cfg = CFG::fromFunction(func);
    DBG(cfg.print(std::cerr));
    MonotoneCFGAnalyzer analyzer(txfn.lattice, txfn, cfg);
    analyzer.evaluate();

    // Optimize local types. TODO: Optimize casts as well.
    localTypes = txfn.lattice.getLocals();
    auto numParams = func->getNumParams();
    for (Index i = numParams; i < localTypes.size(); ++i) {
      func->vars[i - numParams] = localTypes[i];
    }

    // Update gets and sets accordingly.
    super::runOnFunction(wasm, func);

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
