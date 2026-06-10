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

#include "ir/debuginfo.h"
#include "support/small_vector.h"
#include "support/threads.h"
#include "wasm.h"

namespace wasm {

namespace internal {
template<typename T, typename = void> struct GetIsConst { static constexpr bool value = false; };
template<typename T> struct GetIsConst<T, std::void_t<decltype(T::IsConst)>> { static constexpr bool value = T::IsConst; };
}

template<bool IsConstVisitor, typename T>
using MaybeConst = std::conditional_t<IsConstVisitor, const T, T>;

// A generic visitor, defaulting to doing nothing on each visit

template<typename SubType, typename ReturnType_ = void, bool IsConstVisitor = false> struct Visitor {
  // Capture the parameter in something we can access later.
  using ReturnType = ReturnType_;
  static constexpr bool IsConst = IsConstVisitor;
  template<typename T> using C = MaybeConst<IsConstVisitor, T>;

  // Expression visitors
#define DELEGATE(CLASS_TO_VISIT)                                               \
  ReturnType visit##CLASS_TO_VISIT(C<CLASS_TO_VISIT>* curr) {                     \
    return ReturnType();                                                       \
  }
#include "wasm-delegations.def"

  // Module-level visitors
  ReturnType visitExport(C<Export>* curr) { return ReturnType(); }
  ReturnType visitGlobal(C<Global>* curr) { return ReturnType(); }
  ReturnType visitFunction(C<Function>* curr) { return ReturnType(); }
  ReturnType visitTable(C<Table>* curr) { return ReturnType(); }
  ReturnType visitElementSegment(C<ElementSegment>* curr) { return ReturnType(); }
  ReturnType visitMemory(C<Memory>* curr) { return ReturnType(); }
  ReturnType visitDataSegment(C<DataSegment>* curr) { return ReturnType(); }
  ReturnType visitTag(C<Tag>* curr) { return ReturnType(); }
  ReturnType visitModule(C<Module>* curr) { return ReturnType(); }

  ReturnType visit(C<Expression>* curr) {
    assert(curr);

    switch (curr->_id) {
#define DELEGATE(CLASS_TO_VISIT)                                               \
  case Expression::Id::CLASS_TO_VISIT##Id:                                     \
    return static_cast<SubType*>(this)->visit##CLASS_TO_VISIT(                 \
      static_cast<C<CLASS_TO_VISIT>*>(curr))

#include "wasm-delegations.def"

      default:
        WASM_UNREACHABLE("unexpected expression type");
    }
  }
};

// A visitor which must be overridden for each visitor that is reached.

template<typename SubType, typename ReturnType = void, bool IsConstVisitor = false>
struct OverriddenVisitor : public Visitor<SubType, ReturnType, IsConstVisitor> {
  template<typename T> using C = MaybeConst<IsConstVisitor, T>;
// Expression visitors, which must be overridden
#define DELEGATE(CLASS_TO_VISIT)                                               \
  ReturnType visit##CLASS_TO_VISIT(C<CLASS_TO_VISIT>* curr) {                     \
    static_assert(                                                             \
      &SubType::visit##CLASS_TO_VISIT !=                                       \
        &OverriddenVisitor<SubType, ReturnType, IsConstVisitor>::visit##CLASS_TO_VISIT,        \
      "Derived class must implement visit" #CLASS_TO_VISIT);                   \
    WASM_UNREACHABLE("Derived class must implement visit" #CLASS_TO_VISIT);    \
  }

#include "wasm-delegations.def"
};

// Visit with a single unified visitor, called on every node, instead of
// separate visit* per node

template<typename SubType, typename ReturnType = void, bool IsConstVisitor = false>
struct UnifiedExpressionVisitor : public Visitor<SubType, ReturnType, IsConstVisitor> {
  template<typename T> using C = MaybeConst<IsConstVisitor, T>;
  // called on each node
  ReturnType visitExpression(C<Expression>* curr) { return ReturnType(); }

