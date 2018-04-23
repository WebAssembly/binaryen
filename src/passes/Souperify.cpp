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
// Souperify - convert to Souper IR in text form.
//
// This needs 'flatten' to be run before it, as it assumes the IR is in
// flat form. You may also want to optimize a little, e.g.
//    --flatten --simplify-locals-nonesting
// (as otherwise flattening introduces many copies; we do ignore boring
// copies here, but they end up as identical LHSes).
//
// See https://github.com/google/souper/issues/323
//

#include "wasm.h"
#include "pass.h"
#include "wasm-builder.h"
#include "ir/find_all.h"
#include "ir/literal-utils.h"

namespace wasm {

// Simple IR for data flow computation for Souper.
// TODO: loops
// TODO: generalize for other things?

namespace DataFlow {

struct Node {
  // We reuse the Binaryen IR as much as possible: when things are identical between
  // the two IRs, we just create an Expr node, which stores the opcode and other
  // details, and we can emit them to Souper by reading the Binaryen Expression.
  // Other node types here are special things from Souper IR that we can't
  // represent that way.
  // TODO: add more nodes for the differences between the two IRs, like i1.
  enum Type {
    Var,   // an unknown variable number (not to be confused with var/param/local in wasm)
    Expr,  // a value represented by a Binaryen Expression
    Const, // a constant value
    Phi,   // a phi from converging control flow
    Cond,  // a condition on a block path (pc or blockpc)
    Block, // a source of phis
    Bad    // something we can't handle and should ignore
  } type;

  Node(Type type) : type(type) {}

  // TODO: the others, if we need them
  bool isExpr() { return type == Expr; }
  bool isConst() { return type == Const; }
  bool isBad() { return type == Bad; }

  union {
    // For Var
    Index varIndex;
    // For Expr
    Expression* expr;
    // For Const
    Literal value;
    // For Phi
    Node* block;
    // For Cond
    struct { // TODO: move out?
      Node* block;
      Index index;
      Node* node;
      Literal value;
    } cond;
    // For Block
    Index blockSize;
  };

  // Extra list of related nodes.
  // For Expr, these are the Nodes for the inputs to the expression (e.g.
  // a binary would have 2 in this vector here).
  // For Phi, this is the list of values to pick from.
  // For Block, this is the list of Conds. Note that that block does not
  // depend on them - the Phis do, but we store them in the block so that
  // we can avoid duplication.
  std::vector<Node*> values;

  // Constructors
  static Node* makeVar(Index varIndex) {
    Node* ret = new Node(Var);
    ret->varIndex = varIndex;
    return ret;
  }
  static Node* makeExpr(Expression* expr) {
    Node* ret = new Node(Expr);
    ret->expr = expr;
    return ret;
  }
  static Node* makeConst(Literal value) {
    Node* ret = new Node(Const);
    ret->value = value;
    return ret;
  }
  static Node* makePhi(Node* block) {
    Node* ret = new Node(Phi);
    ret->block = block;
    return ret;
  }
  static Node* makeCond(Node* block, Index index, Node* node, Literal value) {
    Node* ret = new Node(Cond);
    ret->cond.block = block;
    ret->cond.index = index;
    ret->cond.node = node;
    ret->cond.value = value;
    return ret;
  }
  static Node* makeBlock(Index blockSize) {
    Node* ret = new Node(Block);
    ret->blockSize = blockSize;
    return ret;
  }
  static Node* makeBad() {
    Node* ret = new Node(Bad);
    return ret;
  }

  // Helpers

  void addValue(Node* value) {
    assert(type == Expr || type == Phi || type == Block);
    values.push_back(value);
  }
  Node* getValue(Index i) {
    assert(type == Expr || type == Phi || type == Block);
    return values.at(i);
  }
};

// We only need one canonical bad node. It is never modified.
static Node CanonicalBad(Node::Type::Bad);

// Main logic to generate IR for a function. This is implemented as a
// visitor on the wasm, where visitors return a Node* that either
// contains the DataFlow IR for that expression, which can be a
// Bad node if not supported, or nullptr if not relevant (we only
// use the return value for internal expressions, that is, the
// value of a set_local or the condition of an if etc).
struct Builder : public Visitor<Builder, Node*> {
  // Tracks the state of locals in a control flow path:
  //   localState[i] = the node whose value it contains
  typedef std::vector<Node*> LocalState;

  // The current local state in the control flow path being emitted.
  LocalState localState;

  // Connects a specific set to the data in its value.
  std::unordered_map<SetLocal*, Node*> setNodeMap;

