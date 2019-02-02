/*
 * Copyright 2018 WebAssembly Community Group participants
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

#include "support/command-line.h"
#include "pass.h"

//
// Shared optimization options for commandline tools
//

namespace wasm {

struct ToolOptions : public Options {
  PassOptions passOptions;

  ToolOptions(const std::string& command, const std::string& description)
      : Options(command, description) {
    (*this)
        .add("--mvp-features", "-mvp", "Disable all non-MVP features",
             Options::Arguments::Zero,
             [this](Options *o, const std::string& arguments) {
               passOptions.features = FeatureSet::MVP;
             })
        .add("--all-features", "-all", "Enable all features (default)",
             Options::Arguments::Zero,
             [this](Options *o, const std::string& arguments) {
               passOptions.features = FeatureSet::All;
             })
        .add("--enable-threads", "", "Enable atomic operations",
             Options::Arguments::Zero,
             [this](Options *o, const std::string& arguments) {
               passOptions.features.setAtomics();
             })
        .add("--disable-threads", "", "Disable atomic operations",
             Options::Arguments::Zero,
             [this](Options *o, const std::string& arguments) {
               passOptions.features.setAtomics(false);
             })
        .add("--enable-mutable-globals", "", "Enable mutable globals",
             Options::Arguments::Zero,
             [this](Options *o, const std::string& arguments) {
               passOptions.features.setMutableGlobals();
             })
        .add("--disable-mutable-globals", "", "Disable mutable globals",
             Options::Arguments::Zero,
             [this](Options *o, const std::string& arguments) {
               passOptions.features.setMutableGlobals(false);
             })
        .add("--enable-nontrapping-float-to-int", "",
             "Enable nontrapping float-to-int operations",
             Options::Arguments::Zero,
             [this](Options *o, const std::string& arguments) {
               passOptions.features.setTruncSat();
             })
        .add("--disable-nontrapping-float-to-int", "",
             "Disable nontrapping float-to-int operations",
             Options::Arguments::Zero,
             [this](Options *o, const std::string& arguments) {
               passOptions.features.setTruncSat(false);
             })
        .add("--enable-simd", "",
             "Enable SIMD operations and types",
             Options::Arguments::Zero,
             [this](Options *o, const std::string& arguments) {
               passOptions.features.setSIMD();
             })
        .add("--disable-simd", "",
             "Disable SIMD operations and types",
             Options::Arguments::Zero,
             [this](Options *o, const std::string& arguments) {
               passOptions.features.setSIMD(false);
             })
        .add("--enable-bulk-memory", "",
             "Enable bulk memory operations",
             Options::Arguments::Zero,
             [this](Options *o, const std::string& arguments) {
               passOptions.features.setBulkMemory();
             })
        .add("--disable-bulk-memory", "",
             "Disable bulk memory operations",
             Options::Arguments::Zero,
             [this](Options *o, const std::string& arguments) {
               passOptions.features.setBulkMemory(false);
             })
        .add("--no-validation", "-n", "Disables validation, assumes inputs are correct",
             Options::Arguments::Zero,
             [this](Options* o, const std::string& argument) {
               passOptions.validate = false;
             });
        ;
  }

  FeatureSet getFeatures() const {
    return passOptions.features;
  }
};

} // namespace wasm
