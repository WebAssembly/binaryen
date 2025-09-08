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

#ifndef wasm_passes_stringify_walker_h
#define wasm_passes_stringify_walker_h

#include <queue>

#include "ir/iteration.h"
#include "ir/module-utils.h"
#include "wasm-traversal.h"

namespace wasm {

/*
 * This walker does a normal postorder traversal except that it defers
 * traversing the contents of control flow structures it encounters. This
 * effectively un-nests control flow.
 *
 * For example, the below (contrived) wat:
 * 1 : (block
 * 2 :   (if
 * 3 :     (i32.const 0)
 * 4 :     (then (return (i32.const 1)))
 * 5 :     (else (return (i32.const 0)))))
 * 6 :   (drop
 * 7 :     (i32.add
 * 8 :       (i32.const 20)
 * 9 :       (i32.const 10)))
 * 10:   (if
 * 11:     (i32.const 1)
 * 12:     (then (return (i32.const 2)))
 * 14: )
 * Would have its expressions visited in the following order (based on line
 * number):
 * 1, 3, 2, 8, 9, 7, 6, 11, 10, 4, 5, 12
 *
 * Of note:
 *   - The visits to if-True on line 4 and if-False on line 5 are deferred until
 *     after the rest of the siblings of the if expression on line 2 are
 *     visited.
 *   - The if-condition (i32.const 0) on line 3 is visited before the if
 *     expression on line 2. Similarly, the if-condition (i32.const 1) on line
 *     11 is visited before the if expression on line 10.
 *   - The add (line 7) binary operator's left and right children (lines 8 - 9)
 *     are visited first as they need to be on the stack before the add
 *     operation is executed.
 */

template<typename SubType>
struct StringifyWalker
  : public PostWalker<SubType, UnifiedExpressionVisitor<SubType>> {

  using Super = PostWalker<SubType, UnifiedExpressionVisitor<SubType>>;

  struct SeparatorReason {
    struct FuncStart {
      Function* func;
    };

    struct BlockStart {
      Block* block;
    };

    struct IfStart {
      If* iff;
    };

    struct ElseStart {};

    struct LoopStart {
      Loop* loop;
    };

    struct TryStart {
      Try* tryy;
    };

    struct CatchStart {
      Name tag;
    };

    struct CatchAllStart {};

    struct TryTableStart {
      TryTable* tryt;
    };

    struct End {
      Expression* curr;
    };
    using Separator = std::variant<FuncStart,
                                   BlockStart,
                                   IfStart,
                                   ElseStart,
                                   LoopStart,
                                   TryStart,
                                   CatchStart,
                                   CatchAllStart,
                                   TryTableStart,
                                   End>;

    Separator reason;

    SeparatorReason(Separator reason) : reason(reason) {}

    static SeparatorReason makeFuncStart(Function* func) {
      return SeparatorReason(FuncStart{func});
    }
    static SeparatorReason makeBlockStart(Block* block) {
      return SeparatorReason(BlockStart{block});
    }
    static SeparatorReason makeIfStart(If* iff) {
      return SeparatorReason(IfStart{iff});
    }
    static SeparatorReason makeElseStart() {
      return SeparatorReason(ElseStart{});
    }
    static SeparatorReason makeLoopStart(Loop* loop) {
      return SeparatorReason(LoopStart{loop});
    }
    static SeparatorReason makeTryStart(Try* tryy) {
      return SeparatorReason(TryStart{tryy});
    }
    static SeparatorReason makeCatchStart(Name tag) {
      return SeparatorReason(CatchStart{tag});
    }
    static SeparatorReason makeCatchAllStart() {
      return SeparatorReason(CatchAllStart{});
    }
    static SeparatorReason makeTryTableStart(TryTable* tryt) {
      return SeparatorReason(TryTableStart{tryt});
    }
    static SeparatorReason makeEnd() { return SeparatorReason(End{}); }
    FuncStart* getFuncStart() { return std::get_if<FuncStart>(&reason); }
    BlockStart* getBlockStart() { return std::get_if<BlockStart>(&reason); }
    IfStart* getIfStart() { return std::get_if<IfStart>(&reason); }
    ElseStart* getElseStart() { return std::get_if<ElseStart>(&reason); }
    LoopStart* getLoopStart() { return std::get_if<LoopStart>(&reason); }
    TryStart* getTryStart() { return std::get_if<TryStart>(&reason); }
    CatchStart* getCatchStart() { return std::get_if<CatchStart>(&reason); }
    CatchAllStart* getCatchAllStart() {
      return std::get_if<CatchAllStart>(&reason);
    }
    TryTableStart* getTryTableStart() {
      return std::get_if<TryTableStart>(&reason);
    }
    End* getEnd() { return std::get_if<End>(&reason); }
  };

  friend std::ostream&
  operator<<(std::ostream& o,
             typename StringifyWalker::SeparatorReason reason) {
    if (reason.getFuncStart()) {
      return o << "Func Start";
    } else if (reason.getBlockStart()) {
      return o << "Block Start";
    } else if (reason.getIfStart()) {
      return o << "If Start";
    } else if (reason.getElseStart()) {
      return o << "Else Start";
    } else if (reason.getLoopStart()) {
      return o << "Loop Start";
    } else if (reason.getTryStart()) {
      return o << "Try Start";
    } else if (reason.getCatchStart()) {
      return o << "Catch Start";
    } else if (reason.getCatchAllStart()) {
      return o << "Catch All Start";
    } else if (reason.getTryTableStart()) {
      return o << "Try Table Start";
    } else if (reason.getEnd()) {
      return o << "End";
    }

    return o << "~~~Undefined in operator<< overload~~~";
  }

  // To ensure control flow children are walked consistently during outlining,
  // we push a copy of the control flow expression. This avoids an issue where
  // control flow no longer points to the same expression after being
  // outlined into a new function.
  std::queue<Expression*> controlFlowQueue;

  /*
   * To initiate the walk, subclasses should call walkModule with a pointer to
   * the wasm module.
   *
   * Member functions addUniqueSymbol and visitExpression are provided as
   * extension points for subclasses. These functions will be called at
   * appropriate points during the walk and should be implemented by subclasses.
   */
  void visitExpression(Expression* curr);
  void addUniqueSymbol(SeparatorReason reason);

  void doWalkModule(Module* module);
  void doWalkFunction(Function* func);
  static void scan(SubType* self, Expression** currp);
  static void doVisitExpression(SubType* self, Expression** currp);

  void flushControlFlowQueue() {
    while (!controlFlowQueue.empty()) {
      dequeueControlFlow();
    }
  }
  void dequeueControlFlow();
};

// Implementation follows

// This walker supplies its own doWalkModule because it does not make sense to
// walk anything besides defined functions.
template<typename SubType>
inline void StringifyWalker<SubType>::doWalkModule(Module* module) {
  ModuleUtils::iterDefinedFunctions(
    *module, [&](Function* func) { this->walkFunction(func); });
}

template<typename SubType>
inline void StringifyWalker<SubType>::doWalkFunction(Function* func) {
  addUniqueSymbol(SeparatorReason::makeFuncStart(func));
  Super::walk(func->body);
  addUniqueSymbol(SeparatorReason::makeEnd());
  flushControlFlowQueue();
}

template<typename SubType>
inline void StringifyWalker<SubType>::scan(SubType* self, Expression** currp) {
  Expression* curr = *currp;
  if (Properties::isControlFlowStructure(curr)) {
    self->pushTask(doVisitExpression, currp);
    // The if-condition is a value child consumed by the if control flow, which
    // makes the if-condition a true sibling rather than part of its contents in
    // the binary format
    for (auto*& child : ValueChildIterator(curr)) {
      scan(self, &child);
    }
    self->controlFlowQueue.push(curr);
  } else {
    Super::scan(self, currp);
  }
}

// This dequeueControlFlow is responsible for visiting the children expressions
// of control flow.
template<typename SubType> void StringifyWalker<SubType>::dequeueControlFlow() {
  auto& queue = controlFlowQueue;
  Expression* curr = queue.front();
  queue.pop();

  // TODO: Issue #5796, Make a ControlChildIterator
  switch (curr->_id) {
    case Expression::Id::BlockId: {
      auto* block = curr->cast<Block>();
      addUniqueSymbol(SeparatorReason::makeBlockStart(block));
      for (auto& child : block->list) {
        Super::walk(child);
      }
      addUniqueSymbol(SeparatorReason::makeEnd());
      break;
    }
    case Expression::Id::IfId: {
      auto* iff = curr->cast<If>();
      addUniqueSymbol(SeparatorReason::makeIfStart(iff));
      Super::walk(iff->ifTrue);
      if (iff->ifFalse) {
        addUniqueSymbol(SeparatorReason::makeElseStart());
        Super::walk(iff->ifFalse);
      }
      addUniqueSymbol(SeparatorReason::makeEnd());
      break;
    }
    case Expression::Id::TryId: {
      auto* tryy = curr->cast<Try>();
      assert(!tryy->isDelegate() && "TODO: try-delegate");
      addUniqueSymbol(SeparatorReason::makeTryStart(tryy));
      Super::walk(tryy->body);
      for (size_t i = 0; i < tryy->catchBodies.size(); i++) {
        if (tryy->hasCatchAll() && i == tryy->catchBodies.size() - 1) {
          addUniqueSymbol(SeparatorReason::makeCatchAllStart());
        } else {
          addUniqueSymbol(SeparatorReason::makeCatchStart(tryy->catchTags[i]));
        }
        Super::walk(tryy->catchBodies[i]);
      }
      addUniqueSymbol(SeparatorReason::makeEnd());
      break;
    }
    case Expression::Id::LoopId: {
      auto* loop = curr->cast<Loop>();
      addUniqueSymbol(SeparatorReason::makeLoopStart(loop));
      Super::walk(loop->body);
      addUniqueSymbol(SeparatorReason::makeEnd());
      break;
    }
    case Expression::Id::TryTableId: {
      auto* tryt = curr->cast<TryTable>();
      addUniqueSymbol(SeparatorReason::makeTryTableStart(tryt));
      Super::walk(tryt->body);
      addUniqueSymbol(SeparatorReason::makeEnd());
      break;
    }
    default: {
      assert(Properties::isControlFlowStructure(curr));
      WASM_UNREACHABLE("unexpected expression");
    }
  }
}

template<typename SubType>
void StringifyWalker<SubType>::doVisitExpression(SubType* self,
                                                 Expression** currp) {
  Expression* curr = *currp;
  self->visit(curr);
}

template<typename SubType>
inline void StringifyWalker<SubType>::addUniqueSymbol(SeparatorReason reason) {
  // TODO: Add the following static_assert when the compilers running our GitHub
  // actions are updated enough to know that this is a constant condition:
  // static_assert(&StringifyWalker<SubType>::addUniqueSymbol !=
  // &SubType::addUniqueSymbol);
  auto self = static_cast<SubType*>(this);
  self->addUniqueSymbol(reason);
}

} // namespace wasm

#endif // wasm_passes_stringify_walker_h
