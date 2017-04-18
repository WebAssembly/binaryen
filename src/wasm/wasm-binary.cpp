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

#include "wasm-binary.h"

#include <fstream>
#include "support/bits.h"

namespace wasm {

void WasmBinaryWriter::prepare() {
  // we need function types for all our functions
  for (auto& func : wasm->functions) {
    if (func->type.isNull()) {
      func->type = ensureFunctionType(getSig(func.get()), wasm)->name;
    }
    // TODO: depending on upstream flux https://github.com/WebAssembly/spec/pull/301 might want this: assert(!func->type.isNull());
  }
}

void WasmBinaryWriter::write() {
  writeHeader();
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
  if (sourceMap) writeSourceMapUrl();
  if (symbolMap.size() > 0) writeSymbolMap();

  if (sourceMap) {
    writeSourceMapEpilog();
  }
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

void WasmBinaryWriter::writeResizableLimits(Address initial, Address maximum, bool hasMaximum) {
  uint32_t flags = hasMaximum ? 1 : 0;
  o << U32LEB(flags);
  o << U32LEB(initial);
  if (hasMaximum) {
    o << U32LEB(maximum);
  }
}

int32_t WasmBinaryWriter::startSection(BinaryConsts::Section code) {
  o << U32LEB(code);
  return writeU32LEBPlaceholder(); // section size to be filled in later
}

void WasmBinaryWriter::finishSection(int32_t start) {
  int32_t size = o.size() - start - 5; // section size does not include the 5 bytes of the size field itself
  o.writeAt(start, U32LEB(size));
}

int32_t WasmBinaryWriter::startSubsection(BinaryConsts::UserSections::Subsection code) {
  o << U32LEB(code);
  return writeU32LEBPlaceholder(); // section size to be filled in later
}

void WasmBinaryWriter::finishSubsection(int32_t start) {
  int32_t size = o.size() - start - 5; // section size does not include the 5 bytes of the size field itself
  o.writeAt(start, U32LEB(size));
}

void WasmBinaryWriter::writeStart() {
  if (!wasm->start.is()) return;
  if (debug) std::cerr << "== writeStart" << std::endl;
  auto start = startSection(BinaryConsts::Section::Start);
  o << U32LEB(getFunctionIndex(wasm->start.str));
  finishSection(start);
}

void WasmBinaryWriter::writeMemory() {
  if (!wasm->memory.exists || wasm->memory.imported) return;
  if (debug) std::cerr << "== writeMemory" << std::endl;
  auto start = startSection(BinaryConsts::Section::Memory);
  o << U32LEB(1); // Define 1 memory
  writeResizableLimits(wasm->memory.initial, wasm->memory.max, wasm->memory.max != Memory::kMaxSize);
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
      o << binaryWasmType(param);
    }
    if (type->result == none) {
      o << U32LEB(0);
    } else {
      o << U32LEB(1);
      o << binaryWasmType(type->result);
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
  if (wasm->imports.size() == 0) return;
  if (debug) std::cerr << "== writeImports" << std::endl;
  auto start = startSection(BinaryConsts::Section::Import);
  o << U32LEB(wasm->imports.size());
  for (auto& import : wasm->imports) {
    if (debug) std::cerr << "write one" << std::endl;
    writeInlineString(import->module.str);
    writeInlineString(import->base.str);
    o << U32LEB(int32_t(import->kind));
    switch (import->kind) {
      case ExternalKind::Function: o << U32LEB(getFunctionTypeIndex(import->functionType)); break;
      case ExternalKind::Table: {
        o << S32LEB(BinaryConsts::EncodedType::AnyFunc);
        writeResizableLimits(wasm->table.initial, wasm->table.max, wasm->table.max != Table::kMaxSize);
        break;
      }
      case ExternalKind::Memory: {
        writeResizableLimits(wasm->memory.initial, wasm->memory.max, wasm->memory.max != Memory::kMaxSize);
        break;
      }
      case ExternalKind::Global:
        o << binaryWasmType(import->globalType);
        o << U32LEB(0); // Mutable global's can't be imported for now.
        break;
      default: WASM_UNREACHABLE();
    }
  }
  finishSection(start);
}

void WasmBinaryWriter::mapLocals(Function* function) {
  for (Index i = 0; i < function->getNumParams(); i++) {
    size_t curr = mappedLocals.size();
    mappedLocals[i] = curr;
  }
  for (auto type : function->vars) {
    numLocalsByType[type]++;
  }
  std::map<WasmType, size_t> currLocalsByType;
  for (Index i = function->getVarIndexBase(); i < function->getNumLocals(); i++) {
    size_t index = function->getVarIndexBase();
    WasmType type = function->getLocalType(i);
    currLocalsByType[type]++; // increment now for simplicity, must decrement it in returns
    if (type == i32) {
      mappedLocals[i] = index + currLocalsByType[i32] - 1;
      continue;
    }
    index += numLocalsByType[i32];
    if (type == i64) {
      mappedLocals[i] = index + currLocalsByType[i64] - 1;
      continue;
    }
    index += numLocalsByType[i64];
    if (type == f32) {
      mappedLocals[i] = index + currLocalsByType[f32] - 1;
      continue;
    }
    index += numLocalsByType[f32];
    if (type == f64) {
      mappedLocals[i] = index + currLocalsByType[f64] - 1;
      continue;
    }
    abort();
  }
}

void WasmBinaryWriter::writeFunctionSignatures() {
  if (wasm->functions.size() == 0) return;
  if (debug) std::cerr << "== writeFunctionSignatures" << std::endl;
  auto start = startSection(BinaryConsts::Section::Function);
  o << U32LEB(wasm->functions.size());
  for (auto& curr : wasm->functions) {
    if (debug) std::cerr << "write one" << std::endl;
    o << U32LEB(getFunctionTypeIndex(curr->type));
  }
  finishSection(start);
}

void WasmBinaryWriter::writeExpression(Expression* curr) {
  assert(depth == 0);
  recurse(curr);
  assert(depth == 0);
}

void WasmBinaryWriter::writeFunctions() {
  if (wasm->functions.size() == 0) return;
  if (debug) std::cerr << "== writeFunctions" << std::endl;
  auto start = startSection(BinaryConsts::Section::Code);
  size_t total = wasm->functions.size();
  o << U32LEB(total);
  for (size_t i = 0; i < total; i++) {
    if (debug) std::cerr << "write one at" << o.size() << std::endl;
    size_t sizePos = writeU32LEBPlaceholder();
    size_t start = o.size();
    Function* function = wasm->functions[i].get();
    currFunction = function;
    mappedLocals.clear();
    numLocalsByType.clear();
    if (debug) std::cerr << "writing" << function->name << std::endl;
    mapLocals(function);
    o << U32LEB(
        (numLocalsByType[i32] ? 1 : 0) +
        (numLocalsByType[i64] ? 1 : 0) +
        (numLocalsByType[f32] ? 1 : 0) +
        (numLocalsByType[f64] ? 1 : 0)
                );
    if (numLocalsByType[i32]) o << U32LEB(numLocalsByType[i32]) << binaryWasmType(i32);
    if (numLocalsByType[i64]) o << U32LEB(numLocalsByType[i64]) << binaryWasmType(i64);
    if (numLocalsByType[f32]) o << U32LEB(numLocalsByType[f32]) << binaryWasmType(f32);
    if (numLocalsByType[f64]) o << U32LEB(numLocalsByType[f64]) << binaryWasmType(f64);

    writeExpression(function->body);
    o << int8_t(BinaryConsts::End);
    size_t size = o.size() - start;
    assert(size <= std::numeric_limits<uint32_t>::max());
    if (debug) std::cerr << "body size: " << size << ", writing at " << sizePos << ", next starts at " << o.size() << std::endl;
    o.writeAt(sizePos, U32LEB(size));
  }
  currFunction = nullptr;
  finishSection(start);
}

void WasmBinaryWriter::writeGlobals() {
  if (wasm->globals.size() == 0) return;
  if (debug) std::cerr << "== writeglobals" << std::endl;
  auto start = startSection(BinaryConsts::Section::Global);
  o << U32LEB(wasm->globals.size());
  for (auto& curr : wasm->globals) {
    if (debug) std::cerr << "write one" << std::endl;
    o << binaryWasmType(curr->type);
    o << U32LEB(curr->mutable_);
    writeExpression(curr->init);
    o << int8_t(BinaryConsts::End);
  }
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

void WasmBinaryWriter::writeDataSegments() {
  if (wasm->memory.segments.size() == 0) return;
  uint32_t num = 0;
  for (auto& segment : wasm->memory.segments) {
    if (segment.data.size() > 0) num++;
  }
  auto start = startSection(BinaryConsts::Section::Data);
  o << U32LEB(num);
  for (auto& segment : wasm->memory.segments) {
    if (segment.data.size() == 0) continue;
    o << U32LEB(0); // Linear memory 0 in the MVP
    writeExpression(segment.offset);
    o << int8_t(BinaryConsts::End);
    writeInlineBuffer(&segment.data[0], segment.data.size());
  }
  finishSection(start);
}

uint32_t WasmBinaryWriter::getFunctionIndex(Name name) {
  if (!mappedFunctions.size()) {
    // Create name => index mapping.
    for (auto& import : wasm->imports) {
      if (import->kind != ExternalKind::Function) continue;
      assert(mappedFunctions.count(import->name) == 0);
      auto index = mappedFunctions.size();
      mappedFunctions[import->name] = index;
    }
    for (size_t i = 0; i < wasm->functions.size(); i++) {
      assert(mappedFunctions.count(wasm->functions[i]->name) == 0);
      auto index = mappedFunctions.size();
      mappedFunctions[wasm->functions[i]->name] = index;
    }
  }
  assert(mappedFunctions.count(name));
  return mappedFunctions[name];
}

uint32_t WasmBinaryWriter::getGlobalIndex(Name name) {
  if (!mappedGlobals.size()) {
    // Create name => index mapping.
    for (auto& import : wasm->imports) {
      if (import->kind != ExternalKind::Global) continue;
      assert(mappedGlobals.count(import->name) == 0);
      auto index = mappedGlobals.size();
      mappedGlobals[import->name] = index;
    }
    for (size_t i = 0; i < wasm->globals.size(); i++) {
      assert(mappedGlobals.count(wasm->globals[i]->name) == 0);
      auto index = mappedGlobals.size();
      mappedGlobals[wasm->globals[i]->name] = index;
    }
  }
  assert(mappedGlobals.count(name));
  return mappedGlobals[name];
}

void WasmBinaryWriter::writeFunctionTableDeclaration() {
  if (!wasm->table.exists || wasm->table.imported) return;
  if (debug) std::cerr << "== writeFunctionTableDeclaration" << std::endl;
  auto start = startSection(BinaryConsts::Section::Table);
  o << U32LEB(1); // Declare 1 table.
  o << S32LEB(BinaryConsts::EncodedType::AnyFunc);
  writeResizableLimits(wasm->table.initial, wasm->table.max, wasm->table.max != Table::kMaxSize);
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
  } else {
    for (auto& import : wasm->imports) {
      if (import->kind == ExternalKind::Function) {
        hasContents = true;
        getFunctionIndex(import->name); // generate mappedFunctions
        break;
      }
    }
  }
  if (!hasContents) return;
  if (debug) std::cerr << "== writeNames" << std::endl;
  auto start = startSection(BinaryConsts::Section::User);
  writeInlineString(BinaryConsts::UserSections::Name);
  auto substart = startSubsection(BinaryConsts::UserSections::Subsection::NameFunction);
  o << U32LEB(mappedFunctions.size());
  Index emitted = 0;
  for (auto& import : wasm->imports) {
    if (import->kind == ExternalKind::Function) {
      o << U32LEB(emitted);
      writeInlineString(import->name.str);
      emitted++;
    }
  }
  for (auto& curr : wasm->functions) {
    o << U32LEB(emitted);
    writeInlineString(curr->name.str);
    emitted++;
  }
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
  for (auto& import : wasm->imports) {
    if (import->kind == ExternalKind::Function) {
      file << getFunctionIndex(import->name) << ":" << import->name.str << std::endl;
    }
  }
  for (auto& func : wasm->functions) {
    file << getFunctionIndex(func->name) << ":" << func->name.str << std::endl;
  }
  file.close();
}

void WasmBinaryWriter::writeSourceMapProlog() {
  lastDebugLocation = { 0, /* lineNumber = */ 1, 0 };
  lastBytecodeOffset = 0;
  *sourceMap << "{\"version\":3,\"sources\":[";
  for (size_t i = 0; i < wasm->debugInfoFileNames.size(); i++) {
    if (i > 0) *sourceMap << ",";
    // TODO respect JSON string encoding, e.g. quotes and control chars.
    *sourceMap << "\"" << wasm->debugInfoFileNames[i] << "\"";
  }
  *sourceMap << "],\"names\":[],\"mappings\":\"";
}

void WasmBinaryWriter::writeSourceMapEpilog() {
  *sourceMap << "\"}";
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

void WasmBinaryWriter::writeDebugLocation(size_t offset, const Function::DebugLocation& loc) {
  if (lastBytecodeOffset > 0) {
    *sourceMap << ",";
  }
  writeBase64VLQ(*sourceMap, int32_t(offset - lastBytecodeOffset));
  writeBase64VLQ(*sourceMap, int32_t(loc.fileIndex - lastDebugLocation.fileIndex));
  writeBase64VLQ(*sourceMap, int32_t(loc.lineNumber - lastDebugLocation.lineNumber));
  writeBase64VLQ(*sourceMap, int32_t(loc.columnNumber - lastDebugLocation.columnNumber));
  lastDebugLocation = loc;
  lastBytecodeOffset = offset;
}

void WasmBinaryWriter::writeInlineString(const char* name) {
  int32_t size = strlen(name);
  o << U32LEB(size);
  for (int32_t i = 0; i < size; i++) {
    o << int8_t(name[i]);
  }
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

void WasmBinaryWriter::recurse(Expression*& curr) {
  if (debug) std::cerr << "zz recurse into " << ++depth << " at " << o.size() << std::endl;
  visit(curr);
  if (debug) std::cerr << "zz recurse from " << depth-- << " at " << o.size() << std::endl;
}

static bool brokenTo(Block* block) {
  return block->name.is() && BreakSeeker::has(block, block->name);
}

void WasmBinaryWriter::visitBlock(Block *curr) {
  if (debug) std::cerr << "zz node: Block" << std::endl;
  o << int8_t(BinaryConsts::Block);
  o << binaryWasmType(curr->type != unreachable ? curr->type : none);
  breakStack.push_back(curr->name);
  Index i = 0;
  for (auto* child : curr->list) {
    if (debug) std::cerr << "  " << size_t(curr) << "\n zz Block element " << i++ << std::endl;
    recurse(child);
  }
  breakStack.pop_back();
  if (curr->type == unreachable) {
    // an unreachable block is one that cannot be exited. We cannot encode this directly
    // in wasm, where blocks must be none,i32,i64,f32,f64. Since the block cannot be
    // exited, we can emit an unreachable at the end, and that will always be valid,
    // and then the block is ok as a none
    o << int8_t(BinaryConsts::Unreachable);
  }
  o << int8_t(BinaryConsts::End);
  if (curr->type == unreachable) {
    // and emit an unreachable *outside* the block too, so later things can pop anything
    o << int8_t(BinaryConsts::Unreachable);
  }
}

// emits a node, but if it is a block with no name, emit a list of its contents
void WasmBinaryWriter::recursePossibleBlockContents(Expression* curr) {
  auto* block = curr->dynCast<Block>();
  if (!block || brokenTo(block)) {
    recurse(curr);
    return;
  }
  for (auto* child : block->list) {
    recurse(child);
  }
}

void WasmBinaryWriter::visitIf(If *curr) {
  if (debug) std::cerr << "zz node: If" << std::endl;
  if (curr->condition->type == unreachable) {
    // this if-else is unreachable because of the condition, i.e., the condition
    // does not exit. So don't emit the if, but do consume the condition
    recurse(curr->condition);
    o << int8_t(BinaryConsts::Unreachable);
    return;
  }
  recurse(curr->condition);
  o << int8_t(BinaryConsts::If);
  o << binaryWasmType(curr->type != unreachable ? curr->type : none);
  breakStack.push_back(IMPOSSIBLE_CONTINUE); // the binary format requires this; we have a block if we need one; TODO: optimize
  recursePossibleBlockContents(curr->ifTrue); // TODO: emit block contents directly, if possible
  breakStack.pop_back();
  if (curr->ifFalse) {
    o << int8_t(BinaryConsts::Else);
    breakStack.push_back(IMPOSSIBLE_CONTINUE); // TODO ditto
    recursePossibleBlockContents(curr->ifFalse);
    breakStack.pop_back();
  }
  o << int8_t(BinaryConsts::End);
  if (curr->type == unreachable) {
    // we already handled the case of the condition being unreachable. otherwise,
    // we may still be unreachable, if we are an if-else with both sides unreachable.
    // wasm does not allow this to be emitted directly, so we must do something more. we could do
    // better, but for now we emit an extra unreachable instruction after the if, so it is not consumed itself,
    assert(curr->ifFalse);
    o << int8_t(BinaryConsts::Unreachable);
  }
}
void WasmBinaryWriter::visitLoop(Loop *curr) {
  if (debug) std::cerr << "zz node: Loop" << std::endl;
  o << int8_t(BinaryConsts::Loop);
  o << binaryWasmType(curr->type != unreachable ? curr->type : none);
  breakStack.push_back(curr->name);
  recursePossibleBlockContents(curr->body);
  breakStack.pop_back();
  o << int8_t(BinaryConsts::End);
  if (curr->type == unreachable) {
    // we emitted a loop without a return type, so it must not be consumed
    o << int8_t(BinaryConsts::Unreachable);
  }
}

int32_t WasmBinaryWriter::getBreakIndex(Name name) { // -1 if not found
  for (int i = breakStack.size() - 1; i >= 0; i--) {
    if (breakStack[i] == name) {
      return breakStack.size() - 1 - i;
    }
  }
  std::cerr << "bad break: " << name << std::endl;
  abort();
}

void WasmBinaryWriter::visitBreak(Break *curr) {
  if (debug) std::cerr << "zz node: Break" << std::endl;
  if (curr->value) {
    recurse(curr->value);
  }
  if (curr->condition) recurse(curr->condition);
  o << int8_t(curr->condition ? BinaryConsts::BrIf : BinaryConsts::Br)
    << U32LEB(getBreakIndex(curr->name));
}

void WasmBinaryWriter::visitSwitch(Switch *curr) {
  if (debug) std::cerr << "zz node: Switch" << std::endl;
  if (curr->value) {
    recurse(curr->value);
  }
  recurse(curr->condition);
  o << int8_t(BinaryConsts::TableSwitch) << U32LEB(curr->targets.size());
  for (auto target : curr->targets) {
    o << U32LEB(getBreakIndex(target));
  }
  o << U32LEB(getBreakIndex(curr->default_));
}

void WasmBinaryWriter::visitCall(Call *curr) {
  if (debug) std::cerr << "zz node: Call" << std::endl;
  for (auto* operand : curr->operands) {
    recurse(operand);
  }
  o << int8_t(BinaryConsts::CallFunction) << U32LEB(getFunctionIndex(curr->target));
}

void WasmBinaryWriter::visitCallImport(CallImport *curr) {
  if (debug) std::cerr << "zz node: CallImport" << std::endl;
  for (auto* operand : curr->operands) {
    recurse(operand);
  }
  o << int8_t(BinaryConsts::CallFunction) << U32LEB(getFunctionIndex(curr->target));
}

void WasmBinaryWriter::visitCallIndirect(CallIndirect *curr) {
  if (debug) std::cerr << "zz node: CallIndirect" << std::endl;

  for (auto* operand : curr->operands) {
    recurse(operand);
  }
  recurse(curr->target);
  o << int8_t(BinaryConsts::CallIndirect)
    << U32LEB(getFunctionTypeIndex(curr->fullType))
    << U32LEB(0); // Reserved flags field
}

void WasmBinaryWriter::visitGetLocal(GetLocal *curr) {
  if (debug) std::cerr << "zz node: GetLocal " << (o.size() + 1) << std::endl;
  o << int8_t(BinaryConsts::GetLocal) << U32LEB(mappedLocals[curr->index]);
}

void WasmBinaryWriter::visitSetLocal(SetLocal *curr) {
  if (debug) std::cerr << "zz node: Set|TeeLocal" << std::endl;
  recurse(curr->value);
  o << int8_t(curr->isTee() ? BinaryConsts::TeeLocal : BinaryConsts::SetLocal) << U32LEB(mappedLocals[curr->index]);
}

void WasmBinaryWriter::visitGetGlobal(GetGlobal *curr) {
  if (curr->name.is()) {
    if (debug) std::cerr << "zz node: GetGlobal " << (o.size() + 1) << " curr->name=" << curr->name.str << std::endl;
    o << int8_t(BinaryConsts::GetGlobal) << U32LEB(getGlobalIndex(curr->name));
  } else {
    if (debug) std::cerr << "zz node: GetGlobal curr->name.str is null" << std::endl;
    return;
  }
}

void WasmBinaryWriter::visitSetGlobal(SetGlobal *curr) {
  if (debug) std::cerr << "zz node: SetGlobal" << std::endl;
  recurse(curr->value);
  o << int8_t(BinaryConsts::SetGlobal) << U32LEB(getGlobalIndex(curr->name));
}

void WasmBinaryWriter::emitMemoryAccess(size_t alignment, size_t bytes, uint32_t offset) {
  o << U32LEB(Log2(alignment ? alignment : bytes));
  o << U32LEB(offset);
}

void WasmBinaryWriter::visitLoad(Load *curr) {
  if (debug) std::cerr << "zz node: Load" << std::endl;
  recurse(curr->ptr);
  switch (curr->type) {
    case i32: {
      switch (curr->bytes) {
        case 1: o << int8_t(curr->signed_ ? BinaryConsts::I32LoadMem8S : BinaryConsts::I32LoadMem8U); break;
        case 2: o << int8_t(curr->signed_ ? BinaryConsts::I32LoadMem16S : BinaryConsts::I32LoadMem16U); break;
        case 4: o << int8_t(BinaryConsts::I32LoadMem); break;
        default: abort();
      }
      break;
    }
    case i64: {
      switch (curr->bytes) {
        case 1: o << int8_t(curr->signed_ ? BinaryConsts::I64LoadMem8S : BinaryConsts::I64LoadMem8U); break;
        case 2: o << int8_t(curr->signed_ ? BinaryConsts::I64LoadMem16S : BinaryConsts::I64LoadMem16U); break;
        case 4: o << int8_t(curr->signed_ ? BinaryConsts::I64LoadMem32S : BinaryConsts::I64LoadMem32U); break;
        case 8: o << int8_t(BinaryConsts::I64LoadMem); break;
        default: abort();
      }
      break;
    }
    case f32: o << int8_t(BinaryConsts::F32LoadMem); break;
    case f64: o << int8_t(BinaryConsts::F64LoadMem); break;
    case unreachable: return; // the pointer is unreachable, so we are never reached; just don't emit a load
    default: WASM_UNREACHABLE();
  }
  emitMemoryAccess(curr->align, curr->bytes, curr->offset);
}

void WasmBinaryWriter::visitStore(Store *curr) {
  if (debug) std::cerr << "zz node: Store" << std::endl;
  recurse(curr->ptr);
  recurse(curr->value);
  switch (curr->valueType) {
    case i32: {
      switch (curr->bytes) {
        case 1: o << int8_t(BinaryConsts::I32StoreMem8); break;
        case 2: o << int8_t(BinaryConsts::I32StoreMem16); break;
        case 4: o << int8_t(BinaryConsts::I32StoreMem); break;
        default: abort();
      }
      break;
    }
    case i64: {
      switch (curr->bytes) {
        case 1: o << int8_t(BinaryConsts::I64StoreMem8); break;
        case 2: o << int8_t(BinaryConsts::I64StoreMem16); break;
        case 4: o << int8_t(BinaryConsts::I64StoreMem32); break;
        case 8: o << int8_t(BinaryConsts::I64StoreMem); break;
        default: abort();
      }
      break;
    }
    case f32: o << int8_t(BinaryConsts::F32StoreMem); break;
    case f64: o << int8_t(BinaryConsts::F64StoreMem); break;
    default: abort();
  }
  emitMemoryAccess(curr->align, curr->bytes, curr->offset);
}

void WasmBinaryWriter::visitConst(Const *curr) {
  if (debug) std::cerr << "zz node: Const" << curr << " : " << curr->type << std::endl;
  switch (curr->type) {
    case i32: {
      o << int8_t(BinaryConsts::I32Const) << S32LEB(curr->value.geti32());
      break;
    }
    case i64: {
      o << int8_t(BinaryConsts::I64Const) << S64LEB(curr->value.geti64());
      break;
    }
    case f32: {
      o << int8_t(BinaryConsts::F32Const) << curr->value.reinterpreti32();
      break;
    }
    case f64: {
      o << int8_t(BinaryConsts::F64Const) << curr->value.reinterpreti64();
      break;
    }
    default: abort();
  }
  if (debug) std::cerr << "zz const node done.\n";
}

void WasmBinaryWriter::visitUnary(Unary *curr) {
  if (debug) std::cerr << "zz node: Unary" << std::endl;
  recurse(curr->value);
  switch (curr->op) {
    case ClzInt32:         o << int8_t(BinaryConsts::I32Clz); break;
    case CtzInt32:         o << int8_t(BinaryConsts::I32Ctz); break;
    case PopcntInt32:      o << int8_t(BinaryConsts::I32Popcnt); break;
    case EqZInt32:         o << int8_t(BinaryConsts::I32EqZ); break;
    case ClzInt64:         o << int8_t(BinaryConsts::I64Clz); break;
    case CtzInt64:         o << int8_t(BinaryConsts::I64Ctz); break;
    case PopcntInt64:      o << int8_t(BinaryConsts::I64Popcnt); break;
    case EqZInt64:         o << int8_t(BinaryConsts::I64EqZ); break;
    case NegFloat32:       o << int8_t(BinaryConsts::F32Neg); break;
    case AbsFloat32:       o << int8_t(BinaryConsts::F32Abs); break;
    case CeilFloat32:      o << int8_t(BinaryConsts::F32Ceil); break;
    case FloorFloat32:     o << int8_t(BinaryConsts::F32Floor); break;
    case TruncFloat32:     o << int8_t(BinaryConsts::F32Trunc); break;
    case NearestFloat32:   o << int8_t(BinaryConsts::F32NearestInt); break;
    case SqrtFloat32:      o << int8_t(BinaryConsts::F32Sqrt); break;
    case NegFloat64:       o << int8_t(BinaryConsts::F64Neg); break;
    case AbsFloat64:       o << int8_t(BinaryConsts::F64Abs); break;
    case CeilFloat64:      o << int8_t(BinaryConsts::F64Ceil); break;
    case FloorFloat64:     o << int8_t(BinaryConsts::F64Floor); break;
    case TruncFloat64:     o << int8_t(BinaryConsts::F64Trunc); break;
    case NearestFloat64:   o << int8_t(BinaryConsts::F64NearestInt); break;
    case SqrtFloat64:      o << int8_t(BinaryConsts::F64Sqrt); break;
    case ExtendSInt32:     o << int8_t(BinaryConsts::I64STruncI32); break;
    case ExtendUInt32:     o << int8_t(BinaryConsts::I64UTruncI32); break;
    case WrapInt64:        o << int8_t(BinaryConsts::I32ConvertI64); break;
    case TruncUFloat32ToInt32: o << int8_t(BinaryConsts::I32UTruncF32); break;
    case TruncUFloat32ToInt64: o << int8_t(BinaryConsts::I64UTruncF32); break;
    case TruncSFloat32ToInt32: o << int8_t(BinaryConsts::I32STruncF32); break;
    case TruncSFloat32ToInt64: o << int8_t(BinaryConsts::I64STruncF32); break;
    case TruncUFloat64ToInt32: o << int8_t(BinaryConsts::I32UTruncF64); break;
    case TruncUFloat64ToInt64: o << int8_t(BinaryConsts::I64UTruncF64); break;
    case TruncSFloat64ToInt32: o << int8_t(BinaryConsts::I32STruncF64); break;
    case TruncSFloat64ToInt64: o << int8_t(BinaryConsts::I64STruncF64); break;
    case ConvertUInt32ToFloat32: o << int8_t(BinaryConsts::F32UConvertI32); break;
    case ConvertUInt32ToFloat64: o << int8_t(BinaryConsts::F64UConvertI32); break;
    case ConvertSInt32ToFloat32: o << int8_t(BinaryConsts::F32SConvertI32); break;
    case ConvertSInt32ToFloat64: o << int8_t(BinaryConsts::F64SConvertI32); break;
    case ConvertUInt64ToFloat32: o << int8_t(BinaryConsts::F32UConvertI64); break;
    case ConvertUInt64ToFloat64: o << int8_t(BinaryConsts::F64UConvertI64); break;
    case ConvertSInt64ToFloat32: o << int8_t(BinaryConsts::F32SConvertI64); break;
    case ConvertSInt64ToFloat64: o << int8_t(BinaryConsts::F64SConvertI64); break;
    case DemoteFloat64:    o << int8_t(BinaryConsts::F32ConvertF64); break;
    case PromoteFloat32:   o << int8_t(BinaryConsts::F64ConvertF32); break;
    case ReinterpretFloat32: o << int8_t(BinaryConsts::I32ReinterpretF32); break;
    case ReinterpretFloat64: o << int8_t(BinaryConsts::I64ReinterpretF64); break;
    case ReinterpretInt32: o << int8_t(BinaryConsts::F32ReinterpretI32); break;
    case ReinterpretInt64: o << int8_t(BinaryConsts::F64ReinterpretI64); break;
    default: abort();
  }
}

void WasmBinaryWriter::visitBinary(Binary *curr) {
  if (debug) std::cerr << "zz node: Binary" << std::endl;
  recurse(curr->left);
  recurse(curr->right);

  switch (curr->op) {
    case AddInt32:      o << int8_t(BinaryConsts::I32Add);     break;
    case SubInt32:      o << int8_t(BinaryConsts::I32Sub);     break;
    case MulInt32:      o << int8_t(BinaryConsts::I32Mul);     break;
    case DivSInt32:     o << int8_t(BinaryConsts::I32DivS);   break;
    case DivUInt32:     o << int8_t(BinaryConsts::I32DivU);   break;
    case RemSInt32:     o << int8_t(BinaryConsts::I32RemS);   break;
    case RemUInt32:     o << int8_t(BinaryConsts::I32RemU);   break;
    case AndInt32:      o << int8_t(BinaryConsts::I32And);     break;
    case OrInt32:       o << int8_t(BinaryConsts::I32Or);      break;
    case XorInt32:      o << int8_t(BinaryConsts::I32Xor);     break;
    case ShlInt32:      o << int8_t(BinaryConsts::I32Shl);     break;
    case ShrUInt32:     o << int8_t(BinaryConsts::I32ShrU);   break;
    case ShrSInt32:     o << int8_t(BinaryConsts::I32ShrS);   break;
    case RotLInt32:     o << int8_t(BinaryConsts::I32RotL);    break;
    case RotRInt32:     o << int8_t(BinaryConsts::I32RotR);    break;
    case EqInt32:       o << int8_t(BinaryConsts::I32Eq);      break;
    case NeInt32:       o << int8_t(BinaryConsts::I32Ne);      break;
    case LtSInt32:      o << int8_t(BinaryConsts::I32LtS);    break;
    case LtUInt32:      o << int8_t(BinaryConsts::I32LtU);    break;
    case LeSInt32:      o << int8_t(BinaryConsts::I32LeS);    break;
    case LeUInt32:      o << int8_t(BinaryConsts::I32LeU);    break;
    case GtSInt32:      o << int8_t(BinaryConsts::I32GtS);    break;
    case GtUInt32:      o << int8_t(BinaryConsts::I32GtU);    break;
    case GeSInt32:      o << int8_t(BinaryConsts::I32GeS);    break;
    case GeUInt32:      o << int8_t(BinaryConsts::I32GeU);    break;

    case AddInt64:      o << int8_t(BinaryConsts::I64Add);     break;
    case SubInt64:      o << int8_t(BinaryConsts::I64Sub);     break;
    case MulInt64:      o << int8_t(BinaryConsts::I64Mul);     break;
    case DivSInt64:     o << int8_t(BinaryConsts::I64DivS);   break;
    case DivUInt64:     o << int8_t(BinaryConsts::I64DivU);   break;
    case RemSInt64:     o << int8_t(BinaryConsts::I64RemS);   break;
    case RemUInt64:     o << int8_t(BinaryConsts::I64RemU);   break;
    case AndInt64:      o << int8_t(BinaryConsts::I64And);     break;
    case OrInt64:       o << int8_t(BinaryConsts::I64Or);      break;
    case XorInt64:      o << int8_t(BinaryConsts::I64Xor);     break;
    case ShlInt64:      o << int8_t(BinaryConsts::I64Shl);     break;
    case ShrUInt64:     o << int8_t(BinaryConsts::I64ShrU);   break;
    case ShrSInt64:     o << int8_t(BinaryConsts::I64ShrS);   break;
    case RotLInt64:     o << int8_t(BinaryConsts::I64RotL);    break;
    case RotRInt64:     o << int8_t(BinaryConsts::I64RotR);    break;
    case EqInt64:       o << int8_t(BinaryConsts::I64Eq);      break;
    case NeInt64:       o << int8_t(BinaryConsts::I64Ne);      break;
    case LtSInt64:      o << int8_t(BinaryConsts::I64LtS);    break;
    case LtUInt64:      o << int8_t(BinaryConsts::I64LtU);    break;
    case LeSInt64:      o << int8_t(BinaryConsts::I64LeS);    break;
    case LeUInt64:      o << int8_t(BinaryConsts::I64LeU);    break;
    case GtSInt64:      o << int8_t(BinaryConsts::I64GtS);    break;
    case GtUInt64:      o << int8_t(BinaryConsts::I64GtU);    break;
    case GeSInt64:      o << int8_t(BinaryConsts::I64GeS);    break;
    case GeUInt64:      o << int8_t(BinaryConsts::I64GeU);    break;

    case AddFloat32:      o << int8_t(BinaryConsts::F32Add);     break;
    case SubFloat32:      o << int8_t(BinaryConsts::F32Sub);     break;
    case MulFloat32:      o << int8_t(BinaryConsts::F32Mul);     break;
    case DivFloat32:      o << int8_t(BinaryConsts::F32Div);     break;
    case CopySignFloat32: o << int8_t(BinaryConsts::F32CopySign);break;
    case MinFloat32:      o << int8_t(BinaryConsts::F32Min);     break;
    case MaxFloat32:      o << int8_t(BinaryConsts::F32Max);     break;
    case EqFloat32:       o << int8_t(BinaryConsts::F32Eq);      break;
    case NeFloat32:       o << int8_t(BinaryConsts::F32Ne);      break;
    case LtFloat32:       o << int8_t(BinaryConsts::F32Lt);      break;
    case LeFloat32:       o << int8_t(BinaryConsts::F32Le);      break;
    case GtFloat32:       o << int8_t(BinaryConsts::F32Gt);      break;
    case GeFloat32:       o << int8_t(BinaryConsts::F32Ge);      break;

    case AddFloat64:      o << int8_t(BinaryConsts::F64Add);     break;
    case SubFloat64:      o << int8_t(BinaryConsts::F64Sub);     break;
    case MulFloat64:      o << int8_t(BinaryConsts::F64Mul);     break;
    case DivFloat64:      o << int8_t(BinaryConsts::F64Div);     break;
    case CopySignFloat64: o << int8_t(BinaryConsts::F64CopySign);break;
    case MinFloat64:      o << int8_t(BinaryConsts::F64Min);     break;
    case MaxFloat64:      o << int8_t(BinaryConsts::F64Max);     break;
    case EqFloat64:       o << int8_t(BinaryConsts::F64Eq);      break;
    case NeFloat64:       o << int8_t(BinaryConsts::F64Ne);      break;
    case LtFloat64:       o << int8_t(BinaryConsts::F64Lt);      break;
    case LeFloat64:       o << int8_t(BinaryConsts::F64Le);      break;
    case GtFloat64:       o << int8_t(BinaryConsts::F64Gt);      break;
    case GeFloat64:       o << int8_t(BinaryConsts::F64Ge);      break;
    default: abort();
  }
}

void WasmBinaryWriter::visitSelect(Select *curr) {
  if (debug) std::cerr << "zz node: Select" << std::endl;
  recurse(curr->ifTrue);
  recurse(curr->ifFalse);
  recurse(curr->condition);
  o << int8_t(BinaryConsts::Select);
}

void WasmBinaryWriter::visitReturn(Return *curr) {
  if (debug) std::cerr << "zz node: Return" << std::endl;
  if (curr->value) {
    recurse(curr->value);
  }
  o << int8_t(BinaryConsts::Return);
}

void WasmBinaryWriter::visitHost(Host *curr) {
  if (debug) std::cerr << "zz node: Host" << std::endl;
  switch (curr->op) {
    case CurrentMemory: {
      o << int8_t(BinaryConsts::CurrentMemory);
      break;
    }
    case GrowMemory: {
      recurse(curr->operands[0]);
      o << int8_t(BinaryConsts::GrowMemory);
      break;
    }
    default: abort();
  }
  o << U32LEB(0); // Reserved flags field
}

void WasmBinaryWriter::visitNop(Nop *curr) {
  if (debug) std::cerr << "zz node: Nop" << std::endl;
  o << int8_t(BinaryConsts::Nop);
}

void WasmBinaryWriter::visitUnreachable(Unreachable *curr) {
  if (debug) std::cerr << "zz node: Unreachable" << std::endl;
  o << int8_t(BinaryConsts::Unreachable);
}

void WasmBinaryWriter::visitDrop(Drop *curr) {
  if (debug) std::cerr << "zz node: Drop" << std::endl;
  recurse(curr->value);
  o << int8_t(BinaryConsts::Drop);
}

// reader

static Name RETURN_BREAK("binaryen|break-to-return");

void WasmBinaryBuilder::read() {

  readHeader();
  readSourceMapHeader();

  // read sections until the end
  while (more()) {
    uint32_t sectionCode = getU32LEB();
    uint32_t payloadLen = getU32LEB();
    if (pos + payloadLen > input.size()) throw ParseException("Section extends beyond end of input");

    auto oldPos = pos;

    // note the section in the list of seen sections, as almost no sections can appear more than once,
    // and verify those that shouldn't do not.
    if (sectionCode != BinaryConsts::Section::User && sectionCode != BinaryConsts::Section::Code) {
      if (!seenSections.insert(BinaryConsts::Section(sectionCode)).second) {
        throw ParseException("section seen more than once: " + std::to_string(sectionCode));
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
          throw ParseException("bad user section size, started at " + std::to_string(oldPos) + " plus payload " + std::to_string(payloadLen) + " not being equal to new position " + std::to_string(pos));
        }
        pos = oldPos + payloadLen;
      }
    }

    // make sure we advanced exactly past this section
    if (pos != oldPos + payloadLen) {
      throw ParseException("bad section size, started at " + std::to_string(oldPos) + " plus payload " + std::to_string(payloadLen) + " not being equal to new position " + std::to_string(pos));
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
  if (!more()) throw ParseException("unexpected end of input");
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

WasmType WasmBinaryBuilder::getWasmType() {
  int type = getS32LEB();
  switch (type) {
    // None only used for block signatures. TODO: Separate out?
    case BinaryConsts::EncodedType::Empty: return none;
    case BinaryConsts::EncodedType::i32: return i32;
    case BinaryConsts::EncodedType::i64: return i64;
    case BinaryConsts::EncodedType::f32: return f32;
    case BinaryConsts::EncodedType::f64: return f64;
    default: throw ParseException("invalid wasm type: " + std::to_string(type));
  }
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
    str = str + char(getInt8());
  }
  if (debug) std::cerr << "getInlineString: " << str << " ==>" << std::endl;
  return Name(str);
}

void WasmBinaryBuilder::verifyInt8(int8_t x) {
  int8_t y = getInt8();
  if (x != y) throw ParseException("surprising value", 0, pos);
}

void WasmBinaryBuilder::verifyInt16(int16_t x) {
  int16_t y = getInt16();
  if (x != y) throw ParseException("surprising value", 0, pos);
}

void WasmBinaryBuilder::verifyInt32(int32_t x) {
  int32_t y = getInt32();
  if (x != y) throw ParseException("surprising value", 0, pos);
}

void WasmBinaryBuilder::verifyInt64(int64_t x) {
  int64_t y = getInt64();
  if (x != y) throw ParseException("surprising value", 0, pos);
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
    throw ParseException("Must be exactly 1 memory");
  }
  if (wasm.memory.exists) {
    throw ParseException("Memory cannot be both imported and defined");
  }
  wasm.memory.exists = true;
  getResizableLimits(wasm.memory.initial, wasm.memory.max, Memory::kMaxSize);
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
      throw ParseException("bad signature form " + std::to_string(form));
    }
    size_t numParams = getU32LEB();
    if (debug) std::cerr << "num params: " << numParams << std::endl;
    for (size_t j = 0; j < numParams; j++) {
      curr->params.push_back(getWasmType());
    }
    auto numResults = getU32LEB();
    if (numResults == 0) {
      curr->result = none;
    } else {
      if (numResults != 1) {
        throw ParseException("signature must have 1 result");
      }
      curr->result = getWasmType();
    }
    curr->name = Name::fromInt(wasm.functionTypes.size());
    wasm.addFunctionType(curr);
  }
}

Name WasmBinaryBuilder::getFunctionIndexName(Index i) {
  if (i < functionImportIndexes.size()) {
    auto* import = wasm.getImport(functionImportIndexes[i]);
    assert(import->kind == ExternalKind::Function);
    return import->name;
  } else {
    i -= functionImportIndexes.size();
    if (i >= wasm.functions.size()) {
      throw ParseException("bad function index");
    }
    return wasm.functions[i]->name;
  }
}

void WasmBinaryBuilder::getResizableLimits(Address& initial, Address& max, Address defaultIfNoMax) {
  auto flags = getU32LEB();
  initial = getU32LEB();
  bool hasMax = flags & 0x1;
  if (hasMax) max = getU32LEB();
  else max = defaultIfNoMax;
}

void WasmBinaryBuilder::readImports() {
  if (debug) std::cerr << "== readImports" << std::endl;
  size_t num = getU32LEB();
  if (debug) std::cerr << "num: " << num << std::endl;
  for (size_t i = 0; i < num; i++) {
    if (debug) std::cerr << "read one" << std::endl;
    auto curr = new Import;
    curr->name = Name(std::string("import$") + std::to_string(i));
    curr->module = getInlineString();
    curr->base = getInlineString();
    curr->kind = (ExternalKind)getU32LEB();
    switch (curr->kind) {
      case ExternalKind::Function: {
        auto index = getU32LEB();
        if (index >= wasm.functionTypes.size()) {
          throw ParseException("invalid function index " + std::to_string(index) + " / " + std::to_string(wasm.functionTypes.size()));
        }
        curr->functionType = wasm.functionTypes[index]->name;
        assert(curr->functionType.is());
        functionImportIndexes.push_back(curr->name);
        break;
      }
      case ExternalKind::Table: {
        auto elementType = getS32LEB();
        WASM_UNUSED(elementType);
        if (elementType != BinaryConsts::EncodedType::AnyFunc) throw ParseException("Imported table type is not AnyFunc");
        wasm.table.exists = true;
        wasm.table.imported = true;
        getResizableLimits(wasm.table.initial, wasm.table.max, Table::kMaxSize);
        break;
      }
      case ExternalKind::Memory: {
        wasm.memory.exists = true;
        wasm.memory.imported = true;
        getResizableLimits(wasm.memory.initial, wasm.memory.max, Memory::kMaxSize);
        break;
      }
      case ExternalKind::Global: {
        curr->globalType = getWasmType();
        auto globalMutable = getU32LEB();
        if (globalMutable) {
          throw ParseException("imported globals cannot be mutable");
        }
        break;
      }
      default: {
        throw ParseException("bad import kind");
      }
    }
    wasm.addImport(curr);
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
      throw ParseException("invalid function type index for function");
    }
    functionTypes.push_back(wasm.functionTypes[index].get());
  }
}

void WasmBinaryBuilder::readFunctions() {
  if (debug) std::cerr << "== readFunctions" << std::endl;
  size_t total = getU32LEB();
  if (total != functionTypes.size()) {
    throw ParseException("invalid function section size, must equal types");
  }
  for (size_t i = 0; i < total; i++) {
    if (debug) std::cerr << "read one at " << pos << std::endl;
    size_t size = getU32LEB();
    if (size == 0) {
      throw ParseException("empty function size");
    }
    endOfFunction = pos + size;
    auto type = functionTypes[i];
    if (debug) std::cerr << "reading " << i << std::endl;
    size_t nextVar = 0;
    auto addVar = [&]() {
      Name name = cashew::IString(("var$" + std::to_string(nextVar++)).c_str(), false);
      return name;
    };
    std::vector<NameType> params, vars;
    for (size_t j = 0; j < type->params.size(); j++) {
      params.emplace_back(addVar(), type->params[j]);
    }
    size_t numLocalTypes = getU32LEB();
    for (size_t t = 0; t < numLocalTypes; t++) {
      auto num = getU32LEB();
      auto type = getWasmType();
      while (num > 0) {
        vars.emplace_back(addVar(), type);
        num--;
      }
    }
    auto func = Builder(wasm).makeFunction(
        Name::fromInt(i),
        std::move(params),
        type->result,
        std::move(vars)
                                           );
    func->type = type->name;
    currFunction = func;
    {
      // process the function body
      if (debug) std::cerr << "processing function: " << i << std::endl;
      nextLabel = 0;
      useDebugLocation = false;
      breaksToReturn = false;
      // process body
      assert(breakStack.empty());
      breakStack.emplace_back(RETURN_BREAK, func->result != none); // the break target for the function scope
      assert(expressionStack.empty());
      assert(depth == 0);
      func->body = getMaybeBlock(func->result);
      assert(depth == 0);
      assert(breakStack.size() == 1);
      breakStack.pop_back();
      if (!expressionStack.empty()) {
        throw ParseException("stack not empty on function exit");
      }
      if (pos != endOfFunction) {
        throw ParseException("binary offset at function exit not at expected location");
      }
      if (breaksToReturn) {
        // we broke to return, so we need an outer block to break to
        func->body = Builder(wasm).blockifyWithName(func->body, RETURN_BREAK);
      }
    }
    currFunction = nullptr;
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
      throw ParseException("duplicate export name");
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
    char ch = in.get();
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

  auto maybeReadChar = [&](char expected) {
    if (sourceMap->peek() != expected) return false;
    sourceMap->get();
    return true;
  };
  auto mustReadChar = [&](char expected) {
    if (sourceMap->get() != expected) {
      throw MapParseException("Unexpected char");
    }
  };
  auto findField = [&](const char* name, size_t len) {
    bool matching = false;
    size_t pos;
    while (1) {
      int ch = sourceMap->get();
      if (ch == EOF) return false;
      if (ch == '\"') {
        matching = true;
        pos = 0;
      } else if (matching && name[pos] == ch) {
        ++pos;
        if (pos == len) {
          if (maybeReadChar('\"')) break; // found field
        }
      } else {
        matching = false;
      }
    }
    mustReadChar(':');
    return true;
  };
  auto readString = [&](std::string& str) {
    std::vector<char> vec;
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
    str = std::string(vec.begin(), vec.end());
  };

  if (!findField("sources", strlen("sources"))) {
    throw MapParseException("cannot find the sources field in map");
  }
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

  if (!findField("mappings", strlen("mappings"))) {
    throw MapParseException("cannot find the mappings field in map");
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

  char ch;
  *sourceMap >> ch;
  if (ch == '\"') { // end of records
    nextDebugLocation.first = 0;
    return;
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

Expression* WasmBinaryBuilder::readExpression() {
  assert(depth == 0);
  processExpressions();
  if (expressionStack.size() != 1) {
    throw ParseException("expected to read a single expression");
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
    auto curr = new Global;
    curr->type = getWasmType();
    auto mutable_ = getU32LEB();
    if (bool(mutable_) != mutable_) throw ParseException("Global mutability must be 0 or 1");
    curr->mutable_ = mutable_;
    curr->init = readExpression();
    curr->name = Name("global$" + std::to_string(wasm.globals.size()));
    wasm.addGlobal(curr);
  }
}

void WasmBinaryBuilder::processExpressions() { // until an end or else marker, or the end of the function
  while (1) {
    Expression* curr;
    auto ret = readExpression(curr);
    if (!curr) {
      lastSeparator = ret;
      return;
    }
    expressionStack.push_back(curr);
  }
}

Expression* WasmBinaryBuilder::popExpression() {
  if (expressionStack.empty()) {
    throw ParseException("attempted pop from empty stack");
  }
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
  auto type = block->list[0]->type;
  if (!currFunction) {
    throw ParseException("popping void outside of function, where we need a new local");
  }
  auto local = builder.addVar(currFunction, type);
  block->list[0] = builder.makeSetLocal(local, block->list[0]);
  block->list.push_back(builder.makeGetLocal(local, type));
  block->finalize();
  return block;
}

Name WasmBinaryBuilder::getGlobalName(Index index) {
  if (!mappedGlobals.size()) {
    // Create name => index mapping.
    for (auto& import : wasm.imports) {
      if (import->kind != ExternalKind::Global) continue;
      auto index = mappedGlobals.size();
      mappedGlobals[index] = import->name;
    }
    for (size_t i = 0; i < wasm.globals.size(); i++) {
      auto index = mappedGlobals.size();
      mappedGlobals[index] = wasm.globals[i]->name;
    }
  }
  if (index == Index(-1)) return Name("null"); // just a force-rebuild
  if (mappedGlobals.count(index) == 0) {
    throw ParseException("bad global index");
  }
  return mappedGlobals[index];
}

void WasmBinaryBuilder::processFunctions() {
  for (auto& func : functions) {
    wasm.addFunction(func);
  }

  // we should have seen all the functions
  // we assume this later down in fact, when we read wasm.functions[index],
  // as index was validated vs functionTypes.size()
  if (wasm.functions.size() != functionTypes.size()) {
    throw ParseException("did not see the right number of functions");
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
      default: throw ParseException("bad export kind");
    }
    wasm.addExport(curr);
  }

  for (auto& iter : functionCalls) {
    size_t index = iter.first;
    auto& calls = iter.second;
    for (auto* call : calls) {
      call->target = wasm.functions[index]->name;
    }
  }

  for (auto& pair : functionTable) {
    auto i = pair.first;
    auto& indexes = pair.second;
    for (auto j : indexes) {
      wasm.table.segments[i].data.push_back(getFunctionIndexName(j));
    }
  }
}

void WasmBinaryBuilder::readDataSegments() {
  if (debug) std::cerr << "== readDataSegments" << std::endl;
  auto num = getU32LEB();
  for (size_t i = 0; i < num; i++) {
    auto memoryIndex = getU32LEB();
    WASM_UNUSED(memoryIndex);
    if (memoryIndex != 0) {
      throw ParseException("bad memory index, must be 0");
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
  if (numTables != 1) throw ParseException("Only 1 table definition allowed in MVP");
  if (wasm.table.exists) throw ParseException("Table cannot be both imported and defined");
  wasm.table.exists = true;
  auto elemType = getS32LEB();
  if (elemType != BinaryConsts::EncodedType::AnyFunc) throw ParseException("ElementType must be AnyFunc in MVP");
  getResizableLimits(wasm.table.initial, wasm.table.max, Table::kMaxSize);
}

void WasmBinaryBuilder::readTableElements() {
  if (debug) std::cerr << "== readTableElements" << std::endl;
  auto numSegments = getU32LEB();
  if (numSegments >= Table::kMaxSize) throw ParseException("Too many segments");
  for (size_t i = 0; i < numSegments; i++) {
    auto tableIndex = getU32LEB();
    if (tableIndex != 0) throw ParseException("Table elements must refer to table 0 in MVP");
    wasm.table.segments.emplace_back(readExpression());

    auto& indexSegment = functionTable[i];
    auto size = getU32LEB();
    for (Index j = 0; j < size; j++) {
      indexSegment.push_back(getU32LEB());
    }
  }
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
    uint32_t importedFunctions = 0;
    for (auto& import : wasm.imports) {
      if (import->kind != ExternalKind::Function) continue;
      importedFunctions++;
    }
    for (size_t i = 0; i < num; i++) {
      auto index = getU32LEB();
      if (index < importedFunctions) {
        getInlineString(); // TODO: use this
      } else if (index - importedFunctions < functions.size()) {
        auto name = getInlineString();
        functions[index - importedFunctions]->name = name;
      }
    }
    // disallow duplicate names
    std::set<Name> functionNames;
    for (auto* func : functions) {
      if (!functionNames.insert(func->name).second) {
        throw ParseException("duplicate function name: " + std::string(func->name.str));
      }
    }
    if (pos != subsectionPos + subsectionSize) {
      throw ParseException("bad names subsection position change");
    }
  }
  if (pos != sectionPos + payloadLen) {
    throw ParseException("bad names section position change");
  }
}

BinaryConsts::ASTNodes WasmBinaryBuilder::readExpression(Expression*& curr) {
  if (pos == endOfFunction) {
    throw ParseException("Reached function end without seeing End opcode");
  }
  if (debug) std::cerr << "zz recurse into " << ++depth << " at " << pos << std::endl;
  if (nextDebugLocation.first) {
    while (nextDebugLocation.first && nextDebugLocation.first <= pos) {
      if (nextDebugLocation.first < pos) {
        std::cerr << "skipping debug location info for " << nextDebugLocation.first << std::endl;
      }
      debugLocation = nextDebugLocation.second;
      useDebugLocation = currFunction; // using only for function expressions
      readNextDebugLocation();
    }
  }
  uint8_t code = getInt8();
  if (debug) std::cerr << "readExpression seeing " << (int)code << std::endl;
  switch (code) {
    case BinaryConsts::Block:        visitBlock((curr = allocator.alloc<Block>())->cast<Block>()); break;
    case BinaryConsts::If:           visitIf((curr = allocator.alloc<If>())->cast<If>());  break;
    case BinaryConsts::Loop:         visitLoop((curr = allocator.alloc<Loop>())->cast<Loop>()); break;
    case BinaryConsts::Br:
    case BinaryConsts::BrIf:         visitBreak((curr = allocator.alloc<Break>())->cast<Break>(), code); break; // code distinguishes br from br_if
    case BinaryConsts::TableSwitch:  visitSwitch((curr = allocator.alloc<Switch>())->cast<Switch>()); break;
    case BinaryConsts::CallFunction: curr = visitCall(); break; // we don't know if it's a call or call_import yet
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
    default: {
      // otherwise, the code is a subcode TODO: optimize
      if (maybeVisitBinary(curr, code)) break;
      if (maybeVisitUnary(curr, code)) break;
      if (maybeVisitConst(curr, code)) break;
      if (maybeVisitLoad(curr, code)) break;
      if (maybeVisitStore(curr, code)) break;
      if (maybeVisitHost(curr, code)) break;
      throw ParseException("bad node code " + std::to_string(code));
    }
  }
  if (useDebugLocation && curr) {
    currFunction->debugLocations[curr] = debugLocation;
  }
  if (debug) std::cerr << "zz recurse from " << depth-- << " at " << pos << std::endl;
  return BinaryConsts::ASTNodes(code);
}

void WasmBinaryBuilder::visitBlock(Block *curr) {
  if (debug) std::cerr << "zz node: Block" << std::endl;
  // special-case Block and de-recurse nested blocks in their first position, as that is
  // a common pattern that can be very highly nested.
  std::vector<Block*> stack;
  while (1) {
    curr->type = getWasmType();
    curr->name = getNextLabel();
    breakStack.push_back({curr->name, curr->type != none});
    stack.push_back(curr);
    if (getInt8() == BinaryConsts::Block) {
      // a recursion
      curr = allocator.alloc<Block>();
      continue;
    } else {
      // end of recursion
      ungetInt8();
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
      throw ParseException("block cannot pop from outside");
    }
    for (size_t i = start; i < end; i++) {
      if (debug) std::cerr << "  " << size_t(expressionStack[i]) << "\n zz Block element " << curr->list.size() << std::endl;
      curr->list.push_back(expressionStack[i]);
    }
    expressionStack.resize(start);
    curr->finalize(curr->type);
    breakStack.pop_back();
  }
}

Expression* WasmBinaryBuilder::getMaybeBlock(WasmType type) {
  auto start = expressionStack.size();
  processExpressions();
  size_t end = expressionStack.size();
  if (start - end == 1) {
    return popExpression();
  }
  if (start > end) {
    throw ParseException("block cannot pop from outside");
  }
  auto* block = allocator.alloc<Block>();
  for (size_t i = start; i < end; i++) {
    block->list.push_back(expressionStack[i]);
  }
  block->finalize(type);
  expressionStack.resize(start);
  return block;
}

Expression* WasmBinaryBuilder::getBlock(WasmType type) {
  Name label = getNextLabel();
  breakStack.push_back({label, type != none && type != unreachable});
  auto* block = Builder(wasm).blockify(getMaybeBlock(type));
  breakStack.pop_back();
  block->cast<Block>()->name = label;
  return block;
}

void WasmBinaryBuilder::visitIf(If *curr) {
  if (debug) std::cerr << "zz node: If" << std::endl;
  curr->type = getWasmType();
  curr->condition = popNonVoidExpression();
  curr->ifTrue = getBlock(curr->type);
  if (lastSeparator == BinaryConsts::Else) {
    curr->ifFalse = getBlock(curr->type);
  }
  curr->finalize(curr->type);
  if (lastSeparator != BinaryConsts::End) {
    throw ParseException("if should end with End");
  }
}

void WasmBinaryBuilder::visitLoop(Loop *curr) {
  if (debug) std::cerr << "zz node: Loop" << std::endl;
  curr->type = getWasmType();
  curr->name = getNextLabel();
  breakStack.push_back({curr->name, 0});
  curr->body = getMaybeBlock(curr->type);
  breakStack.pop_back();
  curr->finalize(curr->type);
}

WasmBinaryBuilder::BreakTarget WasmBinaryBuilder::getBreakTarget(int32_t offset) {
  if (debug) std::cerr << "getBreakTarget " << offset << std::endl;
  size_t index = breakStack.size() - 1 - offset;
  if (index >= breakStack.size()) {
    throw ParseException("bad breakindex");
  }
  if (index == 0) {
    // trying to access the topmost element means we break out
    // to the function scope, doing in effect a return, we'll
    // need to create a block for that.
    breaksToReturn = true;
  }
  if (debug) std::cerr << "breaktarget "<< breakStack[index].name << " arity " << breakStack[index].arity <<  std::endl;
  return breakStack[index];
}

void WasmBinaryBuilder::visitBreak(Break *curr, uint8_t code) {
  if (debug) std::cerr << "zz node: Break, code "<< int32_t(code) << std::endl;
  BreakTarget target = getBreakTarget(getU32LEB());
  curr->name = target.name;
  if (code == BinaryConsts::BrIf) curr->condition = popNonVoidExpression();
  if (target.arity) curr->value = popNonVoidExpression();
  curr->finalize();
}

void WasmBinaryBuilder::visitSwitch(Switch *curr) {
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

Expression* WasmBinaryBuilder::visitCall() {
  if (debug) std::cerr << "zz node: Call" << std::endl;
  auto index = getU32LEB();
  FunctionType* type;
  Expression* ret;
  if (index < functionImportIndexes.size()) {
    // this is a call of an imported function
    auto* call = allocator.alloc<CallImport>();
    auto* import = wasm.getImport(functionImportIndexes[index]);
    call->target = import->name;
    type = wasm.getFunctionType(import->functionType);
    fillCall(call, type);
    call->finalize();
    ret = call;
  } else {
    // this is a call of a defined function
    auto* call = allocator.alloc<Call>();
    auto adjustedIndex = index - functionImportIndexes.size();
    if (adjustedIndex >= functionTypes.size()) {
      throw ParseException("bad call index");
    }
    type = functionTypes[adjustedIndex];
    fillCall(call, type);
    functionCalls[adjustedIndex].push_back(call); // we don't know function names yet
    call->finalize();
    ret = call;
  }
  return ret;
}

void WasmBinaryBuilder::visitCallIndirect(CallIndirect *curr) {
  if (debug) std::cerr << "zz node: CallIndirect" << std::endl;
  auto index = getU32LEB();
  if (index >= wasm.functionTypes.size()) {
    throw ParseException("bad call_indirect function index");
  }
  auto* fullType = wasm.functionTypes[index].get();
  auto reserved = getU32LEB();
  if (reserved != 0) throw ParseException("Invalid flags field in call_indirect");
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

void WasmBinaryBuilder::visitGetLocal(GetLocal *curr) {
  if (debug) std::cerr << "zz node: GetLocal " << pos << std::endl;
  if (!currFunction) {
    throw ParseException("get_local outside of function");
  }
  curr->index = getU32LEB();
  if (curr->index >= currFunction->getNumLocals()) {
    throw ParseException("bad get_local index");
  }
  curr->type = currFunction->getLocalType(curr->index);
  curr->finalize();
}

void WasmBinaryBuilder::visitSetLocal(SetLocal *curr, uint8_t code) {
  if (debug) std::cerr << "zz node: Set|TeeLocal" << std::endl;
  if (!currFunction) {
    throw ParseException("set_local outside of function");
  }
  curr->index = getU32LEB();
  if (curr->index >= currFunction->getNumLocals()) {
    throw ParseException("bad set_local index");
  }
  curr->value = popNonVoidExpression();
  curr->type = curr->value->type;
  curr->setTee(code == BinaryConsts::TeeLocal);
  curr->finalize();
}

void WasmBinaryBuilder::visitGetGlobal(GetGlobal *curr) {
  if (debug) std::cerr << "zz node: GetGlobal " << pos << std::endl;
  auto index = getU32LEB();
  curr->name = getGlobalName(index);
  auto* global = wasm.getGlobalOrNull(curr->name);
  if (global) {
    curr->type = global->type;
    return;
  }
  auto* import = wasm.getImportOrNull(curr->name);
  if (import && import->kind == ExternalKind::Global) {
    curr->type = import->globalType;
    return;
  }
  throw ParseException("bad get_global");
}

void WasmBinaryBuilder::visitSetGlobal(SetGlobal *curr) {
  if (debug) std::cerr << "zz node: SetGlobal" << std::endl;
  auto index = getU32LEB();
  curr->name = getGlobalName(index);
  curr->value = popNonVoidExpression();
  curr->finalize();
}

void WasmBinaryBuilder::readMemoryAccess(Address& alignment, size_t bytes, Address& offset) {
  alignment = Pow2(getU32LEB());
  offset = getU32LEB();
}

bool WasmBinaryBuilder::maybeVisitLoad(Expression*& out, uint8_t code) {
  Load* curr;
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
  readMemoryAccess(curr->align, curr->bytes, curr->offset);
  curr->ptr = popNonVoidExpression();
  curr->finalize();
  out = curr;
  return true;
}

bool WasmBinaryBuilder::maybeVisitStore(Expression*& out, uint8_t code) {
  Store* curr;
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
  if (debug) std::cerr << "zz node: Store" << std::endl;
  readMemoryAccess(curr->align, curr->bytes, curr->offset);
  curr->value = popNonVoidExpression();
  curr->ptr = popNonVoidExpression();
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
    case BinaryConsts::I32Clz:         curr = allocator.alloc<Unary>(); curr->op = ClzInt32;      curr->type = i32; break;
    case BinaryConsts::I64Clz:         curr = allocator.alloc<Unary>(); curr->op = ClzInt64;      curr->type = i64; break;
    case BinaryConsts::I32Ctz:         curr = allocator.alloc<Unary>(); curr->op = CtzInt32;      curr->type = i32; break;
    case BinaryConsts::I64Ctz:         curr = allocator.alloc<Unary>(); curr->op = CtzInt64;      curr->type = i64; break;
    case BinaryConsts::I32Popcnt:      curr = allocator.alloc<Unary>(); curr->op = PopcntInt32;   curr->type = i32; break;
    case BinaryConsts::I64Popcnt:      curr = allocator.alloc<Unary>(); curr->op = PopcntInt64;   curr->type = i64; break;
    case BinaryConsts::I32EqZ:         curr = allocator.alloc<Unary>(); curr->op = EqZInt32;      curr->type = i32; break;
    case BinaryConsts::I64EqZ:         curr = allocator.alloc<Unary>(); curr->op = EqZInt64;      curr->type = i32; break;
    case BinaryConsts::F32Neg:         curr = allocator.alloc<Unary>(); curr->op = NegFloat32;    curr->type = f32; break;
    case BinaryConsts::F64Neg:         curr = allocator.alloc<Unary>(); curr->op = NegFloat64;           curr->type = f64; break;
    case BinaryConsts::F32Abs:         curr = allocator.alloc<Unary>(); curr->op = AbsFloat32;           curr->type = f32; break;
    case BinaryConsts::F64Abs:         curr = allocator.alloc<Unary>(); curr->op = AbsFloat64;           curr->type = f64; break;
    case BinaryConsts::F32Ceil:        curr = allocator.alloc<Unary>(); curr->op = CeilFloat32;          curr->type = f32; break;
    case BinaryConsts::F64Ceil:        curr = allocator.alloc<Unary>(); curr->op = CeilFloat64;          curr->type = f64; break;
    case BinaryConsts::F32Floor:       curr = allocator.alloc<Unary>(); curr->op = FloorFloat32;         curr->type = f32; break;
    case BinaryConsts::F64Floor:       curr = allocator.alloc<Unary>(); curr->op = FloorFloat64;         curr->type = f64; break;
    case BinaryConsts::F32NearestInt:  curr = allocator.alloc<Unary>(); curr->op = NearestFloat32;       curr->type = f32; break;
    case BinaryConsts::F64NearestInt:  curr = allocator.alloc<Unary>(); curr->op = NearestFloat64;       curr->type = f64; break;
    case BinaryConsts::F32Sqrt:        curr = allocator.alloc<Unary>(); curr->op = SqrtFloat32;          curr->type = f32; break;
    case BinaryConsts::F64Sqrt:        curr = allocator.alloc<Unary>(); curr->op = SqrtFloat64;          curr->type = f64; break;
    case BinaryConsts::F32UConvertI32: curr = allocator.alloc<Unary>(); curr->op = ConvertUInt32ToFloat32; curr->type = f32; break;
    case BinaryConsts::F64UConvertI32: curr = allocator.alloc<Unary>(); curr->op = ConvertUInt32ToFloat64; curr->type = f64; break;
    case BinaryConsts::F32SConvertI32: curr = allocator.alloc<Unary>(); curr->op = ConvertSInt32ToFloat32; curr->type = f32; break;
    case BinaryConsts::F64SConvertI32: curr = allocator.alloc<Unary>(); curr->op = ConvertSInt32ToFloat64; curr->type = f64; break;
    case BinaryConsts::F32UConvertI64: curr = allocator.alloc<Unary>(); curr->op = ConvertUInt64ToFloat32; curr->type = f32; break;
    case BinaryConsts::F64UConvertI64: curr = allocator.alloc<Unary>(); curr->op = ConvertUInt64ToFloat64; curr->type = f64; break;
    case BinaryConsts::F32SConvertI64: curr = allocator.alloc<Unary>(); curr->op = ConvertSInt64ToFloat32; curr->type = f32; break;
    case BinaryConsts::F64SConvertI64: curr = allocator.alloc<Unary>(); curr->op = ConvertSInt64ToFloat64; curr->type = f64; break;

    case BinaryConsts::I64STruncI32:  curr = allocator.alloc<Unary>(); curr->op = ExtendSInt32;  curr->type = i64; break;
    case BinaryConsts::I64UTruncI32:  curr = allocator.alloc<Unary>(); curr->op = ExtendUInt32;  curr->type = i64; break;
    case BinaryConsts::I32ConvertI64: curr = allocator.alloc<Unary>(); curr->op = WrapInt64;     curr->type = i32; break;

    case BinaryConsts::I32UTruncF32: curr = allocator.alloc<Unary>(); curr->op = TruncUFloat32ToInt32; curr->type = i32; break;
    case BinaryConsts::I32UTruncF64: curr = allocator.alloc<Unary>(); curr->op = TruncUFloat64ToInt32; curr->type = i32; break;
    case BinaryConsts::I32STruncF32: curr = allocator.alloc<Unary>(); curr->op = TruncSFloat32ToInt32; curr->type = i32; break;
    case BinaryConsts::I32STruncF64: curr = allocator.alloc<Unary>(); curr->op = TruncSFloat64ToInt32; curr->type = i32; break;
    case BinaryConsts::I64UTruncF32: curr = allocator.alloc<Unary>(); curr->op = TruncUFloat32ToInt64; curr->type = i64; break;
    case BinaryConsts::I64UTruncF64: curr = allocator.alloc<Unary>(); curr->op = TruncUFloat64ToInt64; curr->type = i64; break;
    case BinaryConsts::I64STruncF32: curr = allocator.alloc<Unary>(); curr->op = TruncSFloat32ToInt64; curr->type = i64; break;
    case BinaryConsts::I64STruncF64: curr = allocator.alloc<Unary>(); curr->op = TruncSFloat64ToInt64; curr->type = i64; break;

    case BinaryConsts::F32Trunc: curr = allocator.alloc<Unary>(); curr->op = TruncFloat32; curr->type = f32; break;
    case BinaryConsts::F64Trunc: curr = allocator.alloc<Unary>(); curr->op = TruncFloat64; curr->type = f64; break;

    case BinaryConsts::F32ConvertF64:     curr = allocator.alloc<Unary>(); curr->op = DemoteFloat64;     curr->type = f32; break;
    case BinaryConsts::F64ConvertF32:     curr = allocator.alloc<Unary>(); curr->op = PromoteFloat32;    curr->type = f64; break;
    case BinaryConsts::I32ReinterpretF32: curr = allocator.alloc<Unary>(); curr->op = ReinterpretFloat32;  curr->type = i32; break;
    case BinaryConsts::I64ReinterpretF64: curr = allocator.alloc<Unary>(); curr->op = ReinterpretFloat64;  curr->type = i64; break;
    case BinaryConsts::F32ReinterpretI32: curr = allocator.alloc<Unary>(); curr->op = ReinterpretInt32;    curr->type = f32; break;
    case BinaryConsts::F64ReinterpretI64: curr = allocator.alloc<Unary>(); curr->op = ReinterpretInt64;    curr->type = f64; break;

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
    case BinaryConsts::I32##code: curr = allocator.alloc<Binary>(); curr->op = code##Int32; curr->type = i32; break; \
      case BinaryConsts::I64##code: curr = allocator.alloc<Binary>(); curr->op = code##Int64; curr->type = i64; break; \
  }
#define FLOAT_TYPED_CODE(code) {                                        \
    case BinaryConsts::F32##code: curr = allocator.alloc<Binary>(); curr->op = code##Float32; curr->type = f32; break; \
      case BinaryConsts::F64##code: curr = allocator.alloc<Binary>(); curr->op = code##Float64; curr->type = f64; break; \
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

void WasmBinaryBuilder::visitSelect(Select *curr) {
  if (debug) std::cerr << "zz node: Select" << std::endl;
  curr->condition = popNonVoidExpression();
  curr->ifFalse = popNonVoidExpression();
  curr->ifTrue = popNonVoidExpression();
  curr->finalize();
}

void WasmBinaryBuilder::visitReturn(Return *curr) {
  if (debug) std::cerr << "zz node: Return" << std::endl;
  if (!currFunction) {
    throw ParseException("return outside of function");
  }
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
      curr->type = i32;
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
  if (reserved != 0) throw ParseException("Invalid reserved field on grow_memory/current_memory");
  curr->finalize();
  out = curr;
  return true;
}

void WasmBinaryBuilder::visitNop(Nop *curr) {
  if (debug) std::cerr << "zz node: Nop" << std::endl;
}

void WasmBinaryBuilder::visitUnreachable(Unreachable *curr) {
  if (debug) std::cerr << "zz node: Unreachable" << std::endl;
}

void WasmBinaryBuilder::visitDrop(Drop *curr) {
  if (debug) std::cerr << "zz node: Drop" << std::endl;
  curr->value = popNonVoidExpression();
  curr->finalize();
}

} // namespace wasm
