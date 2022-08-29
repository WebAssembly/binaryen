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

#ifndef wasm_dataflow_utils_h
#define wasm_dataflow_utils_h

#include "dataflow/graph.h"
#include "dataflow/node.h"
#include "wasm.h"

namespace wasm::DataFlow {

inline std::ostream& dump(Node* node, std::ostream& o, size_t indent = 0) {
  auto doIndent = [&]() { o << std::string(indent, ' '); };
  doIndent();
  o << '[' << node << ' ';
  switch (node->type) {
    case Node::Type::Var:
      o << "var " << node->wasmType << ' ' << node;
      break;
    case Node::Type::Expr: {
      o << "expr ";
      o << *node->expr << '\n';
      break;
    }
    case Node::Type::Phi:
      o << "phi " << node->index;
      break;
    case Node::Type::Cond:
      o << "cond " << node->index;
      break;
    case Node::Type::Block: {
      // don't print the conds - they would recurse
      o << "block (" << node->values.size() << " conds)]\n";
      return o;
    }
    case Node::Type::Zext:
      o << "zext";
      break;
    case Node::Type::Bad:
      o << "bad";
      break;
  }
  if (!node->values.empty()) {
    o << '\n';
    for (auto* value : node->values) {
      dump(value, o, indent + 1);
    }
    doIndent();
  }
  o << "] (origin: " << (void*)(node->origin) << ")\n";
  return o;
}

inline std::ostream& dump(Graph& graph, std::ostream& o) {
  for (auto& node : graph.nodes) {
    o << "NODE " << node.get() << ": ";
    dump(node.get(), o);
    if (auto* set = graph.getSet(node.get())) {
      o << "  and that is set to local " << set->index << '\n';
    }
  }
  return o;
}

// Checks if the inputs are all identical - something we could
// probably optimize. Returns false if irrelevant.
inline bool allInputsIdentical(Node* node) {
  switch (node->type) {
    case Node::Type::Expr: {
      if (node->expr->is<Binary>()) {
        return *(node->getValue(0)) == *(node->getValue(1));
      } else if (node->expr->is<Select>()) {
        return *(node->getValue(1)) == *(node->getValue(2));
      }
      break;
    }
    case Node::Type::Phi: {
      auto* first = node->getValue(1);
      // Check if any of the others are not equal
      for (Index i = 2; i < node->values.size(); i++) {
        auto* curr = node->getValue(i);
        if (*first != *curr) {
          return false;
        }
      }
      return true;
    }
    default: {}
  }
  return false;
}

// Checks if the inputs are all constant - something we could
// probably optimize. Returns false if irrelevant.
inline bool allInputsConstant(Node* node) {
  switch (node->type) {
    case Node::Type::Expr: {
      if (node->expr->is<Unary>()) {
        return node->getValue(0)->isConst();
      } else if (node->expr->is<Binary>()) {
        return node->getValue(0)->isConst() && node->getValue(1)->isConst();
      } else if (node->expr->is<Select>()) {
        return node->getValue(0)->isConst() && node->getValue(1)->isConst() &&
               node->getValue(2)->isConst();
      }
      break;
    }
    case Node::Type::Phi: {
      // Check if any of the others are not equal
      for (Index i = 1; i < node->values.size(); i++) {
        if (!node->getValue(i)->isConst()) {
          return false;
        }
      }
      return true;
    }
    default: {}
  }
  return false;
}

} // namespace wasm::DataFlow

#endif // wasm_dataflow_utils
