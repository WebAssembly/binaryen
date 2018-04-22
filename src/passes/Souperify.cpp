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
// Souperify - convert to Souper IR in text form.
//
// This needs 'flatten' to be run before it, as it assumes the IR is in
// flat form.
//
// See https://github.com/google/souper/issues/323
//

#include <string>

#include "wasm.h"
#include "pass.h"
#include "ir/find_all.h"
#include "ir/literal-utils.h"

namespace wasm {

// Simple IR for data flow computation for Souper.
// TODO: loops
// TODO: generalize for other things?

namespace DataFlow {

struct Node {
  enum Type {
    Var,   // an unknown variable number (not to be confused with var/param/local in wasm)
    Set,   // a register, defined by a SetLocal
    Const, // a constant value TODO: should this be just Zero?
    Phi,   // a phi from converging control flow
    Block, // a source of phis
    Bad    // something we can't handle and should ignore
  } type;

  Node(Type type) : type(type) {}

  template<Type expected>
  bool is() { return type == expected; }

  union {
    // For Var
    Index varIndex;
    // For Set
    SetLocal* set;
    // For Const
    Literal value;
    // For Phi
    Node* block;
    // For Block
    Index blockSize;
  };

  // For Phi (can't be in the union)
  std::unique_ptr<std::vector<Node*>> values;

  // Constructors
  static Node* makeVar(Index varIndex) {
    Node* ret = new Node(Var);
    ret->varIndex = varIndex;
    return ret;
  }
  static Node* makeSet(SetLocal* set) {
    Node* ret = new Node(Set);
    ret->set = set;
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
    ret->values = make_unique<std::vector<Node*>>();
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

  void addPhiValue(Node* value) {
    assert(type == Phi);
    (*values).push_back(value);
  }
  Node* getPhiValue(Index i) {
    assert(type == Phi);
    return (*values)[i];
  }
};

// Main logic to generate IR for a function. This is implemented as a
// visitor on the wasm, where visitors return a bool whether the node is
// supported (false === bad).
struct Builder : public Visitor<Builder, bool> {
  // Tracks the state of locals in a control flow path:
  //   localState[i] = the node whose value it contains
  typedef std::vector<Node*> LocalState;

  // The current local state in the control flow path being emitted.
  LocalState localState;

  // Connects a specific get to the data flowing into it.
  std::unordered_map<GetLocal*, Node*> getNodeMap;

  // Connects a specific set to the data in its value.
  std::unordered_map<SetLocal*, Node*> setNodeMap;

  // All the sets, in order of appearance.
  std::vector<SetLocal*> sets;

  // The function being processed.
  Function* func;

  // All of our nodes
  std::vector<std::unique_ptr<Node>> nodes;

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
    std::cout << "; function: " << func->name << '\n';
    // Set up initial local state IR.
    localState.resize(func->getNumLocals());
    for (Index i = 0; i < func->getNumLocals(); i++) {
      Node* node;
      if (func->isParam(i)) {
        node = Node::makeVar(i);
      } else {
        node = Node::makeConst(LiteralUtils::makeLiteralZero(func->getLocalType(i)));
      }
      addNode(node, i);
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

  // Add a new node, for a specific local index.
  Node* addNode(Node* node, Index index) {
    localState[index] = node;
    return addNode(node);
  }

  // Merge local state for multiple control flow paths
  // TODO: more than 2
  void merge(const LocalState& aState, const LocalState& bState, LocalState& out) {
    assert(out.size() == func->getNumLocals());
    // create a block only if necessary
    Node* block = nullptr;
    for (Index i = 0; i < func->getNumLocals(); i++) {
      auto a = aState[i];
      auto b = bState[i];
      if (a == b) {
        out[i] = a;
      } else {
        // We need to actually merge some stuff.
        if (!block) {
          block = addNode(Node::makeBlock(2));
        }
        auto* phi = addNode(Node::makePhi(block));
        phi->addPhiValue(a);
        phi->addPhiValue(b);
        out[i] = phi;
      }
    }
  }

  // Visitors.

  bool visitBlock(Block* curr) {
    // TODO: handle super-deep nesting
    // TODO: handle breaks to here
    for (auto* child : curr->list) {
      visit(child);
    }
    return true;
  }
  bool visitIf(If* curr) {
    // TODO: blockpc
    auto initialState = localState;
    visit(curr->ifTrue);
    auto afterIfTrueState = localState;
    if (curr->ifFalse) {
      localState = initialState;
      visit(curr->ifFalse);
      auto afterIfFalseState = localState; // TODO: optimize
      merge(afterIfTrueState, afterIfFalseState, localState);
    } else {
      merge(initialState, afterIfTrueState, localState);
    }
    return true;
  }
  bool visitLoop(Loop* curr) { return false; }
  bool visitBreak(Break* curr) { return false; }
  bool visitSwitch(Switch* curr) { return false; }
  bool visitCall(Call* curr) { return false; }
  bool visitCallImport(CallImport* curr) { return false; }
  bool visitCallIndirect(CallIndirect* curr) { return false; }
  bool visitGetLocal(GetLocal* curr) {
    // We now know which IR node this get refers to
    auto* node = localState[curr->index];
    getNodeMap[curr] = node;
    return !node->is<Node::Type::Bad>();
  }
  bool visitSetLocal(SetLocal* curr) {
    sets.push_back(curr);
    // If we are doing a copy, just do the copy.
    if (auto* get = curr->value->dynCast<GetLocal>()) {
      setNodeMap[curr] = localState[curr->index] = localState[get->index];
      return true;
    }
    // Make a new IR node for the new value here.
    if (visit(curr->value)) {
      setNodeMap[curr] = addNode(Node::makeSet(curr), curr->index);
      return true;
    } else {
      setNodeMap[curr] = addNode(Node::makeBad(), curr->index);
      return false;
    }
  }
  bool visitGetGlobal(GetGlobal* curr) {
    return false;
  }
  bool visitSetGlobal(SetGlobal* curr) {
    return false;
  }
  bool visitLoad(Load* curr) {
    return false;
  }
  bool visitStore(Store* curr) {
    return false;
  }
  bool visitAtomicRMW(AtomicRMW* curr) {
    return false;
  }
  bool visitAtomicCmpxchg(AtomicCmpxchg* curr) {
    return false;
  }
  bool visitAtomicWait(AtomicWait* curr) {
    return false;
  }
  bool visitAtomicWake(AtomicWake* curr) {
    return false;
  }
  bool visitConst(Const* curr) {
    return true;
  }
  bool visitUnary(Unary* curr) {
    return false;
  }
  bool visitBinary(Binary *curr) {
    return visit(curr->left) && visit(curr->right);
  }
  bool visitSelect(Select* curr) {
    return false;
  }
  bool visitDrop(Drop* curr) {
    return false;
  }
  bool visitReturn(Return* curr) {
    // note we don't need the value (it's a const or a get as we are flattened)
    return true;
  }
  bool visitHost(Host* curr) {
    return false;
  }
  bool visitNop(Nop* curr) {
    return true;
  }
  bool visitUnreachable(Unreachable* curr) {
    return false;
  }
};

// Generates a trace: all the information to generate a Souper LHS
// for a specific set whose value we want to infer.
struct Trace : public Visitor<Trace> {
  Builder& builder;
  SetLocal* set;

