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
  bool prologueEnd = false;
  bool epilogueBegin = false;
  bool endSequence = false;

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
            endSequence = true;
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
    // Zero values imply we can ignore this line.
    // https://github.com/WebAssembly/debugging/issues/9#issuecomment-567720872
    return line != 0 && addr != 0;
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
      // Emit a special, which emits a line automatically.
      // TODO
    } else {
      // Emit the line manually.
      if (endSequence) {
        // len = 1 (subopcode)
        newOpcodes.push_back(makeItem(llvm::dwarf::DW_LNE_end_sequence, 1));
        // Reset the state.
        *this = LineState(table);
      } else {
        newOpcodes.push_back(makeItem(llvm::dwarf::DW_LNS_copy));
      }
    }
    resetAfterLine();
  }

  // Some flags are automatically reset after each debug line.
  void resetAfterLine() { prologueEnd = false; }

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
  std::unordered_map<BinaryLocation, Expression*> startMap;
  std::unordered_map<BinaryLocation, Expression*> endMap;

  // Some instructions have extra binary locations, like the else and end in
  // and if. Track those separately, including their expression and their id
  // ("else", "end", etc.), as they are rare, and we don't want to
  // bloat the common case which is represented in the earlier maps.
  struct ExtraInfo {
    Expression* expr;
    BinaryLocations::DelimiterId id;
  };
  std::unordered_map<BinaryLocation, ExtraInfo> extraMap;

  // Construct the map from the binaryLocations loaded from the wasm.
  AddrExprMap(const Module& wasm) {
    for (auto& func : wasm.functions) {
      for (auto pair : func->expressionLocations) {
        add(pair.first, pair.second);
      }
      for (auto pair : func->delimiterLocations) {
        add(pair.first, pair.second);
      }
    }
  }

  Expression* getStart(BinaryLocation addr) const {
    auto iter = startMap.find(addr);
    if (iter != startMap.end()) {
      return iter->second;
    }
    return nullptr;
  }

  Expression* getEnd(BinaryLocation addr) const {
    auto iter = endMap.find(addr);
    if (iter != endMap.end()) {
      return iter->second;
    }
    return nullptr;
  }

  ExtraInfo getExtra(BinaryLocation addr) const {
    auto iter = extraMap.find(addr);
    if (iter != extraMap.end()) {
      return iter->second;
    }
    return ExtraInfo{nullptr, BinaryLocations::Invalid};
  }

private:
  void add(Expression* expr, const BinaryLocations::Span span) {
    assert(startMap.count(span.start) == 0);
    startMap[span.start] = expr;
    assert(endMap.count(span.end) == 0);
    endMap[span.end] = expr;
  }

  void add(Expression* expr, const BinaryLocations::DelimiterLocations& extra) {
    for (Index i = 0; i < extra.size(); i++) {
      if (extra[i] != 0) {
        assert(extraMap.count(extra[i]) == 0);
        extraMap[extra[i]] = ExtraInfo{expr, BinaryLocations::DelimiterId(i)};
      }
    }
  }
};

// Represents a mapping of addresses to expressions. As with expressions, we
// track both start and end; here, however, "start" means the "start" and
// "declarations" fields in FunctionLocations, and "end" means the two locations
// of one past the end, and one before it which is the "end" opcode that is
// emitted.
struct FuncAddrMap {
  std::unordered_map<BinaryLocation, Function*> startMap, endMap;

  // Construct the map from the binaryLocations loaded from the wasm.
  FuncAddrMap(const Module& wasm) {
    for (auto& func : wasm.functions) {
      startMap[func->funcLocation.start] = func.get();
      startMap[func->funcLocation.declarations] = func.get();
      endMap[func->funcLocation.end - 1] = func.get();
      endMap[func->funcLocation.end] = func.get();
    }
  }

  Function* getStart(BinaryLocation addr) const {
    auto iter = startMap.find(addr);
    if (iter != startMap.end()) {
      return iter->second;
    }
    return nullptr;
  }