  // Maps a control-flo expression to the DataFlow Block for it. E.g.
  // for an if that is the block for the if condition.
  std::unordered_map<Expression*, Node*> expressionBlockMap;

  // Maps each expression to its control-flow parent (or null if
  // there is none). We only map expressions we need to know about,
  // which are sets and control-flow constructs.
  std::unordered_map<Expression*, Expression*> parentMap;

  Expression* parent = nullptr;

  // All the sets, in order of appearance.
  std::vector<SetLocal*> sets;

  // The function being processed.
  Function* func;

  // All of our nodes
  std::vector<std::unique_ptr<Node>> nodes;

  // We need to create some extra expression nodes in some case.
  MixedArena extra;

  // Check if a function is relevant for us.
  static bool check(Function* func) {
    // TODO handle loops. for now, just ignore the entire function
    if (!FindAll<Loop>(func->body).list.empty()) {
      return false;
    }
    return true;
  }

  Builder(Function* funcInit) {
    func = funcInit;
    std::cout << "\n; function: " << func->name << '\n';
    // Set up initial local state IR.
    localState.resize(func->getNumLocals());
    for (Index i = 0; i < func->getNumLocals(); i++) {
      Node* node;
      if (func->isParam(i)) {
        node = Node::makeVar(i);
      } else {
        node = Node::makeConst(LiteralUtils::makeLiteralZero(func->getLocalType(i)));
      }
      addNode(node);
      localState[i] = node;
    }
    // Process the function body, generating the rest of the IR.
    visit(func->body);
    // TODO: handle value flowing out of body
  }

  // Add a new node to our list of owned nodes.
  Node* addNode(Node* node) {
    nodes.push_back(std::unique_ptr<Node>(node));
    return node;
  }

  // Merge local state for multiple control flow paths
  // TODO: more than 2
  void merge(const LocalState& aState, const LocalState& bState, Node* condition, Expression* expr, LocalState& out) {
    assert(out.size() == func->getNumLocals());
    auto* block = addNode(Node::makeBlock(2));
    // FIXME: we need eqz neqz here
    block->addValue(addNode(Node::makeCond(block, 0, condition, Literal(int32_t(1)))));
    block->addValue(addNode(Node::makeCond(block, 1, condition, Literal(int32_t(0)))));
    expressionBlockMap[expr] = block;
    for (Index i = 0; i < func->getNumLocals(); i++) {
      auto a = aState[i];
      auto b = bState[i];
      if (a == b) {
        out[i] = a;
      } else {
        // We need to actually merge some stuff.
        auto* phi = addNode(Node::makePhi(block));
        phi->addValue(a);
        phi->addValue(b);
        out[i] = phi;
      }
    }
  }

  // Visitors.

