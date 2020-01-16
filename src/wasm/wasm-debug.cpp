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

#include "wasm-debug.h"
#include "wasm.h"

#ifdef BUILD_LLVM_DWARF
#include "llvm/ObjectYAML/DWARFEmitter.h"
#include "llvm/ObjectYAML/DWARFYAML.h"
#include "llvm/include/llvm/DebugInfo/DWARFContext.h"

std::error_code dwarf2yaml(llvm::DWARFContext& DCtx, llvm::DWARFYAML::Data& Y);
#endif

#include "wasm-binary.h"
#include "wasm-debug.h"
#include "wasm.h"

namespace wasm {

namespace Debug {

bool isDWARFSection(Name name) { return name.startsWith(".debug_"); }

bool hasDWARFSections(const Module& wasm) {
  for (auto& section : wasm.userSections) {
    if (isDWARFSection(section.name)) {
      return true;
    }
  }
  return false;
}

#ifdef BUILD_LLVM_DWARF

struct BinaryenDWARFInfo {
  llvm::StringMap<std::unique_ptr<llvm::MemoryBuffer>> sections;
  std::unique_ptr<llvm::DWARFContext> context;

  BinaryenDWARFInfo(const Module& wasm) {
    // Get debug sections from the wasm.
    for (auto& section : wasm.userSections) {
      if (Name(section.name).startsWith(".debug_")) {
        // TODO: efficiency
        sections[section.name.substr(1)] = llvm::MemoryBuffer::getMemBufferCopy(
          llvm::StringRef(section.data.data(), section.data.size()));
      }
    }
    // Parse debug sections.
    uint8_t addrSize = 4;
    bool isLittleEndian = true;
    context = llvm::DWARFContext::create(sections, addrSize, isLittleEndian);
  }
};

void dumpDWARF(const Module& wasm) {
  BinaryenDWARFInfo info(wasm);
  std::cout << "DWARF debug info\n";
  std::cout << "================\n\n";
  for (auto& section : wasm.userSections) {
    if (Name(section.name).startsWith(".debug_")) {
      std::cout << "Contains section " << section.name << " ("
                << section.data.size() << " bytes)\n";
    }
  }
  llvm::DIDumpOptions options;
  options.DumpType = llvm::DIDT_All;
  options.ShowChildren = true;
  options.Verbose = true;
  info.context->dump(llvm::outs(), options);
}

//
// Big picture: We use a DWARFContext to read data, then DWARFYAML support
// code to write it. That is not the main LLVM Dwarf code used for writing
// object files, but it avoids us create a "fake" MC layer, and provides a
// simple way to write out the debug info. Likely the level of info represented
// in the DWARFYAML::Data object is sufficient for Binaryen's needs, but if not,
// we may need a different approach.
//
// In more detail:
//
// 1. Binary sections => DWARFContext:
//
//     llvm::DWARFContext::create(sections..)
//
// 2. DWARFContext => DWARFYAML::Data
//
//     std::error_code dwarf2yaml(DWARFContext &DCtx, DWARFYAML::Data &Y) {
//
// 3. DWARFYAML::Data => binary sections
//
//     StringMap<std::unique_ptr<MemoryBuffer>>
//     EmitDebugSections(llvm::DWARFYAML::Data &DI, bool ApplyFixups);
//

// Represents the state when parsing a line table.
struct LineState {
  uint32_t addr = 0;
  // TODO sectionIndex?
  uint32_t line = 1;
  uint32_t col = 0;
  uint32_t file = 1;
  uint32_t isa = 0;
  uint32_t discriminator = 0;
  bool isStmt;
  bool basicBlock = false;
  // XXX these two should be just prologue, epilogue?
  bool prologueEnd = false;
  bool epilogueBegin = false;

  LineState(const LineState& other) = default;
  LineState(const llvm::DWARFYAML::LineTable& table)
    : isStmt(table.DefaultIsStmt) {}

  LineState& operator=(const LineState& other) = default;

