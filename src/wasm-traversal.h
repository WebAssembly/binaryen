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

namespace wasm {

template<typename SubType, typename ReturnType>
struct WasmVisitor {
  virtual ~WasmVisitor() {}
  // should be pure virtual, but https://gcc.gnu.org/bugzilla/show_bug.cgi?id=51048
  // Expression visitors
  ReturnType visitBlock(Block *curr) { abort(); }
  ReturnType visitIf(If *curr) { abort(); }
  ReturnType visitLoop(Loop *curr) { abort(); }
  ReturnType visitBreak(Break *curr) { abort(); }
  ReturnType visitSwitch(Switch *curr) { abort(); }
  ReturnType visitCall(Call *curr) { abort(); }
  ReturnType visitCallImport(CallImport *curr) { abort(); }
  ReturnType visitCallIndirect(CallIndirect *curr) { abort(); }
  ReturnType visitGetLocal(GetLocal *curr) { abort(); }
  ReturnType visitSetLocal(SetLocal *curr) { abort(); }
  ReturnType visitLoad(Load *curr) { abort(); }
  ReturnType visitStore(Store *curr) { abort(); }
  ReturnType visitConst(Const *curr) { abort(); }
  ReturnType visitUnary(Unary *curr) { abort(); }
  ReturnType visitBinary(Binary *curr) { abort(); }
  ReturnType visitSelect(Select *curr) { abort(); }
  ReturnType visitReturn(Return *curr) { abort(); }
  ReturnType visitHost(Host *curr) { abort(); }
  ReturnType visitNop(Nop *curr) { abort(); }
  ReturnType visitUnreachable(Unreachable *curr) { abort(); }
  // Module-level visitors
  ReturnType visitFunctionType(FunctionType *curr) { abort(); }
  ReturnType visitImport(Import *curr) { abort(); }
  ReturnType visitExport(Export *curr) { abort(); }
  ReturnType visitFunction(Function *curr) { abort(); }
  ReturnType visitTable(Table *curr) { abort(); }
  ReturnType visitMemory(Memory *curr) { abort(); }
  ReturnType visitModule(Module *curr) { abort(); }

#define DELEGATE(CLASS_TO_VISIT) \
  return static_cast<SubType*>(this)-> \
      visit##CLASS_TO_VISIT(static_cast<CLASS_TO_VISIT*>(curr))

  ReturnType visit(Expression *curr) {
    assert(curr);
    switch (curr->_id) {
      case Expression::Id::InvalidId: abort();
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
      default: WASM_UNREACHABLE();
    }
  }
};

//
// Base class for all WasmWalkers
//
template<typename SubType, typename ReturnType = void>
struct WasmWalkerBase : public WasmVisitor<SubType, ReturnType> {
  virtual void walk(Expression*& curr) { abort(); }
  virtual void startWalk(Function *func) { abort(); }
  virtual void startWalk(Module *module) { abort(); }
};

template<typename ParentType>
struct ChildWalker : public WasmWalkerBase<ChildWalker<ParentType>> {
  ParentType& parent;

  ChildWalker(ParentType& parent) : parent(parent) {}

