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

#ifndef wasm_ir_possible_contents_h
#define wasm_ir_possible_contents_h

#include <variant>

#include "ir/possible-constant.h"
#include "ir/subtypes.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

// Similar to PossibleConstantValues, but considers more types of contents.
// Specifically, this can also track types, making this a variant over:
//  * None: No possible value.
//  * Literal: One possible constant value like i32(42)
//  * ImmutableGlobal: The name of an immutable global whose value is here. We
//    do not know that value at compile time, but we know it is equal to the
//    global.
//  * ExactType: Any possible value of a specific exact type. For example,
//               ExactType($struct) means the value is of type $struct but not
//               any subtype of it.
//               If the type here is nullable then null is also allowed.
//               TODO: add ConeType, which would include subtypes
//  * Many: None of the above, so we must assume many things are possible here,
//          more than we are willing to track, and must assume the worst in the
//          calling code.
struct PossibleContents {
  struct None : public std::monostate {};

  struct ImmutableGlobal {
    Name name;
    // The type of the global in the module. We stash this here so that we do
    // not need to pass around a module all the time.
    // TODO: could we save size in this variant if we did pass around the
    //       module?
    Type type;
    bool operator==(const ImmutableGlobal& other) const {
      return name == other.name && type == other.type;
    }
  };

  struct Many : public std::monostate {};

  using Variant = std::variant<None, Literal, ImmutableGlobal, Type, Many>;
  Variant value;

public:
  PossibleContents() : value(None()) {}
  PossibleContents(Variant value) : value(value) {}
  template<typename T> PossibleContents(T curr) : value(Variant(curr)) {}

  static PossibleContents none() { return PossibleContents(Variant(None())); }
  static PossibleContents constantLiteral(Literal c) {
    return PossibleContents(Variant(c));
  }
  static PossibleContents constantGlobal(Name name, Type type) {
    return PossibleContents(Variant(ImmutableGlobal{name, type}));
  }
  static PossibleContents exactType(Type type) {
    return PossibleContents(Variant(type));
  }
  static PossibleContents many() { return PossibleContents(Variant(Many())); }

  bool operator==(const PossibleContents& other) const {
    return value == other.value;
  }

  bool operator!=(const PossibleContents& other) const {
    return !(*this == other);
  }

  // Combine the information in a given PossibleContents to this one. The
  // contents here will then include whatever content was possible in |other|.
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

    auto applyIfDifferent = [&](const PossibleContents& newContents) {
      if (*this == newContents) {
        return false;
      }

      *this = newContents;
      return true;
    };

    auto type = getType();
    auto otherType = other.getType();

    // Special handling for nulls. Nulls are always equal to each other, even
    // if their types differ.
    if (type.isRef() && otherType.isRef() && (isNull() || other.isNull())) {
      // If only one is a null then the combination is to add nullability to
      // this one. (This is correct both for a literal or for a type: if it was
      // a literal then now we have either a literal or a null, so we do not
      // have a single constant anymore).
      if (!isNull()) {
        return applyIfDifferent(
          PossibleContents(Type(type.getHeapType(), Nullable)));
      }
      if (!other.isNull()) {
        return applyIfDifferent(
          PossibleContents(Type(otherType.getHeapType(), Nullable)));
      }

      // Both are null. The result is a null, of the LUB.
      auto lub = Type(HeapType::getLeastUpperBound(type.getHeapType(),
                                                   otherType.getHeapType()),
                      Nullable);
      return applyIfDifferent(PossibleContents(Literal::makeNull(lub)));
    }

    if (other.value == value) {
      return false;
    }

    // The values differ, but if they share the same type then we can set to
    // that.
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
      return applyIfDifferent(
        PossibleContents(Type(type.getHeapType(), Nullable)));
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

  bool isNull() const {
    return isConstantLiteral() && getConstantLiteral().isNull();
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
    // Encode this using three bits for the variant type, then the rest of the
    // contents.
    if (isNone()) {
      return 0;
    } else if (isConstantLiteral()) {
      return size_t(1) | (std::hash<Literal>()(getConstantLiteral()) << 3);
    } else if (isConstantGlobal()) {
      return size_t(2) | (std::hash<Name>()(getConstantGlobal()) << 3);
    } else if (isExactType()) {
      return size_t(3) | (std::hash<Type>()(getType()) << 3);
    } else if (isMany()) {
      return 4;
    } else {
      WASM_UNREACHABLE("bad variant");
    }
  }

