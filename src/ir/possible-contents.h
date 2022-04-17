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
#include "ir/subtypes.h"
#include "support/unique_deferring_queue.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

// Similar to PossibleConstantValues, but considers more types of contents.
// Specifically, this can also track types, making this a variant over:
//  * "None": No possible value.
//  * Exactly one possible constant value.
//  * "ExactType": Exactly one possible type (but the value of that type is not
//  constant).
//    This is an *exact* type as regards the heap type: this type and no subtype
//    (if subtypes are possible here than we will be in the "Many" state). As
//    regards nullability, if this is nullable then the value may be null.
//    * TODO: add ConeType, which would include subtypes (but may still be more
//            refined than the type declared in the IR)
//  * "Many" - either multiple constant values for one type, or multiple types.
struct PossibleContents {
public:
  struct ImmutableGlobal {
    Name name;
    Type type;
    bool operator==(const ImmutableGlobal& other) const {
      return name == other.name && type == other.type;
    }
  };

private:
  // No possible value.
  struct None : public std::monostate {};

  // Many possible values, and so this represents unknown data: we cannot infer
  // anything there.
  struct Many : public std::monostate {};

  using Variant = std::variant<None, Literal, ImmutableGlobal, Type, Many>;
  Variant value;

public:
  PossibleContents() : value(None()) {}
  PossibleContents(Variant value) : value(value) {}
  template<typename T> PossibleContents(T curr) : value(Variant(curr)) {}

  static PossibleContents none() { return PossibleContents(Variant(None())); }
  static PossibleContents many() { return PossibleContents(Variant(Many())); }

  bool operator==(const PossibleContents& other) const {
    return value == other.value;
  }

//  bool operator!=(const PossibleContents& other) const {
//    return value != other.value;
//  }

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

    // TODO: do we need special null handling here? e.g. nulls of different
    //       types can be merged, they are not actually different values, so
    //       we could LUB there.
    if (other.value == value) {
      return false;
    }

    // TODO unit test all this
    // The values differ, but if they share the same type then we can set to
    // that.
    // TODO: what if one is nullable and the other isn't? Should we be tracking
    //       a heap type here, really?
    auto type = getType();
    auto otherType = other.getType();
    if (otherType == type) {
      if (isExactType()) {
        // We were already marked as an arbitrary value of this type.
        return false;
      }

      // We were a constant, and encountered another constant or an arbitrary
      // value of our type. We change to be an arbitrary value of our type.
      assert(isConstant());
      assert(other.isConstant() || other.isExactType());
      value = Type(type);
      return true;
    }

    if (type.isRef() && otherType.isRef() &&
        type.getHeapType() == otherType.getHeapType()) {
      // The types differ, but the heap types agree, so the only difference here
      // is in nullability, and the combined value is the nullable type.
      auto newContents = PossibleContents(Type(type.getHeapType(), Nullable));
      if (*this == newContents) {
        assert(otherType.isNonNullable());
        return false;
      }

      *this = newContents;
      return true;
    }

    // Worst case.
    value = Many();
    return true;
  }

  bool isNone() const { return std::get_if<None>(&value); }
  bool isConstantLiteral() const { return std::get_if<Literal>(&value); }
  bool isConstantGlobal() const { return std::get_if<ImmutableGlobal>(&value); }
  bool isExactType() const { return std::get_if<Type>(&value); }
  bool isMany() const { return std::get_if<Many>(&value); }

  bool isConstant() const { return isConstantLiteral() || isConstantGlobal(); }

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

  size_t hash() const {
    if (isNone()) {
      return 0; // TODO: better
    } else if (isConstantLiteral()) {
      return std::hash<Literal>()(getConstantLiteral());
    } else if (isConstantGlobal()) {
      return std::hash<Name>()(getConstantGlobal());
    } else if (isExactType()) {
      return std::hash<Type>()(getType());
    } else if (isMany()) {
      return 1;
    } else {
      WASM_UNREACHABLE("bad variant");
    }
  }

  void dump(std::ostream& o) const {
    o << '[';
    if (isNone()) {
      o << "None";
    } else if (isConstantLiteral()) {
      o << "Literal " << getConstantLiteral();
      auto t = getType();
      if (t.isRef()) {
        auto h = t.getHeapType();
        o << " HT: " << h << '\n';
      }
    } else if (isConstantGlobal()) {
      o << "Global $" << getConstantGlobal();
    } else if (isExactType()) {
      o << "Type " << getType();
      auto t = getType();
      if (t.isRef()) {
        auto h = t.getHeapType();
        o << " HT: " << h << '\n';
      }
    } else if (isMany()) {
      o << "Many";
    } else {
      WASM_UNREACHABLE("bad variant");
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

template<> struct hash<wasm::PossibleContents> {
  size_t operator()(const wasm::PossibleContents& contents) const {
    return contents.hash();
  }
};

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

  // Internals for flow.

  // In some cases we need to know the parent of an expression. This maps such
  // children to their parents. TODO merge comments
  // In some cases we need to know the parent of the expression, like with GC
  // operations. Consider this:
  //
  //  (struct.set $A k
  //    (local.get $ref)
  //    (local.get $value)
  //  )
  //
  // Imagine that the first local.get, for $ref, receives a new value. That can
  // affect where the struct.set sends values: if previously that local.get had
  // no possible contents, and now it does, then we have StructLocations to
  // update. Likewise, when the second local.get is updated we must do the same,
  // but again which StructLocations we update depends on the ref passed to the
  // struct.get. To handle such things, we set |parent| to the parent, and check
  // for it during the flow. In the common case, however, where the parent does
  // not matter, this field can be nullptr XXX.
  //
  // In practice we always create an ExpressionLocation with a nullptr parent
  // for everything, so the local.gets above would each have two: one
  // ExpressionLocation without a parent, that is used in the graph normally,
  // and whose value flows into an ExpressionLocation with a parent equal to the
  // struct.set. This is practical because normally we do not know the parent of
  // each node as we traverse, so always adding a parent would make the graph-
  // building logic more complicated.
  std::unordered_map<Expression*, Expression*> childParents;

  // A piece of work during the flow: A location and some content that is sent
  // to it. That content may or may not actually lead to something new at that
  // location; if it does, then it may create further work.
  using Work = std::pair<Location, PossibleContents>;

  // The work remaining to do during the flow: locations that we just updated,
  // which means we should update their children when we pop them from this
  // queue.
  UniqueDeferredQueue<Work> workQueue;

  // During the flow we will need information about subtyping.
  std::unique_ptr<SubTypes> subTypes;

  std::unordered_set<Connection> connections;

  // We may add new connections as we flow. Do so to a temporary structure on
  // the side as we are iterating on |targets| here, which might be one of the
  // lists we want to update.
  std::vector<Connection> newConnections;

  void addWork(const Work& work) {
    workQueue.push(work);
  }

  // Update a target location with contents arriving to it. Add new work as
  // relevant based on what happens there.
  void processWork(const Work& work);

  void updateNewConnections();
};

} // namespace wasm

#endif // wasm_ir_possible_types_h
