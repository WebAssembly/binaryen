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

#include "wasm.h"

namespace wasm {

// A vector of a template type values. One such vector will be used per struct
// type, where each element in the vector represents a field. We always assume
// that the vectors are pre-initialized to the right length before accessing any
// data, which this class enforces using assertions, and which is implemented in
// StructValuesMap.
template<typename T>
struct StructValues : public std::vector<T> {
  T& operator[](size_t index) {
    assert(index < this->size());
    return std::vector<T>::operator[](index);
  }

  const T& operator[](size_t index) const {
    assert(index < this->size());
    return std::vector<T>::operator[](index);
  }
};

// Map of types to information about the values their fields can take.
// Concretely, this maps a type to a StructValues which has one element per
// field.
template<typename T>
struct StructValuesMap : public std::unordered_map<HeapType, StructValues<T>> {
  // When we access an item, if it does not already exist, create it with a
  // vector of the right length for that type.
  StructValues<T>& operator[](HeapType type) {
    auto inserted = this->insert({type, {}});
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
template<typename T>
using FunctionStructValuesMap = std::unordered_map<Function*, StructValuesMap<T>>;

// Scan each function to note all its writes to struct fields.
//
// We track information from struct.new and struct.set separately, because in
// struct.new we know more about the type - we know the actual exact type being
// written to, and not just that it is of a subtype of the instruction's type,
// which helps later.
template<typename T>
struct Scanner : public WalkerPass<PostWalker<Scanner<T>>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override {
    return new Scanner(functionNewInfos, functionSetInfos);
  }

  Scanner(FunctionStructValuesMap<T>& functionNewInfos,
          FunctionStructValuesMap<T>& functionSetInfos)
    : functionNewInfos(functionNewInfos), functionSetInfos(functionSetInfos) {}

  void visitStructNew(StructNew* curr) {
    auto type = curr->type;
    if (type == Type::unreachable) {
      return;
    }

    // Note writes to all the fields of the struct.
    auto heapType = type.getHeapType();
    auto& values = functionNewInfos[this->getFunction()][heapType];
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
  FunctionStructValuesMap<T>& functionNewInfos;
  FunctionStructValuesMap<T>& functionSetInfos;

  // Note a value, checking whether it is a constant or not.
  void noteExpression(Expression* expr,
                      HeapType type,
                      Index index,
                      FunctionStructValuesMap<T>& valuesMap) {
    expr = Properties::getFallthrough(expr, this->getPassOptions(), *this->getModule());

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

    auto& info = valuesMap[this->getFunction()][type][index];
    if (!Properties::isConstantExpression(expr)) {
      info.noteUnknown();
    } else {
      info.note(Properties::getLiteral(expr));
    }
  }
};

} // namespace wasm

#endif // wasm_ir_struct_utils_h
