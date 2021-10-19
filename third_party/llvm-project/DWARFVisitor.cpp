//===--- DWARFVisitor.cpp ---------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
//===----------------------------------------------------------------------===//

#include <unordered_map>

#include "DWARFVisitor.h"
#include "llvm/ObjectYAML/DWARFYAML.h"

using namespace llvm;

template <typename T>
void DWARFYAML::VisitorImpl<T>::onVariableSizeValue(uint64_t U, unsigned Size) {
  switch (Size) {
  case 8:
    onValue((uint64_t)U);
    break;
  case 4:
    onValue((uint32_t)U);
    break;
  case 2:
    onValue((uint16_t)U);
    break;
  case 1:
    onValue((uint8_t)U);
    break;
  default:
    llvm_unreachable("Invalid integer write size.");
  }
}

static unsigned getOffsetSize(const DWARFYAML::Unit &Unit) {
  return Unit.Length.isDWARF64() ? 8 : 4;
}

static unsigned getRefSize(const DWARFYAML::Unit &Unit) {
  if (Unit.Version == 2)
    return Unit.AddrSize;
  return getOffsetSize(Unit);
}

template <typename T> void DWARFYAML::VisitorImpl<T>::traverseDebugInfo() {
  // XXX BINARYEN: Handle multiple linked compile units, each of which can
  // refer to a different abbreviation list.
  // TODO: This code appears to assume that abbreviation codes increment by 1
  // so that lookups are linear. In LLVM output that is true, but it might not
  // be in general.
  // Create a map of [byte offset into the abbreviation section] => [index in
  // DebugInfo.AbbrevDecls]. This avoids linear search for each CU.
  std::unordered_map<size_t, size_t> abbrByteOffsetToDeclsIndex;
  for (size_t i = 0; i < DebugInfo.AbbrevDecls.size(); i++) {
    auto offset = DebugInfo.AbbrevDecls[i].ListOffset;
    // The offset is the same for all entries for the same CU, so only note the
    // first as that is where the list for the CU (that LLVM DeclSet) begins.
    // That is, DebugInfo.AbbrevDecls looks like this:
    //
    //  i  CU   Abbrev  ListOffset
    // ============================
    //  0   X     X1      150
    //  1   X     X2      150
    //  2   X     X3      150
    //           ..
    //  6   Y     Y1      260
    //  7   Y     Y2      260
    //
    // Note how multiple rows i have the same CU. All those abbrevs have the
    // same ListOffset, which is the byte offset into the abbreviation section
    // for that set of abbreviations.
    if (abbrByteOffsetToDeclsIndex.count(offset)) {
      continue;
    }
    abbrByteOffsetToDeclsIndex[offset] = i;
  }
  for (auto &Unit : DebugInfo.CompileUnits) {
    // AbbrOffset is the byte offset into the abbreviation section, which we
    // need to find among the Abbrev's ListOffsets (which are the byte offsets
    // of where that abbreviation list begins).
    // TODO: Optimize this to not be O(#CUs * #abbrevs).
    auto offset = Unit.AbbrOffset;
    assert(abbrByteOffsetToDeclsIndex.count(offset));
    size_t AbbrevStart = abbrByteOffsetToDeclsIndex[offset];
    assert(DebugInfo.AbbrevDecls[AbbrevStart].ListOffset == offset);
    // Find the last entry in this abbreviation list.
    size_t AbbrevEnd = AbbrevStart;
    while (AbbrevEnd < DebugInfo.AbbrevDecls.size() &&
           DebugInfo.AbbrevDecls[AbbrevEnd].Code) {
      AbbrevEnd++;
    }
    // XXX BINARYEN If there are no abbreviations, there is nothing to
    //              do in this unit.
    if (AbbrevStart == AbbrevEnd) {
      continue;
    }
    onStartCompileUnit(Unit);
    if (Unit.Entries.empty()) { // XXX BINARYEN
      continue;
    }
    for (auto &Entry : Unit.Entries) {
      onStartDIE(Unit, Entry);
      if (Entry.AbbrCode == 0u)
        continue;
      // XXX BINARYEN valid abbreviation codes start from 1, so subtract that,
      //              and are relative to the start of the abbrev table
      auto RelativeAbbrIndex = Entry.AbbrCode - 1 + AbbrevStart;
      if (RelativeAbbrIndex >= AbbrevEnd) {
        errs() << "warning: invalid abbreviation code " << Entry.AbbrCode
               << " (range: " << AbbrevStart << ".." << AbbrevEnd << ")\n";
        continue;
      }
      auto &Abbrev = DebugInfo.AbbrevDecls[RelativeAbbrIndex];
      auto FormVal = Entry.Values.begin();
      auto AbbrForm = Abbrev.Attributes.begin();
      for (;
           FormVal != Entry.Values.end() && AbbrForm != Abbrev.Attributes.end();
           ++FormVal, ++AbbrForm) {
        onForm(*AbbrForm, *FormVal);
        dwarf::Form Form = AbbrForm->Form;
        bool Indirect;
        do {
          Indirect = false;
          switch (Form) {
          case dwarf::DW_FORM_addr:
            onVariableSizeValue(FormVal->Value, Unit.AddrSize);
            break;
          case dwarf::DW_FORM_ref_addr:
            onVariableSizeValue(FormVal->Value, getRefSize(Unit));
            break;
          case dwarf::DW_FORM_exprloc:
          case dwarf::DW_FORM_block:
            onValue((uint64_t)FormVal->BlockData.size(), true);
            onValue(
                MemoryBufferRef(StringRef((const char *)FormVal->BlockData.data(),
                                          FormVal->BlockData.size()),
                                ""));
            break;
          case dwarf::DW_FORM_block1: {
            auto writeSize = FormVal->BlockData.size();
            onValue((uint8_t)writeSize);
            onValue(
                MemoryBufferRef(StringRef((const char *)FormVal->BlockData.data(),
                                          FormVal->BlockData.size()),
                                ""));
            break;
          }
          case dwarf::DW_FORM_block2: {
            auto writeSize = FormVal->BlockData.size();
            onValue((uint16_t)writeSize);
            onValue(
                MemoryBufferRef(StringRef((const char *)FormVal->BlockData.data(),
                                          FormVal->BlockData.size()),
                                ""));
            break;
          }
          case dwarf::DW_FORM_block4: {
            auto writeSize = FormVal->BlockData.size();
            onValue((uint32_t)writeSize);
            onValue(
                MemoryBufferRef(StringRef((const char *)FormVal->BlockData.data(),
                                          FormVal->BlockData.size()),
                                ""));
            break;
          }
          case dwarf::DW_FORM_data1:
          case dwarf::DW_FORM_ref1:
          case dwarf::DW_FORM_flag:
          case dwarf::DW_FORM_strx1:
          case dwarf::DW_FORM_addrx1:
            onValue((uint8_t)FormVal->Value);
            break;
          case dwarf::DW_FORM_data2:
          case dwarf::DW_FORM_ref2:
          case dwarf::DW_FORM_strx2:
          case dwarf::DW_FORM_addrx2:
            onValue((uint16_t)FormVal->Value);
            break;
          case dwarf::DW_FORM_data4:
          case dwarf::DW_FORM_ref4:
          case dwarf::DW_FORM_ref_sup4:
          case dwarf::DW_FORM_strx4:
          case dwarf::DW_FORM_addrx4:
            onValue((uint32_t)FormVal->Value);
            break;
          case dwarf::DW_FORM_data8:
          case dwarf::DW_FORM_ref8:
          case dwarf::DW_FORM_ref_sup8:
            onValue((uint64_t)FormVal->Value);
            break;
          case dwarf::DW_FORM_sdata:
            onValue((int64_t)FormVal->Value, true);
            break;
          case dwarf::DW_FORM_udata:
          case dwarf::DW_FORM_ref_udata:
            onValue((uint64_t)FormVal->Value, true);
            break;
          case dwarf::DW_FORM_string:
            onValue(FormVal->CStr);
            break;
          case dwarf::DW_FORM_indirect:
            onValue((uint64_t)FormVal->Value, true);
            Indirect = true;
            Form = static_cast<dwarf::Form>((uint64_t)FormVal->Value);
            ++FormVal;
            break;
          case dwarf::DW_FORM_strp:
          case dwarf::DW_FORM_sec_offset:
          case dwarf::DW_FORM_GNU_ref_alt:
          case dwarf::DW_FORM_GNU_strp_alt:
          case dwarf::DW_FORM_line_strp:
          case dwarf::DW_FORM_strp_sup:
            onVariableSizeValue(FormVal->Value, getOffsetSize(Unit));
            break;
          case dwarf::DW_FORM_ref_sig8:
            onValue((uint64_t)FormVal->Value);
            break;
          case dwarf::DW_FORM_GNU_addr_index:
          case dwarf::DW_FORM_GNU_str_index:
            onValue((uint64_t)FormVal->Value, true);
            break;
          default:
            break;
          }
        } while (Indirect);
      }
      onEndDIE(Unit, Entry);
    }
    onEndCompileUnit(Unit);
  }
}

// Explicitly instantiate the two template expansions.
template class DWARFYAML::VisitorImpl<DWARFYAML::Data>;
template class DWARFYAML::VisitorImpl<const DWARFYAML::Data>;
