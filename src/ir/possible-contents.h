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

#include "ir/possible-constant.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

// Similar to PossibleConstantValues, but considers more types of contents.
// Specifically, this can also track types, making this a variant over:
//  * No possible value.
//  * One possible constant value.
//  * One possible type but the value of that type is not constant.
//  * "Many" - either multiple constant values for one type, or multiple types.
struct PossibleContents {
private:
  // No possible value.
  struct None : public std::monostate {};

  // Many possible values, and so this represents unknown data: we cannot infer
  // anything there.
  struct Many : public std::monostate {};

  struct ImmutableGlobal {
    Name name;
    Type type;
    bool operator==(const ImmutableGlobal& other) const {
      return name == other.name && type == other.type;
    }
  };

  using Variant = std::variant<None, Literal, ImmutableGlobal, Type, Many>;
  Variant value;

public:
  PossibleContents() : value(None()) {}
  PossibleContents(Variant value) : value(value) {}
  template<typename T> PossibleContents(T curr) : value(Variant(curr)) {}

  static PossibleContents many() { return PossibleContents(Variant(Many())); }

  bool operator==(const PossibleContents& other) const {
    return value == other.value;
  }

  // Notes the contents of an expression and update our internal knowledge based
  // on it and all previous values noted.
  void note(Expression* expr, Module& wasm) {
    // If this is a constant literal value, note that.
    if (Properties::isConstantExpression(expr)) {
      combine(Variant(Properties::getLiteral(expr)));
      return;
    }

    // If this is an immutable global that we get, note that.
    if (auto* get = expr->dynCast<GlobalGet>()) {
      auto* global = wasm.getGlobal(get->name);
      if (global->mutable_ == Immutable) {
        combine(Variant(ImmutableGlobal{get->name, global->type}));
        return;
      }
    }

    // Otherwise, note the type.
    // TODO: should we ignore unreachable here, or assume the caller has already
    //       run dce or otherwise handled that?
    combine(Variant(expr->type));
  }

  template<typename T> void note(T curr) { note(Variant(curr)); }

  // Notes a value that is unknown - it can be anything. We have failed to
  // identify a constant value here.
  void noteUnknown() { value = Many(); }

  // Combine the information in a given PossibleContents to this one. This
  // is the same as if we have called note*() on us with all the history of
  // calls to that other object.
  //
  // Returns whether we changed anything.
  bool combine(const PossibleContents& other) {
    if (std::get_if<None>(&other.value)) {
      return false;
    }

    if (std::get_if<None>(&value)) {
      value = other.value;
      return true;
    }

    if (std::get_if<Many>(&value)) {
      return false;
    }

    if (std::get_if<Many>(&other.value)) {
      value = Many();
      return true;
    }

    // Neither is None, and neither is Many.

    // TODO: do we need special null handling here?
    if (other.value == value) {
      return false;
    }

    // The values differ, but if they share the same type then we can set to
    // that.
    if (other.getType() == getType()) {
      if (std::get_if<Type>(&value)) {
        // We were already marked as an arbitrary value of this type.
        return false;
      }
      value = Type(getType());
      return true;
    }

    // TODO: lub of the different types? lub returns none for no possible lub,
    //       so we also do not need the Many state.

    // Worst case.
    value = Many();
    return true;
  }

  bool isNone() const { return std::get_if<None>(&value); }
  // Check if all the values are identical and constant.
  bool isConstant() const {
    return !std::get_if<None>(&value) && !std::get_if<Many>(&value) &&
           !std::get_if<Type>(&value);
  }
  bool isConstantLiteral() const { return std::get_if<Literal>(&value); }
  bool isConstantGlobal() const { return std::get_if<ImmutableGlobal>(&value); }
  bool isType() const { return std::get_if<Type>(&value); }
  bool isMany() const { return std::get_if<Many>(&value); }

  // Returns the single constant value.
  Literal getConstantLiteral() const {
    assert(isConstant());
    return std::get<Literal>(value);
  }

  Name getConstantGlobal() const {
    assert(isConstant());
    return std::get<ImmutableGlobal>(value).name;
  }

  // Return the types possible here. If no type is possible, returns
  // unreachable; if many types are, returns none.
  Type getType() const {
    if (auto* literal = std::get_if<Literal>(&value)) {
      return literal->type;
    } else if (auto* global = std::get_if<ImmutableGlobal>(&value)) {
      return global->type;
    } else if (auto* type = std::get_if<Type>(&value)) {
      return *type;
    } else if (std::get_if<None>(&value)) {
      return Type::unreachable;
    } else if (std::get_if<Many>(&value)) {
      return Type::none;
    } else {
      WASM_UNREACHABLE("bad value");
    }
  }

  // Assuming we have a single value, make an expression containing that value.
  Expression* makeExpression(Module& wasm) {
    Builder builder(wasm);
    if (isConstantLiteral()) {
      return builder.makeConstantExpression(getConstantLiteral());
    } else {
      auto name = getConstantGlobal();
      return builder.makeGlobalGet(name, wasm.getGlobal(name)->type);
    }
  }

  // Returns whether we have ever noted a value.
  bool hasNoted() const { return !std::get_if<None>(&value); }

  void dump(std::ostream& o) const {
    o << '[';
    if (!hasNoted()) {
      o << "unwritten";
    } else if (!isConstant()) {
      o << "unknown";
    } else if (isConstantLiteral()) {
      o << getConstantLiteral();
    } else if (isConstantGlobal()) {
      o << '$' << getConstantGlobal();
    }
    o << ']';
  }
};

// *Location structs describe particular locations where types can appear.

