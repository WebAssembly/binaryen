/*
 * Copyright 2023 WebAssembly Community Group participants
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

#include "contexts.h"

namespace wasm::WATParser {

namespace {

void applyImportNames(Importable& item, ImportNames* names) {
  if (names) {
    item.module = names->mod;
    item.base = names->nm;
  }
}

Result<> addExports(Lexer& in,
                    Module& wasm,
                    const Named* item,
                    const std::vector<Name>& exports,
                    ExternalKind kind) {
  for (auto name : exports) {
    if (wasm.getExportOrNull(name)) {
      // TODO: Fix error location
      return in.err("repeated export name");
    }
    wasm.addExport(Builder(wasm).makeExport(name, item->name, kind));
  }
  return Ok{};
}

} // anonymous namespace

Result<Function*>
ParseDeclsCtx::addFuncDecl(Index pos, Name name, ImportNames* importNames) {
  auto f = std::make_unique<Function>();
  if (name.is()) {
    if (wasm.getFunctionOrNull(name)) {
      // TDOO: if the existing function is not explicitly named, fix its name
      // and continue.
      return in.err(pos, "repeated function name");
    }
    f->setExplicitName(name);
  } else {
    name = (importNames ? "fimport$" : "") + std::to_string(funcCounter++);
    name = Names::getValidFunctionName(wasm, name);
    f->name = name;
  }
  applyImportNames(*f, importNames);
  return wasm.addFunction(std::move(f));
}

Result<> ParseDeclsCtx::addFunc(Name name,
                                const std::vector<Name>& exports,
                                ImportNames* import,
                                TypeUseT type,
                                std::optional<LocalsT>,
                                std::vector<Annotation>&& annotations,
                                Index pos) {
  CHECK_ERR(checkImport(pos, import));
  auto f = addFuncDecl(pos, name, import);
  CHECK_ERR(f);
  CHECK_ERR(addExports(in, wasm, *f, exports, ExternalKind::Function));
  funcDefs.push_back(
    {name, pos, Index(funcDefs.size()), std::move(annotations)});
  return Ok{};
}

Result<Table*> ParseDeclsCtx::addTableDecl(Index pos,
                                           Name name,
                                           ImportNames* importNames,
                                           TableType type) {
  auto t = std::make_unique<Table>();
  t->indexType = type.indexType;
  t->initial = type.limits.initial;
  t->max = type.limits.max ? *type.limits.max : Table::kUnlimitedSize;
  if (name.is()) {
    if (wasm.getTableOrNull(name)) {
      // TODO: if the existing table is not explicitly named, fix its name and
      // continue.
      return in.err(pos, "repeated table name");
    }
    t->setExplicitName(name);
  } else {
    name = (importNames ? "timport$" : "") + std::to_string(tableCounter++);
    name = Names::getValidTableName(wasm, name);
    t->name = name;
  }
  applyImportNames(*t, importNames);
  return wasm.addTable(std::move(t));
}

Result<> ParseDeclsCtx::addTable(Name name,
                                 const std::vector<Name>& exports,
                                 ImportNames* import,
                                 TableType type,
                                 Index pos) {
  CHECK_ERR(checkImport(pos, import));
  auto t = addTableDecl(pos, name, import, type);
  CHECK_ERR(t);
  CHECK_ERR(addExports(in, wasm, *t, exports, ExternalKind::Table));
  // TODO: table annotations
  tableDefs.push_back({name, pos, Index(tableDefs.size()), {}});
  return Ok{};
}

Result<> ParseDeclsCtx::addImplicitElems(TypeT, ElemListT&& elems) {
  auto& table = *wasm.tables.back();
  auto e = std::make_unique<ElementSegment>();
  e->table = table.name;
  e->offset = Builder(wasm).makeConstPtr(0, Type::i32);
  e->name = Names::getValidElementSegmentName(wasm, "implicit-elem");
  wasm.addElementSegment(std::move(e));

  // Record the index mapping so we can find this segment again to set its type
  // and elements in later phases.
  Index tableIndex = wasm.tables.size() - 1;
  Index elemIndex = wasm.elementSegments.size() - 1;
  implicitElemIndices[tableIndex] = elemIndex;

  return Ok{};
}

Result<Memory*> ParseDeclsCtx::addMemoryDecl(Index pos,
                                             Name name,
                                             ImportNames* importNames,
                                             MemType type) {
  auto m = std::make_unique<Memory>();
  m->indexType = type.indexType;
  m->initial = type.limits.initial;
  m->max = type.limits.max ? *type.limits.max : Memory::kUnlimitedSize;
  m->shared = type.shared;
  if (name) {
    // TODO: if the existing memory is not explicitly named, fix its name
    // and continue.
    if (wasm.getMemoryOrNull(name)) {
      return in.err(pos, "repeated memory name");
    }
    m->setExplicitName(name);
  } else {
    name = (importNames ? "mimport$" : "") + std::to_string(memoryCounter++);
    name = Names::getValidMemoryName(wasm, name);
    m->name = name;
  }
  applyImportNames(*m, importNames);
  return wasm.addMemory(std::move(m));
}

Result<> ParseDeclsCtx::addMemory(Name name,
                                  const std::vector<Name>& exports,
                                  ImportNames* import,
                                  MemType type,
                                  Index pos) {
  CHECK_ERR(checkImport(pos, import));
  auto m = addMemoryDecl(pos, name, import, type);
  CHECK_ERR(m);
  CHECK_ERR(addExports(in, wasm, *m, exports, ExternalKind::Memory));
  // TODO: memory annotations
  memoryDefs.push_back({name, pos, Index(memoryDefs.size()), {}});
  return Ok{};
}

Result<> ParseDeclsCtx::addImplicitData(DataStringT&& data) {
  auto& mem = *wasm.memories.back();
  auto d = std::make_unique<DataSegment>();
  d->memory = mem.name;
  d->isPassive = false;
  d->offset = Builder(wasm).makeConstPtr(0, mem.indexType);
  d->data = std::move(data);
  d->name = Names::getValidDataSegmentName(wasm, "implicit-data");
  wasm.addDataSegment(std::move(d));
  return Ok{};
}

Result<Global*>
ParseDeclsCtx::addGlobalDecl(Index pos, Name name, ImportNames* importNames) {
  auto g = std::make_unique<Global>();
  if (name) {
    if (wasm.getGlobalOrNull(name)) {
      // TODO: if the existing global is not explicitly named, fix its name
      // and continue.
      return in.err(pos, "repeated global name");
    }
    g->setExplicitName(name);
  } else {
    name =
      (importNames ? "gimport$" : "global$") + std::to_string(globalCounter++);
    name = Names::getValidGlobalName(wasm, name);
    g->name = name;
  }
  applyImportNames(*g, importNames);
  return wasm.addGlobal(std::move(g));
}

Result<> ParseDeclsCtx::addGlobal(Name name,
                                  const std::vector<Name>& exports,
                                  ImportNames* import,
                                  GlobalTypeT,
                                  std::optional<ExprT>,
                                  Index pos) {
  CHECK_ERR(checkImport(pos, import));
  auto g = addGlobalDecl(pos, name, import);
  CHECK_ERR(g);
  CHECK_ERR(addExports(in, wasm, *g, exports, ExternalKind::Global));
  // TODO: global annotations
  globalDefs.push_back({name, pos, Index(globalDefs.size()), {}});
  return Ok{};
}

Result<> ParseDeclsCtx::addElem(
  Name name, TableIdxT*, std::optional<ExprT>, ElemListT&&, Index pos) {
  auto e = std::make_unique<ElementSegment>();
  if (name) {
    if (wasm.getElementSegmentOrNull(name)) {
      // TDOO: if the existing segment is not explicitly named, fix its name and
      // continue.
      return in.err(pos, "repeated element segment name");
    }
    e->setExplicitName(name);
  } else {
    name = std::to_string(elemCounter++);
    name = Names::getValidElementSegmentName(wasm, name);
    e->name = name;
  }
  // TODO: element segment annotations
  elemDefs.push_back({name, pos, Index(wasm.elementSegments.size()), {}});
  wasm.addElementSegment(std::move(e));
  return Ok{};
}

Result<> ParseDeclsCtx::addData(Name name,
                                MemoryIdxT*,
                                std::optional<ExprT>,
                                std::vector<char>&& data,
                                Index pos) {
  auto d = std::make_unique<DataSegment>();
  if (name) {
    if (wasm.getDataSegmentOrNull(name)) {
      // TODO: if the existing segment is not explicitly named, fix its name
      // and continue.
      return in.err(pos, "repeated data segment name");
    }
    d->setExplicitName(name);
  } else {
    name = std::to_string(dataCounter++);
    name = Names::getValidDataSegmentName(wasm, name);
    d->name = name;
  }
  d->data = std::move(data);
  // TODO: data segment annotations
  dataDefs.push_back({name, pos, Index(wasm.dataSegments.size()), {}});
  wasm.addDataSegment(std::move(d));
  return Ok{};
}

Result<Tag*>
ParseDeclsCtx::addTagDecl(Index pos, Name name, ImportNames* importNames) {
  auto t = std::make_unique<Tag>();
  if (name) {
    if (wasm.getTagOrNull(name)) {
      // TODO: if the existing tag is not explicitly named, fix its name and
      // continue.
      return in.err(pos, "repeated tag name");
    }
    t->setExplicitName(name);
  } else {
    name = (importNames ? "eimport$" : "tag$") + std::to_string(tagCounter++);
    name = Names::getValidTagName(wasm, name);
    t->name = name;
  }
  applyImportNames(*t, importNames);
  return wasm.addTag(std::move(t));
}

Result<> ParseDeclsCtx::addTag(Name name,
                               const std::vector<Name>& exports,
                               ImportNames* import,
                               TypeUseT type,
                               Index pos) {
  CHECK_ERR(checkImport(pos, import));
  auto t = addTagDecl(pos, name, import);
  CHECK_ERR(t);
  CHECK_ERR(addExports(in, wasm, *t, exports, ExternalKind::Tag));
  // TODO: tag annotations
  tagDefs.push_back({name, pos, Index(tagDefs.size()), {}});
  return Ok{};
}

} // namespace wasm::WATParser
