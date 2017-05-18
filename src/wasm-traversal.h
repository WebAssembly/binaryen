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

#ifndef wasm_wasm_traversal_h
#define wasm_wasm_traversal_h

#include "wasm.h"
#include "support/threads.h"

namespace wasm {

template<typename SubType, typename ReturnType = void>
struct Visitor {
  // Expression visitors
  ReturnType visitBlock(Block* curr) {}
  ReturnType visitIf(If* curr) {}
  ReturnType visitLoop(Loop* curr) {}
  ReturnType visitBreak(Break* curr) {}
  ReturnType visitSwitch(Switch* curr) {}
  ReturnType visitCall(Call* curr) {}
  ReturnType visitCallImport(CallImport* curr) {}
  ReturnType visitCallIndirect(CallIndirect* curr) {}
  ReturnType visitGetLocal(GetLocal* curr) {}
  ReturnType visitSetLocal(SetLocal* curr) {}
  ReturnType visitGetGlobal(GetGlobal* curr) {}
  ReturnType visitSetGlobal(SetGlobal* curr) {}
  ReturnType visitLoad(Load* curr) {}
  ReturnType visitStore(Store* curr) {}
  ReturnType visitConst(Const* curr) {}
  ReturnType visitUnary(Unary* curr) {}
  ReturnType visitBinary(Binary* curr) {}
  ReturnType visitSelect(Select* curr) {}
  ReturnType visitDrop(Drop* curr) {}
  ReturnType visitReturn(Return* curr) {}
  ReturnType visitHost(Host* curr) {}
  ReturnType visitNop(Nop* curr) {}
  ReturnType visitUnreachable(Unreachable* curr) {}
  // Module-level visitors
  ReturnType visitFunctionType(FunctionType* curr) {}
  ReturnType visitImport(Import* curr) {}
  ReturnType visitExport(Export* curr) {}
  ReturnType visitGlobal(Global* curr) {}
  ReturnType visitFunction(Function* curr) {}
  ReturnType visitTable(Table* curr) {}
  ReturnType visitMemory(Memory* curr) {}
  ReturnType visitModule(Module* curr) {}

