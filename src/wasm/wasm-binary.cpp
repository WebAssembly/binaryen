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
#include <iomanip>

#include "ir/eh-utils.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/table-utils.h"
#include "ir/type-updating.h"
#include "support/bits.h"
#include "support/debug.h"
#include "support/stdckdint.h"
#include "support/string.h"
#include "wasm-binary.h"
#include "wasm-debug.h"
#include "wasm-limits.h"
#include "wasm-stack.h"

#define DEBUG_TYPE "binary"

namespace wasm {

void WasmBinaryWriter::prepare() {
  // Collect function types and their frequencies. Collect information in each
  // function in parallel, then merge.
  indexedTypes = ModuleUtils::getOptimizedIndexedHeapTypes(*wasm);
  for (Index i = 0, size = indexedTypes.types.size(); i < size; ++i) {
    if (indexedTypes.types[i].isSignature()) {
      signatureIndexes.insert({indexedTypes.types[i].getSignature(), i});
    }
  }
  importInfo = std::make_unique<ImportInfo>(*wasm);
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
  writeTableDeclarations();
  writeMemories();
  writeTags();
  if (wasm->features.hasStrings()) {
    writeStrings();
  }
  writeGlobals();
  writeExports();
  writeStart();
  writeElementSegments();
  writeDataCount();
  writeFunctions();
  writeDataSegments();
  if (debugInfo || emitModuleName) {
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

  writeLateCustomSections();
  writeFeaturesSection();
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

void WasmBinaryWriter::writeResizableLimits(
  Address initial, Address maximum, bool hasMaximum, bool shared, bool is64) {
  uint32_t flags = (hasMaximum ? (uint32_t)BinaryConsts::HasMaximum : 0U) |
                   (shared ? (uint32_t)BinaryConsts::IsShared : 0U) |
                   (is64 ? (uint32_t)BinaryConsts::Is64 : 0U);
  o << U32LEB(flags);
  if (is64) {
    o << U64LEB(initial);
    if (hasMaximum) {
      o << U64LEB(maximum);
    }
  } else {
    o << U32LEB(initial);
    if (hasMaximum) {
      o << U32LEB(maximum);
    }
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
    for (auto& [_, locations] : binaryLocations.expressions) {
      locations.start -= totalAdjustment;
      locations.end -= totalAdjustment;
    }
    for (auto& [_, locations] : binaryLocations.functions) {
      locations.start -= totalAdjustment;
      locations.declarations -= totalAdjustment;
      locations.end -= totalAdjustment;
    }
    for (auto& [_, locations] : binaryLocations.delimiters) {
      for (auto& item : locations) {
        item -= totalAdjustment;
      }
    }
  }
}

int32_t WasmBinaryWriter::startSubsection(
  BinaryConsts::CustomSections::Subsection code) {
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

void WasmBinaryWriter::writeMemories() {
  if (importInfo->getNumDefinedMemories() == 0) {
    return;
  }
  BYN_TRACE("== writeMemories\n");
  auto start = startSection(BinaryConsts::Section::Memory);
  auto num = importInfo->getNumDefinedMemories();
  o << U32LEB(num);
  ModuleUtils::iterDefinedMemories(*wasm, [&](Memory* memory) {
    writeResizableLimits(memory->initial,
                         memory->max,
                         memory->hasMax(),
                         memory->shared,
                         memory->is64());
  });
  finishSection(start);
}

void WasmBinaryWriter::writeTypes() {
  if (indexedTypes.types.size() == 0) {
    return;
  }
  // Count the number of recursion groups, which is the number of elements in
  // the type section.
  size_t numGroups = 0;
  {
    std::optional<RecGroup> lastGroup;
    for (auto type : indexedTypes.types) {
      auto currGroup = type.getRecGroup();
      numGroups += lastGroup != currGroup;
      lastGroup = currGroup;
    }
  }

  // As a temporary measure, detect which types have subtypes and always use
  // `sub` or `sub final` for these types. The standard says that types without
  // `sub` or `sub final` are final, but we currently treat them as non-final.
  // To avoid unsafe ambiguity, only use the short form for types that it would
  // be safe to treat as final, i.e. types without subtypes.
  std::vector<bool> hasSubtypes(indexedTypes.types.size());
  for (auto type : indexedTypes.types) {
    if (auto super = type.getDeclaredSuperType()) {
      hasSubtypes[indexedTypes.indices[*super]] = true;
    }
  }

  BYN_TRACE("== writeTypes\n");
  auto start = startSection(BinaryConsts::Section::Type);
  o << U32LEB(numGroups);
  std::optional<RecGroup> lastGroup = std::nullopt;
  for (Index i = 0; i < indexedTypes.types.size(); ++i) {
    auto type = indexedTypes.types[i];
    // Check whether we need to start a new recursion group. Recursion groups of
    // size 1 are implicit, so only emit a group header for larger groups.
    auto currGroup = type.getRecGroup();
    if (lastGroup != currGroup && currGroup.size() > 1) {
      o << uint8_t(BinaryConsts::EncodedType::Rec) << U32LEB(currGroup.size());
    }
    lastGroup = currGroup;
    // Emit the type definition.
    BYN_TRACE("write " << type << std::endl);
    auto super = type.getDeclaredSuperType();
    if (super || type.isOpen()) {
      if (type.isOpen()) {
        o << uint8_t(BinaryConsts::EncodedType::Sub);
      } else {
        o << uint8_t(BinaryConsts::EncodedType::SubFinal);
      }
      if (super) {
        o << U32LEB(1);
        writeHeapType(*super);
      } else {
        o << U32LEB(0);
      }
    }
    if (type.isShared()) {
      o << uint8_t(BinaryConsts::EncodedType::SharedDef);
    }
    switch (type.getKind()) {
      case HeapTypeKind::Func: {
        o << uint8_t(BinaryConsts::EncodedType::Func);
        auto sig = type.getSignature();
        for (auto& sigType : {sig.params, sig.results}) {
          o << U32LEB(sigType.size());
          for (const auto& type : sigType) {
            writeType(type);
          }
        }
        break;
      }
      case HeapTypeKind::Struct: {
        o << uint8_t(BinaryConsts::EncodedType::Struct);
        auto fields = type.getStruct().fields;
        o << U32LEB(fields.size());
        for (const auto& field : fields) {
          writeField(field);
        }
        break;
      }
      case HeapTypeKind::Array:
        o << uint8_t(BinaryConsts::EncodedType::Array);
        writeField(type.getArray().element);
        break;
      case HeapTypeKind::Cont:
        o << uint8_t(BinaryConsts::EncodedType::Cont);
        writeHeapType(type.getContinuation().type);
        break;
      case HeapTypeKind::Basic:
        WASM_UNREACHABLE("unexpected kind");
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
    o << U32LEB(getTypeIndex(func->type));
  });
  ModuleUtils::iterImportedGlobals(*wasm, [&](Global* global) {
    BYN_TRACE("write one global\n");
    writeImportHeader(global);
    o << U32LEB(int32_t(ExternalKind::Global));
    writeType(global->type);
    o << U32LEB(global->mutable_);
  });
  ModuleUtils::iterImportedTags(*wasm, [&](Tag* tag) {
    BYN_TRACE("write one tag\n");
    writeImportHeader(tag);
    o << U32LEB(int32_t(ExternalKind::Tag));
    o << uint8_t(0); // Reserved 'attribute' field. Always 0.
    o << U32LEB(getTypeIndex(tag->sig));
  });
  ModuleUtils::iterImportedMemories(*wasm, [&](Memory* memory) {
    BYN_TRACE("write one memory\n");
    writeImportHeader(memory);
    o << U32LEB(int32_t(ExternalKind::Memory));
    writeResizableLimits(memory->initial,
                         memory->max,
                         memory->hasMax(),
                         memory->shared,
                         memory->is64());
  });
  ModuleUtils::iterImportedTables(*wasm, [&](Table* table) {
    BYN_TRACE("write one table\n");
    writeImportHeader(table);
    o << U32LEB(int32_t(ExternalKind::Table));
    writeType(table->type);
    writeResizableLimits(table->initial,
                         table->max,
                         table->hasMax(),
                         /*shared=*/false,
                         table->is64());
  });
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
    o << U32LEB(getTypeIndex(func->type));
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

  std::optional<ModuleStackIR> moduleStackIR;
  if (options.generateStackIR) {
    moduleStackIR.emplace(*wasm, options);
  }

  BYN_TRACE("== writeFunctions\n");
  auto sectionStart = startSection(BinaryConsts::Section::Code);
  o << U32LEB(importInfo->getNumDefinedFunctions());
  bool DWARF = Debug::hasDWARFSections(*getModule());
  ModuleUtils::iterDefinedFunctions(*wasm, [&](Function* func) {
    assert(binaryLocationTrackedExpressionsForFunc.empty());
    BYN_TRACE("write one at" << o.size() << std::endl);
    // Do not smear any debug location from the previous function.
    writeNoDebugLocation();
    size_t sourceMapLocationsSizeAtFunctionStart = sourceMapLocations.size();
    size_t sizePos = writeU32LEBPlaceholder();
    size_t start = o.size();
    BYN_TRACE("writing" << func->name << std::endl);
    // Emit Stack IR if present.
    StackIR* stackIR = nullptr;
    if (moduleStackIR) {
      stackIR = moduleStackIR->getStackIROrNull(func);
    }
    if (stackIR) {
      BYN_TRACE("write Stack IR\n");
      StackIRToBinaryWriter writer(*this, o, func, *stackIR, sourceMap, DWARF);
      writer.write();
      if (debugInfo) {
        funcMappedLocals[func->name] = std::move(writer.getMappedLocals());
      }
    } else {
      BYN_TRACE("write Binaryen IR\n");
      BinaryenIRToBinaryWriter writer(*this, o, func, sourceMap, DWARF);
      writer.write();
      if (debugInfo) {
        funcMappedLocals[func->name] = std::move(writer.getMappedLocals());
      }
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

    if (func->getParams().size() > WebLimitations::MaxFunctionParams) {
      std::cerr << "Some VMs may not accept this binary because it has a large "
                << "number of parameters in function " << func->name << ".\n";
    }
  });
  finishSection(sectionStart);
}

void WasmBinaryWriter::writeStrings() {
  assert(wasm->features.hasStrings());

  // Scan the entire wasm to find the relevant strings.
  // To find all the string literals we must scan all the code.
  using StringSet = std::unordered_set<Name>;

  struct StringWalker : public PostWalker<StringWalker> {
    StringSet& strings;

    StringWalker(StringSet& strings) : strings(strings) {}

    void visitStringConst(StringConst* curr) { strings.insert(curr->string); }
  };

  ModuleUtils::ParallelFunctionAnalysis<StringSet> analysis(
    *wasm, [&](Function* func, StringSet& strings) {
      if (!func->imported()) {
        StringWalker(strings).walk(func->body);
      }
    });

  // Also walk the global module code (for simplicity, also add it to the
  // function map, using a "function" key of nullptr).
  auto& globalStrings = analysis.map[nullptr];
  StringWalker(globalStrings).walkModuleCode(wasm);

  // Generate the indexes from the combined set of necessary strings,
  // which we sort for determinism.
  StringSet allStrings;
  for (auto& [func, strings] : analysis.map) {
    for (auto& string : strings) {
      allStrings.insert(string);
    }
  }
  std::vector<Name> sorted;
  for (auto& string : allStrings) {
    sorted.push_back(string);
  }
  std::sort(sorted.begin(), sorted.end());
  for (Index i = 0; i < sorted.size(); i++) {
    stringIndexes[sorted[i]] = i;
  }

  auto num = sorted.size();
  if (num == 0) {
    return;
  }

  auto start = startSection(BinaryConsts::Section::Strings);

  // Placeholder for future use in the spec.
  o << U32LEB(0);

  // The number of strings and then their contents.
  o << U32LEB(num);
  for (auto& string : sorted) {
    // Re-encode from WTF-16 to WTF-8.
    std::stringstream wtf8;
    [[maybe_unused]] bool valid = String::convertWTF16ToWTF8(wtf8, string.str);
    assert(valid);
    // TODO: Use wtf8.view() once we have C++20.
    writeInlineString(wtf8.str());
  }

  finishSection(start);
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
      writeType(t);
      o << U32LEB(global->mutable_);
      if (global->type.size() == 1) {
        writeExpression(global->init);
      } else if (auto* make = global->init->dynCast<TupleMake>()) {
        // Emit the proper lane for this global.
        writeExpression(make->operands[i]);
      } else {
        // For now tuple globals must contain tuple.make. We could perhaps
        // support more operations, like global.get, but the code would need to
        // look something like this:
        //
        //   auto parentIndex = getGlobalIndex(get->name);
        //   o << int8_t(BinaryConsts::GlobalGet) << U32LEB(parentIndex + i);
        //
        // That is, we must emit the instruction here, and not defer to
        // writeExpression, as writeExpression writes an entire expression at a
        // time (and not just one of the lanes). As emitting an instruction here
        // is less clean, and there is no important use case for global.get of
        // one tuple global to another, we disallow this.
        WASM_UNREACHABLE("unsupported tuple global operation");
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
        o << U32LEB(getTableIndex(curr->value));
        break;
      case ExternalKind::Memory:
        o << U32LEB(getMemoryIndex(curr->value));
        break;
      case ExternalKind::Global:
        o << U32LEB(getGlobalIndex(curr->value));
        break;
      case ExternalKind::Tag:
        o << U32LEB(getTagIndex(curr->value));
        break;
      default:
        WASM_UNREACHABLE("unexpected extern kind");
    }
  }
  finishSection(start);
}

void WasmBinaryWriter::writeDataCount() {
  if (!wasm->features.hasBulkMemory() || !wasm->dataSegments.size()) {
    return;
  }
  auto start = startSection(BinaryConsts::Section::DataCount);
  o << U32LEB(wasm->dataSegments.size());
  finishSection(start);
}

void WasmBinaryWriter::writeDataSegments() {
  if (wasm->dataSegments.size() == 0) {
    return;
  }
  if (wasm->dataSegments.size() > WebLimitations::MaxDataSegments) {
    std::cerr << "Some VMs may not accept this binary because it has a large "
              << "number of data segments. Run the limit-segments pass to "
              << "merge segments.\n";
  }
  auto start = startSection(BinaryConsts::Section::Data);
  o << U32LEB(wasm->dataSegments.size());
  for (auto& segment : wasm->dataSegments) {
    uint32_t flags = 0;
    Index memoryIndex = 0;
    if (segment->isPassive) {
      flags |= BinaryConsts::IsPassive;
    } else {
      memoryIndex = getMemoryIndex(segment->memory);
      if (memoryIndex) {
        flags |= BinaryConsts::HasIndex;
      }
    }
    o << U32LEB(flags);
    if (!segment->isPassive) {
      if (memoryIndex) {
        o << U32LEB(memoryIndex);
      }
      writeExpression(segment->offset);
      o << int8_t(BinaryConsts::End);
    }
    writeInlineBuffer(segment->data.data(), segment->data.size());
  }
  finishSection(start);
}

uint32_t WasmBinaryWriter::getFunctionIndex(Name name) const {
  auto it = indexes.functionIndexes.find(name);
  assert(it != indexes.functionIndexes.end());
  return it->second;
}

uint32_t WasmBinaryWriter::getTableIndex(Name name) const {
  auto it = indexes.tableIndexes.find(name);
  assert(it != indexes.tableIndexes.end());
  return it->second;
}

uint32_t WasmBinaryWriter::getMemoryIndex(Name name) const {
  auto it = indexes.memoryIndexes.find(name);
  assert(it != indexes.memoryIndexes.end());
  return it->second;
}

uint32_t WasmBinaryWriter::getGlobalIndex(Name name) const {
  auto it = indexes.globalIndexes.find(name);
  assert(it != indexes.globalIndexes.end());
  return it->second;
}

uint32_t WasmBinaryWriter::getTagIndex(Name name) const {
  auto it = indexes.tagIndexes.find(name);
  assert(it != indexes.tagIndexes.end());
  return it->second;
}

uint32_t WasmBinaryWriter::getDataSegmentIndex(Name name) const {
  auto it = indexes.dataIndexes.find(name);
  assert(it != indexes.dataIndexes.end());
  return it->second;
}

uint32_t WasmBinaryWriter::getElementSegmentIndex(Name name) const {
  auto it = indexes.elemIndexes.find(name);
  assert(it != indexes.elemIndexes.end());
  return it->second;
}

uint32_t WasmBinaryWriter::getTypeIndex(HeapType type) const {
  auto it = indexedTypes.indices.find(type);
#ifndef NDEBUG
  if (it == indexedTypes.indices.end()) {
    std::cout << "Missing type: " << type << '\n';
    assert(0);
  }
#endif
  return it->second;
}

uint32_t WasmBinaryWriter::getSignatureIndex(Signature sig) const {
  auto it = signatureIndexes.find(sig);
#ifndef NDEBUG
  if (it == signatureIndexes.end()) {
    std::cout << "Missing signature: " << sig << '\n';
    assert(0);
  }
#endif
  return it->second;
}

uint32_t WasmBinaryWriter::getStringIndex(Name string) const {
  auto it = stringIndexes.find(string);
  assert(it != stringIndexes.end());
  return it->second;
}

void WasmBinaryWriter::writeTableDeclarations() {
  if (importInfo->getNumDefinedTables() == 0) {
    // std::cerr << std::endl << "(WasmBinaryWriter::writeTableDeclarations) No
    // defined tables found. skipping" << std::endl;
    return;
  }
  BYN_TRACE("== writeTableDeclarations\n");
  auto start = startSection(BinaryConsts::Section::Table);
  auto num = importInfo->getNumDefinedTables();
  o << U32LEB(num);
  ModuleUtils::iterDefinedTables(*wasm, [&](Table* table) {
    writeType(table->type);
    writeResizableLimits(table->initial,
                         table->max,
                         table->hasMax(),
                         /*shared=*/false,
                         table->is64());
  });
  finishSection(start);
}

void WasmBinaryWriter::writeElementSegments() {
  size_t elemCount = wasm->elementSegments.size();
  auto needingElemDecl = TableUtils::getFunctionsNeedingElemDeclare(*wasm);
  if (!needingElemDecl.empty()) {
    elemCount++;
  }
  if (elemCount == 0) {
    return;
  }

  BYN_TRACE("== writeElementSegments\n");
  auto start = startSection(BinaryConsts::Section::Element);
  o << U32LEB(elemCount);

  Type funcref = Type(HeapType::func, Nullable);
  for (auto& segment : wasm->elementSegments) {
    Index tableIdx = 0;

    bool isPassive = segment->table.isNull();
    // If the segment is MVP, we can use the shorter form.
    bool usesExpressions = TableUtils::usesExpressions(segment.get(), wasm);

    // The table index can and should be elided for active segments of table 0
    // when table 0 has type funcref. This was the only type of segment
    // supported by the MVP, which also did not support table indices in the
    // segment encoding.
    bool hasTableIndex = false;
    if (!isPassive) {
      tableIdx = getTableIndex(segment->table);
      hasTableIndex =
        tableIdx > 0 || wasm->getTable(segment->table)->type != funcref;
    }

    uint32_t flags = 0;
    if (usesExpressions) {
      flags |= BinaryConsts::UsesExpressions;
    }
    if (isPassive) {
      flags |= BinaryConsts::IsPassive;
    } else if (hasTableIndex) {
      flags |= BinaryConsts::HasIndex;
    }

    o << U32LEB(flags);
    if (!isPassive) {
      if (hasTableIndex) {
        o << U32LEB(tableIdx);
      }
      writeExpression(segment->offset);
      o << int8_t(BinaryConsts::End);
    }

    if (isPassive || hasTableIndex) {
      if (usesExpressions) {
        // elemType
        writeType(segment->type);
      } else {
        // MVP elemKind of funcref
        o << U32LEB(0);
      }
    }
    o << U32LEB(segment->data.size());
    if (usesExpressions) {
      for (auto* item : segment->data) {
        writeExpression(item);
        o << int8_t(BinaryConsts::End);
      }
    } else {
      for (auto& item : segment->data) {
        // We've ensured that all items are ref.func.
        auto& name = item->cast<RefFunc>()->func;
        o << U32LEB(getFunctionIndex(name));
      }
    }
  }

  if (!needingElemDecl.empty()) {
    o << U32LEB(BinaryConsts::IsPassive | BinaryConsts::IsDeclarative);
    o << U32LEB(0); // type (indicating funcref)
    o << U32LEB(needingElemDecl.size());
    for (auto name : needingElemDecl) {
      o << U32LEB(indexes.functionIndexes[name]);
    }
  }

  finishSection(start);
}

void WasmBinaryWriter::writeTags() {
  if (importInfo->getNumDefinedTags() == 0) {
    return;
  }
  BYN_TRACE("== writeTags\n");
  auto start = startSection(BinaryConsts::Section::Tag);
  auto num = importInfo->getNumDefinedTags();
  o << U32LEB(num);
  ModuleUtils::iterDefinedTags(*wasm, [&](Tag* tag) {
    BYN_TRACE("write one\n");
    o << uint8_t(0); // Reserved 'attribute' field. Always 0.
    o << U32LEB(getTypeIndex(tag->sig));
  });

  finishSection(start);
}

void WasmBinaryWriter::writeNames() {
  BYN_TRACE("== writeNames\n");
  auto start = startSection(BinaryConsts::Section::Custom);
  writeInlineString(BinaryConsts::CustomSections::Name);

  // module name
  if (emitModuleName && wasm->name.is()) {
    auto substart =
      startSubsection(BinaryConsts::CustomSections::Subsection::NameModule);
    writeEscapedName(wasm->name.str);
    finishSubsection(substart);
  }

  if (!debugInfo) {
    // We were only writing the module name.
    finishSection(start);
    return;
  }

  // function names
  {
    std::vector<std::pair<Index, Function*>> functionsWithNames;
    Index checked = 0;
    auto check = [&](Function* curr) {
      if (curr->hasExplicitName) {
        functionsWithNames.push_back({checked, curr});
      }
      checked++;
    };
    ModuleUtils::iterImportedFunctions(*wasm, check);
    ModuleUtils::iterDefinedFunctions(*wasm, check);
    assert(checked == indexes.functionIndexes.size());
    if (functionsWithNames.size() > 0) {
      auto substart =
        startSubsection(BinaryConsts::CustomSections::Subsection::NameFunction);
      o << U32LEB(functionsWithNames.size());
      for (auto& [index, global] : functionsWithNames) {
        o << U32LEB(index);
        writeEscapedName(global->name.str);
      }
      finishSubsection(substart);
    }
  }

  // local names
  {
    // Find all functions with at least one local name and only emit the
    // subsection if there is at least one.
    std::vector<std::pair<Index, Function*>> functionsWithLocalNames;
    Index checked = 0;
    auto check = [&](Function* curr) {
      auto numLocals = curr->getNumLocals();
      for (Index i = 0; i < numLocals; ++i) {
        if (curr->hasLocalName(i)) {
          functionsWithLocalNames.push_back({checked, curr});
          break;
        }
      }
      checked++;
    };
    ModuleUtils::iterImportedFunctions(*wasm, check);
    ModuleUtils::iterDefinedFunctions(*wasm, check);
    assert(checked == indexes.functionIndexes.size());
    if (functionsWithLocalNames.size() > 0) {
      // Otherwise emit those functions but only include locals with a name.
      auto substart =
        startSubsection(BinaryConsts::CustomSections::Subsection::NameLocal);
      o << U32LEB(functionsWithLocalNames.size());
      Index emitted = 0;
      for (auto& [index, func] : functionsWithLocalNames) {
        // Pairs of (local index in IR, name).
        std::vector<std::pair<Index, Name>> localsWithNames;
        auto numLocals = func->getNumLocals();
        for (Index indexInFunc = 0; indexInFunc < numLocals; ++indexInFunc) {
          if (func->hasLocalName(indexInFunc)) {
            Index indexInBinary;
            auto iter = funcMappedLocals.find(func->name);
            if (iter != funcMappedLocals.end()) {
              // TODO: handle multivalue
              indexInBinary = iter->second[{indexInFunc, 0}];
            } else {
              // No data on funcMappedLocals. That is only possible if we are an
              // imported function, where there are no locals to map, and in
              // that case the index is unchanged anyhow: parameters always have
              // the same index, they are not mapped in any way.
              assert(func->imported());
              indexInBinary = indexInFunc;
            }
            localsWithNames.push_back(
              {indexInBinary, func->getLocalName(indexInFunc)});
          }
        }
        assert(localsWithNames.size());
        std::sort(localsWithNames.begin(), localsWithNames.end());
        o << U32LEB(index);
        o << U32LEB(localsWithNames.size());
        for (auto& [indexInBinary, name] : localsWithNames) {
          o << U32LEB(indexInBinary);
          writeEscapedName(name.str);
        }
        emitted++;
      }
      assert(emitted == functionsWithLocalNames.size());
      finishSubsection(substart);
    }
  }

  // type names
  {
    std::vector<HeapType> namedTypes;
    for (auto type : indexedTypes.types) {
      if (wasm->typeNames.count(type) && wasm->typeNames[type].name.is()) {
        namedTypes.push_back(type);
      }
    }
    if (!namedTypes.empty()) {
      auto substart =
        startSubsection(BinaryConsts::CustomSections::Subsection::NameType);
      o << U32LEB(namedTypes.size());
      for (auto type : namedTypes) {
        o << U32LEB(indexedTypes.indices[type]);
        writeEscapedName(wasm->typeNames[type].name.str);
      }
      finishSubsection(substart);
    }
  }

  // table names
  {
    std::vector<std::pair<Index, Table*>> tablesWithNames;
    Index checked = 0;
    auto check = [&](Table* curr) {
      if (curr->hasExplicitName) {
        tablesWithNames.push_back({checked, curr});
      }
      checked++;
    };
    ModuleUtils::iterImportedTables(*wasm, check);
    ModuleUtils::iterDefinedTables(*wasm, check);
    assert(checked == indexes.tableIndexes.size());

    if (tablesWithNames.size() > 0) {
      auto substart =
        startSubsection(BinaryConsts::CustomSections::Subsection::NameTable);
      o << U32LEB(tablesWithNames.size());

      for (auto& [index, table] : tablesWithNames) {
        o << U32LEB(index);
        writeEscapedName(table->name.str);
      }

      finishSubsection(substart);
    }
  }

  // memory names
  {
    std::vector<std::pair<Index, Memory*>> memoriesWithNames;
    Index checked = 0;
    auto check = [&](Memory* curr) {
      if (curr->hasExplicitName) {
        memoriesWithNames.push_back({checked, curr});
      }
      checked++;
    };
    ModuleUtils::iterImportedMemories(*wasm, check);
    ModuleUtils::iterDefinedMemories(*wasm, check);
    assert(checked == indexes.memoryIndexes.size());
    if (memoriesWithNames.size() > 0) {
      auto substart =
        startSubsection(BinaryConsts::CustomSections::Subsection::NameMemory);
      o << U32LEB(memoriesWithNames.size());
      for (auto& [index, memory] : memoriesWithNames) {
        o << U32LEB(index);
        writeEscapedName(memory->name.str);
      }
      finishSubsection(substart);
    }
  }

  // global names
  {
    std::vector<std::pair<Index, Global*>> globalsWithNames;
    Index checked = 0;
    auto check = [&](Global* curr) {
      if (curr->hasExplicitName) {
        globalsWithNames.push_back({checked, curr});
      }
      checked++;
    };
    ModuleUtils::iterImportedGlobals(*wasm, check);
    ModuleUtils::iterDefinedGlobals(*wasm, check);
    assert(checked == indexes.globalIndexes.size());
    if (globalsWithNames.size() > 0) {
      auto substart =
        startSubsection(BinaryConsts::CustomSections::Subsection::NameGlobal);
      o << U32LEB(globalsWithNames.size());
      for (auto& [index, global] : globalsWithNames) {
        o << U32LEB(index);
        writeEscapedName(global->name.str);
      }
      finishSubsection(substart);
    }
  }

  // elem segment names
  {
    std::vector<std::pair<Index, ElementSegment*>> elemsWithNames;
    Index checked = 0;
    for (auto& curr : wasm->elementSegments) {
      if (curr->hasExplicitName) {
        elemsWithNames.push_back({checked, curr.get()});
      }
      checked++;
    }
    assert(checked == indexes.elemIndexes.size());

    if (elemsWithNames.size() > 0) {
      auto substart =
        startSubsection(BinaryConsts::CustomSections::Subsection::NameElem);
      o << U32LEB(elemsWithNames.size());

      for (auto& [index, elem] : elemsWithNames) {
        o << U32LEB(index);
        writeEscapedName(elem->name.str);
      }

      finishSubsection(substart);
    }
  }

  // data segment names
  {
    Index count = 0;
    for (auto& seg : wasm->dataSegments) {
      if (seg->hasExplicitName) {
        count++;
      }
    }

    if (count) {
      auto substart =
        startSubsection(BinaryConsts::CustomSections::Subsection::NameData);
      o << U32LEB(count);
      for (Index i = 0; i < wasm->dataSegments.size(); i++) {
        auto& seg = wasm->dataSegments[i];
        if (seg->hasExplicitName) {
          o << U32LEB(i);
          writeEscapedName(seg->name.str);
        }
      }
      finishSubsection(substart);
    }
  }

  // TODO: label, type, and element names
  // see: https://github.com/WebAssembly/extended-name-section

  // GC field names
  if (wasm->features.hasGC()) {
    std::vector<HeapType> relevantTypes;
    for (auto& type : indexedTypes.types) {
      if (type.isStruct() && wasm->typeNames.count(type) &&
          !wasm->typeNames[type].fieldNames.empty()) {
        relevantTypes.push_back(type);
      }
    }
    if (!relevantTypes.empty()) {
      auto substart =
        startSubsection(BinaryConsts::CustomSections::Subsection::NameField);
      o << U32LEB(relevantTypes.size());
      for (Index i = 0; i < relevantTypes.size(); i++) {
        auto type = relevantTypes[i];
        o << U32LEB(indexedTypes.indices[type]);
        std::unordered_map<Index, Name>& fieldNames =
          wasm->typeNames.at(type).fieldNames;
        o << U32LEB(fieldNames.size());
        for (auto& [index, name] : fieldNames) {
          o << U32LEB(index);
          writeEscapedName(name.str);
        }
      }
      finishSubsection(substart);
    }
  }

  // tag names
  if (!wasm->tags.empty()) {
    Index count = 0;
    for (auto& tag : wasm->tags) {
      if (tag->hasExplicitName) {
        count++;
      }
    }

    if (count) {
      auto substart =
        startSubsection(BinaryConsts::CustomSections::Subsection::NameTag);
      o << U32LEB(count);
      for (Index i = 0; i < wasm->tags.size(); i++) {
        auto& tag = wasm->tags[i];
        if (tag->hasExplicitName) {
          o << U32LEB(i);
          writeEscapedName(tag->name.str);
        }
      }
      finishSubsection(substart);
    }
  }

  finishSection(start);
}

void WasmBinaryWriter::writeSourceMapUrl() {
  BYN_TRACE("== writeSourceMapUrl\n");
  auto start = startSection(BinaryConsts::Section::Custom);
  writeInlineString(BinaryConsts::CustomSections::SourceMapUrl);
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
  *sourceMap << "{\"version\":3,";

  for (const auto& section : wasm->customSections) {
    if (section.name == BinaryConsts::CustomSections::BuildId) {
      U32LEB ret;
      size_t pos = 0;
      ret.read([&]() { return section.data[pos++]; });

      if (section.data.size() != pos + ret.value) {
        std::cerr
          << "warning: build id section with an incorrect size detected!\n";
        break;
      }

      *sourceMap << "\"debugId\":\"";
      for (size_t i = pos; i < section.data.size(); i++) {
        *sourceMap << std::setfill('0') << std::setw(2) << std::hex
                   << static_cast<int>(static_cast<uint8_t>(section.data[i]));
      }
      *sourceMap << "\",";
      break;
    }
  }

  *sourceMap << "\"sources\":[";
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
  for (const auto& [offset, loc] : sourceMapLocations) {
    if (lastOffset > 0) {
      *sourceMap << ",";
    }
    writeBase64VLQ(*sourceMap, int32_t(offset - lastOffset));
    lastOffset = offset;
    if (loc) {
      // There is debug information for this location, so emit the next 3
      // fields and update lastLoc.
      writeBase64VLQ(*sourceMap, int32_t(loc->fileIndex - lastLoc.fileIndex));
      writeBase64VLQ(*sourceMap, int32_t(loc->lineNumber - lastLoc.lineNumber));
      writeBase64VLQ(*sourceMap,
                     int32_t(loc->columnNumber - lastLoc.columnNumber));
      lastLoc = *loc;
    }
  }
  *sourceMap << "\"}";
}

void WasmBinaryWriter::writeLateCustomSections() {
  for (auto& section : wasm->customSections) {
    if (section.name != BinaryConsts::CustomSections::Dylink) {
      writeCustomSection(section);
    }
  }
}

void WasmBinaryWriter::writeCustomSection(const CustomSection& section) {
  auto start = startSection(BinaryConsts::Custom);
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
        return BinaryConsts::CustomSections::AtomicsFeature;
      case FeatureSet::MutableGlobals:
        return BinaryConsts::CustomSections::MutableGlobalsFeature;
      case FeatureSet::TruncSat:
        return BinaryConsts::CustomSections::TruncSatFeature;
      case FeatureSet::SIMD:
        return BinaryConsts::CustomSections::SIMD128Feature;
      case FeatureSet::BulkMemory:
        return BinaryConsts::CustomSections::BulkMemoryFeature;
      case FeatureSet::SignExt:
        return BinaryConsts::CustomSections::SignExtFeature;
      case FeatureSet::ExceptionHandling:
        return BinaryConsts::CustomSections::ExceptionHandlingFeature;
      case FeatureSet::TailCall:
        return BinaryConsts::CustomSections::TailCallFeature;
      case FeatureSet::ReferenceTypes:
        return BinaryConsts::CustomSections::ReferenceTypesFeature;
      case FeatureSet::Multivalue:
        return BinaryConsts::CustomSections::MultivalueFeature;
      case FeatureSet::GC:
        return BinaryConsts::CustomSections::GCFeature;
      case FeatureSet::Memory64:
        return BinaryConsts::CustomSections::Memory64Feature;
      case FeatureSet::RelaxedSIMD:
        return BinaryConsts::CustomSections::RelaxedSIMDFeature;
      case FeatureSet::ExtendedConst:
        return BinaryConsts::CustomSections::ExtendedConstFeature;
      case FeatureSet::Strings:
        return BinaryConsts::CustomSections::StringsFeature;
      case FeatureSet::MultiMemory:
        return BinaryConsts::CustomSections::MultiMemoryFeature;
      case FeatureSet::TypedContinuations:
        return BinaryConsts::CustomSections::TypedContinuationsFeature;
      case FeatureSet::SharedEverything:
        return BinaryConsts::CustomSections::SharedEverythingFeature;
      case FeatureSet::FP16:
        return BinaryConsts::CustomSections::FP16Feature;
      case FeatureSet::None:
      case FeatureSet::Default:
      case FeatureSet::All:
        break;
    }
    WASM_UNREACHABLE("unexpected feature flag");
  };

  std::vector<const char*> features;
  wasm->features.iterFeatures(
    [&](FeatureSet::Feature f) { features.push_back(toString(f)); });

  auto start = startSection(BinaryConsts::Custom);
  writeInlineString(BinaryConsts::CustomSections::TargetFeatures);
  o << U32LEB(features.size());
  for (auto& f : features) {
    o << uint8_t(BinaryConsts::FeatureUsed);
    writeInlineString(f);
  }
  finishSection(start);
}

void WasmBinaryWriter::writeLegacyDylinkSection() {
  if (!wasm->dylinkSection) {
    return;
  }

  auto start = startSection(BinaryConsts::Custom);
  writeInlineString(BinaryConsts::CustomSections::Dylink);
  o << U32LEB(wasm->dylinkSection->memorySize);
  o << U32LEB(wasm->dylinkSection->memoryAlignment);
  o << U32LEB(wasm->dylinkSection->tableSize);
  o << U32LEB(wasm->dylinkSection->tableAlignment);
  o << U32LEB(wasm->dylinkSection->neededDynlibs.size());
  for (auto& neededDynlib : wasm->dylinkSection->neededDynlibs) {
    writeInlineString(neededDynlib.str);
  }
  finishSection(start);
}

void WasmBinaryWriter::writeDylinkSection() {
  if (!wasm->dylinkSection) {
    return;
  }

  if (wasm->dylinkSection->isLegacy) {
    writeLegacyDylinkSection();
    return;
  }

  auto start = startSection(BinaryConsts::Custom);
  writeInlineString(BinaryConsts::CustomSections::Dylink0);

  auto substart =
    startSubsection(BinaryConsts::CustomSections::Subsection::DylinkMemInfo);
  o << U32LEB(wasm->dylinkSection->memorySize);
  o << U32LEB(wasm->dylinkSection->memoryAlignment);
  o << U32LEB(wasm->dylinkSection->tableSize);
  o << U32LEB(wasm->dylinkSection->tableAlignment);
  finishSubsection(substart);

  if (wasm->dylinkSection->neededDynlibs.size()) {
    substart =
      startSubsection(BinaryConsts::CustomSections::Subsection::DylinkNeeded);
    o << U32LEB(wasm->dylinkSection->neededDynlibs.size());
    for (auto& neededDynlib : wasm->dylinkSection->neededDynlibs) {
      writeInlineString(neededDynlib.str);
    }
    finishSubsection(substart);
  }

  writeData(wasm->dylinkSection->tail.data(), wasm->dylinkSection->tail.size());
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

void WasmBinaryWriter::writeNoDebugLocation() {
  // Emit an indication that there is no debug location there (so that
  // we do not get "smeared" with debug info from anything before or
  // after us).
  //
  // We don't need to write repeated "no debug info" indications, as a
  // single one is enough to make it clear that the debug information
  // before us is valid no longer. We also don't need to write one if
  // there is nothing before us.
  if (!sourceMapLocations.empty() &&
      sourceMapLocations.back().second != nullptr) {
    sourceMapLocations.emplace_back(o.size(), nullptr);

    // Initialize the state of debug info to indicate there is no current
    // debug info relevant. This sets |lastDebugLocation| to a dummy value,
    // so that later places with debug info can see that they differ from
    // it (without this, if we had some debug info, then a nullptr for none,
    // and then the same debug info, we could get confused).
    initializeDebugInfo();
  }
}

void WasmBinaryWriter::writeDebugLocation(Expression* curr, Function* func) {
  if (sourceMap) {
    auto& debugLocations = func->debugLocations;
    auto iter = debugLocations.find(curr);
    if (iter != debugLocations.end() && iter->second) {
      // There is debug information here, write it out.
      writeDebugLocation(*(iter->second));
    } else {
      // This expression has no debug location.
      writeNoDebugLocation();
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
    span.end = o.size();
  }
}

void WasmBinaryWriter::writeExtraDebugLocation(Expression* curr,
                                               Function* func,
                                               size_t id) {
  if (func && !func->expressionLocations.empty()) {
    binaryLocations.delimiters[curr][id] = o.size();
  }
}

void WasmBinaryWriter::writeData(const char* data, size_t size) {
  for (size_t i = 0; i < size; i++) {
    o << int8_t(data[i]);
  }
}

void WasmBinaryWriter::writeInlineString(std::string_view name) {
  o << U32LEB(name.size());
  writeData(name.data(), name.size());
}

static bool isHexDigit(char ch) {
  return (ch >= '0' && ch <= '9') || (ch >= 'a' && ch <= 'f') ||
         (ch >= 'A' && ch <= 'F');
}

static int decodeHexNibble(char ch) {
  return ch <= '9' ? ch & 15 : (ch & 15) + 9;
}

void WasmBinaryWriter::writeEscapedName(std::string_view name) {
  if (name.find('\\') == std::string_view::npos) {
    writeInlineString(name);
    return;
  }
  // decode escaped by escapeName (see below) function names
  std::string unescaped;
  for (size_t i = 0; i < name.size();) {
    char ch = name[i++];
    // support only `\xx` escapes; ignore invalid or unsupported escapes
    if (ch != '\\' || i + 1 >= name.size() || !isHexDigit(name[i]) ||
        !isHexDigit(name[i + 1])) {
      unescaped.push_back(ch);
      continue;
    }
    unescaped.push_back(
      char((decodeHexNibble(name[i]) << 4) | decodeHexNibble(name[i + 1])));
    i += 2;
  }
  writeInlineString({unescaped.data(), unescaped.size()});
}

void WasmBinaryWriter::writeInlineBuffer(const char* data, size_t size) {
  o << U32LEB(size);
  writeData(data, size);
}

void WasmBinaryWriter::writeType(Type type) {
  if (type.isRef()) {
    // The only reference types allowed without GC are funcref and externref. We
    // internally use more refined versions of those types, but we cannot emit
    // those more refined types.
    if (!wasm->features.hasGC()) {
      auto ht = type.getHeapType();
      if (ht.isMaybeShared(HeapType::string)) {
        // Do not overgeneralize stringref to anyref. We have tests that when a
        // stringref is expected, we actually get a stringref. If we see a
        // string, the stringref feature must be enabled.
        type = Type(HeapTypes::string.getBasic(ht.getShared()), Nullable);
      } else {
        type = Type(type.getHeapType().getTop(), Nullable);
      }
    }
    auto heapType = type.getHeapType();
    if (type.isNullable() && heapType.isBasic() && !heapType.isShared()) {
      switch (heapType.getBasic(Unshared)) {
        case HeapType::ext:
          o << S32LEB(BinaryConsts::EncodedType::externref);
          return;
        case HeapType::any:
          o << S32LEB(BinaryConsts::EncodedType::anyref);
          return;
        case HeapType::func:
          o << S32LEB(BinaryConsts::EncodedType::funcref);
          return;
        case HeapType::cont:
          o << S32LEB(BinaryConsts::EncodedType::contref);
          return;
        case HeapType::eq:
          o << S32LEB(BinaryConsts::EncodedType::eqref);
          return;
        case HeapType::i31:
          o << S32LEB(BinaryConsts::EncodedType::i31ref);
          return;
        case HeapType::struct_:
          o << S32LEB(BinaryConsts::EncodedType::structref);
          return;
        case HeapType::array:
          o << S32LEB(BinaryConsts::EncodedType::arrayref);
          return;
        case HeapType::exn:
          o << S32LEB(BinaryConsts::EncodedType::exnref);
          return;
        case HeapType::string:
          o << S32LEB(BinaryConsts::EncodedType::stringref);
          return;
        case HeapType::none:
          o << S32LEB(BinaryConsts::EncodedType::nullref);
          return;
        case HeapType::noext:
          o << S32LEB(BinaryConsts::EncodedType::nullexternref);
          return;
        case HeapType::nofunc:
          o << S32LEB(BinaryConsts::EncodedType::nullfuncref);
          return;
        case HeapType::noexn:
          o << S32LEB(BinaryConsts::EncodedType::nullexnref);
          return;
        case HeapType::nocont:
          o << S32LEB(BinaryConsts::EncodedType::nullcontref);
          return;
      }
    }
    if (type.isNullable()) {
      o << S32LEB(BinaryConsts::EncodedType::nullable);
    } else {
      o << S32LEB(BinaryConsts::EncodedType::nonnullable);
    }
    writeHeapType(type.getHeapType());
    return;
  }
  int ret = 0;
  TODO_SINGLE_COMPOUND(type);
  switch (type.getBasic()) {
    // None only used for block signatures. TODO: Separate out?
    case Type::none:
      ret = BinaryConsts::EncodedType::Empty;
      break;
    case Type::i32:
      ret = BinaryConsts::EncodedType::i32;
      break;
    case Type::i64:
      ret = BinaryConsts::EncodedType::i64;
      break;
    case Type::f32:
      ret = BinaryConsts::EncodedType::f32;
      break;
    case Type::f64:
      ret = BinaryConsts::EncodedType::f64;
      break;
    case Type::v128:
      ret = BinaryConsts::EncodedType::v128;
      break;
    default:
      WASM_UNREACHABLE("unexpected type");
  }
  o << S32LEB(ret);
}

void WasmBinaryWriter::writeHeapType(HeapType type) {
  // ref.null always has a bottom heap type in Binaryen IR, but those types are
  // only actually valid with GC. Otherwise, emit the corresponding valid top
  // types instead.
  if (!wasm->features.hasGC()) {
    type = type.getTop();
  }

  if (!type.isBasic()) {
    o << S64LEB(getTypeIndex(type)); // TODO: Actually s33
    return;
  }

  int ret = 0;
  if (type.isShared()) {
    o << S32LEB(BinaryConsts::EncodedType::Shared);
  }
  switch (type.getBasic(Unshared)) {
    case HeapType::ext:
      ret = BinaryConsts::EncodedHeapType::ext;
      break;
    case HeapType::func:
      ret = BinaryConsts::EncodedHeapType::func;
      break;
    case HeapType::cont:
      ret = BinaryConsts::EncodedHeapType::cont;
      break;
    case HeapType::any:
      ret = BinaryConsts::EncodedHeapType::any;
      break;
    case HeapType::eq:
      ret = BinaryConsts::EncodedHeapType::eq;
      break;
    case HeapType::i31:
      ret = BinaryConsts::EncodedHeapType::i31;
      break;
    case HeapType::struct_:
      ret = BinaryConsts::EncodedHeapType::struct_;
      break;
    case HeapType::array:
      ret = BinaryConsts::EncodedHeapType::array;
      break;
    case HeapType::exn:
      ret = BinaryConsts::EncodedHeapType::exn;
      break;
    case HeapType::string:
      ret = BinaryConsts::EncodedHeapType::string;
      break;
    case HeapType::none:
      ret = BinaryConsts::EncodedHeapType::none;
      break;
    case HeapType::noext:
      ret = BinaryConsts::EncodedHeapType::noext;
      break;
    case HeapType::nofunc:
      ret = BinaryConsts::EncodedHeapType::nofunc;
      break;
    case HeapType::noexn:
      ret = BinaryConsts::EncodedHeapType::noexn;
      break;
    case HeapType::nocont:
      ret = BinaryConsts::EncodedHeapType::nocont;
      break;
  }
  o << S64LEB(ret); // TODO: Actually s33
}

void WasmBinaryWriter::writeIndexedHeapType(HeapType type) {
  o << U32LEB(getTypeIndex(type));
}

void WasmBinaryWriter::writeField(const Field& field) {
  if (field.type == Type::i32 && field.packedType != Field::not_packed) {
    if (field.packedType == Field::i8) {
      o << S32LEB(BinaryConsts::EncodedType::i8);
    } else if (field.packedType == Field::i16) {
      o << S32LEB(BinaryConsts::EncodedType::i16);
    } else {
      WASM_UNREACHABLE("invalid packed type");
    }
  } else {
    writeType(field.type);
  }
  o << U32LEB(field.mutable_);
}

// reader

WasmBinaryReader::WasmBinaryReader(Module& wasm,
                                   FeatureSet features,
                                   const std::vector<char>& input)
  : wasm(wasm), allocator(wasm.allocator), input(input), sourceMap(nullptr),
    nextDebugPos(0), nextDebugLocation{0, 0, 0},
    nextDebugLocationHasDebugInfo(false), debugLocation() {
  wasm.features = features;
}

bool WasmBinaryReader::hasDWARFSections() {
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
    if (sectionCode == BinaryConsts::Section::Custom) {
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

void WasmBinaryReader::read() {
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
    if (sectionCode != BinaryConsts::Section::Custom &&
        !seenSections.insert(sectionCode).second) {
      throwError("section seen more than once: " + std::to_string(sectionCode));
    }

    switch (sectionCode) {
      case BinaryConsts::Section::Start:
        readStart();
        break;
      case BinaryConsts::Section::Memory:
        readMemories();
        break;
      case BinaryConsts::Section::Type:
        readTypes();
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
        readElementSegments();
        break;
      case BinaryConsts::Section::Strings:
        readStrings();
        break;
      case BinaryConsts::Section::Global:
        readGlobals();
        break;
      case BinaryConsts::Section::Data:
        readDataSegments();
        break;
      case BinaryConsts::Section::DataCount:
        readDataSegmentCount();
        break;
      case BinaryConsts::Section::Table:
        readTableDeclarations();
        break;
      case BinaryConsts::Section::Tag:
        readTags();
        break;
      case BinaryConsts::Section::Custom: {
        readCustomSection(payloadLen);
        if (pos > oldPos + payloadLen) {
          throwError("bad user section size, started at " +
                     std::to_string(oldPos) + " plus payload " +
                     std::to_string(payloadLen) +
                     " not being equal to new position " + std::to_string(pos));
        }
        pos = oldPos + payloadLen;
        break;
      }
      default:
        throwError(std::string("unrecognized section ID: ") +
                   std::to_string(sectionCode));
    }

    // make sure we advanced exactly past this section
    if (pos != oldPos + payloadLen) {
      throwError("bad section size, started at " + std::to_string(oldPos) +
                 " plus payload " + std::to_string(payloadLen) +
                 " not being equal to new position " + std::to_string(pos));
    }
  }

  validateBinary();
  processNames();
}

void WasmBinaryReader::readCustomSection(size_t payloadLen) {
  BYN_TRACE("== readCustomSection\n");
  auto oldPos = pos;
  Name sectionName = getInlineString();
  size_t read = pos - oldPos;
  if (read > payloadLen) {
    throwError("bad user section size");
  }
  payloadLen -= read;
  if (sectionName.equals(BinaryConsts::CustomSections::Name)) {
    if (debugInfo) {
      readNames(payloadLen);
    } else {
      pos += payloadLen;
    }
  } else if (sectionName.equals(BinaryConsts::CustomSections::TargetFeatures)) {
    readFeatures(payloadLen);
  } else if (sectionName.equals(BinaryConsts::CustomSections::Dylink)) {
    readDylink(payloadLen);
  } else if (sectionName.equals(BinaryConsts::CustomSections::Dylink0)) {
    readDylink0(payloadLen);
  } else {
    // an unfamiliar custom section
    if (sectionName.equals(BinaryConsts::CustomSections::Linking)) {
      std::cerr
        << "warning: linking section is present, so this is not a standard "
           "wasm file - binaryen cannot handle this properly!\n";
    }
    wasm.customSections.resize(wasm.customSections.size() + 1);
    auto& section = wasm.customSections.back();
    section.name = sectionName.str;
    auto data = getByteView(payloadLen);
    section.data = {data.begin(), data.end()};
  }
}

std::string_view WasmBinaryReader::getByteView(size_t size) {
  if (size > input.size() || pos > input.size() - size) {
    throwError("unexpected end of input");
  }
  pos += size;
  return {input.data() + (pos - size), size};
}

uint8_t WasmBinaryReader::getInt8() {
  if (!more()) {
    throwError("unexpected end of input");
  }
  BYN_TRACE("getInt8: " << (int)(uint8_t)input[pos] << " (at " << pos << ")\n");
  return input[pos++];
}

uint16_t WasmBinaryReader::getInt16() {
  BYN_TRACE("<==\n");
  auto ret = uint16_t(getInt8());
  ret |= uint16_t(getInt8()) << 8;
  BYN_TRACE("getInt16: " << ret << "/0x" << std::hex << ret << std::dec
                         << " ==>\n");
  return ret;
}

uint32_t WasmBinaryReader::getInt32() {
  BYN_TRACE("<==\n");
  auto ret = uint32_t(getInt16());
  ret |= uint32_t(getInt16()) << 16;
  BYN_TRACE("getInt32: " << ret << "/0x" << std::hex << ret << std::dec
                         << " ==>\n");
  return ret;
}

uint64_t WasmBinaryReader::getInt64() {
  BYN_TRACE("<==\n");
  auto ret = uint64_t(getInt32());
  ret |= uint64_t(getInt32()) << 32;
  BYN_TRACE("getInt64: " << ret << "/0x" << std::hex << ret << std::dec
                         << " ==>\n");
  return ret;
}

uint8_t WasmBinaryReader::getLaneIndex(size_t lanes) {
  BYN_TRACE("<==\n");
  auto ret = getInt8();
  if (ret >= lanes) {
    throwError("Illegal lane index");
  }
  BYN_TRACE("getLaneIndex(" << lanes << "): " << ret << " ==>" << std::endl);
  return ret;
}

Literal WasmBinaryReader::getFloat32Literal() {
  BYN_TRACE("<==\n");
  auto ret = Literal(getInt32());
  ret = ret.castToF32();
  BYN_TRACE("getFloat32: " << ret << " ==>\n");
  return ret;
}

Literal WasmBinaryReader::getFloat64Literal() {
  BYN_TRACE("<==\n");
  auto ret = Literal(getInt64());
  ret = ret.castToF64();
  BYN_TRACE("getFloat64: " << ret << " ==>\n");
  return ret;
}

Literal WasmBinaryReader::getVec128Literal() {
  BYN_TRACE("<==\n");
  std::array<uint8_t, 16> bytes;
  for (auto i = 0; i < 16; ++i) {
    bytes[i] = getInt8();
  }
  auto ret = Literal(bytes.data());
  BYN_TRACE("getVec128: " << ret << " ==>\n");
  return ret;
}

uint32_t WasmBinaryReader::getU32LEB() {
  BYN_TRACE("<==\n");
  U32LEB ret;
  ret.read([&]() { return getInt8(); });
  BYN_TRACE("getU32LEB: " << ret.value << " ==>\n");
  return ret.value;
}

uint64_t WasmBinaryReader::getU64LEB() {
  BYN_TRACE("<==\n");
  U64LEB ret;
  ret.read([&]() { return getInt8(); });
  BYN_TRACE("getU64LEB: " << ret.value << " ==>\n");
  return ret.value;
}

int32_t WasmBinaryReader::getS32LEB() {
  BYN_TRACE("<==\n");
  S32LEB ret;
  ret.read([&]() { return (int8_t)getInt8(); });
  BYN_TRACE("getS32LEB: " << ret.value << " ==>\n");
  return ret.value;
}

int64_t WasmBinaryReader::getS64LEB() {
  BYN_TRACE("<==\n");
  S64LEB ret;
  ret.read([&]() { return (int8_t)getInt8(); });
  BYN_TRACE("getS64LEB: " << ret.value << " ==>\n");
  return ret.value;
}

bool WasmBinaryReader::getBasicType(int32_t code, Type& out) {
  switch (code) {
    case BinaryConsts::EncodedType::i32:
      out = Type::i32;
      return true;
    case BinaryConsts::EncodedType::i64:
      out = Type::i64;
      return true;
    case BinaryConsts::EncodedType::f32:
      out = Type::f32;
      return true;
    case BinaryConsts::EncodedType::f64:
      out = Type::f64;
      return true;
    case BinaryConsts::EncodedType::v128:
      out = Type::v128;
      return true;
    case BinaryConsts::EncodedType::funcref:
      out = Type(HeapType::func, Nullable);
      return true;
    case BinaryConsts::EncodedType::contref:
      out = Type(HeapType::cont, Nullable);
      return true;
    case BinaryConsts::EncodedType::externref:
      out = Type(HeapType::ext, Nullable);
      return true;
    case BinaryConsts::EncodedType::anyref:
      out = Type(HeapType::any, Nullable);
      return true;
    case BinaryConsts::EncodedType::eqref:
      out = Type(HeapType::eq, Nullable);
      return true;
    case BinaryConsts::EncodedType::i31ref:
      out = Type(HeapType::i31, Nullable);
      return true;
    case BinaryConsts::EncodedType::structref:
      out = Type(HeapType::struct_, Nullable);
      return true;
    case BinaryConsts::EncodedType::arrayref:
      out = Type(HeapType::array, Nullable);
      return true;
    case BinaryConsts::EncodedType::exnref:
      out = Type(HeapType::exn, Nullable);
      return true;
    case BinaryConsts::EncodedType::stringref:
      out = Type(HeapType::string, Nullable);
      return true;
    case BinaryConsts::EncodedType::nullref:
      out = Type(HeapType::none, Nullable);
      return true;
    case BinaryConsts::EncodedType::nullexternref:
      out = Type(HeapType::noext, Nullable);
      return true;
    case BinaryConsts::EncodedType::nullfuncref:
      out = Type(HeapType::nofunc, Nullable);
      return true;
    case BinaryConsts::EncodedType::nullexnref:
      out = Type(HeapType::noexn, Nullable);
      return true;
    case BinaryConsts::EncodedType::nullcontref:
      out = Type(HeapType::nocont, Nullable);
      return true;
    default:
      return false;
  }
}

bool WasmBinaryReader::getBasicHeapType(int64_t code, HeapType& out) {
  switch (code) {
    case BinaryConsts::EncodedHeapType::func:
      out = HeapType::func;
      return true;
    case BinaryConsts::EncodedHeapType::cont:
      out = HeapType::cont;
      return true;
    case BinaryConsts::EncodedHeapType::ext:
      out = HeapType::ext;
      return true;
    case BinaryConsts::EncodedHeapType::any:
      out = HeapType::any;
      return true;
    case BinaryConsts::EncodedHeapType::eq:
      out = HeapType::eq;
      return true;
    case BinaryConsts::EncodedHeapType::i31:
      out = HeapType::i31;
      return true;
    case BinaryConsts::EncodedHeapType::struct_:
      out = HeapType::struct_;
      return true;
    case BinaryConsts::EncodedHeapType::array:
      out = HeapType::array;
      return true;
    case BinaryConsts::EncodedHeapType::exn:
      out = HeapType::exn;
      return true;
    case BinaryConsts::EncodedHeapType::string:
      out = HeapType::string;
      return true;
    case BinaryConsts::EncodedHeapType::none:
      out = HeapType::none;
      return true;
    case BinaryConsts::EncodedHeapType::noext:
      out = HeapType::noext;
      return true;
    case BinaryConsts::EncodedHeapType::nofunc:
      out = HeapType::nofunc;
      return true;
    case BinaryConsts::EncodedHeapType::noexn:
      out = HeapType::noexn;
      return true;
    case BinaryConsts::EncodedHeapType::nocont:
      out = HeapType::nocont;
      return true;
    default:
      return false;
  }
}

Type WasmBinaryReader::getType(int initial) {
  // Single value types are negative; signature indices are non-negative
  if (initial >= 0) {
    // TODO: Handle block input types properly.
    auto sig = getSignatureByTypeIndex(initial);
    if (sig.params != Type::none) {
      throwError("control flow inputs are not supported yet");
    }
    return sig.results;
  }
  Type type;
  if (getBasicType(initial, type)) {
    return type;
  }
  switch (initial) {
    // None only used for block signatures. TODO: Separate out?
    case BinaryConsts::EncodedType::Empty:
      return Type::none;
    case BinaryConsts::EncodedType::nullable:
      return Type(getHeapType(), Nullable);
    case BinaryConsts::EncodedType::nonnullable:
      return Type(getHeapType(), NonNullable);
    default:
      throwError("invalid wasm type: " + std::to_string(initial));
  }
  WASM_UNREACHABLE("unexpected type");
}

Type WasmBinaryReader::getType() { return getType(getS32LEB()); }

HeapType WasmBinaryReader::getHeapType() {
  auto type = getS64LEB(); // TODO: Actually s33
  // Single heap types are negative; heap type indices are non-negative
  if (type >= 0) {
    if (size_t(type) >= types.size()) {
      throwError("invalid signature index: " + std::to_string(type));
    }
    return types[type];
  }
  auto share = Unshared;
  if (type == BinaryConsts::EncodedType::Shared) {
    share = Shared;
    type = getS64LEB(); // TODO: Actually s33
  }
  HeapType ht;
  if (getBasicHeapType(type, ht)) {
    return ht.getBasic(share);
  } else {
    throwError("invalid wasm heap type: " + std::to_string(type));
  }
  WASM_UNREACHABLE("unexpected type");
}

HeapType WasmBinaryReader::getIndexedHeapType() {
  auto index = getU32LEB();
  if (index >= types.size()) {
    throwError("invalid heap type index: " + std::to_string(index));
  }
  return types[index];
}

Type WasmBinaryReader::getConcreteType() {
  auto type = getType();
  if (!type.isConcrete()) {
    throwError("non-concrete type when one expected");
  }
  return type;
}

Name WasmBinaryReader::getInlineString(bool requireValid) {
  BYN_TRACE("<==\n");
  auto len = getU32LEB();
  auto data = getByteView(len);
  if (requireValid && !String::isUTF8(data)) {
    throwError("invalid UTF-8 string");
  }
  BYN_TRACE("getInlineString: " << data << " ==>\n");
  return Name(data);
}

void WasmBinaryReader::verifyInt8(int8_t x) {
  int8_t y = getInt8();
  if (x != y) {
    throwError("surprising value");
  }
}

void WasmBinaryReader::verifyInt16(int16_t x) {
  int16_t y = getInt16();
  if (x != y) {
    throwError("surprising value");
  }
}

void WasmBinaryReader::verifyInt32(int32_t x) {
  int32_t y = getInt32();
  if (x != y) {
    throwError("surprising value");
  }
}

void WasmBinaryReader::verifyInt64(int64_t x) {
  int64_t y = getInt64();
  if (x != y) {
    throwError("surprising value");
  }
}

void WasmBinaryReader::readHeader() {
  BYN_TRACE("== readHeader\n");
  verifyInt32(BinaryConsts::Magic);
  auto version = getInt32();
  if (version != BinaryConsts::Version) {
    if (version == 0x1000d) {
      throwError("this looks like a wasm component, which Binaryen does not "
                 "support yet (see "
                 "https://github.com/WebAssembly/binaryen/issues/6728)");
    }
    throwError("invalid version");
  }
}

void WasmBinaryReader::readStart() {
  BYN_TRACE("== readStart\n");
  startIndex = getU32LEB();
}

static Name makeName(std::string prefix, size_t counter) {
  return Name(prefix + std::to_string(counter));
}

void WasmBinaryReader::readMemories() {
  BYN_TRACE("== readMemories\n");
  auto num = getU32LEB();
  BYN_TRACE("num: " << num << std::endl);
  for (size_t i = 0; i < num; i++) {
    BYN_TRACE("read one\n");
    auto memory = Builder::makeMemory(makeName("", i));
    getResizableLimits(memory->initial,
                       memory->max,
                       memory->shared,
                       memory->indexType,
                       Memory::kUnlimitedSize);
    wasm.addMemory(std::move(memory));
  }
}

void WasmBinaryReader::readTypes() {
  BYN_TRACE("== readTypes\n");
  TypeBuilder builder(getU32LEB());
  BYN_TRACE("num: " << builder.size() << std::endl);

  auto readHeapType = [&]() -> HeapType {
    int64_t htCode = getS64LEB(); // TODO: Actually s33
    auto share = Unshared;
    if (htCode == BinaryConsts::EncodedType::Shared) {
      share = Shared;
      htCode = getS64LEB(); // TODO: Actually s33
    }
    HeapType ht;
    if (getBasicHeapType(htCode, ht)) {
      return ht.getBasic(share);
    }
    if (size_t(htCode) >= builder.size()) {
      throwError("invalid type index: " + std::to_string(htCode));
    }
    return builder.getTempHeapType(size_t(htCode));
  };
  auto makeType = [&](int32_t typeCode) {
    Type type;
    if (getBasicType(typeCode, type)) {
      return type;
    }

    switch (typeCode) {
      case BinaryConsts::EncodedType::nullable:
      case BinaryConsts::EncodedType::nonnullable: {
        auto nullability = typeCode == BinaryConsts::EncodedType::nullable
                             ? Nullable
                             : NonNullable;

        HeapType ht = readHeapType();
        if (ht.isBasic()) {
          return Type(ht, nullability);
        }

        return builder.getTempRefType(ht, nullability);
      }
      default:
        throwError("unexpected type index: " + std::to_string(typeCode));
    }
    WASM_UNREACHABLE("unexpected type");
  };
  auto readType = [&]() { return makeType(getS32LEB()); };

  auto readSignatureDef = [&]() {
    std::vector<Type> params;
    std::vector<Type> results;
    size_t numParams = getU32LEB();
    BYN_TRACE("num params: " << numParams << std::endl);
    for (size_t j = 0; j < numParams; j++) {
      params.push_back(readType());
    }
    auto numResults = getU32LEB();
    BYN_TRACE("num results: " << numResults << std::endl);
    for (size_t j = 0; j < numResults; j++) {
      results.push_back(readType());
    }
    return Signature(builder.getTempTupleType(params),
                     builder.getTempTupleType(results));
  };

  auto readContinuationDef = [&]() {
    HeapType ht = readHeapType();
    if (!ht.isSignature()) {
      throw ParseException("cont types must be built from function types");
    }
    return Continuation(ht);
  };

  auto readMutability = [&]() {
    switch (getU32LEB()) {
      case 0:
        return Immutable;
      case 1:
        return Mutable;
      default:
        throw ParseException("Expected 0 or 1 for mutability");
    }
  };

  auto readFieldDef = [&]() {
    // The value may be a general wasm type, or one of the types only possible
    // in a field.
    auto typeCode = getS32LEB();
    if (typeCode == BinaryConsts::EncodedType::i8) {
      auto mutable_ = readMutability();
      return Field(Field::i8, mutable_);
    }
    if (typeCode == BinaryConsts::EncodedType::i16) {
      auto mutable_ = readMutability();
      return Field(Field::i16, mutable_);
    }
    // It's a regular wasm value.
    auto type = makeType(typeCode);
    auto mutable_ = readMutability();
    return Field(type, mutable_);
  };

  auto readStructDef = [&]() {
    FieldList fields;
    size_t numFields = getU32LEB();
    BYN_TRACE("num fields: " << numFields << std::endl);
    for (size_t j = 0; j < numFields; j++) {
      fields.push_back(readFieldDef());
    }
    return Struct(std::move(fields));
  };

  for (size_t i = 0; i < builder.size(); i++) {
    BYN_TRACE("read one\n");
    auto form = getInt8();
    if (form == BinaryConsts::EncodedType::Rec) {
      uint32_t groupSize = getU32LEB();
      if (groupSize == 0u) {
        // TODO: Support groups of size zero by shrinking the builder.
        throwError("Recursion groups of size zero not supported");
      }
      // The group counts as one element in the type section, so we have to
      // allocate space for the extra types.
      builder.grow(groupSize - 1);
      builder.createRecGroup(i, groupSize);
      form = getInt8();
    }
    std::optional<uint32_t> superIndex;
    if (form == BinaryConsts::EncodedType::Sub ||
        form == BinaryConsts::EncodedType::SubFinal) {
      if (form == BinaryConsts::EncodedType::Sub) {
        builder[i].setOpen();
      }
      uint32_t supers = getU32LEB();
      if (supers > 0) {
        if (supers != 1) {
          throwError("Invalid type definition with " + std::to_string(supers) +
                     " supertypes");
        }
        superIndex = getU32LEB();
      }
      form = getInt8();
    }
    if (form == BinaryConsts::SharedDef) {
      builder[i].setShared();
      form = getInt8();
    }
    if (form == BinaryConsts::EncodedType::Func) {
      builder[i] = readSignatureDef();
    } else if (form == BinaryConsts::EncodedType::Cont) {
      builder[i] = readContinuationDef();
    } else if (form == BinaryConsts::EncodedType::Struct) {
      builder[i] = readStructDef();
    } else if (form == BinaryConsts::EncodedType::Array) {
      builder[i] = Array(readFieldDef());
    } else {
      throwError("Bad type form " + std::to_string(form));
    }
    if (superIndex) {
      if (*superIndex > builder.size()) {
        throwError("Out of bounds supertype index " +
                   std::to_string(*superIndex));
      }
      builder[i].subTypeOf(builder[*superIndex]);
    }
  }

  auto result = builder.build();
  if (auto* err = result.getError()) {
    Fatal() << "Invalid type: " << err->reason << " at index " << err->index;
  }
  types = *result;
}

Name WasmBinaryReader::getFunctionName(Index index) {
  if (index >= wasm.functions.size()) {
    throwError("invalid function index");
  }
  return wasm.functions[index]->name;
}

Name WasmBinaryReader::getTableName(Index index) {
  if (index >= wasm.tables.size()) {
    throwError("invalid table index");
  }
  return wasm.tables[index]->name;
}

Name WasmBinaryReader::getMemoryName(Index index) {
  if (index >= wasm.memories.size()) {
    throwError("invalid memory index");
  }
  return wasm.memories[index]->name;
}

Name WasmBinaryReader::getGlobalName(Index index) {
  if (index >= wasm.globals.size()) {
    throwError("invalid global index");
  }
  return wasm.globals[index]->name;
}

Table* WasmBinaryReader::getTable(Index index) {
  if (index < wasm.tables.size()) {
    return wasm.tables[index].get();
  }
  throwError("Table index out of range.");
}

Name WasmBinaryReader::getTagName(Index index) {
  if (index >= wasm.tags.size()) {
    throwError("invalid tag index");
  }
  return wasm.tags[index]->name;
}

Name WasmBinaryReader::getDataName(Index index) {
  if (index >= wasm.dataSegments.size()) {
    throwError("invalid data segment index");
  }
  return wasm.dataSegments[index]->name;
}

Name WasmBinaryReader::getElemName(Index index) {
  if (index >= wasm.elementSegments.size()) {
    throwError("invalid element segment index");
  }
  return wasm.elementSegments[index]->name;
}

Memory* WasmBinaryReader::getMemory(Index index) {
  if (index < wasm.memories.size()) {
    return wasm.memories[index].get();
  }
  throwError("Memory index out of range.");
}

void WasmBinaryReader::getResizableLimits(Address& initial,
                                          Address& max,
                                          bool& shared,
                                          Type& indexType,
                                          Address defaultIfNoMax) {
  auto flags = getU32LEB();
  bool hasMax = (flags & BinaryConsts::HasMaximum) != 0;
  bool isShared = (flags & BinaryConsts::IsShared) != 0;
  bool is64 = (flags & BinaryConsts::Is64) != 0;
  initial = is64 ? getU64LEB() : getU32LEB();
  if (isShared && !hasMax) {
    throwError("shared memory must have max size");
  }
  shared = isShared;
  indexType = is64 ? Type::i64 : Type::i32;
  if (hasMax) {
    max = is64 ? getU64LEB() : getU32LEB();
  } else {
    max = defaultIfNoMax;
  }
}

void WasmBinaryReader::readImports() {
  BYN_TRACE("== readImports\n");
  size_t num = getU32LEB();
  BYN_TRACE("num: " << num << std::endl);
  Builder builder(wasm);
  size_t tableCounter = 0;
  size_t memoryCounter = 0;
  size_t functionCounter = 0;
  size_t globalCounter = 0;
  size_t tagCounter = 0;
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
        Name name = makeName("fimport$", functionCounter++);
        auto index = getU32LEB();
        functionTypes.push_back(getTypeByIndex(index));
        auto type = getTypeByIndex(index);
        if (!type.isSignature()) {
          throwError(std::string("Imported function ") + module.toString() +
                     '.' + base.toString() +
                     "'s type must be a signature. Given: " + type.toString());
        }
        auto curr = builder.makeFunction(name, type, {});
        curr->module = module;
        curr->base = base;
        wasm.addFunction(std::move(curr));
        break;
      }
      case ExternalKind::Table: {
        auto table = builder.makeTable(makeName("timport$", tableCounter++));
        table->module = module;
        table->base = base;
        table->type = getType();

        bool is_shared;
        getResizableLimits(table->initial,
                           table->max,
                           is_shared,
                           table->indexType,
                           Table::kUnlimitedSize);
        if (is_shared) {
          throwError("Tables may not be shared");
        }

        wasm.addTable(std::move(table));
        break;
      }
      case ExternalKind::Memory: {
        auto memory = builder.makeMemory(makeName("mimport$", memoryCounter++));
        memory->module = module;
        memory->base = base;
        getResizableLimits(memory->initial,
                           memory->max,
                           memory->shared,
                           memory->indexType,
                           Memory::kUnlimitedSize);
        wasm.addMemory(std::move(memory));
        break;
      }
      case ExternalKind::Global: {
        auto type = getConcreteType();
        auto mutable_ = getU32LEB();
        if (mutable_ & ~1) {
          throwError("Global mutability must be 0 or 1");
        }
        auto curr =
          builder.makeGlobal(makeName("gimport$", globalCounter++),
                             type,
                             nullptr,
                             mutable_ ? Builder::Mutable : Builder::Immutable);
        curr->module = module;
        curr->base = base;
        wasm.addGlobal(std::move(curr));
        break;
      }
      case ExternalKind::Tag: {
        Name name = makeName("eimport$", tagCounter++);
        getInt8(); // Reserved 'attribute' field
        auto index = getU32LEB();
        auto curr = builder.makeTag(name, getSignatureByTypeIndex(index));
        curr->module = module;
        curr->base = base;
        wasm.addTag(std::move(curr));
        break;
      }
      default: {
        throwError("bad import kind");
      }
    }
  }
}

Name WasmBinaryReader::getNextLabel() {
  requireFunctionContext("getting a label");
  return makeName("label$", nextLabel++);
}

void WasmBinaryReader::requireFunctionContext(const char* error) {
  if (!currFunction) {
    throwError(std::string("in a non-function context: ") + error);
  }
}

void WasmBinaryReader::readFunctionSignatures() {
  BYN_TRACE("== readFunctionSignatures\n");
  size_t num = getU32LEB();
  BYN_TRACE("num: " << num << std::endl);
  for (size_t i = 0; i < num; i++) {
    BYN_TRACE("read one\n");
    auto index = getU32LEB();
    functionTypes.push_back(getTypeByIndex(index));
    // Check that the type is a signature.
    getSignatureByTypeIndex(index);
  }
}

HeapType WasmBinaryReader::getTypeByIndex(Index index) {
  if (index >= types.size()) {
    throwError("invalid type index " + std::to_string(index) + " / " +
               std::to_string(types.size()));
  }
  return types[index];
}

HeapType WasmBinaryReader::getTypeByFunctionIndex(Index index) {
  if (index >= functionTypes.size()) {
    throwError("invalid function index");
  }
  return functionTypes[index];
}

Signature WasmBinaryReader::getSignatureByTypeIndex(Index index) {
  auto heapType = getTypeByIndex(index);
  if (!heapType.isSignature()) {
    throwError("invalid signature type " + heapType.toString());
  }
  return heapType.getSignature();
}

Signature WasmBinaryReader::getSignatureByFunctionIndex(Index index) {
  auto heapType = getTypeByFunctionIndex(index);
  if (!heapType.isSignature()) {
    throwError("invalid signature type " + heapType.toString());
  }
  return heapType.getSignature();
}

void WasmBinaryReader::readFunctions() {
  BYN_TRACE("== readFunctions\n");
  auto numImports = wasm.functions.size();
  size_t total = getU32LEB();
  if (total != functionTypes.size() - numImports) {
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

    auto func = std::make_unique<Function>();
    func->name = makeName("", i);
    func->type = getTypeByFunctionIndex(numImports + i);
    currFunction = func.get();

    if (DWARF) {
      func->funcLocation = BinaryLocations::FunctionLocations{
        BinaryLocation(sizePos - codeSectionLocation),
        BinaryLocation(pos - codeSectionLocation),
        BinaryLocation(pos - codeSectionLocation + size)};
    }

    readNextDebugLocation();

    BYN_TRACE("reading " << i << std::endl);

    readVars();

    func->prologLocation = debugLocation;
    {
      // process the function body
      BYN_TRACE("processing function: " << i << std::endl);
      nextLabel = 0;
      willBeIgnored = false;
      // process body
      assert(breakStack.empty());
      assert(breakTargetNames.empty());
      assert(exceptionTargetNames.empty());
      assert(expressionStack.empty());
      assert(controlFlowStack.empty());
      assert(depth == 0);
      // Even if we are skipping function bodies we need to not skip the start
      // function. That contains important code for wasm-emscripten-finalize in
      // the form of pthread-related segment initializations. As this is just
      // one function, it doesn't add significant time, so the optimization of
      // skipping bodies is still very useful.
      auto currFunctionIndex = wasm.functions.size();
      bool isStart = startIndex == currFunctionIndex;
      if (!skipFunctionBodies || isStart) {
        func->body = getBlockOrSingleton(func->getResults());
      } else {
        // When skipping the function body we need to put something valid in
        // their place so we validate. An unreachable is always acceptable
        // there.
        func->body = Builder(wasm).makeUnreachable();

        // Skip reading the contents.
        pos = endOfFunction;
      }
      assert(depth == 0);
      assert(breakStack.empty());
      assert(breakTargetNames.empty());
      if (!exceptionTargetNames.empty()) {
        // A delegate index existed that did not end up referring to any valid
        // outer try-catch (we remove valid ones from exceptionTargetNames as we
        // go).
        throwError("exceptionTargetNames not empty - invalid delegate");
      }
      if (!expressionStack.empty()) {
        throwError("stack not empty on function exit");
      }
      assert(controlFlowStack.empty());
      if (pos != endOfFunction) {
        throwError("binary offset at function exit not at expected location");
      }
    }

    TypeUpdating::handleNonDefaultableLocals(func.get(), wasm);

    std::swap(func->epilogLocation, debugLocation);
    currFunction = nullptr;
    debugLocation.clear();
    wasm.addFunction(std::move(func));
  }
  BYN_TRACE(" end function bodies\n");
}

void WasmBinaryReader::readVars() {
  uint32_t totalVars = 0;
  size_t numLocalTypes = getU32LEB();
  for (size_t t = 0; t < numLocalTypes; t++) {
    auto num = getU32LEB();
    // The core spec allows up to 2^32 locals, but to avoid allocation failures,
    // we additionally impose a much smaller limit, matching the JS embedding.
    if (std::ckd_add(&totalVars, totalVars, num) ||
        totalVars > WebLimitations::MaxFunctionLocals) {
      throwError("too many locals");
    }
    auto type = getConcreteType();

    while (num > 0) {
      currFunction->vars.push_back(type);
      num--;
    }
  }
}

void WasmBinaryReader::readExports() {
  BYN_TRACE("== readExports\n");
  size_t num = getU32LEB();
  BYN_TRACE("num: " << num << std::endl);
  std::unordered_set<Name> names;
  for (size_t i = 0; i < num; i++) {
    BYN_TRACE("read one\n");
    auto curr = std::make_unique<Export>();
    curr->name = getInlineString();
    if (!names.emplace(curr->name).second) {
      throwError("duplicate export name");
    }
    curr->kind = (ExternalKind)getU32LEB();
    auto index = getU32LEB();
    exportIndices[curr.get()] = index;
    exportOrder.push_back(std::move(curr));
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

void WasmBinaryReader::readSourceMapHeader() {
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
    nextDebugPos = 0;
    return;
  }
  // read first debug location
  // TODO: Handle the case where the very first one has only a position but not
  //       debug info. In practice that does not happen, which needs
  //       investigation (if it does, it will assert in readBase64VLQ, so it
  //       would not be a silent error at least).
  uint32_t position = readBase64VLQ(*sourceMap);
  nextDebugPos = position;

  auto peek = sourceMap->peek();
  if (peek == ',' || peek == '\"') {
    // This is a 1-length entry, so the next location has no debug info.
    nextDebugLocationHasDebugInfo = false;
  } else {
    uint32_t fileIndex = readBase64VLQ(*sourceMap);
    uint32_t lineNumber =
      readBase64VLQ(*sourceMap) + 1; // adjust zero-based line number
    uint32_t columnNumber = readBase64VLQ(*sourceMap);
    nextDebugLocation = {fileIndex, lineNumber, columnNumber};
    nextDebugLocationHasDebugInfo = true;
  }
}

void WasmBinaryReader::readNextDebugLocation() {
  if (!sourceMap) {
    return;
  }

  if (nextDebugPos == 0) {
    // We reached the end of the source map; nothing left to read.
    return;
  }

  while (nextDebugPos && nextDebugPos <= pos) {
    debugLocation.clear();
    // use debugLocation only for function expressions
    if (currFunction) {
      if (nextDebugLocationHasDebugInfo) {
        debugLocation.insert(nextDebugLocation);
      } else {
        debugLocation.clear();
      }
    }

    char ch;
    *sourceMap >> ch;
    if (ch == '\"') { // end of records
      nextDebugPos = 0;
      break;
    }
    if (ch != ',') {
      throw MapParseException("Unexpected delimiter");
    }

    int32_t positionDelta = readBase64VLQ(*sourceMap);
    uint32_t position = nextDebugPos + positionDelta;

    nextDebugPos = position;

    auto peek = sourceMap->peek();
    if (peek == ',' || peek == '\"') {
      // This is a 1-length entry, so the next location has no debug info.
      nextDebugLocationHasDebugInfo = false;
      break;
    }

    int32_t fileIndexDelta = readBase64VLQ(*sourceMap);
    uint32_t fileIndex = nextDebugLocation.fileIndex + fileIndexDelta;
    int32_t lineNumberDelta = readBase64VLQ(*sourceMap);
    uint32_t lineNumber = nextDebugLocation.lineNumber + lineNumberDelta;
    int32_t columnNumberDelta = readBase64VLQ(*sourceMap);
    uint32_t columnNumber = nextDebugLocation.columnNumber + columnNumberDelta;

    nextDebugLocation = {fileIndex, lineNumber, columnNumber};
    nextDebugLocationHasDebugInfo = true;
  }
}

Expression* WasmBinaryReader::readExpression() {
  assert(depth == 0);
  processExpressions();
  if (expressionStack.size() != 1) {
    throwError("expected to read a single expression");
  }
  auto* ret = popExpression();
  assert(depth == 0);
  return ret;
}

void WasmBinaryReader::readStrings() {
  auto reserved = getU32LEB();
  if (reserved != 0) {
    throwError("unexpected reserved value in strings");
  }
  size_t num = getU32LEB();
  for (size_t i = 0; i < num; i++) {
    auto string = getInlineString(false);
    // Re-encode from WTF-8 to WTF-16.
    std::stringstream wtf16;
    if (!String::convertWTF8ToWTF16(wtf16, string.str)) {
      throwError("invalid string constant");
    }
    // TODO: Use wtf16.view() once we have C++20.
    strings.push_back(wtf16.str());
  }
}

void WasmBinaryReader::readGlobals() {
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
      Builder::makeGlobal(makeName("global$", i),
                          type,
                          init,
                          mutable_ ? Builder::Mutable : Builder::Immutable));
  }
}

void WasmBinaryReader::processExpressions() {
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
          peek == BinaryConsts::Catch_Legacy ||
          peek == BinaryConsts::CatchAll_Legacy ||
          peek == BinaryConsts::Delegate) {
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

void WasmBinaryReader::skipUnreachableCode() {
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
    if (curr->type == Type::unreachable) {
      // Nothing before this unreachable should be available to future
      // expressions. They will get `(unreachable)`s if they try to pop past
      // this point.
      expressionStack.clear();
    } else {
      pushExpression(curr);
    }
  }
}

void WasmBinaryReader::pushExpression(Expression* curr) {
  auto type = curr->type;
  if (type.isTuple()) {
    // Store tuple to local and push individual extracted values.
    Builder builder(wasm);
    requireFunctionContext("pushExpression-tuple");
    Index tuple = builder.addVar(currFunction, type);
    expressionStack.push_back(builder.makeLocalSet(tuple, curr));
    for (Index i = 0; i < type.size(); ++i) {
      expressionStack.push_back(
        builder.makeTupleExtract(builder.makeLocalGet(tuple, type), i));
    }
  } else {
    expressionStack.push_back(curr);
  }
}

Expression* WasmBinaryReader::popExpression() {
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

Expression* WasmBinaryReader::popNonVoidExpression() {
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

Expression* WasmBinaryReader::popTuple(size_t numElems) {
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

Expression* WasmBinaryReader::popTypedExpression(Type type) {
  if (type.isSingle()) {
    return popNonVoidExpression();
  } else if (type.isTuple()) {
    return popTuple(type.size());
  } else {
    WASM_UNREACHABLE("Invalid popped type");
  }
}

void WasmBinaryReader::validateBinary() {
  if (hasDataCount && wasm.dataSegments.size() != dataCount) {
    throwError("Number of segments does not agree with DataCount section");
  }

  if (functionTypes.size() != wasm.functions.size()) {
    throwError("function section without code section");
  }
}

void WasmBinaryReader::processNames() {
  // now that we have names, apply things

  if (startIndex != static_cast<Index>(-1)) {
    wasm.start = getFunctionName(startIndex);
  }

  for (auto& curr : exportOrder) {
    auto index = exportIndices[curr.get()];
    switch (curr->kind) {
      case ExternalKind::Function: {
        curr->value = getFunctionName(index);
        break;
      }
      case ExternalKind::Table:
        curr->value = getTableName(index);
        break;
      case ExternalKind::Memory:
        curr->value = getMemoryName(index);
        break;
      case ExternalKind::Global:
        curr->value = getGlobalName(index);
        break;
      case ExternalKind::Tag:
        curr->value = getTagName(index);
        break;
      default:
        throwError("bad export kind");
    }
    wasm.addExport(std::move(curr));
  }

  for (auto& [index, refs] : functionRefs) {
    for (auto* ref : refs) {
      *ref = getFunctionName(index);
    }
  }
  for (auto& [index, refs] : tableRefs) {
    for (auto* ref : refs) {
      *ref = getTableName(index);
    }
  }
  for (auto& [index, refs] : memoryRefs) {
    for (auto ref : refs) {
      *ref = getMemoryName(index);
    }
  }
  for (auto& [index, refs] : globalRefs) {
    for (auto* ref : refs) {
      *ref = getGlobalName(index);
    }
  }
  for (auto& [index, refs] : tagRefs) {
    for (auto* ref : refs) {
      *ref = getTagName(index);
    }
  }
  for (auto& [index, refs] : dataRefs) {
    for (auto* ref : refs) {
      *ref = getDataName(index);
    }
  }
  for (auto& [index, refs] : elemRefs) {
    for (auto* ref : refs) {
      *ref = getElemName(index);
    }
  }

  // Everything now has its proper name.

  wasm.updateMaps();
}

void WasmBinaryReader::readDataSegmentCount() {
  BYN_TRACE("== readDataSegmentCount\n");
  hasDataCount = true;
  dataCount = getU32LEB();
}

void WasmBinaryReader::readDataSegments() {
  BYN_TRACE("== readDataSegments\n");
  auto num = getU32LEB();
  for (size_t i = 0; i < num; i++) {
    auto curr = Builder::makeDataSegment();
    uint32_t flags = getU32LEB();
    if (flags > 2) {
      throwError("bad segment flags, must be 0, 1, or 2, not " +
                 std::to_string(flags));
    }
    curr->setName(Name::fromInt(i), false);
    curr->isPassive = flags & BinaryConsts::IsPassive;
    if (curr->isPassive) {
      curr->memory = Name();
      curr->offset = nullptr;
    } else {
      Index memIdx = 0;
      if (flags & BinaryConsts::HasIndex) {
        memIdx = getU32LEB();
      }
      memoryRefs[memIdx].push_back(&curr->memory);
      curr->offset = readExpression();
    }
    auto size = getU32LEB();
    auto data = getByteView(size);
    curr->data = {data.begin(), data.end()};
    wasm.addDataSegment(std::move(curr));
  }
}

void WasmBinaryReader::readTableDeclarations() {
  BYN_TRACE("== readTableDeclarations\n");
  auto numTables = getU32LEB();

  for (size_t i = 0; i < numTables; i++) {
    auto elemType = getType();
    if (!elemType.isRef()) {
      throwError("Table type must be a reference type");
    }
    auto table = Builder::makeTable(makeName("", i), elemType);
    bool is_shared;
    getResizableLimits(table->initial,
                       table->max,
                       is_shared,
                       table->indexType,
                       Table::kUnlimitedSize);
    if (is_shared) {
      throwError("Tables may not be shared");
    }
    wasm.addTable(std::move(table));
  }
}

void WasmBinaryReader::readElementSegments() {
  BYN_TRACE("== readElementSegments\n");
  auto numSegments = getU32LEB();
  if (numSegments >= Table::kMaxSize) {
    throwError("Too many segments");
  }
  for (size_t i = 0; i < numSegments; i++) {
    auto flags = getU32LEB();
    bool isPassive = (flags & BinaryConsts::IsPassive) != 0;
    bool hasTableIdx = !isPassive && ((flags & BinaryConsts::HasIndex) != 0);
    bool isDeclarative =
      isPassive && ((flags & BinaryConsts::IsDeclarative) != 0);
    bool usesExpressions = (flags & BinaryConsts::UsesExpressions) != 0;

    if (isDeclarative) {
      // Declared segments are needed in wasm text and binary, but not in
      // Binaryen IR; skip over the segment
      [[maybe_unused]] auto type = getU32LEB();
      auto num = getU32LEB();
      for (Index i = 0; i < num; i++) {
        if (usesExpressions) {
          readExpression();
        } else {
          getU32LEB();
        }
      }
      continue;
    }

    auto segment = std::make_unique<ElementSegment>();
    segment->setName(Name::fromInt(i), false);

    if (!isPassive) {
      Index tableIdx = 0;
      if (hasTableIdx) {
        tableIdx = getU32LEB();
      }

      if (tableIdx >= wasm.tables.size()) {
        throwError("Table index out of range.");
      }
      auto* table = wasm.tables[tableIdx].get();
      segment->table = table->name;
      segment->offset = readExpression();
    }

    if (isPassive || hasTableIdx) {
      if (usesExpressions) {
        segment->type = getType();
      } else {
        auto elemKind = getU32LEB();
        if (elemKind != 0x0) {
          throwError("Invalid kind (!= funcref(0)) since !usesExpressions.");
        }
      }
    }

    auto& segmentData = segment->data;
    auto size = getU32LEB();
    if (usesExpressions) {
      for (Index j = 0; j < size; j++) {
        segmentData.push_back(readExpression());
      }
    } else {
      for (Index j = 0; j < size; j++) {
        Index index = getU32LEB();
        auto sig = getTypeByFunctionIndex(index);
        // Use a placeholder name for now
        auto* refFunc = Builder(wasm).makeRefFunc(Name::fromInt(index), sig);
        functionRefs[index].push_back(&refFunc->func);
        segmentData.push_back(refFunc);
      }
    }

    wasm.addElementSegment(std::move(segment));
  }
}

void WasmBinaryReader::readTags() {
  BYN_TRACE("== readTags\n");
  size_t numTags = getU32LEB();
  BYN_TRACE("num: " << numTags << std::endl);
  for (size_t i = 0; i < numTags; i++) {
    BYN_TRACE("read one\n");
    getInt8(); // Reserved 'attribute' field
    auto typeIndex = getU32LEB();
    wasm.addTag(Builder::makeTag(makeName("tag$", i),
                                 getSignatureByTypeIndex(typeIndex)));
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

Name WasmBinaryReader::escape(Name name) {
  bool allIdChars = true;
  for (char c : name.str) {
    if (!(allIdChars = isIdChar(c))) {
      break;
    }
  }
  if (allIdChars) {
    return name;
  }
  // encode name, if at least one non-idchar (per WebAssembly spec) was found
  std::string escaped;
  for (char c : name.str) {
    if (isIdChar(c)) {
      escaped.push_back(c);
      continue;
    }
    // replace non-idchar with `\xx` escape
    escaped.push_back('\\');
    escaped.push_back(formatNibble(c >> 4));
    escaped.push_back(formatNibble(c & 15));
  }
  return escaped;
}

namespace {

// Performs necessary processing of names from the name section before using
// them. Specifically it escapes and deduplicates them.
//
// Deduplication is not trivial, since we can't only consider things in the name
// section itself. The issue is that we have already given everything a
// temporary name. Consider if we gave these two temp names:
//
//  $foo$0
//  $foo$1
//
// and imagine that the first appears in the name section, where it is given the
// the name $foo$1, and the second does not appear in the name section. In that
// case, we'd rename the second to the same name as the first. If we left things
// there that would be invalid, so we need to pick another temp name for the
// second item to resolve that.
class NameProcessor {
public:
  // Returns a unique, escaped name. Notes that name for the items to follow to
  // keep them unique as well.
  Name process(Name name) {
    return deduplicate(WasmBinaryReader::escape(name));
  }

  // After processing the names section entries, which set explicit names, we
  // also handle the remaining items here, which handles the corner case
  // described above.
  //
  // TODO: This handles vectors of Named objects; we should also do this for
  //       local names and type names etc.
  template<typename T> void deduplicateUnexplicitlyNamed(std::vector<T>& vec) {
    for (auto& x : vec) {
      if (!x->hasExplicitName) {
        x->name = deduplicate(x->name);
      }
    }
  }

private:
  std::unordered_set<Name> usedNames;

  Name deduplicate(Name base) {
    auto name = Names::getValidNameGivenExisting(base, usedNames);
    usedNames.insert(name);
    return name;
  }
};

} // anonymous namespace

void WasmBinaryReader::readNames(size_t payloadLen) {
  BYN_TRACE("== readNames\n");
  auto sectionPos = pos;
  uint32_t lastType = 0;
  while (pos < sectionPos + payloadLen) {
    auto nameType = getU32LEB();
    if (lastType && nameType <= lastType) {
      std::cerr << "warning: out-of-order name subsection: " << nameType
                << std::endl;
    }
    lastType = nameType;
    auto subsectionSize = getU32LEB();
    auto subsectionPos = pos;
    using Subsection = BinaryConsts::CustomSections::Subsection;
    if (nameType == Subsection::NameModule) {
      wasm.name = getInlineString();
    } else if (nameType == Subsection::NameFunction) {
      auto num = getU32LEB();
      NameProcessor processor;
      for (size_t i = 0; i < num; i++) {
        auto index = getU32LEB();
        auto rawName = getInlineString();
        auto name = processor.process(rawName);
        if (index < wasm.functions.size()) {
          wasm.functions[index]->setExplicitName(name);
        } else {
          std::cerr << "warning: function index out of bounds in name section, "
                       "function subsection: "
                    << std::string(rawName.str) << " at index "
                    << std::to_string(index) << std::endl;
        }
      }
      processor.deduplicateUnexplicitlyNamed(wasm.functions);
    } else if (nameType == Subsection::NameLocal) {
      auto numFuncs = getU32LEB();
      for (size_t i = 0; i < numFuncs; i++) {
        auto funcIndex = getU32LEB();
        Function* func = nullptr;
        if (funcIndex < wasm.functions.size()) {
          func = wasm.functions[funcIndex].get();
        } else {
          std::cerr
            << "warning: function index out of bounds in name section, local "
               "subsection: "
            << std::to_string(funcIndex) << std::endl;
        }
        auto numLocals = getU32LEB();
        NameProcessor processor;
        for (size_t j = 0; j < numLocals; j++) {
          auto localIndex = getU32LEB();
          auto rawLocalName = getInlineString();
          if (!func) {
            continue; // read and discard in case of prior error
          }
          auto localName = processor.process(rawLocalName);
          if (localName.size() == 0) {
            std::cerr << "warning: empty local name at index "
                      << std::to_string(localIndex) << " in function "
                      << std::string(func->name.str) << std::endl;
          } else if (localIndex < func->getNumLocals()) {
            func->localNames[localIndex] = localName;
          } else {
            std::cerr << "warning: local index out of bounds in name "
                         "section, local subsection: "
                      << std::string(rawLocalName.str) << " at index "
                      << std::to_string(localIndex) << " in function "
                      << std::string(func->name.str) << std::endl;
          }
        }
      }
    } else if (nameType == Subsection::NameType) {
      auto num = getU32LEB();
      NameProcessor processor;
      for (size_t i = 0; i < num; i++) {
        auto index = getU32LEB();
        auto rawName = getInlineString();
        auto name = processor.process(rawName);
        if (index < types.size()) {
          wasm.typeNames[types[index]].name = name;
        } else {
          std::cerr << "warning: type index out of bounds in name section, "
                       "type subsection: "
                    << std::string(rawName.str) << " at index "
                    << std::to_string(index) << std::endl;
        }
      }
    } else if (nameType == Subsection::NameTable) {
      auto num = getU32LEB();
      NameProcessor processor;
      for (size_t i = 0; i < num; i++) {
        auto index = getU32LEB();
        auto rawName = getInlineString();
        auto name = processor.process(rawName);

        if (index < wasm.tables.size()) {
          auto* table = wasm.tables[index].get();
          for (auto& segment : wasm.elementSegments) {
            if (segment->table == table->name) {
              segment->table = name;
            }
          }
          table->setExplicitName(name);
        } else {
          std::cerr << "warning: table index out of bounds in name section, "
                       "table subsection: "
                    << std::string(rawName.str) << " at index "
                    << std::to_string(index) << std::endl;
        }
      }
      processor.deduplicateUnexplicitlyNamed(wasm.tables);
    } else if (nameType == Subsection::NameElem) {
      auto num = getU32LEB();
      NameProcessor processor;
      for (size_t i = 0; i < num; i++) {
        auto index = getU32LEB();
        auto rawName = getInlineString();
        auto name = processor.process(rawName);

        if (index < wasm.elementSegments.size()) {
          wasm.elementSegments[index]->setExplicitName(name);
        } else {
          std::cerr << "warning: elem index out of bounds in name section, "
                       "elem subsection: "
                    << std::string(rawName.str) << " at index "
                    << std::to_string(index) << std::endl;
        }
      }
      processor.deduplicateUnexplicitlyNamed(wasm.elementSegments);
    } else if (nameType == Subsection::NameMemory) {
      auto num = getU32LEB();
      NameProcessor processor;
      for (size_t i = 0; i < num; i++) {
        auto index = getU32LEB();
        auto rawName = getInlineString();
        auto name = processor.process(rawName);
        if (index < wasm.memories.size()) {
          wasm.memories[index]->setExplicitName(name);
        } else {
          std::cerr << "warning: memory index out of bounds in name section, "
                       "memory subsection: "
                    << std::string(rawName.str) << " at index "
                    << std::to_string(index) << std::endl;
        }
      }
      processor.deduplicateUnexplicitlyNamed(wasm.memories);
    } else if (nameType == Subsection::NameData) {
      auto num = getU32LEB();
      NameProcessor processor;
      for (size_t i = 0; i < num; i++) {
        auto index = getU32LEB();
        auto rawName = getInlineString();
        auto name = processor.process(rawName);
        if (index < wasm.dataSegments.size()) {
          wasm.dataSegments[index]->setExplicitName(name);
        } else {
          std::cerr << "warning: data index out of bounds in name section, "
                       "data subsection: "
                    << std::string(rawName.str) << " at index "
                    << std::to_string(index) << std::endl;
        }
      }
      processor.deduplicateUnexplicitlyNamed(wasm.dataSegments);
    } else if (nameType == Subsection::NameGlobal) {
      auto num = getU32LEB();
      NameProcessor processor;
      for (size_t i = 0; i < num; i++) {
        auto index = getU32LEB();
        auto rawName = getInlineString();
        auto name = processor.process(rawName);
        if (index < wasm.globals.size()) {
          wasm.globals[index]->setExplicitName(name);
        } else {
          std::cerr << "warning: global index out of bounds in name section, "
                       "global subsection: "
                    << std::string(rawName.str) << " at index "
                    << std::to_string(index) << std::endl;
        }
      }
      processor.deduplicateUnexplicitlyNamed(wasm.globals);
    } else if (nameType == Subsection::NameField) {
      auto numTypes = getU32LEB();
      for (size_t i = 0; i < numTypes; i++) {
        auto typeIndex = getU32LEB();
        bool validType =
          typeIndex < types.size() && types[typeIndex].isStruct();
        if (!validType) {
          std::cerr << "warning: invalid field index in name field section\n";
        }
        auto numFields = getU32LEB();
        NameProcessor processor;
        for (size_t i = 0; i < numFields; i++) {
          auto fieldIndex = getU32LEB();
          auto rawName = getInlineString();
          auto name = processor.process(rawName);
          if (validType) {
            wasm.typeNames[types[typeIndex]].fieldNames[fieldIndex] = name;
          }
        }
      }
    } else if (nameType == Subsection::NameTag) {
      auto num = getU32LEB();
      NameProcessor processor;
      for (size_t i = 0; i < num; i++) {
        auto index = getU32LEB();
        auto rawName = getInlineString();
        auto name = processor.process(rawName);
        if (index < wasm.tags.size()) {
          wasm.tags[index]->setExplicitName(name);
        } else {
          std::cerr << "warning: tag index out of bounds in name section, "
                       "tag subsection: "
                    << std::string(rawName.str) << " at index "
                    << std::to_string(index) << std::endl;
        }
      }
      processor.deduplicateUnexplicitlyNamed(wasm.tags);
    } else {
      std::cerr << "warning: unknown name subsection with id "
                << std::to_string(nameType) << " at " << pos << std::endl;
      pos = subsectionPos + subsectionSize;
    }
    if (pos != subsectionPos + subsectionSize) {
      throwError("bad names subsection position change");
    }
  }
  if (pos != sectionPos + payloadLen) {
    throwError("bad names section position change");
  }
}

void WasmBinaryReader::readFeatures(size_t payloadLen) {
  wasm.hasFeaturesSection = true;

  auto sectionPos = pos;
  size_t numFeatures = getU32LEB();
  for (size_t i = 0; i < numFeatures; ++i) {
    uint8_t prefix = getInt8();

    bool disallowed = prefix == BinaryConsts::FeatureDisallowed;
    bool required = prefix == BinaryConsts::FeatureRequired;
    bool used = prefix == BinaryConsts::FeatureUsed;

    if (!disallowed && !required && !used) {
      throwError("Unrecognized feature policy prefix");
    }
    if (required) {
      std::cerr << "warning: required features in feature section are ignored";
    }

    Name name = getInlineString();
    if (pos > sectionPos + payloadLen) {
      throwError("ill-formed string extends beyond section");
    }

    FeatureSet feature;
    if (name == BinaryConsts::CustomSections::AtomicsFeature) {
      feature = FeatureSet::Atomics;
    } else if (name == BinaryConsts::CustomSections::BulkMemoryFeature) {
      feature = FeatureSet::BulkMemory;
    } else if (name == BinaryConsts::CustomSections::ExceptionHandlingFeature) {
      feature = FeatureSet::ExceptionHandling;
    } else if (name == BinaryConsts::CustomSections::MutableGlobalsFeature) {
      feature = FeatureSet::MutableGlobals;
    } else if (name == BinaryConsts::CustomSections::TruncSatFeature) {
      feature = FeatureSet::TruncSat;
    } else if (name == BinaryConsts::CustomSections::SignExtFeature) {
      feature = FeatureSet::SignExt;
    } else if (name == BinaryConsts::CustomSections::SIMD128Feature) {
      feature = FeatureSet::SIMD;
    } else if (name == BinaryConsts::CustomSections::TailCallFeature) {
      feature = FeatureSet::TailCall;
    } else if (name == BinaryConsts::CustomSections::ReferenceTypesFeature) {
      feature = FeatureSet::ReferenceTypes;
    } else if (name == BinaryConsts::CustomSections::MultivalueFeature) {
      feature = FeatureSet::Multivalue;
    } else if (name == BinaryConsts::CustomSections::GCFeature) {
      feature = FeatureSet::GC;
    } else if (name == BinaryConsts::CustomSections::Memory64Feature) {
      feature = FeatureSet::Memory64;
    } else if (name == BinaryConsts::CustomSections::RelaxedSIMDFeature) {
      feature = FeatureSet::RelaxedSIMD;
    } else if (name == BinaryConsts::CustomSections::ExtendedConstFeature) {
      feature = FeatureSet::ExtendedConst;
    } else if (name == BinaryConsts::CustomSections::StringsFeature) {
      feature = FeatureSet::Strings;
    } else if (name == BinaryConsts::CustomSections::MultiMemoryFeature) {
      feature = FeatureSet::MultiMemory;
    } else if (name ==
               BinaryConsts::CustomSections::TypedContinuationsFeature) {
      feature = FeatureSet::TypedContinuations;
    } else if (name == BinaryConsts::CustomSections::SharedEverythingFeature) {
      feature = FeatureSet::SharedEverything;
    } else if (name == BinaryConsts::CustomSections::FP16Feature) {
      feature = FeatureSet::FP16;
    } else {
      // Silently ignore unknown features (this may be and old binaryen running
      // on a new wasm).
    }

    if (disallowed && wasm.features.has(feature)) {
      std::cerr
        << "warning: feature " << feature.toString()
        << " was enabled by the user, but disallowed in the features section.";
    }
    if (required || used) {
      wasm.features.enable(feature);
    }
  }
  if (pos != sectionPos + payloadLen) {
    throwError("bad features section size");
  }
}

void WasmBinaryReader::readDylink(size_t payloadLen) {
  wasm.dylinkSection = std::make_unique<DylinkSection>();

  auto sectionPos = pos;

  wasm.dylinkSection->isLegacy = true;
  wasm.dylinkSection->memorySize = getU32LEB();
  wasm.dylinkSection->memoryAlignment = getU32LEB();
  wasm.dylinkSection->tableSize = getU32LEB();
  wasm.dylinkSection->tableAlignment = getU32LEB();

  size_t numNeededDynlibs = getU32LEB();
  for (size_t i = 0; i < numNeededDynlibs; ++i) {
    wasm.dylinkSection->neededDynlibs.push_back(getInlineString());
  }

  if (pos != sectionPos + payloadLen) {
    throwError("bad dylink section size");
  }
}

void WasmBinaryReader::readDylink0(size_t payloadLen) {
  BYN_TRACE("== readDylink0\n");
  auto sectionPos = pos;
  uint32_t lastType = 0;

  wasm.dylinkSection = std::make_unique<DylinkSection>();
  while (pos < sectionPos + payloadLen) {
    auto oldPos = pos;
    auto dylinkType = getU32LEB();
    if (lastType && dylinkType <= lastType) {
      std::cerr << "warning: out-of-order dylink.0 subsection: " << dylinkType
                << std::endl;
    }
    lastType = dylinkType;
    auto subsectionSize = getU32LEB();
    auto subsectionPos = pos;
    if (dylinkType == BinaryConsts::CustomSections::Subsection::DylinkMemInfo) {
      wasm.dylinkSection->memorySize = getU32LEB();
      wasm.dylinkSection->memoryAlignment = getU32LEB();
      wasm.dylinkSection->tableSize = getU32LEB();
      wasm.dylinkSection->tableAlignment = getU32LEB();
    } else if (dylinkType ==
               BinaryConsts::CustomSections::Subsection::DylinkNeeded) {
      size_t numNeededDynlibs = getU32LEB();
      for (size_t i = 0; i < numNeededDynlibs; ++i) {
        wasm.dylinkSection->neededDynlibs.push_back(getInlineString());
      }
    } else {
      // Unknown subsection.  Stop parsing now and store the rest of
      // the section verbatim.
      pos = oldPos;
      size_t remaining = (sectionPos + payloadLen) - pos;
      auto tail = getByteView(remaining);
      wasm.dylinkSection->tail = {tail.begin(), tail.end()};
      break;
    }
    if (pos != subsectionPos + subsectionSize) {
      throwError("bad dylink.0 subsection position change");
    }
  }
}

BinaryConsts::ASTNodes WasmBinaryReader::readExpression(Expression*& curr) {
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
      // Pop the current control flow structure off the stack. If there is none
      // then this is the "end" of the function itself, which also emits an
      // "end" byte.
      if (!controlFlowStack.empty()) {
        controlFlowStack.pop_back();
      }
      break;
    case BinaryConsts::Else:
    case BinaryConsts::Catch_Legacy:
    case BinaryConsts::CatchAll_Legacy: {
      curr = nullptr;
      if (DWARF && currFunction) {
        assert(!controlFlowStack.empty());
        auto currControlFlow = controlFlowStack.back();
        BinaryLocation delimiterId;
        if (currControlFlow->is<If>()) {
          delimiterId = BinaryLocations::Else;
        } else {
          // Both Catch and CatchAll can simply append to the list as we go, as
          // we visit them in the right order in the binary, and like the binary
          // we store the CatchAll at the end.
          delimiterId =
            currFunction->delimiterLocations[currControlFlow].size();
        }
        currFunction->delimiterLocations[currControlFlow][delimiterId] =
          startPos - codeSectionLocation;
      }
      break;
    }
    case BinaryConsts::Delegate: {
      curr = nullptr;
      if (DWARF && currFunction) {
        assert(!controlFlowStack.empty());
        controlFlowStack.pop_back();
      }
      break;
    }
    case BinaryConsts::RefNull:
      visitRefNull((curr = allocator.alloc<RefNull>())->cast<RefNull>());
      break;
    case BinaryConsts::RefIsNull:
      visitRefIsNull((curr = allocator.alloc<RefIsNull>())->cast<RefIsNull>());
      break;
    case BinaryConsts::RefFunc:
      visitRefFunc((curr = allocator.alloc<RefFunc>())->cast<RefFunc>());
      break;
    case BinaryConsts::RefEq:
      visitRefEq((curr = allocator.alloc<RefEq>())->cast<RefEq>());
      break;
    case BinaryConsts::RefAsNonNull:
      visitRefAs((curr = allocator.alloc<RefAs>())->cast<RefAs>(), code);
      break;
    case BinaryConsts::BrOnNull:
      maybeVisitBrOn(curr, code);
      break;
    case BinaryConsts::BrOnNonNull:
      maybeVisitBrOn(curr, code);
      break;
    case BinaryConsts::TableGet:
      visitTableGet((curr = allocator.alloc<TableGet>())->cast<TableGet>());
      break;
    case BinaryConsts::TableSet:
      visitTableSet((curr = allocator.alloc<TableSet>())->cast<TableSet>());
      break;
    case BinaryConsts::Try:
      visitTryOrTryInBlock(curr);
      break;
    case BinaryConsts::TryTable:
      visitTryTable((curr = allocator.alloc<TryTable>())->cast<TryTable>());
      break;
    case BinaryConsts::Throw:
      visitThrow((curr = allocator.alloc<Throw>())->cast<Throw>());
      break;
    case BinaryConsts::Rethrow:
      visitRethrow((curr = allocator.alloc<Rethrow>())->cast<Rethrow>());
      break;
    case BinaryConsts::ThrowRef:
      visitThrowRef((curr = allocator.alloc<ThrowRef>())->cast<ThrowRef>());
      break;
    case BinaryConsts::MemorySize: {
      auto size = allocator.alloc<MemorySize>();
      curr = size;
      visitMemorySize(size);
      break;
    }
    case BinaryConsts::MemoryGrow: {
      auto grow = allocator.alloc<MemoryGrow>();
      curr = grow;
      visitMemoryGrow(grow);
      break;
    }
    case BinaryConsts::CallRef:
    case BinaryConsts::RetCallRef: {
      auto call = allocator.alloc<CallRef>();
      call->isReturn = code == BinaryConsts::RetCallRef;
      curr = call;
      visitCallRef(call);
      break;
    }
    case BinaryConsts::ContBind: {
      visitContBind((curr = allocator.alloc<ContBind>())->cast<ContBind>());
      break;
    }
    case BinaryConsts::ContNew: {
      auto contNew = allocator.alloc<ContNew>();
      curr = contNew;
      visitContNew(contNew);
      break;
    }
    case BinaryConsts::Resume: {
      visitResume((curr = allocator.alloc<Resume>())->cast<Resume>());
      break;
    }
    case BinaryConsts::Suspend: {
      visitSuspend((curr = allocator.alloc<Suspend>())->cast<Suspend>());
      break;
    }
    case BinaryConsts::AtomicPrefix: {
      code = static_cast<uint8_t>(getU32LEB());
      if (maybeVisitLoad(curr, code, BinaryConsts::AtomicPrefix)) {
        break;
      }
      if (maybeVisitStore(curr, code, BinaryConsts::AtomicPrefix)) {
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
      if (maybeVisitTableSize(curr, opcode)) {
        break;
      }
      if (maybeVisitTableGrow(curr, opcode)) {
        break;
      }
      if (maybeVisitTableFill(curr, opcode)) {
        break;
      }
      if (maybeVisitTableCopy(curr, opcode)) {
        break;
      }
      if (maybeVisitTableInit(curr, opcode)) {
        break;
      }
      if (maybeVisitLoad(curr, opcode, BinaryConsts::MiscPrefix)) {
        break;
      }
      if (maybeVisitStore(curr, opcode, BinaryConsts::MiscPrefix)) {
        break;
      }
      throwError("invalid code after misc prefix: " + std::to_string(opcode));
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
      if (maybeVisitSIMDLoadStoreLane(curr, opcode)) {
        break;
      }
      throwError("invalid code after SIMD prefix: " + std::to_string(opcode));
      break;
    }
    case BinaryConsts::GCPrefix: {
      auto opcode = getU32LEB();
      if (maybeVisitRefI31(curr, opcode)) {
        break;
      }
      if (maybeVisitI31Get(curr, opcode)) {
        break;
      }
      if (maybeVisitRefTest(curr, opcode)) {
        break;
      }
      if (maybeVisitRefCast(curr, opcode)) {
        break;
      }
      if (maybeVisitBrOn(curr, opcode)) {
        break;
      }
      if (maybeVisitStructNew(curr, opcode)) {
        break;
      }
      if (maybeVisitStructGet(curr, opcode)) {
        break;
      }
      if (maybeVisitStructSet(curr, opcode)) {
        break;
      }
      if (maybeVisitArrayNewData(curr, opcode)) {
        break;
      }
      if (maybeVisitArrayNewElem(curr, opcode)) {
        break;
      }
      if (maybeVisitArrayNewFixed(curr, opcode)) {
        break;
      }
      if (maybeVisitArrayGet(curr, opcode)) {
        break;
      }
      if (maybeVisitArraySet(curr, opcode)) {
        break;
      }
      if (maybeVisitArrayLen(curr, opcode)) {
        break;
      }
      if (maybeVisitArrayCopy(curr, opcode)) {
        break;
      }
      if (maybeVisitArrayFill(curr, opcode)) {
        break;
      }
      if (maybeVisitArrayInit(curr, opcode)) {
        break;
      }
      if (maybeVisitStringNew(curr, opcode)) {
        break;
      }
      if (maybeVisitStringAsWTF16(curr, opcode)) {
        break;
      }
      if (maybeVisitStringConst(curr, opcode)) {
        break;
      }
      if (maybeVisitStringMeasure(curr, opcode)) {
        break;
      }
      if (maybeVisitStringEncode(curr, opcode)) {
        break;
      }
      if (maybeVisitStringConcat(curr, opcode)) {
        break;
      }
      if (maybeVisitStringEq(curr, opcode)) {
        break;
      }
      if (maybeVisitStringWTF16Get(curr, opcode)) {
        break;
      }
      if (maybeVisitStringSliceWTF(curr, opcode)) {
        break;
      }
      if (opcode == BinaryConsts::AnyConvertExtern ||
          opcode == BinaryConsts::ExternConvertAny) {
        visitRefAs((curr = allocator.alloc<RefAs>())->cast<RefAs>(), opcode);
        break;
      }
      throwError("invalid code after GC prefix: " + std::to_string(opcode));
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
      if (maybeVisitLoad(curr, code, /*prefix=*/std::nullopt)) {
        break;
      }
      if (maybeVisitStore(curr, code, /*prefix=*/std::nullopt)) {
        break;
      }
      throwError("bad node code " + std::to_string(code));
      break;
    }
  }
  if (curr) {
    if (currDebugLocation.size()) {
      requireFunctionContext("debugLocation");
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

void WasmBinaryReader::startControlFlow(Expression* curr) {
  if (DWARF && currFunction) {
    controlFlowStack.push_back(curr);
  }
}

void WasmBinaryReader::pushBlockElements(Block* curr, Type type, size_t start) {
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

void WasmBinaryReader::visitBlock(Block* curr) {
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
        requireFunctionContext("block-debugLocation");
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
                   breakTargetNames.find(curr->name) != breakTargetNames.end()
                     ? Block::HasBreak
                     : Block::NoBreak);
    breakStack.pop_back();
    breakTargetNames.erase(curr->name);
  }
}

// Gets a block of expressions. If it's just one, return that singleton.
Expression* WasmBinaryReader::getBlockOrSingleton(Type type) {
  Name label = getNextLabel();
  breakStack.push_back({label, type});
  auto start = expressionStack.size();

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
  if (breakTargetNames.find(block->name) == breakTargetNames.end() &&
      exceptionTargetNames.find(block->name) == exceptionTargetNames.end()) {
    block->name = Name();
    if (block->list.size() == 1) {
      return block->list[0];
    }
  }
  breakTargetNames.erase(block->name);
  return block;
}

void WasmBinaryReader::visitIf(If* curr) {
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

void WasmBinaryReader::visitLoop(Loop* curr) {
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
  if (start > end) {
    throwError("block cannot pop from outside");
  }
  if (end - start == 1) {
    curr->body = popExpression();
  } else {
    auto* block = allocator.alloc<Block>();
    pushBlockElements(block, curr->type, start);
    block->finalize(curr->type);
    curr->body = block;
  }
  breakStack.pop_back();
  breakTargetNames.erase(curr->name);
  curr->finalize(curr->type);
}

WasmBinaryReader::BreakTarget WasmBinaryReader::getBreakTarget(int32_t offset) {
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

Name WasmBinaryReader::getExceptionTargetName(int32_t offset) {
  BYN_TRACE("getExceptionTarget " << offset << std::endl);
  // We always start parsing a function by creating a block label and pushing it
  // in breakStack in getBlockOrSingleton, so if a 'delegate''s target is that
  // block, it does not mean it targets that block; it throws to the caller.
  if (breakStack.size() - 1 == size_t(offset)) {
    return DELEGATE_CALLER_TARGET;
  }
  size_t index = breakStack.size() - 1 - offset;
  if (index > breakStack.size()) {
    throwError("bad try index (high)");
  }
  BYN_TRACE("exception target " << breakStack[index].name << std::endl);
  auto& ret = breakStack[index];
  // if the delegate/rethrow is in literally unreachable code, then we will not
  // emit it anyhow, so do not note that the target has a reference to it
  if (!willBeIgnored) {
    exceptionTargetNames.insert(ret.name);
  }
  return ret.name;
}

void WasmBinaryReader::visitBreak(Break* curr, uint8_t code) {
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

void WasmBinaryReader::visitSwitch(Switch* curr) {
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

void WasmBinaryReader::visitCall(Call* curr) {
  BYN_TRACE("zz node: Call\n");
  auto index = getU32LEB();
  auto sig = getSignatureByFunctionIndex(index);
  auto num = sig.params.size();
  curr->operands.resize(num);
  for (size_t i = 0; i < num; i++) {
    curr->operands[num - i - 1] = popNonVoidExpression();
  }
  curr->type = sig.results;
  // We don't know function names yet.
  functionRefs[index].push_back(&curr->target);
  curr->finalize();
}

void WasmBinaryReader::visitCallIndirect(CallIndirect* curr) {
  BYN_TRACE("zz node: CallIndirect\n");
  auto index = getU32LEB();
  curr->heapType = getTypeByIndex(index);
  Index tableIdx = getU32LEB();
  // TODO: Handle error cases where `heapType` is not a signature?
  auto num = curr->heapType.getSignature().params.size();
  curr->operands.resize(num);
  curr->target = popNonVoidExpression();
  for (size_t i = 0; i < num; i++) {
    curr->operands[num - i - 1] = popNonVoidExpression();
  }
  // Defer setting the table name for later, when we know it.
  tableRefs[tableIdx].push_back(&curr->table);
  curr->finalize();
}

void WasmBinaryReader::visitLocalGet(LocalGet* curr) {
  BYN_TRACE("zz node: LocalGet " << pos << std::endl);
  requireFunctionContext("local.get");
  curr->index = getU32LEB();
  if (curr->index >= currFunction->getNumLocals()) {
    throwError("bad local.get index");
  }
  curr->type = currFunction->getLocalType(curr->index);
  curr->finalize();
}

void WasmBinaryReader::visitLocalSet(LocalSet* curr, uint8_t code) {
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

void WasmBinaryReader::visitGlobalGet(GlobalGet* curr) {
  BYN_TRACE("zz node: GlobalGet " << pos << std::endl);
  auto index = getU32LEB();
  if (index >= wasm.globals.size()) {
    throwError("invalid global index");
  }
  auto* global = wasm.globals[index].get();
  curr->name = global->name;
  curr->type = global->type;
  globalRefs[index].push_back(&curr->name); // we don't know the final name yet
}

void WasmBinaryReader::visitGlobalSet(GlobalSet* curr) {
  BYN_TRACE("zz node: GlobalSet\n");
  auto index = getU32LEB();
  if (index >= wasm.globals.size()) {
    throwError("invalid global index");
  }
  curr->name = wasm.globals[index]->name;
  curr->value = popNonVoidExpression();
  globalRefs[index].push_back(&curr->name); // we don't know the final name yet
  curr->finalize();
}

Index WasmBinaryReader::readMemoryAccess(Address& alignment, Address& offset) {
  auto rawAlignment = getU32LEB();
  bool hasMemIdx = false;
  Index memIdx = 0;
  // Check bit 6 in the alignment to know whether a memory index is present per:
  // https://github.com/WebAssembly/multi-memory/blob/main/proposals/multi-memory/Overview.md
  if (rawAlignment & (1 << (6))) {
    hasMemIdx = true;
    // Clear the bit before we parse alignment
    rawAlignment = rawAlignment & ~(1 << 6);
  }

  if (rawAlignment > 8) {
    throwError("Alignment must be of a reasonable size");
  }

  alignment = Bits::pow2(rawAlignment);
  if (hasMemIdx) {
    memIdx = getU32LEB();
  }
  if (memIdx >= wasm.memories.size()) {
    throwError("Memory index out of range while reading memory alignment.");
  }
  auto* memory = wasm.memories[memIdx].get();
  offset = memory->indexType == Type::i32 ? getU32LEB() : getU64LEB();

  return memIdx;
}

bool WasmBinaryReader::maybeVisitLoad(
  Expression*& out,
  uint8_t code,
  std::optional<BinaryConsts::ASTNodes> prefix) {
  Load* curr;
  auto allocate = [&]() {
    curr = allocator.alloc<Load>();
  };
  if (!prefix) {
    switch (code) {
      case BinaryConsts::I32LoadMem8S:
        allocate();
        curr->bytes = 1;
        curr->type = Type::i32;
        curr->signed_ = true;
        break;
      case BinaryConsts::I32LoadMem8U:
        allocate();
        curr->bytes = 1;
        curr->type = Type::i32;
        break;
      case BinaryConsts::I32LoadMem16S:
        allocate();
        curr->bytes = 2;
        curr->type = Type::i32;
        curr->signed_ = true;
        break;
      case BinaryConsts::I32LoadMem16U:
        allocate();
        curr->bytes = 2;
        curr->type = Type::i32;
        break;
      case BinaryConsts::I32LoadMem:
        allocate();
        curr->bytes = 4;
        curr->type = Type::i32;
        break;
      case BinaryConsts::I64LoadMem8S:
        allocate();
        curr->bytes = 1;
        curr->type = Type::i64;
        curr->signed_ = true;
        break;
      case BinaryConsts::I64LoadMem8U:
        allocate();
        curr->bytes = 1;
        curr->type = Type::i64;
        break;
      case BinaryConsts::I64LoadMem16S:
        allocate();
        curr->bytes = 2;
        curr->type = Type::i64;
        curr->signed_ = true;
        break;
      case BinaryConsts::I64LoadMem16U:
        allocate();
        curr->bytes = 2;
        curr->type = Type::i64;
        break;
      case BinaryConsts::I64LoadMem32S:
        allocate();
        curr->bytes = 4;
        curr->type = Type::i64;
        curr->signed_ = true;
        break;
      case BinaryConsts::I64LoadMem32U:
        allocate();
        curr->bytes = 4;
        curr->type = Type::i64;
        break;
      case BinaryConsts::I64LoadMem:
        allocate();
        curr->bytes = 8;
        curr->type = Type::i64;
        break;
      case BinaryConsts::F32LoadMem:
        allocate();
        curr->bytes = 4;
        curr->type = Type::f32;
        break;
      case BinaryConsts::F64LoadMem:
        allocate();
        curr->bytes = 8;
        curr->type = Type::f64;
        break;
      default:
        return false;
    }
    BYN_TRACE("zz node: Load\n");
  } else if (prefix == BinaryConsts::AtomicPrefix) {
    switch (code) {
      case BinaryConsts::I32AtomicLoad8U:
        allocate();
        curr->bytes = 1;
        curr->type = Type::i32;
        break;
      case BinaryConsts::I32AtomicLoad16U:
        allocate();
        curr->bytes = 2;
        curr->type = Type::i32;
        break;
      case BinaryConsts::I32AtomicLoad:
        allocate();
        curr->bytes = 4;
        curr->type = Type::i32;
        break;
      case BinaryConsts::I64AtomicLoad8U:
        allocate();
        curr->bytes = 1;
        curr->type = Type::i64;
        break;
      case BinaryConsts::I64AtomicLoad16U:
        allocate();
        curr->bytes = 2;
        curr->type = Type::i64;
        break;
      case BinaryConsts::I64AtomicLoad32U:
        allocate();
        curr->bytes = 4;
        curr->type = Type::i64;
        break;
      case BinaryConsts::I64AtomicLoad:
        allocate();
        curr->bytes = 8;
        curr->type = Type::i64;
        break;
      default:
        return false;
    }
    BYN_TRACE("zz node: AtomicLoad\n");
  } else if (prefix == BinaryConsts::MiscPrefix) {
    switch (code) {
      case BinaryConsts::F32_F16LoadMem:
        allocate();
        curr->bytes = 2;
        curr->type = Type::f32;
        break;
      default:
        return false;
    }
    BYN_TRACE("zz node: Load\n");
  } else {
    return false;
  }

  curr->isAtomic = prefix == BinaryConsts::AtomicPrefix;
  Index memIdx = readMemoryAccess(curr->align, curr->offset);
  memoryRefs[memIdx].push_back(&curr->memory);
  curr->ptr = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryReader::maybeVisitStore(
  Expression*& out,
  uint8_t code,
  std::optional<BinaryConsts::ASTNodes> prefix) {
  Store* curr;
  if (!prefix) {
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
  } else if (prefix == BinaryConsts::AtomicPrefix) {
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
  } else if (prefix == BinaryConsts::MiscPrefix) {
    switch (code) {
      case BinaryConsts::F32_F16StoreMem:
        curr = allocator.alloc<Store>();
        curr->bytes = 2;
        curr->valueType = Type::f32;
        break;
      default:
        return false;
    }
  } else {
    return false;
  }

  curr->isAtomic = prefix == BinaryConsts::AtomicPrefix;
  BYN_TRACE("zz node: Store\n");
  Index memIdx = readMemoryAccess(curr->align, curr->offset);
  memoryRefs[memIdx].push_back(&curr->memory);
  curr->value = popNonVoidExpression();
  curr->ptr = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryReader::maybeVisitAtomicRMW(Expression*& out, uint8_t code) {
  if (code < BinaryConsts::AtomicRMWOps_Begin ||
      code > BinaryConsts::AtomicRMWOps_End) {
    return false;
  }
  auto* curr = allocator.alloc<AtomicRMW>();

  // Set curr to the given opcode, type and size.
#define SET(opcode, optype, size)                                              \
  curr->op = RMW##opcode;                                                      \
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
  Index memIdx = readMemoryAccess(readAlign, curr->offset);
  memoryRefs[memIdx].push_back(&curr->memory);
  if (readAlign != curr->bytes) {
    throwError("Align of AtomicRMW must match size");
  }
  curr->value = popNonVoidExpression();
  curr->ptr = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryReader::maybeVisitAtomicCmpxchg(Expression*& out, uint8_t code) {
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
  Index memIdx = readMemoryAccess(readAlign, curr->offset);
  memoryRefs[memIdx].push_back(&curr->memory);
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

bool WasmBinaryReader::maybeVisitAtomicWait(Expression*& out, uint8_t code) {
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
  Index memIdx = readMemoryAccess(readAlign, curr->offset);
  memoryRefs[memIdx].push_back(&curr->memory);
  if (readAlign != curr->expectedType.getByteSize()) {
    throwError("Align of AtomicWait must match size");
  }
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryReader::maybeVisitAtomicNotify(Expression*& out, uint8_t code) {
  if (code != BinaryConsts::AtomicNotify) {
    return false;
  }
  auto* curr = allocator.alloc<AtomicNotify>();
  BYN_TRACE("zz node: AtomicNotify\n");

  curr->type = Type::i32;
  curr->notifyCount = popNonVoidExpression();
  curr->ptr = popNonVoidExpression();
  Address readAlign;
  Index memIdx = readMemoryAccess(readAlign, curr->offset);
  memoryRefs[memIdx].push_back(&curr->memory);
  if (readAlign != curr->type.getByteSize()) {
    throwError("Align of AtomicNotify must match size");
  }
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryReader::maybeVisitAtomicFence(Expression*& out, uint8_t code) {
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

bool WasmBinaryReader::maybeVisitConst(Expression*& out, uint8_t code) {
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

bool WasmBinaryReader::maybeVisitUnary(Expression*& out, uint8_t code) {
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

bool WasmBinaryReader::maybeVisitTruncSat(Expression*& out, uint32_t code) {
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

bool WasmBinaryReader::maybeVisitMemoryInit(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::MemoryInit) {
    return false;
  }
  auto* curr = allocator.alloc<MemoryInit>();
  curr->size = popNonVoidExpression();
  curr->offset = popNonVoidExpression();
  curr->dest = popNonVoidExpression();
  Index segIdx = getU32LEB();
  dataRefs[segIdx].push_back(&curr->segment);
  Index memIdx = getU32LEB();
  memoryRefs[memIdx].push_back(&curr->memory);
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryReader::maybeVisitDataDrop(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::DataDrop) {
    return false;
  }
  auto* curr = allocator.alloc<DataDrop>();
  Index segIdx = getU32LEB();
  dataRefs[segIdx].push_back(&curr->segment);
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryReader::maybeVisitMemoryCopy(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::MemoryCopy) {
    return false;
  }
  auto* curr = allocator.alloc<MemoryCopy>();
  curr->size = popNonVoidExpression();
  curr->source = popNonVoidExpression();
  curr->dest = popNonVoidExpression();
  Index destIdx = getU32LEB();
  Index sourceIdx = getU32LEB();
  curr->finalize();
  memoryRefs[destIdx].push_back(&curr->destMemory);
  memoryRefs[sourceIdx].push_back(&curr->sourceMemory);
  out = curr;
  return true;
}

bool WasmBinaryReader::maybeVisitMemoryFill(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::MemoryFill) {
    return false;
  }
  auto* curr = allocator.alloc<MemoryFill>();
  curr->size = popNonVoidExpression();
  curr->value = popNonVoidExpression();
  curr->dest = popNonVoidExpression();
  Index memIdx = getU32LEB();
  curr->finalize();
  memoryRefs[memIdx].push_back(&curr->memory);
  out = curr;
  return true;
}

bool WasmBinaryReader::maybeVisitTableSize(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::TableSize) {
    return false;
  }
  Index tableIdx = getU32LEB();
  if (tableIdx >= wasm.tables.size()) {
    throwError("bad table index");
  }
  auto* curr = allocator.alloc<TableSize>();
  if (getTable(tableIdx)->is64()) {
    curr->type = Type::i64;
  }
  curr->finalize();
  // Defer setting the table name for later, when we know it.
  tableRefs[tableIdx].push_back(&curr->table);
  out = curr;
  return true;
}

bool WasmBinaryReader::maybeVisitTableGrow(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::TableGrow) {
    return false;
  }
  Index tableIdx = getU32LEB();
  if (tableIdx >= wasm.tables.size()) {
    throwError("bad table index");
  }
  auto* curr = allocator.alloc<TableGrow>();
  curr->delta = popNonVoidExpression();
  curr->value = popNonVoidExpression();
  if (getTable(tableIdx)->is64()) {
    curr->type = Type::i64;
  }
  curr->finalize();
  // Defer setting the table name for later, when we know it.
  tableRefs[tableIdx].push_back(&curr->table);
  out = curr;
  return true;
}

bool WasmBinaryReader::maybeVisitTableFill(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::TableFill) {
    return false;
  }
  Index tableIdx = getU32LEB();
  if (tableIdx >= wasm.tables.size()) {
    throwError("bad table index");
  }
  auto* size = popNonVoidExpression();
  auto* value = popNonVoidExpression();
  auto* dest = popNonVoidExpression();
  auto* ret = Builder(wasm).makeTableFill(Name(), dest, value, size);
  tableRefs[tableIdx].push_back(&ret->table);
  out = ret;
  return true;
}

bool WasmBinaryReader::maybeVisitTableCopy(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::TableCopy) {
    return false;
  }
  Index destTableIdx = getU32LEB();
  if (destTableIdx >= wasm.tables.size()) {
    throwError("bad table index");
  }
  Index sourceTableIdx = getU32LEB();
  if (sourceTableIdx >= wasm.tables.size()) {
    throwError("bad table index");
  }
  auto* size = popNonVoidExpression();
  auto* source = popNonVoidExpression();
  auto* dest = popNonVoidExpression();
  auto* ret = Builder(wasm).makeTableCopy(dest, source, size, Name(), Name());
  tableRefs[destTableIdx].push_back(&ret->destTable);
  tableRefs[sourceTableIdx].push_back(&ret->sourceTable);
  out = ret;
  return true;
}

bool WasmBinaryReader::maybeVisitTableInit(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::TableInit) {
    return false;
  }
  auto* curr = allocator.alloc<TableInit>();
  curr->size = popNonVoidExpression();
  curr->offset = popNonVoidExpression();
  curr->dest = popNonVoidExpression();
  Index segIdx = getU32LEB();
  elemRefs[segIdx].push_back(&curr->segment);
  Index memIdx = getU32LEB();
  tableRefs[memIdx].push_back(&curr->table);
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryReader::maybeVisitBinary(Expression*& out, uint8_t code) {
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

bool WasmBinaryReader::maybeVisitSIMDBinary(Expression*& out, uint32_t code) {
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
    case BinaryConsts::I64x2Eq:
      curr = allocator.alloc<Binary>();
      curr->op = EqVecI64x2;
      break;
    case BinaryConsts::I64x2Ne:
      curr = allocator.alloc<Binary>();
      curr->op = NeVecI64x2;
      break;
    case BinaryConsts::I64x2LtS:
      curr = allocator.alloc<Binary>();
      curr->op = LtSVecI64x2;
      break;
    case BinaryConsts::I64x2GtS:
      curr = allocator.alloc<Binary>();
      curr->op = GtSVecI64x2;
      break;
    case BinaryConsts::I64x2LeS:
      curr = allocator.alloc<Binary>();
      curr->op = LeSVecI64x2;
      break;
    case BinaryConsts::I64x2GeS:
      curr = allocator.alloc<Binary>();
      curr->op = GeSVecI64x2;
      break;
    case BinaryConsts::F16x8Eq:
      curr = allocator.alloc<Binary>();
      curr->op = EqVecF16x8;
      break;
    case BinaryConsts::F16x8Ne:
      curr = allocator.alloc<Binary>();
      curr->op = NeVecF16x8;
      break;
    case BinaryConsts::F16x8Lt:
      curr = allocator.alloc<Binary>();
      curr->op = LtVecF16x8;
      break;
    case BinaryConsts::F16x8Gt:
      curr = allocator.alloc<Binary>();
      curr->op = GtVecF16x8;
      break;
    case BinaryConsts::F16x8Le:
      curr = allocator.alloc<Binary>();
      curr->op = LeVecF16x8;
      break;
    case BinaryConsts::F16x8Ge:
      curr = allocator.alloc<Binary>();
      curr->op = GeVecF16x8;
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
    case BinaryConsts::V128Andnot:
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
    case BinaryConsts::I16x8Q15MulrSatS:
      curr = allocator.alloc<Binary>();
      curr->op = Q15MulrSatSVecI16x8;
      break;
    case BinaryConsts::I16x8ExtmulLowI8x16S:
      curr = allocator.alloc<Binary>();
      curr->op = ExtMulLowSVecI16x8;
      break;
    case BinaryConsts::I16x8ExtmulHighI8x16S:
      curr = allocator.alloc<Binary>();
      curr->op = ExtMulHighSVecI16x8;
      break;
    case BinaryConsts::I16x8ExtmulLowI8x16U:
      curr = allocator.alloc<Binary>();
      curr->op = ExtMulLowUVecI16x8;
      break;
    case BinaryConsts::I16x8ExtmulHighI8x16U:
      curr = allocator.alloc<Binary>();
      curr->op = ExtMulHighUVecI16x8;
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
    case BinaryConsts::I32x4DotI16x8S:
      curr = allocator.alloc<Binary>();
      curr->op = DotSVecI16x8ToVecI32x4;
      break;
    case BinaryConsts::I32x4ExtmulLowI16x8S:
      curr = allocator.alloc<Binary>();
      curr->op = ExtMulLowSVecI32x4;
      break;
    case BinaryConsts::I32x4ExtmulHighI16x8S:
      curr = allocator.alloc<Binary>();
      curr->op = ExtMulHighSVecI32x4;
      break;
    case BinaryConsts::I32x4ExtmulLowI16x8U:
      curr = allocator.alloc<Binary>();
      curr->op = ExtMulLowUVecI32x4;
      break;
    case BinaryConsts::I32x4ExtmulHighI16x8U:
      curr = allocator.alloc<Binary>();
      curr->op = ExtMulHighUVecI32x4;
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
    case BinaryConsts::I64x2ExtmulLowI32x4S:
      curr = allocator.alloc<Binary>();
      curr->op = ExtMulLowSVecI64x2;
      break;
    case BinaryConsts::I64x2ExtmulHighI32x4S:
      curr = allocator.alloc<Binary>();
      curr->op = ExtMulHighSVecI64x2;
      break;
    case BinaryConsts::I64x2ExtmulLowI32x4U:
      curr = allocator.alloc<Binary>();
      curr->op = ExtMulLowUVecI64x2;
      break;
    case BinaryConsts::I64x2ExtmulHighI32x4U:
      curr = allocator.alloc<Binary>();
      curr->op = ExtMulHighUVecI64x2;
      break;
    case BinaryConsts::F16x8Add:
      curr = allocator.alloc<Binary>();
      curr->op = AddVecF16x8;
      break;
    case BinaryConsts::F16x8Sub:
      curr = allocator.alloc<Binary>();
      curr->op = SubVecF16x8;
      break;
    case BinaryConsts::F16x8Mul:
      curr = allocator.alloc<Binary>();
      curr->op = MulVecF16x8;
      break;
    case BinaryConsts::F16x8Div:
      curr = allocator.alloc<Binary>();
      curr->op = DivVecF16x8;
      break;
    case BinaryConsts::F16x8Min:
      curr = allocator.alloc<Binary>();
      curr->op = MinVecF16x8;
      break;
    case BinaryConsts::F16x8Max:
      curr = allocator.alloc<Binary>();
      curr->op = MaxVecF16x8;
      break;
    case BinaryConsts::F16x8Pmin:
      curr = allocator.alloc<Binary>();
      curr->op = PMinVecF16x8;
      break;
    case BinaryConsts::F16x8Pmax:
      curr = allocator.alloc<Binary>();
      curr->op = PMaxVecF16x8;
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
    case BinaryConsts::F32x4Pmin:
      curr = allocator.alloc<Binary>();
      curr->op = PMinVecF32x4;
      break;
    case BinaryConsts::F32x4Pmax:
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
    case BinaryConsts::F64x2Pmin:
      curr = allocator.alloc<Binary>();
      curr->op = PMinVecF64x2;
      break;
    case BinaryConsts::F64x2Pmax:
      curr = allocator.alloc<Binary>();
      curr->op = PMaxVecF64x2;
      break;
    case BinaryConsts::I8x16NarrowI16x8S:
      curr = allocator.alloc<Binary>();
      curr->op = NarrowSVecI16x8ToVecI8x16;
      break;
    case BinaryConsts::I8x16NarrowI16x8U:
      curr = allocator.alloc<Binary>();
      curr->op = NarrowUVecI16x8ToVecI8x16;
      break;
    case BinaryConsts::I16x8NarrowI32x4S:
      curr = allocator.alloc<Binary>();
      curr->op = NarrowSVecI32x4ToVecI16x8;
      break;
    case BinaryConsts::I16x8NarrowI32x4U:
      curr = allocator.alloc<Binary>();
      curr->op = NarrowUVecI32x4ToVecI16x8;
      break;
    case BinaryConsts::I8x16Swizzle:
      curr = allocator.alloc<Binary>();
      curr->op = SwizzleVecI8x16;
      break;
    case BinaryConsts::I8x16RelaxedSwizzle:
      curr = allocator.alloc<Binary>();
      curr->op = RelaxedSwizzleVecI8x16;
      break;
    case BinaryConsts::F32x4RelaxedMin:
      curr = allocator.alloc<Binary>();
      curr->op = RelaxedMinVecF32x4;
      break;
    case BinaryConsts::F32x4RelaxedMax:
      curr = allocator.alloc<Binary>();
      curr->op = RelaxedMaxVecF32x4;
      break;
    case BinaryConsts::F64x2RelaxedMin:
      curr = allocator.alloc<Binary>();
      curr->op = RelaxedMinVecF64x2;
      break;
    case BinaryConsts::F64x2RelaxedMax:
      curr = allocator.alloc<Binary>();
      curr->op = RelaxedMaxVecF64x2;
      break;
    case BinaryConsts::I16x8RelaxedQ15MulrS:
      curr = allocator.alloc<Binary>();
      curr->op = RelaxedQ15MulrSVecI16x8;
      break;
    case BinaryConsts::I16x8DotI8x16I7x16S:
      curr = allocator.alloc<Binary>();
      curr->op = DotI8x16I7x16SToVecI16x8;
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
bool WasmBinaryReader::maybeVisitSIMDUnary(Expression*& out, uint32_t code) {
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
    case BinaryConsts::F16x8Splat:
      curr = allocator.alloc<Unary>();
      curr->op = SplatVecF16x8;
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
    case BinaryConsts::V128AnyTrue:
      curr = allocator.alloc<Unary>();
      curr->op = AnyTrueVec128;
      break;
    case BinaryConsts::I8x16Popcnt:
      curr = allocator.alloc<Unary>();
      curr->op = PopcntVecI8x16;
      break;
    case BinaryConsts::I8x16Abs:
      curr = allocator.alloc<Unary>();
      curr->op = AbsVecI8x16;
      break;
    case BinaryConsts::I8x16Neg:
      curr = allocator.alloc<Unary>();
      curr->op = NegVecI8x16;
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
    case BinaryConsts::I32x4AllTrue:
      curr = allocator.alloc<Unary>();
      curr->op = AllTrueVecI32x4;
      break;
    case BinaryConsts::I32x4Bitmask:
      curr = allocator.alloc<Unary>();
      curr->op = BitmaskVecI32x4;
      break;
    case BinaryConsts::I64x2Abs:
      curr = allocator.alloc<Unary>();
      curr->op = AbsVecI64x2;
      break;
    case BinaryConsts::I64x2Neg:
      curr = allocator.alloc<Unary>();
      curr->op = NegVecI64x2;
      break;
    case BinaryConsts::I64x2AllTrue:
      curr = allocator.alloc<Unary>();
      curr->op = AllTrueVecI64x2;
      break;
    case BinaryConsts::I64x2Bitmask:
      curr = allocator.alloc<Unary>();
      curr->op = BitmaskVecI64x2;
      break;
    case BinaryConsts::F16x8Abs:
      curr = allocator.alloc<Unary>();
      curr->op = AbsVecF16x8;
      break;
    case BinaryConsts::F16x8Neg:
      curr = allocator.alloc<Unary>();
      curr->op = NegVecF16x8;
      break;
    case BinaryConsts::F16x8Sqrt:
      curr = allocator.alloc<Unary>();
      curr->op = SqrtVecF16x8;
      break;
    case BinaryConsts::F16x8Ceil:
      curr = allocator.alloc<Unary>();
      curr->op = CeilVecF16x8;
      break;
    case BinaryConsts::F16x8Floor:
      curr = allocator.alloc<Unary>();
      curr->op = FloorVecF16x8;
      break;
    case BinaryConsts::F16x8Trunc:
      curr = allocator.alloc<Unary>();
      curr->op = TruncVecF16x8;
      break;
    case BinaryConsts::F16x8Nearest:
      curr = allocator.alloc<Unary>();
      curr->op = NearestVecF16x8;
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
    case BinaryConsts::I16x8ExtaddPairwiseI8x16S:
      curr = allocator.alloc<Unary>();
      curr->op = ExtAddPairwiseSVecI8x16ToI16x8;
      break;
    case BinaryConsts::I16x8ExtaddPairwiseI8x16U:
      curr = allocator.alloc<Unary>();
      curr->op = ExtAddPairwiseUVecI8x16ToI16x8;
      break;
    case BinaryConsts::I32x4ExtaddPairwiseI16x8S:
      curr = allocator.alloc<Unary>();
      curr->op = ExtAddPairwiseSVecI16x8ToI32x4;
      break;
    case BinaryConsts::I32x4ExtaddPairwiseI16x8U:
      curr = allocator.alloc<Unary>();
      curr->op = ExtAddPairwiseUVecI16x8ToI32x4;
      break;
    case BinaryConsts::I32x4TruncSatF32x4S:
      curr = allocator.alloc<Unary>();
      curr->op = TruncSatSVecF32x4ToVecI32x4;
      break;
    case BinaryConsts::I32x4TruncSatF32x4U:
      curr = allocator.alloc<Unary>();
      curr->op = TruncSatUVecF32x4ToVecI32x4;
      break;
    case BinaryConsts::F32x4ConvertI32x4S:
      curr = allocator.alloc<Unary>();
      curr->op = ConvertSVecI32x4ToVecF32x4;
      break;
    case BinaryConsts::F32x4ConvertI32x4U:
      curr = allocator.alloc<Unary>();
      curr->op = ConvertUVecI32x4ToVecF32x4;
      break;
    case BinaryConsts::I16x8ExtendLowI8x16S:
      curr = allocator.alloc<Unary>();
      curr->op = ExtendLowSVecI8x16ToVecI16x8;
      break;
    case BinaryConsts::I16x8ExtendHighI8x16S:
      curr = allocator.alloc<Unary>();
      curr->op = ExtendHighSVecI8x16ToVecI16x8;
      break;
    case BinaryConsts::I16x8ExtendLowI8x16U:
      curr = allocator.alloc<Unary>();
      curr->op = ExtendLowUVecI8x16ToVecI16x8;
      break;
    case BinaryConsts::I16x8ExtendHighI8x16U:
      curr = allocator.alloc<Unary>();
      curr->op = ExtendHighUVecI8x16ToVecI16x8;
      break;
    case BinaryConsts::I32x4ExtendLowI16x8S:
      curr = allocator.alloc<Unary>();
      curr->op = ExtendLowSVecI16x8ToVecI32x4;
      break;
    case BinaryConsts::I32x4ExtendHighI16x8S:
      curr = allocator.alloc<Unary>();
      curr->op = ExtendHighSVecI16x8ToVecI32x4;
      break;
    case BinaryConsts::I32x4ExtendLowI16x8U:
      curr = allocator.alloc<Unary>();
      curr->op = ExtendLowUVecI16x8ToVecI32x4;
      break;
    case BinaryConsts::I32x4ExtendHighI16x8U:
      curr = allocator.alloc<Unary>();
      curr->op = ExtendHighUVecI16x8ToVecI32x4;
      break;
    case BinaryConsts::I64x2ExtendLowI32x4S:
      curr = allocator.alloc<Unary>();
      curr->op = ExtendLowSVecI32x4ToVecI64x2;
      break;
    case BinaryConsts::I64x2ExtendHighI32x4S:
      curr = allocator.alloc<Unary>();
      curr->op = ExtendHighSVecI32x4ToVecI64x2;
      break;
    case BinaryConsts::I64x2ExtendLowI32x4U:
      curr = allocator.alloc<Unary>();
      curr->op = ExtendLowUVecI32x4ToVecI64x2;
      break;
    case BinaryConsts::I64x2ExtendHighI32x4U:
      curr = allocator.alloc<Unary>();
      curr->op = ExtendHighUVecI32x4ToVecI64x2;
      break;
    case BinaryConsts::F64x2ConvertLowI32x4S:
      curr = allocator.alloc<Unary>();
      curr->op = ConvertLowSVecI32x4ToVecF64x2;
      break;
    case BinaryConsts::F64x2ConvertLowI32x4U:
      curr = allocator.alloc<Unary>();
      curr->op = ConvertLowUVecI32x4ToVecF64x2;
      break;
    case BinaryConsts::I32x4TruncSatF64x2SZero:
      curr = allocator.alloc<Unary>();
      curr->op = TruncSatZeroSVecF64x2ToVecI32x4;
      break;
    case BinaryConsts::I32x4TruncSatF64x2UZero:
      curr = allocator.alloc<Unary>();
      curr->op = TruncSatZeroUVecF64x2ToVecI32x4;
      break;
    case BinaryConsts::F32x4DemoteF64x2Zero:
      curr = allocator.alloc<Unary>();
      curr->op = DemoteZeroVecF64x2ToVecF32x4;
      break;
    case BinaryConsts::F64x2PromoteLowF32x4:
      curr = allocator.alloc<Unary>();
      curr->op = PromoteLowVecF32x4ToVecF64x2;
      break;
    case BinaryConsts::I32x4RelaxedTruncF32x4S:
      curr = allocator.alloc<Unary>();
      curr->op = RelaxedTruncSVecF32x4ToVecI32x4;
      break;
    case BinaryConsts::I32x4RelaxedTruncF32x4U:
      curr = allocator.alloc<Unary>();
      curr->op = RelaxedTruncUVecF32x4ToVecI32x4;
      break;
    case BinaryConsts::I32x4RelaxedTruncF64x2SZero:
      curr = allocator.alloc<Unary>();
      curr->op = RelaxedTruncZeroSVecF64x2ToVecI32x4;
      break;
    case BinaryConsts::I32x4RelaxedTruncF64x2UZero:
      curr = allocator.alloc<Unary>();
      curr->op = RelaxedTruncZeroUVecF64x2ToVecI32x4;
      break;
    default:
      return false;
  }
  curr->value = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryReader::maybeVisitSIMDConst(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::V128Const) {
    return false;
  }
  auto* curr = allocator.alloc<Const>();
  curr->value = getVec128Literal();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryReader::maybeVisitSIMDStore(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::V128Store) {
    return false;
  }
  auto* curr = allocator.alloc<Store>();
  curr->bytes = 16;
  curr->valueType = Type::v128;
  Index memIdx = readMemoryAccess(curr->align, curr->offset);
  memoryRefs[memIdx].push_back(&curr->memory);
  curr->isAtomic = false;
  curr->value = popNonVoidExpression();
  curr->ptr = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryReader::maybeVisitSIMDExtract(Expression*& out, uint32_t code) {
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
    case BinaryConsts::F16x8ExtractLane:
      curr = allocator.alloc<SIMDExtract>();
      curr->op = ExtractLaneVecF16x8;
      curr->index = getLaneIndex(8);
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

bool WasmBinaryReader::maybeVisitSIMDReplace(Expression*& out, uint32_t code) {
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
    case BinaryConsts::F16x8ReplaceLane:
      curr = allocator.alloc<SIMDReplace>();
      curr->op = ReplaceLaneVecF16x8;
      curr->index = getLaneIndex(8);
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

bool WasmBinaryReader::maybeVisitSIMDShuffle(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::I8x16Shuffle) {
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

bool WasmBinaryReader::maybeVisitSIMDTernary(Expression*& out, uint32_t code) {
  SIMDTernary* curr;
  switch (code) {
    case BinaryConsts::V128Bitselect:
      curr = allocator.alloc<SIMDTernary>();
      curr->op = Bitselect;
      break;
    case BinaryConsts::I8x16Laneselect:
      curr = allocator.alloc<SIMDTernary>();
      curr->op = LaneselectI8x16;
      break;
    case BinaryConsts::I16x8Laneselect:
      curr = allocator.alloc<SIMDTernary>();
      curr->op = LaneselectI16x8;
      break;
    case BinaryConsts::I32x4Laneselect:
      curr = allocator.alloc<SIMDTernary>();
      curr->op = LaneselectI32x4;
      break;
    case BinaryConsts::I64x2Laneselect:
      curr = allocator.alloc<SIMDTernary>();
      curr->op = LaneselectI64x2;
      break;
    case BinaryConsts::F16x8RelaxedMadd:
      curr = allocator.alloc<SIMDTernary>();
      curr->op = RelaxedMaddVecF16x8;
      break;
    case BinaryConsts::F16x8RelaxedNmadd:
      curr = allocator.alloc<SIMDTernary>();
      curr->op = RelaxedNmaddVecF16x8;
      break;
    case BinaryConsts::F32x4RelaxedMadd:
      curr = allocator.alloc<SIMDTernary>();
      curr->op = RelaxedMaddVecF32x4;
      break;
    case BinaryConsts::F32x4RelaxedNmadd:
      curr = allocator.alloc<SIMDTernary>();
      curr->op = RelaxedNmaddVecF32x4;
      break;
    case BinaryConsts::F64x2RelaxedMadd:
      curr = allocator.alloc<SIMDTernary>();
      curr->op = RelaxedMaddVecF64x2;
      break;
    case BinaryConsts::F64x2RelaxedNmadd:
      curr = allocator.alloc<SIMDTernary>();
      curr->op = RelaxedNmaddVecF64x2;
      break;
    case BinaryConsts::I32x4DotI8x16I7x16AddS:
      curr = allocator.alloc<SIMDTernary>();
      curr->op = DotI8x16I7x16AddSToVecI32x4;
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

bool WasmBinaryReader::maybeVisitSIMDShift(Expression*& out, uint32_t code) {
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

bool WasmBinaryReader::maybeVisitSIMDLoad(Expression*& out, uint32_t code) {
  if (code == BinaryConsts::V128Load) {
    auto* curr = allocator.alloc<Load>();
    curr->type = Type::v128;
    curr->bytes = 16;
    Index memIdx = readMemoryAccess(curr->align, curr->offset);
    memoryRefs[memIdx].push_back(&curr->memory);
    curr->isAtomic = false;
    curr->ptr = popNonVoidExpression();
    curr->finalize();
    out = curr;
    return true;
  }
  SIMDLoad* curr;
  switch (code) {
    case BinaryConsts::V128Load8Splat:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = Load8SplatVec128;
      break;
    case BinaryConsts::V128Load16Splat:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = Load16SplatVec128;
      break;
    case BinaryConsts::V128Load32Splat:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = Load32SplatVec128;
      break;
    case BinaryConsts::V128Load64Splat:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = Load64SplatVec128;
      break;
    case BinaryConsts::V128Load8x8S:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = Load8x8SVec128;
      break;
    case BinaryConsts::V128Load8x8U:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = Load8x8UVec128;
      break;
    case BinaryConsts::V128Load16x4S:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = Load16x4SVec128;
      break;
    case BinaryConsts::V128Load16x4U:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = Load16x4UVec128;
      break;
    case BinaryConsts::V128Load32x2S:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = Load32x2SVec128;
      break;
    case BinaryConsts::V128Load32x2U:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = Load32x2UVec128;
      break;
    case BinaryConsts::V128Load32Zero:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = Load32ZeroVec128;
      break;
    case BinaryConsts::V128Load64Zero:
      curr = allocator.alloc<SIMDLoad>();
      curr->op = Load64ZeroVec128;
      break;
    default:
      return false;
  }
  Index memIdx = readMemoryAccess(curr->align, curr->offset);
  memoryRefs[memIdx].push_back(&curr->memory);
  curr->ptr = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryReader::maybeVisitSIMDLoadStoreLane(Expression*& out,
                                                   uint32_t code) {
  SIMDLoadStoreLaneOp op;
  size_t lanes;
  switch (code) {
    case BinaryConsts::V128Load8Lane:
      op = Load8LaneVec128;
      lanes = 16;
      break;
    case BinaryConsts::V128Load16Lane:
      op = Load16LaneVec128;
      lanes = 8;
      break;
    case BinaryConsts::V128Load32Lane:
      op = Load32LaneVec128;
      lanes = 4;
      break;
    case BinaryConsts::V128Load64Lane:
      op = Load64LaneVec128;
      lanes = 2;
      break;
    case BinaryConsts::V128Store8Lane:
      op = Store8LaneVec128;
      lanes = 16;
      break;
    case BinaryConsts::V128Store16Lane:
      op = Store16LaneVec128;
      lanes = 8;
      break;
    case BinaryConsts::V128Store32Lane:
      op = Store32LaneVec128;
      lanes = 4;
      break;
    case BinaryConsts::V128Store64Lane:
      op = Store64LaneVec128;
      lanes = 2;
      break;
    default:
      return false;
  }
  auto* curr = allocator.alloc<SIMDLoadStoreLane>();
  curr->op = op;
  Index memIdx = readMemoryAccess(curr->align, curr->offset);
  memoryRefs[memIdx].push_back(&curr->memory);
  curr->index = getLaneIndex(lanes);
  curr->vec = popNonVoidExpression();
  curr->ptr = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

void WasmBinaryReader::visitSelect(Select* curr, uint8_t code) {
  BYN_TRACE("zz node: Select, code " << int32_t(code) << std::endl);
  if (code == BinaryConsts::SelectWithType) {
    size_t numTypes = getU32LEB();
    std::vector<Type> types;
    for (size_t i = 0; i < numTypes; i++) {
      auto t = getType();
      if (!t.isConcrete()) {
        throwError("bad select type");
      }
      types.push_back(t);
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

void WasmBinaryReader::visitReturn(Return* curr) {
  BYN_TRACE("zz node: Return\n");
  requireFunctionContext("return");
  Type type = currFunction->getResults();
  if (type.isConcrete()) {
    curr->value = popTypedExpression(type);
  }
  curr->finalize();
}

void WasmBinaryReader::visitMemorySize(MemorySize* curr) {
  BYN_TRACE("zz node: MemorySize\n");
  Index index = getU32LEB();
  if (getMemory(index)->is64()) {
    curr->type = Type::i64;
  }
  curr->finalize();
  memoryRefs[index].push_back(&curr->memory);
}

void WasmBinaryReader::visitMemoryGrow(MemoryGrow* curr) {
  BYN_TRACE("zz node: MemoryGrow\n");
  curr->delta = popNonVoidExpression();
  Index index = getU32LEB();
  if (getMemory(index)->is64()) {
    curr->type = Type::i64;
  }
  memoryRefs[index].push_back(&curr->memory);
}

void WasmBinaryReader::visitNop(Nop* curr) { BYN_TRACE("zz node: Nop\n"); }

void WasmBinaryReader::visitUnreachable(Unreachable* curr) {
  BYN_TRACE("zz node: Unreachable\n");
}

void WasmBinaryReader::visitDrop(Drop* curr) {
  BYN_TRACE("zz node: Drop\n");
  curr->value = popNonVoidExpression();
  curr->finalize();
}

void WasmBinaryReader::visitRefNull(RefNull* curr) {
  BYN_TRACE("zz node: RefNull\n");
  curr->finalize(getHeapType().getBottom());
}

void WasmBinaryReader::visitRefIsNull(RefIsNull* curr) {
  BYN_TRACE("zz node: RefIsNull\n");
  curr->value = popNonVoidExpression();
  curr->finalize();
}

void WasmBinaryReader::visitRefFunc(RefFunc* curr) {
  BYN_TRACE("zz node: RefFunc\n");
  Index index = getU32LEB();
  // We don't know function names yet, so record this use to be updated later.
  // Note that we do not need to check that 'index' is in bounds, as that will
  // be verified in the next line. (Also, note that functionRefs[index] may
  // write to an odd place in the functionRefs map if index is invalid, but that
  // is harmless.)
  functionRefs[index].push_back(&curr->func);
  // To support typed function refs, we give the reference not just a general
  // funcref, but a specific subtype with the actual signature.
  curr->finalize(Type(getTypeByFunctionIndex(index), NonNullable));
}

void WasmBinaryReader::visitRefEq(RefEq* curr) {
  BYN_TRACE("zz node: RefEq\n");
  curr->right = popNonVoidExpression();
  curr->left = popNonVoidExpression();
  curr->finalize();
}

void WasmBinaryReader::visitTableGet(TableGet* curr) {
  BYN_TRACE("zz node: TableGet\n");
  Index tableIdx = getU32LEB();
  if (tableIdx >= wasm.tables.size()) {
    throwError("bad table index");
  }
  curr->index = popNonVoidExpression();
  curr->type = wasm.tables[tableIdx]->type;
  curr->finalize();
  // Defer setting the table name for later, when we know it.
  tableRefs[tableIdx].push_back(&curr->table);
}

void WasmBinaryReader::visitTableSet(TableSet* curr) {
  BYN_TRACE("zz node: TableSet\n");
  Index tableIdx = getU32LEB();
  if (tableIdx >= wasm.tables.size()) {
    throwError("bad table index");
  }
  curr->value = popNonVoidExpression();
  curr->index = popNonVoidExpression();
  curr->finalize();
  // Defer setting the table name for later, when we know it.
  tableRefs[tableIdx].push_back(&curr->table);
}

void WasmBinaryReader::visitTryOrTryInBlock(Expression*& out) {
  BYN_TRACE("zz node: Try\n");
  auto* curr = allocator.alloc<Try>();
  startControlFlow(curr);
  // For simplicity of implementation, like if scopes, we create a hidden block
  // within each try-body and catch-body, and let branches target those inner
  // blocks instead.
  curr->type = getType();
  curr->body = getBlockOrSingleton(curr->type);

  Builder builder(wasm);
  // A nameless label shared by all catch body blocks
  Name catchLabel = getNextLabel();
  breakStack.push_back({catchLabel, curr->type});

  auto readCatchBody = [&](Type tagType) {
    auto start = expressionStack.size();
    if (tagType != Type::none) {
      pushExpression(builder.makePop(tagType));
    }
    processExpressions();
    size_t end = expressionStack.size();
    if (start > end) {
      throwError("block cannot pop from outside");
    }
    if (end - start == 1) {
      curr->catchBodies.push_back(popExpression());
    } else {
      auto* block = allocator.alloc<Block>();
      pushBlockElements(block, curr->type, start);
      block->finalize(curr->type);
      curr->catchBodies.push_back(block);
    }
  };

  // We cannot immediately update tagRefs in the loop below, as catchTags is
  // being grown, an so references would get invalidated. Store the indexes
  // here, then do that later.
  std::vector<Index> tagIndexes;

  while (lastSeparator == BinaryConsts::Catch_Legacy ||
         lastSeparator == BinaryConsts::CatchAll_Legacy) {
    if (lastSeparator == BinaryConsts::Catch_Legacy) {
      auto index = getU32LEB();
      if (index >= wasm.tags.size()) {
        throwError("bad tag index");
      }
      tagIndexes.push_back(index);
      auto* tag = wasm.tags[index].get();
      curr->catchTags.push_back(tag->name);
      readCatchBody(tag->sig.params);
    } else { // catch_all
      if (curr->hasCatchAll()) {
        throwError("there should be at most one 'catch_all' clause per try");
      }
      readCatchBody(Type::none);
    }
  }
  breakStack.pop_back();

  for (Index i = 0; i < tagIndexes.size(); i++) {
    // We don't know the final name yet.
    tagRefs[tagIndexes[i]].push_back(&curr->catchTags[i]);
  }

  if (lastSeparator == BinaryConsts::Delegate) {
    curr->delegateTarget = getExceptionTargetName(getU32LEB());
  }

  // For simplicity, we ensure that try's labels can only be targeted by
  // delegates and rethrows, and delegates/rethrows can only target try's
  // labels. (If they target blocks or loops, it is a validation failure.)
  // Because we create an inner block within each try and catch body, if any
  // delegate/rethrow targets those inner blocks, we should make them target the
  // try's label instead.
  curr->name = getNextLabel();
  if (auto* block = curr->body->dynCast<Block>()) {
    if (block->name.is()) {
      if (exceptionTargetNames.find(block->name) !=
          exceptionTargetNames.end()) {
        BranchUtils::replaceExceptionTargets(block, block->name, curr->name);
        exceptionTargetNames.erase(block->name);
      }
    }
  }
  if (exceptionTargetNames.find(catchLabel) != exceptionTargetNames.end()) {
    for (auto* catchBody : curr->catchBodies) {
      BranchUtils::replaceExceptionTargets(catchBody, catchLabel, curr->name);
    }
    exceptionTargetNames.erase(catchLabel);
  }

  // If catch bodies contained stacky code, 'pop's can be nested within a block.
  // Fix that up.
  EHUtils::handleBlockNestedPop(curr, currFunction, wasm);
  curr->finalize(curr->type);

  // For simplicity, we create an inner block within the catch body too, but the
  // one within the 'catch' *must* be omitted when we write out the binary back
  // later, because the 'catch' instruction pushes a value onto the stack and
  // the inner block does not support block input parameters without multivalue
  // support.
  // try
  //   ...
  // catch $e   ;; Pushes value(s) onto the stack
  //   block  ;; Inner block. Should be deleted when writing binary!
  //     use the pushed value
  //   end
  // end
  //
  // But when input binary code is like
  // try
  //   ...
  // catch $e
  //   br 0
  // end
  //
  // 'br 0' accidentally happens to target the inner block, creating code like
  // this in Binaryen IR, making the inner block not deletable, resulting in a
  // validation error:
  // (try
  //   ...
  //   (catch $e
  //     (block $label0 ;; Cannot be deleted, because there's a branch to this
  //       ...
  //       (br $label0)
  //     )
  //   )
  // )
  //
  // When this happens, we fix this by creating a block that wraps the whole
  // try-catch, and making the branches target that block instead, like this:
  // (block $label  ;; New enclosing block, new target for the branch
  //   (try
  //     ...
  //     (catch $e
  //       (block   ;; Now this can be deleted when writing binary
  //         ...
  //         (br $label)
  //       )
  //     )
  //   )
  // )
  if (breakTargetNames.find(catchLabel) == breakTargetNames.end()) {
    out = curr;
  } else {
    // Create a new block that encloses the whole try-catch
    auto* block = builder.makeBlock(catchLabel, curr);
    out = block;
  }
  breakTargetNames.erase(catchLabel);
}

void WasmBinaryReader::visitTryTable(TryTable* curr) {
  BYN_TRACE("zz node: TryTable\n");

  // For simplicity of implementation, like if scopes, we create a hidden block
  // within each try-body, and let branches target those inner blocks instead.
  curr->type = getType();
  auto numCatches = getU32LEB();
  // We cannot immediately update tagRefs in the loop below, as catchTags is
  // being grown, an so references would get invalidated. Store the indexes
  // here, then do that later.
  std::vector<Index> tagIndexes;

  for (size_t i = 0; i < numCatches; i++) {
    uint8_t code = getInt8();
    if (code == BinaryConsts::Catch || code == BinaryConsts::CatchRef) {
      auto index = getU32LEB();
      if (index >= wasm.tags.size()) {
        throwError("bad tag index");
      }
      tagIndexes.push_back(index);
      auto* tag = wasm.tags[index].get();
      curr->catchTags.push_back(tag->name);
    } else {
      tagIndexes.push_back(-1); // unused
      curr->catchTags.push_back(Name());
    }
    curr->catchDests.push_back(getBreakTarget(getU32LEB()).name);
    curr->catchRefs.push_back(code == BinaryConsts::CatchRef ||
                              code == BinaryConsts::CatchAllRef);
  }

  for (Index i = 0; i < tagIndexes.size(); i++) {
    if (curr->catchTags[i]) {
      // We don't know the final name yet.
      tagRefs[tagIndexes[i]].push_back(&curr->catchTags[i]);
    }
  }

  // catch_*** clauses should refer to block labels without entering the try
  // scope. So we do this after reading catch clauses.
  startControlFlow(curr);
  curr->body = getBlockOrSingleton(curr->type);
  curr->finalize(curr->type, &wasm);
}

void WasmBinaryReader::visitThrow(Throw* curr) {
  BYN_TRACE("zz node: Throw\n");
  auto index = getU32LEB();
  if (index >= wasm.tags.size()) {
    throwError("bad tag index");
  }
  auto* tag = wasm.tags[index].get();
  curr->tag = tag->name;
  tagRefs[index].push_back(&curr->tag); // we don't know the final name yet
  size_t num = tag->sig.params.size();
  curr->operands.resize(num);
  for (size_t i = 0; i < num; i++) {
    curr->operands[num - i - 1] = popNonVoidExpression();
  }
  curr->finalize();
}

void WasmBinaryReader::visitRethrow(Rethrow* curr) {
  BYN_TRACE("zz node: Rethrow\n");
  curr->target = getExceptionTargetName(getU32LEB());
  // This special target is valid only for delegates
  if (curr->target == DELEGATE_CALLER_TARGET) {
    throwError(std::string("rethrow target cannot use internal name ") +
               DELEGATE_CALLER_TARGET.toString());
  }
  curr->finalize();
}

void WasmBinaryReader::visitThrowRef(ThrowRef* curr) {
  BYN_TRACE("zz node: ThrowRef\n");
  curr->exnref = popNonVoidExpression();
  curr->finalize();
}

void WasmBinaryReader::visitCallRef(CallRef* curr) {
  BYN_TRACE("zz node: CallRef\n");
  curr->target = popNonVoidExpression();
  HeapType heapType = getTypeByIndex(getU32LEB());
  if (!Type::isSubType(curr->target->type, Type(heapType, Nullable))) {
    throwError("Call target has invalid type: " +
               curr->target->type.toString());
  }
  if (!heapType.isSignature()) {
    throwError("Invalid reference type for a call_ref: " + heapType.toString());
  }
  auto sig = heapType.getSignature();
  auto num = sig.params.size();
  curr->operands.resize(num);
  for (size_t i = 0; i < num; i++) {
    curr->operands[num - i - 1] = popNonVoidExpression();
  }
  // If the target has bottom type, we won't be able to infer the correct type
  // from it, so set the type manually to be safe.
  curr->type = sig.results;
  curr->finalize();
}

bool WasmBinaryReader::maybeVisitRefI31(Expression*& out, uint32_t code) {
  Shareability share;
  switch (code) {
    case BinaryConsts::RefI31:
      share = Unshared;
      break;
    case BinaryConsts::RefI31Shared:
      share = Shared;
      break;
    default:
      return false;
  }
  auto* value = popNonVoidExpression();
  out = Builder(wasm).makeRefI31(value, share);
  return true;
}

bool WasmBinaryReader::maybeVisitI31Get(Expression*& out, uint32_t code) {
  I31Get* curr;
  switch (code) {
    case BinaryConsts::I31GetS:
      curr = allocator.alloc<I31Get>();
      curr->signed_ = true;
      break;
    case BinaryConsts::I31GetU:
      curr = allocator.alloc<I31Get>();
      curr->signed_ = false;
      break;
    default:
      return false;
  }
  curr->i31 = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryReader::maybeVisitRefTest(Expression*& out, uint32_t code) {
  if (code == BinaryConsts::RefTest || code == BinaryConsts::RefTestNull) {
    auto castType = getHeapType();
    auto nullability =
      (code == BinaryConsts::RefTestNull) ? Nullable : NonNullable;
    auto* ref = popNonVoidExpression();
    out = Builder(wasm).makeRefTest(ref, Type(castType, nullability));
    return true;
  }
  return false;
}

bool WasmBinaryReader::maybeVisitRefCast(Expression*& out, uint32_t code) {
  if (code == BinaryConsts::RefCast || code == BinaryConsts::RefCastNull) {
    auto heapType = getHeapType();
    auto nullability = code == BinaryConsts::RefCast ? NonNullable : Nullable;
    auto type = Type(heapType, nullability);
    auto* ref = popNonVoidExpression();
    out = Builder(wasm).makeRefCast(ref, type);
    return true;
  }
  return false;
}

bool WasmBinaryReader::maybeVisitBrOn(Expression*& out, uint32_t code) {
  Type castType = Type::none;
  BrOnOp op;
  switch (code) {
    case BinaryConsts::BrOnNull:
      op = BrOnNull;
      break;
    case BinaryConsts::BrOnNonNull:
      op = BrOnNonNull;
      break;
    case BinaryConsts::BrOnCast:
      op = BrOnCast;
      break;
    case BinaryConsts::BrOnCastFail:
      op = BrOnCastFail;
      break;
    default:
      return false;
  }
  bool isCast =
    code == BinaryConsts::BrOnCast || code == BinaryConsts::BrOnCastFail;
  uint8_t flags = 0;
  if (isCast) {
    flags = getInt8();
  }
  auto name = getBreakTarget(getU32LEB()).name;
  auto* ref = popNonVoidExpression();
  if (!ref->type.isRef() && ref->type != Type::unreachable) {
    throwError("bad input type for br_on*");
  }
  if (isCast) {
    auto inputNullability = (flags & 1) ? Nullable : NonNullable;
    auto castNullability = (flags & 2) ? Nullable : NonNullable;
    auto inputHeapType = getHeapType();
    auto castHeapType = getHeapType();
    castType = Type(castHeapType, castNullability);
    auto inputType = Type(inputHeapType, inputNullability);
    if (!Type::isSubType(castType, inputType)) {
      throwError("br_on_cast* cast type must be subtype of input type");
    }
    if (!Type::isSubType(ref->type, inputType)) {
      throwError(std::string("Invalid reference type for ") +
                 ((op == BrOnCast) ? "br_on_cast" : "br_on_cast_fail"));
    }
  }
  out = Builder(wasm).makeBrOn(op, name, ref, castType);
  return true;
}

bool WasmBinaryReader::maybeVisitStructNew(Expression*& out, uint32_t code) {
  if (code == BinaryConsts::StructNew ||
      code == BinaryConsts::StructNewDefault) {
    auto heapType = getIndexedHeapType();
    if (!heapType.isStruct()) {
      throwError("Expected struct heaptype");
    }
    std::vector<Expression*> operands;
    if (code == BinaryConsts::StructNew) {
      auto numOperands = heapType.getStruct().fields.size();
      operands.resize(numOperands);
      for (Index i = 0; i < numOperands; i++) {
        operands[numOperands - i - 1] = popNonVoidExpression();
      }
    }
    out = Builder(wasm).makeStructNew(heapType, operands);
    return true;
  }
  return false;
}

bool WasmBinaryReader::maybeVisitStructGet(Expression*& out, uint32_t code) {
  bool signed_ = false;
  switch (code) {
    case BinaryConsts::StructGet:
    case BinaryConsts::StructGetU:
      break;
    case BinaryConsts::StructGetS:
      signed_ = true;
      break;
    default:
      return false;
  }
  auto heapType = getIndexedHeapType();
  if (!heapType.isStruct()) {
    throwError("Expected struct heaptype");
  }
  auto index = getU32LEB();
  if (index >= heapType.getStruct().fields.size()) {
    throwError("Struct field index out of bounds");
  }
  auto type = heapType.getStruct().fields[index].type;
  auto ref = popNonVoidExpression();
  validateHeapTypeUsingChild(ref, heapType);
  out = Builder(wasm).makeStructGet(index, ref, type, signed_);
  return true;
}

bool WasmBinaryReader::maybeVisitStructSet(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::StructSet) {
    return false;
  }
  auto* curr = allocator.alloc<StructSet>();
  auto heapType = getIndexedHeapType();
  if (!heapType.isStruct()) {
    throwError("Expected struct heaptype");
  }
  curr->index = getU32LEB();
  curr->value = popNonVoidExpression();
  curr->ref = popNonVoidExpression();
  validateHeapTypeUsingChild(curr->ref, heapType);
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryReader::maybeVisitArrayNewData(Expression*& out, uint32_t code) {
  if (code == BinaryConsts::ArrayNew || code == BinaryConsts::ArrayNewDefault) {
    auto heapType = getIndexedHeapType();
    if (!heapType.isArray()) {
      throwError("Expected array heaptype");
    }
    auto* size = popNonVoidExpression();
    Expression* init = nullptr;
    if (code == BinaryConsts::ArrayNew) {
      init = popNonVoidExpression();
    }
    out = Builder(wasm).makeArrayNew(heapType, size, init);
    return true;
  }
  return false;
}

bool WasmBinaryReader::maybeVisitArrayNewElem(Expression*& out, uint32_t code) {
  if (code == BinaryConsts::ArrayNewData ||
      code == BinaryConsts::ArrayNewElem) {
    auto isData = code == BinaryConsts::ArrayNewData;
    auto heapType = getIndexedHeapType();
    if (!heapType.isArray()) {
      throwError("Expected array heaptype");
    }
    auto segIdx = getU32LEB();
    auto* size = popNonVoidExpression();
    auto* offset = popNonVoidExpression();
    if (isData) {
      auto* curr =
        Builder(wasm).makeArrayNewData(heapType, Name(), offset, size);
      dataRefs[segIdx].push_back(&curr->segment);
      out = curr;
    } else {
      auto* curr =
        Builder(wasm).makeArrayNewElem(heapType, Name(), offset, size);
      elemRefs[segIdx].push_back(&curr->segment);
      out = curr;
    }
    return true;
  }
  return false;
}

bool WasmBinaryReader::maybeVisitArrayNewFixed(Expression*& out,
                                               uint32_t code) {
  if (code == BinaryConsts::ArrayNewFixed) {
    auto heapType = getIndexedHeapType();
    if (!heapType.isArray()) {
      throwError("Expected array heaptype");
    }
    auto size = getU32LEB();
    std::vector<Expression*> values(size);
    for (size_t i = 0; i < size; i++) {
      values[size - i - 1] = popNonVoidExpression();
    }
    out = Builder(wasm).makeArrayNewFixed(heapType, values);
    return true;
  }
  return false;
}

bool WasmBinaryReader::maybeVisitArrayGet(Expression*& out, uint32_t code) {
  bool signed_ = false;
  switch (code) {
    case BinaryConsts::ArrayGet:
    case BinaryConsts::ArrayGetU:
      break;
    case BinaryConsts::ArrayGetS:
      signed_ = true;
      break;
    default:
      return false;
  }
  auto heapType = getIndexedHeapType();
  if (!heapType.isArray()) {
    throwError("Expected array heaptype");
  }
  auto type = heapType.getArray().element.type;
  auto* index = popNonVoidExpression();
  auto* ref = popNonVoidExpression();
  validateHeapTypeUsingChild(ref, heapType);
  out = Builder(wasm).makeArrayGet(ref, index, type, signed_);
  return true;
}

bool WasmBinaryReader::maybeVisitArraySet(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::ArraySet) {
    return false;
  }
  auto heapType = getIndexedHeapType();
  if (!heapType.isArray()) {
    throwError("Expected array heaptype");
  }
  auto* value = popNonVoidExpression();
  auto* index = popNonVoidExpression();
  auto* ref = popNonVoidExpression();
  validateHeapTypeUsingChild(ref, heapType);
  out = Builder(wasm).makeArraySet(ref, index, value);
  return true;
}

bool WasmBinaryReader::maybeVisitArrayLen(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::ArrayLen) {
    return false;
  }
  auto* ref = popNonVoidExpression();
  out = Builder(wasm).makeArrayLen(ref);
  return true;
}

bool WasmBinaryReader::maybeVisitArrayCopy(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::ArrayCopy) {
    return false;
  }
  auto destHeapType = getIndexedHeapType();
  if (!destHeapType.isArray()) {
    throwError("Expected array heaptype");
  }
  auto srcHeapType = getIndexedHeapType();
  if (!srcHeapType.isArray()) {
    throwError("Expected array heaptype");
  }
  auto* length = popNonVoidExpression();
  auto* srcIndex = popNonVoidExpression();
  auto* srcRef = popNonVoidExpression();
  auto* destIndex = popNonVoidExpression();
  auto* destRef = popNonVoidExpression();
  validateHeapTypeUsingChild(destRef, destHeapType);
  validateHeapTypeUsingChild(srcRef, srcHeapType);
  out =
    Builder(wasm).makeArrayCopy(destRef, destIndex, srcRef, srcIndex, length);
  return true;
}

bool WasmBinaryReader::maybeVisitArrayFill(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::ArrayFill) {
    return false;
  }
  auto heapType = getIndexedHeapType();
  if (!heapType.isArray()) {
    throwError("Expected array heaptype");
  }
  auto* size = popNonVoidExpression();
  auto* value = popNonVoidExpression();
  auto* index = popNonVoidExpression();
  auto* ref = popNonVoidExpression();
  validateHeapTypeUsingChild(ref, heapType);
  out = Builder(wasm).makeArrayFill(ref, index, value, size);
  return true;
}

bool WasmBinaryReader::maybeVisitArrayInit(Expression*& out, uint32_t code) {
  bool isData = true;
  switch (code) {
    case BinaryConsts::ArrayInitData:
      break;
    case BinaryConsts::ArrayInitElem:
      isData = false;
      break;
    default:
      return false;
  }
  auto heapType = getIndexedHeapType();
  if (!heapType.isArray()) {
    throwError("Expected array heaptype");
  }
  Index segIdx = getU32LEB();
  auto* size = popNonVoidExpression();
  auto* offset = popNonVoidExpression();
  auto* index = popNonVoidExpression();
  auto* ref = popNonVoidExpression();
  validateHeapTypeUsingChild(ref, heapType);
  if (isData) {
    auto* curr =
      Builder(wasm).makeArrayInitData(Name(), ref, index, offset, size);
    dataRefs[segIdx].push_back(&curr->segment);
    out = curr;
  } else {
    auto* curr =
      Builder(wasm).makeArrayInitElem(Name(), ref, index, offset, size);
    elemRefs[segIdx].push_back(&curr->segment);
    out = curr;
  }
  return true;
}

bool WasmBinaryReader::maybeVisitStringNew(Expression*& out, uint32_t code) {
  StringNewOp op;
  if (code == BinaryConsts::StringNewLossyUTF8Array) {
    op = StringNewLossyUTF8Array;
  } else if (code == BinaryConsts::StringNewWTF16Array) {
    op = StringNewWTF16Array;
  } else if (code == BinaryConsts::StringFromCodePoint) {
    out = Builder(wasm).makeStringNew(StringNewFromCodePoint,
                                      popNonVoidExpression());
    return true;
  } else {
    return false;
  }
  Expression* end = popNonVoidExpression();
  Expression* start = popNonVoidExpression();
  auto* ref = popNonVoidExpression();
  out = Builder(wasm).makeStringNew(op, ref, start, end);
  return true;
}

bool WasmBinaryReader::maybeVisitStringAsWTF16(Expression*& out,
                                               uint32_t code) {
  if (code != BinaryConsts::StringAsWTF16) {
    return false;
  }
  // Accept but ignore `string.as_wtf16`, parsing the next expression in its
  // place. We do not support this instruction in the IR, but we need to accept
  // it in the parser because it is emitted as part of the instruction sequence
  // for `stringview_wtf16.get_codeunit` and `stringview_wtf16.slice`.
  readExpression(out);
  return true;
}

bool WasmBinaryReader::maybeVisitStringConst(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::StringConst) {
    return false;
  }
  auto index = getU32LEB();
  if (index >= strings.size()) {
    throwError("bad string index");
  }
  out = Builder(wasm).makeStringConst(strings[index]);
  return true;
}

bool WasmBinaryReader::maybeVisitStringMeasure(Expression*& out,
                                               uint32_t code) {
  StringMeasureOp op;
  if (code == BinaryConsts::StringMeasureUTF8) {
    op = StringMeasureUTF8;
  } else if (code == BinaryConsts::StringMeasureWTF16) {
    op = StringMeasureWTF16;
  } else {
    return false;
  }
  auto* ref = popNonVoidExpression();
  out = Builder(wasm).makeStringMeasure(op, ref);
  return true;
}

bool WasmBinaryReader::maybeVisitStringEncode(Expression*& out, uint32_t code) {
  StringEncodeOp op;
  if (code == BinaryConsts::StringEncodeLossyUTF8Array) {
    op = StringEncodeLossyUTF8Array;
  } else if (code == BinaryConsts::StringEncodeWTF16Array) {
    op = StringEncodeWTF16Array;
  } else {
    return false;
  }
  auto* start = popNonVoidExpression();
  auto* ptr = popNonVoidExpression();
  auto* ref = popNonVoidExpression();
  out = Builder(wasm).makeStringEncode(op, ref, ptr, start);
  return true;
}

bool WasmBinaryReader::maybeVisitStringConcat(Expression*& out, uint32_t code) {
  if (code != BinaryConsts::StringConcat) {
    return false;
  }
  auto* right = popNonVoidExpression();
  auto* left = popNonVoidExpression();
  out = Builder(wasm).makeStringConcat(left, right);
  return true;
}

bool WasmBinaryReader::maybeVisitStringEq(Expression*& out, uint32_t code) {
  StringEqOp op;
  if (code == BinaryConsts::StringEq) {
    op = StringEqEqual;
  } else if (code == BinaryConsts::StringCompare) {
    op = StringEqCompare;
  } else {
    return false;
  }
  auto* right = popNonVoidExpression();
  auto* left = popNonVoidExpression();
  out = Builder(wasm).makeStringEq(op, left, right);
  return true;
}

bool WasmBinaryReader::maybeVisitStringWTF16Get(Expression*& out,
                                                uint32_t code) {
  if (code != BinaryConsts::StringViewWTF16GetCodePoint) {
    return false;
  }
  auto* pos = popNonVoidExpression();
  auto* ref = popNonVoidExpression();
  out = Builder(wasm).makeStringWTF16Get(ref, pos);
  return true;
}

bool WasmBinaryReader::maybeVisitStringSliceWTF(Expression*& out,
                                                uint32_t code) {
  if (code != BinaryConsts::StringViewWTF16Slice) {
    return false;
  }
  auto* end = popNonVoidExpression();
  auto* start = popNonVoidExpression();
  auto* ref = popNonVoidExpression();
  out = Builder(wasm).makeStringSliceWTF(ref, start, end);
  return true;
}

void WasmBinaryReader::visitRefAs(RefAs* curr, uint8_t code) {
  BYN_TRACE("zz node: RefAs\n");
  switch (code) {
    case BinaryConsts::RefAsNonNull:
      curr->op = RefAsNonNull;
      break;
    case BinaryConsts::AnyConvertExtern:
      curr->op = AnyConvertExtern;
      break;
    case BinaryConsts::ExternConvertAny:
      curr->op = ExternConvertAny;
      break;
    default:
      WASM_UNREACHABLE("invalid code for ref.as_*");
  }
  curr->value = popNonVoidExpression();
  if (!curr->value->type.isRef() && curr->value->type != Type::unreachable) {
    throwError("bad input type for ref.as: " + curr->value->type.toString());
  }
  curr->finalize();
}

void WasmBinaryReader::visitContBind(ContBind* curr) {
  BYN_TRACE("zz node: ContBind\n");

  auto contTypeBeforeIndex = getU32LEB();
  curr->contTypeBefore = getTypeByIndex(contTypeBeforeIndex);

  auto contTypeAfterIndex = getU32LEB();
  curr->contTypeAfter = getTypeByIndex(contTypeAfterIndex);

  for (auto& ct : {curr->contTypeBefore, curr->contTypeAfter}) {
    if (!ct.isContinuation()) {
      throwError("non-continuation type in cont.bind instruction " +
                 ct.toString());
    }
  }

  curr->cont = popNonVoidExpression();

  size_t paramsBefore =
    curr->contTypeBefore.getContinuation().type.getSignature().params.size();
  size_t paramsAfter =
    curr->contTypeAfter.getContinuation().type.getSignature().params.size();
  if (paramsBefore < paramsAfter) {
    throwError("incompatible continuation types in cont.bind: source type " +
               curr->contTypeBefore.toString() +
               " has fewer parameters than destination " +
               curr->contTypeAfter.toString());
  }
  size_t numArgs = paramsBefore - paramsAfter;
  curr->operands.resize(numArgs);
  for (size_t i = 0; i < numArgs; i++) {
    curr->operands[numArgs - i - 1] = popNonVoidExpression();
  }

  curr->finalize();
}

void WasmBinaryReader::visitContNew(ContNew* curr) {
  BYN_TRACE("zz node: ContNew\n");

  auto contTypeIndex = getU32LEB();
  curr->contType = getTypeByIndex(contTypeIndex);
  if (!curr->contType.isContinuation()) {
    throwError("non-continuation type in cont.new instruction " +
               curr->contType.toString());
  }

  curr->func = popNonVoidExpression();
  curr->finalize();
}

void WasmBinaryReader::visitResume(Resume* curr) {
  BYN_TRACE("zz node: Resume\n");

  auto contTypeIndex = getU32LEB();
  curr->contType = getTypeByIndex(contTypeIndex);
  if (!curr->contType.isContinuation()) {
    throwError("non-continuation type in resume instruction " +
               curr->contType.toString());
  }

  auto numHandlers = getU32LEB();

  // We *must* bring the handlerTags vector to an appropriate size to ensure
  // that we do not invalidate the pointers we add to tagRefs. They need to stay
  // valid until processNames ran.
  curr->handlerTags.resize(numHandlers);
  curr->handlerBlocks.resize(numHandlers);

  BYN_TRACE("handler num: " << numHandlers << std::endl);
  for (size_t i = 0; i < numHandlers; i++) {
    BYN_TRACE("read one tag handler pair \n");
    auto tagIndex = getU32LEB();
    auto tag = getTagName(tagIndex);

    auto handlerIndex = getU32LEB();
    auto handler = getBreakTarget(handlerIndex).name;

    curr->handlerTags[i] = tag;
    curr->handlerBlocks[i] = handler;

    // We don't know the final name yet
    tagRefs[tagIndex].push_back(&curr->handlerTags[i]);
  }

  curr->cont = popNonVoidExpression();

  auto numArgs =
    curr->contType.getContinuation().type.getSignature().params.size();
  curr->operands.resize(numArgs);
  for (size_t i = 0; i < numArgs; i++) {
    curr->operands[numArgs - i - 1] = popNonVoidExpression();
  }

  curr->finalize(&wasm);
}

void WasmBinaryReader::visitSuspend(Suspend* curr) {
  BYN_TRACE("zz node: Suspend\n");

  auto tagIndex = getU32LEB();
  if (tagIndex >= wasm.tags.size()) {
    throwError("bad tag index");
  }
  auto* tag = wasm.tags[tagIndex].get();
  curr->tag = tag->name;
  tagRefs[tagIndex].push_back(&curr->tag);

  auto numArgs = tag->sig.params.size();
  curr->operands.resize(numArgs);
  for (size_t i = 0; i < numArgs; i++) {
    curr->operands[numArgs - i - 1] = popNonVoidExpression();
  }

  curr->finalize(&wasm);
}

void WasmBinaryReader::throwError(std::string text) {
  throw ParseException(text, 0, pos);
}

void WasmBinaryReader::validateHeapTypeUsingChild(Expression* child,
                                                  HeapType heapType) {
  if (child->type == Type::unreachable) {
    return;
  }
  if (!child->type.isRef() ||
      !HeapType::isSubType(child->type.getHeapType(), heapType)) {
    throwError("bad heap type: expected " + heapType.toString() +
               " but found " + child->type.toString());
  }
}

} // namespace wasm
