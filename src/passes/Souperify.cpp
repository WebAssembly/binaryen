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
//    --flatten --simplify-locals-nonesting --reorder-locals
// (as otherwise flattening introduces many copies; we do ignore boring
// copies here, but they end up as identical LHSes).
//
// See https://github.com/google/souper/issues/323
//
// TODO:
//  * pcs and blockpcs for things other than ifs
//  * Investigate 'inlining', adding in nodes through calls
//  * Consider generalizing DataFlow IR for internal Binaryen use.
//  * Automatic conversion of Binaryen IR opts to run on the DataFlow IR.
//    This would subsume precompute-propagate, for example. Using DFIR we
//    can "expand" the BIR into expressions that BIR opts can handle
//    directly, without the need for *-propagate techniques.
//

#include "wasm.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm-printing.h"
#include "ir/abstract.h"
#include "ir/literal-utils.h"
#include "ir/utils.h"

namespace wasm {

// Simple IR for data flow computation for Souper.

namespace DataFlow {

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
  bool isBad() { return type == Bad; }

  union {
    // For Var
    wasm::Type wasmType;
    // For Expr
    Expression* expr;
    // For Cond
    Index index;
  };

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
  static Node* makeExpr(Expression* expr) {
    Node* ret = new Node(Expr);
    ret->expr = expr;
    return ret;
  }
  static Node* makePhi(Node* block) {
    Node* ret = new Node(Phi);
    ret->addValue(block);
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
  static Node* makeZext(Node* child) {
    Node* ret = new Node(Zext);
    ret->addValue(child);
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

  wasm::Type getWasmType() {
    switch (type) {
      case Var:   return wasmType;
      case Expr:  return expr->type;
      case Phi:   return getValue(1)->getWasmType();
      case Zext:  return getValue(0)->getWasmType();
      default:    WASM_UNREACHABLE();
    }
  }

  bool operator==(const Node& other) {
    if (type != other.type) return false;
    switch (type) {
      case Var:
      case Block: return this == &other;
      case Expr:  if (!ExpressionAnalyzer::equal(expr, other.expr)) return false;
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
};

// As mentioned above, comparisons return i1. This checks
// if an operation is of that sort.
static bool returnsI1InDataFlow(Expression* curr) {
  if (auto* binary = curr->dynCast<Binary>()) {
    return binary->isRelational();
  } else if (auto* unary = curr->dynCast<Unary>()) {
    return unary->isRelational();
  }
  return false;
}

// As mentioned above, comparisons return i1. This checks
// if an operation is of that sort.
static bool returnsI1(Node* node) {
  if (node->isExpr()) {
    return returnsI1InDataFlow(node->expr);
  }
  return false;
}

// We only need one canonical bad node. It is never modified.
static Node CanonicalBad(Node::Type::Bad);

// Main logic to generate IR for a function. This is implemented as a
// visitor on the wasm, where visitors return a Node* that either
// contains the DataFlow IR for that expression, which can be a
// Bad node if not supported, or nullptr if not relevant (we only
// use the return value for internal expressions, that is, the
// value of a set_local or the condition of an if etc).
struct Builder : public Visitor<Builder, Node*> {
  // Connects a specific set to the data in its value.
  std::unordered_map<SetLocal*, Node*> setNodeMap;

  // Maps a control-flow expression to the conditions for it. Currently,
  // this maps an if to the conditions for its arms
  std::unordered_map<Expression*, std::vector<Node*>> expressionConditionMap;

  // Maps each expression to its control-flow parent (or null if
  // there is none). We only map expressions we need to know about,
  // which are sets and control-flow constructs.
  std::unordered_map<Expression*, Expression*> parentMap;

  // All the sets, in order of appearance.
  std::vector<SetLocal*> sets;

  // The function being processed.
  Function* func;

  // All of our nodes
  std::vector<std::unique_ptr<Node>> nodes;

  // We need to create some extra expression nodes in some case.
  MixedArena extra;

  // Tracking state during building

  // We need to track the parents of control flow nodes.
  Expression* parent = nullptr;

  // Tracks the state of locals in a control flow path:
  //   locals[i] = the node whose value it contains
  // When we are in unreachable code (i.e., a path that does not
  // need to be merged in anywhere), we set the length of this
  // vector to 0 to indicate that.
  typedef std::vector<Node*> Locals;

  // The current local state in the control flow path being emitted.
  Locals locals;

  // The local states on branches to a specific target.
  std::unordered_map<Name, std::vector<Locals>> breakStates;

  // The local state in a control flow path, including a possible
  // condition as well.
  struct FlowState {
    Locals locals; // TODO: avoid copies here
    Node* condition;
    FlowState(Locals locals, Node* condition) : locals(locals), condition(condition) {}
  };

  // API

  // Check if a function is relevant for us.
  static bool check(Function* func) {
    return true;
  }

  Builder(Function* funcInit) {
    func = funcInit;
    std::cout << "\n; function: " << func->name << '\n';
    auto numLocals = func->getNumLocals();
    if (numLocals == 0) return; // nothing to do
    // Set up initial local state IR.
    setInReachable();
    for (Index i = 0; i < numLocals; i++) {
      Node* node;
      auto type = func->getLocalType(i);
      if (func->isParam(i)) {
        node = makeVar(type);
      } else {
        node = makeZero(type);
      }
      locals[i] = node;
    }
    // Process the function body, generating the rest of the IR.
    visit(func->body);
  }

  // Makes a Var node, representing a value that could be anything.
  Node* makeVar(wasm::Type type) {
    if (isRelevantType(type)) {
      return addNode(Node::makeVar(type));
    } else {
      return &CanonicalBad;
    }
  }

  Node* makeZero(wasm::Type type) {
    wasm::Builder builder(extra);
    return addNode(Node::makeExpr(builder.makeConst(LiteralUtils::makeLiteralZero(type))));
  }

  // Add a new node to our list of owned nodes.
  Node* addNode(Node* node) {
    nodes.push_back(std::unique_ptr<Node>(node));
    return node;
  }

  Node* makeZeroComp(Node* node, bool equal) {
    assert(!node->isBad());
    wasm::Builder builder(extra);
    auto type = node->getWasmType();
    auto* expr = builder.makeBinary(Abstract::getBinary(type, equal ? Abstract::Eq : Abstract::Ne), getUnused(type), getUnused(type));
    // The unused child nodes are unreachable, but we don't need this to be a fully useful node,
    // just force the type to what we know is correct.
    expr->type = type;
    auto* zero = makeZero(type);
    auto* check = addNode(Node::makeExpr(expr));
    check->addValue(expandFromI1(node));
    check->addValue(zero);
    return check;
  }

  Expression* getUnused(wasm::Type type) {
    wasm::Builder builder(extra);
    // Use unreachable nodes, so that if we see them in use that indicates
    // something went horribly wrong.
    switch(type) {
      case i32: return builder.makeUnreachable();
      case i64: return builder.makeUnreachable();
      default: WASM_UNREACHABLE();
    }
  }

  void setInUnreachable() {
    locals.clear();
  }

  void setInReachable() {
    locals.resize(func->getNumLocals());
  }

  bool isInUnreachable() {
    return isInUnreachable(locals);
  }

  bool isInUnreachable(const Locals& state) {
    return state.empty();
  }

  bool isInUnreachable(const FlowState& state) {
    return isInUnreachable(state.locals);
  }

  // Visitors.

  Node* visitBlock(Block* curr) {
    // TODO: handle super-deep nesting
    auto* oldParent = parent;
    parentMap[curr] = oldParent;
    parent = curr;
    for (auto* child : curr->list) {
      visit(child);
    }
    // Merge the outputs
    // TODO handle conditions on these breaks
    if (curr->name.is()) {
      auto iter = breakStates.find(curr->name);
      if (iter != breakStates.end()) {
        auto& states = iter->second;
        // Add the state flowing out
        states.push_back(locals);
        mergeBlock(states, locals);
      }
    }
    parent = oldParent;
    return &CanonicalBad;
  }
  Node* visitIf(If* curr) {
    auto* oldParent = parent;
    parentMap[curr] = oldParent;
    parent = curr;
    // Set up the condition.
    Node* condition = visit(curr->condition);
    assert(condition);
    // Handle the contents.
    auto initialState = locals;
    visit(curr->ifTrue);
    auto afterIfTrueState = locals;
    if (curr->ifFalse) {
      locals = initialState;
      visit(curr->ifFalse);
      auto afterIfFalseState = locals; // TODO: optimize
      mergeIf(afterIfTrueState, afterIfFalseState, condition, curr, locals);
    } else {
      mergeIf(initialState, afterIfTrueState, condition, curr, locals);
    }
    parent = oldParent;
    return &CanonicalBad;
  }
  Node* visitLoop(Loop* curr) {
/*
    // As in Souper's LLVM extractor, we avoid loop phis, as we don't want
    // our traces to represent a value that differs across loop iterations.
    // For example,
    //   %b = block
    //   %x = phi %b, 1, %y
    //   %y = phi %b, 2, %x
    //   %z = eq %x %y
    //   infer %z
    // Here %y refers to the previous iteration's %x.
    // To do this, we set all locals to a Var at the loop entry, then process
    // the inside of the loop. When that is done, we can see if a phi was
    // actually needed for each local. If it was, we leave the Var (it
    // represents an unknown value; analysis stops there), and if not, we
    // can replace the Var with the fixed value.
    // TODO: perhaps some more general uses of DataFlow will want loop phis?
    // TODO: optimize stuff here
    if (!curr->name.is()) {
      return &CanonicalBad; // no phis are possible
    }
    auto previous = locals;
    auto numLocals = func->getNumLocals();
    for (Index i = 0; i < numLocals; i++) {
      local = makeVar(func->getLocalType(i));
    }
    visit(curr->body);
    auto iter = breakStates.find(curr->name);
    if (iter == breakStates.end()) {
      return &CanonicalBad; // no phis are possible
    }
    auto& breaks = iter->second;
    // Phis are possible, check for them.
    for (Index i = 0; i < numLocals; i++) {
      auto proper = previous[i];
      for (auto& other : breaks) {
        if (other[i] != proper)
      }
    }


*/
    return &CanonicalBad;
  }
  Node* visitBreak(Break* curr) {
    breakStates[curr->name].push_back(locals);
    if (!curr->condition) {
      setInUnreachable();
    }
    return &CanonicalBad;
  }
  Node* visitSwitch(Switch* curr) {
    std::unordered_set<Name> targets;
    for (auto target : curr->targets) {
      targets.insert(target);
    }
    targets.insert(curr->default_);
    for (auto target : targets) {
      breakStates[target].push_back(locals);
    }
    setInUnreachable();
    return &CanonicalBad;
  }
  Node* visitCall(Call* curr) {
    return makeVar(curr->type);
  }
  Node* visitCallImport(CallImport* curr) {
    return makeVar(curr->type);
  }
  Node* visitCallIndirect(CallIndirect* curr) {
    return makeVar(curr->type);
  }
  Node* visitGetLocal(GetLocal* curr) {
    if (!isRelevantLocal(curr->index) || isInUnreachable()) {
      return &CanonicalBad;
    }
    // We now know which IR node this get refers to
    return locals[curr->index];
  }
  Node* visitSetLocal(SetLocal* curr) {
    if (!isRelevantLocal(curr->index) || isInUnreachable()) {
      return &CanonicalBad;
    }
    sets.push_back(curr);
    parentMap[curr] = parent;
    // Set the current node in the local state.
    locals[curr->index] = setNodeMap[curr] = visit(curr->value);
    return &CanonicalBad;
  }
  Node* visitGetGlobal(GetGlobal* curr) {
    return makeVar(curr->type);
  }
  Node* visitSetGlobal(SetGlobal* curr) {
    return &CanonicalBad;
  }
  Node* visitLoad(Load* curr) {
    return makeVar(curr->type);
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
    return addNode(Node::makeExpr(curr));
  }
  Node* visitUnary(Unary* curr) {
    // First, check if we support this op.
    switch (curr->op) {
      case ClzInt32:
      case ClzInt64:
      case CtzInt32:
      case CtzInt64:
      case PopcntInt32:
      case PopcntInt64: {
        // These are ok as-is.
        // Check if our child is supported.
        auto* value = expandFromI1(visit(curr->value));
        if (value->isBad()) return value;
        // Great, we are supported!
        auto* ret = addNode(Node::makeExpr(curr));
        ret->addValue(value);
        return ret;
      }
      case EqZInt32:
      case EqZInt64: {
        // These can be implemented using a binary.
        // Check if our child is supported.
        auto* value = expandFromI1(visit(curr->value));
        if (value->isBad()) return value;
        // Great, we are supported!
        return makeZeroComp(value, true);
      }
      default: {
        // Anything else is an unknown value.
        return makeVar(curr->type);
      }
    }
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
        auto* left = expandFromI1(visit(curr->left));
        if (left->isBad()) return left;
        auto* right = expandFromI1(visit(curr->right));
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
      default: {
        // Anything else is an unknown value.
        return makeVar(curr->type);
      }
    }
  }
  Node* visitSelect(Select* curr) {
    auto* ifTrue = expandFromI1(visit(curr->ifTrue));
    if (ifTrue->isBad()) return ifTrue;
    auto* ifFalse = expandFromI1(visit(curr->ifFalse));
    if (ifFalse->isBad()) return ifFalse;
    auto* condition = ensureI1(visit(curr->condition));
    if (condition->isBad()) return condition;
    // Great, we are supported!
    auto* ret = addNode(Node::makeExpr(curr));
    ret->addValue(condition);
    ret->addValue(ifTrue);
    ret->addValue(ifFalse);
    return ret;
  }
  Node* visitDrop(Drop* curr) {
    return &CanonicalBad;
  }
  Node* visitReturn(Return* curr) {
    // note we don't need the value (it's a const or a get as we are flattened)
    setInUnreachable();
    return &CanonicalBad;
  }
  Node* visitHost(Host* curr) {
    return &CanonicalBad;
  }
  Node* visitNop(Nop* curr) {
    return &CanonicalBad;
  }
  Node* visitUnreachable(Unreachable* curr) {
    setInUnreachable();
    return &CanonicalBad;
  }

  // Helpers.

  bool isRelevantType(wasm::Type type) {
    return isIntegerType(type);
  }

  bool isRelevantLocal(Index index) {
    return isRelevantType(func->getLocalType(index));
  }

  // Merge local state for an if, also creating a block and conditions.
  void mergeIf(Locals& aState, Locals& bState, Node* condition, Expression* expr, Locals& out) {
    // Create the conditions (if we can).
    Node* ifTrue;
    Node* ifFalse;
    if (!condition->isBad()) {
      // Generate boolean (i1 returning) conditions for the two branches.
      auto& conditions = expressionConditionMap[expr];
      ifTrue = ensureI1(condition);
      conditions.push_back(ifTrue);
      ifFalse = makeZeroComp(condition, true);
      conditions.push_back(ifFalse);
    } else {
      ifTrue = ifFalse = &CanonicalBad;
    }
    // Finally, merge the state with that block. TODO optimize
    std::vector<FlowState> states;
    states.emplace_back(aState, ifTrue);
    states.emplace_back(bState, ifFalse);
    merge(states, out);
  }

  // Merge local state for a block
  void mergeBlock(std::vector<Locals>& localses, Locals& out) {
    // TODO: conditions
    std::vector<FlowState> states;
    for (auto& locals : localses) {
      states.emplace_back(locals, &CanonicalBad);
    }
    merge(states, out);
  }

  // Merge local state for multiple control flow paths, creating phis as needed.
  void merge(std::vector<FlowState>& states, Locals& out) {
    Index numLocals = func->getNumLocals();
    // Ignore unreachable states; we don't need to merge them.
    states.erase(std::remove_if(states.begin(), states.end(), [&](const FlowState& curr) {
      return isInUnreachable(curr.locals);
    }), states.end());
    Index numStates = states.size();
    if (numStates == 0) {
      // We were unreachable, and still are.
      assert(isInUnreachable());
      return;
    }
    // We may have just become reachable, if we were not before.
    setInReachable();
    // Just one thing to merge is trivial.
    if (numStates == 1) {
      out = states[0].locals;
      return;
    }
    // We create a block if we need one.
    Node* block = nullptr;
    for (Index i = 0; i < numLocals; i++) {
      // Process the inputs. If any is bad, the phi is bad.
      bool bad = false;
      for (auto& state : states) {
        auto* node = state.locals[i];
        if (node->isBad()) {
          bad = true;
          out[i] = node;
          break;
        }
      }
      if (bad) continue;
      // Nothing is bad, proceed.
      Node* first = nullptr;
      for (auto& state : states) {
        if (!first) {
          first = out[i] = state.locals[i];
        } else if (state.locals[i] != first) {
          // We need to actually merge some stuff.
          if (!block) {
            block = addNode(Node::makeBlock());
            for (Index index = 0; index < numStates; index++) {
              auto* condition = states[index].condition;
              if (!condition->isBad()) {
                condition = addNode(Node::makeCond(block, index, condition));
              }
              block->addValue(condition);
            }
          }
          auto* phi = addNode(Node::makePhi(block));
          for (auto& state : states) {
            phi->addValue(expandFromI1(state.locals[i]));
          }
          out[i] = phi;
          break;
        }
      }
    }
  }

  // If the node returns an i1, then we are called from a context that needs
  // to use it normally as in wasm - extend it
  Node* expandFromI1(Node* node) {
    if (!node->isBad() && returnsI1(node)) {
      node = addNode(Node::makeZext(node));
    }
    return node;
  }

  Node* ensureI1(Node* node) {
    if (!node->isBad() && !returnsI1(node)) {
      node = makeZeroComp(node, false);
    }
    return node;
  }
};

// Generates a trace: all the information to generate a Souper LHS
// for a specific set_local whose value we want to infer.
struct Trace {
  Builder& builder;
  SetLocal* set;

  // A limit on how deep we go - we don't want to create arbitrarily
  // large traces.
  size_t depthLimit = 10;

  bool bad = false;
  std::vector<Node*> nodes;
  std::unordered_set<Node*> addedNodes;
  std::vector<Node*> pathConditions;
  // When we need to (like when the depth is too deep), we replace
  // expressions with other expressions, and track them here.
  std::unordered_map<Node*, std::unique_ptr<Node>> replacements;

  Trace(Builder& builder, SetLocal* set) : builder(builder), set(set) {
    // Check if there is a depth limit override
    auto* depthLimitStr = getenv("BINARYEN_SOUPERIFY_DEPTH_LIMIT");
    if (depthLimitStr) {
      depthLimit = atoi(depthLimitStr);
    }
    // Get the node for this set.
    auto* node = builder.setNodeMap[set];
    // Pull in all the dependencies, starting from the value itself.
    add(node, 0);
    // If we are trivial before adding pcs, we are still trivial, and
    // can ignore this.
    auto sizeBeforePathConditions = nodes.size();
    if (!bad) {
      // No input is uninteresting
      if (sizeBeforePathConditions == 0) {
        bad = true;
        return;
      }
      // Just a var is uninteresting. TODO: others too?
      if (sizeBeforePathConditions == 1 && nodes[0]->isVar()) {
        bad = true;
        return;
      }
    }
    // Also pull in conditions based on the location of this node: e.g.
    // if it is inside an if's true branch, we can add a path-condition
    // for that.
    addPath(set);
  }

  Node* add(Node* node, size_t depth) {
    depth++;
    // If already added, nothing more to do.
    if (addedNodes.find(node) != addedNodes.end()) {
      return node;
    }
    switch (node->type) {
      case Node::Type::Var: {
        break; // nothing more to add
      }
      case Node::Type::Expr: {
        // If this is a Const, it's not an instruction - nothing to add,
        // it's just a value.
        if (node->expr->is<Const>()) {
          return node;
        }
        // If we've gone too deep, emit a var instead.
        if (depth >= depthLimit) {
          auto* var = Node::makeVar(node->getWasmType());
          replacements[node] = std::unique_ptr<Node>(var);
          return var;
        }
        // Add the dependencies.
        assert(!node->expr->is<GetLocal>());
        for (Index i = 0; i < node->values.size(); i++) {
          add(node->getValue(i), depth);
        }
        break;
      }
      case Node::Type::Phi: {
        auto* block = add(node->getValue(0), depth);
        auto size = block->values.size();
        // First, add the conditions for the block
        for (Index i = 0; i < size; i++) {
          // a condition may be bad, but conditions are not necessary -
          // we can proceed without the extra condition information
          auto* condition = block->getValue(i);
          if (!condition->isBad()) {
            add(condition, depth);
          }
        }
        // Then, add the phi values
        for (Index i = 1; i < size + 1; i++) {
          add(node->getValue(i), depth);
        }
        break;
      }
      case Node::Type::Cond: {
        add(node->getValue(0), depth); // add the block
        add(node->getValue(1), depth); // add the node
        break;
      }
      case Node::Type::Block: {
        break; // nothing more to add
      }
      case Node::Type::Zext: {
        add(node->getValue(0), depth);
        break;
      }
      case Node::Type::Bad: {
        bad = true;
        return nullptr;
      }
      default: WASM_UNREACHABLE();
    }
    // Assert on no cycles
    assert(addedNodes.find(node) == addedNodes.end());
    nodes.push_back(node);
    addedNodes.insert(node);
    return node;
  }

  void addPath(Expression* curr) {
    // We track curr and parent, which are always in the state of parent
    // being the parent of curr.
    auto* parent = builder.parentMap.at(set);
    while (parent) {
      auto iter = builder.expressionConditionMap.find(parent);
      if (iter != builder.expressionConditionMap.end()) {
        // Given the block, add a proper path-condition
        addPathTo(parent, curr, iter->second);
      }
      curr = parent;
      parent = builder.parentMap.at(parent);
    }
  }

  // curr is a child of parent, and parent has a Block which we are
  // give as 'node'. Add a path condition for reaching the child.
  void addPathTo(Expression* parent, Expression* curr, std::vector<Node*> conditions) {
    if (auto* iff = parent->dynCast<If>()) {
      Index index;
      if (curr == iff->ifTrue) {
        index = 0;
      } else if (curr == iff->ifFalse) {
        index = 1;
      } else {
        WASM_UNREACHABLE();
      }
      auto* condition = conditions[index];
      // Add the condition itself as an instruction in the trace -
      // the pc uses it as its input.
      add(condition, 0);
      // Add it as a pc, which we will emit directly.
      pathConditions.push_back(condition);
    } else {
      WASM_UNREACHABLE();
    }
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

  bool debug;

  Printer(Builder& builder, Trace& trace) : builder(builder), trace(trace) {
    debug = getenv("BINARYEN_DEBUG_SOUPERIFY") != nullptr;

    std::cout << "\n; start LHS (in " << builder.func->name << ")\n";
    // Index the nodes.
    for (auto* node : trace.nodes) {
      if (!node->isCond()) { // pcs and blockpcs are not instructions and do not need to be indexed
        auto index = indexing.size();
        indexing[node] = index;
      }
    }
    // Print them out.
    for (auto* node : trace.nodes) {
      print(node);
    }
    // Print out pcs.
    for (auto* condition : trace.pathConditions) {
      printPathCondition(condition);
    }

    // Finish up
    std::cout << "infer %" << indexing[builder.setNodeMap[trace.set]] << "\n\n";
  }

  void print(Node* node) {
    assert(node);
    // The node may have been replaced during trace building, if so then
    // print the proper replacement.
    auto iter = trace.replacements.find(node);
    if (iter != trace.replacements.end()) {
      print(iter->second.get());
      return;
    }
    switch (node->type) {
      case Node::Type::Var: {
        std::cout << "%" << indexing[node] << ":" << printType(node->wasmType) << " = var\n";
        break; // nothing more to add
      }
      case Node::Type::Expr: {
        if (debug) {
          std::cout << "; ";
          WasmPrinter::printExpression(node->expr, std::cout, true);
          std::cout << '\n';
        }
        std::cout << "%" << indexing[node] << " = ";
        printExpression(node);
        break;
      }
      case Node::Type::Phi: {
        auto* block = node->getValue(0);
        auto size = block->values.size();
        std::cout << "%" << indexing[node] << " = phi %" << indexing[block];
        for (Index i = 1; i < size + 1; i++) {
          std::cout << ", ";
          printInternal(node->getValue(i));
        }
        std::cout << '\n';
        if (debug) warnOnSuspiciousValues(node, 1, size);
        break;
      }
      case Node::Type::Cond: {
        std::cout << "blockpc %" << indexing[node->getValue(0)] << ' ' << node->index << ' ';
        printInternal(node->getValue(1));
        std::cout << " 1:i1\n";
        break;
      }
      case Node::Type::Block: {
        std::cout << "%" << indexing[node] << " = block " << node->values.size() << '\n';
        break;
      }
      case Node::Type::Zext: {
        auto* child = node->getValue(0);
        std::cout << "%" << indexing[node] << ':' << printType(child->getWasmType());
        std::cout << " = zext ";
        printInternal(child);
        std::cout << '\n';
        break;
      }
      case Node::Type::Bad: {
        std::cout << "!!!BAD!!!";
        WASM_UNREACHABLE();
      }
      default: WASM_UNREACHABLE();
    }
  }

  void print(Literal value) {
    std::cout << value.getInteger() << ':' << printType(value.type);
  }

  void printInternal(Node* node) {
    assert(node);
    if (node->isExpr() && node->expr->is<Const>()) {
      print(node->expr->cast<Const>()->value);
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
      std::cout << '\n';
    } else if (auto* unary = curr->dynCast<Unary>()) {
      switch (unary->op) {
        case ClzInt32:
        case ClzInt64:    std::cout << "ctlz";  break;
        case CtzInt32:
        case CtzInt64:    std::cout << "cttz";  break;
        case PopcntInt32:
        case PopcntInt64: std::cout << "ctpop"; break;
        default: WASM_UNREACHABLE();
      }
      std::cout << ' ';
      auto* value = node->getValue(0);
      printInternal(value);
      std::cout << '\n';
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
        case ShrUInt64: std::cout << "lshr"; break;
        case ShrSInt32:
        case ShrSInt64: std::cout << "ashr"; break;
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
      std::cout << '\n';
      if (debug) warnOnSuspiciousValues(node, 0, 1);
    } else if (curr->is<Select>()) {
      std::cout << "select ";
      printInternal(node->getValue(0));
      std::cout << ", ";
      printInternal(node->getValue(1));
      std::cout << ", ";
      printInternal(node->getValue(2));
      std::cout << '\n';
      if (debug) warnOnSuspiciousValues(node, 0, 2);
    } else {
      WASM_UNREACHABLE();
    }
  }

  void printPathCondition(Node* condition) {
    std::cout << "pc ";
    printInternal(condition);
    std::cout << " 1:i1\n";
  }

  // Checks if a range [inclusiveStart, inclusiveEnd] of values looks suspicious,
  // like an obvious missing optimization.
  void warnOnSuspiciousValues(Node* node, Index inclusiveStart, Index inclusiveEnd) {
    assert(debug);
    auto* first = node->getValue(inclusiveStart);
    bool allIdentical = true;
    // Check if any of the others are not equal
    for (Index i = inclusiveStart + 1; i <= inclusiveEnd; i++) {
      auto* curr = node->getValue(i);
      if (*first != *curr) {
        allIdentical = false;
        break;
      }
    }
    if (allIdentical) {
      std::cout << "^^ suspicious identical inputs! missing optimization in " << builder.func->name << "? ^^\n";
      return;
    }
    // If not all identical, warn on all-constant inputs to a non-phi, that's odd too.
    if (!node->isPhi()) {
      bool allConstant = true;
      for (Index i = inclusiveStart; i <= inclusiveEnd; i++) {
        auto* curr = node->getValue(i);
        if (!curr->isExpr() || !curr->expr->is<Const>()) {
          allConstant = false;
          break;
        }
      }
      if (allConstant) {
        std::cout << "^^ suspicious constant inputs! missing optimization in " << builder.func->name << "? ^^\n";
      }
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

