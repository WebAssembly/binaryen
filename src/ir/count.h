/*
 * Copyright 2016 WebAssembly Community Group participants
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

#ifndef wasm_ir_count_h
#define wasm_ir_count_h

namespace wasm {

struct GetLocalCounter : public PostWalker<GetLocalCounter> {
  std::vector<Index> num;

  GetLocalCounter() {}
  GetLocalCounter(Function* func) {
    analyze(func, func->body);
  }
  GetLocalCounter(Function* func, Expression* ast) {
    analyze(func, ast);
  }

  void analyze(Function* func) {
    analyze(func, func->body);
  }
  void analyze(Function* func, Expression* ast) {
    num.resize(func->getNumLocals());
    std::fill(num.begin(), num.end(), 0);
    walk(ast);
  }

  void visitGetLocal(GetLocal *curr) {
    num[curr->index]++;
  }
};

} // namespace wasm

#endif // wasm_ir_count_h

