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
    context = llvm::DWARFContext::create(sections, addrSize);
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
  // TODO uint32_t isa = 0;
  // TODO Discriminator = 0;
  bool isStmt;
  bool basicBlock = false;
  // XXX these two should be just prologue, epilogue?
  bool prologueEnd = false;
  bool epilogueBegin = false;

  LineState() = default;
  LineState(const LineState& other) = default;
  LineState(const llvm::DWARFYAML::LineTable& table)
    : isStmt(table.DefaultIsStmt) {}

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
          default: {
            Fatal() << "unknown debug line sub-opcode: " << std::hex
                    << opcode.SubOpcode;
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
      case llvm::dwarf::DW_LNS_const_add_pc: {
        uint8_t AdjustOpcode = 255 - table.OpcodeBase;
        uint64_t AddrOffset =
          (AdjustOpcode / table.LineRange) * table.MinInstLength;
        addr += AddrOffset;
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

  // Given an old state, emit the diff from it to this state into a new line
  // table.
  void emitDiff(const LineState& old,
                std::vector<llvm::DWARFYAML::LineTableOpcode>& newOpcodes,
                const llvm::DWARFYAML::LineTable& table) {
    // If any value is 0, can ignore it
    // https://github.com/WebAssembly/debugging/issues/9#issuecomment-567720872
    if (line == 0 || col == 0 || addr == 0) {
      return;
    }
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
      item.Data = col;
      newOpcodes.push_back(item);
    }
    if (isStmt != old.isStmt) {
      newOpcodes.push_back(makeItem(llvm::dwarf::DW_LNS_negate_stmt));
    }
    if (basicBlock != old.basicBlock) {
      Fatal() << "bb";
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

// Represents a mapping of addresses to expressions.
struct AddrExprMap {
  std::unordered_map<uint32_t, Expression*> map;

  // Construct the map from the binaryLocations loaded from the wasm.
  AddrExprMap(const Module& wasm) {
    for (auto& func : wasm.functions) {
      for (auto pair : func->binaryLocations) {
        assert(map.count(pair.second) == 0);
        map[pair.second] = pair.first;
      }
    }
  }

  // Construct the map from new binaryLocations just written
  AddrExprMap(const BinaryLocationsMap& newLocations) {
    for (auto pair : newLocations) {
      assert(map.count(pair.second) == 0);
      map[pair.second] = pair.first;
    }
  }

  Expression* get(uint32_t addr) {
    auto iter = map.find(addr);
    if (iter != map.end()) {
      return iter->second;
    }
    return nullptr;
  }

  void dump() {
    std::cout << "  (size: " << map.size() << ")\n";
    for (auto pair : map) {
      std::cout << "  " << pair.first << " => " << pair.second << '\n';
    }
  }
};

static void updateDebugLines(const Module& wasm,
                             llvm::DWARFYAML::Data& data,
                             const BinaryLocationsMap& newLocations) {
  // TODO: for memory efficiency, we may want to do this in a streaming manner,
  //       binary to binary, without YAML IR.

  // TODO: apparently DWARF offsets may be into the middle of instructions...
  //       we may need to track their spans too
  // https://github.com/WebAssembly/debugging/issues/9#issuecomment-567720872
  AddrExprMap oldAddrMap(wasm);
  // std::cout << "old\n";
  // oldAddrMap.dump();
  AddrExprMap newAddrMap(newLocations);
  // std::cout << "new\n";
  // newAddrMap.dump();

  for (auto& table : data.DebugLines) {
    // Parse the original opcodes and emit new ones.
    LineState state(table);
    // All the addresses we need to write out.
    std::vector<uint32_t> newAddrs;
    std::unordered_map<uint32_t, LineState> newAddrInfo;
    for (auto& opcode : table.Opcodes) {
      // Update the state, and check if we have a new row to emit.
      if (state.update(opcode, table)) {
        // An expression may not exist for this line table item, if we optimized
        // it away.
        if (auto* expr = oldAddrMap.get(state.addr)) {
          auto iter = newLocations.find(expr);
          if (iter != newLocations.end()) {
            uint32_t newAddr = iter->second;
            newAddrs.push_back(newAddr);
            auto& updatedState = newAddrInfo[newAddr] = state;
            // The only difference is the address TODO other stuff?
            updatedState.addr = newAddr;
          }
        }
        if (opcode.Opcode == 0 &&
            opcode.SubOpcode == llvm::dwarf::DW_LNE_end_sequence) {
          state = LineState(table);
        }
      }
    }
    // Sort the new addresses (which may be substantially different from the
    // original layout after optimization).
    std::sort(newAddrs.begin(), newAddrs.end(), [](uint32_t a, uint32_t b) {
      return a < b;
    });
    // Emit a new line table.
    {
      std::vector<llvm::DWARFYAML::LineTableOpcode> newOpcodes;
      LineState state(table);
      for (uint32_t addr : newAddrs) {
        LineState oldState(state);
        state = newAddrInfo[addr];
        state.emitDiff(oldState, newOpcodes, table);
      }
      table.Opcodes.swap(newOpcodes);
    }
  }
}

static void fixEmittedSection(const std::string& name,
                              std::vector<char>& data) {
  if (name == ".debug_line") {
    // The YAML code does not update the line section size. However, it is
    // trivial to do so after the fact, as the wasm section's additional size is
    // easy to compute: it is the emitted size - the 4 bytes of the size itself.
    uint32_t size = data.size() - 4;
    BufferWithRandomAccess buf;
    buf << size;
    for (int i = 0; i < 4; i++) {
      data[i] = buf[i];
    }
  }
}

void writeDWARFSections(Module& wasm, const BinaryLocationsMap& newLocations) {
  BinaryenDWARFInfo info(wasm);

  // Convert to Data representation, which YAML can use to write.
  llvm::DWARFYAML::Data data;
  if (dwarf2yaml(*info.context, data)) {
    Fatal() << "Failed to parse DWARF to YAML";
  }

  updateDebugLines(wasm, data, newLocations);

  // TODO: Actually update, and remove sections we don't know how to update yet?

  // Convert to binary sections.
  auto newSections = EmitDebugSections(data, true);

  // Update the custom sections in the wasm.
  // TODO: efficiency
  for (auto& section : wasm.userSections) {
    if (Name(section.name).startsWith(".debug_")) {
      auto llvmName = section.name.substr(1);
      if (newSections.count(llvmName)) {
        auto llvmData = newSections[llvmName]->getBuffer();
        section.data.resize(llvmData.size());
        std::copy(llvmData.begin(), llvmData.end(), section.data.data());
        fixEmittedSection(section.name, section.data);
      }
    }
  }
}

#else // BUILD_LLVM_DWARF

void dumpDWARF(const Module& wasm) {
  std::cerr << "warning: no DWARF dumping support present\n";
}

void writeDWARFSections(Module& wasm, const BinaryLocationsMap& newLocations) {
  std::cerr << "warning: no DWARF updating support present\n";
}

#endif // BUILD_LLVM_DWARF

} // namespace Debug

} // namespace wasm
