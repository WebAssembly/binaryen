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

      .add("", "-O", "execute default optimization passes",
           Options::Arguments::Zero,
           [&runOptimizationPasses, &passOptions](Options*, const std::string&) {
             passOptions.optimizeLevel = 2;
             passOptions.shrinkLevel = 1;
             runOptimizationPasses = true;
           })
      .add("", "-O0", "execute no optimization passes",
           Options::Arguments::Zero,
           [&passOptions](Options*, const std::string&) {
             passOptions.optimizeLevel = 0;
             passOptions.shrinkLevel = 0;
           })
      .add("", "-O1", "execute -O1 optimization passes",
           Options::Arguments::Zero,
           [&runOptimizationPasses, &passOptions](Options*, const std::string&) {
             passOptions.optimizeLevel = 1;
             passOptions.shrinkLevel = 0;
             runOptimizationPasses = true;
           })
      .add("", "-O2", "execute -O2 optimization passes",
           Options::Arguments::Zero,
           [&runOptimizationPasses, &passOptions](Options*, const std::string&) {
             passOptions.optimizeLevel = 2;
             passOptions.shrinkLevel = 0;
             runOptimizationPasses = true;
           })
      .add("", "-O3", "execute -O3 optimization passes",
           Options::Arguments::Zero,
           [&runOptimizationPasses, &passOptions](Options*, const std::string&) {
             passOptions.optimizeLevel = 3;
             passOptions.shrinkLevel = 0;
             runOptimizationPasses = true;
           })
      .add("", "-Os", "execute default optimization passes, focusing on code size",
           Options::Arguments::Zero,
           [&runOptimizationPasses, &passOptions](Options*, const std::string&) {
             passOptions.optimizeLevel = 2;
             passOptions.shrinkLevel = 1;
             runOptimizationPasses = true;
           })
      .add("", "-Oz", "execute default optimization passes, super-focusing on code size",
           Options::Arguments::Zero,
           [&runOptimizationPasses, &passOptions](Options*, const std::string&) {
             passOptions.optimizeLevel = 2;
             passOptions.shrinkLevel = 2;
             runOptimizationPasses = true;
           })
      .add("--optimize-level", "-ol", "How much to focus on optimizing code",
           Options::Arguments::One,
           [&passOptions](Options* o, const std::string& argument) {
             passOptions.optimizeLevel = atoi(argument.c_str());
           })
      .add("--shrink-level", "-s", "How much to focus on shrinking code size",
           Options::Arguments::One,
           [&passOptions](Options* o, const std::string& argument) {
             passOptions.shrinkLevel = atoi(argument.c_str());
           })
      .add("--ignore-implicit-traps", "-iit", "Optimize under the helpful assumption that no surprising traps occur (from load, div/mod, etc.)",
           Options::Arguments::Zero,
           [&passOptions](Options*, const std::string&) {
             passOptions.ignoreImplicitTraps = true;
           })