  // redirects
#define DELEGATE(CLASS_TO_VISIT)                                               \
  ReturnType visit##CLASS_TO_VISIT(C<CLASS_TO_VISIT>* curr) {                     \
    return static_cast<SubType*>(this)->visitExpression(curr);                 \
  }

#include "wasm-delegations.def"
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
  static constexpr bool IsConst = internal::GetIsConst<VisitorType>::value;
  template<typename T> using C = MaybeConst<IsConst, T>;

  // Useful methods for visitor implementations

  // Replace the current node. You can call this in your visit*() methods.
  // Note that the visit*() for the result node is not called for you (i.e.,
  // just one visit*() method is called by the traversal; if you replace a node,
  // and you want to process the output, you must do that explicitly).
  template<bool U = IsConst, typename std::enable_if<!U, int>::type = 0>
  Expression* replaceCurrent(Expression* expression) {
    // Copy debug info, if present.
    if (currFunction) {
      debuginfo::copyOriginalToReplacement(
        getCurrent(), expression, currFunction);
    }
    return *replacep = expression;
  }

  C<Expression>* getCurrent() { return *replacep; }

  C<Expression>** getCurrentPointer() { return replacep; }

  // Get the current module
  C<Module>* getModule() { return currModule; }

  // Get the current function
  C<Function>* getFunction() { return currFunction; }

  // Walk starting

  void walkGlobal(C<Global>* global) {
    walk(global->init);
    static_cast<SubType*>(this)->visitGlobal(global);
  }

  void walkFunction(C<Function>* func) {
    setFunction(func);
    static_cast<SubType*>(this)->doWalkFunction(func);
    static_cast<SubType*>(this)->visitFunction(func);
    setFunction(nullptr);
  }

  void walkTag(C<Tag>* tag) { static_cast<SubType*>(this)->visitTag(tag); }

  void walkFunctionInModule(C<Function>* func, C<Module>* module) {
    setModule(module);
    setFunction(func);
    static_cast<SubType*>(this)->doWalkFunction(func);
    static_cast<SubType*>(this)->visitFunction(func);
    setFunction(nullptr);
    setModule(nullptr);
  }

  // override this to provide custom functionality
  void doWalkFunction(C<Function>* func) { walk(func->body); }

  void walkElementSegment(C<ElementSegment>* segment) {
    if (segment->isActive()) {
      walk(segment->offset);
    }
    for (auto* expr : segment->data) {
      walk(expr);
    }
    static_cast<SubType*>(this)->visitElementSegment(segment);
  }

  void walkTable(C<Table>* table) {
    if (table->init) {
      walk(table->init);
    }
    static_cast<SubType*>(this)->visitTable(table);
  }

  void walkDataSegment(C<DataSegment>* segment) {
    if (segment->isActive()) {
      walk(segment->offset);
    }
    static_cast<SubType*>(this)->visitDataSegment(segment);
  }

  void walkMemory(C<Memory>* memory) {
    // TODO: This method and walkTable should walk children too, or be renamed.
    static_cast<SubType*>(this)->visitMemory(memory);
  }

  void walkModule(C<Module>* module) {
    setModule(module);
    static_cast<SubType*>(this)->doWalkModule(module);
    static_cast<SubType*>(this)->visitModule(module);
    setModule(nullptr);
  }

  // override this to provide custom functionality
  void doWalkModule(C<Module>* module) {
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
    for (auto& curr : module->tags) {
      if (curr->imported()) {
        self->visitTag(curr.get());
      } else {
        self->walkTag(curr.get());
      }
    }
    for (auto& curr : module->elementSegments) {
      self->walkElementSegment(curr.get());
    }
    for (auto& curr : module->tables) {
      self->walkTable(curr.get());
    }
    for (auto& curr : module->dataSegments) {
      self->walkDataSegment(curr.get());
    }
    for (auto& curr : module->memories) {
      self->walkMemory(curr.get());
    }
  }

  // Walks module-level code, that is, code that is not in functions.
  void walkModuleCode(C<Module>* module) {
    setModule(module);
    // Dispatch statically through the SubType.
    SubType* self = static_cast<SubType*>(this);
    for (auto& curr : module->tables) {
      if (curr->init) {
        self->walk(curr->init);
      }
    }
    for (auto& curr : module->globals) {
      if (!curr->imported()) {
        self->walk(curr->init);
      }
    }
    for (auto& curr : module->elementSegments) {
      if (curr->offset) {
        self->walk(curr->offset);
      }
      for (auto* item : curr->data) {
        self->walk(item);
      }
    }
    for (auto& curr : module->dataSegments) {
      if (curr->offset) {
        self->walk(curr->offset);
      }
    }
    setModule(nullptr);
  }