  bool bad = false;
  std::vector<Node*> nodes;
  std::unordered_set<Node*> addedNodes;

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
  }

  Node* add(Node* node) {
    switch (node->type) {
      case Node::Type::Var: {
        break; // nothing more to add
      }
      case Node::Type::Set: {
        // Add the dependencies.
        visit(node->set->value);
        break;
      }
      case Node::Type::Const: {
        break; // nothing more to add
      }
      case Node::Type::Phi: {
        auto* block = add(node->block);
        for (Index i = 0; i < block->blockSize; i++) {
          add(node->getPhiValue(i));
        }
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

  bool isBad() {
    return bad;
  }

  // Visitors for possible set_local values

  void visitGetLocal(GetLocal* curr) {
    add(builder.getNodeMap[curr]);
  }
  void visitConst(Const* curr) {
  }
  void visitBinary(Binary *curr) {
    visit(curr->left);
    visit(curr->right);
  }
};

// Emits a trace, which is basically a Souper LHS.
struct Printer : public Visitor<Printer> {
  Builder& builder;
  Trace& trace;

  // Each Node in a trace has an index, from 0.
  std::unordered_map<Node*, Index> indexing;

  Printer(Builder& builder, Trace& trace) : builder(builder), trace(trace) {
    std::cout << "\n; start LHS\n";
    // Index the nodes.
    for (auto* node : trace.nodes) {
      auto index = indexing.size();
      indexing[node] = index;
    }
    // Print them out.
    for (auto* node : trace.nodes) {
      print(node);
    }
    // Finish up
    std::cout << "infer %" << indexing[trace.nodes.back()] << '\n';
  }

  void print(Node* node) {
    switch (node->type) {
      case Node::Type::Var: {
        std::cout << "%" << indexing[node] << " = var";
        break; // nothing more to add
      }
      case Node::Type::Set: {
        std::cout << "%" << indexing[node] << " = ";
        visit(node->set->value);
        break;
      }
      case Node::Type::Const: {
        print(node->value);
        break;
      }
      case Node::Type::Phi: {
        auto* block = node->block;
        std::cout << "%" << indexing[node] << " = phi %" << indexing[block];
        for (Index i = 0; i < block->blockSize; i++) {
          std::cout << ", %" << indexing[node->getPhiValue(i)];
        }
        break;
      }
      case Node::Type::Block: {
        std::cout << "%" << indexing[node] << ' ' << node->blockSize;
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

  // Visitors for possible set_local values

  void visitGetLocal(GetLocal* curr) {
    std::cout << "%" << indexing[builder.getNodeMap[curr]];
  }
  void visitConst(Const* curr) {
    print(curr->value);
  }
  void visitBinary(Binary *curr) {
    switch (curr->op) {
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
      case GtSInt32:
      case GtSInt64:  std::cout << "sgt";  break;
      case GtUInt32:
      case GtUInt64:  std::cout << "ugt";  break;
      case GeSInt32:
      case GeSInt64:  std::cout << "sge";  break;
      case GeUInt32:
      case GeUInt64:  std::cout << "uge";  break;

      default: WASM_UNREACHABLE();
    }
    std::cout << ' ';
    visit(curr->left);
    std::cout << ", ";
    visit(curr->right);
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

