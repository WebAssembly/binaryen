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

#include "dataflow/graph.h"
#include "dataflow/node.h"
#include "dataflow/utils.h"
#include "ir/flat.h"
#include "ir/local-graph.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

static int debug() {
  static char* str = getenv("BINARYEN_DEBUG_SOUPERIFY");
  static int ret = str ? atoi(str) : 0;
  return ret;
}

namespace DataFlow {

// Internal helper to find all the uses of a set.
struct UseFinder {
  // Gets a list of all the uses of an expression. As we are in flat IR,
  // the expression must be the value of a set, and we seek the other sets
  // (or rather, their values) that contain a get that uses that value.
  // There may also be non-set uses of the value, for example in a drop
  // or a return. We represent those with a nullptr, meaning "other".
  std::vector<Expression*>
  getUses(Expression* origin, Graph& graph, LocalGraph& localGraph) {
    if (debug() >= 2) {
      std::cout << "getUses\n" << origin << '\n';
    }
    std::vector<Expression*> ret;
    auto* set = graph.getSet(origin);
    if (!set) {
      // If the parent is not a set (a drop, call, return, etc.) then
      // it is not something we need to track.
      return ret;
    }
    addSetUses(set, graph, localGraph, ret);
    return ret;
  }

  // There may be loops of sets with copies between them.
  std::unordered_set<LocalSet*> seenSets;

  void addSetUses(LocalSet* set,
                  Graph& graph,
                  LocalGraph& localGraph,
                  std::vector<Expression*>& ret) {
    // If already handled, nothing to do here.
    if (!seenSets.emplace(set).second) {
      return;
    }
    // Find all the uses of that set.
    auto& gets = localGraph.getSetInfluences(set);
    if (debug() >= 2) {
      std::cout << "addSetUses for " << set << ", " << gets.size() << " gets\n";
    }
    for (auto* get : gets) {
      // Each of these relevant gets is either
      //  (1) a child of a set, which we can track, or
      //  (2) not a child of a set, e.g., a call argument or such
      auto& sets = localGraph.getGetInfluences(get); // TODO: iterator
      // In flat IR, each get can influence at most 1 set.
      assert(sets.size() <= 1);
      if (sets.size() == 0) {
        // This get is not the child of a set. Check if it is a drop,
        // otherwise it is an actual use, and so an external use.
        auto* parent = graph.getParent(get);
        if (parent && parent->is<Drop>()) {
          // Just ignore it.
        } else {
          ret.push_back(nullptr);
          if (debug() >= 2) {
            std::cout << "add nullptr\n";
          }
        }
      } else {
        // This get is the child of a set.
        auto* subSet = *sets.begin();
        // If this is a copy, we need to look through it: data-flow IR
        // counts actual values, not copies, and in particular we need
        // to look through the copies that implement a phi.
        if (subSet->value == get) {
          // Indeed a copy.
          // TODO: this could be optimized and done all at once beforehand.
          addSetUses(subSet, graph, localGraph, ret);
        } else {
          // Not a copy.
          auto* value = subSet->value;
          ret.push_back(value);
          if (debug() >= 2) {
            std::cout << "add a value\n" << value << '\n';
          }
        }
      }
    }
  }
};

// Generates a trace: all the information to generate a Souper LHS
// for a specific local.set whose value we want to infer.
struct Trace {
  Graph& graph;
  Node* toInfer;
  // Nodes we should exclude from being children of traces (but they
  // may be the root we try to infer.
  std::unordered_set<Node*>& excludeAsChildren;

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
  // The nodes that have additional external uses (only computed
  // for the "work" nodes, not the descriptive nodes arriving for
  // path conditions).
  std::unordered_set<Node*> hasExternalUses;
  // We add path conditions after the "work". We collect them here
  // and then go through them at the proper time.
  std::vector<Node*> conditionsToAdd;
  // Whether we are at the adding-conditions stage (i.e., post
  // adding the "work").
  bool addingConditions = false;
  // The local information graph. Used to check if a node has external uses.
  LocalGraph& localGraph;

