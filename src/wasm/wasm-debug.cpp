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
#include "dwarf-ranges.h"
#include "wasm.h"

#ifdef BUILD_LLVM_DWARF

#ifdef __clang__
// DWARFEmitter.h transitively includes llvm/ADT/iterator.h, which uses
// std::iterator, which is deprecated in C++17. This can trigger a deprecation
// warning which if -Werror is enabled can cause the build to fail. That warning
// is suppressed while including DWARFEmitter.h to allow the build to succeed.
#pragma clang diagnostic push
#pragma clang diagnostic warning "-Wdeprecated-declarations"
#endif

#include "llvm/ObjectYAML/DWARFEmitter.h"

#ifdef __clang__
#pragma clang diagnostic pop
#endif

#include "../../third_party/llvm-project/DWARFVisitor.h"
#include "support/small_vector.h"
#include "llvm/DebugInfo/DWARF/DWARFExpression.h"
#include "llvm/ObjectYAML/DWARFYAML.h"
#include "llvm/Support/LEB128.h"
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

void updateLocalIndices(Function* func, const std::vector<Index>& oldToNew) {
  if (!func->funcLocation.end) {
    return;
  }
  if (func->dwarfLocalIndices.empty()) {
    for (Index i = 0; i < oldToNew.size(); ++i) {
      if (oldToNew[i] != i) {
        func->dwarfLocalIndices = oldToNew;
        break;
      }
    }
  } else {
    for (auto& index : func->dwarfLocalIndices) {
      if (index != Index(-1)) {
        assert(index < oldToNew.size());
        index = oldToNew[index];
      }
    }
  }
}

#ifdef BUILD_LLVM_DWARF

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

