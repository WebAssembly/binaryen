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

#include <algorithm>
#include <limits>

namespace wasm {

namespace {

void accumulatePosition(uint32_t& lineAcc,
                        uint32_t& colAcc,
                        uint32_t lineInc,
                        uint32_t colInc) {
  lineAcc += lineInc;
  if (lineInc == 0) {
    colAcc += colInc;
  } else {
    colAcc = colInc;
  }
}

std::optional<uint32_t>
accumulateIndex(int64_t& acc, int32_t inc, size_t numNames) {
  acc += inc;
  if (acc < 0) {
    acc = 0;
  }
  if (uint64_t(acc) >= numNames) {
    return std::nullopt;
  }
  return uint32_t(acc);
}

} // anonymous namespace

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

  // Flattened pre-order OriginalScope entries per source file, used locally
  // while decoding "ranges" to resolve scope names and relative call sites.
  struct ParsedScope {
    uint32_t line = 1;
    uint32_t col = 0;
    std::optional<uint32_t> symbol;
  };
  std::vector<std::vector<ParsedScope>> parsedScopes;

  if (json.has("scopes")) {
    json::Ref sc = json["scopes"];
    if (!sc->isArray()) {
      throw MapParseException("Source map scopes is not an array");
    }
    size_t numScopes = sc->size();
    parsedScopes.resize(numScopes);
    for (size_t i = 0; i < numScopes; i++) {
      json::Ref v = sc[i];
      if (v->isNull()) {
        continue;
      }
      if (!v->isString()) {
        throw MapParseException("Source map scopes contains non-string");
      }
      std::string_view scopeStr = v->getCString();
      size_t openDepth = 0;
      uint32_t scopeLine = 0;
      uint32_t scopeCol = 0;
      int64_t scopeNameIndex = 0;
      int64_t scopeKindIndex = 0;
      size_t p = 0;
      while (p < scopeStr.size()) {
        if (scopeStr[p] == ',') {
          ++p;
          continue;
        }
        uint32_t tag = readBase64VLQUnsigned(scopeStr, p);
        if (tag == 1) { // 'B': OriginalScopeStart
          uint32_t flags = readBase64VLQUnsigned(scopeStr, p);
          uint32_t relLine = readBase64VLQUnsigned(scopeStr, p);
          uint32_t relCol = readBase64VLQUnsigned(scopeStr, p);
          accumulatePosition(scopeLine, scopeCol, relLine, relCol);
          ParsedScope scope;
          scope.line = scopeLine + 1;
          scope.col = scopeCol;
          if (flags & 0x1) {
            int32_t relName = readBase64VLQSigned(scopeStr, p);
            scope.symbol = accumulateIndex(
              scopeNameIndex, relName, wasm.debugInfoSymbolNames.size());
          }
          if (flags & 0x2) {
            int32_t relKind = readBase64VLQSigned(scopeStr, p);
            accumulateIndex(
              scopeKindIndex, relKind, wasm.debugInfoSymbolNames.size());
          }
          while (p < scopeStr.size() && scopeStr[p] != ',') {
            readBase64VLQUnsigned(scopeStr, p);
          }
          parsedScopes[i].push_back(scope);
          ++openDepth;
        } else if (tag == 2) { // 'C': OriginalScopeEnd
          uint32_t relLine = readBase64VLQUnsigned(scopeStr, p);
          uint32_t relCol = readBase64VLQUnsigned(scopeStr, p);
          accumulatePosition(scopeLine, scopeCol, relLine, relCol);
          while (p < scopeStr.size() && scopeStr[p] != ',') {
            readBase64VLQUnsigned(scopeStr, p);
          }
          if (openDepth == 0) {
            throw MapParseException("Unexpected OriginalScopeEnd in scopes");
          }
          --openDepth;
        } else {
          // OriginalScopeVariables ('D' = 3), VendorExtensionItem ('V' = 21),
          // or InvalidScopeItem: ignore.
          while (p < scopeStr.size() && scopeStr[p] != ',') {
            readBase64VLQUnsigned(scopeStr, p);
          }
        }
        if (p < scopeStr.size()) {
          if (scopeStr[p] != ',') {
            throw MapParseException("Expected delimiter in scopes");
          }
          ++p;
        }
      }
      if (openDepth != 0) {
        throw MapParseException("Unclosed scope in scopes");
      }
    }
  }