  // Updates the state, and returns whether a new row is ready to be emitted.
  bool update(llvm::DWARFYAML::LineTableOpcode& opcode,
              const llvm::DWARFYAML::LineTable& table) {
    switch (opcode.Opcode) {
      case 0: {
        // Extended opcodes
        switch (opcode.SubOpcode) {
          case llvm::dwarf::DW_LNE_set_address: {
            addr = opcode.Data;
            break;
          }
          case llvm::dwarf::DW_LNE_end_sequence: {
            return true;
          }
          case llvm::dwarf::DW_LNE_set_discriminator: {
            discriminator = opcode.Data;
            break;
          }
          case llvm::dwarf::DW_LNE_define_file: {
            Fatal() << "TODO: DW_LNE_define_file";
          }
          default: {
            // An unknown opcode, ignore.
            std::cerr << "warning: unknown subopcopde " << opcode.SubOpcode
                      << '\n';
          }
        }
        break;
      }
      case llvm::dwarf::DW_LNS_set_column: {
        col = opcode.Data;
        break;
      }
      case llvm::dwarf::DW_LNS_set_prologue_end: {
        prologueEnd = true;
        break;
      }
      case llvm::dwarf::DW_LNS_copy: {
        return true;
      }
      case llvm::dwarf::DW_LNS_advance_pc: {
        assert(table.MinInstLength == 1);
        addr += opcode.Data;
        break;
      }
      case llvm::dwarf::DW_LNS_advance_line: {
        line += opcode.SData;
        break;
      }
      case llvm::dwarf::DW_LNS_set_file: {
        file = opcode.Data;
        break;
      }
      case llvm::dwarf::DW_LNS_negate_stmt: {
        isStmt = !isStmt;
        break;
      }
      case llvm::dwarf::DW_LNS_set_basic_block: {
        basicBlock = true;
        break;
      }
      case llvm::dwarf::DW_LNS_const_add_pc: {
        uint8_t AdjustOpcode = 255 - table.OpcodeBase;
        uint64_t AddrOffset =
          (AdjustOpcode / table.LineRange) * table.MinInstLength;
        addr += AddrOffset;
        break;
      }
      case llvm::dwarf::DW_LNS_fixed_advance_pc: {
        addr += opcode.Data;
        break;
      }
      case llvm::dwarf::DW_LNS_set_isa: {
        isa = opcode.Data;
        break;
      }
      default: {
        if (opcode.Opcode >= table.OpcodeBase) {
          // Special opcode: adjust line and addr, using some math.
          uint8_t AdjustOpcode =
            opcode.Opcode - table.OpcodeBase; // 20 - 13 = 7
          uint64_t AddrOffset = (AdjustOpcode / table.LineRange) *
                                table.MinInstLength; // (7 / 14) * 1 = 0
          int32_t LineOffset =
            table.LineBase +
            (AdjustOpcode % table.LineRange); // -5 + (7 % 14) = 2
          line += LineOffset;
          addr += AddrOffset;
          return true;
        } else {
          Fatal() << "unknown debug line opcode: " << std::hex << opcode.Opcode;
        }
      }
    }
    return false;
  }

  // Checks if this starts a new range of addresses. Each range is a set of
  // related addresses, where in particular, if the first has been zeroed out
  // by the linker, we must omit the entire range. (If we do not, then the
  // initial range is 0 and the others are offsets relative to it, which will
  // look like random addresses, perhaps into the middle of instructions, and
  // perhaps that happen to collide with real ones.)
  bool startsNewRange(llvm::DWARFYAML::LineTableOpcode& opcode) {
    return opcode.Opcode == 0 &&
           opcode.SubOpcode == llvm::dwarf::DW_LNE_set_address;
  }

  bool needToEmit() {
    // If any value is 0, can ignore it
    // https://github.com/WebAssembly/debugging/issues/9#issuecomment-567720872
    return line != 0 && col != 0 && addr != 0;
  }

