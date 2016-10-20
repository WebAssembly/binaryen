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

  writeTypes();
  writeImports();
  writeFunctionSignatures();
  writeFunctionTableDeclaration();
  writeMemory();
  writeGlobals();
  writeExports();
  writeTableElements();
  writeStart();
  writeFunctions();
  writeDataSegments();
  if (debugInfo) writeNames();

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
    o << int8_t(BinaryConsts::TypeForms::Basic);
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
      case ExternalKind::Function: o << U32LEB(getFunctionTypeIndex(import->functionType->name)); break;
      case ExternalKind::Table: {
        o << U32LEB(BinaryConsts::ElementType::AnyFunc);
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
  o << U32LEB(BinaryConsts::ElementType::AnyFunc);
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
  if (wasm->functions.size() == 0) return;
  if (debug) std::cerr << "== writeNames" << std::endl;
  auto start = startSection(BinaryConsts::Section::User);
  writeInlineString(BinaryConsts::UserSections::Name);
  o << U32LEB(wasm->functions.size());
  for (auto& curr : wasm->functions) {
    writeInlineString(curr->name.str);
    o << U32LEB(0); // TODO: locals
  }
  finishSection(start);
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

void WasmBinaryWriter::visitBlock(Block *curr) {
  if (debug) std::cerr << "zz node: Block" << std::endl;
  o << int8_t(BinaryConsts::Block);
  o << binaryWasmType(curr->type != unreachable ? curr->type : none);
  breakStack.push_back(curr->name);
  size_t i = 0;
  for (auto* child : curr->list) {
    if (debug) std::cerr << "  " << size_t(curr) << "\n zz Block element " << i++ << std::endl;
    recurse(child);
  }
  breakStack.pop_back();
  o << int8_t(BinaryConsts::End);
}

// emits a node, but if it is a block with no name, emit a list of its contents
void WasmBinaryWriter::recursePossibleBlockContents(Expression* curr) {
  auto* block = curr->dynCast<Block>();
  if (!block || (block->name.is() && BreakSeeker::has(curr, block->name))) {
    recurse(curr);
    return;
  }
  for (auto* child : block->list) {
    recurse(child);
  }
}

void WasmBinaryWriter::visitIf(If *curr) {
  if (debug) std::cerr << "zz node: If" << std::endl;
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
}
void WasmBinaryWriter::visitLoop(Loop *curr) {
  if (debug) std::cerr << "zz node: Loop" << std::endl;
  o << int8_t(BinaryConsts::Loop);
  o << binaryWasmType(curr->type != unreachable ? curr->type : none);
  breakStack.push_back(curr->name);
  recursePossibleBlockContents(curr->body);
  breakStack.pop_back();
  o << int8_t(BinaryConsts::End);
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
  o << int8_t(BinaryConsts::CallIndirect) << U32LEB(getFunctionTypeIndex(curr->fullType));
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
  if (debug) std::cerr << "zz node: GetGlobal " << (o.size() + 1) << std::endl;
  o << int8_t(BinaryConsts::GetGlobal) << U32LEB(getGlobalIndex(curr->name));
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
    default: abort();
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
      o << int8_t(BinaryConsts::F32Const) << curr->value.getf32();
      break;
    }
    case f64: {
      o << int8_t(BinaryConsts::F64Const) << curr->value.getf64();
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

} // namespace wasm
