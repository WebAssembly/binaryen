/*
 * Copyright 2018 WebAssembly Community Group participants
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
// DataFlow IR is an SSA representation. It can be built from the main
// Binaryen IR.
//
// THe main initial use case was an IR that could easily be converted to
// Souper IR, and the design favors that.
//

#ifndef wasm_dataflow_node_h
#define wasm_dataflow_node_h

#include "wasm.h"

namespace wasm {

namespace DataFlow {

//
// The core IR representation in DataFlow: a Node.
//
// We reuse the Binaryen IR as much as possible: when things are identical between
// the two IRs, we just create an Expr node, which stores the opcode and other
// details, and we can emit them to Souper by reading the Binaryen Expression.
// Other node types here are special things from Souper IR that we can't
// represent that way.
//
// * Souper comparisons return an i1. We extend them immediately if they are
//   going to be used as i32s or i64s.
// * When we use an Expression node, we just use its immediate fields, like the
//   op in a binary, alignment etc. in a load, etc. We don't look into the
//   pointers to child nodes. Instead, the DataFlow IR has its own pointers
//   directly to DataFlow children. In particular, this means that it's easy
//   to create an Expression with the info you need and not care about linking
//   it up to other Expressions.
//

struct Node {
  enum Type {
    Var,   // an unknown variable number (not to be confused with var/param/local in wasm)
    Expr,  // a value represented by a Binaryen Expression
    Phi,   // a phi from converging control flow
    Cond,  // a blockpc, representing one of the branchs for a Block
    Block, // a source of phis
    Zext,  // zero-extend an i1 (from an op where Souper returns i1 but wasm does not,
           // and so we need a special way to get back to an i32/i64 if we operate
           // on that value instead of just passing it straight to Souper).
    Bad    // something we can't handle and should ignore
  } type;

  Node(Type type) : type(type) {}

  // TODO: the others, if we need them
  bool isVar() { return type == Var; }
  bool isExpr() { return type == Expr; }
  bool isPhi() { return type == Phi; }
  bool isCond() { return type == Cond; }
  bool isBlock() { return type == Block; }
  bool isZext() { return type == Zext; }
  bool isBad() { return type == Bad; }

  bool isConst() { return type == Expr && expr->is<Const>(); }

  union {
    // For Var
    wasm::Type wasmType;
    // For Expr
    Expression* expr;
    // For Phi and Cond (the local index for phi, the block
    // index for cond)
    Index index;
  };

  // The wasm expression that we originate from (if such exists). A single
  // wasm instruction may be turned into multiple dataflow IR nodes, and some
  // nodes have no wasm origin (like phis).
  Expression* origin = nullptr;

  // Extra list of related nodes.
  // For Expr, these are the Nodes for the inputs to the expression (e.g.
  // a binary would have 2 in this vector here).
  // For Phi, this is the block and then the list of values to pick from.
  // For Cond, this is the block and node.
  // For Block, this is the list of Conds. Note that that block does not
  // depend on them - the Phis do, but we store them in the block so that
  // we can avoid duplication.
  // For Zext, this is the value we extend.
  std::vector<Node*> values;

  // Constructors
  static Node* makeVar(wasm::Type wasmType) {
    Node* ret = new Node(Var);
    ret->wasmType = wasmType;
    return ret;
  }
  static Node* makeExpr(Expression* expr, Expression* origin) {
    Node* ret = new Node(Expr);
    ret->expr = expr;
    ret->origin = origin;
    return ret;
  }
  static Node* makePhi(Node* block, Index index) {
    Node* ret = new Node(Phi);
    ret->addValue(block);
    ret->index = index;
    return ret;
  }
  static Node* makeCond(Node* block, Index index, Node* node) {
    Node* ret = new Node(Cond);
    ret->addValue(block);
    ret->index = index;
    ret->addValue(node);
    return ret;
  }
  static Node* makeBlock() {
    Node* ret = new Node(Block);
    return ret;
  }
  static Node* makeZext(Node* child, Expression* origin) {
    Node* ret = new Node(Zext);
    ret->addValue(child);
    ret->origin = origin;
    return ret;
  }
  static Node* makeBad() {
    Node* ret = new Node(Bad);
    return ret;
  }

  // Helpers

  void addValue(Node* value) {
    values.push_back(value);
  }
  Node* getValue(Index i) {
    return values.at(i);
  }

  // Gets the wasm type of the node. If there isn't a valid one,
  // return unreachable.
  wasm::Type getWasmType() {
    switch (type) {
      case Var:   return wasmType;
      case Expr:  return expr->type;
      case Phi:   return getValue(1)->getWasmType();
      case Zext:  return getValue(0)->getWasmType();
      case Bad:   return unreachable;
      default:    WASM_UNREACHABLE();
    }
  }

  bool operator==(const Node& other) {
    if (type != other.type) return false;
    switch (type) {
      case Var:
      case Block: return this == &other;
      case Expr: {
        if (!ExpressionAnalyzer::equal(expr, other.expr)) {
          return false;
        }
        break;
      }
      case Cond:  if (index != other.index) return false;
      default: {}
    }
    if (values.size() != other.values.size()) return false;
    for (Index i = 0; i < values.size(); i++) {
      if (*(values[i]) != *(other.values[i])) return false;
    }
    return true;
  }

  bool operator!=(const Node& other) {
    return !(*this == other);
  }

  // As mentioned above, comparisons return i1. This checks
  // if an operation is of that sort.
  bool returnsI1() {
    if (isExpr()) {
      if (auto* binary = expr->dynCast<Binary>()) {
        return binary->isRelational();
      } else if (auto* unary = expr->dynCast<Unary>()) {
        return unary->isRelational();
      }
    }
    return false;
  }
};

} // namespace DataFlow

} // namespace wasm

#endif // wasm_dataflow_node