  Node* visitBlock(Block* curr) {
    // TODO: handle super-deep nesting
    // TODO: handle breaks to here
    auto* oldParent = parent;
    parentMap[curr] = oldParent;
    parent = curr;
    for (auto* child : curr->list) {
      visit(child);
    }
    parent = oldParent;
    return nullptr;
  }
  Node* visitIf(If* curr) {
    auto* oldParent = parent;
    parentMap[curr] = oldParent;
    parent = curr;
    // Set up the condition.
    Node* condition = visit(curr->condition);
    assert(condition);
    // Handle the contents.
    auto initialState = localState;
    visit(curr->ifTrue);
    auto afterIfTrueState = localState;
    if (curr->ifFalse) {
      localState = initialState;
      visit(curr->ifFalse);
      auto afterIfFalseState = localState; // TODO: optimize
      merge(afterIfTrueState, afterIfFalseState, condition, curr, localState);
    } else {
      merge(initialState, afterIfTrueState, condition, curr, localState);
    }
    parent = oldParent;
    return nullptr;
  }
  Node* visitLoop(Loop* curr) { return &CanonicalBad; }
  Node* visitBreak(Break* curr) { return &CanonicalBad; }
  Node* visitSwitch(Switch* curr) { return &CanonicalBad; }
  Node* visitCall(Call* curr) { return &CanonicalBad; }
  Node* visitCallImport(CallImport* curr) { return &CanonicalBad; }
  Node* visitCallIndirect(CallIndirect* curr) { return &CanonicalBad; }
  Node* visitGetLocal(GetLocal* curr) {
    // We now know which IR node this get refers to
    return localState[curr->index];
  }
  Node* visitSetLocal(SetLocal* curr) {
    sets.push_back(curr);
    parentMap[curr] = parent;
    // If we are doing a copy, just do the copy.
    if (auto* get = curr->value->dynCast<GetLocal>()) {
      setNodeMap[curr] = localState[curr->index] = localState[get->index];
      return nullptr;
    }
    // Make a new IR node for the new value here.
    auto* node = setNodeMap[curr] = visit(curr->value);
    localState[curr->index] = node;
    return nullptr;
  }
  Node* visitGetGlobal(GetGlobal* curr) {
    return &CanonicalBad;
  }
  Node* visitSetGlobal(SetGlobal* curr) {
    return &CanonicalBad;
  }
  Node* visitLoad(Load* curr) {
    return &CanonicalBad;
  }
  Node* visitStore(Store* curr) {
    return &CanonicalBad;
  }
  Node* visitAtomicRMW(AtomicRMW* curr) {
    return &CanonicalBad;
  }
  Node* visitAtomicCmpxchg(AtomicCmpxchg* curr) {
    return &CanonicalBad;
  }
  Node* visitAtomicWait(AtomicWait* curr) {
    return &CanonicalBad;
  }
  Node* visitAtomicWake(AtomicWake* curr) {
    return &CanonicalBad;
  }
  Node* visitConst(Const* curr) {
    return addNode(Node::makeConst(curr->value));
  }
  Node* visitUnary(Unary* curr) {
    return &CanonicalBad;
  }
  Node* visitBinary(Binary *curr) {
    // First, check if we support this op.
    switch (curr->op) {
      case AddInt32:
      case AddInt64:
      case SubInt32:
      case SubInt64:
      case MulInt32:
      case MulInt64:
      case DivSInt32:
      case DivSInt64:
      case DivUInt32:
      case DivUInt64:
      case RemSInt32:
      case RemSInt64:
      case RemUInt32:
      case RemUInt64:
      case AndInt32:
      case AndInt64:
      case OrInt32:
      case OrInt64:
      case XorInt32:
      case XorInt64:
      case ShlInt32:
      case ShlInt64:
      case ShrUInt32:
      case ShrUInt64:
      case ShrSInt32:
      case ShrSInt64:
      case RotLInt32:
      case RotLInt64:
      case RotRInt32:
      case RotRInt64:
      case EqInt32:
      case EqInt64:
      case NeInt32:
      case NeInt64:
      case LtSInt32:
      case LtSInt64:
      case LtUInt32:
      case LtUInt64:
      case LeSInt32:
      case LeSInt64:
      case LeUInt32:
      case LeUInt64: {
        // These are ok as-is.
        // Check if our children are supported.
        auto* left = visit(curr->left);
        if (left->isBad()) return left;
        auto* right = visit(curr->right);
        if (right->isBad()) return right;
        // Great, we are supported!
        auto* ret = addNode(Node::makeExpr(curr));
        ret->addValue(left);
        ret->addValue(right);
        return ret;
      }
      case GtSInt32:
      case GtSInt64:
      case GeSInt32:
      case GeSInt64:
      case GtUInt32:
      case GtUInt64:
      case GeUInt32:
      case GeUInt64: {
        // These need to be flipped as Souper does not support redundant ops.
        wasm::Builder builder(extra);
        BinaryOp opposite;
        switch (curr->op) {
          case GtSInt32: opposite = LeSInt32; break;
          case GtSInt64: opposite = LeSInt64; break;
          case GeSInt32: opposite = LtSInt32; break;
          case GeSInt64: opposite = LtSInt64; break;
          case GtUInt32: opposite = LeUInt32; break;
          case GtUInt64: opposite = LeUInt64; break;
          case GeUInt32: opposite = LtUInt32; break;
          case GeUInt64: opposite = LtUInt64; break;
          default: WASM_UNREACHABLE();
        }
        return visitBinary(builder.makeBinary(opposite, curr->right, curr->left));
      }
      default: return &CanonicalBad; // anything else is bad
    }
  }
  Node* visitSelect(Select* curr) {
    return &CanonicalBad;
  }
  Node* visitDrop(Drop* curr) {
    return &CanonicalBad;
  }
  Node* visitReturn(Return* curr) {
    // note we don't need the value (it's a const or a get as we are flattened)
    return nullptr;
  }
  Node* visitHost(Host* curr) {
    return &CanonicalBad;
  }
  Node* visitNop(Nop* curr) {
    return nullptr;
  }
  Node* visitUnreachable(Unreachable* curr) {
    return &CanonicalBad;
  }
};

// Generates a trace: all the information to generate a Souper LHS
// for a specific set_local whose value we want to infer.
struct Trace {
  Builder& builder;
  SetLocal* set;