  // Given an old state, emit the diff from it to this state into a new line
  // table entry (that will be emitted in the updated DWARF debug line section).
  void emitDiff(const LineState& old,
                std::vector<llvm::DWARFYAML::LineTableOpcode>& newOpcodes,
                const llvm::DWARFYAML::LineTable& table) {
    bool useSpecial = false;
    if (addr != old.addr || line != old.line) {
      // Try to use a special opcode TODO
    }
    if (addr != old.addr && !useSpecial) {
      // len = 1 (subopcode) + 4 (wasm32 address)
      // FIXME: look at AddrSize on the Unit.
      auto item = makeItem(llvm::dwarf::DW_LNE_set_address, 5);
      item.Data = addr;
      newOpcodes.push_back(item);
    }
    if (line != old.line && !useSpecial) {
      auto item = makeItem(llvm::dwarf::DW_LNS_advance_line);
      item.SData = line - old.line;
      newOpcodes.push_back(item);
    }
    if (col != old.col) {
      auto item = makeItem(llvm::dwarf::DW_LNS_set_column);
      item.Data = col;
      newOpcodes.push_back(item);
    }
    if (file != old.file) {
      auto item = makeItem(llvm::dwarf::DW_LNS_set_file);
      item.Data = file;
      newOpcodes.push_back(item);
    }
    if (isa != old.isa) {
      auto item = makeItem(llvm::dwarf::DW_LNS_set_isa);
      item.Data = isa;
      newOpcodes.push_back(item);
    }
    if (discriminator != old.discriminator) {
      // len = 1 (subopcode) + 4 (wasm32 address)
      auto item = makeItem(llvm::dwarf::DW_LNE_set_discriminator, 5);
      item.Data = discriminator;
      newOpcodes.push_back(item);
    }
    if (isStmt != old.isStmt) {
      newOpcodes.push_back(makeItem(llvm::dwarf::DW_LNS_negate_stmt));
    }
    if (basicBlock != old.basicBlock) {
      assert(basicBlock);
      newOpcodes.push_back(makeItem(llvm::dwarf::DW_LNS_set_basic_block));
    }
    if (prologueEnd != old.prologueEnd) {
      assert(prologueEnd);
      newOpcodes.push_back(makeItem(llvm::dwarf::DW_LNS_set_prologue_end));
    }
    if (epilogueBegin != old.epilogueBegin) {
      Fatal() << "eb";
    }
    if (useSpecial) {
      // Emit a special, which ends a sequence automatically.
      // TODO
    } else {
      // End the sequence manually.
      // len = 1 (subopcode)
      newOpcodes.push_back(makeItem(llvm::dwarf::DW_LNE_end_sequence, 1));
      // Reset the state.
      *this = LineState(table);
    }
  }

private:
  llvm::DWARFYAML::LineTableOpcode makeItem(llvm::dwarf::LineNumberOps opcode) {
    llvm::DWARFYAML::LineTableOpcode item = {};
    item.Opcode = opcode;
    return item;
  }

  llvm::DWARFYAML::LineTableOpcode
  makeItem(llvm::dwarf::LineNumberExtendedOps opcode, uint64_t len) {
    auto item = makeItem(llvm::dwarf::LineNumberOps(0));
    // All the length after the len field itself, including the subopcode
    // (1 byte).
    item.ExtLen = len;
    item.SubOpcode = opcode;
    return item;
  }
};

// Represents a mapping of addresses to expressions. We track beginnings and
// endings of expressions separately, since the end of one (which is one past
// the end in DWARF notation) overlaps with the beginning of the next, and also
// to let us use contextual information (we may know we are looking up the end
// of an instruction).
struct AddrExprMap {
  std::unordered_map<uint32_t, Expression*> startMap;
  std::unordered_map<uint32_t, Expression*> endMap;

  // Construct the map from the binaryLocations loaded from the wasm.
  AddrExprMap(const Module& wasm) {
    for (auto& func : wasm.functions) {
      for (auto pair : func->expressionLocations) {
        add(pair.first, pair.second);
      }
    }
  }

  // Construct the map from new binaryLocations just written
  AddrExprMap(const BinaryLocations& newLocations) {
    for (auto pair : newLocations.expressions) {
      add(pair.first, pair.second);
    }
  }

  Expression* getStart(uint32_t addr) const {
    auto iter = startMap.find(addr);
    if (iter != startMap.end()) {
      return iter->second;
    }
    return nullptr;
  }

