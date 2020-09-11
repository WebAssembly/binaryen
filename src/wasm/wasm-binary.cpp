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

#include "ir/module-utils.h"
#include "support/bits.h"
#include "support/debug.h"
#include "wasm-binary.h"
#include "wasm-debug.h"
#include "wasm-stack.h"

#define DEBUG_TYPE "binary"

namespace wasm {

void WasmBinaryWriter::prepare() {
  // Collect function types and their frequencies. Collect information in each
  // function in parallel, then merge.
  ModuleUtils::collectSignatures(*wasm, types, typeIndices);
  importInfo = wasm::make_unique<ImportInfo>(*wasm);
}

void WasmBinaryWriter::write() {
  writeHeader();

  writeDylinkSection();

  initializeDebugInfo();
  if (sourceMap) {
    writeSourceMapProlog();
  }

  writeTypes();
  writeImports();
  writeFunctionSignatures();
  writeFunctionTableDeclaration();
  writeMemory();
  writeEvents();
  writeGlobals();
  writeExports();
  writeStart();
  writeTableElements();
  writeDataCount();
  writeFunctions();
  writeDataSegments();
  if (debugInfo) {
    writeNames();
  }
  if (sourceMap && !sourceMapUrl.empty()) {
    writeSourceMapUrl();
  }
  if (symbolMap.size() > 0) {
    writeSymbolMap();
  }

  if (sourceMap) {
    writeSourceMapEpilog();
  }

#ifdef BUILD_LLVM_DWARF
  // Update DWARF user sections after writing the data they refer to
  // (function bodies), and before writing the user sections themselves.
  if (Debug::hasDWARFSections(*wasm)) {
    Debug::writeDWARFSections(*wasm, binaryLocations);
  }
#endif

  writeLateUserSections();
  writeFeaturesSection();

  finishUp();
}

void WasmBinaryWriter::writeHeader() {
  BYN_TRACE("== writeHeader\n");
  o << int32_t(BinaryConsts::Magic); // magic number \0asm
  o << int32_t(BinaryConsts::Version);
}

int32_t WasmBinaryWriter::writeU32LEBPlaceholder() {
  int32_t ret = o.size();
  o << int32_t(0);
  o << int8_t(0);
  return ret;
}

void WasmBinaryWriter::writeResizableLimits(Address initial,
                                            Address maximum,
                                            bool hasMaximum,
                                            bool shared) {
  uint32_t flags = (hasMaximum ? (uint32_t)BinaryConsts::HasMaximum : 0U) |
                   (shared ? (uint32_t)BinaryConsts::IsShared : 0U);
  o << U32LEB(flags);
  o << U32LEB(initial);
  if (hasMaximum) {
    o << U32LEB(maximum);
  }
}

template<typename T> int32_t WasmBinaryWriter::startSection(T code) {
  o << uint8_t(code);
  if (sourceMap) {
    sourceMapLocationsSizeAtSectionStart = sourceMapLocations.size();
  }
  binaryLocationsSizeAtSectionStart = binaryLocations.expressions.size();
  return writeU32LEBPlaceholder(); // section size to be filled in later
}

void WasmBinaryWriter::finishSection(int32_t start) {
  // section size does not include the reserved bytes of the size field itself
  int32_t size = o.size() - start - MaxLEB32Bytes;
  auto sizeFieldSize = o.writeAt(start, U32LEB(size));
  // We can move things back if the actual LEB for the size doesn't use the
  // maximum 5 bytes. In that case we need to adjust offsets after we move
  // things backwards.
  auto adjustmentForLEBShrinking = MaxLEB32Bytes - sizeFieldSize;
  if (adjustmentForLEBShrinking) {
    // we can save some room, nice
    assert(sizeFieldSize < MaxLEB32Bytes);
    std::move(&o[start] + MaxLEB32Bytes,
              &o[start] + MaxLEB32Bytes + size,
              &o[start] + sizeFieldSize);
    o.resize(o.size() - adjustmentForLEBShrinking);
    if (sourceMap) {
      for (auto i = sourceMapLocationsSizeAtSectionStart;
           i < sourceMapLocations.size();
           ++i) {
        sourceMapLocations[i].first -= adjustmentForLEBShrinking;
      }
    }
  }

  if (binaryLocationsSizeAtSectionStart != binaryLocations.expressions.size()) {
    // We added the binary locations, adjust them: they must be relative
    // to the code section.
    assert(binaryLocationsSizeAtSectionStart == 0);
    // The section type byte is right before the LEB for the size; we want
    // offsets that are relative to the body, which is after that section type
    // byte and the the size LEB.
    auto body = start + sizeFieldSize;
    // Offsets are relative to the body of the code section: after the
    // section type byte and the size.
    // Everything was moved by the adjustment, track that. After this,
    // we are at the right absolute address.
    // We are relative to the section start.
    auto totalAdjustment = adjustmentForLEBShrinking + body;
    for (auto& pair : binaryLocations.expressions) {
      pair.second.start -= totalAdjustment;
      pair.second.end -= totalAdjustment;
    }
    for (auto& pair : binaryLocations.functions) {
      pair.second.start -= totalAdjustment;
      pair.second.declarations -= totalAdjustment;
      pair.second.end -= totalAdjustment;
    }
    for (auto& pair : binaryLocations.delimiters) {
      for (auto& item : pair.second) {
        item -= totalAdjustment;
      }
    }
  }
}

int32_t
WasmBinaryWriter::startSubsection(BinaryConsts::UserSections::Subsection code) {
  return startSection(code);
}

void WasmBinaryWriter::finishSubsection(int32_t start) { finishSection(start); }

void WasmBinaryWriter::writeStart() {
  if (!wasm->start.is()) {
    return;
  }
  BYN_TRACE("== writeStart\n");
  auto start = startSection(BinaryConsts::Section::Start);
  o << U32LEB(getFunctionIndex(wasm->start.str));
  finishSection(start);
}

void WasmBinaryWriter::writeMemory() {
  if (!wasm->memory.exists || wasm->memory.imported()) {
    return;
  }
  BYN_TRACE("== writeMemory\n");
  auto start = startSection(BinaryConsts::Section::Memory);
  o << U32LEB(1); // Define 1 memory
  writeResizableLimits(wasm->memory.initial,
                       wasm->memory.max,
                       wasm->memory.hasMax(),
                       wasm->memory.shared);
  finishSection(start);
}

void WasmBinaryWriter::writeTypes() {
  if (types.size() == 0) {
    return;
  }
  BYN_TRACE("== writeTypes\n");
  auto start = startSection(BinaryConsts::Section::Type);
  o << U32LEB(types.size());
  for (Index i = 0; i < types.size(); ++i) {
    Signature& sig = types[i];
    BYN_TRACE("write " << sig.params << " -> " << sig.results << std::endl);
    o << S32LEB(BinaryConsts::EncodedType::Func);
    for (auto& sigType : {sig.params, sig.results}) {
      o << U32LEB(sigType.size());
      for (const auto& type : sigType) {
        o << binaryType(type);
      }
    }
  }
  finishSection(start);
}

void WasmBinaryWriter::writeImports() {
  auto num = importInfo->getNumImports();
  if (num == 0) {
    return;
  }
  BYN_TRACE("== writeImports\n");
  auto start = startSection(BinaryConsts::Section::Import);
  o << U32LEB(num);
  auto writeImportHeader = [&](Importable* import) {
    writeInlineString(import->module.str);
    writeInlineString(import->base.str);
  };
  ModuleUtils::iterImportedFunctions(*wasm, [&](Function* func) {
    BYN_TRACE("write one function\n");
    writeImportHeader(func);
    o << U32LEB(int32_t(ExternalKind::Function));
    o << U32LEB(getTypeIndex(func->sig));
  });
  ModuleUtils::iterImportedGlobals(*wasm, [&](Global* global) {
    BYN_TRACE("write one global\n");
    writeImportHeader(global);
    o << U32LEB(int32_t(ExternalKind::Global));
    o << binaryType(global->type);
    o << U32LEB(global->mutable_);
  });
  ModuleUtils::iterImportedEvents(*wasm, [&](Event* event) {
    BYN_TRACE("write one event\n");
    writeImportHeader(event);
    o << U32LEB(int32_t(ExternalKind::Event));
    o << U32LEB(event->attribute);
    o << U32LEB(getTypeIndex(event->sig));
  });
  if (wasm->memory.imported()) {
    BYN_TRACE("write one memory\n");
    writeImportHeader(&wasm->memory);
    o << U32LEB(int32_t(ExternalKind::Memory));
    writeResizableLimits(wasm->memory.initial,
                         wasm->memory.max,
                         wasm->memory.hasMax(),
                         wasm->memory.shared);
  }
  if (wasm->table.imported()) {
    BYN_TRACE("write one table\n");
    writeImportHeader(&wasm->table);
    o << U32LEB(int32_t(ExternalKind::Table));
    o << S32LEB(BinaryConsts::EncodedType::funcref);
    writeResizableLimits(wasm->table.initial,
                         wasm->table.max,
                         wasm->table.hasMax(),
                         /*shared=*/false);
  }
  finishSection(start);
}

void WasmBinaryWriter::writeFunctionSignatures() {
  if (importInfo->getNumDefinedFunctions() == 0) {
    return;
  }
  BYN_TRACE("== writeFunctionSignatures\n");
  auto start = startSection(BinaryConsts::Section::Function);
  o << U32LEB(importInfo->getNumDefinedFunctions());
  ModuleUtils::iterDefinedFunctions(*wasm, [&](Function* func) {
    BYN_TRACE("write one\n");
    o << U32LEB(getTypeIndex(func->sig));
  });
  finishSection(start);
}

void WasmBinaryWriter::writeExpression(Expression* curr) {
  BinaryenIRToBinaryWriter(*this, o).visit(curr);
}

void WasmBinaryWriter::writeFunctions() {
  if (importInfo->getNumDefinedFunctions() == 0) {
    return;
  }
  BYN_TRACE("== writeFunctions\n");
  auto sectionStart = startSection(BinaryConsts::Section::Code);
  o << U32LEB(importInfo->getNumDefinedFunctions());
  bool DWARF = Debug::hasDWARFSections(*getModule());
  ModuleUtils::iterDefinedFunctions(*wasm, [&](Function* func) {
    assert(binaryLocationTrackedExpressionsForFunc.empty());
    size_t sourceMapLocationsSizeAtFunctionStart = sourceMapLocations.size();
    BYN_TRACE("write one at" << o.size() << std::endl);
    size_t sizePos = writeU32LEBPlaceholder();
    size_t start = o.size();
    BYN_TRACE("writing" << func->name << std::endl);
    // Emit Stack IR if present, and if we can
    if (func->stackIR && !sourceMap && !DWARF) {
      BYN_TRACE("write Stack IR\n");
      StackIRToBinaryWriter(*this, o, func).write();
    } else {
      BYN_TRACE("write Binaryen IR\n");
      BinaryenIRToBinaryWriter(*this, o, func, sourceMap, DWARF).write();
    }
    size_t size = o.size() - start;
    assert(size <= std::numeric_limits<uint32_t>::max());
    BYN_TRACE("body size: " << size << ", writing at " << sizePos
                            << ", next starts at " << o.size() << "\n");
    auto sizeFieldSize = o.writeAt(sizePos, U32LEB(size));
    // We can move things back if the actual LEB for the size doesn't use the
    // maximum 5 bytes. In that case we need to adjust offsets after we move
    // things backwards.
    auto adjustmentForLEBShrinking = MaxLEB32Bytes - sizeFieldSize;
    if (adjustmentForLEBShrinking) {
      // we can save some room, nice
      assert(sizeFieldSize < MaxLEB32Bytes);
      std::move(&o[start], &o[start] + size, &o[sizePos] + sizeFieldSize);
      o.resize(o.size() - adjustmentForLEBShrinking);
      if (sourceMap) {
        for (auto i = sourceMapLocationsSizeAtFunctionStart;
             i < sourceMapLocations.size();
             ++i) {
          sourceMapLocations[i].first -= adjustmentForLEBShrinking;
        }
      }
      for (auto* curr : binaryLocationTrackedExpressionsForFunc) {
        // We added the binary locations, adjust them: they must be relative
        // to the code section.
        auto& span = binaryLocations.expressions[curr];
        span.start -= adjustmentForLEBShrinking;
        span.end -= adjustmentForLEBShrinking;
        auto iter = binaryLocations.delimiters.find(curr);
        if (iter != binaryLocations.delimiters.end()) {
          for (auto& item : iter->second) {
            item -= adjustmentForLEBShrinking;
          }
        }
      }
    }
    if (!binaryLocationTrackedExpressionsForFunc.empty()) {
      binaryLocations.functions[func] = BinaryLocations::FunctionLocations{
        BinaryLocation(sizePos),
        BinaryLocation(start - adjustmentForLEBShrinking),
        BinaryLocation(o.size())};
    }
    tableOfContents.functionBodies.emplace_back(
      func->name, sizePos + sizeFieldSize, size);
    binaryLocationTrackedExpressionsForFunc.clear();
  });
  finishSection(sectionStart);
}

void WasmBinaryWriter::writeGlobals() {
  if (importInfo->getNumDefinedGlobals() == 0) {
    return;
  }
  BYN_TRACE("== writeglobals\n");
  auto start = startSection(BinaryConsts::Section::Global);
  // Count and emit the total number of globals after tuple globals have been
  // expanded into their constituent parts.
  Index num = 0;
  ModuleUtils::iterDefinedGlobals(
    *wasm, [&num](Global* global) { num += global->type.size(); });
  o << U32LEB(num);
  ModuleUtils::iterDefinedGlobals(*wasm, [&](Global* global) {
    BYN_TRACE("write one\n");
    size_t i = 0;
    for (const auto& t : global->type) {
      o << binaryType(t);
      o << U32LEB(global->mutable_);
      if (global->type.size() == 1) {
        writeExpression(global->init);
      } else {
        writeExpression(global->init->cast<TupleMake>()->operands[i]);
      }
      o << int8_t(BinaryConsts::End);
      ++i;
    }
  });
  finishSection(start);
}

void WasmBinaryWriter::writeExports() {
  if (wasm->exports.size() == 0) {
    return;
  }
  BYN_TRACE("== writeexports\n");
  auto start = startSection(BinaryConsts::Section::Export);
  o << U32LEB(wasm->exports.size());
  for (auto& curr : wasm->exports) {
    BYN_TRACE("write one\n");
    writeInlineString(curr->name.str);
    o << U32LEB(int32_t(curr->kind));
    switch (curr->kind) {
      case ExternalKind::Function:
        o << U32LEB(getFunctionIndex(curr->value));
        break;
      case ExternalKind::Table:
        o << U32LEB(0);
        break;
      case ExternalKind::Memory:
        o << U32LEB(0);
        break;
      case ExternalKind::Global:
        o << U32LEB(getGlobalIndex(curr->value));
        break;
      case ExternalKind::Event:
        o << U32LEB(getEventIndex(curr->value));
        break;
      default:
        WASM_UNREACHABLE("unexpected extern kind");
    }
  }
  finishSection(start);
}

void WasmBinaryWriter::writeDataCount() {
  if (!wasm->features.hasBulkMemory() || !wasm->memory.segments.size()) {
    return;
  }
  auto start = startSection(BinaryConsts::Section::DataCount);
  o << U32LEB(wasm->memory.segments.size());
  finishSection(start);
}

void WasmBinaryWriter::writeDataSegments() {
  if (wasm->memory.segments.size() == 0) {
    return;
  }
  if (wasm->memory.segments.size() > WebLimitations::MaxDataSegments) {
    std::cerr << "Some VMs may not accept this binary because it has a large "
              << "number of data segments. Run the limit-segments pass to "
              << "merge segments.\n";
  }
  auto start = startSection(BinaryConsts::Section::Data);
  o << U32LEB(wasm->memory.segments.size());
  for (auto& segment : wasm->memory.segments) {
    uint32_t flags = 0;
    if (segment.isPassive) {
      flags |= BinaryConsts::IsPassive;
    }
    o << U32LEB(flags);
    if (!segment.isPassive) {
      writeExpression(segment.offset);
      o << int8_t(BinaryConsts::End);
    }
    writeInlineBuffer(segment.data.data(), segment.data.size());
  }
  finishSection(start);
}

uint32_t WasmBinaryWriter::getFunctionIndex(Name name) const {
  auto it = indexes.functionIndexes.find(name);
  assert(it != indexes.functionIndexes.end());
  return it->second;
}

uint32_t WasmBinaryWriter::getGlobalIndex(Name name) const {
  auto it = indexes.globalIndexes.find(name);
  assert(it != indexes.globalIndexes.end());
  return it->second;
}

uint32_t WasmBinaryWriter::getEventIndex(Name name) const {
  auto it = indexes.eventIndexes.find(name);
  assert(it != indexes.eventIndexes.end());
  return it->second;
}

uint32_t WasmBinaryWriter::getTypeIndex(Signature sig) const {
  auto it = typeIndices.find(sig);
  assert(it != typeIndices.end());
  return it->second;
}

void WasmBinaryWriter::writeFunctionTableDeclaration() {
  if (!wasm->table.exists || wasm->table.imported()) {
    return;
  }
  BYN_TRACE("== writeFunctionTableDeclaration\n");
  auto start = startSection(BinaryConsts::Section::Table);
  o << U32LEB(1); // Declare 1 table.
  o << S32LEB(BinaryConsts::EncodedType::funcref);
  writeResizableLimits(wasm->table.initial,
                       wasm->table.max,
                       wasm->table.hasMax(),
                       /*shared=*/false);
  finishSection(start);
}

void WasmBinaryWriter::writeTableElements() {
  if (!wasm->table.exists || wasm->table.segments.size() == 0) {
    return;
  }
  BYN_TRACE("== writeTableElements\n");
  auto start = startSection(BinaryConsts::Section::Element);

  o << U32LEB(wasm->table.segments.size());
  for (auto& segment : wasm->table.segments) {
    // Table index; 0 in the MVP (and binaryen IR only has 1 table)
    o << U32LEB(0);
    writeExpression(segment.offset);
    o << int8_t(BinaryConsts::End);
    o << U32LEB(segment.data.size());
    for (auto name : segment.data) {
      o << U32LEB(getFunctionIndex(name));
    }
  }
  finishSection(start);
}

void WasmBinaryWriter::writeEvents() {
  if (importInfo->getNumDefinedEvents() == 0) {
    return;
  }
  BYN_TRACE("== writeEvents\n");
  auto start = startSection(BinaryConsts::Section::Event);
  auto num = importInfo->getNumDefinedEvents();
  o << U32LEB(num);
  ModuleUtils::iterDefinedEvents(*wasm, [&](Event* event) {
    BYN_TRACE("write one\n");
    o << U32LEB(event->attribute);
    o << U32LEB(getTypeIndex(event->sig));
  });

  finishSection(start);
}

void WasmBinaryWriter::writeNames() {
  if (wasm->functions.empty()) {
    return;
  }

  BYN_TRACE("== writeNames\n");
  auto start = startSection(BinaryConsts::Section::User);
  writeInlineString(BinaryConsts::UserSections::Name);
  auto substart =
    startSubsection(BinaryConsts::UserSections::Subsection::NameFunction);
  o << U32LEB(indexes.functionIndexes.size());
  Index emitted = 0;
  auto add = [&](Function* curr) {
    o << U32LEB(emitted);
    writeEscapedName(curr->name.str);
    emitted++;
  };
  ModuleUtils::iterImportedFunctions(*wasm, add);
  ModuleUtils::iterDefinedFunctions(*wasm, add);
  assert(emitted == indexes.functionIndexes.size());
  finishSubsection(substart);
  /* TODO: locals */
  finishSection(start);
}

void WasmBinaryWriter::writeSourceMapUrl() {
  BYN_TRACE("== writeSourceMapUrl\n");
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

void WasmBinaryWriter::initializeDebugInfo() {
  lastDebugLocation = {0, /* lineNumber = */ 1, 0};
}

void WasmBinaryWriter::writeSourceMapProlog() {
  *sourceMap << "{\"version\":3,\"sources\":[";
  for (size_t i = 0; i < wasm->debugInfoFileNames.size(); i++) {
    if (i > 0) {
      *sourceMap << ",";
    }
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
    out << char(digit < 20
                  ? 'g' + digit
                  : digit < 30 ? '0' + digit - 20 : digit == 30 ? '+' : '/');
  }
}

void WasmBinaryWriter::writeSourceMapEpilog() {
  // write source map entries
  size_t lastOffset = 0;
  Function::DebugLocation lastLoc = {0, /* lineNumber = */ 1, 0};
  for (const auto& offsetAndlocPair : sourceMapLocations) {
    if (lastOffset > 0) {
      *sourceMap << ",";
    }
    size_t offset = offsetAndlocPair.first;
    const Function::DebugLocation& loc = *offsetAndlocPair.second;
    writeBase64VLQ(*sourceMap, int32_t(offset - lastOffset));
    writeBase64VLQ(*sourceMap, int32_t(loc.fileIndex - lastLoc.fileIndex));
    writeBase64VLQ(*sourceMap, int32_t(loc.lineNumber - lastLoc.lineNumber));
    writeBase64VLQ(*sourceMap,
                   int32_t(loc.columnNumber - lastLoc.columnNumber));
    lastLoc = loc;
    lastOffset = offset;
  }
  *sourceMap << "\"}";
}

void WasmBinaryWriter::writeLateUserSections() {
  for (auto& section : wasm->userSections) {
    if (section.name != BinaryConsts::UserSections::Dylink) {
      writeUserSection(section);
    }
  }
}

void WasmBinaryWriter::writeUserSection(const UserSection& section) {
  auto start = startSection(BinaryConsts::User);
  writeInlineString(section.name.c_str());
  for (size_t i = 0; i < section.data.size(); i++) {
    o << uint8_t(section.data[i]);
  }
  finishSection(start);
}

void WasmBinaryWriter::writeFeaturesSection() {
  if (!wasm->hasFeaturesSection || wasm->features.isMVP()) {
    return;
  }

  // TODO(tlively): unify feature names with rest of toolchain and use
  // FeatureSet::toString()
  auto toString = [](FeatureSet::Feature f) {
    switch (f) {
      case FeatureSet::Atomics:
        return BinaryConsts::UserSections::AtomicsFeature;
      case FeatureSet::MutableGlobals:
        return BinaryConsts::UserSections::MutableGlobalsFeature;
      case FeatureSet::TruncSat:
        return BinaryConsts::UserSections::TruncSatFeature;
      case FeatureSet::SIMD:
        return BinaryConsts::UserSections::SIMD128Feature;
      case FeatureSet::BulkMemory:
        return BinaryConsts::UserSections::BulkMemoryFeature;
      case FeatureSet::SignExt:
        return BinaryConsts::UserSections::SignExtFeature;
      case FeatureSet::ExceptionHandling:
        return BinaryConsts::UserSections::ExceptionHandlingFeature;
      case FeatureSet::TailCall:
        return BinaryConsts::UserSections::TailCallFeature;
      case FeatureSet::ReferenceTypes:
        return BinaryConsts::UserSections::ReferenceTypesFeature;
      case FeatureSet::Multivalue:
        return BinaryConsts::UserSections::MultivalueFeature;
      case FeatureSet::Anyref:
        return BinaryConsts::UserSections::AnyrefFeature;
      default:
        WASM_UNREACHABLE("unexpected feature flag");
    }
  };

  std::vector<const char*> features;
  wasm->features.iterFeatures(
    [&](FeatureSet::Feature f) { features.push_back(toString(f)); });

  auto start = startSection(BinaryConsts::User);
  writeInlineString(BinaryConsts::UserSections::TargetFeatures);
  o << U32LEB(features.size());
  for (auto& f : features) {
    o << uint8_t(BinaryConsts::FeatureUsed);
    writeInlineString(f);
  }
  finishSection(start);
}

void WasmBinaryWriter::writeDylinkSection() {
  if (!wasm->dylinkSection) {
    return;
  }

  auto start = startSection(BinaryConsts::User);
  writeInlineString(BinaryConsts::UserSections::Dylink);
  o << U32LEB(wasm->dylinkSection->memorySize);
  o << U32LEB(wasm->dylinkSection->memoryAlignment);
  o << U32LEB(wasm->dylinkSection->tableSize);
  o << U32LEB(wasm->dylinkSection->tableAlignment);
  o << U32LEB(wasm->dylinkSection->neededDynlibs.size());
  for (auto& neededDynlib : wasm->dylinkSection->neededDynlibs) {
    writeInlineString(neededDynlib.c_str());
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
  if (sourceMap) {
    auto& debugLocations = func->debugLocations;
    auto iter = debugLocations.find(curr);
    if (iter != debugLocations.end()) {
      writeDebugLocation(iter->second);
    }
  }
  // If this is an instruction in a function, and if the original wasm had
  // binary locations tracked, then track it in the output as well.
  if (func && !func->expressionLocations.empty()) {
    binaryLocations.expressions[curr] =
      BinaryLocations::Span{BinaryLocation(o.size()), 0};
    binaryLocationTrackedExpressionsForFunc.push_back(curr);
  }
}

void WasmBinaryWriter::writeDebugLocationEnd(Expression* curr, Function* func) {
  if (func && !func->expressionLocations.empty()) {
    auto& span = binaryLocations.expressions.at(curr);
    assert(span.end == 0);
    span.end = o.size();
  }
}

void WasmBinaryWriter::writeExtraDebugLocation(
  Expression* curr, Function* func, BinaryLocations::DelimiterId id) {
  if (func && !func->expressionLocations.empty()) {
    binaryLocations.delimiters[curr][id] = o.size();
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
  return (ch >= '0' && ch <= '9') || (ch >= 'a' && ch <= 'f') ||
         (ch >= 'A' && ch <= 'F');
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
    if (ch != '\\' || i + 1 >= size || !isHexDigit(name[i]) ||
        !isHexDigit(name[i + 1])) {
      unescaped.push_back(ch);
      continue;
    }
    unescaped.push_back(
      char((decodeHexNibble(name[i]) << 4) | decodeHexNibble(name[i + 1])));
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
  // placeholder, we'll fill in the pointer to the buffer later when we have it
  o << uint32_t(0);
}

void WasmBinaryWriter::emitString(const char* str) {
  BYN_TRACE("emitString " << str << std::endl);
  emitBuffer(str, strlen(str) + 1);
}

void WasmBinaryWriter::finishUp() {
  BYN_TRACE("finishUp\n");
  // finish buffers
  for (const auto& buffer : buffersToWrite) {
    BYN_TRACE("writing buffer"
              << (int)buffer.data[0] << "," << (int)buffer.data[1] << " at "
              << o.size() << " and pointer is at " << buffer.pointerLocation
              << "\n");
    o.writeAt(buffer.pointerLocation, (uint32_t)o.size());
    for (size_t i = 0; i < buffer.size; i++) {
      o << (uint8_t)buffer.data[i];
    }
  }
}

// reader

bool WasmBinaryBuilder::hasDWARFSections() {
  assert(pos == 0);
  getInt32(); // magic
  getInt32(); // version
  bool has = false;
  while (more()) {
    uint8_t sectionCode = getInt8();
    uint32_t payloadLen = getU32LEB();
    if (uint64_t(pos) + uint64_t(payloadLen) > input.size()) {
      throwError("Section extends beyond end of input");
    }
    auto oldPos = pos;
    if (sectionCode == BinaryConsts::Section::User) {
      auto sectionName = getInlineString();
      if (Debug::isDWARFSection(sectionName)) {
        has = true;
        break;
      }
    }
    pos = oldPos + payloadLen;
  }
  pos = 0;
  return has;
}

void WasmBinaryBuilder::read() {
  if (DWARF) {
    // In order to update dwarf, we must store info about each IR node's
    // binary position. This has noticeable memory overhead, so we don't do it
    // by default: the user must request it by setting "DWARF", and even if so
    // we scan ahead to see that there actually *are* DWARF sections, so that
    // we don't do unnecessary work.
    if (!hasDWARFSections()) {
      DWARF = false;
    }
  }

  readHeader();
  readSourceMapHeader();

  // read sections until the end
  while (more()) {
    uint8_t sectionCode = getInt8();
    uint32_t payloadLen = getU32LEB();
    if (uint64_t(pos) + uint64_t(payloadLen) > input.size()) {
      throwError("Section extends beyond end of input");
    }

    auto oldPos = pos;

    // note the section in the list of seen sections, as almost no sections can
    // appear more than once, and verify those that shouldn't do not.
    if (sectionCode != BinaryConsts::Section::User &&
        sectionCode != BinaryConsts::Section::Code) {
      if (!seenSections.insert(BinaryConsts::Section(sectionCode)).second) {
        throwError("section seen more than once: " +
                   std::to_string(sectionCode));
      }
    }

    switch (sectionCode) {
      case BinaryConsts::Section::Start:
        readStart();
        break;
      case BinaryConsts::Section::Memory:
        readMemory();
        break;
      case BinaryConsts::Section::Type:
        readSignatures();
        break;
      case BinaryConsts::Section::Import:
        readImports();
        break;
      case BinaryConsts::Section::Function:
        readFunctionSignatures();
        break;
      case BinaryConsts::Section::Code:
        if (DWARF) {
          codeSectionLocation = pos;
        }
        readFunctions();
        break;
      case BinaryConsts::Section::Export:
        readExports();
        break;
      case BinaryConsts::Section::Element:
        readTableElements();
        break;
      case BinaryConsts::Section::Global:
        readGlobals();
        break;
      case BinaryConsts::Section::Data:
        readDataSegments();
        break;
      case BinaryConsts::Section::DataCount:
        readDataCount();
        break;
      case BinaryConsts::Section::Table:
        readFunctionTableDeclaration();
        break;
      case BinaryConsts::Section::Event:
        readEvents();
        break;
      default: {
        readUserSection(payloadLen);
        if (pos > oldPos + payloadLen) {
          throwError("bad user section size, started at " +
                     std::to_string(oldPos) + " plus payload " +
                     std::to_string(payloadLen) +
                     " not being equal to new position " + std::to_string(pos));
        }
        pos = oldPos + payloadLen;
      }
    }

    // make sure we advanced exactly past this section
    if (pos != oldPos + payloadLen) {
      throwError("bad section size, started at " + std::to_string(oldPos) +
                 " plus payload " + std::to_string(payloadLen) +
                 " not being equal to new position " + std::to_string(pos));
    }
  }

  validateBinary();
  processFunctions();
}

void WasmBinaryBuilder::readUserSection(size_t payloadLen) {
  auto oldPos = pos;
  Name sectionName = getInlineString();
  size_t read = pos - oldPos;
  if (read > payloadLen) {
    throwError("bad user section size");
  }
  payloadLen -= read;
  if (sectionName.equals(BinaryConsts::UserSections::Name)) {
    readNames(payloadLen);
  } else if (sectionName.equals(BinaryConsts::UserSections::TargetFeatures)) {
    readFeatures(payloadLen);
  } else if (sectionName.equals(BinaryConsts::UserSections::Dylink)) {
    readDylink(payloadLen);
  } else {
    // an unfamiliar custom section
    if (sectionName.equals(BinaryConsts::UserSections::Linking)) {
      std::cerr
        << "warning: linking section is present, so this is not a standard "
           "wasm file - binaryen cannot handle this properly!\n";
    }
    wasm.userSections.resize(wasm.userSections.size() + 1);
    auto& section = wasm.userSections.back();
    section.name = sectionName.str;
    auto sectionSize = payloadLen;
    section.data.resize(sectionSize);
    for (size_t i = 0; i < sectionSize; i++) {
      section.data[i] = getInt8();
    }
  }
}

uint8_t WasmBinaryBuilder::getInt8() {
  if (!more()) {
    throwError("unexpected end of input");
  }
  BYN_TRACE("getInt8: " << (int)(uint8_t)input[pos] << " (at " << pos << ")\n");
  return input[pos++];
}

uint16_t WasmBinaryBuilder::getInt16() {
  BYN_TRACE("<==\n");
  auto ret = uint16_t(getInt8());
  ret |= uint16_t(getInt8()) << 8;
  BYN_TRACE("getInt16: " << ret << "/0x" << std::hex << ret << std::dec
                         << " ==>\n");
  return ret;
}

uint32_t WasmBinaryBuilder::getInt32() {
  BYN_TRACE("<==\n");
  auto ret = uint32_t(getInt16());
  ret |= uint32_t(getInt16()) << 16;
  BYN_TRACE("getInt32: " << ret << "/0x" << std::hex << ret << std::dec
                         << " ==>\n");
  return ret;
}

uint64_t WasmBinaryBuilder::getInt64() {
  BYN_TRACE("<==\n");
  auto ret = uint64_t(getInt32());
  ret |= uint64_t(getInt32()) << 32;
  BYN_TRACE("getInt64: " << ret << "/0x" << std::hex << ret << std::dec
                         << " ==>\n");
  return ret;
}

uint8_t WasmBinaryBuilder::getLaneIndex(size_t lanes) {
  BYN_TRACE("<==\n");
  auto ret = getInt8();
  if (ret >= lanes) {
    throwError("Illegal lane index");
  }
  BYN_TRACE("getLaneIndex(" << lanes << "): " << ret << " ==>" << std::endl);
  return ret;
}

Literal WasmBinaryBuilder::getFloat32Literal() {
  BYN_TRACE("<==\n");
  auto ret = Literal(getInt32());
  ret = ret.castToF32();
  BYN_TRACE("getFloat32: " << ret << " ==>\n");
  return ret;
}

Literal WasmBinaryBuilder::getFloat64Literal() {
  BYN_TRACE("<==\n");
  auto ret = Literal(getInt64());
  ret = ret.castToF64();
  BYN_TRACE("getFloat64: " << ret << " ==>\n");
  return ret;
}

Literal WasmBinaryBuilder::getVec128Literal() {
  BYN_TRACE("<==\n");
  std::array<uint8_t, 16> bytes;
  for (auto i = 0; i < 16; ++i) {
    bytes[i] = getInt8();
  }
  auto ret = Literal(bytes.data());
  BYN_TRACE("getVec128: " << ret << " ==>\n");
  return ret;
}

uint32_t WasmBinaryBuilder::getU32LEB() {
  BYN_TRACE("<==\n");
  U32LEB ret;
  ret.read([&]() { return getInt8(); });
  BYN_TRACE("getU32LEB: " << ret.value << " ==>\n");
  return ret.value;
}

uint64_t WasmBinaryBuilder::getU64LEB() {
  BYN_TRACE("<==\n");
  U64LEB ret;
  ret.read([&]() { return getInt8(); });
  BYN_TRACE("getU64LEB: " << ret.value << " ==>\n");
  return ret.value;
}

int32_t WasmBinaryBuilder::getS32LEB() {
  BYN_TRACE("<==\n");
  S32LEB ret;
  ret.read([&]() { return (int8_t)getInt8(); });
  BYN_TRACE("getS32LEB: " << ret.value << " ==>\n");
  return ret.value;
}

int64_t WasmBinaryBuilder::getS64LEB() {
  BYN_TRACE("<==\n");
  S64LEB ret;
  ret.read([&]() { return (int8_t)getInt8(); });
  BYN_TRACE("getS64LEB: " << ret.value << " ==>\n");
  return ret.value;
}

Type WasmBinaryBuilder::getType() {
  int type = getS32LEB();
  // Single value types are negative; signature indices are non-negative
  if (type >= 0) {
    // TODO: Handle block input types properly
    if (size_t(type) >= signatures.size()) {
      throwError("invalid signature index: " + std::to_string(type));
    }
    return signatures[type].results;
  }
  switch (type) {
    // None only used for block signatures. TODO: Separate out?
    case BinaryConsts::EncodedType::Empty:
      return Type::none;
    case BinaryConsts::EncodedType::i32:
      return Type::i32;
    case BinaryConsts::EncodedType::i64:
      return Type::i64;
    case BinaryConsts::EncodedType::f32:
      return Type::f32;
    case BinaryConsts::EncodedType::f64:
      return Type::f64;
    case BinaryConsts::EncodedType::v128:
      return Type::v128;
    case BinaryConsts::EncodedType::funcref:
      return Type::funcref;
    case BinaryConsts::EncodedType::externref:
      return Type::externref;
    case BinaryConsts::EncodedType::exnref:
      return Type::exnref;
    case BinaryConsts::EncodedType::anyref:
      return Type::anyref;
    default:
      throwError("invalid wasm type: " + std::to_string(type));
  }
  WASM_UNREACHABLE("unexpeced type");
}

HeapType WasmBinaryBuilder::getHeapType() {
  int type = getS32LEB(); // TODO: Actually encoded as s33
  // Single heap types are negative; heap type indices are non-negative
  if (type >= 0) {
    if (size_t(type) >= signatures.size()) {
      throwError("invalid signature index: " + std::to_string(type));
    }
    return HeapType(signatures[type]);
  }
  switch (type) {
    case BinaryConsts::EncodedHeapType::func:
      return HeapType::FuncKind;
    case BinaryConsts::EncodedHeapType::extern_:
      return HeapType::ExternKind;
    case BinaryConsts::EncodedHeapType::exn:
      return HeapType::ExnKind;
    case BinaryConsts::EncodedHeapType::any:
      return HeapType::AnyKind;
    default:
      throwError("invalid wasm heap type: " + std::to_string(type));
  }
  WASM_UNREACHABLE("unexpeced type");
}

Type WasmBinaryBuilder::getConcreteType() {
  auto type = getType();
  if (!type.isConcrete()) {
    throw ParseException("non-concrete type when one expected");
  }
  return type;
}

Name WasmBinaryBuilder::getInlineString() {
  BYN_TRACE("<==\n");
  auto len = getU32LEB();
  std::string str;
  for (size_t i = 0; i < len; i++) {
    auto curr = char(getInt8());
    if (curr == 0) {
      throwError(
        "inline string contains NULL (0). that is technically valid in wasm, "
        "but you shouldn't do it, and it's not supported in binaryen");
    }
    str = str + curr;
  }
  BYN_TRACE("getInlineString: " << str << " ==>\n");
  return Name(str);
}

void WasmBinaryBuilder::verifyInt8(int8_t x) {
  int8_t y = getInt8();
  if (x != y) {
    throwError("surprising value");
  }
}

void WasmBinaryBuilder::verifyInt16(int16_t x) {
  int16_t y = getInt16();
  if (x != y) {
    throwError("surprising value");
  }
}

void WasmBinaryBuilder::verifyInt32(int32_t x) {
  int32_t y = getInt32();
  if (x != y) {
    throwError("surprising value");
  }
}

void WasmBinaryBuilder::verifyInt64(int64_t x) {
  int64_t y = getInt64();
  if (x != y) {
    throwError("surprising value");
  }
}

void WasmBinaryBuilder::ungetInt8() {
  assert(pos > 0);
  BYN_TRACE("ungetInt8 (at " << pos << ")\n");
  pos--;
}

void WasmBinaryBuilder::readHeader() {
  BYN_TRACE("== readHeader\n");
  verifyInt32(BinaryConsts::Magic);
  verifyInt32(BinaryConsts::Version);
}

void WasmBinaryBuilder::readStart() {
  BYN_TRACE("== readStart\n");
  startIndex = getU32LEB();
}

void WasmBinaryBuilder::readMemory() {
  BYN_TRACE("== readMemory\n");
  auto numMemories = getU32LEB();
  if (!numMemories) {
    return;
  }
  if (numMemories != 1) {
    throwError("Must be exactly 1 memory");
  }
  if (wasm.memory.exists) {
    throwError("Memory cannot be both imported and defined");
  }
  wasm.memory.exists = true;
  getResizableLimits(wasm.memory.initial,
                     wasm.memory.max,
                     wasm.memory.shared,
                     Memory::kUnlimitedSize);
}

void WasmBinaryBuilder::readSignatures() {
  BYN_TRACE("== readSignatures\n");
  size_t numTypes = getU32LEB();
  BYN_TRACE("num: " << numTypes << std::endl);
  for (size_t i = 0; i < numTypes; i++) {
    BYN_TRACE("read one\n");
    std::vector<Type> params;
    std::vector<Type> results;
    auto form = getS32LEB();
    if (form != BinaryConsts::EncodedType::Func) {
      throwError("bad signature form " + std::to_string(form));
    }
    size_t numParams = getU32LEB();
    BYN_TRACE("num params: " << numParams << std::endl);
    for (size_t j = 0; j < numParams; j++) {
      params.push_back(getConcreteType());
    }
    auto numResults = getU32LEB();
    BYN_TRACE("num results: " << numResults << std::endl);
    for (size_t j = 0; j < numResults; j++) {
      results.push_back(getConcreteType());
    }
    signatures.emplace_back(Type(params), Type(results));
  }
}

Name WasmBinaryBuilder::getFunctionName(Index index) {
  if (index >= wasm.functions.size()) {
    throwError("invalid function index");
  }
  return wasm.functions[index]->name;
}

Name WasmBinaryBuilder::getGlobalName(Index index) {
  if (index >= wasm.globals.size()) {
    throwError("invalid global index");
  }
  return wasm.globals[index]->name;
}

Name WasmBinaryBuilder::getEventName(Index index) {
  if (index >= wasm.events.size()) {
    throwError("invalid event index");
  }
  return wasm.events[index]->name;
}

void WasmBinaryBuilder::getResizableLimits(Address& initial,
                                           Address& max,
                                           bool& shared,
                                           Address defaultIfNoMax) {
  auto flags = getU32LEB();
  initial = getU32LEB();
  bool hasMax = (flags & BinaryConsts::HasMaximum) != 0;
  bool isShared = (flags & BinaryConsts::IsShared) != 0;
  if (isShared && !hasMax) {
    throwError("shared memory must have max size");
  }
  shared = isShared;
  if (hasMax) {
    max = getU32LEB();
  } else {
    max = defaultIfNoMax;
  }
}

void WasmBinaryBuilder::readImports() {
  BYN_TRACE("== readImports\n");
  size_t num = getU32LEB();
  BYN_TRACE("num: " << num << std::endl);
  Builder builder(wasm);
  for (size_t i = 0; i < num; i++) {
    BYN_TRACE("read one\n");
    auto module = getInlineString();
    auto base = getInlineString();
    auto kind = (ExternalKind)getU32LEB();
    // We set a unique prefix for the name based on the kind. This ensures no
    // collisions between them, which can't occur here (due to the index i) but
    // could occur later due to the names section.
    switch (kind) {
      case ExternalKind::Function: {
        auto name = Name(std::string("fimport$") + std::to_string(i));
        auto index = getU32LEB();
        if (index >= signatures.size()) {
          throwError("invalid function index " + std::to_string(index) + " / " +
                     std::to_string(signatures.size()));
        }
        auto* curr = builder.makeFunction(name, signatures[index], {});
        curr->module = module;
        curr->base = base;
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
        if (elementType != BinaryConsts::EncodedType::funcref) {
          throwError("Imported table type is not funcref");
        }
        wasm.table.exists = true;
        bool is_shared;
        getResizableLimits(
          wasm.table.initial, wasm.table.max, is_shared, Table::kUnlimitedSize);
        if (is_shared) {
          throwError("Tables may not be shared");
        }
        break;
      }
      case ExternalKind::Memory: {
        wasm.memory.module = module;
        wasm.memory.base = base;
        wasm.memory.name = Name(std::to_string(i));
        wasm.memory.exists = true;
        getResizableLimits(wasm.memory.initial,
                           wasm.memory.max,
                           wasm.memory.shared,
                           Memory::kUnlimitedSize);
        break;
      }
      case ExternalKind::Global: {
        auto name = Name(std::string("gimport$") + std::to_string(i));
        auto type = getConcreteType();
        auto mutable_ = getU32LEB();
        auto* curr =
          builder.makeGlobal(name,
                             type,
                             nullptr,
                             mutable_ ? Builder::Mutable : Builder::Immutable);
        curr->module = module;
        curr->base = base;
        wasm.addGlobal(curr);
        break;
      }
      case ExternalKind::Event: {
        auto name = Name(std::string("eimport$") + std::to_string(i));
        auto attribute = getU32LEB();
        auto index = getU32LEB();
        if (index >= signatures.size()) {
          throwError("invalid event index " + std::to_string(index) + " / " +
                     std::to_string(signatures.size()));
        }
        auto* curr = builder.makeEvent(name, attribute, signatures[index]);
        curr->module = module;
        curr->base = base;
        wasm.addEvent(curr);
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
  BYN_TRACE("== readFunctionSignatures\n");
  size_t num = getU32LEB();
  BYN_TRACE("num: " << num << std::endl);
  for (size_t i = 0; i < num; i++) {
    BYN_TRACE("read one\n");
    auto index = getU32LEB();
    if (index >= signatures.size()) {
      throwError("invalid function type index for function");
    }
    functionSignatures.push_back(signatures[index]);
  }
}

void WasmBinaryBuilder::readFunctions() {
  BYN_TRACE("== readFunctions\n");
  size_t total = getU32LEB();
  if (total != functionSignatures.size()) {
    throwError("invalid function section size, must equal types");
  }
  for (size_t i = 0; i < total; i++) {
    BYN_TRACE("read one at " << pos << std::endl);
    auto sizePos = pos;
    size_t size = getU32LEB();
    if (size == 0) {
      throwError("empty function size");
    }
    endOfFunction = pos + size;

    auto* func = new Function;
    func->name = Name::fromInt(i);
    func->sig = functionSignatures[i];
    currFunction = func;

    if (DWARF) {
      func->funcLocation = BinaryLocations::FunctionLocations{
        BinaryLocation(sizePos - codeSectionLocation),
        BinaryLocation(pos - codeSectionLocation),
        BinaryLocation(pos - codeSectionLocation + size)};
    }

    readNextDebugLocation();

    BYN_TRACE("reading " << i << std::endl);
    size_t numLocalTypes = getU32LEB();
    for (size_t t = 0; t < numLocalTypes; t++) {
      auto num = getU32LEB();
      auto type = getConcreteType();
      while (num > 0) {
        func->vars.push_back(type);
        num--;
      }
    }
    std::swap(func->prologLocation, debugLocation);
    {
      // process the function body
      BYN_TRACE("processing function: " << i << std::endl);
      nextLabel = 0;
      debugLocation.clear();
      willBeIgnored = false;
      // process body
      assert(breakTargetNames.size() == 0);
      assert(breakStack.empty());
      assert(expressionStack.empty());
      assert(controlFlowStack.empty());
      assert(depth == 0);
      func->body = getBlockOrSingleton(func->sig.results);
      assert(depth == 0);
      assert(breakStack.size() == 0);
      assert(breakTargetNames.size() == 0);
      if (!expressionStack.empty()) {
        throwError("stack not empty on function exit");
      }
      assert(controlFlowStack.empty());
      if (pos != endOfFunction) {
        throwError("binary offset at function exit not at expected location");
      }
    }
    std::swap(func->epilogLocation, debugLocation);
    currFunction = nullptr;
    debugLocation.clear();
    functions.push_back(func);
  }
  BYN_TRACE(" end function bodies\n");
}

void WasmBinaryBuilder::readExports() {
  BYN_TRACE("== readExports\n");
  size_t num = getU32LEB();
  BYN_TRACE("num: " << num << std::endl);
  std::set<Name> names;
  for (size_t i = 0; i < num; i++) {
    BYN_TRACE("read one\n");
    auto curr = new Export;
    curr->name = getInlineString();
    if (names.count(curr->name) > 0) {
      throwError("duplicate export name");
    }
    names.insert(curr->name);
    curr->kind = (ExternalKind)getU32LEB();
    auto index = getU32LEB();
    exportIndices[curr] = index;
    exportOrder.push_back(curr);
  }
}

static int32_t readBase64VLQ(std::istream& in) {
  uint32_t value = 0;
  uint32_t shift = 0;
  while (1) {
    auto ch = in.get();
    if (ch == EOF) {
      throw MapParseException("unexpected EOF in the middle of VLQ");
    }
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

void WasmBinaryBuilder::readSourceMapHeader() {
  if (!sourceMap) {
    return;
  }

  auto skipWhitespace = [&]() {
    while (sourceMap->peek() == ' ' || sourceMap->peek() == '\n') {
      sourceMap->get();
    }
  };

  auto maybeReadChar = [&](char expected) {
    if (sourceMap->peek() != expected) {
      return false;
    }
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
      if (ch == EOF) {
        return false;
      }
      if (ch == '\"') {
        if (matching) {
          // we matched a terminating quote.
          if (pos == len) {
            break;
          }
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
        if (ch == '\"') {
          break;
        }
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
  uint32_t lineNumber =
    readBase64VLQ(*sourceMap) + 1; // adjust zero-based line number
  uint32_t columnNumber = readBase64VLQ(*sourceMap);
  nextDebugLocation = {position, {fileIndex, lineNumber, columnNumber}};
}

void WasmBinaryBuilder::readNextDebugLocation() {
  if (!sourceMap) {
    return;
  }

  while (nextDebugLocation.first && nextDebugLocation.first <= pos) {
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
    uint32_t columnNumber =
      nextDebugLocation.second.columnNumber + columnNumberDelta;

    nextDebugLocation = {position, {fileIndex, lineNumber, columnNumber}};
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
  BYN_TRACE("== readGlobals\n");
  size_t num = getU32LEB();
  BYN_TRACE("num: " << num << std::endl);
  for (size_t i = 0; i < num; i++) {
    BYN_TRACE("read one\n");
    auto type = getConcreteType();
    auto mutable_ = getU32LEB();
    if (mutable_ & ~1) {
      throwError("Global mutability must be 0 or 1");
    }
    auto* init = readExpression();
    wasm.addGlobal(
      Builder::makeGlobal("global$" + std::to_string(i),
                          type,
                          init,
                          mutable_ ? Builder::Mutable : Builder::Immutable));
  }
}

void WasmBinaryBuilder::processExpressions() {
  BYN_TRACE("== processExpressions\n");
  unreachableInTheWasmSense = false;
  while (1) {
    Expression* curr;
    auto ret = readExpression(curr);
    if (!curr) {
      lastSeparator = ret;
      BYN_TRACE("== processExpressions finished\n");
      return;
    }
    pushExpression(curr);
    if (curr->type == Type::unreachable) {
      // Once we see something unreachable, we don't want to add anything else
      // to the stack, as it could be stacky code that is non-representable in
      // our AST. but we do need to skip it.
      // If there is nothing else here, just stop. Otherwise, go into
      // unreachable mode. peek to see what to do.
      if (pos == endOfFunction) {
        throwError("Reached function end without seeing End opcode");
      }
      if (!more()) {
        throwError("unexpected end of input");
      }
      auto peek = input[pos];
      if (peek == BinaryConsts::End || peek == BinaryConsts::Else ||
          peek == BinaryConsts::Catch) {
        BYN_TRACE("== processExpressions finished with unreachable"
                  << std::endl);
        lastSeparator = BinaryConsts::ASTNodes(peek);
        // Read the byte we peeked at. No new instruction is generated for it.
        Expression* dummy = nullptr;
        readExpression(dummy);
        assert(!dummy);
        return;
      } else {
        skipUnreachableCode();
        return;
      }
    }
  }
}

void WasmBinaryBuilder::skipUnreachableCode() {
  BYN_TRACE("== skipUnreachableCode\n");
  // preserve the stack, and restore it. it contains the instruction that made
  // us unreachable, and we can ignore anything after it. things after it may
  // pop, we want to undo that
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
    // set the unreachableInTheWasmSense flag each time, as sub-blocks may set
    // and unset it
    unreachableInTheWasmSense = true;
    Expression* curr;
    auto ret = readExpression(curr);
    if (!curr) {
      BYN_TRACE("== skipUnreachableCode finished\n");
      lastSeparator = ret;
      unreachableInTheWasmSense = false;
      willBeIgnored = before;
      expressionStack = savedStack;
      return;
    }
    pushExpression(curr);
  }
}

void WasmBinaryBuilder::pushExpression(Expression* curr) {
  if (curr->type.isTuple()) {
    // Store tuple to local and push individual extracted values
    Builder builder(wasm);
    Index tuple = builder.addVar(currFunction, curr->type);
    expressionStack.push_back(builder.makeLocalSet(tuple, curr));
    for (Index i = 0; i < curr->type.size(); ++i) {
      expressionStack.push_back(
        builder.makeTupleExtract(builder.makeLocalGet(tuple, curr->type), i));
    }
  } else {
    expressionStack.push_back(curr);
  }
}

Expression* WasmBinaryBuilder::popExpression() {
  BYN_TRACE("== popExpression\n");
  if (expressionStack.empty()) {
    if (unreachableInTheWasmSense) {
      // in unreachable code, trying to pop past the polymorphic stack
      // area results in receiving unreachables
      BYN_TRACE("== popping unreachable from polymorphic stack" << std::endl);
      return allocator.alloc<Unreachable>();
    }
    throwError(
      "attempted pop from empty stack / beyond block start boundary at " +
      std::to_string(pos));
  }
  // the stack is not empty, and we would not be going out of the current block
  auto ret = expressionStack.back();
  assert(!ret->type.isTuple());
  expressionStack.pop_back();
  return ret;
}

Expression* WasmBinaryBuilder::popNonVoidExpression() {
  auto* ret = popExpression();
  if (ret->type != Type::none) {
    return ret;
  }
  // we found a void, so this is stacky code that we must handle carefully
  Builder builder(wasm);
  // add elements until we find a non-void
  std::vector<Expression*> expressions;
  expressions.push_back(ret);
  while (1) {
    auto* curr = popExpression();
    expressions.push_back(curr);
    if (curr->type != Type::none) {
      break;
    }
  }
  auto* block = builder.makeBlock();
  while (!expressions.empty()) {
    block->list.push_back(expressions.back());
    expressions.pop_back();
  }
  requireFunctionContext("popping void where we need a new local");
  auto type = block->list[0]->type;
  if (type.isConcrete()) {
    auto local = builder.addVar(currFunction, type);
    block->list[0] = builder.makeLocalSet(local, block->list[0]);
    block->list.push_back(builder.makeLocalGet(local, type));
  } else {
    assert(type == Type::unreachable);
    // nothing to do here - unreachable anyhow
  }
  block->finalize();
  return block;
}

Expression* WasmBinaryBuilder::popTuple(size_t numElems) {
  Builder builder(wasm);
  std::vector<Expression*> elements;
  elements.resize(numElems);
  for (size_t i = 0; i < numElems; i++) {
    auto* elem = popNonVoidExpression();
    if (elem->type == Type::unreachable) {
      // All the previously-popped items cannot be reached, so ignore them. We
      // cannot continue popping because there might not be enough items on the
      // expression stack after an unreachable expression. Any remaining
      // elements can stay unperturbed on the stack and will be explicitly
      // dropped by some parent call to pushBlockElements.
      return elem;
    }
    elements[numElems - i - 1] = elem;
  }
  return Builder(wasm).makeTupleMake(std::move(elements));
}

Expression* WasmBinaryBuilder::popTypedExpression(Type type) {
  if (type.isSingle()) {
    return popNonVoidExpression();
  } else if (type.isTuple()) {
    return popTuple(type.size());
  } else {
    WASM_UNREACHABLE("Invalid popped type");
  }
}

void WasmBinaryBuilder::validateBinary() {
  if (hasDataCount && wasm.memory.segments.size() != dataCount) {
    throwError("Number of segments does not agree with DataCount section");
  }
}

void WasmBinaryBuilder::processFunctions() {
  for (auto* func : functions) {
    wasm.addFunction(func);
  }

  // now that we have names for each function, apply things

  if (startIndex != static_cast<Index>(-1)) {
    wasm.start = getFunctionName(startIndex);
  }

  for (auto* curr : exportOrder) {
    auto index = exportIndices[curr];
    switch (curr->kind) {
      case ExternalKind::Function: {
        curr->value = getFunctionName(index);
        break;
      }
      case ExternalKind::Table:
        curr->value = Name::fromInt(0);
        break;
      case ExternalKind::Memory:
        curr->value = Name::fromInt(0);
        break;
      case ExternalKind::Global:
        curr->value = getGlobalName(index);
        break;
      case ExternalKind::Event:
        curr->value = getEventName(index);
        break;
      default:
        throwError("bad export kind");
    }
    wasm.addExport(curr);
  }

  for (auto& iter : functionRefs) {
    size_t index = iter.first;
    auto& refs = iter.second;
    for (auto* ref : refs) {
      if (auto* call = ref->dynCast<Call>()) {
        call->target = getFunctionName(index);
      } else if (auto* refFunc = ref->dynCast<RefFunc>()) {
        refFunc->func = getFunctionName(index);
      } else {
        WASM_UNREACHABLE("Invalid type in function references");
      }
    }
  }

  for (auto& pair : functionTable) {
    auto i = pair.first;
    auto& indices = pair.second;
    for (auto j : indices) {
      wasm.table.segments[i].data.push_back(getFunctionName(j));
    }
  }

  // Everything now has its proper name.

  wasm.updateMaps();
}

void WasmBinaryBuilder::readDataCount() {
  BYN_TRACE("== readDataCount\n");
  hasDataCount = true;
  dataCount = getU32LEB();
}

void WasmBinaryBuilder::readDataSegments() {
  BYN_TRACE("== readDataSegments\n");
  auto num = getU32LEB();
  for (size_t i = 0; i < num; i++) {
    Memory::Segment curr;
    uint32_t flags = getU32LEB();
    if (flags > 2) {
      throwError("bad segment flags, must be 0, 1, or 2, not " +
                 std::to_string(flags));
    }
    curr.isPassive = flags & BinaryConsts::IsPassive;
    if (flags & BinaryConsts::HasMemIndex) {
      auto memIndex = getU32LEB();
      if (memIndex != 0) {
        throwError("nonzero memory index");
      }
    }
    if (!curr.isPassive) {
      curr.offset = readExpression();
    }
    auto size = getU32LEB();
    curr.data.resize(size);
    for (size_t j = 0; j < size; j++) {
      curr.data[j] = char(getInt8());
    }
    wasm.memory.segments.push_back(curr);
  }
}

void WasmBinaryBuilder::readFunctionTableDeclaration() {
  BYN_TRACE("== readFunctionTableDeclaration\n");
  auto numTables = getU32LEB();
  if (numTables != 1) {
    throwError("Only 1 table definition allowed in MVP");
  }
  if (wasm.table.exists) {
    throwError("Table cannot be both imported and defined");
  }
  wasm.table.exists = true;
  auto elemType = getS32LEB();
  if (elemType != BinaryConsts::EncodedType::funcref) {
    throwError("ElementType must be funcref in MVP");
  }
  bool is_shared;
  getResizableLimits(
    wasm.table.initial, wasm.table.max, is_shared, Table::kUnlimitedSize);
  if (is_shared) {
    throwError("Tables may not be shared");
  }
}

void WasmBinaryBuilder::readTableElements() {
  BYN_TRACE("== readTableElements\n");
  auto numSegments = getU32LEB();
  if (numSegments >= Table::kMaxSize) {
    throwError("Too many segments");
  }
  for (size_t i = 0; i < numSegments; i++) {
    auto tableIndex = getU32LEB();
    if (tableIndex != 0) {
      throwError("Table elements must refer to table 0 in MVP");
    }
    wasm.table.segments.emplace_back(readExpression());

    auto& indexSegment = functionTable[i];
    auto size = getU32LEB();
    for (Index j = 0; j < size; j++) {
      indexSegment.push_back(getU32LEB());
    }
  }
}

void WasmBinaryBuilder::readEvents() {
  BYN_TRACE("== readEvents\n");
  size_t numEvents = getU32LEB();
  BYN_TRACE("num: " << numEvents << std::endl);
  for (size_t i = 0; i < numEvents; i++) {
    BYN_TRACE("read one\n");
    auto attribute = getU32LEB();
    auto typeIndex = getU32LEB();
    if (typeIndex >= signatures.size()) {
      throwError("invalid event index " + std::to_string(typeIndex) + " / " +
                 std::to_string(signatures.size()));
    }
    wasm.addEvent(Builder::makeEvent(
      "event$" + std::to_string(i), attribute, signatures[typeIndex]));
  }
}

static bool isIdChar(char ch) {
  return (ch >= '0' && ch <= '9') || (ch >= 'A' && ch <= 'Z') ||
         (ch >= 'a' && ch <= 'z') || ch == '!' || ch == '#' || ch == '$' ||
         ch == '%' || ch == '&' || ch == '\'' || ch == '*' || ch == '+' ||
         ch == '-' || ch == '.' || ch == '/' || ch == ':' || ch == '<' ||
         ch == '=' || ch == '>' || ch == '?' || ch == '@' || ch == '^' ||
         ch == '_' || ch == '`' || ch == '|' || ch == '~';
}

static char formatNibble(int nibble) {
  return nibble < 10 ? '0' + nibble : 'a' - 10 + nibble;
}

Name WasmBinaryBuilder::escape(Name name) {
  bool allIdChars = true;
  for (const char* p = name.str; allIdChars && *p; p++) {
    allIdChars = isIdChar(*p);
  }
  if (allIdChars) {
    return name;
  }
  // encode name, if at least one non-idchar (per WebAssembly spec) was found
  std::string escaped;
  for (const char* p = name.str; *p; p++) {
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
  return escaped;
}

void WasmBinaryBuilder::readNames(size_t payloadLen) {
  BYN_TRACE("== readNames\n");
  auto sectionPos = pos;
  while (pos < sectionPos + payloadLen) {
    auto nameType = getU32LEB();
    auto subsectionSize = getU32LEB();
    auto subsectionPos = pos;
    if (nameType != BinaryConsts::UserSections::Subsection::NameFunction) {
      // TODO: locals
      std::cerr << "warning: unknown name subsection at " << pos << std::endl;
      pos = subsectionPos + subsectionSize;
      continue;
    }
    auto num = getU32LEB();
    std::set<Name> usedNames;
    for (size_t i = 0; i < num; i++) {
      auto index = getU32LEB();
      auto rawName = getInlineString();
      rawName = escape(rawName);
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

void WasmBinaryBuilder::readFeatures(size_t payloadLen) {
  wasm.hasFeaturesSection = true;
  wasm.features = FeatureSet::MVP;

  auto sectionPos = pos;
  size_t numFeatures = getU32LEB();
  for (size_t i = 0; i < numFeatures; ++i) {
    uint8_t prefix = getInt8();
    if (prefix != BinaryConsts::FeatureUsed) {
      if (prefix == BinaryConsts::FeatureRequired) {
        std::cerr
          << "warning: required features in feature section are ignored";
      } else if (prefix == BinaryConsts::FeatureDisallowed) {
        std::cerr
          << "warning: disallowed features in feature section are ignored";
      } else {
        throwError("Unrecognized feature policy prefix");
      }
    }

    Name name = getInlineString();
    if (pos > sectionPos + payloadLen) {
      throwError("ill-formed string extends beyond section");
    }

    if (prefix != BinaryConsts::FeatureDisallowed) {
      if (name == BinaryConsts::UserSections::AtomicsFeature) {
        wasm.features.setAtomics();
      } else if (name == BinaryConsts::UserSections::BulkMemoryFeature) {
        wasm.features.setBulkMemory();
      } else if (name == BinaryConsts::UserSections::ExceptionHandlingFeature) {
        wasm.features.setExceptionHandling();
      } else if (name == BinaryConsts::UserSections::MutableGlobalsFeature) {
        wasm.features.setMutableGlobals();
      } else if (name == BinaryConsts::UserSections::TruncSatFeature) {
        wasm.features.setTruncSat();
      } else if (name == BinaryConsts::UserSections::SignExtFeature) {
        wasm.features.setSignExt();
      } else if (name == BinaryConsts::UserSections::SIMD128Feature) {
        wasm.features.setSIMD();
      } else if (name == BinaryConsts::UserSections::TailCallFeature) {
        wasm.features.setTailCall();
      } else if (name == BinaryConsts::UserSections::ReferenceTypesFeature) {
        wasm.features.setReferenceTypes();
      } else if (name == BinaryConsts::UserSections::MultivalueFeature) {
        wasm.features.setMultivalue();
      } else if (name == BinaryConsts::UserSections::AnyrefFeature) {
        wasm.features.setAnyref();
      }
    }
  }
  if (pos != sectionPos + payloadLen) {
    throwError("bad features section size");
  }
}

void WasmBinaryBuilder::readDylink(size_t payloadLen) {
  wasm.dylinkSection = make_unique<DylinkSection>();

  auto sectionPos = pos;

  wasm.dylinkSection->memorySize = getU32LEB();
  wasm.dylinkSection->memoryAlignment = getU32LEB();
  wasm.dylinkSection->tableSize = getU32LEB();
  wasm.dylinkSection->tableAlignment = getU32LEB();

  size_t numNeededDynlibs = getU32LEB();
  for (size_t i = 0; i < numNeededDynlibs; ++i) {
    wasm.dylinkSection->neededDynlibs.push_back(getInlineString());
  }

  if (pos != sectionPos + payloadLen) {
    throwError("bad features section size");
  }
}

BinaryConsts::ASTNodes WasmBinaryBuilder::readExpression(Expression*& curr) {
  if (pos == endOfFunction) {
    throwError("Reached function end without seeing End opcode");
  }
  BYN_TRACE("zz recurse into " << ++depth << " at " << pos << std::endl);
  readNextDebugLocation();
  std::set<Function::DebugLocation> currDebugLocation;
  if (debugLocation.size()) {
    currDebugLocation.insert(*debugLocation.begin());
  }
  size_t startPos = pos;
  uint8_t code = getInt8();
  BYN_TRACE("readExpression seeing " << (int)code << std::endl);
  switch (code) {
    case BinaryConsts::Block:
      visitBlock((curr = allocator.alloc<Block>())->cast<Block>());
      break;
    case BinaryConsts::If:
      visitIf((curr = allocator.alloc<If>())->cast<If>());
      break;
    case BinaryConsts::Loop:
      visitLoop((curr = allocator.alloc<Loop>())->cast<Loop>());
      break;
    case BinaryConsts::Br:
    case BinaryConsts::BrIf:
      visitBreak((curr = allocator.alloc<Break>())->cast<Break>(), code);
      break; // code distinguishes br from br_if
    case BinaryConsts::BrTable:
      visitSwitch((curr = allocator.alloc<Switch>())->cast<Switch>());
      break;
    case BinaryConsts::CallFunction:
      visitCall((curr = allocator.alloc<Call>())->cast<Call>());
      break;
    case BinaryConsts::CallIndirect:
      visitCallIndirect(
        (curr = allocator.alloc<CallIndirect>())->cast<CallIndirect>());
      break;
    case BinaryConsts::RetCallFunction: {
      auto call = allocator.alloc<Call>();
      call->isReturn = true;
      curr = call;
      visitCall(call);
      break;
    }
    case BinaryConsts::RetCallIndirect: {
      auto call = allocator.alloc<CallIndirect>();
      call->isReturn = true;
      curr = call;
      visitCallIndirect(call);
      break;
    }
    case BinaryConsts::LocalGet:
      visitLocalGet((curr = allocator.alloc<LocalGet>())->cast<LocalGet>());
      break;
    case BinaryConsts::LocalTee:
    case BinaryConsts::LocalSet:
      visitLocalSet((curr = allocator.alloc<LocalSet>())->cast<LocalSet>(),
                    code);
      break;
    case BinaryConsts::GlobalGet:
      visitGlobalGet((curr = allocator.alloc<GlobalGet>())->cast<GlobalGet>());
      break;
    case BinaryConsts::GlobalSet:
      visitGlobalSet((curr = allocator.alloc<GlobalSet>())->cast<GlobalSet>());
      break;
    case BinaryConsts::Select:
    case BinaryConsts::SelectWithType:
      visitSelect((curr = allocator.alloc<Select>())->cast<Select>(), code);
      break;
    case BinaryConsts::Return:
      visitReturn((curr = allocator.alloc<Return>())->cast<Return>());
      break;
    case BinaryConsts::Nop:
      visitNop((curr = allocator.alloc<Nop>())->cast<Nop>());
      break;
    case BinaryConsts::Unreachable:
      visitUnreachable(
        (curr = allocator.alloc<Unreachable>())->cast<Unreachable>());
      break;
    case BinaryConsts::Drop:
      visitDrop((curr = allocator.alloc<Drop>())->cast<Drop>());
      break;
    case BinaryConsts::End:
      curr = nullptr;
      continueControlFlow(BinaryLocations::End, startPos);
      break;
    case BinaryConsts::Else:
      curr = nullptr;
      continueControlFlow(BinaryLocations::Else, startPos);
      break;
    case BinaryConsts::Catch:
      curr = nullptr;
      continueControlFlow(BinaryLocations::Catch, startPos);
      break;
    case BinaryConsts::RefNull:
      visitRefNull((curr = allocator.alloc<RefNull>())->cast<RefNull>());
      break;
    case BinaryConsts::RefIsNull:
      visitRefIsNull((curr = allocator.alloc<RefIsNull>())->cast<RefIsNull>());
      break;
    case BinaryConsts::RefFunc:
      visitRefFunc((curr = allocator.alloc<RefFunc>())->cast<RefFunc>());
      break;
    case BinaryConsts::Try:
      visitTry((curr = allocator.alloc<Try>())->cast<Try>());
      break;
    case BinaryConsts::Throw:
      visitThrow((curr = allocator.alloc<Throw>())->cast<Throw>());
      break;
    case BinaryConsts::Rethrow:
      visitRethrow((curr = allocator.alloc<Rethrow>())->cast<Rethrow>());
      break;
    case BinaryConsts::BrOnExn:
      visitBrOnExn((curr = allocator.alloc<BrOnExn>())->cast<BrOnExn>());
      break;
    case BinaryConsts::AtomicPrefix: {
      code = static_cast<uint8_t>(getU32LEB());
      if (maybeVisitLoad(curr, code, /*isAtomic=*/true)) {
        break;
      }
      if (maybeVisitStore(curr, code, /*isAtomic=*/true)) {
        break;
      }
      if (maybeVisitAtomicRMW(curr, code)) {
        break;
      }
      if (maybeVisitAtomicCmpxchg(curr, code)) {
        break;
      }
      if (maybeVisitAtomicWait(curr, code)) {
        break;
      }
      if (maybeVisitAtomicNotify(curr, code)) {
        break;
      }
      if (maybeVisitAtomicFence(curr, code)) {
        break;
      }
      throwError("invalid code after atomic prefix: " + std::to_string(code));
      break;
    }
    case BinaryConsts::MiscPrefix: {
      auto opcode = getU32LEB();
      if (maybeVisitTruncSat(curr, opcode)) {
        break;
      }
      if (maybeVisitMemoryInit(curr, opcode)) {
        break;
      }
      if (maybeVisitDataDrop(curr, opcode)) {
        break;
      }
      if (maybeVisitMemoryCopy(curr, opcode)) {
        break;
      }
      if (maybeVisitMemoryFill(curr, opcode)) {
        break;
      }
      throwError("invalid code after nontrapping float-to-int prefix: " +
                 std::to_string(opcode));
      break;
    }
    case BinaryConsts::SIMDPrefix: {
      auto opcode = getU32LEB();
      if (maybeVisitSIMDBinary(curr, opcode)) {
        break;
      }
      if (maybeVisitSIMDUnary(curr, opcode)) {
        break;
      }
      if (maybeVisitSIMDConst(curr, opcode)) {
        break;
      }
      if (maybeVisitSIMDStore(curr, opcode)) {
        break;
      }
      if (maybeVisitSIMDExtract(curr, opcode)) {
        break;
      }
      if (maybeVisitSIMDReplace(curr, opcode)) {
        break;
      }
      if (maybeVisitSIMDShuffle(curr, opcode)) {
        break;
      }
      if (maybeVisitSIMDTernary(curr, opcode)) {
        break;
      }
      if (maybeVisitSIMDShift(curr, opcode)) {
        break;
      }
      if (maybeVisitSIMDLoad(curr, opcode)) {
        break;
      }
      throwError("invalid code after SIMD prefix: " + std::to_string(opcode));
      break;
    }
    default: {
      // otherwise, the code is a subcode TODO: optimize
      if (maybeVisitBinary(curr, code)) {
        break;
      }
      if (maybeVisitUnary(curr, code)) {
        break;
      }
      if (maybeVisitConst(curr, code)) {
        break;
      }
      if (maybeVisitLoad(curr, code, /*isAtomic=*/false)) {
        break;
      }
      if (maybeVisitStore(curr, code, /*isAtomic=*/false)) {
        break;
      }
      if (maybeVisitHost(curr, code)) {
        break;
      }
      throwError("bad node code " + std::to_string(code));
      break;
    }
  }
  if (curr) {
    if (currDebugLocation.size()) {
      currFunction->debugLocations[curr] = *currDebugLocation.begin();
    }
    if (DWARF && currFunction) {
      currFunction->expressionLocations[curr] =
        BinaryLocations::Span{BinaryLocation(startPos - codeSectionLocation),
                              BinaryLocation(pos - codeSectionLocation)};
    }
  }
  BYN_TRACE("zz recurse from " << depth-- << " at " << pos << std::endl);
  return BinaryConsts::ASTNodes(code);
}

void WasmBinaryBuilder::startControlFlow(Expression* curr) {
  if (DWARF && currFunction) {
    controlFlowStack.push_back(curr);
  }
}

void WasmBinaryBuilder::continueControlFlow(BinaryLocations::DelimiterId id,
                                            BinaryLocation pos) {
  if (DWARF && currFunction) {
    if (controlFlowStack.empty()) {
      // We reached the end of the function, which is also marked with an
      // "end", like a control flow structure.
      assert(id == BinaryLocations::End);
      assert(pos + 1 == endOfFunction);
      return;
    }
    assert(!controlFlowStack.empty());
    auto currControlFlow = controlFlowStack.back();
    // We are called after parsing the byte, so we need to subtract one to
    // get its position.
    currFunction->delimiterLocations[currControlFlow][id] =
      pos - codeSectionLocation;
    if (id == BinaryLocations::End) {
      controlFlowStack.pop_back();
    }
  }
}

void WasmBinaryBuilder::pushBlockElements(Block* curr,
                                          Type type,
                                          size_t start) {
  assert(start <= expressionStack.size());
  // The results of this block are the last values pushed to the expressionStack
  Expression* results = nullptr;
  if (type.isConcrete()) {
    results = popTypedExpression(type);
  }
  if (expressionStack.size() < start) {
    throwError("Block requires more values than are available");
  }
  // Everything else on the stack after `start` is either a none-type expression
  // or a concretely-type expression that is implicitly dropped due to
  // unreachability at the end of the block, like this:
  //
  //  block i32
  //   i32.const 1
  //   i32.const 2
  //   i32.const 3
  //   return
  //  end
  //
  // The first two const elements will be emitted as drops in the block (the
  // optimizer can remove them, of course, but in general we may need dropped
  // items here as they may have side effects).
  //
  for (size_t i = start; i < expressionStack.size(); ++i) {
    auto* item = expressionStack[i];
    if (item->type.isConcrete()) {
      item = Builder(wasm).makeDrop(item);
    }
    curr->list.push_back(item);
  }
  expressionStack.resize(start);
  if (results != nullptr) {
    curr->list.push_back(results);
  }
}

void WasmBinaryBuilder::visitBlock(Block* curr) {
  BYN_TRACE("zz node: Block\n");
  startControlFlow(curr);
  // special-case Block and de-recurse nested blocks in their first position, as
  // that is a common pattern that can be very highly nested.
  std::vector<Block*> stack;
  while (1) {
    curr->type = getType();
    curr->name = getNextLabel();
    breakStack.push_back({curr->name, curr->type});
    stack.push_back(curr);
    if (more() && input[pos] == BinaryConsts::Block) {
      // a recursion
      readNextDebugLocation();
      curr = allocator.alloc<Block>();
      startControlFlow(curr);
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
    // everything after this, that is left when we see the marker, is ours
    size_t start = expressionStack.size();
    if (last) {
      // the previous block is our first-position element
      pushExpression(last);
    }
    last = curr;
    processExpressions();
    size_t end = expressionStack.size();
    if (end < start) {
      throwError("block cannot pop from outside");
    }
    pushBlockElements(curr, curr->type, start);
    curr->finalize(curr->type,
                   breakTargetNames.find(curr->name) !=
                     breakTargetNames.end() /* hasBreak */);
    breakStack.pop_back();
    breakTargetNames.erase(curr->name);
  }
}

// Gets a block of expressions. If it's just one, return that singleton.
// numPops is the number of pop instructions we add before starting to parse the
// block. Can be used when we need to assume certain number of values are on top
// of the stack in the beginning.
Expression* WasmBinaryBuilder::getBlockOrSingleton(Type type,
                                                   unsigned numPops) {
  Name label = getNextLabel();
  breakStack.push_back({label, type});
  auto start = expressionStack.size();

  Builder builder(wasm);
  for (unsigned i = 0; i < numPops; i++) {
    auto* pop = builder.makePop(Type::exnref);
    pushExpression(pop);
  }

  processExpressions();
  size_t end = expressionStack.size();
  if (end < start) {
    throwError("block cannot pop from outside");
  }
  breakStack.pop_back();
  auto* block = allocator.alloc<Block>();
  pushBlockElements(block, type, start);
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
  BYN_TRACE("zz node: If\n");
  startControlFlow(curr);
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
  BYN_TRACE("zz node: Loop\n");
  startControlFlow(curr);
  curr->type = getType();
  curr->name = getNextLabel();
  breakStack.push_back({curr->name, Type::none});
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
    pushBlockElements(block, curr->type, start);
    block->finalize(curr->type);
    curr->body = block;
  }
  breakStack.pop_back();
  breakTargetNames.erase(curr->name);
  curr->finalize(curr->type);
}

WasmBinaryBuilder::BreakTarget
WasmBinaryBuilder::getBreakTarget(int32_t offset) {
  BYN_TRACE("getBreakTarget " << offset << std::endl);
  if (breakStack.size() < 1 + size_t(offset)) {
    throwError("bad breakindex (low)");
  }
  size_t index = breakStack.size() - 1 - offset;
  if (index >= breakStack.size()) {
    throwError("bad breakindex (high)");
  }
  BYN_TRACE("breaktarget " << breakStack[index].name << " type "
                           << breakStack[index].type << std::endl);
  auto& ret = breakStack[index];
  // if the break is in literally unreachable code, then we will not emit it
  // anyhow, so do not note that the target has breaks to it
  if (!willBeIgnored) {
    breakTargetNames.insert(ret.name);
  }
  return ret;
}

void WasmBinaryBuilder::visitBreak(Break* curr, uint8_t code) {
  BYN_TRACE("zz node: Break, code " << int32_t(code) << std::endl);
  BreakTarget target = getBreakTarget(getU32LEB());
  curr->name = target.name;
  if (code == BinaryConsts::BrIf) {
    curr->condition = popNonVoidExpression();
  }
  if (target.type.isConcrete()) {
    curr->value = popTypedExpression(target.type);
  }
  curr->finalize();
}

void WasmBinaryBuilder::visitSwitch(Switch* curr) {
  BYN_TRACE("zz node: Switch\n");
  curr->condition = popNonVoidExpression();
  auto numTargets = getU32LEB();
  BYN_TRACE("targets: " << numTargets << std::endl);
  for (size_t i = 0; i < numTargets; i++) {
    curr->targets.push_back(getBreakTarget(getU32LEB()).name);
  }
  auto defaultTarget = getBreakTarget(getU32LEB());
  curr->default_ = defaultTarget.name;
  BYN_TRACE("default: " << curr->default_ << "\n");
  if (defaultTarget.type.isConcrete()) {
    curr->value = popTypedExpression(defaultTarget.type);
  }
  curr->finalize();
}

void WasmBinaryBuilder::visitCall(Call* curr) {
  BYN_TRACE("zz node: Call\n");
  auto index = getU32LEB();
  Signature sig;
  if (index < functionImports.size()) {
    auto* import = functionImports[index];
    sig = import->sig;
  } else {
    Index adjustedIndex = index - functionImports.size();
    if (adjustedIndex >= functionSignatures.size()) {
      throwError("invalid call index");
    }
    sig = functionSignatures[adjustedIndex];
  }
  auto num = sig.params.size();
  curr->operands.resize(num);
  for (size_t i = 0; i < num; i++) {
    curr->operands[num - i - 1] = popNonVoidExpression();
  }
  curr->type = sig.results;
  functionRefs[index].push_back(curr); // we don't know function names yet
  curr->finalize();
}

void WasmBinaryBuilder::visitCallIndirect(CallIndirect* curr) {
  BYN_TRACE("zz node: CallIndirect\n");
  auto index = getU32LEB();
  if (index >= signatures.size()) {
    throwError("bad call_indirect function index");
  }
  curr->sig = signatures[index];
  auto reserved = getU32LEB();
  if (reserved != 0) {
    throwError("Invalid flags field in call_indirect");
  }
  auto num = curr->sig.params.size();
  curr->operands.resize(num);
  curr->target = popNonVoidExpression();
  for (size_t i = 0; i < num; i++) {
    curr->operands[num - i - 1] = popNonVoidExpression();
  }
  curr->finalize();
}

void WasmBinaryBuilder::visitLocalGet(LocalGet* curr) {
  BYN_TRACE("zz node: LocalGet " << pos << std::endl);
  ;
  requireFunctionContext("local.get");
  curr->index = getU32LEB();
  if (curr->index >= currFunction->getNumLocals()) {
    throwError("bad local.get index");
  }
  curr->type = currFunction->getLocalType(curr->index);
  curr->finalize();
}

void WasmBinaryBuilder::visitLocalSet(LocalSet* curr, uint8_t code) {
  BYN_TRACE("zz node: Set|LocalTee\n");
  requireFunctionContext("local.set outside of function");
  curr->index = getU32LEB();
  if (curr->index >= currFunction->getNumLocals()) {
    throwError("bad local.set index");
  }
  curr->value = popNonVoidExpression();
  if (code == BinaryConsts::LocalTee) {
    curr->makeTee(currFunction->getLocalType(curr->index));
  } else {
    curr->makeSet();
  }
  curr->finalize();
}

void WasmBinaryBuilder::visitGlobalGet(GlobalGet* curr) {
  BYN_TRACE("zz node: GlobalGet " << pos << std::endl);
  auto index = getU32LEB();
  curr->name = getGlobalName(index);
  curr->type = wasm.getGlobal(curr->name)->type;
}

void WasmBinaryBuilder::visitGlobalSet(GlobalSet* curr) {
  BYN_TRACE("zz node: GlobalSet\n");
  auto index = getU32LEB();
  curr->name = getGlobalName(index);
  curr->value = popNonVoidExpression();
  curr->finalize();
}

void WasmBinaryBuilder::readMemoryAccess(Address& alignment, Address& offset) {
  auto rawAlignment = getU32LEB();
  if (rawAlignment > 4) {
    throwError("Alignment must be of a reasonable size");
  }
  alignment = Pow2(rawAlignment);
  offset = getU32LEB();
}

bool WasmBinaryBuilder::maybeVisitLoad(Expression*& out,
                                       uint8_t code,
                                       bool isAtomic) {
  Load* curr;
  if (!isAtomic) {
    switch (code) {
      case BinaryConsts::I32LoadMem8S:
        curr = allocator.alloc<Load>();
        curr->bytes = 1;
        curr->type = Type::i32;
        curr->signed_ = true;
        break;
      case BinaryConsts::I32LoadMem8U:
        curr = allocator.alloc<Load>();
        curr->bytes = 1;
        curr->type = Type::i32;
        curr->signed_ = false;
        break;
      case BinaryConsts::I32LoadMem16S:
        curr = allocator.alloc<Load>();
        curr->bytes = 2;
        curr->type = Type::i32;
        curr->signed_ = true;
        break;
      case BinaryConsts::I32LoadMem16U:
        curr = allocator.alloc<Load>();
        curr->bytes = 2;
        curr->type = Type::i32;
        curr->signed_ = false;
        break;
      case BinaryConsts::I32LoadMem:
        curr = allocator.alloc<Load>();
        curr->bytes = 4;
        curr->type = Type::i32;
        break;
      case BinaryConsts::I64LoadMem8S:
        curr = allocator.alloc<Load>();
        curr->bytes = 1;
        curr->type = Type::i64;
        curr->signed_ = true;
        break;
      case BinaryConsts::I64LoadMem8U:
        curr = allocator.alloc<Load>();
        curr->bytes = 1;
        curr->type = Type::i64;
        curr->signed_ = false;
        break;
      case BinaryConsts::I64LoadMem16S:
        curr = allocator.alloc<Load>();
        curr->bytes = 2;
        curr->type = Type::i64;
        curr->signed_ = true;
        break;
      case BinaryConsts::I64LoadMem16U:
        curr = allocator.alloc<Load>();
        curr->bytes = 2;
        curr->type = Type::i64;
        curr->signed_ = false;
        break;
      case BinaryConsts::I64LoadMem32S:
        curr = allocator.alloc<Load>();
        curr->bytes = 4;
        curr->type = Type::i64;
        curr->signed_ = true;
        break;
      case BinaryConsts::I64LoadMem32U:
        curr = allocator.alloc<Load>();
        curr->bytes = 4;
        curr->type = Type::i64;
        curr->signed_ = false;
        break;
      case BinaryConsts::I64LoadMem:
        curr = allocator.alloc<Load>();
        curr->bytes = 8;
        curr->type = Type::i64;
        break;
      case BinaryConsts::F32LoadMem:
        curr = allocator.alloc<Load>();
        curr->bytes = 4;
        curr->type = Type::f32;
        break;
      case BinaryConsts::F64LoadMem:
        curr = allocator.alloc<Load>();
        curr->bytes = 8;
        curr->type = Type::f64;
        break;
      default:
        return false;
    }
    BYN_TRACE("zz node: Load\n");
  } else {
    switch (code) {
      case BinaryConsts::I32AtomicLoad8U:
        curr = allocator.alloc<Load>();
        curr->bytes = 1;
        curr->type = Type::i32;
        break;
      case BinaryConsts::I32AtomicLoad16U:
        curr = allocator.alloc<Load>();
        curr->bytes = 2;
        curr->type = Type::i32;
        break;
      case BinaryConsts::I32AtomicLoad:
        curr = allocator.alloc<Load>();
        curr->bytes = 4;
        curr->type = Type::i32;
        break;
      case BinaryConsts::I64AtomicLoad8U:
        curr = allocator.alloc<Load>();
        curr->bytes = 1;
        curr->type = Type::i64;
        break;
      case BinaryConsts::I64AtomicLoad16U:
        curr = allocator.alloc<Load>();
        curr->bytes = 2;
        curr->type = Type::i64;
        break;
      case BinaryConsts::I64AtomicLoad32U:
        curr = allocator.alloc<Load>();
        curr->bytes = 4;
        curr->type = Type::i64;
        break;
      case BinaryConsts::I64AtomicLoad:
        curr = allocator.alloc<Load>();
        curr->bytes = 8;
        curr->type = Type::i64;
        break;
      default:
        return false;
    }
    curr->signed_ = false;
    BYN_TRACE("zz node: AtomicLoad\n");
  }

  curr->isAtomic = isAtomic;
  readMemoryAccess(curr->align, curr->offset);
  curr->ptr = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitStore(Expression*& out,
                                        uint8_t code,
                                        bool isAtomic) {
  Store* curr;
  if (!isAtomic) {
    switch (code) {
      case BinaryConsts::I32StoreMem8:
        curr = allocator.alloc<Store>();
        curr->bytes = 1;
        curr->valueType = Type::i32;
        break;
      case BinaryConsts::I32StoreMem16:
        curr = allocator.alloc<Store>();
        curr->bytes = 2;
        curr->valueType = Type::i32;
        break;
      case BinaryConsts::I32StoreMem:
        curr = allocator.alloc<Store>();
        curr->bytes = 4;
        curr->valueType = Type::i32;
        break;
      case BinaryConsts::I64StoreMem8:
        curr = allocator.alloc<Store>();
        curr->bytes = 1;
        curr->valueType = Type::i64;
        break;
      case BinaryConsts::I64StoreMem16:
        curr = allocator.alloc<Store>();
        curr->bytes = 2;
        curr->valueType = Type::i64;
        break;
      case BinaryConsts::I64StoreMem32:
        curr = allocator.alloc<Store>();
        curr->bytes = 4;
        curr->valueType = Type::i64;
        break;
      case BinaryConsts::I64StoreMem:
        curr = allocator.alloc<Store>();
        curr->bytes = 8;
        curr->valueType = Type::i64;
        break;
      case BinaryConsts::F32StoreMem:
        curr = allocator.alloc<Store>();
        curr->bytes = 4;
        curr->valueType = Type::f32;
        break;
      case BinaryConsts::F64StoreMem:
        curr = allocator.alloc<Store>();
        curr->bytes = 8;
        curr->valueType = Type::f64;
        break;
      default:
        return false;
    }
  } else {
    switch (code) {
      case BinaryConsts::I32AtomicStore8:
        curr = allocator.alloc<Store>();
        curr->bytes = 1;
        curr->valueType = Type::i32;
        break;
      case BinaryConsts::I32AtomicStore16:
        curr = allocator.alloc<Store>();
        curr->bytes = 2;
        curr->valueType = Type::i32;
        break;
      case BinaryConsts::I32AtomicStore:
        curr = allocator.alloc<Store>();
        curr->bytes = 4;
        curr->valueType = Type::i32;
        break;
      case BinaryConsts::I64AtomicStore8:
        curr = allocator.alloc<Store>();
        curr->bytes = 1;
        curr->valueType = Type::i64;
        break;
      case BinaryConsts::I64AtomicStore16:
        curr = allocator.alloc<Store>();
        curr->bytes = 2;
        curr->valueType = Type::i64;
        break;
      case BinaryConsts::I64AtomicStore32:
        curr = allocator.alloc<Store>();
        curr->bytes = 4;
        curr->valueType = Type::i64;
        break;
      case BinaryConsts::I64AtomicStore:
        curr = allocator.alloc<Store>();
        curr->bytes = 8;
        curr->valueType = Type::i64;
        break;
      default:
        return false;
    }
  }

  curr->isAtomic = isAtomic;
  BYN_TRACE("zz node: Store\n");
  readMemoryAccess(curr->align, curr->offset);
  curr->value = popNonVoidExpression();
  curr->ptr = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitAtomicRMW(Expression*& out, uint8_t code) {
  if (code < BinaryConsts::AtomicRMWOps_Begin ||
      code > BinaryConsts::AtomicRMWOps_End) {
    return false;
  }
  auto* curr = allocator.alloc<AtomicRMW>();

  // Set curr to the given opcode, type and size.
#define SET(opcode, optype, size)                                              \
  curr->op = opcode;                                                           \
  curr->type = optype;                                                         \
  curr->bytes = size

  // Handle the cases for all the valid types for a particular opcode
#define SET_FOR_OP(Op)                                                         \
  case BinaryConsts::I32AtomicRMW##Op:                                         \
    SET(Op, Type::i32, 4);                                                     \
    break;                                                                     \
  case BinaryConsts::I32AtomicRMW##Op##8U:                                     \
    SET(Op, Type::i32, 1);                                                     \
    break;                                                                     \
  case BinaryConsts::I32AtomicRMW##Op##16U:                                    \
    SET(Op, Type::i32, 2);                                                     \
    break;                                                                     \
  case BinaryConsts::I64AtomicRMW##Op:                                         \
    SET(Op, Type::i64, 8);                                                     \
    break;                                                                     \
  case BinaryConsts::I64AtomicRMW##Op##8U:                                     \
    SET(Op, Type::i64, 1);                                                     \
    break;                                                                     \
  case BinaryConsts::I64AtomicRMW##Op##16U:                                    \
    SET(Op, Type::i64, 2);                                                     \
    break;                                                                     \
  case BinaryConsts::I64AtomicRMW##Op##32U:                                    \
    SET(Op, Type::i64, 4);                                                     \
    break;

  switch (code) {
    SET_FOR_OP(Add);
    SET_FOR_OP(Sub);
    SET_FOR_OP(And);
    SET_FOR_OP(Or);
    SET_FOR_OP(Xor);
    SET_FOR_OP(Xchg);
    default:
      WASM_UNREACHABLE("unexpected opcode");
  }
#undef SET_FOR_OP
#undef SET

  BYN_TRACE("zz node: AtomicRMW\n");
  Address readAlign;
  readMemoryAccess(readAlign, curr->offset);
  if (readAlign != curr->bytes) {
    throwError("Align of AtomicRMW must match size");
  }
  curr->value = popNonVoidExpression();
  curr->ptr = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitAtomicCmpxchg(Expression*& out,
                                                uint8_t code) {
  if (code < BinaryConsts::AtomicCmpxchgOps_Begin ||
      code > BinaryConsts::AtomicCmpxchgOps_End) {
    return false;
  }
  auto* curr = allocator.alloc<AtomicCmpxchg>();

  // Set curr to the given type and size.
#define SET(optype, size)                                                      \
  curr->type = optype;                                                         \
  curr->bytes = size

  switch (code) {
    case BinaryConsts::I32AtomicCmpxchg:
      SET(Type::i32, 4);
      break;
    case BinaryConsts::I64AtomicCmpxchg:
      SET(Type::i64, 8);
      break;
    case BinaryConsts::I32AtomicCmpxchg8U:
      SET(Type::i32, 1);
      break;
    case BinaryConsts::I32AtomicCmpxchg16U:
      SET(Type::i32, 2);
      break;
    case BinaryConsts::I64AtomicCmpxchg8U:
      SET(Type::i64, 1);
      break;
    case BinaryConsts::I64AtomicCmpxchg16U:
      SET(Type::i64, 2);
      break;
    case BinaryConsts::I64AtomicCmpxchg32U:
      SET(Type::i64, 4);
      break;
    default:
      WASM_UNREACHABLE("unexpected opcode");
  }

  BYN_TRACE("zz node: AtomicCmpxchg\n");
  Address readAlign;
  readMemoryAccess(readAlign, curr->offset);
  if (readAlign != curr->bytes) {
    throwError("Align of AtomicCpxchg must match size");
  }
  curr->replacement = popNonVoidExpression();
  curr->expected = popNonVoidExpression();
  curr->ptr = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitAtomicWait(Expression*& out, uint8_t code) {
  if (code < BinaryConsts::I32AtomicWait ||
      code > BinaryConsts::I64AtomicWait) {
    return false;
  }
  auto* curr = allocator.alloc<AtomicWait>();

  switch (code) {
    case BinaryConsts::I32AtomicWait:
      curr->expectedType = Type::i32;
      break;
    case BinaryConsts::I64AtomicWait:
      curr->expectedType = Type::i64;
      break;
    default:
      WASM_UNREACHABLE("unexpected opcode");
  }
  curr->type = Type::i32;
  BYN_TRACE("zz node: AtomicWait\n");
  curr->timeout = popNonVoidExpression();
  curr->expected = popNonVoidExpression();
  curr->ptr = popNonVoidExpression();
  Address readAlign;
  readMemoryAccess(readAlign, curr->offset);
  if (readAlign != curr->expectedType.getByteSize()) {
    throwError("Align of AtomicWait must match size");
  }
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitAtomicNotify(Expression*& out, uint8_t code) {
  if (code != BinaryConsts::AtomicNotify) {
    return false;
  }
  auto* curr = allocator.alloc<AtomicNotify>();
  BYN_TRACE("zz node: AtomicNotify\n");

  curr->type = Type::i32;
  curr->notifyCount = popNonVoidExpression();
  curr->ptr = popNonVoidExpression();
  Address readAlign;
  readMemoryAccess(readAlign, curr->offset);
  if (readAlign != curr->type.getByteSize()) {
    throwError("Align of AtomicNotify must match size");
  }
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitAtomicFence(Expression*& out, uint8_t code) {
  if (code != BinaryConsts::AtomicFence) {
    return false;
  }
  auto* curr = allocator.alloc<AtomicFence>();
  BYN_TRACE("zz node: AtomicFence\n");
  curr->order = getU32LEB();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitConst(Expression*& out, uint8_t code) {
  Const* curr;
  BYN_TRACE("zz node: Const, code " << code << std::endl);
  switch (code) {
    case BinaryConsts::I32Const:
      curr = allocator.alloc<Const>();
      curr->value = Literal(getS32LEB());
      break;
    case BinaryConsts::I64Const:
      curr = allocator.alloc<Const>();
      curr->value = Literal(getS64LEB());
      break;
    case BinaryConsts::F32Const:
      curr = allocator.alloc<Const>();
      curr->value = getFloat32Literal();
      break;
    case BinaryConsts::F64Const:
      curr = allocator.alloc<Const>();
      curr->value = getFloat64Literal();
      break;
    default:
      return false;
  }
  curr->type = curr->value.type;
  out = curr;

  return true;
}

bool WasmBinaryBuilder::maybeVisitUnary(Expression*& out, uint8_t code) {
  Unary* curr;
  switch (code) {
    case BinaryConsts::I32Clz:
      curr = allocator.alloc<Unary>();
      curr->op = ClzInt32;
      break;
    case BinaryConsts::I64Clz:
      curr = allocator.alloc<Unary>();
      curr->op = ClzInt64;
      break;
    case BinaryConsts::I32Ctz:
      curr = allocator.alloc<Unary>();
      curr->op = CtzInt32;
      break;
    case BinaryConsts::I64Ctz:
      curr = allocator.alloc<Unary>();
      curr->op = CtzInt64;
      break;
    case BinaryConsts::I32Popcnt:
      curr = allocator.alloc<Unary>();
      curr->op = PopcntInt32;
      break;
    case BinaryConsts::I64Popcnt:
      curr = allocator.alloc<Unary>();
      curr->op = PopcntInt64;
      break;
    case BinaryConsts::I32EqZ:
      curr = allocator.alloc<Unary>();
      curr->op = EqZInt32;
      break;
    case BinaryConsts::I64EqZ:
      curr = allocator.alloc<Unary>();
      curr->op = EqZInt64;
      break;
    case BinaryConsts::F32Neg:
      curr = allocator.alloc<Unary>();
      curr->op = NegFloat32;
      break;
    case BinaryConsts::F64Neg:
      curr = allocator.alloc<Unary>();
      curr->op = NegFloat64;
      break;
    case BinaryConsts::F32Abs:
      curr = allocator.alloc<Unary>();
      curr->op = AbsFloat32;
      break;
    case BinaryConsts::F64Abs:
      curr = allocator.alloc<Unary>();
      curr->op = AbsFloat64;
      break;
    case BinaryConsts::F32Ceil:
      curr = allocator.alloc<Unary>();
      curr->op = CeilFloat32;
      break;
    case BinaryConsts::F64Ceil:
      curr = allocator.alloc<Unary>();
      curr->op = CeilFloat64;
      break;
    case BinaryConsts::F32Floor:
      curr = allocator.alloc<Unary>();
      curr->op = FloorFloat32;
      break;
    case BinaryConsts::F64Floor:
      curr = allocator.alloc<Unary>();
      curr->op = FloorFloat64;
      break;
    case BinaryConsts::F32NearestInt:
      curr = allocator.alloc<Unary>();
      curr->op = NearestFloat32;
      break;
    case BinaryConsts::F64NearestInt:
      curr = allocator.alloc<Unary>();
      curr->op = NearestFloat64;
      break;
    case BinaryConsts::F32Sqrt:
      curr = allocator.alloc<Unary>();
      curr->op = SqrtFloat32;
      break;
    case BinaryConsts::F64Sqrt:
      curr = allocator.alloc<Unary>();
      curr->op = SqrtFloat64;
      break;
    case BinaryConsts::F32UConvertI32:
      curr = allocator.alloc<Unary>();
      curr->op = ConvertUInt32ToFloat32;
      break;
    case BinaryConsts::F64UConvertI32:
      curr = allocator.alloc<Unary>();
      curr->op = ConvertUInt32ToFloat64;
      break;
    case BinaryConsts::F32SConvertI32:
      curr = allocator.alloc<Unary>();
      curr->op = ConvertSInt32ToFloat32;
      break;
    case BinaryConsts::F64SConvertI32:
      curr = allocator.alloc<Unary>();
      curr->op = ConvertSInt32ToFloat64;
      break;
    case BinaryConsts::F32UConvertI64:
      curr = allocator.alloc<Unary>();
      curr->op = ConvertUInt64ToFloat32;
      break;
    case BinaryConsts::F64UConvertI64:
      curr = allocator.alloc<Unary>();
      curr->op = ConvertUInt64ToFloat64;
      break;
    case BinaryConsts::F32SConvertI64:
      curr = allocator.alloc<Unary>();
      curr->op = ConvertSInt64ToFloat32;
      break;
    case BinaryConsts::F64SConvertI64:
      curr = allocator.alloc<Unary>();
      curr->op = ConvertSInt64ToFloat64;
      break;

    case BinaryConsts::I64SExtendI32:
      curr = allocator.alloc<Unary>();
      curr->op = ExtendSInt32;
      break;
    case BinaryConsts::I64UExtendI32:
      curr = allocator.alloc<Unary>();
      curr->op = ExtendUInt32;
      break;
    case BinaryConsts::I32WrapI64:
      curr = allocator.alloc<Unary>();
      curr->op = WrapInt64;
      break;

    case BinaryConsts::I32UTruncF32:
      curr = allocator.alloc<Unary>();
      curr->op = TruncUFloat32ToInt32;
      break;
    case BinaryConsts::I32UTruncF64:
      curr = allocator.alloc<Unary>();
      curr->op = TruncUFloat64ToInt32;
      break;
    case BinaryConsts::I32STruncF32:
      curr = allocator.alloc<Unary>();
      curr->op = TruncSFloat32ToInt32;
      break;
    case BinaryConsts::I32STruncF64:
      curr = allocator.alloc<Unary>();
      curr->op = TruncSFloat64ToInt32;
      break;
    case BinaryConsts::I64UTruncF32:
      curr = allocator.alloc<Unary>();
      curr->op = TruncUFloat32ToInt64;
      break;
    case BinaryConsts::I64UTruncF64:
      curr = allocator.alloc<Unary>();
      curr->op = TruncUFloat64ToInt64;
      break;
    case BinaryConsts::I64STruncF32:
      curr = allocator.alloc<Unary>();
      curr->op = TruncSFloat32ToInt64;
      break;
    case BinaryConsts::I64STruncF64:
      curr = allocator.alloc<Unary>();
      curr->op = TruncSFloat64ToInt64;
      break;

    case BinaryConsts::F32Trunc:
      curr = allocator.alloc<Unary>();
      curr->op = TruncFloat32;
      break;
    case BinaryConsts::F64Trunc:
      curr = allocator.alloc<Unary>();
      curr->op = TruncFloat64;
      break;

    case BinaryConsts::F32DemoteI64:
      curr = allocator.alloc<Unary>();
      curr->op = DemoteFloat64;
      break;
    case BinaryConsts::F64PromoteF32:
      curr = allocator.alloc<Unary>();
      curr->op = PromoteFloat32;
      break;
    case BinaryConsts::I32ReinterpretF32:
      curr = allocator.alloc<Unary>();
      curr->op = ReinterpretFloat32;
      break;
    case BinaryConsts::I64ReinterpretF64:
      curr = allocator.alloc<Unary>();
      curr->op = ReinterpretFloat64;
      break;
    case BinaryConsts::F32ReinterpretI32:
      curr = allocator.alloc<Unary>();
      curr->op = ReinterpretInt32;
      break;
    case BinaryConsts::F64ReinterpretI64:
      curr = allocator.alloc<Unary>();
      curr->op = ReinterpretInt64;
      break;

    case BinaryConsts::I32ExtendS8:
      curr = allocator.alloc<Unary>();
      curr->op = ExtendS8Int32;
      break;
    case BinaryConsts::I32ExtendS16:
      curr = allocator.alloc<Unary>();
      curr->op = ExtendS16Int32;
      break;
    case BinaryConsts::I64ExtendS8:
      curr = allocator.alloc<Unary>();
      curr->op = ExtendS8Int64;
      break;
    case BinaryConsts::I64ExtendS16:
      curr = allocator.alloc<Unary>();
      curr->op = ExtendS16Int64;
      break;
    case BinaryConsts::I64ExtendS32:
      curr = allocator.alloc<Unary>();
      curr->op = ExtendS32Int64;
      break;

    default:
      return false;
  }
  BYN_TRACE("zz node: Unary\n");
  curr->value = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitTruncSat(Expression*& out, uint32_t code) {
  Unary* curr;
  switch (code) {
    case BinaryConsts::I32STruncSatF32:
      curr = allocator.alloc<Unary>();
      curr->op = TruncSatSFloat32ToInt32;
      break;
    case BinaryConsts::I32UTruncSatF32:
      curr = allocator.alloc<Unary>();
      curr->op = TruncSatUFloat32ToInt32;
      break;
    case BinaryConsts::I32STruncSatF64:
      curr = allocator.alloc<Unary>();
      curr->op = TruncSatSFloat64ToInt32;
      break;
    case BinaryConsts::I32UTruncSatF64:
      curr = allocator.alloc<Unary>();
      curr->op = TruncSatUFloat64ToInt32;
      break;
    case BinaryConsts::I64STruncSatF32:
      curr = allocator.alloc<Unary>();
      curr->op = TruncSatSFloat32ToInt64;
      break;
    case BinaryConsts::I64UTruncSatF32:
      curr = allocator.alloc<Unary>();
      curr->op = TruncSatUFloat32ToInt64;
      break;
    case BinaryConsts::I64STruncSatF64:
      curr = allocator.alloc<Unary>();
      curr->op = TruncSatSFloat64ToInt64;
      break;
    case BinaryConsts::I64UTruncSatF64:
      curr = allocator.alloc<Unary>();
      curr->op = TruncSatUFloat64ToInt64;
      break;
    default:
      return false;
  }
  BYN_TRACE("zz node: Unary (nontrapping float-to-int)\n");
  curr->value = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitMemoryInit(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::MemoryInit) {
    return false;
  }
  auto* curr = allocator.alloc<MemoryInit>();
  curr->size = popNonVoidExpression();
  curr->offset = popNonVoidExpression();
  curr->dest = popNonVoidExpression();
  curr->segment = getU32LEB();
  if (getInt8() != 0) {
    throwError("Unexpected nonzero memory index");
  }
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitDataDrop(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::DataDrop) {
    return false;
  }
  auto* curr = allocator.alloc<DataDrop>();
  curr->segment = getU32LEB();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitMemoryCopy(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::MemoryCopy) {
    return false;
  }
  auto* curr = allocator.alloc<MemoryCopy>();
  curr->size = popNonVoidExpression();
  curr->source = popNonVoidExpression();
  curr->dest = popNonVoidExpression();
  if (getInt8() != 0 || getInt8() != 0) {
    throwError("Unexpected nonzero memory index");
  }
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitMemoryFill(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::MemoryFill) {
    return false;
  }
  auto* curr = allocator.alloc<MemoryFill>();
  curr->size = popNonVoidExpression();
  curr->value = popNonVoidExpression();
  curr->dest = popNonVoidExpression();
  if (getInt8() != 0) {
    throwError("Unexpected nonzero memory index");
  }
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitBinary(Expression*& out, uint8_t code) {
  Binary* curr;
#define INT_TYPED_CODE(code)                                                   \
  {                                                                            \
    case BinaryConsts::I32##code:                                              \
      curr = allocator.alloc<Binary>();                                        \
      curr->op = code##Int32;                                                  \
      break;                                                                   \
    case BinaryConsts::I64##code:                                              \
      curr = allocator.alloc<Binary>();                                        \
      curr->op = code##Int64;                                                  \
      break;                                                                   \
  }
#define FLOAT_TYPED_CODE(code)                                                 \
  {                                                                            \
    case BinaryConsts::F32##code:                                              \
      curr = allocator.alloc<Binary>();                                        \
      curr->op = code##Float32;                                                \
      break;                                                                   \
    case BinaryConsts::F64##code:                                              \
      curr = allocator.alloc<Binary>();                                        \
      curr->op = code##Float64;                                                \
      break;                                                                   \
  }
#define TYPED_CODE(code)                                                       \
  {                                                                            \
    INT_TYPED_CODE(code)                                                       \
    FLOAT_TYPED_CODE(code)                                                     \
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
    default:
      return false;
  }
  BYN_TRACE("zz node: Binary\n");
  curr->right = popNonVoidExpression();
  curr->left = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
#undef TYPED_CODE
#undef INT_TYPED_CODE
#undef FLOAT_TYPED_CODE
}

bool WasmBinaryBuilder::maybeVisitSIMDBinary(Expression*& out, uint32_t code) {
  Binary* curr;
  switch (code) {
    case BinaryConsts::I8x16Eq:
      curr = allocator.alloc<Binary>();
      curr->op = EqVecI8x16;
      break;
    case BinaryConsts::I8x16Ne:
      curr = allocator.alloc<Binary>();
      curr->op = NeVecI8x16;
      break;
    case BinaryConsts::I8x16LtS:
      curr = allocator.alloc<Binary>();
      curr->op = LtSVecI8x16;
      break;
    case BinaryConsts::I8x16LtU:
      curr = allocator.alloc<Binary>();
      curr->op = LtUVecI8x16;
      break;
    case BinaryConsts::I8x16GtS:
      curr = allocator.alloc<Binary>();
      curr->op = GtSVecI8x16;
      break;
    case BinaryConsts::I8x16GtU:
      curr = allocator.alloc<Binary>();
      curr->op = GtUVecI8x16;
      break;
    case BinaryConsts::I8x16LeS:
      curr = allocator.alloc<Binary>();
      curr->op = LeSVecI8x16;
      break;
    case BinaryConsts::I8x16LeU:
      curr = allocator.alloc<Binary>();
      curr->op = LeUVecI8x16;
      break;
    case BinaryConsts::I8x16GeS:
      curr = allocator.alloc<Binary>();
      curr->op = GeSVecI8x16;
      break;
    case BinaryConsts::I8x16GeU:
      curr = allocator.alloc<Binary>();
      curr->op = GeUVecI8x16;
      break;
    case BinaryConsts::I16x8Eq:
      curr = allocator.alloc<Binary>();
      curr->op = EqVecI16x8;
      break;
    case BinaryConsts::I16x8Ne:
      curr = allocator.alloc<Binary>();
      curr->op = NeVecI16x8;
      break;
    case BinaryConsts::I16x8LtS:
      curr = allocator.alloc<Binary>();
      curr->op = LtSVecI16x8;
      break;
    case BinaryConsts::I16x8LtU:
      curr = allocator.alloc<Binary>();
      curr->op = LtUVecI16x8;
      break;
    case BinaryConsts::I16x8GtS:
      curr = allocator.alloc<Binary>();
      curr->op = GtSVecI16x8;
      break;
    case BinaryConsts::I16x8GtU:
      curr = allocator.alloc<Binary>();
      curr->op = GtUVecI16x8;
      break;
    case BinaryConsts::I16x8LeS:
      curr = allocator.alloc<Binary>();
      curr->op = LeSVecI16x8;
      break;
    case BinaryConsts::I16x8LeU:
      curr = allocator.alloc<Binary>();
      curr->op = LeUVecI16x8;
      break;
    case BinaryConsts::I16x8GeS:
      curr = allocator.alloc<Binary>();
      curr->op = GeSVecI16x8;
      break;
    case BinaryConsts::I16x8GeU:
      curr = allocator.alloc<Binary>();
      curr->op = GeUVecI16x8;
      break;
    case BinaryConsts::I32x4Eq:
      curr = allocator.alloc<Binary>();
      curr->op = EqVecI32x4;
      break;
    case BinaryConsts::I32x4Ne:
      curr = allocator.alloc<Binary>();
      curr->op = NeVecI32x4;
      break;
    case BinaryConsts::I32x4LtS:
      curr = allocator.alloc<Binary>();
      curr->op = LtSVecI32x4;
      break;
    case BinaryConsts::I32x4LtU:
      curr = allocator.alloc<Binary>();
      curr->op = LtUVecI32x4;
      break;
    case BinaryConsts::I32x4GtS:
      curr = allocator.alloc<Binary>();
      curr->op = GtSVecI32x4;
      break;
    case BinaryConsts::I32x4GtU:
      curr = allocator.alloc<Binary>();
      curr->op = GtUVecI32x4;
      break;
    case BinaryConsts::I32x4LeS:
      curr = allocator.alloc<Binary>();
      curr->op = LeSVecI32x4;
      break;
    case BinaryConsts::I32x4LeU:
      curr = allocator.alloc<Binary>();
      curr->op = LeUVecI32x4;
      break;
    case BinaryConsts::I32x4GeS:
      curr = allocator.alloc<Binary>();
      curr->op = GeSVecI32x4;
      break;
    case BinaryConsts::I32x4GeU:
      curr = allocator.alloc<Binary>();
      curr->op = GeUVecI32x4;
      break;
    case BinaryConsts::F32x4Eq:
      curr = allocator.alloc<Binary>();
      curr->op = EqVecF32x4;
      break;
    case BinaryConsts::F32x4Ne:
      curr = allocator.alloc<Binary>();
      curr->op = NeVecF32x4;
      break;
    case BinaryConsts::F32x4Lt:
      curr = allocator.alloc<Binary>();
      curr->op = LtVecF32x4;
      break;
    case BinaryConsts::F32x4Gt:
      curr = allocator.alloc<Binary>();
      curr->op = GtVecF32x4;
      break;
    case BinaryConsts::F32x4Le:
      curr = allocator.alloc<Binary>();
      curr->op = LeVecF32x4;
      break;
    case BinaryConsts::F32x4Ge:
      curr = allocator.alloc<Binary>();
      curr->op = GeVecF32x4;
      break;
    case BinaryConsts::F64x2Eq:
      curr = allocator.alloc<Binary>();
      curr->op = EqVecF64x2;
      break;
    case BinaryConsts::F64x2Ne:
      curr = allocator.alloc<Binary>();
      curr->op = NeVecF64x2;
      break;
    case BinaryConsts::F64x2Lt:
      curr = allocator.alloc<Binary>();
      curr->op = LtVecF64x2;
      break;
    case BinaryConsts::F64x2Gt:
      curr = allocator.alloc<Binary>();
      curr->op = GtVecF64x2;
      break;
    case BinaryConsts::F64x2Le:
      curr = allocator.alloc<Binary>();
      curr->op = LeVecF64x2;
      break;
    case BinaryConsts::F64x2Ge:
      curr = allocator.alloc<Binary>();
      curr->op = GeVecF64x2;
      break;
    case BinaryConsts::V128And:
      curr = allocator.alloc<Binary>();
      curr->op = AndVec128;
      break;
    case BinaryConsts::V128Or:
      curr = allocator.alloc<Binary>();
      curr->op = OrVec128;
      break;
    case BinaryConsts::V128Xor:
      curr = allocator.alloc<Binary>();
      curr->op = XorVec128;
      break;
    case BinaryConsts::V128AndNot:
      curr = allocator.alloc<Binary>();
      curr->op = AndNotVec128;
      break;
    case BinaryConsts::I8x16Add:
      curr = allocator.alloc<Binary>();
      curr->op = AddVecI8x16;
      break;
    case BinaryConsts::I8x16AddSatS:
      curr = allocator.alloc<Binary>();
      curr->op = AddSatSVecI8x16;
      break;
    case BinaryConsts::I8x16AddSatU:
      curr = allocator.alloc<Binary>();
      curr->op = AddSatUVecI8x16;
      break;
    case BinaryConsts::I8x16Sub:
      curr = allocator.alloc<Binary>();
      curr->op = SubVecI8x16;
      break;
    case BinaryConsts::I8x16SubSatS:
      curr = allocator.alloc<Binary>();
      curr->op = SubSatSVecI8x16;
      break;
    case BinaryConsts::I8x16SubSatU:
      curr = allocator.alloc<Binary>();
      curr->op = SubSatUVecI8x16;
      break;
    case BinaryConsts::I8x16Mul:
      curr = allocator.alloc<Binary>();
      curr->op = MulVecI8x16;
      break;
    case BinaryConsts::I8x16MinS:
      curr = allocator.alloc<Binary>();
      curr->op = MinSVecI8x16;
      break;
    case BinaryConsts::I8x16MinU:
      curr = allocator.alloc<Binary>();
      curr->op = MinUVecI8x16;
      break;
    case BinaryConsts::I8x16MaxS:
      curr = allocator.alloc<Binary>();
      curr->op = MaxSVecI8x16;
      break;
    case BinaryConsts::I8x16MaxU:
      curr = allocator.alloc<Binary>();
      curr->op = MaxUVecI8x16;
      break;
    case BinaryConsts::I8x16AvgrU:
      curr = allocator.alloc<Binary>();
      curr->op = AvgrUVecI8x16;
      break;
    case BinaryConsts::I16x8Add:
      curr = allocator.alloc<Binary>();
      curr->op = AddVecI16x8;
      break;
    case BinaryConsts::I16x8AddSatS:
      curr = allocator.alloc<Binary>();
      curr->op = AddSatSVecI16x8;
      break;
    case BinaryConsts::I16x8AddSatU:
      curr = allocator.alloc<Binary>();
      curr->op = AddSatUVecI16x8;
      break;
    case BinaryConsts::I16x8Sub:
      curr = allocator.alloc<Binary>();
      curr->op = SubVecI16x8;
      break;
    case BinaryConsts::I16x8SubSatS:
      curr = allocator.alloc<Binary>();
      curr->op = SubSatSVecI16x8;
      break;
    case BinaryConsts::I16x8SubSatU:
      curr = allocator.alloc<Binary>();
      curr->op = SubSatUVecI16x8;
      break;
    case BinaryConsts::I16x8Mul:
      curr = allocator.alloc<Binary>();
      curr->op = MulVecI16x8;
      break;
    case BinaryConsts::I16x8MinS:
      curr = allocator.alloc<Binary>();
      curr->op = MinSVecI16x8;
      break;
    case BinaryConsts::I16x8MinU:
      curr = allocator.alloc<Binary>();
      curr->op = MinUVecI16x8;
      break;
    case BinaryConsts::I16x8MaxS:
      curr = allocator.alloc<Binary>();
      curr->op = MaxSVecI16x8;
      break;
    case BinaryConsts::I16x8MaxU:
      curr = allocator.alloc<Binary>();
      curr->op = MaxUVecI16x8;
      break;
    case BinaryConsts::I16x8AvgrU:
      curr = allocator.alloc<Binary>();
      curr->op = AvgrUVecI16x8;
      break;
    case BinaryConsts::I32x4Add:
      curr = allocator.alloc<Binary>();
      curr->op = AddVecI32x4;
      break;
    case BinaryConsts::I32x4Sub:
      curr = allocator.alloc<Binary>();
      curr->op = SubVecI32x4;
      break;
    case BinaryConsts::I32x4Mul:
      curr = allocator.alloc<Binary>();
      curr->op = MulVecI32x4;
      break;
    case BinaryConsts::I32x4MinS:
      curr = allocator.alloc<Binary>();
      curr->op = MinSVecI32x4;
      break;
    case BinaryConsts::I32x4MinU:
      curr = allocator.alloc<Binary>();
      curr->op = MinUVecI32x4;
      break;
    case BinaryConsts::I32x4MaxS:
      curr = allocator.alloc<Binary>();
      curr->op = MaxSVecI32x4;
      break;
    case BinaryConsts::I32x4MaxU:
      curr = allocator.alloc<Binary>();
      curr->op = MaxUVecI32x4;
      break;
    case BinaryConsts::I32x4DotSVecI16x8:
      curr = allocator.alloc<Binary>();
      curr->op = DotSVecI16x8ToVecI32x4;
      break;
    case BinaryConsts::I64x2Add:
      curr = allocator.alloc<Binary>();
      curr->op = AddVecI64x2;
      break;
    case BinaryConsts::I64x2Sub:
      curr = allocator.alloc<Binary>();
      curr->op = SubVecI64x2;
      break;
    case BinaryConsts::I64x2Mul:
      curr = allocator.alloc<Binary>();
      curr->op = MulVecI64x2;
      break;
    case BinaryConsts::F32x4Add:
      curr = allocator.alloc<Binary>();
      curr->op = AddVecF32x4;
      break;
    case BinaryConsts::F32x4Sub:
      curr = allocator.alloc<Binary>();
      curr->op = SubVecF32x4;
      break;
    case BinaryConsts::F32x4Mul:
      curr = allocator.alloc<Binary>();
      curr->op = MulVecF32x4;
      break;
    case BinaryConsts::F32x4Div:
      curr = allocator.alloc<Binary>();
      curr->op = DivVecF32x4;
      break;
    case BinaryConsts::F32x4Min:
      curr = allocator.alloc<Binary>();
      curr->op = MinVecF32x4;
      break;
    case BinaryConsts::F32x4Max:
      curr = allocator.alloc<Binary>();
      curr->op = MaxVecF32x4;
      break;
    case BinaryConsts::F32x4PMin:
      curr = allocator.alloc<Binary>();
      curr->op = PMinVecF32x4;
      break;
    case BinaryConsts::F32x4PMax:
      curr = allocator.alloc<Binary>();
      curr->op = PMaxVecF32x4;
      break;
    case BinaryConsts::F64x2Add:
      curr = allocator.alloc<Binary>();
      curr->op = AddVecF64x2;
      break;
    case BinaryConsts::F64x2Sub:
      curr = allocator.alloc<Binary>();
      curr->op = SubVecF64x2;
      break;
    case BinaryConsts::F64x2Mul:
      curr = allocator.alloc<Binary>();
      curr->op = MulVecF64x2;
      break;
    case BinaryConsts::F64x2Div:
      curr = allocator.alloc<Binary>();
      curr->op = DivVecF64x2;
      break;
    case BinaryConsts::F64x2Min:
      curr = allocator.alloc<Binary>();
      curr->op = MinVecF64x2;
      break;
    case BinaryConsts::F64x2Max:
      curr = allocator.alloc<Binary>();
      curr->op = MaxVecF64x2;
      break;
    case BinaryConsts::F64x2PMin:
      curr = allocator.alloc<Binary>();
      curr->op = PMinVecF64x2;
      break;
    case BinaryConsts::F64x2PMax:
      curr = allocator.alloc<Binary>();
      curr->op = PMaxVecF64x2;
      break;
    case BinaryConsts::I8x16NarrowSI16x8:
      curr = allocator.alloc<Binary>();
      curr->op = NarrowSVecI16x8ToVecI8x16;
      break;
    case BinaryConsts::I8x16NarrowUI16x8:
      curr = allocator.alloc<Binary>();
      curr->op = NarrowUVecI16x8ToVecI8x16;
      break;
    case BinaryConsts::I16x8NarrowSI32x4:
      curr = allocator.alloc<Binary>();
      curr->op = NarrowSVecI32x4ToVecI16x8;
      break;
    case BinaryConsts::I16x8NarrowUI32x4:
      curr = allocator.alloc<Binary>();
      curr->op = NarrowUVecI32x4ToVecI16x8;
      break;
    case BinaryConsts::V8x16Swizzle:
      curr = allocator.alloc<Binary>();
      curr->op = SwizzleVec8x16;
      break;
    default:
      return false;
  }
  BYN_TRACE("zz node: Binary\n");
  curr->right = popNonVoidExpression();
  curr->left = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}
bool WasmBinaryBuilder::maybeVisitSIMDUnary(Expression*& out, uint32_t code) {
  Unary* curr;
  switch (code) {
    case BinaryConsts::I8x16Splat:
      curr = allocator.alloc<Unary>();
      curr->op = SplatVecI8x16;
      break;
    case BinaryConsts::I16x8Splat:
      curr = allocator.alloc<Unary>();
      curr->op = SplatVecI16x8;
      break;
    case BinaryConsts::I32x4Splat:
      curr = allocator.alloc<Unary>();
      curr->op = SplatVecI32x4;
      break;
    case BinaryConsts::I64x2Splat:
      curr = allocator.alloc<Unary>();
      curr->op = SplatVecI64x2;
      break;
    case BinaryConsts::F32x4Splat:
      curr = allocator.alloc<Unary>();
      curr->op = SplatVecF32x4;
      break;
    case BinaryConsts::F64x2Splat:
      curr = allocator.alloc<Unary>();
      curr->op = SplatVecF64x2;
      break;
    case BinaryConsts::V128Not:
      curr = allocator.alloc<Unary>();
      curr->op = NotVec128;
      break;
    case BinaryConsts::I8x16Abs:
      curr = allocator.alloc<Unary>();
      curr->op = AbsVecI8x16;
      break;
    case BinaryConsts::I8x16Neg:
      curr = allocator.alloc<Unary>();
      curr->op = NegVecI8x16;
      break;
    case BinaryConsts::I8x16AnyTrue:
      curr = allocator.alloc<Unary>();
      curr->op = AnyTrueVecI8x16;
      break;
    case BinaryConsts::I8x16AllTrue:
      curr = allocator.alloc<Unary>();
      curr->op = AllTrueVecI8x16;
      break;
    case BinaryConsts::I8x16Bitmask:
      curr = allocator.alloc<Unary>();
      curr->op = BitmaskVecI8x16;
      break;
    case BinaryConsts::I16x8Abs:
      curr = allocator.alloc<Unary>();
      curr->op = AbsVecI16x8;
      break;
    case BinaryConsts::I16x8Neg:
      curr = allocator.alloc<Unary>();
      curr->op = NegVecI16x8;
      break;
    case BinaryConsts::I16x8AnyTrue:
      curr = allocator.alloc<Unary>();
      curr->op = AnyTrueVecI16x8;
      break;
    case BinaryConsts::I16x8AllTrue:
      curr = allocator.alloc<Unary>();
      curr->op = AllTrueVecI16x8;
      break;
    case BinaryConsts::I16x8Bitmask:
      curr = allocator.alloc<Unary>();
      curr->op = BitmaskVecI16x8;
      break;
    case BinaryConsts::I32x4Abs:
      curr = allocator.alloc<Unary>();
      curr->op = AbsVecI32x4;
      break;
    case BinaryConsts::I32x4Neg:
      curr = allocator.alloc<Unary>();
      curr->op = NegVecI32x4;
      break;
    case BinaryConsts::I32x4AnyTrue:
      curr = allocator.alloc<Unary>();
      curr->op = AnyTrueVecI32x4;
      break;
    case BinaryConsts::I32x4AllTrue:
      curr = allocator.alloc<Unary>();
      curr->op = AllTrueVecI32x4;
      break;
    case BinaryConsts::I32x4Bitmask:
      curr = allocator.alloc<Unary>();
      curr->op = BitmaskVecI32x4;
      break;
    case BinaryConsts::I64x2Neg:
      curr = allocator.alloc<Unary>();
      curr->op = NegVecI64x2;
      break;
    case BinaryConsts::I64x2AnyTrue:
      curr = allocator.alloc<Unary>();
      curr->op = AnyTrueVecI64x2;
      break;
    case BinaryConsts::I64x2AllTrue:
      curr = allocator.alloc<Unary>();
      curr->op = AllTrueVecI64x2;
      break;
    case BinaryConsts::F32x4Abs:
      curr = allocator.alloc<Unary>();
      curr->op = AbsVecF32x4;
      break;
    case BinaryConsts::F32x4Neg:
      curr = allocator.alloc<Unary>();
      curr->op = NegVecF32x4;
      break;
    case BinaryConsts::F32x4Sqrt:
      curr = allocator.alloc<Unary>();
      curr->op = SqrtVecF32x4;
      break;
    case BinaryConsts::F32x4Ceil:
      curr = allocator.alloc<Unary>();
      curr->op = CeilVecF32x4;
      break;
    case BinaryConsts::F32x4Floor:
      curr = allocator.alloc<Unary>();
      curr->op = FloorVecF32x4;
      break;
    case BinaryConsts::F32x4Trunc:
      curr = allocator.alloc<Unary>();
      curr->op = TruncVecF32x4;
      break;
    case BinaryConsts::F32x4Nearest:
      curr = allocator.alloc<Unary>();
      curr->op = NearestVecF32x4;
      break;
    case BinaryConsts::F64x2Abs:
      curr = allocator.alloc<Unary>();
      curr->op = AbsVecF64x2;
      break;
    case BinaryConsts::F64x2Neg:
      curr = allocator.alloc<Unary>();
      curr->op = NegVecF64x2;
      break;
    case BinaryConsts::F64x2Sqrt:
      curr = allocator.alloc<Unary>();
      curr->op = SqrtVecF64x2;
      break;
    case BinaryConsts::F64x2Ceil:
      curr = allocator.alloc<Unary>();
      curr->op = CeilVecF64x2;
      break;
    case BinaryConsts::F64x2Floor:
      curr = allocator.alloc<Unary>();
      curr->op = FloorVecF64x2;
      break;
    case BinaryConsts::F64x2Trunc:
      curr = allocator.alloc<Unary>();
      curr->op = TruncVecF64x2;
      break;
    case BinaryConsts::F64x2Nearest:
      curr = allocator.alloc<Unary>();
      curr->op = NearestVecF64x2;
      break;
    case BinaryConsts::I32x4TruncSatSF32x4:
      curr = allocator.alloc<Unary>();
      curr->op = TruncSatSVecF32x4ToVecI32x4;
      break;
    case BinaryConsts::I32x4TruncSatUF32x4:
      curr = allocator.alloc<Unary>();
      curr->op = TruncSatUVecF32x4ToVecI32x4;
      break;
    case BinaryConsts::I64x2TruncSatSF64x2:
      curr = allocator.alloc<Unary>();
      curr->op = TruncSatSVecF64x2ToVecI64x2;
      break;
    case BinaryConsts::I64x2TruncSatUF64x2:
      curr = allocator.alloc<Unary>();
      curr->op = TruncSatUVecF64x2ToVecI64x2;
      break;
    case BinaryConsts::F32x4ConvertSI32x4:
      curr = allocator.alloc<Unary>();
      curr->op = ConvertSVecI32x4ToVecF32x4;
      break;
    case BinaryConsts::F32x4ConvertUI32x4:
      curr = allocator.alloc<Unary>();
      curr->op = ConvertUVecI32x4ToVecF32x4;
      break;
    case BinaryConsts::F64x2ConvertSI64x2:
      curr = allocator.alloc<Unary>();
      curr->op = ConvertSVecI64x2ToVecF64x2;
      break;
    case BinaryConsts::F64x2ConvertUI64x2:
      curr = allocator.alloc<Unary>();
      curr->op = ConvertUVecI64x2ToVecF64x2;
      break;
    case BinaryConsts::I16x8WidenLowSI8x16:
      curr = allocator.alloc<Unary>();
      curr->op = WidenLowSVecI8x16ToVecI16x8;
      break;
    case BinaryConsts::I16x8WidenHighSI8x16:
      curr = allocator.alloc<Unary>();
      curr->op = WidenHighSVecI8x16ToVecI16x8;
      break;
    case BinaryConsts::I16x8WidenLowUI8x16:
      curr = allocator.alloc<Unary>();
      curr->op = WidenLowUVecI8x16ToVecI16x8;
      break;
    case BinaryConsts::I16x8WidenHighUI8x16:
      curr = allocator.alloc<Unary>();
      curr->op = WidenHighUVecI8x16ToVecI16x8;
      break;
    case BinaryConsts::I32x4WidenLowSI16x8:
      curr = allocator.alloc<Unary>();
      curr->op = WidenLowSVecI16x8ToVecI32x4;
      break;
    case BinaryConsts::I32x4WidenHighSI16x8:
      curr = allocator.alloc<Unary>();
      curr->op = WidenHighSVecI16x8ToVecI32x4;
      break;
    case BinaryConsts::I32x4WidenLowUI16x8:
      curr = allocator.alloc<Unary>();
      curr->op = WidenLowUVecI16x8ToVecI32x4;
      break;
    case BinaryConsts::I32x4WidenHighUI16x8:
      curr = allocator.alloc<Unary>();
      curr->op = WidenHighUVecI16x8ToVecI32x4;
      break;
    default:
      return false;
  }
  curr->value = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitSIMDConst(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::V128Const) {
    return false;
  }
  auto* curr = allocator.alloc<Const>();
  curr->value = getVec128Literal();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitSIMDStore(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::V128Store) {
    return false;
  }
  auto* curr = allocator.alloc<Store>();
  curr->bytes = 16;
  curr->valueType = Type::v128;
  readMemoryAccess(curr->align, curr->offset);
  curr->isAtomic = false;
  curr->value = popNonVoidExpression();
  curr->ptr = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitSIMDExtract(Expression*& out, uint32_t code) {
  SIMDExtract* curr;
  switch (code) {
    case BinaryConsts::I8x16ExtractLaneS:
      curr = allocator.alloc<SIMDExtract>();
      curr->op = ExtractLaneSVecI8x16;
      curr->index = getLaneIndex(16);
      break;
    case BinaryConsts::I8x16ExtractLaneU:
      curr = allocator.alloc<SIMDExtract>();
      curr->op = ExtractLaneUVecI8x16;
      curr->index = getLaneIndex(16);
      break;
    case BinaryConsts::I16x8ExtractLaneS:
      curr = allocator.alloc<SIMDExtract>();
      curr->op = ExtractLaneSVecI16x8;
      curr->index = getLaneIndex(8);
      break;
    case BinaryConsts::I16x8ExtractLaneU:
      curr = allocator.alloc<SIMDExtract>();
      curr->op = ExtractLaneUVecI16x8;
      curr->index = getLaneIndex(8);
      break;
    case BinaryConsts::I32x4ExtractLane:
      curr = allocator.alloc<SIMDExtract>();
      curr->op = ExtractLaneVecI32x4;
      curr->index = getLaneIndex(4);
      break;
    case BinaryConsts::I64x2ExtractLane:
      curr = allocator.alloc<SIMDExtract>();
      curr->op = ExtractLaneVecI64x2;
      curr->index = getLaneIndex(2);
      break;
    case BinaryConsts::F32x4ExtractLane:
      curr = allocator.alloc<SIMDExtract>();
      curr->op = ExtractLaneVecF32x4;
      curr->index = getLaneIndex(4);
      break;
    case BinaryConsts::F64x2ExtractLane:
      curr = allocator.alloc<SIMDExtract>();
      curr->op = ExtractLaneVecF64x2;
      curr->index = getLaneIndex(2);
      break;
    default:
      return false;
  }
  curr->vec = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitSIMDReplace(Expression*& out, uint32_t code) {
  SIMDReplace* curr;
  switch (code) {
    case BinaryConsts::I8x16ReplaceLane:
      curr = allocator.alloc<SIMDReplace>();
      curr->op = ReplaceLaneVecI8x16;
      curr->index = getLaneIndex(16);
      break;
    case BinaryConsts::I16x8ReplaceLane:
      curr = allocator.alloc<SIMDReplace>();
      curr->op = ReplaceLaneVecI16x8;
      curr->index = getLaneIndex(8);
      break;
    case BinaryConsts::I32x4ReplaceLane:
      curr = allocator.alloc<SIMDReplace>();
      curr->op = ReplaceLaneVecI32x4;
      curr->index = getLaneIndex(4);
      break;
    case BinaryConsts::I64x2ReplaceLane:
      curr = allocator.alloc<SIMDReplace>();
      curr->op = ReplaceLaneVecI64x2;
      curr->index = getLaneIndex(2);
      break;
    case BinaryConsts::F32x4ReplaceLane:
      curr = allocator.alloc<SIMDReplace>();
      curr->op = ReplaceLaneVecF32x4;
      curr->index = getLaneIndex(4);
      break;
    case BinaryConsts::F64x2ReplaceLane:
      curr = allocator.alloc<SIMDReplace>();
      curr->op = ReplaceLaneVecF64x2;
      curr->index = getLaneIndex(2);
      break;
    default:
      return false;
  }
  curr->value = popNonVoidExpression();
  curr->vec = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitSIMDShuffle(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::V8x16Shuffle) {
    return false;
  }
  auto* curr = allocator.alloc<SIMDShuffle>();
  for (auto i = 0; i < 16; ++i) {
    curr->mask[i] = getLaneIndex(32);
  }
  curr->right = popNonVoidExpression();
  curr->left = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitSIMDTernary(Expression*& out, uint32_t code) {
  SIMDTernary* curr;
  switch (code) {
    case BinaryConsts::V128Bitselect:
      curr = allocator.alloc<SIMDTernary>();
      curr->op = Bitselect;
      break;
    case BinaryConsts::F32x4QFMA:
      curr = allocator.alloc<SIMDTernary>();
      curr->op = QFMAF32x4;
      break;
    case BinaryConsts::F32x4QFMS:
      curr = allocator.alloc<SIMDTernary>();
      curr->op = QFMSF32x4;
      break;
    case BinaryConsts::F64x2QFMA:
      curr = allocator.alloc<SIMDTernary>();
      curr->op = QFMAF64x2;
      break;
    case BinaryConsts::F64x2QFMS:
      curr = allocator.alloc<SIMDTernary>();
      curr->op = QFMSF64x2;
      break;
    default:
      return false;
  }
  curr->c = popNonVoidExpression();
  curr->b = popNonVoidExpression();
  curr->a = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitSIMDShift(Expression*& out, uint32_t code) {
  SIMDShift* curr;
  switch (code) {
    case BinaryConsts::I8x16Shl:
      curr = allocator.alloc<SIMDShift>();
      curr->op = ShlVecI8x16;
      break;
    case BinaryConsts::I8x16ShrS:
      curr = allocator.alloc<SIMDShift>();
      curr->op = ShrSVecI8x16;
      break;
    case BinaryConsts::I8x16ShrU:
      curr = allocator.alloc<SIMDShift>();
      curr->op = ShrUVecI8x16;
      break;
    case BinaryConsts::I16x8Shl:
      curr = allocator.alloc<SIMDShift>();
      curr->op = ShlVecI16x8;
      break;
    case BinaryConsts::I16x8ShrS:
      curr = allocator.alloc<SIMDShift>();
      curr->op = ShrSVecI16x8;
      break;
    case BinaryConsts::I16x8ShrU:
      curr = allocator.alloc<SIMDShift>();
      curr->op = ShrUVecI16x8;
      break;
    case BinaryConsts::I32x4Shl:
      curr = allocator.alloc<SIMDShift>();
      curr->op = ShlVecI32x4;
      break;
    case BinaryConsts::I32x4ShrS:
      curr = allocator.alloc<SIMDShift>();
      curr->op = ShrSVecI32x4;
      break;
    case BinaryConsts::I32x4ShrU:
      curr = allocator.alloc<SIMDShift>();
      curr->op = ShrUVecI32x4;
      break;
    case BinaryConsts::I64x2Shl:
      curr = allocator.alloc<SIMDShift>();
      curr->op = ShlVecI64x2;
      break;
    case BinaryConsts::I64x2ShrS:
      curr = allocator.alloc<SIMDShift>();
      curr->op = ShrSVecI64x2;
      break;
    case BinaryConsts::I64x2ShrU:
      curr = allocator.alloc<SIMDShift>();
      curr->op = ShrUVecI64x2;
      break;
    default:
      return false;
  }
  curr->shift = popNonVoidExpression();
  curr->vec = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitSIMDLoad(Expression*& out, uint32_t code) {
  if (code == BinaryConsts::V128Load) {
    auto* curr = allocator.alloc<Load>();
    curr->type = Type::v128;
    curr->bytes = 16;
    readMemoryAccess(curr->align, curr->offset);
    curr->isAtomic = false;
    curr->ptr = popNonVoidExpression();
    curr->finalize();
    out = curr;
    return true;
  }
  SIMDLoad* curr;
  switch (code) {
    case BinaryConsts::V8x16LoadSplat:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = LoadSplatVec8x16;
      break;
    case BinaryConsts::V16x8LoadSplat:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = LoadSplatVec16x8;
      break;
    case BinaryConsts::V32x4LoadSplat:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = LoadSplatVec32x4;
      break;
    case BinaryConsts::V64x2LoadSplat:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = LoadSplatVec64x2;
      break;
    case BinaryConsts::I16x8LoadExtSVec8x8:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = LoadExtSVec8x8ToVecI16x8;
      break;
    case BinaryConsts::I16x8LoadExtUVec8x8:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = LoadExtUVec8x8ToVecI16x8;
      break;
    case BinaryConsts::I32x4LoadExtSVec16x4:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = LoadExtSVec16x4ToVecI32x4;
      break;
    case BinaryConsts::I32x4LoadExtUVec16x4:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = LoadExtUVec16x4ToVecI32x4;
      break;
    case BinaryConsts::I64x2LoadExtSVec32x2:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = LoadExtSVec32x2ToVecI64x2;
      break;
    case BinaryConsts::I64x2LoadExtUVec32x2:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = LoadExtUVec32x2ToVecI64x2;
      break;
    case BinaryConsts::V128Load32Zero:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = Load32Zero;
      break;
    case BinaryConsts::V128Load64Zero:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = Load64Zero;
      break;
    default:
      return false;
  }
  readMemoryAccess(curr->align, curr->offset);
  curr->ptr = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

void WasmBinaryBuilder::visitSelect(Select* curr, uint8_t code) {
  BYN_TRACE("zz node: Select, code " << int32_t(code) << std::endl);
  if (code == BinaryConsts::SelectWithType) {
    size_t numTypes = getU32LEB();
    std::vector<Type> types;
    for (size_t i = 0; i < numTypes; i++) {
      types.push_back(getType());
    }
    curr->type = Type(types);
  }
  curr->condition = popNonVoidExpression();
  curr->ifFalse = popNonVoidExpression();
  curr->ifTrue = popNonVoidExpression();
  if (code == BinaryConsts::SelectWithType) {
    curr->finalize(curr->type);
  } else {
    curr->finalize();
  }
}

void WasmBinaryBuilder::visitReturn(Return* curr) {
  BYN_TRACE("zz node: Return\n");
  requireFunctionContext("return");
  if (currFunction->sig.results.isConcrete()) {
    curr->value = popTypedExpression(currFunction->sig.results);
  }
  curr->finalize();
}

bool WasmBinaryBuilder::maybeVisitHost(Expression*& out, uint8_t code) {
  Host* curr;
  switch (code) {
    case BinaryConsts::MemorySize: {
      curr = allocator.alloc<Host>();
      curr->op = MemorySize;
      break;
    }
    case BinaryConsts::MemoryGrow: {
      curr = allocator.alloc<Host>();
      curr->op = MemoryGrow;
      curr->operands.resize(1);
      curr->operands[0] = popNonVoidExpression();
      break;
    }
    default:
      return false;
  }
  BYN_TRACE("zz node: Host\n");
  auto reserved = getU32LEB();
  if (reserved != 0) {
    throwError("Invalid reserved field on memory.grow/memory.size");
  }
  curr->finalize();
  out = curr;
  return true;
}

void WasmBinaryBuilder::visitNop(Nop* curr) { BYN_TRACE("zz node: Nop\n"); }

void WasmBinaryBuilder::visitUnreachable(Unreachable* curr) {
  BYN_TRACE("zz node: Unreachable\n");
}

void WasmBinaryBuilder::visitDrop(Drop* curr) {
  BYN_TRACE("zz node: Drop\n");
  curr->value = popNonVoidExpression();
  curr->finalize();
}

void WasmBinaryBuilder::visitRefNull(RefNull* curr) {
  BYN_TRACE("zz node: RefNull\n");
  curr->finalize(getHeapType());
}

void WasmBinaryBuilder::visitRefIsNull(RefIsNull* curr) {
  BYN_TRACE("zz node: RefIsNull\n");
  curr->value = popNonVoidExpression();
  curr->finalize();
}

void WasmBinaryBuilder::visitRefFunc(RefFunc* curr) {
  BYN_TRACE("zz node: RefFunc\n");
  Index index = getU32LEB();
  if (index >= functionImports.size() + functionSignatures.size()) {
    throwError("ref.func: invalid call index");
  }
  functionRefs[index].push_back(curr); // we don't know function names yet
  curr->finalize();
}

void WasmBinaryBuilder::visitTry(Try* curr) {
  BYN_TRACE("zz node: Try\n");
  startControlFlow(curr);
  // For simplicity of implementation, like if scopes, we create a hidden block
  // within each try-body and catch-body, and let branches target those inner
  // blocks instead.
  curr->type = getType();
  curr->body = getBlockOrSingleton(curr->type);
  if (lastSeparator != BinaryConsts::Catch) {
    throwError("No catch instruction within a try scope");
  }
  curr->catchBody = getBlockOrSingleton(curr->type, 1);
  curr->finalize(curr->type);
  if (lastSeparator != BinaryConsts::End) {
    throwError("try should end with end");
  }
}

void WasmBinaryBuilder::visitThrow(Throw* curr) {
  BYN_TRACE("zz node: Throw\n");
  auto index = getU32LEB();
  if (index >= wasm.events.size()) {
    throwError("bad event index");
  }
  auto* event = wasm.events[index].get();
  curr->event = event->name;
  size_t num = event->sig.params.size();
  curr->operands.resize(num);
  for (size_t i = 0; i < num; i++) {
    curr->operands[num - i - 1] = popNonVoidExpression();
  }
  curr->finalize();
}

void WasmBinaryBuilder::visitRethrow(Rethrow* curr) {
  BYN_TRACE("zz node: Rethrow\n");
  curr->exnref = popNonVoidExpression();
  curr->finalize();
}

void WasmBinaryBuilder::visitBrOnExn(BrOnExn* curr) {
  BYN_TRACE("zz node: BrOnExn\n");
  BreakTarget target = getBreakTarget(getU32LEB());
  curr->name = target.name;
  auto index = getU32LEB();
  if (index >= wasm.events.size()) {
    throwError("bad event index");
  }
  curr->event = wasm.events[index]->name;
  curr->exnref = popNonVoidExpression();

  Event* event = wasm.getEventOrNull(curr->event);
  assert(event && "br_on_exn's event must exist");

  // Copy params info into BrOnExn, because it is necessary when BrOnExn is
  // refinalized without the module.
  curr->sent = event->sig.params;
  curr->finalize();
}

void WasmBinaryBuilder::throwError(std::string text) {
  throw ParseException(text, 0, pos);
}

} // namespace wasm
