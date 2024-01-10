/*
 * Copyright 2022 WebAssembly Community Group participants
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

#ifndef wasm_ir_possible_constant_h
#define wasm_ir_possible_constant_h

#include <variant>

#include "ir/properties.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

// Represents data about what constant values are possible in a particular
// place. There may be no values, or one, or many, or if a non-constant value is
// possible, then all we can say is that the value is "unknown" - it can be
// anything. The values can either be literal values (Literal) or the names of
// immutable globals (Name).
//
// Currently this just looks for a single constant value, and even two constant
// values are treated as unknown. It may be worth optimizing more than that TODO
struct PossibleConstantValues {
private:
  // No possible value.
  struct None : public std::monostate {};

  // Many possible values, and so this represents unknown data: we cannot infer
  // anything there.
  struct Many : public std::monostate {};

  using Variant = std::variant<None, Literal, Name, Many>;
  Variant value;

public:
  PossibleConstantValues() : value(None()) {}

  bool operator==(const PossibleConstantValues& other) const {
    return value == other.value;
  }

  // Notes the contents of an expression and update our internal knowledge based
  // on it and all previous values noted.
  void note(Expression* expr, Module& wasm) {
    // If this is a constant literal value, note that.
    if (Properties::isConstantExpression(expr)) {
      note(Properties::getLiteral(expr));
      return;
    }

    // If this is an immutable global that we get, note that.
    if (auto* get = expr->dynCast<GlobalGet>()) {
      auto* global = wasm.getGlobal(get->name);
      if (global->mutable_ == Immutable) {
        note(get->name);
        return;
      }
    }

    // Otherwise, this is not something we can reason about.
    noteUnknown();
  }

  // Note either a Literal or a Name.
  template<typename T> void note(T curr) {
    PossibleConstantValues other;
    other.value = curr;
    combine(other);
  }

  // Notes a value that is unknown - it can be anything. We have failed to
  // identify a constant value here.
  void noteUnknown() { value = Many(); }

  // Combine the information in a given PossibleConstantValues to this one. This
  // is the same as if we have called note*() on us with all the history of
  // calls to that other object.
  //
  // Returns whether we changed anything.
  bool combine(const PossibleConstantValues& other) {
    if (std::get_if<None>(&other.value)) {
      return false;
    }

    if (std::get_if<None>(&value)) {
      value = other.value;
      return true;
    }

    if (std::get_if<Many>(&value)) {
      return false;
    }

    if (other.value != value) {
      value = Many();
      return true;
    }

    // Nulls compare equal, and we could consider any of the input nulls as the
    // combination of the two (as any of them would be valid to place in the
    // location we are working to optimize). In order to have simple symmetric
    // behavior here, which does not depend on the order of the inputs, use the
    // LUB.
    if (isNull() && other.isNull()) {
      auto type = getConstantLiteral().type.getHeapType();
      auto otherType = other.getConstantLiteral().type.getHeapType();
      auto lub = HeapType::getLeastUpperBound(type, otherType);
      if (!lub) {
        // TODO: Remove this workaround once we have bottom types to assign to
        // null literals.
        value = Many();
        return true;
      }
      if (*lub != type) {
        value = Literal::makeNull(*lub);
        return true;
      }
      return false;
    }

    return false;
  }

  // Check if all the values are identical and constant.
  bool isConstant() const {
    return !std::get_if<None>(&value) && !std::get_if<Many>(&value);
  }

  bool isConstantLiteral() const { return std::get_if<Literal>(&value); }

  bool isConstantGlobal() const { return std::get_if<Name>(&value); }

  bool isNull() const {
    return isConstantLiteral() && getConstantLiteral().isNull();
  }

  // Returns the single constant value.
  Literal getConstantLiteral() const {
    assert(isConstant());
    return std::get<Literal>(value);
  }

  Name getConstantGlobal() const {
    assert(isConstant());
    return std::get<Name>(value);
  }

  // Assuming we have a single value, make an expression containing that value.
  Expression* makeExpression(Module& wasm) const {
    Builder builder(wasm);
    if (isConstantLiteral()) {
      return builder.makeConstantExpression(getConstantLiteral());
    } else {
      auto name = getConstantGlobal();
      return builder.makeGlobalGet(name, wasm.getGlobal(name)->type);
    }
  }

  // Returns whether we have ever noted a value.
  bool hasNoted() const { return !std::get_if<None>(&value); }

  void dump(std::ostream& o) const {
    o << '[';
    if (!hasNoted()) {
      o << "unwritten";
    } else if (!isConstant()) {
      o << "unknown";
    } else if (isConstantLiteral()) {
      o << getConstantLiteral();
    } else if (isConstantGlobal()) {
      o << '$' << getConstantGlobal();
    }
    o << ']';
  }
};

} // namespace wasm

#endif // wasm_ir_possible_constant_h
