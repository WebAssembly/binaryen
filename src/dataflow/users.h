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

namespace wasm::DataFlow {

// Calculates the users of each node.
//   users[x] = { y, z, .. }
// where y, z etc. are nodes that use x, that is, x is in their
// values vector.
class Users {
  using UserSet = std::unordered_set<DataFlow::Node*>;

  std::unordered_map<DataFlow::Node*, UserSet> users;

public:
  void build(Graph& graph) {
    for (auto& node : graph.nodes) {
      for (auto* value : node->values) {
        users[value].insert(node.get());
      }
    }
  }

  UserSet& getUsers(Node* node) {
    auto iter = users.find(node);
    if (iter == users.end()) {
      static UserSet empty; // FIXME thread_local?
      return empty;
    }
    return iter->second;
  }

  Index getNumUses(Node* node) {
    auto& users = getUsers(node);
    // A user may have more than one use
    Index numUses = 0;
    for (auto* user : users) {
#ifndef NDEBUG
      bool found = false;
#endif
      for (auto* value : user->values) {
        if (value == node) {
          numUses++;
#ifndef NDEBUG
          found = true;
#endif
        }
      }
      assert(found);
    }
    return numUses;
  }

  // Stops using all the values of this node. Called when a node is being
  // removed.
  void stopUsingValues(Node* node) {
    for (auto* value : node->values) {
      auto& users = getUsers(value);
      users.erase(node);
    }
  }

  // Adds a new user to a node. Called when we add or change a value of a node.
  void addUser(Node* node, Node* newUser) { users[node].insert(newUser); }

  // Remove all uses of a node. Called when a node is being removed.
  void removeAllUsesOf(Node* node) { users.erase(node); }
};

} // namespace wasm::DataFlow

#endif // wasm_dataflow_users
