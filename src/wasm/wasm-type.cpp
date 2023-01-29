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
#define TIME_CANONICALIZATION 0

#if TRACE_CANONICALIZATION || TIME_CANONICALIZATION
#include <iostream>
#endif

#if TIME_CANONICALIZATION
#include <chrono>
#endif

namespace wasm {

static TypeSystem typeSystem = TypeSystem::Isorecursive;

void setTypeSystem(TypeSystem system) { typeSystem = system; }

TypeSystem getTypeSystem() { return typeSystem; }

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
    Nullability nullable;
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

  bool isNullable() const { return kind == RefKind && ref.nullable; }

  // If this TypeInfo represents a Type that can be represented more simply,
  // return that simpler Type. For example, this handles canonicalizing the
  // TypeInfo representing (ref null any) into the BasicType anyref. It also
  // handles eliminating singleton tuple types.
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
  // If `isFinalized`, then hashing and equality are performed on the finite
  // shape of the type definition tree rooted at the HeapTypeInfo.
  // Otherwise, the type definition tree is still being constructed via the
  // TypeBuilder interface, so hashing and equality use pointer identity.
  bool isFinalized = true;
  // In nominal or isorecursive mode, the supertype of this HeapType, if it
  // exists.
  HeapTypeInfo* supertype = nullptr;
  // In isorecursive mode, the recursion group of this type or null if the
  // recursion group is trivial (i.e. contains only this type).
  RecGroupInfo* recGroup = nullptr;
  size_t recGroupIndex = 0;
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

  // If this HeapTypeInfo represents a HeapType that can be represented more
  // simply, return that simpler HeapType. This handles turning BasicKind
  // HeapTypes into their corresponding BasicHeapTypes.
  std::optional<HeapType> getCanonical() const;

  HeapTypeInfo& operator=(const HeapTypeInfo& other);
  bool operator==(const HeapTypeInfo& other) const;
  bool operator!=(const HeapTypeInfo& other) const { return !(*this == other); }
};

