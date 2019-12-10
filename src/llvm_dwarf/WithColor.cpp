//===- WithColor.cpp ------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/Support/WithColor.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

#if 0 // XXX BINARYEN
cl::OptionCategory llvm::ColorCategory("Color Options");

static cl::opt<cl::boolOrDefault>
    UseColor("color", cl::cat(ColorCategory),
             cl::desc("Use colors in output (default=autodetect)"),
             cl::init(cl::BOU_UNSET));
#endif

WithColor::WithColor(raw_ostream &OS, HighlightColor Color, bool DisableColors)
    : OS(OS), DisableColors(DisableColors) {
  // Detect color from terminal type unless the user passed the --color option.
  // XXX BINARYEN - no color support
}

raw_ostream &WithColor::error() { return error(errs()); }

raw_ostream &WithColor::warning() { return warning(errs()); }

raw_ostream &WithColor::note() { return note(errs()); }

raw_ostream &WithColor::remark() { return remark(errs()); }

raw_ostream &WithColor::error(raw_ostream &OS, StringRef Prefix,
                              bool DisableColors) {
  if (!Prefix.empty())
    OS << Prefix << ": ";
  return WithColor(OS, HighlightColor::Error, DisableColors).get()
         << "error: ";
}

raw_ostream &WithColor::warning(raw_ostream &OS, StringRef Prefix,
                                bool DisableColors) {
  if (!Prefix.empty())
    OS << Prefix << ": ";
  return WithColor(OS, HighlightColor::Warning, DisableColors).get()
         << "warning: ";
}

raw_ostream &WithColor::note(raw_ostream &OS, StringRef Prefix,
                             bool DisableColors) {
  if (!Prefix.empty())
    OS << Prefix << ": ";
  return WithColor(OS, HighlightColor::Note, DisableColors).get() << "note: ";
}

raw_ostream &WithColor::remark(raw_ostream &OS, StringRef Prefix,
                               bool DisableColors) {
  if (!Prefix.empty())
    OS << Prefix << ": ";
  return WithColor(OS, HighlightColor::Remark, DisableColors).get()
         << "remark: ";
}

bool WithColor::colorsEnabled() {
  return false; // XXX BINARYEN
}

WithColor &WithColor::changeColor(raw_ostream::Colors Color, bool Bold,
                                  bool BG) {
  // XXX BINARYEN
  return *this;
}

WithColor &WithColor::resetColor() {
  // XXX BINARYEN
  return *this;
}

WithColor::~WithColor() { resetColor(); }