  void dump(std::ostream& o, Module* wasm = nullptr) const {
    o << '[';
    if (isNone()) {
      o << "None";
    } else if (isConstantLiteral()) {
      o << "Literal " << getConstantLiteral();
      auto t = getType();
      if (t.isRef()) {
        auto h = t.getHeapType();
        o << " HT: " << h;
      }
    } else if (isConstantGlobal()) {
      o << "ImmutableGlobal $" << getConstantGlobal();
    } else if (isExactType()) {
      o << "ExactType " << getType();
      auto t = getType();
      if (t.isRef()) {
        auto h = t.getHeapType();
        o << " HT: " << h;
        if (wasm && wasm->typeNames.count(h)) {
          o << " $" << wasm->typeNames[h].name;
        }
        if (t.isNullable()) {
          o << " null";
        }
      }
    } else if (isMany()) {
      o << "Many";
    } else {
      WASM_UNREACHABLE("bad variant");
    }
    o << ']';
  }
};

// *Location structs describe particular locations where content can appear.

// The location of a specific expression, referring to the possible content
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

// A location is a variant over all the possible flavors of locations that we
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

// A link indicates a flow of content from one location to another. For
// example, if we do a local.get and return that value from a function, then
// we have a link from a LocalLocaiton to a ResultLocation.
struct Link {
  Location from;
  Location to;

  bool operator==(const Link& other) const {
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

// Define hashes of all the *Location flavors so that Location itself is
// hashable and we can use it in unordered maps and sets.

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

template<> struct hash<wasm::Link> {
  size_t operator()(const wasm::Link& loc) const {
    return std::hash<std::pair<wasm::Location, wasm::Location>>{}(
      {loc.from, loc.to});
  }
};

} // namespace std

namespace wasm {

// Analyze the entire wasm file to find which contents are possible in which
// locations. This assumes a closed world and starts from roots - newly created
// values - and propagates them to the locations they reach. After the
// analysis the user of this class can ask which contents are possible at any
// location.
//
// TODO: refactor the internals out of this header.
class ContentOracle {
  Module& wasm;

  void analyze();

public:
  ContentOracle(Module& wasm) : wasm(wasm) { analyze(); }

  // Get the contents possible at a location.
  PossibleContents getContents(Location location) {
    auto iter = flowInfoMap.find(location);
    if (iter == flowInfoMap.end()) {
      return {};
    }
    return iter->second.contents;
  }

private:
  // The information needed during and after flowing the contents through the
  // graph. TODO: do not keep this around forever, delete the stuff we only need
  // during the flow after the flow.
  struct LocationInfo {
    // The contents possible at this location.
    PossibleContents contents;

    // The targets to which this sends contents.
    std::vector<Location> targets;
  };

  std::unordered_map<Location, LocationInfo> flowInfoMap;

  // Internals for flow.

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
  // struct.get. To handle such things, we set add a childParent link, and then
  // when we update the child we can handle any possible action regarding the
  // parent.
  std::unordered_map<Expression*, Expression*> childParents;

  // The work remaining to do during the flow: locations that we are sending an
  // update to. This maps the target location to the new contents, which is
  // efficient since we may send contents A to a target and then send further
  // contents B before we even get to processing that target; rather than queue
  // two work items, we want just one with the combined contents.
  std::unordered_map<Location, PossibleContents> workQueue;

  // During the flow we will need information about subtyping.
  std::unique_ptr<SubTypes> subTypes;

  std::unordered_set<Link> links;

  // We may add new links as we flow. Do so to a temporary structure on
  // the side to avoid any aliasing as we work.
  std::vector<Link> newLinks;

  // TODO: if we add work that turns a target into Many, we can delete the link
  //       to it.
  void addWork(const Location& location, const PossibleContents& contents);

  // Update a target location with contents arriving to it. Add new work as
  // relevant based on what happens there.
  void processWork(const Location& location, const PossibleContents& arrivingContents);

  void updateNewLinks();
};

} // namespace wasm

#endif // wasm_ir_possible_contents_h