static bool isLocationList(llvm::dwarf::Attribute attr,
                           llvm::dwarf::Form form,
                           unsigned version) {
  using namespace llvm::dwarf;
  return isLocationAttribute(attr) &&
         (form == DW_FORM_sec_offset ||
          (version < 4 && attr != DW_AT_data_member_location &&
           (form == DW_FORM_data4 || form == DW_FORM_data8)));
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
    llvm::DWARFYAML::AttributeAbbrev* form;
    size_t locIndex;
    llvm::DWARFUnit* unit;
    const std::vector<Index>* indices;
    // Unknown until decoded; only DIE references need later layout iterations.
    bool hasReferences = true;
  };
  struct Reference {
    Value* value;
    llvm::DWARFYAML::AttributeAbbrev* form;
    uint64_t target;
    uint64_t base;
    unsigned bits;
  };
  struct List {
    size_t begin, end;
    std::vector<Value*> references;
  };
  struct ListUse {
    Value* value;
    llvm::DWARFUnit* unit;
    const std::vector<Index>* indices;
  };
  using ListUses = std::unordered_map<uint64_t, std::vector<ListUse>>;
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
                const std::vector<Index>* indices,
                bool& hasReferences) {
    using namespace llvm::dwarf;
    llvm::DataExtractor bytes(
      llvm::ArrayRef<uint8_t>(input), true, unit->getAddressByteSize());
    auto truncated = [] { Fatal() << "truncated DWARF location expression"; };
    auto readUnsigned = [&](uint64_t& pos, unsigned width) {
      if (!bytes.isValidOffsetForDataOfSize(pos, width)) {
        truncated();
      }
      return bytes.getUnsigned(&pos, width);
    };
    auto readULEB = [&](uint64_t& pos) {
      auto start = pos;
      auto value = bytes.getULEB128(&pos);
      if (pos == start) {
        truncated();
      }
      return value;
    };
    Bytes output;
    // Instruction boundaries are already ordered. A small vector avoids a
    // hash allocation per instruction in the common few-op expression.
    SmallVector<std::pair<uint64_t, size_t>, 8> positions;
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
    auto fixed = [&](uint64_t value, unsigned width) {
      if (width < 8 && value >= (uint64_t(1) << (8 * width))) {
        Fatal() << "relocated DWARF expression reference does not fit";
      }
      for (unsigned i = 0; i < width; ++i) {
        output.push_back(value >> (8 * i));
      }
    };
    auto typeRef = [&](uint64_t& pos) {
      auto target = readULEB(pos);
      hasReferences |= target != 0;
      auto base = unit->getOffset();
      // Convert/reinterpret use zero for the generic type, not a DIE.
      uleb(target ? relocate(base + target) - relocate(base) : 0);
    };
    for (uint64_t pos = 0; pos < input.size();) {
      auto start = pos;
      positions.push_back({start, output.size()});
      auto opcode = input[pos++];
      if (opcode == DW_OP_WASM_location) {
        // The Wasm convention uses an unsigned local/global/stack index;
        // selector 3 instead has a fixed-width 32-bit global index.
        auto kind = readUnsigned(pos, 1);
        if (kind > 3) {
          Fatal() << "unsupported DW_OP_WASM_location selector";
        }
        auto index = kind == 3 ? readUnsigned(pos, 4) : readULEB(pos);
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
        auto size = readULEB(pos);
        if (size > input.size() - pos) {
          truncated();
        }
        auto nested =
          rewrite(Bytes(input.begin() + pos, input.begin() + pos + size),
                  unit,
                  indices,
                  hasReferences);
        if (nested.empty()) {
          return {};
        }
        output.push_back(opcode);
        uleb(nested.size());
        output.insert(output.end(), nested.begin(), nested.end());
        pos += size;
      } else if (opcode >= DW_OP_const_type && opcode <= DW_OP_reinterpret) {
        // The vendored decoder predates these typed operations. Their type
        // operands are CU-relative DIE references, not opaque bytes.
        output.push_back(opcode);
        if (opcode == DW_OP_regval_type) {
          uleb(readULEB(pos));
        } else if (opcode == DW_OP_deref_type || opcode == DW_OP_xderef_type) {
          output.push_back(readUnsigned(pos, 1));
        }
        typeRef(pos);
        if (opcode == DW_OP_const_type) {
          auto size = readUnsigned(pos, 1);
          if (size > input.size() - pos) {
            truncated();
          }
          output.push_back(size);
          output.insert(
            output.end(), input.begin() + pos, input.begin() + pos + size);
          pos += size;
        }
      } else if (opcode == DW_OP_implicit_pointer) {
        hasReferences = true;
        output.push_back(opcode);
        auto width = unit->getFormParams().getDwarfOffsetByteSize();
        fixed(relocate(readUnsigned(pos, width)), width);
        auto start = pos;
        bytes.getSLEB128(&pos);
        if (pos == start) {
          truncated();
        }
        output.insert(output.end(), input.begin() + start, input.begin() + pos);
      } else {
        llvm::DWARFExpression::Operation op;
        if (!op.extract(
              bytes, unit->getVersion(), unit->getAddressByteSize(), start)) {
          Fatal() << "cannot relocate unsupported DWARF location expression";
        }
        // The vendored decoder leaves the offset unchanged on failed reads
        // but still returns true. Every non-block operand must consume bytes.
        auto operandStart = start + 1;
        for (unsigned i = 0; i < 2; ++i) {
          auto encoding = op.getDescription().Op[i];
          if (encoding == llvm::DWARFExpression::Operation::SizeNA) {
            break;
          }
          auto end = op.getOperandEndOffset(i);
          if (end > input.size() || end < operandStart ||
              (end == operandStart &&
               encoding != llvm::DWARFExpression::Operation::SizeBlock)) {
            truncated();
          }
          operandStart = end;
        }
        pos = op.getEndOffset();
        auto outStart = output.size();
        output.insert(output.end(), input.begin() + start, input.begin() + pos);
        if (opcode == DW_OP_skip || opcode == DW_OP_bra) {
          branches.push_back(
            {outStart + 1, pos + int16_t(op.getRawOperand(0))});
        } else if (opcode == DW_OP_call2 || opcode == DW_OP_call4 ||
                   opcode == DW_OP_call_ref) {
          hasReferences = true;
          auto base = opcode == DW_OP_call_ref ? 0 : unit->getOffset();
          auto target = relocate(base + op.getRawOperand(0)) - relocate(base);
          auto width = pos - start - 1;
          output.resize(outStart + 1);
          if (opcode == DW_OP_call2 && target > UINT16_MAX) {
            output[outStart] = DW_OP_call4;
            width = 4;
          }
          fixed(target, width);
        }
      }
    }
    positions.push_back({input.size(), output.size()});
    for (auto [operand, target] : branches) {
      auto iter = std::lower_bound(
        positions.begin(),
        positions.end(),
        target,
        [](auto position, auto target) { return position.first < target; });
      if (iter == positions.end() || (*iter).first != target) {
        Fatal() << "invalid DWARF expression branch target";
      }
      auto delta = int64_t((*iter).second) - int64_t(operand + 2);
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
    size_t dieIndex = 0;
    uint64_t position = 0, start = 0;
    llvm::DWARFUnit* unit = nullptr;
    std::unordered_map<uint64_t, uint64_t> offsets;

    Layout(DwarfLocalRewriter& owner)
      : llvm::DWARFYAML::Visitor(owner.data), owner(owner) {}

    void onStartCompileUnit(llvm::DWARFYAML::Unit& cu) override {
      auto index = &cu - owner.data.CompileUnits.data();
      unit = (owner.context.compile_units().begin() + index)->get();
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

  ListUses collectReferences() {
    using namespace llvm::dwarf;
    ListUses listUses;
    std::map<std::pair<uint64_t, uint64_t>, llvm::DWARFYAML::Abbrev*> abbrevs;
    for (auto& abbrev : data.AbbrevDecls) {
      abbrevs[{abbrev.ListOffset, abbrev.Code}] = &abbrev;
    }
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
          auto* yamlForm = &abbrevs.at({yaml.AbbrOffset, entry.AbbrCode})
                              ->Attributes[attrIndex];
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
               yamlForm,
               0,
               cu.get(),
               indices});
          } else if (isLocationList(attr.Attr, form, cu->getVersion())) {
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
              references.push_back(
                {&value, yamlForm, base + value.Value, base, bits});
            }
          }
        }
      }
    }
    return listUses;
  }

  uint64_t locSize(const llvm::DWARFYAML::Loc& loc,
                   unsigned addressSize) const {
    // Match EmitDebugLoc, including base-address entries and terminators.
    auto size = 2 * addressSize;
    if ((loc.Start || loc.End) && loc.Start != uint32_t(-1)) {
      if (loc.Location.size() > UINT16_MAX) {
        Fatal() << "relocated DWARF location exceeds the list entry size limit";
      }
      size += 2 + loc.Location.size();
    }
    return size;
  }

  void appendList(const std::vector<llvm::DWARFYAML::Loc>& oldLocs,
                  size_t begin,
                  size_t end,
                  const std::vector<ListUse>& uses) {
    // Different functions or CUs can share a list but require different
    // rewrites. Keep groups in DIE order, not pointer order, for determinism.
    std::vector<std::vector<ListUse>> groups;
    for (auto use : uses) {
      auto iter = std::find_if(groups.begin(), groups.end(), [&](auto& group) {
        return group.front().indices == use.indices &&
               group.front().unit == use.unit;
      });
      if (iter == groups.end()) {
        groups.push_back({use});
      } else {
        iter->push_back(use);
      }
    }
    for (auto& group : groups) {
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
          expressions.push_back({data.Locs[i].Location,
                                 nullptr,
                                 nullptr,
                                 i,
                                 group.front().unit,
                                 group.front().indices});
        }
      }
      lists.push_back(std::move(list));
    }
  }

  void collectLists(ListUses listUses) {
    auto oldLocs = std::move(data.Locs);
    // The parser uses the first input CU's width; the output may have been
    // lowered to wasm32 already. Input list references still use old offsets.
    auto addressSize =
      context.compile_units().begin()->get()->getAddressByteSize();
    for (size_t begin = 0; begin < oldLocs.size();) {
      size_t end = begin + 1;
      auto offset = oldLocs[begin].CompileUnitOffset;
      while (end < oldLocs.size() && oldLocs[end].CompileUnitOffset == offset) {
        ++end;
      }
      for (size_t i = begin; i < end; ++i) {
        auto use = listUses.find(offset);
        if (use != listUses.end()) {
          // References may start at any entry, not just a parsed list's head.
          // Emit each referenced suffix as a list so its CU supplies the
          // initial base independently of entries preceding that suffix.
          appendList(oldLocs, i, end, use->second);
          listUses.erase(use);
        } else if (i == begin) {
          // Preserve unreferenced data as well; it needs no local remapping.
          appendList(
            oldLocs,
            begin,
            end,
            {{nullptr, context.compile_units().begin()->get(), nullptr}});
        }
        offset += locSize(oldLocs[i], addressSize);
      }
      begin = end;
    }
    if (!listUses.empty()) {
      Fatal() << "DWARF location list does not start at an entry boundary";
    }
  }

  bool relocateInfo() {
    using namespace llvm::dwarf;
    for (;;) {
      bool infoResized =
        std::any_of(data.CompileUnits.begin(),
                    data.CompileUnits.end(),
                    [](auto& cu) { return cu.AddrSizeChanged; });
      for (auto& expr : expressions) {
        if (offsets.empty() &&
            (!expr.indices ||
             std::find(expr.input.begin(),
                       expr.input.end(),
                       DW_OP_WASM_location) == expr.input.end())) {
          continue;
        }
        if (!expr.hasReferences) {
          continue;
        }
        expr.hasReferences = false;
        auto bytes =
          rewrite(expr.input, expr.unit, expr.indices, expr.hasReferences);
        if (expr.inlineValue) {
          // A wider local operand can overflow a block1/block2 length. Change
          // the shared abbreviation to the equivalent variable-length form;
          // Layout measures all DIEs using that abbreviation again.
          auto form = expr.form->Form;
          if ((form == DW_FORM_block1 && bytes.size() > UINT8_MAX) ||
              (form == DW_FORM_block2 && bytes.size() > UINT16_MAX)) {
            expr.form->Form = DW_FORM_block;
          }
          infoResized |= bytes.size() != expr.inlineValue->BlockData.size() ||
                         form != expr.form->Form;
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
          locOffset += locSize(loc, data.CompileUnits[0].AddrSize);
        }
      }
      // Most permutations preserve inline expression widths. Location-list
      // offsets are fixed-width attributes, so changing those alone does not
      // require laying out .debug_info or relocating any DIE references.
      if (offsets.empty() && !infoResized) {
        return false;
      }
      for (auto& ref : references) {
        auto value = relocate(ref.target) - relocate(ref.base);
        auto form = ref.form->Form;
        auto bits = form == DW_FORM_ref8   ? 64
                    : form == DW_FORM_ref4 ? 32
                                           : ref.bits;
        if (bits < 64 && value >= (uint64_t(1) << bits)) {
          if (form == DW_FORM_ref1 || form == DW_FORM_ref2 ||
              form == DW_FORM_ref4) {
            ref.form->Form = value <= UINT32_MAX ? DW_FORM_ref4 : DW_FORM_ref8;
          } else {
            Fatal() << "relocated DWARF DIE reference does not fit";
          }
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
    return true;
  }

  void updatePublicNames() {
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
        if (!bytes.isValidOffsetForDataOfSize(pos, 4)) {
          Fatal() << "truncated DWARF public-name table";
        }
        auto length = uint64_t(bytes.getU32(&pos));
        unsigned width = 4;
        if (length == uint32_t(-1)) {
          length = bytes.getU64(&pos);
          width = 8;
        }
        auto end = pos + length;
        if (end > contents.size() || length < 2 + 3 * width) {
          Fatal() << "invalid DWARF public-name table length";
        }
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
          if (end - pos < width) {
            Fatal() << "truncated DWARF public-name entry";
          }
          auto offset = bytes.getUnsigned(&pos, width);
          if (!offset) {
            break;
          }
          patch(field, relocate(base + offset) - relocate(base), width);
          if (gnu) {
            bytes.getU8(&pos);
          }
          auto string = pos;
          bytes.getCStr(&pos);
          if (pos <= string || pos > end) {
            Fatal() << "invalid DWARF public-name entry";
          }
        }
        pos = end;
      }
    }
  }

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
    collectLists(collectReferences());
    if (relocateInfo()) {
      updatePublicNames();
    }
  }
};

