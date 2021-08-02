/*
 * Copyright 2019 WebAssembly Community Group participants
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

//
// Find struct fields that are always written to with a constant value, and
// replace gets of them with that value.
//
// For example, if we have a vtable type T, and we always create it with one of
// the fields containing a ref.func of the same function F, and there is no
// write to that field of a different value (even using a subtype of T), then
// anywhere we see a get of that field we can place a ref.func of F.
//
// FIXME: This pass assumes a closed world. When we start to allow multi-module
//        wasm GC programs we need to check for type escaping.
//

#include "ir/properties.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace {

// Represents a graph of nominal types. A nominal type knows who its supertype
// is, if there is one; this class provides the list of immedaite subtypes for a
// type.
struct TypeGraph {
  // Add a type to the graph.
  void note(HeapType type) {
    HeapType super;
    if (type.getSuperType(super)) {
      typeSubTypes[super].insert(type);
    }
  }

  const std::unordered_set<HeapType>& getSubTypes(HeapType type) {
    return typeSubTypes[type];
  }

private:
  // Maps a type to its subtypes.
  std::unordered_map<HeapType, std::unordered_set<HeapType>> typeSubTypes;
};

// Represents data about what constant values are possible in a particular
// place. There may be no values, or one, or many, or if a non-constant value is
// possible, then all we can say is that the value is "unknown" - it can be
// anything.
//
// Currently this just looks for a single constant value, and even two constant
// values are treated as unknown. It may be worth optimizing more than that.
// TODO look into that
struct PossibleConstantValues {
  // Note a written value as we see it, and update our internal knowledge based
  // on it and all previous values noted.
  void note(Literal curr) {
    if (!noted) {
      // This is the first value.
      value = curr;
      noted = true;
      return;
    }

    // This is a subsequent value. Check if it is different from all previous
    // ones.
    if (value != curr) {
      noteUnknown();
    }
  }

  // Notes a value that is unknown - it can be anything. We have failed to
  // identify a constant value here.
  void noteUnknown() {
    value = Literal(Type::none);
    noted = true;
  }

  // Combine the information in a given PossibleConstantValues to this one. This is the same
  // as if we have called note*() on us with all the history of calls to that
  // other object.
  //
  // Returns whether we changed anything.
  bool combine(const PossibleConstantValues& other) {
    if (!other.noted) {
      return false;
    }
    if (!noted) {
      *this = other;
      return other.noted;
    }
    if (!isConstant()) {
      return false;
    }
    if (!other.isConstant() || getConstantValue() != other.getConstantValue()) {
      noteUnknown();
      return true;
    }
    return false;
  }

  // Check if all the values are identical and constant.
  bool isConstant() const { return value.type.isConcrete(); }

  Literal getConstantValue() const {
    assert(isConstant());
    return value;
  }

  bool hasWrites() const {
    return noted;
  }

  void dump(std::ostream& o) {
    o << '[';
    if (!hasWrites()) {
      o << "unwritten";
    } else if (!isConstant()) {
      o << "unknown";
    } else {
      o << value;
    }
    o << ']';
  }

private:
  // Whether we have noted any values at all.
  bool noted = false;

  // The one value we have seen, if there is one. Initialized to have type
  // unreachable to indicate nothing has been seen yet. When values conflict,
  // we mark this as type none to indicate failure. Otherwise, a concrete type
  // indicates we have seen one value so far.
  Literal value;
};

// A vector of PossibleConstantValues. One such vector will be used per struct type,
// where each element in the vector represents a field. We always
// assume that the vectors are pre-initialized to the right length before
// accessing any data, which this class enforces using assertions, and which is
// implemented in StructValuesMap.
struct StructValues : public std::vector<PossibleConstantValues> {
  PossibleConstantValues& operator[](size_t index) {
    assert(index < size());
    return std::vector<PossibleConstantValues>::operator[](index);
  }
};

// Map of types to information about the values its fields can take. Concretely,
// this mapes a type to a StructValues which has one element per
// field.
struct StructValuesMap
  : public std::unordered_map<HeapType, StructValues> {
  // When we access an item, if it does not already exist, create it with a
  // vector of the right length.
  StructValues& operator[](HeapType type) {
    auto iter = find(type);
    if (iter != end()) {
      return iter->second;
    }
    auto& ret = std::unordered_map<HeapType, StructValues>::operator[](type);
    ret.resize(type.getStruct().fields.size());
    return ret;
  }

  void dump(std::ostream& o) {
    o << "dump " << this << '\n';
    for (auto& kv : (*this)) {
      auto type = kv.first;
      auto& vec = kv.second;
      o << "dump " << type << " " << &vec << ' ';
      for (auto x : vec) {
        x.dump(o);
        o << " ";
      };
      o << '\n';
    }
  }
};

// Map of function to their field value infos. We compute those in parallel.
using FunctionStructValuesMap = std::unordered_map<Function*, StructValuesMap>;

// Scan each function to find all its writes to struct fields.
struct Scanner : public WalkerPass<PostWalker<Scanner>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new Scanner(functionInfos); }

  Scanner(FunctionStructValuesMap* functionInfos)
    : functionInfos(functionInfos) {}

  void visitStructNew(StructNew* curr) {
    auto type = curr->type;
    if (type == Type::unreachable) {
      return;
    }
    auto heapType = type.getHeapType();
    auto& infos = getInfos();
    auto& fields = heapType.getStruct().fields;
    for (Index i = 0; i < fields.size(); i++) {
      auto& info = infos[heapType][i];
      if (curr->isWithDefault()) {
        info.note(Literal::makeZero(fields[i].type));
      } else {
        noteExpression(curr->operands[i], info);
      }
    }
  }

  void visitStructSet(StructSet* curr) {
    auto type = curr->ref->type;
    if (type == Type::unreachable) {
      return;
    }
    auto heapType = type.getHeapType();
    noteExpression(curr->value, getInfos()[heapType][curr->index]);
  }

  void visitStructGet(StructGet* curr) {
    auto type = curr->ref->type;
    if (type == Type::unreachable) {
      return;
    }

    // Ensure the heap type is noted, so that later we can assume all heap types
    // are represented in the map.
    getInfos()[type.getHeapType()];
  }

private:
  FunctionStructValuesMap* functionInfos;

  StructValuesMap& getInfos() { return (*functionInfos)[getFunction()]; }

  void noteExpression(Expression* expr, PossibleConstantValues& info) {
    if (!Properties::isConstantExpression(expr)) {
      info.noteUnknown();
    } else {
      info.note(Properties::getLiteral(expr));
    }
  }
};

// Optimize struct gets based on what we've learned about writes.
//
// TODO Aside from writes, we could use information like whether any struct of
//      this type has even been created (to handle the case of struct.sets but
//      no struct.news.
struct FunctionOptimizer : public WalkerPass<PostWalker<FunctionOptimizer>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new FunctionOptimizer(infos); }

  FunctionOptimizer(StructValuesMap* infos) : infos(infos) {}

  void visitStructGet(StructGet* curr) {
    auto type = curr->ref->type;
    if (type == Type::unreachable) {
      return;
    }

    // Find the info for this field, and see if we can optimize.
    // Note that the heap type must already be in the map here, as we operate on
    // it in parallel, hence at().
    auto& info = infos->at(type.getHeapType())[curr->index];

    Builder builder(*getModule());

    if (!info.hasWrites()) {
      // This field is never written at all. That means that we do not even
      // construct any data of this type, and so it is a logic error to reach
      // this location in the code. (Unless we are not in a closed-world
      // situation, which we assume we are not in.) Replace this get with a
      // trap. Note that we do not need to care about the nullability of the
      // reference, as if it should have trapped, we are replacing it with
      // another trap, which we allow to reorder.
      replaceCurrent(builder.makeSequence(
        builder.makeDrop(curr->ref),
        builder.makeUnreachable()));
    }

    if (!info.isConstant()) {
      return;
    }

    // We can do this! Replace the get with a throw on a null reference (as the
    // get would have done so), plus the constant value. (Leave it to further
    // optimizations to get rid of the ref.)
    replaceCurrent(builder.makeSequence(
      builder.makeDrop(builder.makeRefAs(RefAsNonNull, curr->ref)),
      builder.makeConstantExpression(info.getConstantValue())));
  }

private:
  StructValuesMap* infos;
};

struct ConstantFieldPropagation : public Pass {
  void run(PassRunner* runner, Module* module) override {
    // Find and analyze all writes inside each function.
    FunctionStructValuesMap functionInfos;
    for (auto& func : module->functions) {
      // Initialize the data for each function, so that we can operate on this
      // structure in parallel without modifying it.
      functionInfos[func.get()];
    }
    Scanner scanner(&functionInfos);
    scanner.run(runner, module);
    scanner.walkModuleCode(module);

    // Combine the data from the functions.
    StructValuesMap combinedInfos;
    for (auto& kv : functionInfos) {
      StructValuesMap& infos = kv.second;
      for (auto& kv : infos) {
        auto type = kv.first;
        auto& info = kv.second;
        auto& combinedInfo = combinedInfos[type];
        for (Index i = 0; i < info.size(); i++) {
          combinedInfo[i].combine(info[i]);
        }
      }
    }

    // Handle subtyping: If we see a write to type T of field F, then the object
    // at runtime might be of type T, or any subtype of T. We need to propagate
    // the writes we have seen to all the subtypes of T.
    // TODO: assert nominal!
    // TODO: cycles are impossible with nominal supertypes, right? (even when
    //       not adding a field?)
    // TODO: We only need to propagate struct.sets, and not values in creation,
    //       as we know the precise type when creating.
    TypeGraph typeGraph;
    UniqueDeferredQueue<HeapType> work;
    for (auto& kv : combinedInfos) {
      auto type = kv.first;
      typeGraph.note(type);
      work.push(type);
    }
    while (!work.empty()) {
      auto type = work.pop();
      auto& infos = combinedInfos[type];
      auto& subTypes = typeGraph.getSubTypes(type);
      auto& fields = type.getStruct().fields;
      for (auto subType : subTypes) {
        auto& subInfos = combinedInfos[subType];
        for (Index i = 0; i < fields.size(); i++) {
          if (subInfos[i].combine(infos[i])) {
            work.push(subType);
          }
        }
      }
    }

    // Prepare the data for assisting the optimization of struct.gets. When we
    // see a struct.get of type T, the actual instance might be of a subtype,
    // and so we should check not just T but all subtypes. To make that fast,
    // propagate writes in the other direction, that is, from each T to its
    // supertype.
    for (auto& kv : combinedInfos) {
      auto type = kv.first;
      work.push(type);
    }
    while (!work.empty()) {
      auto type = work.pop();
      HeapType superType;
      if (type.getSuperType(superType)) {
        auto& infos = combinedInfos[type];
        auto& superInfos = combinedInfos[superType];
        auto& superFields = superType.getStruct().fields;
        for (Index i = 0; i < superFields.size(); i++) {
          if (superInfos[i].combine(infos[i])) {
            work.push(superType);
          }
        }
      }
    }

    // Optimize.
    // TODO: Skip this if we cannot optimize anything
    FunctionOptimizer(&combinedInfos).run(runner, module);

    // TODO: Actually remove the field from the type, where possible? That might
    //       be best in another pass.
  }
};

} // anonymous namespace

Pass* createConstantFieldPropagationPass() {
  return new ConstantFieldPropagation();
}

} // namespace wasm
