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
  enum Kind {
    SignatureKind,
    StructKind,
    ArrayKind,
  } kind;
  union {
    Signature signature;
    Struct struct_;
    Array array;
  };

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
  // Set of HeapTypes we are assuming satisfy the relation as long as we cannot
  // prove otherwise.
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
  // Set of HeapTypes we are assuming satisfy the relation as long as we cannot
  // prove otherwise.
  std::unordered_set<std::pair<HeapType, HeapType>> seen;
  bool isSubType(Type a, Type b);
  bool isSubType(HeapType a, HeapType b);
  bool isSubType(const Tuple& a, const Tuple& b);
  bool isSubType(const Field& a, const Field& b);
  bool isSubType(const HeapTypeInfo& a, const HeapTypeInfo& b);
  bool isSubType(const Signature& a, const Signature& b);
  bool isSubType(const Struct& a, const Struct& b);
  bool isSubType(const Array& a, const Array& b);
  bool isSubType(const Rtt& a, const Rtt& b);
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
  template<typename T, typename F> std::ostream& printChild(T curr, F printer) {
    auto it = depths.find(curr.getID());
    if (it != depths.end()) {
      assert(it->second <= currDepth);
      size_t relativeDepth = currDepth - it->second;
      return os << "..." << relativeDepth;
    }
    depths[curr.getID()] = ++currDepth;
    printer();
    depths.erase(curr.getID());
    return os;
  }
};

} // anonymous namespace
} // namespace wasm

