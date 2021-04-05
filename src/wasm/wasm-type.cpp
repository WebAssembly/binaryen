/*
 * Copyright 2017 WebAssembly Community Group participants
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

#include <algorithm>
#include <array>
#include <cassert>
#include <shared_mutex>
#include <sstream>
#include <unordered_map>
#include <unordered_set>

#include "compiler-support.h"
#include "support/hash.h"
#include "wasm-features.h"
#include "wasm-type.h"

namespace wasm {

namespace {

struct TypeInfo {
  using type_t = Type;
  // Used in assertions to ensure that temporary types don't leak into the
  // global store.
  bool isTemp = false;
  enum Kind {
    TupleKind,
    RefKind,
    RttKind,
  } kind;
  struct Ref {
    HeapType heapType;
    Nullability nullable;
  };
  union {
    Tuple tuple;
    Ref ref;
    Rtt rtt;
  };

  TypeInfo(const Tuple& tuple) : kind(TupleKind), tuple(tuple) {}
  TypeInfo(Tuple&& tuple) : kind(TupleKind), tuple(std::move(tuple)) {}
  TypeInfo(HeapType heapType, Nullability nullable)
    : kind(RefKind), ref{heapType, nullable} {}
  TypeInfo(Rtt rtt) : kind(RttKind), rtt(rtt) {}
  TypeInfo(const TypeInfo& other);
  ~TypeInfo();

  constexpr bool isTuple() const { return kind == TupleKind; }
  constexpr bool isRef() const { return kind == RefKind; }
  constexpr bool isRtt() const { return kind == RttKind; }

  bool isNullable() const { return kind == RefKind && ref.nullable; }

  bool operator==(const TypeInfo& other) const;
  bool operator!=(const TypeInfo& other) const { return !(*this == other); }
};

struct HeapTypeInfo {
  using type_t = HeapType;
  // Used in assertions to ensure that temporary types don't leak into the
  // global store.
  bool isTemp = false;
  // If `isFinalized`, then hashing and equality are performed on the finite
  // shape of the type definition tree rooted at the HeapTypeInfo.
  // Otherwise, the type definition tree is still being constructed via the
  // TypeBuilder interface, so hashing and equality use pointer identity.
  bool isFinalized = true;
  enum Kind {
    BasicKind,
    SignatureKind,
    StructKind,
    ArrayKind,
  } kind;
  union {
    HeapType::BasicHeapType basic;
    Signature signature;
    Struct struct_;
    Array array;
  };

  HeapTypeInfo(HeapType::BasicHeapType basic) : kind(BasicKind), basic(basic) {}
  HeapTypeInfo(Signature sig) : kind(SignatureKind), signature(sig) {}
  HeapTypeInfo(const Struct& struct_) : kind(StructKind), struct_(struct_) {}
  HeapTypeInfo(Struct&& struct_)
    : kind(StructKind), struct_(std::move(struct_)) {}
  HeapTypeInfo(Array array) : kind(ArrayKind), array(array) {}
  HeapTypeInfo(const HeapTypeInfo& other);
  ~HeapTypeInfo();

  constexpr bool isSignature() const { return kind == SignatureKind; }
  constexpr bool isStruct() const { return kind == StructKind; }
  constexpr bool isArray() const { return kind == ArrayKind; }
  constexpr bool isData() const { return isStruct() || isArray(); }

  HeapTypeInfo& operator=(const HeapTypeInfo& other);
  bool operator==(const HeapTypeInfo& other) const;
  bool operator!=(const HeapTypeInfo& other) const { return !(*this == other); }
};

// Helper for coinductively comparing Types and HeapTypes according to some
// arbitrary notion of complexity.
struct TypeComparator {
  // Set of HeapTypes we are assuming are equivalent as long as we cannot prove
  // otherwise.
  std::unordered_set<std::pair<HeapType, HeapType>> seen;
  bool lessThan(Type a, Type b);
  bool lessThan(HeapType a, HeapType b);
  bool lessThan(const TypeInfo& a, const TypeInfo& b);
  bool lessThan(const HeapTypeInfo& a, const HeapTypeInfo& b);
  bool lessThan(const Tuple& a, const Tuple& b);
  bool lessThan(const Field& a, const Field& b);
  bool lessThan(const Signature& a, const Signature& b);
  bool lessThan(const Struct& a, const Struct& b);
  bool lessThan(const Array& a, const Array& b);
  bool lessThan(const Rtt& a, const Rtt& b);
};

// Helper for coinductively checking whether a pair of Types or HeapTypes are in
// a subtype relation.
struct SubTyper {
  // Set of HeapTypes we are assuming are equivalent as long as we cannot prove
  // otherwise.
  std::unordered_set<std::pair<HeapType, HeapType>> seen;
  bool isSubType(Type a, Type b);
  bool isSubType(HeapType a, HeapType b);
  bool isSubType(const Tuple& a, const Tuple& b);
  bool isSubType(const Field& a, const Field& b);
  bool isSubType(const Signature& a, const Signature& b);
  bool isSubType(const Struct& a, const Struct& b);
  bool isSubType(const Array& a, const Array& b);
  bool isSubType(const Rtt& a, const Rtt& b);
};

// Helper for finding the equirecursive least upper bound of two types.
struct TypeBounder {
  TypeBuilder builder;
  // The indices in `builder` at which the LUB of each pair of HeapTypes are
  // being constructed.
  std::unordered_map<std::pair<HeapType, HeapType>, size_t> indices;

  bool hasLeastUpperBound(Type a, Type b);
  Type getLeastUpperBound(Type a, Type b);

private:
  // Return true and set `out` to be the LUB iff a LUB was found. The HeapType
  // and Struct overloads are exceptional because they are infallible;
  // HeapType::any is an upper bound of all HeapTypes and the empty struct is an
  // upper bound of all struct types. Note that these methods can return
  // temporary types, so they should never be used directly.
  bool lub(Type a, Type b, Type& out);
  HeapType lub(HeapType a, HeapType b);
  bool lub(const Tuple& a, const Tuple& b, Tuple& out);
  bool lub(const Field& a, const Field& b, Field& out);
  bool lub(const Signature& a, const Signature& b, Signature& out);
  Struct lub(const Struct& a, const Struct& b);
  bool lub(const Array& a, const Array& b, Array& out);
  bool lub(const Rtt& a, const Rtt& b, Rtt& out);
};

// Helper for printing types without infinitely recursing on recursive types.
struct TypePrinter {
  size_t currDepth = 0;
  std::unordered_map<TypeID, size_t> depths;

  // The stream we are printing to.
  std::ostream& os;

  TypePrinter(std::ostream& os) : os(os) {}

  std::ostream& print(Type type);
  std::ostream& print(HeapType heapType);
  std::ostream& print(const Tuple& tuple);
  std::ostream& print(const Field& field);
  std::ostream& print(const Signature& sig);
  std::ostream& print(const Struct& struct_);
  std::ostream& print(const Array& array);
  std::ostream& print(const Rtt& rtt);

private:
  template<typename T, typename F> std::ostream& printChild(T curr, F printer);
};

// Helper for hashing the shapes of TypeInfos and HeapTypeInfos. Keeps track of
// previously seen HeapTypes to avoid traversing them more than once. Infos
// referring to different type IDs but sharing a finite shape will compare and
// hash the same.
struct FiniteShapeHasher {
  bool topLevelOnly;
  size_t currDepth = 0;
  size_t currStep = 0;
  std::unordered_map<HeapType, size_t> seen;

  FiniteShapeHasher(bool topLevelOnly = false) : topLevelOnly(topLevelOnly) {}

  size_t hash(Type type);
  size_t hash(HeapType heapType);
  size_t hash(const TypeInfo& info);
  size_t hash(const HeapTypeInfo& info);
  size_t hash(const Tuple& tuple);
  size_t hash(const Field& field);
  size_t hash(const Signature& sig);
  size_t hash(const Struct& struct_);
  size_t hash(const Array& array);
  size_t hash(const Rtt& rtt);
};

// Helper for comparing the shapes of TypeInfos and HeapTypeInfos for equality.
// Like FiniteShapeHasher, keeps track of previously seen HeapTypes. Note that
// this does not test for coinductive equality of the infinite expansion of the
// type tree, but rather tests for equality of the finite shape of the graph. If
// FiniteShapeEquator reports that two type shapes are equal, FiniteShapeHasher
// should produce the same hash for them.
struct FiniteShapeEquator {
  bool topLevelOnly;
  size_t currDepth = 0;
  size_t currStep = 0;
  std::unordered_map<HeapType, size_t> seenA, seenB;

  FiniteShapeEquator(bool topLevelOnly = false) : topLevelOnly(topLevelOnly) {}

  bool eq(Type a, Type b);
  bool eq(HeapType a, HeapType b);
  bool eq(const TypeInfo& a, const TypeInfo& b);
  bool eq(const HeapTypeInfo& a, const HeapTypeInfo& b);
  bool eq(const Tuple& a, const Tuple& b);
  bool eq(const Field& a, const Field& b);
  bool eq(const Signature& a, const Signature& b);
  bool eq(const Struct& a, const Struct& b);
  bool eq(const Array& a, const Array& b);
  bool eq(const Rtt& a, const Rtt& b);
};

} // anonymous namespace
} // namespace wasm

namespace std {

template<> class hash<wasm::TypeInfo> {
public:
  size_t operator()(const wasm::TypeInfo& info) const {
    return wasm::FiniteShapeHasher().hash(info);
  }
};

template<> class hash<wasm::HeapTypeInfo> {
public:
  size_t operator()(const wasm::HeapTypeInfo& info) const {
    return wasm::FiniteShapeHasher().hash(info);
  }
};

template<typename T> class hash<reference_wrapper<const T>> {
public:
  size_t operator()(const reference_wrapper<const T>& ref) const {
    return hash<T>{}(ref.get());
  }
};

template<typename T> class equal_to<reference_wrapper<const T>> {
public:
  bool operator()(const reference_wrapper<const T>& a,
                  const reference_wrapper<const T>& b) const {
    return equal_to<T>{}(a.get(), b.get());
  }
};

} // namespace std

namespace wasm {
namespace {

TypeInfo* getTypeInfo(Type type) {
  assert(type.isCompound());
  return (TypeInfo*)type.getID();
}

HeapTypeInfo* getHeapTypeInfo(HeapType ht) {
  assert(ht.isCompound());
  return (HeapTypeInfo*)ht.getID();
}

HeapType asHeapType(std::unique_ptr<HeapTypeInfo>& info) {
  return HeapType(uintptr_t(info.get()));
}

Type markTemp(Type type) {
  if (!type.isBasic()) {
    getTypeInfo(type)->isTemp = true;
  }
  return type;
}

bool isTemp(Type type) { return !type.isBasic() && getTypeInfo(type)->isTemp; }

bool isTemp(HeapType type) {
  return !type.isBasic() && getHeapTypeInfo(type)->isTemp;
}

TypeInfo::TypeInfo(const TypeInfo& other) {
  kind = other.kind;
  switch (kind) {
    case TupleKind:
      new (&tuple) auto(other.tuple);
      return;
    case RefKind:
      new (&ref) auto(other.ref);
      return;
    case RttKind:
      new (&rtt) auto(other.rtt);
      return;
  }
  WASM_UNREACHABLE("unexpected kind");
}

TypeInfo::~TypeInfo() {
  switch (kind) {
    case TupleKind:
      tuple.~Tuple();
      return;
    case RefKind:
      ref.~Ref();
      return;
    case RttKind:
      rtt.~Rtt();
      return;
  }
  WASM_UNREACHABLE("unexpected kind");
}

bool TypeInfo::operator==(const TypeInfo& other) const {
  // TypeInfos with the same shape are considered equivalent. This is important
  // during global canonicalization, when newly created canonically-shaped
  // graphs are checked against the existing globally canonical graphs.
  return FiniteShapeEquator().eq(*this, other);
}

HeapTypeInfo::HeapTypeInfo(const HeapTypeInfo& other) {
  kind = other.kind;
  switch (kind) {
    case BasicKind:
      new (&basic) auto(other.basic);
      return;
    case SignatureKind:
      new (&signature) auto(other.signature);
      return;
    case StructKind:
      new (&struct_) auto(other.struct_);
      return;
    case ArrayKind:
      new (&array) auto(other.array);
      return;
  }
  WASM_UNREACHABLE("unexpected kind");
}

HeapTypeInfo::~HeapTypeInfo() {
  switch (kind) {
    case BasicKind:
      return;
    case SignatureKind:
      signature.~Signature();
      return;
    case StructKind:
      struct_.~Struct();
      return;
    case ArrayKind:
      array.~Array();
      return;
  }
  WASM_UNREACHABLE("unexpected kind");
}

HeapTypeInfo& HeapTypeInfo::operator=(const HeapTypeInfo& other) {
  if (&other != this) {
    this->~HeapTypeInfo();
    new (this) HeapTypeInfo(other);
  }
  return *this;
}

bool HeapTypeInfo::operator==(const HeapTypeInfo& other) const {
  return FiniteShapeEquator().eq(*this, other);
}

template<typename Info> struct Store {
  std::mutex mutex;

  // Track unique_ptrs for constructed types to avoid leaks.
  std::vector<std::unique_ptr<Info>> constructedTypes;

  // Maps from constructed types to their canonical Type IDs.
  std::unordered_map<std::reference_wrapper<const Info>, uintptr_t> typeIDs;

#ifndef NDEBUG
  bool isGlobalStore();
#endif

  TypeID recordCanonical(std::unique_ptr<Info>&& info);
  typename Info::type_t canonicalize(const Info& info);
};

struct TypeStore : Store<TypeInfo> {
  Type canonicalize(TypeInfo info);
};

struct HeapTypeStore : Store<HeapTypeInfo> {
  HeapType canonicalize(const HeapTypeInfo& info) {
    if (info.kind == HeapTypeInfo::BasicKind) {
      return info.basic;
    }
    return Store<HeapTypeInfo>::canonicalize(info);
  }
  HeapType canonicalize(std::unique_ptr<HeapTypeInfo>&& info);
};

TypeStore globalTypeStore;
HeapTypeStore globalHeapTypeStore;

// Specialized to simplify programming generically over Types and HeapTypes.
template<typename T> struct MetaTypeInfo {};

template<> struct MetaTypeInfo<Type> {
#ifndef NDEBUG
  constexpr static TypeStore& globalStore = globalTypeStore;
#endif
  static TypeInfo* getInfo(Type type) { return getTypeInfo(type); }
};

template<> struct MetaTypeInfo<HeapType> {
#ifndef NDEBUG
  constexpr static HeapTypeStore& globalStore = globalHeapTypeStore;
#endif
  static HeapTypeInfo* getInfo(HeapType ht) { return getHeapTypeInfo(ht); }
};

#ifndef NDEBUG
template<typename Info> bool Store<Info>::isGlobalStore() {
  return this == &MetaTypeInfo<typename Info::type_t>::globalStore;
}
#endif

template<typename Info>
TypeID Store<Info>::recordCanonical(std::unique_ptr<Info>&& info) {
  assert((!isGlobalStore() || !info->isTemp) && "Leaking temporary type!");
  TypeID id = uintptr_t(info.get());
  assert(id > Info::type_t::_last_basic_type);
  typeIDs[*info] = id;
  constructedTypes.emplace_back(std::move(info));
  return id;
}

template<typename Info>
typename Info::type_t Store<Info>::canonicalize(const Info& info) {
  std::lock_guard<std::mutex> lock(mutex);
  auto indexIt = typeIDs.find(std::cref(info));
  if (indexIt != typeIDs.end()) {
    return typename Info::type_t(indexIt->second);
  }
  return typename Info::type_t(recordCanonical(std::make_unique<Info>(info)));
}

HeapType HeapTypeStore::canonicalize(std::unique_ptr<HeapTypeInfo>&& info) {
  if (info->kind == HeapTypeInfo::BasicKind) {
    return info->basic;
  }
  std::lock_guard<std::mutex> lock(mutex);
  auto indexIt = typeIDs.find(std::cref(*info));
  if (indexIt != typeIDs.end()) {
    return HeapType(indexIt->second);
  }
  info->isTemp = false;
  return HeapType(recordCanonical(std::move(info)));
}

Type TypeStore::canonicalize(TypeInfo info) {
  if (info.isTuple()) {
    if (info.tuple.types.size() == 0) {
      return Type::none;
    }
    if (info.tuple.types.size() == 1) {
      return info.tuple.types[0];
    }
  }
  if (info.isRef() && info.ref.heapType.isBasic()) {
    if (info.ref.nullable) {
      switch (info.ref.heapType.getBasic()) {
        case HeapType::func:
          return Type::funcref;
        case HeapType::ext:
          return Type::externref;
        case HeapType::any:
          return Type::anyref;
        case HeapType::eq:
          return Type::eqref;
        case HeapType::i31:
        case HeapType::data:
          break;
      }
    } else {
      if (info.ref.heapType == HeapType::i31) {
        return Type::i31ref;
      }
      if (info.ref.heapType == HeapType::data) {
        return Type::dataref;
      }
    }
  }
  return Store<TypeInfo>::canonicalize(info);
}

} // anonymous namespace

Type::Type(std::initializer_list<Type> types) : Type(Tuple(types)) {}

Type::Type(const Tuple& tuple) {
#ifndef NDEBUG
  for (auto type : tuple.types) {
    assert(!isTemp(type) && "Leaking temporary type!");
  }
#endif
  new (this) Type(globalTypeStore.canonicalize(tuple));
}

Type::Type(Tuple&& tuple) {
#ifndef NDEBUG
  for (auto type : tuple.types) {
    assert(!isTemp(type) && "Leaking temporary type!");
  }
#endif
  new (this) Type(globalTypeStore.canonicalize(std::move(tuple)));
}

Type::Type(HeapType heapType, Nullability nullable) {
  assert(!isTemp(heapType) && "Leaking temporary type!");
  new (this) Type(globalTypeStore.canonicalize(TypeInfo(heapType, nullable)));
}

Type::Type(Rtt rtt) {
  assert(!isTemp(rtt.heapType) && "Leaking temporary type!");
  new (this) Type(globalTypeStore.canonicalize(rtt));
}

bool Type::isTuple() const {
  if (isBasic()) {
    return false;
  } else {
    return getTypeInfo(*this)->isTuple();
  }
}

bool Type::isRef() const {
  if (isBasic()) {
    return id >= funcref && id <= _last_basic_type;
  } else {
    return getTypeInfo(*this)->isRef();
  }
}

bool Type::isFunction() const {
  if (isBasic()) {
    return id == funcref;
  } else {
    auto* info = getTypeInfo(*this);
    return info->isRef() && info->ref.heapType.isFunction();
  }
}

bool Type::isData() const {
  if (isBasic()) {
    return id == dataref;
  } else {
    auto* info = getTypeInfo(*this);
    return info->isRef() && info->ref.heapType.isData();
  }
}

bool Type::isNullable() const {
  if (isBasic()) {
    return id >= funcref && id <= eqref; // except i31ref and dataref
  } else {
    return getTypeInfo(*this)->isNullable();
  }
}

bool Type::isRtt() const {
  if (isBasic()) {
    return false;
  } else {
    return getTypeInfo(*this)->isRtt();
  }
}

bool Type::isStruct() const { return isRef() && getHeapType().isStruct(); }

bool Type::isArray() const { return isRef() && getHeapType().isArray(); }

bool Type::isDefaultable() const {
  // A variable can get a default value if its type is concrete (unreachable
  // and none have no values, hence no default), and if it's a reference, it
  // must be nullable.
  if (isTuple()) {
    for (auto t : *this) {
      if (!t.isDefaultable()) {
        return false;
      }
    }
    return true;
  }
  return isConcrete() && (!isRef() || isNullable()) && !isRtt();
}

Nullability Type::getNullability() const {
  return isNullable() ? Nullable : NonNullable;
}

bool Type::operator<(const Type& other) const {
  return TypeComparator().lessThan(*this, other);
}

unsigned Type::getByteSize() const {
  // TODO: alignment?
  auto getSingleByteSize = [](Type t) {
    switch (t.getBasic()) {
      case Type::i32:
      case Type::f32:
        return 4;
      case Type::i64:
      case Type::f64:
        return 8;
      case Type::v128:
        return 16;
      case Type::funcref:
      case Type::externref:
      case Type::anyref:
      case Type::eqref:
      case Type::i31ref:
      case Type::dataref:
      case Type::none:
      case Type::unreachable:
        break;
    }
    WASM_UNREACHABLE("invalid type");
  };

  if (isTuple()) {
    unsigned size = 0;
    for (const auto& t : *this) {
      size += getSingleByteSize(t);
    }
    return size;
  }
  return getSingleByteSize(*this);
}

Type Type::reinterpret() const {
  assert(!isTuple() && "Unexpected tuple type");
  switch ((*begin()).getBasic()) {
    case Type::i32:
      return f32;
    case Type::i64:
      return f64;
    case Type::f32:
      return i32;
    case Type::f64:
      return i64;
    default:
      WASM_UNREACHABLE("invalid type");
  }
}

FeatureSet Type::getFeatures() const {
  auto getSingleFeatures = [](Type t) -> FeatureSet {
    if (t.isRef()) {
      // A reference type implies we need that feature. Some also require more,
      // such as GC or exceptions.
      auto heapType = t.getHeapType();
      if (heapType.isStruct() || heapType.isArray()) {
        return FeatureSet::ReferenceTypes | FeatureSet::GC;
      }
      if (heapType.isBasic()) {
        switch (heapType.getBasic()) {
          case HeapType::BasicHeapType::any:
          case HeapType::BasicHeapType::eq:
          case HeapType::BasicHeapType::i31:
          case HeapType::BasicHeapType::data:
            return FeatureSet::ReferenceTypes | FeatureSet::GC;
          default: {}
        }
      }
      // Note: Technically typed function references also require the typed
      // function references feature, however, we use these types internally
      // regardless of the presence of features (in particular, since during
      // load of the wasm we don't know the features yet, so we apply the more
      // refined types), so we don't add that in any case here.
      return FeatureSet::ReferenceTypes;
    } else if (t.isRtt()) {
      return FeatureSet::ReferenceTypes | FeatureSet::GC;
    }
    TODO_SINGLE_COMPOUND(t);
    switch (t.getBasic()) {
      case Type::v128:
        return FeatureSet::SIMD;
      default:
        return FeatureSet::MVP;
    }
  };

  if (isTuple()) {
    FeatureSet feats = FeatureSet::Multivalue;
    for (const auto& t : *this) {
      feats |= getSingleFeatures(t);
    }
    return feats;
  }
  return getSingleFeatures(*this);
}

const Tuple& Type::getTuple() const {
  assert(isTuple());
  return getTypeInfo(*this)->tuple;
}

HeapType Type::getHeapType() const {
  if (isBasic()) {
    switch (getBasic()) {
      case Type::none:
      case Type::unreachable:
      case Type::i32:
      case Type::i64:
      case Type::f32:
      case Type::f64:
      case Type::v128:
        break;
      case Type::funcref:
        return HeapType::func;
      case Type::externref:
        return HeapType::ext;
      case Type::anyref:
        return HeapType::any;
      case Type::eqref:
        return HeapType::eq;
      case Type::i31ref:
        return HeapType::i31;
      case Type::dataref:
        return HeapType::data;
    }
    WASM_UNREACHABLE("Unexpected type");
  } else {
    auto* info = getTypeInfo(*this);
    switch (info->kind) {
      case TypeInfo::TupleKind:
        break;
      case TypeInfo::RefKind:
        return info->ref.heapType;
      case TypeInfo::RttKind:
        return info->rtt.heapType;
    }
    WASM_UNREACHABLE("Unexpected type");
  }
}

Rtt Type::getRtt() const {
  assert(isRtt());
  return getTypeInfo(*this)->rtt;
}

Type Type::get(unsigned byteSize, bool float_) {
  if (byteSize < 4) {
    return Type::i32;
  }
  if (byteSize == 4) {
    return float_ ? Type::f32 : Type::i32;
  }
  if (byteSize == 8) {
    return float_ ? Type::f64 : Type::i64;
  }
  if (byteSize == 16) {
    return Type::v128;
  }
  WASM_UNREACHABLE("invalid size");
}

bool Type::isSubType(Type left, Type right) {
  return SubTyper().isSubType(left, right);
}

bool Type::hasLeastUpperBound(Type a, Type b) {
  return TypeBounder().hasLeastUpperBound(a, b);
}

Type Type::getLeastUpperBound(Type a, Type b) {
  return TypeBounder().getLeastUpperBound(a, b);
}

Type::Iterator Type::end() const {
  if (isTuple()) {
    return Iterator(this, getTypeInfo(*this)->tuple.types.size());
  } else {
    // TODO: unreachable is special and expands to {unreachable} currently.
    // see also: https://github.com/WebAssembly/binaryen/issues/3062
    return Iterator(this, size_t(id != Type::none));
  }
}

const Type& Type::Iterator::operator*() const {
  if (parent->isTuple()) {
    return getTypeInfo(*parent)->tuple.types[index];
  } else {
    // TODO: see comment in Type::end()
    assert(index == 0 && parent->id != Type::none && "Index out of bounds");
    return *parent;
  }
}

const Type& Type::operator[](size_t index) const {
  if (isTuple()) {
    return getTypeInfo(*this)->tuple.types[index];
  } else {
    assert(index == 0 && "Index out of bounds");
    return *begin();
  }
}

HeapType::HeapType(Signature sig) {
  assert(!isTemp(sig.params) && "Leaking temporary type!");
  assert(!isTemp(sig.results) && "Leaking temporary type!");
  new (this) HeapType(globalHeapTypeStore.canonicalize(sig));
}

HeapType::HeapType(const Struct& struct_) {
#ifndef NDEBUG
  for (const auto& field : struct_.fields) {
    assert(!isTemp(field.type) && "Leaking temporary type!");
  }
#endif
  new (this) HeapType(globalHeapTypeStore.canonicalize(struct_));
}

HeapType::HeapType(Struct&& struct_) {
#ifndef NDEBUG
  for (const auto& field : struct_.fields) {
    assert(!isTemp(field.type) && "Leaking temporary type!");
  }
#endif
  new (this) HeapType(globalHeapTypeStore.canonicalize(std::move(struct_)));
}

HeapType::HeapType(Array array) {
  assert(!isTemp(array.element.type) && "Leaking temporary type!");
  new (this) HeapType(globalHeapTypeStore.canonicalize(array));
}

bool HeapType::isFunction() const {
  if (isBasic()) {
    return id == func;
  } else {
    return getHeapTypeInfo(*this)->isSignature();
  }
}

bool HeapType::isData() const {
  if (isBasic()) {
    return id == data;
  } else {
    return getHeapTypeInfo(*this)->isData();
  }
}

bool HeapType::isSignature() const {
  if (isBasic()) {
    return false;
  } else {
    return getHeapTypeInfo(*this)->isSignature();
  }
}

bool HeapType::isStruct() const {
  if (isBasic()) {
    return false;
  } else {
    return getHeapTypeInfo(*this)->isStruct();
  }
}

bool HeapType::isArray() const {
  if (isBasic()) {
    return false;
  } else {
    return getHeapTypeInfo(*this)->isArray();
  }
}

bool HeapType::operator<(const HeapType& other) const {
  return TypeComparator().lessThan(*this, other);
}

Signature HeapType::getSignature() const {
  assert(isSignature());
  return getHeapTypeInfo(*this)->signature;
}

const Struct& HeapType::getStruct() const {
  assert(isStruct());
  return getHeapTypeInfo(*this)->struct_;
}

Array HeapType::getArray() const {
  assert(isArray());
  return getHeapTypeInfo(*this)->array;
}

bool HeapType::isSubType(HeapType left, HeapType right) {
  return SubTyper().isSubType(left, right);
}

bool Signature::operator<(const Signature& other) const {
  return TypeComparator().lessThan(*this, other);
}

template<typename T> static std::string genericToString(const T& t) {
  std::ostringstream ss;
  ss << t;
  return ss.str();
}
std::string Type::toString() const { return genericToString(*this); }
std::string HeapType::toString() const { return genericToString(*this); }
std::string Tuple::toString() const { return genericToString(*this); }
std::string Signature::toString() const { return genericToString(*this); }
std::string Struct::toString() const { return genericToString(*this); }
std::string Array::toString() const { return genericToString(*this); }
std::string Rtt::toString() const { return genericToString(*this); }
std::ostream& operator<<(std::ostream& os, Type type) {
  return TypePrinter(os).print(type);
}
std::ostream& operator<<(std::ostream& os, HeapType heapType) {
  return TypePrinter(os).print(heapType);
}
std::ostream& operator<<(std::ostream& os, Tuple tuple) {
  return TypePrinter(os).print(tuple);
}
std::ostream& operator<<(std::ostream& os, Signature sig) {
  return TypePrinter(os).print(sig);
}
std::ostream& operator<<(std::ostream& os, Field field) {
  return TypePrinter(os).print(field);
}
std::ostream& operator<<(std::ostream& os, Struct struct_) {
  return TypePrinter(os).print(struct_);
}
std::ostream& operator<<(std::ostream& os, Array array) {
  return TypePrinter(os).print(array);
}
std::ostream& operator<<(std::ostream& os, Rtt rtt) {
  return TypePrinter(os).print(rtt);
}

unsigned Field::getByteSize() const {
  if (type != Type::i32) {
    return type.getByteSize();
  }
  switch (packedType) {
    case Field::PackedType::i8:
      return 1;
    case Field::PackedType::i16:
      return 2;
    case Field::PackedType::not_packed:
      return 4;
  }
  WASM_UNREACHABLE("impossible packed type");
}

namespace {

bool TypeComparator::lessThan(Type a, Type b) {
  if (a == b) {
    return false;
  }
  if (a.isBasic() && b.isBasic()) {
    return a.getBasic() < b.getBasic();
  }
  if (a.isBasic()) {
    return true;
  }
  if (b.isBasic()) {
    return false;
  }
  return lessThan(*getTypeInfo(a), *getTypeInfo(b));
}

bool TypeComparator::lessThan(HeapType a, HeapType b) {
  if (a == b) {
    return false;
  }
  if (seen.count({a, b})) {
    // We weren't able to disprove that a == b since we last saw them, so it
    // holds coinductively that a < b is false.
    return false;
  }
  if (a.isBasic() && b.isBasic()) {
    return a.getBasic() < b.getBasic();
  }
  if (a.isBasic()) {
    return true;
  }
  if (b.isBasic()) {
    return false;
  }
  // As we recurse, we will coinductively assume that a == b unless proven
  // otherwise.
  seen.insert({a, b});
  return lessThan(*getHeapTypeInfo(a), *getHeapTypeInfo(b));
}

bool TypeComparator::lessThan(const TypeInfo& a, const TypeInfo& b) {
  if (a.kind != b.kind) {
    return a.kind < b.kind;
  }
  switch (a.kind) {
    case TypeInfo::TupleKind:
      return lessThan(a.tuple, b.tuple);
    case TypeInfo::RefKind:
      if (a.ref.nullable != b.ref.nullable) {
        return a.ref.nullable < b.ref.nullable;
      }
      return lessThan(a.ref.heapType, b.ref.heapType);
    case TypeInfo::RttKind:
      return lessThan(a.rtt, b.rtt);
  }
  WASM_UNREACHABLE("unexpected kind");
}

bool TypeComparator::lessThan(const HeapTypeInfo& a, const HeapTypeInfo& b) {
  if (a.kind != b.kind) {
    return a.kind < b.kind;
  }
  switch (a.kind) {
    case HeapTypeInfo::BasicKind:
      return a.basic < b.basic;
    case HeapTypeInfo::SignatureKind:
      return lessThan(a.signature, b.signature);
    case HeapTypeInfo::StructKind:
      return lessThan(a.struct_, b.struct_);
    case HeapTypeInfo::ArrayKind:
      return lessThan(a.array, b.array);
  }
  WASM_UNREACHABLE("unexpected kind");
}

bool TypeComparator::lessThan(const Tuple& a, const Tuple& b) {
  return std::lexicographical_compare(
    a.types.begin(),
    a.types.end(),
    b.types.begin(),
    b.types.end(),
    [&](Type ta, Type tb) { return lessThan(ta, tb); });
}

bool TypeComparator::lessThan(const Field& a, const Field& b) {
  if (a.mutable_ != b.mutable_) {
    return a.mutable_ < b.mutable_;
  }
  if (a.type == Type::i32 && b.type == Type::i32) {
    return a.packedType < b.packedType;
  }
  return lessThan(a.type, b.type);
}

bool TypeComparator::lessThan(const Signature& a, const Signature& b) {
  if (a.results != b.results) {
    return lessThan(a.results, b.results);
  }
  return lessThan(a.params, b.params);
}

bool TypeComparator::lessThan(const Struct& a, const Struct& b) {
  return std::lexicographical_compare(
    a.fields.begin(),
    a.fields.end(),
    b.fields.begin(),
    b.fields.end(),
    [&](const Field& fa, const Field& fb) { return lessThan(fa, fb); });
}

bool TypeComparator::lessThan(const Array& a, const Array& b) {
  return lessThan(a.element, b.element);
}

bool TypeComparator::lessThan(const Rtt& a, const Rtt& b) {
  if (a.depth != b.depth) {
    return a.depth < b.depth;
  }
  return lessThan(a.heapType, b.heapType);
}

bool SubTyper::isSubType(Type a, Type b) {
  if (a == b) {
    return true;
  }
  if (a == Type::unreachable) {
    return true;
  }
  if (a.isRef() && b.isRef()) {
    return (a.isNullable() == b.isNullable() || !a.isNullable()) &&
           isSubType(a.getHeapType(), b.getHeapType());
  }
  if (a.isTuple() && b.isTuple()) {
    return isSubType(a.getTuple(), b.getTuple());
  }
  if (a.isRtt() && b.isRtt()) {
    return isSubType(a.getRtt(), b.getRtt());
  }
  return false;
}

bool SubTyper::isSubType(HeapType a, HeapType b) {
  // See:
  // https://github.com/WebAssembly/function-references/blob/master/proposals/function-references/Overview.md#subtyping
  // https://github.com/WebAssembly/gc/blob/master/proposals/gc/MVP.md#defined-types
  if (a == b) {
    return true;
  }
  if (seen.count({a, b})) {
    // We weren't able to disprove that a == b since we last saw them, so the
    // relation holds coinductively.
    return true;
  }
  // Everything is a subtype of any.
  if (b == HeapType::any) {
    return true;
  }
  // Various things are subtypes of eq.
  if (b == HeapType::eq) {
    return a == HeapType::i31 || a.isData();
  }
  // Some are also subtypes of data.
  if (b == HeapType::data) {
    return a.isData();
  }
  // Signatures are subtypes of funcref.
  if (b == HeapType::func) {
    return a.isSignature();
  }
  // As we recurse, we will coinductively assume that a == b unless proven
  // otherwise.
  seen.insert({a, b});
  if (a.isSignature() && b.isSignature()) {
    return isSubType(a.getSignature(), b.getSignature());
  }
  if (a.isArray() && b.isArray()) {
    return isSubType(a.getArray(), b.getArray());
  }
  if (a.isStruct() && b.isStruct()) {
    return isSubType(a.getStruct(), b.getStruct());
  }
  return false;
}

bool SubTyper::isSubType(const Tuple& a, const Tuple& b) {
  if (a.types.size() != b.types.size()) {
    return false;
  }
  for (size_t i = 0; i < a.types.size(); ++i) {
    if (!isSubType(a.types[i], b.types[i])) {
      return false;
    }
  }
  return true;
}

bool SubTyper::isSubType(const Field& a, const Field& b) {
  if (a == b) {
    return true;
  }
  // Immutable fields can be subtypes.
  return a.mutable_ == Immutable && b.mutable_ == Immutable &&
         a.packedType == b.packedType && isSubType(a.type, b.type);
}

bool SubTyper::isSubType(const Signature& a, const Signature& b) {
  // TODO: Implement proper signature subtyping, covariant in results and
  // contravariant in params, once V8 implements it.
  // return isSubType(b.params, a.params) && isSubType(a.results, b.results);
  return a == b;
}

bool SubTyper::isSubType(const Struct& a, const Struct& b) {
  // There may be more fields on the left, but not fewer.
  if (a.fields.size() < b.fields.size()) {
    return false;
  }
  for (size_t i = 0; i < b.fields.size(); ++i) {
    if (!isSubType(a.fields[i], b.fields[i])) {
      return false;
    }
  }
  return true;
}

bool SubTyper::isSubType(const Array& a, const Array& b) {
  return isSubType(a.element, b.element);
}

bool SubTyper::isSubType(const Rtt& a, const Rtt& b) {
  // (rtt n $x) is a subtype of (rtt $x), that is, if the only difference in
  // information is that the left side specifies a depth while the right side
  // allows any depth.
  return a.heapType == b.heapType && a.hasDepth() && !b.hasDepth();
}

bool TypeBounder::hasLeastUpperBound(Type a, Type b) {
  Type tempLUB;
  return lub(a, b, tempLUB);
}

Type TypeBounder::getLeastUpperBound(Type a, Type b) {
  Type tempLUB;
  if (!lub(a, b, tempLUB)) {
    return Type::none;
  }
  // `tempLUB` is a temporary type owned by `builder`. Since TypeBuilder::build
  // returns HeapTypes rather than Types, create a new HeapType definition meant
  // only to get `tempLUB` canonicalized in a known location. The use of an
  // Array is arbitrary; it might as well have been a Struct.
  builder.grow(1);
  builder[builder.size() - 1] = Array(Field(tempLUB, Mutable));
  return builder.build().back().getArray().element.type;
}

bool TypeBounder::lub(Type a, Type b, Type& out) {
  if (a == b) {
    out = a;
    return true;
  }
  if (a == Type::unreachable) {
    out = b;
    return true;
  }
  if (b == Type::unreachable) {
    out = a;
    return true;
  }
  if (a.isTuple() && b.isTuple()) {
    Tuple tuple;
    if (!lub(a.getTuple(), b.getTuple(), tuple)) {
      return false;
    }
    out = builder.getTempTupleType(tuple);
    return true;
  } else if (a.isRef() && b.isRef()) {
    auto nullability =
      (a.isNullable() || b.isNullable()) ? Nullable : NonNullable;
    HeapType heapType = lub(a.getHeapType(), b.getHeapType());
    out = builder.getTempRefType(heapType, nullability);
    return true;
  } else if (a.isRtt() && b.isRtt()) {
    Rtt rtt(HeapType::any);
    if (!lub(a.getRtt(), b.getRtt(), rtt)) {
      return false;
    }
    out = builder.getTempRttType(rtt);
    return true;
  }
  return false;
}

HeapType TypeBounder::lub(HeapType a, HeapType b) {
  if (a == b) {
    return a;
  }
  // Canonicalize to have the basic HeapType on the left.
  if (b.isBasic()) {
    std::swap(a, b);
  }
  if (a.isBasic()) {
    switch (a.getBasic()) {
      case HeapType::func:
        if (b.isFunction()) {
          return HeapType::func;
        } else {
          return HeapType::any;
        }
      case HeapType::ext:
        return HeapType::any;
      case HeapType::any:
        return HeapType::any;
      case HeapType::eq:
        if (b == HeapType::i31 || b.isData()) {
          return HeapType::eq;
        } else {
          return HeapType::any;
        }
      case HeapType::i31:
        if (b.isData()) {
          return HeapType::eq;
        } else {
          return HeapType::any;
        }
      case HeapType::data:
        if (b.isData()) {
          return HeapType::data;
        } else if (b == HeapType::i31) {
          return HeapType::eq;
        } else {
          return HeapType::any;
        }
    }
  }
  // Allocate a new slot to construct the LUB of this pair if we have not
  // already seen it before. Canonicalize the pair to have the element with the
  // smaller ID first since order does not matter.
  auto pair = std::make_pair(std::min(a, b), std::max(a, b));
  size_t index = builder.size();
  auto result = indices.insert({pair, index});
  if (!result.second) {
    // We've seen this pair before; stop recursing and do not allocate.
    return builder[result.first->second];
  }

  builder.grow(1);
  if (a.isSignature() && b.isSignature()) {
    Signature sig;
    if (lub(a.getSignature(), b.getSignature(), sig)) {
      return builder[index] = sig;
    } else {
      return builder[index] = HeapType::func;
    }
  } else if (a.isStruct() && b.isStruct()) {
    return builder[index] = lub(a.getStruct(), b.getStruct());
  } else if (a.isArray() && b.isArray()) {
    Array array;
    if (lub(a.getArray(), b.getArray(), array)) {
      return builder[index] = array;
    } else {
      return builder[index] = HeapType::data;
    }
  } else {
    // The types are not of the same kind, so the LUB is either `data` or `any`.
    if (a.isSignature() || b.isSignature()) {
      return builder[index] = HeapType::any;
    } else {
      return builder[index] = HeapType::data;
    }
  }
}

bool TypeBounder::lub(const Tuple& a, const Tuple& b, Tuple& out) {
  if (a.types.size() != b.types.size()) {
    return false;
  }
  out.types.resize(a.types.size());
  for (size_t i = 0; i < a.types.size(); ++i) {
    if (!lub(a.types[i], b.types[i], out.types[i])) {
      return false;
    }
  }
  return true;
}

bool TypeBounder::lub(const Field& a, const Field& b, Field& out) {
  if (a == b) {
    out = a;
    return true;
  }
  // Mutable fields are invariant, so they would have had to be the same.
  if (a.mutable_ == Mutable || b.mutable_ == Mutable) {
    return false;
  }
  // Packed types must match.
  if (a.isPacked() != b.isPacked() ||
      (a.isPacked() && a.packedType != b.packedType)) {
    return false;
  }
  // Either the packed types match or the types aren't packed.
  Type type;
  if (lub(a.type, b.type, type)) {
    out = a;
    out.type = type;
    return true;
  } else {
    return false;
  }
}

bool TypeBounder::lub(const Signature& a, const Signature& b, Signature& out) {
  // TODO: Implement proper signature subtyping, covariant in results and
  // contravariant in params, once V8 implements it.
  if (a != b) {
    return false;
  } else {
    out = a;
    return true;
  }
}

Struct TypeBounder::lub(const Struct& a, const Struct& b) {
  Struct out;
  size_t numFields = std::min(a.fields.size(), b.fields.size());
  for (size_t i = 0; i < numFields; ++i) {
    Field field;
    if (lub(a.fields[i], b.fields[i], field)) {
      out.fields.push_back(field);
    } else {
      // Stop at the common prefix and ignore the rest.
      break;
    }
  }
  return out;
}

bool TypeBounder::lub(const Array& a, const Array& b, Array& out) {
  return lub(a.element, b.element, out.element);
}

bool TypeBounder::lub(const Rtt& a, const Rtt& b, Rtt& out) {
  if (a.heapType != b.heapType) {
    return false;
  }
  uint32_t depth = (a.depth == b.depth) ? a.depth : Rtt::NoDepth;
  out = Rtt(depth, a.heapType);
  return true;
}

template<typename T, typename F>
std::ostream& TypePrinter::printChild(T curr, F printer) {
  auto it = depths.find(curr.getID());
  if (it != depths.end()) {
    assert(it->second <= currDepth);
    size_t relativeDepth = currDepth - it->second;
    return os << "..." << relativeDepth;
  }
  depths[curr.getID()] = ++currDepth;
  printer();
  depths.erase(curr.getID());
  --currDepth;
  return os;
}

std::ostream& TypePrinter::print(Type type) {
  if (type.isBasic()) {
    switch (type.getBasic()) {
      case Type::none:
        return os << "none";
      case Type::unreachable:
        return os << "unreachable";
      case Type::i32:
        return os << "i32";
      case Type::i64:
        return os << "i64";
      case Type::f32:
        return os << "f32";
      case Type::f64:
        return os << "f64";
      case Type::v128:
        return os << "v128";
      case Type::funcref:
        return os << "funcref";
      case Type::externref:
        return os << "externref";
      case Type::anyref:
        return os << "anyref";
      case Type::eqref:
        return os << "eqref";
      case Type::i31ref:
        return os << "i31ref";
      case Type::dataref:
        return os << "dataref";
    }
  }

  return printChild(type, [&]() {
    if (isTemp(type)) {
      os << "[T]";
    }
    if (type.isTuple()) {
      print(type.getTuple());
    } else if (type.isRef()) {
      os << "(ref ";
      if (type.isNullable()) {
        os << "null ";
      }
      print(type.getHeapType());
      os << ')';
    } else if (type.isRtt()) {
      print(type.getRtt());
    } else {
      WASM_UNREACHABLE("unexpected type");
    }
  });
}

std::ostream& TypePrinter::print(HeapType heapType) {
  if (heapType.isBasic()) {
    switch (heapType.getBasic()) {
      case HeapType::func:
        return os << "func";
      case HeapType::ext:
        return os << "extern";
      case HeapType::any:
        return os << "any";
      case HeapType::eq:
        return os << "eq";
      case HeapType::i31:
        return os << "i31";
      case HeapType::data:
        return os << "data";
    }
  }

  return printChild(heapType, [&]() {
    if (isTemp(heapType)) {
      os << "[T]";
    }
    if (heapType.isSignature()) {
      print(heapType.getSignature());
    } else if (heapType.isStruct()) {
      print(heapType.getStruct());
    } else if (heapType.isArray()) {
      print(heapType.getArray());
    } else {
      WASM_UNREACHABLE("unexpected type");
    }
  });
}

std::ostream& TypePrinter::print(const Tuple& tuple) {
  os << '(';
  auto sep = "";
  for (Type type : tuple.types) {
    os << sep;
    sep = " ";
    print(type);
  }
  return os << ')';
}

std::ostream& TypePrinter::print(const Field& field) {
  if (field.mutable_) {
    os << "(mut ";
  }
  if (field.isPacked()) {
    auto packedType = field.packedType;
    if (packedType == Field::PackedType::i8) {
      os << "i8";
    } else if (packedType == Field::PackedType::i16) {
      os << "i16";
    } else {
      WASM_UNREACHABLE("unexpected packed type");
    }
  } else {
    print(field.type);
  }
  if (field.mutable_) {
    os << ')';
  }
  return os;
}

std::ostream& TypePrinter::print(const Signature& sig) {
  auto printPrefixed = [&](const char* prefix, Type type) {
    os << '(' << prefix;
    for (Type t : type) {
      os << ' ';
      print(t);
    }
    os << ')';
  };

  os << "(func";
  if (sig.params.getID() != Type::none) {
    os << ' ';
    printPrefixed("param", sig.params);
  }
  if (sig.results.getID() != Type::none) {
    os << ' ';
    printPrefixed("result", sig.results);
  }
  return os << ')';
}

std::ostream& TypePrinter::print(const Struct& struct_) {
  os << "(struct";
  if (struct_.fields.size()) {
    os << " (field";
  }
  for (const Field& field : struct_.fields) {
    os << ' ';
    print(field);
  }
  if (struct_.fields.size()) {
    os << ')';
  }
  return os << ')';
}

std::ostream& TypePrinter::print(const Array& array) {
  os << "(array ";
  print(array.element);
  return os << ')';
}

std::ostream& TypePrinter::print(const Rtt& rtt) {
  os << "(rtt ";
  if (rtt.hasDepth()) {
    os << rtt.depth << ' ';
  }
  print(rtt.heapType);
  return os << ')';
}

size_t FiniteShapeHasher::hash(Type type) {
  size_t digest = wasm::hash(type.isBasic());
  if (type.isBasic()) {
    rehash(digest, type.getID());
  } else {
    hash_combine(digest, hash(*getTypeInfo(type)));
  }
  return digest;
}

size_t FiniteShapeHasher::hash(HeapType heapType) {
  size_t digest = wasm::hash(heapType.isBasic());
  if (heapType.isBasic()) {
    rehash(digest, heapType.getID());
    return digest;
  }
  if (topLevelOnly && currDepth > 0) {
    return digest;
  }
  auto it = seen.find(heapType);
  rehash(digest, it != seen.end());
  if (it != seen.end()) {
    rehash(digest, it->second);
    return digest;
  }
  seen[heapType] = ++currStep;
  ++currDepth;
  hash_combine(digest, hash(*getHeapTypeInfo(heapType)));
  --currDepth;
  return digest;
}

size_t FiniteShapeHasher::hash(const TypeInfo& info) {
  size_t digest = wasm::hash(info.kind);
  switch (info.kind) {
    case TypeInfo::TupleKind:
      hash_combine(digest, hash(info.tuple));
      return digest;
    case TypeInfo::RefKind:
      rehash(digest, info.ref.nullable);
      hash_combine(digest, hash(info.ref.heapType));
      return digest;
    case TypeInfo::RttKind:
      hash_combine(digest, hash(info.rtt));
      return digest;
  }
  WASM_UNREACHABLE("unexpected kind");
}

size_t FiniteShapeHasher::hash(const HeapTypeInfo& info) {
  // If the HeapTypeInfo is not finalized, then it is mutable and its shape
  // might change in the future. In that case, fall back to pointer identity to
  // keep the hash consistent until all the TypeBuilder's types are finalized.
  size_t digest = wasm::hash(info.isFinalized);
  if (!info.isFinalized) {
    rehash(digest, uintptr_t(&info));
    return digest;
  }
  rehash(digest, info.kind);
  switch (info.kind) {
    case HeapTypeInfo::BasicKind:
      hash_combine(digest, wasm::hash(info.basic));
      return digest;
    case HeapTypeInfo::SignatureKind:
      hash_combine(digest, hash(info.signature));
      return digest;
    case HeapTypeInfo::StructKind:
      hash_combine(digest, hash(info.struct_));
      return digest;
    case HeapTypeInfo::ArrayKind:
      hash_combine(digest, hash(info.array));
      return digest;
  }
  WASM_UNREACHABLE("unexpected kind");
}

size_t FiniteShapeHasher::hash(const Tuple& tuple) {
  size_t digest = wasm::hash(tuple.types.size());
  for (auto type : tuple.types) {
    hash_combine(digest, hash(type));
  }
  return digest;
}

size_t FiniteShapeHasher::hash(const Field& field) {
  size_t digest = wasm::hash(field.packedType);
  rehash(digest, field.mutable_);
  hash_combine(digest, hash(field.type));
  return digest;
}

size_t FiniteShapeHasher::hash(const Signature& sig) {
  size_t digest = hash(sig.params);
  hash_combine(digest, hash(sig.results));
  return digest;
}

size_t FiniteShapeHasher::hash(const Struct& struct_) {
  size_t digest = wasm::hash(struct_.fields.size());
  for (const auto& field : struct_.fields) {
    hash_combine(digest, hash(field));
  }
  return digest;
}

size_t FiniteShapeHasher::hash(const Array& array) {
  return hash(array.element);
}

size_t FiniteShapeHasher::hash(const Rtt& rtt) {
  size_t digest = wasm::hash(rtt.depth);
  hash_combine(digest, hash(rtt.heapType));
  return digest;
}

bool FiniteShapeEquator::eq(Type a, Type b) {
  if (a.isBasic() != b.isBasic()) {
    return false;
  } else if (a.isBasic()) {
    return a.getID() == b.getID();
  } else {
    return eq(*getTypeInfo(a), *getTypeInfo(b));
  }
}

bool FiniteShapeEquator::eq(HeapType a, HeapType b) {
  if (a.isBasic() != b.isBasic()) {
    return false;
  } else if (a.isBasic()) {
    return a.getID() == b.getID();
  }
  if (topLevelOnly && currDepth > 0) {
    return true;
  }
  auto itA = seenA.find(a);
  auto itB = seenB.find(b);
  if ((itA != seenA.end()) != (itB != seenB.end())) {
    return false;
  } else if (itA != seenA.end()) {
    return itA->second == itB->second;
  }
  seenA[a] = seenB[b] = ++currStep;
  ++currDepth;
  bool ret = eq(*getHeapTypeInfo(a), *getHeapTypeInfo(b));
  --currDepth;
  return ret;
}

bool FiniteShapeEquator::eq(const TypeInfo& a, const TypeInfo& b) {
  if (a.kind != b.kind) {
    return false;
  }
  switch (a.kind) {
    case TypeInfo::TupleKind:
      return eq(a.tuple, b.tuple);
    case TypeInfo::RefKind:
      return a.ref.nullable == b.ref.nullable &&
             eq(a.ref.heapType, b.ref.heapType);
    case TypeInfo::RttKind:
      return eq(a.rtt, b.rtt);
  }
  WASM_UNREACHABLE("unexpected kind");
}

bool FiniteShapeEquator::eq(const HeapTypeInfo& a, const HeapTypeInfo& b) {
  if (a.isFinalized != b.isFinalized) {
    return false;
  } else if (!a.isFinalized) {
    // See comment on corresponding FiniteShapeHasher method.
    return &a == &b;
  }
  if (a.kind != b.kind) {
    return false;
  }
  switch (a.kind) {
    case HeapTypeInfo::BasicKind:
      return a.basic == b.basic;
    case HeapTypeInfo::SignatureKind:
      return eq(a.signature, b.signature);
    case HeapTypeInfo::StructKind:
      return eq(a.struct_, b.struct_);
    case HeapTypeInfo::ArrayKind:
      return eq(a.array, b.array);
  }
  WASM_UNREACHABLE("unexpected kind");
}

bool FiniteShapeEquator::eq(const Tuple& a, const Tuple& b) {
  return std::equal(a.types.begin(),
                    a.types.end(),
                    b.types.begin(),
                    b.types.end(),
                    [&](const Type& x, const Type& y) { return eq(x, y); });
}

bool FiniteShapeEquator::eq(const Field& a, const Field& b) {
  return a.packedType == b.packedType && a.mutable_ == b.mutable_ &&
         eq(a.type, b.type);
}

bool FiniteShapeEquator::eq(const Signature& a, const Signature& b) {
  return eq(a.params, b.params) && eq(a.results, b.results);
}

bool FiniteShapeEquator::eq(const Struct& a, const Struct& b) {
  return std::equal(a.fields.begin(),
                    a.fields.end(),
                    b.fields.begin(),
                    b.fields.end(),
                    [&](const Field& x, const Field& y) { return eq(x, y); });
}

bool FiniteShapeEquator::eq(const Array& a, const Array& b) {
  return eq(a.element, b.element);
}

bool FiniteShapeEquator::eq(const Rtt& a, const Rtt& b) {
  return a.depth == b.depth && eq(a.heapType, b.heapType);
}

} // anonymous namespace

struct TypeBuilder::Impl {
  TypeStore typeStore;

  struct Entry {
    std::unique_ptr<HeapTypeInfo> info;
    bool initialized = false;
    Entry() {
      // We need to eagerly allocate the HeapTypeInfo so we have a TypeID to use
      // to refer to it before it is initialized. Arbitrarily choose a default
      // value.
      info = std::make_unique<HeapTypeInfo>(Signature());
      set(Signature());
    }
    void set(HeapTypeInfo&& hti) {
      *info = std::move(hti);
      info->isTemp = true;
      info->isFinalized = false;
      initialized = true;
    }
    HeapType get() { return HeapType(TypeID(info.get())); }
  };

  std::vector<Entry> entries;

  Impl(size_t n) : entries(n) {}
};

TypeBuilder::TypeBuilder(size_t n) {
  impl = std::make_unique<TypeBuilder::Impl>(n);
}

TypeBuilder::~TypeBuilder() = default;

void TypeBuilder::grow(size_t n) {
  assert(size() + n > size());
  impl->entries.resize(size() + n);
}

size_t TypeBuilder::size() { return impl->entries.size(); }

void TypeBuilder::setHeapType(size_t i, HeapType::BasicHeapType basic) {
  assert(i < size() && "Index out of bounds");
  impl->entries[i].set(basic);
}

void TypeBuilder::setHeapType(size_t i, Signature signature) {
  assert(i < size() && "Index out of bounds");
  impl->entries[i].set(signature);
}

void TypeBuilder::setHeapType(size_t i, const Struct& struct_) {
  assert(i < size() && "index out of bounds");
  impl->entries[i].set(struct_);
}

void TypeBuilder::setHeapType(size_t i, Struct&& struct_) {
  assert(i < size() && "index out of bounds");
  impl->entries[i].set(std::move(struct_));
}

void TypeBuilder::setHeapType(size_t i, Array array) {
  assert(i < size() && "index out of bounds");
  impl->entries[i].set(array);
}

HeapType TypeBuilder::getTempHeapType(size_t i) {
  assert(i < size() && "index out of bounds");
  return impl->entries[i].get();
}

Type TypeBuilder::getTempTupleType(const Tuple& tuple) {
  Type ret = impl->typeStore.canonicalize(tuple);
  if (tuple.types.size() > 1) {
    return markTemp(ret);
  } else {
    // No new tuple was created, so the result might not be temporary.
    return ret;
  }
}

Type TypeBuilder::getTempRefType(HeapType type, Nullability nullable) {
  return markTemp(impl->typeStore.canonicalize(TypeInfo(type, nullable)));
}

Type TypeBuilder::getTempRttType(Rtt rtt) {
  return markTemp(impl->typeStore.canonicalize(rtt));
}

namespace {

// A wrapper around a HeapType that provides equality and hashing based only on
// its top-level shape, up to but not including its closest HeapType
// descendants. This is the shape that determines the most fine-grained
// initial partitions for Hopcroft's algorithm and also the shape that
// determines the "alphabet" for transitioning to the child HeapTypes in the DFA
// view of the type definition.
struct ShallowHeapType {
  HeapType heapType;

  ShallowHeapType(HeapType heapType) : heapType(heapType) {}
  bool operator==(const ShallowHeapType& other) const;
};

bool ShallowHeapType::operator==(const ShallowHeapType& other) const {
  return FiniteShapeEquator(/*topLevelOnly=*/true)
    .eq(this->heapType, other.heapType);
}

} // anonymous namespace
} // namespace wasm

