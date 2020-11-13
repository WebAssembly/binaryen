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

#include "support/small_vector.h"
#include "support/threads.h"
#include "wasm.h"

namespace wasm {

// A generic visitor, defaulting to doing nothing on each visit

template<typename SubType, typename ReturnType = void> struct Visitor {
  // Expression visitors
#define DELEGATE(CLASS_TO_VISIT)                                               \
  ReturnType visit##CLASS_TO_VISIT(CLASS_TO_VISIT* curr) {                     \
    return ReturnType();                                                       \
  }
#include "wasm-delegations.h"

  // Module-level visitors
  ReturnType visitExport(Export* curr) { return ReturnType(); }
  ReturnType visitGlobal(Global* curr) { return ReturnType(); }
  ReturnType visitFunction(Function* curr) { return ReturnType(); }
  ReturnType visitTable(Table* curr) { return ReturnType(); }
  ReturnType visitMemory(Memory* curr) { return ReturnType(); }
  ReturnType visitEvent(Event* curr) { return ReturnType(); }
  ReturnType visitModule(Module* curr) { return ReturnType(); }

  ReturnType visit(Expression* curr) {
    assert(curr);

    switch (curr->_id) {
#define DELEGATE(CLASS_TO_VISIT)                                               \
  case Expression::Id::CLASS_TO_VISIT##Id:                                     \
    return static_cast<SubType*>(this)->visit##CLASS_TO_VISIT(                 \
      static_cast<CLASS_TO_VISIT*>(curr))

#include "wasm-delegations.h"

      default:
        WASM_UNREACHABLE("unexpected expression type");
    }
  }
};

// A visitor which must be overridden for each visitor that is reached.

template<typename SubType, typename ReturnType = void>
struct OverriddenVisitor {
// Expression visitors, which must be overridden
#define DELEGATE(CLASS_TO_VISIT)                                               \
  ReturnType visit##CLASS_TO_VISIT(CLASS_TO_VISIT* curr) {                     \
    static_assert(                                                             \
      &SubType::visit##CLASS_TO_VISIT !=                                       \
        &OverriddenVisitor<SubType, ReturnType>::visit##CLASS_TO_VISIT,        \
      "Derived class must implement visit" #CLASS_TO_VISIT);                   \
    WASM_UNREACHABLE("Derived class must implement visit" #CLASS_TO_VISIT);    \
  }

#include "wasm-delegations.h"

  ReturnType visit(Expression* curr) {
    assert(curr);

    switch (curr->_id) {
#define DELEGATE(CLASS_TO_VISIT)                                               \
  case Expression::Id::CLASS_TO_VISIT##Id:                                     \
    return static_cast<SubType*>(this)->visit##CLASS_TO_VISIT(                 \
      static_cast<CLASS_TO_VISIT*>(curr))

#include "wasm-delegations.h"

      default:
        WASM_UNREACHABLE("unexpected expression type");
    }
  }
};

// Visit with a single unified visitor, called on every node, instead of
// separate visit* per node

template<typename SubType, typename ReturnType = void>
struct UnifiedExpressionVisitor : public Visitor<SubType, ReturnType> {
  // called on each node
  ReturnType visitExpression(Expression* curr) { return ReturnType(); }

  // redirects
#define DELEGATE(CLASS_TO_VISIT)                                               \
  ReturnType visit##CLASS_TO_VISIT(CLASS_TO_VISIT* curr) {                     \
    return static_cast<SubType*>(this)->visitExpression(curr);                 \
  }

