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

#include "ir/module-utils.h"
#include "ir/properties.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace {

// A nominal type always knows who its supertype is, if there is one; this class
// provides the list of immediate subtypes.
struct SubTypes {
  SubTypes(Module& wasm) {
    std::vector<HeapType> types;
    std::unordered_map<HeapType, Index> typeIndices;
    ModuleUtils::collectHeapTypes(wasm, types, typeIndices);
    for (auto type : types) {
      note(type);
    }
  }

  const std::unordered_set<HeapType>& getSubTypes(HeapType type) {
    return typeSubTypes[type];
  }

private:
  // Add a type to the graph.
  void note(HeapType type) {
    HeapType super;
    if (type.getSuperType(super)) {
      typeSubTypes[super].insert(type);
    }
  }

  // Maps a type to its subtypes.
  std::unordered_map<HeapType, std::unordered_set<HeapType>> typeSubTypes;
};

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

  const PossibleConstantValues& operator[](size_t index) const {
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
//
// We track information from struct.new and struct.set separately, because in
// struct.new we know more about the type - we know the actual exact type being
// written to, and not just that it is of a subtype of the instruction's type,
// which helps later.
struct Scanner : public WalkerPass<PostWalker<Scanner>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override {
    return new Scanner(functionNewInfos, functionSetInfos);
  }

  Scanner(FunctionStructValuesMap& functionNewInfos,
          FunctionStructValuesMap& functionSetInfos)
    : functionNewInfos(functionNewInfos), functionSetInfos(functionSetInfos) {}

  void visitStructNew(StructNew* curr) {
    auto type = curr->type;
    if (type == Type::unreachable) {
      return;
    }

    // Note writes to all the fields of the struct.
    auto heapType = type.getHeapType();
    auto& values = functionNewInfos[getFunction()][heapType];
    auto& fields = heapType.getStruct().fields;
    for (Index i = 0; i < fields.size(); i++) {
      if (curr->isWithDefault()) {
        values[i].note(Literal::makeZero(fields[i].type));
      } else {
        noteExpression(curr->operands[i], heapType, i, functionNewInfos);
      }
    }
  }

  void visitStructSet(StructSet* curr) {
    auto type = curr->ref->type;
    if (type == Type::unreachable) {
      return;
    }

    // Note a write to this field of the struct.
    noteExpression(
      curr->value, type.getHeapType(), curr->index, functionSetInfos);
  }

private:
  FunctionStructValuesMap& functionNewInfos;
  FunctionStructValuesMap& functionSetInfos;

  // Note a value, checking whether it is a constant or not.
  void noteExpression(Expression* expr,
                      HeapType type,
                      Index index,
                      FunctionStructValuesMap& valuesMap) {
    expr = Properties::getFallthrough(expr, getPassOptions(), *getModule());

    // Ignore copies: when we set a value to a field from that same field, no
    // new values are actually introduced.
    //
    // Note that this is only sound by virtue of the overall analysis in this
    // pass: the object read from may be of a subclass, and so subclass values
    // may be actually written here. But as our analysis considers subclass
    // values too (as it must) then that is safe. That is, if a subclass of $A
    // adds a value X that can be loaded from (struct.get $A $b), then consider
    // a copy
    //
    //   (struct.set $A $b (struct.get $A $b))
    //
    // Our analysis will figure out that X can appear in that copy's get, and so
    // the copy itself does not add any information about values.
    //
    // TODO: This may be extensible to a copy from a subtype by the above
    //       analysis (but this is already entering the realm of diminishing
    //       returns).
    if (auto* get = expr->dynCast<StructGet>()) {
      if (get->index == index && get->ref->type != Type::unreachable &&
          get->ref->type.getHeapType() == type) {
        return;
      }
    }

    auto& info = valuesMap[getFunction()][type][index];
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

  FunctionOptimizer(StructValuesMap& infos) : infos(infos) {}

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
    auto iter = infos.find(type.getHeapType());
    if (iter != infos.end()) {
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
      changed = true;
      return;
    }

    // If the value is not a constant, then it is unknown and we must give up.
    if (!info.isConstant()) {
      return;
    }

    // We can do this! Replace the get with a trap on a null reference using a
    // ref.as_non_null (we need to trap as the get would have done so), plus the
    // constant value. (Leave it to further optimizations to get rid of the
    // ref.)
    replaceCurrent(builder.makeSequence(
      builder.makeDrop(builder.makeRefAs(RefAsNonNull, curr->ref)),
      builder.makeConstantExpression(info.getConstantValue())));
    changed = true;
  }

  void doWalkFunction(Function* func) {
    WalkerPass<PostWalker<FunctionOptimizer>>::doWalkFunction(func);

    // If we changed anything, we need to update parent types as types may have
    // changed.
    if (changed) {
      ReFinalize().walkFunctionInModule(func, getModule());
    }
  }

private:
  StructValuesMap& infos;

  bool changed = false;
};