// The location of a specific expression, referring to the possible types
// it can contain (which may be more precise than expr->type).
struct ExpressionLocation {
  Expression* expr;
  // If this expression contains a tuple then each index in the tuple will have
  // its own location with a corresponding tupleIndex. If this is not a tuple
  // then we only use tupleIndex 0.
  Index tupleIndex;
  bool operator==(const ExpressionLocation& other) const {
    return expr == other.expr && tupleIndex == other.tupleIndex;
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
  // The index of the local.
  Index index;
  // As in ExpressionLocation, the index inside the tuple, or 0 if not a tuple.
  Index tupleIndex;
  bool operator==(const LocalLocation& other) const {
    return func == other.func && index == other.index &&
           tupleIndex == other.tupleIndex;
  }
};

// The location of a branch target in a function, identified by its name.
struct BranchLocation {
  Function* func;
  Name target;
  // As in ExpressionLocation, the index inside the tuple, or 0 if not a tuple.
  Index tupleIndex;
  bool operator==(const BranchLocation& other) const {
    return func == other.func && target == other.target &&
           tupleIndex == other.tupleIndex;
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

// The location of a struct field. Note that this is specific to this type - it
// does not include data about subtypes or supertypes.
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
  Index tupleIndex;
  bool operator==(const TagLocation& other) const {
    return tag == other.tag && tupleIndex == other.tupleIndex;
  }
};

// A null value. This is used as the location of the default value of a var in a
// function, a null written to a struct field in struct.new_with_default, etc.
struct NullLocation {
  Type type;
  bool operator==(const NullLocation& other) const {
    return type == other.type;
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
                              TagLocation,
                              NullLocation>;

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

} // namespace wasm

namespace std {

// Define hashes of all the *Location types so that Location itself is hashable
// and we can use it in unordered maps and sets.

template<> struct hash<wasm::ExpressionLocation> {
  size_t operator()(const wasm::ExpressionLocation& loc) const {
    return std::hash<std::pair<size_t, wasm::Index>>{}(
      {size_t(loc.expr), loc.tupleIndex});
  }
};

template<> struct hash<wasm::ResultLocation> {
  size_t operator()(const wasm::ResultLocation& loc) const {
    return std::hash<std::pair<size_t, wasm::Index>>{}(
      {size_t(loc.func), loc.index});
  }
};

template<> struct hash<wasm::LocalLocation> {
  size_t operator()(const wasm::LocalLocation& loc) const {
    return std::hash<std::pair<size_t, std::pair<wasm::Index, wasm::Index>>>{}(
      {size_t(loc.func), {loc.index, loc.tupleIndex}});
  }
};

template<> struct hash<wasm::BranchLocation> {
  size_t operator()(const wasm::BranchLocation& loc) const {
    return std::hash<std::pair<size_t, std::pair<wasm::Name, wasm::Index>>>{}(
      {size_t(loc.func), {loc.target, loc.tupleIndex}});
  }
};

template<> struct hash<wasm::GlobalLocation> {
  size_t operator()(const wasm::GlobalLocation& loc) const {
    return std::hash<wasm::Name>{}(loc.name);
  }
};

template<> struct hash<wasm::SignatureParamLocation> {
  size_t operator()(const wasm::SignatureParamLocation& loc) const {
    return std::hash<std::pair<wasm::HeapType, wasm::Index>>{}(
      {loc.type, loc.index});
  }
};

template<> struct hash<wasm::SignatureResultLocation> {
  size_t operator()(const wasm::SignatureResultLocation& loc) const {
    return std::hash<std::pair<wasm::HeapType, wasm::Index>>{}(
      {loc.type, loc.index});
  }
};

template<> struct hash<wasm::StructLocation> {
  size_t operator()(const wasm::StructLocation& loc) const {
    return std::hash<std::pair<wasm::HeapType, wasm::Index>>{}(
      {loc.type, loc.index});
  }
};

template<> struct hash<wasm::ArrayLocation> {
  size_t operator()(const wasm::ArrayLocation& loc) const {
    return std::hash<wasm::HeapType>{}(loc.type);
  }
};

template<> struct hash<wasm::TagLocation> {
  size_t operator()(const wasm::TagLocation& loc) const {
    return std::hash<std::pair<wasm::Name, wasm::Index>>{}(
      {loc.tag, loc.tupleIndex});
  }
};

template<> struct hash<wasm::NullLocation> {
  size_t operator()(const wasm::NullLocation& loc) const {
    return std::hash<wasm::Type>{}(loc.type);
  }
};

template<> struct hash<wasm::Connection> {
  size_t operator()(const wasm::Connection& loc) const {
    return std::hash<std::pair<wasm::Location, wasm::Location>>{}(
      {loc.from, loc.to});
  }
};

} // namespace std

namespace wasm {

// Analyze the entire wasm file to find which types are possible in which
// locations. This assumes a closed world and starts from struct.new/array.new
// instructions, and propagates them to the locations they reach. After the
// analysis the user of this class can ask which types are possible at any
// location.
//
// TODO: refactor into a separate file if other passes want it too.
class ContentOracle {
  Module& wasm;

  void analyze();

public:
  ContentOracle(Module& wasm) : wasm(wasm) { analyze(); }

  // Get the types possible at a location.
  PossibleContents getTypes(Location location) {
    auto iter = flowInfoMap.find(location);
    if (iter == flowInfoMap.end()) {
      return {};
    }
    return iter->second.types;
  }

private:
  // The information needed during and after flowing the types through the
  // graph. TODO: do not keep this around forever, delete the stuff we only need
  // during the flow after the flow.
  struct LocationInfo {
    // The types possible at this location.
    PossibleContents types;

    // The targets to which this sends types.
    std::vector<Location> targets;
  };

  std::unordered_map<Location, LocationInfo> flowInfoMap;
};

} // namespace wasm

#endif // wasm_ir_possible_types_h