  Function* getEnd(BinaryLocation addr) const {
    auto iter = endMap.find(addr);
    if (iter != endMap.end()) {
      return iter->second;
    }
    return nullptr;
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
  FuncAddrMap oldFuncAddrMap;

  // TODO: for memory efficiency, we may want to do this in a streaming manner,
  //       binary to binary, without YAML IR.

  LocationUpdater(Module& wasm, const BinaryLocations& newLocations)
    : wasm(wasm), newLocations(newLocations), oldExprAddrMap(wasm),
      oldFuncAddrMap(wasm) {}

  // Updates an expression's address. If there was never an instruction at that
  // address, or if there was but if that instruction no longer exists, return
  // 0. Otherwise, return the new updated location.
  BinaryLocation getNewExprAddr(BinaryLocation oldAddr) const {
    if (auto* expr = oldExprAddrMap.getStart(oldAddr)) {
      auto iter = newLocations.expressions.find(expr);
      if (iter != newLocations.expressions.end()) {
        BinaryLocation newAddr = iter->second.start;
        return newAddr;
      }
    }
    return 0;
  }

  bool hasOldExprStartAddr(BinaryLocation oldAddr) const {
    return oldExprAddrMap.getStart(oldAddr);
  }

  BinaryLocation getNewExprEndAddr(BinaryLocation oldAddr) const {
    if (auto* expr = oldExprAddrMap.getEnd(oldAddr)) {
      auto iter = newLocations.expressions.find(expr);
      if (iter != newLocations.expressions.end()) {
        return iter->second.end;
      }
    }
    return 0;
  }

  bool hasOldExprEndAddr(BinaryLocation oldAddr) const {
    return oldExprAddrMap.getEnd(oldAddr);
  }

  BinaryLocation getNewFuncStartAddr(BinaryLocation oldAddr) const {
    if (auto* func = oldFuncAddrMap.getStart(oldAddr)) {
      // The function might have been optimized away, check.
      auto iter = newLocations.functions.find(func);
      if (iter != newLocations.functions.end()) {
        auto oldLocations = func->funcLocation;
        auto newLocations = iter->second;
        if (oldAddr == oldLocations.start) {
          return newLocations.start;
        } else if (oldAddr == oldLocations.declarations) {
          return newLocations.declarations;
        } else {
          WASM_UNREACHABLE("invalid func start");
        }
      }
    }
    return 0;
  }

  bool hasOldFuncStartAddr(BinaryLocation oldAddr) const {
    return oldFuncAddrMap.getStart(oldAddr);
  }

  BinaryLocation getNewFuncEndAddr(BinaryLocation oldAddr) const {
    if (auto* func = oldFuncAddrMap.getEnd(oldAddr)) {
      // The function might have been optimized away, check.
      auto iter = newLocations.functions.find(func);
      if (iter != newLocations.functions.end()) {
        auto oldLocations = func->funcLocation;
        auto newLocations = iter->second;
        if (oldAddr == oldLocations.end) {
          return newLocations.end;
        } else if (oldAddr == oldLocations.end - 1) {
          return newLocations.end - 1;
        } else {
          WASM_UNREACHABLE("invalid func end");
        }
      }
    }
    return 0;
  }

  // Check for either the end opcode, or one past the end.
  bool hasOldFuncEndAddr(BinaryLocation oldAddr) const {
    return oldFuncAddrMap.getEnd(oldAddr);
  }

  // Check specifically for the end opcode.
  bool hasOldFuncEndOpcodeAddr(BinaryLocation oldAddr) const {
    if (auto* func = oldFuncAddrMap.getEnd(oldAddr)) {
      return oldAddr == func->funcLocation.end - 1;
    }
    return false;
  }

  BinaryLocation getNewExtraAddr(BinaryLocation oldAddr) const {
    auto info = oldExprAddrMap.getExtra(oldAddr);
    if (info.expr) {
      auto iter = newLocations.delimiters.find(info.expr);
      if (iter != newLocations.delimiters.end()) {
        return iter->second[info.id];
      }
    }
    return 0;
  }

  bool hasOldExtraAddr(BinaryLocation oldAddr) const {
    return oldExprAddrMap.getExtra(oldAddr).expr;
  }

  // getNewStart|EndAddr utilities.
  // TODO: should we track the start and end of delimiters, even though they
  //       are just one byte?
  BinaryLocation getNewStartAddr(BinaryLocation oldStart) const {
    if (hasOldExprStartAddr(oldStart)) {
      return getNewExprAddr(oldStart);
    } else if (hasOldFuncStartAddr(oldStart)) {
      return getNewFuncStartAddr(oldStart);
    } else if (hasOldExtraAddr(oldStart)) {
      return getNewExtraAddr(oldStart);
    }
    return 0;
  }

  BinaryLocation getNewEndAddr(BinaryLocation oldEnd) const {
    if (hasOldExprEndAddr(oldEnd)) {
      return getNewExprEndAddr(oldEnd);
    } else if (hasOldFuncEndAddr(oldEnd)) {
      return getNewFuncEndAddr(oldEnd);
    } else if (hasOldExtraAddr(oldEnd)) {
      return getNewExtraAddr(oldEnd);
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
    std::vector<BinaryLocation> newAddrs;
    std::unordered_map<BinaryLocation, LineState> newAddrInfo;
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
        BinaryLocation oldAddr = state.addr;
        BinaryLocation newAddr = 0;
        if (locationUpdater.hasOldExprStartAddr(oldAddr)) {
          newAddr = locationUpdater.getNewExprAddr(oldAddr);
        }
        // Test for a function's end address first, as LLVM output appears to
        // use 1-past-the-end-of-the-function as a location in that function,
        // and not the next (but the first byte of the next function, which is
        // ambiguously identical to that value, is used at least in low_pc).
        else if (locationUpdater.hasOldFuncEndAddr(oldAddr)) {
          newAddr = locationUpdater.getNewFuncEndAddr(oldAddr);
        } else if (locationUpdater.hasOldFuncStartAddr(oldAddr)) {
          newAddr = locationUpdater.getNewFuncStartAddr(oldAddr);
        } else if (locationUpdater.hasOldExtraAddr(oldAddr)) {
          newAddr = locationUpdater.getNewExtraAddr(oldAddr);
        }
        if (newAddr) {
          // LLVM sometimes emits the same address more than once. We should
          // probably investigate that.
          if (newAddrInfo.count(newAddr)) {
            continue;
          }
          newAddrs.push_back(newAddr);
          newAddrInfo.emplace(newAddr, state);
          auto& updatedState = newAddrInfo.at(newAddr);
          // The only difference is the address TODO other stuff?
          updatedState.addr = newAddr;
          // Reset relevant state.
          state.resetAfterLine();
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
      for (BinaryLocation addr : newAddrs) {
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

static void updateDIE(const llvm::DWARFDebugInfoEntry& DIE,
                      llvm::DWARFYAML::Entry& yamlEntry,
                      const llvm::DWARFAbbreviationDeclaration* abbrevDecl,
                      const LocationUpdater& locationUpdater) {
  auto tag = DIE.getTag();
  // Pairs of low/high_pc require some special handling, as the high
  // may be an offset relative to the low. First, process the low_pcs.
  BinaryLocation oldLowPC = 0, newLowPC = 0;
  iterContextAndYAML(
    abbrevDecl->attributes(),
    yamlEntry.Values,
    [&](const llvm::DWARFAbbreviationDeclaration::AttributeSpec& attrSpec,
        llvm::DWARFYAML::FormValue& yamlValue) {
      auto attr = attrSpec.Attr;
      if (attr != llvm::dwarf::DW_AT_low_pc) {
        return;
      }
      BinaryLocation oldValue = yamlValue.Value, newValue = 0;
      if (tag == llvm::dwarf::DW_TAG_GNU_call_site ||
          tag == llvm::dwarf::DW_TAG_inlined_subroutine ||
          tag == llvm::dwarf::DW_TAG_lexical_block ||
          tag == llvm::dwarf::DW_TAG_label) {
        newValue = locationUpdater.getNewExprAddr(oldValue);
      } else if (tag == llvm::dwarf::DW_TAG_compile_unit ||
                 tag == llvm::dwarf::DW_TAG_subprogram) {
        newValue = locationUpdater.getNewFuncStartAddr(oldValue);
      } else {
        Fatal() << "unknown tag with low_pc "
                << llvm::dwarf::TagString(tag).str();
      }
      oldLowPC = oldValue;
      newLowPC = newValue;
      yamlValue.Value = newValue;
    });
  // Next, process the high_pcs.
  // TODO: do this more efficiently, without a second traversal (but that's a
  //       little tricky given the special double-traversal we have).
  iterContextAndYAML(
    abbrevDecl->attributes(),
    yamlEntry.Values,
    [&](const llvm::DWARFAbbreviationDeclaration::AttributeSpec& attrSpec,
        llvm::DWARFYAML::FormValue& yamlValue) {
      auto attr = attrSpec.Attr;
      if (attr != llvm::dwarf::DW_AT_high_pc) {
        return;
      }
      BinaryLocation oldValue = yamlValue.Value, newValue = 0;
      bool isRelative = attrSpec.Form == llvm::dwarf::DW_FORM_data4;
      if (isRelative) {
        oldValue += oldLowPC;
      }
      if (tag == llvm::dwarf::DW_TAG_GNU_call_site ||
          tag == llvm::dwarf::DW_TAG_inlined_subroutine ||
          tag == llvm::dwarf::DW_TAG_lexical_block ||
          tag == llvm::dwarf::DW_TAG_label) {
        newValue = locationUpdater.getNewExprEndAddr(oldValue);
      } else if (tag == llvm::dwarf::DW_TAG_compile_unit ||
                 tag == llvm::dwarf::DW_TAG_subprogram) {
        newValue = locationUpdater.getNewFuncEndAddr(oldValue);
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

static void updateRanges(llvm::DWARFYAML::Data& yaml,
                         const LocationUpdater& locationUpdater) {
  // In each range section, try to update the start and end. If we no longer
  // have something to map them to, we must skip that part.
  size_t skip = 0;
  for (size_t i = 0; i < yaml.Ranges.size(); i++) {
    auto& range = yaml.Ranges[i];
    BinaryLocation oldStart = range.Start, oldEnd = range.End, newStart = 0,
                   newEnd = 0;
    // If this was not an end marker, try to find what it should be updated to.
    if (oldStart != 0 && oldEnd != 0) {
      newStart = locationUpdater.getNewStartAddr(oldStart);
      newEnd = locationUpdater.getNewEndAddr(oldEnd);
      if (newStart == 0 || newEnd == 0) {
        // This part of the range no longer has a mapping, so we must skip it.
        skip++;
        continue;
      }
      // The range start and end markers have been preserved. However, TODO
      // instructions in the middle may have moved around, making the range no
      // longer contiguous, we should check that, and possibly split/merge
      // the range. Or, we may need to have tracking in the IR for this.
    } else {
      // This was not a valid range in the old binary. It was either two 0's
      // (an end marker) or an invalid value that should be ignored. Either way,
      // write an end marker and finish the current section of ranges, filling
      // it out to the original size (we must fill it out as indexes into
      // the ranges section are not updated - we could update them and then
      // pack the section, as an optimization TODO).
      while (skip) {
        auto& writtenRange = yaml.Ranges[i - skip];
        writtenRange.Start = writtenRange.End = 0;
        skip--;
      }
    }
    auto& writtenRange = yaml.Ranges[i - skip];
    writtenRange.Start = newStart;
    writtenRange.End = newEnd;
  }
}

// A location that is ignoreable, i.e., not a special value like 0 or -1 (which
// would indicate an end or a base in .debug_loc).
static const BinaryLocation IGNOREABLE_LOCATION = 1;

// Update the .debug_loc section.
static void updateLoc(llvm::DWARFYAML::Data& yaml,
                      const LocationUpdater& locationUpdater) {
  // Similar to ranges, try to update the start and end. Note that here we
  // can't skip since the location description is a variable number of bytes,
  // so we mark no longer valid addresses as empty.
  // Locations have an optional base.
  BinaryLocation base = 0;
  for (size_t i = 0; i < yaml.Locs.size(); i++) {
    auto& loc = yaml.Locs[i];
    BinaryLocation newStart = loc.Start, newEnd = loc.End;
    if (newStart == BinaryLocation(-1)) {
      // This is a new base.
      // Note that the base is not the address of an instruction, necessarily -
      // it's just a number (seems like it could always be an instruction, but
      // that's not what LLVM emits).
      base = newEnd;
    } else if (newStart == 0 && newEnd == 0) {
      // This is an end marker, this list is done.
      base = 0;
    } else {
      // This is a normal entry, try to find what it should be updated to. First
      // relativize it to the base.
      newStart = locationUpdater.getNewStartAddr(loc.Start + base);
      newEnd = locationUpdater.getNewEndAddr(loc.End + base);
      if (newStart == 0 || newEnd == 0) {
        // This part of the loc no longer has a mapping, so we must ignore it.
        newStart = newEnd = IGNOREABLE_LOCATION;
      } else {
        // Finally, de-relativize it to the base.
        newStart -= base;
        newEnd -= base;
      }
      // The loc start and end markers have been preserved. However, TODO
      // instructions in the middle may have moved around, making the loc no
      // longer contiguous, we should check that, and possibly split/merge
      // the loc. Or, we may need to have tracking in the IR for this.
    }
    loc.Start = newStart;
    loc.End = newEnd;
    // Note how the ".Location" field is unchanged.
  }
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

  updateRanges(data, locationUpdater);

  updateLoc(data, locationUpdater);

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
