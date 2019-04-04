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

#include "ir/module-utils.h"
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
             Arguments::Zero,
             [this](Options*, const std::string&) {
               hasFeatureOptions = true;
               passOptions.features.makeMVP();
               enabledFeatures.makeMVP();
               disabledFeatures.setAll();
             })
        .add("--all-features", "-all", "Enable all features "
             "(default if there is no target features section"
             " or if any feature options are provided)",
             Arguments::Zero,
             [this](Options*, const std::string&) {
               hasFeatureOptions = true;
               passOptions.features.setAll();
               enabledFeatures.setAll();
               disabledFeatures.makeMVP();
             })
        .add("--detect-features", "",
             "Use features from the target features section"
             "(default if there is a target features section"
             " and no feature options are provided)",
             Arguments::Zero,
             [this](Options*, const std::string&) {
               hasFeatureOptions = true;
               detectFeatures = true;
               enabledFeatures.makeMVP();
               disabledFeatures.makeMVP();
             });
    (*this)
        .addFeature("sign-ext", "sign extension operations",
                    FeatureSet::SignExt)
        .addFeature("threads", "atomic operations",
                    FeatureSet::Atomics)
        .addFeature("mutable-globals", "mutable globals",
                    FeatureSet::MutableGlobals)
        .addFeature("nontrapping-float-to-int",
                    "nontrapping float-to-int operations",
                    FeatureSet::TruncSat)
        .addFeature("simd", "SIMD operations and types",
                    FeatureSet::SIMD)
        .addFeature("bulk-memory", "bulk memory operations",
                    FeatureSet::BulkMemory)
        .add("--no-validation", "-n",
             "Disables validation, assumes inputs are correct",
             Options::Arguments::Zero,
             [this](Options* o, const std::string& argument) {
               passOptions.validate = false;
             });
  }

  ToolOptions& addFeature(const std::string& name,
                          const std::string& description,
                          FeatureSet::Feature feature) {
    (*this)
        .add(std::string("--enable-") + name, "",
             std::string("Enable ") + description, Arguments::Zero,
             [=](Options*, const std::string&) {
               hasFeatureOptions = true;
               passOptions.features.set(feature, true);
               enabledFeatures.set(feature, true);
               disabledFeatures.set(feature, false);
             })

        .add(std::string("--disable-") + name, "",
             std::string("Disable ") + description, Arguments::Zero,
             [=](Options*, const std::string&) {
               hasFeatureOptions = true;
               passOptions.features.set(feature, false);
               enabledFeatures.set(feature, false);
               disabledFeatures.set(feature, true);
             });
    return *this;
  }

  void calculateFeatures(const Module& module) {
    FeatureSet wasmFeatures;
    bool wasmHasFeatures =
        ModuleUtils::readFeaturesSection(module, wasmFeatures);

    if (hasFeatureOptions) {
      if (detectFeatures) {
        wasmFeatures.enable(enabledFeatures);
        wasmFeatures.disable(disabledFeatures);
        passOptions.features = wasmFeatures;
      } else if (!(wasmFeatures <= passOptions.features)) {
        Fatal() << "module uses features not explicitly specified, "
                << "use --detect-features to resolve";
      }
    } else if (wasmHasFeatures) {
      passOptions.features = wasmFeatures;
    }
  }

private:
  bool hasFeatureOptions = false;
  bool detectFeatures = false;
  FeatureSet enabledFeatures = FeatureSet::MVP;
  FeatureSet disabledFeatures = FeatureSet::MVP;
};

} // namespace wasm
