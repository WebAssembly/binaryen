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

#ifndef wasm_safe_integer_h
#define wasm_safe_integer_h

#include <cstdint>

namespace wasm {

bool isInteger(double x);
bool isUInteger32(double x);
bool isSInteger32(double x);
uint32_t toUInteger32(double x);
int32_t toSInteger32(double x);
bool isUInteger64(double x);
bool isSInteger64(double x);
uint64_t toUInteger64(double x);
int64_t toSInteger64(double x);
// The isInRange* functions all expect to be passed the binary representation
// of a float or double.
bool isInRangeI32TruncS(int32_t i);
bool isInRangeI64TruncS(int32_t i);
bool isInRangeI32TruncU(int32_t i);
bool isInRangeI64TruncU(int32_t i);
bool isInRangeI32TruncS(int64_t i);
bool isInRangeI32TruncU(int64_t i);
bool isInRangeI64TruncS(int64_t i);
bool isInRangeI64TruncU(int64_t i);

} // namespace wasm

#endif // wasm_safe_integer_h
