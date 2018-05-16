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

#ifndef wasm_dataflow_users_h
#define wasm_dataflow_users_h

#include "dataflow/graph.h"

namespace wasm {

namespace DataFlow {

// Calculates the users of each node.
//   users[x] = { y, z, .. }
// where y, z etc. are nodes that use x, that is, x is in their
// values vector.
class Users {
  typedef std::unordered_set<DataFlow::Node*> UserSet;

  std::unordered_map<DataFlow::Node*, UserSet> users;

  std::unordered_map<DataFlow::Node*, Index> numUses;

public:
  void build(Graph& graph) {
    for (auto& node : graph.nodes) {
      for (auto* value : node->values) {
        users[value].insert(node.get());
        numUses[value]++;
      }
    }
  }

  UserSet& getUsers(Node* node) {
    auto iter = users.find(node);
    if (iter == users.end()) {
      static UserSet empty;
      return empty;
    }
    return iter->second;
  }

  Index getNumUses(Node* node) {
    auto iter = numUses.find(node);
    if (iter == numUses.end()) return 0;
    return iter->second;
  }

  remove etc. utils - must alter numUses as well.
};

} // namespace DataFlow

} // namespace wasm

#endif // wasm_dataflow_users