namespace std {

template<> class hash<wasm::TypeInfo> {
public:
  size_t operator()(const wasm::TypeInfo&) const;
};

template<> class hash<wasm::HeapTypeInfo> {
public:
  size_t operator()(const wasm::HeapTypeInfo&) const;
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
  if (kind != other.kind) {
    return false;
  }
  switch (kind) {
    case TupleKind:
      return tuple == other.tuple;
    case RefKind:
      return ref.heapType == other.ref.heapType &&
             ref.nullable == other.ref.nullable;
    case RttKind:
      return rtt == other.rtt;
  }
  WASM_UNREACHABLE("unexpected kind");
}

HeapTypeInfo::HeapTypeInfo(const HeapTypeInfo& other) {
  kind = other.kind;
  switch (kind) {
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
  if (kind != other.kind) {
    return false;
  }
  switch (kind) {
    case SignatureKind:
      return signature == other.signature;
    case StructKind:
      return struct_ == other.struct_;
    case ArrayKind:
      return array == other.array;
  }
  WASM_UNREACHABLE("unexpected kind");
}

template<typename Info> struct Store {
  std::mutex mutex;

  // Track unique_ptrs for constructed types to avoid leaks.
  std::vector<std::unique_ptr<Info>> constructedTypes;

  // Maps from constructed types to their canonical Type IDs.
  std::unordered_map<Info, uintptr_t> typeIDs;

  TypeID recordCanonical(std::unique_ptr<Info>&& info) {
    TypeID id = uintptr_t(info.get());
    assert(id > Info::type_t::_last_basic_type);
    typeIDs[*info] = id;
    constructedTypes.emplace_back(std::move(info));
    return id;
  }

  typename Info::type_t canonicalize(const Info& info) {
    std::lock_guard<std::mutex> lock(mutex);
    auto indexIt = typeIDs.find(info);
    if (indexIt != typeIDs.end()) {
      return typename Info::type_t(indexIt->second);
    }
    return typename Info::type_t(recordCanonical(std::make_unique<Info>(info)));
  }
};

struct TypeStore : Store<TypeInfo> {
  Type canonicalize(TypeInfo info) {
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
};

using HeapTypeStore = Store<HeapTypeInfo>;

TypeStore globalTypeStore;
HeapTypeStore globalHeapTypeStore;

// Specialized to simplify programming generically over Types and HeapTypes.
template<typename T> struct MetaTypeInfo {};

template<> struct MetaTypeInfo<Type> {
  constexpr static TypeStore& globalStore = globalTypeStore;
  static TypeInfo* getInfo(Type type) { return getTypeInfo(type); }
};

template<> struct MetaTypeInfo<HeapType> {
  constexpr static HeapTypeStore& globalStore = globalHeapTypeStore;
  static HeapTypeInfo* getInfo(HeapType ht) { return getHeapTypeInfo(ht); }
};

} // anonymous namespace

Type::Type(std::initializer_list<Type> types) : Type(Tuple(types)) {}

Type::Type(const Tuple& tuple) {
  new (this) Type(globalTypeStore.canonicalize(tuple));
}

Type::Type(Tuple&& tuple) {
  new (this) Type(globalTypeStore.canonicalize(std::move(tuple)));
}

Type::Type(HeapType heapType, Nullability nullable) {
  new (this) Type(globalTypeStore.canonicalize(TypeInfo(heapType, nullable)));
}

Type::Type(Rtt rtt) { new (this) Type(globalTypeStore.canonicalize(rtt)); }

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
  return isConcrete() && (!isRef() || isNullable()) && !isRtt();
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

Type Type::getLeastUpperBound(Type a, Type b) {
  if (a == b) {
    return a;
  }
  if (a == Type::unreachable) {
    return b;
  }
  if (b == Type::unreachable) {
    return a;
  }
  if (a.size() != b.size()) {
    return Type::none; // a poison value that must not be consumed
  }
  if (a.isRef() || b.isRef()) {
    if (!a.isRef() || !b.isRef()) {
      return Type::none;
    }
    auto handleNullability = [&](HeapType heapType) {
      return Type(heapType,
                  a.isNullable() || b.isNullable() ? Nullable : NonNullable);
    };
    auto aHeap = a.getHeapType();
    auto bHeap = b.getHeapType();
    if (aHeap.isFunction() && bHeap.isFunction()) {
      return handleNullability(HeapType::func);
    }
    if (aHeap.isData() && bHeap.isData()) {
      return handleNullability(HeapType::data);
    }
    if ((aHeap == HeapType::eq || aHeap == HeapType::i31 ||
         aHeap == HeapType::data) &&
        (bHeap == HeapType::eq || bHeap == HeapType::i31 ||
         bHeap == HeapType::data)) {
      return handleNullability(HeapType::eq);
    }
    // The LUB of two different reference types is anyref, which may or may
    // not be a valid type depending on whether the GC feature is enabled. When
    // GC is disabled, it is possible for the finalization of invalid code to
    // introduce a use of anyref via this function, but that is not a problem
    // because it will be caught and rejected by validation.
    return Type::anyref;
  }
  if (a.isTuple()) {
    TypeList types;
    types.resize(a.size());
    for (size_t i = 0; i < types.size(); ++i) {
      types[i] = getLeastUpperBound(a[i], b[i]);
      if (types[i] == Type::none) {
        return Type::none;
      }
    }
    return Type(types);
  }
  return Type::none;
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

HeapType::HeapType(Signature signature) {
  new (this) HeapType(globalHeapTypeStore.canonicalize(signature));
}

HeapType::HeapType(const Struct& struct_) {
  new (this) HeapType(globalHeapTypeStore.canonicalize(struct_));
}

HeapType::HeapType(Struct&& struct_) {
  new (this) HeapType(globalHeapTypeStore.canonicalize(std::move(struct_)));
}

HeapType::HeapType(Array array) {
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
    // We weren't able to disprove that a < b since we last saw them, so the
    // relation holds coinductively.
    return true;
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
  // As we recurse, we will coinductively assume that a < b unless proven
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
    // We weren't able to disprove that a is a subtype of b since we last saw
    // them, so the relation holds coinductively.
    return true;
  }
  // Everything is a subtype of any.
  if (b == HeapType::any) {
    return true;
  }
  // Various things are subtypes of eq.
  if (b == HeapType::eq) {
    return a == HeapType::i31 || a.isArray() || a.isStruct();
  }
  // Some are also subtypes of data.
  if (b == HeapType::data) {
    return a.isData();
  }
  // Signatures are subtypes of funcref.
  if (b == HeapType::func) {
    return a.isSignature();
  }
  // As we recurse, we will coinductively assume that a is a subtype of b unless
  // proven otherwise.
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
    }
    void set(HeapTypeInfo&& hti) {
      *info = hti;
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

void TypeBuilder::setHeapType(size_t i, Signature signature) {
  assert(i < impl->entries.size() && "Index out of bounds");
  impl->entries[i].set(signature);
}

void TypeBuilder::setHeapType(size_t i, const Struct& struct_) {
  assert(i < impl->entries.size() && "index out of bounds");
  impl->entries[i].set(struct_);
}

void TypeBuilder::setHeapType(size_t i, Struct&& struct_) {
  assert(i < impl->entries.size() && "index out of bounds");
  impl->entries[i].set(std::move(struct_));
}

void TypeBuilder::setHeapType(size_t i, Array array) {
  assert(i < impl->entries.size() && "index out of bounds");
  impl->entries[i].set(array);
}

Type TypeBuilder::getTempTupleType(const Tuple& tuple) {
  return impl->typeStore.canonicalize(tuple);
}

Type TypeBuilder::getTempRefType(size_t i, Nullability nullable) {
  assert(i < impl->entries.size() && "Index out of bounds");
  return impl->typeStore.canonicalize(
    TypeInfo(impl->entries[i].get(), nullable));
}

Type TypeBuilder::getTempRttType(size_t i, uint32_t depth) {
  assert(i < impl->entries.size() && "Index out of bounds");
  return impl->typeStore.canonicalize(Rtt(depth, impl->entries[i].get()));
}

namespace {

// Implements the algorithm to canonicalize the HeapTypes in a TypeBuilder,
// replacing and deduplicating the temporary type and heaptypes backed by
// storage owned by the TypeBuilder into normal types and heap types backed by
// the global stores.
struct Canonicalizer {
  TypeBuilder& builder;

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

  // Maps Type and HeapType IDs to the IDs of their child Types and HeapTypes
  // in the type graph. Only considers compound Types and HeapTypes.
  std::unordered_map<TypeID, std::unordered_set<TypeID>> children;

  // Maps each temporary Type and HeapType to the locations where they will have
  // to be replaced with canonical Types and HeapTypes.
  std::unordered_map<Type, std::vector<Type*>> typeLocations;
  std::unordered_map<HeapType, std::vector<HeapType*>> heapTypeLocations;

  // These heap types will not participate in canonicalization.
  std::unordered_set<HeapType> selfReferentialHeapTypes;

  // Maps Types and HeapTypes backed by the TypeBuilder's Stores to globally
  // canonical Types and HeapTypes.
  std::unordered_map<Type, Type> canonicalTypes;
  std::unordered_map<HeapType, HeapType> canonicalHeapTypes;

  // The fully canonicalized heap types.
  std::vector<HeapType> results;

  Canonicalizer(TypeBuilder& builder);
  template<typename T1, typename T2> void noteChild(T1 parent, T2* child);
  void scanHeapType(HeapType* ht);
  void scanType(Type* child);
  void findSelfReferentialHeapTypes();
  std::vector<Item> getOrderedItems();

  // Replaces the pointee Type or HeapType of `type` with its globally canonical
  // equivalent, recording the substitution for future use in either
  // `canonicalTypes` or `canonicalHeapTypes`.
  template<typename T>
  void canonicalize(T* type, std::unordered_map<T, T>& canonicals);
};

// Traverse the type graph rooted at the initialized HeapTypeInfos in reverse
// postorder, replacing in place all Types and HeapTypes backed by the
// TypeBuilder's Stores with equivalent globally canonicalized Types and
// HeapTypes.
Canonicalizer::Canonicalizer(TypeBuilder& builder) : builder(builder) {
  // Initialize `results` to hold all the temporary HeapTypes. Since we are
  // canonicalizing all Types and HeapTypes in place, this will end up holding
  // all the canonicalized HeapTypes instead. Also seed the scan list with these
  // HeapTypes.
  results.reserve(builder.impl->entries.size());
  for (auto& entry : builder.impl->entries) {
    assert(entry.initialized && "Cannot access uninitialized HeapType");
    results.push_back(entry.get());
    scanList.push_back(&results.back());
  }

  // Traverse the type graph reachable from the heap types, calculating
  // reachability and collecting a list of types and heap types that need to be
  // canonicalized.
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

  findSelfReferentialHeapTypes();

  // Visit the use sites of Types and HeapTypes, replacing them with their
  // canonicalized versions in an order that guarantees no temporary types will
  // be leaked into the global stores.
  for (auto it : getOrderedItems()) {
    switch (it.kind) {
      case Item::TypeKind:
        canonicalize(it.type, canonicalTypes);
        break;
      case Item::HeapTypeKind:
        canonicalize(it.heapType, canonicalHeapTypes);
        break;
    }
  }

  // Now that all other Types and HeapTypes have been canonicalized, move
  // self-referential HeapTypes to the global store so that they will be
  // considered canonical and outlive the TypeBuilder.
  std::lock_guard<std::mutex> lock(globalHeapTypeStore.mutex);
  for (auto& entry : builder.impl->entries) {
    if (selfReferentialHeapTypes.count(entry.get())) {
      globalHeapTypeStore.recordCanonical(std::move(entry.info));
    }
  }
}

template<typename T1, typename T2>
void Canonicalizer::noteChild(T1 parent, T2* child) {
  if (child->isCompound()) {
    children[parent.getID()].insert(child->getID());
    scanList.push_back(child);
  }
}

void Canonicalizer::scanHeapType(HeapType* ht) {
  assert(ht->isCompound());
  heapTypeLocations[*ht].push_back(ht);
  if (scanned.count(ht->getID())) {
    return;
  }
  scanned.insert(ht->getID());

  auto* info = getHeapTypeInfo(*ht);
  switch (info->kind) {
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

void Canonicalizer::scanType(Type* type) {
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

void Canonicalizer::findSelfReferentialHeapTypes() {
  // Use Tarjan's strongly connected components algorithm on the parent-child
  // graph to find self-referential types in O(|V|+|E|) time. Each HeapType in a
  // strongly connected component with multiple elements must be
  // self-referential because it is mutually recursive with all other HeapTypes
  // in that strongly connected component. HeapTypes in strongly connected
  // components of size one may also be self-referential, but it is trivial to
  // find these because they must be their own direct children. See
  // https://en.wikipedia.org/wiki/Tarjan%27s_strongly_connected_components_algorithm.

  // Get the HeapType children of a HeapType, skipping all intermediate Types.
  auto getChildren = [&](HeapType type) {
    std::unordered_set<HeapType> results;
    std::function<void(TypeID, bool)> visit = [&](TypeID id, bool isRoot) {
      if (isRoot || typeLocations.count(Type(id))) {
        auto it = children.find(id);
        if (it != children.end()) {
          for (TypeID child : it->second) {
            visit(child, false);
          }
        }
      } else {
        results.insert(HeapType(id));
      }
    };
    visit(type.getID(), true);
    return results;
  };

  // The Tarjan's algorithm stack. Similar to a DFS stack, but elements are only
  // popped off once they are committed to a strongly connected component.
  // HeapTypes stay on the stack after they are visited iff they have a back
  // edge to a HeapType earlier in the stack.
  std::vector<HeapType> stack;
  std::unordered_set<HeapType> stackElems;
  // Indices assigned to each HeapType in the order they are visited.
  std::unordered_map<HeapType, size_t> indices;
  // The smallest index of the HeapTypes reachable from each HeapType through
  // its subtree.
  std::unordered_map<HeapType, size_t> minReachable;

  std::function<void(HeapType)> visit = [&](HeapType curr) {
    size_t index = indices.size();
    indices[curr] = index;
    minReachable[curr] = index;
    stack.push_back(curr);
    stackElems.insert(curr);

    for (HeapType child : getChildren(curr)) {
      if (!indices.count(child)) {
        // Child has not been visited yet; visit it.
        visit(child);
        minReachable[curr] = std::min(minReachable[curr], minReachable[child]);
      } else if (stackElems.count(child)) {
        // Child was already visited but not committed to a strongly connected
        // component.
        minReachable[curr] = std::min(minReachable[curr], indices[child]);
      }
      // We cannot differentiate self-referential types with strongly connected
      // component size one from non-self-referential types just by looking at
      // the strongly connected components. If a type is directly
      // self-referential, mark it here so we don't miss it later.
      if (child == curr) {
        selfReferentialHeapTypes.insert(child);
      }
    }

    if (minReachable[curr] == indices[curr]) {
      // Curr doesn't have any back edges to an earlier element, so it is the
      // root of the strongly connected component including itself and anything
      // after it still on the stack. If this strongly connected component has
      // more than one element, they are all self referential HeapTypes.
      // Self-referential types with SCC size one were already accounted for.
      if (stack.back() != curr) {
        selfReferentialHeapTypes.insert(curr);
        while (stack.back() != curr) {
          selfReferentialHeapTypes.insert(stack.back());
          stackElems.erase(stack.back());
          stack.pop_back();
        }
      }
      stack.pop_back();
      stackElems.erase(curr);
    }
  };

  for (auto& entry : builder.impl->entries) {
    visit(entry.get());
  }
}

std::vector<Canonicalizer::Item> Canonicalizer::getOrderedItems() {
  // In order to canonicalize Types and HeapTypes without leaking any temporary
  // types into the global type store, we need to canonicalize children before
  // parents. In the case of recursive types, this is not possible due to cycles
  // in the parent-child relation. In principle that can be overcome by
  // canonicalizing type structures rather than type contents, but for now we
  // instead cut corners and break the cycles by skipping canonicalization of
  // self-referential HeapTypes. This works because the path from any Type or
  // HeapType to itself in the parent-child relation must go through some
  // self-referential HeapType; it is not possible to have a cycle composed only
  // of Types, for example. In effect this means that we have a nominal type
  // system for self-referential HeapTypes and a structural type system for
  // everything else. Eventually we will have to implement something more
  // consistent, but this is good enough for getting prototype toolchains up and
  // running.

  // TODO: None of this is particularly optimized. Benchmark to see if this is a
  // significant bottleneck and investigate using better data structures and
  // algorithms.

  // Remove self-referential HeapTypes to cut cycles.
  auto childrenDAG = children;
  for (HeapType type : selfReferentialHeapTypes) {
    childrenDAG.erase(type.getID());
    for (auto& kv : childrenDAG) {
      kv.second.erase(type.getID());
    }
  }

  // Collect the remaining types that will be sorted.
  std::unordered_set<TypeID> toSort;
  for (auto& entry : builder.impl->entries) {
    HeapType curr = entry.get();
    if (!selfReferentialHeapTypes.count(curr)) {
      toSort.insert(curr.getID());
    }
  }
  for (auto& kv : childrenDAG) {
    toSort.insert(kv.first);
    for (auto& child : kv.second) {
      toSort.insert(child);
    }
  }

  // Topologically sort so that children come before their parents.
  std::vector<TypeID> sorted;
  std::unordered_set<TypeID> seen;
  std::function<void(TypeID)> visit = [&](TypeID id) {
    if (seen.count(id)) {
      return;
    }
    // Push children of the current type before pushing the current type.
    auto it = childrenDAG.find(id);
    if (it != childrenDAG.end()) {
      for (auto child : it->second) {
        visit(child);
      }
    }
    seen.insert(id);
    sorted.push_back(id);
  };
  for (TypeID i : toSort) {
    visit(i);
  }

  // Expand the ordered types into ordered type use sites.
  std::vector<Item> items;
  for (TypeID id : sorted) {
    // IDs may be Types or HeapTypes, so just try both.
    if (typeLocations.count(Type(id))) {
      for (Type* loc : typeLocations[Type(id)]) {
        items.emplace_back(loc);
      }
    } else {
      for (HeapType* loc : heapTypeLocations[HeapType(id)]) {
        items.emplace_back(loc);
      }
    }
  }
  return items;
}

template<typename T>
void Canonicalizer::canonicalize(T* type,
                                 std::unordered_map<T, T>& canonicals) {
  auto it = canonicals.find(*type);
  if (it != canonicals.end()) {
    *type = it->second;
  } else {
    // Get the globally canonicalized version of the type
    auto* info = MetaTypeInfo<T>::getInfo(*type);
    T canonical = MetaTypeInfo<T>::globalStore.canonicalize(*info);
    canonicals.insert({*type, canonical});
    *type = canonical;
  }
}

} // anonymous namespace

std::vector<HeapType> TypeBuilder::build() {
  return Canonicalizer(*this).results;
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

size_t hash<wasm::TypeInfo>::operator()(const wasm::TypeInfo& info) const {
  auto digest = wasm::hash(info.kind);
  switch (info.kind) {
    case wasm::TypeInfo::TupleKind:
      wasm::rehash(digest, info.tuple);
      return digest;
    case wasm::TypeInfo::RefKind:
      wasm::rehash(digest, info.ref.heapType);
      wasm::rehash(digest, info.ref.nullable);
      return digest;
    case wasm::TypeInfo::RttKind:
      wasm::rehash(digest, info.rtt);
      return digest;
  }
  WASM_UNREACHABLE("unexpected kind");
}

size_t hash<wasm::HeapTypeInfo>::
operator()(const wasm::HeapTypeInfo& info) const {
  auto digest = wasm::hash(info.kind);
  switch (info.kind) {
    case wasm::HeapTypeInfo::SignatureKind:
      wasm::rehash(digest, info.signature);
      return digest;
    case wasm::HeapTypeInfo::StructKind:
      wasm::rehash(digest, info.struct_);
      return digest;
    case wasm::HeapTypeInfo::ArrayKind:
      wasm::rehash(digest, info.array);
      return digest;
  }
  WASM_UNREACHABLE("unexpected kind");
}

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
  // Note that the name is not hashed here - it is pure metadata for printing
  // purposes only.
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
