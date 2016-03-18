/*
 * Copyright 2015 WebAssembly Community Group participants
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
// Command line helpers.
//

#ifndef wasm_support_command_line_h
#define wasm_support_command_line_h

#include <functional>
#include <map>
#include <string>
#include <utility>
#include <vector>

#include "wasm.h"


namespace wasm {

class Options {
 public:
  typedef std::function<void(Options *, const std::string &)> Action;
  enum class Arguments { Zero, One, N, Optional };

  bool debug;
  std::map<std::string, std::string> extra;

  Options(const std::string &command, const std::string &description);
  ~Options();
  Options &add(const std::string &longName, const std::string &shortName,
               const std::string &description, Arguments arguments,
               const Action &action);
  Options &add_positional(const std::string &name, Arguments arguments,
                          const Action &action);
  void parse(int argc, const char *argv[]);

 private:
  Options() = delete;
  Options(const Options &) = delete;
  Options &operator=(const Options &) = delete;

  struct Option {
    std::string longName;
    std::string shortName;
    std::string description;
    Arguments arguments;
    Action action;
    size_t seen;
  };
  std::vector<Option> options;
  Arguments positional;
  std::string positionalName;
  Action positionalAction;
};

}  // namespace wasm

#endif // wasm_support_command_line_h
