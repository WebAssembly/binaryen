//===- ObjectFile.cpp - File format independent object file ---------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines a file format independent ObjectFile class.
//
//===----------------------------------------------------------------------===//

#include "llvm/Object/ObjectFile.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/BinaryFormat/Magic.h"
#include "llvm/Object/Binary.h"
#include "llvm/Object/COFF.h"
#include "llvm/Object/Error.h"
#include "llvm/Object/MachO.h"
#include "llvm/Object/Wasm.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/ErrorOr.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/raw_ostream.h"
#include <algorithm>
#include <cstdint>
#include <memory>
#include <system_error>

using namespace llvm;
using namespace object;

void ObjectFile::anchor() {}

ObjectFile::ObjectFile(unsigned int Type, MemoryBufferRef Source)
    : SymbolicFile(Type, Source) {}

bool SectionRef::containsSymbol(SymbolRef S) const {
  llvm_unreachable("containsSymbol"); // XXX BINARYEN
}

uint64_t ObjectFile::getSymbolValue(DataRefImpl Ref) const {
  uint32_t Flags = getSymbolFlags(Ref);
  if (Flags & SymbolRef::SF_Undefined)
    return 0;
  if (Flags & SymbolRef::SF_Common)
    return getCommonSymbolSize(Ref);
  return getSymbolValueImpl(Ref);
}

Error ObjectFile::printSymbolName(raw_ostream &OS, DataRefImpl Symb) const {
  Expected<StringRef> Name = getSymbolName(Symb);
  if (!Name)
    return Name.takeError();
  OS << *Name;
  return Error::success();
}

uint32_t ObjectFile::getSymbolAlignment(DataRefImpl DRI) const { return 0; }

bool ObjectFile::isSectionBitcode(DataRefImpl Sec) const {
  Expected<StringRef> NameOrErr = getSectionName(Sec);
  if (NameOrErr)
    return *NameOrErr == ".llvmbc";
  consumeError(NameOrErr.takeError());
  return false;
}

bool ObjectFile::isSectionStripped(DataRefImpl Sec) const { return false; }

bool ObjectFile::isBerkeleyText(DataRefImpl Sec) const {
  return isSectionText(Sec);
}

bool ObjectFile::isBerkeleyData(DataRefImpl Sec) const {
  return isSectionData(Sec);
}

Expected<section_iterator>
ObjectFile::getRelocatedSection(DataRefImpl Sec) const {
  return section_iterator(SectionRef(Sec, this));
}

Triple ObjectFile::makeTriple() const {
  llvm_unreachable("makeTriple"); // XXX BINARYEN
}

Expected<std::unique_ptr<ObjectFile>>
ObjectFile::createObjectFile(MemoryBufferRef Object, file_magic Type) {
  llvm_unreachable("createObjectFile"); // XXX BINARYEN
}

#if 0 // XXX BINARYEN
Expected<OwningBinary<ObjectFile>>
ObjectFile::createObjectFile(StringRef ObjectPath) {
  ErrorOr<std::unique_ptr<MemoryBuffer>> FileOrErr =
      MemoryBuffer::getFile(ObjectPath);
  if (std::error_code EC = FileOrErr.getError())
    return errorCodeToError(EC);
  std::unique_ptr<MemoryBuffer> Buffer = std::move(FileOrErr.get());

  Expected<std::unique_ptr<ObjectFile>> ObjOrErr =
      createObjectFile(Buffer->getMemBufferRef());
  if (Error Err = ObjOrErr.takeError())
    return std::move(Err);
  std::unique_ptr<ObjectFile> Obj = std::move(ObjOrErr.get());

  return OwningBinary<ObjectFile>(std::move(Obj), std::move(Buffer));
}
#endif
