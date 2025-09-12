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

#ifndef wasm_ir_struct_utils_h
#define wasm_ir_struct_utils_h

#include "ir/properties.h"
#include "ir/subtypes.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

// A pair of a struct type and a field index, together defining a field in a
// particular type.
using StructField = std::pair<HeapType, Index>;

namespace StructUtils {

// A value that has a single bool, and implements combine() so it can be used in
// StructValues.
struct CombinableBool {
  bool value = false;

  CombinableBool() {}
  CombinableBool(bool value) : value(value) {}

  operator bool() const { return value; }

  bool combine(const CombinableBool& other) {
    if (!value && other.value) {
      value = true;
      return true;
    }
    return false;
  }
};

static const Index DescriptorIndex = -1;

// A vector of a template type's values. One such vector will be used per struct
// type, where each element in the vector represents a field. We always assume
// that the vectors are pre-initialized to the right length before accessing any
// data, which this class enforces using assertions, and which is implemented in
// StructValuesMap.
template<typename T> struct StructValues : public std::vector<T> {
  T& operator[](size_t index) {
    if (index == DescriptorIndex) {
      return desc;
    }
    assert(index < this->size());
    return std::vector<T>::operator[](index);
  }

  const T& operator[](size_t index) const {
    if (index == DescriptorIndex) {
      return desc;
    }
    assert(index < this->size());
    return std::vector<T>::operator[](index);
  }

  // Store the descriptor as another field. (This could be a std::optional to
  // indicate that the descriptor's existence depends on the type, but that
  // would add overhead & code clutter (type checks). If there is no descriptor,
  // this will just hang around with the default values, not harming anything
  // except perhaps for looking a little odd during debugging. And whenever we
  // combine() a non-existent descriptor, we are doing unneeded work, but the
  // data here is typically just a few bools, so it is simpler and likely
  // faster to just copy those rather than check if the type has a descriptor.)
  T desc;
};

// Maps heap types to a StructValues for that heap type. Includes exactness in
// the key to allow differentiating between values for exact and inexact
// references to each type.
//
// Also provides a combineInto() helper that combines one map into another. This
// depends on the underlying T defining a combine() method.
template<typename T>
struct StructValuesMap
  : public std::unordered_map<std::pair<HeapType, Exactness>, StructValues<T>> {
  // When we access an item, if it does not already exist, create it with a
  // vector of the right length for that type.
  StructValues<T>& operator[](std::pair<HeapType, Exactness> type) {
    assert(type.first.isStruct());
    auto inserted = this->insert({type, {}});
    auto& values = inserted.first->second;
    if (inserted.second) {
      values.resize(type.first.getStruct().fields.size());
    }
    return values;
  }

  void combineInto(StructValuesMap<T>& combinedInfos) const {
    for (auto& [type, info] : *this) {
      for (Index i = 0; i < info.size(); i++) {
        combinedInfos[type][i].combine(info[i]);
      }
      combinedInfos[type].desc.combine(info.desc);
    }
  }

  void dump(std::ostream& o) {
    o << "dump " << this << '\n';
    for (auto& [type, vec] : (*this)) {
      o << "dump " << type.first << (type.second == Exact ? " exact " : " ")
        << &vec << ' ';
      for (auto x : vec) {
        x.dump(o);
        o << " ";
      };
      o << " desc: ";
      vec.desc.dump(o);
      o << '\n';
    }
  }
};

// Map of functions to StructValuesMap. This lets us compute in parallel while
// we walk the module, and afterwards we will merge them all.
template<typename T>
struct FunctionStructValuesMap
  : public std::unordered_map<Function*, StructValuesMap<T>> {
  FunctionStructValuesMap(Module& wasm) {
    // Initialize the data for each function in preparation for parallel
    // computation.
    for (auto& func : wasm.functions) {
      (*this)[func.get()];
    }
  }

  // Combine information across functions.
  void combineInto(StructValuesMap<T>& combinedInfos) const {
    for (auto& kv : *this) {
      const StructValuesMap<T>& infos = kv.second;
      infos.combineInto(combinedInfos);
    }
  }
};

// A generic scanner that finds struct operations and calls hooks to update
// information. Subclasses must define these methods:
//
// * Note an expression written into a field.
//
//   void noteExpression(Expression* expr, HeapType type, Index index, T& info);
//
// * Note a default value written during creation.
//
//   void noteDefault(Type fieldType, HeapType type, Index index, T& info);
//
// * Note a RMW operation on a field. TODO: Pass more useful information here.
//
//   void noteRMW(Expression* expr, HeapType type, Index index, T& info);
//
// * Note a copied value (read from this field and written to the same, possibly
//   in another object). Note that we require that the two types (the one read
//   from, and written to) are identical; allowing subtyping is possible, but
//   would add complexity amid diminishing returns.
//
//   void noteCopy(HeapType type, Index index, T& info);
//
// * Note a read.
//
//   void noteRead(HeapType type, Index index, T& info);
//
// We track information from struct.new and struct.set/struct.get separately,
// because in struct.new we know more about the type - we know the actual exact
// type being written to, and not just that it is of a subtype of the
// instruction's type, which helps later.
//
// Descriptors are treated as fields in that we call the above functions on
// them. We pass DescriptorIndex for their index as a fake value.
template<typename T, typename SubType>
struct StructScanner
  : public WalkerPass<PostWalker<StructScanner<T, SubType>>> {
  bool isFunctionParallel() override { return true; }

  bool modifiesBinaryenIR() override { return false; }

  SubType& self() { return *static_cast<SubType*>(this); }

  StructScanner(FunctionStructValuesMap<T>& functionNewInfos,
                FunctionStructValuesMap<T>& functionSetGetInfos)
    : functionNewInfos(functionNewInfos),
      functionSetGetInfos(functionSetGetInfos) {}

  void visitStructNew(StructNew* curr) {
    auto type = curr->type;
    if (type == Type::unreachable) {
      return;
    }

    // Note writes to all the fields of the struct.
    auto heapType = type.getHeapType();
    auto& fields = heapType.getStruct().fields;
    auto ht = std::make_pair(heapType, Exact);
    auto& infos = functionNewInfos[this->getFunction()][ht];
    for (Index i = 0; i < fields.size(); i++) {
      if (curr->isWithDefault()) {
        self().noteDefault(fields[i].type, heapType, i, infos[i]);
      } else {
        noteExpressionOrCopy(curr->operands[i], heapType, i, infos[i]);
      }
    }

    if (curr->desc) {
      self().noteExpression(curr->desc, heapType, DescriptorIndex, infos.desc);
    }
  }

  void visitStructSet(StructSet* curr) {
    auto type = curr->ref->type;
    if (type == Type::unreachable || type.isNull()) {
      return;
    }

    // Note a write to this field of the struct.
    auto ht = std::make_pair(type.getHeapType(), type.getExactness());
    noteExpressionOrCopy(
      curr->value,
      type.getHeapType(),
      curr->index,
      functionSetGetInfos[this->getFunction()][ht][curr->index]);
  }

  void visitStructGet(StructGet* curr) {
    auto type = curr->ref->type;
    if (type == Type::unreachable || type.isNull()) {
      return;
    }

    auto ht = std::make_pair(type.getHeapType(), type.getExactness());
    auto index = curr->index;
    self().noteRead(type.getHeapType(),
                    index,
                    functionSetGetInfos[this->getFunction()][ht][index]);
  }

  void visitStructRMW(StructRMW* curr) {
    auto type = curr->ref->type;
    if (type == Type::unreachable || type.isNull()) {
      return;
    }

    auto heapType = type.getHeapType();
    auto ht = std::make_pair(heapType, type.getExactness());
    auto index = curr->index;
    auto& info = functionSetGetInfos[this->getFunction()][ht][index];

    if (curr->op == RMWXchg) {
      // An xchg is really like a read and write combined.
      self().noteRead(heapType, index, info);
      noteExpressionOrCopy(curr->value, heapType, index, info);
      return;
    }

    // Otherwise we don't have a simple expression to describe the written
    // value, so fall back to noting an opaque RMW.
    self().noteRMW(curr->value, heapType, index, info);
  }

  void visitStructCmpxchg(StructCmpxchg* curr) {
    auto type = curr->ref->type;
    if (type == Type::unreachable || type.isNull()) {
      return;
    }

    auto heapType = type.getHeapType();
    auto ht = std::make_pair(heapType, type.getExactness());
    auto index = curr->index;
    auto& info = functionSetGetInfos[this->getFunction()][ht][index];

    // A cmpxchg is like a read and conditional write.
    self().noteRead(heapType, index, info);
    noteExpressionOrCopy(curr->replacement, heapType, index, info);
  }

  void visitRefCast(RefCast* curr) {
    if (curr->desc) {
      // We may try to read a descriptor from anything arriving in |curr->ref|,
      // but the only things that matter are the things we cast to: other types
      // can lack a descriptor, and are skipped anyhow. So the only effective
      // read is of the cast type.
      handleDescRead(curr->getCastType());
    }
  }

  void visitBrOn(BrOn* curr) {
    if (curr->desc &&
        (curr->op == BrOnCastDesc || curr->op == BrOnCastDescFail)) {
      handleDescRead(curr->getCastType());
    }
  }

  void visitRefGetDesc(RefGetDesc* curr) {
    // Unlike a cast, anything in |curr->ref| may be read from.
    handleDescRead(curr->ref->type);
  }

  void handleDescRead(Type type) {
    if (type == Type::unreachable) {
      return;
    }
    auto heapType = type.getHeapType();
    auto ht = std::make_pair(heapType, type.getExactness());
    if (heapType.isStruct()) {
      // Any subtype of the reference here may be read from.
      self().noteRead(heapType,
                      DescriptorIndex,
                      functionSetGetInfos[this->getFunction()][ht].desc);
      return;
    }
  }

  void
  noteExpressionOrCopy(Expression* expr, HeapType type, Index index, T& info) {
    // Look at the value falling through, if it has the exact same type
    // (otherwise, we'd need to consider both the type actually written and the
    // type of the fallthrough, somehow).
    auto* fallthrough = Properties::getFallthrough(
      expr,
      this->getPassOptions(),
      *this->getModule(),
      static_cast<SubType*>(this)->getFallthroughBehavior());
    if (fallthrough->type == expr->type) {
      expr = fallthrough;
    }
    if (auto* get = expr->dynCast<StructGet>()) {
      if (get->index == index && get->ref->type != Type::unreachable &&
          get->ref->type.getHeapType() == type) {
        static_cast<SubType*>(this)->noteCopy(type, index, info);
        return;
      }
    }
    static_cast<SubType*>(this)->noteExpression(expr, type, index, info);
  }

  Properties::FallthroughBehavior getFallthroughBehavior() {
    // By default, look at and use tee&br_if fallthrough values.
    return Properties::FallthroughBehavior::AllowTeeBrIf;
  }

  FunctionStructValuesMap<T>& functionNewInfos;
  FunctionStructValuesMap<T>& functionSetGetInfos;
};

// Helper class to propagate information to sub- and/or super- classes in the
// type hierarchy. While propagating it calls a method
//
//  to.combine(from)
//
// which combines the information from |from| into |to|, and should return true
// if we changed something.
template<typename T> class TypeHierarchyPropagator {
public:
  // Constructor that gets a module and computes subtypes.
  TypeHierarchyPropagator(Module& wasm) : subTypes(wasm) {}

  // Constructor that gets subtypes and uses them, avoiding a scan of a
  // module. TODO: avoid a copy here?
  TypeHierarchyPropagator(const SubTypes& subTypes) : subTypes(subTypes) {}

  SubTypes subTypes;

  // Propagate given a StructValuesMap, which means we need to take into
  // account fields.
  void propagateToSuperTypes(StructValuesMap<T>& infos) {
    propagate(infos, false, true);
  }
  void propagateToSubTypes(StructValuesMap<T>& infos) {
    propagate(infos, true, false);
  }
  void propagateToSuperAndSubTypes(StructValuesMap<T>& infos) {
    propagate(infos, true, true);
  }

  // Propagate on a simpler map of structs and infos (that is, not using
  // separate values for the fields, as StructValuesMap does). This is useful
  // when not tracking individual fields, but something more general about
  // types.
  using StructMap = std::unordered_map<HeapType, T>;

  void propagateToSuperTypes(StructMap& infos) {
    propagate(infos, false, true);
  }
  void propagateToSubTypes(StructMap& infos) { propagate(infos, true, false); }
  void propagateToSuperAndSubTypes(StructMap& infos) {
    propagate(infos, true, true);
  }

private:
  void propagate(StructValuesMap<T>& combinedInfos,
                 bool toSubTypes,
                 bool toSuperTypes) {
    UniqueDeferredQueue<std::pair<HeapType, Exactness>> work;
    for (auto& [ht, _] : combinedInfos) {
      work.push(ht);
    }
    while (!work.empty()) {
      auto [type, exactness] = work.pop();
      auto& infos = combinedInfos[{type, exactness}];

      if (toSuperTypes) {
        // Propagate shared fields to the supertype, which may be the inexact
        // version of the same type.
        std::optional<std::pair<HeapType, Exactness>> super;
        if (exactness == Exact) {
          super = {type, Inexact};
        } else if (auto superType = type.getDeclaredSuperType()) {
          super = {*superType, Inexact};
        }
        if (super) {
          auto& superInfos = combinedInfos[*super];
          const auto& superFields = &super->first.getStruct().fields;
          for (Index i = 0; i < superFields->size(); i++) {
            if (superInfos[i].combine(infos[i])) {
              work.push(*super);
            }
          }
          // Propagate the descriptor to the super, if the super has one.
          if (super->first.getDescriptorType() &&
              superInfos.desc.combine(infos.desc)) {
            work.push(*super);
          }
        }
      }

      if (toSubTypes && exactness == Inexact) {
        // Propagate shared fields to the subtypes, which may just be the exact
        // version of the same type.
        auto numFields = type.getStruct().fields.size();
        auto handleSubtype = [&](std::pair<HeapType, Exactness> sub) {
          auto& subInfos = combinedInfos[sub];
          for (Index i = 0; i < numFields; i++) {
            if (subInfos[i].combine(infos[i])) {
              work.push(sub);
            }
          }
          // Propagate the descriptor.
          if (subInfos.desc.combine(infos.desc)) {
            work.push(sub);
          }
        };
        handleSubtype({type, Exact});
        for (auto subType : subTypes.getImmediateSubTypes(type)) {
          handleSubtype({subType, Inexact});
        }
      }
    }
  }

  void propagate(StructMap& combinedInfos, bool toSubTypes, bool toSuperTypes) {
    UniqueDeferredQueue<HeapType> work;
    for (auto& [type, _] : combinedInfos) {
      work.push(type);
    }
    while (!work.empty()) {
      auto type = work.pop();
      auto& info = combinedInfos[type];

      if (toSuperTypes) {
        // Propagate to the supertype.
        if (auto superType = type.getDeclaredSuperType()) {
          auto& superInfo = combinedInfos[*superType];
          if (superInfo.combine(info)) {
            work.push(*superType);
          }
        }
      }

      if (toSubTypes) {
        // Propagate shared fields to the subtypes.
        for (auto subType : subTypes.getImmediateSubTypes(type)) {
          auto& subInfo = combinedInfos[subType];
          if (subInfo.combine(info)) {
            work.push(subType);
          }
        }
      }
    }
  }
};

} // namespace StructUtils

} // namespace wasm

#endif // wasm_ir_struct_utils_h
