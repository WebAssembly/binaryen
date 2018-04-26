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

#include "support/command-line.h"

using namespace wasm;

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH 80
#endif

void printWrap(std::ostream& os, int leftPad, const std::string& content) {
  int len = content.size();
  int space = SCREEN_WIDTH - leftPad;
  std::string nextWord;
  std::string pad(leftPad, ' ');
  for (int i = 0; i <= len; ++i) {
    if (i != len && content[i] != ' ' && content[i] != '\n') {
      nextWord += content[i];
    } else {
      if (static_cast<int>(nextWord.size()) > space) {
        os << '\n' << pad;
        space = SCREEN_WIDTH - leftPad;
      }
      os << nextWord;
      space -= nextWord.size() + 1;
      if (space > 0) os << ' ';
      nextWord.clear();
      if (content[i] == '\n') {
        os << '\n';
        space = SCREEN_WIDTH - leftPad;
      }
    }
  }
}

Options::Options(const std::string& command, const std::string& description)
    : debug(false), positional(Arguments::Zero) {
  add("--help", "-h", "Show this help message and exit", Arguments::Zero,
      [this, command, description](Options* o, const std::string&) {
        std::cerr << command;
        if (positional != Arguments::Zero) std::cerr << ' ' << positionalName;
        std::cerr << "\n\n";
        printWrap(std::cerr, 0, description);
        std::cerr << "\n\nOptions:\n";
        size_t optionWidth = 0;
        for (const auto& o : options) {
          optionWidth =
              std::max(optionWidth, o.longName.size() + o.shortName.size());
        }
        for (const auto& o : options) {
          bool long_n_short = o.longName.size() != 0 && o.shortName.size() != 0;
          size_t pad = 1 + optionWidth - o.longName.size() - o.shortName.size();
          std::cerr << "  " << o.longName << (long_n_short ? ',' : ' ')
                    << o.shortName << std::string(pad, ' ');
          printWrap(std::cerr, optionWidth + 4, o.description);
          std::cerr << '\n';
        }
        std::cerr << '\n';
        exit(EXIT_SUCCESS);
      });
  add("--debug", "-d", "Print debug information to stderr", Arguments::Zero,
      [&](Options* o, const std::string& arguments) { debug = true; });
}

Options::~Options() {}

Options& Options::add(const std::string& longName, const std::string& shortName,
                      const std::string& description, Arguments arguments,
                      const Action& action) {
  options.push_back({longName, shortName, description, arguments, action, 0});
  return *this;
}

Options& Options::add_positional(const std::string& name, Arguments arguments,
                                 const Action& action) {
  positional = arguments;
  positionalName = name;
  positionalAction = action;
  return *this;
}

void Options::parse(int argc, const char* argv[]) {
  assert(argc > 0 && "expect at least program name as an argument");
  size_t positionalsSeen = 0;
  auto dashes = [](const std::string& s) {
    for (size_t i = 0;; ++i) {
      if (s[i] != '-') return i;
    }
  };
  for (size_t i = 1, e = argc; i != e; ++i) {
    std::string currentOption = argv[i];

    if (dashes(currentOption) == 0) {
      // Positional.
      switch (positional) {
        case Arguments::Zero:
          std::cerr << "Unexpected positional argument '" << currentOption
                    << "'\n";
          exit(EXIT_FAILURE);
        case Arguments::One:
        case Arguments::Optional:
          if (positionalsSeen) {
            std::cerr << "Unexpected second positional argument '"
                      << currentOption << "' for " << positionalName << '\n';
            exit(EXIT_FAILURE);
          }
        // Fallthrough.
        case Arguments::N:
          positionalAction(this, currentOption);
          ++positionalsSeen;
          break;
      }
      continue;
    }

    // Non-positional.
    std::string argument;
    auto equal = currentOption.find_first_of('=');
    if (equal != std::string::npos) {
      argument = currentOption.substr(equal + 1);
      currentOption = currentOption.substr(0, equal);
    }
    Option* option = nullptr;
    for (auto& o : options)
      if (o.longName == currentOption || o.shortName == currentOption)
        option = &o;
    if (!option) {
      std::cerr << "Unknown option '" << currentOption << "'\n";
      exit(EXIT_FAILURE);
    }
    switch (option->arguments) {
      case Arguments::Zero:
        if (argument.size()) {
          std::cerr << "Unexpected argument '" << argument << "' for option '"
                    << currentOption << "'\n";
          exit(EXIT_FAILURE);
        }
        break;
      case Arguments::One:
        if (option->seen) {
          std::cerr << "Unexpected second argument '" << argument << "' for '"
                    << currentOption << "'\n";
          exit(EXIT_FAILURE);
        }
      // Fallthrough.
      case Arguments::N:
        if (!argument.size()) {
          if (i + 1 == e) {
            std::cerr << "Couldn't find expected argument for '"
                      << currentOption << "'\n";
            exit(EXIT_FAILURE);
          }
          argument = argv[++i];
        }
        break;
      case Arguments::Optional:
        if (!argument.size()) {
          if (i + 1 != e) argument = argv[++i];
        }
        break;
    }
    option->action(this, argument);
    ++option->seen;
  }
}
