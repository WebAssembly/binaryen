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
#include "support/small_vector.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

//
// PossibleContents represents the possible contents at a particular location
// (such as in a local or in a function parameter). This is a little similar to
// PossibleConstantValues, but considers more types of contents than constant
// values - in particular, it can track types to some extent.
//
// The specific contents this can vary over are:
//
//  * None:            No possible value.
//
//  * Literal:         One possible constant value like an i32 of 42.
//
//  * Global:          The name of an global whose value is here. We do not know
//                     the actual value at compile time, but we know it is equal
//                     to that global. Typically we can only infer this for
//                     immutable globals.
//
//  * ExactType:       Any possible value of a specific exact type - *not*
//                     including subtypes. For example, struct.new $Foo has
//                     ExactType contents of type $Foo.
//                     If the type here is nullable then null is also allowed.
//                     TODO: Add ConeType, which would include subtypes.
//
//  * Many:            Anything else. Many things are possible here, and we do
//                     not track what they might be, so we must assume the worst
//                     in the calling code.
//
struct PossibleContents {
  struct None : public std::monostate {};

  struct GlobalInfo {
    Name name;
    // The type of the global in the module. We stash this here so that we do
    // not need to pass around a module all the time.
    // TODO: could we save size in this variant if we did pass around the
    //       module?
    Type type;
    bool operator==(const GlobalInfo& other) const {
      return name == other.name && type == other.type;
    }
  };

  struct Many : public std::monostate {};

  // TODO: This is similar to the variant in PossibleConstantValues, and perhaps
  //       we could share code, but extending a variant using template magic may
  //       not be worthwhile. Another option might be to make PCV inherit from
  //       this and disallow ExactType etc.
  using Variant = std::variant<None, Literal, GlobalInfo, Type, Many>;
  Variant value;

  template<typename T> PossibleContents(T curr) : value(Variant(curr)) {}

public:
  // The only public constructor creates a None - nothing is possible there. All
  // other things must use one of the static constructors below.
  PossibleContents() : value(None()) {}

  static PossibleContents none() { return PossibleContents(Variant(None())); }
  static PossibleContents literal(Literal c) {
    return PossibleContents(Variant(c));
  }
  static PossibleContents global(Name name, Type type) {
    return PossibleContents(Variant(GlobalInfo{name, type}));
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
    // First handle the trivial cases of them being equal, or one of them is
    // None or Many.
    if (*this == other) {
      return false;
    }
    if (other.isNone()) {
      return false;
    }
    if (isNone()) {
      value = other.value;
      return true;
    }
    if (isMany()) {
      return false;
    }
    if (other.isMany()) {
      value = Many();
      return true;
    }

    auto applyIfDifferent = [&](const PossibleContents& newContents) {
      if (*this == newContents) {
        return false;
      }

      *this = newContents;
      return true;
    };

    auto type = getType();
    auto otherType = other.getType();

    // Special handling for nulls and nullability.
    if (type.isRef() && otherType.isRef()) {
      // Nulls are always equal to each other, even if their types differ.
      if (isNull() || other.isNull()) {
        // If only one is a null then the combination is to add nullability to
        // this one. (This is correct both for a literal or for a type: if it
        // was a literal then now we have either a literal or a null, so we do
        // not have a single constant anymore).
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

      if (type.getHeapType() == otherType.getHeapType()) {
        // The types differ, but the heap types agree, so the only difference
        // here is in nullability, and the combined value is the nullable type.
        return applyIfDifferent(
          PossibleContents(Type(type.getHeapType(), Nullable)));
      }
    }

    if (type == otherType) {
      // At least their types match, so we can switch to an exact type here
      // (unless we were already that, in which case nothing happens.
      if (isExactType()) {
        return false;
      }
      value = Type(type);
      return true;
    }

    // Nothing else possible combines in an interesting way; emit a Many.
    value = Many();
    return true;
  }

  bool isNone() const { return std::get_if<None>(&value); }
  bool isConstantLiteral() const { return std::get_if<Literal>(&value); }
  bool isGlobal() const { return std::get_if<GlobalInfo>(&value); }
  bool isExactType() const { return std::get_if<Type>(&value); }
  bool isMany() const { return std::get_if<Many>(&value); }

  bool isConstant() const { return isConstantLiteral() || isGlobal(); }

  // Returns the single constant value.
  Literal getConstantLiteral() const {
    assert(isConstant());
    return std::get<Literal>(value);
  }

  Name getGlobal() const {
    assert(isConstant());
    return std::get<GlobalInfo>(value).name;
  }

  bool isNull() const {
    return isConstantLiteral() && getConstantLiteral().isNull();
  }

  // Return the types possible here. If no type is possible, returns
  // unreachable; if many types are, returns none.
  Type getType() const {
    if (auto* literal = std::get_if<Literal>(&value)) {
      return literal->type;
    } else if (auto* global = std::get_if<GlobalInfo>(&value)) {
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
      auto name = getGlobal();
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
    } else if (isGlobal()) {
      return size_t(2) | (std::hash<Name>()(getGlobal()) << 3);
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
    } else if (isGlobal()) {
      o << "GlobalInfo $" << getGlobal();
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

// The location of contents in a struct or array (i.e., things that can fit in a
// dataref). Note that this is specific to this type - it does not include data
// about subtypes or supertypes.
struct DataLocation {
  HeapType type;
  // The index of the field in a struct, or 0 for an array (where we do not
  // attempt to differentiate positions).
  Index index;
  bool operator==(const DataLocation& other) const {
    return type == other.type && index == other.index;
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

// Special locations do not correspond to actual locations in the wasm, but are
// used to organize and optimize the graph. For example, in order to avoid N
// locations that are all connected to M other nodes - which requires N * M
// edges - we might introduce a single SpecialLocation that all the N connect to
// and which connects to all the M. That requires only N + M connections (though
// it does add "latency" in requiring an additional step along the way for the
// data).
struct SpecialLocation {
  // A unique index for this location. Necessary to keep different
  // SpecialLocations different, but the actual value here does not matter
  // otherwise.
  Index index;
  bool operator==(const SpecialLocation& other) const {
    return index == other.index;
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
                              DataLocation,
                              TagLocation,
                              NullLocation,
                              SpecialLocation>;

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

template<> struct hash<wasm::DataLocation> {
  size_t operator()(const wasm::DataLocation& loc) const {
    return std::hash<std::pair<wasm::HeapType, wasm::Index>>{}(
      {loc.type, loc.index});
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

template<> struct hash<wasm::SpecialLocation> {
  size_t operator()(const wasm::SpecialLocation& loc) const {
    return std::hash<wasm::Index>{}(loc.index);
  }
};

} // namespace std

namespace wasm {

// Analyze the entire wasm file to find which contents are possible in which
// locations. This assumes a closed world and starts from roots - newly created
// values - and propagates them to the locations they reach. After the
// analysis the user of this class can ask which contents are possible at any
// location.
class ContentOracle {
  Module& wasm;

  void analyze();

public:
  ContentOracle(Module& wasm) : wasm(wasm) { analyze(); }

  // Get the contents possible at a location.
  PossibleContents getContents(Location location) {
    auto iter = locationContents.find(location);
    if (iter == locationContents.end()) {
      // We know of no possible contents here.
      return PossibleContents::none();
    }
    return iter->second;
  }

private:
  std::unordered_map<Location, PossibleContents> locationContents;
};

} // namespace wasm

#endif // wasm_ir_possible_contents_h
