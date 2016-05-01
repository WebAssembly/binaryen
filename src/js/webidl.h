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

// Literal type subclasses for Web IDL

class I32Literal : public Literal {
public:
  I32Literal(int32_t  init) : Literal(init) {}
};
class F32Literal : public Literal {
public:
  F32Literal(float  init) : Literal(init) {}
};
class F64Literal : public Literal {
public:
  F64Literal(double  init) : Literal(init) {}
};