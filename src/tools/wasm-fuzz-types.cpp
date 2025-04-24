/*
 * Copyright 2021 WebAssembly Community Group participants
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

#include <optional>
#include <random>
#include <string>
#include <variant>

#include "support/command-line.h"
#include "tools/fuzzing/heap-types.h"
#include "tools/fuzzing/random.h"
#include "wasm-type-printing.h"
#include "wasm-type-shape.h"

namespace wasm {

using RandEngine = std::mt19937_64;

uint64_t getSeed() {
  // Return a (truly) random 64-bit value.
  std::random_device rand;
  return std::uniform_int_distribution<uint64_t>{}(rand);
}

struct Fuzzer {
  bool verbose;

  // Initialized by `run` for checkers and possible later inspection
  std::vector<HeapType> types;
  std::vector<std::vector<Index>> subtypeIndices;
  Random rand;

  Fuzzer(bool verbose) : verbose(verbose), rand({}) {}

  // Generate types and run checkers on them.
  void run(uint64_t seed);

  static void printTypes(const std::vector<HeapType>&);

  // Checkers for various properties.
  void checkSubtypes() const;
  void checkLUBs() const;
  void checkCanonicalization();
  void checkInhabitable();
  void checkRecGroupShapes();
};

void Fuzzer::run(uint64_t seed) {
  // TODO: Reset the global type state to avoid monotonically increasing
  // memory use.
  RandEngine getRand(seed);
  std::cout << "Running with seed " << seed << "\n";

  // 4kb of random bytes should be enough for anyone!
  std::vector<char> bytes(4096);
  for (size_t i = 0; i < bytes.size(); i += sizeof(uint64_t)) {
    *(uint64_t*)(bytes.data() + i) = getRand();
  }
  rand = Random(std::move(bytes));

  // TODO: Options to control the size or set it randomly.
  HeapTypeGenerator generator =
    HeapTypeGenerator::create(rand, FeatureSet::All, 20);
  auto result = generator.builder.build();
  if (auto* err = result.getError()) {
    Fatal() << "Failed to build types: " << err->reason << " at index "
            << err->index;
  }
  types = std::move(*result);
  subtypeIndices = std::move(generator.subtypeIndices);

  if (verbose) {
    printTypes(types);
  }

  checkSubtypes();
  checkLUBs();
  checkCanonicalization();
  checkInhabitable();
  checkRecGroupShapes();
}

void Fuzzer::printTypes(const std::vector<HeapType>& types) {
  std::cout << "Built " << types.size() << " types:\n";
  struct FatalTypeNameGenerator
    : TypeNameGeneratorBase<FatalTypeNameGenerator> {
    TypeNames getNames(HeapType type) {
      Fatal() << "trying to print unknown heap type";
    }
  } fatalGenerator;
  IndexedTypeNameGenerator<FatalTypeNameGenerator> print(types, fatalGenerator);
  std::unordered_map<HeapType, size_t> seen;
  std::optional<RecGroup> currRecGroup;
  auto inRecGroup = [&]() { return currRecGroup && currRecGroup->size() > 1; };
  for (size_t i = 0; i < types.size(); ++i) {
    auto type = types[i];
    if (type.getRecGroup() != currRecGroup) {
      if (inRecGroup()) {
        std::cout << ")\n";
      }
      currRecGroup = type.getRecGroup();
      if (inRecGroup()) {
        std::cout << "(rec\n";
      }
    }
    if (inRecGroup()) {
      std::cout << ' ';
    }
    auto [it, inserted] = seen.insert({type, i});
    if (inserted) {
      std::cout << print(type);
    } else {
      std::cout << "(type $" << i << " identical to $" << it->second << ")";
    }
    std::cout << "\n";
  }
  if (inRecGroup()) {
    std::cout << ")\n";
  }
}

void Fuzzer::checkSubtypes() const {
  for (size_t super = 0; super < types.size(); ++super) {
    for (auto sub : subtypeIndices[super]) {
      if (!HeapType::isSubType(types[sub], types[super])) {
        Fatal() << "HeapType " << sub << " should be a subtype of HeapType "
                << super << " but is not!\n"
                << sub << ": " << types[sub] << "\n"
                << super << ": " << types[super] << "\n";
      }
    }
  }
}

void Fuzzer::checkLUBs() const {
  // For each unordered pair of types...
  for (size_t i = 0; i < types.size(); ++i) {
    for (size_t j = i; j < types.size(); ++j) {
      HeapType a = types[i], b = types[j];
      // Check that their LUB is stable when calculated multiple times and in
      // reverse order.
      auto lub = HeapType::getLeastUpperBound(a, b);
      if (lub) {
        if (lub != HeapType::getLeastUpperBound(b, a) ||
            lub != HeapType::getLeastUpperBound(a, b)) {
          Fatal() << "Could not calculate a stable LUB of HeapTypes " << i
                  << " and " << j << "!\n"
                  << i << ": " << a << "\n"
                  << j << ": " << b << "\n";
        }
        // Check that each type is a subtype of the LUB.
        if (!HeapType::isSubType(a, *lub)) {
          Fatal() << "HeapType " << i
                  << " is not a subtype of its LUB with HeapType " << j << "!\n"
                  << i << ": " << a << "\n"
                  << j << ": " << b << "\n"
                  << "lub: " << *lub << "\n";
        }
        if (!HeapType::isSubType(b, *lub)) {
          Fatal() << "HeapType " << j
                  << " is not a subtype of its LUB with HeapType " << i << "!\n"
                  << i << ": " << a << "\n"
                  << j << ": " << b << "\n"
                  << "lub: " << *lub << "\n";
        }
        // Check that the LUB of each type and the original LUB is still the
        // original LUB.
        if (lub != HeapType::getLeastUpperBound(a, *lub)) {
          Fatal() << "The LUB of HeapType " << i << " and HeapType " << j
                  << " should be the LUB of itself and HeapType " << i
                  << ", but it is not!\n"
                  << i << ": " << a << "\n"
                  << j << ": " << b << "\n"
                  << "lub: " << *lub << "\n";
        }
        if (lub != HeapType::getLeastUpperBound(*lub, b)) {
          Fatal() << "The LUB of HeapType " << i << " and HeapType " << j
                  << " should be the LUB of itself and HeapType " << j
                  << ", but it is not!\n"
                  << i << ": " << a << "\n"
                  << j << ": " << b << "\n"
                  << "lub: " << *lub << "\n";
        }
      } else {
        // No LUB. Check that this is symmetrical.
        if (auto lub2 = HeapType::getLeastUpperBound(b, a)) {
          Fatal() << "There is no LUB of HeapType " << i << " and HeapType "
                  << j << ", but there is a LUB in the reverse direction!\n"
                  << i << ": " << a << "\n"
                  << j << ": " << b << "\n"
                  << "lub: " << *lub2 << "\n";
        }
        // There also shouldn't be a subtype relation in this case.
        if (HeapType::isSubType(a, b)) {
          Fatal() << "There is no LUB of HeapType " << i << " and HeapType "
                  << j << ", but HeapType " << i << " is a subtype of HeapType "
                  << j << "!\n"
                  << i << ": " << a << "\n"
                  << j << ": " << b << "\n";
        }
        if (HeapType::isSubType(b, a)) {
          Fatal() << "There is no LUB of HeapType " << i << " and HeapType "
                  << j << ", but HeapType " << j << " is a subtype of HeapType "
                  << i << "!\n"
                  << i << ": " << a << "\n"
                  << j << ": " << b << "\n";
        }
      }
    }
  }
}

void Fuzzer::checkCanonicalization() {
  // Check that structural canonicalization is working correctly by building the
  // types again, choosing randomly between equivalent possible children for
  // each definition from both the new and old sets of built types.
  TypeBuilder builder(types.size());

  // Helper for creating new definitions of existing types, randomly choosing
  // between canonical and temporary components.
  struct Copier {
    Random& rand;
    const std::vector<HeapType>& types;
    TypeBuilder& builder;

    // For each type, the indices in `types` at which it appears.
    std::unordered_map<HeapType, std::vector<Index>> typeIndices;

    // For each type, the index one past the end of its rec group, or
    // alternatively the cumulative size of its rec group and previous rec
    // groups.
    std::vector<Index> recGroupEnds;

    // The index of the type we are currently building.
    Index index = 0;

    Copier(Fuzzer& parent, TypeBuilder& builder)
      : rand(parent.rand), types(parent.types), builder(builder) {
      // Set the type indices
      for (size_t i = 0; i < types.size(); ++i) {
        typeIndices[types[i]].push_back(i);
      }

      // Set supertypes
      // TODO: support setting old canonical types as the supertypes.
      const auto& subtypeIndices = parent.subtypeIndices;
      for (size_t super = 0; super < subtypeIndices.size(); ++super) {
        for (auto sub : subtypeIndices[super]) {
          if (sub != super) {
            builder[sub].subTypeOf(builder[super]);
          }
        }
      }

      // Set finality and shareability
      for (size_t i = 0; i < types.size(); ++i) {
        builder[i].setOpen(types[i].isOpen());
        builder[i].setShared(types[i].getShared());
      }

      // Set up recursion groups and record group ends to ensure we only select
      // valid children.
      recGroupEnds.reserve(builder.size());
      // Set up recursion groups
      std::optional<RecGroup> currGroup;
      size_t currGroupStart = 0;
      auto finishGroup = [&](Index end) {
        builder.createRecGroup(currGroupStart, end - currGroupStart);
        for (Index i = currGroupStart; i < end; ++i) {
          recGroupEnds.push_back(end);
        }
        currGroupStart = end;
      };
      for (Index i = 0; i < types.size(); ++i) {
        auto newGroup = types[i].getRecGroup();
        if (!currGroup || newGroup != currGroup ||
            types[i] == types[currGroupStart]) {
          finishGroup(i);
          currGroup = newGroup;
        }
      }
      finishGroup(builder.size());

      // Copy the original types
      for (; index < types.size(); ++index) {
        auto type = types[index];
        switch (type.getKind()) {
          case HeapTypeKind::Func:
            builder[index] = getSignature(type.getSignature());
            continue;
          case HeapTypeKind::Struct:
            builder[index] = getStruct(type.getStruct());
            continue;
          case HeapTypeKind::Array:
            builder[index] = getArray(type.getArray());
            continue;
          case HeapTypeKind::Cont:
            WASM_UNREACHABLE("TODO: cont");
          case HeapTypeKind::Basic:
            break;
        }
        WASM_UNREACHABLE("unexpected type kind");
      }
    }

    struct NewHeapType : HeapType {};
    struct OldHeapType : HeapType {};
    struct CopiedHeapType {
      std::variant<NewHeapType, OldHeapType> type;
      NewHeapType* getNew() { return std::get_if<NewHeapType>(&type); }
      OldHeapType* getOld() { return std::get_if<OldHeapType>(&type); }
      HeapType get() {
        return getNew() ? HeapType(*getNew()) : HeapType(*getOld());
      }
    };

    struct NewType : Type {};
    struct OldType : Type {};
    struct CopiedType {
      std::variant<NewType, OldType> type;
      NewType* getNew() { return std::get_if<NewType>(&type); }
      OldType* getOld() { return std::get_if<OldType>(&type); }
      Type get() { return getNew() ? Type(*getNew()) : Type(*getOld()); }
    };

    CopiedHeapType getChildHeapType(HeapType old) {
      auto it = typeIndices.find(old);
      if (it == typeIndices.end()) {
        // This is a basic heap type and wasn't explicitly built.
        assert(old.isBasic());
        return {OldHeapType{old}};
      }
      assert(!old.isBasic());
      // Check whether this child heap type is supposed to be a self-reference
      // into the recursion group we are defining. If it is, we must use the
      // corresponding type in the new recursion group, since anything else
      // would break isorecursive equivalence.
      auto group = old.getRecGroup();
      if (group == types[index].getRecGroup()) {
        // This is a self-reference, so find the correct index, which is the
        // last matching index less than the end of this rec group.
        std::optional<Index> i;
        for (auto candidate : it->second) {
          if (candidate >= recGroupEnds[index]) {
            break;
          }
          i = candidate;
        }
        return {NewHeapType{builder[*i]}};
      }
      // Choose whether to use an old type or a new type
      if (rand.oneIn(2)) {
        // Using a copied heap type; filter out invalid candidates.
        // Filter out invalid candidates.
        std::vector<Index> candidateIndices;
        for (auto i : it->second) {
          if (i < recGroupEnds[index]) {
            candidateIndices.push_back(i);
          }
        }
        assert(!candidateIndices.empty());
        Index i = rand.pick(candidateIndices);
        return {NewHeapType{builder[i]}};
      } else {
        // Using an original heap type.
        Index i = rand.pick(it->second);
        return {OldHeapType{types[i]}};
      }
    }

    CopiedType getTuple(Type old) {
      TypeList types;
      types.reserve(old.size());
      bool hasTempChild = false;
      for (auto type : old) {
        auto copied = getType(type);
        if (copied.getNew()) {
          hasTempChild = true;
        }
        types.push_back(copied.get());
      }
      // Must use a temporary type if we have a temporary child, otherwise we
      // can choose.
      if (hasTempChild || rand.oneIn(2)) {
        return {NewType{builder.getTempTupleType(types)}};
      } else {
        return {OldType{Tuple(std::move(types))}};
      }
    }

    CopiedType getRef(Type old) {
      auto copied = getChildHeapType(old.getHeapType());
      auto type = copied.get();
      auto nullability = old.getNullability();
      if (copied.getNew()) {
        // The child is temporary, so we must put it in a temporary type.
        return {NewType{builder.getTempRefType(type, nullability)}};
      } else {
        // The child is canonical, so we can either put it in a temporary type
        // or use the canonical type.
        if (rand.oneIn(2)) {
          return {NewType{builder.getTempRefType(type, nullability)}};
        } else {
          return {OldType{Type(type, nullability)}};
        }
      }
    }

    CopiedType getType(Type old) {
      if (old.isTuple()) {
        return getTuple(old);
      } else if (old.isRef()) {
        return getRef(old);
      } else {
        assert(old.isBasic());
        return {OldType{old}};
      }
    }

    Field getField(Field old) {
      old.type = getType(old.type).get();
      return old;
    }

    Signature getSignature(Signature old) {
      return {getType(old.params).get(), getType(old.results).get()};
    }

    Struct getStruct(const Struct& old) {
      FieldList fields;
      fields.reserve(old.fields.size());
      for (const auto& field : old.fields) {
        fields.push_back(getField(field));
      }
      return {std::move(fields)};
    }

    Array getArray(Array old) {
      old.element = getField(old.element);
      return old;
    }
  };

  Copier{*this, builder};

  auto result = builder.build();
  if (auto* error = result.getError()) {
    IndexedTypeNameGenerator print(types);
    Fatal() << "Failed to build copies of the types: " << error->reason
            << " at index " << error->index;
  }
  auto newTypes = *result;
  assert(types.size() == newTypes.size());
  for (size_t i = 0; i < types.size(); ++i) {
    if (types[i] != newTypes[i]) {
      IndexedTypeNameGenerator print(types);
      std::cerr << "\n";
      for (size_t j = 0; j < newTypes.size(); ++j) {
        std::cerr << j << ": " << print(newTypes[j]) << "\n";
      }
      Fatal() << "Copy of type at index " << i << " is distinct:\n"
              << "original: " << print(types[i]) << '\n'
              << "copy:     " << print(newTypes[i]);
    }
  }
}

void Fuzzer::checkInhabitable() {
  std::vector<HeapType> inhabitable = HeapTypeGenerator::makeInhabitable(types);
  if (verbose) {
    std::cout << "\nInhabitable types:\n\n";
    printTypes(inhabitable);
  }

  // Check whether any of the original types are uninhabitable.
  bool haveUninhabitable =
    HeapTypeGenerator::getInhabitable(types).size() != types.size();
  if (haveUninhabitable) {
    // Verify that the transformed types are inhabitable.
    auto verifiedInhabitable = HeapTypeGenerator::getInhabitable(inhabitable);
    if (verifiedInhabitable.size() != inhabitable.size()) {
      IndexedTypeNameGenerator print(inhabitable);
      for (size_t i = 0; i < inhabitable.size(); ++i) {
        if (i > verifiedInhabitable.size() ||
            inhabitable[i] != verifiedInhabitable[i]) {
          Fatal() << "Found uninhabitable type: " << print(inhabitable[i]);
        }
      }
    }
    // TODO: We could also check that the transformed types are the same as the
    // original types up to nullability.
  } else {
    // Verify the produced inhabitable types are the same as the original types
    // (which also implies that they are indeed inhabitable).
    if (types.size() != inhabitable.size()) {
      Fatal() << "Number of inhabitable types does not match number of "
                 "original types";
    }
    for (size_t i = 0; i < types.size(); ++i) {
      if (types[i] != inhabitable[i]) {
        IndexedTypeNameGenerator print(types);
        Fatal() << "makeInhabitable incorrectly changed type "
                << print(types[i]);
      }
    }
  }
}

void Fuzzer::checkRecGroupShapes() {
  using ShapeHash = std::hash<RecGroupShape>;

  // Collect the groups and order types by index.
  std::vector<std::vector<HeapType>> groups;
  std::unordered_map<HeapType, Index> typeIndices;
  for (auto type : types) {
    typeIndices.insert({type, typeIndices.size()});
    // We know we are at the beginning of a new rec group when we see a type
    // that is at index zero of its rec group.
    if (type.getRecGroupIndex() == 0) {
      groups.push_back({type});
    } else {
      assert(!groups.empty());
      groups.back().push_back(type);
    }
  }

  auto less = [&typeIndices](HeapType a, HeapType b) {
    return typeIndices.at(a) < typeIndices.at(b);
  };

  for (size_t i = 0; i < groups.size(); ++i) {
    ComparableRecGroupShape shape(groups[i], less);
    // A rec group should compare equal to itself.
    if (shape != shape) {
      Fatal() << "Rec group shape " << i << " not equal to itself";
    }

    // Its hash should be deterministic
    auto hash = ShapeHash{}(shape);
    if (hash != ShapeHash{}(shape)) {
      Fatal() << "Rec group shape " << i << " has non-deterministic hash";
    }

    // Check how it compares to other groups.
    for (size_t j = i + 1; j < groups.size(); ++j) {
      ComparableRecGroupShape other(groups[j], less);
      bool isLess = shape < other;
      bool isEq = shape == other;
      bool isGreater = shape > other;
      if (isLess + isEq + isGreater == 0) {
        Fatal() << "Rec groups " << i << " and " << j
                << " do not have comparable shapes";
      }
      if (isLess + isEq + isGreater > 1) {
        std::string comparisons;
        auto append = [&](std::string comp) {
          comparisons = comparisons == "" ? comp : comparisons + ", " + comp;
        };
        if (isLess) {
          append("<");
        }
        if (isEq) {
          append("==");
        }
        if (isGreater) {
          append(">");
        }
        Fatal() << "Rec groups " << i << " and " << j << " compare "
                << comparisons;
      }

      auto otherHash = ShapeHash{}(other);
      if (isEq) {
        if (hash != otherHash) {
          Fatal() << "Equivalent rec groups " << i << " and " << j
                  << " do not have equivalent hashes";
        }
      } else {
        // Hash collisions are technically possible, but should be rare enough
        // that we can consider them bugs if the fuzzer finds them.
        if (hash == otherHash) {
          Fatal() << "Hash collision between rec groups " << i << " and " << j;
        }
      }

      if (j + 1 < groups.size()) {
        // Check transitivity.
        RecGroupShape third(groups[j + 1]);
        if ((isLess && other <= third && shape >= third) ||
            (isEq && other == third && shape != third) ||
            (isGreater && other >= third && shape <= third)) {
          Fatal() << "Comparison between rec groups " << i << ", " << j
                  << ", and " << (j + 1) << " is not transitive";
        }
      }
    }
  }
}

} // namespace wasm

int main(int argc, const char* argv[]) {
  using namespace wasm;

  const std::string WasmFuzzTypesOption = "wasm-fuzz-types options";

  Options options("wasm-fuzz-types",
                  "Fuzz type construction, canonicalization, and operations");

  std::optional<uint64_t> seed;
  options.add("--seed",
              "",
              "Run a single workload generated by the given seed",
              WasmFuzzTypesOption,
              Options::Arguments::One,
              [&](Options*, const std::string& arg) {
                seed = uint64_t(std::stoull(arg));
              });

  bool verbose = false;
  options.add("--verbose",
              "-v",
              "Print extra information",
              WasmFuzzTypesOption,
              Options::Arguments::Zero,
              [&](Options*, const std::string& arg) { verbose = true; });

  options.parse(argc, argv);

  Fuzzer fuzzer{verbose};
  if (seed) {
    // Run just a single workload with the given seed.
    fuzzer.run(*seed);
  } else {
    // Continuously run workloads with new randomly generated seeds.
    size_t i = 0;
    RandEngine nextSeed(getSeed());
    while (true) {
      std::cout << "Iteration " << ++i << "\n";
      fuzzer.run(nextSeed());
    }
  }
  return 0;
}
