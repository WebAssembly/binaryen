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
#include "wasm.h"

namespace wasm {

// A pair of a struct type and a field index, together defining a field in a
// particular type.
using StructField = std::pair<HeapType, Index>;

namespace StructUtils {

// A vector of a template type's values. One such vector will be used per struct
// type, where each element in the vector represents a field. We always assume
// that the vectors are pre-initialized to the right length before accessing any
// data, which this class enforces using assertions, and which is implemented in
// StructValuesMap.
template<typename T> struct StructValues : public std::vector<T> {
  T& operator[](size_t index) {
    assert(index < this->size());
    return std::vector<T>::operator[](index);
  }

  const T& operator[](size_t index) const {
    assert(index < this->size());
    return std::vector<T>::operator[](index);
  }
};

// Maps heap types to a StructValues for that heap type.
//
// Also provides a combineInto() helper that combines one map into another. This
// depends on the underlying T defining a combine() method.
template<typename T>
struct StructValuesMap : public std::unordered_map<HeapType, StructValues<T>> {
  // When we access an item, if it does not already exist, create it with a
  // vector of the right length for that type.
  StructValues<T>& operator[](HeapType type) {
    assert(type.isStruct());
    auto inserted = this->insert({type, {}});
    auto& values = inserted.first->second;
    if (inserted.second) {
      values.resize(type.getStruct().fields.size());
    }
    return values;
  }

  void combineInto(StructValuesMap<T>& combinedInfos) const {
    for (auto& [type, info] : *this) {
      for (Index i = 0; i < info.size(); i++) {
        combinedInfos[type][i].combine(info[i]);
      }
    }
  }

  void dump(std::ostream& o) {
    o << "dump " << this << '\n';
    for (auto& [type, vec] : (*this)) {
      o << "dump " << type << " " << &vec << ' ';
      for (auto x : vec) {
        x.dump(o);
        o << " ";
      };
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
// * Note a copied value (read from this field and written to the same, possibly
//   in another object). Note that we require that the two types (the one read
//   from, and written to) are identical; allowing subtyping is possible, but
//   would add complexity amid diminishing returns.
//
//   void noteCopy(HeapType type, Index index, T& info);
//
// * Note a read
//
//   void noteRead(HeapType type, Index index, T& info);
//
// We track information from struct.new and struct.set/struct.get separately,
// because in struct.new we know more about the type - we know the actual exact
// type being written to, and not just that it is of a subtype of the
// instruction's type, which helps later.
template<typename T, typename SubType>
struct StructScanner
  : public WalkerPass<PostWalker<StructScanner<T, SubType>>> {
  bool isFunctionParallel() override { return true; }

  bool modifiesBinaryenIR() override { return false; }

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
    auto& infos = functionNewInfos[this->getFunction()][heapType];
    for (Index i = 0; i < fields.size(); i++) {
      if (curr->isWithDefault()) {
        static_cast<SubType*>(this)->noteDefault(
          fields[i].type, heapType, i, infos[i]);
      } else {
        noteExpressionOrCopy(curr->operands[i], heapType, i, infos[i]);
      }
    }
  }

  void visitStructSet(StructSet* curr) {
    auto type = curr->ref->type;
    if (type == Type::unreachable || type.isNull()) {
      return;
    }

    // Note a write to this field of the struct.
    noteExpressionOrCopy(curr->value,
                         type.getHeapType(),
                         curr->index,
                         functionSetGetInfos[this->getFunction()]
                                            [type.getHeapType()][curr->index]);
  }

  void visitStructGet(StructGet* curr) {
    auto type = curr->ref->type;
    if (type == Type::unreachable || type.isNull()) {
      return;
    }

    auto heapType = type.getHeapType();
    auto index = curr->index;
    static_cast<SubType*>(this)->noteRead(
      heapType,
      index,
      functionSetGetInfos[this->getFunction()][heapType][index]);
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

// Helper class to propagate information about fields to sub- and/or super-
// classes in the type hierarchy. While propagating it calls a method
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

  void propagateToSuperTypes(StructValuesMap<T>& infos) {
    propagate(infos, false, true);
  }

  void propagateToSubTypes(StructValuesMap<T>& infos) {
    propagate(infos, true, false);
  }

  void propagateToSuperAndSubTypes(StructValuesMap<T>& infos) {
    propagate(infos, true, true);
  }

private:
  void propagate(StructValuesMap<T>& combinedInfos,
                 bool toSubTypes,
                 bool toSuperTypes) {
    UniqueDeferredQueue<HeapType> work;
    for (auto& [type, _] : combinedInfos) {
      work.push(type);
    }
    while (!work.empty()) {
      auto type = work.pop();
      auto& infos = combinedInfos[type];

      if (toSuperTypes) {
        // Propagate shared fields to the supertype.
        if (auto superType = type.getDeclaredSuperType()) {
          auto& superInfos = combinedInfos[*superType];
          auto& superFields = superType->getStruct().fields;
          for (Index i = 0; i < superFields.size(); i++) {
            if (superInfos[i].combine(infos[i])) {
              work.push(*superType);
            }
          }
        }
      }

      if (toSubTypes) {
        // Propagate shared fields to the subtypes.
        auto numFields = type.getStruct().fields.size();
        for (auto subType : subTypes.getImmediateSubTypes(type)) {
          auto& subInfos = combinedInfos[subType];
          for (Index i = 0; i < numFields; i++) {
            if (subInfos[i].combine(infos[i])) {
              work.push(subType);
            }
          }
        }
      }
    }
  }
};

} // namespace StructUtils

} // namespace wasm

#endif // wasm_ir_struct_utils_h