namespace std {

template<> class hash<wasm::ShallowHeapType> {
public:
  size_t operator()(const wasm::ShallowHeapType& type) const {
    return wasm::FiniteShapeHasher(/*topLevelOnly=*/true).hash(type.heapType);
  }
};

} // namespace std

namespace wasm {
namespace {

// Uses Hopcroft's DFA minimization algorithm to construct a minimal type
// definition graph from an input graph. See
// https://en.wikipedia.org/wiki/DFA_minimization#Hopcroft's_algorithm.
struct ShapeCanonicalizer {
  // The new, minimal type definition graph.
  std::vector<std::unique_ptr<HeapTypeInfo>> infos;

  // Maps each input HeapType to the index of its partition in `partitions`,
  // which is also the index of its canonicalized HeapTypeInfo in infos.
  std::unordered_map<HeapType, size_t> partitionIndices;

  ShapeCanonicalizer(const std::vector<HeapType>& input);

private:
  using TypeSet = std::unordered_set<HeapType>;

  // The HeapTypes in the type definition graph to canonicalize.
  const std::vector<HeapType>& input;

  // The partitioning of the input HeapTypes used by Hopcroft's algorithm.
  std::vector<TypeSet> partitions;

  // Hopcroft's algorithm needs to be able to find the predecessors of a
  // particular state via a given symbol in the alphabet. We use simple child
  // indices as the alphabet.
  size_t alphabetSize = 0;
  std::unordered_map<HeapType, std::unordered_map<size_t, TypeSet>> preds;