// DWARF address fields in the wasm32 input are 4 bytes wide. A legacy
// .debug_ranges entry stores a start and an end address of that width.
static const size_t AddressSize = 4;
static constexpr size_t RangeEntrySize = 2 * AddressSize;

// DWARF v6 reserves the all-ones address for a non-existent entity. LLVM also
// recognizes max-minus-one in legacy range and location data, where all-ones
// is already the base-address-selection marker. Zero is a historical linker
// tombstone, but is context-dependent because it can also be a valid address.
static constexpr BinaryLocation AllOnesAddress = BinaryLocation(-1);
// LLVM's legacy dead-address encoding where all-ones selects a range base.
static constexpr BinaryLocation LegacyTombstoneAddress = BinaryLocation(-2);
// A nonzero empty range avoids the (0, 0) range-list terminator.
static constexpr BinaryLocation EmptyRangeAddress = 1;
// Root DIEs have no parent in the per-compilation-unit index.
static constexpr size_t NoParent = size_t(-1);

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
      case llvm::dwarf::DW_LNS_set_epilogue_begin: {
        epilogueBegin = true;
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
    if (epilogueBegin) {
      newOpcodes.push_back(makeItem(llvm::dwarf::DW_LNS_set_epilogue_begin));
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
  void resetAfterLine() {
    prologueEnd = false;
    epilogueBegin = false;
  }

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
    assert(!startMap.contains(span.start));
    startMap[span.start] = expr;
    assert(!endMap.contains(span.end));
    endMap[span.end] = expr;
  }

  void add(Expression* expr,
           const BinaryLocations::DelimiterLocations& delimiter) {
    for (Index i = 0; i < delimiter.size(); i++) {
      if (delimiter[i] != 0) {
        assert(!delimiterMap.contains(delimiter[i]));
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
    if (!locToUnitMap.contains(offset)) {
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

static bool isNonzeroTombstone(BinaryLocation location) {
  return location == AllOnesAddress || location == LegacyTombstoneAddress;
}

// Keep accepting the historical zero tombstone. Callers whose encoding permits
// a real address zero must use isNonzeroTombstone instead.
static bool isTombstone(uint32_t x) { return x == 0 || isNonzeroTombstone(x); }

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
          if (newAddrInfo.contains(newAddr)) {
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
                      size_t compileUnitIndex,
                      unsigned version) {
  auto tag = DIE.getTag();
  // Pairs of low/high_pc require some special handling, as the high
  // may be an offset relative to the low. First, process everything but
  // the high pcs, so we see the low pcs first.
  BinaryLocation oldLowPC = 0, newLowPC = 0;
  llvm::DWARFYAML::FormValue* lowPCValue = nullptr;
  iterContextAndYAML(
    abbrevDecl->attributes(),
    yamlEntry.Values,
    [&](const llvm::DWARFAbbreviationDeclaration::AttributeSpec& attrSpec,
        llvm::DWARFYAML::FormValue& yamlValue) {
      auto attr = attrSpec.Attr;
      if (attr == llvm::dwarf::DW_AT_low_pc) {
        // This is an address.
        BinaryLocation oldValue = yamlValue.Value, newValue = 0;
        lowPCValue = &yamlValue;
        // Preserve reserved dead-address sentinels. Mapping them as instruction
        // offsets would turn dead DIEs into live ranges at address zero.
        if (isNonzeroTombstone(oldValue)) {
          newValue = oldValue;
        } else if (tag == llvm::dwarf::DW_TAG_GNU_call_site ||
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
        // The location mapper returns zero when a function or expression no
        // longer has a mapped start. Unlike a CU base, that is not a usable
        // start for a non-CU DIE even if its end still has a mapping.
        if (tag != llvm::dwarf::DW_TAG_compile_unit && newValue == 0) {
          newValue = AllOnesAddress;
        }
        oldLowPC = oldValue;
        newLowPC = newValue;
        yamlValue.Value = newValue;
      } else if (attr == llvm::dwarf::DW_AT_stmt_list) {
        // This is an offset into the debug line section.
        yamlValue.Value =
          locationUpdater.getNewDebugLineLocation(yamlValue.Value);
      } else if (isLocationList(attr, attrSpec.Form, version)) {
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
      if (isNonzeroTombstone(newLowPC)) {
        newValue = newLowPC;
      } else if (tag == llvm::dwarf::DW_TAG_GNU_call_site ||
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
      // If one endpoint disappeared or moved before the other, the exact
      // scope can no longer be represented by this low/high pair. Tombstone
      // the DIE instead of emitting a wrapping or unrelated address range.
      if (!isNonzeroTombstone(newLowPC) &&
          tag != llvm::dwarf::DW_TAG_compile_unit &&
          (newValue == 0 || newValue < newLowPC)) {
        newLowPC = AllOnesAddress;
        newValue = AllOnesAddress;
        assert(lowPCValue);
        lowPCValue->Value = newLowPC;
      }
      if (isRelative) {
        newValue -= newLowPC;
      }
      yamlValue.Value = newValue;
    });
}

static void updateCompileUnits(const BinaryenDWARFInfo& info,
                               llvm::DWARFYAML::Data& yaml,
                               LocationUpdater& locationUpdater) {
  // The context has the high-level information we need, and the YAML is where
  // we write changes. First, iterate over the compile units.
  size_t compileUnitIndex = 0;
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
            updateDIE(DIE,
                      yamlEntry,
                      abbrevDecl,
                      locationUpdater,
                      compileUnitIndex,
                      CU->getVersion());
          }
        });
      compileUnitIndex++;
    });
}

static void updateRanges(llvm::DWARFYAML::Data& yaml,
                         const LocationUpdater& locationUpdater,
                         bool canRepairRanges) {
  // In each range section, update the start and end. If either endpoint no
  // longer has a mapping, emit an empty range that a debugger can safely
  // ignore. Do not use (0, 0), since that is the list terminator.
  for (auto& range : yaml.Ranges) {
    BinaryLocation oldStart = range.Start, oldEnd = range.End, newStart = 0,
                   newEnd = 0;
    if (!canRepairRanges) {
      // Preserve the previous updater's behavior for non-wasm32 CUs. The
      // vendored emitter cannot write address-sized range entries for them.
      if (isTombstone(oldStart) || isTombstone(oldEnd)) {
        continue;
      }
      newStart = locationUpdater.getNewStart(oldStart);
      newEnd = locationUpdater.getNewEnd(oldEnd);
      if (isTombstone(newStart) || isTombstone(newEnd)) {
        newStart = 0;
        newEnd = 1;
      }
      range.Start = newStart;
      range.End = newEnd;
      continue;
    }
    if ((oldStart == 0 && oldEnd == 0) || oldStart == AllOnesAddress) {
      newStart = oldStart;
      newEnd = oldEnd;
    } else if (oldStart == LegacyTombstoneAddress || isTombstone(oldEnd)) {
      newStart = EmptyRangeAddress;
      newEnd = EmptyRangeAddress;
    } else {
      // Zero is a valid offset from the current range-list base. It is only a
      // tombstone when paired with a zero end as handled above.
      newStart = oldStart == 0 ? 0 : locationUpdater.getNewStart(oldStart);
      newEnd = locationUpdater.getNewEnd(oldEnd);
      if ((oldStart != 0 && isTombstone(newStart)) || isTombstone(newEnd) ||
          newEnd <= newStart) {
        newStart = EmptyRangeAddress;
        newEnd = EmptyRangeAddress;
      }
      // TODO even if range start and end markers have been preserved,
      // instructions in the middle may have moved around, making the range no
      // longer contiguous. We should check that, and possibly split/merge
      // the range. Or, we may need to have tracking in the IR for this.
    }
    range.Start = newStart;
    range.End = newEnd;
  }
}

// Per-DIE state for repairDIEAddressRanges: remapped ranges and scope-tree
// relationships, plus references to the YAML fields that need updating when
// repairing a range list or making a scope unavailable.
struct DIEAddressInfo {
  llvm::DWARFYAML::Entry* yamlEntry = nullptr;
  llvm::DWARFYAML::FormValue* rangesValue = nullptr;
  const llvm::DWARFAbbreviationDeclaration* abbrevDecl = nullptr;
  llvm::dwarf::Tag tag = llvm::dwarf::DW_TAG_null;
  uint32_t depth = 0;
  size_t parent = NoParent;
  DwarfRanges ranges;
  bool hasRangeDescription = false;
  bool rangeListDirty = false;
  bool malformed = false;
  bool unavailable = false;
};

static void readDIEAddressRanges(DIEAddressInfo& info,
                                 llvm::DWARFYAML::Data& yaml,
                                 BinaryLocation compileUnitBase) {
  std::optional<BinaryLocation> lowPC;
  std::optional<BinaryLocation> highPC;
  std::optional<BinaryLocation> rangesOffset;
  bool highPCIsRelative = false;

  iterContextAndYAML(
    info.abbrevDecl->attributes(),
    info.yamlEntry->Values,
    [&](const llvm::DWARFAbbreviationDeclaration::AttributeSpec& attrSpec,
        llvm::DWARFYAML::FormValue& yamlValue) {
      if (attrSpec.Attr == llvm::dwarf::DW_AT_low_pc) {
        lowPC = BinaryLocation(yamlValue.Value);
      } else if (attrSpec.Attr == llvm::dwarf::DW_AT_high_pc) {
        highPC = BinaryLocation(yamlValue.Value);
        highPCIsRelative = attrSpec.Form == llvm::dwarf::DW_FORM_data4;
      } else if (attrSpec.Attr == llvm::dwarf::DW_AT_ranges) {
        rangesOffset = BinaryLocation(yamlValue.Value);
        info.rangesValue = &yamlValue;
      }
    });

  if (rangesOffset) {
    info.hasRangeDescription = true;
    if (*rangesOffset % RangeEntrySize != 0 ||
        *rangesOffset / RangeEntrySize >= yaml.Ranges.size()) {
      info.malformed = true;
      return;
    }
    auto base = uint64_t(compileUnitBase);
    bool terminated = false;
    for (size_t i = *rangesOffset / RangeEntrySize; i < yaml.Ranges.size();
         ++i) {
      auto start = BinaryLocation(yaml.Ranges[i].Start);
      auto end = BinaryLocation(yaml.Ranges[i].End);
      if (start == 0 && end == 0) {
        terminated = true;
        break;
      }
      if (start == AllOnesAddress) {
        base = end;
        continue;
      }
      // A zero start is a valid offset from the current base. Only (0, 0),
      // handled above, terminates the list.
      if (start == LegacyTombstoneAddress || isTombstone(end)) {
        continue;
      }
      auto absoluteStart = base + start;
      auto absoluteEnd = base + end;
      // Keep the addition wide so an offset that escapes wasm32's address
      // space cannot wrap back into an apparently valid range.
      if (absoluteStart > std::numeric_limits<BinaryLocation>::max() ||
          absoluteEnd > std::numeric_limits<BinaryLocation>::max() ||
          absoluteStart > absoluteEnd) {
        info.malformed = true;
      } else if (absoluteStart < absoluteEnd) {
        info.ranges.add(absoluteStart, absoluteEnd);
      }
    }
    if (!terminated) {
      info.malformed = true;
    }
  } else if (lowPC && highPC) {
    info.hasRangeDescription = true;
    // Unlike a range-list terminator, zero is a valid low_pc when paired with
    // a nonzero high_pc. Only the reserved nonzero sentinels are unambiguously
    // unavailable in this encoding.
    if (!isNonzeroTombstone(*lowPC)) {
      uint64_t start = *lowPC;
      uint64_t end = highPCIsRelative ? start + *highPC : *highPC;
      // A relative high_pc can overflow the 32-bit wasm32 address space;
      // doing the addition in uint64_t makes that detectable rather than
      // wrapping to a plausible lower address.
      if (end > std::numeric_limits<BinaryLocation>::max() || start > end) {
        info.malformed = true;
      } else if (start < end) {
        info.ranges.add(start, end);
      }
    }
  }

  info.rangeListDirty |= info.rangesValue && info.ranges.normalize();
}

static void writeRangeList(DIEAddressInfo& info, llvm::DWARFYAML::Data& yaml) {
  assert(info.rangesValue);
  info.rangesValue->Value = yaml.Ranges.size() * RangeEntrySize;
  // Use an explicit zero base so the new entries remain absolute and can be
  // updated again without recovering an implicit compile-unit base.
  yaml.Ranges.push_back(llvm::DWARFYAML::Range{AllOnesAddress, 0, 0});
  for (auto [start, end] : info.ranges.get()) {
    yaml.Ranges.push_back(llvm::DWARFYAML::Range{start, end, 0});
  }
  yaml.Ranges.push_back(llvm::DWARFYAML::Range{0, 0, 0});
}

static void markUnavailable(std::vector<DIEAddressInfo>& infos,
                            const std::vector<std::vector<size_t>>& children,
                            size_t root) {
  std::vector<size_t> pending{root};
  // Follow the explicit tree rather than scanning by depth. Null DIE
  // terminators do not have abbreviation data and would stop a depth scan
  // before all descendants were reached.
  while (!pending.empty()) {
    auto index = pending.back();
    pending.pop_back();
    infos[index].unavailable = true;
    pending.insert(
      pending.end(), children[index].begin(), children[index].end());
  }
}

static void
writeUnavailableDIE(DIEAddressInfo& info,
                    llvm::DWARFYAML::Data& yaml,
                    std::optional<BinaryLocation>& emptyRangeListOffset) {
  iterContextAndYAML(
    info.abbrevDecl->attributes(),
    info.yamlEntry->Values,
    [&](const llvm::DWARFAbbreviationDeclaration::AttributeSpec& attrSpec,
        llvm::DWARFYAML::FormValue& yamlValue) {
      if (attrSpec.Attr == llvm::dwarf::DW_AT_low_pc) {
        yamlValue.Value = AllOnesAddress;
      } else if (attrSpec.Attr == llvm::dwarf::DW_AT_high_pc) {
        yamlValue.Value =
          attrSpec.Form == llvm::dwarf::DW_FORM_data4 ? 0 : AllOnesAddress;
      } else if (attrSpec.Attr == llvm::dwarf::DW_AT_ranges) {
        if (!emptyRangeListOffset) {
          emptyRangeListOffset = yaml.Ranges.size() * RangeEntrySize;
          yaml.Ranges.push_back(llvm::DWARFYAML::Range{0, 0, 0});
        }
        yamlValue.Value = *emptyRangeListOffset;
      }
    });
}

// A pass may reorder instructions such that independently mapped range
// endpoints no longer describe a valid DWARF scope tree. In that case it is
// safer to make the affected scope unavailable than to assign variables to
// code that did not originally belong to the scope.
static void repairDIEAddressRanges(const BinaryenDWARFInfo& dwarfInfo,
                                   llvm::DWARFYAML::Data& yaml,
                                   const LocationUpdater& locationUpdater) {
  size_t compileUnitIndex = 0;
  std::optional<BinaryLocation> emptyRangeListOffset;
  iterContextAndYAML(
    dwarfInfo.context->compile_units(),
    yaml.CompileUnits,
    [&](const std::unique_ptr<llvm::DWARFUnit>& CU,
        llvm::DWARFYAML::Unit& yamlUnit) {
      std::vector<DIEAddressInfo> infos(yamlUnit.Entries.size());
      std::vector<size_t> ancestors;
      auto yamlEntry = yamlUnit.Entries.begin();
      size_t index = 0;
      BinaryLocation compileUnitBase = 0;
      if (auto iter = locationUpdater.compileUnitBases.find(compileUnitIndex);
          iter != locationUpdater.compileUnitBases.end()) {
        compileUnitBase = iter->second.second;
      }
      for (const auto& DIE : CU->dies()) {
        assert(yamlEntry != yamlUnit.Entries.end());
        auto abbrevDecl = DIE.getAbbreviationDeclarationPtr();
        if (abbrevDecl) {
          auto& info = infos[index];
          info.yamlEntry = &*yamlEntry;
          info.abbrevDecl = abbrevDecl;
          info.tag = DIE.getTag();
          info.depth = DIE.getDepth();
          while (ancestors.size() > info.depth) {
            ancestors.pop_back();
          }
          if (info.depth > 0 && ancestors.size() == info.depth) {
            info.parent = ancestors.back();
          }
          // In preorder, a valid DIE cannot descend more than one level at
          // once. Keep malformed depths unavailable rather than indexing past
          // the ancestor stack in non-asserting builds.
          if (ancestors.size() < info.depth) {
            info.malformed = true;
          }
          ancestors.push_back(index);
          readDIEAddressRanges(info, yaml, compileUnitBase);
        }
        ++yamlEntry;
        ++index;
      }
      assert(yamlEntry == yamlUnit.Entries.end());

      std::vector<std::vector<size_t>> children(infos.size());
      for (size_t i = 0; i < infos.size(); ++i) {
        if (infos[i].abbrevDecl && infos[i].parent != NoParent) {
          children[infos[i].parent].push_back(i);
        }
      }

      // Compute this once bottom-up instead of rescanning every subtree.
      std::vector<bool> hasRangedDescendant(infos.size());
      for (size_t i = infos.size(); i-- > 0;) {
        if (infos[i].parent != NoParent &&
            (!infos[i].ranges.empty() || hasRangedDescendant[i])) {
          hasRangedDescendant[infos[i].parent] = true;
        }
      }
      for (size_t i = 0; i < infos.size(); ++i) {
        if (!infos[i].abbrevDecl) {
          continue;
        }
        if (infos[i].malformed ||
            (!infos[i].rangesValue && infos[i].hasRangeDescription &&
             infos[i].ranges.empty() && hasRangedDescendant[i])) {
          markUnavailable(infos, children, i);
        }
      }

      // Process each sibling group after its children have reached their final
      // ranges. This ensures that extending a range-list child cannot create an
      // overlap that was checked only against its old endpoints.
      for (size_t parentIndex = infos.size(); parentIndex-- > 0;) {
        auto& parent = infos[parentIndex];
        if (!parent.abbrevDecl || parent.unavailable) {
          continue;
        }
        auto& siblings = children[parentIndex];
        for (size_t i = 0; i < siblings.size(); ++i) {
          for (size_t j = i + 1; j < siblings.size(); ++j) {
            if (!infos[siblings[i]].unavailable &&
                !infos[siblings[j]].unavailable &&
                !infos[siblings[i]].ranges.empty() &&
                !infos[siblings[j]].ranges.empty() &&
                infos[siblings[i]].ranges.overlaps(infos[siblings[j]].ranges)) {
              // Remove conflicting scopes immediately. Later pairs need only
              // compare surviving siblings; a third scope may remain usable
              // if it overlapped only one that has already been removed.
              markUnavailable(infos, children, siblings[i]);
              markUnavailable(infos, children, siblings[j]);
            }
          }
        }

        // A range-list parent can represent the union of its existing ranges
        // and its surviving children. Extend it before it is checked as a
        // child at the next level of the tree.
        if (parent.rangesValue) {
          for (auto childIndex : siblings) {
            auto& child = infos[childIndex];
            if (!child.unavailable) {
              parent.rangeListDirty |= parent.ranges.add(child.ranges);
            }
          }
        }

        for (auto childIndex : siblings) {
          auto& child = infos[childIndex];
          if (child.unavailable) {
            continue;
          }
          bool subprogramPair = child.tag == llvm::dwarf::DW_TAG_subprogram &&
                                parent.tag == llvm::dwarf::DW_TAG_subprogram;
          if (!subprogramPair && !child.ranges.empty() &&
              !parent.ranges.empty() && !parent.ranges.contains(child.ranges)) {
            markUnavailable(infos, children, childIndex);
          }
        }
      }

      for (auto& info : infos) {
        if (info.abbrevDecl && info.unavailable) {
          writeUnavailableDIE(info, yaml, emptyRangeListOffset);
        } else if (info.abbrevDecl && info.rangeListDirty) {
          writeRangeList(info, yaml);
        }
      }
      ++compileUnitIndex;
    });
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

  // Finalize output address widths before measuring relocated DIEs and lists.
  // The context retains the input widths for decoding old list offsets.
  auto addressSize = !wasm.memories.empty() && wasm.memories[0]->is64() ? 8 : 4;
  for (auto& unit : data.CompileUnits) {
    if (unit.AddrSize != addressSize) {
      unit.AddrSize = addressSize;
      unit.AddrSizeChanged = true;
    }
  }
  DwarfLocalRewriter(wasm, data, *info.context, newLocations).run();

  updateDebugLines(data, locationUpdater);

  updateCompileUnits(info, data, locationUpdater);

  // The vendored DWARFYAML emitter still writes .debug_ranges entries as
  // pairs of 4-byte addresses. Rebuilding lists for 8-byte or mixed-width
  // CUs would write invalid DW_AT_ranges offsets. Keep the earlier updater
  // behavior until that emitter supports address-sized entries.
  bool canRepairRanges = true;
  for (const auto& CU : data.CompileUnits) {
    if (CU.AddrSize != AddressSize) {
      canRepairRanges = false;
      break;
    }
  }
  updateRanges(data, locationUpdater, canRepairRanges);
  if (canRepairRanges) {
    repairDIEAddressRanges(info, data, locationUpdater);
  }

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