  bool bad = false;
  std::vector<Node*> nodes;
  std::unordered_set<Node*> addedNodes;
  std::unordered_set<Node*> pathConditions; // which conditions were added as path conditions

  Trace(Builder& builder, SetLocal* set) : builder(builder), set(set) {
    auto* node = builder.setNodeMap[set];
    // Pull in all the dependencies, starting from the value itself.
    add(node);
    // If nothing bad showed up, still mark it as bad if it's trivial
    // and worthless.
    if (!bad) {
      if (nodes.size() <= 1) {
        bad = true;
      }
    }
    // Also pull in conditions based on the location of this node: e.g.
    // if it is inside an if's true branch, we can add a path-condition
    // for that.
    addPath(set);
  }

  Node* add(Node* node) {
    switch (node->type) {
      case Node::Type::Var: {
        break; // nothing more to add
      }
      case Node::Type::Expr: {
        // Add the dependencies.
        assert(!node->expr->is<GetLocal>());
        for (Index i = 0; i < node->values.size(); i++) {
          add(node->getValue(i));
        }
        break;
      }
      case Node::Type::Const: {
        return node; // nothing more to add
      }
      case Node::Type::Phi: {
        auto* block = add(node->block);
        // First, add the conditions for the block
        for (Index i = 0; i < block->blockSize; i++) {
          add(block->getValue(i));
        }
        // Then, add the phi values
        for (Index i = 0; i < block->blockSize; i++) {
          add(node->getValue(i));
        }
        break;
      }
      case Node::Type::Cond: {
        if (!isPathCondition(node)) {
          add(node->cond.block);
        }
        add(node->cond.node);
        break;
      }
      case Node::Type::Block: {
        break; // nothing more to add
      }
      case Node::Type::Bad: {
        bad = true;
        return nullptr;
      }
      default: WASM_UNREACHABLE();
    }
    if (addedNodes.count(node) == 0) {
      addedNodes.insert(node);
      nodes.push_back(node);
    }
    return node;
  }

  void addPath(Expression* curr) {
    // We track curr and parent, which are always in the state of parent
    // being the parent of curr.
    auto* parent = builder.parentMap.at(set);
    while (parent) {
      auto iter = builder.expressionBlockMap.find(parent);
      if (iter != builder.expressionBlockMap.end()) {
        // Given the block, add a proper path-condition
        Node* node = iter->second;
        addPathTo(parent, curr, node);
      }
      curr = parent;
      parent = builder.parentMap.at(parent);
    }
  }

  // curr is a child of parent, and parent has a Block which we are
  // give as 'node'. Add a path condition for reaching the child.
  void addPathTo(Expression* parent, Expression* curr, Node* node) {
    if (auto* iff = parent->dynCast<If>()) {
      Index index;
      if (curr == iff->ifTrue) {
        index = 0;
      } else if (curr == iff->ifFalse) {
        index = 1;
      } else {
        WASM_UNREACHABLE();
      }
      auto* condition = node->getValue(index);
      pathConditions.insert(condition);
      add(condition);
    } else {
      WASM_UNREACHABLE();
    }
  }

  bool isPathCondition(Node* node) {
    return pathConditions.count(node) == 1;
  }

  bool isBad() {
    return bad;
  }
};

// Emits a trace, which is basically a Souper LHS.
struct Printer {
  Builder& builder;
  Trace& trace;

  // Each Node in a trace has an index, from 0.
  std::unordered_map<Node*, Index> indexing;

  Printer(Builder& builder, Trace& trace) : builder(builder), trace(trace) {
    std::cout << "\n; start LHS\n";
    // Index the nodes.
    for (auto* node : trace.nodes) {
      if (!trace.isPathCondition(node)) { // pcs do not need to be indexed
        auto index = indexing.size();
        indexing[node] = index;
      }
    }
    // Print them out.
    for (auto* node : trace.nodes) {
      print(node);
    }
    // Finish up
    std::cout << "infer %" << indexing[builder.setNodeMap[trace.set]] << "\n\n";
  }

