//===- SymbolicFile.cpp - Interface that only provides symbols ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines a file format independent SymbolicFile class.
//
//===----------------------------------------------------------------------===//

#include "llvm/Object/SymbolicFile.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/BinaryFormat/Magic.h"
#if 0 // XXX BINARYEN
#include "llvm/Object/COFFImportFile.h"
#endif
#include "llvm/Object/Error.h"
#if 0 // XXX BINARYEN
#include "llvm/Object/IRObjectFile.h"
#endif
#include "llvm/Object/ObjectFile.h"
#include "llvm/Support/Compiler.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/ErrorOr.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/MemoryBuffer.h"
#include <algorithm>
#include <memory>

using namespace llvm;
using namespace object;

SymbolicFile::SymbolicFile(unsigned int Type, MemoryBufferRef Source)
    : Binary(Type, Source) {}

SymbolicFile::~SymbolicFile() = default;

Expected<std::unique_ptr<SymbolicFile>>
SymbolicFile::createSymbolicFile(MemoryBufferRef Object, file_magic Type,
                                 LLVMContext *Context) {
  llvm_unreachable("createSymbolicFile");
}
