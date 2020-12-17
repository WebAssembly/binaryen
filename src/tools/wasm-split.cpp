/*
 * Copyright 2020 WebAssembly Community Group participants
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

// wasm-split: Split a module in two or instrument a module to inform future
// splitting.

#include "ir/module-splitting.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "support/file.h"
#include "support/name.h"
#include "support/utilities.h"
#include "tool-options.h"
#include "wasm-builder.h"
#include "wasm-io.h"
#include "wasm-type.h"
#include "wasm-validator.h"
#include <sstream>

using namespace wasm;

namespace {

const std::string DEFAULT_PROFILE_EXPORT("__write_profile");

std::set<Name> parseNameList(const std::string& list) {
  std::set<Name> names;
  std::istringstream stream(list);
  for (std::string name; std::getline(stream, name, ',');) {
    names.insert(name);
  }
  return names;
}

struct WasmSplitOptions : ToolOptions {
  bool verbose = false;
  bool emitBinary = true;

  bool instrument = false;

  std::string profileFile;
  std::string profileExport = DEFAULT_PROFILE_EXPORT;

  std::set<Name> keepFuncs;
  std::set<Name> splitFuncs;

  std::string input;
  std::string output;
  std::string primaryOutput;
  std::string secondaryOutput;

  std::string importNamespace;
  std::string placeholderNamespace;
  std::string exportPrefix;

  // A hack to ensure the split and instrumented modules have the same table
  // size when using Emscripten's SPLIT_MODULE mode with dynamic linking. TODO:
  // Figure out a more elegant solution for that use case and remove this.
  int initialTableSize = -1;

  WasmSplitOptions();
  bool validate();
  void parse(int argc, const char* argv[]);
};

WasmSplitOptions::WasmSplitOptions()
  : ToolOptions("wasm-split",
                "Split a module into a primary module and a secondary "
                "module or instrument a module to gather a profile that "
                "can inform future splitting.") {
  (*this)
    .add("--instrument",
         "",
         "Instrument the module to generate a profile that can be used to "
         "guide splitting",
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) { instrument = true; })
    .add(
      "--profile",
      "",
      "The profile to use to guide splitting. May not be used with "
      "--instrument.",
      Options::Arguments::One,
      [&](Options* o, const std::string& argument) { profileFile = argument; })
    .add("--profile-export",
         "",
         "The export name of the function the embedder calls to write the "
         "profile into memory. Defaults to `__write_profile`. Must be used "
         "with --instrument.",
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           profileExport = argument;
         })
    .add("--keep-funcs",
         "",
         "Comma-separated list of functions to keep in the primary module, "
         "regardless of any profile.",
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           keepFuncs = parseNameList(argument);
         })
    .add("--split-funcs",
         "",
         "Comma-separated list of functions to split into the secondary "
         "module, regardless of any profile. If there is no profile, then "
         "this defaults to all functions defined in the module.",
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           splitFuncs = parseNameList(argument);
         })
    .add("--output",
         "-o",
         "Output file. Only usable with --instrument.",
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) { output = argument; })
    .add("--primary-output",
         "-o1",
         "Output file for the primary module. Not usable with --instrument.",
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           primaryOutput = argument;
         })
    .add("--secondary-output",
         "-o2",
         "Output file for the secondary module. Not usable with --instrument.",
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           secondaryOutput = argument;
         })
    .add("--import-namespace",
         "",
         "The namespace from which to import objects from the primary "
         "module into the secondary module.",
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           importNamespace = argument;
         })
    .add("--placeholder-namespace",
         "",
         "The namespace from which to import placeholder functions into "
         "the primary module.",
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           placeholderNamespace = argument;
         })
    .add(
      "--export-prefix",
      "",
      "An identifying prefix to prepend to new export names created "
      "by module splitting.",
      Options::Arguments::One,
      [&](Options* o, const std::string& argument) { exportPrefix = argument; })
    .add("--verbose",
         "-v",
         "Verbose output mode. Prints the functions that will be kept "
         "and split out when splitting a module.",
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) {
           verbose = true;
           quiet = false;
         })
    .add("--emit-text",
         "-S",
         "Emit text instead of binary for the output file or files.",
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) { emitBinary = false; })
    .add("--debuginfo",
         "-g",
         "Emit names section in wasm binary (or full debuginfo in wast)",
         Options::Arguments::Zero,
         [&](Options* o, const std::string& arguments) {
           passOptions.debugInfo = true;
         })
    .add("--initial-table",
         "",
         "A hack to ensure the split and instrumented modules have the same "
         "table size when using Emscripten's SPLIT_MODULE mode with dynamic "
         "linking. TODO: Figure out a more elegant solution for that use "
         "case and remove this.",
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           initialTableSize = std::stoi(argument);
         })
    .add_positional(
      "INFILE",
      Options::Arguments::One,
      [&](Options* o, const std::string& argument) { input = argument; });
}

bool WasmSplitOptions::validate() {
  bool valid = true;
  auto fail = [&](auto msg) {
    std::cerr << "error: " << msg << "\n";
    valid = false;
  };

  if (!input.size()) {
    fail("no input file");
  }
  if (instrument) {
    using Opt = std::pair<const std::string&, const std::string>;
    for (auto& opt : {Opt{profileFile, "--profile"},
                      Opt{primaryOutput, "primary output"},
                      Opt{secondaryOutput, "secondary output"},
                      Opt{importNamespace, "--import-namespace"},
                      Opt{placeholderNamespace, "--placeholder-namespace"},
                      Opt{exportPrefix, "--export-prefix"}}) {
      if (opt.first.size()) {
        fail(opt.second + " cannot be used with --instrument");
      }
    }
    if (keepFuncs.size()) {
      fail("--keep-funcs cannot be used with --instrument");
    }
    if (splitFuncs.size()) {
      fail("--split-funcs cannot be used with --instrument");
    }
  } else {
    if (output.size()) {
      fail(
        "must provide separate primary and secondary output with -o1 and -o2");
    }
    if (profileExport != DEFAULT_PROFILE_EXPORT) {
      fail("--profile-export must be used with --instrument");
    }
  }

  std::vector<Name> impossible;
  std::set_intersection(keepFuncs.begin(),
                        keepFuncs.end(),
                        splitFuncs.begin(),
                        splitFuncs.end(),
                        std::inserter(impossible, impossible.end()));
  for (auto& func : impossible) {
    fail(std::string("Cannot both keep and split out function ") +
         func.c_str());
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

void parseInput(Module& wasm, const WasmSplitOptions& options) {
  ModuleReader reader;
  reader.setProfile(options.profile);
  try {
    reader.read(options.input, wasm);
  } catch (ParseException& p) {
    p.dump(std::cerr);
    std::cerr << '\n';
    Fatal() << "error parsing wasm";
  } catch (std::bad_alloc&) {
    Fatal() << "error building module, std::bad_alloc (possibly invalid "
               "request for silly amounts of memory)";
  }
  options.applyFeatures(wasm);
}

// Add a global monotonic counter and a timestamp global for each function, code
// at the beginning of each function to set its timestamp, and a new exported
// function for dumping the profile data.
struct Instrumenter : public Pass {
  PassRunner* runner = nullptr;
  Module* wasm = nullptr;

  const std::string& profileExport;
  uint64_t moduleHash;

  Name counterGlobal;
  std::vector<Name> functionGlobals;

  Instrumenter(const std::string& profileExport, uint64_t moduleHash);

  void run(PassRunner* runner, Module* wasm) override;
  void addGlobals();
  void instrumentFuncs();
  void addProfileExport();
};

Instrumenter::Instrumenter(const std::string& profileExport,
                           uint64_t moduleHash)
  : profileExport(profileExport), moduleHash(moduleHash) {}

void Instrumenter::run(PassRunner* runner, Module* wasm) {
  this->runner = runner;
  this->wasm = wasm;
  addGlobals();
  instrumentFuncs();
  addProfileExport();
}

void Instrumenter::addGlobals() {
  // Create fresh global names (over-reserves, but that's ok)
  counterGlobal = Names::getValidGlobalName(*wasm, "monotonic_counter");
  functionGlobals.reserve(wasm->functions.size());
  ModuleUtils::iterDefinedFunctions(*wasm, [&](Function* func) {
    functionGlobals.push_back(Names::getValidGlobalName(
      *wasm, std::string(func->name.c_str()) + "_timestamp"));
  });

  // Create and add new globals
  auto addGlobal = [&](Name name) {
    auto global = Builder::makeGlobal(
      name,
      Type::i32,
      Builder(*wasm).makeConst(Literal::makeZero(Type::i32)),
      Builder::Mutable);
    global->hasExplicitName = true;
    wasm->addGlobal(std::move(global));
  };
  addGlobal(counterGlobal);
  for (auto& name : functionGlobals) {
    addGlobal(name);
  }
}

void Instrumenter::instrumentFuncs() {
  // Inject the following code at the beginning of each function to advance the
  // monotonic counter and set the function's timestamp if it hasn't already
  // been set.
  //
  //   (if (i32.eqz (global.get $timestamp))
  //     (block
  //       (global.set $monotonic_counter
  //         (i32.add
  //           (global.get $monotonic_counter)
  //           (i32.const 1)
  //         )
  //       )
  //       (global.set $timestamp
  //         (global.get $monotonic_counter)
  //       )
  //     )
  //   )
  Builder builder(*wasm);
  auto globalIt = functionGlobals.begin();
  ModuleUtils::iterDefinedFunctions(*wasm, [&](Function* func) {
    func->body = builder.makeSequence(
      builder.makeIf(
        builder.makeUnary(EqZInt32,
                          builder.makeGlobalGet(*globalIt, Type::i32)),
        builder.makeSequence(
          builder.makeGlobalSet(
            counterGlobal,
            builder.makeBinary(AddInt32,
                               builder.makeGlobalGet(counterGlobal, Type::i32),
                               builder.makeConst(Literal::makeOne(Type::i32)))),
          builder.makeGlobalSet(
            *globalIt, builder.makeGlobalGet(counterGlobal, Type::i32)))),
      func->body,
      func->body->type);
    ++globalIt;
  });
}

// wasm-split profile format:
//
// The wasm-split profile is a binary format designed to be simple to produce
// and consume. It is comprised of:
//
//   1. An 8-byte module hash
//
//   2. A 4-byte timestamp for each defined function
//
// The module hash is meant to guard against bugs where the module that was
// instrumented and the module that is being split are different. The timestamps
// are non-zero for functions that were called during the instrumented run and 0
// otherwise. Functions with smaller non-zero timestamps were called earlier in
// the instrumented run than funtions with larger timestamps.

void Instrumenter::addProfileExport() {
  // Create and export a function to dump the profile into a given memory
  // buffer. The function takes the available address and buffer size as
  // arguments and returns the total size of the profile. It only actually
  // writes the profile if the given space is sufficient to hold it.
  auto name = Names::getValidFunctionName(*wasm, profileExport);
  auto writeProfile = Builder::makeFunction(
    name, Signature({Type::i32, Type::i32}, Type::i32), {});
  writeProfile->hasExplicitName = true;
  writeProfile->setLocalName(0, "addr");
  writeProfile->setLocalName(1, "size");

  // Calculate the size of the profile:
  //   8 bytes module hash +
  //   4 bytes for the timestamp for each function
  const size_t profileSize = 8 + 4 * functionGlobals.size();

  // Create the function body
  Builder builder(*wasm);
  auto getAddr = [&]() { return builder.makeLocalGet(0, Type::i32); };
  auto getSize = [&]() { return builder.makeLocalGet(1, Type::i32); };
  auto hashConst = [&]() { return builder.makeConst(int64_t(moduleHash)); };
  auto profileSizeConst = [&]() {
    return builder.makeConst(int32_t(profileSize));
  };

  // Write the hash followed by all the time stamps
  Expression* writeData =
    builder.makeStore(8, 0, 1, getAddr(), hashConst(), Type::i64);

  uint32_t offset = 8;
  for (const auto& global : functionGlobals) {
    writeData = builder.blockify(
      writeData,
      builder.makeStore(4,
                        offset,
                        1,
                        getAddr(),
                        builder.makeGlobalGet(global, Type::i32),
                        Type::i32));
    offset += 4;
  }

  writeProfile->body = builder.makeSequence(
    builder.makeIf(builder.makeBinary(GeUInt32, getSize(), profileSizeConst()),
                   writeData),
    profileSizeConst());

  // Create an export for the function
  wasm->addFunction(std::move(writeProfile));
  wasm->addExport(
    Builder::makeExport(profileExport, name, ExternalKind::Function));

  // Also make sure there is a memory with enough pages to write into
  size_t pages = (profileSize + Memory::kPageSize - 1) / Memory::kPageSize;
  if (!wasm->memory.exists) {
    wasm->memory.exists = true;
    wasm->memory.initial = pages;
    wasm->memory.max = pages;
  } else if (wasm->memory.initial < pages) {
    wasm->memory.initial = pages;
    if (wasm->memory.max < pages) {
      wasm->memory.max = pages;
    }
  }

  // TODO: export the memory if it is not already exported.
}

uint64_t hashFile(const std::string& filename) {
  auto contents(read_file<std::vector<char>>(filename, Flags::Binary));
  size_t digest = 0;
  // Don't use `hash` or `rehash` - they aren't deterministic between executions
  for (char c : contents) {
    hash_combine(digest, c);
  }
  return uint64_t(digest);
}

void adjustTableSize(Module& wasm, int initialSize) {
  if (initialSize < 0) {
    return;
  }
  if (!wasm.table.exists) {
    Fatal() << "--initial-table used but there is no table";
  }
  if ((uint64_t)initialSize < wasm.table.initial) {
    Fatal() << "Specified initial table size too small, should be at least "
            << wasm.table.initial;
  }
  if ((uint64_t)initialSize > wasm.table.max) {
    Fatal() << "Specified initial table size larger than max table size "
            << wasm.table.max;
  }
  wasm.table.initial = initialSize;
}

void instrumentModule(Module& wasm, const WasmSplitOptions& options) {
  // Check that the profile export name is not already taken
  if (wasm.getExportOrNull(options.profileExport) != nullptr) {
    Fatal() << "error: Export " << options.profileExport << " already exists.";
  }

  uint64_t moduleHash = hashFile(options.input);
  PassRunner runner(&wasm, options.passOptions);
  Instrumenter(options.profileExport, moduleHash).run(&runner, &wasm);

  adjustTableSize(wasm, options.initialTableSize);

  // Write the output modules
  ModuleWriter writer;
  writer.setBinary(options.emitBinary);
  writer.setDebugInfo(options.passOptions.debugInfo);
  writer.write(wasm, options.output);
}

// See "wasm-split profile format" above for more information.
std::set<Name> readProfile(Module& wasm, const WasmSplitOptions& options) {
  auto profileData =
    read_file<std::vector<char>>(options.profileFile, Flags::Binary);
  size_t i = 0;
  auto readi32 = [&]() {
    if (i + 4 > profileData.size()) {
      Fatal() << "Unexpected end of profile data";
    }
    uint32_t i32 = 0;
    i32 |= uint32_t(uint8_t(profileData[i++]));
    i32 |= uint32_t(uint8_t(profileData[i++])) << 8;
    i32 |= uint32_t(uint8_t(profileData[i++])) << 16;
    i32 |= uint32_t(uint8_t(profileData[i++])) << 24;
    return i32;
  };

  // Read and compare the 8-byte module hash.
  uint64_t expected = readi32();
  expected |= uint64_t(readi32()) << 32;
  if (expected != hashFile(options.input)) {
    Fatal() << "error: checksum in profile does not match module checksum. "
            << "The split module must be the original module that was "
            << "instrumented to generate the profile.";
  }

  std::set<Name> keptFuncs;
  ModuleUtils::iterDefinedFunctions(wasm, [&](Function* func) {
    uint32_t timestamp = readi32();
    // TODO: provide an option to set the timestamp threshold. For now, kee the
    // function if the profile shows it being run at all.
    if (timestamp > 0) {
      keptFuncs.insert(func->name);
    }
  });

  if (i != profileData.size()) {
    // TODO: Handle concatenated profile data.
    Fatal() << "Unexpected extra profile data";
  }

  return keptFuncs;
}

void splitModule(Module& wasm, const WasmSplitOptions& options) {
  std::set<Name> keepFuncs;

  if (options.profileFile.size()) {
    // Use the profile to initialize `keepFuncs`
    keepFuncs = readProfile(wasm, options);
  }

  // Add in the functions specified with --keep-funcs
  for (auto& func : options.keepFuncs) {
    if (!options.quiet && wasm.getFunctionOrNull(func) == nullptr) {
      std::cerr << "warning: function " << func << " does not exist\n";
    }
    keepFuncs.insert(func);
  }

  // Remove the functions specified with --remove-funcs
  for (auto& func : options.splitFuncs) {
    auto* function = wasm.getFunctionOrNull(func);
    if (!options.quiet && function == nullptr) {
      std::cerr << "warning: function " << func << " does not exist\n";
    }
    if (function && function->imported()) {
      if (!options.quiet) {
        std::cerr << "warning: cannot split out imported function " << func
                  << "\n";
      }
    } else {
      keepFuncs.erase(func);
    }
  }

  if (!options.quiet && keepFuncs.size() == 0) {
    std::cerr << "warning: not keeping any functions in the primary module\n";
  }

  // If warnings are enabled, check that any functions are being split out.
  if (!options.quiet) {
    std::set<Name> splitFuncs;
    ModuleUtils::iterDefinedFunctions(wasm, [&](Function* func) {
      if (keepFuncs.count(func->name) == 0) {
        splitFuncs.insert(func->name);
      }
    });

    if (splitFuncs.size() == 0) {
      std::cerr
        << "warning: not splitting any functions out to the secondary module\n";
    }

    // Dump the kept and split functions if we are verbose
    if (options.verbose) {
      auto printCommaSeparated = [&](auto funcs) {
        for (auto it = funcs.begin(); it != funcs.end(); ++it) {
          if (it != funcs.begin()) {
            std::cout << ", ";
          }
          std::cout << *it;
        }
      };

      std::cout << "Keeping functions: ";
      printCommaSeparated(keepFuncs);
      std::cout << "\n";

      std::cout << "Splitting out functions: ";
      printCommaSeparated(splitFuncs);
      std::cout << "\n";
    }
  }

  // Actually perform the splitting
  ModuleSplitting::Config config;
  config.primaryFuncs = std::move(keepFuncs);
  if (options.importNamespace.size()) {
    config.importNamespace = options.importNamespace;
  }
  if (options.placeholderNamespace.size()) {
    config.placeholderNamespace = options.placeholderNamespace;
  }
  if (options.exportPrefix.size()) {
    config.newExportPrefix = options.exportPrefix;
  }
  std::unique_ptr<Module> secondary =
    ModuleSplitting::splitFunctions(wasm, config);

  adjustTableSize(wasm, options.initialTableSize);
  adjustTableSize(*secondary, options.initialTableSize);

  // Write the output modules
  ModuleWriter writer;
  writer.setBinary(options.emitBinary);
  writer.setDebugInfo(options.passOptions.debugInfo);
  writer.write(wasm, options.primaryOutput);
  writer.write(*secondary, options.secondaryOutput);
}

} // anonymous namespace

int main(int argc, const char* argv[]) {
  WasmSplitOptions options;
  options.parse(argc, argv);

  if (!options.validate()) {
    Fatal() << "Invalid command line arguments";
  }

  Module wasm;
  parseInput(wasm, options);

  if (options.passOptions.validate && !WasmValidator().validate(wasm)) {
    Fatal() << "error validating input";
  }

  if (options.instrument) {
    instrumentModule(wasm, options);
  } else {
    splitModule(wasm, options);
  }
}
