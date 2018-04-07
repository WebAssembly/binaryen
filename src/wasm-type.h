/*
 * Copyright 2017 WebAssembly Community Group participants
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

#ifndef wasm_wasm_type_h
#define wasm_wasm_type_h

namespace wasm {

enum Type {
  none,
  i32,
  i64,
  f32,
  f64,
  unreachable // none means no type, e.g. a block can have no return type. but
              // unreachable is different, as it can be "ignored" when doing
              // type checking across branches
};

const char* printType(Type type);
unsigned getTypeSize(Type type);
Type getType(unsigned size, bool float_);
Type getReachableType(Type a, Type b);
bool isConcreteType(Type type);
bool isFloatType(Type type);
bool isIntegerType(Type type);

} // namespace wasm

#endif // wasm_wasm_type_h