  void print(Node* node) {
    assert(node);
    switch (node->type) {
      case Node::Type::Var: {
        std::cout << "%" << indexing[node] << ":" << printType(builder.func->getLocalType(node->varIndex)) << " = var";
        break; // nothing more to add
      }
      case Node::Type::Expr: {
        std::cout << "%" << indexing[node] << " = ";
        printExpression(node);
        break;
      }
      case Node::Type::Const: {
        std::cout << "%" << indexing[node] << " = ";
        print(node->value);
        break;
      }
      case Node::Type::Phi: {
        auto* block = node->block;
        std::cout << "%" << indexing[node] << " = phi %" << indexing[block];
        for (Index i = 0; i < block->blockSize; i++) {
          std::cout << ", %" << indexing[node->getValue(i)];
        }
        break;
      }
      case Node::Type::Cond: {
        if (!trace.isPathCondition(node)) {
          // blockpc
          std::cout << "%" << indexing[node] << " = blockpc %" << indexing[node->cond.block] << ' ' << node->cond.index;;
        } else {
          // pc
          std::cout << "pc";
        }
        std::cout << " %" << indexing[node->cond.node] << ' ';
        print(node->cond.value);
        break;
      }
      case Node::Type::Block: {
        std::cout << "%" << indexing[node] << " = block " << node->blockSize;
        break;
      }
      case Node::Type::Bad: {
        std::cout << "!!!BAD!!!";
        WASM_UNREACHABLE();
      }
      default: WASM_UNREACHABLE();
    }
    std::cout << '\n';
  }

  void print(Literal value) {
    std::cout << value.getInteger() << ':' << printType(value.type);
  }

  void printInternal(Node* node) {
    assert(node);
    if (node->isConst()) {
      print(node->value);
    } else {
      std::cout << "%" << indexing[node];
    }
  }

  // Emit an expression

  void printExpression(Node* node) {
    assert(node->isExpr());
    // TODO use a Visitor here?
    auto* curr = node->expr;
    if (auto* c = curr->dynCast<Const>()) {
      print(c->value);
    } else if (auto* binary = curr->dynCast<Binary>()) {
      switch (binary->op) {
        case AddInt32:
        case AddInt64:  std::cout << "add";  break;
        case SubInt32:
        case SubInt64:  std::cout << "sub";  break;
        case MulInt32:
        case MulInt64:  std::cout << "mul";  break;
        case DivSInt32:
        case DivSInt64: std::cout << "sdiv"; break;
        case DivUInt32:
        case DivUInt64: std::cout << "udiv"; break;
        case RemSInt32:
        case RemSInt64: std::cout << "srem"; break;
        case RemUInt32:
        case RemUInt64: std::cout << "urem"; break;
        case AndInt32:
        case AndInt64:  std::cout << "and";  break;
        case OrInt32:
        case OrInt64:   std::cout << "or";   break;
        case XorInt32:
        case XorInt64:  std::cout << "xor";  break;
        case ShlInt32:
        case ShlInt64:  std::cout << "shl";  break;
        case ShrUInt32:
        case ShrUInt64: std::cout << "ushr"; break;
        case ShrSInt32:
        case ShrSInt64: std::cout << "sshr"; break;
        case RotLInt32:
        case RotLInt64: std::cout << "rotl"; break;
        case RotRInt32:
        case RotRInt64: std::cout << "rotr"; break;
        case EqInt32:
        case EqInt64:   std::cout << "eq";   break;
        case NeInt32:
        case NeInt64:   std::cout << "ne";   break;
        case LtSInt32:
        case LtSInt64:  std::cout << "slt";  break;
        case LtUInt32:
        case LtUInt64:  std::cout << "ult";  break;
        case LeSInt32:
        case LeSInt64:  std::cout << "sle";  break;
        case LeUInt32:
        case LeUInt64:  std::cout << "ule";  break;

        default: WASM_UNREACHABLE();
      }
      std::cout << ' ';
      auto* left = node->getValue(0);
      printInternal(left);
      std::cout << ", ";
      auto* right = node->getValue(1);
      printInternal(right);
    } else {
      WASM_UNREACHABLE();
    }
  }
};

} // namespace DataFlow

struct Souperify : public WalkerPass<PostWalker<Souperify>> {
  // Not parallel, for now - could parallelize and combine outputs at the end.
  // If Souper is thread-safe, we could also run it in parallel.

  void doWalkFunction(Function* func) {
    if (DataFlow::Builder::check(func)) {
      // Build the data-flow IR.
      DataFlow::Builder builder(func);
      // Emit possible traces.
      for (auto* set : builder.sets) {
        DataFlow::Trace trace(builder, set);
        if (!trace.isBad()) {
          DataFlow::Printer(builder, trace);
        }
      }
    }
  }
};

Pass *createSouperifyPass() {
  return new Souperify();
}

} // namespace wasm

