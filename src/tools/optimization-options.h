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

//
// Shared optimization options for commandline tools
//

namespace wasm {

struct OptimizationOptions : public Options {
  static constexpr const char* DEFAULT_OPT_PASSES = "O";

  std::vector<std::string> passes;
  PassOptions passOptions;

  OptimizationOptions(const std::string &command, const std::string &description) : Options(command, description) {
    (*this).add("", "-O", "execute default optimization passes",
                Options::Arguments::Zero,
                [this](Options*, const std::string&) {
                  passOptions.optimizeLevel = 2;
                  passOptions.shrinkLevel = 1;
                  passes.push_back(DEFAULT_OPT_PASSES);
                })
           .add("", "-O0", "execute no optimization passes",
                Options::Arguments::Zero,
                [this](Options*, const std::string&) {
                  passOptions.optimizeLevel = 0;
                  passOptions.shrinkLevel = 0;
                })
           .add("", "-O1", "execute -O1 optimization passes",
                Options::Arguments::Zero,
                [this](Options*, const std::string&) {
                  passOptions.optimizeLevel = 1;
                  passOptions.shrinkLevel = 0;
                  passes.push_back(DEFAULT_OPT_PASSES);
                })
           .add("", "-O2", "execute -O2 optimization passes",
                Options::Arguments::Zero,
                [this](Options*, const std::string&) {
                  passOptions.optimizeLevel = 2;
                  passOptions.shrinkLevel = 0;
                  passes.push_back(DEFAULT_OPT_PASSES);
                })
           .add("", "-O3", "execute -O3 optimization passes",
                Options::Arguments::Zero,
                [this](Options*, const std::string&) {
                  passOptions.optimizeLevel = 3;
                  passOptions.shrinkLevel = 0;
                  passes.push_back(DEFAULT_OPT_PASSES);
                })
           .add("", "-Os", "execute default optimization passes, focusing on code size",
                Options::Arguments::Zero,
                [this](Options*, const std::string&) {
                  passOptions.optimizeLevel = 2;
                  passOptions.shrinkLevel = 1;
                  passes.push_back(DEFAULT_OPT_PASSES);
                })
           .add("", "-Oz", "execute default optimization passes, super-focusing on code size",
                Options::Arguments::Zero,
                [this](Options*, const std::string&) {
                  passOptions.optimizeLevel = 2;
                  passOptions.shrinkLevel = 2;
                  passes.push_back(DEFAULT_OPT_PASSES);
                })
           .add("--optimize-level", "-ol", "How much to focus on optimizing code",
                Options::Arguments::One,
                [this](Options* o, const std::string& argument) {
                  passOptions.optimizeLevel = atoi(argument.c_str());
                })
           .add("--shrink-level", "-s", "How much to focus on shrinking code size",
                Options::Arguments::One,
                [this](Options* o, const std::string& argument) {
                  passOptions.shrinkLevel = atoi(argument.c_str());
                })
           .add("--ignore-implicit-traps", "-iit", "Optimize under the helpful assumption that no surprising traps occur (from load, div/mod, etc.)",
                Options::Arguments::Zero,
                [this](Options*, const std::string&) {
                  passOptions.ignoreImplicitTraps = true;
                });
    // add passes in registry
    for (const auto& p : PassRegistry::get()->getRegisteredNames()) {
      (*this).add(
        std::string("--") + p, "", PassRegistry::get()->getPassDescription(p),
        Options::Arguments::Zero,
        [this, p](Options*, const std::string&) {
          passes.push_back(p);
        }
      );
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

  bool runningPasses() {
    return passes.size() > 0;
  }

  PassRunner getPassRunner(Module& wasm) {
    PassRunner passRunner(&wasm, passOptions);
    if (debug) passRunner.setDebug(true);
    for (auto& pass : passes) {
      if (pass == DEFAULT_OPT_PASSES) {
        passRunner.addDefaultOptimizationPasses();
      } else {
        passRunner.add(pass);
      }
    }
    return passRunner;
  }
};

} // namespace wasm

