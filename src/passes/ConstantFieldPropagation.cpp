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

//
// Find struct fields that are always written to with a constant value, and
// replace gets of them with that value.
//
// For example, if we have a vtable of type T, and we always create it with one
// of the fields containing a ref.func of the same function F, and there is no
// write to that field of a different value (even using a subtype of T), then
// anywhere we see a get of that field we can place a ref.func of F.
//
// FIXME: This pass assumes a closed world. When we start to allow multi-module
//        wasm GC programs we need to check for type escaping.
//

#include "ir/properties.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace {

// Represents data about what constant values are possible in a particular
// place. There may be no values, or one, or many, or if a non-constant value is
// possible, then all we can say is that the value is "unknown" - it can be
// anything.
//
// Currently this just looks for a single constant value, and even two constant
// values are treated as unknown. It may be worth optimizing more than that TODO
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
    if (curr != value) {
      noteUnknown();
    }
  }

  // Notes a value that is unknown - it can be anything. We have failed to
  // identify a constant value here.
  void noteUnknown() {
    value = Literal(Type::none);
    noted = true;
  }

  // Combine the information in a given PossibleConstantValues to this one. This
  // is the same as if we have called note*() on us with all the history of
  // calls to that other object.
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
  bool isConstant() const { return noted && value.type.isConcrete(); }

  // Returns the single constant value.
  Literal getConstantValue() const {
    assert(isConstant());
    return value;
  }

  // Returns whether we have ever noted a value.
  bool hasNoted() const { return noted; }

  void dump(std::ostream& o) {
    o << '[';
    if (!hasNoted()) {
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

  // The one value we have seen, if there is one. If we realize there is no
  // single constant value here, we make this have a non-concrete (impossible)
  // type to indicate that. Otherwise, a concrete type indicates we have a
  // constant value.
  Literal value;
};

// A vector of PossibleConstantValues. One such vector will be used per struct
// type, where each element in the vector represents a field. We always assume
// that the vectors are pre-initialized to the right length before accessing any
// data, which this class enforces using assertions, and which is implemented in
// StructValuesMap.
struct StructValues : public std::vector<PossibleConstantValues> {
  PossibleConstantValues& operator[](size_t index) {
    assert(index < size());
    return std::vector<PossibleConstantValues>::operator[](index);
  }
};

// Map of types to information about the values their fields can take.
// Concretely, this maps a type to a StructValues which has one element per
// field.
struct StructValuesMap : public std::unordered_map<HeapType, StructValues> {
  // When we access an item, if it does not already exist, create it with a
  // vector of the right length for that type.
  StructValues& operator[](HeapType type) {
    auto inserted = insert({type, {}});
    auto& values = inserted.first->second;
    if (inserted.second) {
      values.resize(type.getStruct().fields.size());
    }
    return values;
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

// Map of functions to their field value infos. We compute those in parallel,
// then later we will merge them all.
using FunctionStructValuesMap = std::unordered_map<Function*, StructValuesMap>;

// Scan each function to note all its writes to struct fields.
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

    // Note writes to all the fields of the struct.
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

    // Note a write to this field of the struct.
    auto heapType = type.getHeapType();
    noteExpression(curr->value, getInfos()[heapType][curr->index]);
  }

private:
  FunctionStructValuesMap* functionInfos;

  StructValuesMap& getInfos() { return (*functionInfos)[getFunction()]; }

  // Note a value, checking whether it is a constant or not.
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
//      no struct.news).
struct FunctionOptimizer : public WalkerPass<PostWalker<FunctionOptimizer>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new FunctionOptimizer(infos); }

  FunctionOptimizer(StructValuesMap* infos) : infos(infos) {}

  void visitStructGet(StructGet* curr) {
    auto type = curr->ref->type;
    if (type == Type::unreachable) {
      return;
    }

    Builder builder(*getModule());

    // Find the info for this field, and see if we can optimize. First, see if
    // there is any information for this heap type at all. If there isn't, it is
    // as if nothing was ever noted for that field.
    PossibleConstantValues info;
    assert(!info.hasNoted());
    auto iter = infos->find(type.getHeapType());
    if (iter != infos->end()) {
      // There is information on this type, fetch it.
      info = iter->second[curr->index];
    }
    if (!info.hasNoted()) {
      // This field is never written at all. That means that we do not even
      // construct any data of this type, and so it is a logic error to reach
      // this location in the code. (Unless we are in an open-world
      // situation, which we assume we are not in.) Replace this get with a
      // trap. Note that we do not need to care about the nullability of the
      // reference, as if it should have trapped, we are replacing it with
      // another trap, which we allow to reorder (but we do need to care about
      // side effects in the reference, so keep it around).
      replaceCurrent(builder.makeSequence(builder.makeDrop(curr->ref),
                                          builder.makeUnreachable()));
      changedTypes = true;
      return;
    }

    // If the value is not a constant, then it is unknown and we must give up.
    if (!info.isConstant()) {
      return;
    }

    // We can do this! Replace the get with a throw on a null reference (as the
    // get would have done so), plus the constant value. (Leave it to further
    // optimizations to get rid of the ref.)
    replaceCurrent(builder.makeSequence(
      builder.makeDrop(builder.makeRefAs(RefAsNonNull, curr->ref)),
      builder.makeConstantExpression(info.getConstantValue())));
    changedTypes = true;
  }

  void doWalkFunction(Function* func) {
    WalkerPass<PostWalker<FunctionOptimizer>>::doWalkFunction(func);

    // If we changed any types, we need to update parents.
    if (changedTypes) {
      ReFinalize().walkFunctionInModule(func, getModule());
    }
  }

private:
  StructValuesMap* infos;

  bool changedTypes = false;
};

struct ConstantFieldPropagation : public Pass {
  void run(PassRunner* runner, Module* module) override {
    if (getTypeSystem() != TypeSystem::Nominal) {
      Fatal() << "ConstantFieldPropagation requires nominal typing";
    }

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

    // Handle subtyping. |combinedInfo| so far contains data that represents
    // each struct.new and struct.set's operation on the struct type used in
    // that instruction. That is, if we do a struct.set to type T, the value was
    // noted for type T. But our actual goal is to answer questions about
    // struct.gets. Specifically, when later we see:
    //
    //  (struct.get $A x (REF-1))
    //
    // Then we want to find all struct.sets
    //
    //  (struct.set $B x (REF-2) (..value..))
    //
    // where $B is a subtype of $A, because at runtime the value REF-1 might not
    // only be of type $A but also any subtype of $A. To make the lookup
    // efficient when we see the get, we propagate information about sets to
    // their supers, recursively, so long as the super still has that field.
    // (Note that this also handles the case of REF-2 being a subtype of $B.)
    //
    // TODO: Are cycles possible with nominal supertypes?
    UniqueDeferredQueue<HeapType> work;
    for (auto& kv : combinedInfos) {
      auto type = kv.first;
      work.push(type);
    }
    while (!work.empty()) {
      auto type = work.pop();
      auto& infos = combinedInfos[type];
      HeapType superType;
      if (type.getSuperType(superType)) {
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
