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

#include <fstream>

#include "ir/module-splitting.h"
#include "ir/names.h"
#include "support/file.h"
#include "support/name.h"
#include "support/path.h"
#include "support/utilities.h"
#include "wasm-binary.h"
#include "wasm-builder.h"
#include "wasm-io.h"
#include "wasm-validator.h"

#include "instrumenter.h"
#include "split-options.h"

using namespace wasm;

namespace {

void parseInput(Module& wasm, const WasmSplitOptions& options) {
  options.applyFeatures(wasm);
  ModuleReader reader;
  reader.setProfile(options.profile);
  try {
    reader.read(options.inputFiles[0], wasm);
  } catch (ParseException& p) {
    p.dump(std::cerr);
    std::cerr << '\n';
    Fatal() << "error parsing wasm";
  } catch (std::bad_alloc&) {
    Fatal() << "error building module, std::bad_alloc (possibly invalid "
               "request for silly amounts of memory)";
  }

  if (options.passOptions.validate && !WasmValidator().validate(wasm)) {
    Fatal() << "error validating input";
  }
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
  if (wasm.tables.empty()) {
    Fatal() << "--initial-table used but there is no table";
  }

  auto& table = wasm.tables.front();

  if ((uint64_t)initialSize < table->initial) {
    Fatal() << "Specified initial table size too small, should be at least "
            << table->initial;
  }
  if ((uint64_t)initialSize > table->max) {
    Fatal() << "Specified initial table size larger than max table size "
            << table->max;
  }
  table->initial = initialSize;
}

void writeModule(Module& wasm,
                 std::string filename,
                 const WasmSplitOptions& options) {
  ModuleWriter writer(options.passOptions);
  writer.setBinary(options.emitBinary);
  writer.setDebugInfo(options.passOptions.debugInfo);
  if (options.emitModuleNames) {
    writer.setEmitModuleName(true);
  }
  writer.write(wasm, filename);
}

void instrumentModule(const WasmSplitOptions& options) {
  Module wasm;
  parseInput(wasm, options);

  // Check that the profile export name is not already taken
  if (wasm.getExportOrNull(options.profileExport) != nullptr) {
    Fatal() << "error: Export " << options.profileExport << " already exists.";
  }

  uint64_t moduleHash = hashFile(options.inputFiles[0]);
  InstrumenterConfig config;
  if (options.importNamespace.size()) {
    config.importNamespace = options.importNamespace;
  }
  if (options.secondaryMemoryName.size()) {
    config.secondaryMemoryName = options.secondaryMemoryName;
  }
  config.storageKind = options.storageKind;
  config.profileExport = options.profileExport;

  PassRunner runner(&wasm, options.passOptions);
  runner.add(std::make_unique<Instrumenter>(config, moduleHash));
  runner.run();

  adjustTableSize(wasm, options.initialTableSize);

  // Write the output modules
  writeModule(wasm, options.output, options);
}

struct ProfileData {
  uint64_t hash;
  std::vector<size_t> timestamps;
};

// See "wasm-split profile format" in instrumenter.cpp for more information.
ProfileData readProfile(const std::string& file) {
  auto profileData = read_file<std::vector<char>>(file, Flags::Binary);
  size_t i = 0;
  auto readi32 = [&]() {
    if (i + 4 > profileData.size()) {
      Fatal() << "Unexpected end of profile data in " << file;
    }
    uint32_t i32 = 0;
    i32 |= uint32_t(uint8_t(profileData[i++]));
    i32 |= uint32_t(uint8_t(profileData[i++])) << 8;
    i32 |= uint32_t(uint8_t(profileData[i++])) << 16;
    i32 |= uint32_t(uint8_t(profileData[i++])) << 24;
    return i32;
  };

  uint64_t hash = readi32();
  hash |= uint64_t(readi32()) << 32;

  std::vector<size_t> timestamps;
  while (i < profileData.size()) {
    timestamps.push_back(readi32());
  }

  return {hash, timestamps};
}

void getFunctionsToKeepAndSplit(Module& wasm,
                                uint64_t wasmHash,
                                const std::string& profileFile,
                                std::set<Name>& keepFuncs,
                                std::set<Name>& splitFuncs) {
  ProfileData profile = readProfile(profileFile);
  if (profile.hash != wasmHash) {
    Fatal() << "error: checksum in profile does not match module checksum. "
            << "The module to split must be the original, uninstrumented "
               "module, not the module used to generate the profile.";
  }

  size_t i = 0;
  ModuleUtils::iterDefinedFunctions(wasm, [&](Function* func) {
    if (i >= profile.timestamps.size()) {
      Fatal() << "Unexpected end of profile data";
    }
    if (profile.timestamps[i++] > 0) {
      keepFuncs.insert(func->name);
    } else {
      splitFuncs.insert(func->name);
    }
  });
  if (i != profile.timestamps.size()) {
    Fatal() << "Unexpected extra profile data";
  }
}

void writeSymbolMap(Module& wasm, std::string filename) {
  PassOptions options;
  PassRunner runner(&wasm, options);
  runner.add("symbolmap", filename);
  runner.run();
}

void writePlaceholderMap(const std::map<size_t, Name> placeholderMap,
                         std::string filename) {
  Output output(filename, Flags::Text);
  auto& o = output.getStream();
  for (auto& [index, func] : placeholderMap) {
    o << index << ':' << func << '\n';
  }
}

void splitModule(const WasmSplitOptions& options) {
  Module wasm;
  parseInput(wasm, options);

  std::set<Name> keepFuncs;
  std::set<Name> splitFuncs;

  if (options.profileFile.size()) {
    // Use the profile to set `keepFuncs`.
    uint64_t hash = hashFile(options.inputFiles[0]);
    getFunctionsToKeepAndSplit(
      wasm, hash, options.profileFile, keepFuncs, splitFuncs);
  }

  if (options.keepFuncs.size()) {
    // Use the explicitly provided `keepFuncs`.
    for (auto& func : options.keepFuncs) {
      if (!options.quiet && wasm.getFunctionOrNull(func) == nullptr) {
        std::cerr << "warning: function " << func << " does not exist\n";
        continue;
      }

      keepFuncs.insert(func);
      splitFuncs.erase(func);
    }
  }

  if (options.splitFuncs.size()) {
    // Use the explicitly provided `splitFuncs`.
    for (auto& func : options.splitFuncs) {
      auto* function = wasm.getFunctionOrNull(func);
      if (!options.quiet && function == nullptr) {
        std::cerr << "warning: function " << func << " does not exist\n";
        continue;
      }
      if (function && function->imported()) {
        if (!options.quiet) {
          std::cerr << "warning: cannot split out imported function " << func
                    << "\n";
        }
      } else {
        if (!options.quiet && keepFuncs.count(func) > 0) {
          std::cerr
            << "warning: function " << func
            << " was to be kept in primary module. "
            << "However it will now be split out into secondary module.\n";
        }

        splitFuncs.insert(func);
        keepFuncs.erase(func);
      }
    }

    if (keepFuncs.empty()) {
      // could be the case where every function has been split out
      // or when `splitFuncs` is used standalone, which is the case we'll cover
      // here
      for (auto& func : wasm.functions) {
        if (splitFuncs.count(func->name) == 0) {
          keepFuncs.insert(func->name);
        }
      }
    }
  }

  if (!options.quiet && keepFuncs.size() == 0) {
    std::cerr << "warning: not keeping any functions in the primary module\n";
  }

  if (options.jspi) {
    // The load secondary module function must be kept in the main module.
    keepFuncs.insert(ModuleSplitting::LOAD_SECONDARY_MODULE);
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
  config.minimizeNewExportNames = !options.passOptions.debugInfo;
  config.jspi = options.jspi;
  auto splitResults = ModuleSplitting::splitFunctions(wasm, config);
  auto& secondary = splitResults.secondary;

  adjustTableSize(wasm, options.initialTableSize);
  adjustTableSize(*secondary, options.initialTableSize);

  if (options.symbolMap) {
    writeSymbolMap(wasm, options.primaryOutput + ".symbols");
    writeSymbolMap(*secondary, options.secondaryOutput + ".symbols");
  }

  if (options.placeholderMap) {
    writePlaceholderMap(splitResults.placeholderMap,
                        options.primaryOutput + ".placeholders");
  }

  // Set the names of the split modules. This can help differentiate them in
  // stack traces.
  if (options.emitModuleNames) {
    if (!wasm.name) {
      wasm.name = Path::getBaseName(options.primaryOutput);
    }
    secondary->name = Path::getBaseName(options.secondaryOutput);
  }

  // write the output modules
  writeModule(wasm, options.primaryOutput, options);
  writeModule(*secondary, options.secondaryOutput, options);
}

void mergeProfiles(const WasmSplitOptions& options) {
  // Read the initial profile. We will merge other profiles into this one.
  ProfileData data = readProfile(options.inputFiles[0]);

  // In verbose mode, we want to find profiles that don't contribute to the
  // merged profile. To do that, keep track of how many profiles each function
  // appears in. If any profile contains only functions that appear in multiple
  // profiles, it could be dropped.
  std::vector<size_t> numProfiles;
  if (options.verbose) {
    numProfiles.resize(data.timestamps.size());
    for (size_t t = 0; t < data.timestamps.size(); ++t) {
      if (data.timestamps[t]) {
        numProfiles[t] = 1;
      }
    }
  }

  // Read all the other profiles, taking the minimum nonzero timestamp for each
  // function.
  for (size_t i = 1; i < options.inputFiles.size(); ++i) {
    ProfileData newData = readProfile(options.inputFiles[i]);
    if (newData.hash != data.hash) {
      Fatal() << "Checksum in profile " << options.inputFiles[i]
              << " does not match hash in profile " << options.inputFiles[0];
    }
    if (newData.timestamps.size() != data.timestamps.size()) {
      Fatal() << "Profile " << options.inputFiles[i]
              << " incompatible with profile " << options.inputFiles[0];
    }
    for (size_t t = 0; t < data.timestamps.size(); ++t) {
      if (data.timestamps[t] && newData.timestamps[t]) {
        data.timestamps[t] =
          std::min(data.timestamps[t], newData.timestamps[t]);
      } else if (newData.timestamps[t]) {
        data.timestamps[t] = newData.timestamps[t];
      }
      if (options.verbose && newData.timestamps[t]) {
        ++numProfiles[t];
      }
    }
  }

  // Check for useless profiles.
  if (options.verbose) {
    for (const auto& file : options.inputFiles) {
      bool useless = true;
      ProfileData newData = readProfile(file);
      for (size_t t = 0; t < newData.timestamps.size(); ++t) {
        if (newData.timestamps[t] && numProfiles[t] == 1) {
          useless = false;
          break;
        }
      }
      if (useless) {
        std::cout << "Profile " << file
                  << " only includes functions included in other profiles.\n";
      }
    }
  }

  // Write the combined profile.
  BufferWithRandomAccess buffer;
  buffer << data.hash;
  for (size_t t = 0; t < data.timestamps.size(); ++t) {
    buffer << uint32_t(data.timestamps[t]);
  }
  Output out(options.output, Flags::Binary);
  buffer.writeTo(out.getStream());
}

std::string unescape(std::string input) {
  std::string output;
  for (size_t i = 0; i < input.length(); i++) {
    if ((input[i] == '\\') && (i + 2 < input.length()) &&
        isxdigit(input[i + 1]) && isxdigit(input[i + 2])) {
      std::string byte = input.substr(i + 1, 2);
      i += 2;
      char chr = (char)(int)strtol(byte.c_str(), nullptr, 16);
      output.push_back(chr);
    } else {
      output.push_back(input[i]);
    }
  }
  return output;
}

void checkExists(const std::string& path) {
  std::ifstream infile(path);
  if (!infile.is_open()) {
    Fatal() << "File not found: " << path;
  }
}

void printReadableProfile(const WasmSplitOptions& options) {
  const std::string wasmFile(options.inputFiles[0]);
  checkExists(options.profileFile);
  checkExists(wasmFile);

  Module wasm;
  parseInput(wasm, options);

  std::set<Name> keepFuncs;
  std::set<Name> splitFuncs;

  uint64_t hash = hashFile(wasmFile);
  getFunctionsToKeepAndSplit(
    wasm, hash, options.profileFile, keepFuncs, splitFuncs);

  auto printFnSet = [&](auto funcs, std::string prefix) {
    for (auto it = funcs.begin(); it != funcs.end(); ++it) {
      std::cout << prefix << " "
                << (options.unescape ? unescape(it->toString())
                                     : it->toString())
                << std::endl;
    }
  };

  std::cout << "Keeping functions: " << std::endl;
  printFnSet(keepFuncs, "+");
  std::cout << std::endl;

  std::cout << "Splitting out functions: " << std::endl;
  printFnSet(splitFuncs, "-");
  std::cout << std::endl;
}

} // anonymous namespace

int main(int argc, const char* argv[]) {
  WasmSplitOptions options;
  options.parse(argc, argv);

  if (!options.validate()) {
    Fatal() << "Invalid command line arguments";
  }

  switch (options.mode) {
    case WasmSplitOptions::Mode::Split:
      splitModule(options);
      break;
    case WasmSplitOptions::Mode::Instrument:
      instrumentModule(options);
      break;
    case WasmSplitOptions::Mode::MergeProfiles:
      mergeProfiles(options);
      break;
    case WasmSplitOptions::Mode::PrintProfile:
      printReadableProfile(options);
      break;
  }
}
