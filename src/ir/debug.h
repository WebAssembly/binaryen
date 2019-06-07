/*
 * Copyright 2019 WebAssembly Community Group participants
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

#ifndef wasm_ir_debug_h
#define wasm_ir_debug_h

#include <wasm-traversal.h>

namespace wasm {

namespace debug {

// Given an expression and a copy of it in another function, copy the debug
// info into the second function.
inline void copyDebugInfo(Expression* origin,
                          Expression* copy,
                          Function* originFunc,
                          Function* copyFunc) {
  struct Lister : public PostWalker<Lister, UnifiedExpressionVisitor<Lister>> {
    std::vector<Expression*> list;
    void visitExpression(Expression* curr) { list.push_back(curr); }
  };

  Lister originList;
  originList.walk(origin);
  Lister copyList;
  copyList.walk(copy);

  auto& originDebug = originFunc->debugLocations;
  auto& copyDebug = copyFunc->debugLocations;

  assert(originList.list.size() == copyList.list.size());
  for (Index i = 0; i < originList.list.size(); i++) {
    auto iter = originDebug.find(originList.list[i]);
    if (iter != originDebug.end()) {
      auto location = iter->second;
      copyDebug[copyList.list[i]] = location;
    }
  }
};

} // namespace debug

} // namespace wasm

#endif // wasm_ir_debug_h
