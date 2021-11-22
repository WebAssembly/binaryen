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

#ifndef wasm_tools_tool_options_h
#define wasm_tools_tool_options_h

#include "ir/module-utils.h"
#include "pass.h"
#include "support/command-line.h"

//
// Shared options for commandline tools
//

namespace wasm {

struct ToolOptions : public Options {
  PassOptions passOptions;

  bool quiet = false;
  IRProfile profile = IRProfile::Normal;

  ToolOptions(const std::string& command, const std::string& description)
    : Options(command, description) {
    (*this)
      .add("--mvp-features",
           "-mvp",
           "Disable all non-MVP features",
           Arguments::Zero,
           [this](Options*, const std::string&) {
             enabledFeatures.setMVP();
             disabledFeatures.setAll();
           })
      .add("--all-features",
           "-all",
           "Enable all features",
           Arguments::Zero,
           [this](Options*, const std::string&) {
             enabledFeatures.setAll();
             disabledFeatures.setMVP();
           })
      .add("--detect-features",
           "",
           "(deprecated - this flag does nothing)",
           Arguments::Zero,
           [](Options*, const std::string&) {})
      .add("--quiet",
           "-q",
           "Emit less verbose output and hide trivial warnings.",
           Arguments::Zero,
           [this](Options*, const std::string&) { quiet = true; })
      .add(
        "--experimental-poppy",
        "",
        "Parse wast files as Poppy IR for testing purposes.",
        Arguments::Zero,
        [this](Options*, const std::string&) { profile = IRProfile::Poppy; });
    (*this)
      .addFeature(FeatureSet::SignExt, "sign extension operations")
      .addFeature(FeatureSet::Atomics, "atomic operations")
      .addFeature(FeatureSet::MutableGlobals, "mutable globals")
      .addFeature(FeatureSet::TruncSat, "nontrapping float-to-int operations")
      .addFeature(FeatureSet::SIMD, "SIMD operations and types")
      .addFeature(FeatureSet::BulkMemory, "bulk memory operations")
      .addFeature(FeatureSet::ExceptionHandling,
                  "exception handling operations")
      .addFeature(FeatureSet::TailCall, "tail call operations")
      .addFeature(FeatureSet::ReferenceTypes, "reference types")
      .addFeature(FeatureSet::Multivalue, "multivalue functions")
      .addFeature(FeatureSet::GC, "garbage collection")
      .addFeature(FeatureSet::Memory64, "memory64")
      .addFeature(FeatureSet::TypedFunctionReferences,
                  "typed function references")
      .addFeature(FeatureSet::GCNNLocals, "GC non-null locals")
      .addFeature(FeatureSet::RelaxedSIMD, "relaxed SIMD")
      .add("--no-validation",
           "-n",
           "Disables validation, assumes inputs are correct",
           Options::Arguments::Zero,
           [this](Options* o, const std::string& argument) {
             passOptions.validate = false;
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
           })
      .add("--nominal",
           "",
           "Force all GC type definitions to be parsed as nominal.",
           Options::Arguments::Zero,
           [](Options* o, const std::string& argument) {
             setTypeSystem(TypeSystem::Nominal);
           })
      .add("--structural",
           "",
           "Force all GC type definitions to be parsed as structural "
           "(i.e. equirecursive). This is the default.",
           Options::Arguments::Zero,
           [](Options* o, const std::string& argument) {
             setTypeSystem(TypeSystem::Equirecursive);
           });
  }

  ToolOptions& addFeature(FeatureSet::Feature feature,
                          const std::string& description) {
    (*this)
      .add(std::string("--enable-") + FeatureSet::toString(feature),
           "",
           std::string("Enable ") + description,
           Arguments::Zero,
           [=](Options*, const std::string&) {
             enabledFeatures.set(feature, true);
             disabledFeatures.set(feature, false);
           })

      .add(std::string("--disable-") + FeatureSet::toString(feature),
           "",
           std::string("Disable ") + description,
           Arguments::Zero,
           [=](Options*, const std::string&) {
             enabledFeatures.set(feature, false);
             disabledFeatures.set(feature, true);
           });
    return *this;
  }

  void applyFeatures(Module& module) const {
    module.features.enable(enabledFeatures);
    module.features.disable(disabledFeatures);
  }

private:
  FeatureSet enabledFeatures = FeatureSet::MVP;
  FeatureSet disabledFeatures = FeatureSet::MVP;
};

} // namespace wasm

#endif