  // Walk implementation. We don't use recursion as ASTs may be highly
  // nested.

  // Tasks receive the this pointer and a pointer to the pointer to operate on
  using TaskFunc = void (*)(SubType*, C<Expression>**);

  struct Task {
    TaskFunc func;
    C<Expression>** currp;
    Task() {}
    Task(TaskFunc func, C<Expression>** currp) : func(func), currp(currp) {}
  };

  void pushTask(TaskFunc func, C<Expression>** currp) {
    assert(*currp);
    stack.emplace_back(func, currp);
  }
  void maybePushTask(TaskFunc func, C<Expression>** currp) {
    if (*currp) {
      stack.emplace_back(func, currp);
    }
  }
  Task popTask() {
    auto ret = stack.back();
    stack.pop_back();
    return ret;
  }

  void walk(Expression* const& root) {
    assert(stack.size() == 0);
    C<Expression>** p = (C<Expression>**)&root;
    pushTask(SubType::scan, p);
    while (stack.size() > 0) {
      auto task = popTask();
      replacep = task.currp;
      assert(*task.currp);
      task.func(static_cast<SubType*>(this), task.currp);
    }
  }

  // subclasses implement this to define the proper order of execution
  static void scan(SubType* self, C<Expression>** currp) { abort(); }

  // task hooks to call visitors

#define DELEGATE(CLASS_TO_VISIT)                                               \
  static void doVisit##CLASS_TO_VISIT(SubType* self, C<Expression>** currp) {     \
    self->visit##CLASS_TO_VISIT((*currp)->template cast<CLASS_TO_VISIT>());             \
  }

#include "wasm-delegations.def"

  void setModule(C<Module>* module) { this->currModule = module; }

  void setFunction(C<Function>* func) { this->currFunction = func; }

private:
  // the address of the current node, used to replace it
  C<Expression>** replacep = nullptr;
  SmallVector<typename Walker<SubType, VisitorType>::Task, 10> stack;      // stack of tasks
  C<Function>* currFunction = nullptr; // current function being processed
  C<Module>* currModule = nullptr;     // current module being processed
};

// Define which expression classes are leaves. We can handle them more
// optimally below. The accuracy of this list is tested in leaves.cpp.
template<typename T> struct IsLeaf : std::false_type {};

template<> struct IsLeaf<LocalGet> : std::true_type {};
template<> struct IsLeaf<GlobalGet> : std::true_type {};
template<> struct IsLeaf<AtomicFence> : std::true_type {};
template<> struct IsLeaf<Pause> : std::true_type {};
template<> struct IsLeaf<DataDrop> : std::true_type {};
template<> struct IsLeaf<Const> : std::true_type {};
template<> struct IsLeaf<MemorySize> : std::true_type {};
template<> struct IsLeaf<RefNull> : std::true_type {};
template<> struct IsLeaf<RefFunc> : std::true_type {};
template<> struct IsLeaf<TableSize> : std::true_type {};
template<> struct IsLeaf<ElemDrop> : std::true_type {};
template<> struct IsLeaf<Rethrow> : std::true_type {};
template<> struct IsLeaf<Nop> : std::true_type {};
template<> struct IsLeaf<Unreachable> : std::true_type {};
template<> struct IsLeaf<Pop> : std::true_type {};
template<> struct IsLeaf<StringConst> : std::true_type {};

// Walks in post-order, i.e., children first. When there isn't an obvious
// order to operands, we follow them in order of execution.

template<typename SubType, typename VisitorType = Visitor<SubType>>
struct PostWalker : public Walker<SubType, VisitorType> {
  static constexpr bool IsConst = internal::GetIsConst<VisitorType>::value;
  template<typename T> using C = MaybeConst<IsConst, T>;

