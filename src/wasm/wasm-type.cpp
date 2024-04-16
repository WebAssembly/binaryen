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
#include <map>
#include <shared_mutex>
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <variant>

#include "compiler-support.h"
#include "support/hash.h"
#include "support/insert_ordered.h"
#include "wasm-features.h"
#include "wasm-type-printing.h"
#include "wasm-type.h"

#define TRACE_CANONICALIZATION 0

#if TRACE_CANONICALIZATION
#include <iostream>
#endif

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
  } kind;
  struct Ref {
    HeapType heapType;
    Nullability nullability;
  };
  union {
    Tuple tuple;
    Ref ref;
  };

  TypeInfo(const Tuple& tuple) : kind(TupleKind), tuple(tuple) {}
  TypeInfo(Tuple&& tuple) : kind(TupleKind), tuple(std::move(tuple)) {}
  TypeInfo(HeapType heapType, Nullability nullable)
    : kind(RefKind), ref{heapType, nullable} {}
  TypeInfo(const TypeInfo& other);
  ~TypeInfo();

  constexpr bool isTuple() const { return kind == TupleKind; }
  constexpr bool isRef() const { return kind == RefKind; }

  // If this TypeInfo represents a Type that can be represented more simply,
  // return that simpler Type. For example, this handles eliminating singleton
  // tuple types.
  std::optional<Type> getCanonical() const;

  bool operator==(const TypeInfo& other) const;
  bool operator!=(const TypeInfo& other) const { return !(*this == other); }
};

using RecGroupInfo = std::vector<HeapType>;

struct HeapTypeInfo {
  using type_t = HeapType;
  // Used in assertions to ensure that temporary types don't leak into the
  // global store.
  bool isTemp = false;
  bool isOpen = false;
  // The supertype of this HeapType, if it exists.
  HeapTypeInfo* supertype = nullptr;
  // The recursion group of this type or null if the recursion group is trivial
  // (i.e. contains only this type).
  RecGroupInfo* recGroup = nullptr;
  size_t recGroupIndex = 0;
  enum Kind {
    SignatureKind,
    ContinuationKind,
    StructKind,
    ArrayKind,
  } kind;
  union {
    Signature signature;
    Continuation continuation;
    Struct struct_;
    Array array;
  };

  HeapTypeInfo(Signature sig) : kind(SignatureKind), signature(sig) {}
  HeapTypeInfo(Continuation continuation)
    : kind(ContinuationKind), continuation(continuation) {}
  HeapTypeInfo(const Struct& struct_) : kind(StructKind), struct_(struct_) {}
  HeapTypeInfo(Struct&& struct_)
    : kind(StructKind), struct_(std::move(struct_)) {}
  HeapTypeInfo(Array array) : kind(ArrayKind), array(array) {}
  ~HeapTypeInfo();

  constexpr bool isSignature() const { return kind == SignatureKind; }
  constexpr bool isContinuation() const { return kind == ContinuationKind; }
  constexpr bool isStruct() const { return kind == StructKind; }
  constexpr bool isArray() const { return kind == ArrayKind; }
  constexpr bool isData() const { return isStruct() || isArray(); }
};

// Helper for coinductively checking whether a pair of Types or HeapTypes are in
// a subtype relation.
struct SubTyper {
  bool isSubType(Type a, Type b);
  bool isSubType(HeapType a, HeapType b);
  bool isSubType(const Tuple& a, const Tuple& b);
  bool isSubType(const Field& a, const Field& b);
  bool isSubType(const Signature& a, const Signature& b);
  bool isSubType(const Continuation& a, const Continuation& b);
  bool isSubType(const Struct& a, const Struct& b);
  bool isSubType(const Array& a, const Array& b);
};

// Helper for finding the equirecursive least upper bound of two types.
// Helper for printing types.
struct TypePrinter {
  // The stream we are printing to.
  std::ostream& os;

  // The default generator state if no other generator is provided.
  std::optional<DefaultTypeNameGenerator> defaultGenerator;

  // The function we call to get HeapType names.
  HeapTypeNameGenerator generator;

  TypePrinter(std::ostream& os, HeapTypeNameGenerator generator)
    : os(os), defaultGenerator(), generator(generator) {}
  TypePrinter(std::ostream& os)
    : TypePrinter(
        os, [&](HeapType type) { return defaultGenerator->getNames(type); }) {
    defaultGenerator = DefaultTypeNameGenerator{};
  }

  void printHeapTypeName(HeapType type);

  std::ostream& print(Type type);
  std::ostream& print(HeapType type);
  std::ostream& print(const Tuple& tuple);
  std::ostream& print(const Field& field);
  std::ostream& print(const Signature& sig);
  std::ostream& print(const Continuation& cont);
  std::ostream& print(const Struct& struct_,
                      const std::unordered_map<Index, Name>& fieldNames);
  std::ostream& print(const Array& array);
};

struct RecGroupHasher {
  // `group` may or may not be canonical, but any other recursion group it
  // reaches must be canonical.
  RecGroup group;

  RecGroupHasher(RecGroup group) : group(group) {}

  // Perform the hash.
  size_t operator()() const;

  // `topLevelHash` is applied to the top-level group members and observes their
  // structure, while `hash(HeapType)` is applied to the children of group
  // members and does not observe their structure.
  size_t topLevelHash(HeapType type) const;
  size_t hash(Type type) const;
  size_t hash(HeapType type) const;
  size_t hash(const TypeInfo& info) const;
  size_t hash(const HeapTypeInfo& info) const;
  size_t hash(const Tuple& tuple) const;
  size_t hash(const Field& field) const;
  size_t hash(const Signature& sig) const;
  size_t hash(const Continuation& sig) const;
  size_t hash(const Struct& struct_) const;
  size_t hash(const Array& array) const;
};

struct RecGroupEquator {
  // `newGroup` may or may not be canonical, but `otherGroup` and any other
  // recursion group reachable by either of them must be canonical.
  RecGroup newGroup, otherGroup;

  RecGroupEquator(RecGroup newGroup, RecGroup otherGroup)
    : newGroup(newGroup), otherGroup(otherGroup) {}

  // Perform the comparison.
  bool operator()() const;

  // `topLevelEq` is applied to the top-level group members and observes their
  // structure, while `eq(HeapType)` is applied to the children of group members
  // and does not observe their structure.
  bool topLevelEq(HeapType a, HeapType b) const;
  bool eq(Type a, Type b) const;
  bool eq(HeapType a, HeapType b) const;
  bool eq(const TypeInfo& a, const TypeInfo& b) const;
  bool eq(const HeapTypeInfo& a, const HeapTypeInfo& b) const;
  bool eq(const Tuple& a, const Tuple& b) const;
  bool eq(const Field& a, const Field& b) const;
  bool eq(const Signature& a, const Signature& b) const;
  bool eq(const Continuation& a, const Continuation& b) const;
  bool eq(const Struct& a, const Struct& b) const;
  bool eq(const Array& a, const Array& b) const;
};

// A wrapper around a RecGroup that provides equality and hashing based on the
// structure of the group such that isorecursively equivalent recursion groups
// will compare equal and will have the same hash. Assumes that all recursion
// groups reachable from this one have been canonicalized, except for the
// wrapped group itself.
struct RecGroupStructure {
  RecGroup group;
  bool operator==(const RecGroupStructure& other) const {
    return RecGroupEquator{group, other.group}();
  }
};

} // anonymous namespace
} // namespace wasm

namespace std {

template<> class hash<wasm::RecGroupStructure> {
public:
  size_t operator()(const wasm::RecGroupStructure& structure) const {
    return wasm::RecGroupHasher{structure.group}();
  }
};

} // namespace std