  void visitBlock(Block *curr) {
    ExpressionList& list = curr->list;
    for (size_t z = 0; z < list.size(); z++) {
      parent.walk(list[z]);
    }
  }
  void visitIf(If *curr) {
    parent.walk(curr->condition);
    parent.walk(curr->ifTrue);
    parent.walk(curr->ifFalse);
  }
  void visitLoop(Loop *curr) {
    parent.walk(curr->body);
  }
  void visitBreak(Break *curr) {
    parent.walk(curr->condition);
    parent.walk(curr->value);
  }
  void visitSwitch(Switch *curr) {
    parent.walk(curr->condition);
    if (curr->value) parent.walk(curr->value);
  }
  void visitCall(Call *curr) {
    ExpressionList& list = curr->operands;
    for (size_t z = 0; z < list.size(); z++) {
      parent.walk(list[z]);
    }
  }
  void visitCallImport(CallImport *curr) {
    ExpressionList& list = curr->operands;
    for (size_t z = 0; z < list.size(); z++) {
      parent.walk(list[z]);
    }
  }
  void visitCallIndirect(CallIndirect *curr) {
    parent.walk(curr->target);
    ExpressionList& list = curr->operands;
    for (size_t z = 0; z < list.size(); z++) {
      parent.walk(list[z]);
    }
  }
  void visitGetLocal(GetLocal *curr) {}
  void visitSetLocal(SetLocal *curr) {
    parent.walk(curr->value);
  }
  void visitLoad(Load *curr) {
    parent.walk(curr->ptr);
  }
  void visitStore(Store *curr) {
    parent.walk(curr->ptr);
    parent.walk(curr->value);
  }
  void visitConst(Const *curr) {}
  void visitUnary(Unary *curr) {
    parent.walk(curr->value);
  }
  void visitBinary(Binary *curr) {
    parent.walk(curr->left);
    parent.walk(curr->right);
  }
  void visitSelect(Select *curr) {
    parent.walk(curr->ifTrue);
    parent.walk(curr->ifFalse);
    parent.walk(curr->condition);
  }
  void visitReturn(Return *curr) {
    parent.walk(curr->value);
  }
  void visitHost(Host *curr) {
    ExpressionList& list = curr->operands;
    for (size_t z = 0; z < list.size(); z++) {
      parent.walk(list[z]);
    }
  }
  void visitNop(Nop *curr) {}
  void visitUnreachable(Unreachable *curr) {}
};

//
// Simple WebAssembly children-first walking (i.e., post-order, if you look
// at the children as subtrees of the current node), with the ability to replace
// the current expression node. Useful for writing optimization passes.
//

template<typename SubType, typename ReturnType = void>
struct WasmWalker : public WasmWalkerBase<SubType, ReturnType> {
  Expression* replace;

  WasmWalker() : replace(nullptr) {}

  // the visit* methods can call this to replace the current node
  void replaceCurrent(Expression *expression) {
    replace = expression;
  }

  // By default, do nothing
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

  ReturnType visitFunctionType(FunctionType *curr) {}
  ReturnType visitImport(Import *curr) {}
  ReturnType visitExport(Export *curr) {}
  ReturnType visitFunction(Function *curr) {}
  ReturnType visitTable(Table *curr) {}
  ReturnType visitMemory(Memory *curr) {}
  ReturnType visitModule(Module *curr) {}

  // children-first
  void walk(Expression*& curr) override {
    if (!curr) return;

    // special-case Block, because Block nesting (in their first element) can be incredibly deep
    if (curr->is<Block>()) {
      auto* block = curr->dyn_cast<Block>();
      std::vector<Block*> stack;
      stack.push_back(block);
      while (block->list.size() > 0 && block->list[0]->is<Block>()) {
        block = block->list[0]->cast<Block>();
        stack.push_back(block);
      }
      // walk all the children
      for (int i = int(stack.size()) - 1; i >= 0; i--) {
        auto* block = stack[i];
        auto& children = block->list;
        for (size_t j = 0; j < children.size(); j++) {
          if (i < int(stack.size()) - 1 && j == 0) {
            // this is one of the stacked blocks, no need to walk its children, we are doing that ourselves
            this->visit(children[0]);
            if (replace) {
              children[0] = replace;
              replace = nullptr;
            }
          } else {
            this->walk(children[j]);
          }
        }
      }
      // we walked all the children, and can rejoin later below to visit this node itself
    } else {
      // generic child-walking
      ChildWalker<WasmWalker<SubType, ReturnType>>(*this).visit(curr);
    }

    this->visit(curr);

    if (replace) {
      curr = replace;
      replace = nullptr;
    }
  }

  void startWalk(Function *func) override {
    walk(func->body);
  }

  void startWalk(Module *module) override {
    // Dispatch statically through the SubType.
    SubType* self = static_cast<SubType*>(this);
    for (auto curr : module->functionTypes) {
      self->visitFunctionType(curr);
      assert(!replace);
    }
    for (auto curr : module->imports) {
      self->visitImport(curr);
      assert(!replace);
    }
    for (auto curr : module->exports) {
      self->visitExport(curr);
      assert(!replace);
    }
    for (auto curr : module->functions) {
      startWalk(curr);
      self->visitFunction(curr);
      assert(!replace);
    }
    self->visitTable(&module->table);
    assert(!replace);
    self->visitMemory(&module->memory);
    assert(!replace);
    self->visitModule(module);
    assert(!replace);
  }
};

}

#endif // wasm_traversal_h