  if (json.has("ranges")) {
    json::Ref rg = json["ranges"];
    std::vector<std::string_view> rangeSegments;
    if (rg->isArray()) {
      for (size_t i = 0; i < rg->size(); i++) {
        if (!rg[i]->isString()) {
          throw MapParseException("Source map ranges contains non-string");
        }
        rangeSegments.push_back(rg[i]->getCString());
      }
    } else if (rg->isString()) {
      rangeSegments.push_back(rg->getCString());
    } else {
      throw MapParseException("Source map ranges is not an array or string");
    }

    struct OpenRange {
      DecodedRange range;
      std::optional<uint32_t> defFile;
      std::optional<uint32_t> defScope;
    };

    for (std::string_view rangeStr : rangeSegments) {
      uint32_t rangeLine = 0;
      uint32_t rangeCol = 0;
      int64_t defSourceIndex = 0;
      int64_t defScopeIndex = 0;
      std::vector<OpenRange> stack;
      size_t p = 0;
      while (p < rangeStr.size()) {
        if (rangeStr[p] == ',') {
          ++p;
          continue;
        }
        uint32_t tag = readBase64VLQUnsigned(rangeStr, p);
        if (tag == 4) { // 'E': GeneratedRangeStart
          uint32_t flags = readBase64VLQUnsigned(rangeStr, p);
          uint32_t relLine =
            (flags & 0x1) ? readBase64VLQUnsigned(rangeStr, p) : 0;
          uint32_t relCol = readBase64VLQUnsigned(rangeStr, p);
          accumulatePosition(rangeLine, rangeCol, relLine, relCol);
          OpenRange open;
          open.range.startOffset = rangeCol;
          open.range.endOffset = rangeCol;
          if (flags & 0x2) {
            int32_t srcOffset = readBase64VLQSigned(rangeStr, p);
            defSourceIndex += srcOffset;
            if (defSourceIndex < 0) {
              defSourceIndex = 0;
            }
            int64_t scpOffset = 0;
            if (srcOffset == 0) {
              scpOffset = readBase64VLQSigned(rangeStr, p);
            } else {
              defScopeIndex = 0;
              scpOffset = readBase64VLQUnsigned(rangeStr, p);
            }
            defScopeIndex += scpOffset;
            if (defScopeIndex < 0) {
              defScopeIndex = 0;
            }
            if (size_t(defSourceIndex) < parsedScopes.size() &&
                size_t(defScopeIndex) < parsedScopes[defSourceIndex].size()) {
              open.defFile = uint32_t(defSourceIndex);
              open.defScope = uint32_t(defScopeIndex);
              open.range.symbol =
                parsedScopes[defSourceIndex][defScopeIndex].symbol;
            }
          }
          while (p < rangeStr.size() && rangeStr[p] != ',') {
            readBase64VLQUnsigned(rangeStr, p);
          }
          stack.push_back(std::move(open));
        } else if (tag == 5) { // 'F': GeneratedRangeEnd
          uint32_t v1 = readBase64VLQUnsigned(rangeStr, p);
          if (p < rangeStr.size() && rangeStr[p] != ',') {
            uint32_t v2 = readBase64VLQUnsigned(rangeStr, p);
            accumulatePosition(rangeLine, rangeCol, v1, v2);
          } else {
            accumulatePosition(rangeLine, rangeCol, 0, v1);
          }
          while (p < rangeStr.size() && rangeStr[p] != ',') {
            readBase64VLQUnsigned(rangeStr, p);
          }
          if (stack.empty()) {
            throw MapParseException("Unexpected GeneratedRangeEnd in ranges");
          }
          auto finished = std::move(stack.back().range);
          stack.pop_back();
          finished.endOffset = rangeCol;
          if (stack.empty()) {
            rootRanges.push_back(std::move(finished));
          } else {
            stack.back().range.children.push_back(std::move(finished));
          }
        } else if (tag == 8) { // 'I': GeneratedRangeCallSite
          if (stack.empty()) {
            throw MapParseException(
              "Unexpected GeneratedRangeCallSite outside range");
          }
          uint32_t csSource = readBase64VLQUnsigned(rangeStr, p);
          uint32_t csLine = readBase64VLQUnsigned(rangeStr, p);
          uint32_t csCol = readBase64VLQUnsigned(rangeStr, p);
          while (p < rangeStr.size() && rangeStr[p] != ',') {
            readBase64VLQUnsigned(rangeStr, p);
          }
          stack.back().range.callSite =
            CallSitePos{csSource, csLine + 1, csCol};
        } else if (tag == 9) { // 'J': GeneratedRangeRelativeCallSite
          if (stack.empty()) {
            throw MapParseException(
              "Unexpected GeneratedRangeRelativeCallSite outside range");
          }
          SmallVector<uint32_t, 3> vals;
          while (p < rangeStr.size() && rangeStr[p] != ',') {
            vals.push_back(readBase64VLQUnsigned(rangeStr, p));
          }
          if (!vals.empty() && vals.size() <= 3) {
            uint32_t parentIdx = (vals.size() == 3) ? vals[0] : 0;
            const OpenRange* parentDefRange = nullptr;
            uint32_t seenDefs = 0;
            for (int i = int(stack.size()) - 2; i >= 0; --i) {
              if (stack[i].defFile && stack[i].defScope) {
                if (seenDefs == parentIdx) {
                  parentDefRange = &stack[i];
                  break;
                }
                ++seenDefs;
              }
            }
            if (parentDefRange) {
              const auto& parentScope = parsedScopes[*parentDefRange->defFile]
                                                    [*parentDefRange->defScope];
              uint32_t csFile = *parentDefRange->defFile;
              uint32_t csLine = parentScope.line;
              uint32_t csCol = parentScope.col;
              if (vals.size() == 3) {
                csLine += vals[1];
                csCol = vals[2];
              } else if (vals.size() == 2) {
                csLine += vals[0];
                csCol = vals[1];
              } else {
                csCol += vals[0];
              }
              stack.back().range.callSite = CallSitePos{csFile, csLine, csCol};
            }
          }
        } else {
          // VendorExtensionItem ('V' = 21) or InvalidRangeItem: ignore.
          while (p < rangeStr.size() && rangeStr[p] != ',') {
            readBase64VLQUnsigned(rangeStr, p);
          }
        }
        if (p < rangeStr.size()) {
          if (rangeStr[p] != ',') {
            throw MapParseException("Expected delimiter in ranges");
          }
          ++p;
        }
      }
      if (!stack.empty()) {
        throw MapParseException("Unclosed range in ranges");
      }
    }
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

Function::DebugLocations
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
    return {};
  }

