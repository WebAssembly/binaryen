//===--- DWARFEmitter.h - ---------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
/// Common declarations for yaml2obj
//===----------------------------------------------------------------------===//

#ifndef LLVM_OBJECTYAML_DWARFEMITTER_H
#define LLVM_OBJECTYAML_DWARFEMITTER_H

#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/Host.h"
#include "llvm/Support/MemoryBuffer.h"
#include <memory>

namespace llvm {

class raw_ostream;

namespace DWARFYAML {

struct Data;
struct PubSection;

void EmitDebugAbbrev(raw_ostream &OS, const Data &DI);
void EmitDebugStr(raw_ostream &OS, const Data &DI);

void EmitDebugAranges(raw_ostream &OS, const Data &DI);
void EmitDebugRanges(raw_ostream &OS, const Data &DI); // XXX BINARYEN
void EmitDebugLoc(raw_ostream &OS, const Data &DI); // XXX BINARYEN
void EmitPubSection(raw_ostream &OS, const PubSection &Sect,
                    bool IsLittleEndian);
void EmitDebugInfo(raw_ostream &OS, const Data &DI);
void EmitDebugLine(raw_ostream &OS, const Data &DI);
// XXX BINARYEN: Same as EmitDebugLine but also update the Length field in
//               the YAML as we write. We use that information to update
//               offsets into the debug line section.
void ComputeDebugLine(Data &DI, std::vector<size_t>& computedLengths);

Expected<StringMap<std::unique_ptr<MemoryBuffer>>>
EmitDebugSections(StringRef YAMLString, bool ApplyFixups = false,
                  bool IsLittleEndian = sys::IsLittleEndianHost);
StringMap<std::unique_ptr<MemoryBuffer>>
EmitDebugSections(llvm::DWARFYAML::Data &DI, bool ApplyFixups);

} // end namespace DWARFYAML
} // end namespace llvm

#endif // LLVM_OBJECTYAML_DWARFEMITTER_H
