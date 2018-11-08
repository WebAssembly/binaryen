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

#ifndef wasm_dataflow_graph_h
#define wasm_dataflow_graph_h

#include "wasm.h"
#include "ir/abstract.h"
#include "ir/iteration.h"
#include "ir/literal-utils.h"
#include "dataflow/node.h"

namespace wasm {

namespace DataFlow {

// Main logic to generate IR for a function. This is implemented as a
// visitor on the wasm, where visitors return a Node* that either
// contains the DataFlow IR for that expression, which can be a
// Bad node if not supported, or nullptr if not relevant (we only
// use the return value for internal expressions, that is, the
// value of a set_local or the condition of an if etc).
struct Graph : public UnifiedExpressionVisitor<Graph, Node*> {
  // We only need one canonical bad node. It is never modified.
  Node bad = Node(Node::Type::Bad);

  // Connects a specific set to the data in its value.
  std::unordered_map<SetLocal*, Node*> setNodeMap;

  // Maps a control-flow expression to the conditions for it. Currently,
  // this maps an if to the conditions for its arms
  std::unordered_map<Expression*, std::vector<Node*>> expressionConditionMap;

  // Maps each expression to its control-flow parent (or null if
  // there is none). We only map expressions we need to know about,
  // which are sets, set values, and control-flow constructs.
  std::unordered_map<Expression*, Expression*> expressionParentMap;

  // The same, for nodes. Note that we currently don't know the parents
  // of nodes like phis that don't exist in wasm - we need to add more
  // stuff to handle that. But we will know the parent of anything using
  // that phi and storing to a local, which is probably enough anyhow
  // for pc generation.
  std::unordered_map<Node*, Expression*> nodeParentMap;

  // All the sets, in order of appearance.
  std::vector<SetLocal*> sets;

  // The function being processed.
  Function* func;

  // The module we are working in.
  Module* module;

  // All of our nodes
  std::vector<std::unique_ptr<Node>> nodes;

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
    Locals locals;
    Node* condition;
    FlowState(Locals locals, Node* condition) : locals(locals), condition(condition) {}
  };

  // API

  void build(Function* funcInit, Module* moduleInit) {
    func = funcInit;
    module = moduleInit;

    auto numLocals = func->getNumLocals();
    if (numLocals == 0) return; // nothing to do
    // Set up initial local state IR.
    setInReachable();
    for (Index i = 0; i < numLocals; i++) {
      if (!isRelevantType(func->getLocalType(i))) continue;
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
      return &bad;
    }
  }

  // We create one node per constant value
  std::unordered_map<Literal, Node*> constantNodes;

  Node* makeConst(Literal value) {
    auto iter = constantNodes.find(value);
    if (iter!= constantNodes.end()) {
      return iter->second;
    }
    // Create one for this literal.
    Builder builder(*module);
    auto* c = builder.makeConst(value);
    auto* ret = addNode(Node::makeExpr(c, c));
    constantNodes[value] = ret;
    return ret;
  }

  Node* makeZero(wasm::Type type) {
    return makeConst(LiteralUtils::makeLiteralZero(type));
  }

  // Add a new node to our list of owned nodes.
  Node* addNode(Node* node) {
    nodes.push_back(std::unique_ptr<Node>(node));
    return node;
  }