  void initializePredecessors();
  void initializePartitions();
  void translatePartitionsToTypes();

  std::vector<HeapType*> getChildren(HeapType type);
  const TypeSet& getPredsOf(HeapType type, size_t symbol);
  TypeSet getIntersection(const TypeSet& a, const TypeSet& b);
  TypeSet getDifference(const TypeSet& a, const TypeSet& b);
};

ShapeCanonicalizer::ShapeCanonicalizer(const std::vector<HeapType>& input)
  : input(input) {
  initializePredecessors();
  initializePartitions();

  // The Hopcroft's algorithm's list of partitions that may still be
  // distinguishing partitions. Starts out containing all partitions.
  std::set<size_t> distinguishers;
  for (size_t i = 0; i < partitions.size(); ++i) {
    distinguishers.insert(i);
  }

  // Hopcroft's algorithm
  while (distinguishers.size()) {
    // Choose a partition that might be able to distinguish between the members
    // of some other partition.
    auto distinguishingIndexIt = distinguishers.begin();
    TypeSet distinguishing = partitions[*distinguishingIndexIt];
    distinguishers.erase(distinguishingIndexIt);
    // For each possibly distinguishing transition symbol...
    for (size_t symbol = 0; symbol < alphabetSize; ++symbol) {
      // Find all types that reach one of the current distinguishing types via
      // `symbol`.
      TypeSet currPreds;
      for (auto type : distinguishing) {
        const TypeSet& specificPreds = getPredsOf(type, symbol);
        currPreds.insert(specificPreds.begin(), specificPreds.end());
      }
      // Find partitions that contain some elements that are predecessors of the
      // current distinguishing partition and some elements that are not
      // predecessors of the current distinguishing partition.
      for (size_t distinguishedIndex = 0, end = partitions.size();
           distinguishedIndex < end;
           ++distinguishedIndex) {
        TypeSet& distinguished = partitions[distinguishedIndex];
        TypeSet intersection = getIntersection(distinguished, currPreds);
        if (intersection.empty()) {
          continue;
        }
        TypeSet difference = getDifference(distinguished, currPreds);
        if (difference.empty()) {
          continue;
        }
        // We can split the partition! Replace it with the intersection and add
        // the difference as a new partition.
        partitions[distinguishedIndex] = std::move(intersection);
        size_t newPartitionIndex = partitions.size();
        for (auto movedType : difference) {
          partitionIndices[movedType] = newPartitionIndex;
        }
        partitions.emplace_back(std::move(difference));
        // If the split partition was a potential distinguisher, both smaller
        // partitions are as well. Otherwise, we only need to add the smaller of
        // the two smaller partitions as a new potential distinguisher.
        if (distinguishers.count(distinguishedIndex) ||
            partitions[newPartitionIndex].size() <=
              partitions[distinguishedIndex].size()) {
          distinguishers.insert(newPartitionIndex);
        } else {
          distinguishers.insert(distinguishedIndex);
        }
      }
    }
  }

  translatePartitionsToTypes();
}

void ShapeCanonicalizer::initializePredecessors() {
  for (auto heapType : input) {
    size_t childIndex = 0;
    for (auto* child : getChildren(heapType)) {
      alphabetSize = std::max(alphabetSize, childIndex + 1);
      preds[*child][childIndex++].insert(heapType);
    }
  }
}

void ShapeCanonicalizer::initializePartitions() {
  // Create the initial partitions based on the top-level shape of the input
  // heap types. If two heap types are differentiable without recursing into
  // their child heap types, then they are obviously not equivalent and can be
  // placed in different partitions. Starting with this fine-grained partition
  // lets us use simple child indices as our transition alphabet since we will
  // never mix up equivalent indices from different kinds of types, for example
  // considering a struct and a signature with the same children to be the same
  // type.
  std::unordered_map<ShallowHeapType, size_t> initialIndices;
  for (auto type : input) {
    ShallowHeapType shallow(type);
    auto inserted = initialIndices.insert({shallow, partitions.size()});
    if (inserted.second) {
      // We have not seen a type with this shape before; create a new
      // partition.
      partitionIndices[type] = partitions.size();
      partitions.emplace_back(TypeSet{type});
    } else {
      // Add to the partition we have already created for this type shape.
      size_t index = inserted.first->second;
      partitionIndices[type] = index;
      partitions[index].insert(type);
    }
  }
}

void ShapeCanonicalizer::translatePartitionsToTypes() {
  // Create a single new HeapTypeInfo for each partition. Initialize each new
  // HeapTypeInfo as a copy of a representative HeapTypeInfo from its partition,
  // then patch all the children of the new HeapTypeInfos to refer to other new
  // HeapTypeInfos rather than the original HeapTypeInfos. This newly formed
  // graph will have a shape coinductively equivalent to the original graph's
  // shape, but each type definition will be minimal and distinct.
  for (auto& partition : partitions) {
    const auto& representative = *getHeapTypeInfo(*partition.begin());
    infos.push_back(std::make_unique<HeapTypeInfo>(representative));
    infos.back()->isTemp = true;
  }
  for (auto& info : infos) {
    for (auto* child : getChildren(asHeapType(info))) {
      auto partitionIt = partitionIndices.find(*child);
      if (partitionIt == partitionIndices.end()) {
        // This child has already been replaced.
        continue;
      }
      *child = asHeapType(infos.at(partitionIt->second));
    }
  }
}

std::vector<HeapType*> ShapeCanonicalizer::getChildren(HeapType heapType) {
  std::vector<HeapType*> children;

  auto noteChild = [&](HeapType* child) {
    if (!child->isBasic()) {
      children.push_back(child);
    }
  };

  // Scan through Types to find the next HeapType.
  std::function<void(Type)> scanType = [&](Type type) {
    if (type.isBasic()) {
      return;
    }
    auto* info = getTypeInfo(type);
    switch (info->kind) {
      case TypeInfo::TupleKind:
        for (Type t : info->tuple.types) {
          scanType(t);
        }
        return;
      case TypeInfo::RefKind:
        return noteChild(&info->ref.heapType);
      case TypeInfo::RttKind:
        return noteChild(&info->rtt.heapType);
    }
    WASM_UNREACHABLE("unexpected kind");
  };

  assert(!heapType.isBasic() && "Cannot have basic defined HeapType");
  auto* info = getHeapTypeInfo(heapType);
  switch (info->kind) {
    case HeapTypeInfo::BasicKind:
      return children;
    case HeapTypeInfo::SignatureKind:
      scanType(info->signature.params);
      scanType(info->signature.results);
      return children;
    case HeapTypeInfo::StructKind:
      for (auto& field : info->struct_.fields) {
        scanType(field.type);
      }
      return children;
    case HeapTypeInfo::ArrayKind:
      scanType(info->array.element.type);
      return children;
  }
  WASM_UNREACHABLE("unexpected kind");
}

const std::unordered_set<HeapType>&
ShapeCanonicalizer::getPredsOf(HeapType type, size_t symbol) {
  static TypeSet empty;
  auto predsIt = preds.find(type);
  if (predsIt == preds.end()) {
    return empty;
  }
  auto& predsOfType = predsIt->second;
  auto specificPredsIt = predsOfType.find(symbol);
  if (specificPredsIt == predsOfType.end()) {
    return empty;
  }
  return specificPredsIt->second;
}

std::unordered_set<HeapType>
ShapeCanonicalizer::getIntersection(const TypeSet& a, const TypeSet& b) {
  TypeSet ret;
  const TypeSet& smaller = a.size() < b.size() ? a : b;
  const TypeSet& bigger = a.size() < b.size() ? b : a;
  for (auto type : smaller) {
    if (bigger.count(type)) {
      ret.insert(type);
    }
  }
  return ret;
}

std::unordered_set<HeapType>
ShapeCanonicalizer::getDifference(const TypeSet& a, const TypeSet& b) {
  TypeSet ret;
  for (auto type : a) {
    if (!b.count(type)) {
      ret.insert(type);
    }
  }
  return ret;
}

// Replaces temporary types and heap types in a type definition graph with their
// globally canonical versions to prevent temporary types or heap type from
// leaking into the global stores.
struct GlobalCanonicalizer {

