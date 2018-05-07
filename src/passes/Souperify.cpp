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
#include "ir/utils.h"
#include "dataflow/node.h"
#include "dataflow/graph.h"
#include "dataflow/utils.h"

namespace wasm {

namespace DataFlow {

// Generates a trace: all the information to generate a Souper LHS
// for a specific set_local whose value we want to infer.
struct Trace {
  Graph& graph;
  Node* toInfer;
  std::unordered_set<Node*>& exclude; // nodes we should exclude from traces

  // A limit on how deep we go - we don't want to create arbitrarily
  // large traces.
  size_t depthLimit = 10;
  size_t totalLimit = 30;

  bool bad = false;
  std::vector<Node*> nodes;
  std::unordered_set<Node*> addedNodes;
  std::vector<Node*> pathConditions;
  // When we need to (like when the depth is too deep), we replace
  // expressions with other expressions, and track them here.
  std::unordered_map<Node*, std::unique_ptr<Node>> replacements;

  Trace(Graph& graph, Node* toInfer, std::unordered_set<Node*>& exclude) : graph(graph), toInfer(toInfer), exclude(exclude) {
    // Check if there is a depth limit override
    auto* depthLimitStr = getenv("BINARYEN_SOUPERIFY_DEPTH_LIMIT");
    if (depthLimitStr) {
      depthLimit = atoi(depthLimitStr);
    }
    auto* totalLimitStr = getenv("BINARYEN_SOUPERIFY_TOTAL_LIMIT");
    if (totalLimitStr) {
      totalLimit = atoi(totalLimitStr);
    }
    // Pull in all the dependencies, starting from the value itself.
    add(toInfer, 0);
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
    auto iter = graph.nodeParentMap.find(toInfer);
    if (iter != graph.nodeParentMap.end()) {
      addPath(toInfer, iter->second);
    }
  }

  Node* add(Node* node, size_t depth) {
    depth++;
    // If replaced, return the replacement.
    auto iter = replacements.find(node);
    if (iter != replacements.end()) {
      return iter->second.get();
    }
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
        // Do the same if this is a node we should exclude from traces.
        if (depth >= depthLimit || nodes.size() >= totalLimit ||
            exclude.find(node) != exclude.end()) {
          auto type = node->getWasmType();
          assert(isConcreteType(type));
          auto* var = Node::makeVar(type);
          replacements[node] = std::unique_ptr<Node>(var);
          node = var;
          break;
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
        assert(block);
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

  void addPath(Node* node, Expression* curr) {
    // We track curr and parent, which are always in the state of parent
    // being the parent of curr.
    auto* parent = graph.expressionParentMap.at(curr);
    while (parent) {
      auto iter = graph.expressionConditionMap.find(parent);
      if (iter != graph.expressionConditionMap.end()) {
        // Given the block, add a proper path-condition
        addPathTo(parent, curr, iter->second);
      }
      curr = parent;
      parent = graph.expressionParentMap.at(parent);
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
  Graph& graph;
  Trace& trace;

  // Each Node in a trace has an index, from 0.
  std::unordered_map<Node*, Index> indexing;

  bool debug;

  Printer(Graph& graph, Trace& trace) : graph(graph), trace(trace) {
    debug = getenv("BINARYEN_DEBUG_SOUPERIFY") != nullptr;

    std::cout << "\n; start LHS (in " << graph.func->name << ")\n";
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
    std::cout << "infer %" << indexing[trace.toInfer] << "\n\n";
  }

  Node* getMaybeReplaced(Node* node) {
    auto iter = trace.replacements.find(node);
    if (iter != trace.replacements.end()) {
      return iter->second.get();
    }
    return node;
  }

  void print(Node* node) {
    // The node may have been replaced during trace building, if so then
    // print the proper replacement.
    node = getMaybeReplaced(node);
    assert(node);
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
        if (debug) warnOnSuspiciousValues(node);
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
    node = getMaybeReplaced(node);
    assert(node);
    if (node->isConst()) {
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
      if (debug) warnOnSuspiciousValues(node);
    } else if (curr->is<Select>()) {
      std::cout << "select ";
      printInternal(node->getValue(0));
      std::cout << ", ";
      printInternal(node->getValue(1));
      std::cout << ", ";
      printInternal(node->getValue(2));
      std::cout << '\n';
      if (debug) warnOnSuspiciousValues(node);
    } else {
      WASM_UNREACHABLE();
    }
  }

  void printPathCondition(Node* condition) {
    std::cout << "pc ";
    printInternal(condition);
    std::cout << " 1:i1\n";
  }

  // Checks if a value looks suspiciously optimizable.
  void warnOnSuspiciousValues(Node* node) {
    assert(debug);
    if (allInputsIdentical(node)) {
      std::cout << "^^ suspicious identical inputs! missing optimization in " << graph.func->name << "? ^^\n";
      return;
    }
    if (allInputsConstant(node)) {
      std::cout << "^^ suspicious constant inputs! missing optimization in " << graph.func->name << "? ^^\n";
      return;
    }
  }
};

} // namespace DataFlow

struct Souperify : public WalkerPass<PostWalker<Souperify>> {
  // Not parallel, for now - could parallelize and combine outputs at the end.
  // If Souper is thread-safe, we could also run it in parallel.

  bool singleUseOnly;

  Souperify(bool singleUseOnly) : singleUseOnly(singleUseOnly) {}

  void doWalkFunction(Function* func) {
    std::cout << "\n; function: " << func->name << '\n';
    // Build the data-flow IR.
    DataFlow::Graph graph;
    graph.build(func, getModule());
    // If we only want single-use nodes, exclude all the others.
    std::unordered_set<DataFlow::Node*> exclude;
    if (singleUseOnly) {
      std::unordered_map<DataFlow::Node*, Index> uses;
      for (auto& node : graph.nodes) {
        if (node->isExpr() && !graph.isArtificial(node.get())) {
          for (auto* value : node->values) {
            if (value->isExpr() && !value->isConst()) {
//std::cout << "add a use\n";
//dump(node.get(), std::cout);
//dump(value, std::cout);
              uses[value]++;
            }
          }
        }
      }
      for (auto& node : graph.nodes) {
        if (node->isExpr() && uses[node.get()] > 1) {
//std::cout << "dump " << uses[node.get()] << '\n';
//dump(node.get(), std::cout);
          exclude.insert(node.get());
        }
      }
    }
    // Emit possible traces.
    for (auto& node : graph.nodes) {
      if (!graph.isArtificial(node.get())) {
        DataFlow::Trace trace(graph, node.get(), exclude);
        if (!trace.isBad()) {
          DataFlow::Printer(graph, trace);
        }
      }
    }
  }
};

Pass *createSouperifyPass() {
  return new Souperify(false);
}

Pass *createSouperifySingleUsePass() {
  return new Souperify(true);
}

} // namespace wasm