  Node* makeZeroComp(Node* node, bool equal, Expression* origin) {
    assert(!node->isBad());
    Builder builder(*module);
    auto type = node->getWasmType();
    if (!isConcreteType(type)) return &bad;
    auto* zero = makeZero(type);
    auto* expr = builder.makeBinary(
      Abstract::getBinary(type, equal ? Abstract::Eq : Abstract::Ne),
      makeUse(node),
      makeUse(zero)
    );
    auto* check = addNode(Node::makeExpr(expr, origin));
    check->addValue(expandFromI1(node, origin));
    check->addValue(zero);
    return check;
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

  // Visiting.

  Node* visitExpression(Expression* curr) {
    // Control flow and get/set etc. are special. Aside from them, we just need
    // to do something very generic.
    if (auto* block = curr->dynCast<Block>()) {
      return doVisitBlock(block);
    } else if (auto* iff = curr->dynCast<If>()) {
      return doVisitIf(iff);
    } else if (auto* loop = curr->dynCast<Loop>()) {
      return doVisitLoop(loop);
    } else if (auto* get = curr->dynCast<GetLocal>()) {
      return doVisitGetLocal(get);
    } else if (auto* set = curr->dynCast<SetLocal>()) {
      return doVisitSetLocal(set);
    } else if (auto* br = curr->dynCast<Break>()) {
      return doVisitBreak(br);
    } else if (auto* sw = curr->dynCast<Switch>()) {
      return doVisitSwitch(sw);
    } else if (auto* c = curr->dynCast<Const>()) {
      return doVisitConst(c);
    } else if (auto* unary = curr->dynCast<Unary>()) {
      return doVisitUnary(unary);
    } else if (auto* binary = curr->dynCast<Binary>()) {
      return doVisitBinary(binary);
    } else if (auto* select = curr->dynCast<Select>()) {
      return doVisitSelect(select);
    } else if (auto* unreachable = curr->dynCast<Unreachable>()) {
      return doVisitUnreachable(unreachable);
    } else if (auto* drop = curr->dynCast<Drop>()) {
      return doVisitDrop(drop);
    } else {
      return doVisitGeneric(curr);
    }
  }

  Node* doVisitBlock(Block* curr) {
    // TODO: handle super-deep nesting
    auto* oldParent = parent;
    expressionParentMap[curr] = oldParent;
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
        if (!isInUnreachable()) {
          states.push_back(locals);
        }
        mergeBlock(states, locals);
      }
    }
    parent = oldParent;
    return &bad;
  }
  Node* doVisitIf(If* curr) {
    auto* oldParent = parent;
    expressionParentMap[curr] = oldParent;
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
    return &bad;
  }
  Node* doVisitLoop(Loop* curr) {
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
    if (isInUnreachable()) {
      return &bad; // none of this matters
    }
    if (!curr->name.is()) {
      visit(curr->body);
      return &bad; // no phis are possible
    }
    auto previous = locals;
    auto numLocals = func->getNumLocals();
    for (Index i = 0; i < numLocals; i++) {
      locals[i] = makeVar(func->getLocalType(i));
    }
    auto vars = locals; // all the Vars we just created
    // We may need to replace values later - only new nodes added from
    // here are relevant.
    auto firstNodeFromLoop = nodes.size();
    // Process the loop body.
    visit(curr->body);
    // Find all incoming paths.
    auto& breaks = breakStates[curr->name];
    // Phis are possible, check for them.
    for (Index i = 0; i < numLocals; i++) {
      if (!isRelevantType(func->getLocalType(i))) continue;
      bool needPhi = false;
      // We replaced the proper value with a Var. If it's still that
      // Var - or it's the original proper value, which can happen with
      // constants - on all incoming paths, then a phi is not needed.
      auto* var = vars[i];
      auto* proper = previous[i];
      for (auto& other : breaks) {
        assert(!isInUnreachable(other));
        auto& curr = *(other[i]);
        if (curr != *var && curr != *proper) {
          // A phi would be necessary here.
          needPhi = true;
          break;
        }
      }
      if (needPhi) {
        // Nothing to do - leave the Vars, the loop phis are
        // unknown values to us.
      } else {
        // Undo the Var for this local: In every new node added for
        // the loop body, replace references to the Var with the
        // previous value (the value that is all we need instead of a phi).
        for (auto j = firstNodeFromLoop; j < nodes.size(); j++) {
          for (auto*& value : nodes[j].get()->values) {
            if (value == var) {
              value = proper;
            }
          }
        }
        // Also undo in the current local state, which is flowing out
        // of the loop.
        for (auto*& node : locals) {
          if (node == var) {
            node = proper;
          }
        }
      }
    }
    return &bad;
  }
  Node* doVisitBreak(Break* curr) {
    if (!isInUnreachable()) {
      breakStates[curr->name].push_back(locals);
    }
    if (!curr->condition) {
      setInUnreachable();
    } else {
      visit(curr->condition);
    }
    return &bad;
  }
  Node* doVisitSwitch(Switch* curr) {
    visit(curr->condition);
    if (!isInUnreachable()) {
      std::unordered_set<Name> targets;
      for (auto target : curr->targets) {
        targets.insert(target);
      }
      targets.insert(curr->default_);
      for (auto target : targets) {
        breakStates[target].push_back(locals);
      }
    }
    setInUnreachable();
    return &bad;
  }
  Node* doVisitGetLocal(GetLocal* curr) {
    if (!isRelevantLocal(curr->index) || isInUnreachable()) {
      return &bad;
    }
    // We now know which IR node this get refers to
    auto* node = locals[curr->index];
    return node;
  }
  Node* doVisitSetLocal(SetLocal* curr) {
    if (!isRelevantLocal(curr->index) || isInUnreachable()) {
      return &bad;
    }
    assert(isConcreteType(curr->value->type));
    sets.push_back(curr);
    expressionParentMap[curr] = parent;
    expressionParentMap[curr->value] = curr;
    // Set the current node in the local state.
    auto* node = visit(curr->value);
    locals[curr->index] = setNodeMap[curr] = node;
    // If we created a new node (and not just did a get of a set, which
    // passes around an existing node), mark its parent.
    if (nodeParentMap.find(node) == nodeParentMap.end()) {
      nodeParentMap[node] = curr;
    }
    return &bad;
  }
  Node* doVisitConst(Const* curr) {
    return makeConst(curr->value);
  }
  Node* doVisitUnary(Unary* curr) {
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
        auto* value = expandFromI1(visit(curr->value), curr);
        if (value->isBad()) return value;
        // Great, we are supported!
        auto* ret = addNode(Node::makeExpr(curr, curr));
        ret->addValue(value);
        return ret;
      }
      case EqZInt32:
      case EqZInt64: {
        // These can be implemented using a binary.
        // Check if our child is supported.
        auto* value = expandFromI1(visit(curr->value), curr);
        if (value->isBad()) return value;
        // Great, we are supported!
        return makeZeroComp(value, true, curr);
      }
      default: {
        // Anything else is an unknown value.
        return makeVar(curr->type);
      }
    }
  }
  Node* doVisitBinary(Binary *curr) {
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
        auto* left = expandFromI1(visit(curr->left), curr);
        if (left->isBad()) return left;
        auto* right = expandFromI1(visit(curr->right), curr);
        if (right->isBad()) return right;
        // Great, we are supported!
        auto* ret = addNode(Node::makeExpr(curr, curr));
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
        Builder builder(*module);
        BinaryOp opposite;
        switch (curr->op) {
          case GtSInt32: opposite = LtSInt32; break;
          case GtSInt64: opposite = LtSInt64; break;
          case GeSInt32: opposite = LeSInt32; break;
          case GeSInt64: opposite = LeSInt64; break;
          case GtUInt32: opposite = LtUInt32; break;
          case GtUInt64: opposite = LtUInt64; break;
          case GeUInt32: opposite = LeUInt32; break;
          case GeUInt64: opposite = LeUInt64; break;
          default: WASM_UNREACHABLE();
        }
        auto* ret = visitBinary(builder.makeBinary(opposite, curr->right, curr->left));
        // We just created a new binary node, but we need to set the origin properly
        // to the original.
        ret->origin = curr;
        return ret;
      }
      default: {
        // Anything else is an unknown value.
        return makeVar(curr->type);
      }
    }
  }
  Node* doVisitSelect(Select* curr) {
    auto* ifTrue = expandFromI1(visit(curr->ifTrue), curr);
    if (ifTrue->isBad()) return ifTrue;
    auto* ifFalse = expandFromI1(visit(curr->ifFalse), curr);
    if (ifFalse->isBad()) return ifFalse;
    auto* condition = ensureI1(visit(curr->condition), curr);
    if (condition->isBad()) return condition;
    // Great, we are supported!
    auto* ret = addNode(Node::makeExpr(curr, curr));
    ret->addValue(condition);
    ret->addValue(ifTrue);
    ret->addValue(ifFalse);
    return ret;
  }
  Node* doVisitUnreachable(Unreachable* curr) {
    setInUnreachable();
    return &bad;
  }
  Node* doVisitDrop(Drop* curr) {
    visit(curr->value);
    // We need to know that the value's parent is a drop, indicating
    // the value is not actually used here.
    expressionParentMap[curr->value] = curr;
    return &bad;
  }
  Node* doVisitGeneric(Expression* curr) {
    // Just need to visit the nodes so we note all the gets
    for (auto* child : ChildIterator(curr)) {
      visit(child);
    }
    return makeVar(curr->type);
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
      ifTrue = ensureI1(condition, nullptr);
      conditions.push_back(ifTrue);
      ifFalse = makeZeroComp(condition, true, nullptr);
      conditions.push_back(ifFalse);
    } else {
      ifTrue = ifFalse = &bad;
    }
    // Finally, merge the state with that block. TODO optimize
    std::vector<FlowState> states;
    if (!isInUnreachable(aState)) {
      states.emplace_back(aState, ifTrue);
    }
    if (!isInUnreachable(bState)) {
      states.emplace_back(bState, ifFalse);
    }
    merge(states, out);
  }

  // Merge local state for a block
  void mergeBlock(std::vector<Locals>& localses, Locals& out) {
    // TODO: conditions
    std::vector<FlowState> states;
    for (auto& locals : localses) {
      states.emplace_back(locals, &bad);
    }
    merge(states, out);
  }

  // Merge local state for multiple control flow paths, creating phis as needed.
  void merge(std::vector<FlowState>& states, Locals& out) {
    // We should only receive reachable states.
    for (auto& state : states) {
      assert(!isInUnreachable(state.locals));
    }
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
    Index numLocals = func->getNumLocals();
    Node* block = nullptr;
    for (Index i = 0; i < numLocals; i++) {
      if (!isRelevantType(func->getLocalType(i))) continue;
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
          auto* phi = addNode(Node::makePhi(block, i));
          for (auto& state : states) {
            auto* value = expandFromI1(state.locals[i], nullptr);
            phi->addValue(value);
          }
          out[i] = phi;
          break;
        }
      }
    }
  }

  // If the node returns an i1, then we are called from a context that needs
  // to use it normally as in wasm - extend it
  Node* expandFromI1(Node* node, Expression* origin) {
    if (!node->isBad() && node->returnsI1()) {
      node = addNode(Node::makeZext(node, origin));
    }
    return node;
  }

  Node* ensureI1(Node* node, Expression* origin) {
    if (!node->isBad() && !node->returnsI1()) {
      node = makeZeroComp(node, false, origin);
    }
    return node;
  }

  // Given a node representing something that is set_local'd, return
  // the set.
  SetLocal* getSet(Node* node) {
    auto iter = nodeParentMap.find(node);
    if (iter == nodeParentMap.end()) return nullptr;
    return iter->second->dynCast<SetLocal>();
  }

  // Given an expression, return the parent if such exists.
  Expression* getParent(Expression* curr) {
    auto iter = expressionParentMap.find(curr);
    if (iter == expressionParentMap.end()) return nullptr;
    return iter->second;
  }

  // Given an expression, return the set for it if such exists.
  SetLocal* getSet(Expression* curr) {
    auto* parent = getParent(curr);
    return parent ? parent->dynCast<SetLocal>() : nullptr;
  }

  // Creates an expression that uses a node. Generally, a node represents
  // a value in a local, so we create a get_local for it.
  Expression* makeUse(Node* node) {
    Builder builder(*module);
    if (node->isPhi()) {
      // The index is the wasm local that we assign to when implementing
      // the phi; get from there.
      auto index = node->index;
      return builder.makeGetLocal(index, func->getLocalType(index));
    } else if (node->isConst()) {
      return builder.makeConst(node->expr->cast<Const>()->value);
    } else if (node->isExpr()) {
      // Find the set we are a value of.
      auto index = getSet(node)->index;
      return builder.makeGetLocal(index, func->getLocalType(index));
    } else if (node->isZext()) {
      // i1 zexts are a no-op for wasm
      return makeUse(node->values[0]);
    } else if (node->isVar()) {
      // Nothing valid for us to read here. Emit a call, representing an unknown
      // variable value.
      return Builder(*module).makeCall(FAKE_CALL, {}, node->wasmType);
    } else {
      WASM_UNREACHABLE(); // TODO
    }
  }

  const Name FAKE_CALL = "fake$dfo$call";
};

} // namespace DataFlow

} // namespace wasm

#endif // wasm_dataflow_graph_h