  Trace(Graph& graph,
        Node* toInfer,
        std::unordered_set<Node*>& excludeAsChildren,
        LocalGraph& localGraph)
    : graph(graph), toInfer(toInfer), excludeAsChildren(excludeAsChildren),
      localGraph(localGraph) {
    if (debug() >= 2) {
      std::cout << "\nstart a trace (in " << graph.func->name << ")\n";
    }
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
    if (bad) {
      return;
    }
    // If we are trivial before adding pcs, we are still trivial, and
    // can ignore this.
    auto sizeBeforePathConditions = nodes.size();
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
    // Before adding the path conditions, we can now compute the
    // actual number of uses of "work" nodes, the real computation done
    // here and that we hope to replace, as opposed to path condition
    // computation which is only descriptive and helps optimization of
    // the work.
    findExternalUses();
    // We can now add conditions.
    addingConditions = true;
    for (auto* condition : conditionsToAdd) {
      add(condition, 0);
    }
    // Add in path conditions based on the location of this node: e.g.
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
            (node != toInfer &&
             excludeAsChildren.find(node) != excludeAsChildren.end())) {
          auto type = node->getWasmType();
          assert(type.isConcrete());
          auto* var = Node::makeVar(type);
          replacements[node] = std::unique_ptr<Node>(var);
          node = var;
          break;
        }
        // Add the dependencies.
        assert(!node->expr->is<LocalGet>());
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
            if (!addingConditions) {
              // Too early, queue it for later.
              conditionsToAdd.push_back(condition);
            } else {
              add(condition, depth);
            }
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
      default:
        WASM_UNREACHABLE("unexpected node type");
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
  void addPathTo(Expression* parent,
                 Expression* curr,
                 std::vector<Node*> conditions) {
    if (auto* iff = parent->dynCast<If>()) {
      Index index;
      if (curr == iff->ifTrue) {
        index = 0;
      } else if (curr == iff->ifFalse) {
        index = 1;
      } else {
        WASM_UNREACHABLE("invalid expr");
      }
      auto* condition = conditions[index];
      // Add the condition itself as an instruction in the trace -
      // the pc uses it as its input.
      add(condition, 0);
      // Add it as a pc, which we will emit directly.
      pathConditions.push_back(condition);
    } else {
      WASM_UNREACHABLE("invalid expr");
    }
  }

  bool isBad() { return bad; }

  static bool isTraceable(Node* node) {
    if (!node->origin) {
      // Ignore artificial etc. nodes.
      // TODO: perhaps require all the nodes for an origin appear, so we
      //       don't try to compute an internal part of one, like the
      //       extra artificial != 0 of a select?
      return false;
    }
    if (node->isExpr()) {
      // Consider only the simple computational nodes.
      auto* expr = node->expr;
      return expr->is<Unary>() || expr->is<Binary>() || expr->is<Select>();
    }
    return false;
  }

  void findExternalUses() {
    // Find all the wasm code represented in this trace.
    std::unordered_set<Expression*> origins;
    for (auto& node : nodes) {
      if (auto* origin = node->origin) {
        if (debug() >= 2) {
          std::cout << "note origin " << origin << '\n';
        }
        origins.insert(origin);
      }
    }
    for (auto& node : nodes) {
      if (node == toInfer) {
        continue;
      }
      if (auto* origin = node->origin) {
        auto uses = UseFinder().getUses(origin, graph, localGraph);
        for (auto* use : uses) {
          // A non-set use (a drop or return etc.) is definitely external.
          // Otherwise, check if internal or external.
          if (use == nullptr || origins.count(use) == 0) {
            if (debug() >= 2) {
              std::cout << "found external use for\n";
              dump(node, std::cout);
              std::cout << "  due to " << use << '\n';
            }
            hasExternalUses.insert(node);
            break;
          }
        }
      }
    }
  }
};

// Emits a trace, which is basically a Souper LHS.
struct Printer {
  Graph& graph;
  Trace& trace;

