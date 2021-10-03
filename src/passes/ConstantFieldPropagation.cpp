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

#include "ir/local-graph.h"
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

struct OptimizationInfo {
  SubTypes subTypes;

  // Info that includes propagation to sub- and super-types. This is what we use
  // when we see a (struct.get) and are trying to see what possible data could
  // be accessed there. It includes all the possible values written by
  // struct.new or struct.set both up and down the type tree.
  StructValuesMap generalInfo;

  // Info that is precise to the type, not including any propagation. If we know
  // the precise type of a (struct.get), and that it cannot even be a subtype,
  // then we use this. It includes all the possible values written by struct.new
  // of this type itself and nothing more; it also includes propagated types
  // from struct.set.
  //
  // TODO: Figure out which struct.sets set to the precise type, to avoid that
  //       propagation. However, it may not be a problem as vtables are usually
  //       only written to by new anyhow, and not set later.
  StructValuesMap preciseInfo;

  OptimizationInfo(Module& wasm) : subTypes(wasm) {}
};

// Optimize struct gets based on what we've learned about writes.
//
// TODO Aside from writes, we could use information like whether any struct of
//      this type has even been created (to handle the case of struct.sets but
//      no struct.news).
struct FunctionOptimizer : public WalkerPass<PostWalker<FunctionOptimizer>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new FunctionOptimizer(optInfo); }

  FunctionOptimizer(OptimizationInfo& optInfo) : optInfo(optInfo) {}

  void visitStructGet(StructGet* curr) {
    if (curr->ref->type == Type::unreachable) {
      return;
    }

    Builder builder(*getModule());

    PossibleConstantValues info = getInfo(curr);

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
  OptimizationInfo& optInfo;

  bool changed = false;

  // We may need local info. As this is expensive, generate it on demand.
  std::unique_ptr<LocalGraph> localGraph;

  PossibleConstantValues
  getInfo(StructValuesMap& infos, HeapType type, Index index) {
    assert(index < type.getStruct().fields.size());
    PossibleConstantValues info;
    assert(!info.hasNoted());
    auto iter = infos.find(type);
    if (iter != infos.end()) {
      // There is information on this type, fetch it.
      info = iter->second[index];
    }
    return info;
  }

  PossibleConstantValues getInfo(StructGet* get) {
    auto type = get->ref->type.getHeapType();
    auto index = get->index;

    // Find the possible values based on the type of the get.
    auto info = getInfo(optInfo.generalInfo, type, index);
    if (info.isConstant() || !info.hasNoted()) {
      // We found enough information here; return it.
      return info;
    }

    // If there are no subtypes, then we have already done all we can do, and
    // can learn nothing further that could help us. Avoid doing hard work that
    // will only fail.
    if (optInfo.subTypes.getSubTypes(type).empty()) {
      return info;
    }

    // Try to infer more about the type of the reference. We hope to learn
    // either that
    //
    //  1. It is of a specific precise type.
    //  2. It is of some type or any of its subtypes, but that may still be
    //     an improvement over the type we knew before (that is, we narrowed it
    //     down to a more specific set of possible types).
    //
    auto inference = inferType(get->ref);
    if (inference.kind == InferredType::Failure) {
      // We failed to infer anything.
      return info;
    }

    // TODO: use inference.hasField(index) here

    if (inference.kind == InferredType::IncludeSubTypes &&
        inference.type == type) {
      // We failed to infer anything new.
      return info;
    }

    if (inference.kind == InferredType::Precise) {
      // We inferred a precise type.
      return getInfo(optInfo.preciseInfo, inference.type, index);
    } else {
      // We do not have a precise type, as subtypes may be included, but we did
      // at least find a more specific type than we knew earlier.
      assert(inference.kind == InferredType::IncludeSubTypes);
      return getInfo(optInfo.generalInfo, inference.type, index);
    }
  }

  // An inference about a heap type.
  struct InferredType {
    enum Kind {
      // We failed to infer anything.
      Failure,

      // We inferred a precise type: the value must be of this type and nothing
      // else.
      Precise,

      // We inferred that the value must be of this type, or any subtype.
      IncludeSubTypes
    } kind;

    HeapType type;

    // We may also have been able to infer something about some of the fields.
    // If so, they are added to this map. (Failures to infer are not included
    // here.)
    std::unordered_map<Index, std::shared_ptr<InferredType>> fields;

    InferredType() : kind(Failure) {}
    InferredType(Kind kind, HeapType type) : kind(kind), type(type) {
      // If a type was provided, this is not a failure to infer.
      assert(kind != Failure);
    }

    void setField(Index i, InferredType inference) {
      if (inference.kind == Failure) {
        // Failure to infer is indicated by simply not having it in the map.
        return;
      }
      fields[i] = std::make_shared<InferredType>(inference);
    }

    std::shared_ptr<InferredType> getField(Index i) {
      assert(kind != Failure);
      auto iter = fields.find(i);
      if (iter != fields.end()) {
        return iter->second;
      }
      return std::make_shared<InferredType>();
    }

    bool hasField(Index i) { return fields.count(i); }
  };

  // Attempts to infer something useful about the heap type returned by an
  // expression.
  InferredType inferType(Expression* curr) {
    // Look at the fallthrough. Be careful as if the fallthrough changes the
    // type - which a cast might do - then we can infer nothing valid (and a
    // trap will occur at runtime).
    auto originalType = curr->type;
    curr =
      Properties::getFallthrough(curr, getPassOptions(), getModule()->features);
    if (!Type::isSubType(curr->type, originalType)) {
      return InferredType();
    }

    if (auto* get = curr->dynCast<StructGet>()) {
      // This is another struct.get, so we need to infer its reference type too.
      // Nested gets are a common pattern when we load the vtable and then a
      // function reference from it:
      //
      //   (struct.get $vtable.foo indexInVtable
      //     (struct.get $foo indexOfVtable ..)
      //
      auto inference = inferType(get->ref);
      if (inference.kind != InferredType::Failure) {
        // We inferred something useful here. Check if we even managed to infer
        // the field itself.
        auto fieldInference = inference.getField(get->index);
        if (fieldInference->kind != InferredType::Failure) {
          return *fieldInference;
        }

        // Nothing about the field, but knowing more about the reference may
        // still be helpful: we can see what the field's type is for that type.
        auto& field = inference.type.getStruct().fields[get->index];
        return InferredType(InferredType::IncludeSubTypes,
                            field.type.getHeapType());
      }
    } else if (auto* get = curr->dynCast<LocalGet>()) {
      // This is a get of a local. See who writes to it.
      // TODO: avoid possible iloops in unreachable code.
      // TODO: only construct the graph for relevant types.
      if (!localGraph) {
        localGraph = std::make_unique<LocalGraph>(getFunction());
      }
      auto& sets = localGraph->getSetses[get];
      // TODO: support more than one set
      if (sets.size() == 1) {
        auto* set = *sets.begin();
        if (set) {
          // We found the single value that writes here.
          return inferType(set->value);
        } else {
          // If set is nullptr, that means this is a use of the default value,
          // that is, a null. This means we can't infer anything new about the
          // type. We could in principle infer that the operation will trap,
          // though (but other optimizations should handle that).
        }
      }
    } else if (auto* set = curr->dynCast<StructNew>()) {
      // We can infer a precise type here, as struct.new creates exactly that.
      auto type = set->type.getHeapType();
      InferredType structInference(InferredType::Precise, type);

      // Immutable fields can be inferred as well, as they cannot change later
      // on.
      auto& fields = type.getStruct().fields;
      for (Index i = 0; i < fields.size(); i++) {
        auto& field = fields[i];
        if (field.mutable_ == Immutable && field.type.isRef()) {
          structInference.setField(i, inferType(set->operands[i]));
        }
      }

      return structInference;
    } else if (auto* get = curr->dynCast<GlobalGet>()) {
      // If a global is immutable, we can use information about its value,
      // including even a precise type since it likely is a struct.new.
      auto* global = getModule()->getGlobal(get->name);
      if (!global->mutable_) {
        return inferType(global->init);
      }
    }

    // We didn't manage to do any better than the declared type.
    if (curr->type == Type::unreachable) {
      return InferredType();
    }
    return InferredType(InferredType::IncludeSubTypes,
                        curr->type.getHeapType());
  }
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

    // Define the "null function" for global code.
    functionNewInfos[nullptr];
    functionSetInfos[nullptr];
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

    // Compute the final information that we need.
    OptimizationInfo optInfo(*module);

    auto propagate = [&optInfo](StructValuesMap& combinedInfos,
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
          for (auto subType : optInfo.subTypes.getSubTypes(type)) {
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

    auto mergeIn = [](StructValuesMap& target, const StructValuesMap& source) {
      for (auto& kv : source) {
        auto type = kv.first;
        auto& info = kv.second;
        for (Index i = 0; i < info.size(); i++) {
          target[type][i].combine(info[i]);
        }
      }
    };

    // Precise info takes the unpropagated news, and adds propagated sets (see
    // TODO earlier about the latter).
    propagate(combinedSetInfos, true);
    optInfo.preciseInfo = combinedNewInfos;
    mergeIn(optInfo.preciseInfo, combinedSetInfos);

    // General info takes all the propagated info.
    propagate(combinedNewInfos, false);
    optInfo.generalInfo = std::move(combinedNewInfos);
    mergeIn(optInfo.generalInfo, combinedSetInfos);

    // Optimize.
    // TODO: Skip this if we cannot optimize anything
    FunctionOptimizer(optInfo).run(runner, module);

    // TODO: Actually remove the field from the type, where possible? That might
    //       be best in another pass.
  }
};

} // anonymous namespace

Pass* createConstantFieldPropagationPass() {
  return new ConstantFieldPropagation();
}

} // namespace wasm