// Helper for coinductively checking whether a pair of Types or HeapTypes are in
// a subtype relation.
struct SubTyper {
  bool isSubType(Type a, Type b);
  bool isSubType(HeapType a, HeapType b);
  bool isSubType(const Tuple& a, const Tuple& b);
  bool isSubType(const Field& a, const Field& b);
  bool isSubType(const Signature& a, const Signature& b);
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
  std::ostream& print(const Signature& sig,
                      std::optional<HeapType> super = std::nullopt);
  std::ostream& print(const Struct& struct_,
                      std::optional<HeapType> super = std::nullopt);
  std::ostream& print(const Array& array,
                      std::optional<HeapType> super = std::nullopt);
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

template<> class hash<wasm::HeapTypeInfo> {
public:
  size_t operator()(const wasm::HeapTypeInfo& info) const;
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

// Given a Type that may or may not be backed by the simplest possible
// representation, return the equivalent type that is definitely backed by the
// simplest possible representation.
Type asCanonical(Type type) {
  if (type.isBasic()) {
    return type;
  } else if (auto canon = getTypeInfo(type)->getCanonical()) {
    return *canon;
  } else {
    return type;
  }
}

HeapType::BasicHeapType getBasicHeapSupertype(HeapType type) {
  if (type.isBasic()) {
    return type.getBasic();
  }
  auto* info = getHeapTypeInfo(type);
  switch (info->kind) {
    case HeapTypeInfo::BasicKind:
      break;
    case HeapTypeInfo::SignatureKind:
      return HeapType::func;
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
  if (HeapType(a).getBottom() != HeapType(b).getBottom()) {
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
    case HeapType::stringview_wtf8:
    case HeapType::stringview_wtf16:
    case HeapType::stringview_iter:
      return {HeapType::any};
    case HeapType::none:
    case HeapType::noext:
    case HeapType::nofunc:
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
    if (tuple.types.size() == 0) {
      return Type::none;
    }
    if (tuple.types.size() == 1) {
      return tuple.types[0];
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
      return ref.nullable == other.ref.nullable &&
             ref.heapType == other.ref.heapType;
  }
  WASM_UNREACHABLE("unexpected kind");
}

HeapTypeInfo::HeapTypeInfo(const HeapTypeInfo& other) {
  kind = other.kind;
  supertype = other.supertype;
  recGroup = other.recGroup;
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

std::optional<HeapType> HeapTypeInfo::getCanonical() const {
  if (isFinalized && kind == BasicKind) {
    return basic;
  }
  return {};
}

HeapTypeInfo& HeapTypeInfo::operator=(const HeapTypeInfo& other) {
  if (&other != this) {
    this->~HeapTypeInfo();
    new (this) HeapTypeInfo(other);
  }
  return *this;
}

bool HeapTypeInfo::operator==(const HeapTypeInfo& other) const {
  return this == &other;
}

template<typename Info> struct Store {
  std::recursive_mutex mutex;

  // Track unique_ptrs for constructed types to avoid leaks.
  std::vector<std::unique_ptr<Info>> constructedTypes;

  // Maps from constructed types to their canonical Type IDs.
  std::unordered_map<std::reference_wrapper<const Info>, uintptr_t> typeIDs;

#ifndef NDEBUG
  bool isGlobalStore();
#endif

  typename Info::type_t insert(const Info& info) { return doInsert(info); }
  typename Info::type_t insert(std::unique_ptr<Info>&& info) {
    return doInsert(info);
  }
  bool hasCanonical(const Info& info, typename Info::type_t& canonical);

  void clear() {
    typeIDs.clear();
    constructedTypes.clear();
  }

private:
  template<typename Ref> typename Info::type_t doInsert(Ref& infoRef) {
    const Info& info = [&]() {
      if constexpr (std::is_same_v<Ref, const Info>) {
        return infoRef;
      } else if constexpr (std::is_same_v<Ref, std::unique_ptr<Info>>) {
        infoRef->isTemp = false;
        return *infoRef;
      }
    }();

    auto getPtr = [&]() -> std::unique_ptr<Info> {
      if constexpr (std::is_same_v<Ref, const Info>) {
        return std::make_unique<Info>(infoRef);
      } else if constexpr (std::is_same_v<Ref, std::unique_ptr<Info>>) {
        return std::move(infoRef);
      }
    };

    auto insertNew = [&]() {
      assert((!isGlobalStore() || !info.isTemp) && "Leaking temporary type!");
      auto ptr = getPtr();
      TypeID id = uintptr_t(ptr.get());
      assert(id > Info::type_t::_last_basic_type);
      typeIDs.insert({*ptr, id});
      constructedTypes.emplace_back(std::move(ptr));
      return typename Info::type_t(id);
    };

    // Turn e.g. (ref null any) into anyref.
    if (auto canonical = info.getCanonical()) {
      return *canonical;
    }
    std::lock_guard<std::recursive_mutex> lock(mutex);
    // Nominal HeapTypes are always unique, so don't bother deduplicating them.
    if constexpr (std::is_same_v<Info, HeapTypeInfo>) {
      if (typeSystem == TypeSystem::Nominal) {
        return insertNew();
      }
    }
    // Check whether we already have a type for this structural Info.
    auto indexIt = typeIDs.find(std::cref(info));
    if (indexIt != typeIDs.end()) {
      return typename Info::type_t(indexIt->second);
    }
    // We do not have a type for this Info already. Create one.
    return insertNew();
  }
};

using TypeStore = Store<TypeInfo>;
using HeapTypeStore = Store<HeapTypeInfo>;

static TypeStore globalTypeStore;
static HeapTypeStore globalHeapTypeStore;

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

// Cache canonical nominal signature types. See comment in
// `HeapType::HeapType(Signature)`.
struct SignatureTypeCache {
  std::unordered_map<Signature, HeapType> cache;
  std::mutex mutex;

  HeapType getType(Signature sig) {
    std::lock_guard<std::mutex> lock(mutex);
    // Try inserting a placeholder type, then replace it with a real type if we
    // don't already have a canonical type for this signature.
    auto [entry, inserted] = cache.insert({sig, {}});
    auto& [_, type] = *entry;
    if (inserted) {
      type = globalHeapTypeStore.insert(sig);
    }
    return type;
  }

  void insertType(HeapType type) {
    std::lock_guard<std::mutex> lock(mutex);
    cache.insert({type.getSignature(), type});
  }

  void clear() { cache.clear(); }
};

static SignatureTypeCache nominalSignatureCache;

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
      globalHeapTypeStore.insert(std::move(info));
    }
    return canonical[0];
  }

  void clear() {
    canonicalGroups.clear();
    builtGroups.clear();
  }
};

static RecGroupStore globalRecGroupStore;

} // anonymous namespace

void destroyAllTypesForTestingPurposesOnly() {
  globalTypeStore.clear();
  globalHeapTypeStore.clear();
  nominalSignatureCache.clear();
  globalRecGroupStore.clear();
}

Type::Type(std::initializer_list<Type> types) : Type(Tuple(types)) {}

Type::Type(const Tuple& tuple) {
#ifndef NDEBUG
  for (auto type : tuple.types) {
    assert(!isTemp(type) && "Leaking temporary type!");
  }
#endif
  new (this) Type(globalTypeStore.insert(tuple));
}

Type::Type(Tuple&& tuple) {
#ifndef NDEBUG
  for (auto type : tuple.types) {
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
  if (isBasic()) {
    return false;
  } else {
    return getTypeInfo(*this)->isNullable();
  }
}

bool Type::isNonNullable() const {
  if (isRef()) {
    return !isNullable();
  } else {
    return false;
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
      // A reference type implies we need that feature. Some also require more,
      // such as GC or exceptions.
      auto heapType = t.getHeapType();
      if (heapType.isBasic()) {
        switch (heapType.getBasic()) {
          case HeapType::ext:
          case HeapType::func:
            return FeatureSet::ReferenceTypes;
          case HeapType::any:
          case HeapType::eq:
          case HeapType::i31:
          case HeapType::struct_:
          case HeapType::array:
            return FeatureSet::ReferenceTypes | FeatureSet::GC;
          case HeapType::string:
          case HeapType::stringview_wtf8:
          case HeapType::stringview_wtf16:
          case HeapType::stringview_iter:
            return FeatureSet::ReferenceTypes | FeatureSet::Strings;
          case HeapType::none:
          case HeapType::noext:
          case HeapType::nofunc:
            // Technically introduced in GC, but used internally as part of
            // ref.null with just reference types.
            return FeatureSet::ReferenceTypes;
        }
      }
      if (heapType.isStruct() || heapType.isArray() ||
          heapType.getRecGroup().size() > 1 || heapType.getSuperType()) {
        return FeatureSet::ReferenceTypes | FeatureSet::GC;
      }
      // Note: Technically typed function references also require GC, however,
      // we use these types internally regardless of the presence of GC (in
      // particular, since during load of the wasm we don't know the features
      // yet, so we apply the more refined types), so we don't add that in any
      // case here.
      assert(heapType.isSignature());
      return FeatureSet::ReferenceTypes;
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
    }
    WASM_UNREACHABLE("Unexpected type");
  } else {
    auto* info = getTypeInfo(*this);
    switch (info->kind) {
      case TypeInfo::TupleKind:
        break;
      case TypeInfo::RefKind:
        return info->ref.heapType;
    }
    WASM_UNREACHABLE("Unexpected type");
  }
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

size_t Type::size() const {
  if (isTuple()) {
    return getTypeInfo(*this)->tuple.types.size();
  } else {
    // TODO: unreachable is special and expands to {unreachable} currently.
    // see also: https://github.com/WebAssembly/binaryen/issues/3062
    return size_t(id != Type::none);
  }
}

const Type& Type::Iterator::operator*() const {
  if (parent->isTuple()) {
    return getTypeInfo(*parent)->tuple.types[index];
  } else {
    // TODO: see comment in Type::size()
    assert(index == 0 && parent->id != Type::none && "Index out of bounds");
    return *parent;
  }
}

HeapType::HeapType(Signature sig) {
  assert(!isTemp(sig.params) && "Leaking temporary type!");
  assert(!isTemp(sig.results) && "Leaking temporary type!");
  switch (getTypeSystem()) {
    case TypeSystem::Nominal:
      // Special case the creation of signature types in nominal mode to return
      // a "canonical" type for the signature, which happens to be the first one
      // created. We depend on being able to create new function signatures in
      // many places, and historically they have always been structural, so
      // creating a copy of an existing signature did not result in any code
      // bloat or semantic changes. To avoid regressions or significant changes
      // of behavior in nominal mode, we cache the canonical heap types for each
      // signature to emulate structural behavior.
      new (this) HeapType(nominalSignatureCache.getType(sig));
      return;
    case TypeSystem::Isorecursive:
      new (this) HeapType(
        globalRecGroupStore.insert(std::make_unique<HeapTypeInfo>(sig)));
      return;
  }
  WASM_UNREACHABLE("unexpected type system");
}

HeapType::HeapType(const Struct& struct_) {
#ifndef NDEBUG
  for (const auto& field : struct_.fields) {
    assert(!isTemp(field.type) && "Leaking temporary type!");
  }
#endif
  switch (getTypeSystem()) {
    case TypeSystem::Nominal:
      new (this) HeapType(globalHeapTypeStore.insert(struct_));
      return;
    case TypeSystem::Isorecursive:
      new (this) HeapType(
        globalRecGroupStore.insert(std::make_unique<HeapTypeInfo>(struct_)));
      return;
  }
  WASM_UNREACHABLE("unexpected type system");
}

HeapType::HeapType(Struct&& struct_) {
#ifndef NDEBUG
  for (const auto& field : struct_.fields) {
    assert(!isTemp(field.type) && "Leaking temporary type!");
  }
#endif
  switch (getTypeSystem()) {
    case TypeSystem::Nominal:
      new (this) HeapType(globalHeapTypeStore.insert(std::move(struct_)));
      return;
    case TypeSystem::Isorecursive:
      new (this) HeapType(globalRecGroupStore.insert(
        std::make_unique<HeapTypeInfo>(std::move(struct_))));
      return;
  }
  WASM_UNREACHABLE("unexpected type system");
}

HeapType::HeapType(Array array) {
  assert(!isTemp(array.element.type) && "Leaking temporary type!");
  switch (getTypeSystem()) {
    case TypeSystem::Nominal:
      new (this) HeapType(globalHeapTypeStore.insert(array));
      return;
    case TypeSystem::Isorecursive:
      new (this) HeapType(
        globalRecGroupStore.insert(std::make_unique<HeapTypeInfo>(array)));
      return;
  }
  WASM_UNREACHABLE("unexpected type system");
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
    return id == struct_ || id == array;
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

bool HeapType::isBottom() const {
  if (isBasic()) {
    switch (getBasic()) {
      case ext:
      case func:
      case any:
      case eq:
      case i31:
      case struct_:
      case array:
      case string:
      case stringview_wtf8:
      case stringview_wtf16:
      case stringview_iter:
        return false;
      case none:
      case noext:
      case nofunc:
        return true;
    }
  }
  return false;
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

std::optional<HeapType> HeapType::getSuperType() const {
  if (isBasic()) {
    return {};
  }
  HeapTypeInfo* super = getHeapTypeInfo(*this)->supertype;
  if (super != nullptr) {
    return HeapType(uintptr_t(super));
  }
  return {};
}

size_t HeapType::getDepth() const {
  size_t depth = 0;
  std::optional<HeapType> super;
  for (auto curr = *this; (super = curr.getSuperType()); curr = *super) {
    ++depth;
  }
  // In addition to the explicit supertypes we just traversed over, there is
  // implicit supertyping wrt basic types. A signature type always has one more
  // super, HeapType::func, etc.
  if (!isBasic()) {
    if (isFunction()) {
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
      case HeapType::any:
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
      case HeapType::noext:
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
    }
  }
  auto* info = getHeapTypeInfo(*this);
  switch (info->kind) {
    case HeapTypeInfo::BasicKind:
      return HeapType(info->basic).getBottom();
    case HeapTypeInfo::SignatureKind:
      return nofunc;
    case HeapTypeInfo::StructKind:
    case HeapTypeInfo::ArrayKind:
      return none;
  }
  WASM_UNREACHABLE("unexpected kind");
}

bool HeapType::isSubType(HeapType left, HeapType right) {
  // As an optimization, in the common case do not even construct a SubTyper.
  if (left == right) {
    return true;
  }
  return SubTyper().isSubType(left, right);
}

std::vector<HeapType> HeapType::getHeapTypeChildren() const {
  HeapTypeChildCollector collector;
  collector.walkRoot(const_cast<HeapType*>(this));
  return collector.children;
}

std::vector<HeapType> HeapType::getReferencedHeapTypes() const {
  auto types = getHeapTypeChildren();
  if (auto super = getSuperType()) {
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
std::string Tuple::toString() const { return genericToString(*this); }
std::string Signature::toString() const { return genericToString(*this); }
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
        return a.getBottom() == HeapType::noext;
      case HeapType::func:
        return a.getBottom() == HeapType::nofunc;
      case HeapType::any:
        return a.getBottom() == HeapType::none;
      case HeapType::eq:
        return a == HeapType::i31 || a == HeapType::none || a.isData();
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
  return isSubType(b.params, a.params) && isSubType(a.results, b.results);
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
  os << '$' << generator(type).name;
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

  if (isTemp(type)) {
    os << "(; temp ;) ";
  }
#if TRACE_CANONICALIZATION
  os << "(;" << ((type.getID() >> 4) % 1000) << ";) ";
#endif
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
    }
  }

  os << "(type ";
  printHeapTypeName(type);
  os << " ";

  if (isTemp(type)) {
    os << "(; temp ;) ";
  }
#if TRACE_CANONICALIZATION
  os << "(;" << ((type.getID() >> 4) % 1000) << ";)";
#endif
  if (getHeapTypeInfo(type)->kind == HeapTypeInfo::BasicKind) {
    os << "(; noncanonical ;) ";
    print(getHeapTypeInfo(type)->basic);
  } else if (type.isSignature()) {
    print(type.getSignature(), type.getSuperType());
  } else if (type.isStruct()) {
    print(type.getStruct(), type.getSuperType());
  } else if (type.isArray()) {
    print(type.getArray(), type.getSuperType());
  } else {
    WASM_UNREACHABLE("unexpected type");
  }
  return os << ")";
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

std::ostream& TypePrinter::print(const Signature& sig,
                                 std::optional<HeapType> super) {
  auto printPrefixed = [&](const char* prefix, Type type) {
    os << '(' << prefix;
    for (Type t : type) {
      os << ' ';
      print(t);
    }
    os << ')';
  };

  os << "(func";
  if (super) {
    os << "_subtype";
  }
  if (sig.params.getID() != Type::none) {
    os << ' ';
    printPrefixed("param", sig.params);
  }
  if (sig.results.getID() != Type::none) {
    os << ' ';
    printPrefixed("result", sig.results);
  }
  if (super) {
    os << ' ';
    printHeapTypeName(*super);
  }
  return os << ')';
}

std::ostream& TypePrinter::print(const Struct& struct_,
                                 std::optional<HeapType> super) {
  os << "(struct";
  if (super) {
    os << "_subtype";
  }
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
  if (super) {
    os << ' ';
    printHeapTypeName(*super);
  }
  return os << ')';
}

std::ostream& TypePrinter::print(const Array& array,
                                 std::optional<HeapType> super) {
  os << "(array";
  if (super) {
    os << "_subtype";
  }
  os << ' ';
  print(array.element);
  if (super) {
    os << ' ';
    printHeapTypeName(*super);
  }
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
      rehash(digest, info.ref.nullable);
      hash_combine(digest, hash(info.ref.heapType));
      return digest;
  }
  WASM_UNREACHABLE("unexpected kind");
}

size_t RecGroupHasher::hash(const HeapTypeInfo& info) const {
  assert(info.isFinalized);
  size_t digest = wasm::hash(bool(info.supertype));
  if (info.supertype) {
    hash_combine(digest, hash(HeapType(uintptr_t(info.supertype))));
  }
  wasm::rehash(digest, info.kind);
  switch (info.kind) {
    case HeapTypeInfo::BasicKind:
      WASM_UNREACHABLE("Basic HeapTypeInfo should have been canonicalized");
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

size_t RecGroupHasher::hash(const Tuple& tuple) const {
  size_t digest = wasm::hash(tuple.types.size());
  for (auto type : tuple.types) {
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
      return a.ref.nullable == b.ref.nullable &&
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
  if (a.kind != b.kind) {
    return false;
  }
  switch (a.kind) {
    case HeapTypeInfo::BasicKind:
      WASM_UNREACHABLE("Basic HeapTypeInfo should have been canonicalized");
    case HeapTypeInfo::SignatureKind:
      return eq(a.signature, b.signature);
    case HeapTypeInfo::StructKind:
      return eq(a.struct_, b.struct_);
    case HeapTypeInfo::ArrayKind:
      return eq(a.array, b.array);
  }
  WASM_UNREACHABLE("unexpected kind");
}

bool RecGroupEquator::eq(const Tuple& a, const Tuple& b) const {
  return std::equal(a.types.begin(),
                    a.types.end(),
                    b.types.begin(),
                    b.types.end(),
                    [&](const Type& x, const Type& y) { return eq(x, y); });
}

bool RecGroupEquator::eq(const Field& a, const Field& b) const {
  return a.packedType == b.packedType && a.mutable_ == b.mutable_ &&
         eq(a.type, b.type);
}

bool RecGroupEquator::eq(const Signature& a, const Signature& b) const {
  return eq(a.params, b.params) && eq(a.results, b.results);
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
      auto& types = info->tuple.types;
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
    case HeapTypeInfo::BasicKind:
      break;
    case HeapTypeInfo::SignatureKind:
      taskList.push_back(Task::scan(&info->signature.results));
      taskList.push_back(Task::scan(&info->signature.params));
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
  std::vector<std::unique_ptr<RecGroupInfo>> recGroups;

  struct Entry {
    std::unique_ptr<HeapTypeInfo> info;
    bool initialized = false;
    Entry() {
      // We need to eagerly allocate the HeapTypeInfo so we have a TypeID to use
      // to refer to it before it is initialized. Arbitrarily choose a default
      // value.
      info = std::make_unique<HeapTypeInfo>(Signature());
      set(Signature());
      initialized = false;
    }
    void set(HeapTypeInfo&& hti) {
      hti.supertype = info->supertype;
      hti.recGroup = info->recGroup;
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

TypeBuilder::TypeBuilder(TypeBuilder&& other) = default;
TypeBuilder& TypeBuilder::operator=(TypeBuilder&& other) = default;

void TypeBuilder::grow(size_t n) {
  assert(size() + n >= size());
  impl->entries.resize(size() + n);
}

size_t TypeBuilder::size() { return impl->entries.size(); }

void TypeBuilder::setHeapType(size_t i, HeapType::BasicHeapType basic) {
  assert(i < size() && "Index out of bounds");
  impl->entries[i].set(basic);
}

void TypeBuilder::setHeapType(size_t i, Signature signature) {
  assert(i < size() && "index out of bounds");
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

bool TypeBuilder::isBasic(size_t i) {
  assert(i < size() && "index out of bounds");
  return impl->entries[i].info->kind == HeapTypeInfo::BasicKind;
}

HeapType::BasicHeapType TypeBuilder::getBasic(size_t i) {
  assert(isBasic(i));
  return impl->entries[i].info->basic;
}

HeapType TypeBuilder::getTempHeapType(size_t i) {
  assert(i < size() && "index out of bounds");
  return impl->entries[i].get();
}

Type TypeBuilder::getTempTupleType(const Tuple& tuple) {
  Type ret = impl->typeStore.insert(tuple);
  if (tuple.types.size() > 1) {
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

void TypeBuilder::createRecGroup(size_t i, size_t length) {
  assert(i <= size() && i + length <= size() && "group out of bounds");
  // Only materialize nontrivial recursion groups.
  if (length < 2) {
    return;
  }
  auto& groups = impl->recGroups;
  groups.emplace_back(std::make_unique<RecGroupInfo>());
  for (; length > 0; --length) {
    auto& info = impl->entries[i + length - 1].info;
    assert(info->recGroup == nullptr && "group already assigned");
    info->recGroup = groups.back().get();
  }
}

namespace {

// Helper for TypeBuilder::build() that keeps track of temporary types and
// provides logic for replacing them gradually with more canonical types.
struct CanonicalizationState {
  // The list of types being built and canonicalized. Will eventually be
  // returned to the TypeBuilder user.
  std::vector<HeapType> results;
  // The newly constructed, temporary HeapTypeInfos that still need to be
  // canonicalized.
  std::vector<std::unique_ptr<HeapTypeInfo>> newInfos;

  // Either the fully canonical HeapType or a new temporary HeapTypeInfo that a
  // previous HeapTypeInfo will be replaced with.
  struct Replacement : std::variant<HeapType, std::unique_ptr<HeapTypeInfo>> {
    using Super = std::variant<HeapType, std::unique_ptr<HeapTypeInfo>>;
    Replacement(std::unique_ptr<HeapTypeInfo>&& info)
      : Super(std::move(info)) {}
    Replacement(HeapType type) : Super(type) {}
    HeapType* getHeapType() { return std::get_if<HeapType>(this); }
    std::unique_ptr<HeapTypeInfo>* getHeapTypeInfo() {
      return std::get_if<std::unique_ptr<HeapTypeInfo>>(this);
    }
    HeapType getAsHeapType() {
      if (auto* type = getHeapType()) {
        return *type;
      }
      return asHeapType(*getHeapTypeInfo());
    }
  };

  using ReplacementMap = std::unordered_map<HeapType, Replacement>;

  // Updates the `results` and `newInfo` lists, but does not modify any of the
  // infos to update HeapType use sites.
  void updateShallow(ReplacementMap& replacements);
  // Updates the HeapType use sites within `info`.
  void updateUses(ReplacementMap& replacements,
                  std::unique_ptr<HeapTypeInfo>& info);
  // Updates lists and uses.
  void update(ReplacementMap& replacements);

#if TRACE_CANONICALIZATION
  void dump() {
    IndexedTypeNameGenerator print(results);
    std::cerr << "Results:\n";
    for (size_t i = 0; i < results.size(); ++i) {
      std::cerr << i << ": " << print(results[i]) << "\n";
    }
    std::cerr << "NewInfos:\n";
    for (size_t i = 0; i < newInfos.size(); ++i) {
      std::cerr << print(asHeapType(newInfos[i])) << "\n";
    }
    std::cerr << '\n';
  }
#endif // TRACE_CANONICALIZATION
};

void CanonicalizationState::update(ReplacementMap& replacements) {
  if (replacements.empty()) {
    return;
  }
  updateShallow(replacements);
  for (auto& info : newInfos) {
    updateUses(replacements, info);
  }
}

void CanonicalizationState::updateShallow(ReplacementMap& replacements) {
  if (replacements.empty()) {
    return;
  }

  // Update the results vector.
  for (auto& type : results) {
    if (auto it = replacements.find(type); it != replacements.end()) {
      type = it->second.getAsHeapType();
    }
  }

  // Remove replaced types from newInfos.
  bool needsConsolidation = false;
  for (auto& info : newInfos) {
    HeapType oldType = asHeapType(info);
    if (auto it = replacements.find(oldType); it != replacements.end()) {
      auto& replacement = it->second;
      if (auto* newInfo = replacement.getHeapTypeInfo()) {
        // Replace the old info with the new info in `newInfos`, replacing the
        // moved info in `replacement` with the corresponding new HeapType so we
        // can still perform the correct replacement in the next step.
        HeapType newType = asHeapType(*newInfo);
        info = std::move(*newInfo);
        replacement = {newType};
      } else {
        // The old info is replaced, but there is no new Info to replace it, so
        // just delete the old info. We will remove the holes in `newInfos`
        // afterwards.
        info = nullptr;
        needsConsolidation = true;
      }
    }
  }
  if (needsConsolidation) {
    newInfos.erase(std::remove(newInfos.begin(), newInfos.end(), nullptr),
                   newInfos.end());
  }
}

void CanonicalizationState::updateUses(ReplacementMap& replacements,
                                       std::unique_ptr<HeapTypeInfo>& info) {
  if (replacements.empty()) {
    return;
  }
  // Replace all old types reachable from `info`.
  struct ChildUpdater : HeapTypeChildWalker<ChildUpdater> {
    ReplacementMap& replacements;
    ChildUpdater(ReplacementMap& replacements) : replacements(replacements) {}
    void noteChild(HeapType* child) {
      if (auto it = replacements.find(*child); it != replacements.end()) {
        *child = it->second.getAsHeapType();
      }
    }
  };
  HeapType root = asHeapType(info);
  ChildUpdater(replacements).walkRoot(&root);

  // We may need to update its supertype as well.
  if (info->supertype) {
    HeapType super(uintptr_t(info->supertype));
    if (auto it = replacements.find(super); it != replacements.end()) {
      info->supertype = getHeapTypeInfo(it->second.getAsHeapType());
    }
  }
}

// Replaces temporary types and heap types in a type definition graph with their
// globally canonical versions to prevent temporary types or heap type from
// leaking into the global stores.
void globallyCanonicalize(CanonicalizationState& state) {
  // Map each temporary Type and HeapType to the locations where they will
  // have to be replaced with canonical Types and HeapTypes.
  struct Locations : TypeGraphWalker<Locations> {
    std::unordered_map<Type, std::unordered_set<Type*>> types;
    std::unordered_map<HeapType, std::unordered_set<HeapType*>> heapTypes;

    void preVisitType(Type* type) {
      if (!type->isBasic()) {
        types[*type].insert(type);
      }
    }
    void preVisitHeapType(HeapType* ht) {
      if (!ht->isBasic()) {
        heapTypes[*ht].insert(ht);
      }
    }
  };

  Locations locations;
  for (auto& type : state.results) {
    if (!type.isBasic() && getHeapTypeInfo(type)->isTemp) {
      locations.walkRoot(&type);
    }
  }

#if TRACE_CANONICALIZATION
  std::cerr << "Initial Types:\n";
  state.dump();
#endif

  // Canonicalize HeapTypes at all their use sites. HeapTypes for which there
  // was not already a globally canonical version are moved to the global store
  // to become the canonical version. These new canonical HeapTypes still
  // contain references to temporary Types owned by the TypeBuilder, so we must
  // subsequently replace those references with references to canonical Types.
  //
  // Keep a lock on the global HeapType store as long as it can reach temporary
  // types to ensure that no other threads observe the temporary types, for
  // example if another thread concurrently constructs a new HeapType with the
  // same shape as one being canonicalized here. This cannot happen with Types
  // because they are hashed in the global store by pointer identity, which has
  // not yet escaped the builder, rather than shape.
  std::lock_guard<std::recursive_mutex> lock(globalHeapTypeStore.mutex);
  std::unordered_map<HeapType, HeapType> canonicalHeapTypes;
  for (auto& info : state.newInfos) {
    HeapType original = asHeapType(info);
    HeapType canonical = globalHeapTypeStore.insert(std::move(info));
    if (original != canonical) {
      canonicalHeapTypes[original] = canonical;
    }
  }
  for (auto& [original, canonical] : canonicalHeapTypes) {
    for (HeapType* use : locations.heapTypes.at(original)) {
      *use = canonical;
    }
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

#if TRACE_CANONICALIZATION
  std::cerr << "Final Types:\n";
  state.dump();
#endif
}

std::optional<TypeBuilder::Error>
validateSubtyping(const std::vector<HeapType>& types) {
  for (size_t i = 0; i < types.size(); ++i) {
    HeapType type = types[i];
    if (type.isBasic()) {
      continue;
    }
    auto* sub = getHeapTypeInfo(type);
    auto* super = sub->supertype;
    if (super == nullptr) {
      continue;
    }

    auto fail = [&]() {
      return TypeBuilder::Error{i, TypeBuilder::ErrorReason::InvalidSupertype};
    };

    if (sub->kind != super->kind) {
      return fail();
    }
    SubTyper typer;
    switch (sub->kind) {
      case HeapTypeInfo::BasicKind:
        WASM_UNREACHABLE("unexpected kind");
      case HeapTypeInfo::SignatureKind:
        if (!typer.isSubType(sub->signature, super->signature)) {
          return fail();
        }
        break;
      case HeapTypeInfo::StructKind:
        if (!typer.isSubType(sub->struct_, super->struct_)) {
          return fail();
        }
        break;
      case HeapTypeInfo::ArrayKind:
        if (!typer.isSubType(sub->array, super->array)) {
          return fail();
        }
        break;
    }
  }
  return {};
}

std::optional<TypeBuilder::Error>
canonicalizeNominal(CanonicalizationState& state) {
  for (auto& info : state.newInfos) {
    info->recGroup = nullptr;
  }

  // Nominal types do not require separate canonicalization, so just validate
  // that their subtyping is correct.

  // Ensure there are no cycles in the subtype graph. This is the classic DFA
  // algorithm for detecting cycles, but in the form of a simple loop because
  // each node (type) has at most one child (supertype).
  std::unordered_set<HeapTypeInfo*> checked;
  for (size_t i = 0; i < state.results.size(); ++i) {
    HeapType type = state.results[i];
    if (type.isBasic()) {
      continue;
    }
    std::unordered_set<HeapTypeInfo*> path;
    for (auto* curr = getHeapTypeInfo(type);
         curr != nullptr && !checked.count(curr);
         curr = curr->supertype) {
      if (!path.insert(curr).second) {
        return TypeBuilder::Error{i, TypeBuilder::ErrorReason::SelfSupertype};
      }
    }
    // None of the types in `path` reach themselves.
    checked.insert(path.begin(), path.end());
  }

  return {};
}

std::optional<TypeBuilder::Error> canonicalizeIsorecursive(
  CanonicalizationState& state,
  std::vector<std::unique_ptr<RecGroupInfo>>& recGroupInfos) {
  // Fill out the recursion groups.
  for (auto& info : state.newInfos) {
    if (info->recGroup != nullptr) {
      info->recGroupIndex = info->recGroup->size();
      info->recGroup->push_back(asHeapType(info));
    }
  }

  // Map rec groups to the unique pointers to their infos.
  std::unordered_map<RecGroup, std::unique_ptr<RecGroupInfo>> groupInfoMap;
  for (auto& info : recGroupInfos) {
    RecGroup group{uintptr_t(info.get())};
    groupInfoMap[group] = std::move(info);
  }

  // Check that supertypes precede their subtypes and that other child types
  // either precede their parents or appear later in the same recursion group.
  // `indexOfType` both maps types to their indices and keeps track of which
  // types we have seen so far.
  std::unordered_map<HeapType, size_t> indexOfType;
  std::vector<RecGroup> groups;
  size_t groupStart = 0;

  // Validate the children of all types in a recursion group after all the types
  // have been registered in `indexOfType`.
  auto finishGroup = [&](size_t groupEnd) -> std::optional<TypeBuilder::Error> {
    for (size_t index = groupStart; index < groupEnd; ++index) {
      HeapType type = state.results[index];
      for (HeapType child : type.getHeapTypeChildren()) {
        // Only basic children, globally canonical children, and children
        // defined in this or previous recursion groups are allowed.
        if (isTemp(child) && !indexOfType.count(child)) {
          return {{index, TypeBuilder::ErrorReason::ForwardChildReference}};
        }
      }
    }
    groupStart = groupEnd;
    return {};
  };

  for (size_t index = 0; index < state.results.size(); ++index) {
    HeapType type = state.results[index];
    if (type.isBasic()) {
      continue;
    }
    // Validate the supertype. Temporary supertypes must precede their subtypes.
    if (auto super = type.getSuperType()) {
      if (isTemp(*super) && !indexOfType.count(*super)) {
        return {{index, TypeBuilder::ErrorReason::ForwardSupertypeReference}};
      }
    }
    // Check whether we have finished a rec group.
    auto newGroup = type.getRecGroup();
    if (groups.empty() || groups.back() != newGroup) {
      if (auto error = finishGroup(index)) {
        return *error;
      }
      groups.push_back(newGroup);
    }
    // Register this type as seen.
    indexOfType.insert({type, index});
  }
  if (auto error = finishGroup(state.results.size())) {
    return *error;
  }

  // Now that we know everything is valid, start canonicalizing recursion
  // groups. Before canonicalizing each group, update all the HeapType use sites
  // within it to make sure it only refers to other canonical groups or to
  // itself (since other groups it refers to may have been duplicates of
  // previously canonicalized groups and therefore would not be canonical). To
  // canonicalize the group, try to insert it into the global store. If that
  // fails, we already have an isorecursively equivalent group, so update the
  // replacements accordingly.
  CanonicalizationState::ReplacementMap replacements;
  {
    std::lock_guard<std::mutex> lock(globalRecGroupStore.mutex);
    groupStart = 0;
    for (auto group : groups) {
      size_t size = group.size();
      for (size_t i = 0; i < size; ++i) {
        state.updateUses(replacements, state.newInfos[groupStart + i]);
      }
      groupStart += size;
      RecGroup canonical(0);
      // There may or may not be a `RecGroupInfo` for this group depending on
      // whether it is a singleton group or not. If there is one, it is in the
      // `groupInfoMap`. Make the info available for the global store to take
      // ownership of it in case this group is made the canonical group for its
      // structure.
      if (auto it = groupInfoMap.find(group); it != groupInfoMap.end()) {
        canonical = globalRecGroupStore.insert(std::move(it->second));
      } else {
        canonical = globalRecGroupStore.insert(group);
      }
      if (group != canonical) {
        // Replace the non-canonical types with their canonical equivalents.
        assert(canonical.size() == size);
        for (size_t i = 0; i < size; ++i) {
          replacements.insert({group[i], canonical[i]});
        }
      }
    }
  }
  state.updateShallow(replacements);
  return {};
}

void canonicalizeBasicTypes(CanonicalizationState& state) {
  // Replace heap types backed by BasicKind HeapTypeInfos with their
  // corresponding BasicHeapTypes. The heap types backed by BasicKind
  // HeapTypeInfos exist only to support building basic types in a TypeBuilder
  // and are never canonical.
  CanonicalizationState::ReplacementMap replacements;
  for (auto& info : state.newInfos) {
    if (info->kind == HeapTypeInfo::BasicKind) {
      replacements.insert({asHeapType(info), HeapType(info->basic)});
    }
    // Basic supertypes should be implicit.
    if (info->supertype && info->supertype->kind == HeapTypeInfo::BasicKind) {
      info->supertype = nullptr;
    }
  }
  state.update(replacements);

  if (replacements.size()) {
    // Canonicalizing basic heap types may cause their parent types to become
    // canonicalizable as well, for example after creating `(ref null any)` we
    // can futher canonicalize to `anyref`.
    struct TypeCanonicalizer : TypeGraphWalkerBase<TypeCanonicalizer> {
      void scanType(Type* type) {
        if (type->isTuple()) {
          TypeGraphWalkerBase<TypeCanonicalizer>::scanType(type);
        } else {
          *type = asCanonical(*type);
        }
      }
    };
    for (auto& info : state.newInfos) {
      auto root = asHeapType(info);
      TypeCanonicalizer{}.walkRoot(&root);
    }
  }
}

} // anonymous namespace

TypeBuilder::BuildResult TypeBuilder::build() {
  size_t entryCount = impl->entries.size();

  // Initialize the canonicalization state using the HeapTypeInfos from the
  // builder, marking entries finalized.
  CanonicalizationState state;
  state.results.reserve(entryCount);
  state.newInfos.reserve(entryCount);
  for (size_t i = 0; i < entryCount; ++i) {
    assert(impl->entries[i].initialized &&
           "Cannot access uninitialized HeapType");
    auto& info = impl->entries[i].info;
    info->isFinalized = true;
    state.results.push_back(asHeapType(info));
    state.newInfos.emplace_back(std::move(info));
  }

  // Eagerly replace references to built basic heap types so the more
  // complicated canonicalization algorithms don't need to consider them.
  canonicalizeBasicTypes(state);

#if TRACE_CANONICALIZATION
  std::cerr << "After replacing basic heap types:\n";
  state.dump();
#endif

#if TIME_CANONICALIZATION
  using instant_t = std::chrono::time_point<std::chrono::steady_clock>;
  auto getMillis = [&](instant_t start, instant_t end) {
    return std::chrono::duration_cast<std::chrono::milliseconds>(end - start)
      .count();
  };
  auto start = std::chrono::steady_clock::now();
#endif

  switch (typeSystem) {
    case TypeSystem::Nominal:
      if (auto error = canonicalizeNominal(state)) {
        return {*error};
      }
      break;
    case TypeSystem::Isorecursive:
      if (auto error = canonicalizeIsorecursive(state, impl->recGroups)) {
        return {*error};
      }
      break;
  }

#if TIME_CANONICALIZATION
  auto afterStructureCanonicalization = std::chrono::steady_clock::now();
#endif

  globallyCanonicalize(state);

#if TIME_CANONICALIZATION
  auto end = std::chrono::steady_clock::now();
  std::cerr << "Total canonicalization time was " << getMillis(start, end)
            << " ms\n";
  std::cerr << "Structure canonicalization took "
            << getMillis(start, afterStructureCanonicalization) << " ms\n";
  std::cerr << "Global canonicalization took "
            << getMillis(afterStructureCanonicalization, end) << " ms\n";
#endif

  // Check that the declared supertypes are structurally valid.
  if (auto error = validateSubtyping(state.results)) {
    return {*error};
  }

  // Note built signature types. See comment in `HeapType::HeapType(Signature)`.
  for (auto type : state.results) {
    // Do not cache types with explicit supertypes (that is, whose supertype is
    // not HeapType::func). We don't want to reuse such types because then we'd
    // be adding subtyping relationships that are not in the input.
    if (type.isSignature() && (getTypeSystem() == TypeSystem::Nominal) &&
        !type.getSuperType()) {
      nominalSignatureCache.insertType(type);
    }
  }

  return {state.results};
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
      wasm::rehash(digest, info.ref.nullable);
      wasm::rehash(digest, info.ref.heapType);
      return digest;
  }
  WASM_UNREACHABLE("unexpected kind");
}

size_t
hash<wasm::HeapTypeInfo>::operator()(const wasm::HeapTypeInfo& info) const {
  return wasm::hash(uintptr_t(&info));
}

} // namespace std