  // Each Node in a trace has an index, from 0.
  std::unordered_map<Node*, Index> indexing;

  bool printedHasExternalUses = false;

  Printer(Graph& graph, Trace& trace) : graph(graph), trace(trace) {
    std::cout << "\n; start LHS (in " << graph.func->name << ")\n";
    // Index the nodes.
    for (auto* node : trace.nodes) {
      // pcs and blockpcs are not instructions and do not need to be indexed
      if (!node->isCond()) {
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
        std::cout << "%" << indexing[node] << ":" << node->wasmType << " = var";
        break; // nothing more to add
      }
      case Node::Type::Expr: {
        if (debug()) {
          std::cout << "; ";
          std::cout << *node->expr << '\n';
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
        break;
      }
      case Node::Type::Cond: {
        std::cout << "blockpc %" << indexing[node->getValue(0)] << ' '
                  << node->index << ' ';
        printInternal(node->getValue(1));
        std::cout << " 1:i1";
        break;
      }
      case Node::Type::Block: {
        std::cout << "%" << indexing[node] << " = block "
                  << node->values.size();
        break;
      }
      case Node::Type::Zext: {
        auto* child = node->getValue(0);
        std::cout << "%" << indexing[node] << ':' << child->getWasmType();
        std::cout << " = zext ";
        printInternal(child);
        break;
      }
      case Node::Type::Bad: {
        WASM_UNREACHABLE("!!!BAD!!!");
      }
      default:
        WASM_UNREACHABLE("unexpted type");
    }
    if (node->isExpr() || node->isPhi()) {
      if (node->origin != trace.toInfer->origin &&
          trace.hasExternalUses.count(node) > 0) {
        std::cout << " (hasExternalUses)";
        printedHasExternalUses = true;
      }
    }
    std::cout << '\n';
    if (debug() && (node->isExpr() || node->isPhi())) {
      warnOnSuspiciousValues(node);
    }
  }

  void print(Literal value) {
    std::cout << value.getInteger() << ':' << value.type;
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
    } else if (auto* unary = curr->dynCast<Unary>()) {
      switch (unary->op) {
        case ClzInt32:
        case ClzInt64:
          std::cout << "ctlz";
          break;
        case CtzInt32:
        case CtzInt64:
          std::cout << "cttz";
          break;
        case PopcntInt32:
        case PopcntInt64:
          std::cout << "ctpop";
          break;
        default:
          WASM_UNREACHABLE("invalid op");
      }
      std::cout << ' ';
      auto* value = node->getValue(0);
      printInternal(value);
    } else if (auto* binary = curr->dynCast<Binary>()) {
      switch (binary->op) {
        case AddInt32:
        case AddInt64:
          std::cout << "add";
          break;
        case SubInt32:
        case SubInt64:
          std::cout << "sub";
          break;
        case MulInt32:
        case MulInt64:
          std::cout << "mul";
          break;
        case DivSInt32:
        case DivSInt64:
          std::cout << "sdiv";
          break;
        case DivUInt32:
        case DivUInt64:
          std::cout << "udiv";
          break;
        case RemSInt32:
        case RemSInt64:
          std::cout << "srem";
          break;
        case RemUInt32:
        case RemUInt64:
          std::cout << "urem";
          break;
        case AndInt32:
        case AndInt64:
          std::cout << "and";
          break;
        case OrInt32:
        case OrInt64:
          std::cout << "or";
          break;
        case XorInt32:
        case XorInt64:
          std::cout << "xor";
          break;
        case ShlInt32:
        case ShlInt64:
          std::cout << "shl";
          break;
        case ShrUInt32:
        case ShrUInt64:
          std::cout << "lshr";
          break;
        case ShrSInt32:
        case ShrSInt64:
          std::cout << "ashr";
          break;
        case RotLInt32:
        case RotLInt64:
          std::cout << "rotl";
          break;
        case RotRInt32:
        case RotRInt64:
          std::cout << "rotr";
          break;
        case EqInt32:
        case EqInt64:
          std::cout << "eq";
          break;
        case NeInt32:
        case NeInt64:
          std::cout << "ne";
          break;
        case LtSInt32:
        case LtSInt64:
          std::cout << "slt";
          break;
        case LtUInt32:
        case LtUInt64:
          std::cout << "ult";
          break;
        case LeSInt32:
        case LeSInt64:
          std::cout << "sle";
          break;
        case LeUInt32:
        case LeUInt64:
          std::cout << "ule";
          break;
        default:
          WASM_UNREACHABLE("invalid op");
      }
      std::cout << ' ';
      auto* left = node->getValue(0);
      printInternal(left);
      std::cout << ", ";
      auto* right = node->getValue(1);
      printInternal(right);
    } else if (curr->is<Select>()) {
      std::cout << "select ";
      printInternal(node->getValue(0));
      std::cout << ", ";
      printInternal(node->getValue(1));
      std::cout << ", ";
      printInternal(node->getValue(2));
    } else {
      WASM_UNREACHABLE("unexecpted node type");
    }
  }

