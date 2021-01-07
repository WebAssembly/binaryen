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
  bool operator<(const TypeInfo& other) const;
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

  HeapTypeInfo& operator=(const HeapTypeInfo& other);
  bool operator==(const HeapTypeInfo& other) const;
  bool operator!=(const HeapTypeInfo& other) const { return !(*this == other); }
  bool operator<(const HeapTypeInfo& other) const;
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

bool TypeInfo::operator<(const TypeInfo& other) const {
  if (kind != other.kind) {
    return kind < other.kind;
  }
  switch (kind) {
    case TupleKind:
      return tuple < other.tuple;
    case RefKind:
      if (ref.nullable != other.ref.nullable) {
        return ref.nullable < other.ref.nullable;
      }
      return ref.heapType < other.ref.heapType;
    case RttKind:
      return rtt < other.rtt;
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

bool HeapTypeInfo::operator<(const HeapTypeInfo& other) const {
  if (kind != other.kind) {
    return kind < other.kind;
  }
  switch (kind) {
    case SignatureKind:
      return signature < other.signature;
    case StructKind:
      return struct_ < other.struct_;
    case ArrayKind:
      return array < other.array;
  }
  WASM_UNREACHABLE("unexpected kind");
}

template<typename Info> struct Store {
  std::mutex mutex;

  // Track unique_ptrs for constructed types to avoid leaks.
  std::vector<std::unique_ptr<Info>> constructedTypes;

  // Maps from constructed types to their canonical Type IDs.
  std::unordered_map<Info, uintptr_t> typeIDs;

  typename Info::type_t canonicalize(const Info& info) {
    std::lock_guard<std::mutex> lock(mutex);
    auto indexIt = typeIDs.find(info);
    if (indexIt != typeIDs.end()) {
      return typename Info::type_t(indexIt->second);
    }
    auto ptr = std::make_unique<Info>(info);
    auto id = uintptr_t(ptr.get());
    constructedTypes.push_back(std::move(ptr));
    assert(id > Info::type_t::_last_basic_type);
    typeIDs[info] = id;
    return typename Info::type_t(id);
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
          case HeapType::exn:
            return Type::exnref;
          case HeapType::any:
            return Type::anyref;
          case HeapType::eq:
            return Type::eqref;
          case HeapType::i31:
            break;
        }
      } else {
        if (info.ref.heapType == HeapType::i31) {
          return Type::i31ref;
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
    return id >= funcref && id <= i31ref;
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

bool Type::isException() const {
  if (isBasic()) {
    return id == exnref;
  } else {
    auto* info = getTypeInfo(*this);
    return info->isRef() && info->ref.heapType == HeapType::exn;
  }
}

bool Type::isNullable() const {
  if (isBasic()) {
    return id >= funcref && id <= eqref; // except i31ref
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

bool Type::operator<(const Type& other) const {
  if (*this == other) {
    return false;
  }
  if (isBasic() && other.isBasic()) {
    return getBasic() < other.getBasic();
  }
  if (isBasic()) {
    return true;
  }
  if (other.isBasic()) {
    return false;
  }
  return *getTypeInfo(*this) < *getTypeInfo(other);
};

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
      case Type::exnref:
      case Type::anyref:
      case Type::eqref:
      case Type::i31ref:
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
          case HeapType::BasicHeapType::exn:
            return FeatureSet::ReferenceTypes | FeatureSet::ExceptionHandling;
          case HeapType::BasicHeapType::any:
          case HeapType::BasicHeapType::eq:
          case HeapType::BasicHeapType::i31:
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
      case Type::exnref:
        return HeapType::exn;
      case Type::anyref:
        return HeapType::any;
      case Type::eqref:
        return HeapType::eq;
      case Type::i31ref:
        return HeapType::i31;
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
  if (left == right) {
    return true;
  }
  if (left.isRef() && right.isRef()) {
    // Everything is a subtype of anyref.
    if (right == Type::anyref) {
      return true;
    }
    // Various things are subtypes of eqref.
    auto leftHeap = left.getHeapType();
    auto rightHeap = right.getHeapType();
    if ((leftHeap == HeapType::i31 || leftHeap.isArray() ||
         leftHeap.isStruct()) &&
        rightHeap == HeapType::eq &&
        (!left.isNullable() || right.isNullable())) {
      return true;
    }
    // All typed function signatures are subtypes of funcref.
    if (leftHeap.isSignature() && rightHeap == HeapType::func &&
        (!left.isNullable() || right.isNullable())) {
      return true;
    }
    // A non-nullable type is a supertype of a nullable one
    if (leftHeap == rightHeap && !left.isNullable()) {
      // The only difference is the nullability.
      assert(right.isNullable());
      return true;
    }
    return false;
  }
  if (left.isTuple() && right.isTuple()) {
    if (left.size() != right.size()) {
      return false;
    }
    for (size_t i = 0; i < left.size(); ++i) {
      if (!isSubType(left[i], right[i])) {
        return false;
      }
    }
    return true;
  }
  if (left.isRtt() && right.isRtt()) {
    auto leftRtt = left.getRtt();
    auto rightRtt = right.getRtt();
    // (rtt n $x) is a subtype of (rtt $x), that is, if the only difference in
    // information is that the left side specifies a depth while the right side
    // allows any depth.
    return leftRtt.heapType == rightRtt.heapType && leftRtt.hasDepth() &&
           !rightRtt.hasDepth();
  }
  return false;
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
  if (a.isRef()) {
    if (b.isRef()) {
      if (a.isFunction() && b.isFunction()) {
        return Type::funcref;
      }
      if ((a == Type::i31ref && b == Type::eqref) ||
          (a == Type::eqref && b == Type::i31ref)) {
        return Type::eqref;
      }
      // The LUB of two different reference types is anyref, which may or may
      // not be a valid type depending on whether the anyref feature is enabled.
      // When anyref is disabled, it is possible for the finalization of invalid
      // code to introduce a use of anyref via this function, but that is not a
      // problem because it will be caught and rejected by validation.
      return Type::anyref;
    }
    return Type::none;
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

bool HeapType::operator<(const HeapType& other) const {
  if (*this == other) {
    return false;
  }
  if (isBasic() && other.isBasic()) {
    return getBasic() < other.getBasic();
  }
  if (isBasic()) {
    return true;
  }
  if (other.isBasic()) {
    return false;
  }
  return *getHeapTypeInfo(*this) < *getHeapTypeInfo(other);
}

bool HeapType::isArray() const {
  if (isBasic()) {
    return false;
  } else {
    return getHeapTypeInfo(*this)->isArray();
  }
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

bool Signature::operator<(const Signature& other) const {
  if (results != other.results) {
    return results < other.results;
  }
  return params < other.params;
}

bool Field::operator<(const Field& other) const {
  if (mutable_ != other.mutable_) {
    return mutable_ < other.mutable_;
  }
  if (type == Type::i32 && other.type == Type::i32) {
    return packedType < other.packedType;
  }
  return type < other.type;
}

bool Rtt::operator<(const Rtt& other) const {
  if (depth != other.depth) {
    return depth < other.depth;
  }
  return heapType < other.heapType;
}

namespace {

std::ostream&
printPrefixedTypes(std::ostream& os, const char* prefix, Type type) {
  os << '(' << prefix;
  for (const auto& t : type) {
    os << " " << t;
  }
  os << ')';
  return os;
}

template<typename T> std::string genericToString(const T& t) {
  std::ostringstream ss;
  ss << t;
  return ss.str();
}

} // anonymous namespace

std::string Type::toString() const { return genericToString(*this); }

std::string ParamType::toString() const { return genericToString(*this); }

std::string ResultType::toString() const { return genericToString(*this); }

std::string Tuple::toString() const { return genericToString(*this); }

std::string Signature::toString() const { return genericToString(*this); }

std::string Struct::toString() const { return genericToString(*this); }

std::string Array::toString() const { return genericToString(*this); }

std::string HeapType::toString() const { return genericToString(*this); }

std::string Rtt::toString() const { return genericToString(*this); }

std::ostream& operator<<(std::ostream&, TypeInfo);
std::ostream& operator<<(std::ostream&, HeapTypeInfo);

std::ostream& operator<<(std::ostream& os, Type type) {
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
      case Type::exnref:
        return os << "exnref";
      case Type::anyref:
        return os << "anyref";
      case Type::eqref:
        return os << "eqref";
      case Type::i31ref:
        return os << "i31ref";
    }
  }
  return os << *getTypeInfo(type);
}

std::ostream& operator<<(std::ostream& os, ParamType param) {
  return printPrefixedTypes(os, "param", param.type);
}

std::ostream& operator<<(std::ostream& os, ResultType param) {
  return printPrefixedTypes(os, "result", param.type);
}

std::ostream& operator<<(std::ostream& os, Tuple tuple) {
  auto& types = tuple.types;
  auto size = types.size();
  os << "(";
  if (size) {
    os << types[0];
    for (size_t i = 1; i < size; ++i) {
      os << " " << types[i];
    }
  }
  return os << ")";
}

std::ostream& operator<<(std::ostream& os, Signature sig) {
  os << "(func";
  if (sig.params.getID() != Type::none) {
    os << " ";
    printPrefixedTypes(os, "param", sig.params);
  }
  if (sig.results.getID() != Type::none) {
    os << " ";
    printPrefixedTypes(os, "result", sig.results);
  }
  return os << ")";
}

std::ostream& operator<<(std::ostream& os, Field field) {
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
    os << field.type;
  }
  if (field.mutable_) {
    os << ")";
  }
  return os;
};

std::ostream& operator<<(std::ostream& os, Struct struct_) {
  os << "(struct";
  if (struct_.fields.size()) {
    os << " (field";
    for (auto f : struct_.fields) {
      os << " " << f;
    }
    os << ")";
  }
  return os << ")";
}

std::ostream& operator<<(std::ostream& os, Array array) {
  return os << "(array " << array.element << ")";
}

std::ostream& operator<<(std::ostream& os, HeapType heapType) {
  if (heapType.isBasic()) {
    switch (heapType.getBasic()) {
      case HeapType::func:
        return os << "func";
      case HeapType::ext:
        return os << "extern";
      case HeapType::exn:
        return os << "exn";
      case HeapType::any:
        return os << "any";
      case HeapType::eq:
        return os << "eq";
      case HeapType::i31:
        return os << "i31";
    }
  }
  return os << *getHeapTypeInfo(heapType);
}

std::ostream& operator<<(std::ostream& os, Rtt rtt) {
  return os << "(rtt " << rtt.depth << " " << rtt.heapType << ")";
}

std::ostream& operator<<(std::ostream& os, TypeInfo info) {
  switch (info.kind) {
    case TypeInfo::TupleKind: {
      return os << info.tuple;
    }
    case TypeInfo::RefKind: {
      os << "(ref ";
      if (info.ref.nullable) {
        os << "null ";
      }
      return os << info.ref.heapType << ")";
    }
    case TypeInfo::RttKind: {
      return os << info.rtt;
    }
  }
  WASM_UNREACHABLE("unexpected kind");
}

std::ostream& operator<<(std::ostream& os, HeapTypeInfo info) {
  switch (info.kind) {
    case HeapTypeInfo::SignatureKind:
      return os << info.signature;
    case HeapTypeInfo::StructKind:
      return os << info.struct_;
    case HeapTypeInfo::ArrayKind:
      return os << info.array;
  }
  WASM_UNREACHABLE("unexpected kind");
}

struct TypeBuilder::Impl {
  TypeStore typeStore;
  HeapTypeStore heapTypeStore;

  struct Entry {
    // HeapTypeInfo has no default constructor, so pick an arbitrary default.
    HeapTypeInfo info = Signature();
    bool initialized = false;
    void set(HeapTypeInfo&& hti) {
      info = hti;
      initialized = true;
    }
    HeapType get() { return HeapType(TypeID(&info)); }
  };

  std::vector<Entry> entries;
};

TypeBuilder::TypeBuilder(size_t n) {
  impl = std::make_unique<TypeBuilder::Impl>();
  impl->entries.resize(n);
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

  // The list of Types and HeapTypes to visit constructed in forward preorder
  // and eventually traversed in reverse to give a reverse postorder.
  std::vector<Item> visitList;

  // Maps Type and HeapType IDs to the IDs of Types and HeapTypes they can
  // reach in the type graph. Only considers compound Types and HeapTypes.
  std::unordered_map<TypeID, std::unordered_set<TypeID>> reaches;

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
  void makeReachabilityFixedPoint();

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
  // canonicalized. We must scan in depth-first order so that we can do a
  // postorder traversal later.
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

  // Check for recursive types and heap types. TODO: pre-canonicalize these into
  // their minimal finite representations.
  makeReachabilityFixedPoint();
  for (auto& reach : reaches) {
    if (reach.second.count(reach.first) != 0) {
      WASM_UNREACHABLE("TODO: support recursive types");
    }
  }

  // Visit the types and heap types in reverse postorder, replacing them with
  // their canonicalized versions.
  for (auto it = visitList.rbegin(); it != visitList.rend(); ++it) {
    switch (it->kind) {
      case Item::TypeKind:
        canonicalize(it->type, canonicalTypes);
        break;
      case Item::HeapTypeKind:
        canonicalize(it->heapType, canonicalHeapTypes);
        break;
    }
  }
}

template<typename T1, typename T2>
void Canonicalizer::noteChild(T1 parent, T2* child) {
  if (child->isCompound()) {
    reaches[parent.getID()].insert(child->getID());
    scanList.push_back(child);
  }
}

void Canonicalizer::scanHeapType(HeapType* ht) {
  assert(ht->isCompound());
  visitList.push_back(ht);
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
  visitList.push_back(type);
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

void Canonicalizer::makeReachabilityFixedPoint() {
  // Naively calculate the transitive closure of the reachability graph.
  bool changed;
  do {
    changed = false;
    for (auto& entry : reaches) {
      auto& reachable = entry.second;
      std::unordered_set<TypeID> nextReachable;
      for (auto& other : reachable) {
        auto& otherReaches = reaches[other];
        nextReachable.insert(otherReaches.begin(), otherReaches.end());
      }
      size_t oldSize = reachable.size();
      reachable.insert(nextReachable.begin(), nextReachable.end());
      if (reachable.size() != oldSize) {
        changed = true;
      }
    }
  } while (changed);
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
