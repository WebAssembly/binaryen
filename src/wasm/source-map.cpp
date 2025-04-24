/*
 * Copyright 2024 WebAssembly Community Group participants
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

#include "source-map.h"
#include "support/colors.h"
#include "support/json.h"

namespace wasm {

std::vector<char> defaultEmptySourceMap;

void MapParseException::dump(std::ostream& o) const {
  Colors::magenta(o);
  o << "[";
  Colors::red(o);
  o << "map parse exception: ";
  Colors::green(o);
  o << errorText;
  Colors::magenta(o);
  o << "]";
  Colors::normal(o);
}

void SourceMapReader::parse(Module& wasm) {
  if (buffer.empty()) {
    return;
  }
  json::Value json;
  try {
    json.parse(buffer.data(), json::Value::ASCII);
  } catch (json::JsonParseException jx) {
    throw MapParseException(jx);
  }
  if (!json.isObject()) {
    throw MapParseException("Source map is not valid JSON");
  }
  if (!(json.has("version") && json["version"]->isNumber() &&
        json["version"]->getInteger() == 3)) {
    throw MapParseException("Source map version missing or is not 3");
  }
  if (!(json.has("sources") && json["sources"]->isArray())) {
    throw MapParseException("Source map sources missing or not an array");
  }
  json::Ref s = json["sources"];
  for (size_t i = 0; i < s->size(); i++) {
    json::Ref v = s[i];
    if (!(s[i]->isString())) {
      throw MapParseException("Source map sources contains non-string");
    }
    wasm.debugInfoFileNames.push_back(v->getCString());
  }

  if (json.has("sourcesContent")) {
    json::Ref sc = json["sourcesContent"];
    if (!sc->isArray()) {
      throw MapParseException("Source map sourcesContent is not an array");
    }
    for (size_t i = 0; i < sc->size(); i++) {
      wasm.debugInfoSourcesContent.push_back(sc[i]->getCString());
    }
  }

  if (json.has("names")) {
    json::Ref n = json["names"];
    if (!n->isArray()) {
      throw MapParseException("Source map names is not an array");
    }
    for (size_t i = 0; i < n->size(); i++) {
      json::Ref v = n[i];
      if (!v->isString()) {
        throw MapParseException("Source map names contains non-string");
      }
      wasm.debugInfoSymbolNames.push_back(v->getCString());
    }
  }

  if (json.has("sourceRoot")) {
    json::Ref sr = json["sourceRoot"];
    if (!sr->isString()) {
      throw MapParseException("Source map sourceRoot is not a string");
    }
    wasm.debugInfoSourceRoot = sr->getCString();
  }

  if (json.has("file")) {
    json::Ref f = json["file"];
    if (!f->isString()) {
      throw MapParseException("Source map file is not a string");
    }
    wasm.debugInfoFile = f->getCString();
  }

  if (!json.has("mappings")) {
    throw MapParseException("Source map mappings missing");
  }
  json::Ref m = json["mappings"];
  if (!m->isString()) {
    throw MapParseException("Source map mappings is not a string");
  }

  mappings = m->getCString();
  if (mappings.empty()) {
    // There are no mappings.
    location = 0;
    return;
  }

  // Read the location of the first debug location.
  location = readBase64VLQ();
}

std::optional<Function::DebugLocation>
SourceMapReader::readDebugLocationAt(size_t currLocation) {
  while (location && location <= currLocation) {
    do {
      char next = peek();
      if (next == ',' || next == '\"') {
        // This is a 1-length entry, so the next location has no debug info.
        hasInfo = false;
        break;
      }

      hasInfo = true;
      file += readBase64VLQ();
      line += readBase64VLQ();
      col += readBase64VLQ();

      next = peek();
      if (next == ';') {
        // Generated JS files can have multiple lines, and mappings for each
        // line are separated by ';'. Wasm files do not have lines, so there
        // should be only one generated "line".
        throw MapParseException("Unexpected mapping for 2nd generated line");
      }
      if (next == ',' || next == '\"') {
        hasSymbol = false;
        break;
      }

      hasSymbol = true;
      symbol += readBase64VLQ();

    } while (false);

    // Check whether there is another record to read the position for.

    if (peek() == '\"') {
      // End of records.
      location = 0;
      break;
    }
    if (get() != ',') {
      throw MapParseException("Expected delimiter");
    }

    // Set up for the next record.
    location += readBase64VLQ();
  }

  if (!hasInfo) {
    return std::nullopt;
  }
  auto sym = hasSymbol ? symbol : std::optional<uint32_t>{};
  return Function::DebugLocation{file, line, col, sym};
}

int32_t SourceMapReader::readBase64VLQ() {
  uint32_t value = 0;
  uint32_t shift = 0;
  while (1) {
    auto ch = get();
    if ((ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch < 'g')) {
      // last number digit
      uint32_t digit = ch < 'a' ? ch - 'A' : ch - 'a' + 26;
      value |= digit << shift;
      break;
    }
    if (!(ch >= 'g' && ch <= 'z') && !(ch >= '0' && ch <= '9') && ch != '+' &&
        ch != '/') {
      throw MapParseException("invalid VLQ digit");
    }
    uint32_t digit =
      ch > '9' ? ch - 'g' : (ch >= '0' ? ch - '0' + 20 : (ch == '+' ? 30 : 31));
    value |= digit << shift;
    shift += 5;
  }
  return value & 1 ? -int32_t(value >> 1) : int32_t(value >> 1);
}

} // namespace wasm
