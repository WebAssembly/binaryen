/*
 * Copyright 2022 WebAssembly Community Group participants
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

#ifndef wasm_ir_possible_types_h
#define wasm_ir_possible_types_h

#include <variant>

#include "wasm.h"

namespace wasm::PossibleTypes {

// *Location structs describe particular locations where types can appear.

// The location of a specific expression, referring to the possible types
// it can contain (which may be more precise than expr->type).
struct ExpressionLocation {
  Expression* expr;
  bool operator==(const ExpressionLocation& other) const {
    return expr == other.expr;
  }
};

// The location of one of the results of a function.
struct ResultLocation {
  Function* func;
  Index index;
  bool operator==(const ResultLocation& other) const {
    return func == other.func && index == other.index;
  }
};

// The location of one of the locals in a function (either a parameter or a
// var). TODO: would separating params from vars help?
struct LocalLocation {
  Function* func;
  Index index;
  bool operator==(const LocalLocation& other) const {
    return func == other.func && index == other.index;
  }
};

// The location of a branch target in a function, identified by its name.
struct BranchLocation {
  Function* func;
  Name target;
  bool operator==(const BranchLocation& other) const {
    return func == other.func && target == other.target;
  }
};

// The location of a global in the module.
struct GlobalLocation {
  Name name;
  bool operator==(const GlobalLocation& other) const {
    return name == other.name;
  }
};

// The location of one of the parameters in a function signature.
struct SignatureParamLocation {
  HeapType type;
  Index index;
  bool operator==(const SignatureParamLocation& other) const {
    return type == other.type && index == other.index;
  }
};

struct SignatureResultLocation {
  HeapType type;
  Index index;
  bool operator==(const SignatureResultLocation& other) const {
    return type == other.type && index == other.index;
  }
};

// The location of a struct field. This represents a struct.get/set/new instr
// with a particular type. Due to subtyping, the struct.get/set may actually be
// operating on a subtype of that type, which the flow will need to take into
// account.
// TODO: we use this in both get/set and new. if we separate them we would get a
//       more precise analysis because struct.new does know the precise type
//       exactly.
struct StructLocation {
  HeapType type;
  Index index;
  bool operator==(const StructLocation& other) const {
    return type == other.type && index == other.index;
  }
};

// The location of an element in the array (without index - we consider them all
// as one, since we may not have static indexes for them all).
struct ArrayLocation {
  HeapType type;
  bool operator==(const ArrayLocation& other) const {
    return type == other.type;
  }
};

// The location of anything written to a particular index of a particular tag.
struct TagLocation {
  Name tag;
  Index index;
  bool operator==(const TagLocation& other) const {
    return tag == other.tag && index == other.index;
  }
};

// A location is a variant over all the possible types of locations that we
// have.
using Location = std::variant<ExpressionLocation,
                              ResultLocation,
                              LocalLocation,
                              BranchLocation,
                              GlobalLocation,
                              SignatureParamLocation,
                              SignatureResultLocation,
                              StructLocation,
                              ArrayLocation,
                              TagLocation>;

// A connection indicates a flow of types from one location to another. For
// example, if we do a local.get and return that value from a function, then
// we have a connection from a location of LocalTypes to a location of
// ResultTypes.
struct Connection {
  Location from;
  Location to;

  bool operator==(const Connection& other) const {
    return from == other.from && to == other.to;
  }
};

} // namespace wasm::PossibleTypes

namespace std {

// Define hashes of all the *Location types so that Location itself is hashable
// and we can use it in unordered maps and sets.

template<> struct hash<wasm::PossibleTypes::ExpressionLocation> {
  size_t operator()(const wasm::PossibleTypes::ExpressionLocation& loc) const {
    return std::hash<size_t>{}(size_t(loc.expr));
  }
};

template<> struct hash<wasm::PossibleTypes::ResultLocation> {
  size_t operator()(const wasm::PossibleTypes::ResultLocation& loc) const {
    return std::hash<std::pair<size_t, wasm::Index>>{}(
      {size_t(loc.func), loc.index});
  }
};

template<> struct hash<wasm::PossibleTypes::LocalLocation> {
  size_t operator()(const wasm::PossibleTypes::LocalLocation& loc) const {
    return std::hash<std::pair<size_t, wasm::Index>>{}(
      {size_t(loc.func), loc.index});
  }
};

template<> struct hash<wasm::PossibleTypes::BranchLocation> {
  size_t operator()(const wasm::PossibleTypes::BranchLocation& loc) const {
    return std::hash<std::pair<size_t, wasm::Name>>{}(
      {size_t(loc.func), loc.target});
  }
};

template<> struct hash<wasm::PossibleTypes::GlobalLocation> {
  size_t operator()(const wasm::PossibleTypes::GlobalLocation& loc) const {
    return std::hash<wasm::Name>{}(loc.name);
  }
};

template<> struct hash<wasm::PossibleTypes::SignatureParamLocation> {
  size_t
  operator()(const wasm::PossibleTypes::SignatureParamLocation& loc) const {
    return std::hash<std::pair<wasm::HeapType, wasm::Index>>{}(
      {loc.type, loc.index});
  }
};

template<> struct hash<wasm::PossibleTypes::SignatureResultLocation> {
  size_t
  operator()(const wasm::PossibleTypes::SignatureResultLocation& loc) const {
    return std::hash<std::pair<wasm::HeapType, wasm::Index>>{}(
      {loc.type, loc.index});
  }
};

template<> struct hash<wasm::PossibleTypes::StructLocation> {
  size_t operator()(const wasm::PossibleTypes::StructLocation& loc) const {
    return std::hash<std::pair<wasm::HeapType, wasm::Index>>{}(
      {loc.type, loc.index});
  }
};

template<> struct hash<wasm::PossibleTypes::ArrayLocation> {
  size_t operator()(const wasm::PossibleTypes::ArrayLocation& loc) const {
    return std::hash<wasm::HeapType>{}(loc.type);
  }
};

template<> struct hash<wasm::PossibleTypes::TagLocation> {
  size_t operator()(const wasm::PossibleTypes::TagLocation& loc) const {
    return std::hash<std::pair<wasm::Name, wasm::Index>>{}(
      {loc.tag, loc.index});
  }
};

template<> struct hash<wasm::PossibleTypes::Connection> {
  size_t operator()(const wasm::PossibleTypes::Connection& loc) const {
    return std::hash<std::pair<wasm::PossibleTypes::Location,
                               wasm::PossibleTypes::Location>>{}(
      {loc.from, loc.to});
  }
};

} // namespace std

namespace wasm::PossibleTypes {

// Analyze the entire wasm file to find which types are possible in which
// locations. This assumes a closed world and starts from struct.new/array.new
// instructions, and propagates them to the locations they reach. After the
// analysis the user of this class can ask which types are possible at any
// location.
//
// TODO: refactor into a separate file if other passes want it too.
class Oracle {
  Module& wasm;

  void analyze();

public:
  Oracle(Module& wasm) : wasm(wasm) { analyze(); }

  using TypeSet = std::unordered_set<HeapType>;

  // Get the types possible at a location.
  TypeSet getTypes(Location location) {
    auto iter = flowInfoMap.find(location);
    if (iter == flowInfoMap.end()) {
      return {};
    }
    return iter->second.types;
  }

private:
  // The information needed during and after flowing the types through the
  // graph.
  struct LocationInfo {
    // The types possible at this location.
    TypeSet types;

    // The targets to which this sends types.
    std::vector<Location> targets;
  };

  std::unordered_map<Location, LocationInfo> flowInfoMap;
};

} // namespace wasm::PossibleTypes

#endif // wasm_ir_possible_types_h
