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

#include "compiler-support.h"
#include "support/hash.h"
#include "wasm-features.h"
#include "wasm-type.h"

namespace wasm {

struct TypeInfo {
  enum Kind {
    TupleKind,
    RefKind,
    RttKind,
  } kind;
  struct Ref {
    HeapType heapType;
    bool nullable;
  };
  union {
    Tuple tuple;
    Ref ref;
    Rtt rtt;
  };

  TypeInfo(const Tuple& tuple) : kind(TupleKind), tuple(tuple) {}
  TypeInfo(Tuple&& tuple) : kind(TupleKind), tuple(std::move(tuple)) {}
  TypeInfo(const HeapType& heapType, bool nullable)
    : kind(RefKind), ref{heapType, nullable} {}
  TypeInfo(HeapType&& heapType, bool nullable)
    : kind(RefKind), ref{std::move(heapType), nullable} {}
  TypeInfo(const Rtt& rtt) : kind(RttKind), rtt(rtt) {}
  TypeInfo(Rtt&& rtt) : kind(RttKind), rtt(std::move(rtt)) {}
  TypeInfo(const TypeInfo& other) {
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
  ~TypeInfo() {
    switch (kind) {
      case TupleKind: {
        tuple.~Tuple();
        return;
      }
      case RefKind: {
        ref.~Ref();
        return;
      }
      case RttKind: {
        rtt.~Rtt();
        return;
      }
    }
    WASM_UNREACHABLE("unexpected kind");
  }

  constexpr bool isTuple() const { return kind == TupleKind; }
  constexpr bool isRef() const { return kind == RefKind; }
  constexpr bool isRtt() const { return kind == RttKind; }

  bool isNullable() const { return kind == RefKind && ref.nullable; }

  bool operator==(const TypeInfo& other) const {
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
  bool operator!=(const TypeInfo& other) const { return !(*this == other); }
  TypeInfo& operator=(const TypeInfo& other) {
    if (&other != this) {
      this->~TypeInfo();
      new (this) auto(other);
    }
    return *this;
  }

  std::string toString() const;
};

std::ostream& operator<<(std::ostream&, TypeInfo);

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

template<> class hash<wasm::TypeInfo> {
public:
  size_t operator()(const wasm::TypeInfo& info) const {
    auto digest = wasm::hash(info.kind);
    switch (info.kind) {
      case wasm::TypeInfo::TupleKind: {
        wasm::rehash(digest, info.tuple);
        return digest;
      }
      case wasm::TypeInfo::RefKind: {
        wasm::rehash(digest, info.ref.heapType);
        wasm::rehash(digest, info.ref.nullable);
        return digest;
      }
      case wasm::TypeInfo::RttKind: {
        wasm::rehash(digest, info.rtt);
        return digest;
      }
    }
    WASM_UNREACHABLE("unexpected kind");
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
  auto digest = wasm::hash(heapType.kind);
  switch (heapType.kind) {
    case wasm::HeapType::FuncKind:
    case wasm::HeapType::ExternKind:
    case wasm::HeapType::AnyKind:
    case wasm::HeapType::EqKind:
    case wasm::HeapType::I31Kind:
    case wasm::HeapType::ExnKind:
      return digest;
    case wasm::HeapType::SignatureKind:
      wasm::rehash(digest, heapType.signature);
      return digest;
    case wasm::HeapType::StructKind:
      wasm::rehash(digest, heapType.struct_);
      return digest;
    case wasm::HeapType::ArrayKind:
      wasm::rehash(digest, heapType.array);
      return digest;
  }
  WASM_UNREACHABLE("unexpected kind");
}

size_t hash<wasm::Rtt>::operator()(const wasm::Rtt& rtt) const {
  auto digest = wasm::hash(rtt.depth);
  wasm::rehash(digest, rtt.heapType);
  return digest;
}

} // namespace std

namespace wasm {

namespace {

std::mutex mutex;

// Track unique_ptrs for constructed types to avoid leaks
std::vector<std::unique_ptr<TypeInfo>> constructedTypes;

// Maps from constructed types to the canonical Type ID.
std::unordered_map<TypeInfo, uintptr_t> indices = {
  // If a Type is constructed from a list of types, the list of types becomes
  // implicitly converted to a TypeInfo before canonicalizing its id. This is
  // also the case if a list of just one type is provided, even though such a
  // list of types will be canonicalized to the BasicID of the single type. As
  // such, the following entries are solely placeholders to enable the lookup
  // of lists of just one type to the BasicID of the single type.
  {TypeInfo(Tuple()), Type::none},
  {TypeInfo({Type::unreachable}), Type::unreachable},
  {TypeInfo({Type::i32}), Type::i32},
  {TypeInfo({Type::i64}), Type::i64},
  {TypeInfo({Type::f32}), Type::f32},
  {TypeInfo({Type::f64}), Type::f64},
  {TypeInfo({Type::v128}), Type::v128},
  {TypeInfo({Type::funcref}), Type::funcref},
  {TypeInfo(HeapType(HeapType::FuncKind), true), Type::funcref},
  {TypeInfo({Type::externref}), Type::externref},
  {TypeInfo(HeapType(HeapType::ExternKind), true), Type::externref},
  {TypeInfo({Type::exnref}), Type::exnref},
  {TypeInfo(HeapType(HeapType::ExnKind), true), Type::exnref},
  {TypeInfo({Type::anyref}), Type::anyref},
  {TypeInfo(HeapType(HeapType::AnyKind), true), Type::anyref},
  // TODO (GC): Add canonical ids
  // * `(ref null eq) == eqref`
  // * `(ref i31) == i31ref`
};

} // anonymous namespace

static uintptr_t canonicalize(const TypeInfo& info) {
  std::lock_guard<std::mutex> lock(mutex);
  auto indexIt = indices.find(info);
  if (indexIt != indices.end()) {
    return indexIt->second;
  }
  auto ptr = std::make_unique<TypeInfo>(info);
  auto id = uintptr_t(ptr.get());
  constructedTypes.push_back(std::move(ptr));
  assert(id > Type::_last_basic_id);
  indices[info] = id;
  return id;
}

static TypeInfo* getTypeInfo(const Type& type) {
  return (TypeInfo*)type.getID();
}

Type::Type(std::initializer_list<Type> types) : Type(Tuple(types)) {}

Type::Type(const Tuple& tuple) {
  auto& types = tuple.types;
#ifndef NDEBUG
  for (Type t : types) {
    assert(t.isSingle());
  }
#endif
  if (types.size() == 0) {
    id = none;
    return;
  }
  if (types.size() == 1) {
    *this = types[0];
    return;
  }
  id = canonicalize(TypeInfo(tuple));
}

Type::Type(const HeapType& heapType, bool nullable) {
#ifndef NDEBUG
  switch (heapType.kind) {
    case HeapType::FuncKind:
    case HeapType::ExternKind:
    case HeapType::AnyKind:
    case HeapType::EqKind:
    case HeapType::I31Kind:
    case HeapType::ExnKind:
    case HeapType::SignatureKind:
      break;
    case HeapType::StructKind:
      for (Field f : heapType.struct_.fields) {
        assert(f.type.isSingle());
      }
      break;
    case HeapType::ArrayKind:
      assert(heapType.array.element.type.isSingle());
      break;
  }
#endif
  id = canonicalize(TypeInfo(heapType, nullable));
}

Type::Type(const Rtt& rtt) { id = canonicalize(TypeInfo(rtt)); }

bool Type::isTuple() const {
  if (isBasic()) {
    return false;
  } else {
    return getTypeInfo(*this)->isTuple();
  }
}

bool Type::isRef() const {
  if (isBasic()) {
    return id >= funcref && id <= anyref;
  } else {
    return getTypeInfo(*this)->isRef();
  }
}

bool Type::isFunction() const {
  if (isBasic()) {
    return id == funcref;
  } else {
    auto* info = getTypeInfo(*this);
    return info->isRef() && info->ref.heapType.isSignature();
  }
}

bool Type::isException() const {
  if (isBasic()) {
    return id == exnref;
  } else {
    auto* info = getTypeInfo(*this);
    return info->isRef() && info->ref.heapType.isException();
  }
}

bool Type::isNullable() const {
  if (isBasic()) {
    return id >= funcref && id <= anyref;
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

bool Type::operator<(const Type& other) const {
  return std::lexicographical_compare(begin(),
                                      end(),
                                      other.begin(),
                                      other.end(),
                                      [](const Type& a, const Type& b) {
                                        TODO_SINGLE_COMPOUND(a);
                                        TODO_SINGLE_COMPOUND(b);
                                        return a.getBasic() < b.getBasic();
                                      });
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
      case Type::exnref:
      case Type::anyref:
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
    TODO_SINGLE_COMPOUND(t);
    switch (t.getBasic()) {
      case Type::v128:
        return FeatureSet::SIMD;
      case Type::funcref:
      case Type::externref:
        return FeatureSet::ReferenceTypes;
      case Type::exnref:
        return FeatureSet::ReferenceTypes | FeatureSet::ExceptionHandling;
      case Type::anyref:
        return FeatureSet::ReferenceTypes | FeatureSet::Anyref;
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
  if (isRef()) {
    if (isCompound()) {
      return getTypeInfo(*this)->ref.heapType;
    }
    switch (getBasic()) {
      case funcref:
        return HeapType::FuncKind;
      case externref:
        return HeapType::ExternKind;
      case exnref:
        return HeapType::ExnKind;
      case anyref:
        return HeapType::AnyKind;
      default:
        break;
    }
  }
  WASM_UNREACHABLE("unexpected type");
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
    return right == Type::anyref;
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
    // FIXME: `anyref` is only valid here if the `anyref` feature is enabled,
    // but this information is not available within `Type` alone.
    return b.isRef() ? Type::anyref : Type::none;
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

HeapType::HeapType(const HeapType& other) : kind(other.kind) {
  switch (kind) {
    case FuncKind:
    case ExternKind:
    case AnyKind:
    case EqKind:
    case I31Kind:
    case ExnKind:
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

HeapType::~HeapType() {
  switch (kind) {
    case FuncKind:
    case ExternKind:
    case AnyKind:
    case EqKind:
    case I31Kind:
    case ExnKind:
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
}

bool HeapType::operator==(const HeapType& other) const {
  if (kind != other.kind) {
    return false;
  }
  switch (kind) {
    case FuncKind:
    case ExternKind:
    case AnyKind:
    case EqKind:
    case I31Kind:
    case ExnKind:
      return true;
    case SignatureKind:
      return signature == other.signature;
    case StructKind:
      return struct_ == other.struct_;
    case ArrayKind:
      return array == other.array;
  }
  WASM_UNREACHABLE("unexpected kind");
}

HeapType& HeapType::operator=(const HeapType& other) {
  if (&other != this) {
    this->~HeapType();
    new (this) auto(other);
  }
  return *this;
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

std::string TypeInfo::toString() const { return genericToString(*this); }

bool Signature::operator<(const Signature& other) const {
  if (results < other.results) {
    return true;
  } else if (other.results < results) {
    return false;
  } else {
    return params < other.params;
  }
}

std::ostream& operator<<(std::ostream& os, Type type) {
  if (type.isBasic()) {
    switch (type.getBasic()) {
      case Type::none:
        os << "none";
        break;
      case Type::unreachable:
        os << "unreachable";
        break;
      case Type::i32:
        os << "i32";
        break;
      case Type::i64:
        os << "i64";
        break;
      case Type::f32:
        os << "f32";
        break;
      case Type::f64:
        os << "f64";
        break;
      case Type::v128:
        os << "v128";
        break;
      case Type::funcref:
        os << "funcref";
        break;
      case Type::externref:
        os << "externref";
        break;
      case Type::exnref:
        os << "exnref";
        break;
      case Type::anyref:
        os << "anyref";
        break;
    }
  } else {
    os << *getTypeInfo(type);
  }
  return os;
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
  switch (heapType.kind) {
    case wasm::HeapType::FuncKind:
      return os << "func";
    case wasm::HeapType::ExternKind:
      return os << "extern";
    case wasm::HeapType::AnyKind:
      return os << "any";
    case wasm::HeapType::EqKind:
      return os << "eq";
    case wasm::HeapType::I31Kind:
      return os << "i31";
    case wasm::HeapType::ExnKind:
      return os << "exn";
    case wasm::HeapType::SignatureKind:
      return os << heapType.signature;
    case wasm::HeapType::StructKind:
      return os << heapType.struct_;
    case wasm::HeapType::ArrayKind:
      return os << heapType.array;
  }
  WASM_UNREACHABLE("unexpected kind");
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

} // namespace wasm