namespace wasm {
namespace {

// Generic utility for traversing type graphs. The inserted roots must live as
// long as the Walker because they are referenced by address. This base class
// only has logic for traversing type graphs; figuring out when to stop
// traversing the graph and doing useful work during the traversal is left to
// subclasses.
template<typename Self> struct TypeGraphWalkerBase {
  void walkRoot(Type* type);
  void walkRoot(HeapType* ht);

  // Override these in subclasses to do useful work.
  void preVisitType(Type* type) {}
  void preVisitHeapType(HeapType* ht) {}
  void postVisitType(Type* type) {}
  void postVisitHeapType(HeapType* ht) {}

  // This base walker does not know when to stop scanning, so at least one of
  // these needs to be overridden with a method that calls the base scanning
  // method only if some end condition isn't met.
  void scanType(Type* type);
  void scanHeapType(HeapType* ht);

private:
  struct Task {
    enum Kind {
      PreType,
      PreHeapType,
      ScanType,
      ScanHeapType,
      PostType,
      PostHeapType,
    } kind;
    union {
      Type* type;
      HeapType* heapType;
    };
    static Task preVisit(Type* type) { return Task(type, PreType); }
    static Task preVisit(HeapType* ht) { return Task(ht, PreHeapType); }
    static Task scan(Type* type) { return Task(type, ScanType); }
    static Task scan(HeapType* ht) { return Task(ht, ScanHeapType); }
    static Task postVisit(Type* type) { return Task(type, PostType); }
    static Task postVisit(HeapType* ht) { return Task(ht, PostHeapType); }

  private:
    Task(Type* type, Kind kind) : kind(kind), type(type) {}
    Task(HeapType* ht, Kind kind) : kind(kind), heapType(ht) {}
  };

  void doWalk();

  std::vector<Task> taskList;
  void push(Type* type);
  void push(HeapType* type);

  Self& self() { return *static_cast<Self*>(this); }
};

// A type graph walker base class that still does no useful work, but at least
// knows to scan each HeapType only once.
template<typename Self> struct HeapTypeGraphWalker : TypeGraphWalkerBase<Self> {
  // Override this.
  void noteHeapType(HeapType ht) {}

  void scanHeapType(HeapType* ht) {
    if (scanned.insert(*ht).second) {
      static_cast<Self*>(this)->noteHeapType(*ht);
      TypeGraphWalkerBase<Self>::scanHeapType(ht);
    }
  }

private:
  std::unordered_set<HeapType> scanned;
};

// A type graph walker base class that still does no useful work, but at least
// knows to scan each HeapType and Type only once.
template<typename Self> struct TypeGraphWalker : TypeGraphWalkerBase<Self> {
  // Override these.
  void noteType(Type type) {}
  void noteHeapType(HeapType ht) {}

  void scanType(Type* type) {
    if (scannedTypes.insert(*type).second) {
      static_cast<Self*>(this)->noteType(*type);
      TypeGraphWalkerBase<Self>::scanType(type);
    }
  }
  void scanHeapType(HeapType* ht) {
    if (scannedHeapTypes.insert(*ht).second) {
      static_cast<Self*>(this)->noteHeapType(*ht);
      TypeGraphWalkerBase<Self>::scanHeapType(ht);
    }
  }

private:
  std::unordered_set<HeapType> scannedHeapTypes;
  std::unordered_set<Type> scannedTypes;
};

// A type graph walker that only traverses the direct HeapType children of the
// root, looking through child Types. What to do with each child is left to
// subclasses.
template<typename Self> struct HeapTypeChildWalker : HeapTypeGraphWalker<Self> {
  // Override this.
  void noteChild(HeapType* child) {}

  void scanType(Type* type) {
    isTopLevel = false;
    HeapTypeGraphWalker<Self>::scanType(type);
  }
  void scanHeapType(HeapType* ht) {
    if (isTopLevel) {
      HeapTypeGraphWalker<Self>::scanHeapType(ht);
    } else {
      static_cast<Self*>(this)->noteChild(ht);
    }
    isTopLevel = false;
  }

private:
  bool isTopLevel = true;
};

struct HeapTypeChildCollector : HeapTypeChildWalker<HeapTypeChildCollector> {
  std::vector<HeapType> children;
  void noteChild(HeapType* child) { children.push_back(*child); }
};

} // anonymous namespace
} // namespace wasm

namespace std {

template<> class hash<wasm::TypeInfo> {
public:
  size_t operator()(const wasm::TypeInfo& info) const;
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
  assert(!type.isBasic());
  return (TypeInfo*)type.getID();
}

HeapTypeInfo* getHeapTypeInfo(HeapType ht) {
  assert(!ht.isBasic());
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

HeapType::BasicHeapType getBasicHeapSupertype(HeapType type) {
  if (type.isBasic()) {
    return type.getBasic();
  }
  auto* info = getHeapTypeInfo(type);
  switch (info->kind) {
    case HeapTypeInfo::SignatureKind:
      return HeapType::func;
    case HeapTypeInfo::ContinuationKind:
      return HeapType::cont;
    case HeapTypeInfo::StructKind:
      return HeapType::struct_;
    case HeapTypeInfo::ArrayKind:
      return HeapType::array;
  }
  WASM_UNREACHABLE("unexpected kind");
};

std::optional<HeapType> getBasicHeapTypeLUB(HeapType::BasicHeapType a,
                                            HeapType::BasicHeapType b) {
  if (a == b) {
    return a;
  }
  if (HeapType(a).getTop() != HeapType(b).getTop()) {
    return {};
  }
  if (HeapType(a).isBottom()) {
    return b;
  }
  if (HeapType(b).isBottom()) {
    return a;
  }
  // Canonicalize to have `a` be the lesser type.
  if (unsigned(a) > unsigned(b)) {
    std::swap(a, b);
  }
  switch (a) {
    case HeapType::ext:
    case HeapType::func:
    case HeapType::cont:
    case HeapType::exn:
      return std::nullopt;
    case HeapType::any:
      return {HeapType::any};
    case HeapType::eq:
      if (b == HeapType::i31 || b == HeapType::struct_ ||
          b == HeapType::array) {
        return {HeapType::eq};
      }
      return {HeapType::any};
    case HeapType::i31:
      if (b == HeapType::struct_ || b == HeapType::array) {
        return {HeapType::eq};
      }
      return {HeapType::any};
    case HeapType::struct_:
      if (b == HeapType::array) {
        return {HeapType::eq};
      }
      return {HeapType::any};
    case HeapType::array:
    case HeapType::string:
      return {HeapType::any};
    case HeapType::stringview_wtf8:
    case HeapType::stringview_wtf16:
    case HeapType::stringview_iter:
      // Only joinable with bottom or self, both already handled.
      return std::nullopt;
    case HeapType::none:
    case HeapType::noext:
    case HeapType::nofunc:
    case HeapType::nocont:
    case HeapType::noexn:
      // Bottom types already handled.
      break;
  }
  WASM_UNREACHABLE("unexpected basic type");
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
  }
  WASM_UNREACHABLE("unexpected kind");
}

std::optional<Type> TypeInfo::getCanonical() const {
  if (isTuple()) {
    if (tuple.size() == 0) {
      return Type::none;
    }
    if (tuple.size() == 1) {
      return tuple[0];
    }
  }
  return {};
}

bool TypeInfo::operator==(const TypeInfo& other) const {
  if (kind != other.kind) {
    return false;
  }
  switch (kind) {
    case TupleKind:
      return tuple == other.tuple;
    case RefKind:
      return ref.nullability == other.ref.nullability &&
             ref.heapType == other.ref.heapType;
  }
  WASM_UNREACHABLE("unexpected kind");
}

HeapTypeInfo::~HeapTypeInfo() {
  switch (kind) {
    case SignatureKind:
      signature.~Signature();
      return;
    case ContinuationKind:
      continuation.~Continuation();
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

struct TypeStore {
  std::recursive_mutex mutex;

  // Track unique_ptrs for constructed types to avoid leaks.
  std::vector<std::unique_ptr<TypeInfo>> constructedTypes;

  // Maps from constructed types to their canonical Type IDs.
  std::unordered_map<std::reference_wrapper<const TypeInfo>, uintptr_t> typeIDs;

#ifndef NDEBUG
  bool isGlobalStore();
#endif

  Type insert(const TypeInfo& info) { return doInsert(info); }
  Type insert(std::unique_ptr<TypeInfo>&& info) { return doInsert(info); }
  bool hasCanonical(const TypeInfo& info, Type& canonical);

  void clear() {
    typeIDs.clear();
    constructedTypes.clear();
  }

private:
  template<typename Ref> Type doInsert(Ref& infoRef) {
    const TypeInfo& info = [&]() {
      if constexpr (std::is_same_v<Ref, const TypeInfo>) {
        return infoRef;
      } else if constexpr (std::is_same_v<Ref, std::unique_ptr<TypeInfo>>) {
        infoRef->isTemp = false;
        return *infoRef;
      }
    }();

    auto getPtr = [&]() -> std::unique_ptr<TypeInfo> {
      if constexpr (std::is_same_v<Ref, const TypeInfo>) {
        return std::make_unique<TypeInfo>(infoRef);
      } else if constexpr (std::is_same_v<Ref, std::unique_ptr<TypeInfo>>) {
        return std::move(infoRef);
      }
    };

    auto insertNew = [&]() {
      assert((!isGlobalStore() || !info.isTemp) && "Leaking temporary type!");
      auto ptr = getPtr();
      TypeID id = uintptr_t(ptr.get());
      assert(id > Type::_last_basic_type);
      typeIDs.insert({*ptr, id});
      constructedTypes.emplace_back(std::move(ptr));
      return Type(id);
    };

    // Turn e.g. singleton tuple into non-tuple.
    if (auto canonical = info.getCanonical()) {
      return *canonical;
    }

    std::lock_guard<std::recursive_mutex> lock(mutex);
    // Check whether we already have a type for this structural Info.
    auto indexIt = typeIDs.find(std::cref(info));
    if (indexIt != typeIDs.end()) {
      return Type(indexIt->second);
    }
    // We do not have a type for this Info already. Create one.
    return insertNew();
  }
};

static TypeStore globalTypeStore;

static std::vector<std::unique_ptr<HeapTypeInfo>> globalHeapTypeStore;
static std::recursive_mutex globalHeapTypeStoreMutex;

#ifndef NDEBUG
bool TypeStore::isGlobalStore() { return this == &globalTypeStore; }
#endif

// Keep track of the constructed recursion groups.
struct RecGroupStore {
  std::mutex mutex;
  // Store the structures of all rec groups created so far so we can avoid
  // creating duplicates.
  std::unordered_set<RecGroupStructure> canonicalGroups;
  // Keep the `RecGroupInfos` for the nontrivial groups stored in
  // `canonicalGroups` alive.
  std::vector<std::unique_ptr<RecGroupInfo>> builtGroups;

  RecGroup insert(RecGroup group) {
    RecGroupStructure structure{group};
    auto [it, inserted] = canonicalGroups.insert(structure);
    if (inserted) {
      return group;
    } else {
      return it->group;
    }
  }

  RecGroup insert(std::unique_ptr<RecGroupInfo>&& info) {
    RecGroup group{uintptr_t(info.get())};
    auto canonical = insert(group);
    if (canonical == group) {
      builtGroups.emplace_back(std::move(info));
    }
    return canonical;
  }

  // Utility for canonicalizing HeapTypes with trivial recursion groups.
  HeapType insert(std::unique_ptr<HeapTypeInfo>&& info) {
    std::lock_guard<std::mutex> lock(mutex);
    assert(!info->recGroup && "Unexpected nontrivial rec group");
    auto group = asHeapType(info).getRecGroup();
    auto canonical = insert(group);
    if (group == canonical) {
      std::lock_guard<std::recursive_mutex> storeLock(globalHeapTypeStoreMutex);
      globalHeapTypeStore.emplace_back(std::move(info));
    }
    return canonical[0];
  }

  void clear() {
    canonicalGroups.clear();
    builtGroups.clear();
  }
};

static RecGroupStore globalRecGroupStore;

void validateTuple(const Tuple& tuple) {
#ifndef NDEBUG
  for (auto type : tuple) {
    assert(type.isSingle());
  }
#endif
}

} // anonymous namespace

void destroyAllTypesForTestingPurposesOnly() {
  globalTypeStore.clear();
  globalHeapTypeStore.clear();
  globalRecGroupStore.clear();
}

Type::Type(std::initializer_list<Type> types) : Type(Tuple(types)) {}

Type::Type(const Tuple& tuple) {
  validateTuple(tuple);
#ifndef NDEBUG
  for (auto type : tuple) {
    assert(!isTemp(type) && "Leaking temporary type!");
  }
#endif
  new (this) Type(globalTypeStore.insert(tuple));
}

Type::Type(Tuple&& tuple) {
#ifndef NDEBUG
  for (auto type : tuple) {
    assert(!isTemp(type) && "Leaking temporary type!");
  }
#endif
  new (this) Type(globalTypeStore.insert(std::move(tuple)));
}

Type::Type(HeapType heapType, Nullability nullable) {
  assert(!isTemp(heapType) && "Leaking temporary type!");
  new (this) Type(globalTypeStore.insert(TypeInfo(heapType, nullable)));
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
    return false;
  } else {
    return getTypeInfo(*this)->isRef();
  }
}

bool Type::isFunction() const {
  if (isBasic()) {
    return false;
  } else {
    auto* info = getTypeInfo(*this);
    return info->isRef() && info->ref.heapType.isFunction();
  }
}

bool Type::isData() const {
  if (isBasic()) {
    return false;
  } else {
    auto* info = getTypeInfo(*this);
    return info->isRef() && info->ref.heapType.isData();
  }
}

bool Type::isNullable() const {
  if (isRef()) {
    return getTypeInfo(*this)->ref.nullability == Nullable;
  } else {
    return false;
  }
}

bool Type::isNonNullable() const {
  if (isRef()) {
    return getTypeInfo(*this)->ref.nullability == NonNullable;
  } else {
    return false;
  }
}

bool Type::isSignature() const {
  return isRef() && getHeapType().isSignature();
}

bool Type::isStruct() const { return isRef() && getHeapType().isStruct(); }

bool Type::isArray() const { return isRef() && getHeapType().isArray(); }

bool Type::isException() const {
  return isRef() && getHeapType().isException();
}

bool Type::isString() const { return isRef() && getHeapType().isString(); }

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
  return isConcrete() && !isNonNullable();
}