  ReturnType visit(Expression* curr) {
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
      case Expression::Id::GetGlobalId: DELEGATE(GetGlobal);
      case Expression::Id::SetGlobalId: DELEGATE(SetGlobal);
      case Expression::Id::LoadId: DELEGATE(Load);
      case Expression::Id::StoreId: DELEGATE(Store);
      case Expression::Id::ConstId: DELEGATE(Const);
      case Expression::Id::UnaryId: DELEGATE(Unary);
      case Expression::Id::BinaryId: DELEGATE(Binary);
      case Expression::Id::SelectId: DELEGATE(Select);
      case Expression::Id::DropId: DELEGATE(Drop);
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

// Visit with a single unified visitor, called on every node, instead of
// separate visit* per node

template<typename SubType, typename ReturnType = void>
struct UnifiedExpressionVisitor : public Visitor<SubType> {
  // called on each node
  ReturnType visitExpression(Expression* curr) {}

  // redirects
  ReturnType visitBlock(Block* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitIf(If* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitLoop(Loop* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitBreak(Break* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitSwitch(Switch* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitCall(Call* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitCallImport(CallImport* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitCallIndirect(CallIndirect* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitGetLocal(GetLocal* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitSetLocal(SetLocal* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitGetGlobal(GetGlobal* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitSetGlobal(SetGlobal* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitLoad(Load* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitStore(Store* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitConst(Const* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitUnary(Unary* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitBinary(Binary* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitSelect(Select* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitDrop(Drop* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitReturn(Return* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitHost(Host* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitNop(Nop* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
  ReturnType visitUnreachable(Unreachable* curr) { return static_cast<SubType*>(this)->visitExpression(curr); }
};

//
// Base class for all WasmWalkers, which can traverse an AST
// and provide the option to replace nodes while doing so.
//
// Subclass and implement the visit*()
// calls to run code on different node types.
//
template<typename SubType, typename VisitorType>
struct Walker : public VisitorType {
  // Useful methods for visitor implementions

  // Replace the current node. You can call this in your visit*() methods.
  // Note that the visit*() for the result node is not called for you (i.e.,
  // just one visit*() method is called by the traversal; if you replace a node,
  // and you want to process the output, you must do that explicitly).
  Expression* replaceCurrent(Expression* expression) {
    return *replacep = expression;
  }

  Expression* getCurrent() {
    return *replacep;
  }

  // Get the current module
  Module* getModule() {
    return currModule;
  }

  // Get the current function
  Function* getFunction() {
    return currFunction;
  }

  // Walk starting

  void walkGlobal(Global* global) {
    walk(global->init);
    static_cast<SubType*>(this)->visitGlobal(global);
  }

  void walkFunction(Function* func) {
    setFunction(func);
    static_cast<SubType*>(this)->doWalkFunction(func);
    static_cast<SubType*>(this)->visitFunction(func);
    setFunction(nullptr);
  }

  void walkFunctionInModule(Function* func, Module* module) {
    setModule(module);
    setFunction(func);
    static_cast<SubType*>(this)->doWalkFunction(func);
    static_cast<SubType*>(this)->visitFunction(func);
    setFunction(nullptr);
    setModule(nullptr);
  }

  // override this to provide custom functionality
  void doWalkFunction(Function* func) {
    walk(func->body);
  }

  void walkTable(Table* table) {
    for (auto& segment : table->segments) {
      walk(segment.offset);
    }
    static_cast<SubType*>(this)->visitTable(table);
  }

  void walkMemory(Memory* memory) {
    for (auto& segment : memory->segments) {
      walk(segment.offset);
    }
    static_cast<SubType*>(this)->visitMemory(memory);
  }

  void walkModule(Module* module) {
    setModule(module);
    static_cast<SubType*>(this)->doWalkModule(module);
    static_cast<SubType*>(this)->visitModule(module);
    setModule(nullptr);
  }

  // override this to provide custom functionality
  void doWalkModule(Module* module) {
    // Dispatch statically through the SubType.
    SubType* self = static_cast<SubType*>(this);
    for (auto& curr : module->functionTypes) {
      self->visitFunctionType(curr.get());
    }
    for (auto& curr : module->imports) {
      self->visitImport(curr.get());
    }
    for (auto& curr : module->exports) {
      self->visitExport(curr.get());
    }
    for (auto& curr : module->globals) {
      self->walkGlobal(curr.get());
    }
    for (auto& curr : module->functions) {
      self->walkFunction(curr.get());
    }
    self->walkTable(&module->table);
    self->walkMemory(&module->memory);
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
      replacep = task.currp;
      assert(*task.currp);
      task.func(static_cast<SubType*>(this), task.currp);
    }
  }

  // subclasses implement this to define the proper order of execution
  static void scan(SubType* self, Expression** currp) { abort(); }

  // task hooks to call visitors

  static void doVisitBlock(SubType* self, Expression** currp)        { self->visitBlock((*currp)->cast<Block>()); }
  static void doVisitIf(SubType* self, Expression** currp)           { self->visitIf((*currp)->cast<If>()); }
  static void doVisitLoop(SubType* self, Expression** currp)         { self->visitLoop((*currp)->cast<Loop>()); }
  static void doVisitBreak(SubType* self, Expression** currp)        { self->visitBreak((*currp)->cast<Break>()); }
  static void doVisitSwitch(SubType* self, Expression** currp)       { self->visitSwitch((*currp)->cast<Switch>()); }
  static void doVisitCall(SubType* self, Expression** currp)         { self->visitCall((*currp)->cast<Call>()); }
  static void doVisitCallImport(SubType* self, Expression** currp)   { self->visitCallImport((*currp)->cast<CallImport>()); }
  static void doVisitCallIndirect(SubType* self, Expression** currp) { self->visitCallIndirect((*currp)->cast<CallIndirect>()); }
  static void doVisitGetLocal(SubType* self, Expression** currp)     { self->visitGetLocal((*currp)->cast<GetLocal>()); }
  static void doVisitSetLocal(SubType* self, Expression** currp)     { self->visitSetLocal((*currp)->cast<SetLocal>()); }
  static void doVisitGetGlobal(SubType* self, Expression** currp)    { self->visitGetGlobal((*currp)->cast<GetGlobal>()); }
  static void doVisitSetGlobal(SubType* self, Expression** currp)    { self->visitSetGlobal((*currp)->cast<SetGlobal>()); }
  static void doVisitLoad(SubType* self, Expression** currp)         { self->visitLoad((*currp)->cast<Load>()); }
  static void doVisitStore(SubType* self, Expression** currp)        { self->visitStore((*currp)->cast<Store>()); }
  static void doVisitConst(SubType* self, Expression** currp)        { self->visitConst((*currp)->cast<Const>()); }
  static void doVisitUnary(SubType* self, Expression** currp)        { self->visitUnary((*currp)->cast<Unary>()); }
  static void doVisitBinary(SubType* self, Expression** currp)       { self->visitBinary((*currp)->cast<Binary>()); }
  static void doVisitSelect(SubType* self, Expression** currp)       { self->visitSelect((*currp)->cast<Select>()); }
  static void doVisitDrop(SubType* self, Expression** currp)         { self->visitDrop((*currp)->cast<Drop>()); }
  static void doVisitReturn(SubType* self, Expression** currp)       { self->visitReturn((*currp)->cast<Return>()); }
  static void doVisitHost(SubType* self, Expression** currp)         { self->visitHost((*currp)->cast<Host>()); }
  static void doVisitNop(SubType* self, Expression** currp)          { self->visitNop((*currp)->cast<Nop>()); }
  static void doVisitUnreachable(SubType* self, Expression** currp)  { self->visitUnreachable((*currp)->cast<Unreachable>()); }

  void setModule(Module* module) {
    currModule = module;
  }

  void setFunction(Function* func) {
    currFunction = func;
  }

private:
  Expression** replacep = nullptr; // the address of the current node, used to replace it
  std::vector<Task> stack; // stack of tasks
  Function* currFunction = nullptr; // current function being processed
  Module* currModule = nullptr; // current module being processed
};

// Walks in post-order, i.e., children first. When there isn't an obvious
// order to operands, we follow them in order of execution.

template<typename SubType, typename VisitorType = Visitor<SubType>>
struct PostWalker : public Walker<SubType, VisitorType> {

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
        self->pushTask(SubType::scan, &curr->cast<Switch>()->condition);
        self->maybePushTask(SubType::scan, &curr->cast<Switch>()->value);
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
        self->pushTask(SubType::scan, &curr->cast<CallIndirect>()->target);
        for (int i = int(list.size()) - 1; i >= 0; i--) {
          self->pushTask(SubType::scan, &list[i]);
        }
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
      case Expression::Id::GetGlobalId: {
        self->pushTask(SubType::doVisitGetGlobal, currp);
        break;
      }
      case Expression::Id::SetGlobalId: {
        self->pushTask(SubType::doVisitSetGlobal, currp);
        self->pushTask(SubType::scan, &curr->cast<SetGlobal>()->value);
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
      case Expression::Id::DropId: {
        self->pushTask(SubType::doVisitDrop, currp);
        self->pushTask(SubType::scan, &curr->cast<Drop>()->value);
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

// Traversal with a control-flow stack.

template<typename SubType, typename VisitorType = Visitor<SubType>>
struct ControlFlowWalker : public PostWalker<SubType, VisitorType> {
  ControlFlowWalker() {}

  std::vector<Expression*> controlFlowStack; // contains blocks, loops, and ifs

  // Uses the control flow stack to find the target of a break to a name
  Expression* findBreakTarget(Name name) {
    assert(!controlFlowStack.empty());
    Index i = controlFlowStack.size() - 1;
    while (1) {
      auto* curr = controlFlowStack[i];
      if (Block* block = curr->template dynCast<Block>()) {
        if (name == block->name) return curr;
      } else if (Loop* loop = curr->template dynCast<Loop>()) {
        if (name == loop->name) return curr;
      } else {
        // an if, ignorable
        assert(curr->template is<If>());
      }
      if (i == 0) return nullptr;
      i--;
    }
  }

  static void doPreVisitControlFlow(SubType* self, Expression** currp) {
    self->controlFlowStack.push_back(*currp);
  }

  static void doPostVisitControlFlow(SubType* self, Expression** currp) {
    assert(self->controlFlowStack.back() == *currp);
    self->controlFlowStack.pop_back();
  }

  static void scan(SubType* self, Expression** currp) {
    auto* curr = *currp;

    switch (curr->_id) {
      case Expression::Id::BlockId:
      case Expression::Id::IfId:
      case Expression::Id::LoopId: {
        self->pushTask(SubType::doPostVisitControlFlow, currp);
        break;
      }
      default: {}
    }

    PostWalker<SubType, VisitorType>::scan(self, currp);

    switch (curr->_id) {
      case Expression::Id::BlockId:
      case Expression::Id::IfId:
      case Expression::Id::LoopId: {
        self->pushTask(SubType::doPreVisitControlFlow, currp);
        break;
      }
      default: {}
    }
  }
};

// Traversal with an expression stack.

template<typename SubType, typename VisitorType = Visitor<SubType>>
struct ExpressionStackWalker : public PostWalker<SubType, VisitorType> {
  ExpressionStackWalker() {}

  std::vector<Expression*> expressionStack;

  // Uses the control flow stack to find the target of a break to a name
  Expression* findBreakTarget(Name name) {
    assert(!expressionStack.empty());
    Index i = expressionStack.size() - 1;
    while (1) {
      auto* curr = expressionStack[i];
      if (Block* block = curr->template dynCast<Block>()) {
        if (name == block->name) return curr;
      } else if (Loop* loop = curr->template dynCast<Loop>()) {
        if (name == loop->name) return curr;
      } else {
        WASM_UNREACHABLE();
      }
      if (i == 0) return nullptr;
      i--;
    }
  }

  static void doPreVisit(SubType* self, Expression** currp) {
    self->expressionStack.push_back(*currp);
  }

  static void doPostVisit(SubType* self, Expression** currp) {
    self->expressionStack.pop_back();
  }

  static void scan(SubType* self, Expression** currp) {
    self->pushTask(SubType::doPostVisit, currp);

    PostWalker<SubType, VisitorType>::scan(self, currp);

    self->pushTask(SubType::doPreVisit, currp);
  }

  Expression* replaceCurrent(Expression* expression) {
    PostWalker<SubType, VisitorType>::replaceCurrent(expression);
    // also update the stack
    expressionStack.back() = expression;
    return expression;
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

template<typename SubType, typename VisitorType = Visitor<SubType>>
struct LinearExecutionWalker : public PostWalker<SubType, VisitorType> {
  LinearExecutionWalker() {}

  // subclasses should implement this
  void noteNonLinear(Expression* curr) { abort(); }

  static void doNoteNonLinear(SubType* self, Expression** currp) {
    self->noteNonLinear(*currp);
  }

  static void scan(SubType* self, Expression** currp) {

    Expression* curr = *currp;

    switch (curr->_id) {
      case Expression::Id::InvalidId: abort();
      case Expression::Id::BlockId: {
        self->pushTask(SubType::doVisitBlock, currp);
        if (curr->cast<Block>()->name.is()) {
          self->pushTask(SubType::doNoteNonLinear, currp);
        }
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
      case Expression::Id::UnreachableId: {
        self->pushTask(SubType::doVisitUnreachable, currp);
        self->pushTask(SubType::doNoteNonLinear, currp);
        break;
      }
      default: {
        // other node types do not have control flow, use regular post-order
        PostWalker<SubType, VisitorType>::scan(self, currp);
      }
    }
  }
};

} // namespace wasm

#endif // wasm_wasm_traversal_h