struct ConstantFieldPropagation : public Pass {
  void run(PassRunner* runner, Module* module) override {
    if (getTypeSystem() != TypeSystem::Nominal) {
      Fatal() << "ConstantFieldPropagation requires nominal typing";
    }

    // Find and analyze all writes inside each function.
    FunctionStructValuesMap functionNewInfos, functionSetInfos;
    for (auto& func : module->functions) {
      // Initialize the data for each function, so that we can operate on this
      // structure in parallel without modifying it.
      functionNewInfos[func.get()];
      functionSetInfos[func.get()];
    }
    Scanner scanner(functionNewInfos, functionSetInfos);
    scanner.run(runner, module);
    scanner.walkModuleCode(module);

    // Combine the data from the functions.
    auto combine = [](const FunctionStructValuesMap& functionInfos,
                      StructValuesMap& combinedInfos) {
      for (auto& kv : functionInfos) {
        const StructValuesMap& infos = kv.second;
        for (auto& kv : infos) {
          auto type = kv.first;
          auto& info = kv.second;
          for (Index i = 0; i < info.size(); i++) {
            combinedInfos[type][i].combine(info[i]);
          }
        }
      }
    };
    StructValuesMap combinedNewInfos, combinedSetInfos;
    combine(functionNewInfos, combinedNewInfos);
    combine(functionSetInfos, combinedSetInfos);

    // Handle subtyping. |combinedInfo| so far contains data that represents
    // each struct.new and struct.set's operation on the struct type used in
    // that instruction. That is, if we do a struct.set to type T, the value was
    // noted for type T. But our actual goal is to answer questions about
    // struct.gets. Specifically, when later we see:
    //
    //  (struct.get $A x (REF-1))
    //
    // Then we want to be aware of all the relevant struct.sets, that is, the
    // sets that can write data that this get reads. Given a set
    //
    //  (struct.set $B x (REF-2) (..value..))
    //
    // then
    //
    //  1. If $B is a subtype of $A, it is relevant: the get might read from a
    //     struct of type $B (i.e., REF-1 and REF-2 might be identical, and both
    //     be a struct of type $B).
    //  2. If $B is a supertype of $A that still has the field x then it may
    //     also be relevant: since $A is a subtype of $B, the set may write to a
    //     struct of type $A (and again, REF-1 and REF-2 may be identical).
    //
    // Thus, if either $A <: $B or $B <: $A then we must consider the get and
    // set to be relevant to each other. To make our later lookups for gets
    // efficient, we therefore propagate information about the possible values
    // in each field to both subtypes and supertypes.
    //
    // struct.new on the other hand knows exactly what type is being written to,
    // and so given a get of $A and a new of $B, the new is relevant for the get
    // iff $A is a subtype of $B, so we only need to propagate in one direction
    // there, to supertypes.
    //
    // TODO: A topological sort could avoid repeated work here perhaps.

    SubTypes subTypes(*module);

    auto propagate = [&subTypes](StructValuesMap& combinedInfos,
                                 bool toSubTypes) {
      UniqueDeferredQueue<HeapType> work;
      for (auto& kv : combinedInfos) {
        auto type = kv.first;
        work.push(type);
      }
      while (!work.empty()) {
        auto type = work.pop();
        auto& infos = combinedInfos[type];

        // Propagate shared fields to the supertype.
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

        if (toSubTypes) {
          // Propagate shared fields to the subtypes.
          auto numFields = type.getStruct().fields.size();
          for (auto subType : subTypes.getSubTypes(type)) {
            auto& subInfos = combinedInfos[subType];
            for (Index i = 0; i < numFields; i++) {
              if (subInfos[i].combine(infos[i])) {
                work.push(subType);
              }
            }
          }
        }
      }
    };
    propagate(combinedNewInfos, false);
    propagate(combinedSetInfos, true);

    // Combine both sources of information to the final information that gets
    // care about.
    StructValuesMap combinedInfos = std::move(combinedNewInfos);
    for (auto& kv : combinedSetInfos) {
      auto type = kv.first;
      auto& info = kv.second;
      for (Index i = 0; i < info.size(); i++) {
        combinedInfos[type][i].combine(info[i]);
      }
    }

    // Optimize.
    // TODO: Skip this if we cannot optimize anything
    FunctionOptimizer(combinedInfos).run(runner, module);

    // TODO: Actually remove the field from the type, where possible? That might
    //       be best in another pass.
  }
};

} // anonymous namespace

Pass* createConstantFieldPropagationPass() {
  return new ConstantFieldPropagation();
}

} // namespace wasm