Nullability Type::getNullability() const {
  return isNullable() ? Nullable : NonNullable;
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

unsigned Type::hasByteSize() const {
  auto hasSingleByteSize = [](Type t) { return t.isNumber(); };
  if (isTuple()) {
    for (const auto& t : *this) {
      if (!hasSingleByteSize(t)) {
        return false;
      }
    }
    return true;
  }
  return hasSingleByteSize(*this);
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
      // A reference type implies we need that feature. Some also require
      // more, such as GC or exceptions, and may require us to look into child
      // types.
      struct ReferenceFeatureCollector
        : HeapTypeChildWalker<ReferenceFeatureCollector> {
        FeatureSet feats = FeatureSet::None;

        void noteChild(HeapType* heapType) {
          if (heapType->isBasic()) {
            switch (heapType->getBasic()) {
              case HeapType::ext:
              case HeapType::func:
                feats |= FeatureSet::ReferenceTypes;
                return;
              case HeapType::any:
              case HeapType::eq:
              case HeapType::i31:
              case HeapType::struct_:
              case HeapType::array:
                feats |= FeatureSet::ReferenceTypes | FeatureSet::GC;
                return;
              case HeapType::string:
              case HeapType::stringview_wtf8:
              case HeapType::stringview_wtf16:
              case HeapType::stringview_iter:
                feats |= FeatureSet::ReferenceTypes | FeatureSet::Strings;
                return;
              case HeapType::none:
              case HeapType::noext:
              case HeapType::nofunc:
                // Technically introduced in GC, but used internally as part of
                // ref.null with just reference types.
                feats |= FeatureSet::ReferenceTypes;
                return;
              case HeapType::exn:
              case HeapType::noexn:
                feats |=
                  FeatureSet::ExceptionHandling | FeatureSet::ReferenceTypes;
                return;
              case HeapType::cont:
              case HeapType::nocont:
                feats |= FeatureSet::TypedContinuations;
                return;
            }
          }

          if (heapType->isStruct() || heapType->isArray() ||
              heapType->getRecGroup().size() > 1 ||
              heapType->getDeclaredSuperType() || heapType->isOpen()) {
            feats |= FeatureSet::ReferenceTypes | FeatureSet::GC;
          } else if (heapType->isSignature()) {
            // This is a function reference, which requires reference types and
            // possibly also multivalue (if it has multiple returns). Note that
            // technically typed function references also require GC, however,
            // we use these types internally regardless of the presence of GC
            // (in particular, since during load of the wasm we don't know the
            // features yet, so we apply the more refined types), so we don't
            // add that in any case here.
            feats |= FeatureSet::ReferenceTypes;
            auto sig = heapType->getSignature();
            if (sig.results.isTuple()) {
              feats |= FeatureSet::Multivalue;
            }
          } else if (heapType->isContinuation()) {
            feats |= FeatureSet::TypedContinuations;
          }

          // In addition, scan their non-ref children, to add dependencies on
          // things like SIMD.
          for (auto child : heapType->getTypeChildren()) {
            if (!child.isRef()) {
              feats |= child.getFeatures();
            }
          }
        }
      };

      ReferenceFeatureCollector collector;
      auto heapType = t.getHeapType();
      collector.walkRoot(&heapType);
      collector.noteChild(&heapType);
      return collector.feats;
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
  assert(isRef());
  return getTypeInfo(*this)->ref.heapType;
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
  // As an optimization, in the common case do not even construct a SubTyper.
  if (left == right) {
    return true;
  }
  return SubTyper().isSubType(left, right);
}

std::vector<HeapType> Type::getHeapTypeChildren() {
  HeapTypeChildCollector collector;
  collector.walkRoot(this);
  return collector.children;
}

bool Type::hasLeastUpperBound(Type a, Type b) {
  return getLeastUpperBound(a, b) != Type::none;
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
  if (a.isTuple() && b.isTuple()) {
    auto size = a.size();
    if (size != b.size()) {
      return Type::none;
    }
    std::vector<Type> elems;
    elems.reserve(size);
    for (size_t i = 0; i < size; ++i) {
      auto lub = Type::getLeastUpperBound(a[i], b[i]);
      if (lub == Type::none) {
        return Type::none;
      }
      elems.push_back(lub);
    }
    return Type(elems);
  }
  if (a.isRef() && b.isRef()) {
    if (auto heapType =
          HeapType::getLeastUpperBound(a.getHeapType(), b.getHeapType())) {
      auto nullability =
        (a.isNullable() || b.isNullable()) ? Nullable : NonNullable;
      return Type(*heapType, nullability);
    }
  }
  return Type::none;
  WASM_UNREACHABLE("unexpected type");
}

Type Type::getGreatestLowerBound(Type a, Type b) {
  if (a == b) {
    return a;
  }
  if (a.isTuple() && b.isTuple() && a.size() == b.size()) {
    std::vector<Type> elems;
    size_t size = a.size();
    elems.reserve(size);
    for (size_t i = 0; i < size; ++i) {
      auto glb = Type::getGreatestLowerBound(a[i], b[i]);
      if (glb == Type::unreachable) {
        return Type::unreachable;
      }
      elems.push_back(glb);
    }
    return Tuple(elems);
  }
  if (!a.isRef() || !b.isRef()) {
    return Type::unreachable;
  }
  auto heapA = a.getHeapType();
  auto heapB = b.getHeapType();
  if (heapA.getBottom() != heapB.getBottom()) {
    return Type::unreachable;
  }
  auto nullability =
    (a.isNonNullable() || b.isNonNullable()) ? NonNullable : Nullable;
  HeapType heapType;
  if (HeapType::isSubType(heapA, heapB)) {
    heapType = heapA;
  } else if (HeapType::isSubType(heapB, heapA)) {
    heapType = heapB;
  } else {
    heapType = heapA.getBottom();
  }
  return Type(heapType, nullability);
}

size_t Type::size() const {
  if (isTuple()) {
    return getTypeInfo(*this)->tuple.size();
  } else {
    // TODO: unreachable is special and expands to {unreachable} currently.
    // see also: https://github.com/WebAssembly/binaryen/issues/3062
    return size_t(id != Type::none);
  }
}

const Type& Type::Iterator::operator*() const {
  if (parent->isTuple()) {
    return getTypeInfo(*parent)->tuple[index];
  } else {
    // TODO: see comment in Type::size()
    assert(index == 0 && parent->id != Type::none && "Index out of bounds");
    return *parent;
  }
}

HeapType::HeapType(Signature sig) {
  assert(!isTemp(sig.params) && "Leaking temporary type!");
  assert(!isTemp(sig.results) && "Leaking temporary type!");
  new (this)
    HeapType(globalRecGroupStore.insert(std::make_unique<HeapTypeInfo>(sig)));
}

HeapType::HeapType(Continuation continuation) {
  assert(!isTemp(continuation.type) && "Leaking temporary type!");
  new (this) HeapType(
    globalRecGroupStore.insert(std::make_unique<HeapTypeInfo>(continuation)));
}

HeapType::HeapType(const Struct& struct_) {
#ifndef NDEBUG
  for (const auto& field : struct_.fields) {
    assert(!isTemp(field.type) && "Leaking temporary type!");
  }
#endif
  new (this) HeapType(
    globalRecGroupStore.insert(std::make_unique<HeapTypeInfo>(struct_)));
}

HeapType::HeapType(Struct&& struct_) {
#ifndef NDEBUG
  for (const auto& field : struct_.fields) {
    assert(!isTemp(field.type) && "Leaking temporary type!");
  }
#endif
  new (this) HeapType(globalRecGroupStore.insert(
    std::make_unique<HeapTypeInfo>(std::move(struct_))));
}

HeapType::HeapType(Array array) {
  assert(!isTemp(array.element.type) && "Leaking temporary type!");
  new (this)
    HeapType(globalRecGroupStore.insert(std::make_unique<HeapTypeInfo>(array)));
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
    return id == struct_ || id == array || id == string ||
           id == stringview_wtf16;
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

bool HeapType::isContinuation() const {
  if (isBasic()) {
    return false;
  } else {
    return getHeapTypeInfo(*this)->isContinuation();
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

bool HeapType::isException() const { return *this == HeapType::exn; }

bool HeapType::isString() const { return *this == HeapType::string; }

bool HeapType::isBottom() const {
  if (isBasic()) {
    switch (getBasic()) {
      case ext:
      case func:
      case cont:
      case any:
      case eq:
      case i31:
      case struct_:
      case array:
      case exn:
      case string:
      case stringview_wtf8:
      case stringview_wtf16:
      case stringview_iter:
        return false;
      case none:
      case noext:
      case nofunc:
      case nocont:
      case noexn:
        return true;
    }
  }
  return false;
}

bool HeapType::isOpen() const {
  if (isBasic()) {
    return false;
  } else {
    return getHeapTypeInfo(*this)->isOpen;
  }
}

Signature HeapType::getSignature() const {
  assert(isSignature());
  return getHeapTypeInfo(*this)->signature;
}

Continuation HeapType::getContinuation() const {
  assert(isContinuation());
  return getHeapTypeInfo(*this)->continuation;
}

const Struct& HeapType::getStruct() const {
  assert(isStruct());
  return getHeapTypeInfo(*this)->struct_;
}

Array HeapType::getArray() const {
  assert(isArray());
  return getHeapTypeInfo(*this)->array;
}

std::optional<HeapType> HeapType::getDeclaredSuperType() const {
  if (isBasic()) {
    return {};
  }
  HeapTypeInfo* super = getHeapTypeInfo(*this)->supertype;
  if (super != nullptr) {
    return HeapType(uintptr_t(super));
  }
  return {};
}

std::optional<HeapType> HeapType::getSuperType() const {
  auto ret = getDeclaredSuperType();
  if (ret) {
    return ret;
  }

  // There may be a basic supertype.
  if (isBasic()) {
    switch (getBasic()) {
      case ext:
      case noext:
      case func:
      case nofunc:
      case cont:
      case nocont:
      case any:
      case none:
      case exn:
      case noexn:
      case string:
      case stringview_wtf8:
      case stringview_wtf16:
      case stringview_iter:
        return {};
      case eq:
        return any;
      case i31:
      case struct_:
      case array:
        return eq;
    }
  }

  auto* info = getHeapTypeInfo(*this);
  switch (info->kind) {
    case HeapTypeInfo::SignatureKind:
      return func;
    case HeapTypeInfo::ContinuationKind:
      return cont;
    case HeapTypeInfo::StructKind:
      return struct_;
    case HeapTypeInfo::ArrayKind:
      return array;
  }
  WASM_UNREACHABLE("unexpected kind");
}

size_t HeapType::getDepth() const {
  size_t depth = 0;
  std::optional<HeapType> super;
  for (auto curr = *this; (super = curr.getDeclaredSuperType());
       curr = *super) {
    ++depth;
  }
  // In addition to the explicit supertypes we just traversed over, there is
  // implicit supertyping wrt basic types. A signature type always has one more
  // super, HeapType::func, etc.
  if (!isBasic()) {
    if (isFunction() || isContinuation()) {
      depth++;
    } else if (isStruct()) {
      // specific struct types <: struct <: eq <: any
      depth += 3;
    } else if (isArray()) {
      // specific array types <: array <: eq <: any
      depth += 3;
    }
  } else {
    // Some basic types have supers.
    switch (getBasic()) {
      case HeapType::ext:
      case HeapType::func:
      case HeapType::cont:
      case HeapType::any:
      case HeapType::exn:
        break;
      case HeapType::eq:
        depth++;
        break;
      case HeapType::i31:
      case HeapType::struct_:
      case HeapType::array:
      case HeapType::string:
      case HeapType::stringview_wtf8:
      case HeapType::stringview_wtf16:
      case HeapType::stringview_iter:
        depth += 2;
        break;
      case HeapType::none:
      case HeapType::nofunc:
      case HeapType::nocont:
      case HeapType::noext:
      case HeapType::noexn:
        // Bottom types are infinitely deep.
        depth = size_t(-1l);
    }
  }
  return depth;
}

HeapType::BasicHeapType HeapType::getBottom() const {
  if (isBasic()) {
    switch (getBasic()) {
      case ext:
        return noext;
      case func:
        return nofunc;
      case cont:
        return nocont;
      case exn:
        return noexn;
      case any:
      case eq:
      case i31:
      case struct_:
      case array:
      case string:
      case stringview_wtf8:
      case stringview_wtf16:
      case stringview_iter:
      case none:
        return none;
      case noext:
        return noext;
      case nofunc:
        return nofunc;
      case nocont:
        return nocont;
      case noexn:
        return noexn;
    }
  }
  auto* info = getHeapTypeInfo(*this);
  switch (info->kind) {
    case HeapTypeInfo::SignatureKind:
      return nofunc;
    case HeapTypeInfo::ContinuationKind:
      return nocont;
    case HeapTypeInfo::StructKind:
    case HeapTypeInfo::ArrayKind:
      return none;
  }
  WASM_UNREACHABLE("unexpected kind");
}

HeapType::BasicHeapType HeapType::getTop() const {
  if (*this == HeapType::stringview_wtf8 ||
      *this == HeapType::stringview_wtf16 ||
      *this == HeapType::stringview_iter) {
    // These types are their own top types even though they share a bottom type
    // `none` with the anyref hierarchy. This means that technically there are
    // multiple top types for `none`, but `any` is the canonical one.
    return getBasic();
  }
  switch (getBottom()) {
    case none:
      return any;
    case nofunc:
      return func;
    case nocont:
      return cont;
    case noext:
      return ext;
    case noexn:
      return exn;
    case ext:
    case func:
    case cont:
    case any:
    case eq:
    case i31:
    case struct_:
    case array:
    case exn:
    case string:
    case stringview_wtf8:
    case stringview_wtf16:
    case stringview_iter:
      break;
  }
  WASM_UNREACHABLE("unexpected type");
}

bool HeapType::isSubType(HeapType left, HeapType right) {
  // As an optimization, in the common case do not even construct a SubTyper.
  if (left == right) {
    return true;
  }
  return SubTyper().isSubType(left, right);
}

std::vector<Type> HeapType::getTypeChildren() const {
  if (isBasic()) {
    return {};
  }
  if (isStruct()) {
    std::vector<Type> children;
    for (auto& field : getStruct().fields) {
      children.push_back(field.type);
    }
    return children;
  }
  if (isArray()) {
    return {getArray().element.type};
  }
  if (isSignature()) {
    std::vector<Type> children;
    auto sig = getSignature();
    for (auto tuple : {sig.params, sig.results}) {
      for (auto t : tuple) {
        children.push_back(t);
      }
    }
    return children;
  }
  if (isContinuation()) {
    return {};
  }
  WASM_UNREACHABLE("unexpected kind");
}

std::vector<HeapType> HeapType::getHeapTypeChildren() const {
  HeapTypeChildCollector collector;
  collector.walkRoot(const_cast<HeapType*>(this));
  return collector.children;
}

std::vector<HeapType> HeapType::getReferencedHeapTypes() const {
  auto types = getHeapTypeChildren();
  if (auto super = getDeclaredSuperType()) {
    types.push_back(*super);
  }
  return types;
}

std::optional<HeapType> HeapType::getLeastUpperBound(HeapType a, HeapType b) {
  if (a == b) {
    return a;
  }
  if (a.getBottom() != b.getBottom()) {
    return {};
  }
  if (a.isBottom()) {
    return b;
  }
  if (b.isBottom()) {
    return a;
  }
  if (a.isBasic() || b.isBasic()) {
    return getBasicHeapTypeLUB(getBasicHeapSupertype(a),
                               getBasicHeapSupertype(b));
  }

  auto* infoA = getHeapTypeInfo(a);
  auto* infoB = getHeapTypeInfo(b);

  if (infoA->kind != infoB->kind) {
    return getBasicHeapTypeLUB(getBasicHeapSupertype(a),
                               getBasicHeapSupertype(b));
  }

  // Walk up the subtype tree to find the LUB. Ascend the tree from both `a`
  // and `b` in lockstep. The first type we see for a second time must be the
  // LUB because there are no cycles and the only way to encounter a type
  // twice is for it to be on the path above both `a` and `b`.
  std::unordered_set<HeapTypeInfo*> seen;
  seen.insert(infoA);
  seen.insert(infoB);
  while (true) {
    auto* nextA = infoA->supertype;
    auto* nextB = infoB->supertype;
    if (nextA == nullptr && nextB == nullptr) {
      // Did not find a LUB in the subtype tree.
      return getBasicHeapTypeLUB(getBasicHeapSupertype(a),
                                 getBasicHeapSupertype(b));
    }
    if (nextA) {
      if (!seen.insert(nextA).second) {
        return HeapType(uintptr_t(nextA));
      }
      infoA = nextA;
    }
    if (nextB) {
      if (!seen.insert(nextB).second) {
        return HeapType(uintptr_t(nextB));
      }
      infoB = nextB;
    }
  }
}

// Recursion groups with single elements are encoded as that single element's
// type ID with the low bit set and other recursion groups are encoded with the
// address of the vector containing their members. These encodings are disjoint
// because the alignment of the vectors is greater than 1.
static_assert(alignof(std::vector<HeapType>) > 1);

RecGroup HeapType::getRecGroup() const {
  assert(!isBasic());
  if (auto* info = getHeapTypeInfo(*this)->recGroup) {
    return RecGroup(uintptr_t(info));
  } else {
    // Mark the low bit to signify that this is a trivial recursion group and
    // points to a heap type info rather than a vector of heap types.
    return RecGroup(id | 1);
  }
}

size_t HeapType::getRecGroupIndex() const {
  assert(!isBasic());
  return getHeapTypeInfo(*this)->recGroupIndex;
}

HeapType RecGroup::Iterator::operator*() const {
  if (parent->id & 1) {
    // This is a trivial recursion group. Mask off the low bit to recover the
    // single HeapType.
    return {HeapType(parent->id & ~(uintptr_t)1)};
  } else {
    return (*(std::vector<HeapType>*)parent->id)[index];
  }
}

size_t RecGroup::size() const {
  if (id & 1) {
    return 1;
  } else {
    return ((std::vector<HeapType>*)id)->size();
  }
}

TypeNames DefaultTypeNameGenerator::getNames(HeapType type) {
  auto [it, inserted] = nameCache.insert({type, {}});
  if (inserted) {
    // Generate a new name for this type we have not previously seen.
    std::stringstream stream;
    if (type.isSignature()) {
      stream << "func." << funcCount++;
    } else if (type.isContinuation()) {
      stream << "cont." << contCount++;
    } else if (type.isStruct()) {
      stream << "struct." << structCount++;
    } else if (type.isArray()) {
      stream << "array." << arrayCount++;
    } else {
      WASM_UNREACHABLE("unexpected kind");
    }
    it->second = {stream.str(), {}};
  }
  return it->second;
}

template<typename T> static std::string genericToString(const T& t) {
  std::ostringstream ss;
  ss << t;
  return ss.str();
}
std::string Type::toString() const { return genericToString(*this); }
std::string HeapType::toString() const { return genericToString(*this); }
std::string Signature::toString() const { return genericToString(*this); }
std::string Continuation::toString() const { return genericToString(*this); }
std::string Struct::toString() const { return genericToString(*this); }
std::string Array::toString() const { return genericToString(*this); }

std::ostream& operator<<(std::ostream& os, Type type) {
  return TypePrinter(os).print(type);
}
std::ostream& operator<<(std::ostream& os, Type::Printed printed) {
  return TypePrinter(os, printed.generateName).print(Type(printed.typeID));
}
std::ostream& operator<<(std::ostream& os, HeapType type) {
  return TypePrinter(os).print(type);
}
std::ostream& operator<<(std::ostream& os, HeapType::Printed printed) {
  return TypePrinter(os, printed.generateName).print(HeapType(printed.typeID));
}
std::ostream& operator<<(std::ostream& os, Tuple tuple) {
  return TypePrinter(os).print(tuple);
}
std::ostream& operator<<(std::ostream& os, Signature sig) {
  return TypePrinter(os).print(sig);
}
std::ostream& operator<<(std::ostream& os, Continuation cont) {
  return TypePrinter(os).print(cont);
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
std::ostream& operator<<(std::ostream& os, TypeBuilder::ErrorReason reason) {
  switch (reason) {
    case TypeBuilder::ErrorReason::SelfSupertype:
      return os << "Heap type is a supertype of itself";
    case TypeBuilder::ErrorReason::InvalidSupertype:
      return os << "Heap type has an invalid supertype";
    case TypeBuilder::ErrorReason::ForwardSupertypeReference:
      return os << "Heap type has an undeclared supertype";
    case TypeBuilder::ErrorReason::ForwardChildReference:
      return os << "Heap type has an undeclared child";
  }
  WASM_UNREACHABLE("Unexpected error reason");
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
  return false;
}

bool SubTyper::isSubType(HeapType a, HeapType b) {
  // See:
  // https://github.com/WebAssembly/function-references/blob/master/proposals/function-references/Overview.md#subtyping
  // https://github.com/WebAssembly/gc/blob/master/proposals/gc/MVP.md#defined-types
  if (a == b) {
    return true;
  }
  if (b.isBasic()) {
    switch (b.getBasic()) {
      case HeapType::ext:
        return a.getTop() == HeapType::ext;
      case HeapType::func:
        return a.getTop() == HeapType::func;
      case HeapType::cont:
        return a.getTop() == HeapType::cont;
      case HeapType::exn:
        return a.getTop() == HeapType::exn;
      case HeapType::any:
        return a.getTop() == HeapType::any;
      case HeapType::eq:
        return a == HeapType::i31 || a == HeapType::none ||
               a == HeapType::struct_ || a == HeapType::array || a.isStruct() ||
               a.isArray();
      case HeapType::i31:
        return a == HeapType::none;
      case HeapType::struct_:
        return a == HeapType::none || a.isStruct();
      case HeapType::array:
        return a == HeapType::none || a.isArray();
      case HeapType::string:
      case HeapType::stringview_wtf8:
      case HeapType::stringview_wtf16:
      case HeapType::stringview_iter:
        return a == HeapType::none;
      case HeapType::none:
      case HeapType::noext:
      case HeapType::nofunc:
      case HeapType::nocont:
      case HeapType::noexn:
        return false;
    }
  }
  if (a.isBasic()) {
    // Basic HeapTypes are only subtypes of compound HeapTypes if they are
    // bottom types.
    return a == b.getBottom();
  }
  // Subtyping must be declared rather than derived from structure, so we will
  // not recurse. TODO: optimize this search with some form of caching.
  HeapTypeInfo* curr = getHeapTypeInfo(a);
  while ((curr = curr->supertype)) {
    if (curr == getHeapTypeInfo(b)) {
      return true;
    }
  }
  return false;
}

bool SubTyper::isSubType(const Tuple& a, const Tuple& b) {
  if (a.size() != b.size()) {
    return false;
  }
  for (size_t i = 0; i < a.size(); ++i) {
    if (!isSubType(a[i], b[i])) {
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
  return isSubType(b.params, a.params) && isSubType(a.results, b.results);
}

bool SubTyper::isSubType(const Continuation& a, const Continuation& b) {
  return isSubType(a.type, b.type);
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

void TypePrinter::printHeapTypeName(HeapType type) {
  if (type.isBasic()) {
    print(type);
    return;
  }
  generator(type).name.print(os);
#if TRACE_CANONICALIZATION
  os << "(;" << ((type.getID() >> 4) % 1000) << ";) ";
#endif
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
    }
  }

#if TRACE_CANONICALIZATION
  os << "(;" << ((type.getID() >> 4) % 1000) << ";) ";
#endif
  if (isTemp(type)) {
    os << "(; temp ;) ";
  }
  if (type.isTuple()) {
    print(type.getTuple());
  } else if (type.isRef()) {
    auto heapType = type.getHeapType();
    if (heapType.isBasic()) {
      // Print shorthands for certain basic heap types.
      if (type.isNullable()) {
        switch (heapType.getBasic()) {
          case HeapType::ext:
            return os << "externref";
          case HeapType::func:
            return os << "funcref";
          case HeapType::cont:
            return os << "contref";
          case HeapType::any:
            return os << "anyref";
          case HeapType::eq:
            return os << "eqref";
          case HeapType::i31:
            return os << "i31ref";
          case HeapType::struct_:
            return os << "structref";
          case HeapType::array:
            return os << "arrayref";
          case HeapType::exn:
            return os << "exnref";
          case HeapType::string:
            return os << "stringref";
          case HeapType::stringview_wtf8:
            return os << "stringview_wtf8";
          case HeapType::stringview_wtf16:
            return os << "stringview_wtf16";
          case HeapType::stringview_iter:
            return os << "stringview_iter";
          case HeapType::none:
            return os << "nullref";
          case HeapType::noext:
            return os << "nullexternref";
          case HeapType::nofunc:
            return os << "nullfuncref";
          case HeapType::nocont:
            return os << "nullcontref";
          case HeapType::noexn:
            return os << "nullexnref";
        }
      }
    }
    os << "(ref ";
    if (type.isNullable()) {
      os << "null ";
    }
    printHeapTypeName(heapType);
    os << ')';
  } else {
    WASM_UNREACHABLE("unexpected type");
  }
  return os;
}

std::ostream& TypePrinter::print(HeapType type) {
  if (type.isBasic()) {
    switch (type.getBasic()) {
      case HeapType::ext:
        return os << "extern";
      case HeapType::func:
        return os << "func";
      case HeapType::cont:
        return os << "cont";
      case HeapType::any:
        return os << "any";
      case HeapType::eq:
        return os << "eq";
      case HeapType::i31:
        return os << "i31";
      case HeapType::struct_:
        return os << "struct";
      case HeapType::array:
        return os << "array";
      case HeapType::exn:
        return os << "exn";
      case HeapType::string:
        return os << "string";
      case HeapType::stringview_wtf8:
        return os << "stringview_wtf8";
      case HeapType::stringview_wtf16:
        return os << "stringview_wtf16";
      case HeapType::stringview_iter:
        return os << "stringview_iter";
      case HeapType::none:
        return os << "none";
      case HeapType::noext:
        return os << "noextern";
      case HeapType::nofunc:
        return os << "nofunc";
      case HeapType::nocont:
        return os << "nocont";
      case HeapType::noexn:
        return os << "noexn";
    }
  }

  auto names = generator(type);

  os << "(type ";
  names.name.print(os) << ' ';

  if (isTemp(type)) {
    os << "(; temp ;) ";
  }

  bool useSub = false;
  auto super = type.getDeclaredSuperType();
  if (super || type.isOpen()) {
    useSub = true;
    os << "(sub ";
    if (!type.isOpen()) {
      os << "final ";
    }
    if (super) {
      printHeapTypeName(*super);
      os << ' ';
    }
  }
  if (type.isSignature()) {
    print(type.getSignature());
  } else if (type.isContinuation()) {
    print(type.getContinuation());
  } else if (type.isStruct()) {
    print(type.getStruct(), names.fieldNames);
  } else if (type.isArray()) {
    print(type.getArray());
  } else {
    WASM_UNREACHABLE("unexpected type");
  }
  if (useSub) {
    os << ')';
  }
  return os << ')';
}

std::ostream& TypePrinter::print(const Tuple& tuple) {
  os << "(tuple";
  for (Type type : tuple) {
    os << ' ';
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

std::ostream& TypePrinter::print(const Continuation& continuation) {
  os << "(cont ";
  printHeapTypeName(continuation.type);
  return os << ')';
}

std::ostream&
TypePrinter::print(const Struct& struct_,
                   const std::unordered_map<Index, Name>& fieldNames) {
  os << "(struct";
  for (Index i = 0; i < struct_.fields.size(); ++i) {
    // TODO: move this to the function for printing fields.
    os << " (field ";
    if (auto it = fieldNames.find(i); it != fieldNames.end()) {
      it->second.print(os) << ' ';
    }
    print(struct_.fields[i]);
    os << ')';
  }
  // TODO: Remove this extra space kept to minimize test diffs.
  if (struct_.fields.size() == 0) {
    os << ' ';
  }
  return os << ")";
}

std::ostream& TypePrinter::print(const Array& array) {
  os << "(array ";
  print(array.element);
  return os << ')';
}

size_t RecGroupHasher::operator()() const {
  size_t digest = wasm::hash(group.size());
  for (auto type : group) {
    hash_combine(digest, topLevelHash(type));
  }
  return digest;
}

size_t RecGroupHasher::topLevelHash(HeapType type) const {
  size_t digest = wasm::hash(type.isBasic());
  if (type.isBasic()) {
    wasm::rehash(digest, type.getID());
  } else {
    hash_combine(digest, hash(*getHeapTypeInfo(type)));
  }
  return digest;
}

size_t RecGroupHasher::hash(Type type) const {
  size_t digest = wasm::hash(type.isBasic());
  if (type.isBasic()) {
    wasm::rehash(digest, type.getID());
  } else {
    hash_combine(digest, hash(*getTypeInfo(type)));
  }
  return digest;
}

size_t RecGroupHasher::hash(HeapType type) const {
  // Do not recurse into the structure of this child type, but rather hash it as
  // an index into a rec group. Only take the rec group identity into account if
  // the child is not a member of the top-level group because in that case the
  // group may not be canonicalized yet.
  size_t digest = wasm::hash(type.isBasic());
  if (type.isBasic()) {
    wasm::rehash(digest, type.getID());
    return digest;
  }
  wasm::rehash(digest, type.getRecGroupIndex());
  auto currGroup = type.getRecGroup();
  if (currGroup != group) {
    wasm::rehash(digest, currGroup.getID());
  }
  return digest;
}

size_t RecGroupHasher::hash(const TypeInfo& info) const {
  size_t digest = wasm::hash(info.kind);
  switch (info.kind) {
    case TypeInfo::TupleKind:
      hash_combine(digest, hash(info.tuple));
      return digest;
    case TypeInfo::RefKind:
      rehash(digest, info.ref.nullability);
      hash_combine(digest, hash(info.ref.heapType));
      return digest;
  }
  WASM_UNREACHABLE("unexpected kind");
}

size_t RecGroupHasher::hash(const HeapTypeInfo& info) const {
  size_t digest = wasm::hash(bool(info.supertype));
  if (info.supertype) {
    hash_combine(digest, hash(HeapType(uintptr_t(info.supertype))));
  }
  wasm::rehash(digest, info.isOpen);
  wasm::rehash(digest, info.kind);
  switch (info.kind) {
    case HeapTypeInfo::SignatureKind:
      hash_combine(digest, hash(info.signature));
      return digest;
    case HeapTypeInfo::ContinuationKind:
      hash_combine(digest, hash(info.continuation));
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

size_t RecGroupHasher::hash(const Tuple& tuple) const {
  size_t digest = wasm::hash(tuple.size());
  for (auto type : tuple) {
    hash_combine(digest, hash(type));
  }
  return digest;
}

size_t RecGroupHasher::hash(const Field& field) const {
  size_t digest = wasm::hash(field.packedType);
  rehash(digest, field.mutable_);
  hash_combine(digest, hash(field.type));
  return digest;
}

size_t RecGroupHasher::hash(const Signature& sig) const {
  size_t digest = hash(sig.params);
  hash_combine(digest, hash(sig.results));
  return digest;
}

size_t RecGroupHasher::hash(const Continuation& continuation) const {
  // We throw in a magic constant to distinguish (cont $foo) from $foo
  size_t magic = 0xc0117;
  size_t digest = hash(continuation.type);
  rehash(digest, magic);
  return digest;
}

size_t RecGroupHasher::hash(const Struct& struct_) const {
  size_t digest = wasm::hash(struct_.fields.size());
  for (const auto& field : struct_.fields) {
    hash_combine(digest, hash(field));
  }
  return digest;
}

size_t RecGroupHasher::hash(const Array& array) const {
  return hash(array.element);
}

bool RecGroupEquator::operator()() const {
  if (newGroup == otherGroup) {
    return true;
  }
  // The rec groups are equivalent if they are piecewise equivalent.
  return std::equal(
    newGroup.begin(),
    newGroup.end(),
    otherGroup.begin(),
    otherGroup.end(),
    [&](const HeapType& a, const HeapType& b) { return topLevelEq(a, b); });
}

bool RecGroupEquator::topLevelEq(HeapType a, HeapType b) const {
  if (a == b) {
    return true;
  }
  if (a.isBasic() || b.isBasic()) {
    return false;
  }
  return eq(*getHeapTypeInfo(a), *getHeapTypeInfo(b));
}

bool RecGroupEquator::eq(Type a, Type b) const {
  if (a.isBasic() || b.isBasic()) {
    return a == b;
  }
  return eq(*getTypeInfo(a), *getTypeInfo(b));
}

bool RecGroupEquator::eq(HeapType a, HeapType b) const {
  // Do not recurse into the structure of children `a` and `b`, but check
  // whether their recursion groups and indices match. Since `newGroup` may not
  // be canonicalized, explicitly check whether `a` and `b` are in the
  // respective recursion groups of the respective top-level groups we are
  // comparing, in which case the structure is still equivalent.
  if (a.isBasic() || b.isBasic()) {
    return a == b;
  }
  if (a.getRecGroupIndex() != b.getRecGroupIndex()) {
    return false;
  }
  auto groupA = a.getRecGroup();
  auto groupB = b.getRecGroup();
  bool selfRefA = groupA == newGroup;
  bool selfRefB = groupB == otherGroup;
  return (selfRefA && selfRefB) || (!selfRefA && !selfRefB && groupA == groupB);
}

bool RecGroupEquator::eq(const TypeInfo& a, const TypeInfo& b) const {
  if (a.kind != b.kind) {
    return false;
  }
  switch (a.kind) {
    case TypeInfo::TupleKind:
      return eq(a.tuple, b.tuple);
    case TypeInfo::RefKind:
      return a.ref.nullability == b.ref.nullability &&
             eq(a.ref.heapType, b.ref.heapType);
  }
  WASM_UNREACHABLE("unexpected kind");
}

bool RecGroupEquator::eq(const HeapTypeInfo& a, const HeapTypeInfo& b) const {
  if (bool(a.supertype) != bool(b.supertype)) {
    return false;
  }
  if (a.supertype) {
    HeapType superA(uintptr_t(a.supertype));
    HeapType superB(uintptr_t(b.supertype));
    if (!eq(superA, superB)) {
      return false;
    }
  }
  if (a.isOpen != b.isOpen) {
    return false;
  }
  if (a.kind != b.kind) {
    return false;
  }
  switch (a.kind) {
    case HeapTypeInfo::SignatureKind:
      return eq(a.signature, b.signature);
    case HeapTypeInfo::ContinuationKind:
      return eq(a.continuation, b.continuation);
    case HeapTypeInfo::StructKind:
      return eq(a.struct_, b.struct_);
    case HeapTypeInfo::ArrayKind:
      return eq(a.array, b.array);
  }
  WASM_UNREACHABLE("unexpected kind");
}

bool RecGroupEquator::eq(const Tuple& a, const Tuple& b) const {
  return std::equal(
    a.begin(), a.end(), b.begin(), b.end(), [&](const Type& x, const Type& y) {
      return eq(x, y);
    });
}

bool RecGroupEquator::eq(const Field& a, const Field& b) const {
  return a.packedType == b.packedType && a.mutable_ == b.mutable_ &&
         eq(a.type, b.type);
}

bool RecGroupEquator::eq(const Signature& a, const Signature& b) const {
  return eq(a.params, b.params) && eq(a.results, b.results);
}

bool RecGroupEquator::eq(const Continuation& a, const Continuation& b) const {
  return eq(a.type, b.type);
}

bool RecGroupEquator::eq(const Struct& a, const Struct& b) const {
  return std::equal(a.fields.begin(),
                    a.fields.end(),
                    b.fields.begin(),
                    b.fields.end(),
                    [&](const Field& x, const Field& y) { return eq(x, y); });
}

bool RecGroupEquator::eq(const Array& a, const Array& b) const {
  return eq(a.element, b.element);
}

template<typename Self> void TypeGraphWalkerBase<Self>::walkRoot(Type* type) {
  assert(taskList.empty());
  taskList.push_back(Task::scan(type));
  doWalk();
}

template<typename Self> void TypeGraphWalkerBase<Self>::walkRoot(HeapType* ht) {
  assert(taskList.empty());
  taskList.push_back(Task::scan(ht));
  doWalk();
}

template<typename Self> void TypeGraphWalkerBase<Self>::doWalk() {
  while (!taskList.empty()) {
    auto curr = taskList.back();
    taskList.pop_back();
    switch (curr.kind) {
      case Task::PreType:
        self().preVisitType(curr.type);
        break;
      case Task::PreHeapType:
        self().preVisitHeapType(curr.heapType);
        break;
      case Task::ScanType:
        taskList.push_back(Task::postVisit(curr.type));
        self().scanType(curr.type);
        taskList.push_back(Task::preVisit(curr.type));
        break;
      case Task::ScanHeapType:
        taskList.push_back(Task::postVisit(curr.heapType));
        self().scanHeapType(curr.heapType);
        taskList.push_back(Task::preVisit(curr.heapType));
        break;
      case Task::PostType:
        self().postVisitType(curr.type);
        break;
      case Task::PostHeapType:
        self().postVisitHeapType(curr.heapType);
        break;
    }
  }
}

template<typename Self> void TypeGraphWalkerBase<Self>::scanType(Type* type) {
  if (type->isBasic()) {
    return;
  }
  auto* info = getTypeInfo(*type);
  switch (info->kind) {
    case TypeInfo::TupleKind: {
      auto& types = info->tuple;
      for (auto it = types.rbegin(); it != types.rend(); ++it) {
        taskList.push_back(Task::scan(&*it));
      }
      break;
    }
    case TypeInfo::RefKind: {
      taskList.push_back(Task::scan(&info->ref.heapType));
      break;
    }
  }
}

template<typename Self>
void TypeGraphWalkerBase<Self>::scanHeapType(HeapType* ht) {
  if (ht->isBasic()) {
    return;
  }
  auto* info = getHeapTypeInfo(*ht);
  switch (info->kind) {
    case HeapTypeInfo::SignatureKind:
      taskList.push_back(Task::scan(&info->signature.results));
      taskList.push_back(Task::scan(&info->signature.params));
      break;
    case HeapTypeInfo::ContinuationKind:
      taskList.push_back(Task::scan(&info->continuation.type));
      break;
    case HeapTypeInfo::StructKind: {
      auto& fields = info->struct_.fields;
      for (auto field = fields.rbegin(); field != fields.rend(); ++field) {
        taskList.push_back(Task::scan(&field->type));
      }
      break;
    }
    case HeapTypeInfo::ArrayKind:
      taskList.push_back(Task::scan(&info->array.element.type));
      break;
  }
}

} // anonymous namespace

struct TypeBuilder::Impl {
  // Store of temporary Types. Types that need to be canonicalized will be
  // copied into the global TypeStore.
  TypeStore typeStore;

  // Store of temporary recursion groups, which will be moved to the global
  // collection of recursion groups as part of building.
  std::unordered_map<RecGroup, std::unique_ptr<RecGroupInfo>> recGroups;

  struct Entry {
    std::unique_ptr<HeapTypeInfo> info;
    bool initialized = false;
    Entry() {
      // We need to eagerly allocate the HeapTypeInfo so we have a TypeID to use
      // to refer to it before it is initialized. Arbitrarily choose a default
      // value.
      info = std::make_unique<HeapTypeInfo>(Signature());
      info->isTemp = true;
    }
    void set(HeapTypeInfo&& hti) {
      info->kind = hti.kind;
      switch (info->kind) {
        case HeapTypeInfo::SignatureKind:
          info->signature = hti.signature;
          break;
        case HeapTypeInfo::ContinuationKind:
          info->continuation = hti.continuation;
          break;
        case HeapTypeInfo::StructKind:
          info->struct_ = std::move(hti.struct_);
          break;
        case HeapTypeInfo::ArrayKind:
          info->array = hti.array;
          break;
      }
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

TypeBuilder::TypeBuilder(TypeBuilder&& other) = default;
TypeBuilder& TypeBuilder::operator=(TypeBuilder&& other) = default;

void TypeBuilder::grow(size_t n) {
  assert(size() + n >= size());
  impl->entries.resize(size() + n);
}

size_t TypeBuilder::size() { return impl->entries.size(); }

void TypeBuilder::setHeapType(size_t i, Signature signature) {
  assert(i < size() && "index out of bounds");
  impl->entries[i].set(signature);
}

void TypeBuilder::setHeapType(size_t i, Continuation continuation) {
  assert(i < size() && "index out of bounds");
  impl->entries[i].set(continuation);
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
  Type ret = impl->typeStore.insert(tuple);
  if (tuple.size() > 1) {
    return markTemp(ret);
  } else {
    // No new tuple was created, so the result might not be temporary.
    return ret;
  }
}

Type TypeBuilder::getTempRefType(HeapType type, Nullability nullable) {
  return markTemp(impl->typeStore.insert(TypeInfo(type, nullable)));
}

void TypeBuilder::setSubType(size_t i, HeapType super) {
  assert(i < size() && "index out of bounds");
  HeapTypeInfo* sub = impl->entries[i].info.get();
  sub->supertype = getHeapTypeInfo(super);
}

void TypeBuilder::createRecGroup(size_t index, size_t length) {
  assert(index <= size() && index + length <= size() && "group out of bounds");
  // Only materialize nontrivial recursion groups.
  if (length < 2) {
    return;
  }
  auto groupInfo = std::make_unique<RecGroupInfo>();
  groupInfo->reserve(length);
  for (size_t i = 0; i < length; ++i) {
    auto& info = impl->entries[index + i].info;
    assert(info->recGroup == nullptr && "group already assigned");
    groupInfo->push_back(asHeapType(info));
    info->recGroup = groupInfo.get();
    info->recGroupIndex = i;
  }
  impl->recGroups.insert(
    {RecGroup(uintptr_t(groupInfo.get())), std::move(groupInfo)});
}

void TypeBuilder::setOpen(size_t i, bool open) {
  assert(i < size() && "index out of bounds");
  impl->entries[i].info->isOpen = open;
}

namespace {

bool isValidSupertype(const HeapTypeInfo& sub, const HeapTypeInfo& super) {
  if (!super.isOpen) {
    return false;
  }
  if (sub.kind != super.kind) {
    return false;
  }
  SubTyper typer;
  switch (sub.kind) {
    case HeapTypeInfo::SignatureKind:
      return typer.isSubType(sub.signature, super.signature);
    case HeapTypeInfo::ContinuationKind:
      return typer.isSubType(sub.continuation, super.continuation);
    case HeapTypeInfo::StructKind:
      return typer.isSubType(sub.struct_, super.struct_);
    case HeapTypeInfo::ArrayKind:
      return typer.isSubType(sub.array, super.array);
  }
  WASM_UNREACHABLE("unknown kind");
}

void updateReferencedHeapTypes(
  std::unique_ptr<HeapTypeInfo>& info,
  const std::unordered_map<HeapType, HeapType>& canonicalized) {
  // Update the reference types that refer to canonicalized heap types to be
  // their canonical versions. Update the Types rather than the HeapTypes so
  // that the validation of supertypes sees canonical types.
  struct ChildUpdater : TypeGraphWalkerBase<ChildUpdater> {
    const std::unordered_map<HeapType, HeapType>& canonicalized;
    bool isTopLevel = true;

    ChildUpdater(const std::unordered_map<HeapType, HeapType>& canonicalized)
      : canonicalized(canonicalized) {}

    void scanType(Type* type) {
      isTopLevel = false;
      if (type->isRef()) {
        auto ht = type->getHeapType();
        if (auto it = canonicalized.find(ht); it != canonicalized.end()) {
          *type = Type(it->second, type->getNullability());
        } else if (isTemp(*type) && !isTemp(ht)) {
          *type = Type(ht, type->getNullability());
        }
      } else if (type->isTuple()) {
        TypeGraphWalkerBase<ChildUpdater>::scanType(type);
      }
    }

    void scanHeapType(HeapType* type) {
      if (isTopLevel) {
        isTopLevel = false;
        TypeGraphWalkerBase<ChildUpdater>::scanHeapType(type);
      } else {
        if (auto it = canonicalized.find(*type); it != canonicalized.end()) {
          *type = it->second;
        }
      }
    }
  };

  // Update the children.
  ChildUpdater updater(canonicalized);
  auto root = asHeapType(info);
  updater.walkRoot(&root);

  // Update the supertype.
  if (info->supertype) {
    HeapType super(uintptr_t(info->supertype));
    if (auto it = canonicalized.find(super); it != canonicalized.end()) {
      info->supertype = getHeapTypeInfo(it->second);
    }
  }
}

TypeBuilder::BuildResult
buildRecGroup(std::unique_ptr<RecGroupInfo>&& groupInfo,
              std::vector<std::unique_ptr<HeapTypeInfo>>&& typeInfos,
              std::unordered_map<HeapType, HeapType>& canonicalized) {
  // First, we need to replace any referenced temporary HeapTypes from
  // previously built groups with their canonicalized versions.
  for (auto& info : typeInfos) {
    updateReferencedHeapTypes(info, canonicalized);
  }

  // Collect the types and check supertype validity.
  std::unordered_set<HeapType> seenTypes;
  for (size_t i = 0; i < typeInfos.size(); ++i) {
    auto& info = typeInfos[i];
    if (auto* super = info->supertype) {
      // The supertype must be canonical (i.e. defined in a previous rec group)
      // or have already been defined in this rec group.
      if (super->isTemp && !seenTypes.count(HeapType(uintptr_t(super)))) {
        return {TypeBuilder::Error{
          i, TypeBuilder::ErrorReason::ForwardSupertypeReference}};
      }
      // The supertype must have a valid structure.
      if (!isValidSupertype(*info, *super)) {
        return {
          TypeBuilder::Error{i, TypeBuilder::ErrorReason::InvalidSupertype}};
      }
    }
    seenTypes.insert(asHeapType(info));
  }

  // Check that children are either already canonical (i.e. defined in a
  // previous rec group) or are defined in this current rec group.
  for (size_t i = 0; i < typeInfos.size(); ++i) {
    auto type = asHeapType(typeInfos[i]);
    for (auto child : type.getHeapTypeChildren()) {
      if (isTemp(child) && !seenTypes.count(child)) {
        return {TypeBuilder::Error{
          i, TypeBuilder::ErrorReason::ForwardChildReference}};
      }
    }
  }

  // The rec group is valid, so we can try to move the group into the global rec
  // group store. If the returned canonical group is not the same as the input
  // group, then there is already a canonical version of this rec group. Lock
  // the global rec group store here to avoid leaking temporary types to other
  // threads that may be trying to build an identical group.
  auto group = asHeapType(typeInfos[0]).getRecGroup();
  std::lock_guard<std::mutex> lock(globalRecGroupStore.mutex);
  auto canonical = groupInfo ? globalRecGroupStore.insert(std::move(groupInfo))
                             : globalRecGroupStore.insert(group);
  if (group != canonical) {
    // Replace the non-canonical types with their canonical equivalents.
    assert(canonical.size() == group.size());
    for (size_t i = 0; i < group.size(); ++i) {
      canonicalized.insert({group[i], canonical[i]});
    }
    // Return the canonical types.
    return {std::vector<HeapType>(canonical.begin(), canonical.end())};
  }

  // The group was successfully moved to the global rec group store, so it is
  // now canonical. We need to move its heap types to the heap type store so
  // they become canonical as well.
  {
    std::lock_guard<std::recursive_mutex> lock(globalHeapTypeStoreMutex);
    for (auto& info : typeInfos) {
      info->isTemp = false;
      globalHeapTypeStore.emplace_back(std::move(info));
    }
  }

  std::vector<HeapType> results(group.begin(), group.end());

  // We need to make the Types canonical as well, but right now there is no way
  // to move them to their global store, so we have to create new types and
  // replace the old ones. TODO simplify this.
  struct Locations : TypeGraphWalker<Locations> {
    std::unordered_map<Type, std::unordered_set<Type*>> types;
    void preVisitType(Type* type) {
      if (isTemp(*type)) {
        types[*type].insert(type);
      }
    }
  };

  Locations locations;
  for (auto& type : results) {
    locations.walkRoot(&type);
  }

  // Canonicalize non-tuple Types (which never directly refer to other Types)
  // before tuple Types to avoid canonicalizing a tuple that still contains
  // non-canonical Types.
  auto canonicalizeTypes = [&](bool tuples) {
    for (auto& [original, uses] : locations.types) {
      if (original.isTuple() == tuples) {
        Type canonical = globalTypeStore.insert(*getTypeInfo(original));
        for (Type* use : uses) {
          *use = canonical;
        }
      }
    }
  };
  canonicalizeTypes(false);
  canonicalizeTypes(true);

  return {results};
}

} // anonymous namespace

TypeBuilder::BuildResult TypeBuilder::build() {
  size_t entryCount = impl->entries.size();

  std::vector<HeapType> results;
  results.reserve(entryCount);

  // Map temporary HeapTypes to their canonicalized versions so they can be
  // replaced in later rec groups.
  std::unordered_map<HeapType, HeapType> canonicalized;

  // Canonicalize each rec group, one at a time.
  size_t groupStart = 0;
  while (groupStart < entryCount) {
    auto group = asHeapType(impl->entries[groupStart].info).getRecGroup();

    std::unique_ptr<RecGroupInfo> groupInfo;
    if (auto it = impl->recGroups.find(group); it != impl->recGroups.end()) {
      groupInfo = std::move(it->second);
    }

    size_t groupSize = group.size();
    std::vector<std::unique_ptr<HeapTypeInfo>> typeInfos;
    typeInfos.reserve(groupSize);
    for (size_t i = 0; i < groupSize; ++i) {
      typeInfos.emplace_back(std::move(impl->entries[groupStart + i].info));
    }

    auto built =
      buildRecGroup(std::move(groupInfo), std::move(typeInfos), canonicalized);
    if (auto* error = built.getError()) {
      return {TypeBuilder::Error{groupStart + error->index, error->reason}};
    }

    assert(built->size() == groupSize);
    results.insert(results.end(), built->begin(), built->end());

    groupStart += groupSize;
  }

  return {results};
}

void TypeBuilder::dump() {
  std::vector<HeapType> types;
  for (size_t i = 0; i < size(); ++i) {
    types.push_back((*this)[i]);
  }
  IndexedTypeNameGenerator<DefaultTypeNameGenerator> print(types);

  std::optional<RecGroup> currGroup;
  for (auto type : types) {
    if (auto newGroup = type.getRecGroup(); newGroup != currGroup) {
      if (currGroup && currGroup->size() > 1) {
        std::cerr << ")\n";
      }
      if (newGroup.size() > 1) {
        std::cerr << "(rec\n";
      }
      currGroup = newGroup;
    }
    if (currGroup->size() > 1) {
      std::cerr << "  ";
    }
    std::cerr << print(type) << "\n";
  }
  if (currGroup && currGroup->size() > 1) {
    std::cerr << ")\n";
  }
}

std::unordered_set<HeapType> getIgnorablePublicTypes() {
  auto array8 = Array(Field(Field::i8, Mutable));
  auto array16 = Array(Field(Field::i16, Mutable));
  TypeBuilder builder(4);
  // We handle final and non-final here, but should remove one of them
  // eventually TODO
  builder[0] = array8;
  builder[0].setOpen(false);
  builder[1] = array16;
  builder[1].setOpen(false);
  builder[2] = array8;
  builder[2].setOpen(true);
  builder[3] = array16;
  builder[3].setOpen(true);
  auto result = builder.build();
  assert(result);
  std::unordered_set<HeapType> ret;
  for (auto type : *result) {
    ret.insert(type);
  }
  return ret;
}

} // namespace wasm

namespace std {

template<> class hash<wasm::Tuple> {
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

size_t hash<wasm::Signature>::operator()(const wasm::Signature& sig) const {
  auto digest = wasm::hash(sig.params);
  wasm::rehash(digest, sig.results);
  return digest;
}

size_t
hash<wasm::Continuation>::operator()(const wasm::Continuation& cont) const {
  // We throw in a magic constant to distinguish (cont $foo) from $foo
  auto magic = 0xc0117;
  auto digest = wasm::hash(cont.type);
  wasm::rehash(digest, magic);
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

size_t hash<wasm::RecGroup>::operator()(const wasm::RecGroup& group) const {
  return wasm::hash(group.getID());
}

size_t hash<wasm::TypeInfo>::operator()(const wasm::TypeInfo& info) const {
  auto digest = wasm::hash(info.kind);
  switch (info.kind) {
    case wasm::TypeInfo::TupleKind:
      wasm::rehash(digest, info.tuple);
      return digest;
    case wasm::TypeInfo::RefKind:
      wasm::rehash(digest, info.ref.nullability);
      wasm::rehash(digest, info.ref.heapType);
      return digest;
  }
  WASM_UNREACHABLE("unexpected kind");
}

} // namespace std
