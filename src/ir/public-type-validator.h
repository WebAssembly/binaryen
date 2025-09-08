/*
 * Copyright 2025 WebAssembly Community Group participants
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

#ifndef wasm_ir_public_type_validator_h
#define wasm_ir_public_type_validator_h

#include "wasm-features.h"
#include "wasm-type.h"

#include <unordered_map>

namespace wasm {

// Utility for determining whether it is valid to make a given type public given
// some enabled feature set. Used in the fuzzer for determining whether a
// function can be exported, for instance.
class PublicTypeValidator {
public:
  explicit PublicTypeValidator(FeatureSet features) : features(features) {}

  bool isValidPublicType(HeapType type) {
    if (features.hasCustomDescriptors()) {
      return true;
    }
    if (type.isBasic()) {
      return true;
    }
    return isValidPublicTypeImpl(type);
  }

  bool isValidPublicType(Type type) {
    if (features.hasCustomDescriptors()) {
      return true;
    }
    if (type.isBasic()) {
      return true;
    }
    if (type.isTuple()) {
      for (auto t : type) {
        if (!isValidPublicType(t)) {
          return false;
        }
      }
      return true;
    }
    assert(type.isRef());
    if (type.isExact()) {
      return false;
    }
    return isValidPublicType(type.getHeapType());
  }

private:
  FeatureSet features;
  std::unordered_map<RecGroup, bool> allowedPublicGroupCache;
  bool isValidPublicTypeImpl(HeapType type);
};

} // namespace wasm

#endif // wasm_ir_public_type_validator_h
