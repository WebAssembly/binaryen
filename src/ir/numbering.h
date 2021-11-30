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

#ifndef wasm_ir_numberings_h
#define wasm_ir_numberings_h

#include "ir/properties.h"
#include "wasm.h"

namespace wasm {

// General value numbering: Returns a number for an expression. Expressions with
// the same number must be identical in value; expressions with different values
// might happen to be identical at runtime.
class ValueNumbering {
public:
  // Get the value numbering of an arbitrary expression.
  Index getValue(Expression* expr) {
    if (Properties::isConstantExpression(expr)) {
      return getValue(Properties::getLiterals(expr));
    } else {
      auto iter = expressionValues.find(expr);
      if (iter != expressionValues.end()) {
        return iter->second;
      }
      // TODO: full GVN to check for different expressions with the same value.
      return expressionValues[expr] = getUniqueValue();
    }
  }

  // Get the value numbering of an arbitrary set of constants.
  Index getValue(Literals lit) {
    auto iter = literalValues.find(lit);
    if (iter != literalValues.end()) {
      return iter->second;
    }
    return literalValues[lit] = getUniqueValue();
  }

  // Return a new unique value. Normally this is called internally, but there
  // are also use cases for the user of the class to call this, when they want
  // to get a new value that will not collide with any others.
  Index getUniqueValue() { return nextValue++; }

private:
  Index nextValue = 0;

  // Cache the value numbers of literals and expressions.
  std::unordered_map<Literals, Index> literalValues;
  std::unordered_map<Expression*, Index> expressionValues;
};

} // namespace wasm

#endif // wasm_ir_numberings_h
