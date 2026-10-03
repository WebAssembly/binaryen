/*
 * Copyright 2026 WebAssembly Community Group participants
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

#ifndef wasm_dwarf_locals_h
#define wasm_dwarf_locals_h

#include "../../third_party/llvm-project/DWARFVisitor.h"
#include "llvm/DebugInfo/DWARF/DWARFExpression.h"
#include "llvm/Support/LEB128.h"

namespace wasm::Debug {

static bool isLocationAttribute(llvm::dwarf::Attribute attr) {
  using namespace llvm::dwarf;
  switch (attr) {
    case DW_AT_location:
    case DW_AT_frame_base:
    case DW_AT_return_addr:
    case DW_AT_static_link:
    case DW_AT_use_location:
    case DW_AT_vtable_elem_location:
    case DW_AT_string_length:
    case DW_AT_data_member_location:
      return true;
    default:
      return false;
  }
}

// ReorderLocals leaves DWARF in input coordinates, just like code addresses.
// Rewrite it once, after the writer has also mapped IR locals to binary locals.
// An index crossing a LEB boundary changes expression sizes, so both location
// list offsets and DIE references must be relocated, not just the local
// operand.
class DwarfLocalRewriter {
  using Bytes = std::vector<uint8_t>;
  using Value = llvm::DWARFYAML::FormValue;
  Module& wasm;
  llvm::DWARFYAML::Data& data;
  llvm::DWARFContext& context;
  const BinaryLocations& locations;

  struct Expression {
    Bytes input;
    Value* inlineValue;
    size_t locIndex;
    llvm::DWARFUnit* unit;
    const std::vector<Index>* indices;
  };
  struct Reference {
    Value* value;
    uint64_t target;
    uint64_t base;
    unsigned bits;
  };
  struct List {
    size_t begin, end;
    std::vector<Value*> references;
  };
  std::vector<Expression> expressions;
  std::vector<Reference> references;
  std::vector<List> lists;
  std::unordered_map<uint64_t, uint64_t> offsets;

  uint64_t relocate(uint64_t offset) const {
    auto iter = offsets.find(offset);
    return iter == offsets.end() ? offset : iter->second;
  }

  Bytes rewrite(const Bytes& input,
                llvm::DWARFUnit* unit,
                const std::vector<Index>* indices) {
    using namespace llvm::dwarf;
    llvm::DataExtractor bytes(
      llvm::ArrayRef<uint8_t>(input), true, unit->getAddressByteSize());
    Bytes output;
    std::unordered_map<uint64_t, size_t> positions;
    struct Branch {
      size_t operand;
      uint64_t target;
    };
    std::vector<Branch> branches;
    auto uleb = [&](uint64_t value) {
      uint8_t buf[10];
      auto size = llvm::encodeULEB128(value, buf);
      output.insert(output.end(), buf, buf + size);
    };
    for (uint64_t pos = 0; pos < input.size();) {
      auto start = pos;
      positions[start] = output.size();
      auto opcode = input[pos++];
      if (opcode == DW_OP_WASM_location) {
        // The Wasm convention uses an unsigned local/global/stack index;
        // selector 3 instead has a fixed-width 32-bit global index.
        auto kind = bytes.getU8(&pos);
        if (kind > 3) {
          Fatal() << "unsupported DW_OP_WASM_location selector";
        }
        auto index = kind == 3 ? bytes.getU32(&pos) : bytes.getULEB128(&pos);
        if (kind == 0 && indices) {
          if (index >= indices->size() || (*indices)[index] == Index(-1)) {
            // An empty location description means unavailable. In particular,
            // never redirect a removed local to the first surviving local.
            return {};
          }
          output.push_back(opcode);
          output.push_back(kind);
          uleb((*indices)[index]);
        } else {
          output.insert(
            output.end(), input.begin() + start, input.begin() + pos);
        }
      } else if (opcode == DW_OP_entry_value ||
                 opcode == DW_OP_GNU_entry_value) {
        auto size = bytes.getULEB128(&pos);
        if (size > input.size() - pos) {
          Fatal() << "invalid nested DWARF location expression";
        }
        auto nested =
          rewrite(Bytes(input.begin() + pos, input.begin() + pos + size),
                  unit,
                  indices);
        if (nested.empty()) {
          return {};
        }
        output.push_back(opcode);
        uleb(nested.size());
        output.insert(output.end(), nested.begin(), nested.end());
        pos += size;
      } else {
        llvm::DWARFExpression::Operation op;
        if (!op.extract(
              bytes, unit->getVersion(), unit->getAddressByteSize(), start) ||
            op.getEndOffset() > input.size()) {
          Fatal() << "cannot relocate unsupported DWARF location expression";
        }
        pos = op.getEndOffset();
        auto outStart = output.size();
        output.insert(output.end(), input.begin() + start, input.begin() + pos);
        if (opcode == DW_OP_skip || opcode == DW_OP_bra) {
          branches.push_back(
            {outStart + 1, pos + int16_t(op.getRawOperand(0))});
        } else if (opcode == DW_OP_call2 || opcode == DW_OP_call4 ||
                   opcode == DW_OP_call_ref) {
          auto base = opcode == DW_OP_call_ref ? 0 : unit->getOffset();
          auto target = relocate(base + op.getRawOperand(0)) - relocate(base);
          auto width = pos - start - 1;
          if (width < 8 && target >= (uint64_t(1) << (8 * width))) {
            Fatal() << "relocated DWARF expression reference does not fit";
          }
          for (size_t i = 0; i < width; ++i) {
            output[outStart + 1 + i] = target >> (8 * i);
          }
        }
      }
    }
    positions[input.size()] = output.size();
    for (auto [operand, target] : branches) {
      auto iter = positions.find(target);
      if (iter == positions.end()) {
        Fatal() << "invalid DWARF expression branch target";
      }
      auto delta = int64_t(iter->second) - int64_t(operand + 2);
      if (delta < INT16_MIN || delta > INT16_MAX) {
        Fatal() << "relocated DWARF expression branch does not fit";
      }
      output[operand] = uint16_t(delta);
      output[operand + 1] = uint16_t(delta) >> 8;
    }
    return output;
  }

  // Use the same visitor as the emitter to measure every form, including
  // variable-length references. Iterate only if relocation changes a width.
  struct Layout : llvm::DWARFYAML::Visitor {
    DwarfLocalRewriter& owner;
    size_t cuIndex = 0, dieIndex = 0;
    uint64_t position = 0, start = 0;
    llvm::DWARFUnit* unit = nullptr;
    std::unordered_map<uint64_t, uint64_t> offsets;

    Layout(DwarfLocalRewriter& owner)
      : llvm::DWARFYAML::Visitor(owner.data), owner(owner) {}

    void onStartCompileUnit(llvm::DWARFYAML::Unit& cu) override {
      unit = (owner.context.compile_units().begin() + cuIndex++)->get();
      offsets[unit->getOffset()] = start = position;
      position += (cu.Length.isDWARF64() ? 12 : 4) + (cu.Version >= 5 ? 8 : 7);
      dieIndex = 0;
    }
    void onStartDIE(llvm::DWARFYAML::Unit& cu,
                    llvm::DWARFYAML::Entry& die) override {
      offsets[unit->getDIEAtIndex(dieIndex++).getOffset()] = position;
      position += llvm::getULEB128Size(die.AbbrCode);
    }
    void onEndCompileUnit(llvm::DWARFYAML::Unit& cu) override {
      cu.Length.setLength(position - start - (cu.Length.isDWARF64() ? 12 : 4));
    }
    void onValue(uint8_t) override { position += 1; }
    void onValue(uint16_t) override { position += 2; }
    void onValue(uint32_t) override { position += 4; }
    void onValue(uint64_t value, bool leb) override {
      position += leb ? llvm::getULEB128Size(value) : 8;
    }
    void onValue(int64_t value, bool leb) override {
      position += leb ? llvm::getSLEB128Size(value) : 8;
    }
    void onValue(llvm::StringRef value) override {
      position += value.size() + 1;
    }
    void onValue(llvm::MemoryBufferRef value) override {
      position += value.getBufferSize();
    }
  };

public:
  DwarfLocalRewriter(Module& wasm,
                     llvm::DWARFYAML::Data& data,
                     llvm::DWARFContext& context,
                     const BinaryLocations& locations)
    : wasm(wasm), data(data), context(context), locations(locations) {}

  void run() {
    if (locations.localIndices.empty()) {
      return;
    }
    using namespace llvm::dwarf;
    struct ListUse {
      Value* value;
      llvm::DWARFUnit* unit;
      const std::vector<Index>* indices;
    };
    std::unordered_map<uint64_t, std::vector<ListUse>> listUses;
    std::vector<Function*> functions;
    for (auto& [func, indices] : locations.localIndices) {
      functions.push_back(func);
    }
    std::sort(functions.begin(), functions.end(), [](auto* a, auto* b) {
      return a->funcLocation.start < b->funcLocation.start;
    });
    size_t cuIndex = 0;
    for (auto& cu : context.compile_units()) {
      auto& yaml = data.CompileUnits[cuIndex++];
      size_t dieIndex = 0;
      std::vector<const std::vector<Index>*> scopes;
      for (auto& die : cu->dies()) {
        auto& entry = yaml.Entries[dieIndex++];
        auto* abbrev = die.getAbbreviationDeclarationPtr();
        if (!abbrev) {
          continue;
        }
        scopes.resize(die.getDepth());
        auto* indices = scopes.empty() ? nullptr : scopes.back();
        if (die.getTag() == DW_TAG_subprogram) {
          indices = nullptr;
          auto ranges = llvm::DWARFDie(cu.get(), &die).getAddressRanges();
          if (!ranges) {
            llvm::consumeError(ranges.takeError());
          } else {
            for (auto& range : *ranges) {
              auto iter =
                std::upper_bound(functions.begin(),
                                 functions.end(),
                                 range.LowPC,
                                 [](auto pc, auto* func) {
                                   return pc < func->funcLocation.start;
                                 });
              if (iter != functions.begin() &&
                  range.LowPC < (*--iter)->funcLocation.end) {
                indices = &locations.localIndices.at(*iter);
                break;
              }
            }
          }
        }
        scopes.push_back(indices);
        size_t attrIndex = 0;
        for (auto& attr : abbrev->attributes()) {
          auto& value = entry.Values[attrIndex++];
          auto form = attr.Form;
          bool location = isLocationAttribute(attr.Attr);
          if (form == DW_FORM_exprloc ||
              (location &&
               (form == DW_FORM_block || form == DW_FORM_block1 ||
                form == DW_FORM_block2 || form == DW_FORM_block4))) {
            expressions.push_back(
              {Bytes(value.BlockData.begin(), value.BlockData.end()),
               &value,
               0,
               cu.get(),
               indices});
          } else if (location &&
                     (form == DW_FORM_sec_offset ||
                      (cu->getVersion() < 4 && form == DW_FORM_data4))) {
            listUses[value.Value].push_back({&value, cu.get(), indices});
          } else {
            unsigned bits = 0;
            switch (form) {
              case DW_FORM_ref1:
                bits = 8;
                break;
              case DW_FORM_ref2:
                bits = 16;
                break;
              case DW_FORM_ref4:
                bits = 32;
                break;
              case DW_FORM_ref8:
              case DW_FORM_ref_udata:
                bits = 64;
                break;
              case DW_FORM_ref_addr:
                bits =
                  cu->getVersion() == 2 ? 8 * cu->getAddressByteSize() : 32;
                break;
              default:
                break;
            }
            if (bits) {
              auto base = form == DW_FORM_ref_addr ? 0 : cu->getOffset();
              references.push_back({&value, base + value.Value, base, bits});
            }
          }
        }
      }
    }

    // A compiler may share a location list between variables in different
    // functions. Clone only if their local mappings differ.
    auto oldLocs = std::move(data.Locs);
    for (size_t begin = 0; begin < oldLocs.size();) {
      size_t end = begin + 1;
      auto offset = oldLocs[begin].CompileUnitOffset;
      while (end < oldLocs.size() && oldLocs[end].CompileUnitOffset == offset) {
        ++end;
      }
      auto& uses = listUses[offset];
      if (uses.empty()) {
        uses.push_back(
          {nullptr, context.compile_units().begin()->get(), nullptr});
      }
      std::map<const std::vector<Index>*, std::vector<ListUse>> groups;
      for (auto use : uses) {
        groups[use.indices].push_back(use);
      }
      for (auto& [indices, group] : groups) {
        List list{data.Locs.size(), data.Locs.size() + end - begin, {}};
        for (auto use : group) {
          if (use.value) {
            list.references.push_back(use.value);
          }
        }
        data.Locs.insert(
          data.Locs.end(), oldLocs.begin() + begin, oldLocs.begin() + end);
        for (size_t i = list.begin; i < list.end; ++i) {
          if (!data.Locs[i].Location.empty()) {
            expressions.push_back(
              {data.Locs[i].Location, nullptr, i, group.front().unit, indices});
          }
        }
        lists.push_back(std::move(list));
      }
      begin = end;
    }

    for (;;) {
      for (auto& expr : expressions) {
        auto bytes = rewrite(expr.input, expr.unit, expr.indices);
        if (expr.inlineValue) {
          expr.inlineValue->BlockData.assign(bytes.begin(), bytes.end());
        } else {
          data.Locs[expr.locIndex].Location = std::move(bytes);
        }
      }
      uint64_t locOffset = 0;
      for (auto& list : lists) {
        for (auto* value : list.references) {
          value->Value = locOffset;
        }
        auto start = locOffset;
        for (size_t i = list.begin; i < list.end; ++i) {
          auto& loc = data.Locs[i];
          loc.CompileUnitOffset = start;
          locOffset += 2 * data.CompileUnits[0].AddrSize;
          if ((loc.Start || loc.End) && loc.Start != uint32_t(-1)) {
            locOffset += 2 + loc.Location.size();
          }
        }
      }
      for (auto& ref : references) {
        auto value = relocate(ref.target) - relocate(ref.base);
        if (ref.bits < 64 && value >= (uint64_t(1) << ref.bits)) {
          Fatal() << "relocated DWARF DIE reference does not fit";
        }
        ref.value->Value = value;
      }
      Layout layout(*this);
      layout.traverseDebugInfo();
      if (offsets == layout.offsets) {
        break;
      }
      offsets = std::move(layout.offsets);
    }
    for (auto& arange : data.ARanges) {
      arange.CuOffset = relocate(arange.CuOffset);
    }
    // DWARFYAML only retains one public-name table, and Binaryen leaves these
    // sections un-emitted. Patch their fixed-width references in place instead,
    // preserving every CU's table (and GNU one-byte descriptors).
    std::unordered_map<uint64_t, uint64_t> unitSizes;
    for (size_t i = 0; i < data.CompileUnits.size(); ++i) {
      auto& cu = data.CompileUnits[i];
      unitSizes[(context.compile_units().begin() + i)->get()->getOffset()] =
        cu.Length.getLength() + (cu.Length.isDWARF64() ? 12 : 4);
    }
    for (auto& section : wasm.customSections) {
      auto name = section.name;
      bool gnu = name == ".debug_gnu_pubnames" || name == ".debug_gnu_pubtypes";
      if (!gnu && name != ".debug_pubnames" && name != ".debug_pubtypes") {
        continue;
      }
      auto& contents = section.data;
      llvm::DataExtractor bytes(
        llvm::StringRef(contents.data(), contents.size()), true, 4);
      auto patch = [&](uint64_t at, uint64_t value, unsigned width) {
        for (unsigned i = 0; i < width; ++i) {
          contents.at(at + i) = value >> (8 * i);
        }
      };
      uint64_t pos = 0;
      while (pos < contents.size()) {
        auto length = uint64_t(bytes.getU32(&pos));
        unsigned width = 4;
        if (length == uint32_t(-1)) {
          length = bytes.getU64(&pos);
          width = 8;
        }
        auto end = pos + length;
        bytes.getU16(&pos);
        auto unitField = pos;
        auto base = bytes.getUnsigned(&pos, width);
        patch(unitField, relocate(base), width);
        auto sizeField = pos;
        bytes.getUnsigned(&pos, width);
        if (unitSizes.contains(base)) {
          patch(sizeField, unitSizes.at(base), width);
        }
        while (pos < end) {
          auto field = pos;
          auto offset = bytes.getUnsigned(&pos, width);
          if (!offset) {
            break;
          }
          patch(field, relocate(base + offset) - relocate(base), width);
          if (gnu) {
            bytes.getU8(&pos);
          }
          bytes.getCStr(&pos);
        }
        pos = end;
      }
    }
  }
};

} // namespace wasm::Debug

#endif
