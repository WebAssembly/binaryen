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

#ifndef wasm_tools_optimization_options_h
#define wasm_tools_optimization_options_h

#include "tool-options.h"

//
// Shared optimization options for commandline tools
//

namespace wasm {

struct OptimizationOptions : public ToolOptions {
  static constexpr const char* DEFAULT_OPT_PASSES = "O";

  std::vector<std::string> passes;

  OptimizationOptions(const std::string& command,
                      const std::string& description)
    : ToolOptions(command, description) {
    (*this)
      .add("",
           "-O",
           "execute default optimization passes",
           Options::Arguments::Zero,
           [this](Options*, const std::string&) {
             passOptions.setDefaultOptimizationOptions();
             passes.push_back(DEFAULT_OPT_PASSES);
           })
      .add("",
           "-O0",
           "execute no optimization passes",
           Options::Arguments::Zero,
           [this](Options*, const std::string&) {
             passOptions.optimizeLevel = 0;
             passOptions.shrinkLevel = 0;
           })
      .add("",
           "-O1",
           "execute -O1 optimization passes (quick&useful opts, useful for "
           "iteration builds)",
           Options::Arguments::Zero,
           [this](Options*, const std::string&) {
             passOptions.optimizeLevel = 1;
             passOptions.shrinkLevel = 0;
             passes.push_back(DEFAULT_OPT_PASSES);
           })
      .add(
        "",
        "-O2",
        "execute -O2 optimization passes (most opts, generally gets most perf)",
        Options::Arguments::Zero,
        [this](Options*, const std::string&) {
          passOptions.optimizeLevel = 2;
          passOptions.shrinkLevel = 0;
          passes.push_back(DEFAULT_OPT_PASSES);
        })
      .add("",
           "-O3",
           "execute -O3 optimization passes (spends potentially a lot of time "
           "optimizing)",
           Options::Arguments::Zero,
           [this](Options*, const std::string&) {
             passOptions.optimizeLevel = 3;
             passOptions.shrinkLevel = 0;
             passes.push_back(DEFAULT_OPT_PASSES);
           })
      .add("",
           "-O4",
           "execute -O4 optimization passes (also flatten the IR, which can "
           "take a lot more time and memory, but is useful on more nested / "
           "complex / less-optimized input)",
           Options::Arguments::Zero,
           [this](Options*, const std::string&) {
             passOptions.optimizeLevel = 4;
             passOptions.shrinkLevel = 0;
             passes.push_back(DEFAULT_OPT_PASSES);
           })
      .add("",
           "-Os",
           "execute default optimization passes, focusing on code size",
           Options::Arguments::Zero,
           [this](Options*, const std::string&) {
             passOptions.optimizeLevel = 2;
             passOptions.shrinkLevel = 1;
             passes.push_back(DEFAULT_OPT_PASSES);
           })
      .add("",
           "-Oz",
           "execute default optimization passes, super-focusing on code size",
           Options::Arguments::Zero,
           [this](Options*, const std::string&) {
             passOptions.optimizeLevel = 2;
             passOptions.shrinkLevel = 2;
             passes.push_back(DEFAULT_OPT_PASSES);
           })
      .add("--optimize-level",
           "-ol",
           "How much to focus on optimizing code",
           Options::Arguments::One,
           [this](Options* o, const std::string& argument) {
             passOptions.optimizeLevel = atoi(argument.c_str());
           })
      .add("--shrink-level",
           "-s",
           "How much to focus on shrinking code size",
           Options::Arguments::One,
           [this](Options* o, const std::string& argument) {
             passOptions.shrinkLevel = atoi(argument.c_str());
           })
      .add("--debuginfo",
           "-g",
           "Emit names section in wasm binary (or full debuginfo in wast)",
           Options::Arguments::Zero,
           [&](Options* o, const std::string& arguments) {
             passOptions.debugInfo = true;
           })
      .add("--always-inline-max-function-size",
           "-aimfs",
           "Max size of functions that are always inlined (default " +
             std::to_string(InliningOptions().alwaysInlineMaxSize) +
             ", which "
             "is safe for use with -Os builds)",
           Options::Arguments::One,
           [this](Options* o, const std::string& argument) {
             passOptions.inlining.alwaysInlineMaxSize =
               static_cast<Index>(atoi(argument.c_str()));
           })
      .add("--flexible-inline-max-function-size",
           "-fimfs",
           "Max size of functions that are inlined when lightweight (no loops "
           "or function calls) when optimizing aggressively for speed (-O3). "
           "Default: " +
             std::to_string(InliningOptions().flexibleInlineMaxSize),
           Options::Arguments::One,
           [this](Options* o, const std::string& argument) {
             passOptions.inlining.flexibleInlineMaxSize =
               static_cast<Index>(atoi(argument.c_str()));
           })
      .add("--one-caller-inline-max-function-size",
           "-ocimfs",
           "Max size of functions that are inlined when there is only one "
           "caller (default " +
             std::to_string(InliningOptions().oneCallerInlineMaxSize) +
             "). Reason this is not unbounded is that some "
             "implementations may have a hard time optimizing really large "
             "functions",
           Options::Arguments::One,
           [this](Options* o, const std::string& argument) {
             passOptions.inlining.oneCallerInlineMaxSize =
               static_cast<Index>(atoi(argument.c_str()));
           })
      .add("--ignore-implicit-traps",
           "-iit",
           "Optimize under the helpful assumption that no surprising traps "
           "occur (from load, div/mod, etc.)",
           Options::Arguments::Zero,
           [this](Options*, const std::string&) {
             passOptions.ignoreImplicitTraps = true;
           })
      .add("--low-memory-unused",
           "-lmu",
           "Optimize under the helpful assumption that the low 1K of memory is "
           "not used by the application",
           Options::Arguments::Zero,
           [this](Options*, const std::string&) {
             passOptions.lowMemoryUnused = true;
           })
      .add("--pass-arg",
           "-pa",
           "An argument passed along to optimization passes being run. Must be "
           "in the form KEY@VALUE",
           Options::Arguments::N,
           [this](Options*, const std::string& argument) {
             std::string key, value;
             auto colon = argument.find('@');
             if (colon == std::string::npos) {
               key = argument;
               value = "1";
             } else {
               key = argument.substr(0, colon);
               value = argument.substr(colon + 1);
             }
             passOptions.arguments[key] = value;
           });
    // add passes in registry
    for (const auto& p : PassRegistry::get()->getRegisteredNames()) {
      (*this).add(
        std::string("--") + p,
        "",
        PassRegistry::get()->getPassDescription(p),
        Options::Arguments::Zero,
        [this, p](Options*, const std::string&) { passes.push_back(p); });
    }
  }

  bool runningDefaultOptimizationPasses() {
    for (auto& pass : passes) {
      if (pass == DEFAULT_OPT_PASSES) {
        return true;
      }
    }
    return false;
  }

  bool runningPasses() { return passes.size() > 0; }

  void runPasses(Module& wasm) {
    PassRunner passRunner(&wasm, passOptions);
    if (debug) {
      passRunner.setDebug(true);
    }
    for (auto& pass : passes) {
      if (pass == DEFAULT_OPT_PASSES) {
        passRunner.addDefaultOptimizationPasses();
      } else {
        passRunner.add(pass);
      }
    }
    passRunner.run();
  }
};

} // namespace wasm

#endif
