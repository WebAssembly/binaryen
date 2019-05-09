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
// Shared optimization options for commandline tools
//

namespace wasm {

struct ToolOptions : public Options {
  PassOptions passOptions;

  ToolOptions(const std::string& command, const std::string& description)
    : Options(command, description) {
    (*this)
      .add("--mvp-features",
           "-mvp",
           "Disable all non-MVP features",
           Arguments::Zero,
           [this](Options*, const std::string&) {
             hasFeatureOptions = true;
             enabledFeatures.makeMVP();
             disabledFeatures.setAll();
           })
      .add("--all-features",
           "-all",
           "Enable all features",
           Arguments::Zero,
           [this](Options*, const std::string&) {
             hasFeatureOptions = true;
             enabledFeatures.setAll();
             disabledFeatures.makeMVP();
           })
      .add("--detect-features",
           "",
           "Use features from the target features section, or MVP (default)",
           Arguments::Zero,
           [this](Options*, const std::string&) {
             hasFeatureOptions = true;
             detectFeatures = true;
             enabledFeatures.makeMVP();
             disabledFeatures.makeMVP();
           });
    (*this)
      .addFeature(FeatureSet::SignExt, "sign extension operations")
      .addFeature(FeatureSet::Atomics, "atomic operations")
      .addFeature(FeatureSet::MutableGlobals, "mutable globals")
      .addFeature(FeatureSet::TruncSat, "nontrapping float-to-int operations")
      .addFeature(FeatureSet::SIMD, "SIMD operations and types")
      .addFeature(FeatureSet::BulkMemory, "bulk memory operations")
      .addFeature(FeatureSet::ExceptionHandling,
                  "exception handling operations")
      .add("--no-validation",
           "-n",
           "Disables validation, assumes inputs are correct",
           Options::Arguments::Zero,
           [this](Options* o, const std::string& argument) {
             passOptions.validate = false;
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
             hasFeatureOptions = true;
             enabledFeatures.set(feature, true);
             disabledFeatures.set(feature, false);
           })

      .add(std::string("--disable-") + FeatureSet::toString(feature),
           "",
           std::string("Disable ") + description,
           Arguments::Zero,
           [=](Options*, const std::string&) {
             hasFeatureOptions = true;
             enabledFeatures.set(feature, false);
             disabledFeatures.set(feature, true);
           });
    return *this;
  }

  void applyFeatures(Module& module) {
    if (hasFeatureOptions) {
      if (!detectFeatures && module.hasFeaturesSection) {
        FeatureSet optionsFeatures = FeatureSet::MVP;
        optionsFeatures.enable(enabledFeatures);
        optionsFeatures.disable(disabledFeatures);
        if (module.features != optionsFeatures) {
          Fatal() << "module features do not match specified features. "
                  << "Use --detect-features to resolve.";
        }
      }
      module.features.enable(enabledFeatures);
      module.features.disable(disabledFeatures);
    }
  }

private:
  bool hasFeatureOptions = false;
  bool detectFeatures = false;
  FeatureSet enabledFeatures = FeatureSet::MVP;
  FeatureSet disabledFeatures = FeatureSet::MVP;
};

} // namespace wasm

#endif
