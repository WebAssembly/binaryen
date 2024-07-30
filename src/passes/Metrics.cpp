/*
 * Copyright 2016 WebAssembly Community Group participants
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

#include <algorithm>
#include <iomanip>
#include <ir/module-utils.h>
#include <pass.h>
#include <support/colors.h>
#include <wasm-binary.h>
#include <wasm.h>

namespace wasm {

using Counts = std::map<const char*, int>;

static Counts lastCounts;

// Prints metrics between optimization passes.
struct Metrics
  : public WalkerPass<PostWalker<Metrics, UnifiedExpressionVisitor<Metrics>>> {
  bool modifiesBinaryenIR() override { return false; }

  bool byFunction;

  Counts counts;

  Metrics(bool byFunction) : byFunction(byFunction) {}

  void visitExpression(Expression* curr) {
    auto name = getExpressionName(curr);
    counts[name]++;
  }

  void doWalkModule(Module* module) {
    std::string title = getArgumentOrDefault("metrics", "");
    std::cout << "Metrics";
    if (!title.empty()) {
      std::cout << ": " << title;
    }
    std::cout << '\n';

    ImportInfo imports(*module);

    // global things
    for (auto& curr : module->exports) {
      visitExport(curr.get());
    }
    ModuleUtils::iterDefinedGlobals(*module,
                                    [&](Global* curr) { walkGlobal(curr); });

    // add imports / funcs / globals / exports / tables / memories
    counts["[imports]"] = imports.getNumImports();
    counts["[funcs]"] = imports.getNumDefinedFunctions();
    counts["[globals]"] = imports.getNumDefinedGlobals();
    counts["[tags]"] = imports.getNumDefinedTags();
    counts["[exports]"] = module->exports.size();
    counts["[tables]"] = imports.getNumDefinedTables();
    counts["[memories]"] = imports.getNumDefinedMemories();

    // add memory
    for (auto& memory : module->memories) {
      walkMemory(memory.get());
    }
    Index size = 0;
    for (auto& segment : module->dataSegments) {
      walkDataSegment(segment.get());
      size += segment->data.size();
    }
    if (!module->memories.empty()) {
      counts["[memory-data]"] = size;
    }

    // add table
    size = 0;
    for (auto& table : module->tables) {
      walkTable(table.get());
    }
    for (auto& segment : module->elementSegments) {
      walkElementSegment(segment.get());
      size += segment->data.size();
    }
    if (!module->tables.empty()) {
      counts["[table-data]"] = size;
    }

    if (byFunction) {
      // print global
      printCounts("global");
      // compute binary info, so we know function sizes
      BufferWithRandomAccess buffer;
      WasmBinaryWriter writer(module, buffer, getPassOptions());
      writer.write();
      // print for each function
      Index binaryIndex = 0;
      ModuleUtils::iterDefinedFunctions(*module, [&](Function* func) {
        counts.clear();
        walkFunction(func);
        counts["[vars]"] = func->getNumVars();
        counts["[binary-bytes]"] =
          writer.tableOfContents.functionBodies[binaryIndex++].size;
        printCounts(std::string("func: ") + func->name.toString());
      });
      // print for each export how much code size is due to it, i.e.,
      // how much the module could shrink without it.
      auto sizeAfterGlobalCleanup = [&](Module* module) {
        PassRunner runner(module,
                          PassOptions::getWithDefaultOptimizationOptions());
        runner.setIsNested(true);
        runner.addDefaultGlobalOptimizationPostPasses(); // remove stuff
        runner.run();
        BufferWithRandomAccess buffer;
        WasmBinaryWriter writer(module, buffer, getPassOptions());
        writer.write();
        return buffer.size();
      };
      size_t baseline;
      {
        Module test;
        ModuleUtils::copyModule(*module, test);
        baseline = sizeAfterGlobalCleanup(&test);
      }
      for (auto& exp : module->exports) {
        // create a test module where we remove the export and then see how much
        // can be removed thanks to that
        Module test;
        ModuleUtils::copyModule(*module, test);
        test.removeExport(exp->name);
        counts.clear();
        counts["[removable-bytes-without-it]"] =
          baseline - sizeAfterGlobalCleanup(&test);
        printCounts(std::string("export: ") + exp->name.toString() + " (" +
                    exp->value.toString() + ')');
      }
      // check how much size depends on the start method
      if (!module->start.isNull()) {
        Module test;
        ModuleUtils::copyModule(*module, test);
        test.start = Name();
        counts.clear();
        counts["[removable-bytes-without-it]"] =
          baseline - sizeAfterGlobalCleanup(&test);
        printCounts(std::string("start: ") + module->start.toString());
      }
      // can't compare detailed info between passes yet
      lastCounts.clear();
    } else {
      // add function info
      size_t vars = 0;
      ModuleUtils::iterDefinedFunctions(*module, [&](Function* func) {
        walkFunction(func);
        vars += func->getNumVars();
      });
      counts["[vars]"] = vars;
      // print
      printCounts("total");
      // compare to next time
      lastCounts = counts;
    }
  }

  void printCounts(std::string title) {
    using std::left;
    using std::noshowpos;
    using std::right;
    using std::setw;
    using std::showpos;

    std::ostream& o = std::cout;
    std::vector<const char*> keys;
    // add total
    int total = 0;
    for (auto& [key, value] : counts) {
      keys.push_back(key);
      // total is of all the normal stuff, not the special [things]
      if (key[0] != '[') {
        total += value;
      }
    }
    keys.push_back("[total]");
    counts["[total]"] = total;
    // sort
    sort(keys.begin(), keys.end(), [](const char* a, const char* b) -> bool {
      // Sort the [..] ones first.
      if (a[0] == '[' && b[0] != '[') {
        return true;
      }
      if (a[0] != '[' && b[0] == '[') {
        return false;
      }
      return strcmp(b, a) > 0;
    });
    o << title << "\n";
    for (auto* key : keys) {
      auto value = counts[key];
      if (value == 0 && key[0] != '[') {
        continue;
      }
      o << " " << left << setw(15) << key << ": " << setw(8) << value;
      if (lastCounts.count(key)) {
        int before = lastCounts[key];
        int after = value;
        if (after - before) {
          if (after > before) {
            Colors::red(o);
          } else {
            Colors::green(o);
          }
          o << right << setw(8);
          o << showpos << after - before << noshowpos;
          Colors::normal(o);
        }
      }
      o << "\n";
    }
  }
};

Pass* createMetricsPass() { return new Metrics(false); }

Pass* createFunctionMetricsPass() { return new Metrics(true); }

} // namespace wasm
