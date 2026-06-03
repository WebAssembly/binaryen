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

// Spans of values, allowing inference whether a Literal or a local is within
// some range.

#ifndef wasm_ir_span_h
#define wasm_ir_span_h

#include <variant>

#include "support/utilities.h"
#include "wasm.h"

namespace wasm::span {

struct Unknown : public std::monostate {};

// In each span of values, one of the values. This can be either a literal
// like i32(0), or a local index (i.e., a reference to another local, showing
// that this one is related to them somehow: one of ==, <, >=, etc.), or
// something unknown.
struct Value : public std::variant<Unknown, Literal, Index> {
  static Value unknown() { return Value(Unknown()); }

  bool isUnknown() const { return std::holds_alternative<Unknown>(*this); }

  bool operator==(const Value&) const = default;
};

// A span of values, [min, max] (inclusive).
// TODO: support more clever things like unions
struct Span {
  // TODO: add "inclusive" for [ ] vs ( ) bounds?
  Value min;
  Value max;

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

} // namespace wasm::span

#endif // wasm_ir_span_h
