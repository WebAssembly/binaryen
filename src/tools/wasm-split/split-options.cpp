/*
 * Copyright 2021 WebAssembly Community Group participants
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

#include "split-options.h"
#include <fstream>

namespace wasm {

namespace {

std::set<Name> parseNameListFromLine(const std::string& line) {
  std::set<Name> names;
  std::istringstream stream(line);
  for (std::string name; std::getline(stream, name, ',');) {
    names.insert(name);
  }
  return names;
}

std::set<Name> parseNameListFromFile(const std::string& filename) {
  std::ifstream infile(filename);
  if (!infile.is_open()) {
    std::cerr << "Failed opening '" << filename << "'" << std::endl;
    exit(EXIT_FAILURE);
  }

  std::set<Name> names;
  std::string line;
  while (std::getline(infile, line)) {
    if (line.length() > 0) {
      names.insert(line);
    }
  }

  return names;
}

std::set<Name> parseNameList(const std::string& listOrFile) {
  if (!listOrFile.empty() && listOrFile[0] == '@') {
    return parseNameListFromFile(listOrFile.substr(1));
  }

  return parseNameListFromLine(listOrFile);
}

std::ostream& operator<<(std::ostream& o, WasmSplitOptions::Mode& mode) {
  switch (mode) {
    case WasmSplitOptions::Mode::Split:
      o << "split";
      break;
    case WasmSplitOptions::Mode::Instrument:
      o << "instrument";
      break;
    case WasmSplitOptions::Mode::MergeProfiles:
      o << "merge-profiles";
      break;
    case WasmSplitOptions::Mode::PrintProfile:
      o << "print-profile";
      break;
  }
  return o;
}

} // anonymous namespace

WasmSplitOptions::WasmSplitOptions()
  : ToolOptions("wasm-split",
                "Split a module into a primary module and a secondary "
                "module, or instrument a module to gather a profile that "
                "can inform future splitting, or manage such profiles. Options "
                "that are only accepted in particular modes are marked with "
                "the accepted \"[<modes>]\" in their descriptions.") {
  const std::string WasmSplitOption = "wasm-split options";

  (*this)
    .add("--split",
         "",
         "Split an input module into two output modules. The default mode.",
         WasmSplitOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& arugment) { mode = Mode::Split; })
    .add(
      "--instrument",
      "",
      "Instrument an input module to allow it to generate a profile that can"
      " be used to guide splitting.",
      WasmSplitOption,
      Options::Arguments::Zero,
      [&](Options* o, const std::string& argument) { mode = Mode::Instrument; })
    .add("--merge-profiles",
         "",
         "Merge multiple profiles for the same module into a single profile.",
         WasmSplitOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) {
           mode = Mode::MergeProfiles;
         })
    .add("--print-profile",
         "",
         "Print profile contents in a human-readable format.",
         WasmSplitOption,
         {Mode::PrintProfile},
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           mode = Mode::PrintProfile;
           profileFile = argument;
         })
    .add(
      "--profile",
      "",
      "The profile to use to guide splitting.",
      WasmSplitOption,
      {Mode::Split},
      Options::Arguments::One,
      [&](Options* o, const std::string& argument) { profileFile = argument; })
    .add("--keep-funcs",
         "",
         "Comma-separated list of functions to keep in the primary module. The "
         "rest will be split out. Can be used alongside --profile and "
         "--split-funcs. You can also pass a file with one function per line "
         "by passing @filename.",
         WasmSplitOption,
         {Mode::Split},
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           keepFuncs = parseNameList(argument);
         })
    .add("--split-funcs",
         "",
         "Comma-separated list of functions to split out to the secondary "
         "module. The rest will be kept. Can be used alongside --profile and "
         "--keep-funcs. This takes precedence over other split options. "
         "You can also pass a file with one function per line "
         "by passing @filename.",
         WasmSplitOption,
         {Mode::Split},
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           splitFuncs = parseNameList(argument);
         })
    .add("--primary-output",
         "-o1",
         "Output file for the primary module.",
         WasmSplitOption,
         {Mode::Split},
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           primaryOutput = argument;
         })
    .add("--secondary-output",
         "-o2",
         "Output file for the secondary module.",
         WasmSplitOption,
         {Mode::Split},
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           secondaryOutput = argument;
         })
    .add("--symbolmap",
         "",
         "Write a symbol map file for each of the output modules.",
         WasmSplitOption,
         {Mode::Split},
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) { symbolMap = true; })
    .add(
      "--placeholdermap",
      "",
      "Write a file mapping placeholder indices to the function names.",
      WasmSplitOption,
      {Mode::Split},
      Options::Arguments::Zero,
      [&](Options* o, const std::string& argument) { placeholderMap = true; })
    .add("--import-namespace",
         "",
         "When provided as an option for module splitting, the namespace from "
         "which to import objects from the primary "
         "module into the secondary module. In instrument mode, refers to the "
         "namespace from which to import the secondary memory, if any.",
         WasmSplitOption,
         {Mode::Split, Mode::Instrument},
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           importNamespace = argument;
         })
    .add("--placeholder-namespace",
         "",
         "The namespace from which to import placeholder functions into "
         "the primary module.",
         WasmSplitOption,
         {Mode::Split},
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           placeholderNamespace = argument;
         })
    .add("--jspi",
         "",
         "Transform the module to support asynchronously loading the secondary "
         "module before any placeholder functions have been called.",
         WasmSplitOption,
         {Mode::Split},
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) { jspi = true; })
    .add(
      "--export-prefix",
      "",
      "An identifying prefix to prepend to new export names created "
      "by module splitting.",
      WasmSplitOption,
      {Mode::Split},
      Options::Arguments::One,
      [&](Options* o, const std::string& argument) { exportPrefix = argument; })
    .add("--profile-export",
         "",
         "The export name of the function the embedder calls to write the "
         "profile into memory. Defaults to `__write_profile`.",
         WasmSplitOption,
         {Mode::Instrument},
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           profileExport = argument;
         })
    .add(
      "--in-memory",
      "",
      "Store profile information in memory (starting at address 0 and taking "
      "one byte per function) rather than globals (the default) so that "
      "it can be shared between multiple threads. Users are responsible for "
      "ensuring that the module does not use the initial memory region for "
      "anything else.",
      WasmSplitOption,
      {Mode::Instrument},
      Options::Arguments::Zero,
      [&](Options* o, const std::string& argument) {
        storageKind = StorageKind::InMemory;
      })
    .add(
      "--in-secondary-memory",
      "",
      "Store profile information in a separate memory, rather than in module "
      "main memory or globals (the default). With this option, users do not "
      "need to reserve the initial memory region for profile data and the "
      "data can be shared between multiple threads.",
      WasmSplitOption,
      {Mode::Instrument},
      Options::Arguments::Zero,
      [&](Options* o, const std::string& argument) {
        storageKind = StorageKind::InSecondaryMemory;
      })
    .add("--secondary-memory-name",
         "",
         "The name of the secondary memory created to store profile "
         "information.",
         WasmSplitOption,
         {Mode::Instrument},
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           secondaryMemoryName = argument;
         })
    .add(
      "--emit-module-names",
      "",
      "Emit module names, even if not emitting the rest of the names section. "
      "Can help differentiate the modules in stack traces. This option will be "
      "removed once simpler ways of naming modules are widely available. See "
      "https://bugs.chromium.org/p/v8/issues/detail?id=11808.",
      WasmSplitOption,
      {Mode::Split, Mode::Instrument},
      Options::Arguments::Zero,
      [&](Options* o, const std::string& arguments) { emitModuleNames = true; })
    .add("--initial-table",
         "",
         "A hack to ensure the split and instrumented modules have the same "
         "table size when using Emscripten's SPLIT_MODULE mode with dynamic "
         "linking. TODO: Figure out a more elegant solution for that use "
         "case and remove this.",
         WasmSplitOption,
         {Mode::Split, Mode::Instrument},
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           initialTableSize = std::stoi(argument);
         })
    .add("--emit-text",
         "-S",
         "Emit text instead of binary for the output file or files.",
         WasmSplitOption,
         {Mode::Split, Mode::Instrument},
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) { emitBinary = false; })
    .add("--debuginfo",
         "-g",
         "Emit names section in wasm binary (or full debuginfo in wast)",
         WasmSplitOption,
         {Mode::Split, Mode::Instrument},
         Options::Arguments::Zero,
         [&](Options* o, const std::string& arguments) {
           passOptions.debugInfo = true;
         })
    .add("--output",
         "-o",
         "Output file.",
         WasmSplitOption,
         {Mode::Instrument, Mode::MergeProfiles},
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) { output = argument; })
    .add("--unescape",
         "-u",
         "Un-escape function names (in print-profile output)",
         WasmSplitOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) { unescape = true; })
    .add("--verbose",
         "-v",
         "Verbose output mode. Prints the functions that will be kept "
         "and split out when splitting a module.",
         WasmSplitOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) {
           verbose = true;
           quiet = false;
         })
    .add_positional("INFILES",
                    Options::Arguments::N,
                    [&](Options* o, const std::string& argument) {
                      inputFiles.push_back(argument);
                    });
}

WasmSplitOptions& WasmSplitOptions::add(const std::string& longName,
                                        const std::string& shortName,
                                        const std::string& description,
                                        const std::string& category,
                                        std::vector<Mode>&& modes,
                                        Arguments arguments,
                                        const Action& action) {
  // Insert the valid modes at the beginning of the description.
  std::stringstream desc;
  if (modes.size()) {
    desc << '[';
    std::string sep = "";
    for (Mode m : modes) {
      validOptions[static_cast<unsigned>(m)].insert(longName);
      desc << sep << m;
      sep = ", ";
    }
    desc << "] ";
  }
  desc << description;
  ToolOptions::add(
    longName,
    shortName,
    desc.str(),
    category,
    arguments,
    [&, action, longName](Options* o, const std::string& argument) {
      usedOptions.push_back(longName);
      action(o, argument);
    });
  return *this;
}

WasmSplitOptions& WasmSplitOptions::add(const std::string& longName,
                                        const std::string& shortName,
                                        const std::string& description,
                                        const std::string& category,
                                        Arguments arguments,
                                        const Action& action) {
  // Add an option valid in all modes.
  for (unsigned i = 0; i < NumModes; ++i) {
    validOptions[i].insert(longName);
  }
  return add(longName, shortName, description, category, {}, arguments, action);
}

bool WasmSplitOptions::validate() {
  bool valid = true;
  auto fail = [&](auto msg) {
    std::cerr << "error: " << msg << "\n";
    valid = false;
  };

  // Validate the positional arguments.
  if (inputFiles.size() == 0) {
    fail("no input file");
  }
  switch (mode) {
    case Mode::Split:
    case Mode::Instrument:
      if (inputFiles.size() > 1) {
        fail("Cannot have more than one input file.");
      }
      break;
    case Mode::MergeProfiles:
      // Any number >= 1 allowed.
      break;
    case Mode::PrintProfile:
      if (inputFiles.size() != 1) {
        fail("Must have exactly one profile path.");
      }
      break;
  }

  // Validate that all used options are allowed in the current mode.
  for (std::string& opt : usedOptions) {
    if (!validOptions[static_cast<unsigned>(mode)].count(opt)) {
      std::stringstream msg;
      msg << "Option " << opt << " cannot be used in " << mode << " mode.";
      fail(msg.str());
    }
  }

  return valid;
}

void WasmSplitOptions::parse(int argc, const char* argv[]) {
  ToolOptions::parse(argc, argv);
  // Since --quiet is defined in ToolOptions but --verbose is defined here,
  // --quiet doesn't know to unset --verbose. Fix it up here.
  if (quiet && verbose) {
    verbose = false;
  }
}

} // namespace wasm
