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
  using Builder = std::function<void (FeatureSet&)>;
  PassOptions passOptions;

  ToolOptions(const std::string& command, const std::string& description)
      : Options(command, description) {
    (*this)
        .addFeatureOpt("--mvp-features", "-mvp", "Disable all non-MVP features",
                       [this](FeatureSet& features) {
                         features = FeatureSet::MVP;
                       })
        .addFeatureOpt("--all-features", "-all",
                       "Enable all features "
                       "(default if there is no target features section"
                       " or if any feature options are provided)",
                       [this](FeatureSet& features) {
                         features = FeatureSet::All;
                       })
        .addFeatureOpt("--detect-features", "",
                       "Use features from the target features section"
                       "(default if there is a target features section"
                       " and no feature options are provided)",
                       [this](FeatureSet& features) {
                         features = wasmFeatures;
                         errorOnFeatureMismatch = false;
                       })
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

  ToolOptions &addFeatureOpt(const std::string& longName,
                             const std::string& shortName,
                             const std::string& description,
                             Builder builder) {
    add(longName, shortName, description, Options::Arguments::Zero,
        [=](Options*, const std::string&) {
          featureBuilders.push_back(builder);
        });
    return *this;
  }

  ToolOptions &addFeature(const std::string& name,
                          const std::string& description,
                          FeatureSet::Feature feature) {
    (*this)
        .addFeatureOpt(std::string("--enable-") + name, "",
                       std::string("Enable ") + description,
                       [=](FeatureSet& features) {
                         features.set(feature, true);
                       })
        .addFeatureOpt(std::string("--disable-") + name, "",
                       std::string("Disable ") + description,
                       [=](FeatureSet& features) {
                         features.set(feature, false);
                       });
    return *this;
  }

  FeatureSet& getFeatures(const Module& module) {
    if (featuresInitialized) {
      return passOptions.features;
    }

    bool wasmHasFeatures = module.readFeatures(wasmFeatures);
    if (featureBuilders.size()) {
      for (auto& builder : featureBuilders) {
        builder(passOptions.features);
      }
      if (errorOnFeatureMismatch &&
          !(wasmFeatures <= passOptions.features)) {
        Fatal() << "module uses features not explicitly specified, "
                << "use --detect-features to resolve";
      }
    } else if (wasmHasFeatures) {
      passOptions.features = wasmFeatures;
    }
    featuresInitialized = true;
    return passOptions.features;
  }

private:
  std::vector<Builder> featureBuilders;
  bool errorOnFeatureMismatch = true;
  bool featuresInitialized = false;

  // cached contents of the target features section
  FeatureSet wasmFeatures = FeatureSet::MVP;
};

} // namespace wasm