  static void scan(SubType* self, C<Expression>** currp) {
    C<Expression>* curr = *currp;

#define DELEGATE_ID curr->_id

    // Don't push empty tasks, that is, functions that we just push to the
    // stack, pop, and then nothing happens when we call the empty function. The
    // default visitFoo() in Visitor is empty, and the static doVisitFoo() in
    // Walker just calls it, so if neither have been changed, we know that
    // nothing will run.
    //
    // Note that we check Visitor<..> and not VisitorType. Only Visitor is the
    // actual top type we know has empty visitors, while VisitorType could be
    // anything.
    //
    // Unfortunately we must avoid this in gcc 11 and earlier, as they error on
    // these function pointers not being constexpr. Remove the constexpr there.
    // Note that even if this ends up being a runtime check, it should be faster
    // than pushing empty tasks, as the check is much faster than the push/pop/
    // call, and a large number of our calls (most, perhaps) are not overridden.
    //
    // If we do *not* have an empty visitor, we can still optimize in the case
    // of a leaf: leaves have no children, so we can just call doVisit* rather
    // than push that task, pop it later, and call that.
#if defined(__GNUC__) && !defined(__clang__) && __GNUC__ <= 11
#define DELEGATE_START(id)                                                     \
  if (&SubType::visit##id !=                                                   \
        &Visitor<SubType, typename SubType::ReturnType, IsConst>::visit##id || \
      &SubType::doVisit##id != &Walker<SubType, VisitorType>::doVisit##id) {   \
    self->pushTask(SubType::doVisit##id, currp);                               \
  }                                                                            \
  [[maybe_unused]] auto* cast = curr->template cast<id>();
#else // constexpr
#define DELEGATE_START(id)                                                     \
  if constexpr (&SubType::visit##id !=                                         \
                  &Visitor<SubType,                                            \
                           typename SubType::ReturnType, IsConst>::visit##id || \
                &SubType::doVisit##id !=                                       \
                  &Walker<SubType, VisitorType>::doVisit##id) {                \
    if constexpr (IsLeaf<id>::value &&                                         \
                  &SubType::scan == &PostWalker<SubType, VisitorType>::scan) { \
      SubType::doVisit##id(self, currp);                                       \
      return;                                                                  \
    }                                                                          \
    self->pushTask(SubType::doVisit##id, currp);                               \
  }                                                                            \
  [[maybe_unused]] auto* cast = curr->template cast<id>();
#endif // constexpr

#define DELEGATE_GET_FIELD(id, field) cast->field

#define DELEGATE_FIELD_CHILD(id, field)                                        \
  self->pushTask(SubType::scan, (C<Expression>**)&cast->field);

#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field)                               \
  self->maybePushTask(SubType::scan, (C<Expression>**)&cast->field);

#define DELEGATE_FIELD_INT(id, field)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field)
#define DELEGATE_FIELD_TYPE(id, field)
#define DELEGATE_FIELD_HEAPTYPE(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)

#include "wasm-delegations-fields.def"
  }
};

// Stacks of expressions tend to be limited in size (although, sometimes
// super-nested blocks exist for br_table).
using ExpressionStack = SmallVector<Expression*, 10>;

// Traversal with a control-flow stack.

template<typename SubType, typename VisitorType = Visitor<SubType>>
struct ControlFlowWalker : public PostWalker<SubType, VisitorType> {
  static constexpr bool IsConst = internal::GetIsConst<VisitorType>::value;
  template<typename T> using C = MaybeConst<IsConst, T>;
  
  // contains blocks, loops, ifs, trys, and try_tables
  SmallVector<C<Expression>*, 10> controlFlowStack;

  // Uses the control flow stack to find the target of a break to a name
  C<Expression>* findBreakTarget(Name name) {
    assert(!controlFlowStack.empty());
    Index i = controlFlowStack.size() - 1;
    while (true) {
      auto* curr = controlFlowStack[i];
      if (C<Block>* block = curr->template dynCast<Block>()) {
        if (name == block->name) {
          return curr;
        }
      } else if (C<Loop>* loop = curr->template dynCast<Loop>()) {
        if (name == loop->name) {
          return curr;
        }
      } else {
        // an if, try, or try_table, ignorable
        assert(curr->template is<If>() || curr->template is<Try>() ||
               curr->template is<TryTable>());
      }
      if (i == 0) {
        return nullptr;
      }
      i--;
    }
  }

  static void doPreVisitControlFlow(SubType* self, C<Expression>** currp) {
    self->controlFlowStack.push_back(*currp);
  }

  static void doPostVisitControlFlow(SubType* self, C<Expression>** currp) {
    // note that we might be popping something else, as we may have been
    // replaced
    self->controlFlowStack.pop_back();
  }

  static void scan(SubType* self, C<Expression>** currp) {
    auto* curr = *currp;

    switch (curr->_id) {
      case Expression::Id::BlockId:
      case Expression::Id::IfId:
      case Expression::Id::LoopId:
      case Expression::Id::TryId:
      case Expression::Id::TryTableId: {
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
      case Expression::Id::TryId:
      case Expression::Id::TryTableId: {
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
  static constexpr bool IsConst = internal::GetIsConst<VisitorType>::value;
  template<typename T> using C = MaybeConst<IsConst, T>;

  ExpressionStackWalker() = default;

  SmallVector<C<Expression>*, 10> expressionStack;

  // Uses the control flow stack to find the target of a break to a name
  C<Expression>* findBreakTarget(Name name) {
    assert(!expressionStack.empty());
    Index i = expressionStack.size() - 1;
    while (true) {
      auto* curr = expressionStack[i];
      if (C<Block>* block = curr->template dynCast<Block>()) {
        if (name == block->name) {
          return curr;
        }
      } else if (C<Loop>* loop = curr->template dynCast<Loop>()) {
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

  C<Expression>* getParent() {
    if (expressionStack.size() == 1) {
      return nullptr;
    }
    assert(expressionStack.size() >= 2);
    return expressionStack[expressionStack.size() - 2];
  }

  static void doPreVisit(SubType* self, C<Expression>** currp) {
    self->expressionStack.push_back(*currp);
  }

  static void doPostVisit(SubType* self, C<Expression>** currp) {
    self->expressionStack.pop_back();
  }

  static void scan(SubType* self, C<Expression>** currp) {
    self->pushTask(SubType::doPostVisit, currp);

    PostWalker<SubType, VisitorType>::scan(self, currp);

    self->pushTask(SubType::doPreVisit, currp);
  }

  template<bool U = IsConst, typename std::enable_if<!U, int>::type = 0>
  Expression* replaceCurrent(Expression* expression) {
    PostWalker<SubType, VisitorType>::replaceCurrent(expression);
    // also update the stack
    expressionStack.back() = expression;
    return expression;
  }
};

// Traversal keeping track of try depth

// This is used to keep track of whether we are in the scope of an
// exception handler. This matters since return_call is not equivalent
// to return + call within an exception handler. If another kind of
// handler scope is added, this code will need to be updated.
template<typename SubType, typename VisitorType = Visitor<SubType>>
struct TryDepthWalker : public PostWalker<SubType, VisitorType> {
  TryDepthWalker() = default;

  size_t tryDepth = 0;

  static void doEnterTry(SubType* self, Expression** currp) {
    self->tryDepth++;
  }

  static void doLeaveTry(SubType* self, Expression** currp) {
    self->tryDepth--;
  }

  static void scan(SubType* self, Expression** currp) {
    auto* curr = *currp;

    if (curr->is<Try>()) {
      self->pushTask(SubType::doVisitTry, currp);
      auto& catchBodies = curr->cast<Try>()->catchBodies;
      for (int i = int(catchBodies.size()) - 1; i >= 0; i--) {
        self->pushTask(SubType::scan, &catchBodies[i]);
      }
      self->pushTask(SubType::doLeaveTry, currp);
      self->pushTask(SubType::scan, &curr->cast<Try>()->body);
      self->pushTask(SubType::doEnterTry, currp);
      return;
    }

    if (curr->is<TryTable>()) {
      self->pushTask(SubType::doLeaveTry, currp);
    }

    PostWalker<SubType, VisitorType>::scan(self, currp);

    if (curr->is<TryTable>()) {
      self->pushTask(SubType::doEnterTry, currp);
    }
  }
};

} // namespace wasm

#endif // wasm_wasm_traversal_h
