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
#include <pass.h>
#include <wasm.h>

namespace wasm {

using namespace std;

// Prints metrics between optimization passes.
struct Metrics : public WalkerPass<WasmWalker<Metrics>> {
  static Metrics *lastMetricsPass;

  map<const char *, int> counts;
  void walk(Expression *&curr) override {
    WalkerPass::walk(curr);
    if (!curr)
      return;
    auto name = getExpressionName(curr);
    counts[name]++;
  }
  void finalize(PassRunner *runner, Module *module) override {
    ostream &o = cout;
    o << "Counts"
      << "\n";
    vector<const char*> keys;
    for (auto i : counts) {
      keys.push_back(i.first);
    }
    sort(keys.begin(), keys.end(), [](const char* a, const char* b) -> bool {
      return strcmp(b, a) > 0;
    });
    for (auto* key : keys) {
      auto value = counts[key];
      o << " " << left << setw(15) << key << ": " << setw(8)
        << value;
      if (lastMetricsPass) {
        if (lastMetricsPass->counts.count(key)) {
          int before = lastMetricsPass->counts[key];
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
      }
      o << "\n";
    }
    lastMetricsPass = this;
  }
};

Metrics *Metrics::lastMetricsPass;
static RegisterPass<Metrics> registerPass("metrics", "reports metrics");

} // namespace wasm