  void printPathCondition(Node* condition) {
    std::cout << "pc ";
    printInternal(condition);
    std::cout << " 1:i1\n";
  }

  // Checks if a value looks suspiciously optimizable.
  void warnOnSuspiciousValues(Node* node) {
    assert(debug());
    // If the node has no uses, it's not interesting enough to be
    // suspicious. TODO
    // If an input was replaced with a var, then we should not
    // look into it, it's not suspiciously trivial.
    for (auto* value : node->values) {
      if (value != getMaybeReplaced(value)) {
        return;
      }
    }
    if (allInputsIdentical(node)) {
      std::cout << "^^ suspicious identical inputs! missing optimization in "
                << graph.func->name << "? ^^\n";
      return;
    }
    if (!node->isPhi() && allInputsConstant(node)) {
      std::cout << "^^ suspicious constant inputs! missing optimization in "
                << graph.func->name << "? ^^\n";
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
    Flat::verifyFlatness(func);
    // Build the data-flow IR.
    DataFlow::Graph graph;
    graph.build(func, getModule());
    if (debug() >= 2) {
      dump(graph, std::cout);
    }
    // Build the local graph data structure.
    LocalGraph localGraph(func);
    localGraph.computeInfluences();
    // If we only want single-use nodes, exclude all the others.
    std::unordered_set<DataFlow::Node*> excludeAsChildren;
    if (singleUseOnly) {
      for (auto& nodePtr : graph.nodes) {
        auto* node = nodePtr.get();
        if (node->origin) {
          // TODO: work for identical origins could be saved
          auto uses =
            DataFlow::UseFinder().getUses(node->origin, graph, localGraph);
          if (debug() >= 2) {
            std::cout << "following node has " << uses.size() << " uses\n";
            dump(node, std::cout);
          }
          if (uses.size() > 1) {
            excludeAsChildren.insert(node);
          }
        }
      }
    }
    // Emit possible traces.
    for (auto& nodePtr : graph.nodes) {
      auto* node = nodePtr.get();
      // Trace
      if (DataFlow::Trace::isTraceable(node)) {
        DataFlow::Trace trace(graph, node, excludeAsChildren, localGraph);
        if (!trace.isBad()) {
          DataFlow::Printer printer(graph, trace);
          if (singleUseOnly) {
            assert(!printer.printedHasExternalUses);
          }
        }
      }
    }
  }
};

Pass* createSouperifyPass() { return new Souperify(false); }

Pass* createSouperifySingleUsePass() { return new Souperify(true); }

} // namespace wasm