  auto sym = hasSymbol ? symbol : std::optional<uint32_t>{};
  Function::DebugLocations result;

  SmallVector<const DecodedRange*, 4> activeRanges;
  const std::vector<DecodedRange>* rangeList = &rootRanges;
  while (!rangeList->empty()) {
    // Find the last range whose startOffset <= currLocation.
    auto it = std::upper_bound(rangeList->begin(),
                               rangeList->end(),
                               currLocation,
                               [](size_t offset, const DecodedRange& r) {
                                 return offset < r.startOffset;
                               });
    const DecodedRange* match = nullptr;
    while (it != rangeList->begin()) {
      --it;
      if (currLocation >= it->startOffset && currLocation < it->endOffset) {
        match = &*it;
        break;
      }
      if (it->endOffset <= currLocation) {
        break;
      }
    }
    if (!match) {
      break;
    }
    activeRanges.push_back(match);
    rangeList = &match->children;
  }

  if (activeRanges.empty()) {
    result.emplace_back(file, line, col, sym);
    return result;
  }

  std::optional<uint32_t> frameSym = activeRanges[0]->symbol;
  if (activeRanges[0]->callSite) {
    // Top-level inlined range with no enclosing parent GeneratedRange.
    const auto& cs = *activeRanges[0]->callSite;
    result.emplace_back(cs.file, cs.line, cs.col, std::nullopt);
  }

  for (size_t i = 1; i < activeRanges.size(); ++i) {
    const auto* r = activeRanges[i];
    if (r->callSite) {
      const auto& cs = *r->callSite;
      result.emplace_back(cs.file, cs.line, cs.col, frameSym);
      frameSym = r->symbol;
    }
  }

  result.emplace_back(file, line, col, sym ? sym : frameSym);
  return result;
}

uint32_t SourceMapReader::readBase64VLQUnsigned(std::string_view str,
                                                size_t& p) {
  uint64_t value = 0;
  uint32_t shift = 0;
  while (1) {
    if (p >= str.size()) {
      throw MapParseException("unexpected end of source map");
    }
    char ch = str[p++];
    if ((ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch < 'g')) {
      // last number digit
      uint64_t digit = ch < 'a' ? ch - 'A' : ch - 'a' + 26;
      value |= digit << shift;
      if (value >= (1ULL << 32)) {
        throw MapParseException("VLQ value too large");
      }
      break;
    }
    if (!(ch >= 'g' && ch <= 'z') && !(ch >= '0' && ch <= '9') && ch != '+' &&
        ch != '/') {
      throw MapParseException("invalid VLQ digit");
    }
    uint64_t digit =
      ch > '9' ? ch - 'g' : (ch >= '0' ? ch - '0' + 20 : (ch == '+' ? 30 : 31));
    value |= digit << shift;
    shift += 5;
    if (shift >= 32) {
      throw MapParseException("VLQ value too large");
    }
  }
  return uint32_t(value);
}

int32_t SourceMapReader::readBase64VLQSigned(std::string_view str, size_t& p) {
  uint32_t value = readBase64VLQUnsigned(str, p);
  if ((value & 1) && (value >> 1) == 0) {
    return std::numeric_limits<int32_t>::min();
  }
  return (value & 1) ? -int32_t(value >> 1) : int32_t(value >> 1);
}

int32_t SourceMapReader::readBase64VLQ() {
  return readBase64VLQSigned(mappings, pos);
}

} // namespace wasm