  Expression* getEnd(uint32_t addr) const {
    auto iter = endMap.find(addr);
    if (iter != endMap.end()) {
      return iter->second;
    }
    return nullptr;
  }

private:
  void add(Expression* expr, BinaryLocations::Span span) {
    assert(startMap.count(span.first) == 0);
    startMap[span.first] = expr;
    assert(endMap.count(span.second) == 0);
    endMap[span.second] = expr;
  }
};

// Represents a mapping of addresses to expressions. Note that we use a single
// map for the start and end addresses, since there is no chance of a function's
// start overlapping with another's end (there is the size LEB in the middle).
struct FuncAddrMap {
  std::unordered_map<uint32_t, Function*> map;

  // Construct the map from the binaryLocations loaded from the wasm.
  FuncAddrMap(const Module& wasm) {
    for (auto& func : wasm.functions) {
      map[func->funcLocation.first] = func.get();
      map[func->funcLocation.second] = func.get();
    }
  }

  Function* get(uint32_t addr) const {
    auto iter = map.find(addr);
    if (iter != map.end()) {
      return iter->second;
    }
    return nullptr;
  }

  void dump() const {
    std::cout << "  (size: " << map.size() << ")\n";
    for (auto pair : map) {
      std::cout << "  " << pair.first << " => " << pair.second->name << '\n';
    }
  }
};

// Track locations from the original binary and the new one we wrote, so that
// we can update debug positions.
// We track expressions and functions separately, instead of having a single
// big map of (oldAddr) => (newAddr) because of the potentially ambiguous case
// of the final expression in a function: it's end might be identical in offset
// to the end of the function. So we have two different things that map to the
// same offset. However, if the context is "the end of the function" then the
// updated address is the new end of the function, even if the function ends
// with a different instruction now, as the old last instruction might have
// moved or been optimized out.
struct LocationUpdater {
  Module& wasm;
  const BinaryLocations& newLocations;

  AddrExprMap oldExprAddrMap;
  AddrExprMap newExprAddrMap;
  FuncAddrMap oldFuncAddrMap;

  // TODO: for memory efficiency, we may want to do this in a streaming manner,
  //       binary to binary, without YAML IR.

  // TODO: apparently DWARF offsets may be into the middle of instructions...
  //       we may need to track their spans too
  // https://github.com/WebAssembly/debugging/issues/9#issuecomment-567720872

  LocationUpdater(Module& wasm, const BinaryLocations& newLocations)
    : wasm(wasm), newLocations(newLocations), oldExprAddrMap(wasm),
      newExprAddrMap(newLocations), oldFuncAddrMap(wasm) {}

  // Updates an expression's address. If there was never an instruction at that
  // address, or if there was but if that instruction no longer exists, return
  // 0. Otherwise, return the new updated location.
  uint32_t getNewExprAddr(uint32_t oldAddr) const {
    if (auto* expr = oldExprAddrMap.getStart(oldAddr)) {
      auto iter = newLocations.expressions.find(expr);
      if (iter != newLocations.expressions.end()) {
        uint32_t newAddr = iter->second.first;
        return newAddr;
      }
    }
    return 0;
  }

  uint32_t getNewExprEndAddr(uint32_t oldAddr) const {
    if (auto* expr = oldExprAddrMap.getEnd(oldAddr)) {
      auto iter = newLocations.expressions.find(expr);
      if (iter != newLocations.expressions.end()) {
        uint32_t newAddr = iter->second.second;
        return newAddr;
      }
    }
    return 0;
  }