  std::vector<HeapType> results;
  GlobalCanonicalizer(std::vector<std::unique_ptr<HeapTypeInfo>>& infos);

private:
  struct Item {
    enum Kind {
      TypeKind,
      HeapTypeKind,
    } kind;
    union {
      Type* type;
      HeapType* heapType;
    };
    Item(Type* type) : kind(TypeKind), type(type) {}
    Item(HeapType* heapType) : kind(HeapTypeKind), heapType(heapType) {}
  };

  // IDs of scanned Types and HeapTypes, used to prevent repeated scanning.
  std::unordered_set<TypeID> scanned;

  // The work list of Types and HeapTypes remaining to be scanned.
  std::vector<Item> scanList;

  // Maps each temporary Type and HeapType to the locations where they will have
  // to be replaced with canonical Types and HeapTypes.
  std::unordered_map<Type, std::vector<Type*>> typeLocations;
  std::unordered_map<HeapType, std::vector<HeapType*>> heapTypeLocations;

  template<typename T1, typename T2> void noteChild(T1 parent, T2* child);
  void scanHeapType(HeapType* ht);
  void scanType(Type* child);
};

// Traverse the type graph rooted at the initialized HeapTypeInfos, replacing in
// place all Types and HeapTypes backed by the TypeBuilder's Stores with
// equivalent globally canonicalized Types and HeapTypes.
GlobalCanonicalizer::GlobalCanonicalizer(
  std::vector<std::unique_ptr<HeapTypeInfo>>& infos) {
  // Seed the scan list with the HeapTypes to canonicalize.
  results.reserve(infos.size());
  for (auto& info : infos) {
    results.push_back(asHeapType(info));
    scanList.push_back(&results.back());
  }

  // Traverse the type graph reachable from the heap types, collecting a list of
  // type and heap type use sites that need to be patched with canonical types.
  while (scanList.size() != 0) {
    auto item = scanList.back();
    scanList.pop_back();
    switch (item.kind) {
      case Item::TypeKind:
        scanType(item.type);
        break;
      case Item::HeapTypeKind:
        scanHeapType(item.heapType);
        break;
    }
  }

  // Canonicalize HeapTypes at all their use sites. HeapTypes for which there
  // was not already a globally canonical version are moved to the global store
  // to become the canonical version. These new canonical HeapTypes still
  // contain references to temporary Types owned by the TypeBuilder, so we must
  // subsequently replace those references with references to canonical Types.
  // Canonicalize non-tuple Types (which never directly refer to other Types)
  // before tuple Types to avoid canonicalizing a tuple that still contains
  // non-canonical Types.
  for (auto& info : infos) {
    HeapType original = asHeapType(info);
    HeapType canonical = globalHeapTypeStore.canonicalize(std::move(info));
    if (original != canonical) {
      for (HeapType* use : heapTypeLocations.at(original)) {
        *use = canonical;
      }
    }
  }
  auto canonicalizeTypes = [&](bool tuples) {
    for (auto& pair : typeLocations) {
      Type original = pair.first;
      std::vector<Type*>& uses = pair.second;
      if (original.isTuple() == tuples) {
        Type canonical = globalTypeStore.canonicalize(*getTypeInfo(original));
        for (Type* use : uses) {
          *use = canonical;
        }
      }
    }
  };
  canonicalizeTypes(false);
  canonicalizeTypes(true);
}

template<typename T1, typename T2>
void GlobalCanonicalizer::noteChild(T1 parent, T2* child) {
  if (child->isCompound()) {
    scanList.push_back(child);
  }
}

void GlobalCanonicalizer::scanHeapType(HeapType* ht) {
  assert(ht->isCompound());
  heapTypeLocations[*ht].push_back(ht);
  if (scanned.count(ht->getID())) {
    return;
  }
  scanned.insert(ht->getID());

  auto* info = getHeapTypeInfo(*ht);
  switch (info->kind) {
    case HeapTypeInfo::BasicKind:
      break;
    case HeapTypeInfo::SignatureKind:
      noteChild(*ht, &info->signature.params);
      noteChild(*ht, &info->signature.results);
      break;
    case HeapTypeInfo::StructKind:
      for (auto& field : info->struct_.fields) {
        noteChild(*ht, &field.type);
      }
      break;
    case HeapTypeInfo::ArrayKind:
      noteChild(*ht, &info->array.element.type);
      break;
  }
};

void GlobalCanonicalizer::scanType(Type* type) {
  assert(type->isCompound());
  typeLocations[*type].push_back(type);
  if (scanned.count(type->getID())) {
    return;
  }
  scanned.insert(type->getID());

  auto* info = getTypeInfo(*type);
  switch (info->kind) {
    case TypeInfo::TupleKind:
      for (auto& child : info->tuple.types) {
        noteChild(*type, &child);
      }
      break;
    case TypeInfo::RefKind:
      noteChild(*type, &info->ref.heapType);
      break;
    case TypeInfo::RttKind:
      noteChild(*type, &info->rtt.heapType);
      break;
  }
}

} // anonymous namespace

std::vector<HeapType> TypeBuilder::build() {
  std::vector<HeapType> heapTypes;
  for (auto& entry : impl->entries) {
    assert(entry.initialized && "Cannot access uninitialized HeapType");
    entry.info->isFinalized = true;
    heapTypes.push_back(entry.get());
  }

  // Canonicalize the shape of the type definition graph.
  ShapeCanonicalizer minimized(heapTypes);

  // The shape of the definition graph is now canonicalized, but it is still
  // comprised of temporary types and heap types. Get or create their globally
  // canonical versions.
  GlobalCanonicalizer globallyCanonical(minimized.infos);

  // Map the original heap types to their minimized and globally canonical
  // versions.
  for (auto& type : heapTypes) {
    type = globallyCanonical.results[minimized.partitionIndices[type]];
  }

  return heapTypes;
}

} // namespace wasm

