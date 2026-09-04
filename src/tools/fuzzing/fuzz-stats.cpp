/*
 * Copyright 2024 WebAssembly Community Group participants
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

#include "tools/fuzzing/fuzz-stats.h"
#include "wasm-traversal.h"

#include <algorithm>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <map>
#include <set>
#include <sstream>
#include <vector>

#ifndef _WIN32
#include <fcntl.h>
#include <sys/file.h>
#include <unistd.h>
#endif

namespace wasm {

namespace {

struct FileLock {
#ifndef _WIN32
  int fd = -1;
  FileLock(const std::string& path) {
    fd = open(path.c_str(), O_RDWR | O_CREAT, 0666);
    if (fd >= 0) {
      flock(fd, LOCK_EX);
    }
  }
  ~FileLock() {
    if (fd >= 0) {
      flock(fd, LOCK_UN);
      close(fd);
    }
  }
#else
  FileLock(const std::string&) {}
#endif
};

std::string getStatsFilename() {
  if (const char* env = getenv("BINARYEN_FUZZ_STATS")) {
    if (env[0] != '\0') {
      std::string str(env);
      if (str == "1" || str == "true" || str == "on" || str == "yes") {
        return "fuzz-stats.txt";
      }
      return str;
    }
  }
  return "";
}

// List of standard patterns to track and report in order.
const std::vector<std::string> KnownPatterns = {
  "br_on_null",
  "br_on_non_null",
  "br_on_cast",
  "br_on_cast_fail",
  "br_on_cast_desc_eq",
  "br_on_cast_desc_eq_fail",
  "ref_cast",
  "ref_cast_desc_eq",
  "ref_test",
};

struct FuzzStatsVisitor : public PostWalker<FuzzStatsVisitor> {
  // Counts within the current function: pattern name -> count
  std::map<std::string, uint64_t> currentFuncCounts;

  // Pattern stats for this module: pattern name -> total occurrences
  std::map<std::string, uint64_t> occurrences;
  // pattern name -> number of functions with >= 1 occurrence
  std::map<std::string, uint64_t> funcMatches;
  uint64_t numFunctions = 0;

  FuzzStatsVisitor() {
    for (const auto& name : KnownPatterns) {
      occurrences[name] = 0;
      funcMatches[name] = 0;
    }
  }

  void record(const std::string& name) { currentFuncCounts[name]++; }

  void visitFunction(Function* func) {
    if (func->imported() || !func->body) {
      return;
    }
    numFunctions++;
    for (const auto& [name, count] : currentFuncCounts) {
      if (count > 0) {
        occurrences[name] += count;
        funcMatches[name]++;
      }
    }
    currentFuncCounts.clear();
  }

  void visitBrOn(BrOn* curr) {
    switch (curr->op) {
      case BrOnNull:
        record("br_on_null");
        break;
      case BrOnNonNull:
        record("br_on_non_null");
        break;
      case BrOnCast:
        record("br_on_cast");
        break;
      case BrOnCastFail:
        record("br_on_cast_fail");
        break;
      case BrOnCastDescEq:
        record("br_on_cast_desc_eq");
        break;
      case BrOnCastDescEqFail:
        record("br_on_cast_desc_eq_fail");
        break;
    }
  }

  void visitRefCast(RefCast* curr) {
    if (curr->desc) {
      record("ref_cast_desc_eq");
    } else {
      record("ref_cast");
    }
  }

  void visitRefTest(RefTest* curr) { record("ref_test"); }
};

struct PatternStatsRecord {
  uint64_t occurrences = 0;
  uint64_t inModules = 0;
  uint64_t inFunctions = 0;
};

} // namespace

namespace FuzzStats {

void collect(Module& wasm) {
  std::string filename = getStatsFilename();
  if (filename.empty()) {
    return;
  }

  FuzzStatsVisitor visitor;
  for (const auto& func : wasm.functions) {
    if (!func->imported() && func->body) {
      visitor.walkFunction(func.get());
    }
  }

  // Lock file for safe concurrent updates across processes.
  FileLock lock(filename + ".lock");

  // Read existing statistics from file if present.
  uint64_t totalModules = 0;
  uint64_t totalFunctions = 0;
  std::map<std::string, PatternStatsRecord> statsMap;

  {
    std::ifstream in(filename);
    if (in.is_open()) {
      std::string line;
      bool inPatterns = false;
      while (std::getline(in, line)) {
        if (!line.empty() && line.back() == '\r') {
          line.pop_back();
        }
        if (line.empty() || line[0] == '#') {
          continue;
        }
        std::stringstream ss(line);
        std::string key;
        if (ss >> key) {
          if (key == "Modules:") {
            ss >> totalModules;
          } else if (key == "Functions:") {
            ss >> totalFunctions;
          } else if (key == "Patterns:") {
            inPatterns = true;
          } else if (inPatterns) {
            std::string name = key;
            uint64_t occurrences = 0;
            std::string perModStr, perFuncStr;
            uint64_t inMods = 0;
            std::string pctModStr;
            uint64_t inFuncs = 0;
            std::string pctFuncStr;
            if (ss >> occurrences >> perModStr >> perFuncStr >> inMods >>
                pctModStr >> inFuncs >> pctFuncStr) {
              statsMap[name] = {occurrences, inMods, inFuncs};
            } else {
              statsMap[name].occurrences = occurrences;
            }
          }
        }
      }
    }
  }

  // Accumulate current run into overall statistics.
  totalModules += 1;
  totalFunctions += visitor.numFunctions;

  for (const auto& [name, count] : visitor.occurrences) {
    auto& record = statsMap[name];
    record.occurrences += count;
    record.inFunctions += visitor.funcMatches[name];
    if (count > 0) {
      record.inModules += 1;
    }
  }

  // Write updated statistics to a temporary file and atomically rename.
  std::string tmpFilename = filename + ".tmp";
  {
    std::ofstream out(tmpFilename);
    if (!out.is_open()) {
      return;
    }

    out << "# Binaryen Fuzzing Statistics\n";
    out << "Modules: " << totalModules << "\n";
    out << "Functions: " << totalFunctions << "\n\n";
    out << "Patterns:\n";
    out << "# " << std::left << std::setw(30) << "Name" << std::right
        << std::setw(12) << "Occurrences" << std::setw(14) << "Per Module"
        << std::setw(14) << "Per Function" << std::setw(10) << "Modules"
        << std::setw(12) << "% Modules" << std::setw(12) << "Functions"
        << std::setw(14) << "% Functions"
        << "\n";

    std::set<std::string> writtenPatterns;
    auto writeRow = [&](const std::string& name,
                        const PatternStatsRecord& data) {
      double perMod =
        totalModules > 0 ? (double)data.occurrences / totalModules : 0.0;
      double perFunc =
        totalFunctions > 0 ? (double)data.occurrences / totalFunctions : 0.0;
      double pctMod =
        totalModules > 0 ? (100.0 * data.inModules) / totalModules : 0.0;
      double pctFunc =
        totalFunctions > 0 ? (100.0 * data.inFunctions) / totalFunctions : 0.0;

      std::ostringstream pctModStream, pctFuncStream;
      pctModStream << std::fixed << std::setprecision(2) << pctMod << "%";
      pctFuncStream << std::fixed << std::setprecision(2) << pctFunc << "%";

      out << "  " << std::left << std::setw(30) << name << std::right
          << std::setw(12) << data.occurrences << std::setw(14) << std::fixed
          << std::setprecision(4) << perMod << std::setw(14) << std::fixed
          << std::setprecision(4) << perFunc << std::setw(10) << data.inModules
          << std::setw(12) << pctModStream.str() << std::setw(12)
          << data.inFunctions << std::setw(14) << pctFuncStream.str() << "\n";
    };

    for (const auto& name : KnownPatterns) {
      writeRow(name, statsMap[name]);
      writtenPatterns.insert(name);
    }
    for (const auto& [name, data] : statsMap) {
      if (writtenPatterns.find(name) == writtenPatterns.end()) {
        writeRow(name, data);
      }
    }
  }

  rename(tmpFilename.c_str(), filename.c_str());

  if (getenv("BINARYEN_FUZZ_STATS_VERBOSE")) {
    std::cerr << "Fuzz stats updated in " << filename
              << " (Total Modules: " << totalModules
              << ", Total Functions: " << totalFunctions << ")\n";
  }
}

} // namespace FuzzStats

} // namespace wasm
