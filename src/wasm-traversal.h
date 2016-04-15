/*
 * Copyright 2016 WebAssembly Community Group participants
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
// WebAssembly AST visitor. Useful for anything that wants to do something
// different for each AST node type, like printing, interpreting, etc.
//
// This class is specifically designed as a template to avoid virtual function
// call overhead. To write a visitor, derive from this class as follows:
//
//   struct MyVisitor : public WasmVisitor<MyVisitor> { .. }
//

#ifndef wasm_traversal_h
#define wasm_traversal_h

#include "wasm.h"
#include "support/threads.h"

namespace wasm {

template<typename SubType, typename ReturnType = void>
struct Visitor {
  // Expression visitors
  ReturnType visitBlock(Block *curr) {}
  ReturnType visitIf(If *curr) {}
  ReturnType visitLoop(Loop *curr) {}
  ReturnType visitBreak(Break *curr) {}
  ReturnType visitSwitch(Switch *curr) {}
  ReturnType visitCall(Call *curr) {}
  ReturnType visitCallImport(CallImport *curr) {}
  ReturnType visitCallIndirect(CallIndirect *curr) {}
  ReturnType visitGetLocal(GetLocal *curr) {}
  ReturnType visitSetLocal(SetLocal *curr) {}
  ReturnType visitLoad(Load *curr) {}
  ReturnType visitStore(Store *curr) {}
  ReturnType visitConst(Const *curr) {}
  ReturnType visitUnary(Unary *curr) {}
  ReturnType visitBinary(Binary *curr) {}
  ReturnType visitSelect(Select *curr) {}
  ReturnType visitReturn(Return *curr) {}
  ReturnType visitHost(Host *curr) {}
  ReturnType visitNop(Nop *curr) {}
  ReturnType visitUnreachable(Unreachable *curr) {}
  // Module-level visitors
  ReturnType visitFunctionType(FunctionType *curr) {}
  ReturnType visitImport(Import *curr) {}
  ReturnType visitExport(Export *curr) {}
  ReturnType visitFunction(Function *curr) {}
  ReturnType visitTable(Table *curr) {}
  ReturnType visitMemory(Memory *curr) {}
  ReturnType visitModule(Module *curr) {}

  ReturnType visit(Expression *curr) {
    assert(curr);

    #define DELEGATE(CLASS_TO_VISIT) \
      return static_cast<SubType*>(this)-> \
          visit##CLASS_TO_VISIT(static_cast<CLASS_TO_VISIT*>(curr))

    switch (curr->_id) {
      case Expression::Id::BlockId: DELEGATE(Block);
      case Expression::Id::IfId: DELEGATE(If);
      case Expression::Id::LoopId: DELEGATE(Loop);
      case Expression::Id::BreakId: DELEGATE(Break);
      case Expression::Id::SwitchId: DELEGATE(Switch);
      case Expression::Id::CallId: DELEGATE(Call);
      case Expression::Id::CallImportId: DELEGATE(CallImport);
      case Expression::Id::CallIndirectId: DELEGATE(CallIndirect);
      case Expression::Id::GetLocalId: DELEGATE(GetLocal);
      case Expression::Id::SetLocalId: DELEGATE(SetLocal);
      case Expression::Id::LoadId: DELEGATE(Load);
      case Expression::Id::StoreId: DELEGATE(Store);
      case Expression::Id::ConstId: DELEGATE(Const);
      case Expression::Id::UnaryId: DELEGATE(Unary);
      case Expression::Id::BinaryId: DELEGATE(Binary);
      case Expression::Id::SelectId: DELEGATE(Select);
      case Expression::Id::ReturnId: DELEGATE(Return);
      case Expression::Id::HostId: DELEGATE(Host);
      case Expression::Id::NopId: DELEGATE(Nop);
      case Expression::Id::UnreachableId: DELEGATE(Unreachable);
      case Expression::Id::InvalidId:
      default: WASM_UNREACHABLE();
    }

    #undef DELEGATE
  }
};

//
// Base class for all WasmWalkers, which can traverse an AST
// and provide the option to replace nodes while doing so.
//
// Subclass and implement the visit*()
// calls to run code on different node types.
//
template<typename SubType>
struct Walker : public Visitor<SubType> {
  // Extra generic visitor, called before each node's specific visitor. Useful for
  // passes that need to do the same thing for every node type.
  void visitExpression(Expression* curr) {}

  // Function parallelism. By default, walks are not run in parallel, but you
  // can override this method to say that functions are parallelizable. This
  // should always be safe *unless* you do something in the pass that makes it
  // not thread-safe; in other words, the Module and Function objects and
  // so forth are set up so that Functions can be processed in parallel, so
  // if you do not ad global state that could be raced on, your pass could be
  // function-parallel.
  //
  // Function-parallel passes create an instance of the Walker class per core.
  // That means that you can't rely on Walker object properties to persist across
  // your functions, and you can't expect a new object to be created for each
  // function either (which could be very inefficient).
  bool isFunctionParallel() { return false; }

  // Node replacing as we walk - call replaceCurrent from
  // your visitors.

  void replaceCurrent(Expression *expression) {
    replace = expression;
  }

  // Walk starting

  void startWalk(Module *module) {
    // Dispatch statically through the SubType.
    SubType* self = static_cast<SubType*>(this);
    for (auto curr : module->functionTypes) {
      self->visitFunctionType(curr);
    }
    for (auto curr : module->imports) {
      self->visitImport(curr);
    }
    for (auto curr : module->exports) {
      self->visitExport(curr);
    }

    // if this is not a function-parallel traversal, run
    // sequentially
    if (!self->isFunctionParallel()) {
      for (auto curr : module->functions) {
        self->walk(curr->body);
        self->visitFunction(curr);
      }
    } else {
      // execute in parallel on helper threads
      size_t num = ThreadPool::get()->size();
      std::vector<std::unique_ptr<SubType>> instances;
      std::vector<std::function<ThreadWorkState ()>> doWorkers;
      std::atomic<size_t> nextFunction;
      nextFunction.store(0);
      size_t numFunctions = module->functions.size();
      for (size_t i = 0; i < num; i++) {
        auto* instance = new SubType();
        instances.push_back(std::unique_ptr<SubType>(instance));
        doWorkers.push_back([instance, &nextFunction, numFunctions, &module]() {
          auto index = nextFunction.fetch_add(1);
          // get the next task, if there is one
          if (index >= numFunctions) {
            return ThreadWorkState::Finished; // nothing left
          }
          Function* curr = module->functions[index];
          // do the current task
          instance->walk(curr->body);
          instance->visitFunction(curr);
          if (index + 1 == numFunctions) {
            return ThreadWorkState::Finished; // we did the last one
          }
          return ThreadWorkState::More;
        });
      }
      ThreadPool::get()->work(doWorkers);
    }
    self->visitTable(&module->table);
    self->visitMemory(&module->memory);
    self->visitModule(module);
  }

  // Walk implementation. We don't use recursion as ASTs may be highly
  // nested.

  // Tasks receive the this pointer and a pointer to the pointer to operate on
  typedef void (*TaskFunc)(SubType*, Expression**);

  struct Task {
    TaskFunc func;
    Expression** currp;
    Task(TaskFunc func, Expression** currp) : func(func), currp(currp) {}
  };

  void pushTask(TaskFunc func, Expression** currp) {
    stack.emplace_back(func, currp);
  }
  void maybePushTask(TaskFunc func, Expression** currp) {
    if (*currp) {
      stack.emplace_back(func, currp);
    }
  }
  Task popTask() {
    auto ret = stack.back();
    stack.pop_back();
    return ret;
  }

  void walk(Expression*& root) {
    assert(stack.size() == 0);
    pushTask(SubType::scan, &root);
    while (stack.size() > 0) {
      auto task = popTask();
      assert(*task.currp);
      task.func(static_cast<SubType*>(this), task.currp);
      if (replace) {
        *task.currp = replace;
        replace = nullptr;
      }
    }
  }

  // subclasses implement this to define the proper order of execution
  static void scan(SubType* self, Expression** currp) { abort(); }

  // task hooks to call visitors

  static void doVisitBlock(SubType* self, Expression** currp)        { self->visitExpression(*currp); self->visitBlock((*currp)->cast<Block>()); }
  static void doVisitIf(SubType* self, Expression** currp)           { self->visitExpression(*currp); self->visitIf((*currp)->cast<If>()); }
  static void doVisitLoop(SubType* self, Expression** currp)         { self->visitExpression(*currp); self->visitLoop((*currp)->cast<Loop>()); }
  static void doVisitBreak(SubType* self, Expression** currp)        { self->visitExpression(*currp); self->visitBreak((*currp)->cast<Break>()); }
  static void doVisitSwitch(SubType* self, Expression** currp)       { self->visitExpression(*currp); self->visitSwitch((*currp)->cast<Switch>()); }
  static void doVisitCall(SubType* self, Expression** currp)         { self->visitExpression(*currp); self->visitCall((*currp)->cast<Call>()); }
  static void doVisitCallImport(SubType* self, Expression** currp)   { self->visitExpression(*currp); self->visitCallImport((*currp)->cast<CallImport>()); }
  static void doVisitCallIndirect(SubType* self, Expression** currp) { self->visitExpression(*currp); self->visitCallIndirect((*currp)->cast<CallIndirect>()); }
  static void doVisitGetLocal(SubType* self, Expression** currp)     { self->visitExpression(*currp); self->visitGetLocal((*currp)->cast<GetLocal>()); }
  static void doVisitSetLocal(SubType* self, Expression** currp)     { self->visitExpression(*currp); self->visitSetLocal((*currp)->cast<SetLocal>()); }
  static void doVisitLoad(SubType* self, Expression** currp)         { self->visitExpression(*currp); self->visitLoad((*currp)->cast<Load>()); }
  static void doVisitStore(SubType* self, Expression** currp)        { self->visitExpression(*currp); self->visitStore((*currp)->cast<Store>()); }
  static void doVisitConst(SubType* self, Expression** currp)        { self->visitExpression(*currp); self->visitConst((*currp)->cast<Const>()); }
  static void doVisitUnary(SubType* self, Expression** currp)        { self->visitExpression(*currp); self->visitUnary((*currp)->cast<Unary>()); }
  static void doVisitBinary(SubType* self, Expression** currp)       { self->visitExpression(*currp); self->visitBinary((*currp)->cast<Binary>()); }
  static void doVisitSelect(SubType* self, Expression** currp)       { self->visitExpression(*currp); self->visitSelect((*currp)->cast<Select>()); }
  static void doVisitReturn(SubType* self, Expression** currp)       { self->visitExpression(*currp); self->visitReturn((*currp)->cast<Return>()); }
  static void doVisitHost(SubType* self, Expression** currp)         { self->visitExpression(*currp); self->visitHost((*currp)->cast<Host>()); }
  static void doVisitNop(SubType* self, Expression** currp)          { self->visitExpression(*currp); self->visitNop((*currp)->cast<Nop>()); }
  static void doVisitUnreachable(SubType* self, Expression** currp)  { self->visitExpression(*currp); self->visitUnreachable((*currp)->cast<Unreachable>()); }

private:
  Expression *replace = nullptr; // a node to replace
  std::vector<Task> stack; // stack of tasks
};

// Walks in post-order, i.e., children first. When there isn't an obvious
// order to operands, we follow them in order of execution.

template<typename SubType>
struct PostWalker : public Walker<SubType> {

  static void scan(SubType* self, Expression** currp) {

    Expression* curr = *currp;
    switch (curr->_id) {
      case Expression::Id::InvalidId: abort();
      case Expression::Id::BlockId: {
        self->pushTask(SubType::doVisitBlock, currp);
        auto& list = curr->cast<Block>()->list;
        for (int i = int(list.size()) - 1; i >= 0; i--) {
          self->pushTask(SubType::scan, &list[i]);
        }
        break;
      }
      case Expression::Id::IfId: {
        self->pushTask(SubType::doVisitIf, currp);
        self->maybePushTask(SubType::scan, &curr->cast<If>()->ifFalse);
        self->pushTask(SubType::scan, &curr->cast<If>()->ifTrue);
        self->pushTask(SubType::scan, &curr->cast<If>()->condition);
        break;
      }
      case Expression::Id::LoopId: {
        self->pushTask(SubType::doVisitLoop, currp);
        self->pushTask(SubType::scan, &curr->cast<Loop>()->body);
        break;
      }
      case Expression::Id::BreakId: {
        self->pushTask(SubType::doVisitBreak, currp);
        self->maybePushTask(SubType::scan, &curr->cast<Break>()->condition);
        self->maybePushTask(SubType::scan, &curr->cast<Break>()->value);
        break;
      }
      case Expression::Id::SwitchId: {
        self->pushTask(SubType::doVisitSwitch, currp);
        self->maybePushTask(SubType::scan, &curr->cast<Switch>()->value);
        self->pushTask(SubType::scan, &curr->cast<Switch>()->condition);
        break;
      }
      case Expression::Id::CallId: {
        self->pushTask(SubType::doVisitCall, currp);
        auto& list = curr->cast<Call>()->operands;
        for (int i = int(list.size()) - 1; i >= 0; i--) {
          self->pushTask(SubType::scan, &list[i]);
        }
        break;
      }
      case Expression::Id::CallImportId: {
        self->pushTask(SubType::doVisitCallImport, currp);
        auto& list = curr->cast<CallImport>()->operands;
        for (int i = int(list.size()) - 1; i >= 0; i--) {
          self->pushTask(SubType::scan, &list[i]);
        }
        break;
      }
      case Expression::Id::CallIndirectId: {
        self->pushTask(SubType::doVisitCallIndirect, currp);
        auto& list = curr->cast<CallIndirect>()->operands;
        for (int i = int(list.size()) - 1; i >= 0; i--) {
          self->pushTask(SubType::scan, &list[i]);
        }
        self->pushTask(SubType::scan, &curr->cast<CallIndirect>()->target);
        break;
      }
      case Expression::Id::GetLocalId: {
        self->pushTask(SubType::doVisitGetLocal, currp); // TODO: optimize leaves with a direct call?
        break;
      }
      case Expression::Id::SetLocalId: {
        self->pushTask(SubType::doVisitSetLocal, currp);
        self->pushTask(SubType::scan, &curr->cast<SetLocal>()->value);
        break;
      }
      case Expression::Id::LoadId: {
        self->pushTask(SubType::doVisitLoad, currp);
        self->pushTask(SubType::scan, &curr->cast<Load>()->ptr);
        break;
      }
      case Expression::Id::StoreId: {
        self->pushTask(SubType::doVisitStore, currp);
        self->pushTask(SubType::scan, &curr->cast<Store>()->value);
        self->pushTask(SubType::scan, &curr->cast<Store>()->ptr);
        break;
      }
      case Expression::Id::ConstId: {
        self->pushTask(SubType::doVisitConst, currp);
        break;
      }
      case Expression::Id::UnaryId: {
        self->pushTask(SubType::doVisitUnary, currp);
        self->pushTask(SubType::scan, &curr->cast<Unary>()->value);
        break;
      }
      case Expression::Id::BinaryId: {
        self->pushTask(SubType::doVisitBinary, currp);
        self->pushTask(SubType::scan, &curr->cast<Binary>()->right);
        self->pushTask(SubType::scan, &curr->cast<Binary>()->left);
        break;
      }
      case Expression::Id::SelectId: {
        self->pushTask(SubType::doVisitSelect, currp);
        self->pushTask(SubType::scan, &curr->cast<Select>()->condition);
        self->pushTask(SubType::scan, &curr->cast<Select>()->ifFalse);
        self->pushTask(SubType::scan, &curr->cast<Select>()->ifTrue);
        break;
      }
      case Expression::Id::ReturnId: {
        self->pushTask(SubType::doVisitReturn, currp);
        self->maybePushTask(SubType::scan, &curr->cast<Return>()->value);
        break;
      }
      case Expression::Id::HostId: {
        self->pushTask(SubType::doVisitHost, currp);
        auto& list = curr->cast<Host>()->operands;
        for (int i = int(list.size()) - 1; i >= 0; i--) {
          self->pushTask(SubType::scan, &list[i]);
        }
        break;
      }
      case Expression::Id::NopId: {
        self->pushTask(SubType::doVisitNop, currp);
        break;
      }
      case Expression::Id::UnreachableId: {
        self->pushTask(SubType::doVisitUnreachable, currp);
        break;
      }
      default: WASM_UNREACHABLE();
    }
  }
};

// Traversal in the order of execution. This is quick and simple, but
// does not provide the same comprehensive information that a full
// conversion to basic blocks would. What it does give is a quick
// way to view straightline execution traces, i.e., that have no
// branching. This can let optimizations get most of what they
// want without the cost of creating another AST.
//
// When execution is no longer linear, this notifies via a call
// to noteNonLinear().

template<typename SubType>
struct LinearExecutionWalker : public PostWalker<SubType> {
  LinearExecutionWalker() {}

  // subclasses should implement this
  void noteNonLinear() { abort(); }

  static void doNoteNonLinear(SubType* self, Expression** currp) {
    self->noteNonLinear();
  }

  static void scan(SubType* self, Expression** currp) {

    Expression* curr = *currp;

    switch (curr->_id) {
      case Expression::Id::InvalidId: abort();
      case Expression::Id::BlockId: {
        self->pushTask(SubType::doVisitBlock, currp);
        self->pushTask(SubType::doNoteNonLinear, currp);
        auto& list = curr->cast<Block>()->list;
        for (int i = int(list.size()) - 1; i >= 0; i--) {
          self->pushTask(SubType::scan, &list[i]);
        }
        break;
      }
      case Expression::Id::IfId: {
        self->pushTask(SubType::doVisitIf, currp);
        self->pushTask(SubType::doNoteNonLinear, currp);
        self->maybePushTask(SubType::scan, &curr->cast<If>()->ifFalse);
        self->pushTask(SubType::doNoteNonLinear, currp);
        self->pushTask(SubType::scan, &curr->cast<If>()->ifTrue);
        self->pushTask(SubType::doNoteNonLinear, currp);
        self->pushTask(SubType::scan, &curr->cast<If>()->condition);
        break;
      }
      case Expression::Id::LoopId: {
        self->pushTask(SubType::doVisitLoop, currp);
        self->pushTask(SubType::scan, &curr->cast<Loop>()->body);
        self->pushTask(SubType::doNoteNonLinear, currp);
        break;
      }
      case Expression::Id::BreakId: {
        self->pushTask(SubType::doVisitBreak, currp);
        self->pushTask(SubType::doNoteNonLinear, currp);
        self->maybePushTask(SubType::scan, &curr->cast<Break>()->condition);
        self->maybePushTask(SubType::scan, &curr->cast<Break>()->value);
        break;
      }
      case Expression::Id::SwitchId: {
        self->pushTask(SubType::doVisitSwitch, currp);
        self->pushTask(SubType::doNoteNonLinear, currp);
        self->maybePushTask(SubType::scan, &curr->cast<Switch>()->value);
        self->pushTask(SubType::scan, &curr->cast<Switch>()->condition);
        break;
      }
      case Expression::Id::ReturnId: {
        self->pushTask(SubType::doVisitReturn, currp);
        self->pushTask(SubType::doNoteNonLinear, currp);
        self->maybePushTask(SubType::scan, &curr->cast<Return>()->value);
        break;
      }
      default: {
        // other node types do not have control flow, use regular post-order
        PostWalker<SubType>::scan(self, currp);
      }
    }
  }
};

} // namespace wasm

#endif // wasm_traversal_h
