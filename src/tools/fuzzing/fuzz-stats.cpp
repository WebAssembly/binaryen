/*
 * Copyright 2026 WebAssembly Community Group participants
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
#include "support/file_lock.h"

#include <algorithm>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <map>
#include <mutex>
#include <sstream>

namespace wasm {

namespace {

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

struct PatternStatsRecord {
  uint64_t occurrences = 0;
  uint64_t inModules = 0;
  uint64_t inFunctions = 0;
};

std::mutex eventsMutex;
std::map<std::string, std::map<int, uint64_t>> pendingEvents;

void saveStats(bool hasModuleStats,
               uint64_t numFunctions,
               const std::map<std::string, uint64_t>* occurrences,
               const std::map<std::string, uint64_t>* funcMatches) {
  std::string filename = getStatsFilename();
  if (filename.empty()) {
    return;
  }

  std::map<std::string, std::map<int, uint64_t>> localEvents;
  {
    std::lock_guard<std::mutex> lock(eventsMutex);
    localEvents.swap(pendingEvents);
  }

  if (!hasModuleStats && localEvents.empty()) {
    return;
  }

  // Lock file for safe concurrent updates across processes.
  FileLock lock(filename + ".lock");

  // Read existing statistics from file if present.
  uint64_t totalModules = 0;
  uint64_t totalFunctions = 0;
  std::map<std::string, PatternStatsRecord> statsMap;
  std::map<std::string, std::map<int, uint64_t>> eventStatsMap;

  enum class Section { None, Patterns, Events };

  {
    std::ifstream in(filename);
    if (in.is_open()) {
      std::string line;
      Section section = Section::None;
      std::string currentEvent;
      while (std::getline(in, line)) {
        if (!line.empty() && line.back() == '\r') {
          line.pop_back();
        }
        if (line.empty() || line[0] == '#') {
          continue;
        }
        if (line == "Patterns:") {
          section = Section::Patterns;
          continue;
        }
        if (line == "Events:") {
          section = Section::Events;
          currentEvent.clear();
          continue;
        }
        if (section == Section::Events) {
          if (line.rfind("    ", 0) == 0) {
            std::stringstream ss(line);
            int outcome = 0;
            char colon = 0;
            uint64_t count = 0;
            if (!currentEvent.empty() && (ss >> outcome >> colon) &&
                colon == ':' && (ss >> count)) {
              eventStatsMap[currentEvent][outcome] = count;
            }
          } else if (line.rfind("  ", 0) == 0) {
            currentEvent = line.substr(2);
            if (!currentEvent.empty() && currentEvent.back() == ':') {
              currentEvent.pop_back();
            }
          }
          continue;
        }

        std::stringstream ss(line);
        std::string key;
        if (ss >> key) {
          if (key == "Modules:") {
            ss >> totalModules;
          } else if (key == "Functions:") {
            ss >> totalFunctions;
          } else if (section == Section::Patterns) {
            std::string name = key;
            uint64_t occurrencesCount = 0;
            std::string perModStr, perFuncStr;
            uint64_t inMods = 0;
            std::string pctModStr;
            uint64_t inFuncs = 0;
            std::string pctFuncStr;
            if (ss >> occurrencesCount >> perModStr >> perFuncStr >> inMods >>
                pctModStr >> inFuncs >> pctFuncStr) {
              statsMap[name] = {occurrencesCount, inMods, inFuncs};
            } else {
              statsMap[name].occurrences = occurrencesCount;
            }
          }
        }
      }
    }
  }

  // Accumulate current run into overall statistics.
  if (hasModuleStats) {
    totalModules += 1;
    totalFunctions += numFunctions;

    if (occurrences && funcMatches) {
      for (const auto& [name, count] : *occurrences) {
        auto& record = statsMap[name];
        record.occurrences += count;
        record.inFunctions += funcMatches->at(name);
        if (count > 0) {
          record.inModules += 1;
        }
      }
    }
  }

  for (const auto& [eventName, outcomes] : localEvents) {
    for (const auto& [outcome, count] : outcomes) {
      eventStatsMap[eventName][outcome] += count;
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
    out << "Functions: " << totalFunctions << "\n";

    if (!statsMap.empty()) {
      out << "\nPatterns:\n";
      out << "# " << std::left << std::setw(30) << "Name" << std::right
          << std::setw(12) << "Occurrences" << std::setw(14) << "Per Module"
          << std::setw(14) << "Per Function" << std::setw(10) << "Modules"
          << std::setw(12) << "% Modules" << std::setw(12) << "Functions"
          << std::setw(14) << "% Functions"
          << "\n";

      for (const auto& [name, data] : statsMap) {
        double perMod =
          totalModules > 0 ? (double)data.occurrences / totalModules : 0.0;
        double perFunc =
          totalFunctions > 0 ? (double)data.occurrences / totalFunctions : 0.0;
        double pctMod =
          totalModules > 0 ? (100.0 * data.inModules) / totalModules : 0.0;
        double pctFunc = totalFunctions > 0
                           ? (100.0 * data.inFunctions) / totalFunctions
                           : 0.0;

        std::ostringstream pctModStream, pctFuncStream;
        pctModStream << std::fixed << std::setprecision(2) << pctMod << "%";
        pctFuncStream << std::fixed << std::setprecision(2) << pctFunc << "%";

        out << "  " << std::left << std::setw(30) << name << std::right
            << std::setw(12) << data.occurrences << std::setw(14) << std::fixed
            << std::setprecision(4) << perMod << std::setw(14) << std::fixed
            << std::setprecision(4) << perFunc << std::setw(10)
            << data.inModules << std::setw(12) << pctModStream.str()
            << std::setw(12) << data.inFunctions << std::setw(14)
            << pctFuncStream.str() << "\n";
      }
    }

    if (!eventStatsMap.empty()) {
      out << "\nEvents:\n";
      for (const auto& [eventName, outcomes] : eventStatsMap) {
        uint64_t totalEventCount = 0;
        for (const auto& [outcome, count] : outcomes) {
          totalEventCount += count;
        }
        out << "  " << eventName << ":\n";
        for (const auto& [outcome, count] : outcomes) {
          double pct =
            totalEventCount > 0 ? (100.0 * count) / totalEventCount : 0.0;
          std::ostringstream pctStream;
          pctStream << std::fixed << std::setprecision(2) << pct << "%";
          out << "    " << std::left << std::setw(8)
              << (std::to_string(outcome) + ":") << std::right << std::setw(12)
              << count << " (" << std::setw(7) << pctStream.str() << ")\n";
        }
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

struct EventFlusher {
  ~EventFlusher() { saveStats(false, 0, nullptr, nullptr); }
} eventFlusher;

} // namespace

namespace FuzzStats {

bool isEnabled() {
  static const bool enabled = !getStatsFilename().empty();
  return enabled;
}

int recordEvent(const std::string& name, int outcome) {
  if (!isEnabled()) {
    return outcome;
  }
  std::lock_guard<std::mutex> lock(eventsMutex);
  pendingEvents[name][outcome]++;
  return outcome;
}

int recordEvent(const std::string& name,
                const char* file,
                int line,
                int outcome) {
  if (!isEnabled()) {
    return outcome;
  }
  const char* filename = file;
  for (const char* p = file; *p; ++p) {
    if (*p == '/' || *p == '\\') {
      filename = p + 1;
    }
  }
  return recordEvent(name + " (" + filename + ":" + std::to_string(line) + ")",
                     outcome);
}

void save(uint64_t numFunctions,
          const std::map<std::string, uint64_t>& occurrences,
          const std::map<std::string, uint64_t>& funcMatches) {
  saveStats(true, numFunctions, &occurrences, &funcMatches);
}

} // namespace FuzzStats

} // namespace wasm