namespace std {

template<> class hash<wasm::TypeList> {
public:
  size_t operator()(const wasm::TypeList& types) const {
    auto digest = wasm::hash(types.size());
    for (auto type : types) {
      wasm::rehash(digest, type);
    }
    return digest;
  }
};

template<> class hash<wasm::FieldList> {
public:
  size_t operator()(const wasm::FieldList& fields) const {
    auto digest = wasm::hash(fields.size());
    for (auto field : fields) {
      wasm::rehash(digest, field);
    }
    return digest;
  }
};

size_t hash<wasm::Type>::operator()(const wasm::Type& type) const {
  return wasm::hash(type.getID());
}

size_t hash<wasm::Tuple>::operator()(const wasm::Tuple& tuple) const {
  return wasm::hash(tuple.types);
}

size_t hash<wasm::Signature>::operator()(const wasm::Signature& sig) const {
  auto digest = wasm::hash(sig.params);
  wasm::rehash(digest, sig.results);
  return digest;
}

size_t hash<wasm::Field>::operator()(const wasm::Field& field) const {
  auto digest = wasm::hash(field.type);
  wasm::rehash(digest, field.packedType);
  wasm::rehash(digest, field.mutable_);
  return digest;
}

size_t hash<wasm::Struct>::operator()(const wasm::Struct& struct_) const {
  return wasm::hash(struct_.fields);
}

size_t hash<wasm::Array>::operator()(const wasm::Array& array) const {
  return wasm::hash(array.element);
}

size_t hash<wasm::HeapType>::operator()(const wasm::HeapType& heapType) const {
  return wasm::hash(heapType.getID());
}

size_t hash<wasm::Rtt>::operator()(const wasm::Rtt& rtt) const {
  auto digest = wasm::hash(rtt.depth);
  wasm::rehash(digest, rtt.heapType);
  return digest;
}

} // namespace std