#include "wasm-delegations.h"
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
    // Copy debug info, if present.
    if (currFunction) {
      auto& debugLocations = currFunction->debugLocations;
      if (!debugLocations.empty()) {
        auto* curr = getCurrent();
        auto iter = debugLocations.find(curr);
        if (iter != debugLocations.end()) {
          auto location = iter->second;
          debugLocations.erase(iter);
          debugLocations[expression] = location;
        }
      }
    }
    return *replacep = expression;
  }

  Expression* getCurrent() { return *replacep; }

  Expression** getCurrentPointer() { return replacep; }

  // Get the current module
  Module* getModule() { return currModule; }

  // Get the current function
  Function* getFunction() { return currFunction; }

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

  void walkEvent(Event* event) {
    static_cast<SubType*>(this)->visitEvent(event);
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
  void doWalkFunction(Function* func) { walk(func->body); }

  void walkTable(Table* table) {
    for (auto& segment : table->segments) {
      walk(segment.offset);
    }
    static_cast<SubType*>(this)->visitTable(table);
  }

  void walkMemory(Memory* memory) {
    for (auto& segment : memory->segments) {
      if (!segment.isPassive) {
        walk(segment.offset);
      }
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
    for (auto& curr : module->exports) {
      self->visitExport(curr.get());
    }
    for (auto& curr : module->globals) {
      if (curr->imported()) {
        self->visitGlobal(curr.get());
      } else {
        self->walkGlobal(curr.get());
      }
    }
    for (auto& curr : module->functions) {
      if (curr->imported()) {
        self->visitFunction(curr.get());
      } else {
        self->walkFunction(curr.get());
      }
    }
    for (auto& curr : module->events) {
      if (curr->imported()) {
        self->visitEvent(curr.get());
      } else {
        self->walkEvent(curr.get());
      }
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
    Task() {}
    Task(TaskFunc func, Expression** currp) : func(func), currp(currp) {}
  };

  void pushTask(TaskFunc func, Expression** currp) {
    assert(*currp);
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

#define DELEGATE(CLASS_TO_VISIT)                                               \
  static void doVisit##CLASS_TO_VISIT(SubType* self, Expression** currp) {     \
    self->visit##CLASS_TO_VISIT((*currp)->cast<CLASS_TO_VISIT>());             \
  }

#include "wasm-delegations.h"

  void setModule(Module* module) { currModule = module; }

  void setFunction(Function* func) { currFunction = func; }

private:
  // the address of the current node, used to replace it
  Expression** replacep = nullptr;
  SmallVector<Task, 10> stack;      // stack of tasks
  Function* currFunction = nullptr; // current function being processed
  Module* currModule = nullptr;     // current module being processed
};

// Walks in post-order, i.e., children first. When there isn't an obvious
// order to operands, we follow them in order of execution.

template<typename SubType, typename VisitorType = Visitor<SubType>>
struct PostWalker : public Walker<SubType, VisitorType> {

  static void scan(SubType* self, Expression** currp) {
    Expression* curr = *currp;

#define DELEGATE_ID curr->_id

#define DELEGATE_START(id)                                                     \
  self->pushTask(SubType::doVisit##id, currp);                                 \
  auto* cast = curr->cast<id>();                                               \
  WASM_UNUSED(cast);

#define DELEGATE_GET_FIELD(id, name) cast->name

#define DELEGATE_FIELD_CHILD(id, name)                                         \
  self->pushTask(SubType::scan, &cast->name);

#define DELEGATE_FIELD_OPTIONAL_CHILD(id, name)                                \
  self->maybePushTask(SubType::scan, &cast->name);

#define DELEGATE_FIELD_INT(id, name)
#define DELEGATE_FIELD_INT_ARRAY(id, name)
#define DELEGATE_FIELD_LITERAL(id, name)
#define DELEGATE_FIELD_NAME(id, name)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, name)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, name)
#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, name)
#define DELEGATE_FIELD_SIGNATURE(id, name)
#define DELEGATE_FIELD_TYPE(id, name)
#define DELEGATE_FIELD_ADDRESS(id, name)

#include "wasm-delegations-fields.h"
  }
};

// Stacks of expressions tend to be limited in size (although, sometimes
// super-nested blocks exist for br_table).
typedef SmallVector<Expression*, 10> ExpressionStack;

// Traversal with a control-flow stack.

template<typename SubType, typename VisitorType = Visitor<SubType>>
struct ControlFlowWalker : public PostWalker<SubType, VisitorType> {
  ControlFlowWalker() = default;

  ExpressionStack controlFlowStack; // contains blocks, loops, and ifs

  // Uses the control flow stack to find the target of a break to a name
  Expression* findBreakTarget(Name name) {
    assert(!controlFlowStack.empty());
    Index i = controlFlowStack.size() - 1;
    while (true) {
      auto* curr = controlFlowStack[i];
      if (Block* block = curr->template dynCast<Block>()) {
        if (name == block->name) {
          return curr;
        }
      } else if (Loop* loop = curr->template dynCast<Loop>()) {
        if (name == loop->name) {
          return curr;
        }
      } else {
        // an if or try, ignorable
        assert(curr->template is<If>() || curr->template is<Try>());
      }
      if (i == 0) {
        return nullptr;
      }
      i--;
    }
  }

  static void doPreVisitControlFlow(SubType* self, Expression** currp) {
    self->controlFlowStack.push_back(*currp);
  }

  static void doPostVisitControlFlow(SubType* self, Expression** currp) {
    // note that we might be popping something else, as we may have been
    // replaced
    self->controlFlowStack.pop_back();
  }

  static void scan(SubType* self, Expression** currp) {
    auto* curr = *currp;

    switch (curr->_id) {
      case Expression::Id::BlockId:
      case Expression::Id::IfId:
      case Expression::Id::LoopId:
      case Expression::Id::TryId: {
        self->pushTask(SubType::doPostVisitControlFlow, currp);
        break;
      }
      default: {
      }
    }

    PostWalker<SubType, VisitorType>::scan(self, currp);

    switch (curr->_id) {
      case Expression::Id::BlockId:
      case Expression::Id::IfId:
      case Expression::Id::LoopId:
      case Expression::Id::TryId: {
        self->pushTask(SubType::doPreVisitControlFlow, currp);
        break;
      }
      default: {
      }
    }
  }
};

// Traversal with an expression stack.

template<typename SubType, typename VisitorType = Visitor<SubType>>
struct ExpressionStackWalker : public PostWalker<SubType, VisitorType> {
  ExpressionStackWalker() = default;

  ExpressionStack expressionStack;

  // Uses the control flow stack to find the target of a break to a name
  Expression* findBreakTarget(Name name) {
    assert(!expressionStack.empty());
    Index i = expressionStack.size() - 1;
    while (true) {
      auto* curr = expressionStack[i];
      if (Block* block = curr->template dynCast<Block>()) {
        if (name == block->name) {
          return curr;
        }
      } else if (Loop* loop = curr->template dynCast<Loop>()) {
        if (name == loop->name) {
          return curr;
        }
      }
      if (i == 0) {
        return nullptr;
      }
      i--;
    }
  }

  Expression* getParent() {
    if (expressionStack.size() == 1) {
      return nullptr;
    }
    assert(expressionStack.size() >= 2);
    return expressionStack[expressionStack.size() - 2];
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
  LinearExecutionWalker() = default;

  // subclasses should implement this
  void noteNonLinear(Expression* curr) { abort(); }

  static void doNoteNonLinear(SubType* self, Expression** currp) {
    self->noteNonLinear(*currp);
  }

  static void scan(SubType* self, Expression** currp) {

    Expression* curr = *currp;

    switch (curr->_id) {
      case Expression::Id::InvalidId:
        abort();
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
      case Expression::Id::TryId: {
        self->pushTask(SubType::doVisitTry, currp);
        self->pushTask(SubType::doNoteNonLinear, currp);
        self->pushTask(SubType::scan, &curr->cast<Try>()->catchBody);
        self->pushTask(SubType::doNoteNonLinear, currp);
        self->pushTask(SubType::scan, &curr->cast<Try>()->body);
        break;
      }
      case Expression::Id::ThrowId: {
        self->pushTask(SubType::doVisitThrow, currp);
        self->pushTask(SubType::doNoteNonLinear, currp);
        auto& list = curr->cast<Throw>()->operands;
        for (int i = int(list.size()) - 1; i >= 0; i--) {
          self->pushTask(SubType::scan, &list[i]);
        }
        break;
      }
      case Expression::Id::RethrowId: {
        self->pushTask(SubType::doVisitRethrow, currp);
        self->pushTask(SubType::doNoteNonLinear, currp);
        self->pushTask(SubType::scan, &curr->cast<Rethrow>()->exnref);
        break;
      }
      case Expression::Id::BrOnExnId: {
        self->pushTask(SubType::doVisitBrOnExn, currp);
        self->pushTask(SubType::doNoteNonLinear, currp);
        self->pushTask(SubType::scan, &curr->cast<BrOnExn>()->exnref);
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