  uint32_t getNewFuncAddr(uint32_t oldAddr) const {
    if (auto* func = oldFuncAddrMap.get(oldAddr)) {
      // The function might have been optimized away, check.
      auto iter = newLocations.functions.find(func);
      if (iter != newLocations.functions.end()) {
        auto oldSpan = func->funcLocation;
        auto newSpan = iter->second;
        if (oldAddr == oldSpan.first) {
          return newSpan.first;
        } else if (oldAddr == oldSpan.second) {
          return newSpan.second;
        }
      }
    }
    return 0;
  }
};

static void updateDebugLines(llvm::DWARFYAML::Data& data,
                             const LocationUpdater& locationUpdater) {
  for (auto& table : data.DebugLines) {
    // Parse the original opcodes and emit new ones.
    LineState state(table);
    // All the addresses we need to write out.
    std::vector<uint32_t> newAddrs;
    std::unordered_map<uint32_t, LineState> newAddrInfo;
    // If the address was zeroed out, we must omit the entire range (we could
    // also leave it unchanged, so that the debugger ignores it based on the
    // initial zero; but it's easier and better to just not emit it at all).
    bool omittingRange = false;
    for (auto& opcode : table.Opcodes) {
      // Update the state, and check if we have a new row to emit.
      if (state.startsNewRange(opcode)) {
        omittingRange = false;
      }
      if (state.update(opcode, table)) {
        if (state.addr == 0) {
          omittingRange = true;
        }
        if (omittingRange) {
          state = LineState(table);
          continue;
        }
        // An expression may not exist for this line table item, if we optimized
        // it away.
        if (auto newAddr = locationUpdater.getNewExprAddr(state.addr)) {
          newAddrs.push_back(newAddr);
          newAddrInfo.emplace(newAddr, state);
          auto& updatedState = newAddrInfo.at(newAddr);
          // The only difference is the address TODO other stuff?
          updatedState.addr = newAddr;
        }
        if (opcode.Opcode == 0 &&
            opcode.SubOpcode == llvm::dwarf::DW_LNE_end_sequence) {
          state = LineState(table);
        }
      }
    }
    // Sort the new addresses (which may be substantially different from the
    // original layout after optimization).
    std::sort(newAddrs.begin(), newAddrs.end());
    // Emit a new line table.
    {
      std::vector<llvm::DWARFYAML::LineTableOpcode> newOpcodes;
      LineState state(table);
      for (uint32_t addr : newAddrs) {
        LineState oldState(state);
        state = newAddrInfo.at(addr);
        if (state.needToEmit()) {
          state.emitDiff(oldState, newOpcodes, table);
        } else {
          state = oldState;
        }
      }
      table.Opcodes.swap(newOpcodes);
    }
  }
}

// Iterate in parallel over a DwarfContext representation element and a
// YAML element, which parallel each other.
template<typename T, typename U, typename W>
static void iterContextAndYAML(const T& contextList, U& yamlList, W func) {
  auto yamlValue = yamlList.begin();
  for (const auto& contextValue : contextList) {
    assert(yamlValue != yamlList.end());
    func(contextValue, *yamlValue);
    yamlValue++;
  }
  assert(yamlValue == yamlList.end());
}

static void updateDIE(const llvm::DWARFDebugInfoEntry& DIE, llvm::DWARFYAML::Entry& yamlEntry, const llvm::DWARFAbbreviationDeclaration* abbrevDecl, const LocationUpdater& locationUpdater) {
  auto tag = DIE.getTag();
  // Pairs of low/high_pc require some special handling, as the high
  // may be an offset relative to the low. First, process the low_pcs.
  uint32_t oldLowPC = 0, newLowPC = 0;
  iterContextAndYAML(
    abbrevDecl->attributes(),
    yamlEntry.Values,
    [&](const llvm::DWARFAbbreviationDeclaration::AttributeSpec&
          attrSpec,
        llvm::DWARFYAML::FormValue& yamlValue) {
      auto attr = attrSpec.Attr;
      if (attr != llvm::dwarf::DW_AT_low_pc) {
        return;
      }
      uint32_t oldValue = yamlValue.Value, newValue = 0;
      if (tag == llvm::dwarf::DW_TAG_GNU_call_site ||
          tag == llvm::dwarf::DW_TAG_inlined_subroutine ||
          tag == llvm::dwarf::DW_TAG_lexical_block ||
          tag == llvm::dwarf::DW_TAG_label) {
        newValue =
          locationUpdater.getNewExprAddr(oldValue);
      } else if (tag == llvm::dwarf::DW_TAG_compile_unit ||
                 tag == llvm::dwarf::DW_TAG_subprogram) {
        newValue =
          locationUpdater.getNewFuncAddr(oldValue);
      } else {
        Fatal() << "unknown tag with low_pc "
                << llvm::dwarf::TagString(tag).str();
      }
      oldLowPC = oldValue;
      newLowPC = newValue;
      yamlValue.Value = newValue;
    });
  // Next, process the high_pcs.
  iterContextAndYAML(
    abbrevDecl->attributes(),
    yamlEntry.Values,
    [&](const llvm::DWARFAbbreviationDeclaration::AttributeSpec&
          attrSpec,
        llvm::DWARFYAML::FormValue& yamlValue) {
      auto attr = attrSpec.Attr;
      if (attr != llvm::dwarf::DW_AT_high_pc) {
        return;
      }
      uint32_t oldValue = yamlValue.Value, newValue = 0;
      bool isRelative = attrSpec.Form == llvm::dwarf::DW_FORM_data4;
      if (isRelative) {
        oldValue += oldLowPC;
      }
      if (tag == llvm::dwarf::DW_TAG_GNU_call_site ||
          tag == llvm::dwarf::DW_TAG_inlined_subroutine ||
          tag == llvm::dwarf::DW_TAG_lexical_block ||
          tag == llvm::dwarf::DW_TAG_label) {
        newValue =
          locationUpdater.getNewExprEndAddr(oldValue);
      } else if (tag == llvm::dwarf::DW_TAG_compile_unit ||
                 tag == llvm::dwarf::DW_TAG_subprogram) {
        newValue =
          locationUpdater.getNewFuncAddr(oldValue);
      } else {
        Fatal() << "unknown tag with low_pc "
                << llvm::dwarf::TagString(tag).str();
      }
      if (isRelative) {
        newValue -= newLowPC;
      }
      yamlValue.Value = newValue;
    });
}

static void updateCompileUnits(const BinaryenDWARFInfo& info,
                               llvm::DWARFYAML::Data& yaml,
                               const LocationUpdater& locationUpdater) {
  // The context has the high-level information we need, and the YAML is where
  // we write changes. First, iterate over the compile units.
  iterContextAndYAML(
    info.context->compile_units(),
    yaml.CompileUnits,
    [&](const std::unique_ptr<llvm::DWARFUnit>& CU,
        llvm::DWARFYAML::Unit& yamlUnit) {
      // Process the DIEs in each compile unit.
      iterContextAndYAML(
        CU->dies(),
        yamlUnit.Entries,
        [&](const llvm::DWARFDebugInfoEntry& DIE,
            llvm::DWARFYAML::Entry& yamlEntry) {
          // Process the entries in each relevant DIE, looking for attributes to
          // change.
          auto abbrevDecl = DIE.getAbbreviationDeclarationPtr();
          if (abbrevDecl) {
            // This is relevant; look for things to update.
            updateDIE(DIE, yamlEntry, abbrevDecl, locationUpdater);
          }
        });
    });
}

void writeDWARFSections(Module& wasm, const BinaryLocations& newLocations) {
  BinaryenDWARFInfo info(wasm);

  // Convert to Data representation, which YAML can use to write.
  llvm::DWARFYAML::Data data;
  if (dwarf2yaml(*info.context, data)) {
    Fatal() << "Failed to parse DWARF to YAML";
  }

  LocationUpdater locationUpdater(wasm, newLocations);

  updateDebugLines(data, locationUpdater);

  updateCompileUnits(info, data, locationUpdater);

  // TODO: Actually update, and remove sections we don't know how to update yet?

  // Convert to binary sections.
  auto newSections =
    EmitDebugSections(data, false /* EmitFixups for debug_info */);

  // Update the custom sections in the wasm.
  // TODO: efficiency
  for (auto& section : wasm.userSections) {
    if (Name(section.name).startsWith(".debug_")) {
      auto llvmName = section.name.substr(1);
      if (newSections.count(llvmName)) {
        auto llvmData = newSections[llvmName]->getBuffer();
        section.data.resize(llvmData.size());
        std::copy(llvmData.begin(), llvmData.end(), section.data.data());
      }
    }
  }
}

#else // BUILD_LLVM_DWARF

void dumpDWARF(const Module& wasm) {
  std::cerr << "warning: no DWARF dumping support present\n";
}

void writeDWARFSections(Module& wasm, const BinaryLocations& newLocations) {
  std::cerr << "warning: no DWARF updating support present\n";
}

#endif // BUILD_LLVM_DWARF

} // namespace Debug

} // namespace wasm
