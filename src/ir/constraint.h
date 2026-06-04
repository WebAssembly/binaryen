/*
 * Copyright 2026 WebAssembly Community Group participants
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

// Constraints on the values of locals, things like x >=0, x < 42, and x == y.

#ifndef wasm_ir_constraint_h
#define wasm_ir_constraint_h

#include <variant>

#include "ir/abstract.h"
#include "support/utilities.h"
#include "wasm.h"

namespace wasm::constraint {

// A value in a constraint, either a literal value or a local index.
struct Value : public std::variant<Literal, Index> {
  bool operator==(const Value&) const = default;
};

// A constraint.
struct Constraint {
  Value left;
  Value right;

  static Span unknown() { return Span{Unknown(), Unknown()}; }

  bool isUnknown() { return min.isUnknown() && max.isUnknown(); }

  bool operator==(const Span&) const = default;

  // Check if this span definitely includes a value inside it. If we don't know,
  // return false.
  bool includes(const Value& value);
  // TODO: excludes..?

  // Check if this span is definitely smaller than a value (or false if we don't
  // know).
  bool lessThan(const Value& value);

  // Check if this span is definitely greater than a value (or false if we don't
  // know).
  bool greaterThan(const Value& value);
};

bool Span::includes(const Value& value) {
  // In most cases, we don't know enough.
  bool ret = false;
  std::visit(overloaded{
               [&](const Literal& lit) {
                 // The value is a literal. We can infer something here if the
                 // span is a range of literals, checking if value is within
                 // [min, max].
                 const Literal* minLit = std::get_if<Literal>(&min);
                 if (minLit && *minLit == lit) {
                   ret = true;
                   return;
                 }
                 const Literal* maxLit = std::get_if<Literal>(&max);
                 if (maxLit && *maxLit == lit) {
                   ret = true;
                   return;
                 }
                 if (lit.type.isNumber() && minLit && maxLit) {
                   // Numbers can be ordered.
                   assert(minLit->type == lit.type);
                   assert(maxLit->type == lit.type);
                   if (minLit->le(lit).getUnsigned() &&
                       maxLit->ge(lit).getUnsigned()) {
                     ret = true;
                   }
                 }
               },
               [&](const Index& local) {
                 // A local index can be compared to others.
                 const Index* minLocal = std::get_if<Index>(&min);
                 if (minLocal && *minLocal == local) {
                   ret = true;
                   return;
                 }
                 const Index* maxLocal = std::get_if<Index>(&max);
                 if (maxLocal && *maxLocal == local) {
                   ret = true;
                 }
               },
               [&](const Unknown& unknown) {},
             },
             value);
  return ret;
}

bool Span::lessThan(const Value& value) { abort(); }

bool Span::greaterThan(const Value& value) { abort(); }

} // namespace wasm::constraint

#endif // wasm_ir_constraint_h
