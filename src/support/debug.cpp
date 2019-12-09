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

#include "support/debug.h"

#include <cstring>
#include <set>
#include <string>

#ifndef NDEBUG

static bool debugEnabled = false;
static std::set<std::string> debugTypesEnabled;

bool wasm::isDebugEnabled(const char* type) {
  if (!debugEnabled) {
    return false;
  }
  if (debugTypesEnabled.empty()) {
    return true;
  }
  return debugTypesEnabled.count(type) > 0;
}

void wasm::setDebugEnabled(const char* types) {
  debugEnabled = true;
  // split types on comma and add each string to debugTypesEnabled
  size_t start = 0;
  size_t end = strlen(types);
  while (start < end) {
    const char* type_end = strchr(types + start, ',');
    if (type_end == nullptr) {
      type_end = types + end;
    }
    size_t type_size = type_end - (types + start);
    std::string type(types + start, type_size);
    debugTypesEnabled.insert(type);
    start += type_size + 1;
  }
}

#endif
