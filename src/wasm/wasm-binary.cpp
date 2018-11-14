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

#include <algorithm>
#include <fstream>

#include "support/bits.h"
#include "wasm-binary.h"
#include "wasm-stack.h"
#include "ir/module-utils.h"

namespace wasm {

void WasmBinaryWriter::prepare() {
  // we need function types for all our functions
  for (auto& func : wasm->functions) {
    if (func->type.isNull()) {
      func->type = ensureFunctionType(getSig(func.get()), wasm)->name;
    }
    // TODO: depending on upstream flux https://github.com/WebAssembly/spec/pull/301 might want this: assert(!func->type.isNull());
  }
  ModuleUtils::BinaryIndexes indexes(*wasm);
  mappedFunctions = std::move(indexes.functionIndexes);
  mappedGlobals = std::move(indexes.globalIndexes);

  importInfo = wasm::make_unique<ImportInfo>(*wasm);
}

void WasmBinaryWriter::write() {
  writeHeader();

  writeEarlyUserSections();

  if (sourceMap) {
    writeSourceMapProlog();
  }

  writeTypes();
  writeImports();
  writeFunctionSignatures();
  writeFunctionTableDeclaration();
  writeMemory();
  writeGlobals();
  writeExports();
  writeStart();
  writeTableElements();
  writeFunctions();
  writeDataSegments();
  if (debugInfo) writeNames();
  if (sourceMap && !sourceMapUrl.empty()) writeSourceMapUrl();
  if (symbolMap.size() > 0) writeSymbolMap();

  if (sourceMap) {
    writeSourceMapEpilog();
  }

  writeLateUserSections();

  finishUp();
}

void WasmBinaryWriter::writeHeader() {
  if (debug) std::cerr << "== writeHeader" << std::endl;
  o << int32_t(BinaryConsts::Magic); // magic number \0asm
  o << int32_t(BinaryConsts::Version);
}

int32_t WasmBinaryWriter::writeU32LEBPlaceholder() {
  int32_t ret = o.size();
  o << int32_t(0);
  o << int8_t(0);
  return ret;
}

void WasmBinaryWriter::writeResizableLimits(Address initial, Address maximum,
                                            bool hasMaximum, bool shared) {
  uint32_t flags =
      (hasMaximum ? (uint32_t) BinaryConsts::HasMaximum : 0U) |
      (shared ? (uint32_t) BinaryConsts::IsShared : 0U);
  o << U32LEB(flags);
  o << U32LEB(initial);
  if (hasMaximum) {
    o << U32LEB(maximum);
  }
}

template<typename T>
int32_t WasmBinaryWriter::startSection(T code) {
  o << U32LEB(code);
  if (sourceMap) sourceMapLocationsSizeAtSectionStart = sourceMapLocations.size();
  return writeU32LEBPlaceholder(); // section size to be filled in later
}

void WasmBinaryWriter::finishSection(int32_t start) {
  int32_t size = o.size() - start - MaxLEB32Bytes; // section size does not include the reserved bytes of the size field itself
  auto sizeFieldSize = o.writeAt(start, U32LEB(size));
  if (sizeFieldSize != MaxLEB32Bytes) {
    // we can save some room, nice
    assert(sizeFieldSize < MaxLEB32Bytes);
    std::move(&o[start] + MaxLEB32Bytes, &o[start] + MaxLEB32Bytes + size, &o[start] + sizeFieldSize);
    auto adjustment = MaxLEB32Bytes - sizeFieldSize;
    o.resize(o.size() - adjustment);
    if (sourceMap) {
      for (auto i = sourceMapLocationsSizeAtSectionStart; i < sourceMapLocations.size(); ++i) {
        sourceMapLocations[i].first -= adjustment;
      }
    }
  }
}

int32_t WasmBinaryWriter::startSubsection(BinaryConsts::UserSections::Subsection code) {
  return startSection(code);
}

void WasmBinaryWriter::finishSubsection(int32_t start) {
  finishSection(start);
}

void WasmBinaryWriter::writeStart() {
  if (!wasm->start.is()) return;
  if (debug) std::cerr << "== writeStart" << std::endl;
  auto start = startSection(BinaryConsts::Section::Start);
  o << U32LEB(getFunctionIndex(wasm->start.str));
  finishSection(start);
}

void WasmBinaryWriter::writeMemory() {
  if (!wasm->memory.exists || wasm->memory.imported()) return;
  if (debug) std::cerr << "== writeMemory" << std::endl;
  auto start = startSection(BinaryConsts::Section::Memory);
  o << U32LEB(1); // Define 1 memory
  writeResizableLimits(wasm->memory.initial, wasm->memory.max,
                       wasm->memory.hasMax(), wasm->memory.shared);
  finishSection(start);
}

void WasmBinaryWriter::writeTypes() {
  if (wasm->functionTypes.size() == 0) return;
  if (debug) std::cerr << "== writeTypes" << std::endl;
  auto start = startSection(BinaryConsts::Section::Type);
  o << U32LEB(wasm->functionTypes.size());
  for (auto& type : wasm->functionTypes) {
    if (debug) std::cerr << "write one" << std::endl;
    o << S32LEB(BinaryConsts::EncodedType::Func);
    o << U32LEB(type->params.size());
    for (auto param : type->params) {
      o << binaryType(param);
    }
    if (type->result == none) {
      o << U32LEB(0);
    } else {
      o << U32LEB(1);
      o << binaryType(type->result);
    }
  }
  finishSection(start);
}

int32_t WasmBinaryWriter::getFunctionTypeIndex(Name type) {
  // TODO: optimize
  for (size_t i = 0; i < wasm->functionTypes.size(); i++) {
    if (wasm->functionTypes[i]->name == type) return i;
  }
  abort();
}

void WasmBinaryWriter::writeImports() {
  auto num = importInfo->getNumImports();
  if (num == 0) return;
  if (debug) std::cerr << "== writeImports" << std::endl;
  auto start = startSection(BinaryConsts::Section::Import);
  o << U32LEB(num);
  auto writeImportHeader = [&](Importable* import) {
    writeInlineString(import->module.str);
    writeInlineString(import->base.str);
  };
  ModuleUtils::iterImportedFunctions(*wasm, [&](Function* func) {
    if (debug) std::cerr << "write one function" << std::endl;
    writeImportHeader(func);
    o << U32LEB(int32_t(ExternalKind::Function));
    o << U32LEB(getFunctionTypeIndex(func->type));
  });
  ModuleUtils::iterImportedGlobals(*wasm, [&](Global* global) {
    if (debug) std::cerr << "write one global" << std::endl;
    writeImportHeader(global);
    o << U32LEB(int32_t(ExternalKind::Global));
    o << binaryType(global->type);
    o << U32LEB(0); // Mutable globals can't be imported for now.
  });
  if (wasm->memory.imported()) {
    if (debug) std::cerr << "write one memory" << std::endl;
    writeImportHeader(&wasm->memory);
    o << U32LEB(int32_t(ExternalKind::Memory));
    writeResizableLimits(wasm->memory.initial, wasm->memory.max,
                         wasm->memory.hasMax(), wasm->memory.shared);
  }
  if (wasm->table.imported()) {
    if (debug) std::cerr << "write one table" << std::endl;
    writeImportHeader(&wasm->table);
    o << U32LEB(int32_t(ExternalKind::Table));
    o << S32LEB(BinaryConsts::EncodedType::AnyFunc);
    writeResizableLimits(wasm->table.initial, wasm->table.max, wasm->table.hasMax(), /*shared=*/false);
  }
  finishSection(start);
}

void WasmBinaryWriter::writeFunctionSignatures() {
  if (importInfo->getNumDefinedFunctions() == 0) return;
  if (debug) std::cerr << "== writeFunctionSignatures" << std::endl;
  auto start = startSection(BinaryConsts::Section::Function);
  o << U32LEB(importInfo->getNumDefinedFunctions());
  ModuleUtils::iterDefinedFunctions(*wasm, [&](Function* func) {
    if (debug) std::cerr << "write one" << std::endl;
    o << U32LEB(getFunctionTypeIndex(func->type));
  });
  finishSection(start);
}

void WasmBinaryWriter::writeExpression(Expression* curr) {
  ExpressionStackWriter<WasmBinaryWriter>(curr, *this, o, debug);
}

void WasmBinaryWriter::writeFunctions() {
  if (importInfo->getNumDefinedFunctions() == 0) return;
  if (debug) std::cerr << "== writeFunctions" << std::endl;
  auto start = startSection(BinaryConsts::Section::Code);
  o << U32LEB(importInfo->getNumDefinedFunctions());
  ModuleUtils::iterDefinedFunctions(*wasm, [&](Function* func) {
    size_t sourceMapLocationsSizeAtFunctionStart = sourceMapLocations.size();
    if (debug) std::cerr << "write one at" << o.size() << std::endl;
    size_t sizePos = writeU32LEBPlaceholder();
    size_t start = o.size();
    if (debug) std::cerr << "writing" << func->name << std::endl;
    // Emit Stack IR if present, and if we can
    if (func->stackIR && !sourceMap) {
      if (debug) std::cerr << "write Stack IR" << std::endl;
      StackIRFunctionStackWriter<WasmBinaryWriter>(func, *this, o, debug);
    } else {
      if (debug) std::cerr << "write Binaryen IR" << std::endl;
      FunctionStackWriter<WasmBinaryWriter>(func, *this, o, sourceMap, debug);
    }
    size_t size = o.size() - start;
    assert(size <= std::numeric_limits<uint32_t>::max());
    if (debug) std::cerr << "body size: " << size << ", writing at " << sizePos << ", next starts at " << o.size() << std::endl;
    auto sizeFieldSize = o.writeAt(sizePos, U32LEB(size));
    if (sizeFieldSize != MaxLEB32Bytes) {
      // we can save some room, nice
      assert(sizeFieldSize < MaxLEB32Bytes);
      std::move(&o[start], &o[start] + size, &o[sizePos] + sizeFieldSize);
      auto adjustment = MaxLEB32Bytes - sizeFieldSize;
      o.resize(o.size() - adjustment);
      if (sourceMap) {
        for (auto i = sourceMapLocationsSizeAtFunctionStart; i < sourceMapLocations.size(); ++i) {
          sourceMapLocations[i].first -= adjustment;
        }
      }
    }
    tableOfContents.functionBodies.emplace_back(func->name, sizePos + sizeFieldSize, size);
  });
  finishSection(start);
}

void WasmBinaryWriter::writeGlobals() {
  if (importInfo->getNumDefinedGlobals() == 0) return;
  if (debug) std::cerr << "== writeglobals" << std::endl;
  auto start = startSection(BinaryConsts::Section::Global);
  auto num = importInfo->getNumDefinedGlobals();
  o << U32LEB(num);
  ModuleUtils::iterDefinedGlobals(*wasm, [&](Global* global) {
    if (debug) std::cerr << "write one" << std::endl;
    o << binaryType(global->type);
    o << U32LEB(global->mutable_);
    writeExpression(global->init);
    o << int8_t(BinaryConsts::End);
  });
  finishSection(start);
}

void WasmBinaryWriter::writeExports() {
  if (wasm->exports.size() == 0) return;
  if (debug) std::cerr << "== writeexports" << std::endl;
  auto start = startSection(BinaryConsts::Section::Export);
  o << U32LEB(wasm->exports.size());
  for (auto& curr : wasm->exports) {
    if (debug) std::cerr << "write one" << std::endl;
    writeInlineString(curr->name.str);
    o << U32LEB(int32_t(curr->kind));
    switch (curr->kind) {
      case ExternalKind::Function: o << U32LEB(getFunctionIndex(curr->value)); break;
      case ExternalKind::Table: o << U32LEB(0); break;
      case ExternalKind::Memory: o << U32LEB(0); break;
      case ExternalKind::Global: o << U32LEB(getGlobalIndex(curr->value)); break;
      default: WASM_UNREACHABLE();
    }

  }
  finishSection(start);
}

static bool isEmpty(Memory::Segment& segment) {
  return segment.data.size() == 0;
}

static bool isConstantOffset(Memory::Segment& segment) {
  return segment.offset->is<Const>();
}

void WasmBinaryWriter::writeDataSegments() {
  if (wasm->memory.segments.size() == 0) return;
  Index numConstant = 0,
        numDynamic = 0;
  for (auto& segment : wasm->memory.segments) {
    if (!isEmpty(segment)) {
      if (isConstantOffset(segment)) {
        numConstant++;
      } else {
        numDynamic++;
      }
    }
  }
  // check if we have too many dynamic data segments, which we can do nothing about
  auto num = numConstant + numDynamic;
  if (numDynamic + 1 >= WebLimitations::MaxDataSegments) {
    std::cerr << "too many non-constant-offset data segments, wasm VMs may not accept this binary" << std::endl;
  }
  // we'll merge constant segments if we must
  if (numConstant + numDynamic >= WebLimitations::MaxDataSegments) {
    numConstant = WebLimitations::MaxDataSegments - numDynamic - 1;
    num = numConstant + numDynamic;
    assert(num == WebLimitations::MaxDataSegments - 1);
  }
  auto start = startSection(BinaryConsts::Section::Data);
  o << U32LEB(num);
  // first, emit all non-constant-offset segments; then emit the constants,
  // which we may merge if forced to
  Index emitted = 0;
  auto emit = [&](Memory::Segment& segment) {
    o << U32LEB(0); // Linear memory 0 in the MVP
    writeExpression(segment.offset);
    o << int8_t(BinaryConsts::End);
    writeInlineBuffer(&segment.data[0], segment.data.size());
    emitted++;
  };
  auto& segments = wasm->memory.segments;
  for (auto& segment : segments) {
    if (isEmpty(segment)) continue;
    if (isConstantOffset(segment)) continue;
    emit(segment);
  }
  // from here on, we concern ourselves with non-empty constant-offset
  // segments, the ones which we may need to merge
  auto isRelevant = [](Memory::Segment& segment) {
    return !isEmpty(segment) && isConstantOffset(segment);
  };
  for (Index i = 0; i < segments.size(); i++) {
    auto& segment = segments[i];
    if (!isRelevant(segment)) continue;
    if (emitted + 2 < WebLimitations::MaxDataSegments) {
      emit(segment);
    } else {
      // we can emit only one more segment! merge everything into one
      // start the combined segment at the bottom of them all
      auto start = segment.offset->cast<Const>()->value.getInteger();
      for (Index j = i + 1; j < segments.size(); j++) {
        auto& segment = segments[j];
        if (!isRelevant(segment)) continue;
        auto offset = segment.offset->cast<Const>()->value.getInteger();
        start = std::min(start, offset);
      }
      // create the segment and add in all the data
      Const c;
      c.value = Literal(int32_t(start));
      c.type = i32;
      Memory::Segment combined(&c);
      for (Index j = i; j < segments.size(); j++) {
        auto& segment = segments[j];
        if (!isRelevant(segment)) continue;
        auto offset = segment.offset->cast<Const>()->value.getInteger();
        auto needed = offset + segment.data.size() - start;
        if (combined.data.size() < needed) {
          combined.data.resize(needed);
        }
        std::copy(segment.data.begin(), segment.data.end(), combined.data.begin() + offset - start);
      }
      emit(combined);
      break;
    }
  }
  finishSection(start);
}

uint32_t WasmBinaryWriter::getFunctionIndex(Name name) {
  assert(mappedFunctions.count(name));
  return mappedFunctions[name];
}

uint32_t WasmBinaryWriter::getGlobalIndex(Name name) {
  assert(mappedGlobals.count(name));
  return mappedGlobals[name];
}

void WasmBinaryWriter::writeFunctionTableDeclaration() {
  if (!wasm->table.exists || wasm->table.imported()) return;
  if (debug) std::cerr << "== writeFunctionTableDeclaration" << std::endl;
  auto start = startSection(BinaryConsts::Section::Table);
  o << U32LEB(1); // Declare 1 table.
  o << S32LEB(BinaryConsts::EncodedType::AnyFunc);
  writeResizableLimits(wasm->table.initial, wasm->table.max, wasm->table.hasMax(), /*shared=*/false);
  finishSection(start);
}

void WasmBinaryWriter::writeTableElements() {
  if (!wasm->table.exists) return;
  if (debug) std::cerr << "== writeTableElements" << std::endl;
  auto start = startSection(BinaryConsts::Section::Element);

  o << U32LEB(wasm->table.segments.size());
  for (auto& segment : wasm->table.segments) {
    o << U32LEB(0); // Table index; 0 in the MVP (and binaryen IR only has 1 table)
    writeExpression(segment.offset);
    o << int8_t(BinaryConsts::End);
    o << U32LEB(segment.data.size());
    for (auto name : segment.data) {
      o << U32LEB(getFunctionIndex(name));
    }
  }
  finishSection(start);
}

void WasmBinaryWriter::writeNames() {
  bool hasContents = false;
  if (wasm->functions.size() > 0) {
    hasContents = true;
    getFunctionIndex(wasm->functions[0]->name); // generate mappedFunctions
  }
  if (!hasContents) return;
  if (debug) std::cerr << "== writeNames" << std::endl;
  auto start = startSection(BinaryConsts::Section::User);
  writeInlineString(BinaryConsts::UserSections::Name);
  auto substart = startSubsection(BinaryConsts::UserSections::Subsection::NameFunction);
  o << U32LEB(mappedFunctions.size());
  Index emitted = 0;
  auto add = [&](Function* curr) {
    o << U32LEB(emitted);
    writeEscapedName(curr->name.str);
    emitted++;
  };
  ModuleUtils::iterImportedFunctions(*wasm, add);
  ModuleUtils::iterDefinedFunctions(*wasm, add);
  assert(emitted == mappedFunctions.size());
  finishSubsection(substart);
  /* TODO: locals */
  finishSection(start);
}

void WasmBinaryWriter::writeSourceMapUrl() {
  if (debug) std::cerr << "== writeSourceMapUrl" << std::endl;
  auto start = startSection(BinaryConsts::Section::User);
  writeInlineString(BinaryConsts::UserSections::SourceMapUrl);
  writeInlineString(sourceMapUrl.c_str());
  finishSection(start);
}

void WasmBinaryWriter::writeSymbolMap() {
  std::ofstream file(symbolMap);
  auto write = [&](Function* func) {
    file << getFunctionIndex(func->name) << ":" << func->name.str << std::endl;
  };
  ModuleUtils::iterImportedFunctions(*wasm, write);
  ModuleUtils::iterDefinedFunctions(*wasm, write);
  file.close();
}

void WasmBinaryWriter::writeSourceMapProlog() {
  lastDebugLocation = { 0, /* lineNumber = */ 1, 0 };
  *sourceMap << "{\"version\":3,\"sources\":[";
  for (size_t i = 0; i < wasm->debugInfoFileNames.size(); i++) {
    if (i > 0) *sourceMap << ",";
    // TODO respect JSON string encoding, e.g. quotes and control chars.
    *sourceMap << "\"" << wasm->debugInfoFileNames[i] << "\"";
  }
  *sourceMap << "],\"names\":[],\"mappings\":\"";
}

static void writeBase64VLQ(std::ostream& out, int32_t n) {
  uint32_t value = n >= 0 ? n << 1 : ((-n) << 1) | 1;
  while (1) {
    uint32_t digit = value & 0x1F;
    value >>= 5;
    if (!value) {
      // last VLQ digit -- base64 codes 'A'..'Z', 'a'..'f'
      out << char(digit < 26 ? 'A' + digit : 'a' + digit - 26);
      break;
    }
    // more VLG digit will follow -- add continuation bit (0x20),
    // base64 codes 'g'..'z', '0'..'9', '+', '/'
    out << char(digit < 20 ? 'g' + digit : digit < 30 ? '0' + digit - 20 : digit == 30 ? '+' : '/');
  }
}

void WasmBinaryWriter::writeSourceMapEpilog() {
  // write source map entries
  size_t lastOffset = 0;
  Function::DebugLocation lastLoc = { 0, /* lineNumber = */ 1, 0 };
  for (const auto &offsetAndlocPair : sourceMapLocations) {
    if (lastOffset > 0) {
      *sourceMap << ",";
    }
    size_t offset = offsetAndlocPair.first;
    const Function::DebugLocation& loc = *offsetAndlocPair.second;
    writeBase64VLQ(*sourceMap, int32_t(offset - lastOffset));
    writeBase64VLQ(*sourceMap, int32_t(loc.fileIndex - lastLoc.fileIndex));
    writeBase64VLQ(*sourceMap, int32_t(loc.lineNumber - lastLoc.lineNumber));
    writeBase64VLQ(*sourceMap, int32_t(loc.columnNumber - lastLoc.columnNumber));
    lastLoc = loc;
    lastOffset = offset;
  }
  *sourceMap << "\"}";
}

void WasmBinaryWriter::writeEarlyUserSections() {
  // The dylink section must be the first in the module, per
  // the spec, to allow simple parsing by loaders.
  for (auto& section : wasm->userSections) {
    if (section.name == BinaryConsts::UserSections::Dylink) {
      writeUserSection(section);
    }
  }
}

void WasmBinaryWriter::writeLateUserSections() {
  for (auto& section : wasm->userSections) {
    if (section.name != BinaryConsts::UserSections::Dylink) {
      writeUserSection(section);
    }
  }
}

void WasmBinaryWriter::writeUserSection(const UserSection& section) {
  auto start = startSection(0);
  writeInlineString(section.name.c_str());
  for (size_t i = 0; i < section.data.size(); i++) {
    o << uint8_t(section.data[i]);
  }
  finishSection(start);
}

void WasmBinaryWriter::writeDebugLocation(const Function::DebugLocation& loc) {
  if (loc == lastDebugLocation) {
    return;
  }
  auto offset = o.size();
  sourceMapLocations.emplace_back(offset, &loc);
  lastDebugLocation = loc;
}

void WasmBinaryWriter::writeDebugLocation(Expression* curr, Function* func) {
  auto& debugLocations = func->debugLocations;
  auto iter = debugLocations.find(curr);
  if (iter != debugLocations.end()) {
    writeDebugLocation(iter->second);
  }
}

void WasmBinaryWriter::writeInlineString(const char* name) {
  int32_t size = strlen(name);
  o << U32LEB(size);
  for (int32_t i = 0; i < size; i++) {
    o << int8_t(name[i]);
  }
}

static bool isHexDigit(char ch) {
  return (ch >= '0' && ch <= '9') || (ch >= 'a' && ch <= 'f') || (ch >= 'A' && ch <= 'F');
}

static int decodeHexNibble(char ch) {
  return ch <= '9' ? ch & 15 : (ch & 15) + 9;
}

void WasmBinaryWriter::writeEscapedName(const char* name) {
  if (!strpbrk(name, "\\")) {
    writeInlineString(name);
    return;
  }
  // decode escaped by escapeName (see below) function names
  std::string unescaped;
  int32_t size = strlen(name);
  for (int32_t i = 0; i < size;) {
    char ch = name[i++];
    // support only `\xx` escapes; ignore invalid or unsupported escapes
    if (ch != '\\' || i + 1 >= size || !isHexDigit(name[i]) || !isHexDigit(name[i + 1])) {
      unescaped.push_back(ch);
      continue;
    }
    unescaped.push_back(char((decodeHexNibble(name[i]) << 4) | decodeHexNibble(name[i + 1])));
    i += 2;
  }
  writeInlineString(unescaped.c_str());
}

void WasmBinaryWriter::writeInlineBuffer(const char* data, size_t size) {
  o << U32LEB(size);
  for (size_t i = 0; i < size; i++) {
    o << int8_t(data[i]);
  }
}

void WasmBinaryWriter::emitBuffer(const char* data, size_t size) {
  assert(size > 0);
  buffersToWrite.emplace_back(data, size, o.size());
  o << uint32_t(0); // placeholder, we'll fill in the pointer to the buffer later when we have it
}

void WasmBinaryWriter::emitString(const char *str) {
  if (debug) std::cerr << "emitString " << str << std::endl;
  emitBuffer(str, strlen(str) + 1);
}

void WasmBinaryWriter::finishUp() {
  if (debug) std::cerr << "finishUp" << std::endl;
  // finish buffers
  for (const auto& buffer : buffersToWrite) {
    if (debug) std::cerr << "writing buffer" << (int)buffer.data[0] << "," << (int)buffer.data[1] << " at " << o.size() << " and pointer is at " << buffer.pointerLocation << std::endl;
    o.writeAt(buffer.pointerLocation, (uint32_t)o.size());
    for (size_t i = 0; i < buffer.size; i++) {
      o << (uint8_t)buffer.data[i];
    }
  }
}

// reader

void WasmBinaryBuilder::read() {

  readHeader();
  readSourceMapHeader();

  // read sections until the end
  while (more()) {
    uint32_t sectionCode = getU32LEB();
    uint32_t payloadLen = getU32LEB();
    if (pos + payloadLen > input.size()) throwError("Section extends beyond end of input");

    auto oldPos = pos;

    // note the section in the list of seen sections, as almost no sections can appear more than once,
    // and verify those that shouldn't do not.
    if (sectionCode != BinaryConsts::Section::User && sectionCode != BinaryConsts::Section::Code) {
      if (!seenSections.insert(BinaryConsts::Section(sectionCode)).second) {
        throwError("section seen more than once: " + std::to_string(sectionCode));
      }
    }

    switch (sectionCode) {
      case BinaryConsts::Section::Start: readStart(); break;
      case BinaryConsts::Section::Memory: readMemory(); break;
      case BinaryConsts::Section::Type: readSignatures(); break;
      case BinaryConsts::Section::Import: readImports(); break;
      case BinaryConsts::Section::Function: readFunctionSignatures(); break;
      case BinaryConsts::Section::Code: readFunctions(); break;
      case BinaryConsts::Section::Export: readExports(); break;
      case BinaryConsts::Section::Element: readTableElements(); break;
      case BinaryConsts::Section::Global: {
        readGlobals();
        // imports can read global imports, so we run getGlobalName and create the mapping
        // but after we read globals, we need to add the internal globals too, so do that here
        mappedGlobals.clear(); // wipe the mapping
        getGlobalName(-1); // force rebuild
        break;
      }
      case BinaryConsts::Section::Data: readDataSegments(); break;
      case BinaryConsts::Section::Table: readFunctionTableDeclaration(); break;
      default: {
        readUserSection(payloadLen);
        if (pos > oldPos + payloadLen) {
          throwError("bad user section size, started at " + std::to_string(oldPos) + " plus payload " + std::to_string(payloadLen) + " not being equal to new position " + std::to_string(pos));
        }
        pos = oldPos + payloadLen;
      }
    }

    // make sure we advanced exactly past this section
    if (pos != oldPos + payloadLen) {
      throwError("bad section size, started at " + std::to_string(oldPos) + " plus payload " + std::to_string(payloadLen) + " not being equal to new position " + std::to_string(pos));
    }
  }

  processFunctions();
}

void WasmBinaryBuilder::readUserSection(size_t payloadLen) {
  auto oldPos = pos;
  Name sectionName = getInlineString();
  if (sectionName.equals(BinaryConsts::UserSections::Name)) {
    readNames(payloadLen - (pos - oldPos));
  } else {
    // an unfamiliar custom section
    wasm.userSections.resize(wasm.userSections.size() + 1);
    auto& section = wasm.userSections.back();
    section.name = sectionName.str;
    auto sectionSize = payloadLen - (pos - oldPos);
    section.data.resize(sectionSize);
    for (size_t i = 0; i < sectionSize; i++) {
      section.data[i] = getInt8();
    }
  }
}

uint8_t WasmBinaryBuilder::getInt8() {
  if (!more()) throwError("unexpected end of input");
  if (debug) std::cerr << "getInt8: " << (int)(uint8_t)input[pos] << " (at " << pos << ")" << std::endl;
  return input[pos++];
}

uint16_t WasmBinaryBuilder::getInt16() {
  if (debug) std::cerr << "<==" << std::endl;
  auto ret = uint16_t(getInt8());
  ret |= uint16_t(getInt8()) << 8;
  if (debug) std::cerr << "getInt16: " << ret << "/0x" << std::hex << ret << std::dec << " ==>" << std::endl;
  return ret;
}

uint32_t WasmBinaryBuilder::getInt32() {
  if (debug) std::cerr << "<==" << std::endl;
  auto ret = uint32_t(getInt16());
  ret |= uint32_t(getInt16()) << 16;
  if (debug) std::cerr << "getInt32: " << ret << "/0x" << std::hex << ret << std::dec <<" ==>" << std::endl;
  return ret;
}

uint64_t WasmBinaryBuilder::getInt64() {
  if (debug) std::cerr << "<==" << std::endl;
  auto ret = uint64_t(getInt32());
  ret |= uint64_t(getInt32()) << 32;
  if (debug) std::cerr << "getInt64: " << ret  << "/0x" << std::hex << ret << std::dec << " ==>" << std::endl;
  return ret;
}

Literal WasmBinaryBuilder::getFloat32Literal() {
  if (debug) std::cerr << "<==" << std::endl;
  auto ret = Literal(getInt32());
  ret = ret.castToF32();
  if (debug) std::cerr << "getFloat32: " << ret << " ==>" << std::endl;
  return ret;
}

Literal WasmBinaryBuilder::getFloat64Literal() {
  if (debug) std::cerr << "<==" << std::endl;
  auto ret = Literal(getInt64());
  ret = ret.castToF64();
  if (debug) std::cerr << "getFloat64: " << ret << " ==>" << std::endl;
  return ret;
}

uint32_t WasmBinaryBuilder::getU32LEB() {
  if (debug) std::cerr << "<==" << std::endl;
  U32LEB ret;
  ret.read([&]() {
      return getInt8();
    });
  if (debug) std::cerr << "getU32LEB: " << ret.value << " ==>" << std::endl;
  return ret.value;
}

uint64_t WasmBinaryBuilder::getU64LEB() {
  if (debug) std::cerr << "<==" << std::endl;
  U64LEB ret;
  ret.read([&]() {
      return getInt8();
    });
  if (debug) std::cerr << "getU64LEB: " << ret.value << " ==>" << std::endl;
  return ret.value;
}

int32_t WasmBinaryBuilder::getS32LEB() {
  if (debug) std::cerr << "<==" << std::endl;
  S32LEB ret;
  ret.read([&]() {
      return (int8_t)getInt8();
    });
  if (debug) std::cerr << "getS32LEB: " << ret.value << " ==>" << std::endl;
  return ret.value;
}

int64_t WasmBinaryBuilder::getS64LEB() {
  if (debug) std::cerr << "<==" << std::endl;
  S64LEB ret;
  ret.read([&]() {
      return (int8_t)getInt8();
    });
  if (debug) std::cerr << "getS64LEB: " << ret.value << " ==>" << std::endl;
  return ret.value;
}

Type WasmBinaryBuilder::getType() {
  int type = getS32LEB();
  switch (type) {
    // None only used for block signatures. TODO: Separate out?
    case BinaryConsts::EncodedType::Empty: return none;
    case BinaryConsts::EncodedType::i32: return i32;
    case BinaryConsts::EncodedType::i64: return i64;
    case BinaryConsts::EncodedType::f32: return f32;
    case BinaryConsts::EncodedType::f64: return f64;
    default: throwError("invalid wasm type: " + std::to_string(type));
  }
  WASM_UNREACHABLE();
}

Type WasmBinaryBuilder::getConcreteType() {
  auto type = getType();
  if (!isConcreteType(type)) {
    throw ParseException("non-concrete type when one expected");
  }
  return type;
}

Name WasmBinaryBuilder::getString() {
  if (debug) std::cerr << "<==" << std::endl;
  size_t offset = getInt32();
  Name ret = cashew::IString((&input[0]) + offset, false);
  if (debug) std::cerr << "getString: " << ret << " ==>" << std::endl;
  return ret;
}

Name WasmBinaryBuilder::getInlineString() {
  if (debug) std::cerr << "<==" << std::endl;
  auto len = getU32LEB();
  std::string str;
  for (size_t i = 0; i < len; i++) {
    auto curr = char(getInt8());
    if (curr == 0) {
      throwError("inline string contains NULL (0). that is technically valid in wasm, but you shouldn't do it, and it's not supported in binaryen");
    }
    str = str + curr;
  }
  if (debug) std::cerr << "getInlineString: " << str << " ==>" << std::endl;
  return Name(str);
}

void WasmBinaryBuilder::verifyInt8(int8_t x) {
  int8_t y = getInt8();
  if (x != y) throwError("surprising value");
}

void WasmBinaryBuilder::verifyInt16(int16_t x) {
  int16_t y = getInt16();
  if (x != y) throwError("surprising value");
}

void WasmBinaryBuilder::verifyInt32(int32_t x) {
  int32_t y = getInt32();
  if (x != y) throwError("surprising value");
}

void WasmBinaryBuilder::verifyInt64(int64_t x) {
  int64_t y = getInt64();
  if (x != y) throwError("surprising value");
}

void WasmBinaryBuilder::ungetInt8() {
  assert(pos > 0);
  if (debug) std::cerr << "ungetInt8 (at " << pos << ")" << std::endl;
  pos--;
}

void WasmBinaryBuilder::readHeader() {
  if (debug) std::cerr << "== readHeader" << std::endl;
  verifyInt32(BinaryConsts::Magic);
  verifyInt32(BinaryConsts::Version);
}

void WasmBinaryBuilder::readStart() {
  if (debug) std::cerr << "== readStart" << std::endl;
  startIndex = getU32LEB();
}

void WasmBinaryBuilder::readMemory() {
  if (debug) std::cerr << "== readMemory" << std::endl;
  auto numMemories = getU32LEB();
  if (!numMemories) return;
  if (numMemories != 1) {
    throwError("Must be exactly 1 memory");
  }
  if (wasm.memory.exists) {
    throwError("Memory cannot be both imported and defined");
  }
  wasm.memory.exists = true;
  getResizableLimits(wasm.memory.initial, wasm.memory.max, wasm.memory.shared, Memory::kUnlimitedSize);
}

void WasmBinaryBuilder::readSignatures() {
  if (debug) std::cerr << "== readSignatures" << std::endl;
  size_t numTypes = getU32LEB();
  if (debug) std::cerr << "num: " << numTypes << std::endl;
  for (size_t i = 0; i < numTypes; i++) {
    if (debug) std::cerr << "read one" << std::endl;
    auto curr = new FunctionType;
    auto form = getS32LEB();
    if (form != BinaryConsts::EncodedType::Func) {
      throwError("bad signature form " + std::to_string(form));
    }
    size_t numParams = getU32LEB();
    if (debug) std::cerr << "num params: " << numParams << std::endl;
    for (size_t j = 0; j < numParams; j++) {
      curr->params.push_back(getConcreteType());
    }
    auto numResults = getU32LEB();
    if (numResults == 0) {
      curr->result = none;
    } else {
      if (numResults != 1) {
        throwError("signature must have 1 result");
      }
      curr->result = getType();
    }
    curr->name = Name::fromInt(wasm.functionTypes.size());
    wasm.addFunctionType(curr);
  }
}

Name WasmBinaryBuilder::getFunctionIndexName(Index i) {
  return wasm.functions[i]->name;
}

void WasmBinaryBuilder::getResizableLimits(Address& initial, Address& max, bool &shared, Address defaultIfNoMax) {
  auto flags = getU32LEB();
  initial = getU32LEB();
  bool hasMax = (flags & BinaryConsts::HasMaximum) != 0;
  bool isShared = (flags & BinaryConsts::IsShared) != 0;
  if (isShared && !hasMax) throwError("shared memory must have max size");
  shared = isShared;
  if (hasMax) max = getU32LEB();
  else max = defaultIfNoMax;
}

void WasmBinaryBuilder::readImports() {
  if (debug) std::cerr << "== readImports" << std::endl;
  size_t num = getU32LEB();
  if (debug) std::cerr << "num: " << num << std::endl;
  Builder builder(wasm);
  for (size_t i = 0; i < num; i++) {
    if (debug) std::cerr << "read one" << std::endl;
    auto module = getInlineString();
    auto base = getInlineString();
    auto kind = (ExternalKind)getU32LEB();
    // We set a unique prefix for the name based on the kind. This ensures no collisions
    // between them, which can't occur here (due to the index i) but could occur later
    // due to the names section.
    switch (kind) {
      case ExternalKind::Function: {
        auto name = Name(std::string("fimport$") + std::to_string(i));
        auto index = getU32LEB();
        if (index >= wasm.functionTypes.size()) {
          throwError("invalid function index " + std::to_string(index) + " / " + std::to_string(wasm.functionTypes.size()));
        }
        auto* functionType = wasm.functionTypes[index].get();
        auto params = functionType->params;
        auto result = functionType->result;
        auto* curr = builder.makeFunction(name, std::move(params), result, {});
        curr->module = module;
        curr->base = base;
        curr->type = functionType->name;
        wasm.addFunction(curr);
        functionImports.push_back(curr);
        break;
      }
      case ExternalKind::Table: {
        wasm.table.module = module;
        wasm.table.base = base;
        wasm.table.name = Name(std::string("timport$") + std::to_string(i));
        auto elementType = getS32LEB();
        WASM_UNUSED(elementType);
        if (elementType != BinaryConsts::EncodedType::AnyFunc) throwError("Imported table type is not AnyFunc");
        wasm.table.exists = true;
        bool is_shared;
        getResizableLimits(wasm.table.initial, wasm.table.max, is_shared, Table::kUnlimitedSize);
        if (is_shared) throwError("Tables may not be shared");
        break;
      }
      case ExternalKind::Memory: {
        wasm.memory.module = module;
        wasm.memory.base = base;
        wasm.memory.name = Name(std::to_string(i));
        wasm.memory.exists = true;
        getResizableLimits(wasm.memory.initial, wasm.memory.max, wasm.memory.shared, Memory::kUnlimitedSize);
        break;
      }
      case ExternalKind::Global: {
        auto name = Name(std::string("gimport$") + std::to_string(i));
        auto type = getConcreteType();
        auto mutable_ = getU32LEB();
        assert(!mutable_); // for now, until mutable globals
        auto* curr = builder.makeGlobal(name, type, nullptr, mutable_ ? Builder::Mutable : Builder::Immutable);
        curr->module = module;
        curr->base = base;
        wasm.addGlobal(curr);
        break;
      }
      default: {
        throwError("bad import kind");
      }
    }
  }
}

Name WasmBinaryBuilder::getNextLabel() {
  requireFunctionContext("getting a label");
  return Name("label$" + std::to_string(nextLabel++));
}

void WasmBinaryBuilder::requireFunctionContext(const char* error) {
  if (!currFunction) {
    throwError(std::string("in a non-function context: ") + error);
  }
}

void WasmBinaryBuilder::readFunctionSignatures() {
  if (debug) std::cerr << "== readFunctionSignatures" << std::endl;
  size_t num = getU32LEB();
  if (debug) std::cerr << "num: " << num << std::endl;
  for (size_t i = 0; i < num; i++) {
    if (debug) std::cerr << "read one" << std::endl;
    auto index = getU32LEB();
    if (index >= wasm.functionTypes.size()) {
      throwError("invalid function type index for function");
    }
    functionTypes.push_back(wasm.functionTypes[index].get());
  }
}

void WasmBinaryBuilder::readFunctions() {
  if (debug) std::cerr << "== readFunctions" << std::endl;
  size_t total = getU32LEB();
  if (total != functionTypes.size()) {
    throwError("invalid function section size, must equal types");
  }
  for (size_t i = 0; i < total; i++) {
    if (debug) std::cerr << "read one at " << pos << std::endl;
    size_t size = getU32LEB();
    if (size == 0) {
      throwError("empty function size");
    }
    endOfFunction = pos + size;

    Function *func = new Function;
    func->name = Name::fromInt(i);
    currFunction = func;

    readNextDebugLocation();

    auto type = functionTypes[i];
    if (debug) std::cerr << "reading " << i << std::endl;
    func->type = type->name;
    func->result = type->result;
    for (size_t j = 0; j < type->params.size(); j++) {
      func->params.emplace_back(type->params[j]);
    }
    size_t numLocalTypes = getU32LEB();
    for (size_t t = 0; t < numLocalTypes; t++) {
      auto num = getU32LEB();
      auto type = getConcreteType();
      if (num > WebLimitations::MaxFunctionLocals) {
        // In general for Web limitations we try to just warn, but not actually
        // enforce the limit ourselves (as we may be looking at wasm not intended
        // to run on the Web). However, too many locals will simply cause us to
        // OOM, so some arbitrary limit makes sense - and if so, why not use
        // the arbitrary Web limit, for consistency.
        throwError("too many locals, wasm VMs would not accept this binary");
      }
      while (num > 0) {
        func->vars.push_back(type);
        num--;
      }
    }
    std::swap(func->prologLocation, debugLocation);
    {
      // process the function body
      if (debug) std::cerr << "processing function: " << i << std::endl;
      nextLabel = 0;
      debugLocation.clear();
      willBeIgnored = false;
      // process body
      assert(breakTargetNames.size() == 0);
      assert(breakStack.empty());
      assert(expressionStack.empty());
      assert(depth == 0);
      func->body = getBlockOrSingleton(func->result);
      assert(depth == 0);
      assert(breakStack.size() == 0);
      assert(breakTargetNames.size() == 0);
      if (!expressionStack.empty()) {
        throwError("stack not empty on function exit");
      }
      if (pos != endOfFunction) {
        throwError("binary offset at function exit not at expected location");
      }
    }
    std::swap(func->epilogLocation, debugLocation);
    currFunction = nullptr;
    debugLocation.clear();
    functions.push_back(func);
  }
  if (debug) std::cerr << " end function bodies" << std::endl;
}

void WasmBinaryBuilder::readExports() {
  if (debug) std::cerr << "== readExports" << std::endl;
  size_t num = getU32LEB();
  if (debug) std::cerr << "num: " << num << std::endl;
  std::set<Name> names;
  for (size_t i = 0; i < num; i++) {
    if (debug) std::cerr << "read one" << std::endl;
    auto curr = new Export;
    curr->name = getInlineString();
    if (names.count(curr->name) > 0) {
      throwError("duplicate export name");
    }
    names.insert(curr->name);
    curr->kind = (ExternalKind)getU32LEB();
    auto index = getU32LEB();
    exportIndexes[curr] = index;
    exportOrder.push_back(curr);
  }
}

static int32_t readBase64VLQ(std::istream& in) {
  uint32_t value = 0;
  uint32_t shift = 0;
  while (1) {
    auto ch = in.get();
    if (ch == EOF)
      throw MapParseException("unexpected EOF in the middle of VLQ");
    if ((ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch < 'g')) {
      // last number digit
      uint32_t digit = ch < 'a' ? ch - 'A' : ch - 'a' + 26;
      value |= digit << shift;
      break;
    }
    if (!(ch >= 'g' && ch <= 'z') && !(ch >= '0' && ch <= '9') &&
        ch != '+' && ch != '/') {
      throw MapParseException("invalid VLQ digit");
    }
    uint32_t digit = ch > '9' ? ch - 'g' : (ch >= '0' ? ch - '0' + 20 : (ch == '+' ? 30 : 31));
    value |= digit << shift;
    shift += 5;
  }
  return value & 1 ? -int32_t(value >> 1) : int32_t(value >> 1);
}

void WasmBinaryBuilder::readSourceMapHeader() {
  if (!sourceMap) return;

  auto skipWhitespace = [&]() {
    while (sourceMap->peek() == ' ' || sourceMap->peek() == '\n')
      sourceMap->get();
  };

  auto maybeReadChar = [&](char expected) {
    if (sourceMap->peek() != expected) return false;
    sourceMap->get();
    return true;
  };

  auto mustReadChar = [&](char expected) {
    char c = sourceMap->get();
    if (c != expected) {
      throw MapParseException(std::string("Unexpected char: expected '") +
                              expected + "' got '" + c + "'");
    }
  };

  auto findField = [&](const char* name) {
    bool matching = false;
    size_t len = strlen(name);
    size_t pos;
    while (1) {
      int ch = sourceMap->get();
      if (ch == EOF) return false;
      if (ch == '\"') {
        if (matching) {
          // we matched a terminating quote.
          if (pos == len)
            break;
          matching = false;
        } else {
          matching = true;
          pos = 0;
        }
      } else if (matching && name[pos] == ch) {
        ++pos;
      } else if (matching) {
        matching = false;
      }
    }
    skipWhitespace();
    mustReadChar(':');
    skipWhitespace();
    return true;
  };

  auto readString = [&](std::string& str) {
    std::vector<char> vec;
    skipWhitespace();
    mustReadChar('\"');
    if (!maybeReadChar('\"')) {
      while (1) {
        int ch = sourceMap->get();
        if (ch == EOF) {
          throw MapParseException("unexpected EOF in the middle of string");
        }
        if (ch == '\"') break;
        vec.push_back(ch);
      }
    }
    skipWhitespace();
    str = std::string(vec.begin(), vec.end());
  };

  if (!findField("sources")) {
    throw MapParseException("cannot find the 'sources' field in map");
  }

  skipWhitespace();
  mustReadChar('[');
  if (!maybeReadChar(']')) {
    do {
      std::string file;
      readString(file);
      Index index = wasm.debugInfoFileNames.size();
      wasm.debugInfoFileNames.push_back(file);
      debugInfoFileIndices[file] = index;
    } while (maybeReadChar(','));
    mustReadChar(']');
  }

  if (!findField("mappings")) {
    throw MapParseException("cannot find the 'mappings' field in map");
  }

  mustReadChar('\"');
  if (maybeReadChar('\"')) { // empty mappings
    nextDebugLocation.first = 0;
    return;
  }
  // read first debug location
  uint32_t position = readBase64VLQ(*sourceMap);
  uint32_t fileIndex = readBase64VLQ(*sourceMap);
  uint32_t lineNumber = readBase64VLQ(*sourceMap) + 1; // adjust zero-based line number
  uint32_t columnNumber = readBase64VLQ(*sourceMap);
  nextDebugLocation = { position, { fileIndex, lineNumber, columnNumber } };
}

void WasmBinaryBuilder::readNextDebugLocation() {
  if (!sourceMap) return;

  while (nextDebugLocation.first && nextDebugLocation.first <= pos) {
    if (nextDebugLocation.first < pos) {
      std::cerr << "skipping debug location info for 0x";
      std::cerr << std::hex << nextDebugLocation.first << std::dec << std::endl;
    }
    debugLocation.clear();
    // use debugLocation only for function expressions
    if (currFunction) {
      debugLocation.insert(nextDebugLocation.second);
    }

    char ch;
    *sourceMap >> ch;
    if (ch == '\"') { // end of records
      nextDebugLocation.first = 0;
      break;
    }
    if (ch != ',') {
      throw MapParseException("Unexpected delimiter");
    }

    int32_t positionDelta = readBase64VLQ(*sourceMap);
    uint32_t position = nextDebugLocation.first + positionDelta;
    int32_t fileIndexDelta = readBase64VLQ(*sourceMap);
    uint32_t fileIndex = nextDebugLocation.second.fileIndex + fileIndexDelta;
    int32_t lineNumberDelta = readBase64VLQ(*sourceMap);
    uint32_t lineNumber = nextDebugLocation.second.lineNumber + lineNumberDelta;
    int32_t columnNumberDelta = readBase64VLQ(*sourceMap);
    uint32_t columnNumber = nextDebugLocation.second.columnNumber + columnNumberDelta;

    nextDebugLocation = { position, { fileIndex, lineNumber, columnNumber } };
  }
}

Expression* WasmBinaryBuilder::readExpression() {
  assert(depth == 0);
  processExpressions();
  if (expressionStack.size() != 1) {
    throwError("expected to read a single expression");
  }
  auto* ret = popExpression();
  assert(depth == 0);
  return ret;
}

void WasmBinaryBuilder::readGlobals() {
  if (debug) std::cerr << "== readGlobals" << std::endl;
  size_t num = getU32LEB();
  if (debug) std::cerr << "num: " << num << std::endl;
  for (size_t i = 0; i < num; i++) {
    if (debug) std::cerr << "read one" << std::endl;
    auto type = getConcreteType();
    auto mutable_ = getU32LEB();
    if (mutable_ & ~1) throwError("Global mutability must be 0 or 1");
    auto* init = readExpression();
    wasm.addGlobal(Builder::makeGlobal(
      "global$" + std::to_string(i),
      type,
      init,
      mutable_ ? Builder::Mutable : Builder::Immutable
    ));
  }
}

void WasmBinaryBuilder::processExpressions() {
  if (debug) std::cerr << "== processExpressions" << std::endl;
  unreachableInTheWasmSense = false;
  while (1) {
    Expression* curr;
    auto ret = readExpression(curr);
    if (!curr) {
      lastSeparator = ret;
      if (debug) std::cerr << "== processExpressions finished" << std::endl;
      return;
    }
    expressionStack.push_back(curr);
    if (curr->type == unreachable) {
      // once we see something unreachable, we don't want to add anything else
      // to the stack, as it could be stacky code that is non-representable in
      // our AST. but we do need to skip it
      // if there is nothing else here, just stop. otherwise, go into unreachable
      // mode. peek to see what to do
      if (pos == endOfFunction) {
        throwError("Reached function end without seeing End opcode");
      }
      if (!more()) throwError("unexpected end of input");
      auto peek = input[pos];
      if (peek == BinaryConsts::End || peek == BinaryConsts::Else) {
        if (debug) std::cerr << "== processExpressions finished with unreachable" << std::endl;
        readNextDebugLocation();
        lastSeparator = BinaryConsts::ASTNodes(peek);
        pos++;
        return;
      } else {
        skipUnreachableCode();
        return;
      }
    }
  }
}

void WasmBinaryBuilder::skipUnreachableCode() {
  if (debug) std::cerr << "== skipUnreachableCode" << std::endl;
  // preserve the stack, and restore it. it contains the instruction that made us
  // unreachable, and we can ignore anything after it. things after it may pop,
  // we want to undo that
  auto savedStack = expressionStack;
  // note we are entering unreachable code, and note what the state as before so
  // we can restore it
  auto before = willBeIgnored;
  willBeIgnored = true;
  // clear the stack. nothing should be popped from there anyhow, just stuff
  // can be pushed and then popped. Popping past the top of the stack will
  // result in uneachables being returned
  expressionStack.clear();
  while (1) {
    // set the unreachableInTheWasmSense flag each time, as sub-blocks may set and unset it
    unreachableInTheWasmSense = true;
    Expression* curr;
    auto ret = readExpression(curr);
    if (!curr) {
      if (debug) std::cerr << "== skipUnreachableCode finished" << std::endl;
      lastSeparator = ret;
      unreachableInTheWasmSense = false;
      willBeIgnored = before;
      expressionStack = savedStack;
      return;
    }
    expressionStack.push_back(curr);
  }
}

Expression* WasmBinaryBuilder::popExpression() {
  if (debug) std::cerr << "== popExpression" << std::endl;
  if (expressionStack.empty()) {
    if (unreachableInTheWasmSense) {
      // in unreachable code, trying to pop past the polymorphic stack
      // area results in receiving unreachables
      if (debug) std::cerr << "== popping unreachable from polymorphic stack" << std::endl;
      return allocator.alloc<Unreachable>();
    }
    throwError("attempted pop from empty stack / beyond block start boundary at " + std::to_string(pos));
  }
  // the stack is not empty, and we would not be going out of the current block
  auto ret = expressionStack.back();
  expressionStack.pop_back();
  return ret;
}

Expression* WasmBinaryBuilder::popNonVoidExpression() {
  auto* ret = popExpression();
  if (ret->type != none) return ret;
  // we found a void, so this is stacky code that we must handle carefully
  Builder builder(wasm);
  // add elements until we find a non-void
  std::vector<Expression*> expressions;
  expressions.push_back(ret);
  while (1) {
    auto* curr = popExpression();
    expressions.push_back(curr);
    if (curr->type != none) break;
  }
  auto* block = builder.makeBlock();
  while (!expressions.empty()) {
    block->list.push_back(expressions.back());
    expressions.pop_back();
  }
  requireFunctionContext("popping void where we need a new local");
  auto type = block->list[0]->type;
  if (isConcreteType(type)) {
    auto local = builder.addVar(currFunction, type);
    block->list[0] = builder.makeSetLocal(local, block->list[0]);
    block->list.push_back(builder.makeGetLocal(local, type));
  } else {
    assert(type == unreachable);
    // nothing to do here - unreachable anyhow
  }
  block->finalize();
  return block;
}

Name WasmBinaryBuilder::getGlobalName(Index index) {
  if (!mappedGlobals.size()) {
    // Create name => index mapping.
    auto add = [&](Global* curr) {
      auto index = mappedGlobals.size();
      mappedGlobals[index] = curr->name;
    };
    ModuleUtils::iterImportedGlobals(wasm, add);
    ModuleUtils::iterDefinedGlobals(wasm, add);
  }
  if (index == Index(-1)) return Name("null"); // just a force-rebuild
  if (mappedGlobals.count(index) == 0) {
    throwError("bad global index");
  }
  return mappedGlobals[index];
}

void WasmBinaryBuilder::processFunctions() {
  for (auto* func : functions) {
    wasm.addFunction(func);
  }

  // now that we have names for each function, apply things

  if (startIndex != static_cast<Index>(-1)) {
    wasm.start = getFunctionIndexName(startIndex);
  }

  for (auto* curr : exportOrder) {
    auto index = exportIndexes[curr];
    switch (curr->kind) {
      case ExternalKind::Function: {
        curr->value = getFunctionIndexName(index);
        break;
      }
      case ExternalKind::Table: curr->value = Name::fromInt(0); break;
      case ExternalKind::Memory: curr->value = Name::fromInt(0); break;
      case ExternalKind::Global: curr->value = getGlobalName(index); break;
      default: throwError("bad export kind");
    }
    wasm.addExport(curr);
  }

  for (auto& iter : functionCalls) {
    size_t index = iter.first;
    auto& calls = iter.second;
    for (auto* call : calls) {
      call->target = getFunctionIndexName(index);
    }
  }

  for (auto& pair : functionTable) {
    auto i = pair.first;
    auto& indexes = pair.second;
    for (auto j : indexes) {
      wasm.table.segments[i].data.push_back(getFunctionIndexName(j));
    }
  }

  // Everything now has its proper name.

  wasm.updateMaps();
}

void WasmBinaryBuilder::readDataSegments() {
  if (debug) std::cerr << "== readDataSegments" << std::endl;
  auto num = getU32LEB();
  for (size_t i = 0; i < num; i++) {
    auto memoryIndex = getU32LEB();
    WASM_UNUSED(memoryIndex);
    if (memoryIndex != 0) {
      throwError("bad memory index, must be 0");
    }
    Memory::Segment curr;
    auto offset = readExpression();
    auto size = getU32LEB();
    std::vector<char> buffer;
    buffer.resize(size);
    for (size_t j = 0; j < size; j++) {
      buffer[j] = char(getInt8());
    }
    wasm.memory.segments.emplace_back(offset, (const char*)&buffer[0], size);
  }
}

void WasmBinaryBuilder::readFunctionTableDeclaration() {
  if (debug) std::cerr << "== readFunctionTableDeclaration" << std::endl;
  auto numTables = getU32LEB();
  if (numTables != 1) throwError("Only 1 table definition allowed in MVP");
  if (wasm.table.exists) throwError("Table cannot be both imported and defined");
  wasm.table.exists = true;
  auto elemType = getS32LEB();
  if (elemType != BinaryConsts::EncodedType::AnyFunc) throwError("ElementType must be AnyFunc in MVP");
  bool is_shared;
  getResizableLimits(wasm.table.initial, wasm.table.max, is_shared, Table::kUnlimitedSize);
  if (is_shared) throwError("Tables may not be shared");
}

void WasmBinaryBuilder::readTableElements() {
  if (debug) std::cerr << "== readTableElements" << std::endl;
  auto numSegments = getU32LEB();
  if (numSegments >= Table::kMaxSize) throwError("Too many segments");
  for (size_t i = 0; i < numSegments; i++) {
    auto tableIndex = getU32LEB();
    if (tableIndex != 0) throwError("Table elements must refer to table 0 in MVP");
    wasm.table.segments.emplace_back(readExpression());

    auto& indexSegment = functionTable[i];
    auto size = getU32LEB();
    for (Index j = 0; j < size; j++) {
      indexSegment.push_back(getU32LEB());
    }
  }
}

static bool isIdChar(char ch) {
  return (ch >= '0' && ch <= '9') || (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z') ||
    ch == '!' || ch == '#' || ch == '$' || ch == '%' || ch == '&' || ch == '\'' || ch == '*' ||
    ch == '+' || ch == '-' || ch == '.' || ch == '/' || ch == ':' || ch == '<' || ch == '=' ||
    ch == '>' || ch == '?' || ch == '@' || ch == '^' || ch == '_' || ch == '`' || ch == '|' ||
    ch == '~';
}

static char formatNibble(int nibble) {
  return nibble < 10 ? '0' + nibble : 'a' - 10 + nibble;
}

static void escapeName(Name &name) {
  bool allIdChars = true;
  for (const char *p = name.str; allIdChars && *p; p++) {
    allIdChars = isIdChar(*p);
  }
  if (allIdChars) {
    return;
  }
  // encode name, if at least one non-idchar (per WebAssembly spec) was found
  std::string escaped;
  for (const char *p = name.str; *p; p++) {
    char ch = *p;
    if (isIdChar(ch)) {
      escaped.push_back(ch);
      continue;
    }
    // replace non-idchar with `\xx` escape
    escaped.push_back('\\');
    escaped.push_back(formatNibble(ch >> 4));
    escaped.push_back(formatNibble(ch & 15));
  }
  name = escaped;
}

void WasmBinaryBuilder::readNames(size_t payloadLen) {
  if (debug) std::cerr << "== readNames" << std::endl;
  auto sectionPos = pos;
  while (pos < sectionPos + payloadLen) {
    auto nameType = getU32LEB();
    auto subsectionSize = getU32LEB();
    auto subsectionPos = pos;
    if (nameType != BinaryConsts::UserSections::Subsection::NameFunction) {
      // TODO: locals
      std::cerr << "unknown name subsection at " << pos << std::endl;
      pos = subsectionPos + subsectionSize;
      continue;
    }
    auto num = getU32LEB();
    std::set<Name> usedNames;
    for (size_t i = 0; i < num; i++) {
      auto index = getU32LEB();
      auto rawName = getInlineString();
      escapeName(rawName);
      auto name = rawName;
      // De-duplicate names by appending .1, .2, etc.
      for (int i = 1; !usedNames.insert(name).second; ++i) {
        name = rawName.str + std::string(".") + std::to_string(i);
      }
      // note: we silently ignore errors here, as name section errors
      //       are not fatal. should we warn?
      auto numFunctionImports = functionImports.size();
      if (index < numFunctionImports) {
        functionImports[index]->name = name;
      } else if (index - numFunctionImports < functions.size()) {
        functions[index - numFunctionImports]->name = name;
      } else {
        throwError("index out of bounds: " + std::string(name.str));
      }
    }
    if (pos != subsectionPos + subsectionSize) {
      throwError("bad names subsection position change");
    }
  }
  if (pos != sectionPos + payloadLen) {
    throwError("bad names section position change");
  }
}

BinaryConsts::ASTNodes WasmBinaryBuilder::readExpression(Expression*& curr) {
  if (pos == endOfFunction) {
    throwError("Reached function end without seeing End opcode");
  }
  if (debug) std::cerr << "zz recurse into " << ++depth << " at " << pos << std::endl;
  readNextDebugLocation();
  std::set<Function::DebugLocation> currDebugLocation;
  if (debugLocation.size()) {
    currDebugLocation.insert(*debugLocation.begin());
  }
  uint8_t code = getInt8();
  if (debug) std::cerr << "readExpression seeing " << (int)code << std::endl;
  switch (code) {
    case BinaryConsts::Block:        visitBlock((curr = allocator.alloc<Block>())->cast<Block>()); break;
    case BinaryConsts::If:           visitIf((curr = allocator.alloc<If>())->cast<If>()); break;
    case BinaryConsts::Loop:         visitLoop((curr = allocator.alloc<Loop>())->cast<Loop>()); break;
    case BinaryConsts::Br:
    case BinaryConsts::BrIf:         visitBreak((curr = allocator.alloc<Break>())->cast<Break>(), code); break; // code distinguishes br from br_if
    case BinaryConsts::TableSwitch:  visitSwitch((curr = allocator.alloc<Switch>())->cast<Switch>()); break;
    case BinaryConsts::CallFunction: visitCall((curr = allocator.alloc<Call>())->cast<Call>()); break;
    case BinaryConsts::CallIndirect: visitCallIndirect((curr = allocator.alloc<CallIndirect>())->cast<CallIndirect>()); break;
    case BinaryConsts::GetLocal:     visitGetLocal((curr = allocator.alloc<GetLocal>())->cast<GetLocal>()); break;
    case BinaryConsts::TeeLocal:
    case BinaryConsts::SetLocal:     visitSetLocal((curr = allocator.alloc<SetLocal>())->cast<SetLocal>(), code); break;
    case BinaryConsts::GetGlobal:    visitGetGlobal((curr = allocator.alloc<GetGlobal>())->cast<GetGlobal>()); break;
    case BinaryConsts::SetGlobal:    visitSetGlobal((curr = allocator.alloc<SetGlobal>())->cast<SetGlobal>()); break;
    case BinaryConsts::Select:       visitSelect((curr = allocator.alloc<Select>())->cast<Select>()); break;
    case BinaryConsts::Return:       visitReturn((curr = allocator.alloc<Return>())->cast<Return>()); break;
    case BinaryConsts::Nop:          visitNop((curr = allocator.alloc<Nop>())->cast<Nop>()); break;
    case BinaryConsts::Unreachable:  visitUnreachable((curr = allocator.alloc<Unreachable>())->cast<Unreachable>()); break;
    case BinaryConsts::Drop:         visitDrop((curr = allocator.alloc<Drop>())->cast<Drop>()); break;
    case BinaryConsts::End:
    case BinaryConsts::Else:         curr = nullptr; break;
    case BinaryConsts::AtomicPrefix: {
      code = getInt8();
      if (maybeVisitLoad(curr, code, /*isAtomic=*/true)) break;
      if (maybeVisitStore(curr, code, /*isAtomic=*/true)) break;
      if (maybeVisitAtomicRMW(curr, code)) break;
      if (maybeVisitAtomicCmpxchg(curr, code)) break;
      if (maybeVisitAtomicWait(curr, code)) break;
      if (maybeVisitAtomicWake(curr, code)) break;
      throwError("invalid code after atomic prefix: " + std::to_string(code));
      break;
    }
    default: {
      // otherwise, the code is a subcode TODO: optimize
      if (maybeVisitBinary(curr, code)) break;
      if (maybeVisitUnary(curr, code)) break;
      if (maybeVisitConst(curr, code)) break;
      if (maybeVisitLoad(curr, code, /*isAtomic=*/false)) break;
      if (maybeVisitStore(curr, code, /*isAtomic=*/false)) break;
      if (maybeVisitHost(curr, code)) break;
      throwError("bad node code " + std::to_string(code));
      break;
    }
  }
  if (curr && currDebugLocation.size()) {
    currFunction->debugLocations[curr] = *currDebugLocation.begin();
  }
  if (debug) std::cerr << "zz recurse from " << depth-- << " at " << pos << std::endl;
  return BinaryConsts::ASTNodes(code);
}

void WasmBinaryBuilder::pushBlockElements(Block* curr, size_t start, size_t end) {
  assert(start <= expressionStack.size());
  assert(start <= end);
  assert(end <= expressionStack.size());
  // the first dropped element may be consumed by code later - it was on the stack first,
  // and is the only thing left on the stack. there must be just one thing on the stack
  // since we are at the end of a block context. note that we may need to drop more than
  // one thing, since a bunch of concrete values may be all "consumed" by an unreachable
  // (in which case, the first value can't be consumed anyhow, so it doesn't matter)
  const Index NONE = -1;
  Index consumable = NONE;
  for (size_t i = start; i < end; i++) {
    auto* item = expressionStack[i];
    curr->list.push_back(item);
    if (i < end - 1) {
      // stacky&unreachable code may introduce elements that need to be dropped in non-final positions
      if (isConcreteType(item->type)) {
        curr->list.back() = Builder(wasm).makeDrop(item);
        if (consumable == NONE) {
          // this is the first, and hence consumable value. note the location
          consumable = curr->list.size() - 1;
        }
      }
    }
  }
  expressionStack.resize(start);
  // if we have a consumable item and need it, use it
  if (consumable != NONE && curr->list.back()->type == none) {
    requireFunctionContext("need an extra var in a non-function context, invalid wasm");
    Builder builder(wasm);
    auto* item = curr->list[consumable]->cast<Drop>()->value;
    auto temp = builder.addVar(currFunction, item->type);
    curr->list[consumable] = builder.makeSetLocal(temp, item);
    curr->list.push_back(builder.makeGetLocal(temp, item->type));
  }
}

void WasmBinaryBuilder::visitBlock(Block* curr) {
  if (debug) std::cerr << "zz node: Block" << std::endl;
  // special-case Block and de-recurse nested blocks in their first position, as that is
  // a common pattern that can be very highly nested.
  std::vector<Block*> stack;
  while (1) {
    curr->type = getType();
    curr->name = getNextLabel();
    breakStack.push_back({curr->name, curr->type != none});
    stack.push_back(curr);
    auto peek = input[pos];
    if (peek == BinaryConsts::Block) {
      // a recursion
      readNextDebugLocation();
      curr = allocator.alloc<Block>();
      pos++;
      if (debugLocation.size()) {
        currFunction->debugLocations[curr] = *debugLocation.begin();
      }
      continue;
    } else {
      // end of recursion
      break;
    }
  }
  Block* last = nullptr;
  while (stack.size() > 0) {
    curr = stack.back();
    stack.pop_back();
    size_t start = expressionStack.size(); // everything after this, that is left when we see the marker, is ours
    if (last) {
      // the previous block is our first-position element
      expressionStack.push_back(last);
    }
    last = curr;
    processExpressions();
    size_t end = expressionStack.size();
    if (end < start) {
      throwError("block cannot pop from outside");
    }
    pushBlockElements(curr, start, end);
    curr->finalize(curr->type, breakTargetNames.find(curr->name) != breakTargetNames.end() /* hasBreak */);
    breakStack.pop_back();
    breakTargetNames.erase(curr->name);
  }
}

Expression* WasmBinaryBuilder::getBlockOrSingleton(Type type) {
  Name label = getNextLabel();
  breakStack.push_back({label, type != none && type != unreachable});
  auto start = expressionStack.size();
  processExpressions();
  size_t end = expressionStack.size();
  if (end < start) {
    throwError("block cannot pop from outside");
  }
  breakStack.pop_back();
  auto* block = allocator.alloc<Block>();
  pushBlockElements(block, start, end);
  block->name = label;
  block->finalize(type);
  // maybe we don't need a block here?
  if (breakTargetNames.find(block->name) == breakTargetNames.end()) {
    block->name = Name();
    if (block->list.size() == 1) {
      return block->list[0];
    }
  }
  breakTargetNames.erase(block->name);
  return block;
}

void WasmBinaryBuilder::visitIf(If* curr) {
  if (debug) std::cerr << "zz node: If" << std::endl;
  curr->type = getType();
  curr->condition = popNonVoidExpression();
  curr->ifTrue = getBlockOrSingleton(curr->type);
  if (lastSeparator == BinaryConsts::Else) {
    curr->ifFalse = getBlockOrSingleton(curr->type);
  }
  curr->finalize(curr->type);
  if (lastSeparator != BinaryConsts::End) {
    throwError("if should end with End");
  }
}

void WasmBinaryBuilder::visitLoop(Loop* curr) {
  if (debug) std::cerr << "zz node: Loop" << std::endl;
  curr->type = getType();
  curr->name = getNextLabel();
  breakStack.push_back({curr->name, 0});
  // find the expressions in the block, and create the body
  // a loop may have a list of instructions in wasm, much like
  // a block, but it only has a label at the top of the loop,
  // so even if we need a block (if there is more than 1
  // expression) we never need a label on the block.
  auto start = expressionStack.size();
  processExpressions();
  size_t end = expressionStack.size();
  if (end - start == 1) {
    curr->body = popExpression();
  } else {
    if (start > end) {
      throwError("block cannot pop from outside");
    }
    auto* block = allocator.alloc<Block>();
    pushBlockElements(block, start, end);
    block->finalize(curr->type);
    curr->body = block;
  }
  breakStack.pop_back();
  breakTargetNames.erase(curr->name);
  curr->finalize(curr->type);
}

WasmBinaryBuilder::BreakTarget WasmBinaryBuilder::getBreakTarget(int32_t offset) {
  if (debug) std::cerr << "getBreakTarget " << offset << std::endl;
  if (breakStack.size() < 1 + size_t(offset)) {
    throwError("bad breakindex (low)");
  }
  size_t index = breakStack.size() - 1 - offset;
  if (index >= breakStack.size()) {
    throwError("bad breakindex (high)");
  }
  if (debug) std::cerr << "breaktarget "<< breakStack[index].name << " arity " << breakStack[index].arity <<  std::endl;
  auto& ret = breakStack[index];
  // if the break is in literally unreachable code, then we will not emit it anyhow,
  // so do not note that the target has breaks to it
  if (!willBeIgnored) {
    breakTargetNames.insert(ret.name);
  }
  return ret;
}

void WasmBinaryBuilder::visitBreak(Break *curr, uint8_t code) {
  if (debug) std::cerr << "zz node: Break, code "<< int32_t(code) << std::endl;
  BreakTarget target = getBreakTarget(getU32LEB());
  curr->name = target.name;
  if (code == BinaryConsts::BrIf) curr->condition = popNonVoidExpression();
  if (target.arity) curr->value = popNonVoidExpression();
  curr->finalize();
}

void WasmBinaryBuilder::visitSwitch(Switch* curr) {
  if (debug) std::cerr << "zz node: Switch" << std::endl;
  curr->condition = popNonVoidExpression();
  auto numTargets = getU32LEB();
  if (debug) std::cerr << "targets: "<< numTargets<<std::endl;
  for (size_t i = 0; i < numTargets; i++) {
    curr->targets.push_back(getBreakTarget(getU32LEB()).name);
  }
  auto defaultTarget = getBreakTarget(getU32LEB());
  curr->default_ = defaultTarget.name;
  if (debug) std::cerr << "default: "<< curr->default_<<std::endl;
  if (defaultTarget.arity) curr->value = popNonVoidExpression();
  curr->finalize();
}

void WasmBinaryBuilder::visitCall(Call* curr) {
  if (debug) std::cerr << "zz node: Call" << std::endl;
  auto index = getU32LEB();
  FunctionType* type;
  if (index < functionImports.size()) {
    auto* import = functionImports[index];
    type = wasm.getFunctionType(import->type);
  } else {
    auto adjustedIndex = index - functionImports.size();
    type = functionTypes[adjustedIndex];
  }
  assert(type);
  auto num = type->params.size();
  curr->operands.resize(num);
  for (size_t i = 0; i < num; i++) {
    curr->operands[num - i - 1] = popNonVoidExpression();
  }
  curr->type = type->result;
  functionCalls[index].push_back(curr); // we don't know function names yet
  curr->finalize();
}

void WasmBinaryBuilder::visitCallIndirect(CallIndirect* curr) {
  if (debug) std::cerr << "zz node: CallIndirect" << std::endl;
  auto index = getU32LEB();
  if (index >= wasm.functionTypes.size()) {
    throwError("bad call_indirect function index");
  }
  auto* fullType = wasm.functionTypes[index].get();
  auto reserved = getU32LEB();
  if (reserved != 0) throwError("Invalid flags field in call_indirect");
  curr->fullType = fullType->name;
  auto num = fullType->params.size();
  curr->operands.resize(num);
  curr->target = popNonVoidExpression();
  for (size_t i = 0; i < num; i++) {
    curr->operands[num - i - 1] = popNonVoidExpression();
  }
  curr->type = fullType->result;
  curr->finalize();
}

void WasmBinaryBuilder::visitGetLocal(GetLocal* curr) {
  if (debug) std::cerr << "zz node: GetLocal " << pos << std::endl;
  requireFunctionContext("get_local");
  curr->index = getU32LEB();
  if (curr->index >= currFunction->getNumLocals()) {
    throwError("bad get_local index");
  }
  curr->type = currFunction->getLocalType(curr->index);
  curr->finalize();
}

void WasmBinaryBuilder::visitSetLocal(SetLocal *curr, uint8_t code) {
  if (debug) std::cerr << "zz node: Set|TeeLocal" << std::endl;
  requireFunctionContext("set_local outside of function");
  curr->index = getU32LEB();
  if (curr->index >= currFunction->getNumLocals()) {
    throwError("bad set_local index");
  }
  curr->value = popNonVoidExpression();
  curr->type = curr->value->type;
  curr->setTee(code == BinaryConsts::TeeLocal);
  curr->finalize();
}

void WasmBinaryBuilder::visitGetGlobal(GetGlobal* curr) {
  if (debug) std::cerr << "zz node: GetGlobal " << pos << std::endl;
  auto index = getU32LEB();
  curr->name = getGlobalName(index);
  curr->type = wasm.getGlobal(curr->name)->type;
}

void WasmBinaryBuilder::visitSetGlobal(SetGlobal* curr) {
  if (debug) std::cerr << "zz node: SetGlobal" << std::endl;
  auto index = getU32LEB();
  curr->name = getGlobalName(index);
  curr->value = popNonVoidExpression();
  curr->finalize();
}

void WasmBinaryBuilder::readMemoryAccess(Address& alignment, Address& offset) {
  auto rawAlignment = getU32LEB();
  if (rawAlignment > 4) throwError("Alignment must be of a reasonable size");
  alignment = Pow2(rawAlignment);
  offset = getU32LEB();
}

bool WasmBinaryBuilder::maybeVisitLoad(Expression*& out, uint8_t code, bool isAtomic) {
  Load* curr;
  if (!isAtomic) {
    switch (code) {
      case BinaryConsts::I32LoadMem8S:  curr = allocator.alloc<Load>(); curr->bytes = 1; curr->type = i32; curr->signed_ = true; break;
      case BinaryConsts::I32LoadMem8U:  curr = allocator.alloc<Load>(); curr->bytes = 1; curr->type = i32; curr->signed_ = false; break;
      case BinaryConsts::I32LoadMem16S: curr = allocator.alloc<Load>(); curr->bytes = 2; curr->type = i32; curr->signed_ = true; break;
      case BinaryConsts::I32LoadMem16U: curr = allocator.alloc<Load>(); curr->bytes = 2; curr->type = i32; curr->signed_ = false; break;
      case BinaryConsts::I32LoadMem:    curr = allocator.alloc<Load>(); curr->bytes = 4; curr->type = i32; break;
      case BinaryConsts::I64LoadMem8S:  curr = allocator.alloc<Load>(); curr->bytes = 1; curr->type = i64; curr->signed_ = true; break;
      case BinaryConsts::I64LoadMem8U:  curr = allocator.alloc<Load>(); curr->bytes = 1; curr->type = i64; curr->signed_ = false; break;
      case BinaryConsts::I64LoadMem16S: curr = allocator.alloc<Load>(); curr->bytes = 2; curr->type = i64; curr->signed_ = true; break;
      case BinaryConsts::I64LoadMem16U: curr = allocator.alloc<Load>(); curr->bytes = 2; curr->type = i64; curr->signed_ = false; break;
      case BinaryConsts::I64LoadMem32S: curr = allocator.alloc<Load>(); curr->bytes = 4; curr->type = i64; curr->signed_ = true; break;
      case BinaryConsts::I64LoadMem32U: curr = allocator.alloc<Load>(); curr->bytes = 4; curr->type = i64; curr->signed_ = false; break;
      case BinaryConsts::I64LoadMem:    curr = allocator.alloc<Load>(); curr->bytes = 8; curr->type = i64; break;
      case BinaryConsts::F32LoadMem:    curr = allocator.alloc<Load>(); curr->bytes = 4; curr->type = f32; break;
      case BinaryConsts::F64LoadMem:    curr = allocator.alloc<Load>(); curr->bytes = 8; curr->type = f64; break;
      default: return false;
    }
    if (debug) std::cerr << "zz node: Load" << std::endl;
  } else {
    switch (code) {
      case BinaryConsts::I32AtomicLoad8U:  curr = allocator.alloc<Load>(); curr->bytes = 1; curr->type = i32; break;
      case BinaryConsts::I32AtomicLoad16U: curr = allocator.alloc<Load>(); curr->bytes = 2; curr->type = i32; break;
      case BinaryConsts::I32AtomicLoad:    curr = allocator.alloc<Load>(); curr->bytes = 4; curr->type = i32; break;
      case BinaryConsts::I64AtomicLoad8U:  curr = allocator.alloc<Load>(); curr->bytes = 1; curr->type = i64; break;
      case BinaryConsts::I64AtomicLoad16U: curr = allocator.alloc<Load>(); curr->bytes = 2; curr->type = i64; break;
      case BinaryConsts::I64AtomicLoad32U: curr = allocator.alloc<Load>(); curr->bytes = 4; curr->type = i64; break;
      case BinaryConsts::I64AtomicLoad:    curr = allocator.alloc<Load>(); curr->bytes = 8; curr->type = i64; break;
      default: return false;
    }
    curr->signed_ = false;
    if (debug) std::cerr << "zz node: AtomicLoad" << std::endl;
  }

  curr->isAtomic = isAtomic;
  readMemoryAccess(curr->align, curr->offset);
  curr->ptr = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitStore(Expression*& out, uint8_t code, bool isAtomic) {
  Store* curr;
  if (!isAtomic) {
    switch (code) {
      case BinaryConsts::I32StoreMem8:  curr = allocator.alloc<Store>(); curr->bytes = 1; curr->valueType = i32; break;
      case BinaryConsts::I32StoreMem16: curr = allocator.alloc<Store>(); curr->bytes = 2; curr->valueType = i32; break;
      case BinaryConsts::I32StoreMem:   curr = allocator.alloc<Store>(); curr->bytes = 4; curr->valueType = i32; break;
      case BinaryConsts::I64StoreMem8:  curr = allocator.alloc<Store>(); curr->bytes = 1; curr->valueType = i64; break;
      case BinaryConsts::I64StoreMem16: curr = allocator.alloc<Store>(); curr->bytes = 2; curr->valueType = i64; break;
      case BinaryConsts::I64StoreMem32: curr = allocator.alloc<Store>(); curr->bytes = 4; curr->valueType = i64; break;
      case BinaryConsts::I64StoreMem:   curr = allocator.alloc<Store>(); curr->bytes = 8; curr->valueType = i64; break;
      case BinaryConsts::F32StoreMem:   curr = allocator.alloc<Store>(); curr->bytes = 4; curr->valueType = f32; break;
      case BinaryConsts::F64StoreMem:   curr = allocator.alloc<Store>(); curr->bytes = 8; curr->valueType = f64; break;
      default: return false;
    }
  } else {
    switch (code) {
      case BinaryConsts::I32AtomicStore8:  curr = allocator.alloc<Store>(); curr->bytes = 1; curr->valueType = i32; break;
      case BinaryConsts::I32AtomicStore16: curr = allocator.alloc<Store>(); curr->bytes = 2; curr->valueType = i32; break;
      case BinaryConsts::I32AtomicStore:   curr = allocator.alloc<Store>(); curr->bytes = 4; curr->valueType = i32; break;
      case BinaryConsts::I64AtomicStore8:  curr = allocator.alloc<Store>(); curr->bytes = 1; curr->valueType = i64; break;
      case BinaryConsts::I64AtomicStore16: curr = allocator.alloc<Store>(); curr->bytes = 2; curr->valueType = i64; break;
      case BinaryConsts::I64AtomicStore32: curr = allocator.alloc<Store>(); curr->bytes = 4; curr->valueType = i64; break;
      case BinaryConsts::I64AtomicStore:  curr = allocator.alloc<Store>(); curr->bytes = 8; curr->valueType = i64; break;
      default: return false;
    }
  }

  curr->isAtomic = isAtomic;
  if (debug) std::cerr << "zz node: Store" << std::endl;
  readMemoryAccess(curr->align, curr->offset);
  curr->value = popNonVoidExpression();
  curr->ptr = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}


bool WasmBinaryBuilder::maybeVisitAtomicRMW(Expression*& out, uint8_t code) {
  if (code < BinaryConsts::AtomicRMWOps_Begin || code > BinaryConsts::AtomicRMWOps_End) return false;
  auto* curr = allocator.alloc<AtomicRMW>();

  // Set curr to the given opcode, type and size.
#define SET(opcode, optype, size) \
  curr->op = opcode;              \
  curr->type = optype;            \
  curr->bytes = size

  // Handle the cases for all the valid types for a particular opcode
#define SET_FOR_OP(Op) \
    case BinaryConsts::I32AtomicRMW##Op: SET(Op, i32, 4); break;      \
    case BinaryConsts::I32AtomicRMW##Op##8U: SET(Op, i32, 1); break;  \
    case BinaryConsts::I32AtomicRMW##Op##16U: SET(Op, i32, 2); break; \
    case BinaryConsts::I64AtomicRMW##Op: SET(Op, i64, 8); break;      \
    case BinaryConsts::I64AtomicRMW##Op##8U: SET(Op, i64, 1); break;  \
    case BinaryConsts::I64AtomicRMW##Op##16U: SET(Op, i64, 2); break; \
    case BinaryConsts::I64AtomicRMW##Op##32U: SET(Op, i64, 4); break;

  switch(code) {
    SET_FOR_OP(Add);
    SET_FOR_OP(Sub);
    SET_FOR_OP(And);
    SET_FOR_OP(Or);
    SET_FOR_OP(Xor);
    SET_FOR_OP(Xchg);
    default: WASM_UNREACHABLE();
  }
#undef SET_FOR_OP
#undef SET

  if (debug) std::cerr << "zz node: AtomicRMW" << std::endl;
  Address readAlign;
  readMemoryAccess(readAlign, curr->offset);
  if (readAlign != curr->bytes) throwError("Align of AtomicRMW must match size");
  curr->value = popNonVoidExpression();
  curr->ptr = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitAtomicCmpxchg(Expression*& out, uint8_t code) {
  if (code < BinaryConsts::AtomicCmpxchgOps_Begin || code > BinaryConsts::AtomicCmpxchgOps_End) return false;
  auto* curr = allocator.alloc<AtomicCmpxchg>();

  // Set curr to the given type and size.
#define SET(optype, size)         \
  curr->type = optype;            \
  curr->bytes = size

  switch (code) {
    case BinaryConsts::I32AtomicCmpxchg: SET(i32, 4); break;
    case BinaryConsts::I64AtomicCmpxchg: SET(i64, 8); break;
    case BinaryConsts::I32AtomicCmpxchg8U: SET(i32, 1); break;
    case BinaryConsts::I32AtomicCmpxchg16U: SET(i32, 2); break;
    case BinaryConsts::I64AtomicCmpxchg8U: SET(i64, 1); break;
    case BinaryConsts::I64AtomicCmpxchg16U: SET(i64, 2); break;
    case BinaryConsts::I64AtomicCmpxchg32U: SET(i64, 4); break;
    default: WASM_UNREACHABLE();
  }

  if (debug) std::cerr << "zz node: AtomicCmpxchg" << std::endl;
  Address readAlign;
  readMemoryAccess(readAlign, curr->offset);
  if (readAlign != curr->bytes) throwError("Align of AtomicCpxchg must match size");
  curr->replacement = popNonVoidExpression();
  curr->expected = popNonVoidExpression();
  curr->ptr = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitAtomicWait(Expression*& out, uint8_t code) {
  if (code < BinaryConsts::I32AtomicWait || code > BinaryConsts::I64AtomicWait) return false;
  auto* curr = allocator.alloc<AtomicWait>();

  switch (code) {
    case BinaryConsts::I32AtomicWait: curr->expectedType = i32; break;
    case BinaryConsts::I64AtomicWait: curr->expectedType = i64; break;
    default: WASM_UNREACHABLE();
  }
  curr->type = i32;
  if (debug) std::cerr << "zz node: AtomicWait" << std::endl;
  curr->timeout = popNonVoidExpression();
  curr->expected = popNonVoidExpression();
  curr->ptr = popNonVoidExpression();
  Address readAlign;
  readMemoryAccess(readAlign, curr->offset);
  if (readAlign != getTypeSize(curr->expectedType)) throwError("Align of AtomicWait must match size");
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitAtomicWake(Expression*& out, uint8_t code) {
  if (code != BinaryConsts::AtomicWake) return false;
  auto* curr = allocator.alloc<AtomicWake>();
  if (debug) std::cerr << "zz node: AtomicWake" << std::endl;

  curr->type = i32;
  curr->wakeCount = popNonVoidExpression();
  curr->ptr = popNonVoidExpression();
  Address readAlign;
  readMemoryAccess(readAlign, curr->offset);
  if (readAlign != getTypeSize(curr->type)) throwError("Align of AtomicWake must match size");
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitConst(Expression*& out, uint8_t code) {
  Const* curr;
  if (debug) std::cerr << "zz node: Const, code " << code << std::endl;
  switch (code) {
    case BinaryConsts::I32Const: curr = allocator.alloc<Const>(); curr->value = Literal(getS32LEB()); break;
    case BinaryConsts::I64Const: curr = allocator.alloc<Const>(); curr->value = Literal(getS64LEB()); break;
    case BinaryConsts::F32Const: curr = allocator.alloc<Const>(); curr->value = getFloat32Literal(); break;
    case BinaryConsts::F64Const: curr = allocator.alloc<Const>(); curr->value = getFloat64Literal(); break;
    default: return false;
  }
  curr->type = curr->value.type;
  out = curr;

  return true;
}

bool WasmBinaryBuilder::maybeVisitUnary(Expression*& out, uint8_t code) {
  Unary* curr;
  switch (code) {
    case BinaryConsts::I32Clz:         curr = allocator.alloc<Unary>(); curr->op = ClzInt32;               break;
    case BinaryConsts::I64Clz:         curr = allocator.alloc<Unary>(); curr->op = ClzInt64;               break;
    case BinaryConsts::I32Ctz:         curr = allocator.alloc<Unary>(); curr->op = CtzInt32;               break;
    case BinaryConsts::I64Ctz:         curr = allocator.alloc<Unary>(); curr->op = CtzInt64;               break;
    case BinaryConsts::I32Popcnt:      curr = allocator.alloc<Unary>(); curr->op = PopcntInt32;            break;
    case BinaryConsts::I64Popcnt:      curr = allocator.alloc<Unary>(); curr->op = PopcntInt64;            break;
    case BinaryConsts::I32EqZ:         curr = allocator.alloc<Unary>(); curr->op = EqZInt32;               break;
    case BinaryConsts::I64EqZ:         curr = allocator.alloc<Unary>(); curr->op = EqZInt64;               break;
    case BinaryConsts::F32Neg:         curr = allocator.alloc<Unary>(); curr->op = NegFloat32;             break;
    case BinaryConsts::F64Neg:         curr = allocator.alloc<Unary>(); curr->op = NegFloat64;             break;
    case BinaryConsts::F32Abs:         curr = allocator.alloc<Unary>(); curr->op = AbsFloat32;             break;
    case BinaryConsts::F64Abs:         curr = allocator.alloc<Unary>(); curr->op = AbsFloat64;             break;
    case BinaryConsts::F32Ceil:        curr = allocator.alloc<Unary>(); curr->op = CeilFloat32;            break;
    case BinaryConsts::F64Ceil:        curr = allocator.alloc<Unary>(); curr->op = CeilFloat64;            break;
    case BinaryConsts::F32Floor:       curr = allocator.alloc<Unary>(); curr->op = FloorFloat32;           break;
    case BinaryConsts::F64Floor:       curr = allocator.alloc<Unary>(); curr->op = FloorFloat64;           break;
    case BinaryConsts::F32NearestInt:  curr = allocator.alloc<Unary>(); curr->op = NearestFloat32;         break;
    case BinaryConsts::F64NearestInt:  curr = allocator.alloc<Unary>(); curr->op = NearestFloat64;         break;
    case BinaryConsts::F32Sqrt:        curr = allocator.alloc<Unary>(); curr->op = SqrtFloat32;            break;
    case BinaryConsts::F64Sqrt:        curr = allocator.alloc<Unary>(); curr->op = SqrtFloat64;            break;
    case BinaryConsts::F32UConvertI32: curr = allocator.alloc<Unary>(); curr->op = ConvertUInt32ToFloat32; break;
    case BinaryConsts::F64UConvertI32: curr = allocator.alloc<Unary>(); curr->op = ConvertUInt32ToFloat64; break;
    case BinaryConsts::F32SConvertI32: curr = allocator.alloc<Unary>(); curr->op = ConvertSInt32ToFloat32; break;
    case BinaryConsts::F64SConvertI32: curr = allocator.alloc<Unary>(); curr->op = ConvertSInt32ToFloat64; break;
    case BinaryConsts::F32UConvertI64: curr = allocator.alloc<Unary>(); curr->op = ConvertUInt64ToFloat32; break;
    case BinaryConsts::F64UConvertI64: curr = allocator.alloc<Unary>(); curr->op = ConvertUInt64ToFloat64; break;
    case BinaryConsts::F32SConvertI64: curr = allocator.alloc<Unary>(); curr->op = ConvertSInt64ToFloat32; break;
    case BinaryConsts::F64SConvertI64: curr = allocator.alloc<Unary>(); curr->op = ConvertSInt64ToFloat64; break;

    case BinaryConsts::I64STruncI32:  curr = allocator.alloc<Unary>(); curr->op = ExtendSInt32;            break;
    case BinaryConsts::I64UTruncI32:  curr = allocator.alloc<Unary>(); curr->op = ExtendUInt32;            break;
    case BinaryConsts::I32ConvertI64: curr = allocator.alloc<Unary>(); curr->op = WrapInt64;               break;

    case BinaryConsts::I32UTruncF32: curr = allocator.alloc<Unary>(); curr->op = TruncUFloat32ToInt32;     break;
    case BinaryConsts::I32UTruncF64: curr = allocator.alloc<Unary>(); curr->op = TruncUFloat64ToInt32;     break;
    case BinaryConsts::I32STruncF32: curr = allocator.alloc<Unary>(); curr->op = TruncSFloat32ToInt32;     break;
    case BinaryConsts::I32STruncF64: curr = allocator.alloc<Unary>(); curr->op = TruncSFloat64ToInt32;     break;
    case BinaryConsts::I64UTruncF32: curr = allocator.alloc<Unary>(); curr->op = TruncUFloat32ToInt64;     break;
    case BinaryConsts::I64UTruncF64: curr = allocator.alloc<Unary>(); curr->op = TruncUFloat64ToInt64;     break;
    case BinaryConsts::I64STruncF32: curr = allocator.alloc<Unary>(); curr->op = TruncSFloat32ToInt64;     break;
    case BinaryConsts::I64STruncF64: curr = allocator.alloc<Unary>(); curr->op = TruncSFloat64ToInt64;     break;

    case BinaryConsts::F32Trunc: curr = allocator.alloc<Unary>(); curr->op = TruncFloat32;                 break;
    case BinaryConsts::F64Trunc: curr = allocator.alloc<Unary>(); curr->op = TruncFloat64;                 break;

    case BinaryConsts::F32ConvertF64:     curr = allocator.alloc<Unary>(); curr->op = DemoteFloat64;       break;
    case BinaryConsts::F64ConvertF32:     curr = allocator.alloc<Unary>(); curr->op = PromoteFloat32;      break;
    case BinaryConsts::I32ReinterpretF32: curr = allocator.alloc<Unary>(); curr->op = ReinterpretFloat32;  break;
    case BinaryConsts::I64ReinterpretF64: curr = allocator.alloc<Unary>(); curr->op = ReinterpretFloat64;  break;
    case BinaryConsts::F32ReinterpretI32: curr = allocator.alloc<Unary>(); curr->op = ReinterpretInt32;    break;
    case BinaryConsts::F64ReinterpretI64: curr = allocator.alloc<Unary>(); curr->op = ReinterpretInt64;    break;

    case BinaryConsts::I32ExtendS8:  curr = allocator.alloc<Unary>(); curr->op = ExtendS8Int32;            break;
    case BinaryConsts::I32ExtendS16: curr = allocator.alloc<Unary>(); curr->op = ExtendS16Int32;           break;
    case BinaryConsts::I64ExtendS8:  curr = allocator.alloc<Unary>(); curr->op = ExtendS8Int64;            break;
    case BinaryConsts::I64ExtendS16: curr = allocator.alloc<Unary>(); curr->op = ExtendS16Int64;           break;
    case BinaryConsts::I64ExtendS32: curr = allocator.alloc<Unary>(); curr->op = ExtendS32Int64;           break;

    default: return false;
  }
  if (debug) std::cerr << "zz node: Unary" << std::endl;
  curr->value = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitBinary(Expression*& out, uint8_t code) {
  Binary* curr;
#define INT_TYPED_CODE(code) {                                          \
    case BinaryConsts::I32##code: curr = allocator.alloc<Binary>(); curr->op = code##Int32; break; \
      case BinaryConsts::I64##code: curr = allocator.alloc<Binary>(); curr->op = code##Int64; break; \
  }
#define FLOAT_TYPED_CODE(code) {                                        \
    case BinaryConsts::F32##code: curr = allocator.alloc<Binary>(); curr->op = code##Float32; break; \
      case BinaryConsts::F64##code: curr = allocator.alloc<Binary>(); curr->op = code##Float64; break; \
  }
#define TYPED_CODE(code) {                      \
    INT_TYPED_CODE(code)                        \
        FLOAT_TYPED_CODE(code)                  \
        }

  switch (code) {
    TYPED_CODE(Add);
    TYPED_CODE(Sub);
    TYPED_CODE(Mul);
    INT_TYPED_CODE(DivS);
    INT_TYPED_CODE(DivU);
    INT_TYPED_CODE(RemS);
    INT_TYPED_CODE(RemU);
    INT_TYPED_CODE(And);
    INT_TYPED_CODE(Or);
    INT_TYPED_CODE(Xor);
    INT_TYPED_CODE(Shl);
    INT_TYPED_CODE(ShrU);
    INT_TYPED_CODE(ShrS);
    INT_TYPED_CODE(RotL);
    INT_TYPED_CODE(RotR);
    FLOAT_TYPED_CODE(Div);
    FLOAT_TYPED_CODE(CopySign);
    FLOAT_TYPED_CODE(Min);
    FLOAT_TYPED_CODE(Max);
    TYPED_CODE(Eq);
    TYPED_CODE(Ne);
    INT_TYPED_CODE(LtS);
    INT_TYPED_CODE(LtU);
    INT_TYPED_CODE(LeS);
    INT_TYPED_CODE(LeU);
    INT_TYPED_CODE(GtS);
    INT_TYPED_CODE(GtU);
    INT_TYPED_CODE(GeS);
    INT_TYPED_CODE(GeU);
    FLOAT_TYPED_CODE(Lt);
    FLOAT_TYPED_CODE(Le);
    FLOAT_TYPED_CODE(Gt);
    FLOAT_TYPED_CODE(Ge);
    default: return false;
  }
  if (debug) std::cerr << "zz node: Binary" << std::endl;
  curr->right = popNonVoidExpression();
  curr->left = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
#undef TYPED_CODE
#undef INT_TYPED_CODE
#undef FLOAT_TYPED_CODE
}

void WasmBinaryBuilder::visitSelect(Select* curr) {
  if (debug) std::cerr << "zz node: Select" << std::endl;
  curr->condition = popNonVoidExpression();
  curr->ifFalse = popNonVoidExpression();
  curr->ifTrue = popNonVoidExpression();
  curr->finalize();
}

void WasmBinaryBuilder::visitReturn(Return* curr) {
  if (debug) std::cerr << "zz node: Return" << std::endl;
  requireFunctionContext("return");
  if (currFunction->result != none) {
    curr->value = popNonVoidExpression();
  }
  curr->finalize();
}

bool WasmBinaryBuilder::maybeVisitHost(Expression*& out, uint8_t code) {
  Host* curr;
  switch (code) {
    case BinaryConsts::CurrentMemory: {
      curr = allocator.alloc<Host>();
      curr->op = CurrentMemory;
      break;
    }
    case BinaryConsts::GrowMemory: {
      curr = allocator.alloc<Host>();
      curr->op = GrowMemory;
      curr->operands.resize(1);
      curr->operands[0] = popNonVoidExpression();
      break;
    }
    default: return false;
  }
  if (debug) std::cerr << "zz node: Host" << std::endl;
  auto reserved = getU32LEB();
  if (reserved != 0) throwError("Invalid reserved field on grow_memory/current_memory");
  curr->finalize();
  out = curr;
  return true;
}

void WasmBinaryBuilder::visitNop(Nop* curr) {
  if (debug) std::cerr << "zz node: Nop" << std::endl;
}

void WasmBinaryBuilder::visitUnreachable(Unreachable* curr) {
  if (debug) std::cerr << "zz node: Unreachable" << std::endl;
}

void WasmBinaryBuilder::visitDrop(Drop* curr) {
  if (debug) std::cerr << "zz node: Drop" << std::endl;
  curr->value = popNonVoidExpression();
  curr->finalize();
}

void WasmBinaryBuilder::throwError(std::string text) {
  throw ParseException(text, 0, pos);
}

} // namespace wasm
