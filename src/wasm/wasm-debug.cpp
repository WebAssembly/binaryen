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

namespace wasm::Debug {

bool isDWARFSection(Name name) { return name.startsWith(".debug_"); }

bool hasDWARFSections(const Module& wasm) {
  for (auto& section : wasm.customSections) {
    if (isDWARFSection(section.name)) {
      return true;
    }
  }
  return false;
}

#ifdef BUILD_LLVM_DWARF

// In wasm32 the address size is 32 bits.
static const size_t AddressSize = 4;

struct BinaryenDWARFInfo {
  llvm::StringMap<std::unique_ptr<llvm::MemoryBuffer>> sections;
  std::unique_ptr<llvm::DWARFContext> context;

  BinaryenDWARFInfo(const Module& wasm) {
    // Get debug sections from the wasm.
    for (auto& section : wasm.customSections) {
      if (Name(section.name).startsWith(".debug_") && section.data.data()) {
        // TODO: efficiency
        sections[section.name.substr(1)] = llvm::MemoryBuffer::getMemBufferCopy(
          llvm::StringRef(section.data.data(), section.data.size()));
      }
    }
    // Parse debug sections.
    uint8_t addrSize = AddressSize;
    bool isLittleEndian = true;
    context = llvm::DWARFContext::create(sections, addrSize, isLittleEndian);
    if (context->getMaxVersion() > 4) {
      std::cerr << "warning: unsupported DWARF version ("
                << context->getMaxVersion() << ")\n";
    }
  }
};

void dumpDWARF(const Module& wasm) {
  BinaryenDWARFInfo info(wasm);
  std::cout << "DWARF debug info\n";
  std::cout << "================\n\n";
  for (auto& section : wasm.customSections) {
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

bool shouldPreserveDWARF(PassOptions& options, Module& wasm) {
  return options.debugInfo && hasDWARFSections(wasm);
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
  // Each instruction is part of a sequence, all of which get the same ID. The
  // order within a sequence may change if binaryen reorders things, which means
  // that we can't track the end_sequence location and assume it is at the end -
  // we must track sequences and then emit an end for each one.
  // -1 is an invalid marker value (note that this assumes we can fit all ids
  // into just under 32 bits).
  uint32_t sequenceId = -1;

  LineState(const LineState& other) = default;
  LineState(const llvm::DWARFYAML::LineTable& table, uint32_t sequenceId)
    : isStmt(table.DefaultIsStmt), sequenceId(sequenceId) {}

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
            std::cerr << "warning: unknown subopcode " << opcode.SubOpcode
                      << " (this may be an unsupported version of DWARF)\n";
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
        if (table.MinInstLength != 1) {
          std::cerr << "warning: bad MinInstLength "
                       "(this may be an unsupported DWARF version)";
        }
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
                const llvm::DWARFYAML::LineTable& table,
                bool endSequence) const {
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
      // In wasm32 we have 32-bit addresses, and the delta here might be
      // negative (note that SData is 64-bit, as LLVM supports 64-bit
      // addresses too).
      item.SData = int32_t(line - old.line);
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
    if (prologueEnd) {
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
      } else {
        newOpcodes.push_back(makeItem(llvm::dwarf::DW_LNS_copy));
      }
    }
  }

  // Some flags are automatically reset after each debug line.
  void resetAfterLine() { prologueEnd = false; }

private:
  llvm::DWARFYAML::LineTableOpcode
  makeItem(llvm::dwarf::LineNumberOps opcode) const {
    llvm::DWARFYAML::LineTableOpcode item = {};
    item.Opcode = opcode;
    return item;
  }

  llvm::DWARFYAML::LineTableOpcode
  makeItem(llvm::dwarf::LineNumberExtendedOps opcode, uint64_t len) const {
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

  // Some instructions have delimiter binary locations, like the else and end in
  // and if. Track those separately, including their expression and their id
  // ("else", "end", etc.), as they are rare, and we don't want to
  // bloat the common case which is represented in the earlier maps.
  struct DelimiterInfo {
    Expression* expr;
    size_t id;
  };
  std::unordered_map<BinaryLocation, DelimiterInfo> delimiterMap;

  // Construct the map from the binaryLocations loaded from the wasm.
  AddrExprMap(const Module& wasm) {
    for (auto& func : wasm.functions) {
      for (auto& [expr, span] : func->expressionLocations) {
        add(expr, span);
      }
      for (auto& [expr, delim] : func->delimiterLocations) {
        add(expr, delim);
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

  DelimiterInfo getDelimiter(BinaryLocation addr) const {
    auto iter = delimiterMap.find(addr);
    if (iter != delimiterMap.end()) {
      return iter->second;
    }
    return DelimiterInfo{nullptr, BinaryLocations::Invalid};
  }

private:
  void add(Expression* expr, const BinaryLocations::Span span) {
    assert(startMap.count(span.start) == 0);
    startMap[span.start] = expr;
    assert(endMap.count(span.end) == 0);
    endMap[span.end] = expr;
  }

  void add(Expression* expr,
           const BinaryLocations::DelimiterLocations& delimiter) {
    for (Index i = 0; i < delimiter.size(); i++) {
      if (delimiter[i] != 0) {
        assert(delimiterMap.count(delimiter[i]) == 0);
        delimiterMap[delimiter[i]] = DelimiterInfo{expr, i};
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

  // Map offsets of location list entries in the debug_loc section to the index
  // of their compile unit.
  std::unordered_map<BinaryLocation, size_t> locToUnitMap;

  // Map start of line tables in the debug_line section to their new locations.
  std::unordered_map<BinaryLocation, BinaryLocation> debugLineMap;

  using OldToNew = std::pair<BinaryLocation, BinaryLocation>;

  // Map of compile unit index => old and new base offsets (i.e., in the
  // original binary and in the new one).
  std::unordered_map<size_t, OldToNew> compileUnitBases;

  // TODO: for memory efficiency, we may want to do this in a streaming manner,
  //       binary to binary, without YAML IR.

  LocationUpdater(Module& wasm, const BinaryLocations& newLocations)
    : wasm(wasm), newLocations(newLocations), oldExprAddrMap(wasm),
      oldFuncAddrMap(wasm) {}

  // Updates an expression's address. If there was never an instruction at that
  // address, or if there was but if that instruction no longer exists, return
  // 0. Otherwise, return the new updated location.
  BinaryLocation getNewExprStart(BinaryLocation oldAddr) const {
    if (auto* expr = oldExprAddrMap.getStart(oldAddr)) {
      auto iter = newLocations.expressions.find(expr);
      if (iter != newLocations.expressions.end()) {
        BinaryLocation newAddr = iter->second.start;
        return newAddr;
      }
    }
    return 0;
  }

  bool hasOldExprStart(BinaryLocation oldAddr) const {
    return oldExprAddrMap.getStart(oldAddr);
  }

  BinaryLocation getNewExprEnd(BinaryLocation oldAddr) const {
    if (auto* expr = oldExprAddrMap.getEnd(oldAddr)) {
      auto iter = newLocations.expressions.find(expr);
      if (iter != newLocations.expressions.end()) {
        return iter->second.end;
      }
    }
    return 0;
  }

  bool hasOldExprEnd(BinaryLocation oldAddr) const {
    return oldExprAddrMap.getEnd(oldAddr);
  }

  BinaryLocation getNewFuncStart(BinaryLocation oldAddr) const {
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

  bool hasOldFuncStart(BinaryLocation oldAddr) const {
    return oldFuncAddrMap.getStart(oldAddr);
  }

  BinaryLocation getNewFuncEnd(BinaryLocation oldAddr) const {
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
  bool hasOldFuncEnd(BinaryLocation oldAddr) const {
    return oldFuncAddrMap.getEnd(oldAddr);
  }

  // Check specifically for the end opcode.
  bool hasOldFuncEndOpcode(BinaryLocation oldAddr) const {
    if (auto* func = oldFuncAddrMap.getEnd(oldAddr)) {
      return oldAddr == func->funcLocation.end - 1;
    }
    return false;
  }

  BinaryLocation getNewDelimiter(BinaryLocation oldAddr) const {
    auto info = oldExprAddrMap.getDelimiter(oldAddr);
    if (info.expr) {
      auto iter = newLocations.delimiters.find(info.expr);
      if (iter != newLocations.delimiters.end()) {
        return iter->second[info.id];
      }
    }
    return 0;
  }

  bool hasOldDelimiter(BinaryLocation oldAddr) const {
    return oldExprAddrMap.getDelimiter(oldAddr).expr;
  }

  // getNewStart|EndAddr utilities.
  // TODO: should we track the start and end of delimiters, even though they
  //       are just one byte?
  BinaryLocation getNewStart(BinaryLocation oldStart) const {
    if (hasOldExprStart(oldStart)) {
      return getNewExprStart(oldStart);
    } else if (hasOldFuncStart(oldStart)) {
      return getNewFuncStart(oldStart);
    } else if (hasOldDelimiter(oldStart)) {
      return getNewDelimiter(oldStart);
    }
    return 0;
  }

  BinaryLocation getNewEnd(BinaryLocation oldEnd) const {
    if (hasOldExprEnd(oldEnd)) {
      return getNewExprEnd(oldEnd);
    } else if (hasOldFuncEnd(oldEnd)) {
      return getNewFuncEnd(oldEnd);
    } else if (hasOldDelimiter(oldEnd)) {
      return getNewDelimiter(oldEnd);
    }
    return 0;
  }

  BinaryLocation getNewDebugLineLocation(BinaryLocation old) const {
    return debugLineMap.at(old);
  }

  // Given an offset in .debug_loc, get the old and new compile unit bases.
  OldToNew getCompileUnitBasesForLoc(size_t offset) const {
    if (locToUnitMap.count(offset) == 0) {
      // There is no compile unit for this loc. It doesn't matter what we set
      // here.
      return OldToNew{0, 0};
    }
    auto index = locToUnitMap.at(offset);
    auto iter = compileUnitBases.find(index);
    if (iter != compileUnitBases.end()) {
      return iter->second;
    }
    return OldToNew{0, 0};
  }
};

// A tombstone value is a value that is placed where something used to exist,
// but no longer does, like a reference to a function that was DCE'd out during
// linking. In theory the value can be any invalid location, and tools will
// basically ignore it.
// Earlier LLVM used to use 0 there, and newer versions use -1 or -2 depending
// on the DWARF section. For now, support them all, but TODO stop supporting 0,
// as there are apparently some possible corner cases where 0 is a valid value.
static bool isTombstone(uint32_t x) {
  return x == 0 || x == uint32_t(-1) || x == uint32_t(-2);
}

// Update debug lines, and update the locationUpdater with debug line offset
// changes so we can update offsets into the debug line section.
static void updateDebugLines(llvm::DWARFYAML::Data& data,
                             LocationUpdater& locationUpdater) {
  for (auto& table : data.DebugLines) {
    uint32_t sequenceId = 0;
    // Parse the original opcodes and emit new ones.
    LineState state(table, sequenceId);
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
        if (isTombstone(state.addr)) {
          omittingRange = true;
        }
        if (omittingRange) {
          state = LineState(table, sequenceId);
          continue;
        }
        // An expression may not exist for this line table item, if we optimized
        // it away.
        BinaryLocation oldAddr = state.addr;
        BinaryLocation newAddr = 0;
        if (locationUpdater.hasOldExprStart(oldAddr)) {
          newAddr = locationUpdater.getNewExprStart(oldAddr);
        }
        // Test for a function's end address first, as LLVM output appears to
        // use 1-past-the-end-of-the-function as a location in that function,
        // and not the next (but the first byte of the next function, which is
        // ambiguously identical to that value, is used at least in low_pc).
        else if (locationUpdater.hasOldFuncEnd(oldAddr)) {
          newAddr = locationUpdater.getNewFuncEnd(oldAddr);
        } else if (locationUpdater.hasOldFuncStart(oldAddr)) {
          newAddr = locationUpdater.getNewFuncStart(oldAddr);
        } else if (locationUpdater.hasOldDelimiter(oldAddr)) {
          newAddr = locationUpdater.getNewDelimiter(oldAddr);
        } else if (locationUpdater.hasOldExprEnd(oldAddr)) {
          newAddr = locationUpdater.getNewExprEnd(oldAddr);
        }
        if (newAddr && state.needToEmit()) {
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
          sequenceId++;
          // We assume the number of sequences can fit in 32 bits, and -1 is
          // an invalid value.
          assert(sequenceId != uint32_t(-1));
          state = LineState(table, sequenceId);
        }
      }
    }
    // Sort the new addresses (which may be substantially different from the
    // original layout after optimization).
    std::sort(newAddrs.begin(), newAddrs.end());
    // Emit a new line table.
    {
      std::vector<llvm::DWARFYAML::LineTableOpcode> newOpcodes;
      for (size_t i = 0; i < newAddrs.size(); i++) {
        LineState state = newAddrInfo.at(newAddrs[i]);
        assert(state.needToEmit());
        LineState lastState(table, -1);
        if (i != 0) {
          lastState = newAddrInfo.at(newAddrs[i - 1]);
          // If the last line is in another sequence, clear the old state, as
          // there is nothing to diff to.
          if (lastState.sequenceId != state.sequenceId) {
            lastState = LineState(table, -1);
          }
        }
        // This line ends a sequence if there is no next line after it, or if
        // the next line is in a different sequence.
        bool endSequence =
          i + 1 == newAddrs.size() ||
          newAddrInfo.at(newAddrs[i + 1]).sequenceId != state.sequenceId;
        state.emitDiff(lastState, newOpcodes, table, endSequence);
      }
      table.Opcodes.swap(newOpcodes);
    }
  }
  // After updating the contents, run the emitter in order to update the
  // lengths of each section. We will use that to update offsets into the
  // debug_line section.
  std::vector<size_t> computedLengths;
  llvm::DWARFYAML::ComputeDebugLine(data, computedLengths);
  BinaryLocation newLocation = 0;
  for (size_t i = 0; i < data.DebugLines.size(); i++) {
    auto& table = data.DebugLines[i];
    auto oldLocation = table.Position;
    locationUpdater.debugLineMap[oldLocation] = newLocation;
    table.Position = newLocation;
    newLocation += computedLengths[i] + AddressSize;
    table.Length.setLength(computedLengths[i]);
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

// Updates a YAML entry from a DWARF DIE. Also updates LocationUpdater
// associating each .debug_loc entry with the base address of its corresponding
// compilation unit.
static void updateDIE(const llvm::DWARFDebugInfoEntry& DIE,
                      llvm::DWARFYAML::Entry& yamlEntry,
                      const llvm::DWARFAbbreviationDeclaration* abbrevDecl,
                      LocationUpdater& locationUpdater,
                      size_t compileUnitIndex) {
  auto tag = DIE.getTag();
  // Pairs of low/high_pc require some special handling, as the high
  // may be an offset relative to the low. First, process everything but
  // the high pcs, so we see the low pcs first.
  BinaryLocation oldLowPC = 0, newLowPC = 0;
  iterContextAndYAML(
    abbrevDecl->attributes(),
    yamlEntry.Values,
    [&](const llvm::DWARFAbbreviationDeclaration::AttributeSpec& attrSpec,
        llvm::DWARFYAML::FormValue& yamlValue) {
      auto attr = attrSpec.Attr;
      if (attr == llvm::dwarf::DW_AT_low_pc) {
        // This is an address.
        BinaryLocation oldValue = yamlValue.Value, newValue = 0;
        if (tag == llvm::dwarf::DW_TAG_GNU_call_site ||
            tag == llvm::dwarf::DW_TAG_inlined_subroutine ||
            tag == llvm::dwarf::DW_TAG_lexical_block ||
            tag == llvm::dwarf::DW_TAG_label) {
          newValue = locationUpdater.getNewStart(oldValue);
        } else if (tag == llvm::dwarf::DW_TAG_compile_unit) {
          newValue = locationUpdater.getNewFuncStart(oldValue);
          // Per the DWARF spec, "The base address of a compile unit is
          // defined as the value of the DW_AT_low_pc attribute, if present."
          locationUpdater.compileUnitBases[compileUnitIndex] =
            LocationUpdater::OldToNew{oldValue, newValue};
        } else if (tag == llvm::dwarf::DW_TAG_subprogram) {
          newValue = locationUpdater.getNewFuncStart(oldValue);
        } else {
          Fatal() << "unknown tag with low_pc "
                  << llvm::dwarf::TagString(tag).str();
        }
        oldLowPC = oldValue;
        newLowPC = newValue;
        yamlValue.Value = newValue;
      } else if (attr == llvm::dwarf::DW_AT_stmt_list) {
        // This is an offset into the debug line section.
        yamlValue.Value =
          locationUpdater.getNewDebugLineLocation(yamlValue.Value);
      } else if (attr == llvm::dwarf::DW_AT_location &&
                 attrSpec.Form == llvm::dwarf::DW_FORM_sec_offset) {
        BinaryLocation locOffset = yamlValue.Value;
        locationUpdater.locToUnitMap[locOffset] = compileUnitIndex;
      }
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
        newValue = locationUpdater.getNewExprEnd(oldValue);
      } else if (tag == llvm::dwarf::DW_TAG_compile_unit ||
                 tag == llvm::dwarf::DW_TAG_subprogram) {
        newValue = locationUpdater.getNewFuncEnd(oldValue);
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
                               LocationUpdater& locationUpdater,
                               bool is64) {
  // The context has the high-level information we need, and the YAML is where
  // we write changes. First, iterate over the compile units.
  size_t compileUnitIndex = 0;
  iterContextAndYAML(
    info.context->compile_units(),
    yaml.CompileUnits,
    [&](const std::unique_ptr<llvm::DWARFUnit>& CU,
        llvm::DWARFYAML::Unit& yamlUnit) {
      // Our Memory64Lowering pass may change the "architecture" of the DWARF
      // data. AddrSize will cause all DW_AT_low_pc to be written as 32/64-bit.
      auto NewAddrSize = is64 ? 8 : 4;
      if (NewAddrSize != yamlUnit.AddrSize) {
        yamlUnit.AddrSize = NewAddrSize;
        yamlUnit.AddrSizeChanged = true;
      }
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
            updateDIE(
              DIE, yamlEntry, abbrevDecl, locationUpdater, compileUnitIndex);
          }
        });
      compileUnitIndex++;
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
    // If this is an end marker (0, 0), or an invalid range (0, x) or (x, 0)
    // then just emit it as it is - either to mark the end, or to mark an
    // invalid entry.
    if (isTombstone(oldStart) || isTombstone(oldEnd)) {
      newStart = oldStart;
      newEnd = oldEnd;
    } else {
      // This was a valid entry; update it.
      newStart = locationUpdater.getNewStart(oldStart);
      newEnd = locationUpdater.getNewEnd(oldEnd);
      if (isTombstone(newStart) || isTombstone(newEnd)) {
        // This part of the range no longer has a mapping, so we must skip it.
        // Don't use (0, 0) as that would be an end marker; emit something
        // invalid for the debugger to ignore.
        newStart = 0;
        newEnd = 1;
      }
      // TODO even if range start and end markers have been preserved,
      // instructions in the middle may have moved around, making the range no
      // longer contiguous. We should check that, and possibly split/merge
      // the range. Or, we may need to have tracking in the IR for this.
    }
    auto& writtenRange = yaml.Ranges[i - skip];
    writtenRange.Start = newStart;
    writtenRange.End = newEnd;
  }
}

// A location that is ignoreable, i.e., not a special value like 0 or -1 (which
// would indicate an end or a base in .debug_loc).
static const BinaryLocation IGNOREABLE_LOCATION = 1;

static bool isNewBaseLoc(const llvm::DWARFYAML::Loc& loc) {
  return loc.Start == BinaryLocation(-1);
}

static bool isEndMarkerLoc(const llvm::DWARFYAML::Loc& loc) {
  return isTombstone(loc.Start) && isTombstone(loc.End);
}

// Update the .debug_loc section.
static void updateLoc(llvm::DWARFYAML::Data& yaml,
                      const LocationUpdater& locationUpdater) {
  // Similar to ranges, try to update the start and end. Note that here we
  // can't skip since the location description is a variable number of bytes,
  // so we mark no longer valid addresses as empty.
  bool atStart = true;
  // We need to keep positions in the .debug_loc section identical to before
  // (or else we'd need to update their positions too) and so we need to keep
  // base entries around (a base entry is added to every entry after it in the
  // list). However, we may change the base's value as after moving instructions
  // around the old base may not be smaller than all the values relative to it.
  BinaryLocation oldBase, newBase;
  auto& locs = yaml.Locs;
  for (size_t i = 0; i < locs.size(); i++) {
    auto& loc = locs[i];
    if (atStart) {
      std::tie(oldBase, newBase) =
        locationUpdater.getCompileUnitBasesForLoc(loc.CompileUnitOffset);
      atStart = false;
    }
    // By default we copy values over, unless we modify them below.
    BinaryLocation newStart = loc.Start, newEnd = loc.End;
    if (isNewBaseLoc(loc)) {
      // This is a new base.
      // Note that the base is not the address of an instruction, necessarily -
      // it's just a number (seems like it could always be an instruction, but
      // that's not what LLVM emits).
      // We must look forward at everything relative to this base, so that we
      // can emit a new proper base (as mentioned earlier, the original base may
      // not be valid if instructions moved to a position before it - they must
      // be positive offsets from it).
      oldBase = newBase = newEnd;
      BinaryLocation smallest = -1;
      for (size_t j = i + 1; j < locs.size(); j++) {
        auto& futureLoc = locs[j];
        if (isNewBaseLoc(futureLoc) || isEndMarkerLoc(futureLoc)) {
          break;
        }
        auto updatedStart =
          locationUpdater.getNewStart(futureLoc.Start + oldBase);
        // If we found a valid mapping, this is a relevant value for us. If the
        // optimizer removed it, it's a 0, and we can ignore it here - we will
        // emit IGNOREABLE_LOCATION for it later anyhow.
        if (updatedStart != 0) {
          smallest = std::min(smallest, updatedStart);
        }
      }
      // If we found no valid values that will be relativized here, just use 0
      // as the new (never-to-be-used) base, which is less confusing (otherwise
      // the value looks like it means something).
      if (smallest == BinaryLocation(-1)) {
        smallest = 0;
      }
      newBase = newEnd = smallest;
    } else if (isEndMarkerLoc(loc)) {
      // This is an end marker, this list is done; reset the base.
      atStart = true;
    } else {
      // This is a normal entry, try to find what it should be updated to. First
      // de-relativize it to the base to get the absolute address, then look for
      // a new address for it.
      newStart = locationUpdater.getNewStart(loc.Start + oldBase);
      newEnd = locationUpdater.getNewEnd(loc.End + oldBase);
      if (newStart == 0 || newEnd == 0 || newStart > newEnd) {
        // This part of the loc no longer has a mapping, or after the mapping
        // it is no longer a proper span, so we must ignore it.
        newStart = newEnd = IGNOREABLE_LOCATION;
      } else {
        // We picked a new base that ensures it is smaller than the values we
        // will relativize to it.
        assert(newStart >= newBase && newEnd >= newBase);
        newStart -= newBase;
        newEnd -= newBase;
        if (newStart == 0 && newEnd == 0) {
          // After mapping to the new positions, and after relativizing to the
          // base, if we end up with (0, 0) then we must emit something else, as
          // that would be interpreted as the end of a list. As it is an empty
          // span, the actual value doesn't matter, it just has to be != 0.
          // This can happen if the very first span in a compile unit is an
          // empty span, in which case relative to the base of the compile unit
          // we would have (0, 0).
          newStart = newEnd = IGNOREABLE_LOCATION;
        }
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

  bool is64 = wasm.memories.size() > 0 ? wasm.memories[0]->is64() : false;
  updateCompileUnits(info, data, locationUpdater, is64);

  updateRanges(data, locationUpdater);

  updateLoc(data, locationUpdater);

  // Convert to binary sections.
  auto newSections =
    EmitDebugSections(data, false /* EmitFixups for debug_info */);

  // Update the custom sections in the wasm.
  // TODO: efficiency
  for (auto& section : wasm.customSections) {
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

bool shouldPreserveDWARF(PassOptions& options, Module& wasm) { return false; }

#endif // BUILD_LLVM_DWARF

} // namespace wasm::Debug
